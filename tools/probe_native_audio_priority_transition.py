"""Original AF0880 actor controls, state layers/ranges/parents + actual RTPC manager."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
voice=heap+0x1000;others=[heap+0x2000+i*0x300 for i in range(4)];groups=[heap+0x4000,heap+0x4100,0x12100e0];arrays=[heap+0x5000,heap+0x5100,heap+0x5200];calls=[]
regions=[(0xaef2f0,0xaef35c),(0xb014d0,0xb01513),(0xafd670,0xafd803),(0xafd970,0xafdcee)]
def guard(uc,a,n,d):
 if a==0xb014d0:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'group':u.reg_read(UC_X86_REG_ECX),'voice':read(sp+8,'I')[0],'value_bits':read(sp+4,'I')[0]})
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
rows=[]
for old,new,key,presence,mode,target_present in itertools.product([0.,-0.,5.,10.],[-0.,0.,5.,10.,20.,-5.],[2,0x80000000],range(4),range(8),[False,True]):
 u.mem_write(voice,bytes(0x200));put(voice+0x134,'fI',old,key);put(voice+0x198,'II',groups[0] if presence&1 else 0,groups[1] if presence&2 else 0)
 configs=[{'reference':voice,'value':old,'key':key}]
 for i,(ptr,value,serial) in enumerate(zip(others,[20.,10.,5.,0.],[0,1,0x7fffffff,0xffffffff])):
  u.mem_write(ptr,bytes(0x200));put(ptr+0x134,'fI',value,serial);configs.append({'reference':ptr,'value':value,'key':serial})
 group_configs=[]
 for i,(group,array) in enumerate(zip(groups,arrays)):
  ascending=bool(mode&(1<<i));u.mem_write(group,bytes(0x18));refs=list(others)+([voice] if target_present else []);refs.sort(key=lambda ptr:(-read(ptr+0x134,'f')[0],read(ptr+0x138,'I')[0] if ascending else -read(ptr+0x138,'I')[0]));put(group,'II',array,len(refs));u.mem_write(group+0xe,bytes([int(ascending)]))
  for j,ptr in enumerate(refs):put(array+j*4,'I',ptr)
  group_configs.append({'reference':group,'ascending':ascending,'before':refs})
 calls.clear();sp=stack+0x8000;put(sp,'If',trap,new);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,voice);u.emu_start(0xaef2f0,trap,count=30000);assert u.reg_read(UC_X86_REG_EIP)==trap
 rows.append({'voice':voice,'voices':configs,'groups':group_configs,'local_groups':[groups[0] if presence&1 else None,groups[1] if presence&2 else None],'global':groups[2],'new_bits':struct.unpack('<I',struct.pack('<f',new))[0],'output_value_bits':read(voice+0x134,'I')[0],'output_groups':[{'reference':g,'after':[read(a+j*4,'I')[0] for j in range(read(g+4,'I')[0])]} for g,a in zip(groups,arrays)],'calls':list(calls)})
proof={'complete':False,'passed':True,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Original AEF2F0, B014D0, AFD970/AFDB30 and AFD670/AFD740 ordered group lookup/reordering execute unchanged. No transition dispatch or consumer result adapter.','Constructed native-layout voice caches, distinct local/global groups, valid sorted arrays, both unsigned key tie directions and absent target entries.'],'limits':['Finite values only, distinct group identities and unique voice keys; aliased groups, duplicate keys and malformed arrays unqualified.','No physical voice admission/displacement/device output or runtime registration/ownership proof.']}
(r/'data/4.20/audio_priority_transition_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native transition and ordered group consumer cases')
