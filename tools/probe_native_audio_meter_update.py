from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
manager=heap+0x1000;allocator=heap+0x2000;vtable=heap+0x2100;effects=[heap+0x3000+i*0x100 for i in range(4)];calls=[]
put(allocator,'I',vtable);put(vtable+8,'I',trap+0x500);put(0x14a7a3c,'I',heap+0x9000)
regions=[(0xb3ebc0,0xb3ed26),(0xb3ed30,0xb3ed43),(0xb3f280,0xb3f2a2),(0xca2770,0xca2786),(0xca1e10,0xca1e3b)]
finit=trap+0x600;u.mem_write(finit,b'\xdb\xe3\xc3')
def guard(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==trap+0x500:calls.append({'kind':'free_effect','allocator':u.reg_read(UC_X86_REG_ECX),'object':read(sp+4,'I')[0]});ret(0,4);return
 if a==0xb12320:
  id,bits,owner,transition,mode=read(sp+4,'5I');calls.append({'kind':'set_rtpc','manager':u.reg_read(UC_X86_REG_ECX),'id':id,'bits':bits,'owner':owner,'transition':list(read(transition,'2I')),'mode':mode});ret(1,20);return
 if a==0xaeaf90:calls.append({'kind':'unregister_callback','callback':read(sp+4,'I')[0]});ret(0,0);return
 if a==0xada3e0:calls.append({'kind':'free_manager','allocator':read(sp+4,'I')[0],'object':read(sp+8,'I')[0]});ret(0,0);return
 if finit<=a<finit+3:return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard);rows=[]
for count in range(5):
 for mask,id_profile,value_profile,pattern in itertools.product(range(1<<count),range(3),range(3),[0,0xa5,0xff]):
  put(0x14a83c4,'I',manager);put(manager,'IIII',allocator,count,effects[0]if count else 0,effects[count-1]if count else 0);before=bytes(u.mem_read(manager,16)).hex();members=[]
  for i,ref in enumerate(effects[:count]):
   u.mem_write(ref,bytes([pattern])*84);put(ref,'I',0xff36d4);put(ref+4,'I',effects[i+1]if i+1<count else 0);u.mem_write(ref+80,bytes([255 if mask&(1<<i)else 0]));id=([100,101,102,103],[100]*4,[0,100,100,200])[id_profile][i];value=([0xc2400000,0xc1a00000,0xc2200000,0xc1200000],[0,0x80000000,0,0x80000000],[0xc1a00000,0xc1a00000,0xc2400000,0xc1a00000])[value_profile][i];put(ref+36,'I',value);put(ref+72,'I',0xc2700000+i);put(ref+76,'I',id);members.append({'reference':ref,'before':bytes(u.mem_read(ref,84)).hex()})
  calls.clear();sp=stack+0x8000;put(sp,'I',trap);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(finit,trap,count=10);put(sp,'II',trap,0x12345678);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0xb3ed30,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
  for member in members:member['after']=bytes(u.mem_read(member['reference'],84)).hex()
  rows.append({'count':count,'deferred_mask':mask,'id_profile':id_profile,'value_profile':value_profile,'pattern':pattern,'manager_before':before,'manager_after':bytes(u.mem_read(manager,16)).hex(),'global_manager':read(0x14a83c4,'I')[0],'members':members,'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Actual callback B3ED30/update B3EBC0, intrusive removals, native Meter destructor and aligned stack allocation execute. Effect allocator-free, manager free/unregister and RTPC set B12320 are explicit boundaries.'],'findings':['Deferred effects unlink before free, use cached48 value;active effects use24 value. ID0 is omitted;nonzero IDs aggregate max in first-seen order, ties choose incoming raw bits.','RTPC delivery occurs after removals for all aggregated IDs with owner0,transition[0,4],mode1. Empty queue unregisters callback,zeros manager/global and frees manager after deliveries.'],'limits':['Preparatory update/callback evidence, no Rust update port yet.','RTPC mutation/subscriber propagation,physical allocator lifetime and callback registration runtime remain mandatory producers.','Only finite negative values/signed-zero/ties and acyclic lists with0..4 members qualify comparison/removal behavior;NaN/infinity/cycles/malformed counts unqualified.','DSP Process B3E400 and audible output remain incomplete.']}
(r/'data/4.20/audio_meter_update_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual Meter callback/update/deferred release cases')
