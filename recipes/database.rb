#
# Cookbook Name:: laravel
# Recipe:: database
#
# Copyright 2014, Michael Beattie
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
project_dir = "#{node['laravel']['project_root']}/#{node['laravel']['project_name']}"

include_recipe "mysql::client"

def is_local_host?(host)
  if host == 'localhost' || host == '127.0.0.1' || host == '::1'
    true
  else
    require 'socket'
    require 'resolv'
    Socket.ip_address_list.map { |a| a.ip_address }.include? Resolv.getaddress host
  end
end

db = node['laravel']['db']

template "#{project_dir}/app/config/database.php" do
  mode "0644"
end

if is_local_host? db['host']
  execute "Create Laravel Database" do
    action :run
    command "mysql --user='root' --password='' --execute='CREATE DATABASE IF NOT EXISTS #{db['name']}'"
    notifies :run, "execute[Run Initial Migration]"
  end

  execute "Run Initial Migration" do
    action :nothing
    command "cd #{project_dir}; php artisan migrate"
  end

  include_recipe "mysql::server"
end