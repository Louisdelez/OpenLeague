from pathlib import Path
import json,struct,datetime
setup=Path('E:/mapslol3v3/probe_recursive_resource_files.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
setup=setup.replace("if a==0x8b4b30:","if a in [0x8b4b30,0x8b4830]:")
setup=setup.replace("top=u.reg_read(UC_X86_REG_ESP);assert cstr(read32(top+4))=='*'","top=u.reg_read(UC_X86_REG_ESP);assert a==0x8b4830 or cstr(read32(top+4))=='*'")
exec(compile(setup,'native directory collector prerequisites','exec'))
cases=[]
for label,root,rows in [('mixed','Levels',[{'name':'Map10','folder':'Levels','directory':True},{'name':'terrain.inibin','folder':'Levels','directory':False}]),('actual-levels','Levels',[{'name':p.name,'folder':'Levels','directory':p.is_dir()} for p in sorted((source/'Levels').iterdir())]),('actual-characters','DATA/Characters',[{'name':p.name,'folder':'DATA/Characters','directory':p.is_dir()} for p in sorted((source/'DATA/Characters').iterdir())])]:
 allocation_cursor=0x70000000;u.mem_write(mapping,bytes(16));invoke(0x6542a0,mapping);write32(mapping,u.reg_read(UC_X86_REG_EAX));sso(folder,root,0x40009000);sso(pattern,'*',0x40009200)
 write32(sp,end);write32(sp+4,mapping);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,folder);u.reg_write(UC_X86_REG_EDX,pattern)
 u.emu_start(0x905a00,end,count=2000000);assert u.reg_read(UC_X86_REG_EIP)==end
 head=read32(mapping);entries={}
 def walk(node):
  if node==head:return
  walk(read32(node));entries[string(node+0x10)]=string(node+0x28);walk(read32(node+8))
 walk(read32(head+4));assert len(entries)==sum(row['directory'] for row in rows)
 cases.append({'name':label,'root':root,'iterator_rows':rows,'entries':entries})
assert cases[0]['entries']=={'Map10':'Levels/Map10'}
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x905A00',native_addresses=len(visited),cases=cases,limits=['Original directory collector loops and905090insertion execute; native directory flag accepts directories and skips ordinary files. Actual extracted Levels and Characters entries supplied.','8B4830and virtual iterator accessors use explicit filesystem row adapters, null ownership control; native archive order/iterator lifetime unqualified.','This enumerates directory resource paths only; global orchestration of subsequent Scripts/Items/Icons2D and integration with Shared/direct tables remains separate.'])
(r/'data/4.20/resource_directories_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'levels':len(cases[1]['entries']),'characters':len(cases[2]['entries'])}))
