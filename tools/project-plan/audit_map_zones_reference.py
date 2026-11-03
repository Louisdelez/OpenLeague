"""Map10 zone source/consumer links. Pixel identity is not framebuffer acceptance."""
import hashlib,io,json,pathlib,re,struct,sys
R=pathlib.Path('E:/OpenLeague')
sys.path[:0]=[str(R/'tools/project-plan'),str(R/'tools'),str(R/'tools/pythonlibs')]
from audit_navigation_reference import pin,load,require
from rads_reference_membership import RadsReferenceMembership
from native_lua import Chunk,initialization
from PIL import Image
TARGETS=[f'SYS-10.2-{i:02}' for i in range(1,12)]
BOUNDARIES=set()
LOCAL=['crates/client/src/main.rs','tools/create_map_blender_source.py','tools/blender_native_terrain.py','crates/client/src/terrain_material.rs','crates/client/src/map_coordinates.rs','crates/core/src/world.rs','crates/core/src/altars.rs','crates/client/src/map_relic_world.rs','crates/core/src/vision.rs','crates/client/src/map10_vision_view.rs','crates/client/src/camera_native.rs','tools/audit_current_map_textures.py']
COMMON=[(0,'commands.insert_resource(MapHandle(assets.load("maps/twisted_treeline.glb")));'),(1,'bpy.ops.import_scene.gltf(filepath=str(source))')]
SPECS={t:list(COMMON) for t in TARGETS}
for i in [1,2]:SPECS[TARGETS[i-1]] += [(4,'pub fn map_root_transform()'),(3,'pub fn bind(')]
for i in [3,4]:SPECS[TARGETS[i-1]] += [(5,'let points = &world.config.lanes[lane].points;'),(3,'pub fn bind(')]
for i in [5,6,7]:SPECS[TARGETS[i-1]] += [(5,'for (index, member) in camp.config.members.iter().enumerate() {'),(3,'pub fn bind(')]
SPECS[TARGETS[7]] += [(0,'let name = if altar.name == "altar_west" {'),(6,'include_str!("../../../data/4.20/altars_map10.json")')]
SPECS[TARGETS[8]] += [(7,'fn placement(snapshot:'),(7,'const ASSET: &str = "forms/tt_relic.glb";')]
SPECS[TARGETS[9]] += [(8,'pub fn line_of_sight(&self, origin: Point, target: Point)'),(9,'pub fn native_map10()')]
SPECS[TARGETS[10]] += [(10,'let restriction=Restriction{min_x:value("cam_MinX")'),(3,'pub(crate) fn map10_terrain_transform()')]
FINDINGS={
 TARGETS[0]:('La base bleue est repérée par __Spawn_T1 ; le GLB installé est chargé sous MapRoot en XYZ/20 et importé dans le fichier Blender identifié. Les matériaux terrain ont un bind séparé.','Comparer géométrie,contacts,textures et raccords de cette base dans Blender et le framebuffer courant ; un repère de spawn ne définit pas son volume visuel complet.'),
 TARGETS[1]:('La base rouge est repérée par __Spawn_T2 ; le même GLB et le même transform direct sont consommés. Les écarts décimaux SCO/configuration restent mesurés,non effacés.','Recette visuelle propre à cette base,contacts et raccords ; ne pas déduire la symétrie parfaite ou une validation depuis la base bleue.'),
 TARGETS[2]:('Les25 points de la voie supérieure sont reliés aux SCO L01/NAV_L02..24 et au consommateur world.config.lanes[0]. Les matériaux TT_Lanes1 passent par le bind hauteur.','Qualifier surface,raccords,collisions et affichage de la voie entière ; correspondance des points de route ne prouve pas celle de chaque triangle ni l’algorithme historique.'),
 TARGETS[3]:('Les18 points de la voie inférieure sont reliés aux SCO R01/NAV_R02..17 et au consommateur world.config.lanes[1]. Les écarts de sérialisation sont conservés.','Qualifier surface,raccords,collisions et rendu de cette voie ; aucun contrôle visuel courant déduit des points.'),
 TARGETS[4]:('Les camps1..3 regroupent huit membres,issus de CampSpawnPoints natif. world.spawn_unit consomme leurs positions ; GLB et grille sont des sources distinctes.','Comparer chemins,murs,largeurs et hauteurs dans la jungle bleue ; camps et texture TT_Jungle1 ne définissent pas toutes les limites de la zone.'),
 TARGETS[5]:('Les camps4..6 regroupent huit membres dont les coordonnées correspondent à CampSpawnPoints natif et au spawn courant. Le terrain et la navigation sont distincts.','Comparer les chemins et murs de la jungle rouge ; aucun résultat de la jungle bleue n’est transféré automatiquement.'),
 TARGETS[6]:('Le repère de Vilemaw vient du camp natif8,avec position et point de face séparés. Le spawn courant consomme position,hauteur et angle local ; la fosse appartient au décor GLB.','Qualifier géométrie et accès de la fosse ainsi que l’orientation rendue ; un angle calculé depuis FacePoints ne prouve ni pose animée ni orientation native du mesh.'),
 TARGETS[7]:('Les deux autels sont rendus depuis le Snapshot aux centres de altars_map10. Ces centres sont déclarés dérivés de géométrie NVR ; le rayon500 est une politique locale,non une limite serveur native qualifiée.','Qualifier centres géométriques,limites de capture et raccords séparément ; relier chaque volume de trigger et vérifier le rendu des deux emplacements.'),
 TARGETS[8]:('Le camp natif7 fournit le repère exact de la relique. map_relic_world place le GLB TT_Relic seulement si la session et la visibilité/ disponibilité acceptées le permettent ; idle nommé/index3 vérifié par le consommateur.','Qualifier tous les effets de sol,pickup,occlusion et contacts ; présence du modèle et garde de session ne suffisent pas à la recette des effets.'),
 TARGETS[9]:('Les39474 flags de navigation sont comparés à la grille installée. line_of_sight interprète bit1 comme buisson ; Map10VisionView lit le SCB. Le décor visible et le volume logique restent distincts.','Comparer chaque silhouette de buisson et son volume de vision ; les flags et cette règle locale ne prouvent pas les limites visuelles ou les règles historiques de vision.'),
 TARGETS[10]:('Les bornes SCB15398.671875 et les limites caméra800/4200/14700/10000 sont distinctes. Le terrain courant lit le contrat c233 ; le fichier Blender importé reste identifié séparément.','Inspecter toutes les bordures visibles selon pose/zoom et raccords ; rectangle caméra et bornes de niveau ne prouvent pas une couverture complète du décor.')
}
def anchor(root,tid,i,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+tid+': '+n)
 return dict(path=p,line=hits[0],needle=n,role='map_zones_'+tid.lower().replace('-','_').replace('.','_')+'_'+str(i)+'_partial_consumer')
