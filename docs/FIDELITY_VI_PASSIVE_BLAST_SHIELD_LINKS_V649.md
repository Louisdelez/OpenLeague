# SYS-01.2-02 — Vi / Blast Shield, V649

Date UTC 2026-10-27T01:19:42.135366+00:00. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement non établis. Catalogue 4.20.1 distinct.

V649 Vi / Blast Shield : 16 sources natives, 48 associations, 25 points actuels et 50 liens de frontière. Le marqueur natif décrit un bouclier de 10% des PV maximum pendant 3 secondes après une touche de compétence ; producteurs f2/f3 et délai de recharge non résolus. Deux attaques ordinaires aux niveaux 1/18 ne déclenchent pas de bouclier ; les sorts restent refusés. Témoin Barrière distinct : 115/455 de bouclier, absorption des trois types de dégâts, expiration au tick60 ; échéance de recharge6300 enregistrée mais non attendue. 60 refus publics et 14 refus API bouclier sans mutation, 4121 ticks et deux apports XP serveur explicites. BUILD/RUN 0, 1158 entrées conservées. Aucun code de jeu modifié, aucune case ou question fermée.

## Résultat intégré et prérequis

Les trois fiches CH-Vi-PASSIF-SOURCE, CH-Vi-PASSIF-SIMULATION-CONTRAT et CH-Vi-PASSIF-SIMULATION reçoivent les sources, preuves et instructions copiables. SYS-01.2-02 reçoit la synthèse. Seize sources natives donnent 48 associations ; 25 points courants donnent 50 liens sur les deux fiches de simulation. Ce sont des frontières de traitement ou un témoin distinct, pas un producteur de Blast Shield.

Les prérequis des phases, lots et tâches restent dans le reçu. Trois questions propres et quatre dépendances sont conservées, sans déclarer ces prérequis achevés. Statuts, critères et acceptations antérieurs sont inchangés. Les registres d’inconnues, d’identifiants et de hiérarchie restent identiques octet par octet.

## Sources et contrat natif

La découverte vérifie 114 ressources natives : 30 INIBIN, 55 Lua, 27 preloads, un DDF et le fontconfig. Quatre candidats hors périmètre sont exclus. Les 35 références communautaires sont identifiées séparément. Les tailles/SHA correspondent au registre ; l’appartenance native au manifeste RADS sélectionné est vérifiée.

| Ressource reliée | Octets | SHA-256 |
|---|---:|---|
| Vi.inibin | 982 | 0fe52c664652f10fb001886e5827fce781014e177484ebbea924b705f3c836e4 |
| Vi.ddf | 631 | e78383c69b30609a864ede4404cf0f6a6581c6043b8dda1881709a09bd410f04 |
| CharScriptVi.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| CharScriptVi.preload | 1060 | eedbe6cef4622b4c8c9c0c310d383f7e2daa37085b07ccce1065457e9fe6dd97 |
| ViPassive.luaobj | 180 | 461f225bc838e65e69619a27ec8040930441b1c6de17b970daab2f5ff101f66f |
| ViPassive.preload | 91 | 6a574f065a3ac27a1c1b2289ec263ea4602585231927156c5a73f8a261f73299 |
| ViPassiveMarker.inibin | 55 | d2319b6f43c9fc37699097e12b4f85b58b4bbf095e3ea002801ada975952c3d7 |
| ViPassiveMarker.luaobj | 191 | d38419c6f4a30552f7df82a237f7d8a5f3a177b8efd133bc7bf9d9531f01050b |
| ViPassiveBuff.inibin | 45 | eae6ade814eff2028071d45a40a3d95f3c67a21ea4f73a6c7c478ccb1112ada9 |
| ViPassiveBuff.luaobj | 145 | f046bf7735c4689505c03c2da4169e68b46dc97475d83fb1730d748634fe88b5 |
| ViPassiveBuff.preload | 448 | 1f96597673a065d615aa276d2d77ba3ed7031bc475cb08c0a26b87f977cfd118 |
| ViPassiveReady.inibin | 46 | 61e55a37016ef61e4b5fb982f87b8b5a7afec6c7e481ef2cc1b8aaa6dcd5137f |
| ViPassiveReady.luaobj | 180 | 1751f13b03393e1344927aee4f6dd2a91bcbaf06c7d4a6906ed5966f4547e7a8 |
| ViPassiveReady.preload | 175 | 78cc015c5847af8fa101827af349889d9646fdfa189d70370807c2ca5a3ed9f2 |
| ViBasicAttack.inibin | 768 | 4560992dc2a60f5709053f9c49c06975d1fe749de719f0cc8e1b1ee5ddb5a972 |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |

