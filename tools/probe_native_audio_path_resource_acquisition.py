from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
owner=vector+0x4000;resource=vector+0x5000;calls=[];visited=set()
def hook(uc,a,size,data):
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);pool,size=read(sp+4),read(sp+8);assert pool==17 and size==72;reference=0 if failure else resource;calls.append({'kind':'allocate','pool':pool,'bytes':size,'reference':reference})
  if reference:u.mem_write(resource,bytes([pattern])*72)
  finish(reference);return
 assert 0xaf0640<=a<0xaf069f or 0xb1b0f0<=a<0xb1b173,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,existing,failure,identity,defaults in itertools.product([0,0xa5,0xff],[False,True],[False,True],[0,0xffffffff],[(0,0,0),(0x3f800000,0x3f000000,0x40000000),(0xffffffff,0x7fc00001,0x80000000)]):
 calls.clear();u.mem_write(owner,bytes([pattern])*96);u.mem_write(resource,bytes([pattern])*72);w(owner+8,identity);w(owner+68,resource if existing else 0);w(0x12100dc,17)
 for i,v in enumerate(defaults):w(0x121026c+i*4,v)
 def snap():return {'owner':bytes(u.mem_read(owner,96)).hex(),'resource':bytes(u.mem_read(resource,72)).hex()}
 before=snap();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0xaf0640,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'existing':existing,'failure':failure,'identity':identity,'defaults':defaults,'before':before,'after':snap(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaf0640','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual acquisition AF0640 and constructor B1B0F0 execute. Physical allocator is a mandatory controlled transport. 72-byte resource constructor defaults and owner identity are supplied exact raw globals; source global producers, bank-reader acquisition integration, downstream ownership and physical audio remain required.']}
(r/'data/4.20/audio_path_resource_acquisition_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native resource acquisition/constructor cases')
