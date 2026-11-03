# SYS-01.2-02 — Vayne / Night Hunter, V647

Date UTC 2026-10-27T00:21:48.436057+00:00. Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau et déploiement non établis. Catalogue4.20.1 distinct.

V647 Vayne / Night Hunter : 13 sources natives, 39 associations, 20 points actuels et 40 liens de frontière. Le texte natif indique +30 de vitesse vers les champions ennemis proches ; R porte ce bonus à 90 selon son tooltip, sans qualification de son activation. Rayon, angle et politique de visibilité historiques restent inconnus. Aux niveaux 1/18, les déplacements publics vers, contre et latéralement à un ennemi visible restent à 330 de vitesse et 11 unités par tick. Témoin Garen Q distinct : 345 → 455,6 → 345, expiration au tick relatif 45. 60 refus sans mutation, 4952 ticks et un apport XP serveur explicite. BUILD/RUN 0, 1158 entrées conservées. Premier trajet inaccessible et première assertion Focus échouée conservés. Aucun code de jeu modifié, aucune case ou question fermée.

## Résultat et prérequis

Trois fiches CH-Vayne-PASSIF-SOURCE, CH-Vayne-PASSIF-SIMULATION-CONTRAT et CH-Vayne-PASSIF-SIMULATION reçoivent sources, preuves et instructions détaillées. SYS-01.2-02 reçoit la synthèse. Treize sources natives donnent39 associations ;20 points courants donnent40 liens sur les deux fiches de simulation. Ce sont des frontières de traitement et un témoin distinct, pas des implémentations de Night Hunter.

Phases, lots, trois questions propres et quatre dépendances sont conservés dans le reçu ; cette analyse ne les déclare pas achevés. Statuts, critères et acceptations restent conservés. Inconnues, identifiants et hiérarchie restent identiques octet par octet.

## Sources et limites

La découverte vérifie51 ressources natives :17INIBIN,18Lua,14preloads,unDDF et le fontconfig ;quatre candidats exclus et22 références communautaires distinctes. Taille/SHA et appartenance au manifeste RADS sélectionné sont contrôlés. L’inspection complète vérifie aussi deux fichiers Focus sous Ashe, sans les promouvoir comme producteur Vayne.

| Ressource reliée | Octets | SHA-256 |
|---|---:|---|
| Vayne.inibin | 3333 | e082fe41b80b27b1e2972f35d7106763f58be5a25bb789544147e34901428b9c |
| Vayne.ddf | 593 | d1c9b75158b0da806697d6bd7908190bdb9abdd3e8cf61609b8875405eacaac5 |
| CharScriptVayne.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| CharScriptVayne.preload | 495 | ddd4e71df807d85dfda73907f2e73dc32e6d1c4a9175f08c0db4033bb1cb689e |
| VayneHunted.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| VayneInquisition.inibin | 946 | d18dac66061f6338c0f0d3fb38a06ae4638dc1dcb4249060f659e4e8a7798527 |
| VayneInquisition.luaobj | 673 | 19bc25e2b6deebfa6f2a1b2a059513abb2ee21911f28079d79118736bee0a301 |
| VayneInquisition.preload | 93 | f7e6fc44ee0d0cb05cc5e3157fd862a1685ca4e3ed0a60eeed31aeea4dc84fec |
| VayneInquisitionSpeedPart.luaobj | 98 | 2cdc3fed81bc8ac5b5d8dbbde6f72b2e888facd452259e2050483d3d71c0aa89 |
| VayneInquisitionSpeedPart.preload | 104 | 21f6a27fd71df33fc57ea961aa56984aaa5f1823465619e20093834d421d0a88 |
| VayneInquisitionSpeedPartNormal.luaobj | 98 | 2cdc3fed81bc8ac5b5d8dbbde6f72b2e888facd452259e2050483d3d71c0aa89 |
| VayneInquisitionSpeedPartNormal.preload | 108 | 1f9f74d0c7784084fb178cf7d1bb9e0839dc14c4d317ff96058f8152983173ad |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |

