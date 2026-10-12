"""Compare live client listener records with original native backend routines."""
from pathlib import Path
import json,sys,struct,hashlib,math,datetime
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/audio_listener_backend_contract.json').read_text());raw=Path(c['provenance']['executable']).read_bytes();assert hashlib.sha256(raw).hexdigest()==c['provenance']['sha256'];p=pefile.PE(data=raw);base=p.OPTIONAL_HEADER.ImageBase
areas=[(int(v['start'],16),int(v['end'],16)) for v in c['regions']]
for v in c['regions']:assert hashlib.sha256(p.get_data(int(v['start'],16)-base,int(v['end'],16)-int(v['start'],16))).hexdigest()==v['sha256']
heap,stack,trap=0x30000000,0x31000000,0x32000000;u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x10000)
u.mem_write(trap+0x100,b'\xdb\xe3');messages=[]
def hook(uc,a,n,d):
 if a in [0xb08990,0xb05ed0,0xc975f5]:
  sp=uc.reg_read(UC_X86_REG_ESP);ret=struct.unpack('<I',uc.mem_read(sp,4))[0];extra=0
  if a==0xb05ed0:
   ptr=struct.unpack('<I',uc.mem_read(sp+4,4))[0];message=uc.mem_read(ptr,0x38);assert struct.unpack('<H',message[2:4])[0]==16;messages.append(list(struct.unpack('<9f',message[12:48])));extra=8;uc.reg_write(UC_X86_REG_EAX,1)
  elif a==0xb08990:uc.reg_write(UC_X86_REG_EAX,5)
  uc.reg_write(UC_X86_REG_ESP,sp+4+extra);uc.reg_write(UC_X86_REG_EIP,ret);return
 assert any(x<=a<z for x,z in areas) or a==trap+0x100,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def call(fn,args,this=0):
 u.emu_start(trap+0x100,trap+0x102);sp=stack+0x8000;u.mem_write(sp,struct.pack('<I',trap)+args);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this);u.emu_start(fn,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
trace_path=r/'logs/audio_listener_runtime_trace.json';trace=json.loads(trace_path.read_text());assert len(trace)==16,'Wait until the running client has produced all16 samples';checks=[]
for i,s in enumerate(trace):
 assert s['snapshot_tick'] is not None and s['player_id'] is not None and not s['ambient_playback_enabled']
 assert all(math.isfinite(v) for v in s['packed_frame']+s['cached_basis']);assert s['distance_scale']==1. and s['dirty']
 focus=s['focus_world'];expected=[focus[0]*20.,500.,15398.671875-focus[2]*20.]
 assert max(abs(a-b) for a,b in zip(s['position'],expected))<.002
 assert s['packed_frame'][6:9]==s['position']
 u.mem_write(heap,struct.pack('<I',0x10af384));u.mem_write(heap+0xc,b'\1');
 for address,data in [(heap+0x100,s['position']),(heap+0x200,s['raw_forward']),(heap+0x300,s['raw_up'])]:u.mem_write(address,struct.pack('<3f',*data))
 messages.clear();call(0x705e30,struct.pack('<4I',heap+0x100,heap+0x200,heap+0x300,0),heap);assert len(messages)==1
 expected_frame=messages[0];assert struct.pack('<9f',*expected_frame)==struct.pack('<9f',*s['packed_frame']),('frame',i)
 u.mem_write(heap+0x400,struct.pack('<9f',*expected_frame));call(0xb1a0b0,struct.pack('<II',0,heap+0x400));basis=bytes(u.mem_read(0x14a7e60+0x50,36));assert basis==struct.pack('<9f',*s['cached_basis']),('basis',i)
 checks.append({'sample':i,'elapsed_seconds':s['elapsed_seconds'],'snapshot_tick':s['snapshot_tick'],'frame_exact':True,'basis_exact':True,'position_mapping_passed':True})
assert trace[-1]['snapshot_tick']>=trace[0]['snapshot_tick'];assert trace[-1]['elapsed_seconds']>trace[0]['elapsed_seconds']+20.
binary=r/'target/debug/openleague-client.exe';out={'passed':True,'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'client_sha256':hashlib.sha256(binary.read_bytes()).hexdigest(),'trace':'logs/audio_listener_runtime_trace.json','trace_sha256':hashlib.sha256(trace_path.read_bytes()).hexdigest(),'samples':checks,'distinct_focus_positions':len({tuple(s['focus_world']) for s in trace}),'snapshot_tick_range':[trace[0]['snapshot_tick'],trace[-1]['snapshot_tick']],'comparison':'Real client resource frames/bases exactly match original705E30/AEB0E0/B1A0B0 on captured live inputs. Focus->native position within0.002 native units.','native_provenance':c['provenance'],'ambient_playback_enabled':False,'complete':False,'limits':['Native queue/tick/security callbacks are stubbed as in prior48-case contract; actual live PCM, panning, fades and voice aggregation not accepted.','Runtime samples validate current camera bridge, not full historical camera framing or human visual/audio fidelity.','No new framebuffer/pixel verification implied by listener state trace. Samples may represent a static camera/finished match; no simulated gameplay progression claimed.']}
(r/'docs/map_ambient_audio_listener_runtime_validation.json').write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8');print('Live listener verified:',len(checks),'samples; frames/bases exact native f32bits; tick',trace[0]['snapshot_tick'],'->',trace[-1]['snapshot_tick'])
