"""Map10 wave/economy/announcement source links; no full native scheduler acceptance."""
import hashlib,json,pathlib,re,struct,sys
R=pathlib.Path('E:/OpenLeague');sys.path[:0]=[str(R/'tools/project-plan'),str(R/'tools'),str(R/'tools/pythonlibs')]
import pefile
from audit_navigation_reference import pin,load,require
from audit_structures_reference import functions
from native_lua import initialization
from reference_inibin import read,hashkey
from rads_reference_membership import RadsReferenceMembership
TARGETS=[f'SYS-10.5-{i:02}' for i in range(1,11)]
BOUNDARIES=set()
LOCAL=['crates/core/src/world.rs','crates/core/src/progression.rs','crates/core/src/passive_gold.rs','crates/core/src/lib.rs','crates/core/src/annie_r.rs','crates/client/src/map_audio.rs','crates/client/src/main.rs','crates/core/src/audio_announcer_catalog.rs']
SPECS={
 TARGETS[0]:[(0,'next_slot: spells::seconds(config.initial_wave_seconds),'),(0,'if self.tick >= world.next_slot {')],
 TARGETS[1]:[(0,'fn wave_sequence('),(0,'if world.slot == 0 {'),(0,'world.next_slot += spells::seconds(world.config.unit_spacing_seconds);')],
 TARGETS[2]:[(0,'let frequency = if self.tick >= spells::seconds(world.config.cannon_change_seconds)'),(0,'if super_count == 0 && world.wave.is_multiple_of(frequency) {')],
 TARGETS[3]:[(0,'let points = &world.config.lanes[lane].points;'),(0,'let mut route = self.world.as_ref().unwrap().config.lanes[lane]'),(0,'unit.route = route.into_iter().skip(1).collect();')],
 TARGETS[4]:[(0,'let points = &world.config.lanes[lane].points;'),(0,'let mut route = self.world.as_ref().unwrap().config.lanes[lane]'),(0,'unit.route = route.into_iter().skip(1).collect();')],
 TARGETS[5]:[(0,'let upgrades = if def.kind.lane() {'),(0,'let upgrades = upgrades.floor();'),(0,'gold: def.gold + (def.gold_upgrade * upgrades).min(def.gold_max_bonus),')],
 TARGETS[6]:[(0,'let radius = self.world.as_ref().unwrap().config.experience_radius;'),(0,'let share = experience / eligible.len().max(1) as f32;'),(1,'pub fn award_experience(')],
 TARGETS[7]:[(0,'killer.gold += gold + altar_bonus;'),(4,'pub(crate) fn combat_owner('),(0,'if unit.health <= 0. {')],
 TARGETS[8]:[(2,'pub(crate) fn advance_passive_gold('),(3,'self.advance_passive_gold();')],
 TARGETS[9]:[(5,'pub fn altar_events('),(6,'map_audio::altar_events,'),(7,'pub fn original_catalog()'),(7,'pub fn plan(')]
}
FINDINGS={
 TARGETS[0]:('INITIAL_TIME_TO_SPAWN=75 correspond à initial_wave_seconds ; enable_world arme next_slot et advance_world déclenche quand tick>=next_slot. Le callback GetInitSpawnInfo fournit le contrat de cadence natif.','Qualifier l’origine d’horloge et les frontières de scheduler moteur ; la concordance du champ75 ne démontre pas à elle seule l’exécution historique.'),
 TARGETS[1]:('Le code produit super(s),3mêlée,canon conditionnel,puis3casters. Le plan est figé au slot0,les unités espacées de0.8seconde et les vagues de30secondes ; le cap local compte180sbires vivants par équipe.','Qualifier GetMinionSpawnInfo et GetTotalTeamMinionsSpawned,cap par barracks,destructions et modes spéciaux ; un cap vivant local ne vaut pas preuve de la sémantique native du compteur.'),
 TARGETS[2]:('Le script déclare fréquence3,timer720 et callback fixant2. Le consommateur prend3 avant720secondes,puis2 par modulo du numéro de vague,et supprime le canon si un super est prévu.','Qualifier alignement du numéro de vague,ancrage du callback et changements en milieu de séquence ; la nouvelle fréquence est lue seulement lors de construction du plan.'),
 TARGETS[3]:('La voie haute contient25points correspondants aux marqueursSCO ; équipe0 suit l’ordre et équipe1 l’inverse. Le spawn prend la première/dernière position,avec nearest_walkable si le seed est hors sol.','Qualifier barracks actifs,projection nav et cheminement moteur historique ; les coordonnées ne prouvent pas les collisions,blocages ou parcours complet en partie.'),
 TARGETS[4]:('La voie basse contient18points correspondants aux marqueursSCO et suit les mêmes règles d’inversion pour équipe1 et de placement valide.','Qualifier chaque sens de parcours,liaisons nav et replis quand aucune cellule valide n’existe ; ne pas promouvoir une liste de points en recette de déplacement.'),
 TARGETS[5]:('Les huit définitions réutilisent les tables de Map10 pour stats et récompenses. Au spawn,les améliorations sont floor(tick/(30*90)),avec or bonus plafonné ; l’XP reste constant. UpgradeMinionTimer natif modifie les tables de barracks.','Qualifier ancrage du timer,arrondis,effet sur les unités déjà présentes et bonus d’inhibiteur ; distinguer les valeurs INIBIN de base et les overrides de carte.'),
 TARGETS[6]:('Le rayon1250 vient de SpawnTable.ExpRadius ; les sbires partagent leur XP entre joueurs alliés vivants à distance<=rayon. Les monstres/boss créditent seulement combat_owner. award_experience refuse montant invalide ou joueur absent.','Qualifier formule complète de partage,bonus,rayon effectif et règles natives de crédit ; le helper ne porte pas à lui seul les filtres d’équipe/vie qui sont dans son appelant.'),
 TARGETS[7]:('damage_unit crédite le joueur source ou le propriétaire présent du pet,via combat_owner. Une cible déjà morte ne redonne pas la récompense. Le bonus autel et les récompenses globales sont des branches séparées.','Qualifier admissibilité native complète et tous les producteurs de dégâts ; le helper de récompense ne prouve pas l’hostilité à lui seul ni la parité des récompenses de champions.'),
 TARGETS[8]:('Le default natif de montant est8 et d’intervalle5 ; Map10 fournit délai75 et versement permis aux morts. Le code paie aux frontières globales inclusives,sans rattrapage des arrivées tardives et sans basculer après firstblood CLASSIC.','Qualifier le scheduler serveur,le montage des variables et les modificateurs objets/maîtrises/champions ; FirstBloodmode30 est une configuration distincte,non un déclencheur CLASSIC.'),
 TARGETS[9]:('Des cues autel/relique sont enregistrés dans le client ; capture compare captured_tick et unlock traverse5400ticks. Le catalogue Rust des annonces charge quatre banques et conserve leurs alternatives. Les déclarations CLASSIC nomment tourelles,sbires,Vilemaw et autels.','Relier les événements gameplay à la sélection native d’annonce,au chat/texte,à la priorité et au mixer ; les cues locaux et les playlists disponibles ne prouvent pas la chaîne complète ou son écoute.')
}
def anchor(root,tid,i,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+tid+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='waves_'+tid.replace('-','_').replace('.','_')+'_'+str(i))
def _collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 m=RadsReferenceMembership(root)
 for x in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[z['identity'] for z in m.manifests],*m.provenance]:keep(x['path'])
 def native(logical,require_selected=True):
  p=m.deploy/logical;s=keep(p);member=m.inspect(logical,p,s)
  if require_selected:check('membership_'+logical,member['status']=='matches_selected_project_manifest')
  return dict(source=s,membership=member)
 level=native('LEVELS/Map10/Scripts/LevelScript.luaobj');top,fs=functions(pathlib.Path(level['source']['path']).read_bytes());g=json.loads(json.dumps(initialization(top)));globals=g['globals']
 selected=['OnLevelInitServer','GetInitSpawnInfo','GetMinionSpawnInfo','UpgradeMinionTimer','IncreaseCannonMinionSpawnRate','ResetToDefaultWaveCounts','ClearCurrentWaveCounts']
 rows=[]
 for name in selected:
  f=fs[name];rows.append(dict(name=name,constants=f['constants'],opcodes=[w&63 for w in f['code']],words_sha256=hashlib.sha256(struct.pack('<'+'I'*len(f['code']),*f['code'])).hexdigest()));checks.append('function_'+name)
 level.update(initialization=g,functions=rows,callbacks_executed=False);check('partial_top_initialization',g['stopped']=={'pc':277,'opcode':28})
 world=load(root/'data/4.20/map10_world.json');timers=[]
 for key,value,local,div in [('INITIAL_TIME_TO_SPAWN',75,'initial_wave_seconds',1),('UPGRADE_MINION_TIMER',90,'upgrade_seconds',1),('INCREASE_CANNON_RATE_TIMER',720,'cannon_change_seconds',1),('EXP_GIVEN_RADIUS',1250,'experience_radius',1)]:
  check('timer_'+key,globals[key]==value and world[local]==value/div);timers.append(dict(native_field=key,native=value,current_field=local,current=world[local],divisor=div))
 for key,local in [('WaveSpawnRate','wave_seconds'),('SingleMinionSpawnDelay','unit_spacing_seconds')]:
  value=globals['SpawnTable'][key];check('timer_'+key,world[local]==value/1000);timers.append(dict(native_field='SpawnTable.'+key,native=value,current_field=local,current=world[local],divisor=1000,unit_interpretation_qualified=False))
 check('wave_counts_and_frequency',globals['CANNON_MINION_SPAWN_FREQUENCY']==3 and fs['IncreaseCannonMinionSpawnRate']['constants']==['CANNON_MINION_SPAWN_FREQUENCY',2.0] and globals['MAX_MINIONS_EVER']==180)
 check('spawn_order',list(globals['DefaultBarrackInfo']['SpawnOrderMinionNames'].values())==['Super','Melee','Cannon','Caster'])
 profiles=[];fieldmap={'BaseHP':'health','BaseDamage':'damage','Armor':'armor','SpellBlock':'magic_resist','MoveSpeed':'move_speed','AttackRange':'attack_range','ExpGivenOnDeath':'experience','GoldGivenOnDeath':'gold'}
 tablemap={'Armor':'armor','MagicResistance':'magic_resist','ArmorUpgrade':'armor_upgrade','MagicResistanceUpgrade':'mr_upgrade','HPUpgrade':'hp_upgrade','DamageUpgrade':'damage_upgrade','ExpGiven':'experience','GoldGiven':'gold','GoldUpgrade':'gold_upgrade','GoldMaximumBonus':'gold_max_bonus'}
 for team in ['Blue','Red']:
  for suffix,table in [('Basic','Melee'),('Wizard','Caster'),('MechCannon','Cannon'),('MechMelee','Super')]:
   name=team+'_Minion_'+suffix;d=world['definitions'][name];s=native(f'DATA/Characters/{name}/{name}.inibin');v=read(s['source']['path']);fields=[]
   for key,local in fieldmap.items():
    raw=v.get(hashkey('Data',key));fields.append(dict(field='Data.'+key,present=raw is not None,native=raw,current=d[local],numeric_equal=raw is not None and float(raw)==d[local]));checks.append('INIBIN_'+name+'_'+key)
   values=globals[table+'DefaultMinionInfo'];overrides=[]
   for key,local in tablemap.items():
    check('table_'+name+'_'+key,values[key]==d[local]);overrides.append(dict(field=table+'DefaultMinionInfo.'+key,native=values[key],current=d[local],current_field=local))
   profiles.append(dict(name=name,**s,fields=fields,map_values=values,table_overrides=overrides))
 lanes=[]
 for idx,(prefix,end) in enumerate([('L',24),('R',17)]):
  names=[f'__P_Order_Spawn_Barracks__{prefix}01.sco']+[f'__NAV_{prefix}0{i}.sco' for i in range(2,end+1)]+[f'__P_Chaos_Spawn_Barracks__{prefix}01.sco'];pts=world['lanes'][idx]['points'];check('lane_size_'+str(idx),len(pts)==len(names));markers=[]
  for pt,name in zip(pts,names):
   s=native('LEVELS/Map10/scene/'+name);text=pathlib.Path(s['source']['path']).read_text();hit=re.findall(r'^CentralPoint=\s*([^\r\n]+)',text,re.M);check('marker_one_'+name,len(hit)==1);xyz=list(map(float,hit[0].split()));delta=[pt['x']-xyz[0],pt['z']-xyz[2]];check('marker_delta_'+name,max(map(abs,delta))<.001);markers.append(dict(**s,native_xyz=xyz,current=pt,delta=delta))
  lanes.append(dict(index=idx,markers=markers,current_forward=pts,current_reverse=list(reversed(pts)),native_route_algorithm_qualified=False))
 gold=load(root/'data/4.20/passive_gold_rules.json');contract=load(root/'data/4.20/passive_gold_native_contract.json');exe=native('League of Legends.exe');constants=native('LEVELS/Map10/Constants.var');text=pathlib.Path(constants['source']['path']).read_text(encoding='utf-8-sig')
 check('gold_inherited_binary_and_constants',exe['source']['sha256']==contract['native_executable_sha256'] and constants['source']['sha256']==contract['map_source_sha256'] and contract['passed'] is True and contract['complete'] is False)
 for key,value in contract['map_values'].items():
  hit=re.findall(r'^'+key+r'\s*=\s*([-+0-9.]+)',text,re.M);check('gold_config_'+key,len(hit)==1 and float(hit[0])==value)
 check('amount_override_absent',not re.search(r'^ai_AmbientGoldAmount\s*=',text,re.M) and contract['amount_override_present'] is False)
 pe=pefile.PE(exe['source']['path'],fast_load=True);windows=[]
 for start,var,name,value in [(0x4fe3f0,0x123a338,'ai_AmbientGoldAmount',8.),(0x4fe710,0x123a378,'ai_AmbientGoldInterval',5.)]:
  raw=pe.get_data(start-pe.OPTIONAL_HEADER.ImageBase,0x74);pattern=b'\xc7\x05'+struct.pack('<I',var+12)+struct.pack('<f',value);check('native_initializer_store_'+name,raw.count(pattern)==1)
  cases=[c for c in contract['cases'] if c['name']==name];check('inherited_initializer_cases_'+name,len(cases)==2 and all(c['entry']==start and c['variable']==var and struct.unpack('<f',struct.pack('<I',c['value_bits']))[0]==value for c in cases))
  windows.append(dict(entry=start,bytes=len(raw),sha256=hashlib.sha256(raw).hexdigest(),store_offset=raw.index(pattern),variable=var,name=name,default=value,fresh_execution=False))
 pe.close();check('current_gold_values',(gold['amount'],gold['interval_seconds'],gold['delay_seconds'],gold['disable_while_dead'],gold['first_blood_mode_delay_seconds'])==(8,5,75,False,30))
 ann=load(root/'data/4.20/announcement_definitions.json');classic=next(d for d in ann['definitions'] if d['source'].endswith('Announcements_CLASSIC.ini'));src=native(pathlib.Path(classic['source']).relative_to(m.deploy).as_posix(),False)
 check('classic_config_exact',src['source']['sha256']==next(s['sha256'] for s in ann['sources'] if s['path']==classic['source']))
 rawlines=pathlib.Path(src['source']['path']).read_text(encoding='utf-8-sig').splitlines();sections=[]
 for section in classic['sections']:
  if any(w in section['name'].lower() for w in ['minion','turret','barrack','inhib','spider','altar']):
   check('announcement_section_'+section['name'],rawlines[section['line']-1].strip()=='['+section['name']+']')
   for field in section['fields']:
    line=rawlines[field['line']-1].strip();parts=line.split('=',1);check('announcement_field_'+section['name']+'_'+field['key'],len(parts)==2 and parts[0].strip()==field['key'] and parts[1].strip()==field['value'])
   sections.append(section)
 graph=load(root/'data/4.20/announcer_audio_graph.json');banks=[]
 check('graph_link',keep(root/'data/4.20/announcer_audio_graph.json')['sha256']==ann['graph_sha256'])
 for bank in graph['banks']:
  s=native(pathlib.Path(bank['bank']).relative_to(m.deploy).as_posix(),False);check('bank_hash_'+pathlib.Path(bank['bank']).name,s['source']['sha256']==bank['bank_sha256']);containers={c['id']:c for c in bank['containers']};sounds={v['id']:v for v in bank['sounds']}
  for e in bank['events']:
   for action in e['actions']:
    c=containers[action['target']];check('playlist_'+str(e['id']),bool(c['playlist']) and all(sounds[p['sound']]['parent']==c['id'] for p in c['playlist']))
  banks.append(dict(**s,event_count=len(bank['events']),container_count=len(containers),sound_count=len(sounds)))
 check('four_banks_470events',len(banks)==4 and sum(b['event_count'] for b in banks)==470)
 cues=[keep(root/'assets/audio/map10'/name) for name in ['altar_capture.wav','altar_unlock.wav','relic_pickup.wav']]
 local={p:(root/p).read_text(encoding='utf8') for p in LOCAL}
 for name,idx,needles in [
 ('wave_scheduler',0,['if world.slot == 0 {','world.wave += 1;','world.config.initial_wave_seconds','world.config.unit_spacing_seconds','>= 180']),
 ('composition',0,['let mut sequence = vec![Kind::Super; super_count];','sequence.extend([Kind::Melee; 3]);','sequence.extend([Kind::Caster; 3]);','world.wave.is_multiple_of(frequency)']),
 ('routes',0,['if team == 1 {','route.reverse();','self.navigation.nearest_walkable(seed).unwrap_or(seed)']),
 ('upgrade_at_spawn',0,['let upgrades = upgrades.floor();','let health = def.health + def.hp_upgrade * upgrades;','experience: def.experience,']),
 ('XP_credit',0,['p.team == killing_team','p.health > 0.','p.position.distance(position) <= radius','experience / eligible.len().max(1) as f32','let credited=self.combat_owner(source);']),
 ('XP_refusal',1,['if !amount.is_finite() || amount <= 0.','return Err("invalid experience award".into());','ok_or("unknown player")?']),
 ('gold_boundaries',2,['self.tick<delay || (self.tick-delay)%interval!=0','if !r.disable_while_dead || p.health>0.','p.gold+=r.amount;']),
 ('objective_cues_not_announcer',5,['*tick < 5400 && snapshot.tick >= 5400','audio/map10/altar_capture.wav','current','PlaybackSettings::DESPAWN']),
 ('catalog_not_dispatch',7,['pub fn plan(','UnknownBank','UnknownEvent','InvalidGraph'])]:check(name,all(n in local[LOCAL[idx]] for n in needles))
 inherited={}
 for rel in ['docs/passive_gold_integration_progress.json','docs/passive_gold_network_validation.json','docs/announcement_definitions_validation.json','docs/announcer_audio_graph_progress.json']:
  keep(root/rel);old=load(root/rel);matches=[]
  for path,expected in old.get('files_sha256',{}).items():
   p=root/path
   if p.exists():s=keep(p);matches.append(dict(source=s,recorded_sha256=expected,current_matches_recorded=s['sha256']==expected))
   else:matches.append(dict(path=str(p),recorded_sha256=expected,present=False))
  if 'artifact' in old:
   s=keep(root/old['artifact']);matches.append(dict(source=s,recorded_sha256=old['artifact_sha256'],current_matches_recorded=s['sha256']==old['artifact_sha256']))
  inherited[rel]=dict(metadata=old,current_file_comparisons=matches,fresh_execution=False)
 for tid in TARGETS:
  for i,spec in enumerate(SPECS[tid]):checks.append('anchor_'+anchor(root,tid,i,spec)['role'])
 for p in LOCAL+['data/4.20/map10_world.json','data/4.20/passive_gold_rules.json','data/4.20/passive_gold_native_contract.json','data/4.20/announcement_definitions.json','data/4.20/announcer_audio_graph.json','docs/reference_client_4_20.json','tools/project-plan/audit_structures_reference.py','tools/project-plan/reference_inibin.py','tools/project-plan/rads_reference_membership.py','tools/project-plan/audit_navigation_reference.py','tools/native_lua.py']:keep(root/p)
 facts=dict(level_script=level,timers=timers,profiles=profiles,lanes=lanes,gold=dict(rules=gold,contract=contract,constants=constants,native_executable=exe,initializer_windows=windows,fresh_execution=False),announcements=dict(classic_source=src,sections=sections,banks=banks,graph_counts=dict(events=sum(b['event_count'] for b in banks),sounds=sum(b['sound_count'] for b in banks)),cue_assets=cues,cue_provenance_semantics_qualified=False,native_config_runtime_selection_qualified=False,audible_playback_observed=False),inherited_evidence=inherited,policies=dict(native_scheduler_anchor_qualified=False,cap_live_count_native_qualified=False,native_spawn_wave_index_qualified=False,all_live_units_upgrade_qualified=False,complete_XP_sharing_qualified=False,all_damage_credit_callers_qualified=False,ambient_gold_server_cadence_qualified=False,full_announcement_dispatch_qualified=False),source_checks=checks,native_or_game_executed=False,rust_tests_executed=False)
 return facts,list(pins.values())
