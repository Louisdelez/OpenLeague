from pathlib import Path
import itertools,json,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
actor=heap+0x1000;character=heap+0x2000;resource1=heap+0x3000;resource2=heap+0x3500;input_address=heap+0x4000;output=heap+0x4100;vtable=heap+0x5000;skin=heap+0x5500;skin_vtable=heap+0x5600
character_getter=end+0x100;skin_getter=end+0x200;icon_cache=0x2d7c364;ring_cache=0x2d7c380
write32(actor+0x3e0,vtable);write32(vtable,character_getter);write32(skin,skin_vtable);write32(skin_vtable+0x24,skin_getter)
def capture(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==character_getter:assert ecx==actor+0x3e0;ops.append('character');finish(eax=character if has_character else 0);return
 if a==skin_getter:assert ecx==skin;ops.append('skin_id');finish(eax=skin_id);return
 if a==0x564c20:
  src,n=read32(sp+4),read32(sp+8);text=bytes(u.mem_read(src,n)).decode('ascii');changes.append({'op':'assign','text':text});put(ecx,text);finish(8,ecx);return
 if a==0x564af0:
  assert read32(sp+8)==0 and read32(sp+12)==0xffffffff;text=string(read32(sp+4));changes.append({'op':'assign','text':text});put(ecx,text);finish(12,ecx);return
 if a in [0x5fa520,0x564d20]:
  text=cbytes(read32(sp+4)).decode('ascii');changes.append({'op':'append' if a==0x5fa520 else 'assign','text':text});put(ecx,(string(ecx) if a==0x5fa520 else '')+text);finish(4,ecx);return
 if a==0x993860:
  dest,n,fmt,value=[read32(sp+i) for i in [4,8,12,16]];assert n==11 and cbytes(fmt)==b'%u';text=str(value);assert len(text)+1<=n
  numeric.append({'value':value,'format':'%u','capacity':n,'output':text});u.mem_write(dest,text.encode()+b'\0');finish(eax=len(text));return
 if a==0xc97e4c:registrations.append(hex(read32(sp+4)));finish();return
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 if a==0x5fda30:
  pointer,n=read32(sp+4),read32(sp+8);outputs.append(bytes(u.mem_read(pointer,n)).hex());finish(8,output);return
 assert 0x400000<=a<0x1000000,hex(a)
def memory_read(uc,access,address,size,value,user):
 labels={actor+0x1c:'flags',character+0x9c0:'primary',character+0x9bc:'secondary',character+0x20:'skin_owner',character+0x24:'character_flags'}
 if address in labels:assert size==4;ops.append(labels[address])
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,memory_read);cases=[]
for (entry,pattern),state,res,skin_option,hidden,suffix,variant in itertools.product([(0x6d4a10,' icon@'),(0x6d4dc0,' icon@'),(0x6d4a10,' ringicon@')],['absent','unflagged','flagged_no_character','flagged','hero_only'],['none','primary','secondary','both','cache_alias'],[None,0,42,0xffffffff],[False,True],['Portrait','LongPortraitTextureName'],['exact','upper','tail']):
 cursor=heap+0x8000;exists=state!='absent';has_character=state!='flagged_no_character';flags=0x400 if state in ['flagged','flagged_no_character'] else 0x1000 if state=='hero_only' else 0
 write32(actor+0x1c,flags);write32(character+0x24,(1<<23) if hidden else 0);write32(character+0x9c0,icon_cache-0x14 if res=='cache_alias' else resource1 if res in ['primary','both'] else 0);write32(character+0x9bc,resource2 if res in ['secondary','both','cache_alias'] else 0)
 write32(character+0x20,skin if skin_option is not None else 0);skin_id=skin_option or 0;put(resource1+0x14,'PrimaryIcon');put(resource2+0x14,'SecondaryIconLongName');put(character+0x9c8,suffix)
 write32(0x2d7c360,0);write32(0x2d7c37c,0);put(icon_cache,'');put(ring_cache,'');input=pattern.upper() if variant=='upper' else pattern+'tail' if variant=='tail' else pattern
 steps=[]
 for supplied_actor in [actor if exists else 0,0,actor if exists else 0]:
  ops=[];changes=[];numeric=[];registrations=[];outputs=[];u.mem_write(input_address,input.encode()+b'\0');sp=stack+0xc000;write32(sp,end);write32(sp+4,output);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,supplied_actor)
  u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and len(outputs)==1
  steps.append({'exists':bool(supplied_actor),'output_hex':outputs[0],'ops':ops.copy(),'cache_changes':changes.copy(),'numeric_calls':numeric.copy(),'atexit_registrations':registrations.copy()})
 cases.append({'entry':hex(entry),'pattern':pattern,'input':input,'flags':flags,'has_character':has_character,'resource':res,'skin_id':skin_option,'hidden':hidden,'suffix':suffix,'steps':steps})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original icon/ringicon bodies and ordered registered dispatchers executed with three consecutive calls per case: actor, absent actor, actor. Cache initialization and retained/accumulated outputs preserved.','Class gate is actor flags bit10, not hero bit12. Resource primary+9C0 precedes fallback+9BC; resource-name object+14 alias to icon cache skips assignment. Character flag bit23 suppresses suffix or ring clearing.','Native string operations, atexit/security boundaries and bounded unsigned %u formatter supplied. Numeric values include0 andFFFFFFFF; formatting remains explicit boundary, original CRT internals and physical string allocation not qualified.','Live character/resource/skin ownership, cache concurrency, original shutdown registration and normal announcement playback remain incomplete.']}
(r/'data/4.20/audio_announcer_icons_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_icons.py'),r/'tools/qualify_announcer_icons.py')
print(json.dumps({'native_icon_cases':len(cases),'native_icon_frames':len(cases)*3}))
