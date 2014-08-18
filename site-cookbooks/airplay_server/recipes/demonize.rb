bash "demonize" do
  not_if 'ls /etc/init.d/shairport'
  code <<-EOC
    initfile=/home/vagrant/shairport/shairport.init.sample
    daemonfile=/etc/init.d/shairport
    cp $initfile $daemonfile 
    sed -i 's/NAME=.*/NAME=AirPi/g' $daemonfile
    sed -i 's;DAEMON=.*;DAEMON="/home/vagrant/shairport/shairport.pl";g' $daemonfile 
    sed -i 's:DAEMON_ARGS=.*:DAEMON_ARGS="-w $PIDFILE -a AirPi":g' $daemonfile 
    chmod a+x $daemonfile
    update-rc.d shairport defaults
  EOC
end

cookbook_file "/root/shairport-watchdog.sh" do
  mode 00644
end

bash "set_watchdog" do
  not_if 'grep -c -F "* * * * * root /bin/sh /root/shairport-watchdog.sh > /dev/null"'
  code <<-EOC
    sudo bash -c 'echo "* * * * * root /bin/sh /root/shairport-watchdog.sh > /dev/null" >> /etc/crontab'
  EOC
end
