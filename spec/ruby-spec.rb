require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook "playbooks/ruby-playbook.yml", { copy_configru: true, ruby_version: "2.3.0" }
  end
end

describe "Nginx config should be valid" do
  include_examples "nginx::config"
end

describe command(". /etc/profile.d/rbenv.sh && ruby -e \"puts 'ruby installed'\"") do
  its(:stdout) { should eq "ruby installed\n" }

  its(:exit_status) { should eq 0 }
end

describe command(". /etc/profile.d/rbenv.sh && ruby --version") do
  its(:stdout) { should match /^ruby 2\.3\.0/ }

  its(:exit_status) { should eq 0 }
end

describe command(". /etc/profile.d/rbenv.sh && env") do
  its(:stdout) { should match /^RAILS_ENV=development$/ }
end

describe command(". /etc/profile.d/rbenv.sh && gem list") do
  its(:stdout) { should match /^bundler/ }
  its(:stdout) { should match /^rack/ }
  its(:stdout) { should match /^rake/ }
  its(:stdout) { should match /^sass/ }
end

describe command('printf "GET / HTTP/1.1\nHost: ruby-test.dev\n\n" | nc 127.0.0.1 80') do
  its(:stdout) { should match /^+HTTP\/1\.1 200 OK$/ }

  its(:stdout) { should match /Phusion Passenger is serving Ruby 2\.3\.0 code on ruby-test\.dev/ }
end