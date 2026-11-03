# SYS-01.2-02 — Zilean / Heightened Learning, V657

Date UTC 2026-10-27T04:14:22.668303+00:00. Référence PUBLIC4.20.0.315, EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau et déploiement non établis. Catalogue4.20.1 distinct.

V657 Zilean / Heightened Learning : 6 sources natives, 18 associations, 22 points actuels et 44 liens de frontière. Texte natif : 8% d’expérience supplémentaire pour Zilean et ses champions alliés proches ; rayon non indiqué. Quatre simulations Zilean/Annie avec allié à 200 ou 6527,63 unités : aucun bonus de 8% dans les gains observés. 60 refus publics et 68 refus API sans mutation, 12208 ticks, 24 apports XP et 16 décès par API serveur explicitement tracés. BUILD/RUN 0, 1158 entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

## Intégration et prérequis

Les trois fiches CH-Zilean-PASSIF-SOURCE, CH-Zilean-PASSIF-SIMULATION-CONTRAT et CH-Zilean-PASSIF-SIMULATION reçoivent sources, preuves et instructions complètes copiables. SYS-01.2-02 reçoit la synthèse. Six ressources donnent18associations ;22points courants donnent44liens sur les deux fiches de simulation. Tous restent entry_boundary_only, provides_feature_consumer=false et gameplay_accepted=false.

Trois questions propres et quatre dépendances sont préservées. Les prérequis de phase/lot sont consignés sans être déclarés accomplis. Inconnues, identifiants et hiérarchie restent identiques octet par octet ; statuts, critères, acceptations et états manuels restent inchangés.

## Sources et instructions de reprise

33ressources natives et17références communautaires inspectées, neuf exclusions conservées. Tailles, SHA et appartenance au manifeste RADS sélectionné vérifiés. Le lecteur conserve sa racine historique E:/OpenLeague ; les références communautaires restent distinctes du serveur original.

| Ressource sélectionnée | Octets | SHA-256 |
|---|---:|---|
| Zilean.inibin | 2259 | 753a4b05fe678a1fdf44d82e829004ad3ef4f7fe271b25b2c989069aef9425a6 |
| CharScriptZilean.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| CharScriptZilean.preload | 163 | 1f1b2e418bb05988e5eb233265b0be7dd2eae36c31cfc9533f486f8f0110c4d4 |
| Heightened Learning.inibin | 51 | e2ba6ef78c6d9472331738b08b4de273e421ed1380002d2291603de5689eaf9d |
| HeightenedLearning.luaobj | 159 | 663a561f46b3fcdf08354470da4c83a04b3cb7b9bad07ddee39b1a95da010433 |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |

V657 Zilean / Heightened Learning : 6 sources natives, 18 associations, 22 points actuels et 44 liens de frontière. Texte natif : 8% d’expérience supplémentaire pour Zilean et ses champions alliés proches ; rayon non indiqué. Quatre simulations Zilean/Annie avec allié à 200 ou 6527,63 unités : aucun bonus de 8% dans les gains observés. 60 refus publics et 68 refus API sans mutation, 12208 ticks, 24 apports XP et 16 décès par API serveur explicitement tracés. BUILD/RUN 0, 1158 entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

Objectif restant : qualifier Heightened Learning sur la référence4.20 et relier son producteur réel. Zilean.inibin déclare Passive1LuaName="Heightened Learning" et l’icône Chronokeeper_Slow.dds. Passive1Name et PassLev1Desc1 relient les textes exacts. Passive1, Passive1Desc et Passive1Level1..6 sont absents, pas zéro. Description du champion et tooltip BuffData indiquent 8% d’expérience supplémentaire pour Zilean et ses champions alliés proches. Le rayon, les catégories d’XP, l’ordre avec le partage et les arrondis restent à établir.

Sources :33ressources natives,17références communautaires et neuf exclusions conservées.11chunks Lua entièrement lus, sans fonctions enfants ; trois limites NEWTABLE concernent ChronoShift, Rewind et RewindCOF. Aucun DDF trouvé dans ce périmètre. Le CharScript natif est vide. Heightened Learning.inibin ne contient que la clé BuffData.DynamicTooltip=game_buff_tooltip_Heightened_Learning. HeightenedLearning.luaobj contient les littéraux BuffTextureName=Chronokeeper_Slow.dds et BuffName="Heightened Learning", sans callback. Le preload utilise heightenedlearning en minuscules sans espace. Conserver ces identités exactes ; le rapprochement documenté ne prouve pas la résolution effective du chargeur natif ni l’exécution d’une aura.

