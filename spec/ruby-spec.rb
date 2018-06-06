require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    @ruby_version = "2.4.3"

    AnsibleHelper.playbook("playbooks/ruby-playbook.yml", ENV["TARGET_HOST"], {
      copy_configru: true,
      ruby_version: @ruby_version
    })

    set :env, :RBENV_VERSION => @ruby_version
    set :docker_container_exec_options, { :Env => ["RBENV_VERSION=#{@ruby_version}"] }
  end

  config.before :each do
    @ruby_version = "2.4.3"
  end
end

describe "Nginx" do
  include_examples "nginx"
end

describe "Rbenv" do
  let(:subject) { command "rbenv --version" }

  it "is installed" do
    expect(subject.stdout).to match /^rbenv \d+\.\d+\.\d+/
  end

  # Can't use "no errors"; docker thinks this should be interactive/login shell
  it "has no errors" do
    expect(subject.exit_status).to eq 0
  end
end

context "CLI" do
  describe "Ruby runtime" do
    let(:subject) { command %Q{ruby -e "puts 'ruby is installed'"} }

    it "executes Ruby code" do
      expect(subject.stdout).to match /^ruby is installed$/
    end

    it "has no errors" do
      expect(subject.exit_status).to eq 0
    end
  end

  describe "Ruby version" do
    let(:subject) { command "ruby --version" }

    it "is the correct version" do
      expect(subject.stdout).to match /^ruby #{Regexp.quote(@ruby_version)}/
    end

    it "has no errors" do
      expect(subject.exit_status).to eq 0
    end
  end

  describe "Environment variables" do
    let(:subject) { command "env" }

    it "includes the Rails environment" do
      expect(subject.stdout).to match /^RAILS_ENV=development$/
    end
  end

  describe "Default gems" do
    let(:subject) { command "gem list" }

    it "includes bundler" do
      expect(subject.stdout).to match /^bundler/
    end
    it "includes rack" do
      expect(subject.stdout).to match /^rack/
    end
    it "includes rake" do
      expect(subject.stdout).to match /^rake/
    end
    it "includes sass" do
      expect(subject.stdout).to match /^sass/
    end
  end
end

describe "Web service" do
  let(:subject) { command "curl -i ruby-test.dev" }

  include_examples "curl request", "200"

  include_examples "curl request html"

  it "processed Ruby code" do
    expect(subject.stdout).to match /Phusion Passenger is serving Ruby #{Regexp.quote(@ruby_version)} code on ruby-test\.dev/
  end
end
