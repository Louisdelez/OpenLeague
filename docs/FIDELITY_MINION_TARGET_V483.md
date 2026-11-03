# SYS-01.2-02 — Ciblage et changements de cible des sbires, V483

Les 16 fiches WORLD-{Blue,Red}_Minion_{Basic,Wizard,MechCannon,MechMelee}-AI-{CIBLE,AGGRO} reçoivent leurs sources natives, leurs points de code actuels et une question ouverte propre. Les références, critères, prérequis et données manuelles antérieurs restent conservés. Aucun code de gameplay ou asset modifié.

Référence : LoL 4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; build du 2014-11-17 à 17:46:45, fuseau et déploiement non établis ; catalogue 4.20.1 distinct. Projet F:/OpenLeague.

## Sources et consommateurs

Les huit INIBIN sont redécodés et leurs champs comparés aux relevés conservés. AcquisitionRange est absent pour les mêlée et canons : le rayon local 475 reste une valeur locale à qualifier. Il est présent et concordant pour les casters (700) et supers (600). GameplayCollisionRadius, PathfindingCollisionRadius, SelectionRadius et vision restent distincts ; l'égalité d'un rayon ne prouve pas la politique native de ciblage.

Minion.luaobj et Shared/Scripts/Minions.luaobj sont reparsés intégralement. Les instructions, constantes et SHA des 22 fonctions correspondent aux preuves conservées. TimerFindEnemies et FindTargetOrMove demandent notamment FindTargetInAcR ; leurs appels ne révèlent pas à eux seuls les priorités internes de ce helper. Les fonctions OnInit, OnTargetLost, OnCallForHelp et TimerAntiKite sont identifiées séparément de leurs producteurs et du scheduler natifs.

Les 101 observations Lua historiques sont relues, avec résultats attendus/observés concordants. Elles ne sont pas rejouées. Elles utilisent des états symboliques et des API moteur adaptées ; le choix effectif des scripts, les priorités natives, le producteur d'appel à l'aide et l'équivalence temporelle ne sont pas qualifiés.

Six ancres précises du code actuel sont ajoutées : échéance du scan, éligibilité des candidats, choix de la distance minimale, filtre de visibilité, affectation de cible et prochaine échéance, garde de provocation réservée aux camps. Les liens antérieurs sont conservés avec leur portée ; les anciens tests mentionnés dans leurs métadonnées restent hérités.

## Vérification actuelle : 96 scénarios

Un nouveau programme Rust est compilé et exécuté contre la bibliothèque core V476, après comparaison exacte de ses entrées et outils ainsi que des dépendances. Aucun nouveau cargo build du cœur n'est revendiqué. Binaire, commandes, codes de sortie, journaux et observations sont identifiés dans revision483_runtime_checks/CURRENT_MINION_TARGET.json.

Huit variantes × douze profils. La vraie navigation et la vraie fonction de visibilité sont utilisées. Le banc clone une instance issue d'une première vague réelle, puis affecte explicitement définition, type, équipe, identifiant et positions. Il ne prouve donc pas l'apparition naturelle des huit variantes. L'origine (2000,4700) est choisie sur un corridor sans buisson, vérifié sur la grille. Les attaques sont inhibées ; la position de l'acteur est rétablie avant chaque tick de la mesure de cadence. Santé et temps sont contrôlés.

| Profil | Attendu et observé |
| --- | --- |
| Deux ennemis à 100 et 200 | Sélection de celui à 100 |
| Cible précédente à 200 | Remplacement par celle à 100 au scan |
| Deux unités exactement à même distance | L'unité au plus petit identifiant est choisie dans cet ordre d'itération |
| Proche allié | Ignoré, ennemi plus loin retenu |
| Proche neutre | Ignoré, ennemi plus loin retenu |
| Proche mort | Ignoré, ennemi plus loin retenu |
| Identifiant précédent absent | Nouvelle cible valide acquise |
| Distance acquisition + rayon de cible 48 | Cible incluse à la frontière exacte |
| Distance supérieure de 1 à cette frontière | Cible non acquise |
| Rayon de vision de l'acteur contrôlé à zéro | Ennemi proche non visible et non acquis |
| Cible précédente et prochain scan à tick2258 | Conservée de2251 à2257, remplacée à2258 ; prochain scan2266 |
| Dégât de champion sur un allié de voie | Aucun réveil anticipé de l'acteur ; au scan2258, le plus proche ennemi est choisi |

