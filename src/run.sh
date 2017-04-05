readonly LOGSPOUT_DEST_URL="${LOGSPOUT_DEST_URL:-}"
readonly LOGSPOUT_FORMAT_STRING="${LOGSPOUT_FORMAT_STRING:-%rawmsg%}"
readonly LOGSPOUT_DYNAMIC_CONFIG="/etc/rsyslog.d/101-logspout-dynamic.conf"

if [[ "$LOGSPOUT_DEST_URL" != "" ]]; then
	echo "Updating $LOGSPOUT_DYNAMIC_CONFIG..."
	cat > "$LOGSPOUT_DYNAMIC_CONFIG" <<- _EOF_
		\$template LogspoutFormat,"$LOGSPOUT_FORMAT_STRING"
		*.* @@$LOGSPOUT_DEST_URL;LogspoutFormat
	_EOF_
fi

echo "Starting rsyslog..."
rsyslogd -n -f /etc/rsyslog.conf