#
# Cookbook Name:: laravel
# Recipe:: laravel
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

::Chef::Recipe.send(:include, Laravel::Helpers)


# Notify the user if they are creating a new project
# We do this because creating a new project takes a while
unless ::File.directory?("#{project_dir}")
	log "Creating #{node['laravel']['project_name']} ..."
end


# Create a new project if it does not already exist
execute "Create Laravel Project" do
  action :run

  # Check if composer has been installed globally
  if node['composer']['install_globally']
  	command "composer create-project laravel/laravel #{project_dir} --prefer-dist"
  else
  	command "php composer create-project laravel/laravel #{project_dir} --prefer-dist"
  end
  not_if {::File.directory?("#{project_dir}")}
  notifies :run, "execute[Chmod app/storage directory]"
end


# Laravel requires this directory to have write access by the web server
execute "Chmod app/storage directory" do
  action :nothing
  command "sudo chmod -R 755 #{project_dir}/app/storage"
end


# Create the composer config files if they do not already exist
# Generates a new Laravel encryption key
# This is assumed to be during new project creation
unless ::File.exist?("#{project_dir}/composer.json")
  template "#{project_dir}/composer.json" do
     variables(
      :recipes => node['recipes']
    )
    mode "0644"
  end


  template "#{project_dir}/app/config/app.php" do
    variables(
      :recipes => node['recipes']
    )
    mode "0644"
  end


  # Generate Laravel encryption key
  execute "Generate Laravel Encryption Key" do
    action :run
    command "cd #{project_dir}; php artisan key:generate"
  end
end


# Update composer dependencies
execute "Install Composer Packages" do
  action :run
  command "cd #{project_dir}; composer update"
end


include_recipe "laravel::database"
include_recipe "laravel::server"
