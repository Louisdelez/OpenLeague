from pathlib import Path
import itertools,json,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
manager=heap+0x1000;local_actor=heap+0x2000;game=heap+0x3000;vtable=heap+0x3500;output=heap+0x4000;getter=end+0x100
write32(game,vtable);write32(vtable+0xb0,getter);write32(0x2d787b8,game)
offsets=[0xc,0x10,0x14,0x18,0x1c,0x34,0x3c,0x40,0x50,0x54]
def capture(uc,a,size,user):
 if a==getter:assert u.reg_read(UC_X86_REG_ECX)==game;calls.append(spectator_raw);finish(eax=spectator_raw);return
 assert 0x400000<=a<0x1000000,hex(a)
def memory_read(uc,access,address,size,value,user):
 if address==local_actor+0x18:assert size==4;reads.append({'op':'local_raw_team','value':local_team})
 elif manager<=address<manager+0x60:assert size==4;reads.append({'op':'palette_field','offset':address-manager,'value':read32(address)})
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_READ,memory_read);cases=[]
for entry,has_local,local_team,team,spectator_raw,layout in itertools.product([0x7de7b0,0x7de6c0],[False,True],[0,100,200,300,0xffffffff],[0,100,200,300,0x7fffffff,0xffffffff],[0,1,2,255,256,257,0x1000000,0xffffffff],['distinct','zero','ones']):
 fields={str(offset):(0x11223300+offset if layout=='distinct' else 0 if layout=='zero' else 0xffffffff) for offset in offsets}
 for offset in offsets:write32(manager+offset,fields[str(offset)])
 write32(local_actor+0x18,local_team);write32(0x2d77f48,local_actor if has_local else 0);calls=[];reads=[];write32(output,0xdeadbeef)
 sp=stack+0xc000;write32(sp,end);write32(sp+4,output);write32(sp+8,team);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager)
 u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==output
 base=0x34 if entry==0x7de7b0 else 0xc;default=0x3c if entry==0x7de7b0 else 0x10;neutral=0x40 if entry==0x7de7b0 else 0x14;blue=0x50 if entry==0x7de7b0 else 0x18;purple=0x54 if entry==0x7de7b0 else 0x1c
 chosen=(neutral if team==300 else base if local_team==team else default) if has_local else (neutral if team==300 else blue if team==100 else purple if team==200 else default) if spectator_raw&255 else default
 assert read32(output)==fields[str(chosen)] and calls==([] if has_local else [spectator_raw])
 cases.append({'entry':hex(entry),'has_local':has_local,'local_team':local_team,'team':team,'spectator_raw':spectator_raw,'fields':fields,'output':read32(output),'field_reads':reads.copy(),'spectator_calls':calls.copy()})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original team/observer palette bodies executed with exact manager field/local actor raw+18 reads and game-context spectator virtual+B0 getter; output pointer identity verified.','Spectator branch tests AL only, including values256 and257. Local actor exists bypasses spectator getter; neutral300 then bypasses local-team field. No map-mode inference introduced.','Palette field values supplied as distinct/zero/ones layouts; live palette provenance and game/local actor ownership remain incomplete. No decimal/hex conversion or playback claim.']}
(r/'data/4.20/audio_announcer_palettes_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_palettes.py'),r/'tools/qualify_announcer_palettes.py')
print(json.dumps({'native_palette_cases_prepared':len(cases)}))
