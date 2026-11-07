# SYS-01.2-02 — Ziggs / Short Fuse, V656

Date UTC 2026-10-27T03:55:09.151253+00:00. Référence PUBLIC4.20.0.315, EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau et déploiement non établis. Catalogue4.20.1 distinct.

V656 Ziggs / Short Fuse : 14 sources natives, 42 associations, 22 points actuels et 44 liens de frontière. Texte natif : recharge de 12 secondes, réduction de 4 secondes par compétence, dégâts à 150% sur structures. Douze attaques publiques sans supplément magique aux niveaux 1/18 et avec 0/20 AP. Deux contrôles Annie Q distincts réussis. 118 refus publics sans mutation, 13272 ticks, huit apports XP et trois achats publics. BUILD/RUN corrigés 0 ; premier RUN 101 conservé, erreur de régénération dans le diagnostic corrigée sans changer le moteur. 1158 entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

## Intégration et prérequis

Les trois fiches CH-Ziggs-PASSIF-SOURCE, CH-Ziggs-PASSIF-SIMULATION-CONTRAT et CH-Ziggs-PASSIF-SIMULATION reçoivent sources, preuves et instructions complètes copiables. SYS-01.2-02 reçoit la synthèse. Quatorze ressources donnent42associations ;22points courants donnent44liens sur les deux fiches de simulation. Tous restent entry_boundary_only, provides_feature_consumer=false et gameplay_accepted=false.

Trois questions propres et quatre dépendances sont préservées. Les prérequis de phase/lot sont consignés sans être déclarés accomplis. Inconnues, identifiants et hiérarchie restent identiques octet par octet ; statuts, critères, acceptations et états manuels restent inchangés.

## Sources et instructions de reprise

74ressources natives et29références communautaires inspectées, neuf exclusions conservées. Tailles, SHA et appartenance au manifeste RADS sélectionné vérifiés. Le lecteur conserve sa racine historique E:/OpenLeague ; les références communautaires restent distinctes du serveur original.

| Ressource sélectionnée | Octets | SHA-256 |
|---|---:|---|
| Ziggs.inibin | 2415 | 75b525f7279444d9f630c9c0d7f5e386f12ed6605e295ff58f955cd3cdbc2d0a |
| CharScriptZiggs.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| CharScriptZiggs.preload | 222 | b339140c11c4f04be87dc6b53bc4ac43f0c7724d7c26c5d77f8e1bcb9d0eb278 |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |
| ZiggsPassiveAttack.inibin | 1404 | 3b46dba75fba5ca8a0d0716ff74b88258bf16b4998c1d5040e767db7be4f8612 |
| ZiggsPassiveAttack.luaobj | 499 | 0449d2504f06450fcb6c1e5717f700f7dbec24869d025da997f866d7e337a4e0 |
| ZiggsPassiveAttack.preload | 101 | ee0b8dcf082ef598ac39855825dccf8042e9bfe7d6ae81a180f8d46e48a74d7d |
| ZiggsPassiveBuff.inibin | 1112 | 8bd41f901966ff38c03484d632b3335e369129169f6172067814f07fe692a0df |
| ZiggsPassiveBuff.luaobj | 416 | ab5a269394eecbcd73c46d47903833c9f6fbfca9867a4d40e8863f62a7f45bf4 |
| ZiggsPassiveBuff.preload | 91 | 7c818a304e3d4a4f95a8103609b91b0b489608207c7d7e8f3d2d2cabff0f0fe9 |
| ZiggsShortFuse.inibin | 804 | 4bcc120f25083fa264411270a99e33dda0e0eb2a63c0dea29625136e86f69f4e |
| ZiggsShortFuse.luaobj | 710 | e664554ddcf1bb1d920770271221de55d09b2a79710a421aaec32e8210656b2c |
| ZiggsBasicAttack.inibin | 1405 | 91b0b5896536c63c62a15a02d9aca0d7e38a1b3d55b9e03c71103b1955794ff7 |
| ZiggsBasicAttack.luaobj | 167 | 10951de2b5d537716ff2adff5b5f177aa9e3a8a126103b3e0589c4b62d373191 |

V656 Ziggs / Short Fuse : 14 sources natives, 42 associations, 22 points actuels et 44 liens de frontière. Texte natif : recharge de 12 secondes, réduction de 4 secondes par compétence, dégâts à 150% sur structures. Douze attaques publiques sans supplément magique aux niveaux 1/18 et avec 0/20 AP. Deux contrôles Annie Q distincts réussis. 118 refus publics sans mutation, 13272 ticks, huit apports XP et trois achats publics. BUILD/RUN corrigés 0 ; premier RUN 101 conservé, erreur de régénération dans le diagnostic corrigée sans changer le moteur. 1158 entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

