from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
target=vector+0x10000;props=vector+0x11000;params=vector+0x12000;calls=[];adapter_result=1
w(0x12100f4,48000)
def hook(uc,a,size,user):
 if a==0xaf0500:
  sp=uc.reg_read(UC_X86_REG_ESP);calls.append(dict(value=struct.unpack('<f',uc.mem_read(sp+4,4))[0],params=read(sp+8)));finish(adapter_result,8)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for value,bypass,existing,adapter_result in itertools.product([-1.,0.,.5,1.],[False,True],[False,True],[1,2,15]):
 u.mem_write(target,bytes(128));u.mem_write(props,bytes(16));u.mem_write(params,bytes(176));w(target+0x28,props);u.mem_write(props,b'\x01\x19');u.mem_write(props+4,struct.pack('<f',value));u.mem_write(params+0x82,bytes([int(bypass)]));w(params+0x7c,int(existing));w(params+0x74,123);calls.clear()
 call(0xaf1c50,target,struct.pack('<I',params))
 deferred=value>0 and not bypass and not existing
 expected=(3 if adapter_result==1 else adapter_result) if deferred else 1
 assert u.reg_read(UC_X86_REG_EAX)==expected
 assert len(calls)==int(deferred)
 if calls:assert calls[0]==dict(value=value,params=params)
 assert read(params+0x74)==123+(int(value*48000) if value>0 and not bypass and existing else 0)
 assert bytes(u.mem_read(params+0x82,1))==b'\0'
 rows.append(dict(value=value,bypass=bypass,existing=existing,deferred_result=adapter_result,result=expected,delay=read(params+0x74),deferred_calls=list(calls)))
proof=dict(passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(rows),cases=rows,findings=['AF1C50 consumes bypass flag82, otherwise reads property25. Nonpositive values return1.','Positive delay with existing context adds actual AF2500 conversion to params74; 48000 supplied rate.','Without existing context AF0500 is called; success1 becomes3, other result codes propagate.'],adapters=['Deferred scheduling endpoint AF0500 captured with supplied results1/2/15; all gate and conversion instructions execute.','No RTPC bits or random range map; supplied property25 and rate48000.'],limits=['Actual AF0500 scheduling, RTPC/random delay, target virtual13C and cleanup remain open. Not a playback proof.'])
(r/'data/4.20/audio_action_dispatch_gate.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native dispatch gate cases')
