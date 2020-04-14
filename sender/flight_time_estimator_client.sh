
      while getopts ":h" opt; do
                case ${opt} in
                        h ) 
                        echo "Usage:"
                        echo "./flight_time_finder.sh hostname  port"
                  
                        exit
                        ;;
                  
                esac
                done
                
                

echo "Independent usage is flight_time_finder.sh hostname  port "

speedtest/client  --server-ip $1  --server-port $2 
