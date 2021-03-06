# -*- coding: utf-8 -*- 
from urllib2 import urlopen, Request
from urllib import urlencode
import sys
import os
"""
"""

def main():
  if len(sys.argv)!=2:
    return 1
  try:
    err_number=int(sys.argv[1])
  except:
    print 'Invalid number'
    return -1

  BASE_URL = "http://publib.boulder.ibm.com/infocenter/db2luw/v9r5/topic/com.ibm.db2.luw.messages.sql.doc/doc/msql%s.html"
  err_str=("%d" % abs(err_number)).zfill(5)
  err_str+=["w","n"][err_number<0]
  req = Request(BASE_URL % err_str)
  res = urlopen(req)
  f=os.popen("lynx -stdin", 'w')
  f.write(res.read())
  return 0

if __name__=='__main__':
  sys.exit(main())
