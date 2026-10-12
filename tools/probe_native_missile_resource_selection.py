from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
controller=vector+0x6000;spell=vector+0x7000;config=spell+0x34;caster=vector+0x8000;local=vector+0x9000;vt=vector+0xa000;stub=vector+0xb000
w(vt+0xc,stub);selected=[];alias_calls=[];same_team=False
def string(a,s):
 b=s.encode();u.mem_write(a,b'\0'*24);u.mem_write(a,b+b'\0');w(a+0x10,len(b));w(a+0x14,15)
def readstr(a):
 data=bytes(u.mem_read(a,128));return data.split(b'\0')[0].decode()
def hook(uc,a,size,user):
 visited.add(a)
 if a==stub:
  ptr=u.reg_read(UC_X86_REG_ECX);finish(1 if ptr==local+0x124 or same_team else 2);return
 if a==0x90af50:finish(0xcafe0000,4);return
 if a==0x7522b0:
  sp=u.reg_read(UC_X86_REG_ESP);name=readstr(u.reg_read(UC_X86_REG_ECX));alias_calls.append(name);string(read(sp+4),name);finish(0);return
 if a==0x6cced0:finish(0,4);return
 if a==0x7172b0:
  sp=u.reg_read(UC_X86_REG_ESP);selected.append(dict(name=readstr(u.reg_read(UC_X86_REG_EDX)),flags=read(sp+12),source_package=hex(read(sp+4))));u.emu_stop();return
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for count,local_present,caster_present,matching_id,same_team,own_available,enemy_available in itertools.product([-1,0,1],[False,True],[False,True],[False,True],[False,True],[False,True],[False,True]):
 u.mem_write(controller,b'\0'*0x400);u.mem_write(spell,b'\0'*0x800);u.mem_write(caster,b'\0'*0x300);u.mem_write(local,b'\0'*0x300)
 w(controller+0x14,spell);w(controller+0x70,count&0xffffffff);w(controller+0x74,7 if matching_id else 8);w(local+8,7)
 w(caster+0x124,vt);w(local+0x124,vt);w(0x2d77f48,local if local_present else 0)
 string(config+0x5e0,'Base.troy');string(config+0x5f8,'Own.troy' if own_available else '');string(config+0x610,'Enemy.troy' if enemy_available else '')
 w(0x2d7c6d4,1);w(0x2d7c6d8,0x123456);w(0x2d78aac,0);w(0x2d5f588,17)
 u.mem_write(stack-0x100,b'\0'*0x300);w(stack+0x18,caster if caster_present else 0);selected.clear();alias_calls.clear()
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBX,controller);u.reg_write(UC_X86_REG_EAX,caster if caster_present else 0)
 u.emu_start(0x763536,end,count=1000)
 assert len(selected)==1 and len(alias_calls)==1
 expected='Own.troy' if count>0 and local_present and matching_id and own_available else ('Enemy.troy' if local_present and caster_present and not same_team and enemy_available else 'Base.troy')
 assert selected[0]['name']==expected and selected[0]['flags']==0
 cases.append(dict(count=count,local_present=local_present,caster_present=caster_present,matching_id=matching_id,same_team=same_team,own_available=own_available,enemy_available=enemy_available,selected=selected[0],alias_input=alias_calls[0]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x763536',end_boundary='0x7172b0',native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),cases=cases,adapters=['Actor team virtualC returns supplied team IDs. Package90AF50 returns supplied pointer; group6CCED0 returns zero.','Alias7522B0 is an explicit identity string adapter: this probe qualifies pre-alias resource selection only.','Stops at real7172B0 constructor request, before allocation/load.'],limits=['Original selection prefix763536..763678 executes, not whole763410 creation.','Caller7172B0 flags0 are different from generic751BE0 flags8 profile; resulting Troy orientation flags remain unqualified.','Native skin alias algorithm qualified separately; actual package/variant existence and live client selection remain open.'])
(r/'data/4.20/missile_resource_selection_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_instruction_addresses=proof['native_instruction_addresses'])))