Le CharScript communautaire est vide et les fichiers Q/W/E/R simplifiés ne fournissent pas Heightened Learning. Les recherches bornées dans Rust (Zilean ou Heightened avec Learning) et dans les scripts C# (Heightened avec Learning) ne trouvent pas de producteur. Ne pas employer le mot Learning seul : il désigne aussi l’apprentissage des sorts dans le moteur. Ne pas transposer une mécanique de Zilean issue d’une version récente. La recherche locale ne prouve pas une absence dans toutes les communautés ou archives.

Diagnostic :quatre simulations indépendantes avec vraie navigation et monde Map10, propriétaire Zilean ou Annie, ennemi Annie et allié Annie. L’allié est placé à200unités par déplacement public ou reste à6527,6337890625unités. Six trajets Move/Stop publics réussissent sans réémission. Le niveau initial est1 et les XP initiales sont nulles. Chaque destinataire reçoit100puis200XP via award_experience serveur :les deltas sont exactement100et200, les300XP atteignent le niveau2. Les24apports sont des événements de diagnostic, pas une commande client. Aucun bonus de8% n’est ajouté à ces entrées.

À3052ticks, un vrai sbire ennemi de la vague naturelle, un vrai TT_NWolf2 et une vraie tourelle ennemie non protégée sont présents. Un événement apply_damage serveur létal est envoyé à chacun, puis au champion ennemi. Les positions, horloge, unités, PV et niveaux ne sont jamais écrits directement. Ces16événements traversent les consommateurs de récompense du moteur ; ils ne démontrent pas la validité d’une attaque publique à distance, car apply_damage n’est pas une commande de joueur et ne contrôle pas sa portée.

Résultats attendus/observés courants :le sbire porte64XP, partagées32/32 quand les deux alliés sont dans le rayon générique1250, sinon64au propriétaire et0à l’allié éloigné. Le monstre donne12XP au propriétaire seulement. La tourelle donne70XP à chaque allié de l’équipe, proche ou éloigné. Le décès du champion niveau2 donne220XP au tueur niveau2 et0aux autres. Le contrôle indépendant recalcule ce dernier montant depuis l’incrément Map10 niveau2→3 (700−300) et le multiplicateur local0,55. Les résultats Zilean et Annie sont identiques, sans supplément8%. Les politiques génériques de partage et la formule de kill sont des choix locaux dont la fidélité complète au serveur original reste ouverte.

Ne pas confondre le rayon1250 du partage d’XP d’un sbire avec la portée native de Heightened Learning :aucun lien natif ne l’établit. Les deux distances observées ne déterminent pas cette portée. Les trois gains sbire/monstre/tourelle sont lus depuis map10_world.json et comparés aux définitions des vraies unités ; les règles de kill restent séparées des champs natifs et de leur interprétation locale.

Refus :pour chacun des trois destinataires, XP zéro, négative, NaN et infinie sont refusées ; destinataire inconnu également, soit52refus XP API. Répéter les16décès est refusé sans seconde récompense, soit68refus API au total. Les cas Zilean refusent Learn/Cast/CastAt avant/après pour les quatre slots, joueur inconnu, attaque de soi et slot invalide (54refus). Les deux contrôles Annie ajoutent6refus génériques, soit60publics. Tous conservent les snapshots. Aucun sort n’est appris ni lancé dans ce diagnostic. Quatre simulations de3052ticks =12208ticks. Binaire non-test du vrai moteur, dépendances/checksums alignés sur Cargo.lock et1158entrées inchangées. Aucun rendu, audio, réseau ou serveur historique exécuté.

