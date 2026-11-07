"""Map availability source links. Client capabilities do not establish EUW availability."""
import copy,json,pathlib,re,sys
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from audit_navigation_reference import pin,load,require
from frontend_builds import release_manifest,manifest_member
from local_services_reference import rpc_surface,assess,ScopeError
from reference_client import validate,ReferenceError
from rads_reference_membership import RadsReferenceMembership
TARGETS=[f'SYS-11.1-{i:02}' for i in range(1,7)]
BOUNDARIES=set(TARGETS)
LOCAL=['tools/project-plan/reference_client.py','tools/project-plan/local_services_reference.py','crates/server/src/main.rs']
SPECS={t:[(0,'def validate(document,source_root=None,verify_native=False):'),(1,'def assess(doc,family_id,*,original_service=False,real_money=False,external=False):'),(2,'game.enable_map10().map_err(std::io::Error::other)?;')] for t in TARGETS}
FINDINGS={
 TARGETS[0]:('GameMap distingue Map1 et Map11 ; leurs LevelScript sont présents dans la release sélectionnée. PlatformConfigController reçoit les cartes activées ou demande getGameMapList. Le lecteur courant refuse de transformer la date du build en déploiement ; le serveur courant initialise Map10.','Retrouver la décision régionale datée de maintien/remplacement de Map1 et son payload effectif ; ni deux ressources présentes ni la date du PE ne donnent cette décision.'),
 TARGETS[1]:('SUMMONERS_RIFT_UPDATE_SHIPPING vaut11 et son LevelScript est lié au manifeste. La disponibilité provient du message système ou de gameMapService, pas du nom SHIPPING. Les consommateurs locaux identifiés sont des frontières de date/service et le démarrage Map10.','Qualifier la date de déploiement Map11 EUW avec source primaire datée et contexte de file ; distinguer publication, build et activation. Aucun calendrier établi par ce lot.'),
 TARGETS[2]:('CRYSTAL_SCAR_ID vaut8 et GameMode.DOMINION vaut ODIN. GameQueueManager reçoit getAvailableQueues, stocke allGameQueues et filtre selon le type ; une erreur vide cette liste. Ces chemins ne fournissent pas le payload EUW historique.','Relier les files Dominion réellement actives, leurs identifiants, leurs règles et leur période EUW à des réponses ou archives primaires datées ; garder le service local de périmètre distinct de son implémentation.'),
 TARGETS[3]:('HOWLING_ABYSS vaut12 et GameMode.ARAM vaut ARAM ; le LevelScript Map12 est identifié. GameQueueConfig porte supportedMapIds et gameMutators ; le contrôleur combine les cartes générées avec les DTO activés reçus.','Établir disponibilité ARAM et contraintes des files à la date EUW retenue ; constantes, DTO et scripts de carte ne prouvent pas une file ouverte ni sa date.'),
 TARGETS[4]:('CreateTutorialGameController choisit basic/advanced et appelle createTutorialGame avec0 ou1. Advanced dépend de BattleTraining.Enabled ; GameDTO renvoyé devient currentGame. BattleTraining.UseSRU a un défauttrue, distinct du payload dynamique effectif.','Identifier cartes/scénarios réellement renvoyés pour chaque tutoriel, configuration dynamique et exposition EUW ; ne pas déduire une carte de0/1 ni confondre les défauts client avec activation serveur.'),
 TARGETS[5]:('PracticeGameConfig porte carte, mode, mutateurs, région et gameTypeConfig ; PlatformConfigController consomme practiceGameEnabled et practiceGameTypeConfigIdList. PRE_SEASON_SANDBOX90 est une constante distincte ; aucun Practice Tool moderne n’est qualifié.','Établir les variantes entraînement/custom réellement exposées et leurs configurations4.20 ; relier leurs scénarios et restrictions. Le lancement localMap10 et la définition du service ne les implémentent pas.')
}
CLASSES=['GameMap','GameMode','GameQueueConfig','PracticeGameConfig','GameMapServiceImpl','MatchMakerServiceImpl','GameServiceImpl','PlatformConfigController','GameQueueManager','CreateTutorialGameController','BattleTrainingConfig','ClientSystemStatesNotification','GameMapEnabledDTO']

def anchor(root,tid,i,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+tid+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='map_availability_boundary_'+tid.replace('-','_').replace('.','_')+'_'+str(i))

