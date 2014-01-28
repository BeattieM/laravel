#
# Cookbook Name:: laravel
# Recipe:: admin
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


# Publish admin assets if the admin directory already exists 
if ::File.directory?("#{project_path}/app/config/administrator")
	execute "Publish Admin Assets" do
		action :run
		command "cd #{project_path}; php artisan asset:publish frozennode/administrator"
	end


# Create the admin directory structure
else
	execute "Make Administrator Directory" do
		action :run
		command "cd #{project_path}/app/config; sudo mkdir administrator; cd administrator; sudo mkdir settings"
	end


	# Add admin site settings config
	template "#{project_path}/app/config/administrator/settings/site.php" do
		mode "0644"
	end


	# Publish Frozennode admin config
	execute "Publish Admin Config" do
		action :run
		command "cd #{project_path}; php artisan config:publish frozennode/administrator"
	end


	# Publish Frozennode admin assets
	execute "Publish Admin Assets" do
		action :run
		command "cd #{project_path}; php artisan asset:publish frozennode/administrator"
	end


	# Set base admin menu configuration
	template "#{project_path}/app/config/packages/frozennode/administrator/administrator.php" do
		mode "0644"
	end
end
