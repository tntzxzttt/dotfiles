function genpw --description 'Generate random password'
    # Default values
    set -l length 16
    set -l include_special 0
    set -l min_lower 2
    set -l min_upper 2
    set -l min_digit 2
    set -l min_special 2
    set -l lower_chars 'abcdefghijklmnopqrstuvwxyz'
    set -l upper_chars 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    set -l digit_chars '0123456789'
    set -l special_chars '$@+-_=./:[]#&?!^|*(){}%<>' # Restored ! character

    # Parse arguments
    argparse 's/special' 'l/length=' -- $argv
    or return 1

    if set -q _flag_s
        set include_special 1
    end

    if set -q _flag_l
        set length $_flag_l
    end

    # Length validation
    set -l minlen (math $min_lower + $min_upper + $min_digit)
    if test $include_special -eq 1
        set minlen (math $minlen + $min_special)
    end

    if test $length -lt $minlen
        echo "Minimum length is $minlen (current: $length)"
        return 1
    end

    # Randomly select required number from each category
    function _rand_chars
        set -l chars $argv[1]
        set -l count $argv[2]
        for i in (seq $count)
            set -l len (string length $chars)
            set -l pos (random 1 $len)
            string sub -s $pos -l 1 $chars
        end
    end

    set -l pw_chars
    set pw_chars $pw_chars (_rand_chars $lower_chars $min_lower)
    set pw_chars $pw_chars (_rand_chars $upper_chars $min_upper)
    set pw_chars $pw_chars (_rand_chars $digit_chars $min_digit)
    if test $include_special -eq 1
        set pw_chars $pw_chars (_rand_chars $special_chars $min_special)
    end

    # Get remaining characters randomly from all categories
    set -l current_len (count $pw_chars)
    set -l remain (math "$length - $current_len")
    set -l all_chars $lower_chars$upper_chars$digit_chars
    if test $include_special -eq 1
        set all_chars $all_chars$special_chars
    end

    if test $remain -gt 0
        set pw_chars $pw_chars (_rand_chars $all_chars $remain)
    end

    # Shuffle
    set -l chars $pw_chars
    set -l char_count (count $chars)
    if test $char_count -gt 1
        for i in (seq $char_count -1 2)
            set -l j (random 1 $i)
            set -l tmp $chars[$i]
            set chars[$i] $chars[$j]
            set chars[$j] $tmp
        end
    end

    set -l pw (string join '' $chars)
    # # TODO: Fix font ligatures (e.g., != displaying as ≠).
    # # This happens in WezTerm. However, it works fine in iTerm2 and VSCode.
    # set pw 'i9TVq8!='

    printf '%s' $pw | pbcopy
    printf 'Generated password: %s\n' $pw
    echo "($length chars; copied to clipboard)"
end
