from pathlib import Path
from datetime import datetime,timezone
import json,html,hashlib,copy,shutil
r=Path('E:/OpenLeague');d=r/'docs';now=datetime.now(timezone.utc).isoformat();stamp=datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')
plan=json.loads((d/'completion_plan.json').read_text(encoding='utf-8'));coverage=json.loads((d/'coverage.json').read_text(encoding='utf-8'));e=coverage['current_evidence'];checkpoint=json.loads((d/'resume_checkpoint.json').read_text(encoding='utf-8'))
before=copy.deepcopy(plan);ids=[t['id'] for x in plan['domains'] for t in x['tasks']]
assert len(plan['domains'])==24 and len(ids)==114
assert sum(len(x.get('additional_requirements',[])) for x in plan['domains'])==37
backup=d/'plan_history'/stamp;backup.mkdir(parents=True,exist_ok=True)
for name in ['completion_plan.json','completion_plan.html','goal_objective.txt']:shutil.copyfile(d/name,backup/name)
notes={
'01':'Inventaires et sources historiques présents ; référentiel exhaustif des fonctions, provenance et acceptation encore à achever.',
'02':'122 modèles de champions importés et carte restaurée disponible ; références manquantes, variantes, textures ambiguës et reproductibilité complète à résoudre.',
'03':'Moteur Rust compilable, rendu Vulkan observé et outils de diagnostic présents ; stabilité, compatibilité et architecture finale restent à qualifier.',
'04':'Combat, dégâts, boucliers, contrôles et régénération partiellement implémentés ; ordre des modificateurs, exceptions et interactions historiques incomplets.',
'05':'Progression et ressources partiellement implémentées ; rangs, partage des récompenses, remboursements et toutes les exceptions de compétences à achever.',
'06':f"{e['imported_champion_models']} modèles importés ; {e['QWER_core_partially_implemented']} emplacements QWER partiels, {e['unimplemented_QWER']} non implémentés, {e['QWER_fully_complete']} entièrement qualifiés. Aucun kit complet.",
'07':f"Catalogue de {e['native_item_files_audited']} fichiers natifs audité ; {e['active_shop_items']} objets actifs. Passifs, actifs, recettes, restrictions et boutique complète restent à achever.",
'08':f"{e['summoner_spells_partially_implemented']} sorts invocateur partiels, aucun entièrement qualifié ; autres sorts, runes et maîtrises à implémenter et intégrer.",
'09':'Navigation et sélection partielles ; collisions physiques, rayons manquants, priorités et déplacements spéciaux restent incomplets.',
'10':'Scène restaurée chargée dans le moteur ; bâtiments, camps, vagues, autels et reliques partiellement actifs. Fidélité par zone, objectifs et partie à six joueurs jusqu’aux résultats restent à vérifier.',
'11':'Toutes les autres cartes et tous les modes réellement disponibles en 4.20 restent à qualifier, intégrer et tester.',
'12':'Sbires, monstres et IA de base présents ; priorités, scripts particuliers, invocations et kit de Vilemaw restent incomplets.',
'13':'Visibilité par équipe et ciblage caché partiellement implémentés ; buissons, furtivité, détection et brouillard complet restent à achever.',
'14':f"{e['native_animation_bindings_verified']} liaisons d’animations vérifiées ; {e['animation_roles_missing_or_invalid']} rôles manquants ou invalides. Skins sortis, formes, transitions et synchronisation complète à terminer.",
'15':'Particules d’Annie et projection sur terrain restauré partiellement portées. Contrats natifs : émission96cas, naissance48cas, rattachement112cas. Projection du sort non encore activée ; âge, fin de vie, pose propriétaire et toutes les autres capacités/variantes restent à achever.',
'16':'Ressources audio décodées et déclenchements partiels ; lecture audible, mixage, spatialisation, priorités, annonces et langues restent à qualifier.',
'17':'Interface de partie et boutique partielles ; HUD historique complet, informations, interactions et écrans de partie restent à achever.',
'18':'Launcher historique Rust/Tauri à terminer et comparer au client4.20 : patcher, connexion, collection, salons, sélection, options et tous les parcours retenus.',
'19':'Services locaux compte/session/social/progression, files, classement, résultats et persistance à terminer et vérifier de bout en bout.',
'20':'Serveur autoritaire UDP et scénarios partiels présents ; protocole complet, interpolation, pertes, reconnexion et sécurité des commandes restent à achever.',
'21':'Spectateur, enregistrements et fonctions historiques retenues à qualifier, implémenter et vérifier.',
'22':'Localisation partielle ; langues, paramètres persistants, résolutions, entrées et compatibilité finale restent à achever.',
'23':'Tests unitaires et preuves ciblées disponibles ; ils ne clôturent pas les fonctions. Matrice complète d’interactions, parties réelles, endurance, performances et comparaison4.20 restent à réaliser.',
'24':'Installation autonome, paquet final, mises à jour, sauvegarde/restauration, réparation, désinstallation et acceptation depuis une installation propre restent à livrer.'}
receipt_fields={'02':['source_inventory','restored_map_receipt'],'03':['current_build_receipt'],'04':['damage_receipt','regeneration_receipt','shield_barrier_receipt','slow_garen_receipt'],'06':['garen_passive_receipt','garen_cancel_receipt','garen_crossing_receipt'],'09':['collision_selection_receipt','terrain_picking_receipt'],'10':['restored_map_receipt','render_receipt'],'14':['source_inventory'],'15':[],'20':[]}
native_receipts=['docs/simple_projected_progress.json','docs/simple_emission_progress.json','docs/simple_birth_progress.json','docs/simple_attachment_progress.json','docs/projected_terrain_progress.json','docs/projected_render_progress.json']
for domain in plan['domains']:
 domain['current_state']=notes[domain['id']]
 domain['progress_updated_utc']=now
 refs=['docs/coverage.json','docs/resume_checkpoint.json']+[e[k] for k in receipt_fields.get(domain['id'],[]) if isinstance(e.get(k),str)]
 if domain['id']=='15':refs+=native_receipts
 domain['progress_evidence']=[x for x in dict.fromkeys(refs) if (r/x).is_file()]
 domain['remaining_work']=[t['deliverable'] for t in domain['tasks']]+domain.get('additional_requirements',[])
 domain['implementation_complete']=False;domain['acceptance_complete']=False
 if domain['id'] in ['02','03','04','05','06','07','08','09','10','12','13','14','15','16','17','20','23']:domain['status']='en_cours'
 for task in domain['tasks']:
  if task['id'] in ['06.1','06.2','06.4','10.1','10.3','10.4','10.5','14.2','14.4','15.1','15.2','15.3','16.1','16.2']:
   task['status']='partiellement_implemente_a_terminer'
   task['evidence']=list(dict.fromkeys(task.get('evidence',[])+domain['progress_evidence']))
   task['evidence_scope']='Preuves ciblées ou état enregistré seulement ; elles ne clôturent pas cette tâche complète.'
