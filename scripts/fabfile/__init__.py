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
env.colors = True
env.format = True

env.roledefs = {
    'main' : ['biblio', 'etl', 'demo'],
    'rmm' : ['modules', 'femto', 'gsmr',
      'urd2',
      'smartmetering', 'metersg1', 'screens',
      'sysnet',
      'urd31', 'lignepro', 'smarthome',
      'urd44',
      ],
    'sst' : ['sst'],
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
      with hide('stdout'):
        with expecting(prompts):
          erun('git pull')
      run('git submodule update --init')

@task
def create_user(alias):
  key_dir = '~/.ssh/keys'
  config_file = '~/.ssh/config'
  user = 'kevin'
  sudo('adduser {user}')
  sudo('visudo')
  with settings(warn_only=True):
    if run('git --version').failed:
      sudo('apt-get install git-core')
  local('ssh-keygen -f %s' % (os.path.join(key_dir), alias))
  local("""echo "
Host {alias}
  Hostname {env.host_string}
  User {user}
  IdentityFile {key_dir}/{alias}
" >> {config_file}""")
  run('mkdir /home/{user}/.ssh')
  put('{key_dir}/{alias}.pub', '/home/{user}/.ssh/authorized_keys')
  password = ask_password()
  prompts = list()
  prompts += expect('Password', password)
  with cd('~'):
    with prefix('export https_proxy=http://10.66.243.130:8080/'):
      with settings(
          hide('stdout'),
          expecting(prompts)):
        erun('git clone https://wezegege@bitbucket.org/wezegege/config.git')
      run('git submodule update --init', dir='~/config')
    for conf in ('bashrc', 'vimrc', 'vim', 'inputrc', 'commonrc', 'gitconfig'):
      with settings(warn_only=True):
        if run('ls .{conf}').failed:
          run('mv .{conf} .{conf}.old')
      run('ln -s config/{conf} .{conf}')

