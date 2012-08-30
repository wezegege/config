=======
Modules
=======

sagemcom-tools
==============

- http://forge-etl.rmm.sagem/sagemcom-tools

Various helpers about the various softwares used by Sagemcom, such as Bugzilla, SVN, LDAP, ...

etl-tests
=========

http://forge-biblio.vzy.sagem/etl-tests

Data sets and common mocks for your tests writing.

etl-sandbox
===========

sagemcom-scripts
================

categories
    Bugzilla, SVN, LDAP, Gforge, Forge, Testlink

etl-softwares
=============

etl-tools
=========

http://forge-biblio.vzy.sagem/etl-tools

=====
Tools
=====

pip
===

usage
-----

To see which libraries are installed :

    pip freeze -l

installation
------------

    apt-get install python-setuptools
    easy_install pip

or (deprecated)

    apt-get install python-pip

virtualenv
==========

nose
====

selenium
========

pylint
======

fabric
======

=====
Files
=====

requirements.txt
================

purpose
-------

Specify your module's dependencies.

syntax
------

A requirement file contains a dependency per line. You can specify a version range for a lib, a path to an archived lib (tar.gz) or a svn repo with the option "-e".

Example of requirements.txt :

    xlrd
    sqlalchemy>=0.7
    libs/python-ldap-2.4.0.tar.gz
    -e svn+http://forge-etl.rmm.sagem/svn/sagemcom-tools

usage
-----

You can use this file to install requirements with pip :

    pip install -r requirements.txt


setup.py
========

purpose
-------

Provides means for deploying your module. This file is essential for a library, as it can be

syntax
------

usage
-----

    python setup.py <command>

Useful commands are :

- install
- develop
- bdist

=============================
Where do I create my script ?
=============================

- my script will consist on several files. It can be seen as a full software, and will be used either by an end user or a cron, or as a daemon. It has a broad spectrum of use cases or end users. Usage of branches and tags makes sense.

Create your own module.

If your script will be use by an end user, or its code may be useful for reuse by an end user, create it on forge-biblio. Else, if it contains confidential information, such as security matter, or internal behaviour, better create it on forge-etl.

Your module should contain either a "requirement.txt", or a "setup.py" file, specifying the module's dependencies.

It may be pertinent to connect it to Sentry.


- my script will consist of one or two files. It can be seen as a full software, and will be used either by and end user or a cron, or as a daemon. Its use case is very specific to a precise and narrow problem. Usage of branches and tags is useless.

Use http://forge-etl.rmm.sagem/etl-softwares

- my script offers maintenance operations on a forge's tools. It is meant to be launched from a terminal, but would make sense being a feature of vulcain.

Use http://forge-biblio.vzy.sagem/sagemcom-scripts

Update the "requirements.txt" and the "setup.py" files of the module with your dependencies.

When you are done writing your script, create a release with this command :

    python setup.py bdist

- my script is very specific to a problem, and may be used only once.

Use http://forge-etl.rmm.sagem/etl-sandbox
