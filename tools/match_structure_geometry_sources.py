from pathlib import Path
import json,struct,hashlib,collections,datetime,ast
r=Path('E:/OpenLeague');deploy=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy')
parser={'struct':struct};tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'))
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'resource-parser','exec'),parser)
fingerprint=lambda values:hashlib.sha256(b''.join(sorted(set(values)))).hexdigest()
def glb_positions(path):
 b=path.read_bytes();n=struct.unpack_from('<I',b,12)[0];g=json.loads(b[20:20+n]);binary=b[28+n:];positions=[]
 for mesh in g['meshes']:
  for primitive in mesh['primitives']:
   a=g['accessors'][primitive['attributes']['POSITION']];assert a['componentType']==5126 and a['type']=='VEC3' and 'sparse' not in a
   view=g['bufferViews'][a['bufferView']];offset=view.get('byteOffset',0)+a.get('byteOffset',0);stride=view.get('byteStride',12)
   positions.extend(binary[offset+i*stride:offset+i*stride+12] for i in range(a['count']))
 return fingerprint(positions)
manifest=json.loads((r/'data/4.20/world_animation_manifest.json').read_text());prior=json.loads((r/'docs/world_spatial_source_audit.json').read_text());unresolved={row['name'] for row in prior['models'] if not row['ready_for_native_bounds_probe']}
targets={name:glb_positions(r/'assets'/manifest[name]['asset']) for name in unresolved};wanted=set(targets.values());matches=collections.defaultdict(list)
scanned=0
for path in (deploy/'DATA/Characters').rglob('*.skn'):
 b=path.read_bytes()
 try:
  magic,major,minor=struct.unpack_from('<IHH',b);assert magic==0x112233 and minor==1 and major in [0,1,2,4];offset=8
  if major:count=struct.unpack_from('<I',b,offset)[0];offset+=4+count*80
  if major<4:indices,vertices=struct.unpack_from('<II',b,offset);stride=52;offset+=8
  else:_,indices,vertices,stride,kind=struct.unpack_from('<5I',b,offset);offset+=60;assert stride in [52,56]
  offset+=indices*2;assert len(b)>=offset+vertices*stride
  key=fingerprint([b[offset+i*stride:offset+i*stride+12] for i in range(vertices)]);scanned+=1
  if key in wanted:matches[key].append(dict(mesh=str(path),sha256=hashlib.sha256(b).hexdigest(),vertices=vertices))
 except (AssertionError,struct.error):continue
rows=[]
for name,key in sorted(targets.items()):
 candidates=matches[key];config=deploy/'DATA/Characters'/name/(name+'.inibin')
 if not config.is_file():config=None
 if config:
  base=config.parent/'Skins/Base/Base.inibin'
  if base.is_file():config=base
 fields={}
 if config:
  props=parser['ini'](config);fields={k:props.get(parser['hashkey']('MeshSkin',k)) for k in ['SimpleSkin','SkinScale','OverrideBoundingBox']}
 rows.append(dict(name=name,render_asset=manifest[name]['asset'],render_sha256=hashlib.sha256((r/'assets'/manifest[name]['asset']).read_bytes()).hexdigest(),position_set_sha256=key,source_matches=candidates,config=str(config) if config else None,config_sha256=hashlib.sha256(config.read_bytes()).hexdigest() if config else None,fields=fields))
report=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,scanned_original_meshes=scanned,models=rows,limits=['Exact original/rendered vertex-position byte set match only. Deduplicated position set does not qualify topology, rig or full source model identity.','Multiple source meshes remain listed; configuration resource hierarchy and destroyed/altar native model selection remain unqualified.'])
(r/'docs/structure_spatial_geometry_matches.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(scanned=scanned,matched=sum(bool(row['source_matches']) for row in rows),models=[dict(name=row['name'],sources=len(row['source_matches']),config=row['config'],scale=row['fields'].get('SkinScale')) for row in rows])))
