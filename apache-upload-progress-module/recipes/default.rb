#
# Cookbook Name:: apache-upload-progress-module
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

git "/tmp/apache-upload-progress-module" do
  repository "http://github.com/drogus/apache-upload-progress-module.git"
  action :sync
end

execute "Install apache-upload-progress-module" do
  command "apxs2 -c -i mod_upload_progress.c"
  cwd "/tmp/apache-upload-progress-module"
  not_if { File.exists?("/usr/lib/apache2/modules/mod_upload_progress.so") }
end

template "#{node[:apache][:dir]}/mods-available/upload_progress.load" do
  source "upload_progress.load.erb"
  owner "root"
  group "root"
  mode 0755
end

template "#{node[:apache][:dir]}/mods-available/upload_progress.conf" do
  source "upload_progress.conf.erb"
  owner "root"
  group "root"
  mode 0755
end

apache_module "upload_progress"
