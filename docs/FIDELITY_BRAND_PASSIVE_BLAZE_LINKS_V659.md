# SYS-01.2-02 — Brand / Blaze, V659

Date UTC 2026-10-27T04:51:21.707966+00:00. Référence PUBLIC4.20.0.315, EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau et déploiement non établis. Catalogue4.20.1 distinct.

V659 Brand / Blaze : 16 sources natives, 48 associations, 22 points actuels et 44 liens de frontière. Texte4.20 : 8%PVmax en dégâts magiques sur4secondes, plafond annoncé80par seconde contre monstres ; interactions Q/W/E/R conservées. Sorts Brand refusés ; quatre attaques ordinaires, huit contrôles API magiques et deux tirs publics Annie Q distincts. 70 refus publics et 20 refus API sans mutation, 9239 ticks, six apports XP serveur. BUILD/RUN0,1158entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

## Intégration et prérequis

Les trois fiches CH-Brand-PASSIF-SOURCE, CH-Brand-PASSIF-SIMULATION-CONTRAT et CH-Brand-PASSIF-SIMULATION reçoivent sources, preuves et instructions complètes copiables. SYS-01.2-02 reçoit la synthèse.16ressources donnent48associations ;22points courants donnent44liens sur les deux fiches de simulation. Tous restent entry_boundary_only, provides_feature_consumer=false et gameplay_accepted=false.

Trois questions propres et quatre dépendances sont préservées. Les prérequis de phase/lot sont consignés sans être déclarés accomplis. Inconnues, identifiants et hiérarchie restent identiques octet par octet ; statuts, critères, acceptations et états manuels restent inchangés.

## Sources et instructions de reprise

48ressources natives et19références communautaires inspectées ;neuf exclusions conservées. Tailles, SHA et appartenance au manifeste RADS sélectionné vérifiés. Le lecteur conserve sa racine historique E:/OpenLeague ; le projet courant est F:/OpenLeague. Les références communautaires restent distinctes du serveur original.19Lua lus,neuf limites NEWTABLE conservées,aucune fonction enfant. Aucun DDF dans le périmètre inspecté.

| Ressource sélectionnée | Octets | SHA-256 |
|---|---:|---|
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\BrandAblaze.luaobj | 247 | f10e09a943dd994b1e2b99005bfa83ee72a4865a2fd13308d2f601e460fbc747 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\BrandAblaze.preload | 479 | 7f78bbd68cf0481485c6d2f8abc04e9682c9158e643286143b15d7fd5c98b2d3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Brand\Brand.inibin | 2174 | d49d2973143e648ec983da45ce91cb46b6c7017ec00abd30693180e8582ab54c |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Brand\Scripts\CharScriptBrand.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Brand\Scripts\CharScriptBrand.preload | 358 | bf19024bfcd11c30ef4e552d23767f8879b67ae75ce7cca858a2f5c2c1355c69 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\BrandPassive.inibin | 44 | 39c17095b4b12cecd002908bd25fbe90e36bd136fa35a393fbbf942ec9885c32 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\BrandPassive.luaobj | 179 | 1183d9b0fee76b6a468aadc8730336b1333e9aec0bef5d96d5ee8045387b841f |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\BrandAblaze.inibin | 1429 | 188ea506da34c6d6f14a6207ce83b5b8ed483395cc61ac6e26d4f10d0ee4b630 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\menu\fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\BrandBlaze.inibin | 1376 | eea239a25397c5526167de738394857778139e119f36671966a86094bc8d59fb |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\BrandFissure.inibin | 1441 | 353e78759bd6c7b559dd162b9cf27f66b3a66d325f6f8caecc2542fb429b5394 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\BrandConflagration.inibin | 1621 | ed871c0b00ba87d800d0e1e4d071e0ada75f28a6c142e0d3c489388dd13c9f04 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\BrandWildfire.inibin | 1283 | 9d7f93241ba614050daede6f546a8ae3eecf26a00b99985689acfb7bd8e964c7 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\BrandPassiveRunspeed.luaobj | 90 | 0b936e4b235f178501c4b0a41735e6e80944f715b24b4a523e28570f8020d45a |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\BrandPassiveSound.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Spells\BrandZombieResurrection.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |

