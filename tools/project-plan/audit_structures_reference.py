"""Exact Map10 structure inputs and partial consumers; no whole-game qualification."""
import hashlib,json,pathlib,re,struct,sys
R=pathlib.Path('E:/OpenLeague');sys.path[:0]=[str(R/'tools/project-plan'),str(R/'tools')]
from audit_navigation_reference import pin,load,require
from rads_reference_membership import RadsReferenceMembership
from reference_inibin import read,hashkey
from native_lua import Chunk,initialization
TARGETS=[f'SYS-10.3-{i:02}' for i in range(1,10)]
BOUNDARIES=set(TARGETS[1:4])
LOCAL=['crates/core/src/world.rs','crates/core/src/damage.rs','crates/core/src/lib.rs','crates/client/src/main.rs','crates/client/src/animation.rs','crates/client/src/structure_animation_clock.rs','crates/client/src/nexus_ceremony.rs','crates/client/src/endgame_timeline.rs','crates/core/src/match_results.rs']
SPECS={
 TARGETS[0]:[(0,'pub fn protected(&self, id: u32)'),(1,'return Err("damage target protected".into());')],
 TARGETS[1]:[(0,'fn advance_npc_ai(&mut self)'),(0,'.min_by(|a, b| a.1.total_cmp(&b.1))')],
 TARGETS[2]:[(0,'let damage = p.damage;'),(1,'let outgoing = raw * self.exhaust_damage_multiplier(source, kind);')],
 TARGETS[3]:[(0,'pub fn protected(&self, id: u32)'),(0,'pub(crate) fn damage_unit(')],
 TARGETS[4]:[(3,'let destroyed = nexus_ceremony::destroyed(unit, snapshot.result.as_ref(), &clock, time.elapsed_secs_f64());'),(4,'pub fn request('),(5,'pub fn clamp_finished('),(6,'pub fn destroyed(unit:')],
 TARGETS[5]:[(0,'fn wave_sequence(&self, world: &World, team: u8, lane: usize)'),(0,'let mut sequence = vec![Kind::Super; super_count];')],
 TARGETS[6]:[(0,'unit.respawn_at = Some(self.tick + 240 * TICK_RATE);'),(0,'if u.respawn_at.is_some_and(|at| self.tick >= at) {')],
 TARGETS[7]:[(0,'self.winner = Some(1 - team);'),(1,'pub fn apply_damage('),(8,'pub(crate) fn capture_final_results(')],
 TARGETS[8]:[(2,'pub fn command(&mut self, id: u32, action: Action)'),(2,'pub fn advance(&mut self)'),(1,'pub fn apply_damage(')]
}
FINDINGS={
 TARGETS[0]:('Les18 structures ont un graphe local depends_all/depends_any. protected teste la vie des dépendances et protège toujours les fontaines ; apply_damage refuse une cible protégée. LevelScript contient les callbacks de déverrouillage et de réactivation.','Qualifier chaque arête contre les appels natifs et le contexte de lancement ; les noms et positions SCO n’établissent pas à eux seuls la politique d’invulnérabilité.'),
 TARGETS[1]:('Turret.luaobj possède OnCallForHelp,OnReceiveImportantCallForHelp et une liste de cibles. Le corps courant inspecté choisit la cible admissible la plus proche ; cette frontière n’implémente pas la priorité demandée de riposte.','Qualifier les arguments/callbacks natifs puis relier le producteur d’agression alliée et la priorité de riposte ; ne pas présenter la distance minimale comme la politique historique.'),
 TARGETS[2]:('Le code d’attaque courant capture p.damage dans Pending ; la réduction commune consomme cette valeur et les modificateurs généraux. Les INIBIN donnent les dégâts de base,et les CharScriptTT_Turret inspectés sont vides.','Identifier le producteur natif exact de l’escalade par cible et son reset ; l’absence dans ces fichiers bornés ne prouve pas une absence globale dans les scripts/objets serveur.'),
 TARGETS[3]:('OnLevelInitServer référence AllowDamageOnBuildings avec10secondes ; le callback contient SetInvulnerable/SetTargetable. protected actuel dépend du graphe et de la vie, sans lecture du temps dans son corps.','Qualifier l’ancrage du timer,les paramètres par catégorie etles protections temporelles complètes ; ne pas assimiler le seul graphe local à cette règle native.'),
 TARGETS[4]:('La réception choisit un alias _destroyed et remplace l’entité lors du changement.24 entrées de catalogue et48 rôles sont reliés à leurs GLB et politiques de lecture ; clamp_finished garde la pose finale des one-shot. Le Nexus passe par une échéance de cérémonie.','Qualifier matériaux,événements,débris et transitions de chaque structure en partie actuelle ; l’ancienne observation Turret_T2_L_02 ne couvre pas tous les bâtiments.'),
 TARGETS[5]:('wave_sequence ajoute1super pour l’inhibiteur adverse de la voie détruit,ou2 si les deux inhibiteurs sont détruits ; les callbacks natifs contiennent WillSpawnSuperMinion et les bonus de destruction/réapparition.','Qualifier le calcul natif complet de composition,bonus et limites ; aucun simple test de vie local ne prouve l’ensemble des bonus de destruction.'),
 TARGETS[6]:('Le script calcule240+0*NumOfSpawnDisables pour la suspension des vagues. Le code courant utilise240secondes depuis la mort pour rétablir toute la santé de l’inhibiteur. Ces contrats restent distincts.','Qualifier le timer natif de régénération de l’inhibiteur,son ancrage et ses états ; ne pas convertir le timer de suspension des sbires en preuve du respawn.'),
 TARGETS[7]:('damage_unit refuse match fini,dégâts invalides,cible protégée ou déjà morte,puis définit le gagnant à la mort du Nexus. capture_final_results gèle le résultat. HandleDestroyedObject/EndOfGame fournissent les sources de cérémonie.','Qualifier toutes les voies de dégâts autorisées,les dépendances et la victoire des deux équipes ; le helper de dégâts n’impose pas à lui seul l’hostilité du tireur,qui relève des appelants.'),
 TARGETS[8]:('command et apply_damage refusent match ended ; advance clôture les projectiles/effets nommés et capture le résultat. EndOfGameCeremony natif référence verrous d’entrée,HaltAllAI et arrêt des barracks.','Qualifier toutes les commandes et ordres retardés,les sessions et les UI ; le refus de simulation ne démontre pas tous les verrous natifs ou les états du client.')
}
SELECTED={
 'level':['OnLevelInitServer','AllowDamageOnBuildings','DeactivateCorrectStructure','GetDisableMinionSpawnTime','DisableBarracksSpawn','ApplyBarracksDestructionBonuses','ApplyBarracksRespawnReductions','BarrackReactiveEvent','GetMinionSpawnInfo','HandleDestroyedObject'],
 'turret':['OnInit','OnCallForHelp','OnReceiveImportantCallForHelp','TimerFindEnemies','PutTargetInTargetList','UpdateTargetList','HaltAI'],
 'endgame':['EndOfGameCeremony','DestroyNexusPhase','ScoreboardPhase']}
