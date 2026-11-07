"""Bot/tutorial source links; data presence and callable helpers are not full AI."""
import pathlib,json,hashlib,sys,re
R=pathlib.Path('F:/OpenLeague');V=pathlib.Path('F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision103');sys.path[:0]=[str(R/'tools'),str(R/'tools/project-plan')]
from native_lua import Chunk,initialization
from lua51_reference import Reader,LuaReferenceError
from reference_inibin import read
from rads_reference_membership import RadsReferenceMembership
from frontend_builds import release_manifest,manifest_member
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(v,m):
 if not v:raise ValueError(m)
def pin(p):
 p=pathlib.Path(p).resolve();b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
TARGETS=[f'SYS-12.4-{i:02}' for i in range(1,11)];BOUNDARIES=set(TARGETS)
L='crates/core/src/lib.rs';A='launcher/src-tauri/src/main.rs'
SPECS={TARGETS[0]:[(A,'fn roster() -> Result<serde_json::Value, String> {'),(L,'pub fn join(&mut self, name: &str) -> Result<u32, String> {')],TARGETS[1]:[(L,'Action::Move { point } => {'),('crates/core/src/trundle_e.rs','pub(crate) fn dynamic_path(&self,start:Point,end:Point)')],TARGETS[2]:[(L,'Action::Attack { target } => {'),('crates/core/src/world.rs','pub(crate) fn target_info(&self, id: u32) -> Option<Target> {')],TARGETS[3]:[(L,'Action::Cast { slot, target } => self.cast(id, slot, target)?,'),('crates/core/src/annie_w.rs','pub fn cast_at(&mut self,id:u32,slot:u8,point:Point)->Result<(),String> {')],TARGETS[4]:[(L,'Action::Buy { item } => self.buy_item(id, item)?,'),('crates/core/src/shop.rs','pub fn buy_item(&mut self, id: u32, item_id: u32) -> Result<(), String> {')],TARGETS[5]:[(L,'pub fn advance(&mut self) {'),(L,'pub fn command(&mut self, id: u32, action: Action) -> Result<(), String> {')],TARGETS[6]:[('crates/core/src/interactions.rs','pub(crate) fn advance_interactions(&mut self) {'),(L,'pub enum Action {')],TARGETS[7]:[('crates/core/src/vision.rs','pub fn visible_to(&self, team: u8, target: u32) -> bool {'),('crates/core/src/world.rs','pub(crate) fn target_info(&self, id: u32) -> Option<Target> {')],TARGETS[8]:[('crates/core/src/match_results.rs','pub(crate) fn capture_final_results(&mut self) {'),(A,'fn play(')],TARGETS[9]:[('crates/core/src/audio_loading_screen_packet.rs','pub fn receive('),(A,'fn play(')]}
FINDINGS={
TARGETS[0]:('369 fichiers Bot dat/INIBIN se répartissent sur62 des122 dossiers de champions ;59 possèdent un Bot.dat. Les six constantes AIR de difficulté0..5 et le filtre botEnabled sont présents,mais disponibilités et IntermediateInCustoms dépendent de données/configuration. Le roster local charge les122 champions sans matrice de bots.','Retrouver les payloads régionaux et versions serveur,la matrice champion/difficulté/mode et le producteur effectif. Ni62 dossiers,ni59dat,ni les six constantes ne prouvent les bots activés en EUW.'),
TARGETS[1]:('TaskPushLane contient recherche de sbire allié,suivi et distance à la voie ;IsMinionCloseToLane accepte499.999 mais refuse500 et500.001. Action::Move et dynamic_path consomment aujourd’hui un point explicite,avec navigation testée.','Relier une véritable décision de bot aux voies/spawns et au chemin ;qualifier le montage de TaskPushLane et ses API. Le test de navigation seule ne prouve ni affectation de voie ni maintien de formation.'),
TARGETS[2]:('Les tableaux d’instructions de TaskKillHero,TaskKillMinion et TaskKillTower sont identifiés,avec rayons et helpers de sélection distincts. Le cœur actuel valide la cible fournie par Action::Attack/target_info.','Qualifier les getters natifs,priorités,visibilité,distance et producteurs de sélection ;implémenter/identifier la décision ordinaire de bot. Une cible reçue et validée n’est pas une cible choisie par une IA.'),
TARGETS[3]:('TaskCastSpell.UpdatePriority donne0 sans cible et0.48*MP/MaxMP avec cible ;les profils testés ne sont pas plafonnés. Tick appelle seulement math.random(0,3) puis revient ;aucun lancement. Rust route Cast/CastAt vers les kits implémentés avec refus explicites des autres.','Qualifier le véritable scheduler/producteur de cast par champion,cibles,coûts,cooldowns et annulations. Ne pas prendre ce TaskCastSpell livré pour une IA de sorts fonctionnelle ni remplacer un kit absent par un cast générique.'),
TARGETS[4]:('TaskBuyItem contient une liste cyclique1001,2003,1006,1007,1042,1029 :douze lectures/avances exécutées parcourent deux cycles. BeginTask demande arrêt attaque et état shop. Le consommateur buy_item actuel vérifie boutique,argent,recette et inventaire ;ses gardes sont testés.','Qualifier la sélection d’objets et l’appelant bot effectif ;la liste de ce script ne constitue pas la stratégie historique de tous les champions. La réussite de la boutique seule ne prouve aucune décision d’achat de bot.'),
TARGETS[5]:('TaskRetreat.BeginTask demande arrêt d’attaque puis mouvement au point de regroupement fourni. UpdatePriority garde une fermeture avec historique ;le banc refuse GetPos non fourni. Simulation.advance/command sont les frontières actuelles pour ticks et actions,avec aucune décision de retraite de bot démontrée.','Qualifier les seuils HP/MP,dégâts récents,horloge,sortie de retraite et API natives ;relier la décision au déplacement actuel. La requête de mouvement ne prouve pas le calcul de priorité ni une retraite accomplie.'),
TARGETS[6]:('Le soin en fontaine actuel est exercé pour alliés vivants,sans dépasser les PV max. L’énumération Action examinée ne contient pas de Recall. Le script tutoriel demande un objectif rappel et ses helpers de régénération sont identifiés ;TaskRetreat donne une destination de regroupement.','Retrouver les producteurs de rappel/annulation et la politique de retour de bot ;qualifier les transitions complètes retraite,rappel,soin,retour en voie. Le seul soin en fontaine ne couvre pas ce cycle.'),
TARGETS[7]:('TaskDefendStructure et TaskPushLane contiennent les entrées de réaction aux structures/sbires/alliés ;leur choix de tâche et leurs helpers moteur restent séparés. visible_to et target_info exposent aujourd’hui l’information validée,mais ne prennent pas une décision de coopération.','Qualifier les producteurs d’alerte,priorités d’objectifs,visibilité et changements de rôle ;relier une décision de bot réelle sans information cachée. Les filtres de visibilité seuls ne démontrent aucune coopération.'),
TARGETS[8]:('Le launcher play démarre une session locale depuis un champion/sorts ;capture_final_results produit un résultat immuable. Le test de fin passe après dégâts létaux injectés sur la chaîne de structures,avec six joueurs locaux. Les appels AIR selectBotChampion et restrictions de custom sont identifiés.','Qualifier une partie ordinaire contre des bots jusqu’au résultat,avec leurs commandes autonomes et retour au launcher. Ni six joueurs instanciés,ni dégâts injectés,ni résultat sérialisé ne constituent une recette coop contre IA.'),
TARGETS[9]:('TutorialScript Map12 possède100 prototypes nommés,des phases et appels d’objectif/audio. Six profils de callbacks de tutoriel sont exécutés au travers d’observateurs ;OnTutorialInit est refusé faute de LoadLevelScriptIntoScript fourni. AIR demande createTutorialGame(type0/1) et dépend de BattleTraining.Enabled. Le consommateur Rust Kind::Tutorial lu ici reçoit des données de chargement,il ne joue pas les étapes.','Recenser les scénarios réellement activés,leurs scripts montés,conditions d’entrée/sortie et effets moteur puis qualifier chaque parcours. Ne pas transformer une classe de chargement,un tableau de callbacks ou un signal EndGame en progression de tutoriel complète.')}
AIR_CONDITIONS={
'BotParticipant':['SKILL_LEVEL_EASY:int = 0','SKILL_LEVEL_MEDIUM:int = 1','SKILL_LEVEL_HARD:int = 2','SKILL_LEVEL_UBER:int = 3','SKILL_LEVEL_TUTORIAL:int = 4','SKILL_LEVEL_INTRO:int = 5'],
'Champion':['public function get botEnabled() : Boolean','return this._botEnabled;'],
'TeamSelectionController':['if(_loc2_.botEnabled)','"BotConfigurations","IntermediateInCustoms",false','selectBotChampion(param1.champion,param1','this.isOwner && Boolean(this.masterGameController.gameMap.canAddBotsToMap())'],
'GameServiceImpl':['invokeServiceWithoutSession("gameService","createTutorialGame",[param1]','invokeServiceWithoutSession("gameService","selectBotChampion",[param1.championId,param2]'],
'CreateTutorialGameController':['param1 == false && this.isAdvancedTutorialEnabled()','createTutorialGame(this.isBasicTutorial ? 0 : 1','this.masterGameController.gameModel.tutorialType = GameModel.TUTORIAL_TYPE_BASIC;'],
'BattleTrainingConfig':['NAMESPACE:String = "BattleTraining"','ENABLED:String = "Enabled"','USE_SRU_MAP:String = "UseSRU"','getConfiguration(NAMESPACE,ENABLED,false,null)','getConfiguration(NAMESPACE,USE_SRU_MAP,true,null)']}
def anchor(root,t,i,spec):
 p,n=spec;hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+t+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='bot_tutorial_boundary_'+t.replace('-','_').replace('.','_')+'_'+str(i))