V659 Brand / Blaze : 16 sources natives, 48 associations, 22 points actuels et 44 liens de frontière. Texte4.20 : 8%PVmax en dégâts magiques sur4secondes, plafond annoncé80par seconde contre monstres ; interactions Q/W/E/R conservées. Sorts Brand refusés ; quatre attaques ordinaires, huit contrôles API magiques et deux tirs publics Annie Q distincts. 70 refus publics et 20 refus API sans mutation, 9239 ticks, six apports XP serveur. BUILD/RUN0,1158entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

Objectif restant : qualifier Blaze4.20 et relier son producteur réel. Brand.inibin indique Passive1LuaName=BrandPassive, icôneBrandBlaze.dds, Passive1Name et PassLev1Desc1 vers les textes exacts. Passive1,Passive1Desc et Passive1Level1..6 sont absents,pas zéro. Le nom natif BrandBlaze désigne le Q/Sear, distinct du nom affiché Blaze du passif. Les descriptions donnent8%des PVmaximum en dégâts magiques sur4secondes ; le BuffData et la description BrandAblaze annoncent un maximum80dégâts par seconde contre les monstres. Le tooltip Ablaze indique des dégâts chaque seconde. Origine du premier tick, inclusion des bornes, instant de capture des PVmax, arrondis, renouvellement/cumul et application du plafond avant/après mitigation restent à établir.

Interactions natives :Q étourdit2secondes une cible déjà embrasée ;W inflige25%de dégâts supplémentaires aux unités embrasées ;E se propage aux ennemis proches si sa cible est embrasée ;R privilégie les champions pour le rebond suivant si la cible est embrasée. L’ordre lecture/application de l’état, les catégories éligibles, la portée de propagation et l’algorithme exact des rebonds restent ouverts. Ne pas importer une explosion ou des règles d’une version ultérieure.

48ressources natives et19références communautaires inspectées, neuf exclusions conservées.19chunks Lua lus entièrement sans fonctions enfants ; neuf limites NEWTABLE du lecteur conservées. Aucun DDF dans le périmètre inspecté. Le CharScript natif est vide. BrandPassive.inibin contient seulement le lien BuffData. BrandPassive.luaobj déclare l’icône, le BuffName et PersistsThroughDeath=true ; ces métadonnées ne sont pas un callback serveur de brûlure. Le preload de personnage contient brandpassive,brandpassivesound,brandpassiverunspeed et brandzombieresurrection. Runspeed ne déclare qu’une persistance ; Sound et ZombieResurrection sont vides. Ces noms ne valident ni vitesse,ni résurrection,ni audio.

BrandAblaze.inibin possède deux contextes distincts :le BuffData pointe vers le texte valide de dégâts chaque seconde, mais SpellData pointe vers game_spell_tooltip_BrandAblaze, absent du fontconfig exact. Conserver ce lien non résolu sans réécriture automatique. BrandAblaze.luaobj et .preload sont présents et vérifiés. Le Lua déclare NotSingleTargetSpell=true,DoesntTriggerSpellCasts=false,BuffName=BrandAblaze,BrandBlaze.dds et IsDeathRecapSource=true,sans fonctions enfants. Le preload référence six particules de base,frost et zombie ; leur affichage et leur audio ne sont pas exécutés ici. Une première inspection a échoué sur une hypothèse erronée d’absence de ces deux fichiers ; son script et son erreur sont conservés, puis la présence et les métadonnées sont vérifiées par un nouvel inspecteur avant publication. Les champs SpellData ressemblent au Q :coefficient0,65,dégâts80/120/160/200/240,CastRange25000. Ils ne constituent pas la formule8%PVmax du passif ni une portée native acceptée.

La recherche bornée dans crates/core/src ne trouve aucun Brand/Blaze. Les scripts C# communautaires de Q/W/E/R appellent ou testent BrandAblaze, mais la recherche bornée ne trouve pas sa classe d’implémentation ; le CharScript est vide. Leurs simplifications ne sont pas le serveur original ni un consommateur Rust. Les références et leurs limites sont conservées séparément.

