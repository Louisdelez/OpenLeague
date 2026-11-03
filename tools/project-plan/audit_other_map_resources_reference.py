"""Other-map resource/consumer trace. Static inventory is not effective gameplay."""
import collections,hashlib,json,math,pathlib,re,struct,sys
R=pathlib.Path('F:/OpenLeague');sys.path[:0]=[str(R/'tools'),str(R/'tools/project-plan')]
from rads_reference_membership import identity as pin
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(value,message):
 if not value:raise ValueError(message)
from native_lua import Chunk,initialization
from rads_reference_membership import RadsReferenceMembership
from fidelity_ids import positional_subject_key,canonical_task_key,IdentityError
TARGETS=[f'SYS-11.2-{i:02}' for i in range(1,5)];BOUNDARIES=set(TARGETS)
MAPS=['Map1','map11','Map8','Map12']
LOCAL=['crates/core/src/world.rs','tools/native_lua.py','tools/project-plan/fidelity_ids.py','crates/core/src/lib.rs','crates/server/src/main.rs','crates/client/src/native_minimap_geometry.rs','crates/client/src/native_minimap.rs']
SPECS={TARGETS[0]:[(0,'pub fn enable_map10(&mut self) -> Result<(), String> {'),(1,'def initialization(proto):')],TARGETS[1]:[(2,'def positional_subject_key(task):'),(2,'def canonical_task_key(task):')],TARGETS[2]:[(3,'pub fn load(metadata: &str, bytes: &[u8]) -> Result<Self, String> {'),(4,'let navigation = Navigation::load(')],TARGETS[3]:[(5,'pub fn map10()->Result<Self,String> {'),(5,'pub fn project(self,r:Rect,p:Point)->Option<Vec2> {'),(6,'fn sources(hud:&StartupHud)->Result<Vec<Panel>,String> {'),(6,'let rect=rect.ok_or("minimap content unavailable")?;let markers=markers(snapshot,rect,Projection::map10()?)?;')]}
FINDINGS={
 TARGETS[0]:('Les scripts NeutralMinionSpawn des quatre cartes livrent des tables statiques de points et compositions ; leur évaluation locale s’arrête avant la logique de peuplement des camps. Les marqueurs SCO et conteneurs MapObjects.mob sont identifiés séparément. Le consommateur courant enable_map10 charge uniquement map10_world.','Qualifier le montage,les placements MOB et les callbacks qui remplissent les camps ; les tables initiales et marqueurs nommés ne sont ni un inventaire exhaustif de structures actives ni un monde jouable pour chaque carte.'),
 TARGETS[1]:('La politique actuelle de clés STRUCTURE/CAMP utilise entity et action ; un champ map séparé ne change pas la clé. Deux HQ_T1 de cartes différentes auraient la même clé sémantique si leur entity reste non qualifiée. Les noms natifs sont conservés avec leur carte dans le reçu.','Créer les fiches futures avec identité de carte explicite et provenance,après qualification des objets ; conserver les alias/identités existants et ne pas traiter des noms identiques comme un seul objet. Ce lot ne crée ni n’accepte ces fiches.'),
 TARGETS[2]:('Les quatre AIPath sont liés à leur terrain.inibin par carte et manifeste. Le préfixe Map11 est5.1.0,Map8 est3.1.1,Map1/Map12 sont3.1.0 ; seuls les champs communs de début sont relevés. Navigation::load consomme un format local compact11octets/cellule et le serveur lui fournit la grille TT.','Qualifier le lecteur natif de chaque variante,les transformations et la correspondance terrain/grille complète ; ne pas appliquer implicitement les offsets des cellules Map10 au format5 ni assimiler le format compact local au fichier AIPath natif.'),
 TARGETS[3]:('Les DDS minimap de chaque carte sont identifiés avec dimensions/formats ; les bornes SCB disponibles sont séparées de la bounding box AIPath. Projection::map10 utilise le SCB TT et un pan central ; sources filtre ShadowIslesMinimapRight.ini,update appelle Projection::map10.','Relier chaque texture,les bornes effectives,zoom/pan et transformations du contrôleur de sa carte,puis vérifier des points en rendu ; une image et les en-têtes de fichiers ne prouvent pas l’alignement. Les absences locales restent limitées aux chemins inspectés.')}