Objectif restant : qualifier Short Fuse sur la référence 4.20 et relier son producteur réel. Ziggs.inibin déclare Passive1LuaName=ZiggsPassiveBuff et Passive1Icon=ZiggsPassiveReady.dds. Passive1Name et PassLev1Desc1 lient les textes exacts ; Passive1, Passive1Desc et Passive1Level1..6 sont absents, pas zéro. Le BuffData.DynamicTooltip de ZiggsPassiveBuff décrit la prochaine attaque ordinaire, toutes les 12 secondes, avec @f1@ (+@f2@) dégâts magiques supplémentaires, 150% de dégâts sur structures et une réduction de 4 secondes par compétence. Les producteurs f1/f2, la progression par niveau et le coefficient AP restent à établir.

Sources : 74 ressources natives, 29 références communautaires et neuf exclusions conservées. 29 chunks Lua entièrement lus, sans fonctions enfants ; 17 limites du lecteur NEWTABLE conservées. Le CharScript est vide. Les trois Lua passifs contiennent des constantes de buff, icône, persistance et skins ; ZiggsShortFuse mentionne aussi ZiggsPassive.troy et les attaches Bomb/Bomb_b. Ce sont des constantes inspectées, pas des globals interprétés avec succès ni des callbacks du serveur original. Le preload du personnage référence ziggspassivebuff, apbonusdamagetotowers et ziggsshortfuse. Aucun DDF n'apparaît dans le périmètre découvert. Le texte ZiggsShortFuseCooldown existe, sans fichier de même nom dans ce périmètre : ne pas inventer ce fichier.

Conserver séparément BuffData et SpellData : ZiggsPassiveBuff.inibin a le bon tooltip de buff, mais ses champs SpellData renvoient à Disintegrate avec coefficient 0,6000000000000001 et valeurs 80/125/170/215/260. ZiggsShortFuse.inibin a le bon tooltip de buff, mais ses champs SpellData renvoient à ZiggsW avec coefficient 1.0 et valeurs 55/95/135/175/215. Ces champs ne sont pas établis comme formule du passif. ZiggsPassiveAttack conserve cinq Effect1 à 12.0000, un coefficient 0 et des textes tooltip/levelup PLACEHOLDER ; la description et le nom parlent bien de Short Fuse. Ne pas transformer ces vestiges en formule native de dégâts ou en preuve de rendu complet.

Les recherches bornées dans Rust (Ziggs, ShortFuse, Short Fuse) et dans les scripts C# communautaires (ZiggsPassive, ZiggsShortFuse, Short Fuse) ne trouvent aucun producteur. Le CharScript communautaire est vide ; ses Q/W/E/R simplifiés ne remplacent pas le passif. Cette recherche ne démontre pas une absence dans toutes les archives ou communautés. Les sources, icônes et profils présents restent distincts de leur implémentation.

Diagnostic courant : quatre simulations Ziggs niveau 1/18 avec AP 0/20 obtenue par achat public 1052, contre Annie18 ; deux simulations distinctes Annie1 contre Ziggs18 avec AP 0/20. Vraie navigation et monde Map10. Huit award_experience serveur préparent les niveaux ; douze trajets Move/Stop publics sans réémission et trois achats publics réussissent. Aucune position, horloge, statistique, rang ou PV n'est injecté directement.

Trois attaques Ziggs par cas : premier impact, second à 46 ticks au niveau1 ou 34 au niveau18, troisième à 380/378 ticks après le premier. Les snapshots 359/360/361 sont conservés. Chaque attaque est reliée au windup puis au projectile ordinaire et à son impact. Les douze pertes correspondent à AD*100/(100+armure) après régénération du tick, avec résidu inférieur à 0,004. Les variantes AP donnent les mêmes dégâts physiques et aucun supplément magique. Attendre plus de 360 ticks ne prouve pas l'expiration d'une recharge native lorsqu'aucun effet n'a déclenché. Disponibilité initiale, consommation et recharge du passif restent non qualifiées.

Les commandes Learn/Cast/CastAt de Ziggs, les slots invalides, joueur inconnu et attaque de soi sont refusés sans mutation : 108 refus. La réduction de recharge par compétence ne peut pas être qualifiée par un sort refusé. Le multiplicateur sur structures n'est pas exercé. Deux contrôles distincts apprennent et lancent publiquement le Q d'Annie : 80/96 dégâts bruts avec 0/20 AP, coût60, délai8ticks et recharge120ticks ; projectile et impact magique observés contre RM30. Dix refus supplémentaires (cibles absente, soi, inconnue et relances pendant lancement/recharge) conservent les snapshots. Ces contrôles ne valident pas Short Fuse ni l'exactitude native complète d'Annie.