Diagnostic réel :quatre simulations séparées Brand1/18 et contrôles Annie1/18 contre Annie18 sur Map10, sans injection directe de position,PV,horloge,statistique ou unité. Six apports XP par API serveur préparent les niveaux ; huit trajets Move/Stop publics réussissent sans réémission. Chaque simulation exécute une attaque ordinaire avec projectile et dégâts physiques attendus selon l’armure. Après Stop,151ticks sont suivis :seule la régénération attendue est observée. Cette attaque ordinaire n’est pas un déclencheur natif revendiqué du passif.

Deux événements distincts de40dégâts magiques bruts par simulation sont envoyés par apply_damage(Some(propriétaire),cible,...), puis suivis pendant151ticks. Les PV retirés correspondent à40×100/(100+RM), sans dégâts supplémentaires observés pendant ce contrôle. Ces appels serveur ne sont pas des sorts Brand, n’exercent pas un renouvellement de brûlure et ne prouvent pas une autorité joueur ou une portée de sort. NaN,infini,négatif,source inconnue et cible inconnue sont refusés sans mutation :20refus API au total.

Pour Brand,Learn,Cast et CastAt des quatre slots sont refusés avant et après les contrôles ; ajouter les refus de joueur inconnu,attaque de soi et slot invalide. Pour les deux Annie de contrôle,LearnQ et CastQ publics réussissent :80bruts,60mana,délai8ticks,recharge120ticks,projectile puis dégâts magiques attendus. L’ordre courant est dégâts AnnieQ avant régénération ; les attaques ordinaires appliquent leurs dégâts après régénération. Cibles absente/soi/inconnue,relancement pendant incantation et avant recharge sont refusés. Un suivi151ticks après chaque Q ne montre aucun dégât supplémentaire. Ce contrôle Annie ne valide ni Blaze ni la fidélité complète d’Annie.

Total70refus publics+20API,quatre attaques,huit événements API magiques,deux QAnnie,dix horizons151ticks,9239ticks simulés. Binaire non-test du vrai moteur F:/OpenLeague/crates/core/src/lib.rs, dépendances/checksums alignés sur Cargo.lock et1158entrées inchangées. Aucun rendu,audio,réseau ou serveur historique exécuté.

