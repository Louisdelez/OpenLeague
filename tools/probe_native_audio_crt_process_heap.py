from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
api=vector+0x28000;w(0xfa4278,api);calls=[];handle=0
runtime_globals=[{'reference':a,'raw':bytes(u.mem_read(a,z)).hex()}for a,z in [(0x14ae868,4),(0x14af110,4),(0x1222998,4),(0x1222830,45*8)]]
def hook(uc,a,z,user):
 if a==api:calls.append({'kind':'GetProcessHeap','result':handle,'at_call':bytes(u.mem_read(0x14ae87c,4)).hex()});finish(handle)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for initial,handle in itertools.product([0,0xa5a5a5a5,0x12345678],[0,1,0x12340000,0xffffffff]):
 w(0x14ae87c,initial);calls.clear();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xcabb83,end,count=100);assert u.reg_read(UC_X86_REG_EIP)==end;rows.append({'before':initial,'handle':handle,'result':u.reg_read(UC_X86_REG_EAX),'after':read(0x14ae87c),'calls':list(calls)})
p={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xcabb83','case_count':12,'cases':rows,'runtime_globals':runtime_globals,'limits':['Whole original CABB83 body executes GetProcessHeap, publishes32-bit heap handle and returns nonNULL boolean. Supplied handle outcomes; host64-bit handle relocation handled separately. Runtime defaults/table bytes copied from original mapped PE before mutation.']};(r/'data/4.20/audio_crt_process_heap_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_crt_process_heap.py').write_text(Path(__file__).read_text(encoding='utf-8-sig'),encoding='utf-8');print('Captured12 original process heap initialization cases and exact runtime defaults')
