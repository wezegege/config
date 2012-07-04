#!/usr/bin/env python
# -*- coding: utf-8 -*-

@runs_once
def ask_password():
  return getpass.getpass('Git repo password: ')

@task
@hosts('localhost')
def all():
  password = ask_password()
  execute(allconfig, password=password)

@roles('valid', 'rmm', 'main', 'ldap', 'shz')
@parallel
def allconfig(password):
  config(password)

@task
def update(password=None):
  if not password:
    password = ask_password()
  prompts = list()
  prompts += expect('Password', password)
  with cd('~/config'):
    with prefix('export https_proxy=http://10.66.243.130:8080/'):
      with hide('stdout'):
        with expecting(prompts):
          erun('git pull')
      run('git submodule update --init')
