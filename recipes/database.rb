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

# Laravel Database Node
db = node['laravel']['db']

include_recipe "mysql::client"
::Chef::Recipe.send(:include, Laravel::Helpers)


# Check if this is a development machine
if is_local_host? db['host']
  include_recipe "mysql::server"

  # Create the database is it does not already exist
  execute "Create Laravel Database If Not Exists" do
    action :run
    command "mysql --user='#{db['user']}' --password='#{db['password']}' --execute='CREATE DATABASE IF NOT EXISTS #{db['name']}'"
  end
end


# Create the database config file if one does not already exist
# This is assumed to be during new project creation
unless ::File.exist?("#{project_dir}/app/config/database.php")
  template "#{project_dir}/app/config/database.php" do
    mode "0644"
  end

  # Create the migration table in the database
  execute "Run Initial Migration" do
    action :run
    command "cd #{project_dir}; php artisan migrate"
  end
end
