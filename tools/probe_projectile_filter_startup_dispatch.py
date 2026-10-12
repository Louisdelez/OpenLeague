from pathlib import Path
import sys,json,itertools,hashlib
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,unicorn
from unicorn.x86_const import *
raw=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']).read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase;image=pe.get_memory_mapped_image();rows=[]
for rofl,spectator,replay,alternate in itertools.product([False,True],repeat=4):
 u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(0x590000,0x2000);u.mem_write(0x590000,image[0x590000-base:0x592000-base]);u.mem_map(0x2d78000,0x1000);u.mem_map(0x30000000,0x10000);u.mem_write(0x2d787b8,(0x30000100).to_bytes(4,'little'));u.mem_write(0x30000100,(0x30000200).to_bytes(4,'little'));bp=0x30008000;u.reg_write(UC_X86_REG_EBP,bp);u.reg_write(UC_X86_REG_ESP,bp-0x2000)
 for off,value in [(0x1541,rofl),(0x1554,spectator),(0x1542,replay),(0x1543,alternate)]:u.mem_write(bp-off,bytes([value]))
 exits={0x590ab1:'rofl_AC0',0x59033c:'ordinary_skip',0x590b79:'observer_replay_A4',0x590b84:'observer_replay_other'};seen=[]
 def hook(uc,a,size,user):
  if a in exits:seen.append(exits[a]);uc.emu_stop()
 u.hook_add(unicorn.UC_HOOK_CODE,hook);u.emu_start(0x590a93,0x590a93+1,count=1000)
 expected='rofl_AC0' if rofl else ('ordinary_skip' if not spectator and not replay else ('observer_replay_A4' if alternate else 'observer_replay_other'))
 assert seen==[expected],(rofl,spectator,replay,alternate,seen)
 rows.append(dict(rofl=rofl,spectator=spectator,replay=replay,alternate=alternate,path=seen[0]))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Startup string searches at5905DF/590603/590627 use spectator/replay/.rofl and populate flags1554/1542/1541.','Without these modes branch590B50 jumps59033C without activation; .rep branch was separately identified earlier.'],limits=['Original dispatch block executes; parser outputs supplied as flags, not full command-line parser execution.','Alternate observer path from590B84 still requires tracing to its eventual manager call.','Other runtime transitions and all gameplay/team-mask producers remain open.'])
(r/'data/4.20/projectile_filter_startup_dispatch.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS16 native startup dispatch cases')
for name in ['coverage','resume_checkpoint','completion_plan','goal_plan_revision']:
 p=r/f'docs/{name}.json';d=json.loads(p.read_text(encoding='utf-8'));d['next_action']='Root filter startup modes identified: .rep file activation; .rofl flag1541 invokesAC0; spectator1554/replay1542 gate observer branches; neither skips activation at590B50.16 original branch cases passed (projectile_filter_startup_dispatch.json), parser flags supplied. Constructor filter0 now consistent with normal startup path; full runtime transitions still unqualified. Next trace observer path590B84 onward/A8 and team mask15C producers; preserve full goal. No active process.';p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
