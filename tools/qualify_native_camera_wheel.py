from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
exec(compile((r/'tools/qualify_native_camera_random_shake.py').read_text(encoding='utf-8').split('sequences=[]')[0],'setup','exec'))
allowed.extend([(0x7d01c0,0x7d0297),(0x8b1c20,0x8b1c21)])
state=heap+0x9000;event=heap+0xa000;calls=[];config_value=0

def config_hook(uc,a,size,user):
 if a==0x8b1c20:
  sp=u.reg_read(UC_X86_REG_ESP);section=cbytes(u.reg_read(UC_X86_REG_ECX)).decode();key=cbytes(u.reg_read(UC_X86_REG_EDX)).decode();args=[read32(sp+4),read32(sp+8)]
  assert (section,key,args)==('Replay','CameraZoomToMinMaxEnable',[0,0]),(section,key,args)
  calls.append({'section':section,'key':key,'args':args,'return':config_value})
  finish(eax=config_value)
u.hook_add(unicorn.UC_HOOK_CODE,config_hook)
cases=[]
for target,delta,flags,cached,override in itertools.product([0,0x80000000,*bits([999.,1000.,1001.,1500.,2249.,2250.,2251.]),0x7f800000,0xff800000,0x7fc01234],[0,1,-1,120,-120,1250,-1250,0x7fffffff,-0x80000000],[0,1,0xa0,0xa1],[0,2],[0,1,-1]):
 config_value=override&0xffffffff;calls=[]
 initial=[0xa5a50000+i for i in range(128)];initial[0x1bc//4]=target;u.mem_write(state,struct.pack('<128I',*initial))
 u.mem_write(event,bytes(0x50));write32(event+0x4c,delta&0xffffffff);write32(0x2d827ac,flags);u.mem_write(0x2d827b0,bytes([cached]));run(0x7d01c0,[event],ecx=state)
 out=list(struct.unpack('<128I',u.mem_read(state,512)));assert all(a==b for i,(a,b) in enumerate(zip(initial,out)) if i!=0x1bc//4)
 assert len(calls)==(0 if flags&1 else 1)
 cases.append({'target_bits':target,'delta':delta,'flags':flags,'cached_raw':cached,'config_override':override,'output_target_bits':out[0x1bc//4],'output_flags':read32(0x2d827ac),'output_cached_raw':u.mem_read(0x2d827b0,1)[0],'getter_calls':calls})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Full7D01C0 mousewheel handler executed; event signed delta at+4C supplied. Only controller target+1BC mutates.','8B1C20 integer config getter adapted with validated Replay/CameraZoomToMinMaxEnable/default0 arguments; original configuration-file lookup not qualified. First call caches boolean return and sets initflag bit0; existing other bits preserved.','Original event producer and UI capture/eligibility remain unqualified. Windows winit0.30.13 converts raw WHEEL_DELTA120 to line units; reconstructing that conversion does not prove original event producer.','Native exceptional NaN output payloads retained as emulator evidence; cross-host SNAN payload qualification excluded. Full game incomplete.']}
(r/'data/4.20/camera_wheel_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Native wheel handler:',len(cases),'cases')
