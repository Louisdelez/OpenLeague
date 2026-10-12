from pathlib import Path
import struct,json
exec(Path('E:/mapslol3v3/decode_native_endgame_classic.py').read_text(encoding='utf-8').replace("exec(compile(s,'classic-eog','exec'))","exec(compile(s[:s.index('print(json.dumps')],'classic-eog','exec'))"))
def cstr(b,pos):end=b.index(0,pos);return b[pos:end].decode(errors='replace'),end+1
def actions(b,pool=None):
 pool=pool or [];pos=0;out=[]
 while pos<len(b):
  op=b[pos];pos+=1
  if not op:break
  size=0
  if op>=128:size=struct.unpack_from('<H',b,pos)[0];pos+=2
  data=b[pos:pos+size];pos+=size;value=None
  if op==0x88:
   count=struct.unpack_from('<H',data)[0];idx=2;pool=[]
   for _ in range(count):s,idx=cstr(data,idx);pool.append(s)
   value=pool
  elif op==0x96:
   idx=0;value=[]
   while idx<len(data):
    t=data[idx];idx+=1
    if t==0:v,idx=cstr(data,idx)
    elif t in [8,9]:n=data[idx] if t==8 else struct.unpack_from('<H',data,idx)[0];idx+=1 if t==8 else 2;v=pool[n]
    elif t==7:v=struct.unpack_from('<i',data,idx)[0];idx+=4
    elif t==1:v=struct.unpack_from('<f',data,idx)[0];idx+=4
    elif t==6:v='double:'+data[idx:idx+8].hex();idx+=8
    elif t in [4,5]:v={'register' if t==4 else 'bool':data[idx]};idx+=1
    elif t in [2,3]:v='null' if t==2 else 'undefined'
    else:raise ValueError(t)
    value.append(v)
  elif op in [0x9b,0x8e]:
   name,idx=cstr(data,0);count=struct.unpack_from('<H',data,idx)[0];idx+=2
   if op==0x8e:idx+=3
   for _ in range(count):
    if op==0x8e:idx+=1
    _,idx=cstr(data,idx)
   size=struct.unpack_from('<H',data,idx)[0];idx+=2
   body=data[idx:idx+size]
   # Function code follows the declaration's record payload in this stream.
   if len(body)<size:body=b[pos:pos+size];pos+=size
   value=dict(name=name,body=actions(body,pool))
  out.append(dict(op=hex(op),value=value))
 return out
records=[]
def scan(b,start=0):
 for kind,data in tags(b,start):
  if kind==39:scan(data,4)
  if kind in [12,59]:records.append(dict(kind=kind,actions=actions(data[2:] if kind==59 else data)))
scan(b,offset)
Path('E:/mapslol3v3/native_endgame_actions.json').write_text(json.dumps(records,indent=2),encoding='utf-8')
def find(rows):
 for i,a in enumerate(rows):
  if a['op']=='0x96' and a['value'] and any(x in ['closeSplashScreen','CloseSplashScreen','Continue'] for x in a['value'] if isinstance(x,str)):print(json.dumps(rows[max(0,i-3):i+8]))
  if isinstance(a['value'],dict) and 'body' in a['value']:find(a['value']['body'])
for record in records:find(record['actions'])
