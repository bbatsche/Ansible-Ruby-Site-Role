Ansible Ruby Site Role
======================

[![Build Status](https://travis-ci.org/bbatsche/Ansible-Ruby-Site-Role.svg?branch=master)](https://travis-ci.org/bbatsche/Ansible-Ruby-Site-Role)

This role will install Rbenv and use that to install a given version of Ruby. It will create an Nginx site that runs ruby through Phusion Passenger.

Requirements
------------

Installing Rbenv requires Git to be installed on the server. But of course, you already did that, right?

This role takes advantage of Linux filesystem ACLs and a group called "web-admin" for granting access to particular directories. You can either configure those steps manually or install the [`bbatsche.Base`](https://galaxy.ansible.com/bbatsche/Base/) role.

Role Variables
--------------

- `domain` &mdash; Site domain to be created.
- `ruby_version` - Version of Ruby to install. Default is "2.3.0"
- `rbenv_version` - Version of Rbenv to install. Default is "v1.0.0"
- `ruby_build_version` - Version of ruby-build plugin to install. Default is "v20160130"
- `default_gems_version` - Version of default-gems plugin to install. Default is a Git SHA: "4f68eae"
- `rbenv_vars_version` - Version of rbenv-vars plugin to install Default is "v1.2.0"
- `binstubs_version` - Version of binstubs plugin to install. Default is "v1.4"
- `copy_configru` - Whether to copy a stub config.ru file to the site, useful for testing. Default is no
- `http_root` &mdash; Directory all site directories will be created under. Default is "/srv/http".
- `rbenv_root` &mdash; Directory to install Rbenv and its support files. Default is "/usr/local/rbenv"

Dependencies
------------

This role depends on bbatsche.Nginx. You must install that role first using:

```bash
ansible-galaxy install bbatsche.Nginx
```

Example Playbook
----------------

```yml
- hosts: servers
  roles:
     - { role: bbatsche.Ruby, domain: my-node-site.dev }
```

License
-------

MIT

Testing
-------

Included with this role is a set of specs for testing each task individually or as a whole. To run these tests you will first need to have [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) installed. The spec files are written using [Serverspec](http://serverspec.org/) so you will need Ruby and [Bundler](http://bundler.io/). _**Note:** To keep things nicely encapsulated, everything is run through `rake`, including Vagrant itself. Because of this, your version of bundler must match Vagrant's version requirements. As of this writing (Vagrant version 1.8.1) that means your version of bundler must be between 1.5.2 and 1.10.6._

To run the full suite of specs:

```bash
$ gem install bundler -v 1.10.6
$ bundle install
$ rake
```

To see the available rake tasks (and specs):

```bash
$ rake -T
```

There are several rake tasks for interacting with the test environment, including:

- `rake vagrant:up` &mdash; Boot the test environment (_**Note:** This will **not** run any provisioning tasks._)
- `rake vagrant:provision` &mdash; Provision the test environment
- `rake vagrant:destroy` &mdash; Destroy the test environment
- `rake vagrant[cmd]` &mdash; Run some arbitrary Vagrant command in the test environment. For example, to log in to the test environment run: `rake vagrant[ssh]`

These specs are **not** meant to test for idempotence. They are meant to check that the specified tasks perform their expected steps. Idempotency can be tested independently as a form of integration testing.
