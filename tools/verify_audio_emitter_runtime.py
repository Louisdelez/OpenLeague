"""Verify actual emitted scene coordinates and native XYZ packing, without playback."""
from pathlib import Path
import json,sys,struct,hashlib,math,datetime
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
trace=read('logs/audio_emitter_runtime_trace.json');launch=read('logs/emitter_runtime_processes.json')
assert trace['complete_capture'] and len(trace['samples'])==64
assert trace['process_id']==launch['client'] and not trace['ambient_playback_enabled']
assert sha('target/debug/openleague-client.exe')==launch['client_sha256']
native=read('data/4.20/audio_emitter_position_contract.json')
raw=Path(native['provenance']['executable']).read_bytes();assert hashlib.sha256(raw).hexdigest()==native['provenance']['sha256']
p=pefile.PE(data=raw);base=p.OPTIONAL_HEADER.ImageBase
areas=[(int(a['start'],16),int(a['end'],16)) for a in native['regions']]
for a in native['regions']:assert hashlib.sha256(p.get_data(int(a['start'],16)-base,int(a['end'],16)-int(a['start'],16))).hexdigest()==a['sha256']
heap,stack,trap=0x30000000,0x31000000,0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image()
u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x10000)
def put(a,fmt,*v):u.mem_write(a,struct.pack('<'+fmt,*v))
def bits(v):return struct.unpack('<I',struct.pack('<f',v))[0]
def f32(v):return struct.unpack('<f',struct.pack('<f',v))[0]
messages=[]
def ret(value,cleanup):
 sp=u.reg_read(UC_X86_REG_ESP);target=struct.unpack('<I',u.mem_read(sp,4))[0]
 u.reg_write(UC_X86_REG_EAX,value);u.reg_write(UC_X86_REG_ESP,sp+4+cleanup);u.reg_write(UC_X86_REG_EIP,target)
def hook(uc,a,n,d):
 if a==0xaea6b0:ret(1,0);return
 if a in [0x87cd10,0xc975f5]:ret(56,0);return
 if a==0xb05ed0:
  sp=u.reg_read(UC_X86_REG_ESP);ptr,size=struct.unpack('<II',u.mem_read(sp+4,8));assert size==56
  assert struct.unpack('<H',u.mem_read(ptr+2,2))[0]==13
  assert struct.unpack('<I',u.mem_read(ptr+8,4))[0]==123 # emulation fixture, never live ID
  messages.append(list(struct.unpack('<3I',u.mem_read(ptr+12,12))));ret(1,8);return
 assert any(s<=a<e for s,e in areas),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
events=read('data/4.20/ambient_events.json')['models']
def metadata(s):
 entry=next(e for e in events[s['native_asset']]['events'] if e['record_offset']==s['record_offset'])
 assert entry['particle']==s['particle'] and entry['bone']==s['bone']
 assert entry['particle'].startswith('Audio-Emitter_')
 return entry
checked=0;unknown=0;seen={};unresolved=set()
for index,sample in enumerate(trace['samples']):
 assert sample['snapshot_tick'] is not None
 if index:assert sample['elapsed_seconds']>trace['samples'][index-1]['elapsed_seconds']
 keys=set()
 for source in sample['sources']:
  entry=metadata(source);key=(source['instance'],source['record_offset']);assert key not in keys;keys.add(key)
  point=source['native_position'];world=source['world_position']
  if point is None:
   assert source['attachment'] is None and world is None and not entry['attachment_source_resolved']
   unknown+=1;unresolved.add(key);continue
  assert source['attachment'] is not None and world is not None and entry['attachment_source_resolved']
  assert all(math.isfinite(v) for v in point+world)
  expected=[f32(world[0]*20.),f32(world[1]*20.),f32(15398.671875-f32(world[2]*20.))]
  assert [bits(v) for v in point]==[bits(v) for v in expected]
  put(heap+8,'I',123);put(heap+0x100,'3f',*point);messages.clear()
  sp=stack+0x8000;put(sp,'II',trap,heap+0x100);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap)
  u.emu_start(0x706df0,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
  assert messages==[[bits(v) for v in point]]
  seen.setdefault(key,set()).add(tuple(bits(v) for v in point));checked+=1
for event in trace['events']:
 entry=metadata(event)
 assert event['source_start_frame']==f32(entry['start_frame']) and event['source_end_frame']==f32(entry['end_frame'])
 assert (event['attachment'] is not None)==entry['attachment_source_resolved']
assert checked>0 and len(trace['events'])>0
assert trace['samples'][-1]['elapsed_seconds']-trace['samples'][0]['elapsed_seconds']>=31.
moving=[{'instance':key[0],'record_offset':key[1],'distinct_positions':len(value)} for key,value in seen.items() if len(value)>1]
assert moving,'Source motion not demonstrated'
out={'passed':True,'checked_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'client_pid':launch['client'],'client_sha256':launch['client_sha256'],
 'trace':'logs/audio_emitter_runtime_trace.json','trace_sha256':sha('logs/audio_emitter_runtime_trace.json'),
 'samples':64,'coordinate_pairs_verified':checked,'distinct_resolved_source_instances':len(seen),'moving_source_instances':moving,
 'unresolved_samples':unknown,'unresolved_source_instances':[{'instance':k[0],'record_offset':k[1]} for k in sorted(unresolved)],
 'event_records_verified':len(trace['events']),'capture_elapsed_range':[trace['samples'][0]['elapsed_seconds'],trace['samples'][-1]['elapsed_seconds']],
 'snapshot_tick_range':[trace['samples'][0]['snapshot_tick'],trace['samples'][-1]['snapshot_tick']],
 'native_provenance':native['provenance'],'ambient_playback_enabled':False,'complete':False,
 'limits':['Actual scene bone coordinates after propagation are verified; this is not an original-client scene/pose comparison or complete animation/rendering acceptance.',
 'Original706DF0/AEB1C0/AEB1E0 run on captured inputs using objectID123 as emulation fixture; no live audio object ID/registry/playback claimed.',
 'Queue/availability/size/security callbacks stubbed. Raw orientation stack tail is uninitialized and not interpreted.',
 'Missing native Chain4-3 attachments remain explicitly unresolved; no alias/fallback inserted.',
 'Finished-match snapshot ticks may remain constant while ambient animations continue; no gameplay progression claimed.',
 'No audible PCM capture, human listening, foreground screenshot or current GPU pixel fidelity proof.']}
(r/'docs/map_ambient_audio_emitter_runtime_validation.json').write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8')
print({k:v for k,v in out.items() if k in ['passed','samples','coordinate_pairs_verified','distinct_resolved_source_instances','event_records_verified','unresolved_samples']})
print('Moving sources:',len(moving))