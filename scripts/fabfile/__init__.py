#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fabric.api import run, sudo, local, put, get, env, settings, hosts, parallel, task, execute
from fabric.context_managers import cd, prefix, hide
from fabric.decorators import runs_once
import os
import os.path

import ldapsync, db, config

env.use_ssh_config = True
env.colors = True
env.format = True

env.roledefs = {
    'main' : ['biblio', 'etl', 'demo'],
    'rmm' : ['modules', 'femto',
      'urd2',
      'smartmetering', 'metersg1', 'screens',
      'sysnet',
      'urd31', 'lignepro', 'smarthome',
      'urd44',
      ],
    'sst' : ['sst'],
    'shz' : ['shenzhen'],
    'valid' : ['valid8', 'valid9', 'valid10', 'valid11',
      'valid13', 'valid18', 'testperf2'],
    'ldap' : ['ldapprod', 'backup'],
    }

@runs_once
def ask_password():
  return getpass.getpass('User password: ')

@task
def create_user(alias=None):
  if not alias:
    alias = env.host_string
  key_dir = '~/.ssh/keys'
  config_file = '~/.ssh/config'
  user = 'g179076'
  with settings(warn_only=True):
    if sudo('useradd -m -s /bin/bash -G sudo {0}'.format(user)):
      sudo('passwd {0}'.format(user))
  with settings(warn_only=True):
    if run('git --version').failed:
      sudo('apt-get install git-core')
  local('ssh-keygen -f {0}'.format(os.path.join(key_dir, alias)))

  home_folder = '/home/{0}'.format(user)
  with settings(warn_only=True):
    sudo('mkdir {0}/.ssh'.format(home_folder))
  put('{0}/{1}.pub'.format(key_dir, alias),
      '{0}/.ssh/authorized_keys'.format(home_folder), use_sudo=True)
  sudo('chown {0} {1}/.ssh/authorized_keys'.format(user, home_folder))

  # config module checking out
  with prefix('export https_proxy=http://10.66.243.130:8080/'):
    good = False
    with settings(warn_only=True):
      if sudo('ls {0}/config > /dev/null'.format(home_folder), user=user).succeeded:
        with cd('{0}/config'.format(home_folder)):
          good = bool(sudo('git pull', user=user))
    if not good:
      with cd(home_folder):
        sudo('git clone https://wezegege@bitbucket.org/wezegege/config.git', user=user)
    sudo('chown -R {0} {1}/config'.format(user, home_folder))
    with cd('{0}/config'.format(home_folder)):
      sudo('git submodule update --init', user=user)

  # symbolic links
  for conf in ('bashrc', 'vimrc', 'vim', 'inputrc', 'commonrc', 'gitconfig'):
    with settings(warn_only=True):
      if sudo('ls {0}/.{1} > /dev/null'.format(home_folder, conf), user=user).succeeded:
        sudo('mv {0}/.{1} {0}/.{1}.old'.format(home_folder, conf), user=user)
    sudo('ln -s {0}/config/{1} {0}/.{1}'.format(home_folder, conf), user=user)
  sudo('ln -sf {0}/config/uncommonrc/sagemcom {0}/.uncommonrc'.format(home_folder), user=user)
  with settings(warn_only=True):
    if sudo('ls {0}/.ssh > /dev/null'.format(home_folder), user=user).failed:
      sudo('mkdir {0}/.ssh'.format(home_folder), user=user)
  sudo('chown {0} {1}/.ssh'.format(user, home_folder))
  sudo('ln -sf {0}/config/ssh-config {0}/.ssh/config'.format(home_folder), user=user)

  # Add an entry in .ssh/config
  with settings(warn_only=True):
    if local('grep "Host {0}" {1} > /dev/null'.format(alias, config_file)).failed:
      local("""cat << EOF >> {0}

Host {1}
  Hostname {2}
  User {3}
  IdentityFile {4}/{1}
EOF
""".format(config_file, alias, env.host_string, user, key_dir))

