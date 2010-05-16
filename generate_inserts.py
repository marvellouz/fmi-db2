#!/usr/bin/env python
import os
import re
DATA_DIR="./data"

def find_order():
  res=[]
  f = open("createTables.sql", 'r')
  for l in f:
    m=re.match(r'CREATE\W+TABLE\W+(\w+)\W*\(', l)
    if m:
      res.append(m.group(1).lower())
  return res

def custom_key(word, order):
  if word in order:
    return order.index(word)

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

def sort_files(files):
  order=find_order()
  files.sort(key=lambda x: custom_key(x.lower(), order))
  return files

def main():
  files = sort_files(os.listdir(DATA_DIR))
  res = ["set schema FN71100_71012;"]
  os.chdir(DATA_DIR)
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
