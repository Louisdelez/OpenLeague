# Monstres Map10 : sources, cycle de vie et limites d’acceptation — V504

25 octobre 2026 — `F:\OpenLeague` — tâche SYS-01.2-02. Référence conservée : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB, littéral de build 2014-11-17 17:46:45 ; fuseau et date de déploiement non établis. Le catalogue officiel 4.20.1 reste distinct.

## Résultat et portée

Sept fiches `WORLD-<définition>-ACCEPT` disposent maintenant d’associations précises vers leurs sources SOURCE, AI et PRESENT, les consommateurs actuels et une nouvelle exécution CPU contrôlée. Les 26 scénarios passent après correction du calendrier de la sonde. Les sept critères d’acceptation restent ouverts : cette preuve ne satisfait pas leur exigence de scénario ordinaire et de fidélité humaine.

Le code du jeu, les assets, les paramètres distribués et les binaires du launcher/client n’ont pas été modifiés. Les changements concernent les preuves, les quatre registres, les instructions des sept tâches et leurs références dans les deux bases du plan. Aucune case n’est cochée et aucune inconnue antérieure n’est résolue.

## Contrat conservé et prérequis

Critère existant, conservé intégralement dans le registre : « Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu. » Chaque fiche dépend toujours de `WORLD-<définition>-PRESENT`. Le reçu conserve les phases et lots réels d’`execution_plan_A_Z.json` ; leur présence n’est pas une preuve d’achèvement de leurs prérequis.

V504 compose exactement trois enfants par définition : SOURCE V495, AI V498 et PRESENT V503. La sélection refuse un enfant manquant, dupliqué, d’un autre propriétaire ou d’un type inattendu. Les 49 fiches/questions antérieures sélectionnées restent exactes : 7 SOURCE, 7 AI, 7 PRESENT et 28 facettes MODEL/TEXTURE/ANIM/AUDIO. Les sept exclusions sonores de World restent intactes ; un chargement de World ne devient pas une preuve de lecture audio.

## Sources et consommateurs

Les sources natives sont celles déjà identifiées et reliées dans V495, V498 et V503 : configurations des sept personnages, appartenance aux camps et callback de mort, attaques/sorts/Lua, modèles, textures, animations, graphes et références sonores/effets. Les liens natifs sont composés avec leurs sélecteurs exacts et leurs identités, sans fusionner les conclusions ou réexécuter les anciens tests. Les identités des reçus et de leurs entrées sont revérifiées dans V504.

Huit ancres nouvelles précisent les chemins courants réellement exécutés ou traversés :

- `crates/core/src/world.rs` : observation d’un camp entièrement mort, programmation et échéance de réapparition, nettoyage de mort et retrait du cadavre.
- `crates/core/src/lib.rs` : dispatch public `command`, chemin `Move` via `dynamic_path`, validation de cible `Attack`, garde terminale d’`advance`.

Les consommateurs hérités conservent les lecteurs de définition, IA, dégâts/récompenses et présentation avec leurs portées partielles. Le reçu précise pour chaque ancre sa ligne, son aiguille, son rôle, le fichier source et son SHA. Les 398 associations natives ajoutées sont des occurrences de liens composés, pas 398 ressources nouvelles ni 398 comportements terminés. De même, les 720 liens de consommateurs ajoutés incluent les huit références de SYS-01.2-02 ; ils ne représentent pas 720 fonctions nouvelles.

## Exécution actuelle et montage du scénario

Sonde Rust CPU exécutée contre le vrai `Simulation`, la navigation distribuée et `map10_world.json`. Les unités proviennent du scheduler normal des camps ; aucun acteur cloné n’est inséré. Les définitions NPC et leur IA restent inchangées, toutes les IA avancent normalement.

Le joueur est Annie, rejoint depuis son vrai spawn. Pour survivre au scénario, sa définition de santé est portée à 1 000 000 dans la seule mémoire de la simulation. Une première attaque utilise ses dégâts ordinaires et reste non létale. Pour obtenir ensuite la mort dans un temps contrôlé, sa définition de dégâts est portée à 1 000 000, toujours en mémoire seulement. Le déplacement et toutes les morts positives passent par les commandes publiques Move/Stop/Attack ; aucun dégât létal direct n’est injecté. Le seul appel direct de dégâts vise le refus d’une valeur négative et le refus d’une seconde atteinte sur un mort.

Deux sauts d’horloge bornent l’apparition initiale et la réapparition. Les morts, l’approche, le combat, le nettoyage du cadavre et l’attente d’un camp partiellement vidé avancent par ticks normaux. La fin est réglée par affectation directe de winner, pas par destruction ordinaire d’un Nexus. Ces choix de montage empêchent de présenter cette sonde comme une partie ordinaire.

