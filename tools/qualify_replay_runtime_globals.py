from pathlib import Path
import json
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'runtime global prerequisites','exec'))
call(0x901a70,0,[])
regions=[]
for name,address,size in [('global_mutex',0x2d6ed50,32),('thread_pair',0x2d6ed70,8),('network_counters_status',0x2d78efc,32),('allocation_functions',0x1225878,8),('logger_flags_pointer',0x2d78ec0,8),('logger',0x2d78ed0,36),('thread_control_vtable',0x1085f2c,12)]:
 regions.append({'name':name,'address':address,'hex':bytes(u.mem_read(address,size)).hex()})
result={'passed':True,'complete':False,'native_sha256':digest,'regions':regions,'initialized_global_mutex':0x2d6ed58,'logger':read32(0x2d78ec4),'logger_callback':read32(0x2d78ef0),'logger_initialization':snapshot(),'limits':['The actual531A00 global mutex and901A70/901B80/8F9000 logger initialization execute against the inherited CRT prerequisites. Opaque Windows CS bytes use the supplied zero profile.','Rust runtime input banks describe fresh transport globals with an already initialized logger. The logger callback retains its separate native ownership and is not replaced by a fabricated callback allocation; native timestamp/output dispatch remains an external runtime dependency.']}
assert read32(0x2d78f04)==0 and read32(0x2d78f10)==0
assert read32(0x2d6ed70)==read32(0x2d6ed74)==0
Path('E:/mapslol3v3/replay_runtime_globals.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'regions':len(regions),'logger':result['logger'],'logger_callback':result['logger_callback']}))
