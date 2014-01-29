#
# Cookbook Name:: laravel
# Recipe:: laravel
#
# Copyright 2014, Michael Beattie
#
# Licensed under the MIT License.
# You may obtain a copy of the License at
#
#     http://opensource.org/licenses/MIT
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

::Chef::Recipe.send(:include, Laravel::Helpers)
path = project_path


# Notify the user if they are creating a new project
# We do this because creating a new project takes a while
unless ::File.directory?("#{path}")
  log "Creating #{node['laravel']['project_name']} ..."
end


# Create a new project if it does not already exist
execute "Create Laravel Project" do
  action :run

  # Check if composer has been installed globally
  if node['composer']['install_globally']
    command "composer create-project laravel/laravel #{path} --prefer-dist"
  else
    command "php composer create-project laravel/laravel #{path} --prefer-dist"
  end
  not_if {::File.directory?("#{path}")}
  notifies :run, "execute[Chmod app/storage directory]"
end


# Laravel requires this directory to have write access by the web server
execute "Chmod app/storage directory" do
  action :nothing
  command "sudo chmod -R 777 #{path}/app/storage"
end


# Check if the composer config files already exist
if ::File.exist?("#{path}/composer.json")

  # Update composer dependencies
  execute "Install Composer Packages" do
    action :run
    command "cd #{path}; composer update"
  end

# Create the composer config files if they do not already exist
# Generates a new Laravel encryption key
# This is assumed to be during new project creation  
else
  template "#{path}/composer.json" do
     variables(
      :recipes => node['recipes']
    )
    mode "0644"
  end

  template "#{path}/app/config/app.php" do
    variables(
      :recipes => node['recipes']
    )
    mode "0644"
  end

  # Update composer dependencies
  execute "Install Composer Packages" do
    action :run
    command "cd #{path}; composer update"
  end

  # Generate Laravel encryption key
  execute "Generate Laravel Encryption Key" do
    action :run
    command "cd #{path}; php artisan key:generate"
  end
end


include_recipe "laravel::database"
include_recipe "laravel::server"
