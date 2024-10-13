
# Create a directory or file if it doesn't exist
nf() {
	if [[ "$1" == */* ]]; then
		mkdir -p "$(dirname "$1")" && touch "$1"
	else
		touch "$1"
	fi
}