def anchor(root,tid,i,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+tid+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='other_map_resources_boundary_'+tid.replace('-','_').replace('.','_')+'_'+str(i))

def _collect(root=R):
 root=pathlib.Path(root).resolve();pins={};checks=[]
 location=load(root/'docs/project_location.json')
 require(location['schema']=='openleague-project-location/v1' and pathlib.Path(location['active_root']).resolve()==root,'explicit active project root')
 reference_root=pathlib.Path(location['previous_root']).resolve(strict=True)
 require(reference_root!=root and location['external_historical_sources_preserved'] is True,'explicit historical reference root')
 m=RadsReferenceMembership(reference_root)
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 keep(root/'docs/project_location.json');current_catalogue=keep(root/'data/4.20/recovered_rads_manifests.json')
 check('copied_catalogue_matches_historical_reference',all(current_catalogue[k]==m.catalogue_identity[k] for k in ['bytes','sha256']))
 check('current_verifier_imported_from_active_project',pathlib.Path(sys.modules['rads_reference_membership'].__file__).resolve()==root/'tools/project-plan/rads_reference_membership.py')
 for s in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[z['identity'] for z in m.manifests],*m.provenance]:keep(s['path'])
 def native(p):
  p=pathlib.Path(p);s=keep(p);member=m.inspect(p.relative_to(m.deploy).as_posix(),p,s);checks.append('membership_inspected_'+member['logical_path']);return dict(source=s,membership=member)
 maps=[];members=[]
 for name in MAPS:
  base=m.deploy/'LEVELS'/name;ns=native(base/'Scripts/NeutralMinionSpawn.luaobj');raw=pathlib.Path(ns['source']['path']).read_bytes();reader=Chunk(raw);proto=reader.function();check('Lua_complete_'+name,reader.i==len(raw));init=initialization(proto);g=init['globals']
  tables={k:g[k] for k in ['NeutralMinionNames','DefaultNeutralMinionValues','CampSpawnPoints','CampFacePoints','PredefinedCamps','NeutralMinionCamps']};tables=json.loads(json.dumps(tables))
  counts={k:len(v) for k,v in tables.items()};check('static_stop_retained_'+name,init['stopped'] is not None);check('empty_runtime_camps_retained_'+name,all(v=={} for v in tables['NeutralMinionCamps'].values()))
  lua=dict(resource=ns,initial_tables=tables,table_counts=counts,stop=init['stopped'],callbacks_executed=False,effective_camps_qualified=False)
  scene=base/'Scene';selected=sorted([p for p in scene.glob('*.sco') if re.match(r'^(Barracks_|HQ_|Turret_|Info_|__Spawn_|__P_.*Barracks)',p.name,re.I)],key=lambda p:p.name.casefold())
  candidates=[]
  for p in selected:
   s=native(p);text=p.read_text(encoding='utf8');hits=re.findall(r'^CentralPoint=\s*([^\r\n]+)',text,re.M);check('marker_point_'+name+'_'+p.name,len(hits)==1);xyz=list(map(float,hits[0].split()));check('finite_marker_'+name+'_'+p.name,len(xyz)==3 and all(map(math.isfinite,xyz)));candidates.append(dict(name=p.stem,resource=s,central_point=xyz,role_from_filename_only=True,active_object_qualified=False))
  mobpath=scene/'MapObjects.mob';mob=dict(resource=native(mobpath),placement_parser_qualified=False) if mobpath.exists() else dict(inspected_path=str(mobpath),present=False,global_absence_inferred=False)
  nav=native(base/'AIPath.aimesh_ngrid');b=pathlib.Path(nav['source']['path']).read_bytes();check('nav_header_length_'+name,len(b)>=39);head=struct.unpack_from('<6ffII',b,3);check('nav_common_header_sane_'+name,all(map(math.isfinite,head[:7])) and head[6]>0 and head[7]>0 and head[8]>0)
  navigation=dict(resource=nav,version_prefix=list(b[:3]),common_header_candidate=dict(min=list(head[:3]),max=list(head[3:6]),cell_size=head[6],width=head[7],height=head[8]),native_cell_layout_qualified=False,compact_local_equivalent_qualified=False,terrain=native(base/'terrain.inibin'))
  dds=native(base/'INFO/2DLevelMiniMap.dds');b=pathlib.Path(dds['source']['path']).read_bytes();check('dds_header_'+name,len(b)>=128 and b[:4]==b'DDS ' and struct.unpack_from('<I',b,4)[0]==124);height,width=struct.unpack_from('<II',b,12);check('dds_dimensions_'+name,height>0 and width>0)
  mini=dict(resource=dds,width=width,height=height,mip_count=struct.unpack_from('<I',b,28)[0],pixel_flags=struct.unpack_from('<I',b,80)[0],fourcc_hex=b[84:88].hex(),decoded_or_rendered=False,coordinate_alignment_qualified=False)
  bp=scene/'__LevelSize_.scb'
  if bp.exists():
   s=native(bp);b=bp.read_bytes();check('SCB_header_'+name,b[:12]==b'r3d2Mesh\x02\0\x02\0' and len(b)>=176);bounds=list(struct.unpack_from('<6f',b,152));check('SCB_finite_'+name,all(map(math.isfinite,bounds)));scb=dict(resource=s,bounds=bounds,controller_binding_qualified=False)
  else:scb=dict(inspected_path=str(bp),present=False,global_absence_inferred=False)
  maps.append(dict(map_directory=name,lua=lua,candidate_markers=candidates,mob=mob,navigation=navigation,minimap=mini,level_bounds=scb,complete_map_inventory=False))
 check('distinct_grid_versions',[x['navigation']['version_prefix'] for x in maps]==[[3,1,0],[5,1,0],[3,1,1],[3,1,0]])
 check('point_table_counts',[x['lua']['table_counts']['CampSpawnPoints'] for x in maps]==[14,16,10,4]);check('composition_table_counts',[x['lua']['table_counts']['PredefinedCamps'] for x in maps]==[8,12,10,4])
 # Exercise the actual current semantic-key policy with temporary in-memory inputs.
 a=dict(id='STRUCTURE-999-POSITION',entity='HQ_T1',map='Map1');b={**a,'map':'Map11'}
 ka=positional_subject_key(a);kb=positional_subject_key(b);check('map_field_does_not_scope_identity',ka==kb)
 x={**a,'entity':'Map1/HQ_T1'};y={**b,'entity':'Map11/HQ_T1'};kx=canonical_task_key(x);ky=canonical_task_key(y);check('qualified_subjects_distinct',kx!=ky)
 try:positional_subject_key(dict(id='STRUCTURE-999-POSITION',entity=None))
 except IdentityError as e:refusal=str(e);checks.append('ambiguous_subject_refused')
 else:raise ValueError('missing subject accepted')
 identity=dict(unqualified_map1_key=ka,unqualified_map11_key=kb,qualified_examples=[kx,ky],ambiguous_subject_refusal=refusal,registry_modified=False,new_task_policy_adopted=False)
 local={p:(root/p).read_text(encoding='utf8') for p in LOCAL}
 conditions=[('world_map10_only',0,['data/4.20/map10_world.json','for s in config.structures','config: c.clone()']),('local_compact_grid',3,['checked_mul(11)','chunks_exact(11)','invalid native navigation dimensions','flags & 2 == 0']),('server_TT_grid',4,['assets/maps/tt_navigation_grid.json','assets/maps/tt_navigation_grid.cells.bin','game.enable_map10()']),('Map10_projection',5,['assets/maps/tt_level_size.scb','bounds.min[0]!=0. || bounds.min[2]!=0.','unsupported minimap level bounds','let y=(r.height*0.5+r.top)-z*r.height;']),('Map10_minimap_layout',6,['ShadowIslesMinimapRight.ini','three original minimap elements required','Projection::map10()?'])]
 for name,i,needles in conditions:check(name,all(n in local[LOCAL[i]] for n in needles))
 for p in LOCAL+['tools/project-plan/fidelity_identity_aliases_4_20.json','tools/project-plan/rads_reference_membership.py','docs/reference_client_4_20.json','data/4.20/map10_world.json','assets/maps/tt_navigation_grid.json','assets/maps/tt_navigation_grid.cells.bin','assets/maps/tt_level_size.scb','docs/reference_map_availability_sources/map_availability-links.json']:keep(root/p)
 for t in TARGETS:
  for i,s in enumerate(SPECS[t]):checks.append('anchor_'+anchor(root,t,i,s)['role'])
 def walk(x):
  if isinstance(x,dict):
   if 'membership' in x and 'source' in x:members.append(dict(path=x['source']['path'],status=x['membership']['status']))
   for v in x.values():walk(v)
  elif isinstance(x,list):
   for v in x:walk(v)
 walk(maps)
 return dict(storage_roots=dict(current_project=str(root),historical_manifest_reference=str(reference_root),historical_reference_read_only=True),maps=maps,native_member_statuses=members,status_counts=dict(collections.Counter(x['status'] for x in members)),identity_policy=identity,policies=dict(full_inventory=False,other_map_tasks_created=False,other_maps_loaded_by_game=False,native_grid_variants_qualified=False,all_minimap_coordinates_qualified=False,availability_dates_resolved=False,native_or_game_executed=False),source_checks=checks),list(pins.values())
