"""Precise special-movement, picking and camera links; no general gameplay parity."""
import json,pathlib,re,sys
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from audit_navigation_reference import pin,load,require
from rads_reference_membership import RadsReferenceMembership
from reference_inibin import read,hashkey
TARGETS=[f'SYS-09.3-{i:02}' for i in range(1,8)]+[f'SYS-09.4-{i:02}' for i in range(1,8)]
BOUNDARIES={'SYS-09.3-01','SYS-09.3-02','SYS-09.4-03'}
LOCAL=['crates/core/src/spells.rs','crates/core/src/annie_w.rs','crates/core/src/ezreal_e.rs','crates/core/src/trundle_e.rs','crates/core/src/lib.rs','crates/client/src/picking.rs','crates/client/src/main.rs','crates/client/src/ordinary_camera_input.rs','crates/client/src/camera_lock.rs','crates/client/src/native_minimap_input.rs','crates/client/src/native_minimap_geometry.rs','crates/client/src/camera_native.rs','crates/core/src/camera_focus.rs','crates/core/src/camera_sequence.rs','crates/client/src/ordinary_camera_input_tests.rs','crates/client/src/native_minimap_tests.rs','crates/core/src/collision.rs']
SPECS={
 'SYS-09.3-01':[(0,'return Err("champion spell not implemented".into());'),(1,'return Err("champion ground spell not implemented".into());')],
 'SYS-09.3-02':[(1,'pub fn cast_at(&mut self,id:u32,slot:u8,point:Point)'),(0,'return Err("champion spell not implemented".into());')],
 'SYS-09.3-03':[(2,'fn clamp_landing('),(2,'fn ezreal_e_landing('),(2,'p.position = pending.landing; p.height = height;')],
 'SYS-09.3-04':[(2,'fn ezreal_e_landing('),(3,'fn plan_trundle_e_push(')],
 'SYS-09.3-05':[(2,'Some("Ezreal E pending interrupted by control")'),(3,'pub(crate) fn advance_trundle_e(')],
 'SYS-09.3-06':[(3,'pub(crate) fn cast_trundle_e_at('),(3,'pub(crate) fn dynamic_path('),(3,'self.trundle_e.pillars.retain(')],
 'SYS-09.3-07':[(3,'self.trundle_e.pushes.insert(id,push);'),(4,'self.advance_trundle_e();'),(4,'self.advance_ezreal_e();')],
 'SYS-09.4-01':[(5,'fn enemy_target('),(16,'pub fn horizontal_point(')],
 'SYS-09.4-02':[(6,'fn commands('),(5,'pub fn target(')],
 'SYS-09.4-03':[(7,'fn apply(&mut self, context: Context,'),(6,'fn camera(')],
 'SYS-09.4-04':[(7,'pub(crate) fn drive('),(8,'pub fn consume(&mut self, request: Request)')],
 'SYS-09.4-05':[(9,'camera.minimap_focus();focus.0.x=point.x/20.;focus.0.z=point.z/20.;'),(10,'pub fn inverse(self,r:Rect,p:Vec2)')],
 'SYS-09.4-06':[(11,'let restriction=Restriction{min_x:value("cam_MinX")'),(12,'pub fn update(initial:&State,context:&Context,'),(13,'pub fn step_without_auto_follow(')],
 'SYS-09.4-07':[(14,'fn camera_keys_match_original_gameevents_default_bindings()'),(15,'fn map10_native_bounds_and_three_real_hud_records_align_at_both_dpis()'),(5,'fn target_uses_actor_height_and_native_radius_instead_of_fixed_plane()')]
}
FINDINGS={
 'SYS-09.3-01':('GravesMove fournit un exemple natif de ressource de déplacement ; les deux dispatchs locaux refusent les sorts de Graves dans les corps inspectés.','Qualifier et relier chaque dash réellement demandé,destination,collision et interruptions ; le blink Ezreal et les mouvements de particules ne réalisent pas un dash générique.'),
 'SYS-09.3-02':('RocketJump fournit une ressource native de saut ; les dispatchs inspectés ne proposent pas de sort Tristana. La présence des particules Simple/Complex n’est pas un saut de champion.','Qualifier simulation,trajectoire et hauteur visuelle indépendante par capacité ; conserver l’absence de consommateur de saut dans cette frontière explicite.'),
 'SYS-09.3-03':('EzrealE réalise un blink local : clamp radial475,contrôle disque terrain/piliers/occupation à l’admission et au tick de libération,puis commit position/hauteur. Aucun wall snap.','Qualifier politique historique et autres téléportations ; la valeur475 vient du display override natif,son usage gameplay est une décision locale explicite.'),
 'SYS-09.3-04':('Le blink Ezreal vérifie l’arrivée sans tester le segment origine-arrivée ; la poussée Trundle vérifie le segment et exclut uniquement son pilier d’origine.','Qualifier le droit de traverser pour chaque capacité et chaque mur ; aucune matrice générale de permissions n’est déduite de ces deux chemins.'),
 'SYS-09.3-05':('EzrealE en attente refuse stun,déplacement forcé,silence,changement d’origine et tick de libération sauté. La poussée Trundle utilise vie,marqueur,position attendue et durée propres.','Qualifier root,suppression,interruptions et buffering par capacité ; les champs INIBIN ne prouvent pas les callbacks serveur ou les règles locales.'),
 'SYS-09.3-06':('TrundleE ajoute un cercle temporaire,expire ses piliers et les fournit au pathfinding dynamique. Rayon150 et politique de poussée restent reconstruits.','Qualifier empreintes,vision,interactions et autres obstacles créés par champions ; ne pas généraliser ce seul cercle local.'),
 'SYS-09.3-07':('Trundle stocke une seule poussée par acteur via insert ; les cibles sont triées parID. Le tick avance Trundle avant EzrealE,qui refuse un déplacement forcé actif.','Qualifier ordre d’admission et résolution de tous les déplacements simultanés ; remplacement local d’une poussée et ordre des fonctions ne prouvent pas une politique historique universelle.'),
 'SYS-09.4-01':('Picking croise le rayon avec le plan horizontal à la hauteur de l’acteur,puis compare SelectionRadius et choisit la distance horizontale minimale. Quatre rayons de structures absents gardent un fallback local160.','Qualifier volumes3D,occlusion,priorités et tous les types de cibles ; rayon natif ne signifie pas algorithme de sélection natif.'),
 'SYS-09.4-02':('Input.ini distingue MoveClick,AttackMove etAttackOnly ; le client local émet Attack si picking trouve une cible,sinon Move depuis raycast_floor,avec gardes UI.','Qualifier tous les gestes historiques et modificateurs ; clic droit contextuel ne couvre pas automatiquement attack-move,attack-only et sélection gauche.'),
 'SYS-09.4-03':('Le contrôleur ordinaire inspecté consomme flèches,Space etY ; sa fonction apply ne reçoit ni position de curseur ni dimensions de fenêtre. Le point d’entrée caméra consomme focus et molette.','Relier/implémenter le défilement aux bords avec vitesse,marge,focus et captures UI ; aucune absence globale inférée au-delà des corps inspectés.'),
 'SYS-09.4-04':('Y passe par CameraLock.consume avec propriétaire,serial,révision et gardes ; le suivi lit le Snapshot local accepté. Space recentre temporairement.','Qualifier le comportement historique et les transitions complètes ; les bindings natifs ne prouvent pas la fidélité du contrôleur local.'),
 'SYS-09.4-05':('Le clic gauche minimap inverse les coordonnées Map10,demande déverrouillage puis écrit X/Z du focus en gardant Y ; la pose caméra applique ensuite ses contraintes.','Qualifier drag,bords,DPI et interactions avec suivi/fin de partie ; ce contrôleur est local et les callbacks souris natifs ne sont pas portés.'),
 'SYS-09.4-06':('Constants.var fournit800/4200/14700/10000 ; camera_native passe ces limites à la restriction X/Z,et la séquence remet Y à0 avant les deux passes. Les384/512 cas natifs sont des preuves héritées identifiées.','Qualifier bootstrap effectif et toutes cartes/modes/services ; aucun ancien cas ni rendu n’est présenté comme réexécuté dans ce lot.'),
 'SYS-09.4-07':('Des tests courants couvrent bindings clavier,projection minimap/DPI et picking par hauteur/rayon. Le reçu antérieur ordinary_camera_hud conserve ses tentatives et limites.','Construire la recette complète bases,voies,jungle et passages étroits sur le build courant ; tests définis et essais hérités ne prouvent pas cette couverture actuelle.')
}
SPELLS=[('Graves',2),('Tristana',1),('Ezreal',2),('Trundle',2)]
COMMON=['CastRange','CastRangeDisplayOverride','CantCastWhileRooted','CanCastWhileDisabled','CantCancelWhileWindingUp','AnimationName','Effect1Level1Amount','Effect2Level1Amount']
EVENTS=['evtCameraLockToggle','evtCameraSnap','evtScrollUp','evtScrollDown','evtScrollLeft','evtScrollRight','evtPlayerSelectClick','evtPlayerMoveClick','evtPlayerAttackMoveClick','evtPlayerAttackOnlyClick','evtPlayerAttackMove','evtPlayerHoldPosition','evtPlayerStopPosition']
def anchor(root,tid,i,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+tid+': '+n)
 return dict(path=p,line=hits[0],needle=n,role='motion_camera_'+tid.lower().replace('-','_').replace('.','_')+'_'+str(i)+('_entry_boundary' if tid in BOUNDARIES else '_partial_consumer'))
def collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def keep(p):
  s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 m=RadsReferenceMembership(root)
 for x in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[z['identity'] for z in m.manifests],*m.provenance]:keep(x['path'])
 def native(logical):
  p=m.deploy/logical;s=keep(p);member=m.inspect(logical,p,s);check('membership_'+logical,member['status']=='matches_selected_project_manifest');return dict(source=s,membership=member)
 input_source=native('DATA/CFG/defaults/Input.ini');constants=native('LEVELS/Map10/Constants.var');exe=native('League of Legends.exe');nav=native('LEVELS/Map10/AIPath.aimesh_ngrid');scb=native('LEVELS/Map10/Scene/__LevelSize_.SCB')
 text=pathlib.Path(input_source['source']['path']).read_text(encoding='utf8');section=text.split('[GameEvents]',1)[1].split('\n[',1)[0];events={}
 for name in EVENTS:
  hits=re.findall(r'^'+name+r'\s*=\s*([^\r\n]+)',section,re.M);check('event_'+name,len(hits)==1);events[name]=hits[0].strip()
 check('six_camera_bindings',[events[k] for k in EVENTS[:6]]==['[y]','[Space]','[Up Arrow]','[Down Arrow]','[Left Arrow]','[Right Arrow]'])
 check('installed_input_exact',(root/'data/4.20/configuration/defaults/Input.ini').read_bytes()==pathlib.Path(input_source['source']['path']).read_bytes())
 settings=load(root/'data/4.20/camera_map10_settings.json');text=pathlib.Path(constants['source']['path']).read_text();values={}
 check('constants_hash',settings['source_sha256']==constants['source']['sha256'])
 for name,v in settings['native_values'].items():
  hits=re.findall(r'^'+name+r'\s*=\s*([^;\r\n]+)',text,re.M);check('constant_'+name,len(hits)==1 and float(hits[0].strip())==v);values[name]=v
 spells=[];table=load(root/'data/4.20/native_spells_420.json')
 for champion,slot in SPELLS:
  rows=[x for x in table if x['champion']==champion and x['slot']==slot];check('spell_row_'+champion,len(rows)==1);row=rows[0];s=native(row['native_resource']);v=read(s['source']['path']);fields=[]
  names=list(COMMON)
  if champion=='Ezreal':names+=['Coefficient']+[f'{k}{n}' for n in range(1,6) for k in ['ManaCost','Cooldown']]+[f'Effect1Level{n}Amount' for n in range(1,6)]
  if champion=='Trundle':names+=[f'{k}{n}' for n in range(1,6) for k in ['ManaCost','Cooldown','CastRange']]+[f'Effect{k}Level{n}Amount' for n in range(1,6) for k in [1,2]]
  for name in dict.fromkeys(names):
   raw=v.get(hashkey('SpellData',name));local=row['values'].get(name);check('spell_field_'+champion+'_'+name,raw==local)
   fields.append(dict(field='SpellData.'+name,native=raw,local=local,present=hashkey('SpellData',name) in v))
  spells.append(dict(champion=champion,slot=slot,spell=row['spell'],**s,fields=fields,scope='authoring example; not native server callback'))
 radii=[]
 for family,file in [('champion','collision_profiles.json'),('npc','npc_selection_profiles.json')]:
  profiles=load(root/'data/4.20'/file)
  for name,row in sorted(profiles.items()):
   logical=pathlib.Path(row['source']).relative_to(m.deploy).as_posix();s=native(logical);check('radius_hash_'+name,s['source']['sha256']==row['sha256']);v=read(row['source']).get(hashkey('Data','SelectionRadius'));numeric=None if v is None else float(v)
   check('selection_'+name,numeric==row['selection_radius']);radii.append(dict(family=family,name=name,**s,native=v,numeric=numeric,local=row['selection_radius']))
 check('champion122',sum(r['family']=='champion' for r in radii)==122)
 missing=[r['name'] for r in radii if r['native'] is None];check('four_missing_structure_radii',len(missing)==4)
 inherited=[]
 for rel,n in [('data/4.20/camera_focus_contract.json',384),('data/4.20/camera_sequence_contract.json',512)]:
  p=keep(root/rel);d=load(root/rel);check('inherited_'+rel,d['passed'] is True and d['native_sha256']==exe['source']['sha256'] and len(d['cases'])==n)
  inherited.append(dict(source=p,cases=n,limits=d['limits'],fresh_execution=False))
 oldpath='docs/ordinary_camera_hud_progress.json';keep(root/oldpath);old=load(root/oldpath)
 historical={k:old[k] for k in ['updated_utc','automated_qualification_passed','ordinary_hud_runtime_qualified','actual_pixels_qualified','camera_follow_runtime_qualified','native_input_fidelity','complete_game','limits']}
 local={p:(root/p).read_text(encoding='utf8') for p in LOCAL}
 tokens={0:['champion spell not implemented'],1:['champion ground spell not implemented','if slot==2 {return self.cast_ezreal_e_at(id,point);}'],2:['pub const BLINK_RANGE: f32 = 475.;','return Err("Ezreal E landing terrain blocked".into());','return Err("Ezreal E landing pillar blocked".into());','return Err("Ezreal E landing occupied".into());','Some("Ezreal E pending interrupted by control")','"Ezreal E release tick skipped"','p.position = pending.landing; p.height = height;','number("CastRangeDisplayOverride")? != BLINK_RANGE'],3:['pub const WALL_RADIUS:f32=150.;','pub const PUSH_SPEED:f32=600.;','out.sort_by_key(|r|r.0);','self.trundle_e.pushes.insert(id,push);','pillar_navigation::segment_allowed(&self.navigation,from,destination,&circles)'],5:['collision::horizontal_point(origin, direction, p.height)?','collision::profile(&p.champion).selection_radius','unwrap_or(160.)','.min_by(|a, b| a.1.total_cmp(&b.1))'],6:['Action::Attack { target }','Action::Move { point }','terrain.0.raycast_floor(origin, direction)','buttons.just_pressed(MouseButton::Right) || targeted_skill'],7:['const PAN_SPEED: f32 = 150.;','controls.follow = lock.locked();','Origin::Hotkey','if lock.follows_authoritative_target()'],8:['Rejection::ForeignOwner','Rejection::StaleRevision','Rejection::StaleSerial','Rejection::HumanGate'],9:['lock.request(false,crate::camera_lock::Origin::Minimap)','focus.0.x=point.x/20.;focus.0.z=point.z/20.;'],11:['context=Context{active_raw:0,service_flag_raw:0,special_flag_raw:0}','camera_sequence::step_without_auto_follow'],12:['for _ in 0..2','state.current[2]=axis(state.current[2],restriction.min_z,restriction.max_z);'],13:['focus.current[1]=0.;focus=camera_focus::update']}
 for idx,ts in tokens.items():
  for i,t in enumerate(ts):check('token_'+str(idx)+'_'+str(i),t in local[LOCAL[idx]])
 landing=local[LOCAL[2]].split('fn ezreal_e_landing(',1)[1].split('pub(crate) fn cast_ezreal_e_at(',1)[0]
 check('landing_not_segment',all(t not in landing for t in ['segment_allowed','nav.path','dynamic_path','nearest_walkable']))
 apply=local[LOCAL[7]].split('fn apply(&mut self, context: Context,',1)[1].split('pub(crate) fn minimap_focus',1)[0]
 check('bounded_no_cursor_edge_input',all(t not in apply for t in ['cursor_position','CursorMoved','WindowResized','physical_width','physical_height']))
 check('trundle_before_ezreal_tick',local[LOCAL[4]].index('self.advance_trundle_e();')<local[LOCAL[4]].index('self.advance_ezreal_e();'))
 for p in LOCAL+['data/4.20/configuration/defaults/Input.ini','data/4.20/camera_map10_settings.json','data/4.20/native_spells_420.json','data/4.20/collision_profiles.json','data/4.20/npc_selection_profiles.json','docs/reference_client_4_20.json','tools/project-plan/audit_navigation_reference.py','tools/project-plan/reference_inibin.py','tools/project-plan/rads_reference_membership.py']:keep(root/p)
 for tid in TARGETS:
  for i,s in enumerate(SPECS[tid]):a=anchor(root,tid,i,s);checks.append('anchor_'+a['role'])
 facts=dict(native_input=input_source,events=events,map_constants=dict(**constants,values=values),native_executable=exe,navigation=nav,level_size=scb,spells=spells,selection_profiles=radii,missing_selection_fields=missing,inherited_camera_contracts=inherited,historical_camera_progress=historical,source_checks=checks,local_policies=dict(blink_range_source='CastRangeDisplayOverride',blink_range=475,blink_windup_ticks=8,blink_terrain_segment_checked=False,push_wall_radius=150,push_speed=600,pushes_per_actor=1,pick_geometry='horizontal_plane_then_radius',pick_order='horizontal_distance',camera_input='keyboard_Y_Space_arrows_local_policy',camera_edge_input_in_apply=False,camera_pan_speed=150,global_movement_priority_qualified=False,all_dash_jump_implemented=False,full_zone_matrix_tested_now=False),historical_server_policy_qualified=False,native_or_game_executed=False,rust_tests_executed=False)
 return facts,list(pins.values())
