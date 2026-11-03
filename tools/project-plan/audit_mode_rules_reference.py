"""Mode-rule source trace; native constants and AIR branches are not server policy."""
import copy,hashlib,json,pathlib,re,sys
R=pathlib.Path('F:/OpenLeague');sys.path[:0]=[str(R/'tools/project-plan'),str(R/'tools')]
from rads_reference_membership import RadsReferenceMembership,identity as pin
from frontend_builds import release_manifest,manifest_member
from native_lua import Chunk,initialization
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(ok,message):
 if not ok:raise ValueError(message)
TARGETS=[f'SYS-11.3-{i:02}' for i in range(1,6)];BOUNDARIES=set(TARGETS)
LOCAL=['launcher/src-tauri/src/main.rs','crates/core/src/lib.rs','crates/core/src/world.rs','crates/core/src/regeneration.rs','crates/core/src/shop.rs','crates/core/src/match_results.rs','crates/server/src/main.rs','crates/core/src/session_transport.rs']
SPECS={TARGETS[0]:[(0,'fn play('),(0,'fn join_local('),(1,'pub fn join(&mut self, name: &str) -> Result<u32, String> {')],TARGETS[1]:[(1,'let team = if blue <= purple { 0 } else { 1 };'),(2,'pub fn enable_map10(&mut self) -> Result<(), String> {'),(2,'self.winner = Some(1 - team);')],TARGETS[2]:[(1,'pub enum Action {'),(3,'pub(crate) fn advance_regeneration(&mut self) {'),(4,'fn shop_guard(&self, id: u32) -> Result<(), String> {'),(4,'pub fn buy_item(&mut self, id: u32, item_id: u32) -> Result<(), String> {')],TARGETS[3]:[(5,'pub struct MatchResult {'),(5,'pub(crate) fn capture_final_results(&mut self) {')],TARGETS[4]:[(6,'game.enable_map10().map_err(std::io::Error::other)?;'),(5,'fn actual_nexus_death_captures_terminal_results_after_dependency_chain(){')]}
FINDINGS={
TARGETS[0]:('GameTypeConfig distingue six stratégies de sélection et des champs de timers/pools/bans. GameTypeConfigManager conserve les configurations reçues ; les contrôleurs AIR appliquent exclusivePick,crossTeamChampionPool et allowTrades. Le launcher local accepte champion et sorts puis join répartit les joueurs sans protocole blind/draft identifié dans ces entrées.','Retrouver les payloads GameTypeConfig effectifs de chaque file EUW, les séquences de bans/picks/timers et les refus serveur ; qualifier leur consommateur local. Les constantes et branches AIR ne fournissent pas ces valeurs serveur.'),
TARGETS[1]:('Les cinq LevelScript sont des membres exacts de la référence ; les constantes TEAM_ORDER/TEAM_CHAOS et fonctions de niveau sont relevées. Les cérémonies Map8/Map12 et leurs ScoreboardPhase sont distinguées des conditions qui déclenchent la victoire. join local limite six joueurs et équilibre deux équipes avec spawns Map10 ; world fixe winner après destruction du Nexus.','Qualifier équipes,départs et conditions de victoire par couple carte-mode retenu, avec les appels serveur effectifs. La cérémonie de fin ne prouve pas les règles de victoire ; les équipes 0/1 locales ne constituent pas un contrat universel pour tous les modes.'),
TARGETS[2]:('Huit variantes de Recall portent ChannelDuration global initial8,7,4.5,4,6,5.5,4,4. Map12 lie ApplyAramBuffs à deux buffs ; leurs luaobj ne déclarent que métadonnées et persistance. CloseShop/INPUT_LOCK_SHOP appartiennent à EndOfGameCeremony Map8/Map12. Les consommateurs locaux exposent Action, régénération et boutique Map10, pas une politique par mode qualifiée.','Relier la sélection des rappels, interruptions/téléportation et effets des buffs aux contrôleurs natifs ; qualifier restrictions de rappel,régénération et achats pour chaque mode. Ne pas déduire une interdiction depuis le nom du buff ni depuis CloseShop en fin de partie.'),
TARGETS[3]:('EndOfGameStats déclare gameLength,invalid,ipEarned,experienceEarned,bonus et limites custom/coop. Ces champs reçus ne sont pas une formule ni un seuil. MatchResult local capture score,inventaire et gold_remaining après winner ; cet or de partie ne prouve pas une récompense de compte.','Retrouver le calcul natif/service des récompenses et seuils d’admissibilité avec unités, files et exceptions ; relier au consommateur de compte local. Garder durée minimale inconnue ; ne pas inventer un seuil depuis un DTO.'),
TARGETS[4]:('GameQueueConfig et PracticeGameConfig séparent carte,mode,mutateurs,taille et configuration. Le démarrage serveur courant charge Map10 ; le test de résultat détruit les structures avec dégâts injectés et ne constitue pas une recette ordinaire multi-mode. Les sources de niveau sont identifiées sans exécution.','Établir la matrice carte-mode retenue et une recette ordinaire par couple, du lobby au résultat avec preuves visuelles, gameplay et réseau ; conserver les tests de contrat sans les transformer en recettes complètes.')}
CLASSES=['GameTypeConfig','GameTypeConfigManager','ChampionSelectionControllerNew','GameUpdateCommand','SetVisibleChampionsCommand','GameQueueConfig','PracticeGameConfig','EndOfGameStats','GameMode']
CONDITIONS={
'GameTypeConfig':['PICK_MODE_SIMUL_PICK:String = "SimulPickStrategy"','PICK_MODE_DRAFT_MODE_SINGLE_PICK:String = "DraftModeSinglePickStrategy"','PICK_MODE_ALL_RANDOM:String = "AllRandomPickStrategy"','PICK_MODE_TOURNAMENT:String = "TournamentPickStrategy"','PICK_MODE_VOTE_PICK:String = "OneTeamVotePickStrategy"','PICK_MODE_ALL_VOTE_PICK:String = "AllTeamVotePickStrategy"','mainPickTimerDuration','postPickTimerDuration','banTimerDuration','maxAllowableBans','duplicatePick','allowTrades'],
'GameTypeConfigManager':['public function setGameTypeConfigs(param1:ArrayCollection)','if(param1 == null)','this.gameTypeConfigs = param1;','if(_loc3_.id == param1)','return _loc2_;'],
'ChampionSelectionControllerNew':['gameTypeConfig.pickMode == GameTypeConfig.PICK_MODE_DRAFT_MODE_SINGLE_PICK','gameTypeConfig.pickMode == GameTypeConfig.PICK_MODE_TOURNAMENT','gameTypeConfig.pickMode == GameTypeConfig.PICK_MODE_ALL_RANDOM','_loc4_ = Boolean(this.championSelectionViewModel.gameTypeConfig.allowTrades);','championSelectionState == GameState.POST_CHAMPION_SELECTION && !this.championSelectionViewModel.isSpectating && _loc4_'],
'GameUpdateCommand':['gameTypeConfig.exclusivePick == true','_loc3_ = _loc4_ = true;'],
'SetVisibleChampionsCommand':['gameTypeConfig.crossTeamChampionPool','_loc1_.ownedByEitherTeam = true;'],
'GameQueueConfig':['supportedMapIds','gameMutators','gameTypeConfigId','numPlayersPerTeam'],
'PracticeGameConfig':['gameMap:GameMap','gameMutators:ArrayCollection','gameTypeConfig:int','gameMode:String'],
'EndOfGameStats':['gameLength','invalid','ipEarned','experienceEarned','basePoints','completionBonusPoints','firstWinBonus','practiceMinutesPlayedToday','customMinutesLeftToday','coOpVsAiMsecsUntilReset','imbalancedTeamsNoPoints'],
'GameMode':['DOMINION:String = "ODIN"','ARAM:String = "ARAM"','CLASSIC:String = "CLASSIC"']}
RECALLS=dict(Recall=8,RecallImproved=7,OdinRecall=4.5,OdinRecallImproved=4,ShowdownRecall=6,ShowdownRecallImproved=5.5,SuperRecall=4,SuperRecallImproved=4)
MAPS=['Map1','Map8','Map10','map11','Map12']
def anchor(root,tid,i,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+tid+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='mode_rules_boundary_'+tid.replace('-','_').replace('.','_')+'_'+str(i))
def function_records(proto):
 names={}
 for pc,w in enumerate(proto['code'][:-1]):
  nxt=proto['code'][pc+1]
  if w&63==36 and nxt&63==7 and ((w>>6)&255)==((nxt>>6)&255):
   child=w>>14;require(proto['functions'][child]['flags'][0]==0,'no closure upvalue binding');names[child]=proto['constants'][nxt>>14]
 selected=['OnLevelInit','OnLevelInitServer','ApplyAramBuffs','HandleDestroyedObject','EndOfGameCeremony','ScoreboardPhase']
 return [dict(index=i,name=names[i],lines=f['lines'],constants=f['constants'],code=f['code'],callbacks_executed=False) for i,f in enumerate(proto['functions']) if names.get(i) in selected]
