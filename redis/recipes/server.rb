#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2010, Example Com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

pkg = "redis-server_1.2.6-1_i386.deb"

remote_file "/tmp/#{pkg}" do
  source "http://ftp.us.debian.org/debian/pool/main/r/redis/#{pkg}"
end

package pkg do
  provider Chef::Provider::Package::Dpkg
  source "/tmp/#{pkg}"
  only_if do File.exist?("/tmp/#{pkg}") && !`aptitude show redis-server` =~ /State: installed/ end
end

service "redis" do
  service_name "redis-server"
  supports :restart => true, "force-reload" => true
  action :enable
end

template "/etc/redis/redis.conf" do
  source "redis.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "redis"), :immediately
end
