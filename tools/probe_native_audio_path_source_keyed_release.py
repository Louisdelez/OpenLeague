from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x1000;owner=vector+0x2000;entries=vector+0x3000;descriptors=vector+0x4000;buffers=vector+0x5000;calls=[];visited=set();w(0x12100dc,19)
def snap():return {n:bytes(u.mem_read(a,size)).hex()for n,a,size in [('source',source,96),('owner',owner,60),('entries',entries,36),('descriptors',descriptors,192),('buffers',buffers,192)]}
def hook(uc,a,size,data):
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'free','pool':read(sp+4),'reference':read(sp+8),'at_call':snap()});finish(0);return
 assert 0xafe690<=a<0xafe720 or 0xafea30<=a<0xafea7c or 0xb01300<=a<0xb0135d,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,position,refcount,other,descriptor,buffer in itertools.product([0,0xa5],[0,1,3],[0,1,2,3],[0,1,2],[0,1],[False,True],[False,True]):
 for a,size in [(source,96),(owner,60),(entries,36),(descriptors,192),(buffers,192)]:u.mem_write(a,bytes([pattern])*size)
 w(source+28,owner);w(owner,entries);w(owner+4,count);w(owner+12,0x44444444);u.mem_write(owner+48,bytes(8));key=0x9000+position
 for i in range(3):
  entry=entries+i*12;desc=descriptors+i*64;w(entry,0x9000+i);w(entry+4,desc if descriptor else 0);u.mem_write(entry+8,refcount.to_bytes(2,'little')+other.to_bytes(2,'little'));w(desc,buffers+i*64 if buffer else 0);w(desc+4,3);w(desc+8,8)
 calls.clear();before=snap();w(stack,end);w(stack+4,key);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xafe690,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'count':count,'position':position,'refcount':refcount,'other':other,'descriptor':descriptor,'buffer':buffer,'key':key,'before':before,'after':snap(),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AFE690 keyed decrement, AFEA30 ordered buffer/descriptor free and B01300 first-match shift/remove execute. Physical allocator free adapted and free-time full regions captured.','Owner head12 is nonempty to prevent whole empty-owner release in this matrix. Manager/source constructors, Rust replay and integrated frame/output remain required.']}
(r/'data/4.20/audio_path_source_keyed_release_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native keyed-entry destruction/removal cases')
