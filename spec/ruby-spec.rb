require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/ruby-playbook.yml", ENV["TARGET_HOST"], {
      copy_configru: true,
      ruby_version: "2.3.0"
    })
  end
end

describe "Nginx config should be valid" do
  include_examples "nginx"
end

describe command("ruby -e \"puts 'ruby installed'\"") do
  its(:stdout) { should eq "ruby installed\n" }

  its(:exit_status) { should eq 0 }
end

describe command("ruby --version") do
  its(:stdout) { should match /^ruby 2\.3\.0/ }

  its(:exit_status) { should eq 0 }
end

describe command("env") do
  its(:stdout) { should match /^RAILS_ENV=development$/ }
end

describe command("gem list") do
  its(:stdout) { should match /^bundler/ }
  its(:stdout) { should match /^rack/ }
  its(:stdout) { should match /^rake/ }
  its(:stdout) { should match /^sass/ }
end

describe command('curl -i ruby-test.dev') do
  its(:stdout) { should match /^HTTP\/1\.1 200 OK$/ }

  its(:stdout) { should match /Phusion Passenger is serving Ruby 2\.3\.0 code on ruby-test\.dev/ }
end
