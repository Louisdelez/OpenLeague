"""Bounded INIBIN v2 reader with raw field offsets for native particle qualification."""
from pathlib import Path
import struct

def key_hash(section,name):
 h=0
 for c in (section+'*'+name).lower():h=(ord(c)+65599*h)&0xffffffff
 return h

def decode(path):
 data=Path(path).read_bytes();assert len(data)>=5 and data[0]==2,'Only qualified v2 supported'
 string_length,flags=struct.unpack_from('<HH',data,1);assert flags&0xe000==0,'Unqualified field flags'
 string_start=len(data)-string_length;cursor=5;fields={}
 formats=['i','f','B','h','B',None,'3B','3f','2B','2f','4B','4f','H']
 def take(fmt):
  nonlocal cursor
  size=struct.calcsize('<'+fmt);assert cursor+size<=len(data)
  values=struct.unpack_from('<'+fmt,data,cursor);cursor+=size;return values
 for bit,fmt in enumerate(formats):
  if not flags&(1<<bit):continue
  count=take('H')[0];keys=take('I'*count) if count else []
  if bit==5:
   offset=cursor;size=(count+7)//8;assert cursor+size<=string_start;cursor+=size
   values=[int(bool(data[offset+i//8]&(1<<(i%8)))) for i in range(count)]
   offsets=[offset+i//8 for i in range(count)];sizes=[1]*count
  else:
   values=[];offsets=[];sizes=[]
   for key in keys:
    offset=cursor;value=take(fmt);size=cursor-offset
    # All compressed byte vectors use the same tenth-unit encoding as scalars.
    if bit in [2,6,8,10]:value=tuple(x*.1 for x in value)
    value=value[0] if len(value)==1 else list(value)
    if bit==12:
     start=string_start+value;assert string_start<=start<len(data);end=data.find(b'\0',start);assert end>=0;value=data[start:end].decode('ascii')
    values.append(value);offsets.append(offset);sizes.append(size)
  for i,key in enumerate(keys):
   assert key not in fields,'Duplicate native hash'
   fields[key]={'value':values[i],'field_type_bit':bit,'offset':offsets[i],'raw_bytes':data[offsets[i]:offsets[i]+sizes[i]].hex()}
 assert cursor==string_start,(cursor,string_start)
 return fields
