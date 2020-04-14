#!/bin/bash
################################################################################
#                              Test.sh                                            #
#                                                                              #
# Use this template as the beginning of a new program. Place a short           #
# description of the script here.                                              #
#                                                                              #
# Change History                                                               #
# Abhishek Arora 01/Apr/2020 Test file for travis                              #
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

bw=.9898888
eta=2000
min=`echo 'scale=2;'$eta'/60'| bc -l`
echo -e "\nBW UPstream $bw , Expected time  in Minutes $min" 


        finalsize=$(du  -sm /home/abhishek/custom/playground/bash/data | awk '{print $1}')
       
        host='192.168.1.18'
        bw=`./fte.sh $host`
        #bw='.9876876'
        #eta=$((${finalsize}00/$bw))
        eta=$(echo $finalsize / $bw | bc -l)
        echo $eta

             #result=$(div ${finalsize%?} $bw)
             
             [[ "$eta" != "" ]] && echo -e "\nBW UPstream $bw , Expected time  in Minutes" && echo 'scale=2;'$eta'/60' | bc -l   
            

