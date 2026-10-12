from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0];exec(compile(setup,'setup','exec'))
node=vector+0x6000;descriptor=vector+0x7000;points=vector+0x8000;calls=[];visited=set()
def hook(uc,a,size,data):
 global rng
 if a==0xc9bb7a:
  rng=(rng*214013+2531011)&0xffffffff;value=(rng>>16)&0x7fff;calls.append({'kind':'rand','value':value});finish(value);return
 if a==0xb1b510:
  before=struct.unpack('<H',u.mem_read(node+20,2))[0]
  if restart:u.mem_write(node+20,struct.pack('<H',0))
  calls.append({'kind':'restart_path','reference':u.reg_read(UC_X86_REG_ECX),'index_before':before,'status':1 if restart else 52});finish(1 if restart else 52);return
 assert 0xb1b680<=a<0xb1b82a,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,index,restart,seed,interval,duration,frame_end in itertools.product([0,0xa5],[1,3,4],[0,1,3],[0,1],[0,17,0xffffffff],[20,1024],[0,1,40,1024,0x80000000,0xffffffff],[0,0xffffffff]):
 calls.clear();rng=seed;u.mem_write(node,bytes([pattern])*96);w(node,1);w(node+12,descriptor);u.mem_write(node+20,struct.pack('<H',index));w(node+52,frame_end);w(node+56,5);u.mem_write(node+72,struct.pack('<3f',10.,20.,30.));u.mem_write(descriptor,struct.pack('<2I2f',points,count,4.,8.));u.mem_write(points,b''.join(struct.pack('<3fI',1.+i,float(i*2),3.-i,duration)for i in range(5)));w(0x12100f8,interval)
 def snapshot():return {'node':bytes(u.mem_read(node,96)).hex(),'descriptor':bytes(u.mem_read(descriptor,16)).hex(),'points':bytes(u.mem_read(points,80)).hex(),'rng_state':rng}
 before=snapshot();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,node);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0xb1b680,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end;rows.append({'interval':interval,'restart':restart,'before':before,'after':snapshot(),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb1b680','body_sha256':hashlib.sha256(pe.get_data(0xb1b680-base,0x1aa)).hexdigest(),'native_addresses':len(visited),'random_scale_bits':read(0xff1750),'cases':rows,'adapters':['Actual B1B680 current/next path point movement, u16 cursor, signed duration IDIV/zero-to-one, random X/Z jitter, end wrapping, deltas, x87 reciprocal/bias and inactive exit execute. CRT RNG returns qualified Microsoft sequence values. B1B510 restart-path body remains a mandatory controlled interface.'],'limits':['Valid owned backing for five path points, finite point/jitter coordinates, positive20/1024 interval only. Normal path/configuration producers, shared RNG producer, restart body and Rust replay/integration remain required. This is segment advancement, not allocation destruction.']}
(r/'data/4.20/audio_timed_node_segment_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native timed-node next-segment/jitter/duration/restart/inactive sequences')
