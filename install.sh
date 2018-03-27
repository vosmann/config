sudo apt-get update

# tools
sudo apt-get -y install silversearcher-ag # faster than ack-grep
sudo apt-get -y install cloc # lines of code
sudo apt-get -y install tree
sudo apt-get -y install wget
sudo apt-get -y install curl
sudo apt-get -y install apache2-utils # ab - apache benchmark, e.g. ab -k -c 2 -n 10 www.example.com # -k to reuse connections

wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker vosmann
sudo apt-get install apparmor

