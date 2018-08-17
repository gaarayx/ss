#!/bin/sh
  
client_ip=` netstat -anp | grep ESTABLISHED | grep python \
| grep 8388 | awk '{print $5}' \
| sort -u | cut -d : -f 1 | uniq `

cnt=0
for ip in $client_ip
do
        cnt=$(($cnt+1))
        echo "clinet[$cnt]"
        echo -n "\t"    
        curl https://ip.cn/index.php?ip=$ip
done

echo "\nclient sum = $cnt"