plan['version']=int(plan.get('version',2))+1;plan['updated_utc']=now;plan['complete']=False
plan['current_evidence']=copy.deepcopy(e)
plan['counts']={'domains':24,'tasks':114,'additional_requirements':37,'completed_domains':e['completed_domains']}
plan['progress_summary']={'updated_utc':now,'completed_domains':0,'full_champion_kits_complete':0,'client_tests_last_recorded':e['client_tests_passed'],'test_scope':'Tests du client ; aucune acceptation intégrale du jeu déduite.','required_scope_unchanged':True}
plan['goal_text_sync']={'displayed_goal_text_updated':False,'reason':'Les outils Goal disponibles ne proposent aucune modification du texte de l’objectif.','corrected_objective_file':'docs/goal_objective.txt','obsolete_pause_instruction_cancelled_by_user':True,'obsolete_reboot_instruction_removed_from_plan':True}
plan['next_execution_steps']=[
'Terminer âge, fin de vie, pose propriétaire et activation normale de la projection d’Annie ; vérifier visuellement le véritable sort sur le binaire actuel.',
'Achever les systèmes communs et les kits de référence Garen/Annie avec toutes leurs interactions, effets et sons.',
'Achever tous les éléments de la Forêt torturée et vérifier une partie complète à six clients jusqu’à victoire et résultats.',
'Compléter chaque champion, chaque objet, rune, maîtrise, sort invocateur, skin, carte et mode4.20 avec un registre individuel.',
'Achever en parallèle autorisé par les dépendances le launcher historique, les services locaux, le HUD, l’audio, le réseau et les autres domaines.',
'Rejouer qualification, endurance et performances sur les exécutables finaux ; livrer et tester une installation autonome.']
plan['execution_progress']['updated_utc']=now
plan['execution_progress']['complete']=False
for phase in plan['phases']:
 if phase['id']=='P0':phase['title']='Stabiliser le lancement et qualifier le rendu du jeu'
