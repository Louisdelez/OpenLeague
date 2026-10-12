from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_audio_native_random.py').read_text().split('\nrows=[]')[0],'setup','exec'))
action=vector+0xb000;props=vector+0xc000
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,n,d:u.emu_stop(),begin=0xb2d270,end=0xb2d270)
rows=[]
for probability in [None,0.,0.001,25.,50.,99.999,100.]:
 for seed in [0,1,2,17,32767,65535,0x12345678,0x7fffffff,0x80000000,0xffffffff]:
  u.mem_write(action,b'\0'*0x40);u.mem_write(props,b'\x01\x10\0\0'+struct.pack('<f',probability or 0.));w(action+0x14,0 if probability is None else props);w(tls+0x14,seed)
  w(stack,end);u.mem_write(stack+4,b'\0'*8);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,action);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0xb2d240,end,count=2000);where=u.reg_read(UC_X86_REG_EIP);assert where in [0xb2d270,end]
  expected_state=seed;expected=probability is None
  if probability is not None and probability>0:
   expected_state=(expected_state*214013+2531011)&0xffffffff;first=(expected_state>>16)&32767
   expected_state=(expected_state*214013+2531011)&0xffffffff;second=(expected_state>>16)&32767
   percent=((first<<15)+second)/1073741823*100
   expected=percent<=struct.unpack('<f',struct.pack('<f',probability))[0]
  assert (where==0xb2d270)==expected and read(tls+0x14)==expected_state
  rows.append(dict(probability=probability,seed=seed,accepted=expected,final_state=expected_state))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0xb2d240',accept_stop='0xb2d270',cases=rows,limits=['Actual property16 lookup and gate executed; target lookup/playback stopped before execution. CRT TLS accessor adapted.','Absent property accepts without drawing; present zero rejects without drawing; present positive including100 consumes two draws and compares inclusively.','Finite0..100 only; action class vtable mapping to bank action0403 still needs explicit verification.'])
(r/'data/4.20/audio_native_probability.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(passed=True,cases=len(rows))))
