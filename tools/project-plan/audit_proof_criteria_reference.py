"""Trace local proof criteria without treating written instructions as acceptance."""
import json,pathlib,sys
R=pathlib.Path('F:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from rads_reference_membership import identity as pin
import instructions,reference_client
load=lambda p:json.loads(pathlib.Path(p).read_bytes())
def require(ok,message):
 if not ok:raise ValueError(message)
TARGETS=[f'SYS-01.4-{i:02}' for i in range(1,10)];BOUNDARIES=set(TARGETS[:6]+[TARGETS[7]])
LOCAL=['tools/project-plan/instructions.py','tools/project-plan/requirement_trace.py','tools/project-plan/source_versions.py','tools/project-plan/store.py']
FN='def make_instruction(task,phase,package,all_tasks,root,source_cache,client_reference=None):'
OVERRIDE="    for i,step in enumerate(task.get('work_steps') or STEPS[kind],2):lines.append(f'{i}. {step}')"
SPECS={TARGETS[0]:[(0," 'source':["),(0,FN)],TARGETS[1]:[(0," 'simulation':["),(0,FN)],TARGETS[2]:[(0," 'network':["),(0,FN)],TARGETS[3]:[(0," 'presentation':["),(0,OVERRIDE)],TARGETS[4]:[(0," 'presentation':["),(0,OVERRIDE)],TARGETS[5]:[(0," 'acceptance':["),(0,FN)],TARGETS[6]:[(2,'def validate_history(source, root, verify_files=False):'),(1,'def validate(bundle,registry,root,verify_files=False):')],TARGETS[7]:[(1,'def validate(bundle,registry,root,verify_files=False):'),(0,'Rendre le résultat intégré et vérifiable. Si une entrée indispensable manque')],TARGETS[8]:[(3,'    def sync_catalog(self):'),(3,'    def change(self,updates,allow_archived=False):')]}
FINDINGS={
TARGETS[0]:('STEPS.source demande version,SHA,exceptions et inconnues ;make_instruction le consomme réellement pour CH-Aatrox-Q-SOURCE. Il s’agit d’un contrat local de preuve,non d’une règle native de fermeture automatique. Les fiches avec work_steps remplacent ce modèle.','Définir et qualifier un contrat de clôture source appliqué à chaque tâche,avec disponibilité et divergences ;vérifier les overrides sans assimiler une consigne copiée à une preuve acceptée.'),
TARGETS[1]:('STEPS.simulation exige chemin ordinaire,conditions,refus et interactions ;la consigne CH-Aatrox-Q-SIMULATION contient ces étapes. Le générateur produit du texte et n’exécute pas une simulation ni une décision de clôture.','Relier les critères à des scénarios et preuves de simulation réellement consommés pour clôturer chaque tâche ;garder les comportements et interactions non vérifiés ouverts.'),
TARGETS[2]:('STEPS.network contient audiences,ordre,doublons,reconnexion et plusieurs clients ;la consigne réelle CH-Aatrox-Q-NETWORK les conserve. Le recensement des634 tâches network ne trouve pas d’override,mais aucun essai multiclient n’est exécuté ici.','Qualifier le format et le consommateur des preuves multiclient,les scénarios obligatoires et les refus de couverture insuffisante ;une instruction ne prouve pas la cohérence réseau.'),
TARGETS[3]:('Le modèle presentation demande observation dans la fenêtre réelle et référence datée au même cadrage. La fiche VFX échantillonnée possède work_steps :le générateur remplace alors les étapes du modèle. Sa consigne réelle ne contient pas ces étapes génériques.','Définir des critères visuels précis et vérifier leur propagation dans les fiches réellement copiées,leurs overrides et leur décision de clôture. Aucun rendu ni comparaison visuelle n’est validé par ce lot.'),
TARGETS[4]:('Le modèle presentation distingue sortie sonore,image et événement. La fiche audio échantillonnée demande de relier et écouter les sons dans son objectif,mais son override remplace les étapes génériques. L’objectif audio ne prouve pas une écoute comparative effectuée.','Qualifier format,référence,contexte d’écoute et acceptation audio ;vérifier chaque consigne spécifique et séparer événement émis,fichier présent et sortie réellement entendue.'),
TARGETS[5]:('STEPS.acceptance décrit entrées,attendus,succès,refus et limites ;CH-Aatrox-Q-ACCEPTANCE les utilise. Les consignes sont exécutées comme génération de texte ;aucun schéma de scénario structuré universel ni moteur de recette n’est prouvé.','Relier un modèle de scénario exploitable à son consommateur réel et vérifier champs obligatoires,cas de refus et conservation des résultats ;ne pas prendre ce générateur pour l’exécuteur de scénarios.'),
TARGETS[6]:('source_versions valide chaîne,archives et preuves SHA pour une liste locale explicite. Les tests réels refusent dérive,archives modifiées et adoption d’une source historique hors racine active. requirement_trace vérifie les octets seulement avec verify_files=True ;une validation de métadonnées n’établit pas leur fraîcheur.','Qualifier la propagation de péremption vers toutes les preuves dépendantes et leur clôture ;la validation d’un historique de source n’invalide pas automatiquement toutes les recettes. Conserver racines historiques et copies actives distinctes.'),
TARGETS[7]:('requirement_trace valide un graphe avec inconnues ouvertes et retourne gameplay_accepted=False. Sur copie en mémoire du registre réel,forcer acceptance_complete=True ne transforme pas ce résultat en recette :ce validateur n’est pas une garde finale de clôture. Les consignes demandent de conserver les inconnues.','Identifier et qualifier le consommateur final qui refuse toute exigence obligatoire inconnue,ainsi que ses contournements et entrées réelles. Aucun garde final universel créé ou déclaré complet ici.'),
TARGETS[8]:('Store conserve la coche dans task_state séparément de tasks.data. Le test courant prouve qu’une acceptation technique ne coche pas une nouvelle tâche et qu’une synchronisation conserve le choix manuel. change contrôle type,révision et historique ;summary mesure les coches,non la complétude du jeu.','Vérifier tous les parcours de présentation,import/export et clôture pour conserver cette distinction et qualifier l’acceptation humaine séparément. Le test temporaire ne vaut pas observation de l’application native.')}

def anchor(root,tid,i,spec):
 p,n=LOCAL[spec[0]],spec[1];hits=[j+1 for j,l in enumerate((root/p).read_text(encoding='utf8').splitlines()) if n in l];require(len(hits)==1,'unique anchor '+tid+' '+n)
 return dict(path=p,line=hits[0],needle=n,role='proof_criteria_'+('boundary_' if tid in BOUNDARIES else 'partial_')+tid.replace('-','_').replace('.','_')+'_'+str(i))
def work_section(text):return text.split('TRAVAIL À EFFECTUER\n',1)[1].split('\nRÉSULTAT ATTENDU / CRITÈRE DE FIN',1)[0]
def _collect(root=R):
 root=pathlib.Path(root).resolve();pins={};checks=[]
 def keep(p):s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(k,v):require(v,k);checks.append(k)
 loc=load(root/'docs/project_location.json');keep(root/'docs/project_location.json');check('active_F_root',pathlib.Path(loc['active_root']).resolve()==root)
 d=root/'docs/reference_proof_criteria_sources';contract=load(d/'instruction-contracts.json');keep(d/'instruction-contracts.json');check('local_not_native_policy',contract['native_origin'] is False);check('steps_same_as_consumer',contract['steps']==instructions.STEPS)
 reg=load(root/'docs/completion_tasks_2026-10-20.json');h=load(root/'docs/execution_plan_A_Z.json');tm={t['id']:t for t in reg['tasks']};pm={p['id']:p for p in h['packages']};ph={p['id']:p for p in h['phases']};samples=[]
 for sample in contract['samples']:
  tid=sample['task']['id'];t=tm[tid];p=pm[h['task_to_package'][tid]];check('actual_sample_contract_'+tid,t==sample['task'] and p==sample['package'] and ph[p['phase']]==sample['phase']);text=instructions.make_instruction(t,ph[p['phase']],p,tm,root,pathlib.Path('E:/mapslol3v3/Full_project_audit_2026-10-20/official_reference'));source=keep(d/sample['text_file']);check('actual_instruction_'+tid,text==pathlib.Path(source['path']).read_text(encoding='utf8'));section=work_section(text);effective=t.get('work_steps') or instructions.STEPS[t['kind']];check('effective_steps_'+tid,all(step in section for step in effective));default=instructions.STEPS[t['kind']];present=[step in section for step in default];over=bool(t.get('work_steps'));check('override_flag_'+tid,over==sample['uses_override']);check('default_or_override_'+tid,(not any(present)) if over else all(present));samples.append(dict(task_id=tid,kind=t['kind'],uses_override=over,default_steps_present=present,source=source,expected_steps=len(effective),observed_steps=len(effective)))
 census={k:dict(total=sum(t['kind']==k for t in reg['tasks']),override=sum(t['kind']==k and bool(t.get('work_steps')) for t in reg['tasks'])) for k in instructions.STEPS};check('full_kind_override_census',census==contract['kind_census']);check('network_no_override',census['network']==dict(total=634,override=0))
 tests={}
 for name,count in [('local-contract-tests',23),('trace-contract-tests',9)]:
  receipt=load(d/(name+'.json'));keep(d/(name+'.json'));check(name+'_pass',receipt['passed'] is True and receipt['tests_run']==count and receipt['failures']==receipt['errors']==0 and receipt['game_executed'] is False and receipt['live_database_mutated'] is False)
  entries=[receipt['python'],receipt['log'],receipt['harness']]
  if name=='local-contract-tests':entries += [receipt['manual_test_source'],*receipt['modules'].values()]
  else:entries += [receipt['source'],receipt['consumer']]
  for i,s in enumerate(entries):check(name+'_identity_'+str(i),keep(s['path'])==s)
  tests[name]=receipt
 probe=tests['trace-contract-tests']['acceptance_flag_probe']['observed'];check('trace_not_acceptance_gate',probe['verified'] is True and probe['gameplay_accepted'] is False and probe['open_unknowns']==25321 and tests['trace-contract-tests']['full_source_hash_verification'] is False)
 ref=load(root/'docs/reference_client_4_20.json');keep(root/'docs/reference_client_4_20.json');reference_client.validate(ref,verify_native=True);check('reference_4_20_context',True);refs=[keep(pathlib.Path(ref['source_root'])/s['path']) for s in ref['sources']]
 for p in LOCAL+['AGENTS.md','docs/BUILDING.md','tools/project-plan/reference_client.py','tools/project-plan/fidelity_ids.py','tools/project-plan/fidelity_identity_aliases_4_20.json','tools/project-plan/rads_reference_membership.py']:keep(root/p)
 branch_checks={LOCAL[0]:["task.get('work_steps') or STEPS[kind]","task['acceptance']","task['evidence_required']"],LOCAL[1]:["row.get('game_behavior_accepted') is not False","if verify_files:","'gameplay_accepted':False","Unknown resolved without explicit evidence/history"],LOCAL[2]:['if verify_files and (not path.is_file()',"raise SourceVersionError('Current versioned source changed')",'root = _validation_root(source, root)'],LOCAL[3]:['INSERT OR IGNORE INTO task_state(task_id,done)',"[(t['id'],0) for t in tasks]","type(u.get('revision')) is not int","type(done) is not bool","'done':sum(p['done'] for p in phases)"]}
 for p,needles in branch_checks.items():
  text=(root/p).read_text(encoding='utf8')
  for i,n in enumerate(needles):check('current_branch_'+p+str(i),n in text)
 for t in TARGETS:
  for i,s in enumerate(SPECS[t]):checks.append('anchor_'+anchor(root,t,i,s)['role'])
 facts=dict(local_contract=dict(source=str(d/'instruction-contracts.json'),native_origin=False,steps=contract['steps'],kind_census=census,samples=samples),tests=tests,reference=dict(document=ref,sources=refs,native_validated=True,native_executed=False,scope='Version context only;the authored proof requirements are local,not historical game rules.'),policies=dict(universal_proof_gate_qualified=False,universal_scenario_schema_qualified=False,dependency_staleness_propagation_qualified=False,multiclient_recipe_executed=False,visual_comparison_executed=False,audio_listening_executed=False,native_UI_observed=False,manual_and_technical_state_separation_tested=True,native_or_game_executed=False),source_checks=checks)
 return json.loads(json.dumps(facts)),list(pins.values())
_CACHE={}
def collect(root=R):
 context=[pathlib.Path(root)/p for p in ['docs/completion_tasks_2026-10-20.json','docs/execution_plan_A_Z.json']]
 key=(str(pathlib.Path(root).resolve()),tuple((p.stat().st_mtime_ns,p.stat().st_size) for p in context))
 if key not in _CACHE:_CACHE[key]=_collect(root)
 else:
  for p in _CACHE[key][1]:require(pin(p['path'])==p,'changed source '+p['path'])
 return _CACHE[key]
def bindings(f,tid):return []
def audit(q,root='F:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);require(verify_files,'no bypass');require(q['schema']=='openleague_proof_criteria_links/v1' and q['passed'] is True,'schema/status')
 for k in ['full_task_scope_complete','native_or_game_executed','historical_server_policy_qualified']:require(q[k] is False,'unsupported scope '+k)
 f,p=collect(root);require(q['facts']==f,'facts changed');require(q['source_identities']==p,'source identities changed');require(q['checks']==f['source_checks'] and q['checks_count']==len(q['checks']),'check census');require([a['task_id'] for a in q['associations']]==TARGETS,'task census')
 um={u['unknown_id']:u for u in load(root/'docs/fidelity_unknowns_4_20.json')['unknowns']}
 for a in q['associations']:
  t=a['task_id'];require(a['anchors']==[anchor(root,t,i,s) for i,s in enumerate(SPECS[t])],'anchors '+t);require(a['native_bindings']==[],'local policy falsely native '+t);require((a['finding'],a['remaining'])==FINDINGS[t],'claim '+t);require(a['entry_boundary_only']==(t in BOUNDARIES) and a['full_task_scope_complete'] is False,'scope '+t);u=um[a['existing_unknown_id']];require(u['status']=='open' and u['task_id']==t,'unknown '+t)
 return dict(verified=True,checks_count=len(q['checks']),tasks=len(TARGETS),roles=sum(len(a['anchors']) for a in q['associations']),source_pins=len(p),native_or_game_executed=False,local_policy=True,consumer_tests_run=32)
