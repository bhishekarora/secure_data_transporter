#!/bin/bash
################################################################################
#                      Pre flight test to check if system is capable.          #
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


hash md5sum nc du tar &>/dev/null && 
    echo "All programs installed, ** GOOD TO GO ** " ||
    echo "At least one program is missing"
echo "=========="
echo "Checking Number of Processors"
echo "=========="
cat /proc/cpuinfo |grep processor
echo "=========="
echo "Checking Number of Cores"

echo "=========="
cat /proc/cpuinfo |grep cores
echo "=========="

echo " Compression capability will be Processors * Cores"
