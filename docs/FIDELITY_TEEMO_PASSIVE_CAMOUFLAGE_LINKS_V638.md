# Teemo — Camouflage : sources et consommateurs V638

Date UTC : 2026-10-26T20:46:23.046256+00:00. Tâche SYS-01.2-02 sur F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct ; build indiqué 2014-11-17 17:46:45, fuseau et date de déploiement non établis.

## Résultat et portée

Trois fiches Teemo reçoivent 138 associations vers 46 sources natives et 60 liens vers 30 points de code. Le vrai moteur laisse Teemo visible dans les projections ennemies pendant 181 ticks d’immobilité sans action, y compris après plus de deux secondes supplémentaires dans la fenêtre observée. L’entrée en furtivité décrite n’est pas observée. Le bonus de sortie ne peut donc pas être qualifié par ce diagnostic. Aucun code de gameplay n’est modifié.

## Contrat et provenance

Le BuffData Camouflage est lié exactement à `game_buff_tooltip_Camouflage`, fontconfig ligne 1768 : immobile pendant **2 secondes**, Teemo devient furtif ; en quittant la furtivité, sa vitesse d’attaque augmente de **40% pendant 3 secondes**. La description du personnage ligne 4288 précise absence d’action et durée indéfinie de furtivité. CamouflageStealth, ligne 1769, indique l’état furtif. Ces textes donnent le contrat annoncé, pas le producteur serveur ni tous les cas d’interruption/révélation.

Le corpus sélectionné comprend 13 INIBIN, 22 Lua, 9 preloads, Teemo.ddf et fontconfig. Les identités et appartenances aux projets natifs sélectionnés sont vérifiées. Teemo.inibin pointe vers Camouflage et conserve une ancienne description d’augmentation de portée de vision. Passive1 et ses six marqueurs de niveau sont absents ; aucune valeur par défaut n’est inventée. La recherche large Camouflage trouve aussi Kha’Zix : ces textes sont hors contrat Teemo.

CharScriptTeemo.luaobj initialise uniquement Teemo_EagleEye.dds ; son preload cite notamment camouflage, camouflagecheck et traplimiter_teemo. CamouflageCheck a une initialisation vide. Le preload Camouflage référence camouflagecheck et camouflagestealth ; celui de CamouflageStealth référence camouflagebuff, globalstealthscreentint, camouflagecheck et teemocamouflagestealthtt. La chaîne de dépendances est réelle ; elle ne prouve pas son exécution ni la présentation de la teinte écran. Le fournisseur et l’exécution de globalstealthscreentint restent à qualifier au-delà du corpus sélectionné.

CamouflageBuff et TeemoCamouflageStealthTT portent exactement BuffName **CamoflagueBuff** et l’icône **BlindMonk_BlindingStrike.dds**. La faute est conservée, sans alias automatique ; l’icône ne devient pas une règle Lee Sin. Le nom TT et sa référence dans le preload ne suffisent pas à prouver le dispatch historique effectif sur Map10. Camouflage déclare PersistsThroughDeath et NonDispellable : métadonnées, pas politique de mort/réapparition exécutée.

Les 22 Lua sont entièrement lus, sans fonctions enfants. Huit initialisations rencontrent NEWTABLE : BantamTrap, BlindingDart, MoveQuick, les trois attaques Teemo, ToxicShot et ToxicShotAttack. Trois BuffData sont résolus exactement : Camouflage, CamouflageStealth et TrapLimiter. Le DDF contient huit lignes, dont deux liens de recharge de BantamTrap `@cooldownchampion`, coefficients textuels `35/31/27` et `31/27` ; aucune formule de Camouflage n’y est établie.

## Références communautaires

18 fichiers sont inspectés, sans exécution C#. CharScriptTeemo est vide. La recherche dans LeagueSandbox-Scripts ne trouve pas de producteur nommé Camouflage/Camoflague ; TeemoMoveQuick et TeemoToxicShot n’y apparaissent que comme appels W/E. Un fournisseur extérieur reste inconnu.

