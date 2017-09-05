#!/usr/bin/env python 
# python startup file 
# 放在sys.path的site-packeges里
import sys
import readline
import rlcompleter
import atexit
import os
# tab completion 
readline.parse_and_bind('tab: complete')
# history file 
histfile = os.path.join(os.environ['HOME'], '.pythonhistory')
try:
    readline.read_history_file(histfile)
except IOError:
    pass
atexit.register(readline.write_history_file, histfile)
del os, histfile, readline, rlcompleter
