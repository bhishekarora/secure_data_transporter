#!/bin/bash
################################################################################
#                              Payload Sender Utility                          #
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



  if hash netcat 2>/dev/null; then
       
    else
       echo "########This system doesn't contain GNU netcat##### "
       echo  ""
       echo "******This system can be only be used as a receiver and not as a sender****"
    fi




bwtest=0
            echo ""

                while getopts ":hb" opt; do
                case ${opt} in
                        h ) 
                        echo "Usage:"
                        echo "PayloadSender.sh                  Normal mode"
                        echo "PayloadSender.sh -b               Bandwidth test mode"
                        exit
                        ;;
                        b ) 
                        bwtest=1  
                        echo -e  "\n######Enabled Uplink Bandwidth test mode#######"
                        echo -e "\n Please make sure port 9000 is free on receiver & allowed in firewall"
                        echo ""
                        ;;
                        \? ) echo "Usage: cmd [-h] [-b]"
                        ;;
                esac
                done


bar () 
{
            BAR='####################'   # this is full bar, e.g. 20 chars

for i in {1..20}; do
    echo -ne "\r${BAR:0:$i}" # print $i chars of $BAR from 0 position
    sleep .1                 # wait 100ms between "frames"
done
}


color() {
      printf '\033[%sm%s\033[m\n' "$@"
      # usage color "31;5" "string"
      # 0 default
      # 5 blink, 1 strong, 4 underlined
      # fg: 31 red,  32 green, 33 yellow, 34 blue, 35 purple, 36 cyan, 37 white
      # bg: 40 black, 41 red, 44 blue, 45 purple
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

div ()  # Arguments: dividend and divisor
{
        if [ $2 -eq 0 ]; then echo division by 0; exit; fi
        local p=12                            # precision
        local c=${c:-0}                       # precision counter
        local d=.                             # decimal separator
        local r=$(($1/$2)); echo -n $r        # result of division
        local m=$(($r*$2))
        [ $c -eq 0 ] && [ $m -ne $1 ] && echo -n $d
        [ $1 -eq $m ] || [ $c -eq $p ] && return
        local e=$(($1-$m))
        let c=c+1
        div $(($e*10)) $2
}  

mkBanner "-" "40" "Payload Sender Utility-- Multi Threaded TAR/SSL "

if ! [ -x "$(command -v nc)" ]; then
  echo 'Error: netcat  is not installed.// apt install netcat to fix ' >&2
  exit 1
fi




echo " Enter path of source folder"
echo " "
read path
echo " "
origsize=$(du  -sm $path | awk '{print $1}')
echo 'Checking original size'
echo 'Orig size ' $origsize 'MB'
echo ''

mkBanner "-" "50"  "Path  entered $path"
sleep 2
if [ ! -d $path ]; then 
  echo " ===="
  echo "Dir not found... exiting";
  exit
else
   
   echo  "Entered path is valid ... will continue "

fi
    
mkBanner "-" "50" " Tar build starting......"

#./spinner  tar -C $path -I pigz -cf ball.tgz 
./spinner  tar -I pigz -cf ball.tgz  --absolute-names $path


if [ ! -f $(pwd)/ball.tgz ]; then
        echo "Tar ball not generated  ";
	    	echo " "
                
else
          echo -e "\n\n*******Makeing TAR with parallel threads***********"
               
	          echo " Tar ball generated ====> $pwd/ball.tgz";
      
  	       mkBanner "-" "50" "Compression stats..." 
          finalsize=$(du  -sm ball.tgz | awk '{print $1}')
         
          echo "Initial size " $origsize "MB - Final Size -" $finalsize "MB"
          echo ""
          
         
fi


mkBanner "-" "50"  "Specify the host where receiver is running"
read host
echo  "---- Enter port ----- "
read  port

if [ -z "$host" ] || [ -z "$port" ]
then
      mkBanner  "-" "20" "Error ---host or port  is empty,will exit.. "
      exit

else
      echo ""
fi


echo "Please run PayloadReceiver @ other end"
sleep 2


           

            if [ $bwtest -eq 1 ]; then 

            echo "Calculating the estimated time as per the bandwidth of uplink"
            bw=`./fte.sh $host`
            bar
             eta=$(echo $finalsize / $bw | bc -l)
             min=`echo 'scale=2;'$eta'/60'| bc -l`
             [[ "$eta" != "" ]] && echo -e "\nBW UPstream $bw , Expected time in Minutes#" $min 
             echo "==============="
             
             fi
          
 

            read -p "Want to encrypt ? (y/n) " encrypt

            if [ "$encrypt" = "y"  ] ;then
            mkBanner "-" "50" "Starting to encrypt, enter a *PASSWORD* atleast 4 characters"
             openssl aes-256-cbc -md sha512  -in ball.tgz  -out securedball.tgz 2>/dev/null
            echo "Encryption done with AES 256 sending now to target "
            bar
            echo ""  
            nc -N $host $port <   securedball.tgz

            [[ "$?" -ne 0 ]] && echo -e "\nError occured exiting...check listener..." && exit

            echo "File sent to target==> securedball.tgz"
            hash=`md5sum securedball.tgz | awk '{ print $1 }'`
            
            mkBanner "-" "30" "Source HASH - please match @ other end for tamper "
            echo "HASH $hash"
            else
            mkBanner "-" "50" "Trying to send"
            bar
             nc -N $host $port < ball.tgz

             [[ "$?" -ne 0 ]] && echo -e "\nError occured exiting.. check listener.." && exit

             mkBanner "-" "50" "Unencrypted file sent ==> ball.tgz" 
            fi



   
    
   





#/home/abhishek/custom/playground/bash/data






