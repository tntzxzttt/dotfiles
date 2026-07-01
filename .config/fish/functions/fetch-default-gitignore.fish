function fetch-default-gitignore
    # Get the first argument
    set language $argv[1]

    # Exit with an error message if no argument is provided
    if test -z "$language"
        echo "Error: Please provide a programming language."
        return 1
    end

    # Capitalize the first letter
    set formatted_language (echo $language | string replace -r '^(.)' '\u$1')

    # Build the URL
    set url "https://raw.githubusercontent.com/github/gitignore/refs/heads/main/$formatted_language.gitignore"

    # Set up temporary directory and file
    set temp_dir /tmp/fetch-default-gitignore
    set temp_file "$temp_dir/$formatted_language.gitignore"

    # Create temporary directory
    mkdir -p $temp_dir

    # Check if the temporary file already exists
    if test -f $temp_file
        echo "Using cached .gitignore for $formatted_language."
    else
        # Fetch the file and save it to the temporary directory
        curl -s -o $temp_file "$url"

        # Check if curl succeeded
        if test $status -ne 0
            echo "Error: Failed to fetch .gitignore for $formatted_language."
            rm -f $temp_file
            return 1
        end
    end

    # Append to .gitignore file
    echo "# Ref: $url" >>.gitignore
    cat $temp_file >>.gitignore
    echo "Added .gitignore for $formatted_language to the current directory."

    # Remove the temporary file
    rm -f $temp_file
end
