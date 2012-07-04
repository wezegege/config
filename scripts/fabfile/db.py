#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fabric.api import task, run, get, local, env, sudo
from ilogue.fexpect import expect, expecting, run as erun, sudo as esudo, open_shell as eopen_shell
from fabric.context_managers import settings
import os
import os.path
from datetime import datetime

dump_repo = os.path.expanduser('~/workspace/sql')
prefixes = {
    'gforge' : 'gf',
    'bugzilla' : 'bz',
    'wikidb' : 'wk',
    'vulcain' : 'vl',
    }

def credentials(database, user=None, password=None):
  user = user if user else 'root' if env.host_string == 'localhost' else \
      'wikiuser' if database =='wikidb' else database
  if not password:
    if database == 'gforge':
      gforge_conf = '/etc/gforge/gforge.conf'
      password = sudo('grep db_password %s | sed "s/[^=]*=//"' % gforge_conf)
    elif database == 'wikidb':
      password = 'wikipass'
    else:
      password = database
  return user, password

@task
def connect(database, user=None, password=None):
  if not (user and password):
    user, password = credentials(database, user, password)
  prompts = list()
  prompts += expect('Password', password)
  with expecting(prompts):
    eopen_shell('psql -U %s -h localhost %s' % (user, database))

@task
def getdump(database, user=None, password=None):
  remote_dump = '~/%s.pgdump' % database
  dump(database, user, password)
  load(database, remote_dump)
  run('rm %s' % remote_dump)

@task
def dump(database, user=None, password=None):
  if not (user and password):
    user, password = credentials(database, user, password)
  remote_dump = '~/%s.pgdump' % database
  prompts = list()
  prompts += expect('Password', password)
  with expecting(prompts):
    erun('pg_dump -Fc -U %s -h localhost %s > %s' % (user, database, remote_dump))

@task
def load(database, dump=None):
  global dump_repo, prefixes
  if not dump:
    dump = '/backup_*/var_lib/forgedump/%s.pgdump' % database
  prefix = prefixes[database]
  alias = env.host_string
  toremove = (item for item in os.listdir(dump_repo) \
      if item.startswith('%s%s' % (prefix, alias)))
  for item in toremove:
    os.rm(item)
  now = datetime.now().strftime('%Y%m%d-%H%M%S')
  get(dump, os.path.join(dump_repo, '%s%s_%s.pgdump' % (prefix, alias, now)))

@task
def restore(database, alias=None):
  global dump_repo, prefixes
  prefix = prefixes[database]
  if not alias:
    alias = env.host_string
  dbname = '%s%s' % (prefix, alias)
  with settings(warn_only=True):
    if not local('psql -U root -h localhost -l | grep %s' % dbname).return_code:
      local('dropdb -U root -h localhost %s' % dbname)
  local('createdb -U root -h localhost %s -T template0 -E "UTF8"' % dbname)
  dump_file = next((item for item in os.listdir(dump_repo) if item.startswith(dbname)))
  with settings(warn_only=True):
    local('pg_restore -U root -h localhost -d %s %s' %
        (dbname, os.path.join(dump_repo, dump_file)))
