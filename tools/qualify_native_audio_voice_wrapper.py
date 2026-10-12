"""Original6F79D0 +6F61E0 +7042C0 execution with factory/provider adapters."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text().split("hash_inputs=")[0].replace("u.hook_add(unicorn.UC_HOOK_CODE,hook)","")
exec(compile(source,str(r/'tools/qualify_native_audio_legacy_paths.py'),'exec'))
legacy_hook=hook
factory=end+0x200;query=end+0x300
write32(0x2d78b98,heap+0x700);write32(heap+0x700,heap+0x800);write32(heap+0x840,factory);write32(heap+0x870,query)
trace=[];factory_calls=[];height_enabled=False
# Existing cache is empty. Test cache presence activates path conversion; not a success flag.
u.mem_write(heap+0x600,b'\0'*64);u.mem_write(heap+0x60d,b'\1');write32(heap+0x604,heap+0x600)
def wrapper_hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==query:
  trace.append('height');finish(eax=int(height_enabled));return
 if a==0x5c0540:
  assert read32(sp+8)==0 and read32(sp+12)==1 and cbytes(read32(sp+4))[:1]==b'/'
  trace.append('find');i=string(u.reg_read(UC_X86_REG_ECX)).find('/');finish(12,i if i>=0 else 0xffffffff);return
 if a==provider:trace.append('provider')
 if a==factory:
  out,event,actor,position,linked,age=[read32(sp+i) for i in (4,8,12,16,20,24)]
  trace.append('factory');factory_calls.append({'event':string(event),'actor_identity':actor,'position_bits':list(struct.unpack('<III',u.mem_read(position,12))),'callback_identity':linked,'age_bits':age})
  write32(out,0x11112222);write32(out+4,0x33334444);finish(24,out);return
 if 0x6f79d0<=a<=0x6f7ac6 or 0x6f61e0<=a<0x6f62b6:return
 legacy_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,wrapper_hook)
maximum=struct.unpack('<f',bytes.fromhex('ffff7f7f'))[0]
paths=['','Play_Test','/Dialogue/Announcer/Classic/Welcome.mp3','/dialogue/announcer/Classic/Welcome.mp3','other/path.wav']
cases=[]
for event,cache_enabled,position,mode,height_enabled,actor,linked,age in itertools.product(paths,[False,True],[[1.,2.,3.],[maximum]*3,[1.,maximum,3.]],[0,1,255],[False,True],[0,123],[0,456],[-.25,0.,.125]):
 cursor=heap+0x4000;response='Explicit_Announcer_Event';trace=[];factory_calls=[];calls=[]
 put(heap+0xa00,event);u.mem_write(heap+0xb00,struct.pack('<fff',*position));u.mem_write(heap+0xc00,b'\xa5'*8);write32(0x2d78b90,heap+0x500 if cache_enabled else 0);u.mem_write(0x2d78bac,struct.pack('<f',500.))
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<IIIIIf',end,actor,heap+0xb00,mode,linked,age));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap+0xc00);u.reg_write(UC_X86_REG_EDX,heap+0xa00);u.emu_start(0x6f79d0,end,count=100000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==heap+0xc00
 assert list(struct.unpack('<II',u.mem_read(heap+0xc00,8)))==[0x11112222,0x33334444]
 expected_position=position.copy();expected_trace=[]
 if position!=[maximum]*3:
  if mode==0:expected_position[1]=-2500.
  else:
   expected_trace.append('height')
   if height_enabled:expected_position[1]=500.
 expected_event=event
 if cache_enabled:
  expected_trace.append('find')
  if '/' in event:
   if '/Dialogue/Announcer/' in event:expected_event=response;expected_trace.append('provider')
   else:expected_event=''
 expected_trace.append('factory')
 expected={'event':expected_event,'actor_identity':actor,'position_bits':list(struct.unpack('<III',struct.pack('<fff',*expected_position))),'callback_identity':linked,'age_bits':struct.unpack('<I',struct.pack('<f',age))[0]}
 assert factory_calls==[expected] and trace==expected_trace,(event,trace,expected_trace,factory_calls,expected)
 cases.append({'event':event,'cache_enabled':cache_enabled,'position_bits':list(struct.unpack('<III',struct.pack('<fff',*position))),'mode_raw':mode,'height_enabled':height_enabled,'height_bits':struct.unpack('<I',struct.pack('<f',500.))[0],'actor_identity':actor,'callback_identity':linked,'age_bits':expected['age_bits'],'factory_request':factory_calls[0],'trace':trace})
proof={'native_sha256':digest,'passed':True,'cases':cases,'complete':False,'limits':['Original wrapper, position preparation, path parsing/hash/cache and provider dispatch executed. Native engine virtual40 and service virtual10 are explicit adapters; CRT/string/security adapters inherited.','Empty/unrecognized path forwarded to factory as empty event when conversion enabled; plain events bypass conversion. Factory output propagated unchanged.','Only finite position/age, ASCII/no-NUL events, empty native cache and explicit height500 tested here; native cache-hit behavior separately128cases.','No actual engine creation/mixing/audio output or full game acceptance.']}
(r/'data/4.20/audio_voice_wrapper_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original voice wrapper {len(cases)} cases passed')