- Q contient un lancement de projectile commenté. ApplyEffects calcule dégâts et Blind, mais son invocation effective n’est pas démontrée par ce fichier.
- W appelle TeemoMoveQuick pendant 3s ; E installe TeemoToxicShot pendant 999999s. Les noms et durées d’appels ne prouvent pas les producteurs ni leurs effets.
- R comporte un commentaire annonçant 300s, mais programme 60 vérifications à 0..59s. Un champion ennemi déclenche dans un rayon de 120 ; la zone de 160 applique immédiatement des dégâts puis Slow pendant 4s. Durée native, stocks, piège destructible, poison, taux de ralentissement et suppression du plus ancien piège restent à qualifier. Ce contexte R est distinct de Camouflage.

## Diagnostic du moteur courant

Deux cas publics niveau 1 sur Map10 : attente puis attaque ; attente puis déplacement puis attaque. Teemo et Annie ennemie sont déplacés via commandes, avec cinq arrivées au total sans réordre. La navigation choisit les positions réelles (7534,9819336 ; 6934,2402344) et (7834,9819336 ; 6934,2402344). Terrain ouvert, flags 0, ligne de vue directe et distance initiale 300. Aucun objet acheté ; aucune position, XP, santé, dommage ou furtivité injectés.

Pour chaque cas, 181 ticks avancent sans commande pendant l’attente. Position et santé de Teemo restent constantes ; aucune destination, cible ou préparation d’attaque n’est active. Le diagnostic échantillonne l’état initial puis chaque tick : **364 observations** au total. Il lit visible_to, visible_point_to, snapshot_for ennemi, snapshot_for_atomic ennemi et snapshot_for propre. Ces lectures ne sont pas des actions de jeu. Le tick relatif 0 commence après la mise en place et les refus ; Teemo était déjà arrêté pendant le déplacement de son adversaire. Il ne représente donc pas une origine prouvée du timer natif. Les échantillons 59/60/61 vérifient la visibilité dans cette fenêtre, pas une transition native précisément synchronisée ; cette borne reste à qualifier.

| Cas | Échantillon | Présent chez l’ennemi, standard | Présent chez l’ennemi, atomique | Présent chez soi | Délai d’attaque exposé, ticks |
|---|---|---|---|---|---:|
| idle_then_attack | idle0 | True | True | True | 43 |
| idle_then_attack | idle59 | True | True | True | 43 |
| idle_then_attack | idle60 | True | True | True | 43 |
| idle_then_attack | idle61 | True | True | True | 43 |
| idle_then_attack | idle90 | True | True | True | 43 |
| idle_then_attack | idle180 | True | True | True | 43 |
| idle_then_attack | idle181 | True | True | True | 43 |
| idle_then_move_then_attack | idle0 | True | True | True | 43 |
| idle_then_move_then_attack | idle59 | True | True | True | 43 |
| idle_then_move_then_attack | idle60 | True | True | True | 43 |
| idle_then_move_then_attack | idle61 | True | True | True | 43 |
| idle_then_move_then_attack | idle90 | True | True | True | 43 |
| idle_then_move_then_attack | idle180 | True | True | True | 43 |
| idle_then_move_then_attack | idle181 | True | True | True | 43 |

Teemo reste dans les deux projections ennemies, notamment aux ticks 59, 60, 61, 90, 180 et 181. Le délai exposé reste 43 ticks. Six projectiles infligent chacun environ 39,875854 dégâts physiques ordinaires ; le calcul tient compte de l’armure et de la régénération de la cible, tolérance 0,002. Le diagnostic ne mesure pas une accélération après vraie sortie de furtivité, puisque l’entrée n’a pas été observée. Une attente finie de 181 ticks ne prouve pas une durée indéfinie.

54 commandes invalides ou sorts Teemo non pris en charge sont refusés sans mutation de l’instantané. Les projections d’un joueur inconnu renvoient None et les demandes de visibilité d’équipe/cible invalides sont refusées. Tous les personnages restent vivants au niveau 1 ; rangs et délais de sorts Teemo restent à zéro, sans boucliers ni contrôles. Les arbres Rust core ne contiennent pas de branche nommée Teemo/Camouflage/Camoflague ; les branches génériques de vision, statistiques, attaques et commandes sont inspectées séparément.