Vi.inibin nomme ViPassiveMarker et ViPassive.dds. Passive1Desc, PassLev1Desc1, Passive1 et Passive1Level1..6 sont absents, pas zéro. La traduction de personnage existe, mais son lien PassLev1Desc1 n’est pas inventé. Le lien exact de ViPassiveMarker.inibin vers game_buff_tooltip_ViPassiveMarker, ligne2891, établit le texte de référence : une compétence activée touchant un ennemi accorde un bouclier de **10% des PV maximum pendant3secondes**, avec délai @f3@ et affichage de force @f2@.

La formule textuelle10% est connue ; les producteurs de f2/f3 et le délai effectif restent non résolus. Les16entrées DDF ne donnent que quatre associations peuplées de Q/E/W : ViE;f1=14/12,5/11/9,5/8, ViE;f3=1,15AD, ViQ;f1=1,4bonusAD et ViW;f1=@special.viw avec coefficient35. Elles ne deviennent pas le délai de Blast Shield.

Les CharScripts natif et C# sont vides. ViPassive.luaobj déclare Rev Up avec texture Caitlyn_Headshot2.dds ; ViPassiveMarker.luaobj utilise MonkeyKingStoneSkin.dds. Buff et Ready utilisent ViPassive.dds. Ces anomalies sont conservées sans importer le comportement d’autres champions. PersistsThroughDeath dans Passive/Marker/Ready reste une métadonnée, pas une validation du cycle de vie.

Les preloads lient les marqueurs et effets visuels. Celui du buff contient notamment root ; cette dépendance ne prouve pas une immobilisation. Le texte ViPassiveCooldown est présent dans la traduction, mais aucun fichier de ce nom ne figure parmi les114candidats vérifiés ; aucune absence universelle n’est revendiquée. Les55chunks n’ont pas de fonctions enfants ; neuf limites NEWTABLE restent visibles dans le reçu.

## Consommateurs actuels et communauté

