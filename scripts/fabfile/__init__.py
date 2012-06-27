#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fabric.api import run, sudo, local, put, get, env, settings, hosts, parallel, task
from fabric.context_managers import cd, prefix, hide
from fabric.decorators import runs_once
from ilogue.fexpect import expect, expecting, run as erun, sudo as esudo
import getpass
import os
import os.path

import ldapsync
import db

env.use_ssh_config = True

env.roledefs = {
    'main' : ['biblio', 'etl', 'demo'],
    'rmm' : ['modules', 'femto', 'gsmr',
      'urd2',
      'smartmetering', 'metersg1', 'screens',
      'sysnet',
      'urd31', 'lignepro', 'smarthome',
      'urd44',
      ],
    'sst' : ['forge-sst.sst.sagem'],
    'shz' : ['shenzhen'],
    'valid' : ['valid2', 'valid8', 'valid10', 'valid11', 'valid13',
      'valid18', 'testperf2'],
    'ldap' : ['ldapprod', 'backup'],
    }

@runs_once
def ask_password():
  return getpass.getpass('Git repo password: ')

@task
def config():
  password = ask_password()
  prompts = list()
  prompts += expect('Password', password)
  with cd('~/config'):
    with prefix('export https_proxy=http://10.66.243.130:8080/'):
      #with hide('stdout'):
      with expecting(prompts):
        erun('git pull')

@task
def create_user(alias):
  key_dir = '~/.ssh/keys'
  config_file = '~/.ssh/config'
  user = 'kevin'
  sudo('adduser %s' % user)
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

