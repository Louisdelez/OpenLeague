from pathlib import Path
import json,sys,hashlib
ROOT=Path('E:/OpenLeague')
exec(compile((ROOT/'tools/probe_replay_metadata.py').read_text().split('\ncases=[]')[0], 'event prerequisites','exec'))
cases=[]
def rows(offset):
 result=[]
 def walk(node):
  if u.mem_read(node+13,1)[0]:return
  walk(read32(node))
  size=read32(node+40);raw=read32(node+24) if read32(node+44)>=16 else node+24
  row={'key':read32(node+16),'index':read32(node+20),'hex':bytes(u.mem_read(raw,size)).hex()}
  if offset==8:row['extra']=read32(node+48)
  result.append(row);walk(read32(node+8))
 walk(read32(read32(metadata+offset)+4))
 return result
for fill in [0,165]:
 poison=fill;cursor=arena;allocations.clear();freed.clear();live={};metadata=0;metadata_events.clear()
 write32(0x14bef40,0);write32(0x14bef58,0)
 manager=call(0x9933e0,0,[68]);call(0x728e20,manager,[])
 write32(0x2d78520,manager)
 service=heap+0x12000
 call(0x72a800,service,[])
 control=read32(manager+0x38);initial=capture();steps=[]
 for event,key in [(5,5),(5,0),(5,0xffffffff),(5,5),(3,123),(4,456),(0,789),(0x105,999)]:
  before=read32(control+4)
  result=call(0x72b950,service,[event,key])&255
  state=capture();assert read32(control+4)==before==1
  assert result==int(event==5)
  steps.append({'event':event,'key':key,'result':result,'state':state})
 packet=heap+0xe000
 frames=[]
 for count_a,count_b in [(0,0),(1,2),(24,24),(3,1),(0,0)]:
  payload=bytearray(0x191);payload[0]=103
  for offset,value in [(1,count_a),(5,count_b),(0x189,0x11223344),(0x18d,0x55667788)]:payload[offset:offset+4]=value.to_bytes(4,'little')
  for off in range(9,0x189,4):payload[off:off+4]=(0xabc00000+off).to_bytes(4,'little')
  u.mem_write(packet,bytes(payload))
  result=call(0x729370,manager,[0,3,7,0,packet])&255
  assert result==1
  frames.append({'packet_hex':payload.hex(),'result':result,'state':capture()})
 text_frames=[]
 for opcode in [101,102]:
  for key,index,text in [(5,0,b''),(2,0xffffffff,b'A'*16),(0xffffffff,0x80000000,b'long replay text'*4),(5,0,b'replaced'),(2,0xffffffff,b''),(0,0x7fffffff,b'tail')]:
   payload=bytearray(0x11+len(text)+1);payload[0]=opcode
   for offset,value in [(1,key),(5,index),(9,0x13572468)]:payload[offset:offset+4]=value.to_bytes(4,'little')
   payload[0x11:0x11+len(text)]=text
   u.mem_write(packet,bytes(payload));result=call(0x729370,manager,[0,3,7,0,packet])&255;assert result==1
   text_frames.append({'packet_hex':payload.hex(),'result':result,'map56':rows(8),'map48':rows(16),'state':capture()})
 call(0x728ea0,manager,[1]);shutdown=capture();assert not live
 cases.append({'fill':fill,'manager':manager,'service':service,'metadata':metadata,'control':control,'initial':initial,'events':steps,'frames':frames,'text_frames':text_frames,'shutdown':shutdown})
proof={'passed':True,'complete':False,'native_sha256':digest,'cases':cases,'limits':['Original72A800/72B950/729C80/728A60 and shared-control paths execute; no metadata or callback consumer is stubbed. Allocator, byte-copy and single-thread OS lock primitives are supplied by existing harness.','Service events1/2, stream networking, count>24 frame arrays and game simulation are not qualified by this probe.']}
Path(sys.argv[1]).write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'lifetimes':len(cases),'service_events':sum(len(c['events']) for c in cases),'metadata_frames':sum(len(c['frames']) for c in cases),'text_frames':sum(len(c['text_frames']) for c in cases)}))
