# SYS-01.2-02 — Yorick / Unholy Covenant, V653

Date UTC 2026-10-27T02:54:43.578978+00:00. Référence PUBLIC4.20.0.315,EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau et déploiement non établis. Catalogue4.20.1 distinct.

V653 Yorick / Unholy Covenant : 30 sources natives, 90 associations, 26 points actuels et 52 liens de frontière. Texte natif5% par invocation et35%AD/PV pour les goules. Six attaques et six échantillons API de dégâts vérifiés à zéro invocation ; sorts Yorick refusés. Témoin Tibbers distinct : apparition après8ticks, guidage public, expiration1350ticks. 57 refus publics sans mutation, 5542 ticks, quatre apports XP serveur explicites. BUILD/RUN0,1158entrées conservées. Les bonus avec invocations ne sont pas qualifiés. Aucun code de jeu modifié, aucune case ni question fermée.

## Intégration et prérequis

Les trois fiches CH-Yorick-PASSIF-SOURCE, CH-Yorick-PASSIF-SIMULATION-CONTRAT et CH-Yorick-PASSIF-SIMULATION reçoivent sources,preuves et instructions complètes copiables. SYS-01.2-02 reçoit la synthèse.30ressources donnent90associations ;26points courants donnent52liens sur les deux fiches de simulation. Ces liens décrivent les traitements observés et leurs limites,pas un producteur accepté du passif.

Trois questions propres et quatre dépendances sont préservées. Les prérequis de phase/lot sont consignés dans le reçu sans être déclarés accomplis. Inconnues,identifiants et hiérarchie restent identiques octet par octet ;statuts,critères,acceptations et états manuels restent inchangés.

## Sources natives et travail restant

La découverte et le complément vérifient94ressources natives et34références communautaires,avec neuf exclusions initiales. Les tailles,SHA et appartenance au manifeste RADS sélectionné sont contrôlées. La racine historique du lecteur E:/OpenLeague est conservée ;la provenance communautaire reste distincte du serveur original.