BUILD et RUN retournent 0. Le binaire est `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-teemo-passive-camouflage-probe.exe`, 6256640 octets, SHA-256 `1b9c9031d30b1a5fcbbc3b71ece64c8ecea93f9a59fef1ca45263b6f12ed87df`. Il utilise le vrai core de F:/OpenLeague en profil non-test ; identités/checksums Cargo alignés. 1158 entrées code/ressources et les artefacts précédents restent identiques.

## Correction de l’inspection

Une première inspection a échoué avec code 1 sur une assertion erronée selon laquelle les deux preloads Camouflage étaient vides. Les fichiers contiennent les dépendances détaillées ci-dessus. Une nouvelle inspection, dans `revision638_Teemo_inspection_preload`, vérifie ces listes et réussit. Le script initial reste conservé et son empreinte, assertion et motif sont enregistrés dans la nouvelle observation. Le diagnostic Rust n’a pas été modifié pour obtenir ce résultat ; il avait déjà réussi. Un champ Rust provisoire a été corrigé avant compilation et une recherche exploratoire avec glob Windows invalide a été relancée correctement ; aucun échec de build n’est attribué à ces lectures/préparations.

## Intégration vérifiée

PREPARE, CHECK, PUBLISH et AUDIT retournent 0 avant cette synthèse. 72 mutations d’association et quatre mutations du graphe sont refusées. Trois liens courts sont actualisés. Dans les deux bases, quatre destinataires sont vérifiés ; les 42603 autres lignes, 42607 états manuels et 23 historiques sont conservés. La synchronisation est idempotente.

Les trois questions propres, quatre dépendances, statuts, critères et propriétaires sont conservés. Index d’exigences, hiérarchie et registre des inconnues restent identiques à l’octet. Graphe : 99229 sources, 4991 consommateurs ; 4991 ancres exactes et empreintes des fichiers consommateurs vérifiées sans divergence. Cette revue ne constitue pas un nouveau recensement des octets de toutes les sources du graphe ; le corpus sélectionné et les entrées runtime ont leurs vérifications propres.

Fichiers actualisés : registres des tâches/sources/traces, association et preuve Teemo V638, coverage.json, completion_plan.json, resume_checkpoint.json, CURRENT.md et HANDOFF.md. Aucun stage/reset/commit.

## Travail restant et limites

1. Qualifier et produire le timer d’inactivité, les conditions d’admission, le seuil exact de 2s, ses réinitialisations et les transitions de furtivité.
2. Vérifier déplacement, attaques, sorts, dommages, interruptions et événements simultanés ; ne pas importer une politique moderne.
3. Qualifier les détecteurs, révélateurs, vision alliée/ennemie/partagée et spectator, buissons, obstacles, unités et tourelles ; vérifier l’absence de fuite dans les événements/projectiles et les deux projections.
4. Qualifier le dispatch de la variante TT et ses dépendances de présentation, dont la teinte écran, à partir de nouveaux consommateurs réels.
5. Produire et tester le bonus de 40% pendant 3s après une vraie sortie : calcul natif, cap, arrondis, expiration, rafraîchissement et retour au délai normal, niveaux et objets.
6. Vérifier mort/réapparition, reconnexion, déterminisme, puis HUD, VFX, audio, animations, rendu GPU et transport réseau. Aucun de ces parcours complets ni le serveur historique n’est exécuté ici.

Les limites V564/V606 et les autres inconnues restent ouvertes. Ni Teemo ni le jeu ne sont déclarés terminés.

Preuves privées : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision638_Teemo_discovery, revision638_Teemo_passive_probe, revision638_Teemo_inspection_preload, revision638_Teemo et revision639_trace_review. Association publique : docs/reference_requirement_trace_sources/teemo-passive-camouflage-links-v638.json ; preuve : docs/fidelity_teemo_passive_camouflage_links_v638.json. Scripts et générateurs archivés avec la livraison.