def _collect(root=R):
 root=pathlib.Path(root);pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 routespath=root/'docs/reference_air_routes_4_20.json';routes=load(routespath);keep(routespath)
 manifestpath=root/'docs/reference_frontend_sources/air_0.0.1.119.releasemanifest';keep(manifestpath);manifest=release_manifest(manifestpath,'lol_air_client','0.0.1.119')
 air=[];texts={}
 for name in CLASSES:
  rows=[x for x in routes['review_sources'] if (x['analysis'].get('class') or '').split('.')[-1]==name];check('one_export_'+name,len(rows)==1);row=rows[0];raw=next(x for x in routes['original_sources'] if x['path']==row['input'])
  review=keep(root/'docs/reference_air_sources'/row['path']);binary=keep(root/'docs/reference_air_sources/original'/row['input'])
  check('review_identity_'+name,all(review[k]==row[k] for k in ['bytes','sha256']));check('library_identity_'+name,all(binary[k]==raw[k] for k in ['bytes','sha256']))
  member=manifest_member(manifest,row['input'],binary['path'],raw['manifest_entry']['release']);check('library_membership_'+name,member['bytes']==binary['bytes'])
  text=pathlib.Path(review['path']).read_text(encoding='utf8');texts[name]=text
  air.append(dict(class_name=name,review=review,binary=binary,member=member,rpc_calls=rpc_surface(text),fresh_export_executed=False,dated_server_payload_recovered=False))
 maps={n:int(v) for n,v in re.findall(r'public static const (\w+):int = (\d+);',texts['GameMap'])}
 expected={'SUMMONERS_RIFT_ID':1,'SUMMONERS_RIFT_AUTUMN_ID':2,'PROVING_GROUNDS_ID':3,'TWISTED_TREELINE_OLD_ID':4,'SUMMONERS_RIFT_WINTER_ID':6,'PROVING_GROUNDS_ARAM_ID':7,'CRYSTAL_SCAR_ID':8,'TWISTED_TREELINE_ID':10,'SUMMONERS_RIFT_UPDATE_SHIPPING':11,'HOWLING_ABYSS':12,'SUMMONERS_RIFT_UPDATE_WIP':13,'PRE_SEASON_SANDBOX':90}
 check('map_constants',maps==expected)
 modes=dict(re.findall(r'public static const (\w+):String = "([^\"]+)";',texts['GameMode']))
 check('mode_constants',all(modes.get(k)==v for k,v in dict(DOMINION='ODIN',ARAM='ARAM',TUTORIAL='TUTORIAL',CLASSIC='CLASSIC').items()))
 conditions={
 'PlatformConfigController':['param1.gameMapEnabledDTOList','getGameMapList(this.onGameMapsRetrieved,null,null)','param1.enabledQueueIdsList','param1.practiceGameEnabled','param1.advancedTutorialEnabled','param1.practiceGameTypeConfigIdList','GameTypeConfigManager.instance.setPracticeGameConfigs','if(param1.length == 0 || param1[0] is GameMap)','GeneratedContentLoader.instance.mapData','_loc3_.mapId == _loc5_.gameMapId','_loc3_.minCustomPlayers = _loc5_.minPlayers;','AppConfig.instance.availableMaps = _loc2_;'],
 'GameQueueManager':['matchMakerService.getAvailableQueues(this.onRetrieveGameQueuesSuccess,null,this.onRetrieveGameQueuesFailed)','this.platformConfig.allGameQueues = param1.result as ArrayCollection;','this.platformConfig.allGameQueues = new ArrayCollection();','case GameType.NORMAL_GAME:','_loc3_.type == QueueType.NORMAL','_loc3_.ranked == true && _loc3_.minimumParticipantListSize == 1','case GameType.COOP_VS_AI:','_loc3_.type == QueueType.BOT'],
 'GameQueueConfig':['supportedMapIds','gameMutators','gameTypeConfigId','numPlayersPerTeam','minimumParticipantListSize','maximumParticipantListSize'],
 'CreateTutorialGameController':['if(param1 == false && this.isAdvancedTutorialEnabled())','GameModel.TUTORIAL_TYPE_ADVANCED','GameModel.TUTORIAL_TYPE_BASIC','BattleTrainingConfig.getEnabledConfig().getBoolean()','createTutorialGame(this.isBasicTutorial ? 0 : 1','this.masterGameController.currentGame = param1.result as GameDTO;'],
 'BattleTrainingConfig':['NAMESPACE:String = "BattleTraining"','ENABLED:String = "Enabled"','USE_SRU_MAP:String = "UseSRU"','getConfiguration(NAMESPACE,ENABLED,false,null)','getConfiguration(NAMESPACE,USE_SRU_MAP,true,null)'],
 'PracticeGameConfig':['gameMap:GameMap','gameMutators:ArrayCollection','region:String','gameTypeConfig:int','gameMode:String'],
 'GameMapEnabledDTO':['gameMapId','minPlayers'],
 'ClientSystemStatesNotification':['gameMapEnabledDTOList','enabledQueueIdsList','practiceGameTypeConfigIdList','advancedTutorialEnabled']}
 branch_evidence=[]
 for name,needles in conditions.items():
  text=texts[name]
  for i,n in enumerate(needles):
   hits=[j+1 for j,l in enumerate(text.splitlines()) if n in l];check('branch_'+name+'_'+str(i),bool(hits));branch_evidence.append(dict(class_name=name,needle=n,lines=hits))
 for name,ops in [('GameMapServiceImpl',{'getGameMapList','getGameMapSet'}),('MatchMakerServiceImpl',{'getAvailableQueues'}),('GameServiceImpl',{'createTutorialGame','createPracticeGame'})]:
  a=next(a for a in air if a['class_name']==name);check('rpc_'+name,ops<=set(x.get('operation') for x in a['rpc_calls']))
 m=RadsReferenceMembership(root)
 for s in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[z['identity'] for z in m.manifests],*m.provenance]:keep(s['path'])
 levels=[]
 for name in ['Map1','map11','Map8','Map12']:
  logical=f'LEVELS/{name}/Scripts/LevelScript.luaobj';s=keep(m.deploy/logical);member=m.inspect(logical,s['path'],s);check('selected_level_'+name,member['status']=='matches_selected_project_manifest');levels.append(dict(map_directory=name,source=s,membership=member,executed=False,availability_proven=False))
 ref=load(root/'docs/reference_client_4_20.json');validate(ref,verify_native=True)
 for s in ref['sources']:keep(pathlib.Path(ref['source_root'])/s['path'])
 check('reference_date_only',ref['reference']['date_kind']=='embedded_client_build_date' and ref['regional_patch_deployment_date'] is None)
 refusals=[]
 for field in ['timezone','deployment']:
  x=copy.deepcopy(ref)
  if field=='timezone':x['client']['build_timezone']='UTC'
  else:x['regional_patch_deployment_date']='2014-11-17'
  try:validate(x)
  except ReferenceError as e:refusals.append(dict(case=field,expected='refused',observed=str(e)));checks.append('reference_refuses_'+field)
  else:raise ValueError('invented date accepted')
 scope=load(root/'docs/reference_local_services_4_20.json');service=assess(scope,'queues');outside=assess(scope,'queues',original_service=True)
 check('local_scope_not_runtime',service['implemented'] is False and service['runtime_call_executed'] is False);check('Riot_service_outside_scope',outside['decision']=='outside_local_replacement_contract')
 try:assess(scope,'missing_map_availability_family')
 except ScopeError as e:refusals.append(dict(case='unknown_service',expected='refused',observed=str(e)));checks.append('unknown_service_refused')
 else:raise ValueError('unknown service accepted')
 server=(root/LOCAL[2]).read_text(encoding='utf8');check('current_bootstrap_Map10','game.enable_map10().map_err(std::io::Error::other)?;' in server and 'game.enable_map10_cast_ground().map_err(std::io::Error::other)?;' in server)
 for p in LOCAL+['docs/reference_client_4_20.json','docs/reference_local_services_4_20.json','tools/project-plan/frontend_builds.py','tools/project-plan/air_reference.py','tools/project-plan/rads_reference_membership.py','tools/project-plan/audit_navigation_reference.py']:keep(root/p)
 for t in TARGETS:
  for i,s in enumerate(SPECS[t]):checks.append('anchor_'+anchor(root,t,i,s)['role'])
 facts=dict(air=air,map_constants=maps,mode_constants=modes,branches=branch_evidence,levels=levels,reference=dict(region=ref['reference']['region'],locale=ref['reference']['locale'],date=ref['reference']['date'],date_kind=ref['reference']['date_kind'],deployment_date=ref['regional_patch_deployment_date']),local_queue_scope=service,outside_service_scope=outside,executed_reader_refusals=refusals,current_server_bootstrap_map=10,policies=dict(dated_EUW_payload_recovered=False,Map1_replacement_date_established=False,Map11_deployment_date_established=False,Dominion_availability_established=False,ARAM_availability_established=False,tutorial_effective_maps_established=False,modern_practice_tool_inferred=False,native_runtime_executed=False),source_checks=checks)
 return facts,list(pins.values())
