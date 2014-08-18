#
# Cookbook Name:: airplay_server
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{git libao-dev libssl-dev libcrypt-openssl-rsa-perl libio-socket-inet6-perl libwww-perl avahi-utils libmodule-build-perl libavahi-client-dev libasound2-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

git "/home/vagrant/netsdp" do
  user "vagrant"
  repository "git://github.com/njh/perl-net-sdp.git"
  reference "master"
  action :checkout
end

bash "install_netsdp" do
  not_if 'which perl-net-sdp'
  environment "HOME" => '/home/vagrant'
  code <<-EOC
    cd /home/vagrant/netsdp
    perl Build.PL
    sudo ./Build
    sudo ./Build test
    sudo ./Build install
    cd ..
  EOC
end

git "/home/vagrant/shairport" do
  user "vagrant"
  repository "https://github.com/hendrikw82/shairport"
  reference "master"
  action :checkout
end

bash "make_airport" do
  not_if 'ls /home/vagrant/shairport/hairtunes'
  environment "HOME" => '/home/vagrant'
  code <<-EOC
    cd /home/vagrant/shairport
    sudo make 
  EOC
end
