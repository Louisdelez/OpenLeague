from pathlib import Path
import struct,json,configparser,hashlib,datetime,shutil
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
defaults=p.parent/'DATA/cfg/defaults/Input.ini';override=p.parent/'DATA/cfg/input.ini'
parser=configparser.ConfigParser(strict=False);parser.read([defaults,override],encoding='utf-8-sig')
bindings=[dict(slot=i,event=f'evtCastSpell{i+1}',cast=parser['GameEvents'][f'evtCastSpell{i+1}'].strip(),learn=parser['GameEvents'][f'evtLevelSpell{i+1}'].strip()) for i in range(4)]
frame=stack-0x1000;out=vector+0x9000;captures=[];visited=set()
def getstr(a):
 length=read(a+0x10);data=read(a) if read(a+0x14)>=16 else a;return bytes(u.mem_read(data,length))
def putstr(a,b):
 assert len(b)<16;u.mem_write(a,b+b'\0');w(a+0x10,len(b));w(a+0x14,15)
def hook(uc,a,n,unused):
 sp=u.reg_read(UC_X86_REG_ESP);this=u.reg_read(UC_X86_REG_ECX)
 if a==0x5c0540:
  needle=bytes(u.mem_read(read(sp+4),read(sp+12)));captures.append(dict(helper='find',needle=needle.decode(),start=read(sp+8)));finish(getstr(this).find(needle,read(sp+8)),12);return
 if a==0x5bca50:
  target=read(sp+4);start=read(sp+8);length=read(sp+12);putstr(target,getstr(this)[start:start+length]);finish(target,12);return
 if a==0x5648a0:
  data=bytes(u.mem_read(read(sp+4),100)).split(b'\0')[0];putstr(this,data);finish(this,4);return
 assert 0x83df6f<=a<0x83dfb9,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for text in ['[q]','[w]','[e]','[r]','[Q]','[1]','[F1]','[Ctrl][q]','[q],[w]','', '[<Unbound>]']:
 captures.clear();putstr(frame-0x5c,text.encode());putstr(out,b'');w(frame+8,1);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ESI,out)
 # Stop at the common continuation, after either substring or fallback branch.
 u.emu_start(0x83df6f,0x83e1d4,count=200);assert u.reg_read(UC_X86_REG_EIP)==0x83e1d4
 result=getstr(out).decode();cases.append(dict(input=text,short=True,output=result,helpers=captures.copy()))
for b in bindings:
 b['label']=next(c['output'] for c in cases if c['input']==b['cast']);assert b['cast']=='['+b['label']+']';assert b['learn']=='[Ctrl]['+b['label']+']'
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),formatter_slice=['0x83df6f','0x83e1d4'],case_count=len(cases),cases=cases,bindings=bindings,sources={str(x):hashlib.sha256(x.read_bytes()).hexdigest() for x in [defaults,override]},limits=['Short-label branch executes original instructions. String find, substring and assignment helpers adapted to SSO byte operations; original std::string implementations not executed.','Native runtime key-event initialization83ED50, remapping/localization producer6D77E0, long-label formatting and keyboard-layout translation remain open. Source default Input.ini and supplied input.ini merged with configparser; original loader equivalence not claimed.','Current client consumes four recovered default bindings. Editable bindings/options and quickcast/alternate/modifier policies remain open; no full input/HUD qualification.'])
(r/'data/4.20/native_hud_hotkeys_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for src,dest in [(defaults,'data/4.20/configuration/defaults/Input.ini'),(override,'data/4.20/configuration/Input.ini')]:shutil.copy2(src,r/dest)
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'bindings':bindings,'passed':True}))
