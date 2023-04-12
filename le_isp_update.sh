#!/bin/sh

set -euf

nl='
'

readonly isp_cert_dir='/home/httpd-cert'
readonly le_live_dir='/etc/letsencrypt/live'

user_certs="$(find "$isp_cert_dir" -type f -name '*.crt')"
IFS="$nl"
for c in $user_certs; do
    d="$(basename "$c" .crt)"
    k="${c%.crt}.key"
    le_d="${le_live_dir}/$d"
    if [ "$d" = 'dress-code.su' ]; then
        continue
    fi
    if [ -d "$le_d" ]; then
        fullchain="${le_d}/fullchain.pem"
        privkey="${le_d}/privkey.pem"
        if ! diff -q "$fullchain" "$c" >/dev/null; then
            cp -L -v "$fullchain" "$c"
            cp -L -v "$privkey" "$k"
        fi
    fi
done
