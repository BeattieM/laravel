#
# Cookbook Name:: laravel
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

default['laravel']['project_root'] = "/srv"

default['laravel']['db']['name'] = "laraveldb"
default['laravel']['db']['host'] = "localhost"
default['laravel']['db']['user'] = "root"
default['laravel']['db']['pass'] = "#{node['mysql']['server_root_password']}"