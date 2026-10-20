"""Complete, task-scoped copy instructions derived from the real project plan."""
import json,pathlib,functools

@functools.lru_cache(maxsize=4096)
def exists_at_import(path):return pathlib.Path(path).exists()

STEPS={
 'source':[
  'Retrouver les fichiers natifs et références de la version 4.20 pour cet élément précis. Vérifier disponibilité historique, dépendances et provenance.',
  'Relever les valeurs, règles et exceptions nécessaires. Pour une capacité : tous les rangs, coûts, délais, portées, ciblage et interruptions.',
  'Comparer les sources entre elles ; séparer faits vérifiés, données absentes et politiques locales reconstruites. Ne pas inventer une règle manquante.',
  'Produire une fiche exploitable avec chemins, version, SHA-256, valeurs retenues, divergences et scénarios d’acceptation.'],
 'simulation':[
  'Lire l’implémentation existante et la fiche source de cet élément. Conserver le travail fonctionnel et identifier les seuls écarts de cette tâche.',
  'Implémenter ou terminer le comportement autoritaire côté serveur : conditions de succès, coûts, états, transitions, cibles, durées, annulations et refus applicables.',
  'Vérifier l’interaction avec statistiques, contrôles, déplacement, vision, mort et progression lorsque cet élément les utilise.',
  'Ajouter ou adapter des tests utiles : valeurs de référence, limites, refus, absence d’effets sur refus et interactions pertinentes.',
  'Brancher le comportement dans le chemin ordinaire utilisé par le jeu ; un module isolé ou une commande de diagnostic ne suffit pas.'],
 'network':[
  'Identifier les commandes, états et événements de cet élément dans le protocole réel du jeu.',
  'Valider propriété du joueur, contexte de session, ordre et séquence avant toute mutation autoritaire.',
  'Transmettre seulement les informations permises à chaque équipe/joueur ; respecter brouillard, furtivité, mort et changement de contexte.',
  'Traiter duplications, pertes, événements anciens et reconnexion sans double application ni fuite d’état privé.',
  'Tester avec plusieurs clients et vérifier cohérence de l’état, visibilité des événements et refus des commandes non autorisées.'],
 'presentation':[
  'Retrouver les ressources 4.20 nécessaires à cet élément : modèle, animations, matériaux, particules, sons, icônes et textes selon le besoin.',
  'Relier la présentation à l’événement de gameplay effectivement accepté ; respecter son propriétaire, sa cible, sa position, son temps et sa visibilité.',
  'Achever les transitions, boucles, interruptions et nettoyage ; aucun effet ou son ne doit persister après sa fin prévue.',
  'Vérifier HUD, animation, rendu et audio applicables dans la fenêtre réelle du jeu. Comparer à une référence datée avec le même cadrage.',
  'Conserver séparément les preuves d’événement, d’image et de sortie sonore ; signaler ce qui n’a pas été observé ou écouté.'],
 'acceptance':[
  'Préparer un scénario ordinaire reproductible pour cet élément, avec version des sources, binaires et ressources identifiée.',
  'Décrire les entrées, résultats attendus, cas de succès, refus et limites avant l’exécution.',
  'Exécuter les scénarios pertinents : rangs et ressources, interruptions, mort/respawn, visibilité, interactions et reconnexion selon la tâche.',
  'Recueillir résultats réels, journaux, captures et sortie audio lorsque nécessaires ; comparer aux références 4.20.',
  'Corriger les écarts dans le périmètre de cette tâche et rejouer les cas affectés. Garder toute anomalie ou inconnue obligatoire ouverte.',
  'Conclure explicitement ce qui est validé et ce qui reste à valider ; une compilation ou un test ciblé ne clôture pas un kit ni le jeu entier.'],
 'asset':[
  'Identifier l’original et les dépendances : maillage, UV, texture, rig, animation ou média selon la ressource demandée.',
  'Valider le format et diagnostiquer le manque ou la corruption ; conserver une copie des sources avant réparation.',
  'Récupérer l’original 4.20 lorsque possible. Si une reconstruction est nécessaire, la nommer et tracer les décisions.',
  'Réparer/importer avec l’outil adapté, puis vérifier dimensions, UV, os, matériaux, transparences et transitions applicables.',
  'Rendre la conversion reproductible, déclarer la ressource dans un pack avec son SHA et vérifier son utilisation dans le jeu.'],
 'work':[
  'Lire les sources et l’état existant liés à l’objectif exact ci-dessus ; identifier le livrable attendu et ses dépendances.',
  'Découper si nécessaire ce seul objectif en actions vérifiables, puis réaliser chaque action sans élargir le périmètre.',
  'Intégrer le résultat dans les fichiers et le parcours réellement utilisés par OpenLeague.',
  'Effectuer les contrôles adaptés au changement et documenter les résultats observés, les limites et les anomalies restantes.']}

