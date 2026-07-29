function ide -d "Open a tmux/herdr IDE layout with neovim, claude, and two terminals"
    set -l original_dir (pwd)
    set -l nvim_args

    # If a single directory argument is given, cd into it
    # so that nvim's "Find files" (<leader><space>) 
    # only searches within the target directory, 
    # not the directory where this function was invoked.
    if test (count $argv) -eq 1; and test -d $argv[1]
        cd $argv[1]
        # By explicitly passing "." even though it's the current directory,
        # Snacks Explorer will automatically open the file tree side panel 
        # when launching Neovim.
        set nvim_args .
    else
        set nvim_args $argv
    end

    # If inside tmux with a single pane, create the IDE layout
    if set -q TMUX
        set -l panes (tmux display-message -p '#{window_panes}')
        if test $panes -eq 1
            # Split and create bottom pane
            tmux split-window -v -l 25%

            # Split and create bottom-right pane
            tmux split-window -h -l 50%

            # Move back to the top pane
            tmux select-pane -U

            # Split and top-right pane for claude
            tmux split-window -h -l 20% -d "clear && claude"
        end

    # If inside herdr with a single pane, create the same layout via its CLI.
    # Note: herdr's --ratio is the share kept by the existing pane,
    # so tmux's -l 25% / 50% / 20% map to --ratio 0.75 / 0.5 / 0.8.
    # --no-focus keeps focus on the original pane, where nvim launches.
    else if set -q HERDR_PANE_ID
        set -l panes (herdr pane layout --current | jq '.result.layout.panes | length')
        if test $panes -eq 1
            # Split and create bottom pane
            set -l bottom (herdr pane split --current --direction down --ratio 0.75 \
                --cwd (pwd) --no-focus | jq -r '.result.pane.pane_id')

            # Split and create bottom-right pane
            herdr pane split --pane $bottom --direction right --ratio 0.5 \
                --cwd (pwd) --no-focus >/dev/null

            # Split and top-right pane for claude
            # (split cannot spawn a command, so run claude in the new pane's shell)
            set -l claude_pane (herdr pane split --current --direction right --ratio 0.8 \
                --cwd (pwd) --no-focus | jq -r '.result.pane.pane_id')
            herdr pane run $claude_pane 'clear && claude' >/dev/null
        end
    end

    # Launch neovim
    nvim $nvim_args

    # Always restore the original directory
    cd $original_dir
end
