from pathlib import Path
import random,datetime,shutil
exec(compile(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
def track(uc,a,size,user):
 assert base<=a<base+len(image),hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,track)
w(0x14ae660,1)
rows=[];rng=random.Random(420)
for count in [0,1,2,3,16,31,32,33,64,129]:
 for profile in range(5):
  values=[rng.getrandbits(32) for _ in range(count)]
  if profile==1:values=sorted(values)
  if profile==2:values=sorted(values,reverse=True)
  if profile==3:values=[0,0xffffffff,0x80000000,1][0:1]*count
  if profile==4:values=[rng.choice([0,1,0x7fffffff,0x80000000,0xffffffff]) for _ in range(count)]
  for i,v in enumerate(values):w(storage+i*4,v)
  w(stack,end);w(stack+4,count);w(stack+8,0)
  u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,storage);u.reg_write(UC_X86_REG_EDX,storage+count*4)
  u.emu_start(0x735920,end,count=1000000)
  assert u.reg_read(UC_X86_REG_EIP)==end
  actual=[read(storage+i*4) for i in range(count)];assert actual==sorted(values),(count,profile)
  rows.append(dict(input=values,output=actual))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=len(visited),entries=['735920'],adapters=[],limits=['Supplied descriptor handles and normal native sort depth; camera/list merge integration remains separate.'])
(r/'data/4.20/entity_visibility_sort_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(len(rows),len(visited))
