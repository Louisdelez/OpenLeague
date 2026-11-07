"""Source/consumer links for eight Map10 recipe requirements; never match acceptance."""
import hashlib,json,pathlib,re,struct,sys
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from audit_navigation_reference import pin,load,require
from frontend_builds import release_manifest,manifest_member
from local_services_reference import rpc_surface
from audit_structures_reference import functions
from rads_reference_membership import RadsReferenceMembership
TARGETS=[f'SYS-10.6-{i:02}' for i in range(1,9)]
BOUNDARIES=set()
LOCAL=['launcher/src-tauri/src/sessions.rs','crates/core/src/lib.rs','crates/server/src/session_host.rs','crates/core/src/world.rs','crates/core/src/match_results.rs','crates/core/src/interactions.rs','crates/core/src/altars.rs','crates/client/src/session_connection.rs','crates/server/src/reconnect.rs','crates/server/src/result_store.rs','crates/server/src/main.rs','crates/client/src/match_results_ui.rs','crates/client/src/main.rs','crates/client/src/terrain_material.rs','crates/client/src/map_audio.rs','crates/client/src/map_audio_requests.rs','crates/core/src/audio_announcer_catalog.rs']
SPECS={
 TARGETS[0]:[(0,'pub fn play(&self, root:'),(0,'pub fn join_local(&self,root:'),(1,'pub fn join(&mut self, name:'),(2,'let player = match game.join_with_summoners(')],
 TARGETS[1]:[(3,'pub fn protected(&self, id:'),(3,'self.winner = Some(1 - team);'),(4,'pub(crate) fn capture_final_results(')],
 TARGETS[2]:[(3,'pub fn protected(&self, id:'),(3,'self.winner = Some(1 - team);'),(4,'pub(crate) fn capture_final_results(')],
 TARGETS[3]:[(5,'pub(crate) fn advance_interactions('),(6,'pub(crate) fn advance(tick:'),(3,'for (index, member) in camp.config.members.iter().enumerate() {')],
 TARGETS[4]:[(7,'pub fn network_interrupted('),(2,'t::ClientMessage::Resume(request) => {'),(8,"pub fn prepare_resume<'a>(")],
 TARGETS[5]:[(4,'pub(crate) fn capture_final_results('),(9,'pub fn save(directory:'),(10,'match result_store::save('),(11,'fn summary(result:')],
 TARGETS[6]:[(12,'commands.insert_resource(MapHandle(assets.load("maps/twisted_treeline.glb")));'),(13,'pub fn bind(')],
 TARGETS[7]:[(14,'pub fn altar_events('),(15,'pub fn update(time:'),(12,'map_audio_requests::update.after(map_audio::ambient_positions),'),(16,'pub fn plan(')]
}
FINDINGS={
 TARGETS[0]:('Le superviseur play/join_local lance un client et refuse une autre session dans le même état ; Simulation::join limite à six joueurs et équilibre3/3. Host relie JoinResumable à cette création. La preuve réseau héritée contient six sockets UDP, pas six fenêtres.','Qualifier le lancement des six clients graphiques sur les mêmes binaires,identités et deux équipes ; garder le test UDP et les comptes/réservations historiques séparés.'),
 TARGETS[1]:('damage_unit applique protected puis la mort du Nexus fixe winner=1-team ; le Nexus rouge HQ_T2 porte team1 et ses dépendances locales. capture_final_results fige ensuite le résultat. Le callback natif HandleDestroyedObject référence EndOfGameCeremony.','Jouer et enregistrer la victoire bleue ordinaire avec six clients,commandes normales et chaîne de structures ; ni winner injecté ni damage_unit(1_000_000) ne constituent cette recette.'),
 TARGETS[2]:('La même branche traite HQ_T1/team0 pour une victoire rouge ; ses dépendances propres sont lues sans inférer la qualification depuis le camp bleu. Le résultat est capturé une seule fois.','Jouer et enregistrer séparément la victoire rouge ordinaire ; qualifier contraintes de structures,présentation terminale et résultats sur les mêmes binaires.'),
 TARGETS[3]:('advance_interactions appelle les autels et gère la relique ; advance_world crée les camps dont Vilemaw. Les anciens reçus autel/relique/monde sont des essais distincts,et les sorts/buff complets de Vilemaw restent partiels.','Observer autels,relique et Vilemaw dans le même match ordinaire jusqu’au résultat,avec identités de session et sources ; ne pas composer trois anciens essais en une seule partie acceptée.'),
 TARGETS[4]:('Le client marque une interruption pour récupérer le même joueur ; Host prépare et commit Resume avec nouvelle route/clock,Registry contrôle identité/epoch. Les transitions Detached et Retired ont des effets différents sur Simulation.','Qualifier une reconnexion de chaque équipe dans le même match courant,sans nouvelle identité ni double commande/récompense ; l’ancienne qualification automatisée ne prouve pas cette recette graphique.'),
 TARGETS[5]:('capture_final_results fige joueurs,score,inventaire et or restant. result_store publie un JSON synchronisé non remplaçable ; main réessaie une sauvegarde échouée après5secondes. Le panneau lit le roster figé et attend view.dismissed.','Qualifier six résultats uniques et gains de compte idempotents ; or restant,document par session et RPC AIR de consultation ne prouvent pas l’attribution de récompenses ni un historique de compte complet.'),
 TARGETS[6]:('Le client charge le GLB installé et lie les matériaux terrain ; ses octets et ceux du Blender courant sont comparés à V85. Le hash Blender actuel diffère de l’ancien reçu de création ; aucune nouvelle vue ni réexportation n’est déduite.','Comparer les zones,contacts,textures,effets et raccords dans le framebuffer courant avec les sources restaurées ; l’identité des fichiers et les anciennes observations ne sont pas une recette visuelle actuelle.'),
 TARGETS[7]:('Les cues autel/relique sont déclenchés ; les requêtes ambiantes sont mises en file logique après propagation des poses. Le diagnostic courant annonce backend_available=false. Le catalogue des banques fournit une planification, pas la chaîne complète des annonces.','Qualifier le backend sonore réel,dispatch/mixage/volumes puis écouter une partie complète ; conserver audio ponctuel,requête logique,graphe natif et écoute humaine comme preuves distinctes.')
}
def anchor(root,tid,i,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+tid+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='match_recipe_'+tid.replace('-','_').replace('.','_')+'_'+str(i))