def functions(raw):
 c=Chunk(raw);p=c.function();require(c.i==len(raw),'complete Lua source parsed');named={}
 for i,w in enumerate(p['code'][:-1]):
  z=p['code'][i+1]
  if w&63==36 and z&63==7 and (w>>6)&255==(z>>6)&255:named[p['constants'][z>>14]]=p['functions'][w>>14]
 return p,named
def anchor(root,tid,i,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+tid+': '+n)
 return dict(path=p,line=hits[0],needle=n,role='structures_'+tid.lower().replace('-','_').replace('.','_')+'_'+str(i)+('_entry_boundary' if tid in BOUNDARIES else '_partial_consumer'))
def _collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 m=RadsReferenceMembership(root)
 for x in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[z['identity'] for z in m.manifests],*m.provenance]:keep(x['path'])
 def native(logical):
  p=m.deploy/logical;s=keep(p);member=m.inspect(logical,p,s);check('membership_'+logical,member['status']=='matches_selected_project_manifest');return dict(source=s,membership=member)
 scripts={};protos={};named={}
 for key,path in [('level','LEVELS/Map10/Scripts/LevelScript.luaobj'),('turret','DATA/Scripts/Turret.luaobj'),('endgame','DATA/Scripts/EndOfGame.luaobj')]:
  s=native(path);p,fs=functions(pathlib.Path(s['source']['path']).read_bytes());protos[key]=p;named[key]=fs;rows=[]
  for n in SELECTED[key]:
   v=fs[n];rows.append(dict(name=n,source_lines=v['lines'],constants=v['constants'],opcodes=[w&63 for w in v['code']],words_sha256=hashlib.sha256(struct.pack('<'+'I'*len(v['code']),*v['code'])).hexdigest()));check('function_'+key+'_'+n,True)
  scripts[key]=dict(**s,functions=rows,initialization=json.loads(json.dumps(initialization(p))),source_only=True)
 globals=scripts['level']['initialization']['globals'];timer=named['level']['GetDisableMinionSpawnTime'];check('spawn_disable_constants',globals['DISABLE_MINION_SPAWN_BASE_TIME']==240 and globals['DISABLE_MINION_SPAWN_MAG_TIME']==0)
 check('spawn_disable_function_shape',[w&63 for w in timer['code']]==[5,0,0,28,7,5,5,5,6,14,12,30,30])
 check('initial_building_timer_reference',10.0 in named['level']['OnLevelInitServer']['constants'] and 'AllowDamageOnBuildings' in named['level']['OnLevelInitServer']['constants'])
 check('turret_help_callbacks',named['turret']['OnReceiveImportantCallForHelp']['constants']==['ObjectInAttackRange','PutTargetInTargetList'])
 world=load(root/'data/4.20/map10_world.json');definitions={k:v for k,v in world['definitions'].items() if v['kind'] in ['Turret','Fountain','Inhibitor','Nexus']};check('12defs_18structures',len(definitions)==12 and len(world['structures'])==18)
 profiles=[];fields=['BaseHP','BaseDamage','Armor','SpellBlock','AttackRange','AcquisitionRange'];mapping=['health','damage','armor','magic_resist','attack_range','acquisition'];empty=[]
 for name,row in definitions.items():
  s=native(f'DATA/Characters/{name}/{name}.inibin');v=read(s['source']['path']);values=[]
  for field,local in zip(fields,mapping):
   raw=v.get(hashkey('Data',field));numeric=None if raw is None else float(raw);values.append(dict(field='Data.'+field,present=hashkey('Data',field) in v,native=raw,numeric=numeric,current=row[local],numeric_equal=numeric==row[local]));checks.append('field_'+name+'_'+field)
  profiles.append(dict(name=name,**s,fields=values,current_definition=row))
  if 'Turret' in name:
   c=native(f'DATA/Characters/{name}/Scripts/CharScript{name}.luaobj');p,_=functions(pathlib.Path(c['source']['path']).read_bytes());check('empty_charscript_'+name,p['constants']==[] and p['functions']==[]);empty.append(dict(name=name,**c,constants=p['constants'],opcodes=[w&63 for w in p['code']]))
 structure_rows=[];names={s['name'] for s in world['structures']}
 for row in world['structures']:
  s=native('LEVELS/Map10/scene/'+row['name']+'.sco');t=pathlib.Path(s['source']['path']).read_text();matches=re.findall(r'^CentralPoint=\s*([^\r\n]+)',t,re.M);check('SCO_center_'+row['name'],len(matches)==1);xyz=list(map(float,matches[0].split()));cur=[row['position']['x'],row['height'],row['position']['z']];delta=[a-b for a,b in zip(cur,xyz)];check('placement_'+row['name'],max(map(abs,delta))<0.001);check('dependency_names_'+row['name'],set(row['depends_all']+row['depends_any'])<=names);structure_rows.append(dict(**s,current=row,native_xyz=xyz,decimal_delta=delta))
 catalog=load(root/'data/4.20/world_animation_manifest.json');clock=load(root/'data/4.20/structure_clip_playback.json');period=load(root/'data/4.20/structure_clip_period_contract.json');life=load(root/'data/4.20/structure_native_lifecycle_contract.json');exe=native('League of Legends.exe')
 check('inherited_native_animation_binary',period['passed'] is True and life['passed'] is True and period['native_sha256']==life['native_sha256']==exe['source']['sha256'])
 blends=[]
 for entry in period['models']:
  s=native(pathlib.Path(entry['blend']).relative_to(m.deploy).as_posix());check('blend_hash_'+entry['model'],s['source']['sha256']==entry['blend_sha256']);blends.append(dict(model=entry['model'],**s,states=entry['states']))
 animations=[];assets={};roles=0
 for name in sorted(definitions):
  for model in [name,name+'_destroyed']:
   row=catalog[model];p=keep(root/'assets'/row['asset']);key=p['path'];raw=pathlib.Path(key).read_bytes();n=struct.unpack_from('<I',raw,12)[0];d=json.loads(raw[20:20+n]);clips=[a.get('name') for a in d.get('animations',[])];check('GLB_clips_'+model,clips==row['clips']);assets[key]=p;rs=[]
   for role,idx in row['roles'].items():
    check('clip_index_'+model+'_'+role,0<=idx<len(clips));c=clock['models'][model][role];source=next(x for x in period['models'] if x['model']==c['native_model']);state=next(x for x in source['states'] if x['name']==c['native_state']);l=next(x for x in life['states'] if x['model']==c['native_model'] and x['state']==c['native_state']);seconds=struct.unpack('<f',struct.pack('<I',state['native_period_bits']))[0]
    check('clock_policy_'+model+'_'+role,c['repeat']==l['loop'] and abs(c['gltf_endpoint']/c['speed']-seconds)<1e-6);rs.append(dict(role=role,index=idx,clip=clips[idx],clock=c,native_period_seconds=seconds));roles+=1
   animations.append(dict(model=model,source=p,catalog=row,roles=rs))
 check('24_structure_models',len(animations)==24)
 old=load(root/'docs/normal_structure_finished_animation_progress.json');historical_files=[]
 for rel,expected in old['files_sha256'].items():
  p=root/rel
  if not p.exists():historical_files.append(dict(path=str(p),expected_sha256=expected,present=False,current_equals_recorded=False));continue
  s=keep(p);historical_files.append(dict(source=s,expected_sha256=expected,present=True,current_equals_recorded=s['sha256']==expected))
 timerproof=load(root/'data/4.20/map10_inhibitor_timer_source_audit.json');check('timer_proof_not_respawn_authority',timerproof['qualified_native_inhibitor_respawn_seconds'] is None and timerproof['qualified_barrack_spawn_disable_seconds']==240)
 levelproof=next(x for x in timerproof['files'] if x['path'].endswith('LevelScript.luaobj'));check('timer_original_function_exact',levelproof['sha256']==scripts['level']['source']['sha256'] and levelproof['named_functions']['GetDisableMinionSpawnTime']==timer)
 local={p:(root/p).read_text(encoding='utf8') for p in LOCAL};protect=local[LOCAL[0]].split('pub fn protected(',1)[1].split('pub(crate) fn spawn_unit(',1)[0]
 check('protection_predicate',all(x in protect for x in ['rule.depends_all.iter().any(alive)','rule.depends_any.iter().all(alive)','unit.kind == Kind::Fountain']) and 'self.tick' not in protect)
 check('damage_and_terminal_guards',all(x in local[LOCAL[0]] for x in ['if self.winner.is_some() {return;}','!reduced.is_finite() || reduced < 0. || self.protected(target)','unit.respawn_at = Some(self.tick + 240 * TICK_RATE);','u.health = u.max_health;','self.winner = Some(1 - team);']))
 check('super_policy',all(x in local[LOCAL[0]] for x in ['inhibitors.len() == 2 && inhibitors.iter().all(|u| u.health <= 0.)','u.lane == Some(lane) && u.health <= 0.','if super_count == 0 && world.wave.is_multiple_of(frequency)']))
 check('current_damage_boundary',all(x in local[LOCAL[1]] for x in ['return Err("match ended".into());','return Err("unknown damage source".into());','return Err("damage target protected".into());']))
 check('visual_swap_and_clock',all(x in local[LOCAL[3]] for x in ['format!("{}_destroyed", unit.definition)','commands.entity(entity).despawn();']) and 'if !clock.repeat {active.seek_to(clock.gltf_endpoint);}' in local[LOCAL[5]])
 check('terminal_command_and_tick', 'return Err("match ended".into());' in local[LOCAL[2]] and local[LOCAL[2]].count('self.capture_final_results();')>=2)
 for tid in TARGETS:
  for i,s in enumerate(SPECS[tid]):a=anchor(root,tid,i,s);checks.append('anchor_'+a['role'])
 for p in LOCAL+['data/4.20/map10_world.json','data/4.20/world_animation_manifest.json','data/4.20/structure_clip_playback.json','data/4.20/structure_clip_period_contract.json','data/4.20/structure_native_lifecycle_contract.json','data/4.20/map10_inhibitor_timer_source_audit.json','docs/normal_structure_finished_animation_progress.json','docs/normal_structure_combat_progress.json','docs/reference_client_4_20.json','tools/audit_native_map10_inhibitor_timers.py','tools/native_lua.py','tools/project-plan/reference_inibin.py','tools/project-plan/rads_reference_membership.py','tools/project-plan/audit_navigation_reference.py']:keep(root/p)
 facts=dict(scripts=scripts,profiles=profiles,empty_turret_charscripts=empty,structures=structure_rows,native_executable=exe,native_blends=blends,animations=animations,animation_roles=roles,inherited_period_contract=dict(cases=sum(len(s['clock_cases']) for m in period['models'] for s in m['states']),limits=period['limits'],fresh_execution=False),inherited_lifecycle_contract=dict(states=len(life['states']),limits=life['limits'],fresh_execution=False),historical_turret_observation=dict(metadata=old,files=historical_files,fresh_execution=False),timer=dict(native_spawn_disable_base=240,native_spawn_disable_magnitude=0,native_inhibitor_respawn_seconds=None,current_respawn_seconds=240,inherited_cases=timerproof['barrack_duration_cases']),local_policies=dict(target_choice='minimum_distance_in_named_body',same_target_ramp_qualified=False,temporal_protection_qualified=False,all_dependencies_native_qualified=False,all_structures_current_visual_tested=False,victory_all_callers_qualified=False,native_engine_callback_qualified=False),source_checks=checks,historical_server_policy_qualified=False,native_or_game_executed=False,rust_tests_executed=False)
 return facts,list(pins.values())
