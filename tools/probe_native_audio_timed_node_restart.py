from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0];exec(compile(setup,'setup','exec'))
node=vector+0x6000;descriptor=vector+0x7000;selected=vector+0x7400;calls=[];visited=set()
def hook(uc,a,size,data):
 if a==0xb1b850:
  calls.append({'kind':'select_path','reference':u.reg_read(UC_X86_REG_ECX),'completed':completed});w(node+12,selected);u.mem_write(node+16,struct.pack('<H',0x1234));finish(completed);return
 assert 0xb1b510<=a<0xb1b584,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,present,flags,index,limit,loop,completed in itertools.product([0,0xa5],[0,1],[0,1,2,3],[0,1,0xffff],[0,1,2,0xffff],[0,1,255],[0,1]):
 calls.clear();u.mem_write(node,bytes([pattern])*96);w(node+4,descriptor);w(node+12,descriptor+16 if present else 0);u.mem_write(node+16,struct.pack('<3H',index,limit,0xcafe));w(node+24,flags);u.mem_write(node+29,bytes([loop]));before=bytes(u.mem_read(node,96)).hex();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb1b510,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end;rows.append({'completed':completed,'before':before,'after':bytes(u.mem_read(node,96)).hex(),'result':u.reg_read(UC_X86_REG_EAX),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb1b510','body_sha256':hashlib.sha256(pe.get_data(0xb1b510-base,0x74)).hexdigest(),'native_addresses':len(visited),'cases':rows,'adapters':['Actual B1B510 descriptor absence, flag1 random-selection/flag2 sequential path stepping, u16 increment/wrap/limit, looping byte29, pointer reset/advance, cursor20 reset and return1/17 execute. B1B850 selection is a mandatory controlled interface; changes to node descriptor/counter survive caller handling.'],'limits':['Original B1B850 selection, path construction/configuration and Rust replay/segment/full-frame integration remain required. Descriptor backing is not dereferenced by this caller.']}
(r/'data/4.20/audio_timed_node_restart_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native path restart flags/cursors/descriptor selection/loop cases')
