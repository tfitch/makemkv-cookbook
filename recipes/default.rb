#
# Cookbook Name:: makemkv
# Recipe:: default
#
# Copyright (c) 2015 Tyler Fitch, All Rights Reserved.

case node['platform']
when 'ubuntu'
  include_recipe 'makemkv::ubuntu'
else
  PUTS 'UNSUPPORTED PLATFORM'
end

# basically following the instructions from http://www.makemkv.com/forum2/viewtopic.php?f=3&t=224 as of Oct 05, 2015

remote_file '/tmp/makemkv-bin-1.9.7.tar.gz' do
  source 'http://www.makemkv.com/download/makemkv-bin-1.9.7.tar.gz'
end

remote_file '/tmp/makemkv-oss-1.9.7.tar.gz' do
  source 'http://www.makemkv.com/download/makemkv-oss-1.9.7.tar.gz'
end

execute 'extract makemkv-bin' do
  command 'tar xvzf makemkv-bin-1.9.7.tar.gz'
  cwd '/tmp'
  not_if { File.exists?('/tmp/makemkv-bin-1.9.7/Makefile') }
end

execute 'extract makemkv-oss' do
  command 'tar xvzf makemkv-oss-1.9.7.tar.gz'
  cwd '/tmp'
  not_if { File.exists?('/tmp/makemkv-oss-1.9.7/configure') }
end

# FYI:  We're accepting the MakeMKV EULA for you with that funky line that does `make >/dev/null < <(echo yes).
bash 'compile makemkv' do
  cwd '/tmp'
  code <<-EOH
    cd ./makemkv-oss-1.9.7
    ./configure
    make
    make install
    cd ../makemkv-bin-1.9.7
    make >/dev/null < <(echo yes)
    make install
  EOH
  not_if { File.exists?('/usr/bin/makemkv') }
end