def _collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 routespath=root/'docs/reference_air_routes_4_20.json';routes=load(routespath);keep(routespath)
 manifestpath=root/'docs/reference_frontend_sources/air_0.0.1.119.releasemanifest';keep(manifestpath);manifest=release_manifest(manifestpath,'lol_air_client','0.0.1.119')
 air=[]
 for name in ['GameServiceImpl','PlayerStatsServiceImpl','GameMap']:
  rows=[x for x in routes['review_sources'] if (x['analysis'].get('class') or '').split('.')[-1]==name];check('one_export_'+name,len(rows)==1);row=rows[0];raw=next(x for x in routes['original_sources'] if x['path']==row['input'])
  review=keep(root/'docs/reference_air_sources'/row['path']);binary=keep(root/'docs/reference_air_sources/original'/row['input'])
  check('review_identity_'+name,all(review[k]==row[k] for k in ['bytes','sha256']));check('library_identity_'+name,all(binary[k]==raw[k] for k in ['bytes','sha256']))
  member=manifest_member(manifest,row['input'],binary['path'],raw['manifest_entry']['release']);check('library_membership_'+name,member['bytes']==binary['bytes'])
  text=pathlib.Path(review['path']).read_text(encoding='utf8');calls=rpc_surface(text)
  if name=='GameServiceImpl':check('native_game_calls',{'createPracticeGame','joinOrCreatePracticeGame','retrieveInProgressGameInfo'}<=set(x.get('operation') for x in calls))
  elif name=='PlayerStatsServiceImpl':check('native_results_queries',{'getTeamEndOfGameStats','retrievePlayerStatsByAccountId','getRecentGames'}<=set(x.get('operation') for x in calls))
  else:check('native_map10_id','TWISTED_TREELINE_ID:int = 10;' in text)
  air.append(dict(class_name=name,review=review,binary=binary,member=member,rpc_calls=calls,fresh_export_executed=False,server_policy_qualified=False))
 m=RadsReferenceMembership(root)
 for s in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[z['identity'] for z in m.manifests],*m.provenance]:keep(s['path'])
 def native(path):
  p=pathlib.Path(path);p=p if p.is_absolute() else m.deploy/p;s=keep(p);member=m.inspect(p.relative_to(m.deploy).as_posix(),p,s);check('native_member_'+p.name,member['status']=='matches_selected_project_manifest');return dict(source=s,membership=member)
 level=native('LEVELS/Map10/Scripts/LevelScript.luaobj');_,fs=functions(pathlib.Path(level['source']['path']).read_bytes());callbacks=[]
 for name in ['HandleDestroyedObject','DeactivateCorrectStructure','OnLevelInitServer']:
  f=fs[name];callbacks.append(dict(name=name,constants=f['constants'],instruction_count=len(f['code']),words_sha256=hashlib.sha256(struct.pack('<'+'I'*len(f['code']),*f['code'])).hexdigest()));checks.append('callback_'+name)
 check('ceremony_callback_reference','EndOfGameCeremony' in fs['HandleDestroyedObject']['constants']);level.update(callbacks=callbacks,callbacks_executed=False)
 world=load(root/'data/4.20/map10_world.json');nexuses=[]
 for i in [1,2]:
  s=next(s for s in world['structures'] if s['name']==f'HQ_T{i}');check('nexus_team_'+str(i),s['team']==i-1 and s['depends_all']==[f'Turret_T{i}_C_01'] and s['depends_any']==[f'Barracks_T{i}_L1',f'Barracks_T{i}_R1'])
  marker=native(f'LEVELS/Map10/scene/HQ_T{i}.sco');line=re.findall(r'^CentralPoint=\s*([^\r\n]+)',pathlib.Path(marker['source']['path']).read_text(),re.M);check('nexus_marker_'+str(i),len(line)==1);xyz=list(map(float,line[0].split()));delta=[s['position']['x']-xyz[0],s['height']-xyz[1],s['position']['z']-xyz[2]];check('nexus_position_'+str(i),max(map(abs,delta))<.001);nexuses.append(dict(current=s,marker=marker,native_xyz=xyz,delta=delta,native_dependency_graph_qualified=False))
 mapq=load(root/'docs/reference_map_zones_sources/map_zones-links.json');keep(root/'docs/reference_map_zones_sources/map_zones-links.json')
 nvr=native(mapq['facts']['nvr']['source']['path']);neutral=native(mapq['facts']['neutral_source']['source']['path'])
 glb=keep(mapq['facts']['glb']['path']);blend=keep(mapq['facts']['blender']['source']['path']);check('current_GLB_same_as_V85',glb==mapq['facts']['glb']);check('current_blend_same_as_V85',blend==mapq['facts']['blender']['source'])
 oldblend=mapq['facts']['blender']['inherited_receipt'];mapfacts=dict(nvr=nvr,glb=glb,blend=blend,old_creation_blend_sha256=oldblend['blend_sha256'],current_matches_old_creation=blend['sha256']==oldblend['blend_sha256'],fresh_blender_execution=False,fresh_framebuffer_comparison=False)
 waveq=load(root/'docs/reference_waves_sources/waves-links.json');keep(root/'docs/reference_waves_sources/waves-links.json');ann=waveq['facts']['announcements'];announcement_sources=[native(s['source']['path']) for s in [ann['classic_source'],*ann['banks']]]
 for s in [ann['classic_source'],*ann['banks']]:check('V88_audio_identity_'+pathlib.Path(s['source']['path']).name,pin(s['source']['path'])==s['source'])
 cues=[keep(root/'assets/audio/map10'/name) for name in ['altar_capture.wav','altar_unlock.wav','relic_pickup.wav']]
 local={p:(root/p).read_text(encoding='utf8') for p in LOCAL}
 conditions=[('join_capacity',1,['if self.players.len() >= 6 {','let team = if blue <= purple { 0 } else { 1 };','match finished']),('launcher_single_session',0,['if state.has_session()','pub fn join_local(','pub fn play(']),('protected_nexus',3,['rule.depends_all.iter().any(alive)','rule.depends_any.iter().all(alive)','self.winner = Some(1 - team);','if kind==Kind::Nexus {self.capture_final_results();}']),('frozen_results',4,['if self.final_result.is_some(){return;}','self.winner.filter(|team|*team<2)','gold_remaining:p.gold','s.damage_unit(source,target,1_000_000.);']),('resume_paths',2,['r::Transition::Detached','r::Transition::Retired','game.remove_player(player);','self.registry.prepare_resume(peer, &request, now, entropy)','pending.commit(clock.bootstrap())']),('local_resume_limits',8,['live:6,identities:1024,endpoints:4096','Unauthorized','StaleEpoch','Duration::from_secs(30)']),('persistence',9,['file.sync_all()','fs::hard_link(&temporary,&path)','io::ErrorKind::AlreadyExists']),('persistence_retry',10,['if !result_saved && Instant::now()>=next_result_attempt','Duration::from_secs(5)']),('display_not_rewards',11,['gold_remaining','view.dismissed','VICTOIRE','DÉFAITE']),('ambient_unavailable',15,['"backend_available":false','state.pending.push(','state.unresolved.push(']),('cue_audio',14,['AudioPlayer::new','audio/map10/altar_capture.wav','audio/map10/relic_pickup.wav']),('catalog_refusals',16,['UnknownBank','UnknownEvent','InvalidGraph'])]
 for name,idx,needles in conditions:check(name,all(n in local[LOCAL[idx]] for n in needles))
 scripts=['tools/verify_network.py','tools/verify_world.py','tools/prepare_results_visual_fixture.py']
 for p in scripts:keep(root/p)
 nt=(root/scripts[0]).read_text();wt=(root/scripts[1]).read_text();fixture=(root/scripts[2]).read_text()
 check('six_socket_fixture',"socket.socket(socket.AF_INET,socket.SOCK_DGRAM)" in nt and "[0,0,0,1,1,1]" in nt);check('short_world_fixture','time.monotonic()+125' in wt);check('winner_injected_fixture','game.winner=Some(0)' in fixture)
 inherited={};evidence=['docs/network_validation.json','docs/world_network_validation.json','docs/altar_network_validation.json','docs/relic_network_validation.json','docs/match_results_progress.json','docs/match_results_visual_validation.json','docs/smite_and_authenticated_reconnection.json']
 comparisons=set(LOCAL+['target/debug/openleague-client.exe','target/debug/openleague-server.exe'])
 for rel in evidence:
  keep(root/rel);d=load(root/rel);rows=[]
  for p,h in {**d.get('files_sha256',{}),**d.get('sources',{})}.items():
   if p.replace('\\','/') not in comparisons:continue
   path=root/p
   if path.exists():s=keep(path);rows.append(dict(source=s,recorded_sha256=h,current_matches_recorded=s['sha256']==h))
   else:rows.append(dict(path=str(path),present=False,recorded_sha256=h))
  for p,identity in d.get('executables',{}).items():
   if p.replace('\\','/') in comparisons:
    s=keep(root/p);rows.append(dict(source=s,recorded_sha256=identity['sha256'],current_matches_recorded=s['sha256']==identity['sha256']))
  if 'server_sha256' in d:
   s=keep(root/'target/debug/openleague-server.exe');rows.append(dict(source=s,recorded_sha256=d['server_sha256'],current_matches_recorded=s['sha256']==d['server_sha256']))
  inherited[rel]=dict(metadata=d,current_file_comparisons=rows,fresh_execution=False)
 smite=inherited[evidence[-1]]['metadata'];qr=smite['qualification'];receipt=keep(qr['path']);check('reconnect_old_receipt_identity',all(receipt[k]==qr[k] for k in ['bytes','sha256']));oldrun=load(qr['path'])
 check('old_reconnect_limits',any('do not establish graphical' in s for s in oldrun['limits']))
 check('old_results_fixture',inherited['docs/match_results_visual_validation.json']['metadata']['diagnostic_fixture'] is True and inherited['docs/match_results_visual_validation.json']['metadata']['ordinary_victory_qualified'] is False)
 for p in LOCAL+['data/4.20/map10_world.json','docs/reference_local_services_4_20.json','docs/reference_loading_return_4_20.json','docs/reference_client_4_20.json','tools/project-plan/local_services_reference.py','tools/project-plan/audit_structures_reference.py','tools/project-plan/rads_reference_membership.py','tools/project-plan/frontend_builds.py','tools/project-plan/audit_navigation_reference.py']:keep(root/p)
 for tid in TARGETS:
  for i,spec in enumerate(SPECS[tid]):checks.append('anchor_'+anchor(root,tid,i,spec)['role'])
 f=dict(air=air,level_script=level,nexuses=nexuses,neutral_source=neutral,map=mapfacts,announcement_sources=announcement_sources,cue_assets=cues,inherited_evidence=inherited,reconnect_qualification=dict(source=receipt,limits=oldrun['limits'],fresh_execution=False),policies=dict(six_graphical_clients_observed=False,ordinary_blue_victory_observed=False,ordinary_red_victory_observed=False,all_objectives_one_match_observed=False,both_team_reconnect_observed=False,account_rewards_qualified=False,current_full_visual_acceptance=False,full_match_audio_acceptance=False),source_checks=checks,native_or_game_executed=False,rust_tests_executed=False)
 return f,list(pins.values())
