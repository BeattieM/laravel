#
# Cookbook Name:: laravel
# Recipe:: server
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


# Prepare Apache and Virt Host
web_app "laravel" do
  template "laravel.conf.erb"
  docroot "#{path}/public"
  server_name node['fqdn']
  server_aliases node['fqdn']
  enable true
end