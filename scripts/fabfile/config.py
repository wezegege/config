#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fabric.api import run, task, execute, parallel
from fabric.context_managers import cd, prefix, hide, settings
from ilogue.fexpect import expect, expecting, run as erun, sudo as esudo
from fabric.decorators import runs_once, hosts, roles
import getpass

@runs_once
def ask_password():
  return getpass.getpass('Git repo password: ')

@task
@hosts('localhost')
def all():
  ask_password()
  execute(allconfig)

@roles('valid', 'rmm', 'main', 'ldap', 'shz')
@parallel
def allconfig():
  update()

@task
def update():
  password = ask_password()
  prompts = list()
  prompts += expect('Password', password)
  with settings(
      cd('~/config'),
      prefix('export https_proxy=http://10.66.243.130:8080/')
      ):
    with settings(
        hide('stdout'),
        expecting(prompts)
        ):
      erun('git pull')
    run('git submodule update --init')
