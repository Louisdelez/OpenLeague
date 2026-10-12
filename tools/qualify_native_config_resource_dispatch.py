from pathlib import Path
import itertools,json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');exec(compile((r/'tools/qualify_native_config_cache_policy.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'resource native prerequisites','exec'))
objects=0x40010000;vtables=0x40011000;pathptr=0x40012000;modeptr=pathptr+0x200;predicate_stub=end+0x800;open_stub=end+0x820;calls=[];statuses=(0,0,0);handles=(False,False,False)
for p in [predicate_stub,open_stub]:u.mem_write(p,b'\xcc')
for i in range(3):p=objects+i*16;v=vtables+i*16;w(p,v);w(v,open_stub);w(v+4,predicate_stub);w(0x2d6e4a0+i*4,p)
u.mem_write(pathptr,b'Config/Game.cfg\0');w(0x2d78db4,objects+0x100)
def resource_hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a in [predicate_stub,open_stub]:
  i=(this-objects)//16;assert 0<=i<3;assert read(sp+4)==pathptr
  if a==predicate_stub:calls.append(dict(kind='predicate',provider=i,flags=read(sp+8),status=statuses[i]));finish(statuses[i],8)
  else:calls.append(dict(kind='open',provider=i,mode=cbytes(read(sp+8)).decode(),returned=handles[i]));finish(objects+0x400+i*16 if handles[i] else 0,8)
  return
 assert any(begin<=a<stop for begin,stop in [(0x8b4ef0,0x8b4fa8),(0x8b5170,0x8b51b8)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,resource_hook)
cases=[]
for count,statuses,handles,mode in itertools.product([-1,0,1,2,3],itertools.product([0,1,-1],repeat=3),itertools.product([False,True],repeat=3),[b'r',b'rb',b'r+',b'w',b'a',b'x',b'rb+']):
 calls.clear();w(0x2d6e4b0,count);u.mem_write(modeptr,mode+b'\0');w(stack,end);w(stack+4,pathptr);w(stack+8,modeptr);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x8b4ef0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 flags=(4 if mode.startswith(b'r') else 0)|(2 if mode[:1] in [b'w',b'a'] or mode[1:2]==b'+' else 0)
 expected=[];winner=None
 for i in range(max(count,0)):
  expected.append(dict(kind='predicate',provider=i,flags=flags,status=statuses[i]))
  if statuses[i]==0:
   expected.append(dict(kind='open',provider=i,mode=mode.decode(),returned=handles[i]))
   if handles[i]:winner=i;break
 assert calls==expected;assert u.reg_read(UC_X86_REG_EAX)==(0 if winner is None else objects+0x400+winner*16)
 cases.append(dict(kind='open',provider_count=count,statuses=list(statuses),handles=list(handles),mode=mode.decode(),flags=flags,calls=calls.copy(),winner=winner))
for count,statuses in itertools.product([-1,0,1,2,3],itertools.product([0,1,-1],repeat=3)):
 calls.clear();w(0x2d6e4b0,count);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,pathptr);u.emu_start(0x8b5170,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 expected=[];status=-1
 for i in range(max(count,0)):
  status=statuses[i];expected.append(dict(kind='predicate',provider=i,flags=0,status=status))
  if status==0:break
 assert calls==expected;actual=u.reg_read(UC_X86_REG_EAX);assert actual==(status&0xffffffff)
 cases.append(dict(kind='predicate',provider_count=count,statuses=list(statuses),calls=calls.copy(),status=status))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,adapters=['Provider array/count and virtual predicate/open return values supplied; original8B4EF0/8B4F60/8B5170 mode flags, iteration, early exit and status propagation execute.','Resource subsystem preinitialized; actual providers, archives/filesystem, object lifetime and global initialization not executed.'],limits=['Dispatch contract only; status0 is the successful predicate case. Nonzero causes open-provider skip; predicate wrapper returns first0 or last nonzero status, -1 with no providers.','Localized filename branch uses this status as a nonzero test; previously supplied booleans do not qualify actual file existence/providers.','No complete resource provider/cache/runtime menu/game proof.'])
(r/'data/4.20/native_config_resource_dispatch_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