def _collect(root=R):
 root=pathlib.Path(root).resolve();pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 loc=load(root/'docs/project_location.json');keep(root/'docs/project_location.json');check('active_F_root',pathlib.Path(loc['active_root']).resolve()==root);m=RadsReferenceMembership(loc['previous_root'])
 obs=load(V/'native-bot-sources.json');lua=load(V/'bot-lua-observation.json');rust=load(V/'rust-bot-tests.json')
 for name in ['native-bot-sources.json','bot-lua-observation.json','rust-bot-tests.json']:keep(V/name)
 for d in [obs,lua,rust]:check('producer_'+d['producer']['path'],keep(d['producer']['path'])==d['producer']);check('passed_'+d['producer']['path'],d['passed'] is True)
 for d in [obs,lua]:check('python_'+d['producer']['path'],keep(d['python']['path'])==d['python'])
 def native(s,logical):
  check('source_'+logical,keep(s['path'])==s);member=m.inspect(logical,s['path'],s);check('member_'+logical,member['status']=='matches_selected_project_manifest');return member
 def member_equal(a,b):
  a=dict(a,observed=dict(a['observed'],path=str(pathlib.Path(a['observed']['path']).resolve())));b=dict(b,observed=dict(b['observed'],path=str(pathlib.Path(b['observed']['path']).resolve())));return a==b
 reader_cases=[]
 for s in obs['scripts']:
  check('membership_record_'+s['logical'],member_equal(native(s['source'],s['logical']),s['membership']));raw=pathlib.Path(s['source']['path']).read_bytes();c=Chunk(raw);p=c.function();b=Reader(raw).parse();check('complete_parse_'+s['logical'],c.i==len(raw))
  def equal(a,b):return a['code']==b['words'] and a['constants']==b['constants'] and len(a['functions'])==len(b['children']) and all(equal(x,y) for x,y in zip(a['functions'],b['children']))
  check('dual_parse_'+s['logical'],equal(p,b));check('initialization_'+s['logical'],json.loads(json.dumps(initialization(p)))==s['initialization']);check('top_constants_'+s['logical'],p['constants']==s['top_constants']);names={}
  for pc,w in enumerate(p['code'][:-1]):
   n=p['code'][pc+1]
   if w&63==36 and n&63==7 and ((w>>6)&255)==((n>>6)&255) and p['functions'][w>>14]['flags'][0]==0:names[w>>14]=p['constants'][n>>14]
  fs=[dict(index=i,name=names.get(i),lines=f['lines'],flags=f['flags'],constants=f['constants'],words=f['code'],code_sha256=b['children'][i]['code_sha256']) for i,f in enumerate(p['functions'])];check('function_records_'+s['logical'],s['functions']==fs)
  for name,broken in [('truncated',raw[:20]),('trailing',raw+b'\0'),('header',b'bad'+raw[3:])]:
   try:Reader(broken).parse()
   except LuaReferenceError as e:reader_cases.append(dict(source=s['logical'],case=name,expected='refused',observed=str(e)))
   else:raise ValueError('Malformed Lua accepted')
 roster=load(root/'data/4.20/champions.json');check('roster',keep(root/'data/4.20/champions.json')==obs['roster'] and [c['id'] for c in roster]==[c['champion'] for c in obs['kits']] and len(roster)==122)
 dirs={p.name.casefold():p for p in (m.deploy/'DATA/Characters').iterdir() if p.is_dir()};bot_files=0;dat_files=0
 for k in obs['kits']:
  d=dirs[k['champion']];paths=sorted(p for p in d.rglob('*') if p.is_file() and p.suffix.lower() in ['.dat','.inibin'] and 'bot' in p.name.lower());check('kit_census_'+k['champion'],[str(p.resolve()) for p in paths]==[x['source']['path'] for x in k['files']] and k['historical_bot_availability_proven'] is False)
  for p,row in zip(paths,k['files']):
   bot_files+=1;logical=p.relative_to(m.deploy).as_posix();check('kit_membership_'+logical,member_equal(native(row['source'],logical),row['membership']))
   if p.suffix.lower()=='.dat':
    dat_files+=1;text=p.read_text(encoding='utf8');content=dict(kind='text_config_lexical_not_native_parser',noncomment_lines=[dict(line=i+1,text=l) for i,l in enumerate(text.splitlines()) if l.strip() and not l.lstrip().startswith(('#',';'))])
   else:content=dict(kind='decoded_inibin',values=read(p))
   check('kit_content_'+logical,row['content']==content)
 check('bot_file_counts',bot_files==369 and dat_files==59 and sum(bool(k['files']) for k in obs['kits'])==62)
 for search in obs['current_searches']:
  scope=root/search['scope'];files=sorted(p for p in scope.rglob('*') if p.is_file() and p.suffix in search['extensions']);hits=[]
  for p in files:
   text=p.read_text(encoding='utf-8-sig');matches=[dict(line=i+1,text=l.strip()) for i,l in enumerate(text.splitlines()) if re.search(r'\b(bot|bots|tutorial|tutorials)\b',l,re.I)]
   if matches:hits.append(dict(path=p.relative_to(root).as_posix(),source=keep(p),matches=matches))
  check('bounded_current_search_'+search['scope'],search['files_scanned']==len(files) and search['hits']==hits and search['absence_of_all_possible_implementations_proven'] is False)
 routespath=root/'docs/reference_air_routes_4_20.json';routes=load(routespath);keep(routespath);mp=root/'docs/reference_frontend_sources/air_0.0.1.119.releasemanifest';keep(mp);manifest=release_manifest(mp,'lol_air_client','0.0.1.119');air=[]
 for name,needles in AIR_CONDITIONS.items():
  rows=[x for x in routes['review_sources'] if (x['analysis'].get('class') or '').split('.')[-1]==name];check('one_export_'+name,len(rows)==1);row=rows[0];raw=next(x for x in routes['original_sources'] if x['path']==row['input']);review=keep(root/'docs/reference_air_sources'/row['path']);binary=keep(root/'docs/reference_air_sources/original'/row['input']);check('export_hash_'+name,all(review[k]==row[k] for k in ['bytes','sha256']));check('library_hash_'+name,all(binary[k]==raw[k] for k in ['bytes','sha256']));member=manifest_member(manifest,row['input'],binary['path'],raw['manifest_entry']['release']);check('library_member_'+name,member['bytes']==binary['bytes']);text=pathlib.Path(review['path']).read_text(encoding='utf8');branches=[]
  for needle in needles:
   lines=[i+1 for i,l in enumerate(text.splitlines()) if needle in l];check('air_branch_'+name+'_'+needle,bool(lines));branches.append(dict(needle=needle,lines=lines))
  air.append(dict(class_name=name,review=review,binary=binary,member=member,branches=branches,export_reexecuted=False,server_payload_recovered=False))
 for k in ['lua_module','adapter_source']:check('lua_'+k,keep(lua[k]['path'])==lua[k])
 check('lua_scope',lua['case_count']==len(lua['cases'])==49 and lua['engine_apis_are_adapters'] and lua['symbolic_state_and_order_enums'] and all(lua[k] is False for k in ['script_selection_by_engine_proven','complete_bot_decision_loop_qualified','native_timer_scheduler_executed','tutorial_progression_qualified','game_process_executed']))
 for x in lua['native_identities']:check('lua_identity_'+x['name'],x['source'] in [s['source'] for s in obs['scripts']] and x['raw32_roundtrip_exact'] and x['instruction_arrays_preserved'])
 for i,c in enumerate(lua['cases']):check('lua_case_'+str(i),c['expected']==c['observed'])
 check('unprovided_API_refusals',len(lua['adapter_refusals'])==2 and all(not x['native_engine_api_absence_proven'] for x in lua['adapter_refusals']) and 'GetPos' in lua['adapter_refusals'][0]['observed'] and 'LoadLevelScriptIntoScript' in lua['adapter_refusals'][1]['observed'])
 for s in rust['sources']:check('rust_source_'+s['path'],keep(s['path'])==s)
 for c in rust['cases']:
  for k in ['binary','log']:check('rust_identity_'+c['name']+'_'+k,keep(c[k]['path'])==c[k])
  check('rust_case_'+c['name'],c['exit_code']==0 and c['tests_passed']==1 and c['tests_failed']==0 and '1 passed; 0 failed' in pathlib.Path(c['log']['path']).read_text(encoding='utf8') and '--exact' in c['command'])
 check('seven_foundation_tests',rust['case_count']==len(rust['cases'])==7 and 'No champion bot decision loop or tutorial progression executed' in rust['scope'])
 lib=(root/L).read_text(encoding='utf8');action=lib.split('pub enum Action {',1)[1].split('\n}',1)[0];check('action_has_no_Recall_variant','Recall' not in action)
 tutorial=next(s for s in obs['scripts'] if 'TutorialScript' in s['logical']);check('tutorial_prototype_count',len(tutorial['functions'])==100 and all(f['name'] is not None for f in tutorial['functions']))
 cast=next(s for s in obs['scripts'] if s['logical'].endswith('/TaskCastSpell.luaobj'));tick=next(f for f in cast['functions'] if f['name']=='Tick');check('cast_tick_only_random',tick['constants']==['math','random',0,3] and len(tick['words'])==7)
 for t in TARGETS:
  for i,n in enumerate(SPECS[t]):checks.append('anchor_'+anchor(root,t,i,n)['role'])
 for s in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[x['identity'] for x in m.manifests],*m.provenance]:keep(s['path'])
 for p in sorted({s[0] for specs in SPECS.values() for s in specs}):keep(root/p)
 for p in ['crates/server/src/main.rs','tools/native_lua.py','tools/project-plan/lua51_reference.py','tools/project-plan/reference_inibin.py','tools/project-plan/rads_reference_membership.py','tools/project-plan/frontend_builds.py','docs/reference_client_4_20.json']:keep(root/p)
 for p in ['prepare_context.py','phase-and-package-context.json','native-inspection.log','lua-probe.log','rust-run.log']:keep(V/p)
 facts=dict(sources=obs,lua=lua,rust=rust,air=air,reader_refusals=reader_cases,bot_config_counts=dict(files=bot_files,dat_files=dat_files,champions_with_files=62,roster_searched=122),current_action_excerpt=action,policies=dict(historical_bot_roster_qualified=False,historical_difficulties_available_qualified=False,script_selection_qualified=False,complete_native_bot_loop_qualified=False,ordinary_coop_match_qualified=False,tutorial_scenarios_complete=False,timer_scheduler_qualified=False,full_task_scope_complete=False,original_game_executed=False),source_checks=checks)
 return json.loads(json.dumps(facts)),list(pins.values())
