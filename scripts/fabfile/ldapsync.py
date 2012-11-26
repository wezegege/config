#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fabric.api import task, run, sudo, local, put, env, hosts, execute, parallel, settings
from ilogue.fexpect import expect, expecting, sudo as esudo
from fabric.context_managers import cd, hide
from fabric.decorators import runs_once
import getpass
import os
import os.path

@task
def all():
  execute(make)
  execute(install)
  execute(upload)

@runs_once
def svn_password():
  return getpass.getpass('SVN password : ')

@task
@hosts('localhost')
def make():
  workspace = '~/workspace/python/ldapsync/packaging'
  with cd(workspace):
    run('svn2deb ldap-sync.conf')

@task
def restart():
  daemon = '/etc/init.d/ldap-sync'
  sudo('%s restart' % daemon)

@task
def status():
  daemon = '/etc/init.d/ldap-sync'
  with settings(warn_only=True):
    sudo('%s status' % daemon)
    sudo('tail /var/log/ldap-sync.log')

@task
def update():
  password = svn_password()
  install_dir = '/usr/share/LdapSync'
  prompts = list()
  prompts += expect("Password for", password)
  prompts += expect('Store password unencrypted', 'no')
  with settings(
      cd(install_dir),
      expecting(prompts),
      hide('stdout'),
      ):
    esudo('svn update --username g179076')
  restart()

@task
def install():
  dpkg_dir = '/var/cache/pbuilder/result'
  tmp_dir = '/tmp'
  deb_file = next((item for item in os.listdir(dpkg_dir) if item.endswith('.deb')))
  put(os.path.join(dpkg_dir, deb_file), tmp_dir)
  with cd(tmp_dir):
    sudo('dpkg -i %s' % deb_file)
    run('rm %s' % deb_file)

@task
@hosts('repo-forge')
def upload():
  run('~/ldap_sync.sh')
