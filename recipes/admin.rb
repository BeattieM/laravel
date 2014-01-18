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

project_dir = "#{node['laravel']['project_root']}/#{node['laravel']['project_name']}"


execute "Publish Admin Config" do
	action :run
	command "php artisan config:publish frozennode/administrator"
	not_if {::File.exists?("#{project_dir}/app/config/packages/frozennode/administrator/administrator.php")}
end


execute "Publish Admin Assets" do
	action :run
	command "php artisan asset:publish frozennode/administrator"
end