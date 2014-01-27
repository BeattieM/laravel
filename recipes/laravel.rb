# STILL NEED TO GENERATE ENCRYPTION KEY



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

project_dir = "#{node['laravel']['project_root']}/#{node['laravel']['project_name']}"

unless ::File.directory?("#{project_dir}")
	log "Creating #{node['laravel']['project_name']} ..."
end

execute "Create Laravel Project" do
  action :run
  if node['composer']['install_globally']
  	command "composer create-project laravel/laravel #{project_dir} --prefer-dist"
  else
  	command "php composer create-project laravel/laravel #{project_dir} --prefer-dist"
  end
  not_if {::File.directory?("#{project_dir}")}
  notifies :run, "execute[Chmod app/storage directory]"
end


execute "Chmod app/storage directory" do
  action :nothing
  command "sudo chmod -R 777 #{project_dir}/app/storage"
end


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


execute "Install Composer Packages" do
	action :run
	command "cd #{project_dir}; composer update"
end


include_recipe "laravel::database"
include_recipe "laravel::server"
