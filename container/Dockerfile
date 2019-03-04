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

FROM ubuntu:bionic

# setup dependencies
RUN apt-get update && apt-get upgrade -q -y
RUN apt-get install wget curl libjemalloc1 unzip jq -y

RUN apt-get -y install software-properties-common
RUN apt-add-repository -y ppa:bitcoin/bitcoin
RUN apt-get -y update
RUN apt-get -y install git build-essential libtool autotools-dev pkg-config libssl-dev  \
    libboost-all-dev libevent-dev libminiupnpc-dev autoconf automake \
    libdb4.8-dev libdb4.8++-dev

ADD healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh
HEALTHCHECK --interval=10s --timeout=30s --start-period=30s --retries=3 \
  CMD /healthcheck.sh

# create user
RUN adduser --disabled-login \
         --disabled-password \
         --gecos "" \
         --uid 17000 \
         zest

# copy necessary scripts
WORKDIR /home/zest/
COPY get-node.sh ./get-node.sh
COPY get-node-info.sh ./get-node-info.sh
COPY get-version.sh ./get-version.sh
COPY limits.conf ./limits.conf

# set execution rights
RUN chmod +x ./get-node.sh ./get-node-info.sh ./get-version.sh

# get latest zest binaries
RUN ./get-node.sh
RUN mv ./zestd /usr/sbin/zestd
RUN chmod +x /usr/sbin/zestd ./zest-cli

# run zest masternode
USER zest
ENTRYPOINT [ "/usr/sbin/zestd" ] 