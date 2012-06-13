#
# Cookbook Name:: ci-infrastructure
# Recipe:: default
#
# Copyright (c) 2012, PolicyStat LLC.
# Copyright (c) 2012, Blackstone Technology Group
#
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
# 
# Neither the name of PolicyStat LLC. nor the names of its contributors may be used
# to endorse or promote products derived from this software without specific
# prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

include_recipe "apt"
include_recipe "git"

bash "git-submodules" do
  cwd "/vagrant"
  user "vagrant"
  group "vagrant"
  code <<-EOH
    git submodule init
    git submodule update
EOH
end

include_recipe "python"
include_recipe "python::pip"
include_recipe "python::virtualenv"

@ves = "/home/vagrant/.virtualenvs"
@ve = "#{@ves}/ci-infrastructure"

directory @ves do
  owner "vagrant"
  group "vagrant"
  action :create
end

python_virtualenv @ve do
  owner "vagrant"
  group "vagrant"
  action :create
end


bash "pip-install-r" do
  cwd "/home/vagrant"
  user "vagrant"
  code <<-EOH
    source /home/vagrant/.virtualenvs/ci-infrastructure/bin/activate
    pip install -r /vagrant/requirements.txt
  EOH
end

#python_pip "foo" do
#  action :install
#end