_CACHE={}
def collect(root=R):
 k=str(pathlib.Path(root).resolve())
 if k not in _CACHE:_CACHE[k]=_collect(root)
 else:
  for p in _CACHE[k][1]:require(pin(p['path'])==p,'changed source '+p['path'])
 return _CACHE[k]
def bindings(f,tid):
 rows=[];i=TARGETS.index(tid)
 def add(s,role,selector):rows.append(dict(path=s['path'],role=role,selector=selector))
 if i in [0,4,5]:
  names={0:['GameMap','GameServiceImpl'],4:['GameServiceImpl'],5:['PlayerStatsServiceImpl']}[i]
  for a in f['air']:
   if a['class_name'] in names:add(a['binary'],'native_AIR_client_surface_not_server_implementation',a['class_name']+';export='+a['review']['path']+';map ID/createPracticeGame/retrieveInProgressGameInfo/playerStats queries as applicable;local sessions/rewards separate')
 if i in [1,2]:
  add(f['level_script']['source'],'native_destroyed_HQ_callback_not_ordinary_match_acceptance','HandleDestroyedObject:HQType/GetHQType/ORDER_HQ/CHAOS_HQ/EndOfGameCeremony;callbacks not executed')
  add(f['nexuses'][2-i]['marker']['source'],'native_target_Nexus_placement_not_dependency_policy',f['nexuses'][2-i]['current']['name']+';CentralPoint;dependency graph local')
 if i==3:add(f['neutral_source']['source'],'native_Map10_objective_locations_not_complete_match','CampSpawnPoints/CampFacePoints,camp7 relic,camp8 Vilemaw;prior V87 semantics still partial')
 if i==6:add(f['map']['nvr']['source'],'native_environment_input_not_current_framebuffer_acceptance','Map10 authored NVR;installed GLB and Blender separately identified;V85 source receipts inherited')
 if i==7:
  for a in f['announcement_sources']:add(a['source'],'native_audio_resource_not_audible_match_acceptance',pathlib.Path(a['source']['path']).name+';declarations/bank exact identity;no runtime dispatch/mixer qualification')
 return rows
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no bypass');require(q['schema']=='openleague_match_recipe_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source identities changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require([a['task_id'] for a in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchors '+t);require(a['native_bindings']==bindings(f,t),'native roles '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim '+t);require(a['entry_boundary_only'] is False and a['full_task_scope_complete'] is False,'scope '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),native_or_game_executed=False)
