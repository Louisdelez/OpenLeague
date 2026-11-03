# SYS-01.2-02 — Attaques et projectiles des sbires, V484

Les huit fiches WORLD-{Blue,Red}_Minion_{Basic,Wizard,MechCannon,MechMelee}-AI-ATTAQUE sont reliées aux sources natives, aux consommateurs actuels et aux observations d'un nouveau programme Rust. Chacune garde une question ouverte. Aucun code de gameplay, asset, critère, prérequis ou état manuel modifié.

Référence : LoL4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; build2014-11-17 à17:46:45, fuseau et déploiement non établis ; catalogue4.20.1 distinct. Projet F:/OpenLeague.

## Sources et valeurs

Les huit fichiers de personnages et 26 INIBIN d'attaques nommées sont redécodés. L'inventaire borné porte sur DATA/Spells/{nom}*Attack*.inibin et comprend BasicAttack, variantes supplémentaires et CritAttack. La présence et les champs de chaque candidat sont conservés ; sa sélection effective, ses probabilités et son exécution native restent non qualifiées.

Deux scripts Lua sont reparsés, avec les constantes, instructions et SHA des22 fonctions comparés aux preuves antérieures. Les liens portent sur TimerFindEnemies, FindTargetOrMove, OnCanAttack et TimerAntiKite. Les demandes de préparation/attaque du script ne prouvent pas les effets internes des helpers. Aucun callback Lua ancien n'est rejoué.

| Profil | Portée actuelle et native | Dégât de base actuel et natif | Cooldown local, ticks | Windup local, ticks | Vitesse projectile locale et SpellData |
| --- | ---: | ---: | ---: | ---: | ---: |
| Blue Basic |110|12|24|21|0|
| Red Basic |110|12|24|21|0|
| Blue Wizard |550|23|45|15|650|
| Red Wizard |550|23|45|15|650|
| Blue MechCannon |300|40|30|17|1200|
| Red MechCannon |280|40|30|27|1200|
| Blue MechMelee |170|180|44|19|0|
| Red MechMelee |170|180|44|19|0|

Les vitesses des26 fichiers candidats concordent avec leur profil. Cette égalité ne prouve pas quel fichier est choisi. AttackTotalTime et AttackCastTime sont absents des huit fichiers de personnage. Les nombres de ticks locaux sont reproduits par les transformations compatibles déjà relevées en V250 : cooldown=max(1,ceil(30×1,6×(1+offset))) et windup=ceil(30×1,6×(0,3+castOffset)). Ce calcul n'identifie pas le producteur historique et ne qualifie pas son arithmétique. Les champs AttackSpeed, offsets et probabilités sont conservés séparément ; aucun champ absent n'est remplacé par une prétendue valeur native.

Les supers déclarent IsMelee="No" dans les fichiers de personnage, alors que les sorts candidats ont MissileSpeed=0 et le code local ne crée pas de trajet de projectile pour eux. Ces données distinctes sont conservées sans déduire la sémantique native à partir du seul nom de type.

## Exécution actuelle

116 scénarios :13 pour chacun des8 profils, plus3 scénarios après lancement pour chacun des4 profils à projectile. Le nouveau programme est compilé et exécuté contre la bibliothèque coreV476 après revalidation de ses entrées, outils et dépendances ; aucun nouveau cargo build du cœur. Binaire, commandes, codes0, journaux et observations : revision484_runtime_checks/CURRENT_MINION_ATTACK.json.

La navigation réelle est chargée. Les instances sont clonées d'un vrai premier spawn puis configurées explicitement : définition/type, équipe, dégâts de base, santé, armure et positions. La cible est présélectionnée ; acquisition et mouvement sont inhibés. Les autres instances de vague sont retirées entre les ticks de mesure. Les contrôles de stun et de mort passent par grant_stun/apply_damage ; les cas de suppression retirent directement l'entrée d'entité et sont identifiés comme administratifs. Aucun rendu, son, partie ordinaire ou moteur Riot.

