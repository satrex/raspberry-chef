require 'spec_helper'

describe package('git') do
  it { should be_installed }
end

describe file('/home/vagrant/shairport/shairport.pl') do
  it { should be_file }
end

describe "AirPi Daemon" do

    it "has a running service of dbus-daemon" do
            expect(service("dbus-daemon")).to be_running
    end

    it "has a running service of shairport" do
            expect(service("shairport")).to be_running
    end
end
