#
# Cookbook Name:: laravel
# Library:: helpers
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

module Laravel
  module Helpers

    # Define the project path
    def project_path
      "#{node['laravel']['project_root']}/#{node['laravel']['project_name']}"
    end


    # Check if this a development machine
    def is_local_host?(host)
      if host == 'localhost' || host == '127.0.0.1' || host == '::1'
        true
      else
        require 'socket'
        require 'resolv'
        Socket.ip_address_list.map { |a| a.ip_address }.include? Resolv.getaddress host
      end
    end
  end
end