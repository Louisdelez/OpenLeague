from pathlib import Path
import json,struct,itertools,shutil,re
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
actor=heap+0x7000;input_address=heap+0x5000;output=heap+0x6000;name_object=heap+0x4000
translation_path=r/'data/4.20/font_configuration/menu/fontconfig_en_US.txt';translations=dict(re.findall(r'^tr "(game_announcement_replace_[^"]+)" = "([^"]*)"',translation_path.read_text(encoding='utf-8-sig'),re.M))
name_calls=[];localization=[];outputs=[];flag_reads=0;capacity_reads=0
def capture(uc,a,size,user):
 if a==0x716ce0:
  assert u.reg_read(UC_X86_REG_ECX)==actor;name_calls.append('actor');finish(eax=name_object);return
 if a==0x78d0d0:
  key=cbytes(u.reg_read(UC_X86_REG_ECX)).decode('ascii');localization.append(key);u.mem_write(heap+0xb000,translations[key].encode('ascii')+b'\0');finish(eax=heap+0xb000);return
 if a==0x5fda30:
  sp=u.reg_read(UC_X86_REG_ESP);ptr,n=read32(sp+4),read32(sp+8);assert u.reg_read(UC_X86_REG_ECX)==output;outputs.append(bytes(u.mem_read(ptr,n)).hex());finish(8,output);return
 assert 0x400000<=a<0x1000000,hex(a)
def memory_read(uc,access,address,size,value,user):
 global flag_reads,capacity_reads
 if address==actor+0x1c:assert size==4;flag_reads+=1
 if address==name_object+20:assert size==4;capacity_reads+=1
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,memory_read);cases=[]
for entry,exists,flags,name,local,input in itertools.product([0x6d4a10,0x6d4dc0],[False,True],[0,0x800,0x1000,0x2000,0x1800,0x2800,0x3000,0x3800,0xffffffff],['','Garen','ProvidedNameLongerThanNativeSmallStringCapacity'],['none','self','other'],[' you | name@',' YOU | NAME@',' you | name@tail',' unknown field@']):
 name_calls=[];localization=[];outputs=[];flag_reads=0;capacity_reads=0;cursor=heap+0xc000;put(name_object,name);write32(0x2d77f48,0 if local=='none' else actor if local=='self' else heap+0x9000);write32(actor+0x1c,flags);u.mem_write(input_address,input.encode()+b'\0')
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<II',end,output));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,actor if exists else 0);u.emu_start(entry,end,count=50000);assert u.reg_read(UC_X86_REG_EIP)==end;assert len(outputs)==1
 cases.append({'entry':hex(entry),'exists':exists,'flags':flags,'provided_name':name,'local':local,'input':input,'output_hex':outputs[0],'name_calls':list(name_calls),'localization_calls':list(localization),'flag_reads':flag_reads,'capacity_reads':capacity_reads})
proof={'native_sha256':digest,'functions':['0x6D4A10','0x6D4DC0','0x6D30F0','0x6D3160','0x6D3030','0x5FA520'],'passed':True,'complete':False,'translations':translations,'cases':cases,'limits':['Original you-or-name family and exhausted fallback executed, including null actor before local comparison, local identity before flags, mixed hero/turret/minion masks and inline/heap converted names. Named family prefix variants and trailing bytes captured.','716CE0 name provider boundary supplies a valid borrowed original-layout string object; provider internals/name provenance/lifetime not qualified here.','Original localization boundary and final string output storage supplied; source localization dictionary retained. No normal event or playback claim.']}
(r/'data/4.20/audio_announcer_you_or_name_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_you_or_name.py'),r/'tools/qualify_announcer_you_or_name.py');print(json.dumps({'native_cases_prepared':len(cases)}))
