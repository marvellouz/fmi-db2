import sys
from os.path import basename
import os
import re

def fix(sql):
  re.sub()
  return sql

def main():
  if len(sys.argv)!=2:
    print 'error'
    return 1

  fn=sys.argv[1]
  base=os.path.splitext(basename(fn))[0]
  f=open(fn)
  sql=f.read()
  f.close()

  fixed=fix(sql)
  out=open("%s_fixed.sql" % base, 'w')
  out.write(fixed)
  return 0

if __name__=='__main__':
  sys.exit(main())