| Ressource sélectionnée | Octets | SHA-256 |
|---|---:|---|
| Yorick.inibin | 2803 | d4877b8b58833648e82425135864ccab72a3f2107aa9457bd85678580f1c271c |
| Yorick.ddf | 396 | 837185282f6e7b3d686f012a9438ea40c37699df1a9ef1145efd0e3cf96442d8 |
| CharScriptYorick.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| CharScriptYorick.preload | 236 | e7f03e6feb005e666666092fb27481c7f2228d8f7814a11bf9b1e050e25a4848 |
| YorickUnholySymbiosis.inibin | 53 | 2e7e5a74c5c32bb41548abc385a3b2ef240940688ab88b86c12e7411c21e3451 |
| YorickUnholySymbiosis.luaobj | 226 | 5d96058b0da9ace0bd4d19807c281a3032f7efcdb024013f76ea3c4cb5cc699b |
| YorickBasicAttack.inibin | 1227 | 51e4afb769b55178e12c27e33e7ae6686a4394cdce63702e6a887aecea2c33cc |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |
| YorickSummonDecayed.inibin | 1474 | 892149a56141d9f14c41ec06d9366acd4dc6745e93690a1428b045e222b03f7c |
| YorickSummonDecayed.luaobj | 125 | 5894d5d848df45fdca19b1fdc7964b9c6dbf5b58458c0a69da075e575dee6a56 |
| YorickSummonDecayed.preload | 548 | 9dca5bccbe9c4a01526319cf96bee58e17a5f728e9c34d587c3a8d027d7bc52d |
| YorickDecayedLogic.luaobj | 164 | 834fb8d702a7e0a06708d4ca59366b52a033dbd1020d2ebdd22b868d6cc407ec |
| YorickSummonRavenous.inibin | 1466 | ece712ed72fa4d63f0be278aa75e889f463058b75ea3495ed703d5089875e699 |
| YorickSummonRavenous.luaobj | 125 | 5894d5d848df45fdca19b1fdc7964b9c6dbf5b58458c0a69da075e575dee6a56 |
| YorickSummonRavenous.preload | 313 | f93c28093019f92035b1ac1783ffde25f680ed69ce45704a338e16f11e9abcf8 |
| YorickRavenousLogic.luaobj | 160 | 91dea437d51828db36603f8fa4ac368be69feba94211e47858206f9ea25f2c93 |
| YorickSummonSpectral.inibin | 1482 | 6d1a3f0b7cf7428c75a2de1383153a3f29b64383f2447af02a437f2c94abe50c |
| YorickSummonSpectral.luaobj | 88 | 52ab9d3f798588de40abc1c3f9de55c472a8916a550b36b3d0601bc48f887de2 |
| YorickSummonSpectral.preload | 451 | 0d8e5281a991dc7ea716a8a6760b26c1eeccf5eed5223183d0b362c91196d50a |
| YorickSpectralLogic.luaobj | 157 | c91596b085cec44a0d7ecad0fba2f9f5b417c04849335c4d2149f057979101ba |
| YorickSpectral.inibin | 1536 | f55281be7277b05b02a54340ca0d482bb93426f6184c1b6f05ba8fb405bbb3a6 |
| YorickDecayed.inibin | 1544 | aca1965a9953b6ea285db318fd31cb55544d4aa012be89eb56e2e48d1aed361f |
| YorickRavenous.inibin | 1647 | 516a88a62f0492c1253ee3ff7120987e3f76be84032db60ca3538719511047a8 |
| YorickReviveAlly.inibin | 1439 | 2cb1eaf6fdb65bd035407a58d5c12da75e75316ebcdc5e9a73d0c7d9b0ea4072 |
| CharScriptYorickDecayedGhoul.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| YorickDecayedGhoul.inibin | 1772 | fe8774cd876f5fe12385bb1ded0f23c9206ac13872d547f9be0feff3fd4b2a60 |
| CharScriptYorickRavenousGhoul.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| YorickRavenousGhoul.inibin | 1922 | 13308738ac5c0de5c9e3a2273623027eb0b84cd32ec7d905bfb202a94e088c96 |
| CharScriptYorickSpectralGhoul.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| YorickSpectralGhoul.inibin | 1827 | 6702b89bf6c8616d1a6c203cd7c5841bd5cf04f12d992ab48f0dc2c270570f96 |

Les INIBIN de personnages et les sorts de même nom sont des fichiers différents. Le reçu les distingue par chemins complets et identités,notamment pour YorickRavenousGhoul et YorickSpectralGhoul. Les six ressources de personnages proviennent des trois dossiers DATA/Characters/Yorick*Ghoul ;leur collecte ne prouve pas un rendu ni une invocation.

V653 Yorick / Unholy Covenant : 30 sources natives, 90 associations, 26 points actuels et 52 liens de frontière. Texte natif5% par invocation et35%AD/PV pour les goules. Six attaques et six échantillons API de dégâts vérifiés à zéro invocation ; sorts Yorick refusés. Témoin Tibbers distinct : apparition après8ticks, guidage public, expiration1350ticks. 57 refus publics sans mutation, 5542 ticks, quatre apports XP serveur explicites. BUILD/RUN0,1158entrées conservées. Les bonus avec invocations ne sont pas qualifiés. Aucun code de jeu modifié, aucune case ni question fermée.

Objectif restant : qualifier Unholy Covenant à partir de la référence4.20 et relier son producteur au moteur réel. Yorick.inibin lie Passive1LuaName à YorickUnholySymbiosis, l’icône à YorickUnholyCovenant.dds et Passive1Name/Passive1Desc/PassLev1Desc1 aux textes exacts. Passive1 et Passive1Level1..6 sont absents, pas zéro. Le tooltip natif indique, pour chaque invocation active,5% de dégâts reçus en moins et5% de dégâts d’attaque ordinaire supplémentaires ; les goules ont35% de l’AD et des PV de Yorick. Ces nombres sont connus ; catégories comptées, plafond, cumul, ordre des modificateurs, types de dégâts concernés et moment d’échantillonnage restent à qualifier. Ne pas inventer un plafond de quatre ou une formule additive/multiplicative.