def _collect(root=R):
 root=pathlib.Path(root).resolve();pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 location=load(root/'docs/project_location.json');keep(root/'docs/project_location.json')
 check('active_root',location['schema']=='openleague-project-location/v1' and pathlib.Path(location['active_root']).resolve()==root)
 historical=pathlib.Path(location['previous_root']).resolve(strict=True);check('historical_readonly_root',historical!=root and location['external_historical_sources_preserved'] is True)
 m=RadsReferenceMembership(historical);current=keep(root/'data/4.20/recovered_rads_manifests.json');check('catalogue_same_bytes',all(current[k]==m.catalogue_identity[k] for k in ['bytes','sha256']))
 check('current_membership_module',pathlib.Path(sys.modules['rads_reference_membership'].__file__).resolve()==root/'tools/project-plan/rads_reference_membership.py')
 for s in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[x['identity'] for x in m.manifests],*m.provenance]:keep(s['path'])
 routespath=root/'docs/reference_air_routes_4_20.json';routes=load(routespath);keep(routespath)
 mp=root/'docs/reference_frontend_sources/air_0.0.1.119.releasemanifest';keep(mp);manifest=release_manifest(mp,'lol_air_client','0.0.1.119');air=[];texts={};branches=[]
 for name in CLASSES:
  rows=[x for x in routes['review_sources'] if (x['analysis'].get('class') or '').split('.')[-1]==name];check('one_export_'+name,len(rows)==1);row=rows[0];raw=next(x for x in routes['original_sources'] if x['path']==row['input'])
  review=keep(root/'docs/reference_air_sources'/row['path']);binary=keep(root/'docs/reference_air_sources/original'/row['input'])
  check('export_hash_'+name,all(review[k]==row[k] for k in ['bytes','sha256']));check('library_hash_'+name,all(binary[k]==raw[k] for k in ['bytes','sha256']))
  member=manifest_member(manifest,row['input'],binary['path'],raw['manifest_entry']['release']);check('library_member_'+name,member['bytes']==binary['bytes'])
  text=pathlib.Path(review['path']).read_text(encoding='utf8');texts[name]=text
  for i,n in enumerate(CONDITIONS[name]):
   lines=[j+1 for j,l in enumerate(text.splitlines()) if n in l];check('AIR_branch_'+name+'_'+str(i),bool(lines));branches.append(dict(class_name=name,needle=n,lines=lines))
  air.append(dict(class_name=name,review=review,binary=binary,member=member,export_reexecuted=False,server_payload_recovered=False))
 strategies=dict(re.findall(r'public static const (PICK_MODE_\w+):String = "([^\"]+)";',texts['GameTypeConfig']))
 def lua(logical):
  path=m.deploy/logical;s=keep(path);member=m.inspect(logical,path,s);check('native_member_'+logical,member['status']=='matches_selected_project_manifest')
  raw=path.read_bytes();c=Chunk(raw);p=c.function();check('lua_complete_'+logical,c.i==len(raw));init=initialization(p)
  return dict(source=s,membership=member,initialization_stop=init['stopped'],callbacks_executed=False),p,init
 levels=[]
 for name in MAPS:
  resource,p,init=lua(f'LEVELS/{name}/Scripts/LevelScript.luaobj');g=init['globals'];check('team_constants_'+name,g.get('TEAM_ORDER')==100 and g.get('TEAM_CHAOS')==200)
  levels.append(dict(map_directory=name,resource=resource,teams={k:g[k] for k in ['TEAM_ORDER','TEAM_CHAOS']},functions=function_records(p),effective_mode_policy_qualified=False))
 for name in ['Map8','Map12']:
  fs=next(x for x in levels if x['map_directory']==name)['functions'];cer=next(x for x in fs if x['name']=='EndOfGameCeremony');end=next(x for x in fs if x['name']=='ScoreboardPhase')
  check('shop_lock_is_EOG_'+name,{'CloseShop','INPUT_LOCK_SHOP'}<=set(cer['constants']));check('EndGame_in_scoreboard_'+name,'EndGame' in end['constants'])
 aram=next(x for x in levels if x['map_directory']=='Map12')['functions'];apply=next(x for x in aram if x['name']=='ApplyAramBuffs');server=next(x for x in aram if x['name']=='OnLevelInitServer')
 check('Aram_buff_source_chain',{'ApplyPersistentBuffToAllChampions','HowlingAbyssAura','AramShopDisableNoParticle'}<=set(apply['constants']) and 'ApplyAramBuffs' in server['constants'])
 recalls=[]
 for name,duration in RECALLS.items():
  resource,p,init=lua('DATA/Spells/'+name+'.luaobj');check('recall_duration_'+name,init['stopped'] is None and init['globals']['ChannelDuration']==duration)
  recalls.append(dict(name=name,resource=resource,initial_globals=init['globals'],channel_duration=duration,effective_selection_qualified=False))
 buffs=[]
 for name in ['AramShopDisableNoParticle','HowlingAbyssAura']:
  resource,p,init=lua('DATA/Spells/'+name+'.luaobj');check('metadata_only_'+name,init['stopped'] is None and not p['functions'] and init['globals']['PersistsThroughDeath'] is True)
  buffs.append(dict(name=name,resource=resource,initial_globals=init['globals'],effect_qualified=False))
 localtexts={p:(root/p).read_text(encoding='utf8') for p in LOCAL}
 needed={LOCAL[0]:['champion: String,','summoners: [Option<String>; 2],','state.play(&root, &champion, &summoner_json)','state.join_local(&root, &champion, &summoner_json)'],LOCAL[1]:['if self.players.len() >= 6','"3v3 lobby full"','champion_spawns_map10.json','let team = if blue <= purple { 0 } else { 1 };'],LOCAL[2]:['map10_world.json','if kind == Kind::Nexus','self.winner = Some(1 - team);'],LOCAL[3]:['.filter(|p| p.health > 0.)','healing::received_multiplier(p,self.tick)'],LOCAL[4]:['"outside allied shop"','match map10_available(item_id)','"item map availability not qualified"'],LOCAL[5]:['gold_remaining','self.final_result.is_some()','self.winner.filter(|team|*team<2)','1_000_000.'],LOCAL[6]:['game.enable_map10().map_err(std::io::Error::other)?;']}
 for p,needles in needed.items():
  for i,n in enumerate(needles):check('current_branch_'+p+'_'+str(i),n in localtexts[p])
 action=localtexts[LOCAL[1]].split('pub enum Action {',1)[1].split('\n}',1)[0];check('no_recall_variant_in_Action',not re.search(r'\bRecall\b',action))
 for p in LOCAL+['tools/native_lua.py','tools/project-plan/frontend_builds.py','tools/project-plan/rads_reference_membership.py','docs/reference_client_4_20.json','data/4.20/champion_spawns_map10.json','data/4.20/map10_world.json']:keep(root/p)
 for t in TARGETS:
  for i,s in enumerate(SPECS[t]):checks.append('anchor_'+anchor(root,t,i,s)['role'])
 facts=dict(storage_roots=dict(current_project=str(root),historical_manifest_reference=str(historical),historical_reference_read_only=True),air=air,air_branches=branches,pick_strategies=strategies,levels=levels,recalls=recalls,buffs=buffs,local=dict(join_player_limit=6,spawn_map=10,action_enum_has_Recall=False,action_enum_scope='crates/core/src/lib.rs Action only;not global absence',gold_remaining_is_account_reward=False,ordinary_full_match_recipe_executed=False),policies=dict(server_GameTypeConfig_payload_recovered=False,effective_mode_matrix_qualified=False,minimum_eligible_duration=None,account_reward_formula_qualified=False,Recall_mode_selection_qualified=False,buff_effects_qualified=False,full_mode_gameplay_qualified=False,native_or_game_executed=False),source_checks=checks)
 return json.loads(json.dumps(facts)),list(pins.values())
