#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fabric.api import task, run, sudo, local, put, env, hosts, execute
from fabric.context_managers import cd
import getpass
import os
import os.path

@task
def all():
  execute(make)
  execute(install)
  execute(upload)

@task
@hosts('localhost')
def make():
  workspace = '~/workspace/python/ldapsync/packaging'
  with cd(workspace):
    run('svn2deb ldap-sync.conf')

@task
@parallel
def restart():
  daemon = '/etc/init.d/ldap-sync'
  sudo('%s restart' % daemon)

@task
@parallel
def update():
  install_dir = '/usr/share/LdapSync'
  with cd(install_dir):
    sudo('svn update')
  ldapsync_restart()

@task
@parallel
def install():
  dpkg_dir = '/var/cache/pbuilder/result'
  tmp_dir = '/tmp'
  deb_file = next((item for item in os.listdir(dpkg_dir) if item.endswith('.deb')))
  put(os.path.join(dpkg_dir, deb_file), tmp_dir)
  with cd(tmp_dir):
    sudo('dpkg -i %s' % deb_file)
    run('rm %s' % deb_file)

@task
@hosts('socle5')
def upload():
  run('~/ldapsync.sh')
