function nvim-orphans --description "Detect orphaned nvim --embed servers whose TUI parent has died"
    # nvim = TUI client + --embed server. A server wedged mid-shutdown outlives
    # its client and is reparented to launchd, so PPID 1 marks one stuck forever.
    set -l pids
    for pid in (pgrep -f 'nvim --embed' 2>/dev/null)
        set -l ppid (ps -o ppid= -p $pid 2>/dev/null | string trim)
        if test "$ppid" = 1
            set -a pids $pid
        end
    end

    # Healthy case, kept short so this is cheap to run habitually.
    if test (count $pids) -eq 0
        set_color green
        echo "✔ No orphans"
        set_color normal
        echo "  Every nvim server still has a live TUI parent."
        return 0
    end

    set_color yellow
    echo "⚠ Orphaned nvim servers: "(count $pids)
    set_color normal
    echo "  Their TUI parent is gone. They may be wedged mid-shutdown and leaking memory."
    echo

    # footprint, not RSS: a wedged nvim hits 50 GB of footprint while ps reports
    # under 1 GB, since nearly all of it is swapped out or compressed.
    for pid in $pids
        set -l etime (ps -o etime= -p $pid 2>/dev/null | string trim)
        set -l rss (ps -o rss= -p $pid 2>/dev/null | string trim)
        set -l cwd (lsof -a -p $pid -d cwd -Fn 2>/dev/null | string match -rg '^n(.*)')
        set -l fp (footprint -p $pid 2>/dev/null | string match -rg 'phys_footprint:\s+(.+)')

        # Process may vanish mid-probe; an empty $rss would reach math below and
        # print a bogus "0.0 MB" with status 0.
        if test -z "$rss"
            set_color --bold
            printf "  PID %s\n" "$pid"
            set_color normal
            printf "    (exited while being inspected)\n\n"
            continue
        end

        # Can be empty on a live process too; not worth aborting the report.
        test -n "$cwd"; or set cwd "(unknown)"
        test -n "$fp"; or set fp "(unavailable)"

        set_color --bold
        printf "  PID %s\n" "$pid"
        set_color normal
        printf "    footprint  : %s  <- judge by this\n" "$fp"
        printf "    RSS        : %.1f MB  (excludes swapped/compressed pages; unreliable)\n" (math $rss / 1024)
        printf "    uptime     : %s\n" "$etime"
        printf "    cwd        : %s\n" "$cwd"

        # One swap file per unsaved buffer: what you lose by killing. A wedged
        # server already flushed them, so recovery survives SIGKILL.
        # Anchor on the swap basename (always %-encoded) so a real file that
        # merely lives under some .../swap/ path cannot false-match.
        set -l swaps (lsof -a -p $pid -Fn 2>/dev/null | string match -rg '^n(.*/swap/%[^/]*)$')
        if test (count $swaps) -gt 0
            echo "    open files :"
            for s in $swaps
                # %Users%foo%bar.txt.swp -> /Users/foo/bar.txt. nvim encodes a
                # literal % as %%, so decode %% first (via a sentinel) then % -> /.
                echo "      - "(basename $s | string replace -r '\.sw[a-p]$' '' | string replace -a %% \x1e | string replace -a % / | string replace -a \x1e %)
            end
            echo "      ^ swap is already preserved; recover with: nvim -r <file>"
        else
            echo "    open files : none (no unsaved changes)"
        end
        echo
    end

    # No auto-kill: PPID 1 also matches intentionally detached servers
    # (nvim --headless --listen, some GUI frontends).
    set_color --bold
    echo "  To kill:"
    set_color normal
    echo "    kill -9 $pids"
    echo
    echo "  Note: SIGTERM will not work. These processes are stuck inside their own"
    echo "  shutdown path (wait_return), so a signal just returns them to the same"
    echo "  spot. SIGKILL is required."

    # Non-zero when orphans exist, so callers can branch on it.
    return 1
end
