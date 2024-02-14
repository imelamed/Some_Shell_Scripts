#!/bin/bash

#This script customais station name and join it to domain

LOGFILE='initcomp.log'
DOMAIN='itgenie.co.il'
SSSDCNF='/etc/sssd/sssd.conf'
TIMESTAMP=$(date '+%Y%m%d-%H:%M:%S')

if [ ! -e $LOGFILE ]; then
        read -p "Enter Computer Name: " compname
        read -p "Enter Domain UserName: " username
        echo "User $username will have sudo permissions on this ${compname^^} station."
        read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
        echo "$(date '+%Y%m%d-%H:%M:%S') - Starting Initializtion Script initcomp.sh on $TIMESTAMP" > $LOGFILE

        echo "Changing Computer Name..."
        echo "$(date '+%Y%m%d-%H:%M:%S') - Changing Computer Name..." >> $LOGFILE
        sed -i -e "s/DEVLNXWSTEMP/${compname^^}/g" /etc/hosts
        sed -i -e "s/DEVLNXWSTEMP/${compname^^}/g" /etc/hostname
        echo "Computer Name Changed - Successfully to ${compname^^}"
        echo "Adding User to SUDOERS..."
        echo "$(date '+%Y%m%d-%H:%M:%S') - Adding User $username to SUDOERS..." >> $LOGFILE
        echo "$username  ALL=(ALL:ALL) ALL" >> /etc/sudoers
        echo "User $username  added to sudoers - Successfully"
        echo "Rebooting the system.... Manually run init script again after reboot to join station to domain"
        echo "$(date '+%Y%m%d-%H:%M:%S') - Rebooting The System..." >> $LOGFILE
        sudo reboot
else
        echo "Starting Phase 2 Join $(hostname) to d0main - $DOMAIN"
        echo "$(date '+%Y%m%d-%H:%M:%S') - Starting Phase 2 Join $(hostname) to domain - $DOMAIN" >> $LOGFILE
        sudo realm join $DOMAIN
        echo "$(date '+%Y%m%d-%H:%M:%S') - $(hostname) Joined domain - $DOMAIN " >> $LOGFILE
        echo "Custimusing sssd.conf file"
        echo "$(date '+%Y%m%d-%H:%M:%S') - Custimusing $SSSDCNF file" >> $LOGFILE
        sed -i -e "s/fallback_homedir/#fallback_homedir/g" $SSSDCNF
        sed -i -e "s/use_fully_qualified_names/#use_fully_qualified_names/g" $SSSDCNF
        echo "case_sensitive = false" >> $SSSDCNF
        echo "ad_gpo_access_control = enforcing" >> $SSSDCNF
        echo "ad_gpo_map_remote_interactive = +xrdp-sesman" >> $SSSDCNF
        echo "fallback_homedir = /home/%u" >> $SSSDCNF
        echo "use_fully_qualified_names = false" >> $SSSDCNF
        echo "$(date '+%Y%m%d-%H:%M:%S') - Custimusing sssd.conf file Completed " >> $LOGFILE
        echo "Restarting sssd sevice"
        echo "$(date '+%Y%m%d-%H:%M:%S') - Restarting sssd sevice " >> $LOGFILE
        sudo systemctl status sssd >> $LOGFILE
        sudo systemctl restart sssd
        echo "$(date '+%Y%m%d-%H:%M:%S') - sssd sevice after restart " >> $LOGFILE
        sudo systemctl status sssd >> $LOGFILE
        echo "sssd service restartd"
        echo "Init Process Completed - computer joined domain "
        echo "$(date '+%Y%m%d-%H:%M:%S') - Init Process Completed " >> $LOGFILE
fi
