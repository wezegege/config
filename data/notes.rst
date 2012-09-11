================
Create a library
================

http://getpython3.com/diveintopython3/packaging.html

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

vulcain-scripts
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

alternatives : pyflakes, pychecker

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

Provides means for deploying your module.

syntax
------

- Here is an example :

    from setuptools import setup, find_packages
    from os.path import join, dirname

    import sagemcom

    setup(
        name='sagemcom-tools',
        version=sagemcom.__version__,
        packages=find_packages(),
        author="Kevin TRAN",
        author_email="kevin.tran@sagemcom.com",
        url="http://forge-etl.rmm.sagem/projects/sagemcom-tools/",
        description="wrapper for different libraries with sagemcom forge structure",
        long_description=open(join(dirname(__file__), 'README.txt')).read(),
        keywords=['svn', 'sqlalchemy', 'bugzilla', 'gforge', 'vulcain', 'postgresql',
            'ldap'],
        classifiers=[
            "Development Status :: 5 - Production/Stable",
            "Environment :: Console",
            "Intended Audience :: Developers",
            "License :: Other/Proprietary License",
            "Natural Language :: English",
            "Operating System :: OS Independent",
            "Programming Language :: Python :: 2",
            "Topic :: Database",
            "Topic :: Software Development :: Libraries :: Python Modules",
            ],
        license='Sagemcom',
        )

- version indicated in the setup.py file shall always be the next version.
- if you need to use you module as a development module ("python setup.py develop"), put a setup.cfg file in your module's root, with this content :

    [egg_info]
    tag_build = .dev
    tag_svn_revision = 1

  This will tag your lib as "<lib name>-<version>.dev-<svn rev>".
  With version always being the next version, you won't have version issue when doing a "pip install --upgrade".

usage
-----

    python setup.py <command>

Useful commands are :

- install
- develop
- bdist_egg
- sdist

=============================
Where do I create my script ?
=============================

- my script will consist on several files. It can be seen as a full software, and will be used either by an end user or a cron, or as a daemon. It has a broad spectrum of use cases or end users. Usage of branches and tags makes sense.

Create your own module.

If your script will be use by an end user, or its code may be useful for reuse by an end user, create it on forge-biblio. Else, if it contains confidential information, such as security matter, or internal behaviour, better create it on forge-etl.

Your module should contain either a "requirement.txt", or a "setup.py" file, specifying the module's dependencies.

It may be pertinent to connect it to Sentry.

If your module consists of command-line scripts which can be used by vulcain, create an external link in vulcain-scripts, and update its dependencies.


- my script will consist of one or two files. It can be seen as a full software, and will be used either by and end user or a cron, or as a daemon. Its use case is very specific to a precise and narrow problem. Usage of branches and tags is useless.

Use http://forge-etl.rmm.sagem/etl-softwares


- my script offers maintenance operations on a forge's tools. It is meant to be launched from a terminal, but would make sense being a feature of vulcain.

Use http://forge-biblio.vzy.sagem/vulcain-scripts

Update the "requirements.txt" and the "setup.py" files of the module with your dependencies.

When you are done writing your script, create a release with this command :

    python setup.py bdist


- my script is very specific to a problem, and may be used only once.

Use http://forge-etl.rmm.sagem/etl-sandbox

============
Coding style
============

General
=======

- use Pylint.
- if a function you write is generic enough to be used by other scripts, put it in the lib.

Vulcain scripts
===============

- isolate treatment from input checking and output formatting. Treatment operation should be made within a function which receives python structures as input and returns python structures as output. This allows Vulcain to use web forms as input, and a different display as output.

- for complex operations, implement a "simulate" option which will describe what will be done without actually doing it.

=======
Logging
=======

Small scripts logging to Sentry
===============================

Give a name for the logger which is the name of the script (logging.getLogger(<name>)), then put a SentryHandler to the project "test".
You can then filter your script's messages in sentry with the field "logger".
Don't forget to erase your entries ("resolve feed") when done.

Sentry config :

    import raven
    from raven.handlers.logging import SentryHandler
    from raven.conf import setup_logging

    raven_client = raven.Client(servers=[<server>], public_key=<public key>,
            secret_key=<private key>, project=<project id>)
    s_handler = SentryHandler(raven_client)
    setup_logging(s_handler)
    s_handler.setLevel(<log level>)
    s_handler.setFormatter(formatter)
    logging.getLogger('').addHandler(s_handler)

Vulcain
=======

- when use in command line, have the classical console + file handlers
- when use by vulcain, have instead the sagemcom.utils.log_utils.StoreHandler handler. This handler stores messages in a list, so that vulcain can retrieve its content and display it ni a web page.

put the log_init function in sagemcom.utils.log_utils

http://forge-etl.rmm.sagem/svn/sagemcom-tools/BO/branches/BO_sagemcom-tools/sagemcom/utils/log_utils.py

Softwares
=========

- if the scripts is regularly used, use a TimeRotatingFileHandler instead of a regular FileHandler. This creates a new log file per day, then erase the oldests logs. Also create a project in Sentry, and add a SentryHandler.

