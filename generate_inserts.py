#!/usr/bin/env python
import os
import re

def find_order():
  res=[]
  f = open("createTables.sql", 'r')
  for l in f:
    m=re.match(r'CREATE\W+TABLE\W+(\w+)\W*\(', l)
    if m:
      res.append(m.group(1).lowercase())
  return res

def get_value(x):
  x=x.strip()
  x=re.sub(r'\'', "", x)
  if x=="*":
    return "CURRENT TIMESTAMP"
  try:
    return "%d" % int(x)
  except ValueError:
    if x:
      return "'%s'" % x
    else:
      return "NULL"


def main():
  os.chdir("./data")
  files = os.listdir('.')
  #sort_files(files, find_order())
  res = ["set schema FN71100_71012;"]
  for fn in files:
    f = open(fn, 'r')
    for line in f:
      line=line.strip()
      if line:
        res.append("INSERT INTO %s\n VALUES(%s);" % (fn.capitalize(), ', '.join(map(get_value, line.split('|')) )) )
    f.close()
  print "\n".join(res)

if __name__=='__main__':
  main()
