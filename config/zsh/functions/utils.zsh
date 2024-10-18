
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

# Extend mv so that it creates the target path if it doesn't already exist
xmv() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: xmv [options] <source>... <target>"
    return 1
  fi

  dest="${@: -1}"

  if [[ "$dest" == */* ]]; then
    dest_dir=$(dirname "$dest")

    if [ ! -d "$dest_dir" ]; then
      mkdir -p "$dest_dir"
    fi
  fi

  mv "$@"
}

xcp() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: xcp [options] <source>... <target>"
    return 1
  fi

  dest="${@: -1}"

  if [[ "$dest" == */* ]]; then
    dest_dir=$(dirname "$dest")

    if [ ! -d "$dest_dir" ]; then
      mkdir -p "$dest_dir"
    fi
  fi

  cp "$@"
}

# vim -> open vim in the current directory or open the target file
function vim() {
  if [[ $# -eq 0 ]]; then
      nvim .
  else
    nvim "$@"
  fi
}