Suite : Continuer SYS-01.2-02 depuis revision639_trace_review/REVIEW.json. V638 Teemo / Camouflage : 46 fichiers natifs, 138 associations, 30 points de code et 60 liens. Tooltip natif : immobile2s puis furtivité ; description sans action et durée indéfinie ; sortie avec40% de vitesse d’attaque3s. Ancienne description portée de vision, CamoflagueBuff mal orthographié, icône BlindMonk et variante TT conservés sans déduire de dispatch. Vingt-deux Lua sans fonctions enfants, huit limites NEWTABLE, neuf preloads avec chaîne Camouflage/Stealth/Buff/varianteTT, trois BuffData résolus ; DDF huit lignes de recharge R, pas de passif. Dix-huit références communautaires, CharScript vide ; Q projectile commenté, W/E producteurs appelés non retrouvés dans le sous-arbre, R simplifié. Deux cas publics niveau1 : immobile181ticks puis attaque, ou déplacement puis attaque.364 échantillons de visibilité, six projectiles,54 refus atomiques,cinq arrivées sans réordre. Teemo reste visible à l’ennemi en projection standard et atomique, dont ticks59/60/61/181 ; pas de furtivité observée. Cadence43ticks,dégâts ordinaires39,875854 ; bonus de sortie non exercé. BUILD/RUN et inspection corrigée0 ; première assertion erronée de preloads vides conservée ; gameplay, états,cases,inconnues et preuves conservés. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Thresh. Goal actif.

## Sources et points de code sélectionnés

Les reçus JSON contiennent chemins complets, identités et appartenances RADS.

| Fichier | Identifiant de source |
|---|---|
| Teemo.inibin | OLS-3637b967-6fe4-5aba-a9fa-5c722a1b7599 |
| Teemo.ddf | OLS-ac0213ab-3383-5e55-ae6b-e7eb34e1dab0 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptTeemo.luaobj | OLS-2d8e4300-5152-5759-b588-32e9aba81cac |
| CharScriptTeemo.preload | OLS-adb163d4-1909-597f-a9bf-0f8280b570e8 |
| BantamTrap.inibin | OLS-e7bf416f-5285-5dbf-a33d-94b923fe27e6 |
| BantamTrap.luaobj | OLS-4a2ae38b-732f-5282-9cab-2938989de640 |
| BantamTrap.preload | OLS-7e8ee5ea-fcce-5955-b332-761271f886d6 |
| BantamTrapTarget.luaobj | OLS-e3718906-f711-57d7-a05d-da9f47c1df7d |
| BlindingDart.inibin | OLS-b84699d9-462f-58d5-aacc-7e2d9707180d |
| BlindingDart.luaobj | OLS-7abae1ef-c6a2-554b-8658-43c7c0d0ce81 |
| Camouflage.inibin | OLS-03423575-1f0a-56e8-9cda-dce164b56301 |
| Camouflage.luaobj | OLS-146b4ad8-fb71-55c6-ad67-96658cc7f3be |
| Camouflage.preload | OLS-89722712-77b6-512b-b5d1-af0a1144bde3 |
| CamouflageBuff.luaobj | OLS-19472152-497d-589b-887f-8a9a9b03cf5a |
| CamouflageCheck.luaobj | OLS-920bd0e6-558c-5e4e-9c80-e76e7541bcf8 |
| CamouflageStealth.inibin | OLS-306fbd86-050f-5bc9-af08-f08b0d498797 |
| CamouflageStealth.luaobj | OLS-cf1f97a3-1030-5e42-b660-d462897062bf |
| CamouflageStealth.preload | OLS-12193249-ca24-522c-8d48-7fe4a8973b49 |
| MoveQuick.inibin | OLS-a747dc20-c777-5b81-8066-d237f37afcae |
| MoveQuick.luaobj | OLS-28926ddf-60b6-59e3-9b64-9bfe4868970c |
| MoveQuick.preload | OLS-2acb3796-8f7c-5892-9d5c-11a5bde8f469 |
| TeemoBasicAttack.inibin | OLS-35369f85-d38d-5be2-950b-966b43aac886 |
| TeemoBasicAttack.luaobj | OLS-4aadb4d9-adb6-5e4d-ae45-d0b6300290a9 |
| TeemoBasicAttack2.inibin | OLS-2bc2d8ca-6507-5f2e-8572-b43f178653dd |
| TeemoBasicAttack2.luaobj | OLS-14017da5-62d5-53b4-9644-8feb5360aa7c |
| TeemoCamouflageStealthTT.luaobj | OLS-31bc6dc8-0c98-5692-bcef-9037020ee59e |
| TeemoCritAttack.inibin | OLS-29e43eb7-1d9f-525b-9cc3-4520210c2bf6 |
| TeemoCritAttack.luaobj | OLS-4b1a0367-cbd2-593e-8d7b-d623dcfb6dd1 |
| TeemoMoveQuickDebuff.luaobj | OLS-5d7527dd-7a7c-576d-aef0-3d6ae867f552 |
| TeemoMoveQuickDebuff.preload | OLS-c80c5569-b369-56cf-91d3-16e5f19ec49e |
| TeemoMoveQuickPassive.luaobj | OLS-75d8a88a-38ad-59c2-b597-c1278e5eef78 |
| TeemoMoveQuickPassive.preload | OLS-5b6a3ab5-b9c4-564d-b86e-3b71e1e3a5e3 |
| TeemoMoveQuickSpeed.luaobj | OLS-e6023717-42de-5eed-a8a7-f08915d30d40 |
| TeemoMoveQuickSpeed.preload | OLS-a9b3677a-14d2-5833-ad85-2d8cd5e93df4 |
| TeemoMushroomBuff.luaobj | OLS-ce867bc1-b9b4-5e60-b1f0-a76983a0a893 |
| ToxicShot.inibin | OLS-add823a6-2170-566d-8f3e-8406697e7297 |
| ToxicShot.luaobj | OLS-7748e683-c0d7-584a-a514-c224423753af |
| ToxicShot.preload | OLS-d7f9b736-aa9b-54fd-b35e-cdf16e17b989 |
| toxicshotapplicator.luaobj | OLS-51f7811f-0d60-5730-9b46-d6d9de8618cc |
| ToxicShotAttack.inibin | OLS-c960c65f-76be-58cd-98d3-8cda9a1c2311 |
| ToxicShotAttack.luaobj | OLS-e6a383ff-4778-5063-85c6-4755b35224d3 |
| ToxicShotParticle.inibin | OLS-5fa377c0-90f5-5cc6-acf2-6bd148fd76e5 |
| ToxicShotParticle.luaobj | OLS-3b3eef12-8ecb-53ad-bff3-77c71163c28e |
| TrapLimiter_Teemo.inibin | OLS-fb64f06f-a680-5628-8d2a-95136be5669b |
| TrapLimiter_Teemo.luaobj | OLS-8e7b59cb-5630-5b94-8fc4-65134155ff12 |

