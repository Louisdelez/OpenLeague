from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
resource=vector+0x5000;source_points=vector+0x6000;source_pairs=vector+0x7000;old_points=vector+0x8000;old_descriptors=vector+0x9000;new_points=vector+0xa000;new_descriptors=vector+0xb000;calls=[];freed=[];allocations=[];nth=0;visited=set()
def hook(uc,a,size,data):
 global nth
 if a==0xada670:
  nth+=1;sp=u.reg_read(UC_X86_REG_ESP);pool,size=read(sp+4),read(sp+8);stage=nth-(0 if existing else 1);expected=72 if stage==0 else (point_count if stage==1 else descriptor_count)*16;assert pool==17 and size==expected
  ref=0 if failure==nth else resource if stage==0 else new_points if stage==1 else new_descriptors;calls.append({'kind':'allocate','pool':pool,'bytes':size,'reference':ref})
  if ref:u.mem_write(ref,bytes([pattern])*size);allocations.append({'reference':ref,'size':size})
  finish(ref);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);pool,ref=read(sp+4),read(sp+8);assert pool==17 and ref in [old_points,old_descriptors] and ref not in freed;freed.append(ref);calls.append({'kind':'free','pool':pool,'reference':ref});finish(1);return
 if a==0xca1ef0:
  sp=u.reg_read(UC_X86_REG_ESP);dest,src,size=read(sp+4),read(sp+8),read(sp+12);assert dest==new_points and src==source_points and size==point_count*16;u.mem_write(dest,bytes(u.mem_read(src,size)));calls.append({'kind':'copy','source':src,'destination':dest,'bytes':size});finish(dest);return
 assert 0xb1b220<=a<0xb1b3bc or 0xaf2c60<=a<0xaf2e4c or 0xaf0640<=a<0xaf069f or 0xb1b0f0<=a<0xb1b173,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
owner=vector+0x4000;cursor=vector+0x3000;stream=vector+0x6000
profiles=list(itertools.product([0,0xa5],[False,True],[0,1,3],[0,3],[0,2],[0,1]))
for pattern,existing,failure,point_count,descriptor_count,loop in profiles:
 path_mode=0;present=1;first=1;enabled=1;acquire_status=1
 calls.clear();freed.clear();allocations.clear();nth=0
 u.mem_write(owner,bytes([pattern])*96);w(owner+68,resource if existing else 0);u.mem_write(resource,bytes([pattern])*72);w(resource+40,0);w(resource+48,0);w(resource+44,0);w(resource+52,0);w(0x12100dc,17)
 defaults=[0x3f800000,0,0xbf800000]
 for j,v in enumerate(defaults):w(0x121026c+j*4,v)
 payload=bytearray([present,first,enabled]);
 if first:payload+=bytes([loop])
 payload+=struct.pack('<II',path_mode,0x12345678);payload+=bytes([1]);
 if path_mode==1:payload+=bytes([loop])
 else:
  payload+=struct.pack('<I',3);payload+=bytes([loop]);payload+=struct.pack('<I',1024);payload+=bytes([1]);payload+=struct.pack('<I',point_count)
  source_points=stream+len(payload)
  for i in range(point_count):payload+=struct.pack('<3fI',float(i+1),float(2*i),float(-i),40+i)
  payload+=struct.pack('<I',descriptor_count);source_pairs=stream+len(payload)
  for i in range(descriptor_count):payload+=struct.pack('<II',min(i,max(0,point_count-1)),1)
  for i in range(descriptor_count):payload+=struct.pack('<2f',float(i+1)*2,float(i+1)*4)
 u.mem_write(stream,bytes(payload));w(cursor,stream)
 def snap():return {'owner':bytes(u.mem_read(owner,96)).hex(),'resource':bytes(u.mem_read(resource,72)).hex(),'cursor':read(cursor),'stream':bytes(u.mem_read(stream,len(payload))).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex(),'freed':v['reference']in freed}for v in allocations]}
 before=snap();w(stack,end);w(stack+4,cursor);w(stack+8,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0xaf2c60,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'existing':existing,'defaults':defaults,'present':present,'first':first,'enabled':enabled,'acquire_status':acquire_status,'pattern':pattern,'path_mode':path_mode,'point_count':point_count,'descriptor_count':descriptor_count,'failure':failure,'loop':loop,'before':before,'after':snap(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaf2c60','end':'0xaf2e4c','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual parser AF2C60 and B1B220 execute, including flags, cursor advancement and jitter patch. Actual AF0640 acquisition and B1B0F0 constructor execute; only allocator/free/memcpy remain controlled transports. Optional-data early guards, mode1 and acquisition failure execute. Bounded corrupt streams, acquiring-reader Rust replay, owning caller and physical audio remain required.']}
(r/'data/4.20/audio_path_resource_reader_acquiring_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native resource reader and actual shared-block builder cases')
