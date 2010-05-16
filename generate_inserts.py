#!/usr/bin/env python
import os
def get_value(x):
  x=x.strip()
  if x:
    return "'%s'" % x
  else:
    return "NULL"

def main():
  os.chdir("./data")
  files = os.listdir('.')
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
