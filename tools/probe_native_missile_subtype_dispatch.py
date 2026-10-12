from pathlib import Path
import json,hashlib,datetime,shutil,struct
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
body=vector+0x6000;config=vector+0x9000
seen=[];visited=set()
def hook(uc,a,size,user):
 visited.add(a)
 if a in [0x760610,0x760bb0,0x760f10,0x7613c0,0x76f0d0,0x991e60]:
  seen.append(a);uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for kind in [0,1,2,3,4,5,255,0xffffffff]:
 u.mem_write(body,b'\0'*0x600);u.mem_write(config,b'\0'*0x800)
 w(body,config);w(config+0x5e8,kind);u.reg_write(UC_X86_REG_EDI,body);u.reg_write(UC_X86_REG_ESI,0);u.reg_write(UC_X86_REG_EBP,stack+0x100);u.reg_write(UC_X86_REG_ESP,stack)
 seen.clear();u.emu_start(0x7617f8,end,count=200);assert len(seen)==1
 expected={0:0x76f0d0,1:0x760610,2:0x760bb0,3:0x760f10,4:0x7613c0}.get(kind,0x991e60)
 assert seen[0]==expected
 cases.append(dict(raw_type=kind,reached=hex(seen[0])))
# Original bytes, not inferred class names.
assert bytes(u.mem_read(0x10b2b5c+0xe0,4))==struct.pack('<I',0x75fb00)
assert b'SpellMissileClient\0'==bytes(u.mem_read(0x10b49b0,19))
assert bytes(u.mem_read(0x7630db,6))==bytes.fromhex('c7005c2b0b01')
assert bytes(u.mem_read(0x529fd0,30)).find(struct.pack('<I',0x7600e0))>=0
assert bytes(u.mem_read(0x760158,5))==b'\xe8'+struct.pack('<i',0x763010-0x76015d)
assert bytes(u.mem_read(0x76086e,5))==b'\xe8'+struct.pack('<i',0x7172b0-0x760873)
assert bytes(u.mem_read(0x760862,6))==bytes.fromhex('8b0dc42bd602')
assert bytes(u.mem_read(0x76838c,6))==bytes.fromhex('8986b4050000')
assert bytes(u.mem_read(0x10b51cc,9))==b'CastType\0'
assert bytes(u.mem_read(0x10882a8,21))==b'obj_BarracksDampener\0'
spells=json.loads((r/'data/4.20/native_spells_420.json').read_text(encoding='utf-8-sig'))
annie=next(x for x in spells if x['champion']=='Annie' and x['slot']==0)
import ast
t=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));ns={'struct':struct};exec(compile(ast.Module(body=[x for x in t.body if isinstance(x,ast.FunctionDef) and x.name in ['ini','hashkey']],type_ignores=[]),'parse','exec'),ns)
native_file=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Characters/Annie/Spells/Disintegrate.inibin');native=ns['ini'](native_file)
assert native[ns['hashkey']('SpellData','CastType')]==1
assert native[ns['hashkey']('SpellData','TargettingType')]==1
assert native[ns['hashkey']('SpellData','MissileEffect')]=='Annie_Q_mis.troy'
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x7617f8',cases=cases,native_instruction_addresses=len(visited),class_chain=dict(registration='0x529fd0',name='SpellMissileClient',type_descriptor='0x2d62bc4',factory='0x7600e0',constructor='0x763010',object_vtable='0x10b2b5c',direction_virtual_slot='0xe0',direction_entry='0x75fb00',type1_factory_call='0x76086e'),corrected_generic_owner_branch=dict(type_descriptor='0x2d6da00',registration='0x52d5f0',name='obj_BarracksDampener',note='Inhibitor, not missile. Generic actor owner comparisons remain valid; earlier synthetic kind label is not class identity.'),annie=dict(spell=annie['spell'],native_resource=annie['native_resource'],source_sha256=annie['sha256'],original_inibin=str(native_file),original_inibin_sha256=hashlib.sha256(native_file.read_bytes()).hexdigest(),native_fields_checked=['CastType','TargettingType','MissileEffect'],fields={k:v for k,v in annie['values'].items() if k in ['CastType','TargettingType','MissileSpeed','MissileAccel','MissileFixedTravelTime','MissileMaxSpeed','MissileMinSpeed','MissileTargetHeightAugment','MissileEffect']}),limits=['Dispatch runs original instructions; execution stops at selected callee, not full missile creation.','Native CastType load stores inner+5B4; wrapper prefix34 gives+5E8. Original Annie INIBIN CastType=1 selects760610 and SpellMissileClient, not SpellLineMissileClient. Full ordinary creation and movement remain unexecuted here.','Class registration/constructor/table chain checked against original bytes; full allocator/Object lifecycle unexecuted here.','No Rust gameplay integration, client build, GPU/audio acceptance or full-suite rerun.'])
p=r/'data/4.20/missile_subtype_dispatch_contract.json';p.write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_instruction_addresses=len(visited),annie_fields=proof['annie']['fields'])))
