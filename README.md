Ansible Ruby Site Role
======================

[![Build Status](https://travis-ci.org/bbatsche/Ansible-Ruby-Site-Role.svg)](https://travis-ci.org/bbatsche/Ansible-Ruby-Site-Role)
[![License](https://img.shields.io/github/license/bbatsche/Ansible-Ruby-Site-Role.svg)](LICENSE)
[![Role Name](https://img.shields.io/ansible/role/7521.svg)](https://galaxy.ansible.com/bbatsche/Ruby)
[![Release Version](https://img.shields.io/github/tag/bbatsche/Ansible-Ruby-Site-Role.svg)](https://galaxy.ansible.com/bbatsche/Ruby)
[![Downloads](https://img.shields.io/ansible/role/d/7521.svg)](https://galaxy.ansible.com/bbatsche/Ruby)

This role will install Rbenv and use that to install a given version of Ruby. It will create an Nginx site that runs ruby through Phusion Passenger.

Requirements
------------

Installing Rbenv requires Git to be installed on the server. But of course, you already did that, right?

This role takes advantage of Linux filesystem ACLs and a group called "web-admin" for granting access to particular directories. You can either configure those steps manually or install the [`bbatsche.Base`](https://galaxy.ansible.com/bbatsche/Base/) role.

Role Variables
--------------

- `domain` &mdash; Site domain to be created.
- `ruby_version` &mdash; Version of Ruby to install. Default is "2.3.1"
- `rbenv_version` &mdash; Version of Rbenv to install. Default is "v1.0.0"
- `ruby_build_version` &mdash; Version of ruby-build plugin to install. Default is "v20160426"
- `default_gems_version` &mdash; Version of default-gems plugin to install. Default is a Git SHA: "4f68eae"
- `rbenv_vars_version` &mdash; Version of rbenv-vars plugin to install Default is "v1.2.0"
- `binstubs_version` &mdash; Version of binstubs plugin to install. Default is "v1.4"
- `copy_configru` &mdash; Whether to copy a stub config.ru file to the site, useful for testing. Default is no
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

Included with this role is a set of specs for testing each task individually or as a whole. To run these tests you will first need to have [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) installed. The spec files are written using [Serverspec](http://serverspec.org/) so you will need Ruby and [Bundler](http://bundler.io/).

To run the full suite of specs:

```bash
$ gem install bundler
$ bundle install
$ rake
```

The spec suite will target Ubuntu Trusty Tahr (14.04), Xenial Xerus (16.04), and Bionic Bever (18.04).

To see the available rake tasks (and specs):

```bash
$ rake -T
```

These specs are **not** meant to test for idempotence. They are meant to check that the specified tasks perform their expected steps. Idempotency is tested independently via integration testing.
