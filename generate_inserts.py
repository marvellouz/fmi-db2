import os
if __name__=='__main__':
  files = os.listdir('./data')
  for fn in files:
    f = read(fn)
    res=[]
    for line in f.readlines():
       res+="INSERT INTO %s\n VALUES(%s);" % (fn.capitalize(), ','.join(line.split('|'), ))
    "\n".join(res)
    f.close()
