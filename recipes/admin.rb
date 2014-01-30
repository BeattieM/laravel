#
# Cookbook Name:: laravel
# Recipe:: admin
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


# Check if composer has been installed globally
if node['composer']['install_globally']
  composer_command = "composer"
else
  composer_command = "php composer"
end


# Publish admin assets if the admin directory already exists 
if ::File.directory?("#{path}/app/config/administrator")
	execute "Publish Admin Assets" do
		action :run
		command "cd #{path}; php artisan asset:publish frozennode/administrator"
	end


# Create the admin directory structure
else
	execute "Make Administrator Directory" do
		action :run
		command "cd #{path}/app/config; sudo mkdir administrator; cd administrator; sudo mkdir settings"
	end

	# Create the composer config files
	# This will replace any existing file so that the admin module can be included
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
    command "cd #{path}; #{composer_command} update"
  end

	# Publish Frozennode admin config
	execute "Publish Admin Config" do
		action :run
		command "cd #{path}; php artisan config:publish frozennode/administrator"
	end


	# Publish Frozennode admin assets
	execute "Publish Admin Assets" do
		action :run
		command "cd #{path}; php artisan asset:publish frozennode/administrator"
	end

	# Add admin site settings config
	template "#{path}/app/config/administrator/settings/site.php" do
		mode "0644"
	end


	# Set base admin menu configuration
	template "#{path}/app/config/packages/frozennode/administrator/administrator.php" do
		mode "0644"
	end
end
