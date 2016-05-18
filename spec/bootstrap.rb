require "serverspec"
require_relative "lib/ansible_helper"

if ENV.has_key?("CONTINUOUS_INTEGRATION") && ENV["CONTINUOUS_INTEGRATION"] == "true"
  set :backend, :exec
else
  options = AnsibleHelper.instance.sshOptions

  set :backend, :ssh

  set :host,        options[:host_name]
  set :ssh_options, options
end


# Disable sudo
set :disable_sudo, true

# Set environment variables
set :env, :RBENV_VERSION => "2.3.0"

set :login_shell, true

# Set PATH
set :path, '/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:$PATH'

shared_examples "nginx::config" do
  describe command("nginx -t") do
    let(:disable_sudo) { false }
    # stderr?? Wtf nginx.
    its(:stderr) { should match /configuration file \/etc\/nginx\/nginx\.conf syntax is ok/ }
    its(:stderr) { should match /configuration file \/etc\/nginx\/nginx\.conf test is successful/ }

    its(:exit_status) { should eq 0 }
  end
end
