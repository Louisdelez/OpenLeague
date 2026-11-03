# SYS-01.2-02 — Xerath / Mana Surge, V651

Date UTC 2026-10-27T02:20:01.801707+00:00. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement non établis. Catalogue 4.20.1 distinct.

V651 Xerath / Mana Surge : 12 sources natives, 36 associations, 23 points actuels et 46 liens de frontière. Six attaques publiques aux niveaux 1/18 avec déficit de mana créé par achat : aucune restauration supplémentaire au-delà de la régénération courante. Potion de mana distincte vérifiée sur 450 mises à jour. 60 refus publics sans mutation, 4599 ticks, trois apports XP serveur explicites. Valeurs f1/f2/f3 et disponibilité native non qualifiées. BUILD/RUN corrigés 0, 1158 entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

## Résultat intégré

Les trois fiches CH-Xerath-PASSIF-SOURCE, CH-Xerath-PASSIF-SIMULATION-CONTRAT et CH-Xerath-PASSIF-SIMULATION reçoivent sources, preuves et instructions complètes copiables. SYS-01.2-02 reçoit la synthèse. Douze ressources natives donnent 36 associations ; 23 points de code donnent 46 liens sur les deux fiches de simulation. Ces points sont des traitements génériques observés et des frontières de refus, pas un producteur de Mana Surge accepté.

Trois questions propres et quatre dépendances restent ouvertes. Les prérequis de phase, lot et tâche sont conservés dans le reçu, sans prétendre qu’ils sont accomplis. Identifiants, hiérarchie et registre d’inconnues restent identiques octet par octet. Statuts, critères, acceptations et états manuels restent inchangés.

## Référence native vérifiée

La découverte a vérifié 75 fichiers natifs : 27 INIBIN, 28 Lua, 19 preloads et le fontconfig. Huit candidats sont exclus. Vingt-sept références communautaires sont séparées de la référence native. Tailles, empreintes et appartenance au manifeste RADS sélectionné sont vérifiées ; sa racine historique E:/OpenLeague n’est pas réécrite silencieusement.

| Ressource reliée | Octets | SHA-256 |
|---|---:|---|
| Xerath.inibin | 1798 | 87b047e4abf8bcfb2afbc453a19ac8f8baa913811867d97ae0ec5a9637db9e93 |
| CharScriptXerath.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| CharScriptXerath.preload | 961 | 8b5a9267ec60710d4debef9c78a8a8f234dd2be350cb5fbc17a8bc2cffcc9ddf |
| XerathAscended2.inibin | 46 | e536739d8a4fbf786cc037e3684d9e986535ecafe9049f41e0294a9ae41e39d9 |
| XerathAscended2.luaobj | 219 | b8d2cae2d817690db12aacb9a8cf0b5846156f6d99a85e89cb30ca88985764c3 |
| XerathAscended2.preload | 97 | cc83b7c1167f6af87be89f4af4aab7d9321939dd9980b0a58fb6b0c8c5bf02fe |
| XerathAscended2OnHit.inibin | 59 | 640b5b303bd8866bb52aad556284fe466bf84110d7c9570d3f7445d0ff8c2f0b |
| XerathAscended2OnHit.luaobj | 220 | b56dc42d8822a2ea70bbc67bb884f4af95e840a6a411c5eea7ffa7757e3072d3 |
| XerathAscended2OnHit.preload | 110 | b6fd6765c28c950d8c29d59ab34617fc8b947ca99e2d9597387c7791321ccc57 |
| XerathBasicAttack.inibin | 1391 | 56e210799b2703ba79452730b844285a6785102a6fec762ea63557ffc071f976 |
| XerathBasicAttack.luaobj | 119 | acb83274ee7e8e4b393174dac16451907ab92e62aa564f47470c3d01e68ee9e0 |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |

Xerath.inibin lie Passive1LuaName à XerathAscended2, l’icône à Xerath_Passive1.dds, le nom à game_character_passiveName_Xerath et PassLev1Desc1 à game_character_passiveDescription_Xerath. Passive1, Passive1Desc et Passive1Level1..6 sont absents, pas zéro.

Le lien exact de XerathAscended2.inibin vers game_buff_tooltip_XerathAscended (fontconfig ligne2948) distingue @f1@ mana contre sbire/monstre, @f2@ contre champion, toutes les @f3@ secondes. Le lien d’OnHit (ligne2949) décrit la prochaine attaque ordinaire restaurant du mana. Les producteurs et valeurs f1/f2/f3 restent non résolus. Ni période de douze secondes ni doublement contre champion ne sont inférés. Aucun DDF ne figure parmi ces 75 candidats ; ce n’est pas une preuve d’absence dans toutes les archives.

Le CharScript natif et son équivalent communautaire sont vides. Les 28 chunks n’ont pas de fonctions enfants ; treize limites NEWTABLE restent consignées. Ascended2 porte la texture Xerath_AscendedForm.dds, OnHit Xerath_Passive1.dds ; tous deux ont PersistsThroughDeath=true et Nondispellable=true. Ces littéraux ne prouvent pas le cycle de vie, la disponibilité ou une immunité exécutée. Les preloads relient CharScript→Ascended2→OnHit→xerath_base_p_manarestore.troy, sans prouver un rendu effectif.

