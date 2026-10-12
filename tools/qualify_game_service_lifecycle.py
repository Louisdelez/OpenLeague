from pathlib import Path
import json,itertools,ctypes
root=Path('E:/OpenLeague')
source=(root/'tools/probe_whole_announcer_startup.py').read_text().split('\npoison=165;cursor=arena;')[0]
exec(compile(source,'native startup boundaries','exec'))
poison=165;cursor=arena;fail=False
write32(0x14bef40,0);write32(0x14bef58,0);u.mem_write(0x2d77b20,b'\1')
call(0xc9a0b9,0,[]);write32(0x2da5308,read32(0x1222ed0))
assert call(0xcb0378,0,[])==1 and call(0xcaff53,0,[])==0
u.mem_write(service,bytes([poison])*0x188)
assert call(0x72a3b0,service,[])==service
call(0x72a530,service,[0])
assert cursor<arena+0x80000
warmup_windows=list(windows_calls);warmup_allocations=list(allocations)
settings=[];active_replay=0;active_service=0;opaque=None
float_stores={0x59cca8:0,0x59ccbf:4,0x59ccda:8,0x59ccf5:12,0x59cd10:16,0x59cd2b:20}
setting_returns=[]
def setting_result(value):
 q=settings[-1];q['result']=value
 ai,fi=setting_returns.pop()
 q['allocations']=list(allocations[ai:]);q['freed']=list(freed[fi:])
def observe(uc,address,size,user):
 global opaque
 if address in [0x8b20f0,0x8b1910,0x8b1c20]:
  sp=u.reg_read(UC_X86_REG_ESP)
  settings.append({'kind':{0x8b20f0:'float',0x8b1910:'bool',0x8b1c20:'integer'}[address], 'section':cbytes(u.reg_read(UC_X86_REG_ECX)).decode(), 'key':cbytes(u.reg_read(UC_X86_REG_EDX)).decode(), 'default':read32(sp+4)})
  setting_returns.append((len(allocations),len(freed)))
 if address in float_stores:setting_result(read32(active_replay+float_stores[address]))
 if address==0x59ce3f:setting_result(u.mem_read(active_replay+0xa0,1)[0])
 if address==0x59cec3:setting_result(u.mem_read(active_replay+0xd1,1)[0])
 if address==0x72a4b0:setting_result(u.reg_read(UC_X86_REG_EAX)&255)
 if address==0x72a4fb:setting_result(read32(active_service+0x17c))
 if address==0x7307f0:
  sp=u.reg_read(UC_X86_REG_ESP);opaque=u.mem_read(read32(sp+4),1)[0]
u.hook_add(unicorn.UC_HOOK_CODE,observe)
live={};caller_blocks=[]
def snapshot():
 for a in allocations:live[a['pointer']]=a['bytes']
 for p in freed:live.pop(p,None)
 blocks=sorted(list(live.items())+caller_blocks)
 s={'allocations':list(allocations),'freed':list(freed), 'words':[[p+i,read32(p+i)] for p,n in blocks for i in range(0,n,4)]}
 allocations.clear();freed.clear();return s
def reset(fill):
 global poison,cursor,live,caller_blocks
 poison=fill;cursor=arena+0x80000;live={};caller_blocks=[]
 allocations.clear();freed.clear();settings.clear()
def new_callback(owner=0,method=0,extra=0):
 p=call(0x9933e0,0,[16])
 for off,val in [(0,0x10afd08),(4,owner),(8,method),(12,extra)]:write32(p+off,val)
 return p
members=[]
profiles=['empty','buffer','stream','control_last','control_shared','control_weak','control_zero']
for fill,has_callback,profile in itertools.product([0,165],[False,True],profiles):
 reset(fill);active_service=0;active_replay=heap+0x9000;caller_blocks=[(active_replay,0xd4)]
 u.mem_write(active_replay,bytes([fill])*0xd4);slot=heap+0x9800;source_callback=heap+0x9900
 for off,val in [(0,0x10afd08),(4,heap+0x6000),(8,0x72c780),(12,0xffffffff)]:write32(source_callback+off,val)
 write32(slot,source_callback if has_callback else 0)
 assert call(0x59cc60,active_replay,[slot])==active_replay
 constructed=snapshot();queried=list(settings)
 if profile=='buffer':
  p=call(0x9933e0,0,[32])
  for off,val in [(0x50,p),(0x54,p+12),(0x58,p+32)]:write32(active_replay+off,val)
 if profile=='stream':write32(active_replay+0x18,new_callback())
 if profile.startswith('control_'):
  obj=new_callback();call(0x5d1fa0,active_replay+0x6c,[obj]);control=read32(active_replay+0x70)
  strong,weak={'control_last':(1,1),'control_shared':(2,1),'control_weak':(1,2),'control_zero':(0,0)}[profile]
  write32(control+4,strong);write32(control+8,weak)
 prepared=snapshot();call(0x59cf40,active_replay,[]);destroyed=snapshot()
 assert all('result' in q for q in queried)
 members.append({'poison':fill,'has_callback':has_callback,'profile':profile,'object':active_replay,'constructed':constructed,'settings':queried,'prepared':prepared,'destroyed':destroyed})
whole=[]
for fill,flags in itertools.product([0,165],[0,1,256,257]):
 reset(fill);active_service=call(0x9933e0,0,[0x188]);active_replay=active_service+0x60
 result=call(0x72a3b0,active_service,[]);assert result==active_service
 constructed=snapshot();queried=list(settings);constructor_opaque=opaque
 returned=call(0x72a530,active_service,[flags]);assert returned==active_service
 destroyed=snapshot();assert all('result' in q for q in queried)
 whole.append({'poison':fill,'flags':flags,'service':active_service,'opaque_byte':constructor_opaque,'settings':queried,'constructed':constructed,'destroyed':destroyed})
for actual in find_handles.values():
 fn=ctypes.windll.kernel32.FindClose;fn.argtypes=[ctypes.c_void_p];fn(actual)
proof={'passed':True,'complete':False,'native_sha256':digest,'arena':arena+0x80000,'member_cases':members,'whole_cases':whole,'curve_controls_hex':bytes(u.mem_read(0x1224d84,32)).hex(),'native_config_bytes_read_via_windows':any(c['function']=='ReadFile' for c in windows_calls),'warmup_windows_calls':warmup_windows,'warmup_allocations':warmup_allocations,'limits':['Actual59CC60,59CF40,7340C0,578010,72A3B0,72A530 and native member bodies execute; actual native typed setting getters execute on warmed missing-RADS/no-optional-export fallback state. No constructor, setting or destructor result adapters. Only primitive memory/Windows boundaries supplied by existing startup probe.','28 replay member lifetimes cover null/non-null borrowed callback, allocator fill, vector disposal, an actual supported scalar-deletable stream precondition and actual1085F4C shared-control disposal with last/shared/weak/zero counts. Injected populated fields are explicit owned-storage preconditions; replay file loading/streaming is not proven. Eight full service lifetimes cover both fill patterns and scalar delete flags0,1,256,257.','Configuration getters return actual fallback outcomes; no Game.cfg bytes read via Windows. Full normal resource configuration, frame callbacks, native runtime startup, exception/unwind and allocator failures/mutations, real simulation/actor/audio/renderer integration remain open.']}
(root/'data/4.20/audio_game_service_lifecycle_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'replay_member_lifetimes':len(members),'whole_service_lifetimes':len(whole),'native_config_bytes_read':proof['native_config_bytes_read_via_windows']}))
