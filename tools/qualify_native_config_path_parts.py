from pathlib import Path
import itertools,json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');exec(compile((r/'tools/qualify_native_config_cache_policy.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native path prerequisites','exec'))
outputs=[0x40010000,0x40010040,0x40010080];inputptr=0x40012000
def allocate_string(data):
 global allocation
 p=allocation;allocation+=(len(data)+32+15)//16*16;assert allocation<0x41100000;u.mem_write(p,data+b'\0');return p
def path_hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a==0xc9c850:
  p=read(sp+4);index=cbytes(p).rfind(bytes([read(sp+8)&255]));finish(0 if index<0 else p+index);return
 if a==0x564ea0:
  data=ssoread(this);capacity=read(sp+4);p=allocate_string(data+b'\0'*max(0,capacity-len(data)));w(this,p);w(this+0x14,max(16,capacity));finish(1,8);return
 if a==0x6ee4b0:
  assert read(sp+4)==0 and not ssoread(this);ssowrite(this,bytes(u.mem_read(read(sp+8),read(sp+12))));finish(this,12);return
 if a==0x5f82a0:ssowrite(this,ssoread(this)+bytes([read(sp+8)&255])*read(sp+4));finish(this,8);return
 if a==0x564c20:ssowrite(this,bytes(u.mem_read(read(sp+4),read(sp+8))));finish(this,8);return
 assert 0x8b5700<=a<0x8b585a,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,path_hook)
paths=[a+b for a,b in itertools.product([b'',b'Config/',b'Config\\',b'C:',b'C:/',b'//server//cfg/',b'a:b/c\\'],[b'',b'Game',b'Game.cfg',b'.cfg',b'Game.',b'archive.tar.gz',b'a/b.cfg',b'a\\b.cfg',b'a:b.cfg',b'a\0junk.cfg'])]+[b'x'*512+b'/Game.cfg',b'DATA/\xff.cfg']
cases=[]
for data,old_extension in itertools.product(list(dict.fromkeys(paths)),[b'',b'preserved']):
 allocation=0x41000000
 for p,value in zip(outputs,[b'',b'',old_extension]):ssowrite(p,value)
 u.mem_write(inputptr,data+b'\0');w(stack,end);w(stack+4,outputs[1]);w(stack+8,outputs[2]);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,inputptr);u.reg_write(UC_X86_REG_EDX,outputs[0]);u.emu_start(0x8b5700,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
 path=data.split(b'\0',1)[0];sep=max(path.rfind(b'/'),path.rfind(b'\\'),path.rfind(b':'));prefix=path[:sep+1] if sep>=0 else b''
 if sep>=0 and path[sep]==58:prefix+=b'/'
 filename=path[sep+1:];dot=filename.rfind(b'.');name=filename[:dot] if dot>=0 else filename;extension=filename[dot+1:] if dot>=0 else old_extension
 actual=[ssoread(p) for p in outputs];assert actual==[prefix,name,extension],(data,actual,[prefix,name,extension])
 cases.append(dict(input=list(data),initial_extension=list(old_extension),prefix=list(actual[0]),name=list(actual[1]),extension=list(actual[2])))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8b5700',case_count=len(cases),native_addresses=len(visited),native_sha256=hashlib.sha256(raw).hexdigest(),cases=cases,adapters=['CRT strrchr and standard string insertion/assignment/growth boundaries adapted; original separator selection, colon prefix slash, basename/extension branches execute.','Prefix and name outputs initially empty, as in native cache caller; initial extension supplied to verify its preservation without a dot.'],limits=['Path split only; original string allocator/insertion implementation, nonempty prefix/name mutation, filesystem/archive resolution and cache lifetime remain open.','No OS path canonicalization, Unicode interpretation or full game proof.'])
(r/'data/4.20/native_config_path_parts_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
