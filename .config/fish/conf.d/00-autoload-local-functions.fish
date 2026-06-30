# Machine-local functions live in functions.local/ and are git-ignored.
# Fish autoload is non-recursive and skips this directory, so register it here.
# Prepend so a local function can override a tracked one with the same name.
set -l local_functions $__fish_config_dir/functions.local
if test -d $local_functions; and not contains $local_functions $fish_function_path
    set --prepend fish_function_path $local_functions
end
