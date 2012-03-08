#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
$Revision$
$Author$
$Date$

---DocStart---
Description:
-----------

Example:
-------

"""

import sys, os, logging
from optparse import OptionParser

Version  = '1.0'
ThisScript = os.path.basename(sys.argv[0]).split('.')[0]

DefaultLogFileName = ThisScript+'.log'
DefaultLogLevel    = 50

def logInit(options):
   '''Accessing the log system.
   '''
   logging.basicConfig(
        level=options.logLevel,
        format=
'%(asctime)s %(name)-7s %(levelname)-8s %(funcName)-8s: %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S',
        filename=DefaultLogFileName,
        filemode='a')
   # define a Handler which writes INFO messages or higher to the sys.stderr
   console = logging.StreamHandler()
   console.setLevel(options.logLevel)
   # set a format which is simpler for console use
   formatter = logging.Formatter(
      '%(name)-7s: %(levelname)-8s %(funcName)-8s: %(message)s')
   # tell the handler to use this format
   console.setFormatter(formatter)
   # add the handler to the root logger
   logging.getLogger('').addHandler(console)

#------------------------------------------------------------------------------
# Define your methods and classes hereafter. They will be reusable by the other
#    scripts by doing: import <This Script>
#------------------------------------------------------------------------------
class ¤class¤:
   """ Define the class documentation here """
   # Class variables defined here
   VarInt = 1                     # As an example
   VarStr = 'Class value example' # As an example

   # class methods defined hereafter
   def __init__(self, initParam1):
      # Define your class constructor actions here
      self.param1 = initParam1      # As an example
      self.param2 = ¤class¤.VarStr # As an example

   def method1(self):
      """ Define the class method documentation here """
      #define your class method actions here
      pass

   def method2(self, param2):
      """ Define the class method documentation here """
      #define your class method actions here
      self.param2 = param2 # As an example

   def __call__(self, param1):
      # Define actions here (replace pass statement)
      # If object xyz is coming from class ¤class¤:
      #    xyz = ¤class¤()
      # This method is called by:
      #    xyz(param)
      pass

   def __del__(self):
      # Define your class destructor actions here (replace pass statement)
      # If object xyz is coming from class ¤class¤:
      #    xyz = ¤class¤()
      # This is called when the object is going out of scope or when doing an
      #    explicit:
      #    del xyz
      pass

def method1():
   """ Document method1 here:
   can be multi-lines
   """
   #define your method actions here
   pass

#------------------------------------------------------------------------------
# Here comes the main procedure of this script
#------------------------------------------------------------------------------
def run(options, args, parser):
   """ Does the real work.
   """
   logInit(options)
   log = logging.getLogger('')

   log.info('Starting '+ThisScript)
   log.info('Version: '+Version)
   log.info('Log level is: '+str(options.logLevel)+' (0 - 50)')
   log.info('Set --logLevel=50 for no trace')

   status = 0

   #---------------------------------------------------------------------------
   # Start your real coding hereafter
   # ...
   #---------------------------------------------------------------------------

   return status

#------------------------------------------------------------------------------
# Here comes the command line handling (This source being used as a script)
#------------------------------------------------------------------------------
if __name__ == '__main__':
   usage = (
      'usage: %(prog)s.py [options] [args]\n'+\
      __doc__.split('---DocStart---')[1] +\
      """
Version: %(version)s""")%{'prog': ThisScript, 'version': Version}

   mParser = OptionParser(usage=usage)

   mParser.add_option('-l', '--logLevel', dest='logLevel',
                      type=int,
                      help='\
Set log level to LEVEL (between 0 (verbose) to 50 (quiet), defaults to %d)'%\
                        DefaultLogLevel,
                     metavar='LEVEL')

   mParser.set_defaults(logLevel=DefaultLogLevel)

   (mOptions, mArgs) = mParser.parse_args()
   mStatus = run(mOptions, mArgs, mParser)
   sys.exit(mStatus) # This return status can be read by the calling shell