_CACHE={}
def collect(root=R):
 k=str(pathlib.Path(root).resolve())
 if k not in _CACHE:_CACHE[k]=_collect(root)
 else:
  for p in _CACHE[k][1]:require(pin(p['path'])==p,'changed source '+p['path'])
  for m in _CACHE[k][0]['maps']:
   scene=pathlib.Path(m['lua']['resource']['source']['path']).parent.parent/'Scene'
   selected=sorted([p.stem for p in scene.glob('*.sco') if re.match(r'^(Barracks_|HQ_|Turret_|Info_|__Spawn_|__P_.*Barracks)',p.name,re.I)],key=str.casefold)
   require(selected==[x['name'] for x in m['candidate_markers']],'changed scene census '+m['map_directory'])
   for field,filename in [('mob','MapObjects.mob'),('level_bounds','__LevelSize_.scb')]:
    require((scene/filename).exists()==('resource' in m[field]),'changed optional resource '+str(scene/filename))
 return _CACHE[k]

def bindings(f,tid):
 rows=[];i=TARGETS.index(tid)
 def add(s,role,selector):
  suffix=';selected_membership='+s['membership']['status'];rows.append(dict(path=s['source']['path'],role=role,selector=selector+suffix))
 for m in f['maps']:
  name=m['map_directory']
  if i<2:
   add(m['lua']['resource'],'native_static_camp_input_not_runtime_inventory',name+';CampSpawnPoints/PredefinedCamps;stop='+str(m['lua']['stop']))
   for marker in m['candidate_markers']:add(marker['resource'],'native_named_marker_candidate_not_active_structure',name+'/'+marker['name']+';CentralPoint;role from name only')
   if 'resource' in m['mob']:add(m['mob']['resource'],'native_map_container_unparsed',name+';MapObjects.mob;placement parser remains unqualified')
  elif i==2:
   add(m['navigation']['resource'],'native_grid_version_input_not_local_compact_format',name+';prefix='+str(m['navigation']['version_prefix'])+';common header only')
   add(m['navigation']['terrain'],'native_same_map_terrain_reference_not_effective_alignment',name+';terrain.inibin;grid and terrain same selected map;transform unresolved')
  else:
   add(m['minimap']['resource'],'native_minimap_texture_not_coordinate_acceptance',name+';DDS header;not rendered')
   add(m['navigation']['resource'],'native_grid_bounds_candidate_not_minimap_transform',name+';common header candidate;not controller extent')
   if 'resource' in m['level_bounds']:add(m['level_bounds']['resource'],'native_level_bounds_not_bound_controller',name+';SCB bounding box;controller unresolved')
 return rows

def audit(q,root='F:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no bypass');require(q['schema']=='openleague_other_map_resources_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source identities changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require([a['task_id'] for a in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchors '+t);require(a['native_bindings']==bindings(f,t),'native roles '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim '+t);require(a['entry_boundary_only'] is True and a['full_task_scope_complete'] is False,'scope '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),native_or_game_executed=False)
