from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0];exec(compile(setup,'setup','exec'))
node=vector+0x6000;mask=vector+0x7000;descriptors=vector+0x8000;calls=[];visited=set()
def hook(uc,a,size,data):
 global rng
 if a==0xc9bb7a:rng=(rng*214013+2531011)&0xffffffff;value=(rng>>16)&0x7fff;calls.append({'kind':'rand','value':value});finish(value);return
 assert 0xb1b850<=a<0xb1b8d5,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,layout,flags,seed in itertools.product([0,0xa5],[1,2,3,8],['none','all','mixed'],[0,2],[0,17,0xffffffff]):
 calls.clear();rng=seed;u.mem_write(node,bytes([pattern])*96);w(node+4,descriptors);w(node+8,mask);w(node+12,descriptors+16);u.mem_write(node+16,struct.pack('<2H',0xcafe,count));w(node+24,flags);u.mem_write(mask,bytes([pattern])*(count+2))
 for i in range(count):u.mem_write(mask+i,bytes([0 if layout=='none'or(layout=='mixed'and i%2==0)else 0xa5]))
 def snapshot():return {'node':bytes(u.mem_read(node,96)).hex(),'mask':bytes(u.mem_read(mask,count+2)).hex(),'rng_state':rng}
 before=snapshot();steps=[]
 for step in range(6):
  calls.clear();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb1b850,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end;steps.append({'completed':u.reg_read(UC_X86_REG_EAX)&255,'after':snapshot(),'calls':list(calls)})
 rows.append({'before':before,'steps':steps})
faults=[]
for pattern,mode,seed in itertools.product([0,0xa5],['zero_null','zero_owned','nonnull_count1_null','nonnull_count3_null'],[0,17,0xffffffff]):
 calls.clear();rng=seed;count=0 if mode.startswith('zero')else(1 if 'count1'in mode else 3);pointer=mask if mode=='zero_owned'else 0;u.mem_write(node,bytes([pattern])*96);w(node+4,descriptors);w(node+8,pointer);w(node+12,descriptors+16);u.mem_write(node+16,struct.pack('<2H',0xcafe,count));w(node+24,2);u.mem_write(mask,bytes([pattern])*8);before={'node':bytes(u.mem_read(node,96)).hex(),'rng_state':rng};w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,node);error=None
 try:u.emu_start(0xb1b850,end,count=1000)
 except unicorn.UcError as e:error=e.errno
 address=u.reg_read(UC_X86_REG_EIP);expected=0xb1b8a9 if count==0 else 0xb1b86a;assert address==expected and error in([None,unicorn.UC_ERR_EXCEPTION]if count==0 else[unicorn.UC_ERR_READ_UNMAPPED]),(mode,hex(address),error)
 faults.append({'mode':mode,'before':before,'after':{'node':bytes(u.mem_read(node,96)).hex(),'rng_state':rng},'fault_address':hex(address),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'fault_cases':faults,'native_zero_count_faults':12,'native_unowned_mask_faults':12,'step_count':sum(len(v['steps'])for v in rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb1b850','body_sha256':hashlib.sha256(pe.get_data(0xb1b850-base,0x85)).hexdigest(),'native_addresses':len(visited),'cases':rows,'adapters':['Actual B1B850 all-used mask scan/clear, single CRT draw modulo u16 count, cursor and optional descriptor update, selected-byte mark and initial cycle-completed result execute. CRT returns qualified Microsoft sequence values.'],'findings':['Selection does not exclude previously used indices; repeats remain possible. Returned cycle-completed reflects mask before selection. Only count bytes are cleared, padding remains owned unchanged.'],'limits':['Nonempty owned masks/count1/2/3/8 only. Native zero count IDIV0 and null masks for nonzero count are separately prepared in24 native fault cases and require explicit Rust error/fault mapping, not normal success. Shared RNG and normal mask/path constructors and Rust replay/integration remain required.']}
(r/'data/4.20/audio_timed_node_selection_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native selection sequences;',proof['step_count'],'steps')
