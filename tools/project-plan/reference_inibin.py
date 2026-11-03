"""Read-only INIBIN v2 reader for source comparison, never a game importer.

Type/hash layout derived from inspected tools/import_all_champions.py; original
file provenance is recorded in the comparison receipt. Missing keys stay None.
"""
import pathlib,struct
class InibinError(ValueError):pass
def hashkey(section,prop):
 h=0
 for ch in (section+'*'+prop).lower():h=(ord(ch)+65599*h)&0xffffffff
 return str(h)
def decode(data):
 if len(data)<5 or data[0]!=2:raise InibinError('Expected INIBIN v2')
 slen,flags=struct.unpack_from('<HH',data,1);off=5;result={}
 if flags&~8191 or slen>len(data)-5:raise InibinError('Invalid INIBIN flags/string length')
 string_start=len(data)-slen
 def take(fmt):
  nonlocal off
  size=struct.calcsize('<'+fmt)
  if off+size>string_start:raise InibinError('Truncated INIBIN value block')
  v=struct.unpack_from('<'+fmt,data,off);off+=size;return v
 for bit,fmt in enumerate(['i','f','B','h','B',None,'3B','3f','2B','2f','4B','4f','H']):
  if not flags&(1<<bit):continue
  count=take('H')[0];keys=take('I'*count)
  if bit==5:
   n=(count+7)//8
   if off+n>string_start:raise InibinError('Truncated INIBIN boolean block')
   values=[int(bool(data[off+i//8]&(1<<(i%8)))) for i in range(count)];off+=n
  else:
   values=[]
   for _ in keys:
    v=take(fmt);v=v[0] if len(v)==1 else list(v)
    if bit==2:v=v*.1
    if bit in [6,8,10]:v=[x*.1 for x in v]
    if bit==12:
     if v>=slen:raise InibinError('String outside INIBIN string table')
     end=data.find(b'\0',string_start+v)
     if end<0:raise InibinError('Unterminated INIBIN string')
     v=data[string_start+v:end].decode('utf-8')
    values.append(v)
  for k,v in zip(keys,values):
   k=str(k)
   if k in result:raise InibinError('Duplicate hash key in INIBIN')
   result[k]=v
 return result
def read(path):return decode(pathlib.Path(path).read_bytes())
