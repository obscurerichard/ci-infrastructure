#
## Author:: Wes Winham (<@weswinham>)
## Author:: Richard Bullington-McGuire (<@obscurerichard>)
## Cookbook Name:: ci
## Recipe:: default
##
## Copyright 2011, Wes Winham
## Copyright 2009-2010, Opscode, Inc.
## Copyright 2012, Blackstone Technology Group
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
package "xfsprogs" do
  action :install
end

directory node[:jenkins][:server][:home] do
  #owner node[:jenkins][:server][:user]
  #group node[:jenkins][:server][:group]
  recursive true
  action :create
end

# Adapted from https://github.com/opscode-cookbooks/database/blob/master/recipes/ebs_volume.rb
execute "mkfs.xfs #{ebs_vol_dev_mount}" do
  only_if "xfs_admin -l #{ebs_vol_dev_mount} 2>&1 | grep -qx 'xfs_admin: #{ebs_vol_dev_mount} is not a valid XFS filesystem (unexpected SB magic number 0x00000000)'"
end

mount node[:jenkins][:server][:home] do
  device node[:jenkins][:server][:ebs_device]
  options "rw noatime"
  fstype node[:jenkins][:server][:fstype]
  action [:enable, :mount]
  # Don't mount if this is already mounted. Is the needed?
  # not_if "cat /proc/mounts | grep " node[:jenkins][:server][:home]
end
