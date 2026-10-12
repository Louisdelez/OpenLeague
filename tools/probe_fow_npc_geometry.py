from pathlib import Path
import json,struct,datetime,ast,hashlib
r=Path('E:/OpenLeague')
geometry_prerequisites=(r/'tools/probe_fow_source_release.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
exec(compile(geometry_prerequisites,'native character geometry prerequisites','exec'))
tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));parser={'struct':struct}
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'inibin parser','exec'),parser)
champions=json.loads((r/'data/4.20/collision_profiles.json').read_text(encoding='utf-8'))
all_profiles=json.loads((r/'data/4.20/native_vision_radii.json').read_text(encoding='utf-8'))['profiles']
profiles={name:dict(source=p['resource'],sha256=p['sha256']) for name,p in all_profiles.items() if name not in champions}
fields=['SelectionHeight','SelectionRadius','PathfindingCollisionRadius','GameplayCollisionRadius']
rows={}
for name,profile in profiles.items():
 path=Path(profile['source']);assert hashlib.sha256(path.read_bytes()).hexdigest()==profile['sha256']
 raw=parser['ini'](path);values={key:raw.get(parser['hashkey']('Data',key)) for key in fields}
 rows[name]=dict(source=str(path),sha256=profile['sha256'],authored={key:float(v) if v is not None else None for key,v in values.items()})
assert len(rows)==28
stub=end+0x240;return_value=end+0x400;resource=end+0x500;global_resource=end+0x600
native_code_ranges=list(native_code_ranges)+[(stub,stub+7)]
u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',return_value)+b'\xc3');u.mem_write(resource,b'character.inibin\0');u.mem_write(global_resource,b'global-config\0')
character=0x40008000;frame=sp+0x1000;requests=[];current_values={};global_override=None
def string_at(pointer):return bytes(u.mem_read(pointer,80)).split(b'\0')[0].decode('ascii')
def reader_boundary(uc,a,size,user):
 if a==0x8b1f50:
  top=u.reg_read(UC_X86_REG_ESP);res=read32(top+4);section=string_at(read32(top+8));key=string_at(read32(top+12));fallback=struct.unpack('<f',u.mem_read(top+16,4))[0]
  assert read32(top+20)==0
  value=(global_override if global_override is not None else fallback) if res==global_resource else current_values.get(key)
  if value is None:value=fallback
  assert section==('GeneralDataHero' if res==global_resource else 'Data')
  requests.append(dict(section=section,key=key,default=fallback,value=value))
  u.mem_write(return_value,struct.pack('<f',value));u.reg_write(UC_X86_REG_EIP,stub)
u.hook_add(unicorn.UC_HOOK_CODE,reader_boundary)
cases=[]
inputs=[(name,row['authored'],None) for name,row in rows.items()]+[('missing-defaults',{},None),('global-override',{},82.5),('explicit-gameplay-over-global',{'GameplayCollisionRadius':45.},82.5)]
for name,values,override in inputs:
 requests.clear();current_values=values;global_override=override;u.mem_write(character,bytes(0x700));write32(frame-0x418,global_resource)
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ESI,resource);u.reg_write(UC_X86_REG_EDI,character)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x56bd88,0x56be44,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x56be44
 result=[read32(character+o) for o in [0x60c,0x610,0x614,0x618]];assert len(requests)==5
 assert [v['key'] for v in requests]==fields[:3]+['DefaultChampionCollisionRadius','GameplayCollisionRadius']
 assert [v['default'] for v in requests[:4]]==[-1.,-1.,-1.,65.]
 case=dict(name=name,authored=values,global_override=override,result_bits=result,requests=list(requests));cases.append(case)
 if name in rows:rows[name]['native_field_bits']=result
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x56bd88',stop='0x56be44',native_addresses=len({a for a in visited if 0x56bd88<=a<0x56be44}),fields=fields,cases=cases,limits=['Original CharacterData reader call sites/default propagation and field writes execute for28authored NPC resources and3override/missing cases.8B1F50 actual configuration lookup is adapted to parsed original INIBIN values.','Global GeneralDataHero lookup supplies native fallback65 or explicit diagnostic82.5 override. Full configuration hierarchy/global resource reader is not executed; no unqualified global override silently inferred.','Field618 is GameplayCollisionRadius and native614E40 scales it by actor740. Actor field/model scale producers remain separate.','CharacterData reader entry569560 remainder, caches, skins, NPC resources and gameplay source activation/GPU remain incomplete.'])
(r/'data/4.20/fow_npc_geometry_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
(r/'data/4.20/native_npc_geometry.json').write_text(json.dumps(dict(updated_utc=proof['updated_utc'],complete=False,fields=fields,global_collision_default=65.,global_override_qualified=False,profiles=rows),indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=proof['native_addresses'],npc_profiles=len(rows),melee=rows['blue_minion_basic'])))