Échec et correction conservés : le premier binaire compile avec code0 puis retourne101 dans le contrôle Annie Q ; le script enveloppant retourne1. Le diagnostic appliquait à tort la régénération avant les dégâts et plafonnait des PV déjà pleins. Simulation.advance exécute Annie Q avant la régénération et les attaques ordinaires après. Le nouveau binaire vérifie PVfinal=min(PVavant-dégâtsMagiques+régénération,PVmax). Attendu/observé identiques : 1822,9713134765625 pour 80 bruts et 1810,66357421875 pour 96 bruts, à partir de 1884,4000244140625 PV. L'ancienne erreur vaut environ0,10972 PV. Sources, journaux et ancien binaire restent conservés ; aucun code du moteur n'a été changé pour réussir le contrôle. Nouveau BUILD/RUN0, 13272 ticks au total, dépendances/checksums alignés sur Cargo.lock et 1158 entrées inchangées.

À compléter : déterminer f1/f2, progression et AP, dégâts et mitigation, cible autorisée, moment exact de consommation (lancement ou impact), disponibilité initiale, recharge12s, réduction4s pour chaque compétence/toggle et minimum de recharge. Qualifier le multiplicateur150% selon type de structure et son interaction avec le bonus AP générique des tours. Tester annulation, critique, esquive/blocage, boucliers, pénétration, changements de cible, mort/respawn et reconnexion. Relier séparément état réseau/sauvegarde, icône prête/recharge, HUD, particules, animations et audio. Aucun rendu, audio, réseau ou serveur historique n'est exécuté ici. Préserver trois questions, quatre dépendances, critères, preuves, notes et états manuels. Ce lot relie les sources aux frontières actuelles sans terminer Ziggs ni le jeu.


## Consommateurs réels