La frontière d'acquisition est construite le long de X avec distances f32 exactes ; les autres orientations et arrondis ne sont pas couverts. Le cas d'égalité couvre deux unités, pas tous les mélanges joueur/unité ni toutes les priorités. Le test de visibilité manipule un modificateur de rayon ; il ne valide pas l'intégralité des buissons, murs, furtivité ou révélations. La protection des bâtiments est liée à son consommateur existant mais n'est pas réexercée dans ce banc.

## Appel à l'aide : limite précise

Dans damage_unit, le réveil de groupe est sous la garde camp présent. Le cas de voie testé possède camp=None : le dégât public apply_damage attribué à un champion ne réveille pas l'acteur avant son échéance. Cela délimite le chemin observé ; ce n'est pas une preuve d'absence universelle dans tout le jeu.

Le callback natif OnCallForHelp existe et les anciennes observations montrent des demandes de transition selon l'état et la cible. Le déclencheur effectif, les types de dégâts, rayons, filtres et interactions avec l'anti-kite restent inconnus. Aucun remplacement arbitraire de cette règle par la distance minimale locale.

## Contrôles, erreurs conservées et publication

Six copies de scripts altérées sont refusées : troncature, en-tête et octet final supplémentaire pour chacun des deux scripts. Les 17 sélecteurs nominaux et 18 sélecteurs invalides sont vérifiés ; le lecteur public refuse mauvais propriétaire d'inconnue, résolution indue et condition vide. Les 42 214 instructions sont comparées : 16 changent, 42 198 restent identiques. Critères, prérequis et anciennes inconnues inchangés.

Deux erreurs du collecteur sont conservées avant publication : le générateur avait remplacé une portion de dont_write_bytecode au lieu de l'affectation code ; puis il convertissait en entiers les clés de hash renvoyées comme chaînes par le lecteur INIBIN. Les assertions de contenu sont maintenues après correction. Aucun échec du programme Rust et aucune donnée native corrigée pour faire passer les contrôles. Sources et résumé d'erreurs : revision483_prepare_failure01.py, revision483_prepare_failure02.py, revision483_prepare_failures.json.

Les deux bases sont publiées puis relues indépendamment : 17 fiches par base, dont SYS-01.2-02 ; 42 606 états/notes, 23 historiques et 42 589 autres lignes du catalogue conservés exactement. Intégrité SQLite et lectures réelles de tâche/copie vérifiées. Les quatre registres sont contrôlés, pas seulement trois. Aucune case cochée.

## Livrables et travail restant

Modifiés : fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json, fidelity_unknowns_4_20.json, les deux bases du plan, coverage.json, completion_plan.json, resume_checkpoint.json, ai/CURRENT.md et ai/HANDOFF.md.

Nouveaux livrables : docs/reference_minion_behavior_sources/minion-target-v483.json, docs/fidelity_minion_target_v483.json et ce rapport. Producteurs, sauvegardes, observations et contrôles : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision483*.

Restent ouverts : helper et priorités natifs, montage des scripts, scheduler/anti-kite, producteur d'appel à l'aide, interruptions et autres cas de visibilité, ciblage en combat ordinaire. Attaques, suivi de voie, améliorations et présentation des sbires sont des lots distincts à poursuivre. Aucun jeu complet, GPU, audio ou serveur Riot lancé dans ce lot.

Le sous-inventaire des références au chargeur conserve 207 associations à préciser (WORLD179, MODE27, SYS1), 309 partielles et 24 exclusions dont12 audio. Ces nombres ne représentent pas l'avancement global du jeu. Le goal reste actif.

Ajouts : 48 liens natifs, 94 liens consommateurs, 6 nouveaux consommateurs, 2 sources et 16 questions ouvertes. 1235 fichiers directement épinglés. Graphe : 98640 sources, 2485 consommateurs, 25644 ouvertes, 5517 résolues avec historique.
