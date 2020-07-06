#!/bin/bash
backup_folder=/home/backups-mc/$(date +%Y-%m-%d--%H-%M-%S)
minecraft_folder=/home/minecraft
mkdir $backup_folder
echo -e "Starting backup, be patient...\nI will tell you once I have finished\n.\n..\n..."
cp -rf $minecraft_folder/* $backup_folder
if [ $? -eq 0 ]
  then
    touch $backup_folder/00_Backup_OK
    echo -e "Backup created correctly $backup_folder"
  else
    touch $backup_folder/00_Backup_NO_OK
    echo -e "It looks like the backup could not finish correctly"
fi
echo -e "Press any key to exit"
read
exit