| Point de code | Rôle borné |
|---|---|
| crates/core/src/lib.rs:533 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/lib.rs:598 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/progression.rs:68 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/progression.rs:150 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/progression.rs:159 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/spells.rs:101 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/annie_w.rs:29 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/lib.rs:685 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/lib.rs:744 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/damage.rs:53 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:157 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/lifesteal.rs:4 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/regeneration.rs:32 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/regeneration.rs:10 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/world.rs:226 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/damage.rs:38 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:26 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/lifecycle.rs:16 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/lifecycle.rs:24 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:635 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:526 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/spells.rs:5 | current Teemo unprimed attacks,resources or spell-refusal boundary |
| crates/core/src/vision.rs:79 | current visibility or projectile boundary;not Camouflage producer |
| crates/core/src/vision.rs:95 | current visibility or projectile boundary;not Camouflage producer |
| crates/core/src/vision.rs:137 | current visibility or projectile boundary;not Camouflage producer |
| crates/core/src/vision.rs:208 | current visibility or projectile boundary;not Camouflage producer |
| crates/core/src/vision.rs:45 | current visibility or projectile boundary;not Camouflage producer |
| crates/core/src/vision.rs:48 | current visibility or projectile boundary;not Camouflage producer |
| crates/core/src/vision.rs:30 | current visibility or projectile boundary;not Camouflage producer |
| crates/core/src/attacks.rs:159 | current visibility or projectile boundary;not Camouflage producer |
