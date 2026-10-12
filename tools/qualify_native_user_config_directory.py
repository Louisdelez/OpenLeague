from pathlib import Path
import json,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native config directory prerequisites','exec'))
u.mem_map(0,0x1000);u.mem_map(0x41000000,0x100000);allocation=0x41000000;output=vector+0x8000;calls=[];base_path=b'';access_result=0
def cbytes(p):
 out=bytearray()
 while u.mem_read(p,1)[0]:out.append(u.mem_read(p,1)[0]);p+=1
 return bytes(out)
def ssoread(p):return bytes(u.mem_read(read(p) if read(p+20)>=16 else p,read(p+16)))
def ssowrite(p,data):
 global allocation
 u.mem_write(p,b'\0'*24)
 if len(data)<16:u.mem_write(p,data+b'\0');w(p+20,15)
 else:
  u.mem_write(allocation,data+b'\0');w(p,allocation);allocation+=(len(data)+32+15)//16*16;w(p+20,max(31,len(data)))
 w(p+16,len(data))
create_stub=end+0x100;w(0xfa41a8,create_stub);u.mem_write(create_stub,b'\xcc')
suffix=cbytes(0x10c9b9c);fallback=cbytes(0x10c9be8);file_name=cbytes(0x10c9ba8)
def hook_directory(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a==0x8b35a0:ssowrite(this,base_path);finish(this);return
 if a==0x5fa560:
  dest=read(sp+4);src=read(sp+8);tail=read(sp+12);ssowrite(dest,ssoread(src)+cbytes(tail));finish(dest);return
 if a==0x564af0:
  data=ssoread(read(sp+4));start=read(sp+8);count=read(sp+12);ssowrite(this,data[start:] if count==0xffffffff else data[start:start+count]);finish(this,12);return
 if a==0x5648a0:ssowrite(this,cbytes(read(sp+4)));finish(this,4);return
 if a==0x564900:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==create_stub:calls.append(dict(kind='create',path=cbytes(read(sp+4)).decode('latin1')));finish(1,8);return
 if a==0xc9f6c9:calls.append(dict(kind='access',path=cbytes(read(sp+4)).decode('latin1'),mode=read(sp+8)));finish(access_result);return
 if a==0xc975f5:finish(uc.reg_read(UC_X86_REG_EAX));return
 assert 0x8b3840<=a<0x8b3962,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook_directory)
cases=[]
for base_path,mode,access_result in itertools.product([b'',b'./',b'E:/OpenLeague/',b'C:/Users/player/Game/',b'root-without-slash'],[0,1,2],[-1,0,5]):
 allocation=0x41000000;calls.clear();w(0x2d83fbc,1);w(0x2d859f4,mode);ssowrite(output,b'previous');w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,output);u.emu_start(0x8b3840,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
 expected=fallback if mode==2 or access_result!=0 else base_path+suffix;result=ssoread(output);assert result==expected
 assert calls==([] if mode==2 else [dict(kind='create',path=(base_path+suffix).decode('latin1')),dict(kind='access',path=(base_path+suffix).decode('latin1'),mode=2)])
 cases.append(dict(base=base_path.decode('latin1'),mode=mode,access_result=access_result,directory=result.decode('latin1'),calls=list(calls)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x8b3840',case_count=len(cases),native_addresses=len(visited),config_directory_suffix=suffix.decode('latin1'),fallback_directory=fallback.decode('latin1'),user_file_name=file_name.decode('latin1'),cases=cases,adapters=['Underlying base directory8B35A0 supplied; initialized process-mode globals supplied.','Standard string concatenation/copy/construction/destruction adapted; original selection, access-mode handling and return branches execute.','CreateDirectoryA and CRT access boundaries recorded and supplied controlled results; no filesystem operations performed.','Mapped FS exception-chain cell and adapted security cookie; original process setup/Windows thread machinery not executed.'],limits=['Configuration directory chooser only; base directory/process-mode producer and full8B3970 Game.cfg initialization remain open.','Native constants captured; actual user directory selection on this PC and complete cache/file/runtime/menu/persistence not qualified.'])
(r/'data/4.20/native_user_config_directory_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),suffix=proof['config_directory_suffix'],fallback=proof['fallback_directory'],file=proof['user_file_name'])))
