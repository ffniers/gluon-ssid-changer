#!/bin/sh

# At first some Definitions:

ONLINE_SSID='Freifunk'
OFFLINE_SSID='Freifunk-Ohne-Internet' 
UPPER_LIMIT='55' #Above this limit the online SSID will be used
LOWER_LIMIT='45' #Below this limit the offline SSID will be used
# In-between these two values the SSID will never be changed to preven it from toggeling every Minute.

#Is there an active Gateway?
GATEWAY_TQ=`batctl gwl | grep "^=>" | awk -F'[()]' '{print $2}'| tr -d " "` #Grep the Connection Quality of the Gateway which is currently used

if [ ! $GATEWAY_TQ ]; #If there is no gateway there will be errors in the following if clauses
then
	GATEWAY_TQ=0 #Just an easy way to get an valid value if there is no gatway
fi

if [ $GATEWAY_TQ -gt $UPPER_LIMIT ];
then
	echo "Gateway TQ is $GATEWAY_TQ node is online"
	for HOSTAPD in $(ls /var/run/hostapd-phy*); do #Check status for all physical devices
		CURRENT_SSID=`grep "^ssid=$ONLINE_SSID" $HOSTAPD | cut -d"=" -f2`
		if [ $CURRENT_SSID == $ONLINE_SSID ]
		then
			echo "SSID $CURRENT_SSID is correct, noting to do"
			HUP_NEEDED=0
			break
		fi
		CURRENT_SSID=`grep "^ssid=$OFFLINE_SSID" $HOSTAPD | cut -d"=" -f2`
		if [ $CURRENT_SSID == $OFFLINE_SSID ]
		then
			logger -s -t "gluon-offline-ssid" -p 5 "TQ is $GATEWAY_TQ, SSID is $CURRENT_SSID, change to $ONLINE_SSID" #Write Info to Syslog
			sed -i s/^ssid=$CURRENT_SSID/ssid=$ONLINE_SSID/ $HOSTAPD
			HUP_NEEDED=1 # HUP here would be to early for dualband devices
		else
			echo "There is something wrong, did not find SSID $ONLINE_SSID or $OFFLINE_SSID"
		fi
	done
fi

if [ $GATEWAY_TQ -lt $LOWER_LIMIT ];
then
	echo "Gateway TQ is $GATEWAY_TQ node is considered offline"
	for HOSTAPD in $(ls /var/run/hostapd-phy*); do #Check status for all physical devices
		CURRENT_SSID=`grep "^ssid=$OFFLINE_SSID" $HOSTAPD | cut -d"=" -f2`
		if [ $CURRENT_SSID == $OFFLINE_SSID ]
		then
			echo "SSID $CURRENT_SSID is correct, noting to do"
			HUP_NEEDED=0
			break
		fi
		CURRENT_SSID=`grep "^ssid=$ONLINE_SSID" $HOSTAPD | cut -d"=" -f2`
		if [ $CURRENT_SSID == $ONLINE_SSID ]
		then
			logger -s -t "gluon-offline-ssid" -p 5 "TQ is $GATEWAY_TQ, SSID is $CURRENT_SSID, change to $OFFLINE_SSID" #Write Info to Syslog
			sed -i s/^ssid=$ONLINE_SSID/ssid=$OFFLINE_SSID/ $HOSTAPD
			HUP_NEEDED=1 # HUP here would be to early for dualband devices
		else
			echo "There is something wrong, did not find SSID $ONLINE_SSID or $OFFLINE_SSID"
		fi
	done
fi

if [ $GATEWAY_TQ -ge $LOWER_LIMIT -a $GATEWAY_TQ -le $UPPER_LIMIT ]; #This is just get a clean run if we are in-between the grace periode
then
	echo "TQ is $GATEWAY_TQ, do nothing"
	HUP_NEEDED=0
fi

if [ $HUP_NEEDED == 1 ]; then
	killall -HUP hostapd # Send HUP to all hostapd um die neue SSID zu laden
	HUP_NEEDED=0
	echo "HUP!"
fi