_CACHE={}
def collect(root=R):
 k=str(pathlib.Path(root).resolve())
 if k not in _CACHE:_CACHE[k]=_collect(root)
 else:
  for p in _CACHE[k][1]:require(pin(p['path'])==p,'changed source '+p['path'])
 return _CACHE[k]
def bindings(f,tid):
 rows=[]
 def add(s,role,selector):rows.append(dict(path=s['source']['path'],role=role,selector=selector))
 selected={0:['DeactivateCorrectStructure','ApplyBarracksRespawnReductions','HandleDestroyedObject'],1:[],2:[],3:['OnLevelInitServer','AllowDamageOnBuildings'],4:['HandleDestroyedObject'],5:['GetMinionSpawnInfo','ApplyBarracksDestructionBonuses','ApplyBarracksRespawnReductions'],6:['GetDisableMinionSpawnTime','DisableBarracksSpawn','BarrackReactiveEvent','HandleDestroyedObject'],7:['HandleDestroyedObject'],8:[]}[TARGETS.index(tid)]
 if selected:add(f['scripts']['level'],'native_Map10_structure_callback_source_not_engine_qualification',';'.join(selected))
 if tid in TARGETS[1:3]:
  add(f['scripts']['turret'],'native_turret_callback_source_not_ramp_authority','OnCallForHelp/OnReceiveImportantCallForHelp/TimerFindEnemies; native engine arguments/priority separate')
  for p in f['profiles']:
   if 'Turret' in p['name']:add(p,'native_turret_base_stats_not_per_target_scaling','Data.BaseDamage/Armor/SpellBlock/AttackRange/AcquisitionRange; absent fields retained')
 if tid==TARGETS[2]:
  for p in f['empty_turret_charscripts']:add(p,'native_empty_CharScript_not_global_absence_proof','empty constant and child arrays; other inherited/script/item producers not ruled out')
 if tid in [TARGETS[0],TARGETS[7]]:
  for p in f['structures']:add(p,'native_structure_placement_not_dependency_authority',p['current']['name']+'; CentralPoint; local dependency graph separately identified')
 if tid in [TARGETS[4],TARGETS[7],TARGETS[8]]:add(f['scripts']['endgame'],'native_endgame_callback_source_not_current_full_acceptance','EndOfGameCeremony/DestroyNexusPhase/ScoreboardPhase; timers and engine flags require qualification')
 if tid==TARGETS[4]:
  for p in f['native_blends']:add(p,'native_structure_animation_state_input',p['model']+'; inherited period/lifecycle contracts; not reexecuted')
  add(f['native_executable'],'original_structure_clock_lifecycle_inherited_evidence','structure_clip_period_contract and structure_native_lifecycle_contract; exact binary hash; not executed now')
 return rows
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no source verification bypass');require(q['schema']=='openleague_structures_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source pins changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'checks census');require([x['task_id'] for x in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchor rebound '+t);require(a['native_bindings']==bindings(f,t),'native role rebound '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim rebound '+t);require(a['entry_boundary_only']==(t in BOUNDARIES) and a['full_task_scope_complete'] is False,'scope promoted '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown rebound '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),native_scripts=len(f['scripts']),structure_models=len(f['animations']),native_or_game_executed=False)