La découverte initiale comprend88ressources natives,31références communautaires et9exclusions. Le complément ajoute six ressources natives des personnages YorickDecayedGhoul,YorickRavenousGhoul,YorickSpectralGhoul et trois JSON communautaires. Les chemins de personnages et les sorts de noms proches sont distincts : ne pas les écraser dans une table indexée seulement par nom de fichier. Chaque goule déclare60PV,10AD,croissancePV/AD0,armure10,résistance magique20. Ces bases ne deviennent pas les statistiques finales après héritage35%. Les trois CharScripts de goules et celui de Yorick sont vides.41chunks Lua sont consommés entièrement,sans fonctions enfants,avec seuls littéraux qualifiés. La présence de métadonnées ne reconstitue pas les callbacks serveur.

UnholySymbiosis porte PersistsThroughDeath et NonDispellable ; cela ne prouve pas le cycle de vie. Les preloads SummonDecayed/Ravenous/Spectral référencent effectivement les trois personnages et leurs scripts Logic. Les marqueurs DoesntBreakShields et DoesntTriggerSpellCasts ne prouvent pas leurs politiques exécutées. Le DDF ne donne que YorickRavenous;f1=1,0bonusAD. Le E communautaire utilise l’AP dans son corps simplifié : conserver cette différence, sans importer sa formule comme règle native. Le R communautaire ajoute YorickRevenant et une particule ; ce n’est pas une copie de champion créée et validée. Les corps Q/W/E/R et le CharScript inspectés ne produisent pas Unholy Covenant. Le monde actuel ne contient aucune définition Yorick/goule ; les recherches bornées Rust et C# ne trouvent pas de producteur du passif dans leurs périmètres.

Diagnostic : Yorick niveaux1/18 contre Annie18,monde/navigation Map10 activés. Trois apports XP serveur explicites préparent ces deux cas. Quatre trajets publics Move/Stop réussissent sans réémission ;aucune injection directe de position,PV,rang,AD,invocation ou horloge. Trois attaques de mêlée par cas donnent des windups et dégâts physiques après armure/régénération vérifiables,tolérance0,004. Aucun pet possédé n’existe. Trois événements apply_damage serveur par cas (physique,magique,vrai,20bruts chacun) vérifient les défenses sans bonus d’invocation ;ils ne sont pas des sorts ennemis exécutés. Les quatre slots Learn/Cast/CastAt restent refusés avant/après,plus joueur inconnu,attaque de soi et slot invalide :54refus,snapshots inchangés.95ticks supplémentaires restent sans invocation. À zéro invocation,aucun bonus est compatible avec le texte ;ces observations ne testent pas les5% par invocation ni les35% hérités.

Témoin distinct : Annie seule rejoint Map10,passe18 via un quatrième apport XP serveur et apprend R rang1 par Learn. CastAt crée un pending puis Tibbers après8ticks. Le pet porte le bon propriétaire,1200PV,80AD,30armure et une durée1350ticks selon les valeurs courantes. Un second CastAt le guide vers un point valide. Un point non fini et un point trop éloigné sont refusés sans mutation. Le pet est présent aux ticks relatifs1/1349,absent du décompte actif à1350/1351. La tentative de nouvelle invocation avant la fin de recharge est refusée ;le retour complet de recharge et la suppression physique du cadavre ne sont pas attendus. Ces trois refus portent le total public à57. Ce témoin valide des routes actuelles d’apparition/propriété/guidage/expiration de Tibbers, pas les goules de Yorick,le Revenant ou la fidélité native des politiques d’IA.

Total5542ticks :2109 et2074 pour Yorick,1359 pour Tibbers ;six attaques,six événements API de dégâts,quatre apports XP. Le binaire utilise le vrai moteur non-test,identités/checksums alignés sur Cargo.lock ;1158entrées restent inchangées. Les sources natives et les références communautaires sont identifiées séparément. Aucun rendu,audio,HUD ou réseau n’est testé par ce diagnostic.

