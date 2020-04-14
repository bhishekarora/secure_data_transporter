speedtest/client  --server-ip $1  --server-port 9000 |grep -a 'Mbps' | tail -n1 | awk '{print $6}'