| Définition | Camps testés | Équipes | Scénarios réussis |
|---|---|---|---:|
| TT_NGolem | 2, 5 | 0, 1 | 4 |
| TT_NGolem2 | 2, 5 | 0, 1 | 4 |
| TT_NWolf | 3, 6 | 0, 1 | 4 |
| TT_NWolf2 | 3, 6 | 0, 1 | 4 |
| TT_NWraith | 1, 4 | 0, 1 | 4 |
| TT_NWraith2 | 1, 4 | 0, 1 | 4 |
| TT_Spiderboss | 8 | 0, 1 | 2 |

Les 13 couples définition/camp couvrent les sept camps et les deux équipes. Le camp du boss est singleton : le contrôle de camp partiellement vidé est non applicable et reste `null` dans ses deux observations.

## Attendu et observé

| Contrôle | Attendu du contrat courant | Observé |
|---|---|---|
| Apparition | Aucun membre au tick précédent, membres configurés à échéance, équipe neutre 2, santé complète | 26 cas conformes ; tick 3000 pour les camps mobiles, 18000 pour le boss |
| Cible cachée et inconnue | Refus explicite, pas d’admission de l’ordre | 26 refus `target not visible` et 26 refus `unknown target` |
| Dégât invalide | Refus de la valeur négative, santé inchangée | 26 refus `invalid damage` |
| Approche | Déplacement depuis spawn par navigation publique jusqu’au camp, visibilité acquise | 26 approches Move/Stop réussies, sans téléportation |
| Première attaque | Windup/projectile numérique et baisse de santé non létale avec AD ordinaire | 26 cas conformes ; projectiles numériques du joueur observés, pas preuve d’un rendu NPC |
| Réaction NPC | Échéance d’attaque du membre sélectionné avancée et santé du joueur diminuée | 26 cas conformes ; dans un groupe, la perte de santé n’est pas attribuée exclusivement à ce membre |
| Contrôle avant mort | Stun public pour les mobiles ; refus explicite de la politique Boss non qualifiée | 24 stuns mobiles présents puis nettoyés ; 2 refus Boss avec état sérialisé inchangé |
| Mort par attaque publique | Santé zéro, cible/path/destination/stuns/slows nettoyés, retrait à mort+90, pas de respawn individuel | 26 cas conformes ; ordre sur mort et seconde atteinte refusés |
| Retrait du cadavre | Présent à mort+89, absent à mort+90 ; cible ensuite inconnue | 26 cas conformes |
| Camp partiellement vidé | Survivants et identités conservés, aucune nouvelle unité après le délai individuel | 24 cas conformes, IA active ; 2 cas boss non applicables |
| Camp entièrement vidé | Scheduler observe la fin, attend son délai puis crée des IDs nouveaux à santé pleine | 26 cas conformes, absence à échéance−1 puis présence à échéance ; délais courants 1500 ou 9000 ticks |
| Garde de fin | Après winner direct, 100 advances sans changement du tick/des unités/champs de contrôle ; ordre refusé | 26 cas conformes, `match ended` ; transition Nexus non testée |

Les récompenses avant/après sont enregistrées, mais V504 ne les compare pas à une politique serveur historique. Les refus du stun Boss démontrent le comportement local explicite ; ils ne prouvent pas une immunité de LoL 4.20.

## Échec initial et reprise

Premier essai conservé : compilation 0, processus Rust 101, wrapper Python en échec. Le premier cas attendait deux membres réapparus et en observait zéro. Après la dernière mort, l’attaque du joueur intervient après `advance_world` dans le tick ; la sonde sautait directement à l’échéance sans laisser le scheduler observer le camp vidé. Celui-ci programmait alors relativement au temps déjà sauté.

La reprise ajoute une passe normale après la dernière mort avant le saut d’horloge. Le boss ayant déjà avancé pour nettoyer son cadavre, son horloge n’est pas reculée. Le reçu enregistre l’échéance attendue et `scheduling_pass_completed_by`. Aucun changement de production : le comportement du scheduler est désormais respecté par la sonde. L’ancienne source, l’exécutable, les entrées, les sorties et le journal de panique sont conservés dans `revision504_runtime_checks`. La reprise distincte, compilation 0 et exécution 0, est dans `revision504_runtime_checks_retry`.

Deux exécutions de sonde sont comptées : une échouée et une réussie, contenant 26 scénarios complets. L’échec n’est pas compté comme un cas réussi. Les 26 lignes du journal de cas terminés sont comparées exactement au JSON d’observation final.

## Identités et commandes

