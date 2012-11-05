========
Versions
========

forge : v12.2
- gforge : v4.5.14 + v1.0.0
- bugzilla : v3.4.6 + v1.0.0
- viewvc : ? + v1.0.0
- websvn : ? + v1.0.0
- mediawiki : v1.15.1 + v1.0.0
- vulcain : v1.2.46
- testlink : ? + v1.0.0
- fai : v1.0.3
- server-config : v1.0.0
- ldap-sync : v2.1.1

=====
Goals
=====

- make upgrade easier
- ease maintenance
- define a workflow
- make development + validation + deployment faster

====
Todo
====

Bugs
====

- create products with no source, meant for bugs
- create products components

~ 100 bugs in bugzilla, most of them no longer relevant

- confirm
- correct
- validate

Source
======

Actual packages are based on 12.2

- merge orignal sources content
- merge prod patches
- separate products source in distinct modules (viewvc, websvn, mediawiki)
- handle project with patches

Packaging
=========

- sagemcom-style packages
- unique name for each package, do not interfere with official packages
- svnize
- include "forge-install.sh" content in packages
- folder structure : "packaging" folder +  one-level folders (usr-lib-gforge instead of usr/lib/gforge)
- make package for :
  - viewvc
  - websvn
  - mediawiki
  - vulcain
  - testlink
- automate package making and registering
- unix groups : gforge, bugzilla, ...


Upgrades
========

- bugzilla : external cf management
- ubuntu precise
- bugzilla 4
- postgresql 9
- mysql
- viewvc, websvn, mediawiki ?

Administration
==============

- central server log
- integrate config in CFEngine

Validation
==========

- simulate a forge upgrade
- validate bugs
- validate functionalities
- validate package upgrades