_CACHE={}
def collect(root=R):
 k=str(pathlib.Path(root).resolve())
 if k not in _CACHE:_CACHE[k]=_collect(root)
 else:
  for p in _CACHE[k][1]:require(pin(p['path'])==p,'changed source '+p['path'])
 return _CACHE[k]
def bindings(f,tid):
 rows=[];idx=TARGETS.index(tid)
 def add(s,role,selector):rows.append(dict(path=s['source']['path'],role=role,selector=selector))
 if idx<8:add(f['level_script'],'native_Map10_wave_and_reward_tables_not_engine_scheduler','INITIAL_TIME_TO_SPAWN/SpawnTable/GetInitSpawnInfo/GetMinionSpawnInfo/UpgradeMinionTimer/IncreaseCannonMinionSpawnRate; named function bytes and limits retained')
 if idx in [1,5,6,7]:
  for p in f['profiles']:add(p,'native_minion_character_fields_distinct_from_map_overrides',p['name']+';raw Data fields with absent keys preserved; map table overrides recorded separately')
 if idx in [3,4]:
  for p in f['lanes'][idx-3]['markers']:add(p,'native_lane_marker_not_pathfinding_algorithm','CentralPoint;decimal delta retained;current route reverses for team1')
 if idx==8:
  add(f['gold']['constants'],'native_Map10_ambient_gold_overrides','delay75/interval5/deadflag0/FirstBloodmode30;amount override absent')
  add(f['gold']['native_executable'],'native_gold_static_default_stores','0x4fe3f0/0x4fe710;amount8/interval5;old adapted initializer cases not reexecuted;CVA mounting/server cadence open')
 if idx==9:
  add(f['announcements']['classic_source'],'native_CLASSIC_announcement_declarations_not_runtime_selection','OnMinionsSpawn/OnTurretDie/OnKillSpiderBoss/OnCaptureAltar;source membership status retained;ordinary/spectator separate')
  for b in f['announcements']['banks']:add(b,'native_announcer_bank_not_gameplay_trigger',pathlib.Path(b['source']['path']).name+';exact bank identity;catalog relationships checked,not mixer/audio acceptance')
 return rows
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no source verification bypass');require(q['schema']=='openleague_waves_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source pins changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'checks census');require([x['task_id'] for x in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchor rebound '+t);require(a['native_bindings']==bindings(f,t),'native role rebound '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim rebound '+t);require(a['entry_boundary_only']==(t in BOUNDARIES) and a['full_task_scope_complete'] is False,'scope promoted '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown rebound '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),native_or_game_executed=False)

