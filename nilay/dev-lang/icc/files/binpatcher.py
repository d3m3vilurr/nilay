# -*- coding: utf-8 -*-
import sys, os
try:
    sys.argv[1]
except:
    print('icc library patcher.')
    print('usage : %s (binfile1) (binfile2)....')
    sys.exit()

for file in sys.argv[1:]:
    # after dev, should comment out below line.
    #os.system('cp %s %s.orig' %(file, file))
    fp = open(file, 'rb')
    print('file buffered.')
    data = fp.read()
    fp.close()
    data = data.replace('/usr/local/share/macrovision/storage', '/////////////////////////////////tmp')
    data = data.replace('/usr/local/share/macrovision/service/', '/////////////////////////////////tmp/')
    print('patched. exporting...')
    del fp
    fp = open(file, 'wb')
    fp.write(data)
    fp.close()

print('done.')

