#! /vendor/bin/sh

# Copyright (c) 2013, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

CLOVERMAC=/persist/wlan_mac.clover
WLAN_MAC_BIN=/persist/wlan_mac.bin
MACADDRESSBIN=/persist/wlan_bt/wlan.mac
INTFSTR0="Intf0MacAddress="
MAC0=000AF58989FF

get_mac () {
  if [ -f $MACADDRESSBIN ]; then
    realMac=$(printf "%b"  | od -An -t x1 -w6 -N6  $MACADDRESSBIN | tr -d '\n ')
  else
    if [ -f $WLAN_MAC_BIN ]; then
        checkMac=$(printf "%b"  | od -An -t x1 -w6 -N6  $CLOVERMAC | tr -d '\n ')
        if [ $checkMac != $MAC0 ] && [ "${checkMac:0:2}" != "49" ]; then
          realMac=$checkMac
        fi
    else
        realMac=$MAC0
    fi
  fi
}

wlan_mac () {
    wlanMac=$(head -n 1 $CLOVERMAC)
    wlanMac=$(echo -e "${wlanMac//$INTFSTR0}")
}

write_mac () {
        echo -e  "$INTFSTR0""$realMac" >$CLOVERMAC
        echo -e  "END">>$CLOVERMAC
        chown wifi $CLOVERMAC
        chgrp wifi $CLOVERMAC
}

if [ -f $CLOVERMAC ]; then
    get_mac
    wlan_mac
    if [ "${realMac:0:6}" == "${wlanMac:0:6}" ] && [ "${wlanMac:0:2}" != "49" ]; then
        exit 1
    else
        get_mac
        write_mac
    fi
else
    get_mac
    write_mac
fi
