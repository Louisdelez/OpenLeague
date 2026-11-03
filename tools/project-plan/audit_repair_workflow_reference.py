"""Verify bounded reconstruction-source links without declaring whole repairs accepted."""
import pathlib,hashlib,json,struct,sys,collections,copy
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision98');sys.path.insert(0,str(R/'tools/project-plan'))
import repair_reference_contracts as contract
import rads_reference_membership as membership
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
require=contract.require

def pin(p):
 p=pathlib.Path(p).resolve();h=hashlib.sha256()
 with p.open('rb') as f:
  for b in iter(lambda:f.read(1048576),b''):h.update(b)
 return dict(path=str(p),bytes=p.stat().st_size,sha256=h.hexdigest())
TARGETS=[f'SYS-02.4-{i:02}' for i in range(1,11)];BOUNDARIES={TARGETS[2],TARGETS[7],TARGETS[9]}
LOCAL=['tools/create_map_blender_source.py','tools/create_animated_map_blender_source.py','tools/verify_map_blender_source.py','tools/blender_native_terrain.py','crates/client/src/terrain_material.rs','tools/repair_map_material_metadata.py','tools/audit_current_map_textures.py','tools/verify_ambient_blender_endpoints.py','tools/repair_ambient_animation_endpoints.py','crates/client/src/map_events.rs','tools/recover_ambient_audio.py','crates/core/src/audio_media.rs','crates/client/src/main.rs','crates/client/src/map_ambient.rs']
SPECS={TARGETS[0]:[(0,'bpy.ops.wm.save_as_mainfile('),(1,"bpy.ops.wm.open_mainfile(filepath=str(source),use_scripts=False)")],TARGETS[1]:[(2,'def signature(vertices):'),(2,"assert sum(x['triangles'] for x in removed)==62")],TARGETS[2]:[(3,"uv1=node('ShaderNodeUVMap','Spatial UV: reconstructed xz/15360')"),(4,'pub(crate) fn map10_terrain_transform() -> Vec4 {')],TARGETS[3]:[(5,"m['alphaMode']='BLEND';m.pop('alphaCutoff',None)"),(6,'images={};image_entries=[];errors=[]')],TARGETS[4]:[(1,"rig=rigs[0];initial[p['id']]"),(7,"rig=next(o for o in parent.children_recursive if o.type=='ARMATURE')")],TARGETS[5]:[(8,"before=samples[(frames-2,h)][kind];final=samples[(frames-1,h)][kind]"),(9,'pub fn native_period(native: &str) -> f32 {')],TARGETS[6]:[(10,"completed=subprocess.run([str(decoder),'-i','-o',str(wav),str(wem)]"),(11,'pub fn decode(bytes:&[u8])->Result<Pcm,Error> {')],TARGETS[7]:[(6,"native_path=Path(json.loads((r/'docs/environment_vertex_source_validation.json')"),(0,'bpy.ops.import_scene.gltf(filepath=str(source))')],TARGETS[8]:[(5,"if not backup.exists():backup.write_bytes(raw)"),(8,"else:backup.write_bytes(raw)")],TARGETS[9]:[(12,'commands.insert_resource(MapHandle(assets.load("maps/twisted_treeline.glb")))'),(13,'pub fn load_models(')]}
FINDINGS={
TARGETS[0]:('Deux scènes F ont été rouvertes dans Blender4.5 avec autoexec désactivé,sans sauvegarde ni export. Leurs empreintes et celle du GLB actuel restent exactes ;17 décors animés sont reliés au catalogue. Les scripts de création sont identifiés ;les chemins E embarqués restent des références historiques.','Qualifier la procédure de travail sur copies et tous ses exports ;une scène modifiable et sa relecture ne démontrent pas la fidélité complète ni la couverture de toutes les ressources.'),
TARGETS[1]:('Le bloc topologique du vérificateur actuel est réexécuté sur la scène F :62 faces retirées par Blender sont dégénérées ou dupliquées ;les1013104 triangles du GLB restent conservés. La scène contient1013042 triangles avec matériaux.','Étendre les contrôles aux autres maillages et aux invariants attendus de chaque réparation ;ne pas traiter un retrait diagnostiqué comme une validation générale de topologie ou de silhouette.'),
TARGETS[2]:('Les couches UV de terrain sont présentes et finies ;les nœuds Blender conservent le libellé xz/15360. Le consommateur Rust utilise le contrat c233 de bornes natif,distinct de15360. La présence des UV et les marqueurs de coutures ne qualifient ni les coutures ni leur équivalence spatiale.','Comparer numériquement les espaces UV,leurs transformations et les coutures sur le même matériau ;qualifier une procédure de réparation avant adoption. Ne pas remplacer une preuve de coordonnées par un simple libellé de nœud.'),
TARGETS[3]:('La comparaison actuelle des textures est réexécutée avec seuls chemins adaptés :235 images décodées,85 matériaux NVR à pixels identiques,deux matériaux de terrain composites différents,aucun binding diffus absent dans ce périmètre et28 matériaux horsNVR. Trois modifications alpha antérieures conservent leurs preuves.','Qualifier les matériaux terrain,les autres couches et les28 matériaux horsNVR sur leurs sources propres ;les différences de composite ne sont pas des preuves de corruption ni une équivalence du rendu natif.'),
TARGETS[4]:('Les17 hiérarchies de rigs Blender correspondent aux GLTF sources. Pour le marchand,les55 noms et parents correspondent aussi au SKL0 natif et aux deux instances Blender. La lecture est bornée et refuse versions,parents inconnus et cycles.','Qualifier matrices de bind,poids,axes et autres rigs ainsi que la procédure de réparation ;la correspondance noms/parents ne prouve pas toutes les déformations ou le dispatch natif.'),
TARGETS[5]:('Les165 canaux du clip marchand contiennent la dernière trame native451 ;la sauvegarde précédente,qui l’omet,est refusée par ce contrôle. Les octets binaires précédents et métadonnées mesh/skin/images/nodes sont conservés. Les deux actions Blender durent15secondes. Le runtime lit séparément la période via map_events et vérifie nom/index/durée avant chargement.','Qualifier tous les clips,fenêtres d’événements,blends et effets selon leurs consommateurs ;ne pas confondre durée ANM,action Blender et période de boucle runtime.'),
TARGETS[6]:('Les31 WEM correspondent aux entrées DIDX/DATA natives et les31 WAV à leurs empreintes/métadonnées. Un média redécodé dans F est identique au WAV installé ;six tests Rust existants de transport PCM passent.','Réaliser l’écoute comparative et qualifier sélection,mixage,boucles et périphérique ;un décodage exact et des tests de transport ne prouvent pas une restitution audible fidèle.'),
TARGETS[7]:('Le contrôle courant fournit un exemple concret de comparaison native :aucun diffus manquant dans son périmètre NVR,avec deux composites distincts et28 matériaux horsNVR. Blender ouvre les ressources existantes ;aucune comparaison GIMP/génération d’image sur une ressource véritablement manquante n’a été démontrée.','Identifier d’abord une ressource requise réellement absente,puis comparer les outils sur ce cas et sa source de référence. Ne pas inventer un manque à partir d’une différence de matériau composite.'),
TARGETS[8]:('Les scripts de réparation conservent des sauvegardes et des empreintes. La sauvegarde pré-endpoint du marchand est relue et son préfixe binaire préservé dans le résultat ;les sources natives,scènes et outils sont identifiés séparément.','Étendre cette traçabilité à chaque reconstruction et à chaque fichier de travail ;les exemples alpha et endpoint ne couvrent pas toute la chaîne d’adoption ni toutes les scènes.'),
TARGETS[9]:('Les consommateurs Rust chargent le GLB installé et les modèles du catalogue,dont les gardes nom/index/durée. Les scènes Blender sont des sources modifiables ;aucun nouvel export,jeu ou contrôle GPU ne s’est déroulé ici.','Vérifier chaque résultat exporté dans le moteur avec les preuves visuelles,audio et de gameplay pertinentes ;relecture Blender,hash et tests PCM ne valent pas recette après export.')}

