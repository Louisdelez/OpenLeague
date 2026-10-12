from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
import capstone
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
regions=[]
for entry,stop in [(0xb00180,0xb00243),(0xaf0370,0xaf042a),(0xafe760,0xafe7a0),(0xafe720,0xafe760),(0xafe690,0xafe71e),(0xaf6430,0xaf6445)]:
 regions.append({'entry':hex(entry),'end_exclusive':hex(stop),'instructions':[{'address':hex(i.address),'mnemonic':i.mnemonic,'operands':i.op_str,'bytes':i.bytes.hex()}for i in md.disasm(bytes(u.mem_read(entry,stop-entry)),entry)]})
imports=[{'address':hex(i.address),'library':d.dll.decode(),'name':i.name.decode()if i.name else None}for d in pe.DIRECTORY_ENTRY_IMPORT for i in d.imports if i.address in [0xfa4424,0xfa4428]]
(r/'data/4.20/audio_path_source_virtual_cleanup_exact_discovery.json').write_text(json.dumps({'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':regions,'imports':imports},indent=2)+'\n',encoding='utf-8')
source=vector+0x1000;owner=vector+0x2000;entries=vector+0x3000;payload=vector+0x4000;manager=vector+0x5000;vtable=vector+0x6000;parents=vector+0x7000;wrapper=vector+0x8000;calls=[];visited=set()
w(0x14a7a08,manager);w(0x12100dc,19);w(0xfa4424,vector+0xf000);w(0xfa4428,vector+0xf010)
for slot,target in [(0,0xf020),(0x14,0xf030),(0x30,0xf040),(0x8c,0xf050)]:w(vtable+slot,vector+target)
def hook(uc,a,size,data):
 if a in [vector+0xf000,vector+0xf010]:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'lock'if a==vector+0xf000 else'unlock','receiver':read(sp+4)});finish(0,4);return
 if a==0xaf6650:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'remove_manager_key','receiver':u.reg_read(UC_X86_REG_ECX),'key':read(read(sp+4))});finish(1,4);return
 if a in [vector+0xf020,vector+0xf030,vector+0xf040]:
  sp=u.reg_read(UC_X86_REG_ESP);ev={'kind':{vector+0xf020:'source_destructor',vector+0xf030:'source_virtual14',vector+0xf040:'parent_virtual30'}[a],'receiver':u.reg_read(UC_X86_REG_ECX)}
  if a!=vector+0xf030:ev['argument']=read(sp+4)
  calls.append(ev);finish(0,0 if a==vector+0xf030 else 4);return
 if a==vector+0xf050:
  sp=u.reg_read(UC_X86_REG_ESP);p=read(sp+4);calls.append({'kind':'parent_virtual8c','receiver':u.reg_read(UC_X86_REG_ECX),'payload':bytes(u.mem_read(p,24)).hex()});u.mem_write(p+20,b'\x01');finish(0,4);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'free','pool':read(sp+4),'reference':read(sp+8)});finish(0);return
 assert any(start<=a<stop for start,stop in [(0xb00180,0xb00243),(0xaf6430,0xaf6445),(0xaf0370,0xaf042a),(0xafe760,0xafe7a0),(0xafe720,0xafe760),(0xafe690,0xafe71e)]),hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def snap():return {name:bytes(u.mem_read(address,length)).hex()for name,address,length in [('source',source,96),('owner',owner,60),('entries',entries,24),('payload',payload,24),('parents',parents,192),('wrapper',wrapper,16)]}
def reset(pattern):
 for address,length in [(source,96),(owner,60),(entries,24),(payload,24),(parents,192),(wrapper,16)]:u.mem_write(address,bytes([pattern])*length)
 w(source,vtable);w(source+8,0x12345678);w(source+28,owner);w(source+32,0);w(source+36,0);w(source+56,0)
 for address in [parents,parents+96]:w(address,vtable)
 w(wrapper,parents+96);calls.clear()
def run(entry):
 w(stack,end);w(stack+4,payload);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(entry,end,count=4000);assert u.reg_read(UC_X86_REG_EIP)==end
 return u.reg_read(UC_X86_REG_EAX)
release=[]
for pattern,count,flag,parentmask in itertools.product([0,0xa5],[0,1,2,0xffffffff],[0,2],range(4)):
 reset(pattern);w(source+12,count);u.mem_write(source+47,bytes([flag]));w(source+32,parents if parentmask&1 else 0);w(source+36,parents+96 if parentmask&2 else 0)
 before=snap();result=run(0xb00180)
 assert result==(count-1)&0xffffffff
 release.append({'pattern':pattern,'count':count,'flag':flag,'parent_mask':parentmask,'before':before,'after':snap(),'result':result,'calls':list(calls)})
propagate=[]
for pattern,owned,localflag,parentmask,mask,processed,globalcounter,count in itertools.product([0,0xa5],[False,True],[0,8],range(4),range(4),[0,1],[0,1],[0,2]):
 reset(pattern);w(source+28,owner if owned else 0);w(source+32,parents if parentmask&1 else 0);w(source+36,parents+96 if parentmask&2 else 0);w(source+56,wrapper if parentmask&2 else 0);u.mem_write(source+46,bytes([localflag]));w(owner,entries);w(owner+4,2);w(owner+12,0x44444444);u.mem_write(owner+48,count.to_bytes(2,'little')+bytes(2)+count.to_bytes(2,'little')+bytes(2));u.mem_write(owner+56,bytes([globalcounter]));w(entries,0x12345678);w(entries+12,0xabcdef);u.mem_write(entries+8,(2).to_bytes(2,'little')+(3).to_bytes(2,'little'));w(payload+4,0x12345678);u.mem_write(payload+16,mask.to_bytes(2,'little'));u.mem_write(payload+20,bytes([processed]))
 before=snap();result=run(0xaf0370)
 propagate.append({'pattern':pattern,'owned':owned,'local_flag':localflag,'parent_mask':parentmask,'mask':mask,'processed':processed,'global_counter':globalcounter,'count':count,'before':before,'after':snap(),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'release_case_count':len(release),'propagation_case_count':len(propagate),'release_cases':release,'propagation_cases':propagate,'native_addresses':len(visited),'limits':['Native source08 B00180 executes reference decrement, critical-section selection/order, terminal removal/destructor/parent/free ordering. OS locking and AF6650 manager key removal and derived source/parent callbacks are controlled mandatory boundaries.','Native source8C AF0370 with AFE760/AFE720/AFE690 executes owner counter wrapping, matching entry decrement and payload mask/processed-byte routing to three controlled parent callbacks. Owner list is nonempty; final entry and empty-owner release branches are excluded from this matrix.','Supplied source/manager/owner producers, physical concurrent locking, full Rust replay and physical output remain required.']}
(r/'data/4.20/audio_path_source_virtual_cleanup_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(release),'source08;',len(propagate),'source8C native cases')