À compléter :producteur de l’état Ablaze et des dégâts périodiques,instant du premier tick,durée,bornes,PVmaxdynamiques,renouvellement,cumul,multi-sources,arrondis et plafond monstre. Qualifier mitigation,boucliers,immunités,crédit de kill,disparition/mort des acteurs,catégories champion/sbire/monstre/structure et interactions Q/W/E/R. Résoudre le tooltip SpellData absent et les candidats numériques hérités. Relier séparément réplication,sauvegarde,HUD/icônes,particules,modèles/animations et audio. Préserver les trois questions,quatre dépendances,critères,preuves,notes et états manuels. Cette étape de traçabilité laisse l’implémentation du passif ouverte.


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
| crates/core/src/damage.rs:53 | pub fn apply_damage( |
| crates/core/src/damage.rs:38 | pub fn mitigate( |
| crates/core/src/penetration.rs:9 | pub(crate) fn penetrated_defenses( |
| crates/core/src/attacks.rs:157 | pub(crate) fn advance_attacks( |
| crates/core/src/lifesteal.rs:4 | pub(crate) fn basic_attack_hit( |
| crates/core/src/regeneration.rs:10 | pub fn regeneration_rates( |
| crates/core/src/regeneration.rs:32 | pub(crate) fn advance_regeneration( |
| crates/core/src/annie.rs:45 | pub(crate) fn cast_annie( |
| crates/core/src/annie.rs:73 | pub(crate) fn advance_annie( |
| crates/core/src/lib.rs:149 | pub fn champion_catalog( |
| crates/core/src/world.rs:226 | pub(crate) fn target_info( |
| crates/core/src/world.rs:244 | pub fn protected( |

La distribution des commandes refuse les sorts de Brand. Les chemins d’attaque ordinaire, dégâts, mitigation, pénétration, régénération et progression sont inspectés et exercés. Le chemin AnnieQ sert de contrôle distinct. Aucun de ces points n’est qualifié comme producteur de Blaze. La recherche bornée sans Brand/Blaze dans crates/core/src ne prouve pas une absence dans toutes les archives.

## Résultats attendus et observés

| Champion | Niveau | Tirs Annie Q | Refus publics | Refus API | Ticks simulés |
|---|---:|---:|---:|---:|---:|
| brand | 1 | 0 | 27 | 5 | 2216 |
| brand | 18 | 0 | 27 | 5 | 2215 |
| annie | 1 | 1 | 8 | 5 | 2405 |
| annie | 18 | 1 | 8 | 5 | 2403 |

Quatre attaques ordinaires ont un projectile observé et des dégâts physiques égaux au calcul avec l’armure, tolérance0,004. Huit événements API magiques distincts de40bruts retirent40×100/(100+RM)PV. Les deux AnnieQ publics produisent80bruts,60mana,délai8ticks,recharge120ticks et un projectile suivi jusqu’à l’impact. Les résultats sont recalculés indépendamment dans l’inspection ; l’ordre de régénération différent entre attaque ordinaire et AnnieQ est conservé.

Dix horizons de151ticks suivent ces contrôles. Les échantillons encadrent notamment30,60,90 et120ticks ;aucun dégât supplémentaire n’est observé. L’absence après une attaque ordinaire ou un appel API ne teste pas un déclencheur natif de Blaze. Les sorts Brand sont refusés :leurs dégâts périodiques,renouvellement,cumul,plafond contre monstres et interactions Q/W/E/R restent non exercés.

70refus publics et20refus API conservent les snapshots. Six apports XP serveur,huit trajets publics sans réémission,aucune injection directe d’état. Les événements API ne prouvent pas une autorité du joueur ni une portée de sort. Aucun code de jeu ou asset modifié.

Binaire F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-brand-blaze-probe.exe ; 6102016octets ; SHA-256 2844634b7e74547ed7f0af68f758d3225de025061a1767f5871b80c2160d26b3. Compilation du vrai F:/OpenLeague/crates/core/src/lib.rs avec profile.test=false ; dépendances/checksums alignés sur Cargo.lock.1158entrées moteur/ressources identiques avant/après.

## Échec conservé et correction

Le premier inspecteur revision659_brand_inspection.py s’est arrêté avec code1 sur une hypothèse erronée d’absence de BrandAblaze.luaobj et .preload. Ces deux fichiers figuraient déjà dans la découverte de48sources ; leur présence, métadonnées et six preloads de particules sont vérifiés par revision659_brand_inspection_presencechecked.py. Le premier script reste intact et son échec est décrit dans F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision659_inspection_first_failure.json. Aucune publication n’a précédé cette correction. La formule et les callbacks de dégâts restent distincts des métadonnées présentes.

## Vérification de livraison

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 8160261274efb4573d0c10eef0047619ddd43990f8647d4491172eb554c0f96b |
| RUN | 0 | 432fa0fc6310f3dd3fa368098f05bb49cd91f4e72ac645bb2a0f9562ad142921 |
| prepare | 0 | e16fb03de67c212afd70fc366e359859178957972de365fbef058ba560506666 |
| check | 0 | 4ddf595d2a7096eb6e758b7e1e432c18cd2f6507904af18fd5356f228798debe |
| publish | 0 | 3f6c4c7608afedbc46cf32234a9eaf420a89d97cb13a9c8681b638cced669c97 |
| audit | 0 | 99c15f9daeecd690da62cdaaed15f1259323d5ec7b192879626d2eb031b555f0 |

Découverte, inspection corrigée, BUILD/RUN et quatre étapes de livraison réussis.60associations falsifiées et quatre graphes invalides refusés. Trois fragments courts changent,42212restent identiques. Les instructions complètes des quatre destinataires sont relues par Store.task/copy_text avec résolution des sources,questions et dépendances.

Les deux bases conservent42603autres lignes du catalogue,42607états manuels et23historiques. Intégrité et synchronisation idempotente vérifiées. Revue indépendante :5400ancres/empreintes exactes,aucun problème,pour99311sources enregistrées. Elle ne rehache pas toutes les sources historiques et ne mesure pas l’achèvement du jeu.

## Fichiers et preuves

Registres modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json,docs/fidelity_sources_4_20.json. Reçu F:\OpenLeague\docs\reference_requirement_trace_sources\brand-passive-blaze-links-v659.json. Vérification F:\OpenLeague\docs\fidelity_brand_passive_blaze_links_v659.json. Bases :F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json,docs/completion_plan.json,docs/resume_checkpoint.json,docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision659_Brand_discovery\OBSERVATIONS.json. Diagnostic F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision659_Brand_passive_probe\OBSERVATIONS.json. Inspection F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision659_Brand_inspection_presencechecked/OBSERVATIONS.json. Audit F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision659_Brand/DELIVERY_AUDIT.json. Revue F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision660_trace_review\REVIEW.json. Scripts,binaire et premier échec conservés.

Neuf copies privées archivées avec SHA décompressés vérifiés avant retrait des seuls doublons bruts ;gain logique 2554845029octets. Reçu F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision659_Brand/snapshot-archives/VERIFIED.json. Sources enregistrées et bases actives intactes ;restauration explicite par revision659_restore_validation_snapshots.py,non exécutée après archivage.

## Limites et suite

La règle générale de Blaze et ses interactions sont décrites dans les sources4.20, mais le producteur de la brûlure n’est pas relié aux chemins courants. Premier tick,bornes,cumul,renouvellement,PVmaxdynamiques,plafond monstre,mitigation et comportements multi-sources restent ouverts. Le tooltip SpellData BrandAblaze est absent du fontconfig exact ;les champs ressemblant au Q ne sont pas promus en formule du passif. Les callbacks et le serveur historique n’ont pas été exécutés. Rendu,HUD,audio,réseau et sauvegarde nécessitent des contrôles séparés. Ni Brand ni le jeu ne sont déclarés terminés.

Continuer SYS-01.2-02 depuis revision660_trace_review/REVIEW.json. V659 Brand Blaze publié et audité :16sources natives,48associations,22points/44liens.48sources inspectées,19références communautaires ;texte8%PVmax sur4s,max80par seconde contre monstres et interactions Q/W/E/R. Quatre simulations Brand/Annie niveaux1/18 :Brand Learn/Cast/CastAt refusés ;quatre attaques ordinaires,huit événements API magiques,deux AnnieQ publics distincts ;70refus publics+20API,9239ticks,1158entrées conservées,BUILD/RUN0. Brûlure native,renouvellement,cumul,plafond monstre et interactions non exercés. Premier inspecteur arrêté sur hypothèse erronée d’absence de BrandAblaze.luaobj/preload ;les deux fichiers présents sont reliés et leur métadonnée exacte vérifiée par inspection_presencechecked. Échec conservé,aucune publication antérieure à la correction. Tooltip SpellData BrandAblaze non résolu ;coeff0,65/dégâts80..240 pas promus en formule passive. Prochain lot :Braum PASSIF,contrat encore au chargeur partagé selon revue actuelle ;inspecter Concussive Blows4.20 avant diagnostic. Snapshots V659 archivés/restaurables par revision659_restore_validation_snapshots.py. Goal actif. Première découverte Braum exécutée0 :revision660_Braum_discovery/OBSERVATIONS.json,290ressources natives,dont181sous Deprecated,47références communautaires,6exclusions. Utiliser les chemins complets :six noms E/Q/W existent aussi sous Deprecated.125Lua lus sans fonctions enfants,45limites NEWTABLE ;un DDF48lignes ne remplit pas les paramètres BraumMark du tooltip. Alias BraumMarkDamageTracker/icône Braum_Passive.dds. Texte :première marque par attaque ou Q,puis attaques alliées,quatre marques déclenchent étourdissement/dégâts,période immunisée avec dégâts supplémentaires de Braum. Paramètres f1/f2/f3/f5 non qualifiés. MarkCounter et DamageTracker conservent des références Kennen. Aucun diagnostic moteur Braum exécuté.
