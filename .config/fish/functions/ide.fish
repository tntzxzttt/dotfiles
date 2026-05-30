function ide -d "Open a tmux IDE layout with neovim, claude, and two terminals"
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
    end

    # Launch neovim
    nvim $nvim_args

    # Always restore the original directory
    cd $original_dir
end
