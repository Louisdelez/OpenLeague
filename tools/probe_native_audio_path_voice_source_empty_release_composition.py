from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x4000;owner=vector+0x5000;wrapper=vector+0x7000;calls=[];visited=set();freed=set()
parents=[vector+0x8000+j*512 for j in range(3)];parent_owners=[vector+0x9000+j*512 for j in range(3)];tables=[vector+0xa000+j*512 for j in range(3)];buffers=[vector+0xb000+j*512 for j in range(3)]
def snap():return {'source':bytes(u.mem_read(source,96)).hex(),'owner':bytes(u.mem_read(owner,60)).hex(),'wrapper':bytes(u.mem_read(wrapper,16)).hex(),'parents':[{'reference':ref,'raw':bytes(u.mem_read(ref,96)).hex()}for ref in parents],'parent_owners':[{'reference':ref,'raw':bytes(u.mem_read(ref,60)).hex()}for ref in parent_owners],'tables':[{'reference':ref,'raw':bytes(u.mem_read(ref,16)).hex()}for ref in tables],'buffers':[{'reference':ref,'raw':bytes(u.mem_read(ref,32)).hex()}for ref in buffers]}
def hook(uc,a,size,data):
 if a==0xafe9c0:calls.append({'kind':'release_empty_source','source':u.reg_read(UC_X86_REG_ECX),'owner_at_call':bytes(u.mem_read(owner,60)).hex()})
 if a==0xb01360:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'remove_parent_source','parent':u.reg_read(UC_X86_REG_ECX),'source':read(sp+4)});return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);pool,ref=read(sp+4),read(sp+8);assert pool==19 and ref in [owner]+buffers and ref not in freed;freed.add(ref);calls.append({'kind':'free','pool':pool,'reference':ref,'source_at_call':bytes(u.mem_read(source,96)).hex(),'owner_at_call':bytes(u.mem_read(owner,60)).hex()});finish(1);return
 assert 0xaeea00<=a<=0xaeea6e or 0xafe9c0<=a<=0xafea20 or 0xafde90<=a<=0xafdf1a or 0xb01360<=a<=0xb0139f,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,present,parent_profile,buffer_mask,gate in itertools.product([0,0xa5],[True],['none','singleton','missing','duplicate'],[0,1,5,7],range(6)):
 calls.clear();freed.clear();u.mem_write(source,bytes([pattern])*96);w(source+28,owner if present else 0);w(source+32,parents[0]if parent_profile!='none'else 0);w(source+36,parents[1]if parent_profile!='none'else 0);w(source+56,wrapper if parent_profile!='none'else 0);u.mem_write(wrapper,bytes([pattern])*16);w(wrapper,parents[2]);u.mem_write(owner,bytes([pattern])*60)
 for j,(pointer,count,capacity)in enumerate([(0,4,8),(16,20,24),(36,40,44)]):w(owner+pointer,buffers[j]if buffer_mask&(1<<j)else 0);w(owner+count,0);w(owner+capacity,8);u.mem_write(buffers[j],bytes([0x33])*32)
 w(owner+12,0)
 for j in range(4):u.mem_write(owner+48+j*2,(1 if gate==j+1 else 0).to_bytes(2,'little'))
 if gate==5:w(owner+4,1)
 for parent,descriptor,table in zip(parents,parent_owners,tables):
  u.mem_write(parent,bytes([pattern])*96);w(parent+28,descriptor);u.mem_write(descriptor,bytes([pattern])*60);w(descriptor+36,table);values=[source]if parent_profile=='singleton'else[source+512,source+1024,source+1536]if parent_profile=='missing'else[source,source+512,source]if parent_profile=='duplicate'else[];w(descriptor+40,len(values));w(descriptor+44,4);u.mem_write(table,bytes([pattern])*16)
  for j,value in enumerate(values):w(table+j*4,value)
 w(0x12100dc,19);before=snap();w(stack,end);w(stack+4,source+1536);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xaeea00,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'present':present,'parent_profile':parent_profile,'buffer_mask':buffer_mask,'gate':gate,'before':before,'after':snap(),'calls':list(calls),'freed':sorted(freed)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaeea00','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AEEA00 empty-owner gate invokes actual AFE9C0, or blocks all cleanup on one of four half48..54/count4 gates. Actual AFE9C0 removes source from three optional parent collections using actual B01360 first-match/swap-last; actual AFDE90 frees owner buffers in16/0/36 order with counter/capacity resets and head12 clear; owner allocation freed before source28 zero. Full source/owner/parent/array/buffer padding and free-time states captured. Physical allocator/free transports supplied. Source construction, aliases/malformed state, outer cleanup chain and Rust replay remain required.']}
(r/'data/4.20/audio_path_voice_source_empty_release_composition_preparation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'actual empty-source parent removal/owner destruction/physical free cases')
