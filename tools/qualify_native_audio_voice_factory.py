"""Original705A10 factory plus706C70/shared ownership helpers; backend adapted."""
from pathlib import Path
import json,itertools,struct
r=Path(__file__).resolve().parents[1]
# Reuse constructor harness setup; never run its test matrix on import.
setup=(r/'tools/qualify_native_audio_voice_constructor.py').read_text().split('cases=[]')[0]
setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(setup,'constructor_setup','exec'))
constructor_hook=hook
engine=heap+0x7000;output=heap+0x7100;object_ptr=heap+0x7200;object_vt=heap+0x7300;control=heap+0x7400;params=heap+0x7500
u.mem_write(object_ptr,struct.pack('<II',object_vt,123));u.mem_write(object_vt,struct.pack('<I',0x7072f0));u.mem_write(object_vt+0x18,struct.pack('<I',0x7074e0));u.mem_write(end+0x300,b'\xc3')
def read(a,fmt):return struct.unpack('<'+fmt,u.mem_read(a,struct.calcsize('<'+fmt)))
def write(a,fmt,*v):u.mem_write(a,struct.pack('<'+fmt,*v))
def factory_hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==0xaea430:
  ptr=read(sp+4,'I')[0];name=bytes(u.mem_read(ptr,128)).split(b'\0',1)[0].decode('ascii');value=0x811c9dc5
  for ch in name.lower().encode():value=((value*16777619)^ch)&0xffffffff
  calls.append({'kind':'hash','name':name,'value':value});ret(value);return
 if a==0x7067b0:
  out,actor,event,p,flag,age_bits=read(sp+4,'6I');assert ecx==engine and actor==0 and event==play and p==params and flag==0 and age_bits==struct.unpack('<I',struct.pack('<f',age))[0]
  write(out,'I',object_ptr if object_ok else 0);calls.append({'kind':'launch','playing_id':playing_id,'object_present':object_ok,'age_bits':age_bits});ret(playing_id,24);return
 if a==0x704a80:
  assert read(sp+4,'I')[0]==play;name='Stop_'+text_at(play)[5:];string_at(u.reg_read(UC_X86_REG_EDX),name,heap+0x5000);write(ecx,'I',456 if stop_found else 0);calls.append({'kind':'resolve_stop','found':stop_found});ret();return
 if a==0x9933e0:
  size=read(sp+4,'I')[0];assert size in [76,16];calls.append({'kind':'allocate','bytes':size,'success':voice_ok if size==76 else control_ok});ret((voice if voice_ok else 0) if size==76 else (control if control_ok else 0));return
 if a==0x7074e0:
  assert ecx==object_ptr;ptr,ctrl=read(sp+4,'2I');calls.append({'kind':'associate','voice_present':ptr!=0,'control_present':ctrl!=0})
 if a==0x564900:calls.append({'kind':'destroy_stop_string'});ret();return
 if a==0xc975f5:ret();return
 if 0x706c70<=a<0x706d62 or a in [0x564af0,end+0x100,end+0x200] or end+0x100<=a<end+0x109:
  constructor_hook(uc,a,size,user);return
 assert any(s<=a<e for s,e in [(0x705a10,0x705bcc),(0x7072f0,0x7072f4),(0x5d1fa0,0x5d2050),(0x5cc070,0x5cc0f0),(0x5c1df0,0x5c1e25),(0x5bd3c0,0x5bd3f3),(0x7074e0,0x7075a3),(0x707f20,0x707f89),(0x5bde40,0x5bdea0)]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,factory_hook)
cases=[]
for available,playing_id,object_ok,voice_ok,control_ok,stop_found,name,age in itertools.product([False,True],[0,7],[False,True],[False,True],[False,True],[False,True],['event','Play_sfx_Env_Map10_Emitter_brazierchain'],[0.,.5]):
 ready=True;fatal=False;u.mem_write(voice,b'\xa5'*76);u.mem_write(control,b'\0'*16);u.mem_write(output,b'\xa5'*8);write(object_ptr+0x1c,'3I',heap+0x8000,heap+0x8000,heap+0x8100);string_at(play,name,heap+0x1000);write(0x2d791a8,'I',clock);write(heap+0x500,'f',1000.25);u.mem_write(engine+12,bytes([int(available)]));write(0,'I',0)
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<6If',end,output,play,0,params,0,age));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,engine);calls.clear();u.emu_start(0x705a10,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end and not fatal and u.reg_read(UC_X86_REG_EAX)==output
 ptr,ctrl=read(output,'2I');proceeded=available and playing_id!=0 and object_ok
 assert (ptr,ctrl)==((voice if voice_ok else 0,control if control_ok else 0) if proceeded else (0,0))
 assert sum(x['kind']=='associate' for x in calls)==int(proceeded)
 state=None
 if proceeded and voice_ok:
  _,pid,oid,record=read(voice,'4I');sid=read(voice+40,'I')[0];flags=list(u.mem_read(voice+72,2));state={'playing_id':pid,'object_id':oid,'expected_record_raw':record,'stop_event_id':sid,'clock_bits':read(voice+68,'I')[0],'flags':flags};assert (pid,oid,sid,flags)==(7,123,456 if stop_found else 0,[0,1])
 if proceeded and control_ok:assert read(control+4,'3I')==(1,2 if voice_ok else 1,voice if voice_ok else 0)
 cases.append({'engine_available':available,'playing_id':playing_id,'object_present':object_ok,'voice_allocation_ok':voice_ok,'control_allocation_ok':control_ok,'stop_found':stop_found,'event':name,'age_bits':struct.unpack('<I',struct.pack('<f',age))[0],'voice_present':ptr!=0,'control_present':ctrl!=0,'strong_count':read(control+4,'I')[0] if ctrl else None,'weak_count':read(control+8,'I')[0] if ctrl else None,'associated_entries':(read(object_ptr+0x20,'I')[0]-(heap+0x8000))//8,'state':state,'calls':list(calls)})
proof={'passed':True,'cases':cases,'native_sha256':digest,'limits':['Original705A10 factory,706C70 constructor and shared helpers5D1FA0/5CC070/5C1DF0/5BD3C0 executed. Engine launch7067B0, stop resolution704A80, allocators, string operations, clock inputs and actual object association7074E0/weak append707F20/copy5BDE40 executed; remaining backend calls explicitly adapted.','Object association consumes a shared copy and stores weak ownership. Final strong count1 belongs to output only; weak count2 includes association plus implicit live control reference when voice exists. Supersedes earlier adapter strong-retention assumption.','Native allocates a control block even for null voice; failed control allocation can return non-null raw voice without shared control. Neither condition is silently normalized to successful managed playback.','Clock-ready normal path only in factory; missing/not-ready constructor branches separately qualified. No actual audio playback or shared final destructors executed.'],'complete':False}
(r/'data/4.20/audio_voice_factory_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original physical voice factory',len(cases),'cases passed')
