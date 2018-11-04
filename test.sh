if [ $(grep -q 'Match Group sftpUsers' /etc/ssh/sshd_config) ] 
then
    echo 'yes'
else
    echo 'no'
fi