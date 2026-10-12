from pathlib import Path
import sys,struct,json,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'native setup','exec'))
digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
actor=vector+0x8000;cases=[]
for quality in [0,1,2,3,4,0xffffffff,0x80000000,0x7fffffff]:
 for fill in [0,0xa5,0xff]:
  u.mem_write(actor,bytes([fill])*0x400);w(0x1225888,quality);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,actor)
  u.emu_start(0x929523,0x92952e,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x92952e and u.reg_read(UC_X86_REG_ESP)==stack
  words=[read(actor+o) for o in range(0xe8,0x100,4)];expected=[0x41700000,0x3dcccccd,0x3e4ccccd,0x3f800000,0x3f800000,quality] if quality==0 else [0x41700000,0x3e4ccccd,0x3ecccccd,0x3f800000,0x3f800000,quality] if quality==1 else [0x41a00000,0x3ecccccd,0x3f19999a,0x3f800000,0x3f800000,quality] if quality==2 else [0x41f00000,0x3f800000,0x3f800000,0x3f800000,0x3f800000,quality]
  assert words==expected
  cases.append(dict(setting=quality,initial_fill=fill,words=words))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='929523..92952E calls92DA90',cases=cases,findings=['Global1225888 feeds setter92DA90; setting0/1 selects15Hz,2 selects20Hz,all others30Hz.','FieldsEC/F0/F4/F8 and settingFC captured together.'],limits=['Semantic UI name and live global setting producer remain unqualified.','Caller ECX engine supplied; execution begins at global load, following earlier configuration reads.','No graphical integration or whole-game acceptance.'])
(r/'data/4.20/troy_engine_rate_contract.json').write_text(json.dumps(proof,indent=2)+'\n');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(len(cases))
