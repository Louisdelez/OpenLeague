from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x1000;actions=vector+0x2000;tables=vector+0x3000;props=vector+0x4000;children=vector+0x5000;childprops=vector+0x6000;owner=vector+0x7000;voices=vector+0x8000;calls=[];visited=set();allocated=0;allocation_failure=False;w(0x12100dc,19)
regions=[('source',source,160),('actions',actions,128),('tables',tables,96),('properties',props,256),('children',children,320),('child_properties',childprops,128),('owner',owner,64),('voices',voices,1272),('heap',vector+0x10000,1024),('property_owners',vector+0x14000,384),('owner_tables',vector+0x15000,192),('inputs',vector+0x17000,512),('conversion_cache',0x14a7970,8)]
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
 if a==0xaf5670:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'update_property_owner','receiver':u.reg_read(UC_X86_REG_ECX),'arguments':[read(sp+4+j*4)for j in range(6)],'at_call':snap()});return
 if a==0xaf5b90:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'release_property_owner','receiver':u.reg_read(UC_X86_REG_ECX),'owner':read(sp+4),'key':read(sp+8),'at_call':snap()});return
 if a==vector+0x1f040:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'input_virtual9c','receiver':u.reg_read(UC_X86_REG_ECX),'selector':read(sp+4),'at_call':snap()});finish(0,4);return
 if a in [0xaf3420,0xaee780,0xafebb0,0xaefe40]:
  sp=u.reg_read(UC_X86_REG_ESP);d={'kind':{0xaf3420:'source_virtualcc',0xaee780:'clear_voice_flags',0xafebb0:'release_action_owners',0xaefe40:'append_property'}[a],'receiver':u.reg_read(UC_X86_REG_ECX),'at_call':snap()}
  if a==0xaefe40:d['type']=read(sp+4)
  calls.append(d);return
 assert 0xaf5670<=a<0xaf5944 or 0xaf5b90<=a<0xaf5bf8 or 0xaffcb0<=a<0xaffe4c or 0xaf3420<=a<0xaf3440 or 0xaee780<=a<0xaee78f or 0xafebb0<=a<0xafec20 or 0xaefe40<=a<0xaefeec,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,pc,cc,kind,allocation_failure,owner_flags in itertools.product([0,0xa5],[0,1,2],[0,1,3],[0,1,3],['missing','null','present'],[False,True],[0,3]):
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
 w(0x14a7a24,vector+0x18000);w(0x14a7a28,vector+0x16000);w(vector+0x16000+124,31);w(0x12100f8,48);u.mem_write(0x14a7970,bytes(8));w(vector+0x19000+0x9c,vector+0x1f040)
 for i in range(2):
  action=actions+i*64;prop=props+i*128;pa=(pc+4)&~3;inp=vector+0x17000+i*256;w(inp,vector+0x19000);w(action+12,inp)
  for j in range(3):
   property_owner=vector+0x14000+(i*3+j)*64;owner_table=vector+0x15000+(i*3+j)*32;w(property_owner,5+j);w(property_owner+4,0x3f800000);w(property_owner+8,0x40000000);w(property_owner+12,0xc0400000);w(property_owner+32,owner_table);w(property_owner+36,1);w(owner_table,action);w(property_owner+48,0);u.mem_write(property_owner+52,bytes([owner_flags,1]))
   if j<pc:w(prop+pa+j*8+4,property_owner)
 u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 allocated=0;calls.clear();before=snap();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xaffcb0,end,count=12000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'action_count':count,'property_count':pc,'child_property_count':cc,'kind':kind,'allocation_failure':allocation_failure,'owner_flags':owner_flags,'before':before,'after':snap(),'calls':list(calls)})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AFFCB0 nonempty action/property match and missing-child branches, AFEBB0 actual AF5B90 nonzero owner release with cleared pair owner before required input9C, AFEE40 actual allocate/copy/free/publish and allocation failure paths and AF3420/AEE780 voice traversal execute. Exact float bits including negative zero and NaN copied; complete banks and callback snapshots captured.','Allocator/free/CRTmemcpy are explicit ABI adapters with caller supplied physical heap. Exact requested size, call ordering and memory at every boundary captured. Actual nonzero property owner AF5670 executes with flag0/3, original float conversions/cache, current clock31 and frame quantum48; AF5B90 release executes with canonical owner/table. Input9C is an explicitly controlled required callback, captured only after clearing the pair owner. Rust replay, full input behavior, other conversion flags/operation/clock/timing variants remain required. Constructors, aliases and Rust replay remain open.']}
(r/'data/4.20/audio_path_source_virtuald0_owned_properties_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual sourceD0 property cases, with actual append/copy/free paths and explicit allocator/CRT ABI boundaries')
