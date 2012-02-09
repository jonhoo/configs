#!/bin/bash
#curl -s http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html | grep h3 | grep -v xx | perl -pe 's/^.*(\d{3})\s(.*)<\/h3>/$1 $2/' | 

# Fetch list from Wikipedia
curl -s http://en.wikipedia.org/wiki/List_of_HTTP_status_codes | \
# Find status codes
grep dt | grep -P 'span id="\d{3}"' | \
# Extract status code number and text
perl -pe "s/^.*span>(<a[^>]+>)?(\d{3})\s([\w\s\-']+?)\s*(\(|<).*/\2 \3/" | \
# Escape quotes (I'm a teapot)
sed "s/'/\\\\\'/" | \
# Pass through xargs
# Use this line if you want to include 418 (this puts all header strings in double quotes to cater for the ' in I'm)
#xargs -L 1 bash -c "echo 'header(\"HTTP/1.1' \"\$0\" \"\$*\"'\");' > \$0.snippet; echo \"Found \$0 \$*\""
grep -v 418 | xargs -L 1 bash -c "echo \"header('HTTP/1.1\" \"\$0\" \"\$*');\" > \$0.snippet; echo \"Found \$0 \$*\"";
