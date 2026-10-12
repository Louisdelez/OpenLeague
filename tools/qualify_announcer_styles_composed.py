from pathlib import Path
import itertools,json,shutil
bootstrap=Path('E:/OpenLeague/tools/qualify_announcer_style_control.py').read_text(encoding='utf-8').split('for entry,pattern,exists,team,packed,response,allocator,variant')[0]
bootstrap=bootstrap.replace('u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,memory_read);cases=[]','cases=[]')
exec(compile(bootstrap,'qualify_announcer_style_control_bootstrap','exec'))
legacy_capture=capture;legacy_read=memory_read;local_actor=heap+0x5000;game=heap+0x5500;game_vtable=heap+0x5800;spectator_getter=end+0x300
write32(game,game_vtable);write32(game_vtable+0xb0,spectator_getter);write32(0x2d787b8,game)
palette_offsets=[0xc,0x10,0x14,0x18,0x1c,0x34,0x3c,0x40,0x50,0x54]
def capture(uc,a,size,user):
 if a==spectator_getter:assert u.reg_read(UC_X86_REG_ECX)==game;ops.append({'op':'spectator_raw','value':spectator_raw});finish(eax=spectator_raw);return
 if a in [0x7de7b0,0x7de6c0]:
  sp=u.reg_read(UC_X86_REG_ESP);value=read32(sp+8);assert u.reg_read(UC_X86_REG_ECX)==manager and value==team;ops.append({'op':'team_palette' if a==0x7de7b0 else 'observer_palette','team':value});return
 legacy_capture(uc,a,size,user)
def memory_read(uc,access,address,size,value,user):
 if address==local_actor+0x18:assert size==4;ops.append({'op':'local_raw_team','value':local_team});return
 if address-manager in palette_offsets:assert size==4;ops.append({'op':'palette_field','offset':address-manager,'value':read32(address)});return
 legacy_read(uc,access,address,size,value,user)
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,memory_read)
for entry,pattern,local,spectator_raw,team,response in itertools.product([0x6d4a10,0x6d4dc0],[' teamcolor@',' teamcolorhex@',' observercolorhex@'],['none','blue','neutral'],[0,1,256,257],[0,100,200,300,0xffffffff],['','ABCDEF']):
 cursor=heap+0x7000;ops=[];cleanup=[];registrations=[];outputs=[];fields={str(offset):0x11223300+offset for offset in palette_offsets}
 for offset in palette_offsets:write32(manager+offset,fields[str(offset)])
 for a in flags:write32(a,0)
 local_team=300 if local=='neutral' else 100;write32(local_actor+0x18,local_team);write32(0x2d77f48,0 if local=='none' else local_actor);write32(0x14bef40,0)
 u.mem_write(input_address,pattern.encode()+b'\0');sp=stack+0xc000;write32(sp,end);write32(sp+4,output);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,actor)
 u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and len(outputs)==1
 cases.append({'entry':hex(entry),'pattern':pattern,'local':local,'local_team':local_team,'team':team,'spectator_raw':spectator_raw,'fields':fields,'supplied_converter_result':response,'output_hex':outputs[0],'ops':ops.copy(),'cleanup':cleanup.copy(),'atexit_registrations':registrations.copy()})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original registered teamcolor/teamcolorhex/observercolorhex bodies, ordered dispatchers and actual7DE7B0/7DE6C0 palette producers execute in one composed native frame.','Spectator virtual getter, palette/local actor storage, decimal/hex stream conversion and physical string/cleanup/atexit/security boundaries supplied. This proves palette/style composition and read order; actual stream color formatting and live palette values remain unqualified.','Live UI manager/local actor ownership, exceptional storage/CRT paths, cache concurrency and normal announcement playback remain incomplete.']}
(r/'data/4.20/audio_announcer_styles_composed_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_styles_composed.py'),r/'tools/qualify_announcer_styles_composed.py')
print(json.dumps({'native_composed_palette_style_cases':len(cases)}))
