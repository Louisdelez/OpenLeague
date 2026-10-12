from pathlib import Path
import itertools,json,shutil
bootstrap=Path('E:/OpenLeague/tools/qualify_announcer_styles_composed.py').read_text(encoding='utf-8').split('for entry,pattern,local,spectator_raw,team,response')[0]
bootstrap=bootstrap.replace('\nu.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,memory_read)\n','\n')
exec(compile(bootstrap,'native_composed_style_bootstrap','exec'))
outer_capture=capture;facet=heap+0x6000;facet_vtable=heap+0x6100;widen=end+0x400;write32(facet,facet_vtable);write32(facet_vtable+0x20,widen);streams={};fmt_offset=0x6c
def capture(uc,a,size,user):
 global alloc_cursor
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a in [0x8e1db0,0x8e1b30]:ops.append({'op':'decimal_color' if a==0x8e1db0 else 'hex_color','packed':read32(u.reg_read(UC_X86_REG_EDX))});return
 if a==0x5f8590:streams[ecx+16]='';return # Execute actual constructor/default flags instead of a supplied result.
 if a in [0x9933e0,0xce0d77]:alloc_cursor+=16;finish(eax=alloc_cursor);return
 if a==0x5fca80:dest=read32(sp+4);write32(dest,0);finish(4,dest);return
 if a==0x5fc1b0:finish(eax=facet);return
 if a==widen:assert read32(sp+4)==32;finish(4,32);return
 if a in [0x5f95b0,0xce15c9]:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 if a==0x5fd260:
  value=read32(sp+4);raw_flags=read32(ecx+fmt_offset);assert value<=255 and raw_flags in [0x201,0x801];text=format(value,'x') if raw_flags&0x800 else str(value);streams[ecx]+=text;stream_ops.append({'op':'integer','value':value,'flags':raw_flags,'supplied_output':text});finish(4,ecx);return
 if a==0x5fd400:
  stream,src=read32(sp+4),read32(sp+8);text=cbytes(src).decode('ascii');streams[stream]+=text;stream_ops.append({'op':'literal','text':text});finish(eax=stream);return
 if a==0x5fe070:
  stream,src=read32(sp+4),read32(sp+8);text=string(src);streams[stream]+=text;stream_ops.append({'op':'string','text':text});finish(eax=stream);return
 if a==0x5f99e0:dest=read32(sp+4);put(dest,streams[ecx+16]);finish(4,dest);return
 outer_capture(uc,a,size,user)
