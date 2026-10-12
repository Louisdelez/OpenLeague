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
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,memory_read);cases=[]
for entry,pattern,local,spectator_raw,team,layout in itertools.product([0x6d4a10,0x6d4dc0],[' teamcolor@',' teamcolorhex@',' observercolorhex@'],['none','blue','neutral'],[0,1,256,257],[0,100,200,300,0xffffffff],[0,0x11223344,0xffffffff]):
 cursor=heap+0xa000;alloc_cursor=heap+0x7000;ops=[];stream_ops=[];cleanup=[];registrations=[];outputs=[];streams.clear();fields={str(offset):layout^offset for offset in palette_offsets}
 for offset in palette_offsets:write32(manager+offset,fields[str(offset)])
 for a in flags:write32(a,0)
 local_team=300 if local=='neutral' else 100;write32(local_actor+0x18,local_team);write32(0x2d77f48,0 if local=='none' else local_actor);write32(0x14bef40,0)
 u.mem_write(input_address,pattern.encode()+b'\0');sp=stack+0xc000;write32(sp,end);write32(sp+4,output);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,actor)
 u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and len(outputs)==1
 cases.append({'entry':hex(entry),'pattern':pattern,'local':local,'local_team':local_team,'team':team,'spectator_raw':spectator_raw,'fields':fields,'output_hex':outputs[0],'ops':ops.copy(),'stream_ops':stream_ops.copy(),'cleanup':cleanup.copy(),'atexit_registrations':registrations.copy()})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original ordered dispatch, style callbacks, actual palette producers, RGB/byte helpers and complete stream constructors/default field initialization execute in one native frame. No supplied palette or RGB-helper output.','Integer/literal/string stream insertion/extraction, allocation/ref-counter, ctype facet/space widening, destruction and physical string/atexit/security boundaries supplied. Integer insertion uses explicit normal decimal/lowercase-hex primitive; native num_put/CRT/locale internals remain unqualified.','Palette values, local/game metadata and spectator getter supplied. Live ownership, concurrency, exceptions and normal announcement playback remain incomplete.']}
(r/'data/4.20/audio_announcer_rendered_styles_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_rendered_styles.py'),r/'tools/qualify_announcer_rendered_styles.py')
print(json.dumps({'native_rendered_palette_style_frames':len(cases)}))