def bindings(f,tid):
 out=[]
 def add(row,role,selector):out.append(dict(path=row['source']['path'],role=role,selector=selector))
 if tid.startswith('SYS-09.3-'):
  names={'SYS-09.3-01':['Graves'],'SYS-09.3-02':['Tristana'],'SYS-09.3-03':['Ezreal'],'SYS-09.3-04':['Ezreal','Trundle'],'SYS-09.3-05':['Ezreal','Trundle'],'SYS-09.3-06':['Trundle'],'SYS-09.3-07':['Ezreal','Trundle']}[tid]
  for s in f['spells']:
   if s['champion'] in names:add(s,'native_special_movement_authoring_example_not_server_policy',s['spell']+'; '+','.join(x['field'] for x in s['fields']))
  add(f['navigation'],'native_map10_terrain_input_not_movement_permission','AIPath.aimesh_ngrid; current terrain/landing input')
 else:
  add(f['native_input'],'native_gameevents_bindings_not_controller_algorithm','[GameEvents]; '+','.join(EVENTS))
  if tid=='SYS-09.4-01':
   for r in f['selection_profiles']:add(r,'native_selection_radius_or_explicit_absence','Data.SelectionRadius='+str(r['native'])+'; fallback160 remains local for absent fields')
  if tid in ['SYS-09.4-03','SYS-09.4-06']:add(f['map_constants'],'native_camera_map_limits_not_input_bootstrap','cam_MinX/MinY/MaxX/MaxY/FarZ; keyboard orbit values not PAN_SPEED')
  if tid=='SYS-09.4-06':add(f['native_executable'],'original_camera_focus_sequence_inherited_execution','7D1A60/7CFB70; data/4.20/camera_focus_contract.json and camera_sequence_contract.json; not reexecuted')
  if tid in ['SYS-09.4-05','SYS-09.4-07']:add(f['level_size'],'native_map10_minimap_bounds','r3d2Mesh2.2 bounds@152; default Map10 projection')
 return out
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no source verification bypass')
 require(q['schema']=='openleague_motion_camera_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source pins changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'checks census')
 require([x['task_id'] for x in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchor rebound '+t);require(a['native_bindings']==bindings(f,t),'native role rebound '+t)
  require((a['finding'],a['remaining'])==FINDINGS[t],'claim rebound '+t);require(a['entry_boundary_only']==(t in BOUNDARIES) and a['full_task_scope_complete'] is False,'scope promoted '+t)
  u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown rebound '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),spells=len(f['spells']),selection_profiles=len(f['selection_profiles']),native_or_game_executed=False)