assert ids==[t['id'] for x in plan['domains'] for t in x['tasks']]
assert [(x['id'],x['acceptance'],x.get('additional_requirements',[])) for x in plan['domains']]==[(x['id'],x['acceptance'],x.get('additional_requirements',[])) for x in before['domains']]
(d/'completion_plan.json').write_text(json.dumps(plan,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
objective=(d/'goal_objective.txt').read_text(encoding='utf-8')
objective=objective.split('\nÉTAT ACTUALISÉ')[0]
objective=objective.replace('P0 Stabiliser le lancement du jeu, reconstruire le launcher, tester Vulkan et les fenêtres, capturer le vrai rendu et confirmer la carte restaurée. DX12 a planté ; Vulkan compilé mais non qualifié.','P0 Achever la stabilité du lancement, du launcher et du rendu. La carte restaurée a été observée sous Vulkan ; qualification finale des fenêtres, compatibilité et performances encore requise. Conserver les preuves des défauts DX12.')
objective+='\nÉTAT ACTUALISÉ — '+now+'\n24 domaines / 114 tâches / 37 exigences conservés ; 0 domaine entièrement validé.\n122 modèles importés ; 480 emplacements QWER non implémentés, 8 partiels, 0 entièrement terminés.\n51 tests client enregistrés ; émission96cas, naissance48cas et rattachement112cas natifs vérifiés. Ces preuves ciblées ne clôturent ni un champion ni le jeu.\n\nPROCHAINES ÉTAPES :\n'+'\n'.join(f'{i+1}. {x}' for i,x in enumerate(plan['next_execution_steps']))+'\n\nLire l’état et les travaux restants de CHAQUE domaine dans docs/completion_plan.json ; conserver toute exigence jusqu’à preuve de clôture. Le redémarrage personnel et l’ancienne demande de pause ne font pas partie de cet objectif.\n'
# No obsolete personal reboot/pause instruction remains in the objective.
objective=objective.replace(' Le redémarrage personnel et l’ancienne demande de pause ne font pas partie de cet objectif.','')
(d/'goal_objective.txt').write_text(objective,encoding='utf-8')
esc=html.escape
sections=[]
for x in plan['domains']:
 tasks=''.join('<li><b>'+esc(t['id'])+'</b> '+esc(t['deliverable'])+' <span class="status">['+esc(t['status'])+']</span></li>' for t in x['tasks'])
 extras=''.join('<li>'+esc(a)+'</li>' for a in x.get('additional_requirements',[]))
 refs=' · '.join('<a href="'+esc(str(Path(a).relative_to('docs')).replace('\\','/'),quote=True)+'">'+esc(Path(a).name)+'</a>' for a in x['progress_evidence'] if a.startswith('docs/'))
 sections.append('<section id="domain-'+x['id']+'"><h2>'+x['id']+' — '+esc(x['title'])+'</h2><p class="status">'+esc(x['status'])+' — aucune clôture complète</p><p><b>État vérifié ou enregistré :</b> '+esc(x['current_state'])+'</p><p>Dépendances : '+esc(', '.join(x.get('depends_on',[])))+'</p><h3>Travaux requis jusqu’à clôture</h3><ol>'+tasks+'</ol><h3>Exigences complémentaires</h3><ul>'+extras+'</ul><p><b>Critère d’acceptation :</b> '+esc(x['acceptance'])+'</p><p>Preuves et limites : '+refs+'</p></section>')
phases=''.join('<section><h3>'+esc(x['id']+' — '+x['title'])+'</h3><ol>'+''.join('<li>'+esc(t)+'</li>' for t in x['tasks'])+'</ol><p><b>Critère de passage :</b> '+esc(x['acceptance'])+'</p></section>' for x in plan['phases'])
page='<!doctype html><html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>OpenLeague — plan complet actualisé</title><style>body{font:16px/1.6 system-ui;max-width:1100px;margin:30px auto;padding:0 24px;color:#172334;background:#f6f8fb}section{background:white;padding:24px;margin:20px 0;border:1px solid #dae0e8;border-radius:8px}h1,h2,h3{line-height:1.25}li{margin:8px 0}.status{color:#6f4900}.state{padding:16px;background:#fff0cd}a{color:#1759a6}nav{display:grid;gap:8px} @media print{body{background:white;margin:0}section{break-inside:avoid}}</style></head><body><h1>OpenLeague — plan complet jusqu’à livraison</h1><p>'+esc(plan['scope'])+'</p><p>Actualisation : '+esc(now)+' · version '+str(plan['version'])+'</p><p class="state">24 domaines, 114 tâches, 37 exigences complémentaires conservés. 0 domaine entièrement validé. 122 modèles importés ; 480 emplacements QWER non implémentés, 8 partiels. 51 tests client enregistrés : ces contrôles ciblés ne prouvent pas l’achèvement du jeu.</p><p>Le plan référencé par le Goal est actualisé. Le texte affiché du Goal reste techniquement non modifiable avec les outils disponibles ; <a href="goal_objective.txt">son texte corrigé</a> est conservé séparément.</p><h2>Prochaines étapes</h2><ol>'+''.join('<li>'+esc(x)+'</li>' for x in plan['next_execution_steps'])+'</ol><h2>Ordre et dépendances</h2>'+phases+'<h2>Les 24 domaines</h2><nav>'+''.join('<a href="#domain-'+x['id']+'">'+esc(x['id']+' — '+x['title'])+'</a>' for x in plan['domains'])+'</nav>'+''.join(sections)+'<section><h2>Clôture intégrale</h2><p>Toute exigence doit être implémentée, intégrée et vérifiée, avec preuves liées aux exécutables et ressources livrés. Les imports, tests isolés et jalons partiels ne clôturent pas une fonction. Validation technique et validation humaine de fidélité restent distinctes.</p><p><a href="completion_plan.json">Plan exhaustif exploitable et critères de clôture détaillés</a> · <a href="coverage.json">Suivi réel</a> · <a href="resume_checkpoint.json">Point de reprise</a></p></section></body></html>'
(d/'completion_plan.html').write_text(page,encoding='utf-8')
receipt={'updated_utc':now,'scope_preserved':True,'domains':24,'tasks':114,'additional_requirements':37,'backup':str(backup),'displayed_goal_text_updated':False,'files_sha256':{name:hashlib.sha256((d/name).read_bytes()).hexdigest() for name in ['completion_plan.json','completion_plan.html','goal_objective.txt']}}
(d/'plan_update_receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
shutil.copyfile(Path('E:/mapslol3v3/update_full_goal_plan.py'),r/'tools/update_full_goal_plan.py')
print(json.dumps(receipt))