_CACHE={}
def collect(root=R):
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=_collect(root)
 else:
  for s in _CACHE[key][1]:require(pin(s['path'])==s,'source changed '+s['path'])
 return _CACHE[key]
def bindings(f,t):
 index=TARGETS.index(t);by={pathlib.Path(s['logical']).stem:s for s in f['sources']['scripts']};names=[['Bot'],['TaskPushLane'],['TaskKillHero','TaskKillMinion','TaskKillTower'],['TaskCastSpell'],['TaskBuyItem'],['TaskRetreat'],['TaskRetreat','TutorialScript'],['TaskDefendStructure','TaskPushLane'],['Bot','TutorialScript'],['TutorialScript']][index]
 out=[dict(path=by[n]['source']['path'],role='native_bot_or_tutorial_source_with_mounting_and_engine_limits',selector=n+';prototype/instruction records and bounded observations in receipt') for n in names]
 if index in [0,8,9]:
  chosen=['BotParticipant','Champion','TeamSelectionController'] if index==0 else ['TeamSelectionController','GameServiceImpl'] if index==8 else ['CreateTutorialGameController','BattleTrainingConfig','GameServiceImpl']
  out.extend(dict(path=a['binary']['path'],role='native_AIR_bot_or_tutorial_request_not_historical_server_payload',selector=a['class_name']+';export='+a['review']['path']) for a in f['air'] if a['class_name'] in chosen)
 return out
def audit(q,root='F:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no bypass');require(q['schema']=='openleague_bot_tutorial_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source identities changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require([x['task_id'] for x in q['associations']]==TARGETS,'task census');um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,n) for i,n in enumerate(SPECS[t])],'anchors '+t);require(a['native_bindings']==bindings(f,t),'native roles '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim '+t);require(a['entry_boundary_only']==(t in BOUNDARIES) and a['full_task_scope_complete'] is False,'scope '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),original_lua_cases=49,rust_foundation_tests=7,original_game_executed=False)
