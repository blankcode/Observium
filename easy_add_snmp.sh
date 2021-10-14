# Basic Options
# This creates a  SNMPv1/SNMPv2c community named "public".
# Change this to what you use for your community or leave it as default.
COMMUNITY="public"

# Where is the system located? "Datacenter" / "West Dorm, Floor 1, Netwrok Closet"
# Can also be GPS Coordinates or an address.
SYS_LOCATION="VM Datacenter"

# Who to contact? Name or Email.
SYS_CONTACT="bb@myabba.org"

# Network settings
# Network Space. You can get this from "ip route"
# ip route | grep -Po "1(0|72|92)(\.\d{1,3}){3}/\d{1,3}"
NETWORK_CIDR="10.0.0.0/20"

# Protocol TCP or UDP, UDP is typical. Port to use? 161 is typical
UPD_TCP="udp"
LOCAL_PORT="161"

# What user should SNMP run under? root is typical due to access needs.
AGENT_USER="root"
#__________________________________#
###### DO NOT EDIT BELOW HERE ######

# Install snmpd
apt update
apt install -y snmpd

# Configure snmpd.conf; Backup original configuration file.
mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.backup

# Create a new config file from the options the user set at the begining of the script.
echo -ne "  \# this create a  SNMPv1/SNMPv2c community named \"\"\n  \# and restricts access to LAN adresses 10.0.0.0/20 (last two 0's are ranges)\nrocommunity "$COMMUNITY" "$NETWORK_CIDR"\n\n  \# setup info\nsyslocation  "$SYS_LOCATION"\n\nsyscontact  "$SYS_CONTACT"\n\n  \# open up\nagentAddress  "$UPD_TCP":"$LOCAL_PORT"\n  \# run as\nagentuser  "$AGENT_USER"\n  \# dont log connection from UDP:\ndontLogTCPWrappersConnects yes\n  \# fix for disks larger then 2TB\nrealStorageUnits 0" >/etc/snmp/snmpd.conf

# Firewall allow lan can access
iptables -A INPUT -s $NETWORK_CIDR -p $UPD_TCP --dport $LOCAL_PORT -j ACCEPT

# Enable SNMPD to start at boot
systemctl enable snmpd

# Restart snmpd service to apply settings
systemctl restart snmpd
