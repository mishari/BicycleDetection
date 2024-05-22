#!/bin/bash

VIDEOID=479
PYCODE=$(cat <<EOF
import re
from playwright.sync_api import sync_playwright
with sync_playwright() as p:
    browser = p.webkit.launch()
    page = browser.new_page()
    response = page.goto('http://www.bmatraffic.com/')
    for h in response.headers_array():
    	if h['name'] == 'Set-Cookie':
            m = re.match('(.*SessionId=[a-z0-9]+)', h['value'])
            cookie = m.group(1)
            print(cookie)
    browser.close()
EOF
)

mkdir -p images

REQ_NO=0

while true; do
    if (( REQ_NO % 3500 == 0 )); then
	COOKIE=$(python <<< "$PYCODE")
	echo "COOKIE $COOKIE"
	curl "http://www.bmatraffic.com/PlayVideo.aspx?ID=$VIDEOID" -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/png,image/svg+xml,*/*;q=0.8' -H 'Accept-Language: th,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'DNT: 1' -H 'Connection: keep-alive' -H 'Referer: http://www.bmatraffic.com/index.aspx' -H "Cookie: $COOKIE" -H 'Upgrade-Insecure-Requests: 1' -H 'Sec-GPC: 1' -H 'Priority: u=4' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache'
    fi
    TIMESTAMP=$(date +%s)
PATHNAME=images/$TIMESTAMP.jpg

    curl "http://www.bmatraffic.com/show.aspx?image=$VIDEOID&&time=$TIMESTAMP" -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0' -H 'Accept: image/avif,image/webp,image/png,image/svg+xml,image/*;q=0.8,*/*;q=0.5' -H 'Accept-Language: th,en;q=0.5' -H 'Accept-Encoding: gzip, deflate' -H 'DNT: 1' -H 'Connection: keep-alive' -H "Referer: http://www.bmatraffic.com/PlayVideo.aspx?ID=$VIDEOID" -H "Cookie: $COOKIE" -H 'Sec-GPC: 1' -H 'Priority: u=4, i' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -o $PATHNAME
    REQ_NO=$(($REQ_NO + 1))
    sleep 1
done