| Point courant | Ancre vérifiée |
|---|---|
| crates/core/src/lib.rs:533 | pub fn join( |
| crates/core/src/summoners.rs:32 | pub fn join_with_summoners( |
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
| crates/core/src/shields.rs:12 | pub fn grant_shield( |
| crates/core/src/shields.rs:41 | pub(crate) fn advance_shields( |
| crates/core/src/shields.rs:47 | pub(crate) fn absorb_shields( |
| crates/core/src/damage.rs:53 | pub fn apply_damage( |
| crates/core/src/damage.rs:38 | pub fn mitigate( |
| crates/core/src/summoners.rs:44 | pub fn cast_summoner( |
| crates/core/src/summoners.rs:47 | pub fn cast_summoner_on( |
| crates/core/src/regeneration.rs:10 | pub fn regeneration_rates( |
| crates/core/src/regeneration.rs:32 | pub(crate) fn advance_regeneration( |
| crates/core/src/vision.rs:79 | pub fn visible_to( |

Les recherches bornées ViPassive/Blast Shield/identifiant Vi dans le Rust et les scripts C# ne trouvent pas de producteur du passif dans leur périmètre. Le C# Q/E/R effectue des dégâts dans des implémentations simplifiées ; W ajoute ViDentingBlows, ce qui ne constitue pas Blast Shield. Aucun de ces corps n’est promu comme serveur original ni consommateur Rust du bouclier.

Le moteur refuse l’apprentissage des sorts Vi. Les attaques ordinaires passent par advance_attacks/basic_attack_hit/apply_damage ; le profil Vi est de mêlée et ses sources sont identifiées. Barrière utilise cast_summoner_on→grant_shield ; absorb_shields et advance_shields gèrent absorption et expiration. Le consommateur courant de contrôle charge barrier_rules.json, avec ses limites de reconstruction conservées. Il ne valide pas Blast Shield.

## Diagnostic exécuté

Deux simulations niveaux1/18 sur Map10 : Vi et Annie se déplacent par commandes publiques, puis Vi poursuit et porte une attaque de mêlée. Le cas niveau18 utilise deux award_experience(100000), explicitement côté serveur ; aucune progression naturelle n’est revendiquée. Aucune injection directe de position, PV, rang, bouclier ou horloge. Les quatre trajets de préparation se terminent sans réémission.

| Cas | Attendu du diagnostic | Observé |
|---|---|---|
| Attaque ordinaire Vi | windup et dégâts physiques vérifiables | un impact par niveau, après armure/régénération, écart inférieur à0,002 |
| État après attaque ordinaire | observer un éventuel bouclier | aucun pendant95ticks ; cas distinct du déclencheur natif |
| Learn/Cast/CastAt avant/après | refus sans mutation | quatre slots refusés aux deux niveaux |
| Barrière publique | bouclier courant du sort d’invocateur | 115 au niveau1,455 au niveau18 |
| Dégâts aux ticks0/59 | absorption pendant le contrôle actif | physique/magique/vrai absorbés, sans perte de PV |
| Dégâts aux ticks60/61 | absence de bouclier expiré | PV diminués après mitigation ; aucune absorption |
| Recharge Barrière | échéance et refus immédiat | échéance relative6300 et refus ; retour à6300 non testé |

**L’attaque ordinaire ne remplace pas une touche de compétence.** L’absence de bouclier après cette attaque est compatible avec le texte natif et ne prouve pas à elle seule l’absence du passif. La génération par une compétence, la durée native3secondes et le délai Vi restent non qualifiés. Les95ticks de surveillance sans activation ne sont pas une preuve d’expiration d’un bouclier absent.

Les24échantillons de dégâts du contrôle utilisent l’API serveur apply_damage : trois types aux ticks relatifs0/59/60/61, dans deux cas. Ils ne sont pas des sorts Vi ni des attaques ordinaires. Pendant Barrière, les dégâts après mitigation réduisent uniquement sa réserve ; à partir du tick60, le reliquat expire et les mêmes types affectent les PV. La priorité générique entre plusieurs boucliers reste une reconstruction non qualifiée ici.

Les60refus publics comprennent54commandes des cas Vi et6du contrôle Barrière(slot vide,slot invalide,délai). Les14refus de l’API grant_shield couvrent NaN, infini, zéro, négatif, durée nulle, tag vide et cible inconnue, alors qu’un bouclier valide est actif. Chaque refus conserve le snapshot. Total4121ticks :2062au niveau1 et2059au niveau18 ; deux apports XP, deux impacts ordinaires, aucune mort ni victoire provoquée.

Binaire :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-vi-blast-shield-probe.exe ;6098432octets ;SHA-256 3a1ce44cdb8604a9c0b2481374763f8531402e8a84233e1634f7f870579b5ef3. Compilation du vrai F:/OpenLeague/crates/core/src/lib.rs avec profile.test=false. Dépendances/checksums alignés sur Cargo.lock racine ;1158entrées moteur/ressources identiques avant/après. Aucun code de jeu ni asset modifié.

## Vérifications de livraison

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | bd4678d8aeb2e36e2ed587a4fb65b907a3d7029b47c97342c2cf12c48d5f62cc |
| RUN | 0 | 541751242071428f1eaacd83859bfc47c07917d7770e6aeb088ef05f761b1ed0 |
| prepare | 0 | 51fb6ba20e1b39827b035f6b159e4d9f410f82046e63f10c49cc81a1957e765e |
| check | 0 | b19d602bde814fadabee4860d767d9c6037cfdbc0b34562c9280a83ea79bb8a3 |
| publish | 0 | 2e1de5f195cbf44c8eb09e1f970a1358784eea3a9d4e34eadca180a5b0c28c40 |
| audit | 0 | 3fb964c5d76a409df0d91d72007b3a6d82a54cd91924f01ba4f8125bc3aac415 |

Reprise, découverte, inspection et BUILD/RUN :code0. Les60associations falsifiées et quatre graphes invalides sont refusés. Store.task/copy_text vérifie les instructions complètes des quatre destinataires et résout sources, questions et dépendances. Trois fragments courts changent,42212restent identiques.

Les deux bases conservent42603autres lignes du catalogue,42607états manuels et23historiques ;quatre destinataires sont actualisés. Intégrité et synchronisation Store idempotente vérifiées. Revue indépendante :5175ancres/empreintes de consommateurs exactes,99271sources enregistrées. Ce contrôle ne rehache pas toutes les sources historiques et ne mesure pas l’achèvement du jeu.

## Fichiers, preuves et conservation

Registres modifiés :docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu :docs/reference_requirement_trace_sources/vi-passive-blast-shield-links-v649.json. Vérification :docs/fidelity_vi_passive_blast_shield_links_v649.json. Bases :runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision649_Vi_discovery\OBSERVATIONS.json. Diagnostic :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision649_Vi_passive_probe\OBSERVATIONS.json. Inspection :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision649_Vi_inspection/OBSERVATIONS.json. Audit :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision649_Vi/DELIVERY_AUDIT.json. Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision650_trace_review\REVIEW.json. Scripts et journaux conservés sousF:\OpenLeague-work\Requirements_registry_4_20_2026-10-20.

Neuf copies privées de validation sont archivées après audit en gzip, avec comparaison SHA décompressée avant retrait des seuls doublons bruts ;gain logique2454266049octets. Reçu :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision649_Vi/snapshot-archives/VERIFIED.json. Les sources enregistrées, preuves, binaires et bases actives restent intacts. Restauration explicite par revision649_restore_validation_snapshots.py,non exécutée après archivage.

## Manques et prochaine action

Restent ouverts :f3 et variation du délai, liaison f2, producteur de bouclier, catégories de touches/cibles, Q/E/R et attaques renforcées, instant d’échantillonnage des PVmaximum, recharge initiale/fin, renouvellement/cumul, absorption et expiration natives, mort/retour/déconnexion, réseau, HUD, icônes, particules, animation et audio. Aucune question ni case n’est fermée ;ni Vi ni le jeu ne sont déclarés terminés.

Continuer SYS-01.2-02 depuis revision650_trace_review/REVIEW.json. V649 Vi publié et audité :16sources natives,48associations,25points actuels/50liens. Deux attaques publiques de mêlée niveaux1/18,sans bouclier ;sorts refusés. Barrière distincte115/455,24échantillons API de dégâts,expiration60ticks,échéance6300 lue mais non attendue.60refus publics+14API bouclier,4121ticks,deux apports XP. Native10%PVmax/3s après touche de compétence ;f2affichage/f3cooldown et producteur non résolus. Ne pas promouvoir attaque ordinaire ou dégâts API en touche de sort. V650 Viktor PASSIF Glorious Evolution :découverte terminée,82sources natives vérifiées,35références communautaires,huit exclusions. Quatre objets natifs3200/3196/3197/3198 et leurs textes vérifiés ;chaîne Hex Core,restriction Viktor et interdiction de vente présentes. Descriptions natives :3/4/5/6AP par niveau,bonus fixe0/20/40/60AP. CharScript et quatre scripts objets natifs vides ;producteur effectif,liaison f1 et augmentations de compétences non résolus. Comparaison des quatre objets avec le reçu boutique antérieur effectuée,sans réexécuter son audit complet. Découverte conservée dans revision650_Viktor_discovery/OBSERVATIONS.json. Complément statique revision650_Viktor_hexcore_followup/OBSERVATIONS.json :trois fichiers Atmas liés vérifiés ;quatre objets absents du catalogue runtime et de sa table admission Map10. Contrat encore au chargeur partagé :inspecter les consommateurs boutique/inventaire/stats puis qualifier par commandes publiques ;aucun test moteur V650 exécuté. Snapshots V649 archivés/restaurables explicitement par revision649_restore_validation_snapshots.py. Goal actif.
