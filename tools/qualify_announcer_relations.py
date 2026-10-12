from pathlib import Path
import itertools,json,shutil,re
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
actor=heap+0x1000;other=heap+0x2000;table=heap+0x8000;getter=end+0x900;input_address=heap+0x4000;output=heap+0x4100
for address in [actor,other]:write32(address+0x124,table)
write32(table+12,getter)
path=r/'data/4.20/font_configuration/menu/fontconfig_en_US.txt'
translations=dict(re.findall(r'^tr "(game_announcement_replace_[^"]+)" = "([^"]*)"',path.read_text(encoding='utf-8-sig'),re.M))
def capture(uc,a,size,user):
 if a==getter:
  owner=u.reg_read(UC_X86_REG_ECX)-0x124;assert owner in (actor,other);index=len(calls);assert index<2
  calls.append({'owner':7 if owner==actor else 8,'value':[first,second][index]});finish(eax=[first,second][index]);return
 if a==0x78d0d0:
  key=cbytes(u.reg_read(UC_X86_REG_ECX)).decode('ascii');localizations.append(key);u.mem_write(heap+0xa000,translations[key].encode()+b'\0');finish(eax=heap+0xa000);return
 if a==0x5fda30:
  sp=u.reg_read(UC_X86_REG_ESP);pointer,n=read32(sp+4),read32(sp+8);assert u.reg_read(UC_X86_REG_ECX)==output
  outputs.append(bytes(u.mem_read(pointer,n)).hex());finish(8,output);return
 assert 0x400000<=a<0x1000000,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture);cases=[]
for entry,pattern,exists,local,first,second,variant in itertools.product([0x6d4a10,0x6d4dc0],[' blank | your ally | your enemy@',' blank | ally | enemy@',' killdeathannouncesrc@'],[False,True],['none','self','other'],[0,100,200,0xffffffff],[0,100,200,0xffffffff],['exact','upper','tail']):
 calls=[];localizations=[];outputs=[];input=pattern.upper() if variant=='upper' else pattern+'tail' if variant=='tail' else pattern
 write32(0x2d77f48,0 if local=='none' else actor if local=='self' else other);u.mem_write(input_address,input.encode()+b'\0')
 sp=stack+0xc000;write32(sp,end);write32(sp+4,output);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,actor if exists else 0)
 u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end;assert len(outputs)==1
 count=0 if not exists or local=='none' or (local=='self' and pattern.startswith(' blank')) else 2
 assert len(calls)==count
 cases.append({'entry':hex(entry),'pattern':pattern,'input':input,'exists':exists,'local':local,'first_team_value':first,'second_team_value':second,'output_hex':outputs[0],'team_getter_calls':list(calls),'localization_calls':list(localizations)})
proof={'native_sha256':digest,'functions':['0x6D3490','0x6D34F0','0x6D3560','0x6D35C0','0x6D3810','0x6D4A10','0x6D4DC0'],'passed':True,'complete':False,'translations':translations,'cases':cases,'limits':['Actual three relational token families and both ordered dispatchers execute. Getter values vary by call slot; self-owner can change team between calls.','Plain blank families read local team before actor; localized blank families read actor before local. Killdeath family reads local then actor and does not exclude self identity.','Team getter, localization and final string output storage supplied; no live team mutation/ownership, registry, full template rendering or playback claim.']}
(r/'data/4.20/audio_announcer_relations_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_relations.py'),r/'tools/qualify_announcer_relations.py')
print(json.dumps({'native_relational_token_cases_prepared':len(cases)}))