| Point courant | Ancre exacte |
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
| crates/core/src/attacks.rs:141 | fn attack_target_valid( |
| crates/core/src/attacks.rs:157 | pub(crate) fn advance_attacks( |
| crates/core/src/attacks.rs:26 | pub fn windup_ticks( |
| crates/core/src/lifesteal.rs:4 | pub(crate) fn basic_attack_hit( |
| crates/core/src/damage.rs:53 | pub fn apply_damage( |
| crates/core/src/damage.rs:38 | pub fn mitigate( |
| crates/core/src/penetration.rs:9 | pub(crate) fn penetrated_defenses( |
| crates/core/src/regeneration.rs:10 | pub fn regeneration_rates( |
| crates/core/src/regeneration.rs:32 | pub(crate) fn advance_regeneration( |
| crates/core/src/shop.rs:261 | pub fn buy_item( |
| crates/core/src/annie.rs:45 | pub(crate) fn cast_annie( |
| crates/core/src/annie.rs:73 | pub(crate) fn advance_annie( |

Le profil d'attaque courant est lié aux INIBIN Ziggs et ZiggsBasicAttack. Commandes, achat, statistiques, windup, projectile, impact physique, mitigation et régénération sont exercés. Les points Annie Q servent au contrôle magique distinct. Aucun point n'est promu comme producteur du passif Ziggs. La réduction par compétence et les structures ne sont pas qualifiées.

## Résultats attendus et observés

| Niveau Ziggs | AP | Impacts ordinaires | Ticks |
|---:|---:|---:|---:|
| 1 | 0.0 | 3 | 2341 |
| 1 | 20.0 | 3 | 2341 |
| 18 | 0.0 | 3 | 2337 |
| 18 | 20.0 | 3 | 2337 |

Attendu courant : dégâts physiques ordinaires selon AD/armure, indépendants de l'AP dans ces cas ; contrôle Annie Q selon80+0,8AP et RM30. Observé :12attaques, résidu inférieur à0,004, aucun bonus magique ; contrôles Annie80/96bruts et PV finaux conformes. Le second impact survient à46/34ticks et le troisième à380/378ticks. Snapshots359/360/361conservés ; pas d'acceptation de recharge native sans premier déclenchement.

108refus Ziggs et10refus Annie conservent les snapshots. Douze trajets publics sans réémission. Huit apports XP serveur et trois achats publics explicitement tracés. Les contrôles Annie prennent chacun1958ticks, soit13272ticks au total. Aucune injection directe de position, horloge, rang, statistique ou PV.

Le premier contrôle a échoué sur le calcul attendu de régénération d'Annie, après une compilation réussie : RUN101 et wrapper1. Il reste dans revision656_Ziggs_passive_probe avec son binaire. La version orderchecked utilise l'ordre réellement observé dans Simulation.advance : Q avant régénération, attaques ordinaires après. Le moteur est inchangé. L'inspection et le nouveau diagnostic pinent les fichiers de l'échec initial.

Binaire corrigé F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-ziggs-short-fuse-orderchecked-probe.exe ; 6094848octets ; SHA-256 0dad4a3ab220a06e57d336f7e5c07d6a5590e4a94f33af96b934d04657243d94. Compilation du vrai F:/OpenLeague/crates/core/src/lib.rs avec profile.test=false ; dépendances/checksums alignés sur Cargo.lock.1158entrées moteur/ressources identiques avant/après. Aucun code de jeu ni asset modifié.

## Vérification de livraison

| Étape réussie | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 6b0e32377b7206cc2dfe6ee43b8c2b9d399cd93f315974fe39816fa8c42bb51f |
| RUN | 0 | af960afd9b65a44596374239eb1f0ce6fe5329717cbfcc8d3419d685d03a58f0 |
| prepare | 0 | e8516d4936c05425d5f743ff69b8551993ab0422a9f3aeaf0d84374b50d8a731 |
| check | 0 | 42174193aec07d9449cd7e879e00acc6fd71355b0114181ff3fe4c5b2170f866 |
| publish | 0 | 02f68bd3fc1734ffcf14c5db25652971a2dd97adbee0f74fde5fb16f65d45f7c |
| audit | 0 | 3310ff946a4ae59cb26ece2926cf590facb737ae91884464b001133ec3d22933 |

Découverte, inspection, BUILD/RUN corrigés et quatre étapes de livraison réussis.60associations falsifiées et quatre graphes invalides refusés. Trois fragments courts changent,42212restent identiques. Les instructions complètes des quatre destinataires sont relues par Store.task/copy_text avec résolution des sources, questions et dépendances.

Les deux bases conservent42603autres lignes du catalogue,42607états manuels et23historiques. Intégrité et synchronisation idempotente vérifiées. Revue indépendante :5334ancres/empreintes exactes, aucun problème, pour99299sources enregistrées. Elle ne rehache pas toutes les sources historiques et ne mesure pas l'achèvement du jeu.

## Fichiers et preuves

Registres modifiés :docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu F:\OpenLeague\docs\reference_requirement_trace_sources\ziggs-passive-short_fuse-links-v656.json. Vérification F:\OpenLeague\docs\fidelity_ziggs_passive_short_fuse_links_v656.json. Bases :F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision656_Ziggs_discovery\OBSERVATIONS.json. Diagnostic F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision656_Ziggs_passive_probe_orderchecked\OBSERVATIONS.json. Inspection F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision656_Ziggs_inspection/OBSERVATIONS.json. Audit F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision656_Ziggs/DELIVERY_AUDIT.json. Revue F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision657_trace_review\REVIEW.json. Scripts, première erreur et deux binaires conservés.

Neuf copies privées archivées avec SHA décompressés vérifiés avant retrait des seuls doublons bruts ; gain logique 2522606852octets. Reçu F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision656_Ziggs/snapshot-archives/VERIFIED.json. Sources enregistrées et bases actives intactes ; restauration explicite par revision656_restore_validation_snapshots.py, non exécutée après archivage.

## Limites et suite

Les sources décrivent partiellement Short Fuse ; les producteurs f1/f2, le déclencheur, la recharge, sa réduction et le multiplicateur sur structures restent ouverts. Les métadonnées client ne deviennent pas une exécution serveur. Rendu, HUD, audio, réseau et sauvegarde nécessitent des contrôles séparés. Ni Ziggs ni le jeu ne sont déclarés terminés.

Continuer SYS-01.2-02 depuis revision657_trace_review/REVIEW.json. V656 Ziggs Short Fuse publié et audité :14sources natives,42associations,22points/44liens. Alias ZiggsPassiveBuff ;texte12s,réduction4s,150%structures ;f1/f2 et producteurs natifs ouverts. SpellData Disintegrate/ZiggsW distinct de BuffData,PLACEHOLDER et17limites NEWTABLE conservés. Douze attaques publiques sans supplément magique,AP0/20,niveaux1/18 ;deux contrôles publics AnnieQ réussis.118refus publics,13272ticks,huit apports XP,trois achats,1158entrées conservées. Premier RUN101 conservé ;diagnostic corrigé pour Q avant régénération,BUILD/RUN0 sans changement moteur. Prochain lot :Zilean PASSIF,contrat encore au chargeur partagé selon revue actuelle ;inspecter la version4.20 du gain XP et ses portées avant diagnostic. Snapshots V656 archivés/restaurables par revision656_restore_validation_snapshots.py. Goal actif. Première découverte Zilean exécutée0 :revision657_Zilean_discovery/OBSERVATIONS.json,33ressources natives,17références communautaires,9exclusions,trois limites NEWTABLE et aucun DDF dans ce périmètre. Alias avec espace Heightened Learning,préchargement heightenedlearning,Lua HeightenedLearning BuffName exact ;texte8%XP pour Zilean et champions alliés proches. Portée et producteur XP restent ouverts ;aucun diagnostic moteur Zilean exécuté.
