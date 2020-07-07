#!/bin/bash

### Change vars to your values
minecraft_dir=/home/minecraft 	#Directory where Minecraft files are located
jar_file=paper.jar 				      #Minecraft .jar file name
backup_dir=/home/backups-mc		  #Directory where Minecraft will save backups, a folder with the date and time will be created inside
screen_name=mcs				        	#Name of the screen in which Minecraft is running. If you followed Google Cloud guide [1] leave it to mcs

#[1] https://cloud.google.com/solutions/gaming/minecraft-server
###

# Functions

function print_name(){
	cat << EOF
---------------------------------------------------
|   __  __  ___        _   ___  __  __ ___ _  _   |
|  |  \/  |/ __| __   /_\ |   \|  \/  |_ _| \| |  |
|  | |\/| | (_  |___|/ _ \| |) | |\/| || ||    |  |
|  |_|  |_|\___|    /_/ \_\___/|_|  |_|___|_|\_|  |
|  BY MVALSELLS                                   |
---------------------------------------------------

EOF
}

function print_menu() {
	cat << EOF
---------------
Main menu
---------------
1. Start Minecraft
2. Stop Minecraft
3. Access Minecraft console
4. Make backup
5. Exit
----
Input menu option number [1-5]: 
EOF
}

#Main code

menu=0
if [ 0 == $UID ]
then
        while [ $menu -ne 4 ]
        do
                clear
                print_name
                print_menu
                read -r menu
                case "$menu" in
                        1)
                                
								#Check if SCREEN is already running

								if [ "$(screen -list | grep "$screen_name" -c)" -eq 0 ]
								then
									#If not running asking user if it wants to start a doing so.
	                                echo "Do you want to start Minecraft server? [y/n]"
	                                read -r start
	                                if [ "y" == "$start" ]
	                                then
	                                        echo "Starting Minecraft..."
	                                        if cd "$minecraft_dir" #Try to change direcotry, if it does not exist show an error
	                                        then
		                                        screen -d -m -S "$screen_name" java -Xms2G -Xmx10G -d64 -jar "$jar_file" nogui
		                                        echo -e "Screen started with the name $screen_name, in 20-60 seconds it should be working"
		                                    else
		                                    	echo -e "Error changing directory to $minecraft_dir"
		                                   	fi
	                                else
	                                        echo "Okey, not doing anything"
	                                fi
	                            else
	                            	#Do not try to start a new screen if it is alread -ry runing
	                            	echo -e "It looks like theres is screen running which the name contains $screen_name"
	                            	echo "Not doing anything"
	                            fi;;
                        
	                    2)
							echo "Do you want to stop Minecraft server? [y/n]"
	                        read -r stop
	                        if [ "y" == "$stop" ]
							then
								screen -r "$screen_name" -X stuff 'stop\n'
								echo "Stoping Minecraft"
							else
								echo "Okey, not doing anything"
							fi;;
                        3)
							#Remember user how to deatach form screen
                            echo -e "Accessing Minecraft console..."
                            echo -e "-------------------------------------------------------------\nIMPORTANT!!!"
                            echo -e "Remember that in order to exit you need to press ctrl+a followed by d"
                            echo -e "-------------------------------------------------------------\nPress enter key to continue"
                            read
                            screen -r "$screen_name";;
                        4)
							backup_dir="$backup_dir/$(date +%Y-%m-%d--%H-%M-%S)" #Adding time to backup dir
                            mkdir -p "$backup_dir"
							echo -e "Starting backup, be patient...\nI will tell you once I have finished\n.\n..\n..."
                            

                            #Check if the backup has done correctly
                            if cp -rf "$minecraft_dir/"* "$backup_dir"
                            	then
                            	    touch "$backup_dir/00_Backup_OK"
                                    echo -e "Backup created correctly at $backup_dir"
                                else
                                    touch "$backup_dir/00_Backup_NO_OK"
                                    echo -e "\n.\n..\n...\nThere where errors while copying the files, please see errors above"
                             fi;;

						5)exit;;

                        *) echo "Please, type a number between 1 and 5";;
                esac
		echo -e "Press enter key to get back to the main menu"
		read
        done
else
        print_name
        echo -e "You need to be root in order to start MC-ADMIN"
        exit 1
fi
## Exit Codes
# 1 - Must be run as root
