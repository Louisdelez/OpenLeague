from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x1000;actions=vector+0x2000;properties=vector+0x3000;owners=vector+0x5000;tables=vector+0x8000;input=vector+0x9000;vtable=vector+0x9100;calls=[];visited=set();w(input,vtable);w(vtable+0x9c,vector+0xf000);w(0x14a7a24,vector+0xa000)
def snap():return {n:bytes(u.mem_read(a,size)).hex()for n,a,size in [('source',source,96),('actions',actions,64),('properties',properties,128),('owners',owners,384),('tables',tables,96)]}
def hook(uc,a,size,data):
 if a==0xaf5b90:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'release_owner','receiver':u.reg_read(UC_X86_REG_ECX),'owner':read(sp+4),'key':read(sp+8)});return
 if a==vector+0xf000:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'input_virtual9c','receiver':u.reg_read(UC_X86_REG_ECX),'selector':read(sp+4),'at_call':snap()});finish(0,4);return
 assert 0xafec20<=a<0xafec9d or 0xaf5b90<=a<0xaf5bf8,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,action_count,property_count,present,kind,counter in itertools.product([0,0xa5],[0,1,2],[0,1,3],[False,True],['first','missing','duplicate'],[0,1,3]):
 for a,size in[(source,96),(actions,64),(properties,128),(owners,384),(tables,96)]:u.mem_write(a,bytes([pattern])*size)
 w(source+16,actions if action_count else 0)
 for i in range(2):
  action=actions+i*32;blob=properties+i*64;w(action+8,actions+32 if i+1<action_count else 0);w(action+12,input);w(action+16,blob if property_count else 0);u.mem_write(blob,bytes([property_count]));u.mem_write(blob+1,bytes([7])*property_count)
  for j in range(3):
   owner=owners+(i*3+j)*64;table=tables+(i*3+j)*16;slot=blob+((property_count+4)&~3)+j*8;w(slot,0x100+j);w(slot+4,owner if present and j!=1 else 0);w(owner+32,table);w(owner+36,3);w(owner+48,0x11223344);u.mem_write(owner+53,bytes([counter]))
   for k in range(3):w(table+k*4,action if kind=='duplicate'or kind=='first'and k==0 else action+0x100+k*4)
 calls.clear();before=snap();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xafec20,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'action_count':action_count,'property_count':property_count,'present':present,'kind':kind,'counter':counter,'before':before,'after':snap(),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AFEC20 source action traversal, packed property-count/alignment, live owner release AF5B90 and cleared owner-slot before input9C selector3 execute. Source/action list and final storage preserved.','Input virtual9C callback is a mandatory controlled boundary; constructors, malformed/cyclic/alias storage, Rust replay and full source terminal integration remain required.']}
(r/'data/4.20/audio_path_source_action_owner_release_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'source action/owner release native cases')
