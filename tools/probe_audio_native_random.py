from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
tls=vector+0xa000
# Only the CRT per-thread data lookup is adapted, not RNG arithmetic.
def tls_lookup(uc,address,size,data):
 sp=u.reg_read(UC_X86_REG_ESP);ret=read(sp)
 u.reg_write(UC_X86_REG_EAX,tls);u.reg_write(UC_X86_REG_ESP,sp+4);u.reg_write(UC_X86_REG_EIP,ret)
u.hook_add(unicorn.UC_HOOK_CODE,tls_lookup,begin=0xca9191,end=0xca9191)
rows=[]
for seed in [0,1,2,17,32767,65535,0x12345678,0x7fffffff,0x80000000,0xffffffff]:
 w(tls+0x14,seed);expected=seed;draws=[]
 for _ in range(64):
  call(0xc9bb7a,0);value=u.reg_read(UC_X86_REG_EAX)
  expected=(expected*214013+2531011)&0xffffffff
  assert read(tls+0x14)==expected and value==((expected>>16)&32767)
  draws.append(value)
 rows.append(dict(seed=seed,final_state=expected,draws=draws))
modulo=[]
for seed in [0,1,17,0xffffffff]:
 for count in [1,2,3,7,31,32767,65535]:
  w(tls+0x14,seed);u.mem_write(obj+0xc,struct.pack('<H',count))
  u.reg_write(UC_X86_REG_EBX,obj);u.reg_write(UC_X86_REG_ESP,stack)
  u.emu_start(0xb1e324,0xb1e333,count=100)
  assert u.reg_read(UC_X86_REG_EIP)==0xb1e333
  draw=(((seed*214013+2531011)&0xffffffff)>>16)&32767
  actual=u.reg_read(UC_X86_REG_EAX);assert actual==draw%count
  modulo.append(dict(seed=seed,eligible_count=count,draw=draw,index=actual))
weighted=[]
for seed in [0,1,17,0xffffffff]:
 for total in [1,2,3,100,65535,1000000,0xffffffff]:
  w(tls+0x14,seed);w(obj+8,total);call(0xb05050,obj)
  state=(seed*214013+2531011)&0xffffffff;first=(state>>16)&32767
  state=(state*214013+2531011)&0xffffffff;second=(state>>16)&32767
  expected=((first<<15)+second)%total
  assert read(tls+0x14)==state and u.reg_read(UC_X86_REG_EAX)==expected
  weighted.append(dict(seed=seed,total_weight=total,first=first,second=second,rank=expected,final_state=state))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),rng_entry='0xc9bb7a',selection_region=['0xb1e324','0xb1e333'],sequences=rows,modulo_cases=modulo,weighted_cases=weighted,limits=['CRT thread-data lookup adapted to mapped TLS fixture; native arithmetic executed unchanged.','Seeds are supplied test inputs; runtime seeding and shared draw ordering remain unqualified.','Unweighted candidate rank and weighted rank B05050 qualified; playlist weight accumulation, eligibility/history/reset and action probability need separate qualification.','Current unit-draw Selector must not be treated as a native RNG implementation.'])
(r/'data/4.20/audio_native_random_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(dict(passed=True,draws=640,modulo_cases=len(modulo),weighted_cases=len(weighted))))
