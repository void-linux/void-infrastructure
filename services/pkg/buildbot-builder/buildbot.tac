# vim: set filetype=python:

import os
import configparser

from buildbot_worker.bot import Worker

from twisted.application import service
from twisted.python.logfile import LogFile
from twisted.python.log import ILogObserver, FileLogObserver

basedir = '.'
rotateLength = 10000000
maxRotatedFiles = 10

# if this is a relocatable tac file, get the directory containing the TAC
if basedir == '.':
    import os.path
    basedir = os.path.abspath(os.path.dirname(__file__))

# note: this line is matched against to check that this is a worker
# directory; do not edit it.
application = service.Application('buildbot-worker')

logfile = LogFile.fromFullPath(
    os.path.join(basedir, "twistd.log"), rotateLength=rotateLength,
    maxRotatedFiles=maxRotatedFiles)
application.setComponent(ILogObserver, FileLogObserver(logfile).emit)

ini = configparser.ConfigParser()
ini.read_dict({'buildbot': {}, 'worker': {}})
ini.read('/local/config.ini')

buildmaster_host = ini['buildbot'].get('host', 'localhost')
port = ini['buildbot'].getint('worker-port', 9989)
workername = ini['worker'].get('name', 'example-worker')
with open("/secrets/buildbot/worker-password") as f:
    passwd = f.read()
keepalive = ini['worker'].getint('keepalive', 600)
umask = None
maxdelay = ini['worker'].getint('maxdelay', 300)
numcpus = None
allow_shutdown = None
maxretries = None
use_tls = 0
delete_leftover_dirs = False
proxy_connection_string = None
protocol = 'pb'

s = Worker(buildmaster_host, port, workername, passwd, basedir,
           keepalive, umask=umask, maxdelay=maxdelay,
           numcpus=numcpus, allow_shutdown=allow_shutdown,
           maxRetries=maxretries, protocol=protocol, useTls=use_tls,
           delete_leftover_dirs=delete_leftover_dirs,
           proxy_connection_string=proxy_connection_string)
s.setServiceParent(application)