PassLev1Desc1 vise game_character_passiveDescription_Vayne ; la traduction native indique30 de vitesse en avançant vers un champion ennemi proche. Passive1LuaName=Focus mais Passive1Desc contient une ancienne description critique d’Ashe. Les champs Passive1 et Passive1Level1..6 sont absents, pas zéro.

La première inspection affirmait à tort qu’aucun fichier Focus n’existait. Son assertion a échoué, sans publier de résultat. Le script initial reste conservé. La recherche corrigée enregistre Focus.inibin et Focus.luaobj dans DATA/Characters/Ashe/Spells, leur empreinte, leurs données et leur appartenance au manifeste. Cette présence ne qualifie pas le producteur, le rayon ou l’angle du passif Vayne.

CharScriptVayne et VayneHunted sont des chunks natifs vides. Les deux SpeedPart ne déclarent qu’AutoBuffActivateEffect vide ; leurs preloads nomment respectivement vayne_ult_speed_buf.troy et vayne_passive_speed_buf.troy. Ces dépendances ne valident ni rendu ni serveur. Les18chunks n’ont pas de fonctions enfants ; les limites NEWTABLE sur Inquisition et SilveredBolts restent ouvertes. Le DDF ne contient que deux coefficients Q/E peuplés parmi12 entrées :Condemn bonusAD0,5 et Tumble totalAD0,3/0,35/0,4/0,45/0,5. Aucun ne devient un rayon ou angle de détection.

Le tooltip R relie Effect4=90 au bonus Night Hunter amélioré. Son contexte natif donne8/10/12secondes et30/50/70AD aux rangs1/2/3. Cela ne qualifie pas R dans le moteur. Le R communautaire applique de l’AD et un buff fixe8secondes, sans bonus de vitesse ; les durées des rangs2/3 divergent du texte natif. Son commentaire ne prouve pas une exécution. Le CharScript communautaire est vide.

## Consommateurs actuels

Les recherches bornées Vayne/NightHunter dans le Rust et VayneHunted/InquisitionSpeedPart/NightHunter dans les scripts C# n’ont aucun résultat. Elles ne prouvent pas une absence universelle dans toutes les archives.

