#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys, string
try:
    sys.argv[1]
except:
    print 'Nothing to do with no file. Exits!'
    print 'Usage : %s (source).c' %sys.argv[0]
    sys.exit(-1)
path_max_head = '''/* Below one line is written by srcHack_ICC */
#define PATH_MAX 1024
/* Original sources starts from here */
'''
m_pi_head = '''/* Below one line is written by srcHack_ICC */
#define M_PI 3.141592
/* Original sources starts from here */
'''

file = sys.argv[1]
src = open(file, 'r')
dsrc = src.read();src.close()
print 'Testing file.... %s' %file
if string.find(dsrc, 'PATH_MAX') != -1:
    src = open(file, 'w')
    src.write(path_max_head)
    src.write(dsrc)
    src.close()
    print 'Work done. ;-)'
    print 'God will bless the sources? I don\'t know :P'
    sys.exit()
elif string.find(dsrc, 'M_PI') != -1:
    src = open(file, 'w')
    src.write(m_pi_head)
    src.write(dsrc)
    src.close()
    print 'Work done. ;-)'
    print 'God will bless the sources? I don\'t know :P'
    sys.exit()
else:
    print 'No need to patch. pass.'
    sys.exit()


