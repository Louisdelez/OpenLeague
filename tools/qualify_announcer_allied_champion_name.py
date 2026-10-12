from pathlib import Path
import json,itertools,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
actor=heap+0x1000;table=heap+0x8000;getter=end+0x800;objects=[heap+0x5000,heap+0x6000,heap+0x7000];gate=heap+0x9000
other=heap+0x2000;team_table=heap+0x8100;team_getter=end+0xa00;
write32(actor+0x124,team_table);write32(other+0x124,team_table);write32(team_table+12,team_getter)
input_address=heap+0x4000;output=heap+0x4100
write32(actor+0x3e0,table);write32(table,getter);write32(objects[1]+0x9e4,gate)
calls=[];outputs=[];flag_reads=0;gate_reads=[]
def capture(uc,a,size,user):
 if a==team_getter:
  owner=u.reg_read(UC_X86_REG_ECX)-0x124;assert owner in (actor,other);index=len(team_calls);assert index<2;team_calls.append({'owner':7 if owner==actor else 8,'value':[first_team,second_team][index]});finish(eax=[first_team,second_team][index]);return
 if a==getter:
  assert u.reg_read(UC_X86_REG_ECX)==actor+0x3e0;index=len(calls);assert index<3;calls.append(index)
  finish(eax=0 if index==0 and not present else objects[index]);return
 if a==0x5fda30:
  sp=u.reg_read(UC_X86_REG_ESP);address,n=read32(sp+4),read32(sp+8);assert u.reg_read(UC_X86_REG_ECX)==output
  outputs.append(bytes(u.mem_read(address,n)).hex());finish(8,output);return
 assert 0x400000<=a<0x1000000,hex(a)
def reads(uc,access,address,size,value,user):
 global flag_reads
 if address==actor+0x1c:assert size==4;flag_reads+=1
 if address==gate+16:gate_reads.append(size);assert size==1
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,reads);cases=[]
for entry,exists,local,first_team,second_team,flags,present,gate_word,fallback,provided,input in itertools.product([0x6d4a10,0x6d4dc0],[False,True],['none','self','other'],[100,200],[100,200],[0x800,0x1000],[False,True],[0,257],['','FallbackNameLongerThanSmallStringCapacity'],['','CharacterNameLongerThanSmallStringCapacity'],[' allychampionname@']):
 cursor=heap+0xc000;calls=[];outputs=[];flag_reads=0;gate_reads=[];team_calls=[]
 write32(0x2d77f48,0 if local=='none' else actor if local=='self' else other)
 write32(actor+0x1c,flags);write32(gate+16,gate_word);put(actor+0x211c,fallback);put(objects[2]+0x944,provided)
 u.mem_write(input_address,input.encode()+b'\0');sp=stack+0xc000;write32(sp,end);write32(sp+4,output)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,actor if exists else 0)
 u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end;assert len(outputs)==1
 related=exists and local!='none' and first_team==second_team;hero=related and flags&0x1000!=0;selected=provided if present and gate_word&255 else fallback
 assert outputs==[(selected if hero else '').encode().hex()];assert len(calls)==(0 if not hero else 1 if not present else 2 if not gate_word&255 else 3)
 assert flag_reads==int(related);assert len(team_calls)==(2 if exists and local!='none' else 0);assert gate_reads==([1] if hero and present else [])
 cases.append({'entry':hex(entry),'exists':exists,'local':local,'first_team_value':first_team,'second_team_value':second_team,'team_getter_calls':list(team_calls),'flags':flags,'first_character_present':present,'gate_word':gate_word,'fallback_name':fallback,'provided_character_name':provided,'input':input,'output_hex':outputs[0],'getter_calls':list(calls),'flag_reads':flag_reads,'gate_read_sizes':list(gate_reads)})
proof={'native_sha256':digest,'functions':['0x6D4A10','0x6D4DC0','0x6D3870','0x6D37A0'],'passed':True,'complete':False,'cases':cases,'limits':['Original allied-championname body, original championname callback and both dispatchers executed; local and actor team getters supplied with independent per-call values; flags, first-null fallback, fresh second/third getters, single-byte gate and string storage selected natively.','Actor+3E0 virtual getter supplies distinct first/second/third character objects. Gate is byte at pointer(second+9E4)+10; name is native string at third+944, fallback at actor+211C. These are layout roles, not inferred skin semantics.','Both form choices use the same raw name body; no forced translation or casing. Virtual ownership, provenance, invalid second/third pointers and actual source string allocation remain unqualified.','Final output storage supplied; no live actor registry, queue or playback claim.']}
(r/'data/4.20/audio_announcer_allied_champion_name_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_allied_champion_name.py'),r/'tools/qualify_announcer_allied_champion_name.py')
print(json.dumps({'native_allied_champion_name_cases_prepared':len(cases)}))
