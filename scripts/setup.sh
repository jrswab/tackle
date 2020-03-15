#!/bin/sh

green='\033[0;32m'
nc='\033[0m' # No Color

# Change root password (optional):
printf "%s""${green}"
printf "Would you like to change the Root password? (Recomended if the server is new) (y|n)\n"
printf "If your server already had you do this type n and press enter%s ""${nc}"
read -r chgRoot
if [ "$chgRoot" = "y" ]; then
    passwd
fi

printf "%s\n""${green}"
printf "Updating Your Operating System:%s\n""${nc}"
sleep 2;
apt-get update && apt-get upgrade;

printf "%s\n""${green}"
printf "Installing firewall:%s\n""${nc}";
sleep 2;
apt-get install ufw;
ufw allow ssh &&
ufw allow 2001 &&
ufw allow 8090 &&
ufw deny http &&
ufw deny https && 
ufw default deny incoming &&
ufw default allow outgoing &&
ufw limit openssh &&
# User will be asked:
# Command may disrupt existing ssh connections. Proceed with operation (y|n)?
# Add to the updated walkthrough
ufw enable;

printf "%s""${green}"
printf "Open a new terminal or putty session.\n"
printf "Try to login again as root with your new password to make sure you are not locked out.\n"
printf "Were you able to log back in? (y|n)%s ""${nc}"
read -r access
if [ "$access" = "n" ]; then
    ufw disable;
    printf "%s""${green}"
    printf "Disabled Firewall\n"
    printf "Try to login again as root with your new password to make sure you are not locked out.\n"
    printf "Were you able to log back in? (y|n)%s ""${nc}"
    read -r access2
    if [ "$access2" = "n" ]; then
        printf "\n%s""${green}"
        printf "Please check your Root password and try again.\n"
        printf "If the problem persists, leave this SSH session open and message the support channel in the Tackle Discord server.%s\n""${nc}"
        exit 1
    fi
fi

# Install Docker:
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
systemctl enable docker

# user has access:
username=""
printf "%s""${green}"
printf "Tackle can not be run as root.\n"
printf "So let's create a new user.\n"
printf "\n"

# Make sure username is a lowercase "word"
while true
do
    printf "Please enter a user name containing only lowercase letters:\n"
    read -r username
    checkRegex=$(printf "%s""$username" | sed -E '/^[a-z]*$/p' | wc -l)
    if [ "$checkRegex" = 1 ]; then
        break;
    fi
done

adduser --gecos "" "$username"
usermod -a -G sudo "$username"
groupadd docker
usermod -aG docker "$username"

printf "%s""${green}"
printf "Open a new terminal or putty session.\n"
printf "Login with your new username and password..\n"
printf "Was the login successful? (y|n)%s ""${nc}"
read -r userLogin

# disable root login and updat fstab
if [ "$userLogin" = "y" ]; then
    # deleting with sed and appending with printf due to differences between OSes
    sed -i '/PermitRootLogin yes/c\' /etc/ssh/sshd_config
    printf "PermitRootLogin no" >> /etc/ssh/sshd_config

    printf "%s""${green}"
    printf "Root login over ssh has been disabled for server security.%s \n""${nc}"
fi

printf "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0" >> /etc/fstab

# Check if the tackle directory exists on the server.
# If not change to the home directory
if [ ! -d /home/"$username"/tackle ]; then
	cd /home/"$username"/ &&
	runuser -l "$username" -c 'mkdir tackle' &&
	runuser -l "$username" -c 'touch tackle/run.sh' &&
	runuser -l "$username" -c 'wget --output-document=tackle/run.sh https://raw.githubusercontent.com/jrswab/tackle/master/scripts/run.sh' &&
	runuser -l "$username" -c 'chmod 550 tackle/run.sh';
	runuser -l "$username" -c 'docker pull jrswab/tackle'
fi

printf "%s""${green}"
printf "Only use the newly created user from now on.\n"
printf "Server reboot required. Once rebooted login as your new user.%s\n""${nc}"