| Cas | Attendu et observé |
| --- | --- |
| Nominal | Deux impacts à la cadence locale, dégâts bruts sur armure0 |
| Portée exacte | Distance portée+rayon de cible48 incluse ; distance supérieure de1 refusée |
| Déplacement de la cible après préparation | Impact à l'échéance déjà calculée malgré déplacement à2000 |
| Dégâts de l'attaquant changés après préparation | Ancien dégât capturé conservé |
| Armure100 dès le début ou ajoutée après préparation | Dégât divisé par2 à l'impact |
| Cible de l'attaquant changée après préparation | Cible initiale touchée ; cible alternative intacte |
| Stun, mort ou suppression de la source avant lancement | Aucun impact observé |
| Stun ou mort après lancement, profils à projectile uniquement | Impact maintenu tant que l'entrée source reste présente |
| Suppression de la source après lancement, profils à projectile uniquement | Aucun impact observé |
| Cible morte ou supprimée avant impact | Santé reste0 ou entité reste absente ; pas de dommage supplémentaire observable |

Le délai de vol actuel est ceil(distance/vitesse×30), calculé à la préparation ; la libération est à début+windup et l'impact à libération+trajet. Les profils sans projectile ont trajet0. La portée est mesurée le long de X à distance f32 exacte. Les tests ne qualifient pas les autres directions/arrondis, collisions de projectile, homing, sélection native, toutes les modifications de stats ou tous les contrôles.

Les observations de santé pour cible morte/supprimée ne constituent pas une inspection exhaustive de la file Pending ni de son nettoyage visuel/réseau. Une source morte avec son entrée conservée diffère explicitement d'une source retirée. Les tests d'annulation après lancement concernent uniquement les quatre profils à projectile ; les mêlée/supers sont vérifiés avant leur résolution instantanée au terme du windup.

## Intégration et contrôles

Neuf ancres actuelles : portée, délai de vol, récupération, capture Pending, libération du projectile, garde de source, application d'impact, lecture de l'armure et interruption avant/après lancement. Les liens précédents restent conservés avec leur portée.

Huit refus de format : six copies Lua altérées et deux copies INIBIN invalides. Neuf sélecteurs nominaux et dix sélecteurs invalides vérifiés. Trois refus du lecteur public : mauvais propriétaire d'inconnue, résolution indue, condition vide. Les42 214 instructions sont comparées :8 modifiées,42 206 inchangées. Les critères et prérequis restent identiques.

Publication et audit indépendant :9 fiches par base, dont SYS-01.2-02 ;42 606 états/notes,23 historiques et42 597 autres lignes du catalogue conservés exactement ; intégrité SQLite et vrais chemins de lecture/copie vérifiés. Les quatre registres sont contrôlés. Aucune case cochée, aucune inconnue résolue.

## Livrables et limites

Nouveaux fichiers : docs/reference_minion_behavior_sources/minion-attack-v484.json, docs/fidelity_minion_attack_v484.json et ce rapport. Preuves, producteurs et sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision484*.

Modifiés : les quatre registres fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json et fidelity_unknowns_4_20.json ; les deux bases du plan ; coverage.json, completion_plan.json, resume_checkpoint.json, ai/CURRENT.md et ai/HANDOFF.md. Aucun code de jeu ou asset modifié.

Restent ouverts : producteur et formules de timing natifs, choix des variantes/crit, helpers et montage effectif, règles de portée/annulation historiques, modificateurs, cycle ordinaire et présentation. Le sous-inventaire du chargeur conserve199 associations à préciser (WORLD171,MODE27,SYS1),317 partielles et24 exclusions dont12audio ; ce n'est pas un pourcentage global d'achèvement du jeu. Suite : suivi de voie, améliorations temporelles et fiches SOURCE des sbires. Goal actif.

Ajouts : 50 liens natifs, 81 liens consommateurs, 9 nouveaux consommateurs, 2 sources et 8 questions ouvertes. 1260 fichiers directement épinglés. Graphe : 98642 sources, 2494 consommateurs, 25652 ouvertes, 5517 résolues avec historique.
