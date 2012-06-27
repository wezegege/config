#!/usr/bin/env python
# -*- coding: utf-8 -*-

from fabric.api import task, run, get, local
dump_repo = '~/workspace/sql'

@task
def dump_gforge():
  global dump_repo
  gforge_conf = '/etc/gforge/gforge.cfg'
  remote_dump = '~/gforge.pgdump'
  password = sudo('grep password %s | sed' % gforge_conf)
  run('echo %s | pg_dump -Fc -U gforge -h localhost > %s' %
      (password, remote_dump))
  alias = env.host_string
  toremove = (item for item in os.listdir(dump_repo) if item.startswith('gf%s' % alias))
  for item in toremove:
    os.rm(item)
  get(remote_dump, dump_repo)
  run('rm %s' % remote_dump)

@task
def restore_gforge(name=None):
  alias = name if name else env.host_string
  restore(alias, 'gf')

def restore(alias, prefix):
  global dump_repo
  dbname = '%s%s' % (prefix, alias)
  if dbname in local('psql -U root -h localhost -l'):
    local('dropdb -U root -h localhost %s' % dbname)
  local('createdb -U root -h localhost %s -T template0' % dbname)
  dump_file = next((item for item in os.listdir(dump_repo) if item.startswith(dbname)))
  local('pg_restore -U root -h localhost -d %s %s' %
      (dbname, os.path.join(dump_repo, dump_file)))
