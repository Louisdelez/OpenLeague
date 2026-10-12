from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
node=vector+0x4000;buffer=vector+0x10000;calls=[];visited=set();allocated=False
matrices=[]
for i in range(8):
 values=[(-1. if j%2 else 1.)*(1.+i*9+j)for j in range(9)];matrices.append(struct.pack('<9f',*values));u.mem_write(0x14a7eb0+i*0x90,matrices[-1])
def hook(uc,a,size,data):
 global allocated
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);pool,size=read(sp+4),read(sp+8);assert pool==17 and size==mask.bit_count()*36;reference=0 if failure else buffer;calls.append({'kind':'allocate','pool':pool,'bytes':size,'reference':reference});allocated=reference!=0
  if allocated:u.mem_write(buffer,bytes([pattern])*size)
  finish(reference);return
 assert 0xb1b590<=a<0xb1b670,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,mask,existing,failure in itertools.product([0,0xa5],range(256),[False,True],[False,True]):
 calls.clear();allocated=False;u.mem_write(node,bytes([pattern])*108);w(node+104,buffer if existing else 0);u.mem_write(buffer,bytes([0x33])*288);w(0x12100dc,17)
 def snap():return {'node':bytes(u.mem_read(node,108)).hex(),'buffer':bytes(u.mem_read(buffer,288)).hex(),'allocated':{'reference':buffer,'size':mask.bit_count()*36,'raw':bytes(u.mem_read(buffer,mask.bit_count()*36)).hex()}if allocated else None}
 before=snap();w(stack,end);w(stack+4,mask);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb1b590,end,count=4000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'mask':mask,'existing':existing,'failure':failure,'before':before,'after':snap(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb1b590','case_count':len(rows),'listener_matrices':[m.hex()for m in matrices],'cases':rows,'native_addresses':len(visited),'limits':['Actual popcount of caller byte mask, physical allocation field publication, cached-pointer and eight listener transposed matrix copies execute. Controlled allocator transport and supplied exact finite source matrices. Wider-than-byte masks, nonfinite/x87 exceptional matrix payloads, listener matrix producers, Rust port and caller integration remain required.']}
(r/'data/4.20/audio_path_listener_orientation_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native listener orientation allocation/cached/oom/transposed matrix cases')