| Point courant | Ancre vérifiée |
|---|---|
| crates/core/src/lib.rs:533 | pub fn join( |
| crates/core/src/lib.rs:598 | pub fn command( |
| crates/core/src/lib.rs:685 | pub fn advance( |
| crates/core/src/lib.rs:744 | pub fn snapshot( |
| crates/core/src/progression.rs:68 | pub fn stats( |
| crates/core/src/progression.rs:150 | pub fn learn( |
| crates/core/src/progression.rs:159 | pub fn next_rank( |
| crates/core/src/progression.rs:131 | pub fn award_experience( |
| crates/core/src/spells.rs:101 | pub fn cast( |
| crates/core/src/annie_w.rs:29 | pub fn cast_at( |
| crates/core/src/movement.rs:19 | pub fn soft_cap( |
| crates/core/src/movement.rs:38 | fn effective_speed_with_slow( |
| crates/core/src/movement.rs:53 | pub fn movement_speed( |
| crates/core/src/ally_occupancy.rs:635 | pub(crate) fn advance_allied_motion( |
| crates/core/src/vision.rs:79 | pub fn visible_to( |
| crates/core/src/vision.rs:95 | pub fn visible_point_to( |
| crates/core/src/entity_facing.rs:34 | pub(crate) fn capture_facing( |
| crates/core/src/combat.rs:4 | pub(crate) fn advance_pursuit( |
| crates/core/src/lib.rs:392 | pub fn path( |
| crates/core/src/lib.rs:432 | pub fn nearest_walkable( |

movement.rs calcule la vitesse et ses modificateurs ; ally_occupancy.rs déplace les joueurs avec cette vitesse et TICK_RATE. Les chemins de vision et navigation sont identifiés séparément. capture_facing ne renseigne actuellement que Garen/Trundle ; le facing public de Vayne reste absent. Le cosinus diagnostic provient du déplacement mesuré, pas d’une orientation native qualifiée. Une recherche exploratoire sur le nom supposé movement_speed.rs a échoué ; le vrai fichier movement.rs a été inspecté, sans création de remplacement.

## Essais exécutés

Deux simulations Vayne niveaux1/18 rejoignent une zone navigable avec Annie par déplacements publics. Un seul award_experience(100000) prépare le niveau18 ; cela ne représente pas une progression naturelle. Aucune injection directe de position, vitesse, PV, rang ou horloge.

| Cas | Attendu du diagnostic | Observé |
|---|---|---|
| Vers un ennemi visible | mouvement public et mesure de vitesse | distance300→190,cosinus1,vitesse330,11unités/tick |
| À l’opposé | mesurer la vitesse sans direction favorable | cosinus−1,vitesse330,11unités/tick |
| Latéralement | mesurer une direction distincte | cosinus0 à environ−0,313,vitesse330,11unités/tick |
| Arrêt public | conserver état et mesurer vitesse dérivée | vingt mesures à330 |
| Garen Q distinct | effet public appris/lancé puis expiration | 345→455,6→345,expiration relative45ticks |

Soixante mesures Vayne en mouvement, ennemi visible dans chaque mesure ;20mesures immobiles. Les positions testées ne définissent pas le rayon historique ni l’angle requis. Le bonus natif30 n’est pas observé dans ces cas. R est refusé par l’apprentissage courant même au niveau18 ; aucun test d’activation R ni du bonus90 n’est revendiqué.

Le premier diagnostic a compilé(code0) puis échoué à l’exécution(code1) sur destination unreachable. Son journal ne permet pas d’attribuer précisément la branche ; exécutable, source et journaux sont conservés. Le second choisit des destinations accessibles avec le vrai pathfinding et contrôle leur direction ; les quatre trajets de préparation Vayne/Annie n’exigent aucune réémission de commande. Ce choix ne téléporte pas les joueurs.

Chaque cas Vayne comporte29 refus sans changement de snapshot :joueur/slot invalide, destination non finie ou inaccessible, apprentissages et lancements non pris en charge avant/après mouvement.58refus Vayne et2refus Garen(non appris/délai), soit60. Le témoin Garen mesure15frames en mouvement et les ticks relatifs44/45/46 ; il ne qualifie pas Night Hunter. Total4952ticks, dont992pour le témoin. Aucune mort ni fin de partie provoquée.

Binaire exécuté :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-vayne-night-hunter-navchecked-probe.exe ;6086656octets ;SHA-256 53a17239d46a747a0f6388ff89d5fac80fdd6f399d4a86eb7053ed00b02816be. Compilation du vrai F:/OpenLeague/crates/core/src/lib.rs, profile.test=false, verrou et checksums alignés sur Cargo.lock racine.1158 entrées moteur/ressources identiques avant/après. Aucun code de jeu ni asset modifié.

## Livraison et vérifications

| Étape | Code | SHA-256 journal |
|---|---:|---|
| BUILD | 0 | 580e3517dcf630119716f435596663a50ec811cd4be2fb54ec3c1c17981c37f6 |
| RUN | 0 | 24f62d015c28e30ba97ffb42224af57d008735e1a9c945e0fde3e8edf8c85049 |
| prepare | 0 | 7941f1846d7bc70addc47b02f6f6713c4f6739d35600a668d3928aa608516f44 |
| check | 0 | 486dfcec79cc7a1ae8bb62c733502b79ed9f93b3434df072ef69a2edc5e3d7b8 |
| publish | 0 | 9938e14b7d1de979327e8eab55dd33192ca077f41bad50f7b0ad4f25d71ff199 |
| audit | 0 | cd13eb445a8bea4246245b09b670e4fc3e09785b0d4788c1b76bbf1276f695f6 |

Découverte et inspection corrigée :code0. La préparation initiale du générateur de livraison a échoué à l’analyse syntaxique sur les offsets UTF-8 de l’AST ; corrigée dans un générateur distinct avant toute exécution de livraison. Ce premier script est conservé.

Les60 associations falsifiées et quatre graphes invalides sont refusés. Store.task/copy_text vérifie les instructions complètes, sources, questions et dépendances. Trois fragments courts changent ;42212 restent identiques. Les deux bases conservent42603 autres lignes de catalogue,42607 états manuels et23 historiques. Quatre destinataires sont actualisés ; intégrité et synchronisation Store idempotente vérifiées.

Revue indépendante :5127 ancres/empreintes de consommateurs exactes,99263sources enregistrées. Ce contrôle ne rehache pas toutes les sources historiques et ne mesure pas l’achèvement du jeu.

## Fichiers et preuves

Registres modifiés :docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json et docs/fidelity_sources_4_20.json. Reçu :docs/reference_requirement_trace_sources/vayne-passive-night-hunter-links-v647.json. Vérification :docs/fidelity_vayne_passive_night_hunter_links_v647.json. Bases :runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision647_Vayne_discovery\OBSERVATIONS.json. Diagnostic :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision647_Vayne_passive_probe_navchecked\OBSERVATIONS.json. Inspection :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision647_Vayne_inspection_alias_checked/OBSERVATIONS.json. Audit :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision647_Vayne/DELIVERY_AUDIT.json. Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision648_trace_review\REVIEW.json. Scripts, anciens échecs et journaux conservés sousF:\OpenLeague-work\Requirements_registry_4_20_2026-10-20.

Neuf copies privées de validation archivées en gzip avec comparaison SHA décompressée avant retrait des seuls doublons bruts ;gain logique2433326251octets. Reçu :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision647_Vayne/snapshot-archives/VERIFIED.json. Les bases actives, preuves, sources enregistrées et binaires sont conservés. Restauration explicite par revision647_restore_validation_snapshots.py, non exécutée après archivage.

## Manques et suite

Restent ouverts :producteur historique et application courante du bonus, rayon/angle et visibilité, sélection d’ennemi, entrée/sortie et arrêt, R90 et durées natives, ordre avec ralentissements/bonus/plafonds, mort/retour/déconnexion, réplication, HUD, icônes/particules, animation et audio. Aucune question ni case n’est fermée automatiquement. Le passif Vayne et le jeu ne sont pas déclarés terminés.

Continuer SYS-01.2-02 depuis revision648_trace_review/REVIEW.json. V647 Vayne publié et audité :13 sources natives,39 associations,20 points actuels/40 liens ;deux cas publics niveaux1/18,330 de vitesse et11 unités/tick,60 refus,4952 ticks,un apport XP explicite. Témoin Garen Q distinct345/455,6/345 expiration45ticks. Rayon,angle,visibilité et producteur historiques restent ouverts ;contexte R90 non activé. Deux Focus sous Ashe vérifiés,ne prouvent pas Night Hunter. Les premiers échecs de trajet et inspection sont conservés. V648 Velkoz PASSIF Organic Deconstruction :découverte terminée,82sources natives vérifiées,19références communautaires,six exclusions. Les répertoires C# Characters/Velkoz et Buffs/Velkoz sont absents ;36entrées DDF vides,f1 non résolu. Le texte natif distingue marques de sorts et rafraîchissement par attaques,expiration7secondes ;le tooltip de cible emploie attacks plus vaguement. Contrat encore au chargeur partagé :qualifier les consommateurs actuels et exécuter le diagnostic ciblé sans inventer de producteur. Découverte conservée dans revision648_Velkoz_discovery/OBSERVATIONS.json ;aucun test moteur V648 exécuté. Snapshots V647 archivés et restaurables explicitement par revision647_restore_validation_snapshots.py. Goal actif.
