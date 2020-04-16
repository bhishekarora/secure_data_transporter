#!/bin/bash
################################################################################
#                              Payload Receiver Utility                          #
#                                                                              #
# Features                                                                     #
#  -Hyper Threaded Compression / 1 thraed per core                             #
#  -SSL Encryption                                                             #
#  -Tamper proof HASH check before and after transfer                          #
#  -Optimal compression Algorithm with balance of speed/time/final size        #
#                                                                              #
# Change History                                                               #
# Abhishek Arora 01/Apr/2020                                                   #
#                                                                              #
#                                                                              #
################################################################################
################################################################################
################################################################################
#                                                                              #
#  Copyright (C) 2007, 2019 Abhishek Arora                                     #
#                                                        #
#                                                                              #
#  This program is free software; you can redistribute it and/or modify        #
#  it under the terms of the GNU General Public License as published by        #
#  the Free Software Foundation; either version 2 of the License, or           #
#  (at your option) any later version.                                         #
#                                                                              #
#  This program is distributed in the hope that it will be useful,             #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of              #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               #
#  GNU General Public License for more details.                                #
#                                                                              #
#  You should have received a copy of the GNU General Public License           #
#  along with this program; if not, write to the Free Software                 #
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA   #
#                                                                              #
################################################################################
################################################################################
################################################################################
        echo ""

                while getopts ":hb" opt; do
                case ${opt} in
                        h ) 
                        echo "Usage:"
                        echo "PayloadReceiver.sh                  Normal mode"
                        echo "PayloadReceiver.sh -b               Bandwidth test mode"
                        exit
                        ;;
                        b ) 
                         
                        echo -e  "\n#####Enabled Uplink Bandwidth test mode#####"
                        echo -e "\n Please make sure port 9000 is free on this server & allowed in firewall"
                        echo ""
                        flag=`netstat -tnlp 2>/dev/null|grep speedtest|grep :9000|wc -l`
                      
                        if [[ "$flag" -ne 0 ]]  ;then
                       
                        echo "Found *Bandwidth Server* instance, reusing.."

                        else
                        speedtest/server   & 
                        pid=$!
                    
                        

                        fi
                          

                        ;;
                        \? ) echo "Usage: cmd [-h] [-b]"
                        ;;
                esac
                done


function bar () 
{
            BAR='####################'   # this is full bar, e.g. 20 chars

for i in {1..20}; do
    echo -ne "\r${BAR:0:$i}" # print $i chars of $BAR from 0 position
    sleep .1                 # wait 100ms between "frames"
done
}

function mkBanner() {
  mkBorder $1 $2
  echo -e " $3"
  mkBorder $1 $2
}

function mkBorder() {
  for i in $(eval echo {1..$2}); do
    printf $1
  done
  echo ""
} 


mkBanner "-" "50" "Payload Receiver Utility  "


#mkBanner "-" "50"  "Enter the IP/hostname which is reachable by the sender utility "
#read ip 
mkBanner "-" "50"  "Enter port to accept the payload on "
read port 

echo ""
mkBanner "-" "50" "You will receive the file on  port :$port " 
mkBanner "-" "50" "Please provide these details while starting sender utility"

 read -p "Will you be sending encrypted payload ? (y/n) " encrypt

            if [ "$encrypt" = "y"  ] ;then
            mkBanner "-" "50" "Waiting for the encrypted payload "
                 nc -l -p $port > securedball.tgz  < /dev/null
                mkBanner "-" "50" "Encrypted payload received"
               

                echo ""
                hash=`md5sum securedball.tgz | awk '{ print $1 }'`
                mkBanner "-" "10" "Checking hash for on wire tamper "
                echo ""
                echo "Received hash is ==>" $hash 
                echo ""
                echo "Please compare this with source HASH and press y/n to continue "
                echo "==============="
                echo "Continue ?????"
                read response 

                if [ "$response" = "y"  ] ;then

              
                openssl aes-256-cbc -d -md sha512 -in securedball.tgz  -out ball.tgz 2>/dev/null
                 [[ "$?" -ne 0 ]] && echo -e "\nWill exit, couldnt decrypt with pwd..." && exit
                mkBanner "-" "50" "Uncompressing the payload "
                bar
               

               ./spinner  tar -xf ball.tgz 
                
                echo "Payload exploded in current directory"

                else 
                exit
                fi

            else
                mkBanner "-" "50" "Waiting for the unencrypted payload"
                nc -l -p $port > ball.tgz  < /dev/null
                mkBanner "-" "50" "Unencrypted payload received , uncompressing"
                bar
                
                ./spinner  tar -xf ball.tgz 
                 bar
                 echo "Payload exploded in current directory"
            fi

                #Cleaing the bandwidth server process..
                if [ "$pid" != ""  ] ;then
                kill -9 $pid
                echo"Cleaning the pid of bw server"
                fi