Bibliothèque core réutilisée de V476 après vérification de ses entrées et du toolchain actuels : `revision476_runtime_checks/cargo-target/debug/libopenleague_core.rlib`, 278165670 octets, SHA256 `2b40dccfd61b5a50cbf1836aa0c48487fdba6fc2a51124eff33369ee4de2352c`. Elle n’est pas recompilée dans V504. Les deux sondes sont compilées séparément avec rustc et cette bibliothèque ; commandes complètes et codes dans PROBE_COMPILE_EXIT/PROBE_RUN_EXIT de chaque tentative.

Sonde réussie : `monster_lifecycle_probe.exe`, 5954560 octets, SHA256 `ce37b51b0d7be7fecb68ee69c1b4ae7f62c3d0fb8be541f1ecb1c7d4737fd57d`. Observation finale : 1403656 octets, SHA256 `a1aa23276a0c54d754c564d3dcc0243760847356d73fdc2b07f788cc63e71c9c`. Reçu de runtime : CURRENT_MONSTER_LIFECYCLE.json, 251208 octets, SHA256 `ecaa985d752e7cf4b4bcba3a879313b901468230faa1035d37c53a61bc386a40`.

Commandes effectivement exécutées avec Python `-X utf8 -E -u -B` : wrappers `revision504_runtime.py`, puis `revision504_runtime_retry.py` ; `revision504_delivery.py prepare`, `revision504_check.py`, puis `revision504_delivery.py publish` et `audit`. Les identités de l’interpréteur, des scripts, des binaires, bibliothèques, logs, ressources et entrées sont conservées dans les reçus, puis reprises dans EXECUTION_ENVIRONMENT.json. Le contrôle candidat relit 42214 instructions ; sept changent et les 42207 autres restent exactes. Il vérifie également 6 refus de composition/cas, 9 sélecteurs invalides et 3 refus publics de propriété/statut/condition des inconnues.

## Ce qui manque encore

- Un scénario de client ordinaire sur les binaires et ressources identifiés, avec sélection, entrées réelles et progression sans les réglages de la sonde ; observation visuelle et sonore, comparaison à la référence, fidélité humaine.
- Qualification historique des règles de mort/réapparition, horloges, récompenses, acquisition/cible/poursuite/reset/contrôles et comportements propres au boss. Les constantes locales et des champs natifs présents ne reconstituent pas le serveur original.
- Fournisseur et montage effectifs, overlays, choix et activation des variantes/particules ; deux basenames encore non retrouvés dans DATA lors de V503 ne sont pas déclarés absents de tout le jeu.
- Limites graphiques V499–V503 : poses/matrices et provenance du producteur, alpha/mips, quaternions non unitaires et interpolation, horloges BLND, quatre clés terminales, HUD/orientation, projectiles/effets NPC réellement rendus.
- Chaînes sonores des sept monstres, événements/médias effectivement produits, routage/mixage/locale ; World conserve sa référence historique hors portée audio. Aucun son n’est inventé pour masquer cette lacune.
- Réseau, picking du client, GPU, audio, moteur historique et transition normale de victoire non exécutés par cette sonde.

Ces limites sont liées à sept nouvelles questions ouvertes propres aux fiches ACCEPT et aux questions héritées conservées. Aucune absence d’asset n’est déduite de la seule absence de preuve d’exécution.

## Fichiers livrés

Rapport : `docs/FIDELITY_MONSTER_LIFECYCLE_V504.md`. Reçu public : `docs/reference_monster_behavior_sources/monster-lifecycle-v504.json`. Preuve : `docs/fidelity_monster_lifecycle_v504.json`. Registres : fidelity_sources_4_20, fidelity_requirement_trace_4_20, completion_tasks_2026-10-20 et fidelity_unknowns_4_20. Métadonnées de couverture/reprise : coverage, completion_plan, resume_checkpoint, CURRENT et HANDOFF. Les deux bases reçoivent uniquement les données/instructions documentaires des sept fiches et de SYS-01.2-02, après contrôle de conservation des états/notes/historiques.

Sources et commandes de travail : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision504*`. Les fichiers historiques restent disponibles et ne sont pas remplacés par la reprise.

Bilan vérifié : 398 liens natifs, 720 liens consommateurs, 8 ancres, 4 sources, 7 questions ouvertes, aucune résolution. 2108 identités revérifiées. Graphe : 98695 sources / 2595 consommateurs / 25823 questions ouvertes / 5517 résolues avec historique. Deux bases : 8 lignes documentaires actualisées chacune, 42598 autres lignes exactes ; 42606 états/notes et 23 historiques conservés, intégrité OK. Préparation/candidat/publication/audit : codes terminaux 0 observés. Runtime : premier Rust 101 conservé, reprise 0 et 26 cas complets ; deux compilations de sonde 0. Sous-inventaire : 28 à reprendre, 473 partielles, 39 exclusions ouvertes dont 27 audio ; ce ne sont pas des pourcentages de jeu terminé.
