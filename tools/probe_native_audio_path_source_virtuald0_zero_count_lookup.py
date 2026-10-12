from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x1000;actions=vector+0x2000;tables=vector+0x3000;props=vector+0x4000;children=vector+0x5000;childprops=vector+0x6000;owner=vector+0x7000;voices=vector+0x8000;calls=[];visited=set();allocated=0;allocation_failure=False;w(0x12100dc,19)
regions=[('source',source,160),('actions',actions,128),('tables',tables,96),('properties',props,256),('children',children,320),('child_properties',childprops,128),('owner',owner,64),('voices',voices,1272),('heap',vector+0x10000,1024)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,size,data):
 global allocated
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);result=0 if allocation_failure else vector+0x10000+allocated*128;assert read(sp+8)<=128;calls.append({'kind':'allocate','pool':read(sp+4),'size':read(sp+8),'result':result,'at_call':snap()});allocated+=int(not allocation_failure);assert allocated<=8;finish(result);return
 if a==0xca1ef0:
  sp=u.reg_read(UC_X86_REG_ESP);dest,src,n=read(sp+4),read(sp+8),read(sp+12);calls.append({'kind':'memcpy','destination':dest,'source':src,'size':n,'at_call':snap()});
  if n:u.mem_write(dest,bytes(u.mem_read(src,n)))
  finish(dest);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'free','pool':read(sp+4),'reference':read(sp+8),'at_call':snap()});finish(1);return
 if a in [0xaf3420,0xaee780,0xafebb0,0xaefe40]:
  sp=u.reg_read(UC_X86_REG_ESP);d={'kind':{0xaf3420:'source_virtualcc',0xaee780:'clear_voice_flags',0xafebb0:'release_action_owners',0xaefe40:'append_property'}[a],'receiver':u.reg_read(UC_X86_REG_ECX),'at_call':snap()}
  if a==0xaefe40:d['type']=read(sp+4)
  calls.append(d);return
 assert 0xaffcb0<=a<0xaffe4c or 0xaf3420<=a<0xaf3440 or 0xaee780<=a<0xaee78f or 0xafebb0<=a<0xafec20 or 0xaefe40<=a<0xaefeec,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,pc,cc,kind,allocation_failure,padding_type in itertools.product([0,0xa5],[1],[0],[1,3],['present'],[False,True],[0,5,6]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 w(source,0xff1cd8);w(source+16,actions if count else 0);w(source+28,owner);w(owner+12,voices)
 for i in range(3):
  v=voices+i*424;w(v+16,v+424 if i<2 else 0)
 for i in range(2):
  action=actions+i*64;table=tables+i*48;prop=props+i*128;child=children+i*160;cp=childprops+i*64
  w(action+8,actions+64 if i+1<count else 0);w(action+16,prop);w(action+20,table);w(action+24,3);w(action+36,0x1234+i);w(child+16,cp)
  for j in range(3):w(table+j*12,0x1234+i if j==1 and kind!='missing'else 0x2234+j);w(table+j*12+4,0 if kind=='null'else child)
  u.mem_write(prop,bytes([pc]));u.mem_write(cp,bytes([cc]));pa=(pc+4)&~3;ca=(cc+4)&~3
  for j in range(pc):u.mem_write(prop+1+j,bytes([5+j]));w(prop+pa+j*8,0x3f000000+j);w(prop+pa+j*8+4,0)
  for j in range(cc):u.mem_write(cp+1+j,bytes([5+j]));w(cp+ca+j*4,[0x3f800001,0x80000000,0x7fc01234][j])
 for i in range(2):
  prop=props+i*128;u.mem_write(prop+1,bytes([padding_type]));w(prop+8,0)
 allocated=0;calls.clear();before=snap();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xaffcb0,end,count=12000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'action_count':count,'property_count':pc,'child_property_count':cc,'kind':kind,'allocation_failure':allocation_failure,'padding_type':padding_type,'before':before,'after':snap(),'calls':list(calls)})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Present zero-count action property blob still has its first type byte read by original D0 lookup. Supplied padding type0/5/6 demonstrates phantom pair update versus append; owner word is explicitly0. All native copied/retained bytes, allocations/free snapshots and CC/voices captured. This edge cannot be normalized into an empty logical vector before native propagation.','Actual AFFCB0 nonempty action/property match and missing-child branches, AFEBB0 zero-owner release, AFEE40 actual allocate/copy/free/publish and allocation failure paths and AF3420/AEE780 voice traversal execute. Exact float bits including negative zero and NaN copied; complete banks and callback snapshots captured.','Allocator/free/CRTmemcpy are explicit ABI adapters with caller supplied physical heap. Exact requested size, call ordering and memory at every boundary captured. Nonzero property owner AF5670/AF5B90/input9C still require qualification. Constructors, aliases and Rust replay remain open.']}
(r/'data/4.20/audio_path_source_virtuald0_zero_count_lookup_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual sourceD0 property cases, with actual append/copy/free paths and explicit allocator/CRT ABI boundaries')
