from pathlib import Path
import itertools,json,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
actor=heap+0x1000;vtable=heap+0x2000;manager=heap+0x2500;input_address=heap+0x3000;output=heap+0x3100;getter=end+0x100;custom_free=end+0x200
write32(actor+0x124,vtable);write32(vtable+12,getter);write32(0x2d78d28,manager)
flags=[0x2d7c0b4,0x2d7c0d0,0x2d7c0ec,0x2d7c108,0x2d7c124,0x2d7c140]
def capture(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==getter:assert ecx==actor+0x124;ops.append({'op':'team','value':team});finish(eax=team);return
 if a in [0x7de7b0,0x7de6c0]:
  dest,value=read32(sp+4),read32(sp+8);assert ecx==manager and value==team;ops.append({'op':'team_palette' if a==0x7de7b0 else 'observer_palette','team':value});write32(dest,packed);finish(8,dest);return
 if a in [0x8e1db0,0x8e1b30]:
  value=read32(u.reg_read(UC_X86_REG_EDX));ops.append({'op':'decimal_color' if a==0x8e1db0 else 'hex_color','packed':value});put(ecx,response);finish(eax=ecx);return
 if a==0x6ee4b0:
  pos,src,n=read32(sp+4),read32(sp+8),read32(sp+12);assert pos==0 and cbytes(src)==b'#' and n==1;ops.append({'op':'prefix','text':'#'});put(ecx,'#'+string(ecx));finish(12,ecx);return
 if a in [0x5fadb0,0x5fe790,0x5fe7f0]:
  src=read32(sp+4);text=string(src);put(ecx,text);put(src,'');finish(4,ecx);return
 if a==0x564c20:src,n=read32(sp+4),read32(sp+8);put(ecx,bytes(u.mem_read(src,n)).decode('ascii'));finish(8,ecx);return
 if a==0x564900:
  cleanup.append({'op':'temporary_destroy','capacity':read32(ecx+20)});finish(eax=ecx);return
 if a in [0xc98528,custom_free]:
  cleanup.append({'op':'custom_free' if a==custom_free else 'standard_free','context':read32(sp+8) if a==custom_free else None});finish();return
 if a==0xc97e4c:registrations.append(hex(read32(sp+4)));finish();return
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 if a==0x5fda30:pointer,n=read32(sp+4),read32(sp+8);outputs.append(bytes(u.mem_read(pointer,n)).hex());finish(8,output);return
 assert 0x400000<=a<0x1000000,hex(a)
def memory_read(uc,access,address,size,value,user):
 if address in [manager+0x58,manager+0x6c,manager+0x68]:assert size==4;ops.append({'op':'palette_field','offset':address-manager,'value':read32(address)})
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,memory_read);cases=[]
patterns=[' teamcolor@',' teamcolorhex@',' observercolorhex@',' goldcolorhex@',' itemcalloutitemhex@',' itemcalloutbodyhex@']
for entry,pattern,exists,team,packed,response,allocator,variant in itertools.product([0x6d4a10,0x6d4dc0],patterns,[False,True],[0,100,200,300,0xffffffff],[0,0x11223344,0xffffffff],['','abc123','LONG_SUPPLIED_CONVERTER_RESULT'],['standard','custom'],['exact','upper','tail']):
 if pattern==' observercolorhex@' and not exists:continue # Native body has no actor-null guard; supplied zero-page must not fake a valid team.
 cursor=heap+0x7000;ops=[];cleanup=[];registrations=[];outputs=[]
 for a in flags:write32(a,0)
 for offset in [0x58,0x68,0x6c]:write32(manager+offset,packed^offset)
 write32(0x14bef40,custom_free if allocator=='custom' else 0);write32(0x14bef44,0x12345678)
 input=pattern.upper() if variant=='upper' else pattern+'tail' if variant=='tail' else pattern;u.mem_write(input_address,input.encode()+b'\0');sp=stack+0xc000;write32(sp,end);write32(sp+4,output);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,actor if exists else 0)
 u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and len(outputs)==1
 cases.append({'entry':hex(entry),'pattern':pattern,'input':input,'exists':exists,'team':team,'packed':packed,'supplied_converter_result':response,'allocator':allocator,'output_hex':outputs[0],'ops':ops.copy(),'cleanup':cleanup.copy(),'atexit_registrations':registrations.copy()})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original six style callbacks and both ordered dispatchers execute. Team/observer palette providers and decimal/hex conversion results deliberately supplied as arbitrary boundary values; these cases qualify control/data flow, not color conversion semantics or actual live palette values.','Original prefix helper6ED1A0 executes; insertion leaf and physical string moves/copies/destruction/free/atexit/security supplied. Standard/custom outer cleanup branches captured.','Observercolorhex has no null-actor check; absent-actor cases excluded to avoid fake success from shared harness mapped zero-page. Segmented FS-aware fault qualification required.','Native palette generation, stream formatting/locale, physical storage/lifetimes, live source values and normal announcement playback remain incomplete.']}
(r/'data/4.20/audio_announcer_style_control_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_style_control.py'),r/'tools/qualify_announcer_style_control.py')
print(json.dumps({'native_style_control_cases_prepared':len(cases)}))