## Consommateurs actuels

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
| crates/core/src/attacks.rs:141 | fn attack_target_valid( |
| crates/core/src/attacks.rs:157 | pub(crate) fn advance_attacks( |
| crates/core/src/attacks.rs:26 | pub fn windup_ticks( |
| crates/core/src/lifesteal.rs:4 | pub(crate) fn basic_attack_hit( |
| crates/core/src/regeneration.rs:10 | pub fn regeneration_rates( |
| crates/core/src/regeneration.rs:32 | pub(crate) fn advance_regeneration( |
| crates/core/src/vision.rs:79 | pub fn visible_to( |
| crates/core/src/shop.rs:261 | pub fn buy_item( |
| crates/core/src/shop.rs:248 | fn shop_guard( |
| crates/core/src/shop.rs:314 | fn refresh_item_caps( |
| crates/core/src/consumables.rs:8 | pub fn use_item( |
| crates/core/src/consumables.rs:25 | pub(crate) fn advance_consumables( |
| crates/core/src/interactions.rs:79 | pub(crate) fn advance_interactions( |

Les recherches bornées dans les fichiers Rust du moteur (Xerath/Mana Surge) et les scripts C# (XerathAscended/Mana Surge) ne trouvent pas de producteur dans leur périmètre. Les corps communautaires Q/W/E/R simplifiés ne deviennent ni code du serveur original ni consommateur Rust du passif.

Les attaques passent par advance_attacks et basic_attack_hit ; le profil à distance référence exactement Xerath.inibin et XerathBasicAttack.inibin. La régénération courante vient des statistiques de base, de la croissance et des bonus d’objets. Buy→refresh_item_caps augmente le maximum sans remplir le mana courant. UseItem→advance_consumables active la potion et la décrémente sur 450 mises à jour. advance_interactions restaure le mana dans le rayon de fontaine courant de 1000, valeur communautaire explicitement non qualifiée comme règle serveur originale.

## Diagnostic exécuté, résultats attendus et observés

Deux cas utilisent Map10 avec monde et interactions activés. Xerath est niveau1 puis18 ; Annie, cible, est niveau18 dans les deux cas. Trois apports award_experience(100000) préparent les niveaux côté serveur. Les positions sont atteintes par Move/Stop ; aucun état de position, mana, PV, rang, inventaire ou horloge n’est injecté directement. Les huit trajets au total ne nécessitent aucune réémission.

Le point demandé (900,8550), projeté sur la navigation réelle, est à portée de boutique et hors fontaine avec marge supérieure à100. Le premier point (800,8200) était dans la fontaine : la garde a arrêté le diagnostic avant les achats et le combat. Cette première compilation0 et exécution Rust101 sont conservées, ainsi que le lanceur Python1. Un nouvel exécutable navchecked corrige le seul placement. La première inspection confondait code Rust101 et code lanceur1 ; son échec et sa version corrigée commandchecked sont conservés.

| Cas | Attendu du contrôle actuel | Observé |
|---|---|---|
| Achat1027 puis2004 | +200 mana maximum, mana courant inchangé | déficit200 créé publiquement ; coûts400 et35 |
| Trois attaques par niveau | projectiles et dégâts physiques vérifiables | six impacts, après armure et régénération, tolérance0,004 |
| Mana pendant les attaques | détecter une restauration supplémentaire | seul le taux de régénération courant est observé, déficit supérieur à50 |
| Learn/Cast/CastAt avant/après | refus des quatre slots sans mutation | snapshots identiques |
| UseItem invalide/vide/cristal | refus sans consommation | trois refus par cas |
| Potion publique, slot1 | consommation et450ticks actifs | slot consommé,100mana/15s plus régénération et saturation au maximum |
| Fin de potion | un tick à449, zéro à450 | observé, mise à jour451 également contrôlée |

La politique de conservation du mana à l’achat est vérifiée dans le moteur actuel ; elle n’est pas qualifiée comme règle native. La potion est un témoin distinct, pas une substitution au passif. Le manque de mana évite de masquer une éventuelle restauration par saturation, mais **la disponibilité native de Mana Surge n’est pas établie**. L’absence de restauration observée ne suffit pas, seule, à prouver le comportement à l’état prêt. Aucun sbire, monstre ou bâtiment n’est testé.

Les60refus publics se répartissent en54refus généraux/sorts et6refus UseItem. Les snapshots sont identiques après chacun. Total4599ticks (2310 et2289), six impacts, quatre achats et deux consommations réussies. Aucun décès ni victoire provoquée. Les 451 mises à jour de potion sont vérifiées par cas avec saturation au maximum ;100mana potentiels ne signifie pas100mana effectivement reçus si le pool sature.

Binaire : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-xerath-mana-surge-navchecked-probe.exe, 6074880 octets, SHA-256 be65856d09a098c84c8ca88142ba83eebdfaa18a1b31161576e83bb184f00ce6. Le compilateur utilise F:/OpenLeague/crates/core/src/lib.rs avec profile.test=false. Verrou privé aligné sur les identités et checksums du Cargo.lock racine ;1158entrées moteur/ressources inchangées. Aucun code de jeu ni asset modifié.

## Livraison vérifiée

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 1b507880d4dbee27ebd05ba6a4e6c431ede44e3edb3c6324cfab53ea7e1c6122 |
| RUN | 0 | 74c24149ea2f910fe2c95af0379139ebc6f1ef8c707424b7e16f6089dbacb7ae |
| prepare | 0 | dcc26a263fc1c38ce75835b817123241bd690449e899d8a6235034b4047a4ec9 |
| check | 0 | 3a682f1a2379cc43191bfbd47cbc622f23ebe88e41a743a9b9e110a99ebcb8c5 |
| publish | 0 | 04a6223e872990b70b30b592d8c62517b27767ba9c45460d79b71455ced81259 |
| audit | 0 | f59c2db43f1f2018b97cb28da5c8d53c8aa82ff16eb56ed8f64f01dfd75a1f29 |

Découverte et inspection corrigée réussies. Les60associations falsifiées et quatre graphes invalides sont refusés. Trois fragments courts changent,42212restent identiques ; les instructions complètes des quatre destinataires sont vérifiées par Store.task/copy_text. Sources, questions et dépendances sont résolues depuis le consommateur réel du plan.

Les deux bases conservent42603autres lignes du catalogue,42607états manuels et23historiques. Quatre destinataires sont actualisés ; intégrité et synchronisation idempotente vérifiées. La revue indépendante retrouve5222ancres/empreintes exactes et aucun problème de consommateur, pour99279sources enregistrées. Elle ne rehache pas toutes les sources historiques et ne mesure pas l’achèvement du jeu.

## Fichiers et preuves

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu : F:\OpenLeague\docs\reference_requirement_trace_sources\xerath-passive-mana-surge-links-v651.json. Vérification : F:\OpenLeague\docs\fidelity_xerath_passive_mana_surge_links_v651.json. Bases : F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md, docs/ai/HANDOFF.md.

Découverte : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision651_Xerath_discovery\OBSERVATIONS.json. Diagnostic : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision651_Xerath_passive_probe_navchecked\OBSERVATIONS.json. Inspection : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision651_Xerath_inspection_commandchecked/OBSERVATIONS.json. Audit : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision651_Xerath/DELIVERY_AUDIT.json. Revue : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision652_trace_review\REVIEW.json. Scripts, versions échouées, journaux et binaires conservés.

Neuf copies privées de validation sont archivées après audit, comparaison SHA décompressée avant retrait des seuls doublons bruts. Gain logique : 2471805335octets. Reçu F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision651_Xerath/snapshot-archives/VERIFIED.json. Les preuves enregistrées et bases actives sont intactes. Restauration explicite possible par revision651_restore_validation_snapshots.py, non exécutée après archivage.

## Manques ouverts

Montants f1/f2 et progression par niveau, arrondis, délai f3, disponibilité initiale, création et consommation du marqueur à l’envoi ou à l’impact, cibles autorisées, attaques ratées/annulées, saturation, projectiles multiples, interaction avec effets à l’impact, mort/retour/reconnexion restent à qualifier. Réseau, sauvegarde, HUD, tooltips, icônes, particules, animation et audio exigent leurs propres preuves. Aucun de ces points n’est déclaré terminé par la présence d’un fichier ou par une compilation verte.

Continuer SYS-01.2-02 depuis revision652_trace_review/REVIEW.json. V651 Xerath publié et audité : 12 sources natives, 36 associations, 23 points actuels/46 liens. Six attaques à distance avec déficit de mana créé par achat public, aucune restauration hors régénération ; potion distincte vérifiée 450 mises à jour. 60 refus publics, 4599 ticks, trois apports XP serveur. f1/f2/f3, disponibilité, catégories de cibles et cycle de vie natifs restent ouverts. Premier placement refusé par garde fontaine avant combat : RUN Rust101, lanceur1 ; nouveau diagnostic navchecked BUILD/RUN0. Première inspection avait confondu ces codes ; corrigée commandchecked, preuves conservées. Prochain lot : XinZhao PASSIF, contrat encore au chargeur partagé selon revue actuelle ; lire textes natifs, déclencheurs et producteurs avant diagnostic. Vladimir reste couvert par V545, ne pas dupliquer. Snapshots V651 archivés/restaurables explicitement par revision651_restore_validation_snapshots.py. Goal actif. Découverte XinZhao déjà exécutée0 : revision652_XinZhao_discovery/OBSERVATIONS.json,49sources natives,22références communautaires,9exclusions. Les alias XinZhao et XenZhao sont inclus. Challenge décrit15%réduction armure/3secondes,une cible ;ne pas confondre le soin de troisième attaque du W ni la description héritée MasterYi de Passive1Desc avec ce passif. Aucun diagnostic moteur XinZhao exécuté ;valider ces liens exacts avant intégration.