_CACHE={}
def collect(root=R):
 k=str(pathlib.Path(root).resolve())
 if k not in _CACHE:_CACHE[k]=_collect(root)
 else:
  for p in _CACHE[k][1]:require(pin(p['path'])==p,'changed source '+p['path'])
 return _CACHE[k]

def bindings(f,tid):
 i=TARGETS.index(tid);names=['GameMap','GameMode','PlatformConfigController','GameQueueManager','GameQueueConfig','GameMapServiceImpl','MatchMakerServiceImpl']
 if i>=4:names+=['CreateTutorialGameController','BattleTrainingConfig','PracticeGameConfig','GameServiceImpl','ClientSystemStatesNotification']
 rows=[dict(path=a['binary']['path'],role='native_client_availability_input_not_dated_server_payload',selector=a['class_name']+';export='+a['review']['path']+';constants/RPC/response branch;no effective dated EUW payload') for a in f['air'] if a['class_name'] in names]
 if i<4:
  s=f['levels'][i];rows.append(dict(path=s['source']['path'],role='native_selected_map_resource_not_availability_date',selector=s['map_directory']+' LevelScript;exact selected-project membership;not executed'))
 return rows

def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no bypass');require(q['schema']=='openleague_map_availability_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source identities changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require([a['task_id'] for a in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchors '+t);require(a['native_bindings']==bindings(f,t),'native roles '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim '+t);require(a['entry_boundary_only'] is True and a['full_task_scope_complete'] is False,'scope '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),native_or_game_executed=False)