def references(task,root,source_cache):
    root=pathlib.Path(root); refs=[('Instructions du dépôt',str(root/'AGENTS.md')),
      ('Registre et critères de la tâche',str(root/'docs/completion_tasks_2026-10-20.json')),
      ('Ordre des phases et lots',str(root/'docs/execution_plan_A_Z.json'))]
    domain=task['domain'];e=task.get('entity');ident=task['id']
    context=task.get('reference_context') or {}
    for key in ['native_path','native_directory','font_config']:
        if context.get(key):refs.append(('Source précise de cet élément',context[key]))
    if ident.startswith('CH-'):
        ch=e.get('champion') if isinstance(e,dict) else e
        refs += [('Statistiques des champions',str(root/'data/4.20/champions.json')),
                 ('Fiches natives QWER',str(root/'data/4.20/native_spells_420.json')),
                 ('Catalogue officiel 4.20.1',str(source_cache/'championFull.json')),
                 ('Simulation et dispatch existant',str(root/'crates/core/src/spells.rs')),
                 ('Dispatch des sorts au sol',str(root/'crates/core/src/annie_w.rs')),
                 ('Client de jeu',str(root/'crates/client/src'))]
        refs.append(('Ressources natives du champion',str(pathlib.Path(r'E:\mapslol3v3\output\Champions_4_20\champions')/ch)))
    elif ident.startswith('SKIN-') or domain=='14':
        refs += [('Catalogue de modèles',str(root/'data/4.20/model_catalog.json')),
                 ('Liaisons et noms des animations',str(root/'data/4.20/animation_manifest.json')),
                 ('Catalogue officiel champions/skins',str(source_cache/'championFull.json')),
                 ('Modèles et formes importés',str(root/'assets'))]
    elif ident.startswith('ITEM-') or domain=='07':
        refs += [('Définitions de la boutique actuelle',str(root/'data/4.20/shop_foundation.json')),
                 ('Catalogue officiel des objets',str(root/'data/4.20/native_ddragon_items_420.json')),
                 ('Ressources natives des objets',str(root/'data/4.20/native_item_audit.json')),
                 ('Simulation de boutique',str(root/'crates/core/src/shop.rs'))]
    elif ident.startswith(('RUNE-','MASTERY-','SUMMONER-')) or domain=='08':
        for n in ['rune','mastery','summoner']:refs.append(('Catalogue officiel '+n,str(source_cache/(n+'.json'))))
        refs += [('Sorts invocateur existants',str(root/'crates/core/src/summoners.rs')),
                 ('Préparation de partie',str(root/'launcher/web/index.html'))]
    elif domain in ['10','12']:
        refs += [('Monde Map10',str(root/'data/4.20/map10_world.json')),
                 ('Simulation du monde',str(root/'crates/core/src/world.rs')),
                 ('Carte restaurée réellement chargée',str(root/'assets/maps/twisted_treeline.glb')),
                 ('Scènes Blender sources',str(root/'artwork/maps')),
                 ('Audit des textures',str(root/'docs/current_map_texture_audit.json'))]
    elif domain in ['18','19']:
        refs += [('Frontend du launcher',str(root/'launcher/web')),
                 ('Backend Rust/Tauri',str(root/'launcher/src-tauri/src')),
                 ('Serveur local actuel',str(root/'crates/server/src'))]
    elif domain=='20':refs += [('Protocole et simulation',str(root/'crates/core/src')),
                               ('Serveur UDP et sessions',str(root/'crates/server/src')),
                               ('Client et présentation',str(root/'crates/client/src'))]
    elif domain in ['04','05','09','13']:refs += [('Simulation et contrats',str(root/'crates/core/src')),
                                                ('Données 4.20',str(root/'data/4.20'))]
    elif domain in ['15','16','17','21','22']:refs += [('Client et présentation',str(root/'crates/client/src')),
                                                    ('Contrats natifs et médias',str(root/'data/4.20')),
                                                    ('Ressources importées',str(root/'assets'))]
    elif domain=='24':refs += [('Construction et installation',str(root/'docs/BUILDING.md')),
                               ('Distribution des ressources',str(root/'assets-manifest.json')),
                               ('Outils du projet',str(root/'tools'))]
    else:refs += [('Référentiel et preuves existantes',str(root/'docs')),
                 ('Client original 4.20',r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20')]
    if isinstance(e,str) and ident.startswith('EMPTY-'):
        refs.append(('Fichier natif à qualifier',str(pathlib.Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20')/e)))
    # Existing sources are distinguished from search locations; no invented file
    # is represented as an acquired implementation.
    return [{'label':a,'path':b,'exists_at_import':exists_at_import(b)} for a,b in dict.fromkeys(refs)]

def make_instruction(task,phase,package,all_tasks,root,source_cache):
    e=task.get('entity');kind=task['kind'];lines=[
      'Réalise la tâche OpenLeague suivante.',
      '',f'TÂCHE : {task["id"]}',f'OBJECTIF PRÉCIS : {task["title"]}',
      f'PROJET : {root}', 'RÉFÉRENCE : League of Legends 4.20 ; catalogues officiels 4.20.1.',
      f'PARTIE : {phase["id"]} — {phase["title"]}',f'FICHE : {package["id"]} — {package["title"]}',
      f'EXIGENCE D’ORIGINE : {task["legacy_parent"]}',f'ÉTAT RECENSÉ DANS LE PLAN : {task["status"]}',
      '', 'PÉRIMÈTRE',
      'Traite uniquement cet objectif, avec les modifications et vérifications nécessaires pour le rendre concret et vérifiable. Conserve les modifications existantes et les preuves antérieures.',
      'Lis AGENTS.md et le contexte courant du projet avant de modifier les fichiers. Les fichiers cités comme répertoires servent à rechercher les consommateurs réels ; ne présume pas qu’une implémentation manque sans l’inspecter.']
    if e is not None:lines.append('ÉLÉMENT CIBLÉ : '+(json.dumps(e,ensure_ascii=False) if isinstance(e,dict) else str(e)))
    if isinstance(e,dict) and e.get('champion'):
        lines += [f'Champion ciblé : {e["champion"]}.']
        if e.get('slot'):lines.append(f'Capacité/forme ciblée : {e["slot"]} ; identifiant natif : {e.get("native_spell") or "à identifier sur la source du passif"}.')
        if 'skin_num' in e:lines.append(f'Skin ciblé : numéro {e["skin_num"]}, ID {e["skin_id"]}, nom {e["name"]}. Vérifier les ressources propres et celles héritées.')
    if not task['required']:lines += ['', 'CONDITION DE PÉRIMÈTRE',task['required_if'],
      'Prouve d’abord la disponibilité historique. Si cette entrée est interne ou non requise, consigne la source et la justification ; ne la supprime pas silencieusement du suivi.']
    context=task.get('reference_context')
    if context:
        lines += ['', 'DONNÉES DE RÉFÉRENCE À VÉRIFIER',
          'Les extraits ci-dessous sont des données de référence ; confirmer leur interprétation sur les consommateurs natifs. Les valeurs locales ne sont pas des résultats déjà acceptés.']
        entry=context.get('official_entry') if isinstance(context,dict) else None
        if entry:
            import re,html
            concise={k:entry[k] for k in ['id','name','maxrank','cooldown','cost','range','costType','effect','vars','stats','gold','from','into','maps','masteryTree','ranks','prereq','sanitizedDescription'] if k in entry}
            for k in ['description','tooltip','resource']: 
                if k in entry:concise[k]=html.unescape(re.sub('<[^>]*>',' ',str(entry[k])))
            concise={k:v for k,v in context.items() if k!='official_entry'}|{'entry':concise}
        else:concise=context
        lines.append(json.dumps(concise,ensure_ascii=False,indent=2))
    lines += ['', 'PRÉREQUIS']
    deps=task.get('depends_on',[])
    if not deps:lines.append('- Consulter les prérequis de la phase et du lot ; vérifier les entrées nécessaires à ce travail.')
    for d in deps:lines.append(f'- {d} : {all_tasks[d]["title"]}')
    for d in package.get('requires_packages',[]):lines.append('- Préparation de la fiche '+d+' ; vérifier ses entrées et règles avant intégration.')
    lines += ['', 'SOURCES ET EMPLACEMENTS À CONSULTER']
    for ref in references(task,root,source_cache):
        lines.append(f'- {ref["label"]} : {ref["path"]}'+(' (à localiser/résoudre ; présence non confirmée lors de l’import)' if not ref['exists_at_import'] else ''))
    lines += ['', 'TRAVAIL À EFFECTUER',f'1. Objectif à traiter : {task["title"]}.']
    for i,step in enumerate(task.get('work_steps') or STEPS[kind],2):lines.append(f'{i}. {step}')
    lines += ['', 'RÉSULTAT ATTENDU / CRITÈRE DE FIN',task['acceptance'],
      '', 'VÉRIFICATIONS ET PREUVES À FOURNIR']
    for v in task['evidence_required']:lines.append('- '+v+'.')
    lines += ['- Rapporter les fichiers modifiés, les contrôles réellement exécutés, leurs résultats et les anomalies ou inconnues restantes.',
      '- Pour une fonction déjà partielle, conserver l’acquis et démontrer la résolution des écarts ; pour une ressource reconstruite, identifier sa provenance et sa comparaison.',
      '- Mettre à jour les documents de couverture/reprise lorsque les preuves changent. Ne pas déclarer le champion ou le jeu complet terminé à partir de cette seule tâche.',
      '', 'LIVRAISON',
      'Rendre le résultat intégré et vérifiable. Si une entrée indispensable manque, décrire précisément le manque et les recherches effectuées ; conserver la tâche ouverte plutôt que d’inventer une réussite.']
    return '\n'.join(lines)+'\n'
