#!/bin/sh

#  ZEST Masternode docker template
#  Copyright © 2019 cryon.io
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#  Contact: cryi@tutanota.com

BASEDIR=$(dirname "$0")

PARAM=$(echo "$1" | sed "s/=.*//")
VALUE=$(echo "$1" | sed "s/[^>]*=//")

case $PARAM in
    ip)
        PORT=$(grep "masternodeaddr=" "$BASEDIR/../data/zest.conf" | sed 's/masternodeaddr=//g' | sed 's/^.*://g')
         case $VALUE in 
            *:*)
                TEMP=$(sed "s/masternodeaddr=.*/masternodeaddr=[$VALUE]:$PORT/g" "$BASEDIR/../data/zest.conf")
            ;;
            *)
                TEMP=$(sed "s/masternodeaddr=.*/masternodeaddr=$VALUE:$PORT/g" "$BASEDIR/../data/zest.conf")
            ;;
        esac
        #TEMP=$(sed "s/masternodeaddr=.*/masternodeaddr=$VALUE:$PORT/g" "$BASEDIR/../data/zest.conf")

        printf "%s" "$TEMP" > "$BASEDIR/../data/zest.conf"
    ;;
    port)
        ADDR=$(grep "masternodeaddr=" "$BASEDIR/../data/zest.conf" | sed 's/masternodeaddr=//g')
        PORT=$(printf "%s" "$ADDR" | sed 's/^.*://g')
        IP=$(printf "%s" "$ADDR" | sed "s/:$PORT$//g")

        TEMP=$(sed "s/masternodeaddr=.*/masternodeaddr=$IP:$VALUE/g" "$BASEDIR/../data/zest.conf")
        # TEMP=$(printf "%s" "$TEMP" | sed "s/port=.*/port=$VALUE/g")
        printf "%s" "$TEMP" > "$BASEDIR/../data/zest.conf"

        NEW_COMPOSE=$(sed "s/- \".*:22030\"/- \"$VALUE:22030\"/g" "$BASEDIR/../docker-compose.yml")
        printf "%s" "$NEW_COMPOSE" > "$BASEDIR/../data/docker-compose.yml"
    ;;
    nodeprivkey)
        TEMP=$(sed "s/masternodeprivkey=.*/masternodeprivkey=$VALUE/g" "$BASEDIR/../data/zest.conf")
        printf "%s" "$TEMP" > "$BASEDIR/../data/zest.conf"
    ;;
    NODE_VERSION) 
        if grep "NODE_VERSION=" "$BASEDIR/../containers/limits.conf"; then
            TEMP=$(sed "s/NODE_VERSION=.*/NODE_VERSION=$VALUE/g" "$BASEDIR/../containers/limits.conf")
            printf "%s" "$TEMP" > "$BASEDIR/../containers/limits.conf"
        else 
            printf "NODE_VERSION=%s" "$VALUE" >> "$BASEDIR/../containers/limits.conf"
        fi
    ;;
    PROJECT)
        printf "PROJECT=%s" "$VALUE" >  "$BASEDIR/../project_id"
    ;;
esac