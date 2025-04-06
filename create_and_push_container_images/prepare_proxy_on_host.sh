# prepare_proxy_on_host.sh

# The host system needs to have a proxy server running.
# The proxy server needs to be configured to allow connections from the
# containers to the host system.

sudo apt-get install apt-cacher-ng -y

# there is not need to change the configuration
# /etc/apt-cacher-ng/acng.conf

# Before running the scripts to create images, run apt-cacher-ng in WSL Debian bash:
sudo apt-cacher-ng
