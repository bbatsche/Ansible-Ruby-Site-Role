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
