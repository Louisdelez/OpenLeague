from pathlib import Path
import json,struct,itertools,shutil,re,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
actor=heap+0x7000;local=heap+0x8000;table=heap+0x9000;getter=end+0x200;output=heap+0x6000;input_address=heap+0x5000
write32(actor+0x124,table);write32(local+0x124,table);write32(table+12,getter)
pattern_address=read32(0x6d4c29);pattern=cbytes(pattern_address).decode();assert pattern==' you | hero | minion | turret@'
translation_path=r/'data/4.20/font_configuration/menu/fontconfig_en_US.txt'
translations=dict(re.findall(r'^tr "(game_announcement_replace_[^"]+)" = "([^"]*)"',translation_path.read_text(encoding='utf-8-sig'),re.M))
assert translations['game_announcement_replace_hero']=='champion'
calls=[];appends=[];flag_reads=0;localization_calls=[]
def capture(uc,a,size,user):
 if a==getter:
  assert u.reg_read(UC_X86_REG_ECX)==actor+0x124;calls.append('actor');finish(eax=team);return
 if a==0x5fda30:
  sp=u.reg_read(UC_X86_REG_ESP);ptr,n=read32(sp+4),read32(sp+8);assert u.reg_read(UC_X86_REG_ECX)==output;appends.append(bytes(u.mem_read(ptr,n)).decode('ascii'));finish(8,output);return
 if a==0x78d0d0:
  key=cbytes(u.reg_read(UC_X86_REG_ECX)).decode('ascii');localization_calls.append(key);value=translations[key];u.mem_write(heap+0xa000,value.encode('ascii')+b'\0');finish(eax=heap+0xa000);return
 assert 0x400000<=a<0x1000000,hex(a)
def memory_read(uc,access,address,size,value,user):
 global flag_reads
 if address==actor+0x1c:assert size==4;flag_reads+=1
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,memory_read);cases=[]
for identity,local_kind,flags,team,mode,token,entry in itertools.product(['null','actor'],['null','actor','other'],[0,0x800,0x1000,0x2000,0x1800,0x2800,0x3000,0x3800,0xffffffff],[100,200,300],[0,1,2,4],[pattern,pattern+'Trailing',pattern.upper(),' wrong token@'],[0x6ed1f0,0x6d4a10,0x6d4dc0]):
 if entry!=0x6ed1f0 and token==' wrong token@':continue
 calls=[];appends=[];flag_reads=0;localization_calls=[];write32(actor+0x1c,flags);write32(0x2d77f48,{'null':0,'actor':actor,'other':local}[local_kind]);write32(0x2d79058,mode)
 actor_pointer=0 if identity=='null' else actor;u.mem_write(input_address,token.encode()+b'\0');sp=stack+0x8000
 if entry==0x6ed1f0:u.mem_write(sp,struct.pack('<IIII',end,pattern_address,actor_pointer,0x6d3240));u.reg_write(UC_X86_REG_EDX,output)
 else:u.mem_write(sp,struct.pack('<II',end,output));u.reg_write(UC_X86_REG_EDX,actor_pointer)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address)
 try:u.emu_start(entry,end,count=50000)
 except Exception:
  print('fault',identity,local_kind,hex(flags),team,mode,repr(token),hex(entry),hex(u.reg_read(UC_X86_REG_EIP)));raise
 assert u.reg_read(UC_X86_REG_EIP)==end
 matched=bool(u.reg_read(UC_X86_REG_EAX)&255);assert matched==token.lower().startswith(pattern),(hex(entry),token,matched)
 cases.append({'entry':hex(entry),'actor':identity,'local':local_kind,'flags':flags,'team':team,'mode':mode,'input':token,'matched':matched,'appends':list(appends),'getter_calls':list(calls),'flag_reads':flag_reads,'localization_calls':list(localization_calls)})
proof={'native_sha256':digest,'functions':['0x6ED1F0','0x6D4A10','0x6D4DC0','0x6D3240','0x6D3410'],'translation_source':str(translation_path),'translation_sha256':hashlib.sha256(translation_path.read_bytes()).hexdigest(),'translations':translations,'pattern':pattern,'passed':True,'complete':False,'cases':cases,'limits':['Original source/destination actor dispatch, token matcher, CRT comparison and actor functions executed; team virtual getter and final string append supplied.','Original78D0D0 localization boundary adapted using preserved4.20 en_US translations, with every requested key recorded; localization internals not executed.','Actor-token match family qualified through both dispatchs. Unknown token tested only in direct matcher: outer native fallback calls6D3030/6D3090 actor-name lookup, still unqualified; no None fallback claim for complete dispatcher.','Source/destination actor pointers supplied; outer event template ownership and actor flags in live Rust game remain work.']}
(r/'data/4.20/audio_announcer_actor_binding_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_actor_binding.py'),r/'tools/qualify_announcer_actor_binding.py');print(json.dumps({'native_cases':len(cases),'matched':sum(c['matched'] for c in cases)}))
