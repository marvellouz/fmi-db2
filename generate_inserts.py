#!/usr/bin/env python
import os
import re
DATA_DIR="./data"
TABLES_SQL="createTables.sql"

def find_order():
  res=[]
  f = open(TABLES_SQL, 'r')
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
  if re.match(r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}', x):
     return "TIMESTAMP(\"%s\")" % x
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
    fields = []
    field_names = ""
    f = open(fn, 'r')
    for line in f:
      line = line.strip()
      if not line: continue
      if line[0]=='#':
        fields = [s.strip() for s in line[1:].split('|') if s]
        fields_count = len(fields)
        field_names = "(%s)" % ','.join(fields)
      else:
        values = map(get_value, line.split('|'))
        if fields:
            values_count = len(values)
            if fields_count!=values_count:
              raise ValueError("Mismatch between fields count (%d) and values count (%d) in file %s!" % ( fields_count, values_count, fn ))
        if line:
            res.append("INSERT INTO %s %s\n VALUES(%s);" % (fn.capitalize(), field_names, ', '.join(values) ) )
    f.close()
  print "\n".join(res)

if __name__=='__main__':
  main()
