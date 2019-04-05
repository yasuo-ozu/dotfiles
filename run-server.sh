#!/bin/bash

SCRIPT_DIR=$(echo "$0" | sed -e 's/\/[^\/]*$//')
SCRIPT_DIR=$(cd "$SCRIPT_DIR" && pwd)
NETWORK_DEV=$(ip link show | sed -ne '/state UP/p' | head -n 1 | sed -e 's/^[0-9]*: \([^:]*\):.*$/\1/')
IPADDR=$(ip addr show "$NETWORK_DEV" | sed -ne '/inet /p' | sed -e 's/^.*inet \(.*\)\/.*$/\1/')
PORT=8080

which nc &> /dev/null || {
	echo "nc command is not installed." 1>&2
	exit 1
}

TMPFILE=$(mktemp /tmp/dotfiles.XXXXX)
echo "generating archive..."
cd "$SCRIPT_DIR"
tar cz . > "$TMPFILE"
ls -l "$TMPFILE"
md5sum "$TMPFILE"

echo "running server..."
echo "run 'nc $IPADDR $PORT < /dev/null | bash' on target host"

(
	echo '#!/bin/bash'
	echo 'A=`mktemp -d /tmp/dotfiles.XXXXX`'
	echo 'B=`mktemp /tmp/dotfiles.XXXXX`'
	echo 'MYPID=$$'
	echo 'while [[ ! -c $(readlink /proc/$MYPID/fd/0) ]]; do'
	echo '	if [ "$MYPID" -eq 0 -o ! -d "/proc/$MYPID" ]; then'
	echo '		echo "no tty found" 1>&2'
	echo '		exit 1'
	echo '	fi'
	echo '	MYPID=$(cat /proc/$MYPID/stat | cut -d " " -f 4)'
	echo 'done'
	#echo 'timeout 4 bash -c " cat /dev/stdin | tar zxC $A"; cd "$A"; bash install.sh < /proc/$MYPID/fd/0; exit 0'
	#echo 'tar zxC $A; cd "$A"; bash install.sh < /proc/$MYPID/fd/0; exit 0'
	echo 'cat > "$B"; cat "$B" | tar zxC $A; cd "$A"; bash install.sh < /proc/$MYPID/fd/0; rm -rf "$A" "$B"; exit 0'
	cat "$TMPFILE"
	exec 1>&-
) | nc -l -c -vv -p "$PORT"
rm -f "$TMPFILE"