À compléter :identifier producteur8%, rayon et métrique de proximité, conditions d’aura (vivant/mort, visible/invisible, déconnecté), destinataires et exclusions. Qualifier présence de plusieurs Zilean, cumul ou priorité, application avant/après partage et autres multiplicateurs, précision/arrondi, limites de niveau et XP excédentaire. Vérifier chaque origine d’XP (sbires, monstres, champions, structures, événements de carte), mort/respawn, entrée/sortie de portée, changement d’équipe et reconnexion. Relier l’état réseau/sauvegarde, les indications HUD et l’icône, puis les éventuels visuels et sons. Préserver trois questions, quatre dépendances, critères, preuves, notes et états manuels. Ce lot relie les sources et les points actuels ; il ne termine ni Zilean ni le jeu.


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
| crates/core/src/progression.rs:50 | pub(crate) fn threshold( |
| crates/core/src/progression.rs:46 | pub fn growth_total( |
| crates/core/src/spells.rs:101 | pub fn cast( |
| crates/core/src/annie_w.rs:29 | pub fn cast_at( |
| crates/core/src/damage.rs:53 | pub fn apply_damage( |
| crates/core/src/world.rs:355 | pub(crate) fn damage_unit( |
| crates/core/src/world.rs:507 | pub(crate) fn advance_world( |
| crates/core/src/world.rs:265 | pub(crate) fn spawn_unit( |
| crates/core/src/world.rs:226 | pub(crate) fn target_info( |
| crates/core/src/world.rs:244 | pub fn protected( |
| crates/core/src/annie_r.rs:20 | pub(crate) fn combat_owner( |
| crates/core/src/champion_kills.rs:26 | pub(crate) fn record_champion_contribution( |
| crates/core/src/champion_kills.rs:32 | pub(crate) fn reward_champion_death( |
| crates/core/src/champion_kills.rs:13 | pub fn base_experience( |

Le gain direct, les seuils de niveau, les créations naturelles d’unités, les décès, les destinataires du partage, la récompense globale et le crédit de kill sont inspectés et exercés. Les valeurs locales ne sont pas promues en règles natives de l’aura. Les refus de sorts n’en constituent pas une implémentation.

## Résultats attendus et observés

| Propriétaire | Allié proche | Distance propriétaire–allié | Ticks |
|---|---|---:|---:|
| zilean | True | 200.0 | 3052 |
| zilean | False | 6527.6337890625 | 3052 |
| annie | True | 200.0 | 3052 |
| annie | False | 6527.6337890625 | 3052 |

| Origine | Propriétaire | Allié proche | Allié éloigné | Ennemi |
|---|---:|---:|---:|---:|
| Gain direct de100puis200XP | 100puis200 | 100puis200 | 100puis200 | 100puis200 |
| Sbire naturel64XP | 32si partagé,64sinon | 32 | 0 | 0 |
| TT_NWolf2 | 12 | 0 | 0 | 0 |
| Tourelle non protégée | 70 | 70 | 70 | 0 |
| Champion niveau2 | 220 | 0 | 0 | 0 |

Le gain direct est envoyé séparément à chaque destinataire. Les autres montants sont mesurés sur quatre événements de décès dans chaque simulation. Résultats Zilean et Annie identiques ; aucun supplément8%. Vérification indépendante des montants depuis les définitions locales et le calcul (700−300)×0,55 pour le kill, tolérance0,001. Le rayon1250 est celui du partage générique de sbire et ne qualifie pas la portée de Heightened Learning.

60refus publics,52refus XP API et16refus de cible déjà morte conservent les snapshots. Six trajets publics sans réémission ;24apports XP et16événements de décès par API serveur, sans injection directe d’état. Aucune attaque publique à distance ni commande de joueur accordant l’XP n’est revendiquée. Les politiques natives d’XP et de portée restent ouvertes.

Binaire F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-zilean-heightened-learning-probe.exe ; 6144000octets ; SHA-256 f52dbb8a3cd6da142d671fa65e6648d19331f56c0c8eff20b50ff7f4c0054d16. Compilation du vrai F:/OpenLeague/crates/core/src/lib.rs avec profile.test=false ; dépendances/checksums alignés sur Cargo.lock.1158entrées moteur/ressources identiques avant/après. Aucun code de jeu ni asset modifié.

## Vérification de livraison

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 97caf15df3d52a65e32ddb846a520ddd3983bd30307a7be9a6fc166f64e36b56 |
| RUN | 0 | 88f69c037d6475ffaf0e4f353acb92bc3b2ffb25aa1a83b0ecb6e37e267b8633 |
| prepare | 0 | 10ebf12fec7e182ddefaa45a96b581a2ab3e67a2f52bb2a804bcc2bc217a637e |
| check | 0 | 3cd786a28646d3d89cdff60e09e98ce54e54cf7cfe06bf202d949fb8813cc57e |
| publish | 0 | 3cabfa2faeae5597fde9268d5d08d6b7bc17db7ab5eca40227b1f28f9f8d9867 |
| audit | 0 | 796e3d7a26f9d91537cab799b8e06be853f43627402ed1990ad8e515abaa9d9f |

Découverte, inspection, BUILD/RUN et quatre étapes de livraison réussis.60associations falsifiées et quatre graphes invalides refusés. Trois fragments courts changent,42212restent identiques. Les instructions complètes des quatre destinataires sont relues par Store.task/copy_text avec résolution des sources, questions et dépendances.

Les deux bases conservent42603autres lignes du catalogue,42607états manuels et23historiques. Intégrité et synchronisation idempotente vérifiées. Revue indépendante :5356ancres/empreintes exactes, aucun problème, pour99303sources enregistrées. Elle ne rehache pas toutes les sources historiques et ne mesure pas l’achèvement du jeu.

## Fichiers et preuves

Registres modifiés :docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu F:\OpenLeague\docs\reference_requirement_trace_sources\zilean-passive-heightened_learning-links-v657.json. Vérification F:\OpenLeague\docs\fidelity_zilean_passive_heightened_learning_links_v657.json. Bases :F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision657_Zilean_discovery\OBSERVATIONS.json. Diagnostic F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision657_Zilean_passive_probe\OBSERVATIONS.json. Inspection F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision657_Zilean_inspection/OBSERVATIONS.json. Audit F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision657_Zilean/DELIVERY_AUDIT.json. Revue F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision658_trace_review\REVIEW.json. Scripts et binaire conservés.

Neuf copies privées archivées avec SHA décompressés vérifiés avant retrait des seuls doublons bruts ; gain logique 2535031340octets. Reçu F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision657_Zilean/snapshot-archives/VERIFIED.json. Sources enregistrées et bases actives intactes ; restauration explicite par revision657_restore_validation_snapshots.py, non exécutée après archivage.

## Limites et suite

Le texte natif existe, mais aucun producteur du bonus8% n’est relié à ces chemins actuels. Rayon, application avant/après partage, types de récompenses, arrondis, cumul et cycle de vie restent ouverts. Les métadonnées client ne prouvent pas une exécution serveur. Rendu, HUD, audio, réseau et sauvegarde nécessitent des contrôles séparés. Ni Zilean ni le jeu ne sont déclarés terminés.

Continuer SYS-01.2-02 depuis revision658_trace_review/REVIEW.json. V657 Zilean Heightened Learning publié et audité :6sources natives,18associations,22points/44liens. Alias avec espace et preload sans espace conservés ;texte8%XP pour Zilean et alliés proches,rayon inconnu. Quatre simulations Zilean/Annie,allié200/6527,63unités :24apports XP,16décès par API serveur,aucun bonus8% ;sbire32/32ou64/0,monstre12au propriétaire,tourelle70par allié,champion220au tueur.60refus publics+68API,12208ticks,1158entrées conservées,BUILD/RUN0. Partage générique1250 non assimilé à la portée native. Prochain lot :Zyra PASSIF,contrat encore au chargeur partagé selon revue actuelle ;inspecter le passif post-mort de la référence4.20 avant diagnostic,ne pas substituer une mécanique récente. Snapshots V657 archivés/restaurables par revision657_restore_validation_snapshots.py. Goal actif. Première découverte Zyra exécutée0 :revision658_Zyra_discovery/OBSERVATIONS.json,121ressources natives,37références communautaires,9exclusions et un DDF. Alias ZyraPassiveDeathDisplay,icôneZyraP.dds ;texte retour en plante après mort,attente2s puis tir vers curseur par une compétence,dégâts bruts aux ennemis traversés.54Lua lus,21limites NEWTABLE conservées. Aucun diagnostic moteur Zyra exécuté.
