#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fabric.api import run, sudo, local, put, get, env, settings, hosts, parallel, task
from fabric.context_managers import cd
import getpass
import os
import os.path

import ldapsync

env.use_ssh_config = True

@task
@parallel
def config():
  password = getpass.getpass('Git repo password: ')
  with cd('~'):
    run('echo %s | git pull' % password)

@task
def create_user(alias):
  key_dir = '~/.ssh/keys')
  config_file = '~/.ssh/config')
  user = 'kevin'
  password = getpass.getpass('User password: ')
  sudo('echo "%(password)s\\n%(password)s\\n\\n\\n\\n\\n" | adduser %(user)s' %
      {'password' : password, 'user' : user})
  sudo('visudo')
  with settings(warn_only=True):
    if not run('git --version'):
      sudo('apt-get install git-core')
  local('ssh-keygen -f %s' % (os.path.join(key_dir), alias))
  local('echo "\\nHost %s\\n    Hostname %s\\n    User %s\\n    IdentityFile %s" >> %s' %
      (alias, env.host_string, user, os.path.join(key_dir, alias), config_file))
  put('%s/%s.pub' % (key_dir, alias), '/home/%s/authorized_keys' % user)
  put('~/config/scripts/servset.sh', '/home/%s' % user)
  run('/home/%s/servset.sh' % user)