À compléter : producteur d’invocations et attribution au propriétaire,décompte des goules et du Revenant,cumul/plafond/rafraîchissement,statistiques35% (base/total,PVmax/courants,snapshot/dynamique,arrondis),perte de PV et durée des goules,effets5% sur types de dégâts et attaques renforcées,critique,pénétration et autres modificateurs. Vérifier apparition,mort,remplacement,retour et reconnexion,commande/IA,cibles,Q/W/E/R et réanimation,réseau,sauvegarde,HUD,icônes,particules,animations et audio. Préserver trois questions,quatre dépendances,anciens critères,preuves et états manuels. Ce lot relie les sources et consommateurs ;il ne termine ni Yorick ni le jeu.


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
| crates/core/src/annie_r.rs:23 | pub fn tibbers( |
| crates/core/src/annie_r.rs:26 | pub(crate) fn cast_tibbers( |
| crates/core/src/annie_r.rs:62 | pub(crate) fn advance_annie_r( |
| crates/core/src/annie_r.rs:44 | fn guide_tibbers( |
| crates/core/src/annie_r.rs:82 | pub(crate) fn advance_pet_orders( |
| crates/core/src/world.rs:265 | pub(crate) fn spawn_unit( |
| crates/core/src/annie_r.rs:20 | pub(crate) fn combat_owner( |

Les recherches bornées Yorick dans les fichiers Rust et UnholySymbiosis/UnholyCovenant dans les scripts communautaires ne trouvent pas de producteur dans ces périmètres. Le catalogue du monde actuel ne contient aucune définition de goule. Les profils de champion et les fichiers natifs existent :ce constat ne signifie pas que tous les assets manquent.

Les routes de dégâts,statistiques et défenses sont testées à zéro invocation. Les routes annie_r,tibbers,spawn_unit,guide_tibbers,advance_pet_orders et combat_owner ne sont pas promues comme logique Yorick. Chaque nouveau consommateur est entry_boundary_only,provides_feature_consumer=false et gameplay_accepted=false.

## Contrôles exécutés

| Niveau Yorick | Invocations possédées | Impacts ordinaires | Ticks |
|---:|---:|---:|---:|
| 1 | 0 | 3 | 2109 |
| 18 | 0 | 3 | 2074 |

Attendu du diagnostic :windup exact,impact de mêlée sans critique/projectile,dégâts après armure/régénération avec écart inférieur à0,004 ;trois types de dégâts entrants selon la mitigation courante ;refus sans mutation. Observé :six impacts,six événements API entrants,54refus Yorick et zéro invocation. Les95ticks après les impacts restent sans invocation. Cela est compatible avec un bonus nul à décompte zéro et ne qualifie pas les5%/35%.

Contrôle Tibbers séparé :un Learn R rang1 après apport XP,un CastAt puis apparition au tick8,un CastAt de guidage,propriétaire exact,1200PV/80AD/30armure. Présence active à1/1349ticks après apparition,absence à1350/1351. Deux guidages invalides et une réinvocation pendant recharge sont refusés sans mutation. Retour de recharge,suppression du cadavre,dommages offensifs du pet et fidélité de ses politiques d’IA ne sont pas vérifiés ici. Total57refus publics,5542ticks et quatre apports XP explicites ;aucune injection directe d’état.

Binaire F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-yorick-unholy-covenant-probe.exe ;6074368octets ;SHA-256 0809d39d8485f1fb265b4c77c44c955991fe1013dee0a74079e0692e736cf038. Le compilateur utilise F:/OpenLeague/crates/core/src/lib.rs avec profile.test=false,dépendances/checksums alignés sur Cargo.lock.1158entrées moteur/ressources identiques avant/après. Aucun code de jeu ni asset modifié.

## Vérification de livraison

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | cfaf7f5c65356f8b90849bbf8f11a4529a033a47b0a3421a5771d2a939869d70 |
| RUN | 0 | 1ad03aff2078e0e170bb15aa514b435bbbc035281526452cd6406d641103a234 |
| prepare | 0 | 3ab1dc3220834f179e0c5b0cd03147a367d9f0ea10d8254ccec4bfc13af8091c |
| check | 0 | 33cb102cdf0cf1b7045732ee1f30cdf4342423d8368e28cdd05b6e370477ed8a |
| publish | 0 | 413cabb39aac664657e14abc1fa913144ef73bc9e39b308182d1d49aca267e8a |
| audit | 0 | 8c8c769cf8c2d548600d6571e53d4641a3da6b362318d57e2bec3d210834528b |

Découverte,complément goules,inspection,BUILD/RUN et les quatre étapes de livraison réussis.60associations falsifiées et quatre graphes invalides sont refusés. Trois fragments courts changent,42212restent identiques. Les instructions complètes des quatre destinataires sont relues par Store.task/copy_text,avec résolution réelle des sources,questions et dépendances.

Les deux bases conservent42603autres lignes du catalogue,42607états manuels et23historiques. Intégrité et synchronisation idempotente vérifiées. Revue indépendante :5270ancres/empreintes exactes,aucun problème,pour99287sources enregistrées. Elle ne rehache pas toutes les sources historiques et ne mesure pas l’achèvement du jeu.

## Fichiers et preuves

Registres modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json,docs/fidelity_sources_4_20.json. Reçu F:\OpenLeague\docs\reference_requirement_trace_sources\yorick-passive-unholy-covenant-links-v653.json. Vérification F:\OpenLeague\docs\fidelity_yorick_passive_unholy_covenant_links_v653.json. Bases :F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json,docs/completion_plan.json,docs/resume_checkpoint.json,docs/ai/CURRENT.md etdocs/ai/HANDOFF.md.

Découverte F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision653_Yorick_discovery\OBSERVATIONS.json. Complément F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision653_Yorick_ghoul_sources/OBSERVATIONS.json. Diagnostic F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision653_Yorick_passive_probe\OBSERVATIONS.json. Inspection F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision653_Yorick_inspection/OBSERVATIONS.json. Audit F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision653_Yorick/DELIVERY_AUDIT.json. Revue F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision654_trace_review\REVIEW.json. Scripts et binaires conservés.

Neuf copies privées de validation archivées avec SHA décompressés vérifiés avant retrait des seuls doublons bruts ;gain logique 2491570414octets. Reçu F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision653_Yorick/snapshot-archives/VERIFIED.json. Sources enregistrées et bases actives intactes ;restauration explicite par revision653_restore_validation_snapshots.py,non exécutée après archivage.

## Limites et suite

Les nombres5%/35% sont connus. Décompte/catégories/plafond,cumul,producteur de goules et Revenant,héritage des statistiques,ordre des dégâts,cycle de vie,Q/W/E/R et réanimation restent ouverts. HUD,rendu,audio,sauvegarde et réseau nécessitent des preuves séparées. Ni Yorick ni le jeu ne sont déclarés terminés.

Continuer SYS-01.2-02 depuis revision654_trace_review/REVIEW.json. V653 Yorick Unholy Covenant publié et audité :30sources natives,90associations,26points/52liens. Texte5% par invocation et35%AD/PV pour les goules. Six définitions/scripts de goules supplémentaires vérifiés,CharScripts vides,aucune goule dans les définitions du monde actuel. Six attaques et six événements API de dégâts à zéro invocation,sorts refusés ;ce cas ne teste pas les bonus non nuls. Témoin Tibbers public :apparition8ticks,guidage,expiration1350ticks,HP1200/AD80/armure30.57refus publics,5542ticks,quatre apports XP,1158entrées conservées. Décompte,plafond,cumul,héritage et cycle de vie Yorick ouverts. Prochain lot :Zac PASSIF,contrat encore au chargeur partagé selon revue actuelle ;inspecter blobs,soins et résurrection avant diagnostic. Snapshots V653 archivés/restaurables explicitement par revision653_restore_validation_snapshots.py. Goal actif. Première découverte Zac exécutée0 :revision654_Zac_discovery/OBSERVATIONS.json,63sources natives,21références communautaires,6exclusions. Deux limites NEWTABLE sur ZacE/ZacW. Distinguer fragments de soin et quatre bloblets de recomposition ;examiner séparément DATA/Characters/ZacRebirthBloblet et ses consommateurs. Aucun diagnostic moteur Zac exécuté. Les textes mentionnent4%PVmax,8secondes,10–50%PV,12%PVmax/50%défenses par bloblet,5minutes ;vérifier leurs liens et producteurs avant promotion.