_CACHE={}
def collect(root=R):
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=_collect(root)
 else:
  for p in _CACHE[key][1]:require(pin(p['path'])==p,'changed source '+p['path'])
 return _CACHE[key]
def bindings(f,tid):
 names={TARGETS[0]:CLASSES[:5],TARGETS[1]:['GameQueueConfig','GameMode'],TARGETS[2]:['GameMode'],TARGETS[3]:['EndOfGameStats'],TARGETS[4]:['GameQueueConfig','PracticeGameConfig','GameMode']}[tid]
 rows=[dict(path=a['binary']['path'],role='native_AIR_mode_declaration_or_branch_not_server_policy',selector=a['class_name']+';export='+a['review']['path']+';no dated server payload') for a in f['air'] if a['class_name'] in names]
 if tid in [TARGETS[1],TARGETS[2],TARGETS[4]]:
  for x in f['levels']:rows.append(dict(path=x['resource']['source']['path'],role='native_level_mode_source_without_callback_execution',selector=x['map_directory']+';TEAM_ORDER/TEAM_CHAOS and selected named functions in receipt;not active mode qualification'))
 if tid==TARGETS[2]:
  for x in f['recalls']+f['buffs']:rows.append(dict(path=x['resource']['source']['path'],role='native_mode_spell_initial_metadata_not_effective_policy',selector=x['name']+';top-level globals;no callback or server effect executed'))
 return rows

def audit(q,root='F:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no bypass');require(q['schema']=='openleague_mode_rules_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source identities changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require([a['task_id'] for a in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchors '+t);require(a['native_bindings']==bindings(f,t),'native roles '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim '+t);require(a['entry_boundary_only'] is True and a['full_task_scope_complete'] is False,'scope '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),native_or_game_executed=False)
