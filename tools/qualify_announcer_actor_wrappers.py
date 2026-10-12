from pathlib import Path
import json,struct,itertools,shutil,re,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
registry_path=r/'data/4.20/audio_announcer_object_lookup_contract.json';registry=json.loads(registry_path.read_text());layout=next(x for x in registry['layouts'] if x['mask']==3 and x['maximum']==4 and x['keys']==[0,1,17,42,100])
words=dict(layout['words']);manager=layout['manager'];objects={}
for address,value in layout['words']:
 if address>=heap+0x2000 and address<heap+0x3000 and (address-(heap+0x2000))%32==8:objects[value]=words[address+4]
for address,value in layout['words']:write32(address,value)
table=heap+0x9000;getter=end+0x200;output=heap+0x6000;input_address=heap+0x5000
write32(table+12,getter)
for actor in objects.values():write32(actor+0x124,table)
translation_path=r/'data/4.20/font_configuration/menu/fontconfig_en_US.txt';translations=dict(re.findall(r'^tr "(game_announcement_replace_[^"]+)" = "([^"]*)"',translation_path.read_text(encoding='utf-8-sig'),re.M))
pattern=cbytes(read32(0x6d4c29)).decode();calls=[];appends=[];localization=[];flag_reads=0;lookup_keys=[]
def capture(uc,a,size,user):
 if a==0x62b380:lookup_keys.append(read32(u.reg_read(UC_X86_REG_ESP)+4))
 if a==getter:
  actor=u.reg_read(UC_X86_REG_ECX)-0x124;key=next(k for k,v in objects.items() if v==actor);calls.append(key);finish(eax=100 if key==100 else 200);return
 if a==0x5fda30:
  sp=u.reg_read(UC_X86_REG_ESP);ptr,n=read32(sp+4),read32(sp+8);assert u.reg_read(UC_X86_REG_ECX)==output;appends.append(bytes(u.mem_read(ptr,n)).decode('ascii'));finish(8,output);return
 if a==0x78d0d0:
  key=cbytes(u.reg_read(UC_X86_REG_ECX)).decode('ascii');localization.append(key);u.mem_write(heap+0xa000,translations[key].encode('ascii')+b'\0');finish(eax=heap+0xa000);return
 assert 0x400000<=a<0x1000000,hex(a)
def memory_read(uc,access,address,size,value,user):
 global flag_reads
 if address in [v+0x1c for v in objects.values()]:assert size==4;flag_reads+=1
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,memory_read);cases=[]
for flags,local_key,mode,key,entry,input in itertools.product([0x800,0x1000,0x2000],[None,42,100],[0,2],[42,100,99,0xffffffff],[0x6e9da0,0x6e9e00],['src'+pattern,'dest'+pattern,'SOURCE'+pattern.upper(),pattern,'src'+pattern+'Trailing']):
 calls=[];appends=[];localization=[];flag_reads=0;lookup_keys=[]
 for actor in objects.values():write32(actor+0x1c,flags)
 write32(0x2d77f48,objects.get(local_key,0));write32(0x2d79058,mode);u.mem_write(input_address,input.encode()+b'\0')
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<II',end,key));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,output);u.emu_start(entry,end,count=50000);assert u.reg_read(UC_X86_REG_EIP)==end;assert lookup_keys==[key]
 if key not in objects:assert appends==['Unknown'] and flag_reads==0 and not calls and not localization
 cases.append({'entry':hex(entry),'flags':flags,'local_key':local_key,'mode':mode,'key':key,'input':input,'output':''.join(appends),'lookup_keys':list(lookup_keys),'getter_calls':list(calls),'localization_calls':list(localization),'flag_reads':flag_reads})
proof={'native_sha256':digest,'functions':['0x6E9DA0','0x6E9E00','0x62B380','0x5C6830','0xC9B47B','0x6D4A10','0x6D4DC0'],'passed':True,'complete':False,'registry_contract_sha256':hashlib.sha256(registry_path.read_bytes()).hexdigest(),'registry_layout':layout,'objects':objects,'translations':translations,'cases':cases,'limits':['Original wrapper prefix scan, initialized object lookup and actor-family dispatch executed. No lookup result adapter.','Team getter, localization boundary from native en_US dictionary and final string append explicitly supplied.','Missing ID emits original Unknown literal before scanning/dispatch; other malformed strings and generic native name fallback remain work.','Outer formatter callback registration/choice of wrapper and live registry lifetime remain unqualified; no audio trigger or playback claim.']}
(r/'data/4.20/audio_announcer_actor_wrappers_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_actor_wrappers.py'),r/'tools/qualify_announcer_actor_wrappers.py');print(json.dumps({'native_cases':len(cases),'missing_id_cases':sum(c['output']=='Unknown' for c in cases)}))
