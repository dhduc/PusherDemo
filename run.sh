#!/bin/sh
PROJECT='pusher.local'
IP='127.0.0.1'

ENDC=`tput setaf 7`
RED=`tput setaf 1`
GREEN=`tput setaf 2`

echo 'Start running Pusher'

# Create folder
if [ -d '/var/www/pusher' ]; then
	rm -rf /var/www/pusher
fi
mkdir /var/www/pusher	
cp * /var/www/pusher	

# Configure Nginx
if [ -s 'etc/nginx/conf.d/pusher.nginx' ]; then
	sudo rm etc/nginx/conf.d/pusher.nginx
fi	
sudo cp pusher.conf /etc/nginx/conf.d/pusher.conf

# Attempt to hosts files
CONDITION="grep -q '"$PROJECT"' /etc/hosts"
if eval $CONDITION; then
	CMD="sudo sed -i -r \"s/^ *[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+( +"$PROJECT")/"$IP" "$PROJECT"/\" /etc/hosts";
else
	CMD="sudo sed -i '\$a\\\\n# Added automatically by run.sh\n"$IP" "$PROJECT"\n' /etc/hosts";
fi

eval $CMD
if [ "$?" -ne 0 ]; then
	echo $RED ERROR: Could not update $PROJECT to hosts file. $ENDC
	exit 1
fi

# Restart Nginx
sudo service nginx restart

echo 'Go to' $GREEN 'http://'$PROJECT $ENDC