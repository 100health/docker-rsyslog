#readonly LOGSPOUT_DEST_URL="${LOGSPOUT_DEST_URL:-}"
#readonly LOGSPOUT_FORMAT_STRING="${LOGSPOUT_FORMAT_STRING:-%rawmsg%}"

readonly SUMOLOGIC_HOST="${SUMOLOGIC_HOST}"
readonly SUMOLOGIC_PORT="${SUMOLOGIC_PORT}"
readonly SUMOLOGIC_TOKEN="${SUMOLOGIC_TOKEN}"

readonly LOGSPOUT_DYNAMIC_CONFIG="/etc/rsyslog.d/101-logspout-dynamic.conf"

if [[ "$SUMOLOGIC_TOKEN" != "" && "$SUMOLOGIC_HOST" != "" && "$SUMOLOGIC_PORT" != "" ]]; then
	echo "Updating $LOGSPOUT_DYNAMIC_CONFIG..."
	cat > "$LOGSPOUT_DYNAMIC_CONFIG" <<- _EOF_

template(name="SumoFormat" type="string" string="<%pri%>%protocol-version% %timestamp:::date-rfc3339% %HOSTNAME% %app-name% %procid% %msgid% $SUMOLOGIC_TOKEN %msg%\n")

action(type="omfwd" 
        protocol="tcp" 
        target="$SUMOLOGIC_HOST" 
        port="$SUMOLOGIC_PORT" 
        template="SumoFormat" 
        StreamDriver="gtls" 
        StreamDriverMode="1" 
        StreamDriverAuthMode="x509/name" 
        StreamDriverPermittedPeers="syslog.collection.*.sumologic.com")

		*.* @@$SUMOLOGIC_HOST:$SUMOLOGIC_PORT;SumoFormat
	_EOF_
fi

echo "Starting rsyslog..."
rsyslogd -n -f /etc/rsyslog.conf
