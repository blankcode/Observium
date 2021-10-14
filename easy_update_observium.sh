# Updating Observium to the latest version

# Move the old software out of the way
mv observium observium_old

# Download the new software
wget -Oobservium-community-latest.tar.gz https://www.observium.org/observium-community-latest.tar.gz
tar zxvf observium-community-latest.tar.gz # Unpack it

# Move the old data and config to the new software
mv /opt/observium_old/rrd observium/
mv /opt/observium_old/logs observium/
mv /opt/observium_old/config.php observium/

# Run discovery
/opt/observium/discovery.php -u
/opt/observium/discovery.php -h all

# Remove the old software
rm /opt/observium_old
