#
# Cookbook Name:: sphinx
# Recipe:: default
#
# Copyright 2010, 37signals
#
# All rights reserved - Do Not Redistribute
#

include_recipe "god"

script "install sphinx" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  
  code <<-EOH
wget http://www.sphinxsearch.com/downloads/sphinx-#{node[:sphinx][:version]}.tar.gz && \
tar xfz sphinx-#{node[:sphinx][:version]}.tar.gz && \
cd sphinx-#{node[:sphinx][:version]} && \
./configure --prefix=/usr/local && \
make install
rm -rf /tmp/sphinx-#{node[:sphinx][:version]}.tar.gz /tmp/sphinx-#{node[:sphinx][:version]}
EOH
  not_if { File.exist?("/usr/local/bin/search") && `/usr/local/bin/search`.match(/Sphinx #{node[:sphinx][:version]}/) }
end

unless node[:railsapp][:sphinx] == true
  name = node[:railsapp][:name]
  
  directory "/srv/#{name}/shared/sphinx" do
    action :create
    recursive true
    owner "railsapp"
    group "railsapp"
    mode "0755"
  end
  
  god_monitor "sphinx" do
    config "sphinx.god.erb"
  end

  logrotate "sphinx_#{name}" do
    restart_command "god restart sphinx"
    files "/srv/#{name}/shared/log/*.log"
    frequency "daily"
  end
end
