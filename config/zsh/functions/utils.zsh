
# Create a directory or file if it doesn't exist
function nf() {
	if [[ "$1" == */ ]]; then
		mkdir -p "$1"
	elif [[ "$1" == */* ]]; then
		mkdir -p "$(dirname "$1")" && touch "$1"
	else
		touch "$1"
	fi
}

# vim -> open vim in the current directory or open the target file
function vim() {
  if [[ $# -eq 0 ]]; then
      nvim .
  else
    nvim "$@"
  fi
}