def anchor(root,t,i,s):
 path,needle=LOCAL[s[0]],s[1];hits=[n+1 for n,l in enumerate((root/path).read_text(encoding='utf8').splitlines()) if needle in l];require(len(hits)==1,'unique anchor '+t+' '+needle)
 return dict(path=path,line=hits[0],needle=needle,role='repair_workflow_'+('boundary_' if t in BOUNDARIES else 'partial_')+t.replace('-','_').replace('.','_')+'_'+str(i))

def _collect(root=R):
 root=pathlib.Path(root).resolve();pins={};checks=[]
 def keep(p):
  x=pin(p);pins[x['path'].casefold()]=x;return x
 def check(name,v):require(v,name);checks.append(name)
 keep(root/'docs/project_location.json');loc=load(root/'docs/project_location.json');check('active_F_root',pathlib.Path(loc['active_root']).resolve()==root)
 obs=load(V/'blender-readonly-observation.json');ex=load(V/'blender-execution.json');native=load(V/'native-repair-observation.json');tex=load(V/'current-map-texture-observation.json');tx=load(V/'textures-execution.json');rust=load(V/'rust-audio-tests.json')
 for name in ['blender-readonly-observation.json','blender-execution.json','native-repair-observation.json','current-map-texture-observation.json','textures-execution.json','rust-audio-tests.json']:keep(V/name)
 check('Blender_execution',ex['exit_code']==0 and '--disable-autoexec' in ex['command'] and '--python-exit-code' in ex['command'] and obs['blender_version']=='4.5.0' and obs['autoexec_enabled'] is False and obs['all_files_unchanged'] and obs['all_observed_checks_pass'])
 for k in ['save_or_export_or_render_performed','native_program_executed','original_frame_equivalence_qualified']:check('Blender_scope_'+k,obs[k] is False)
 for s in [ex['binary'],ex['script'],ex['producer'],ex['log'],obs['producer'],*obs['protected_files']]:check('Blender_pin_'+s['path'],keep(s['path'])==s)
 check('two_scenes',len(obs['files'])==2)
 for row in obs['files']:
  check('scene_'+row['blend']['path'],keep(row['blend']['path'])==row['blend'] and all(row['checks'].values()))
  check('finite_uv_'+row['blend']['path'],len(row['terrain_uv_observation'])>0 and all(len(x['layers'])==2 and all(y['finite'] for y in x['layers']) for x in row['terrain_uv_observation']))
  check('uv_not_qualified_'+row['blend']['path'],row['uv_seams_or_original_spatial_equivalence_qualified'] is False)
 top=obs['files'][0]['topology'];check('62_faces_scoped',top['native_glb_triangles']==1013104 and top['imported_render_triangles']==1013042 and sum(x['triangles'] for x in top['blender_validation_removed_faces'])==62 and all(x['degenerate'] or x['duplicate'] for x in top['blender_validation_removed_faces']))
 rigs=obs['files'][1]['ambient_rig_comparisons'];check('17_glb_hierarchies',len(rigs)==17 and all(x['exact'] and x['expected_parents']==x['observed_parents'] for x in rigs))
 for row in rigs:
  check('rig_glb_'+row['id'],keep(row['glb_source']['path'])==row['glb_source']);g,b=contract.glb(pathlib.Path(row['glb_source']['path']).read_bytes());check('rig_parents_'+row['id'],contract.glb_parents(g)==row['expected_parents'])
 for s in native['source_identities']:check('native_pin_'+s['path'],keep(s['path'])==s)
 check('native_checks_scope',native['passed'] and native['refusals']==12 and native['game_or_native_code_executed'] is False and native['comparative_listening'] is False and native['live_assets_modified'] is False)
 for s in [native['producer'],native['decoded_again']['decoder'],native['decoded_again']['output'],native['decoded_again']['log']]:check('native_receipt_'+s['path'],keep(s['path'])==s)
 model=next(x for x in load(root/'docs/map_ambient_source_validation.json')['models'] if x['native_asset']=='TT_Shopkeeper');paths={pathlib.Path(s['path']).suffix.lower():s['path'] for s in model['sources']};skl=pathlib.Path(paths['.skl']);anm=pathlib.Path(next(s['path'] for s in model['sources'] if s['path'].endswith('shopkeeper_TT_Idle.anm')));g,b=contract.glb((root/'assets'/model['asset']).read_bytes());parents=contract.skl0_parents(skl.read_bytes());check('native55_parent_map',len(parents)==55 and parents==native['rig']['native_parent_map']==contract.glb_parents(g));check('two_native_Blender_rigs',sum(x['native_asset']=='TT_Shopkeeper' and x['observed_parents']==parents for x in rigs)==2)
 check('165_native_endpoint_channels',contract.compare_endpoint(anm.read_bytes(),g,b,'shopkeeper_TT_Idle')==native['endpoint'] and native['endpoint']['channels']==165 and native['endpoint']['frames']==451)
 old,oldb=contract.glb(pathlib.Path(native['preserved_backup']['identity']['path']).read_bytes());check('backup_preservation',b[:len(oldb)]==oldb and all(g[k]==old[k] for k in ['meshes','skins','images','nodes']))
 check('two_Blender_endpoints',len(obs['files'][1]['shopkeeper_endpoints'])==2 and all(abs(x['seconds']-15)<1e-5 for x in obs['files'][1]['shopkeeper_endpoints']))
 audio=load(root/'data/4.20/ambient_audio_manifest.json');check('31_media',len(native['media'])==len(audio['media'])==31);banks={}
 for x in native['media']:
  if x['native_bank'] not in banks:banks[x['native_bank']]=pathlib.Path(x['native_bank']).read_bytes()
  check('media_'+str(x['source_id']),contract.bank_member(banks[x['native_bank']],x['source_id'])==pathlib.Path(x['wem']['path']).read_bytes())
 check('decode_source_exact',native['decoded_again']['exit_code']==0 and native['decoded_again']['byte_exact_to_installed_wav'] and native['decoded_again']['output']['sha256']==native['media'][0]['wav']['sha256'])
 check('texture_execution',tx['exit_code']==0 and tx['game_or_gpu_executed'] is False)
 for s in [tx['original_source'],tx['adapted_source'],tx['producer'],tx['log']]:check('texture_pin_'+s['path'],keep(s['path'])==s)
 original=pathlib.Path(tx['original_source']['path']).read_text(encoding='utf8');adapted=original.replace("sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')","sys.path.insert(0,'F:/OpenLeague/tools/pythonlibs')").replace("r=Path('E:/OpenLeague')","r=Path('F:/OpenLeague')").replace("(r/'docs/current_map_texture_audit.json')","(Path(__file__).parent/'current-map-texture-observation.json')");check('texture_only_path_adaptation',pathlib.Path(tx['adapted_source']['path']).read_text(encoding='utf8')==adapted)
 check('texture_result_scope',tex['images_decoded']==235 and not tex['image_decode_errors'] and tex['native_diffuse_equal']==85 and len(tex['native_diffuse_differences'])==2 and not tex['missing_native_diffuse_or_binding'] and len(tex['non_nvr_materials'])==28 and not tex['invalid_primitive_materials'])
 check('terrain_composites_distinct',{x['name'] for x in tex['native_diffuse_differences']}=={'NVRMaterial_TT_Jungle1','NVRMaterial_TT_Lanes1'} and all(x['native_type']==3 and x['source_size']==[512,512] and x['size']==[4096,4096] for x in tex['native_diffuse_differences']))
 for x in tex['materials']:
  if x.get('source_sha256'):check('texture_source_'+str(x['index']),keep(x['source'])['sha256']==x['source_sha256'])
 check('current_map_hash',keep(root/'assets/maps/twisted_treeline.glb')['sha256']==tex['map_sha256'])
 material=load(root/'docs/map_material_repair.json');check('native_nvr_hash',keep(material['native_nvr'])['sha256']==material['native_nvr_sha256']==tex['native_nvr_sha256']);check('three_prior_alpha_changes',len(material['changes'])==3 and material['binary_chunks_unchanged'] is True)
 check('rust6_tests',rust['exit_code']==0 and rust['tests_passed']==6 and rust['tests_failed']==0 and rust['game_executed'] is False)
 for k in ['binary','producer','log','source','lock']:check('rust_pin_'+k,keep(rust[k]['path'])==rust[k])
 docs=['docs/reference_client_4_20.json','docs/blender_high_fog_progress.json','docs/map_material_repair.json','docs/map_ambient_endpoint_repair.json','docs/map_ambient_source_validation.json','docs/map_blender_source_validation.json','docs/map_ambient_blender_endpoint_validation.json','docs/environment_vertex_source_validation.json','data/4.20/terrain_materials.json','data/4.20/terrain_transform_contract.json','data/4.20/map10_shader_material_fields.json','data/4.20/ambient_events.json','data/4.20/native_cloud_opacity_contract.json','data/4.20/map_ambient_manifest.json','data/4.20/ambient_audio_manifest.json']
 for p in LOCAL+docs+['tools/project-plan/repair_reference_contracts.py','crates/client/src/pcm_audio.rs']:keep(root/p)
 for p in ['prepare_blender_probe.py','prepare_context.py','repair_reference_contracts.py']:keep(V/p)
 coord=load(root/'data/4.20/terrain_transform_contract.json');check('native_bounds_source',keep(coord['resource']['path'])['sha256']==coord['resource']['sha256']);settings=load(root/'data/4.20/terrain_materials.json');check('UV_policy_distinction','15398.671875' in settings['spatial_uv_policy'] and '15360' in (root/LOCAL[3]).read_text(encoding='utf8') and 'assert_ne!(map.x.to_bits(),(1f32/15360.).to_bits())' in (root/LOCAL[4]).read_text(encoding='utf8'))
 event=load(root/'data/4.20/ambient_events.json');check('event_period_present',event['models']['TT_Shopkeeper']['period']>0)
 verifier=membership.RadsReferenceMembership(loc['previous_root']);nativepaths=[material['native_nvr'],str(skl),str(anm),paths['.blnd'],coord['resource']['path'],native['media'][0]['native_bank']];members=[]
 for p in nativepaths:
  ident=keep(p);logical=pathlib.Path(p).relative_to(verifier.deploy).as_posix();m=verifier.inspect(logical,p,ident);check('selected_native_member_'+logical,m['status']=='matches_selected_project_manifest');members.append(m)
 for x in [verifier.catalogue_identity,verifier.solution_identity,verifier.configuration_identity,*[m['identity'] for m in verifier.manifests],*verifier.provenance]:check('manifest_pin_'+x['path'],all(keep(x['path'])[k]==x[k] for k in ['bytes','sha256']))
 for t in TARGETS:
  for i,s in enumerate(SPECS[t]):checks.append('anchor_'+anchor(root,t,i,s)['role'])
 facts=dict(blender=obs,blender_execution=ex,native=native,textures=tex,textures_execution=tx,rust=rust,native_membership=members,source_roles=dict(nvr=material['native_nvr'],skl=str(skl),anm=str(anm),blnd=paths['.blnd'],bounds=coord['resource']['path'],bank=native['media'][0]['native_bank']),runtime_event_period=event['models']['TT_Shopkeeper']['period'],policies=dict(all_repairs_qualified=False,UV_seams_qualified=False,tool_comparison_on_missing_asset=False,all_rigs_and_weights_qualified=False,all_clip_events_and_blends_qualified=False,comparative_listening=False,post_export_game_acceptance=False,native_or_game_executed=False),source_checks=checks)
 return json.loads(json.dumps(facts)),list(pins.values())
_CACHE={}
def collect(root=R):
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=_collect(root)
 else:
  for p in _CACHE[key][1]:require(pin(p['path'])==p,'changed source '+p['path'])
 return _CACHE[key]
def bindings(f,t):
 names={TARGETS[0]:['nvr'],TARGETS[1]:['nvr'],TARGETS[2]:['bounds'],TARGETS[3]:['nvr'],TARGETS[4]:['skl'],TARGETS[5]:['anm','blnd'],TARGETS[6]:['bank'],TARGETS[7]:['nvr'],TARGETS[8]:['anm','nvr'],TARGETS[9]:['nvr','anm']}[t]
 return [dict(path=f['source_roles'][n],role='native_repair_'+n+'_bounded_context',selector='Observed native member;scope and limits in association;no full repair acceptance') for n in names]
def audit(q,root='F:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no bypass');require(q['schema']=='openleague_repair_workflow_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source identities changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require([a['task_id'] for a in q['associations']]==TARGETS,'task census');um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchors '+t);require(a['native_bindings']==bindings(f,t),'native roles '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim '+t);require(a['entry_boundary_only']==(t in BOUNDARIES) and a['full_task_scope_complete'] is False,'scope '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),Blender_readonly_executed=True,native_or_game_executed=False)