def rgba(data):
 with Image.open(io.BytesIO(data)) as im:
  im=im.convert('RGBA');im.load();return dict(size=list(im.size),rgba_sha256=hashlib.sha256(im.tobytes()).hexdigest())
def _collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def keep(p):
  s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 m=RadsReferenceMembership(root)
 for x in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[z['identity'] for z in m.manifests],*m.provenance]:keep(x['path'])
 def native(logical):
  p=m.deploy/logical;s=keep(p);member=m.inspect(logical,p,s);check('membership_'+logical,member['status']=='matches_selected_project_manifest');return dict(source=s,membership=member)
 nvr=native('LEVELS/Map10/scene/room.nvr');nb=pathlib.Path(nvr['source']['path']).read_bytes()
 glb=keep(root/'assets/maps/twisted_treeline.glb');raw=pathlib.Path(glb['path']).read_bytes();n=struct.unpack_from('<I',raw,12)[0]
 check('GLB2_header',raw[:4]==b'glTF' and struct.unpack_from('<II',raw,4)==(2,len(raw)) and raw[16:20]==b'JSON' and raw[24+n:28+n]==b'BIN\0')
 d=json.loads(raw[20:20+n]);binary=raw[28+n:];imagefacts=[]
 for i,e in enumerate(d['images']):
  view=d['bufferViews'][e['bufferView']];off=view.get('byteOffset',0);payload=binary[off:off+view['byteLength']];check('image_range_'+str(i),len(payload)==view['byteLength']);imagefacts.append(dict(index=i,**rgba(payload),payload_sha256=hashlib.sha256(payload).hexdigest()))
 owners=load(root/'data/4.20/map10_shader_material_fields.json');check('material_receipt_current',owners['native_nvr_sha256']==nvr['source']['sha256'] and owners['map_glb_sha256']==glb['sha256'])
 materialmap={x['gltf_material_index']:x for x in owners['gltf_materials_matched']};native_materials=[]
 count=struct.unpack_from('<i',nb,8)[0];check('87_NVR_materials',count==87)
 for i in range(count):
  off=28+i*2988;name=nb[off:off+260].split(b'\0')[0].decode();typ,flags=struct.unpack_from('<iI',nb,off+260);diffuse=nb[off+284:off+544].split(b'\0')[0].decode()
  native_materials.append(dict(index=i,name=name,type=typ,flags=flags,diffuse=diffuse,record_sha256=hashlib.sha256(nb[off:off+2988]).hexdigest()))
 byname={'NVRMaterial_'+('AlphaTest_' if x['flags']&4 else '')+x['name']:x for x in native_materials};dds={};materials=[]
 for i,mat in enumerate(d['materials']):
  tex=mat.get('pbrMetallicRoughness',{}).get('baseColorTexture');check('material_image_'+str(i),tex is not None)
  imageidx=d['textures'][tex['index']]['source'];ni=byname.get(mat['name']);owner=materialmap.get(i)
  if owner:check('material_owner_'+str(i),owner['name']==mat['name']);ni=native_materials[owner['native_material_index']]
  row=dict(index=i,name=mat['name'],image=imageidx,native_material=ni)
  if ni:
   logical='LEVELS/Map10/scene/Textures/'+ni['diffuse']
   if logical not in dds:
    s=native(logical);dds[logical]=dict(**s,**rgba(pathlib.Path(s['source']['path']).read_bytes()))
   src=dds[logical];row.update(native_texture=src,pixels_equal=all(src[k]==imagefacts[imageidx][k] for k in ['size','rgba_sha256']),actual_image=imagefacts[imageidx])
  materials.append(row)
 equal=sum(x.get('pixels_equal',False) for x in materials);diff=[x['index'] for x in materials if x.get('pixels_equal') is False]
 check('85_equal_2_heightblend',equal==85 and diff==[23,32]);check('28_nonNVR_separate',sum(x['native_material'] is None for x in materials)==28)
 for mesh in d['meshes']:
  check('primitive_material_'+mesh.get('name',''),all(0<=p.get('material',-1)<len(materials) for p in mesh['primitives']))
 triangles=sum(d['accessors'][p['indices']]['count']//3 for mesh in d['meshes'] for p in mesh['primitives']);check('2578_meshes_1013104_triangles',len(d['meshes'])==2578 and triangles==1013104)
 aux=load(root/'docs/current_map_auxiliary_texture_audit.json');terrain=[]
 for e in aux['terrain_shader_textures']:
  s=native(pathlib.Path(e['source']).relative_to(m.deploy).as_posix());p=keep(root/'assets'/e['asset']);a=rgba(pathlib.Path(p['path']).read_bytes());b=rgba(pathlib.Path(s['source']['path']).read_bytes());check('terrain_png_'+e['asset'],p['sha256']==e['png_sha256'] and s['source']['sha256']==e['source_sha256'] and a==b)
  terrain.append(dict(asset=p,native=s,pixels=a,pixels_equal=True))
 config=load(root/'data/4.20/terrain_materials.json');check('two_runtime_names_match_diffuse_differences',[x['name'] for x in config['terrain_materials']]==[materials[i]['name'] for i in diff])
 used={config['height_map'],config['colormap']}|{p for e in config['terrain_materials'] for p in e['layers']};check('six_runtime_terrain_inputs_verified',used=={pathlib.Path(t['asset']['path']).relative_to(root/'assets').as_posix() for t in terrain})
 check('altar_material_present',any(x['diffuse'].lower()=='structure_shrine_base_02.dds' for x in native_materials))
 blendproof=load(root/'docs/map_blender_source_validation.json');blend=keep(blendproof['blend_file']);check('GLB_matches_inherited_source',glb['sha256']==blendproof['source_sha256'])
 inspection=pathlib.Path('E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision85/blender-current.json');keep(inspection);inspection_data=load(inspection)
 for key in ['source','producer','executable']:check('blender_inspection_'+key,keep(inspection_data[key]['path'])==inspection_data[key])
 check('readonly_blender_execution',inspection_data['passed'] is True and all(inspection_data[k] is False for k in ['saved','exported','rendered','historical_game_executed','embedded_scripts_enabled']))
 check('current_scene_GLb_lineage',inspection_data['scene_properties']['OpenLeague_environment_sha256']==glb['sha256'])
 check('current_blend_mesh_counts',inspection_data['render_mesh_objects']==2578 and inspection_data['render_triangles']==1013042 and inspection_data['helpers']==19)
 removed=blendproof['blender_validation_removed_faces'];check('61_records_62_faces_not_discrepancy',len(removed)==61 and sum(x['triangles'] for x in removed)==62 and triangles-blendproof['imported_render_triangles']==62)
 world=load(root/'data/4.20/map10_world.json');spawns=load(root/'data/4.20/champion_spawns_map10.json');scene={}
 names=['__Spawn_T1.sco','__Spawn_T2.sco']
 lane_names=[]
 for prefix,end in [('L',24),('R',17)]:
  nameset=[f'__P_Order_Spawn_Barracks__{prefix}01.sco']+[f'__NAV_{prefix}0{i}.sco' for i in range(2,end+1)]+[f'__P_Chaos_Spawn_Barracks__{prefix}01.sco'];lane_names.append(nameset);names+=nameset
 for name in names:
  s=native('LEVELS/Map10/scene/'+name);text=pathlib.Path(s['source']['path']).read_text();v=re.findall(r'^CentralPoint=\s*([^\r\n]+)',text,re.M);check('central_point_'+name,len(v)==1);scene[name]=dict(**s,xyz=list(map(float,v[0].split())))
 spawnfacts=[]
 for i,s in enumerate(spawns):
  src=scene[f'__Spawn_T{i+1}.sco'];current=[s['point']['x'],s['height'],s['point']['z']];delta=[a-b for a,b in zip(current,src['xyz'])];check('spawn_coordinate_'+str(i),s['team']==i and max(map(abs,delta))<0.001);spawnfacts.append(dict(**src,current_xyz=current,decimal_delta=delta))
 lanes=[]
 for idx,nameset in enumerate(lane_names):
  points=world['lanes'][idx]['points'];check('lane_census_'+str(idx),len(points)==len(nameset));rows=[]
  for pt,name in zip(points,nameset):
   s=scene[name];delta=[pt['x']-s['xyz'][0],pt['z']-s['xyz'][2]];check('lane_marker_'+name,max(map(abs,delta))<0.001);rows.append(dict(marker=s,current_xz=[pt['x'],pt['z']],decimal_delta=delta))
  lanes.append(dict(index=idx,markers=rows,native_route_algorithm_qualified=False))
 neutral=native('LEVELS/Map10/Scripts/NeutralMinionSpawn.luaobj');g=initialization(Chunk(pathlib.Path(neutral['source']['path']).read_bytes()).function());campfacts=[]
 for camp in world['camps']:
  idx=camp['index'];points=g['globals']['CampSpawnPoints'][idx];check('camp_census_'+str(idx),len(points)==len(camp['members']));rows=[]
  for j,member in enumerate(camp['members'],1):
   xyz=points[j];check('camp_position_'+str(idx)+'_'+str(j),[member['position']['x'],member['height'],member['position']['z']]==[xyz[k] for k in ['x','y','z']]);rows.append(dict(definition=member['definition'],native_xyz=xyz,face_xyz=g['globals']['CampFacePoints'][idx][j],local_facing=member['facing']))
  campfacts.append(dict(index=idx,members=rows))
 interactions=load(root/'data/4.20/map10_interactions.json');relic=g['globals']['CampSpawnPoints'][7][1];check('relic_native_xyz',[relic[k] for k in ['x','y','z']]==[interactions['relic_position']['x'],interactions['relic_height'],interactions['relic_position']['z']])
 altars=load(root/'data/4.20/altars_map10.json');check('altar_native_boundary_not_claimed',len(altars['altars'])==2 and altars['capture_radius']==500 and any('not verified server trigger centers' in x for x in altars['limits']))
 scb=native('LEVELS/Map10/scene/__LevelSize_.SCB');bounds=list(struct.unpack_from('<6f',pathlib.Path(scb['source']['path']).read_bytes(),152));check('level_extent',bounds==[0.,-1440.2152099609375,0.,15398.671875,0.,15398.671875])
 check('installed_level_scb_exact',(root/'assets/maps/tt_level_size.scb').read_bytes()==pathlib.Path(scb['source']['path']).read_bytes())
 nav=native('LEVELS/Map10/AIPath.aimesh_ngrid');navbytes=pathlib.Path(nav['source']['path']).read_bytes();head=struct.unpack_from('<6ffII',navbytes,3);cells=head[7]*head[8];compact=(root/'assets/maps/tt_navigation_grid.cells.bin').read_bytes();brush=0
 check('grid_header_and_size',navbytes[:3]==bytes([3,1,0]) and cells==39474 and len(compact)==cells*11)
 for i in range(cells):
  nf=struct.unpack_from('<H',navbytes,39+i*56+50)[0];cf=struct.unpack_from('<H',compact,i*11+4)[0];require(nf==cf,'native flag '+str(i));brush+=bool(nf&1)
 check('39474_flags_exact',True)
 constants=native('LEVELS/Map10/Constants.var');ct=pathlib.Path(constants['source']['path']).read_text();limits={k:float(re.findall(r'^'+k+r'\s*=\s*([^;\r\n]+)',ct,re.M)[0]) for k in ['cam_MinX','cam_MinY','cam_MaxX','cam_MaxY']};check('camera_rectangle',list(limits.values())==[800,4200,14700,10000])
 local={p:(root/p).read_text(encoding='utf8') for p in LOCAL}
 check('import_only_not_export', 'bpy.ops.export_scene' not in local[LOCAL[1]] and 'save_as_mainfile' in local[LOCAL[1]])
 check('runtime_material_replacement',all(t in local[LOCAL[3]] for t in ['native_settings.scales','if let Some(handle) = catalog.0.get(&name.0)','remove::<MeshMaterial3d<StandardMaterial>>()','terrain_transform_from_bounds(read("span_bits"), read("center_bits"))']))
 check('native_XYZ_div20', 'Transform::from_scale(Vec3::splat(1. / NATIVE_UNITS_PER_WORLD_UNIT))' in local[LOCAL[4]])
 check('relic_guard_and_animation',all(t in local[LOCAL[7]] for t in ['session != Some(snapshot.session)','!map.relic_visible || !map.relic_available','const IDLE_INDEX: usize = 3;','model.animations.get(IDLE_INDEX) != Some(idle)']))
 check('brush_rule_local',all(t in local[LOCAL[8]] for t in ['let bush = end & 1 != 0;','if bush && start & 1 == 0','flags & 2 != 0 && flags & (0x40 | 0x100) == 0']))
 for tid in TARGETS:
  for i,s in enumerate(SPECS[tid]):a=anchor(root,tid,i,s);checks.append('anchor_'+a['role'])
 for p in LOCAL+['data/4.20/map10_world.json','data/4.20/champion_spawns_map10.json','data/4.20/map10_interactions.json','data/4.20/altars_map10.json','data/4.20/terrain_materials.json','data/4.20/terrain_transform_contract.json','data/4.20/map10_shader_material_fields.json','docs/map_blender_source_validation.json','docs/current_map_auxiliary_texture_audit.json','docs/current_map_texture_audit.json','docs/environment_vertex_source_validation.json','assets/maps/tt_level_size.scb','assets/maps/tt_navigation_grid.json','assets/maps/tt_navigation_grid.cells.bin','docs/reference_client_4_20.json','tools/native_lua.py','tools/project-plan/rads_reference_membership.py','tools/project-plan/audit_navigation_reference.py']:keep(root/p)
 facts=dict(nvr=nvr,glb=glb,images=imagefacts,materials=materials,diffuse_equal=equal,diffuse_differences=diff,terrain_textures=terrain,blender=dict(source=blend,inherited_receipt=blendproof,current_inspection=inspection_data,current_matches_old_receipt=blend['sha256']==blendproof['blend_sha256'],fresh_readonly_blender_inspection=True,removed_records_inherited=61,removed_faces_inherited=62),spawn_markers=spawnfacts,lanes=lanes,neutral_source=neutral,neutral_static_stop=g['stopped'],camps=campfacts,relic_xyz=relic,altars=altars,navigation=nav,flag_cells=cells,brush_flag_cells=brush,level_size=dict(**scb,bounds=bounds),camera_constants=dict(**constants,limits=limits),source_checks=checks,qualification=dict(native_zone_volumes_qualified=False,per_zone_framebuffer_observed=False,blender_export_used_by_runtime=False,texture_scope='RGBA baselevel only; shader sampling lighting fog mip and framebuffer separate',non_NVR_materials_qualified=False,blender_shader_runtime_parity=False),historical_server_policy_qualified=False,native_or_game_executed=False,rust_tests_executed=False)
 return facts,list(pins.values())
_CACHE={}
def collect(root=R):
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=_collect(root)
 else:
  for p in _CACHE[key][1]:require(pin(p['path'])==p,'source changed since verified parse: '+p['path'])
 return _CACHE[key]
def bindings(f,tid):
 out=[]
 def add(row,role,selector):out.append(dict(path=row['source']['path'],role=role,selector=selector))
 add(f['nvr'],'native_map10_environment_materials_not_zone_acceptance','87 NVR material records @28 stride2988; no native named zone volume inferred')
 add(f['navigation'],'native_map10_navigation_not_visual_geometry','39474 cells; flags@50 stride56; visible geometry separate')
 i=TARGETS.index(tid)
 if i<2:add(f['spawn_markers'][i],'native_base_spawn_marker_not_zone_boundary','CentralPoint; decimal deltas retained')
 if i in [2,3]:
  for j,r in enumerate(f['lanes'][i-2]['markers']):add(r['marker'],'native_lane_marker_not_route_algorithm',f'CentralPoint; current lane[{i-2}].points[{j}]; decimal deltas retained')
 if i in [4,5,6,8]:add(f['neutral_source'],'native_camp_location_not_zone_boundary','CampSpawnPoints/CampFacePoints; camps '+{4:'1,2,3',5:'4,5,6',6:'8',8:'7'}[i]+'; straight-line initialization reader, no Lua engine execution')
 if i==7:add(f['nvr'],'native_altar_geometry_source_claim_not_server_trigger','structure_shrine_base_02.dds in authored material table; current centers mesh-derived, radius500 reconstructed')
 if i in [9,10]:add(f['level_size'],'native_level_extent_not_zone_acceptance','r3d2Mesh2.2 bounds@152; extent15398.671875')
 if i==10:add(f['camera_constants'],'native_camera_rectangle_not_border_mesh_extent','cam_MinX/MinY/MaxX/MaxY=800/4200/14700/10000')
 for r in f['terrain_textures']:add(r['native'],'native_heightblend_input_pixels_not_framebuffer',pathlib.Path(r['asset']['path']).name+'; RGBA baselevel exact')
 return out
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no source verification bypass');require(q['schema']=='openleague_map_zones_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source pins changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'checks census');require([x['task_id'] for x in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchor rebound '+t);require(a['native_bindings']==bindings(f,t),'native role rebound '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim rebound '+t);require(a['entry_boundary_only'] is False and a['full_task_scope_complete'] is False,'scope promoted '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown rebound '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),images=len(f['images']),lane_markers=sum(len(l['markers']) for l in f['lanes']),native_or_game_executed=False)
