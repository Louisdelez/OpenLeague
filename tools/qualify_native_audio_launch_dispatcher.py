"""Original7067B0 selects actual bound706850 or unbound706910 post path."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
setup=(r/'tools/qualify_native_audio_unbound_post.py').read_text().split('\ncases=[]\n')[0]
setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
setup=setup.replace('assert 0x706910<=a<0x706a1d or 0x7072f0<=a<0x7072f4,hex(a)','assert 0x7067b0<=a<0x706a1d or 0x7072f0<=a<0x7072f4,hex(a)')
setup=setup.replace("assert struct.unpack('<I',u.mem_read(sp+4,4))[0]==0","assert struct.unpack('<I',u.mem_read(sp+4,4))[0]==(linked if callback_present else 0)")
exec(compile(setup,'unbound_setup','exec'));prior_hook=hook

def dispatch_hook(uc,a,size,user):
 if a==0x5642d0:
  sp=u.reg_read(UC_X86_REG_ESP);fmt,name=struct.unpack('<II',u.mem_read(sp+4,8));assert fmt==0x10ae3c8;calls.append({'kind':'format_failure','event':text_at(name)});ret();return
 if a==0x5fa170:
  sp=u.reg_read(UC_X86_REG_ESP);z,level,channel,fmt,name=struct.unpack('<5I',u.mem_read(sp+4,20));assert z==0 and fmt==0x10ae3c8;calls.append({'kind':'diagnostic','event':text_at(name)});ret();return
 prior_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,dispatch_hook)
cases=[]
for name,bound,pos,scratch_ok,callback_present,answer,age in itertools.product(['','event','Play_sfx_Env_Map10_Emitter_brazierchain'],[False,True],[[1.,2.,3.],[3.4028234663852886e38]*3,[3.4028234663852886e38,2.,3.]],[False,True],[False,True],[0,7],[0.,-0.,.0005,.5,-.5,2.,3000000.]):
 has_link=callback_present
 u.mem_write(string,b'\0'*24)
 if len(name)<16:u.mem_write(string,name.encode()+b'\0');capacity=15
 else:u.mem_write(heap+0x1000,name.encode()+b'\0');u.mem_write(string,struct.pack('<I',heap+0x1000));capacity=len(name)
 u.mem_write(string+16,struct.pack('<II',len(name),capacity));u.mem_write(position,struct.pack('<3f',*pos));u.mem_write(out,struct.pack('<I',0xfeedbeef));u.mem_write(scratch,struct.pack('<4I',obj,engine,linked if has_link else 0,0))
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<6If',end,out,obj if bound else 0,string,position,linked if callback_present else 0,age));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,engine);calls.clear();u.emu_start(0x7067b0,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
 result=u.reg_read(UC_X86_REG_EAX);output=struct.unpack('<I',u.mem_read(out,4))[0];retired=u.mem_read(scratch+12,1)[0];started=bool(name) and (bound or scratch_ok)
 assert result==(answer if started else 0);assert output==(obj if started else 0);assert retired==int(bool(name) and not bound and scratch_ok and answer==0)
 if not name:assert not calls
 else:
  if bound:
   assert not any(x['kind'] in ['allocate','position','linked_end'] for x in calls)
  if started:
   post=next(x for x in calls if x['kind']=='post');assert post['callback_raw']==((0x704a40 if callback_present else 0) if bound else 0x704a00) and post['cookie']==((linked if callback_present else 0) if bound else scratch),(name,bound,post)
  failed=(not started or answer==0);assert sum(x['kind']=='diagnostic' for x in calls)==int(failed)
  if failed:assert calls[-2:]==[{'kind':'format_failure','event':name},{'kind':'diagnostic','event':name}]
 cases.append({'event':name,'bound':bound,'position_bits':list(struct.unpack('<3I',struct.pack('<3f',*pos))),'scratch_available':scratch_ok,'linked_present':has_link,'callback_cookie':linked if callback_present else 0,'post_return':answer,'age_bits':struct.unpack('<I',struct.pack('<f',age))[0],'calls':list(calls),'result':result,'output_object_raw':output,'retired':retired})
proof={'passed':True,'cases':cases,'native_sha256':digest,'addresses':{'object':obj,'scratch':scratch},'limits':['Original7067B0 dispatcher and actual706850/706910/7072F0 executed. Dependencies reuse explicit scratch/position/Post/Seek/linked adapters; failure formatter/logger captured.','Empty event clears output and emits no failure diagnostic, unlike direct706910 empty-event preservation. Bound actor ignores supplied position/scratch creation and uses supplied linked/callback parameter as bound callback cookie, not actor pointer.','Nonempty playingID0 emits failure diagnostic after route-specific retirement/linked callback. Age seek and failure state preserved. Linked/callback parameter null or present forwarded to scratch allocation/unbound link or bound cookie; actual factory wrapper/path rewrite remains separate qualification.','No actual audio queue/mixer or client output measured.'],'complete':False}
(r/'data/4.20/audio_launch_dispatcher_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original bound/unbound dispatcher',len(cases),'cases passed')
