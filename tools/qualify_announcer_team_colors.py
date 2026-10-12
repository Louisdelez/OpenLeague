from pathlib import Path
import itertools,json,shutil,re
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
actor=heap+0x1000;other=heap+0x2000;table=heap+0x8000;getter=end+0xb00;input_address=heap+0x4000;output=heap+0x4100
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
bindings=[(0x6d4a10,p) for p in [' teamcolornamenopurple@',' your team color | enemy team color@',' red | blue@',' red_cap | blue_cap@']]+[(0x6d4dc0,p) for p in [' red | blue@',' red_cap | blue_cap@']]
for (entry,pattern),exists,local,first,second,mode,variant in itertools.product(bindings,[False,True],['none','self','other'],[0,100,200,300],[0,100,200,300,0xffffffff],[0,1,2,4],['exact','upper','tail']):
 calls=[];localizations=[];outputs=[];input=pattern.upper() if variant=='upper' else pattern+'tail' if variant=='tail' else pattern
 write32(0x2d77f48,0 if local=='none' else actor if local=='self' else other);write32(0x2d79058,mode);u.mem_write(input_address,input.encode()+b'\0')
 sp=stack+0xc000;write32(sp,end);write32(sp+4,output);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,actor if exists else 0)
 u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end;assert len(outputs)==1
 assert len(calls)<=2
 cases.append({'entry':hex(entry),'pattern':pattern,'input':input,'exists':exists,'local':local,'first_team_value':first,'second_team_value':second,'mode':mode,'output_hex':outputs[0],'team_getter_calls':list(calls),'localization_calls':list(localizations)})
proof={'native_sha256':digest,'functions':['0x6D36D0','0x6D3740','0x6D38D0','0x6D3940','0x6D39B0','0x6D3A40','0x6D4A10','0x6D4DC0'],'passed':True,'complete':False,'translations':translations,'cases':cases,'limits':['Original registered team-color variants and both dispatchers execute; repeated actor getters have independent values. Only native registered bindings included.','No-purple color is relative with local owner, absolute when absent.Your-team-color body ignores local owner and distinguishes100/200 from unsupported teams. Red/blue families distinguish300,100 and remaining teams with original mode behavior.','Team getter, localization and final output storage supplied; no unsupported localized registration is invented. Global mode ownership and native locale mechanism remain work.','No live registry, full outer template rendering, scheduling or playback claim.']}
(r/'data/4.20/audio_announcer_team_colors_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_team_colors.py'),r/'tools/qualify_announcer_team_colors.py')
print(json.dumps({'native_team_color_cases_prepared':len(cases)}))
