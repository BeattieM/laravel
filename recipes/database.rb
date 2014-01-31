#
# Cookbook Name:: laravel
# Recipe:: database
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

# Laravel Database Node
db = node['laravel']['db']

include_recipe "mysql::client"
::Chef::Recipe.send(:include, Laravel::Helpers)
path = project_path


# Check if this is a development machine
if is_local_host? db['host']
  include_recipe "mysql::server"

  # Create the database is it does not already exist
  execute "Create Laravel Database If Not Exists" do
    action :run
    command "mysql --user='#{db['user']}' --password='#{db['pass']}' --execute='CREATE DATABASE IF NOT EXISTS #{db['name']}'"
  end
end


# Create the database config file if one does not already exist
# This is assumed to be during new project creation
unless ::File.exist?("#{path}/app/config/database.php")
  template "#{path}/app/config/database.php" do
    mode "0644"
  end

  # Create the migration table in the database
  execute "Run Initial Migration" do
    action :run
    command "cd #{path}; php artisan migrate"
  end
end
