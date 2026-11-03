"""Event-mode source trace; presence, routing and historical activation stay distinct."""
import hashlib,json,pathlib,re,sys
R=pathlib.Path('F:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from rads_reference_membership import identity as pin
from frontend_builds import release_manifest,manifest_member
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(ok,message):
 if not ok:raise ValueError(message)
TARGETS=[f'SYS-11.4-{i:02}' for i in range(1,7)];BOUNDARIES=set(TARGETS)
LOCAL=['launcher/src-tauri/src/main.rs','tools/project-plan/reference_client.py','tools/project-plan/local_services_reference.py','tools/project-plan/fidelity_ids.py','tools/project-plan/store.py','crates/core/src/shop.rs','launcher/src-tauri/src/sessions.rs','crates/core/src/match_results.rs']
SPECS={TARGETS[0]:[(0,'fn roster() -> Result<serde_json::Value, String> {'),(1,'def validate(document,source_root=None,verify_native=False):')],TARGETS[1]:[(1,'def validate(document,source_root=None,verify_native=False):'),(2,'def assess(doc,family_id,*,original_service=False,real_money=False,external=False):')],TARGETS[2]:[(3,'def canonical_task_key(task):'),(4,'    def task(self,ident):')],TARGETS[3]:[(3,'def canonical_task_key(task):'),(4,'    def copy_text(self,kind,ident):')],TARGETS[4]:[(0,'fn play('),(5,'pub fn map10_available(item_id: u32) -> Option<bool> {')],TARGETS[5]:[(6,'pub fn resume(&self)->Result<String,String>{'),(6,'pub fn abandon(&self)->Result<String,String>{'),(7,'pub(crate) fn capture_final_results(&mut self) {')]}
FINDINGS={
TARGETS[0]:('AirGeneratedContent.swf récupéré correspond au manifeste AIR119 et déclare neuf candidats. La factory possède neuf clés différentes : sr6 seulement généré,ppp seulement dans la factory. GeneratedContentLoader et addFeaturedVariants relient ces deux sources. Le roster courant et le lecteur de date restent des frontières ; aucune annonce datée primaire EUW adoptée.','Recenser les annonces primaires datées et leurs régions,relier les événements réellement actifs aux configurations ; conserver les deux ensembles de candidats distincts et ne pas prendre une date de build pour une activation.'),
TARGETS[1]:('FeaturedGameFlowVariant.isEnabled lit EnabledMutators ou EnabledModes via MutatorsConfiguration,avec défautfalse. La liste effective doit être fournie par DynamicClientConfigManager ; le SWF généré ne remplace pas ce payload. Les consommateurs locaux de date/service définissent des limites et ne qualifient aucun événement actif.','Établir une décision datée par candidat avec payload/annonce régionale ; garder chacune des activations inconnue tant que cette preuve manque. Un mode absent de la factory ne suffit pas à prouver son absence globale.'),
TARGETS[2]:('Les variantes définissent des paramètres client de custom : sélection,carte et parfois taille. Les stratégies serveur restent distinctes. canonical_task_key et Store.task sont les consommateurs actuels de définition et lecture des fiches ; aucune nouvelle tâche événement confirmée créée par ce lot.','Après confirmation des événements retenus,créer des fiches précises de règles avec identités stables,conditions,refus et consommateurs ; ne pas créer un périmètre confirmé depuis les seuls candidats AIR.'),
TARGETS[3]:('Le catalogue récupéré et les paramètres des variantes donnent des clés et contextes de ressources. Les titres/icônes/ressources sont référencés,mais pas un inventaire complet du mode. canonical_task_key et Store.copy_text sont des frontières du plan courant.','Recenser chaque ressource native du mode confirmé avec provenance,puis créer ses fiches précises ;une classe ou une clé ne prouve pas toutes les ressources ni leurs animations. Aucun jeu de fiches complet créé ici.'),
TARGETS[4]:('Les overrides AIR concernent surtout picks,cartes et tailles de parties custom ;ils ne constituent pas une liste de restrictions de champions/objets. Le launcher actuel valide le catalogue global et les sorts ;map10_available applique une disponibilité Map10.','Retrouver restrictions effectives des événements confirmés,exceptions et versions serveur ;relier les consommateurs locaux par événement. Ne pas appliquer implicitement la disponibilité Map10 à tous les modes.'),
TARGETS[5]:('QuitPracticeGameAction attend le succès de quitGame avant nettoyage et retour au flux de partie custom ;sur erreur il expose une erreur. MasterGameController distingue GAME_OVER et le contrôleur de résultats. Le superviseur local possède resume/abandon,avec gardes des processus et sessions détenues ;ces chemins ne sont pas des recettes événementielles.','Qualifier fin normale,abandon,erreur,reconnexion et retour au client pour chaque événement retenu avec preuves locales ordinaires ;conserver les restrictions du superviseur et ne pas assimiler une commande envoyée à un retour réussi.')}
CLASSES=['GameFlowVariantFactory','FeaturedGameFlowVariant','MutatorsConfiguration','GeneratedContentLoader','FeaturedGameDefinition','UrfGameFlowVariant','PPPGameFlowVariant','HexakillGameFlowVariant','AscensionGameFlowVariant','NightmareBotsGameFlowVariant','OneForAllGameFlowVariant','OneForAllXGameFlowVariant','FirstBloodGameFlowVariant','QuitPracticeGameAction','MasterGameController','GameMap','GameTypeConfig']
CONDITIONS={
'GameFlowVariantFactory':['GeneratedContentLoader.instance.featuredGameDefinitions','this.gameKeys[_loc2_.key] as FeaturedGameFlowVariant','_loc2_.gameMutators[0]','this.variants[_loc3_.key] = _loc3_;','return this.INVARIANT;'],
'FeaturedGameFlowVariant':['MutatorsConfiguration.ENABLED_MUTATORS,this._identifyingGameMutator','MutatorsConfiguration.ENABLED_MODES,this._identifyingGameMode','_loc1_.gameMode = this._identifyingGameMode;','_loc1_.gameMutators = [this._identifyingGameMutator];','new PracticeGameParameters(this._gameKey)'],
'MutatorsConfiguration':['DynamicClientConfigManager.getConfiguration(MutatorsConfiguration.NAMESPACE,param1,false)','_loc3_.getValue() is String','_loc4_ = parseJsonStringArray','return false;','catch(error:Error)'],
'GeneratedContentLoader':['/assets/swfs/AirGeneratedContent.swf','domain.FeaturedGameGeneratedData','this.loadFeaturedGameData(_loc13_.featuredGames);','_loc4_.key = _loc3_.key;','_loc4_.gameMode = _loc3_.gameMode;','_loc4_.gameMutators = _loc3_.gameMutators;'],
'FeaturedGameDefinition':['gameMutators:Array','gameMode:String','key:String'],
'UrfGameFlowVariant':['GameTypeConfig.PICK_ID_SIM_BAN_SHORT_TIMER'],
'PPPGameFlowVariant':['GameTypeConfig.PICK_ID_SIM_BAN_SHORT_TIMER','GameMap.HOWLING_ABYSS'],
'HexakillGameFlowVariant':['overriddenMaxTeamSize = 6','_gameKey == "sr6"','_gameKey = "tt6"','GameMap.SUMMONERS_RIFT_ID','GameMap.TWISTED_TREELINE_ID'],
'AscensionGameFlowVariant':['GameTypeConfig.PICK_ID_SIM_BAN_SHORT_TIMER','GameMap.CRYSTAL_SCAR_ID','overriddenMaxTeamSize = 5'],
'NightmareBotsGameFlowVariant':['NIGHTMARE_BOTS_1:String = "NightmareBots1"','NIGHTMARE_BOTS_2:String = "NightmareBots2"','NIGHTMARE_BOTS_3:String = "NightmareBots3"','param1.botPlayer'],
'OneForAllGameFlowVariant':['GameTypeConfig.PICK_ID_ONE_TEAM_VOTE_DRAFT'],
'OneForAllXGameFlowVariant':['GameTypeConfig.PICK_ID_ALL_TEAM_VOTE_PICK','function supportsBattleBoost()'],
'FirstBloodGameFlowVariant':['GameTypeConfig.PICK_ID_SIM_BAN','GameMap.HOWLING_ABYSS','overriddenMaxTeamSize = 2'],
'QuitPracticeGameAction':['quitGame(this.onQuitGameSuccess,null,this.onServiceRequestError)','this._masterGameController.cleanupAfterGameCompleteOrAborted();','this._masterGameController.startPracticeGameFlowAtJoinGame();','err(new Error(param1.exception));'],
'MasterGameController':['case GameViewState.GAME_OVER:','this.activeSubsidiaryController = this.endOfGameStatsController;','public function cleanupAfterGameCompleteOrAborted()'],
'GameMap':['SUMMONERS_RIFT_ID:int = 1','TWISTED_TREELINE_ID:int = 10','CRYSTAL_SCAR_ID:int = 8','HOWLING_ABYSS:int = 12'],
'GameTypeConfig':['PICK_ID_SIM_BAN_SHORT_TIMER:int = 16','PICK_ID_ONE_TEAM_VOTE_DRAFT:int = 14','PICK_ID_ALL_TEAM_VOTE_PICK:int = 15']}
def anchor(root,tid,i,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+tid+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='event_modes_boundary_'+tid.replace('-','_').replace('.','_')+'_'+str(i))
def _collect(root=R):
 root=pathlib.Path(root).resolve();pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 location=load(root/'docs/project_location.json');keep(root/'docs/project_location.json');check('active_F_root',pathlib.Path(location['active_root']).resolve()==root)
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

 d=root/'docs/reference_event_modes_sources';swf=keep(d/'AirGeneratedContent.swf');export=keep(d/'FeaturedGameGeneratedData.as');recovery=load(d/'recovery.json');dec=load(d/'decompilation.json');index=load(d/'archive-index.json');web=load(d/'web-search-notes.json')
 for name in ['recovery.json','decompilation.json','archive-index.json','web-search-notes.json']:keep(d/name)
 member=manifest_member(manifest,'assets/swfs/AirGeneratedContent.swf',swf['path'],'0.0.1.119');check('generated_manifest_member',member['bytes']==63377)
 record=index['AirGeneratedContent.swf'];check('exact_archive_entry',record['entry']['path']=='live/projects/lol_air_client/releases/0.0.1.119/files/assets/swfs/AirGeneratedContent.swf' and record['entry']['fileId']=='2A6420560EC49057' and record['entry']['size']==63377)
 check('recovery_identity',len(recovery['files'])==1 and all(recovery['files'][0][k]==swf[k] for k in ['bytes','sha256']) and recovery['files'][0]['archive_record']==record)
 check('decompiler_success_and_identity',dec['exit_code']==0 and len(dec['outputs'])==1 and all(dec['input'][k]==swf[k] and dec['outputs'][0][k]==export[k] for k in ['bytes','sha256']) and dec['native_AIR_executed'] is False)
 for s in [dec['java'],*dec['tool_jars']]:check('tool_identity_'+s['path'],keep(s['path'])==s)
 text=pathlib.Path(export['path']).read_text(encoding='utf8');rows=[]
 pattern=r'featuredGames\["([^" ]+)"\] = createFeaturedGame\("([^" ]+)",(null|"[^" ]+"),(null|\["[^" ]+"\])\);'
 for key,arg,mode,mut in re.findall(pattern,text):
  check('generated_key_'+key,key==arg);rows.append(dict(key=key,game_mode=json.loads(mode),game_mutators=json.loads(mut)))
 expected={'asc':('ASCENSION',None),'fbl':('FIRSTBLOOD',None),'nbots':(None,['NightmareBots']),'ofa':(None,['OneForAll']),'ofax':(None,['OneForAllX']),'sr6':(None,['6v6']),'tagteam':(None,['TagTeam']),'tt6':(None,['6v6']),'urf':(None,['URF'])}
 check('generated_catalogue_exact',len(rows)==9 and {x['key']:(x['game_mode'],x['game_mutators']) for x in rows}==expected)
 factory=dict(re.findall(r'this.gameKeys\["([^" ]+)"\] = new (\w+)\(\);',texts['GameFlowVariantFactory']))
 check('factory_exact',set(factory)=={'asc','fbl','nbots','ofa','ofax','ppp','tt6','tagteam','urf'})
 generated=set(expected);difference=dict(generated_without_factory=sorted(generated-set(factory)),factory_without_generated=sorted(set(factory)-generated));check('two_sets_not_conflated',difference==dict(generated_without_factory=['sr6'],factory_without_generated=['ppp']))
 candidates=[dict(key=k,generated_definition=next((x for x in rows if x['key']==k),None),factory_class=factory.get(k),historical_EUW_activation='unknown',effective_policy_qualified=False) for k in sorted(generated|set(factory))]
 check('ten_union_candidates',len(candidates)==10);check('no_primary_date_adopted',web['historical_activation_established'] is False)
 for p in LOCAL+['tools/project-plan/frontend_builds.py','tools/project-plan/rads_reference_membership.py','docs/reference_client_4_20.json','docs/reference_local_services_4_20.json']:keep(root/p)
 localchecks={LOCAL[0]:['Champion inconnu','state.play(&root, &champion, &summoner_json)'],LOCAL[5]:['map10_available(item_id)','item map availability not qualified'],LOCAL[6]:['if state.joined.is_some()','if !run.can_abandon()','run.drain();','if !run.can_resume()'],LOCAL[7]:['gold_remaining','self.final_result.is_some()']}
 for p,needles in localchecks.items():
  t=(root/p).read_text(encoding='utf8')
  for i,n in enumerate(needles):check('current_branch_'+p+'_'+str(i),n in t)
 for t in TARGETS:
  for i,s in enumerate(SPECS[t]):checks.append('anchor_'+anchor(root,t,i,s)['role'])
 facts=dict(air=air,air_branches=branches,generated=dict(source=swf,export=export,manifest_member=member,recovery=recovery,decompilation=dec,rows=rows,executed=False),factory=factory,catalogue_differences=difference,candidates=candidates,web_research=web,policies=dict(historical_EUW_payload_recovered=False,confirmed_events=[],event_tasks_created=False,event_restrictions_qualified=False,event_resources_complete=False,event_end_to_end_return_qualified=False,native_or_game_executed=False),source_checks=checks)
 return json.loads(json.dumps(facts)),list(pins.values())
_CACHE={}
def collect(root=R):
 key=str(pathlib.Path(root).resolve())
 if key not in _CACHE:_CACHE[key]=_collect(root)
 else:
  for p in _CACHE[key][1]:require(pin(p['path'])==p,'changed source '+p['path'])
 return _CACHE[key]
def bindings(f,tid):
 names={TARGETS[0]:['GameFlowVariantFactory','GeneratedContentLoader','FeaturedGameDefinition'],TARGETS[1]:['FeaturedGameFlowVariant','MutatorsConfiguration','GameFlowVariantFactory'],TARGETS[2]:['FeaturedGameFlowVariant','UrfGameFlowVariant','HexakillGameFlowVariant','AscensionGameFlowVariant','OneForAllGameFlowVariant','OneForAllXGameFlowVariant','FirstBloodGameFlowVariant'],TARGETS[3]:['GeneratedContentLoader','FeaturedGameDefinition','NightmareBotsGameFlowVariant'],TARGETS[4]:['FeaturedGameFlowVariant','GameTypeConfig','GameMap','HexakillGameFlowVariant','PPPGameFlowVariant'],TARGETS[5]:['QuitPracticeGameAction','MasterGameController','FeaturedGameFlowVariant']}[tid]
 rows=[dict(path=a['binary']['path'],role='native_AIR_event_source_not_regional_activation',selector=a['class_name']+';export='+a['review']['path']+';static branch only') for a in f['air'] if a['class_name'] in names]
 if tid!=TARGETS[5]:rows.append(dict(path=f['generated']['source']['path'],role='native_generated_event_candidates_not_activation',selector='FeaturedGameGeneratedData.fillFeaturedGameData;9 exact declarations;sr6 unbound in factory,ppp not generated;10 union candidates not10 active modes'))
 return rows
def audit(q,root='F:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no bypass');require(q['schema']=='openleague_event_modes_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source identities changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require([a['task_id'] for a in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchors '+t);require(a['native_bindings']==bindings(f,t),'native roles '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim '+t);require(a['entry_boundary_only'] is True and a['full_task_scope_complete'] is False,'scope '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),native_or_game_executed=False)
