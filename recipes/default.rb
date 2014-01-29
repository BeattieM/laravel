#
# Cookbook Name:: laravel
# Recipe:: default
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

# Define required user defenitions
missing_attrs = %w[project_name].select { |attr| node['laravel'][attr].nil? }.map { |attr| %Q{node['laravel']['#{attr}']} }


# Fail Chef if required attributes are missing
unless missing_attrs.empty?
  Chef::Application.fatal! "You must set #{missing_attrs.join(', ')}." \
  " For more information, see https://github.com/BeattieM/laravel#attributes"
end


include_recipe "php"


# Laravel requires mycrypt
unless File.exists?("#{node['php']['ext_conf_dir']}/mcrypt.ini")
	include_recipe "php-mcrypt"
end


include_recipe "mysql"
include_recipe "apache2"
include_recipe "composer"
include_recipe "laravel::laravel"