cases=[]
import re,struct
old_capture=capture;character=heap+0x8000;lane_owner=heap+0x6500;gate=heap+0x6800;skin=heap+0x6900;skin_table=heap+0x6a00;converted=heap+0x6b00;champion_raw=heap+0x6c00;resource=heap+0x6d00;actor_table=heap+0x6e00;character_table=heap+0x6e50;float_storage=heap+0x6f00
skin_get=end+0x500;name_get=end+0x510;lane_get=end+0x520;character_get=end+0x530;float_get=end+0x540
write32(actor,actor_table);write32(actor_table+0x278,float_get);write32(actor_table+0x1f8,name_get);write32(actor_table+0x258,lane_get);write32(actor+0x3e0,character_table);write32(character_table,character_get);write32(actor+0x18b8,lane_owner);write32(local_actor+0x124,vtable)
write32(character+0x9e4,gate);write32(character+0x20,skin);write32(skin,skin_table);write32(skin_table+0x24,skin_get)
u.mem_write(float_storage,struct.pack('<f',2.5));u.mem_write(float_get,b'\xd9\x05'+struct.pack('<I',float_storage)+b'\xc3');u.mem_write(champion_raw,b'UnitChampion\0');put(converted,'PlayerName');put(actor+0x211c,'FallbackName');put(character+0x944,'CharacterName');put(character+0x9c8,'Portrait');put(resource+0x14,'PrimaryIcon')
translations=dict(re.findall(r'^tr "(game_announcement_replace_[^"]+)" = "([^"]*)"',(r/'data/4.20/font_configuration/menu/fontconfig_en_US.txt').read_text(encoding='utf-8-sig'),re.M))
def capture(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==0x62b380:lookup_keys.append(read32(sp+4))
 if a==getter:assert ecx in [actor+0x124,local_actor+0x124];finish(eax=team if ecx==actor+0x124 else local_team);return
 if a==character_get:finish(eax=character if has_character else 0);return
 if a==name_get:finish(eax=champion_raw);return
 if a==lane_get:finish(eax=lane);return
 if a==skin_get:finish(eax=42);return
 if float_get<=a<float_get+7:return
 if a==0x716ce0:finish(eax=converted);return
 if a==0x78d0d0:
  key=cbytes(ecx).decode('ascii');u.mem_write(heap+0xe000,translations[key].encode()+b'\0');finish(eax=heap+0xe000);return
 if a==0xc9811c:
  dest,fmt=read32(sp+4),read32(sp+8);number=struct.unpack('<d',u.mem_read(sp+12,8))[0];assert cbytes(fmt)==b'%.0f' and number==2.5;u.mem_write(dest,b'3\0');finish(eax=1);return
 if a==0x564af0:
  assert read32(sp+8)==0 and read32(sp+12)==0xffffffff;put(ecx,string(read32(sp+4)));finish(12,ecx);return
 if a==0x5fa520 and ecx==output:outputs.append(cbytes(read32(sp+4)).hex());finish(4,output);return
 if a in [0x5fa520,0x564d20]:
  text=cbytes(read32(sp+4)).decode('ascii');put(ecx,(string(ecx) if a==0x5fa520 else '')+text);finish(4,ecx);return
 if a==0x993860:
  dest,n,fmt,value=[read32(sp+i) for i in [4,8,12,16]];assert n==11 and cbytes(fmt)==b'%u';text=str(value);u.mem_write(dest,text.encode()+b'\0');finish(eax=len(text));return
 old_capture(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,memory_read)
inventory=json.loads((r/'data/4.20/audio_announcer_dispatch_inventory.json').read_text());patterns=[b['literal_pattern'] or (' have | has@' if b['matcher']=='0x6ed260' else ' dampener lane@') for b in inventory['tables']['plain']['bindings']]+[' unknown@','name@',' name\0@']
scenarios=[(False,0,100,'none',False,False,0,1,0,2,True),(True,0,100,'none',False,False,1,4,1,2,True),(True,0x1000,100,'self',True,False,2,2,0,2,True),(True,0x1400,200,'other',True,False,0,1,257,0,True),(True,0x2000,300,'other',False,False,1,5,0,2,True),(True,0x800,200,'none',False,False,2,3,1,0,True),(True,0x400,300,'none',True,True,0,1,1,2,True),(True,0x400,100,'other',False,False,1,4,0,2,True),(True,0x1400,300,'none',True,False,2,2,257,2,False)]
registry_base=0x33000000;u.mem_map(registry_base,0x10000)
registry=json.loads((r/'data/4.20/audio_announcer_actor_wrappers_contract.json').read_text())['registry_layout']
def relocate(v):return registry_base+v-heap if heap<=v<heap+0x10000 else v
registry_words={relocate(a):relocate(v) for a,v in registry['words']}
old_words=dict(registry['words'])
for address,key in registry['words']:
 if heap+0x2000<=address<heap+0x3000 and (address-(heap+0x2000))%32==8 and key in [42,100]:registry_words[relocate(address+4)]=actor if key==42 else local_actor
for a,v in registry_words.items():write32(a,v)
registry_manager=relocate(registry['manager']);scenarios=[scenarios[3]];input_address=0x34000000;u.mem_map(input_address,0x10000)
cases=[]
for epoch,scenario in enumerate(scenarios):
 exists,actor_flags,team,local,has_character,hidden,lane,kind,spectator_raw,mode,has_resource=scenario
 cursor=heap+0xa000;alloc_cursor=heap+0x7000;write32(actor+0x1c,actor_flags);write32(actor+0x18,team);local_team=team if local=='self' else 200;write32(local_actor+0x18,local_team);write32(0x2d77f48,actor if local=='self' else local_actor if local=='other' else 0);write32(0x2d79058,mode);write32(lane_owner+12,lane);write32(actor+0x2290,kind);u.mem_write(gate+0x10,b'\1');write32(character+0x24,1<<23 if hidden else 0);write32(character+0x9c0,resource if has_resource else 0);write32(character+0x9bc,0);write32(0x14bef40,0)
 fields={str(offset):0x11223300+offset for offset in [*palette_offsets,0x58,0x68,0x6c]}
 for offset,value in fields.items():write32(manager+int(offset),value)
 for address in [*flags,0x2d7c360,0x2d7c37c]:write32(address,0)
 put(0x2d7c364,'');put(0x2d7c380,'')
 for entry,pattern,variant,prefix,key in itertools.product([0x6e9da0,0x6e9e00],[' bounty@'],['exact'],[b'x'*4097,b'x'*8192,b'\xff'*4097,b'\xff'*8192],[42,999]):
  if not exists and pattern==' observercolorhex@':continue
  alloc_cursor=heap+0x7000; text=pattern.upper() if variant=='upper' else pattern+'tail' if variant=='tail' else pattern;ops=[];stream_ops=[];cleanup=[];registrations=[];outputs=[];lookup_keys=[];streams.clear();raw_input=prefix+text.encode();u.mem_write(input_address,raw_input+b'\0');sp=stack+0xc000;write32(sp,end);write32(sp+4,key);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,output)
  try:u.emu_start(entry,end,count=200000)
  except Exception:print(epoch,hex(entry),repr(text),hex(u.reg_read(UC_X86_REG_EIP)));raise
  assert u.reg_read(UC_X86_REG_EIP)==end and len(outputs)==1,(epoch,hex(entry),repr(text),hex(u.reg_read(UC_X86_REG_EIP)),len(outputs))
  cases.append({'epoch':epoch,'entry':hex(entry),'input_hex':raw_input.hex(),'key':key,'lookup_keys':lookup_keys.copy(),'exists':exists,'flags':actor_flags,'team':team,'local':local,'local_team':local_team,'has_character':has_character,'hidden':hidden,'lane':lane,'kind':kind,'spectator_raw':spectator_raw,'mode':mode,'has_resource':has_resource,'fields':fields,'output_hex':outputs[0],'atexit_registrations':registrations.copy()})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'translations':translations,'registry_layout':{'manager':registry_manager,'words':list(registry_words.items())},'actor':actor,'local_actor':local_actor,'limits':['Original6E9DA0/6E9E00 wrappers, initialized62B380/5C6830 registry lookup and signed CRT hash, ordered dispatch and all registered family bodies execute in shared-cache sequences; no supplied registry lookup result. Valid42 and missing999 IDs, Long4097/8192byte ASCII/non-ASCII prefixes included; actual native prefix scanner has no4096byte input limit. actual RGB helpers/palette selectors and constructors execute. Epochs vary actor/class/local/team/character/resource/hidden/lane/mode; both forms include unregistered-family fallbacks and NUL/missing-space inputs.','Native integer/literal/string stream primitives, float2.5 %.0f result3 (independently qualified by actual CRT), unsigned skin formatter, converted-name provider, metadata getters/font values and physical SSO operations/cleanup/atexit/security supplied. No whole family/callback result supplied. Native champion secure copy/scan executes.','Null observer getter omitted here because its real fault is independently qualified. Live physical ownership/registry/callback registration, throwing/native locales and playback remain incomplete.']}
(r/'data/4.20/audio_announcer_long_prefix_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_long_prefix.py'),r/'tools/qualify_announcer_long_prefix.py');print(json.dumps({'native_long_prefix_cases':len(cases)}))
