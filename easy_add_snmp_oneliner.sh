# SNMP Oneliner Setup
# The first 7 commands set the options. Starting with "COMMUNITY" and ending with "AGENT_USER"
COMMUNITY="public"
SYS_LOCATION="[SET-MET-TO-SOMETHING]"
SYS_CONTACT="[SET-MET-TO-SOMETHING]"
NETWORK_CIDR="10.0.0.0/20"
UPD_TCP="udp"
LOCAL_PORT="161"
AGENT_USER="ROOT"
apt update
apt install -y snmpd
mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.backup
echo -ne "  \# this create a  SNMPv1/SNMPv2c community named \"\"\n  \# and restricts access to LAN adresses 10.0.0.0/20 (last two 0's are ranges)\nrocommunity "$COMMUNITY" "$NETWORK_CIDR"\n\n  \# setup info\nsyslocation  "$SYS_LOCATION"\n\nsyscontact  "$SYS_CONTACT"\n\n  \# open up\nagentAddress  "$UPD_TCP":"$LOCAL_PORT"\n  \# run as\nagentuser  "$AGENT_USER"\n  \# dont log connection from UDP:\ndontLogTCPWrappersConnects yes\n  \# fix for disks larger then 2TB\nrealStorageUnits 0" >/etc/snmp/snmpd.conf
iptables -A INPUT -s $NETWORK_CIDR -p $UPD_TCP --dport $LOCAL_PORT -j ACCEPT
systemctl enable snmpd
systemctl restart snmpd
systemctl status snmpd
