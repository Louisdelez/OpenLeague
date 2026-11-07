# SYS-01.2-02 — Zed / Contempt for the Weak, V655

Date UTC 2026-10-27T03:33:57.475628+00:00. Référence PUBLIC4.20.0.315,EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau et déploiement non établis. Catalogue4.20.1 distinct.

V655 Zed / Contempt for the Weak : 16 sources natives, 48 associations, 20 points actuels et 40 liens de frontière. Texte natif : cible sous 50% de PV, bonus magique de 6–10% des PV maximum, recharge de 10 secondes par cible. Dix-huit attaques publiques observées sans bonus magique aux niveaux 1/18, dont deux premiers impacts exactement à 50%. Contrôle magique API distinct réussi. 162 refus publics et 18 refus API sans mutation, 13362 ticks, neuf apports XP et huit préparations de PV par API explicites. BUILD/RUN 0, 1158 entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

## Intégration et prérequis

Les trois fiches CH-Zed-PASSIF-SOURCE,CH-Zed-PASSIF-SIMULATION-CONTRAT et CH-Zed-PASSIF-SIMULATION reçoivent sources,preuves et instructions complètes copiables. SYS-01.2-02 reçoit la synthèse.16ressources donnent48associations ;20points courants donnent40liens sur les deux fiches de simulation. Tous ces points sont entry_boundary_only,provides_feature_consumer=false et gameplay_accepted=false.

Trois questions propres et quatre dépendances sont préservées. Les prérequis de phase/lot sont consignés sans être déclarés accomplis. Inconnues,identifiants et hiérarchie restent identiques octet par octet ;statuts,critères,acceptations et états manuels restent inchangés.

## Sources et contrat restant

109ressources natives et37références communautaires inspectées,neuf exclusions conservées. Tailles,SHA et appartenance au manifeste RADS sélectionné vérifiés. Le lecteur conserve sa racine historique E:/OpenLeague ;la provenance communautaire reste distincte du serveur original.

| Ressource sélectionnée | Octets | SHA-256 |
|---|---:|---|
| Zed.inibin | 2028 | 0fa7bf92de960df7d36cfb257b779c7527e25bf8be4ba73db213d27352ac0d5c |
| CharScriptZed.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| CharScriptZed.preload | 1023 | 4af59bc51939000131abf3629201ce15d60d362ac08d732078dbe7280cf38d1a |
| Zed.ddf | 3398 | 4fd9c752adcd53f7cab085d65b7cf5dc0578dfbcc45939782148443b2b7a0551 |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |
| ZedPassive.luaobj | 225 | 454a458b6406ab8884ad8b38278cbfeea213d3cf9472d6da06aa70819ef72fbd |
| ZedPassiveToolTip.inibin | 49 | fafa02124092fa201f1e70de2b165127e659a621cfa16708280a63abca0bf653 |
| ZedPassiveToolTip.luaobj | 135 | 8f7cb57942062173459b3455c18cf425f975c9c3f77e95731b74893700b4bc3f |
| ZedPassiveCD.inibin | 44 | 0f26b157193a51438d31c9e688e3ca3211b382254a99dc8646c3b79867baaa9d |
| ZedPassiveCD.luaobj | 148 | 0eabe1481b2dc756bfb4ddedf432edf55798912bc44d22d9f175ff1cce55008d |
| ZedNewPassive.luaobj | 112 | 638b3ec5421029c4b35c6acfa01354160c5449b635b0a877fd3087497e7ba582 |
| ZedNewPassive.preload | 91 | 598ef1163281dd50984911de2cc021cc814e04c67e53857fced2d79a867125c7 |
| ZedNewPassive2.luaobj | 112 | 638b3ec5421029c4b35c6acfa01354160c5449b635b0a877fd3087497e7ba582 |
| ZedWPassiveBuff.inibin | 47 | 11ba9a46d03f678f54bb5fe9d837050eaaa1f2ce28065419b4b149b591e6930c |
| ZedWPassiveBuff.luaobj | 185 | f9c0a1e59a47d0c66a0b906bcbd1e3e993d25cddc238a700cf94adadcb8caa9d |
| ZedBasicAttack.inibin | 958 | bd6988a4af840a312c70428ec5fd9e13b43fd965af5cb8b52cf342a550e9c05f |

V655 Zed / Contempt for the Weak : 16 sources natives, 48 associations, 20 points actuels et 40 liens de frontière. Texte natif : cible sous 50% de PV, bonus magique de 6–10% des PV maximum, recharge de 10 secondes par cible. Dix-huit attaques publiques observées sans bonus magique aux niveaux 1/18, dont deux premiers impacts exactement à 50%. Contrôle magique API distinct réussi. 162 refus publics et 18 refus API sans mutation, 13362 ticks, neuf apports XP et huit préparations de PV par API explicites. BUILD/RUN 0, 1158 entrées conservées. Aucun code de jeu modifié, aucune case ni question fermée.

Objectif restant : qualifier Contempt for the Weak sur la référence4.20 et relier son producteur réel. Zed.inibin déclare Passive1LuaName=ZedPassiveToolTip et l'icône shadowninja_P.dds. Passive1Name et PassLev1Desc1 lient les textes exacts. Passive1,Passive1Desc et Passive1Level1..6 sont absents,pas zéro. Le tooltip décrit une attaque ordinaire contre une cible sous50%PV donnant @f1@% de ses PVmaximum en dégâts magiques,une fois toutes les10secondes par cible. La description du personnage précise6–10%. Les paliers par niveau,le producteur f1,le moment exact du test de PV et les règles d'arrondi restent ouverts.

Sources :109ressources natives,37références communautaires et neuf exclusions.49chunks Lua entièrement lus,sans fonction enfant ;12limites NEWTABLE conservées. Le CharScript est vide. ZedPassiveToolTip.luaobj donne BuffName et PersistsThroughDeath ;le fichier distinct ZedPassive.luaobj porte le même BuffName mais l'icône AkaliTwinDisciplines et la particule Zed_Passive_Stage1. Les alternatives ZedNewPassive/ZedNewPassive2 portent ZiggsPassiveReady.dds. Conserver tous ces candidats sans choisir une précédence d'exécution inventée. Le buff ZedPassiveCD décrit la cible récemment affectée,sans livrer un callback de recharge. ZedWPassiveBuff concerne un bonus d'AD du W,distinct du passif étudié.

Le DDF contient72lignes,dont17liens/coefficients remplis :trois concernent AkaliShadowDance/AkaliShadowSwipe et les autres des sorts Zed. Aucun nom Passive n'y figure. Ne pas transformer ces coefficients de sorts ou les anciennes entrées Akali en formule6–10% du passif. Les Q/W/E/R communautaires et leur CharScript simplifiés ne produisent pas ZedPassive dans le périmètre inspecté. Les recherches bornées Rust (préfixe de mot Zed/Contempt) et C# (ZedPassive/Contempt) ne trouvent pas de producteur. Le préfixe de mot évite les faux résultats dans «normalized/serialized». La présence des sources,icônes et profils ne signifie pas une implémentation complète.

Diagnostic :six simulations séparées avec vraie navigation/monde Map10,Zed niveaux1/18 contre Annie18 et cible préparée à60%,50%,40%PV. Neuf award_experience serveur préparent les niveaux ;douze trajets Move/Stop publics réussissent sans réémission. Les PV cibles sont préparés via apply_damage/heal autoritaires explicitement tracés,et non par modification directe des structures. Les deux cas50% ajoutent une préparation juste avant la libération du windup pour compenser la régénération du tick :la valeur avant impact est exactement la moitié des PVmaximum. Huit préparations API au total. Position,horloge,rangs et statistiques ne sont pas injectés directement.

Trois attaques publiques par cas :premier impact,puis un second à46ticks (niveau1) ou30ticks (niveau18),puis un troisième à312/309ticks après le premier. Les instantanés299/300/301ticks sont conservés. Chaque windup cible le bon adversaire et se libère au tick prévu,sans critique ni projectile. Les18pertes de PV correspondent à AD*100/(100+armure),après prise en compte de la régénération,avec erreur inférieure à0,004. Aucun supplément magique n'est observé,notamment lors des impacts réellement sous50%. Les premiers impacts exactement à50% font passer la cible sous le seuil,mais cela ne décide pas l'ordre natif du test faute de producteur exécuté.

Le calcul contrefactuel6–10%PVmax après la résistance magique actuelle sert seulement à montrer l'échelle d'un éventuel supplément. Ce n'est ni une formule native exacte par niveau ni une acceptation du premier impact. Une recharge ne peut pas être déclarée expirée lorsqu'aucun effet n'a été déclenché :les observations au-delà de300ticks vérifient l'absence persistante du producteur courant,pas la recharge native. Les changements de cible et propriétaires multiples restent non testés.

Contrôle distinct :un appel apply_damage magique de20bruts par cas retire le montant attendu après résistance magique,sans bouclier ni décès. Les demandes magique NaN,infini et négative sont refusées sans mutation. Cela valide le trajet générique des dégâts magiques,et non un déclenchement de Zed. Les commandes Learn/Cast/CastAt pour les quatre slots sont refusées avant et après les attaques,avec joueur inconnu,attaque de soi et slot invalide :162refus publics.18refus API s'y ajoutent. Total13362ticks,18impacts,six contrôles magiques,neuf apports XP,huit préparations PV. Le binaire non-test consomme le vrai moteur,les dépendances/checksums concordent avec Cargo.lock et1158entrées restent inchangées. Aucun rendu,HUD,audio,réseau ou serveur historique n'est exécuté.

À compléter :résoudre le producteur f1 et les paliers6–10%,le test strict du seuil avant/après l'impact physique,les cibles admissibles(champions,sbires,monstres,structures),les bornes/caps éventuels,la mitigation et les interactions avec critique,boucliers,pénétration et effets d'attaque. Qualifier recharge par cible et propriétaire,rafraîchissement,suppression,retour de cible,changement de cible,mort/respawn et reconnexion. Distinguer le W et les ombres de ce passif. Qualifier séparément réseau,sauvegarde,HUD,icônes,particules,animations et son. Préserver trois questions,quatre dépendances,critères,preuves,notes et états manuels. Ce lot relie les sources et les frontières actuelles sans terminer Zed ni le jeu.


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
| crates/core/src/healing.rs:16 | pub fn heal( |

Le profil d'attaque natif est lié à l'INIBIN du champion et à ZedBasicAttack. Les commandes,poursuite/windup,impact physique,mitigation,régénération et préparations par API sont exercés. Aucun point n'est promu comme producteur du bonus magique de Zed. La recherche Rust utilise un préfixe de mot pour éviter de compter normalized/serialized comme mentions de Zed.

## Diagnostic attendu et observé

| Niveau Zed | PV initiaux de la cible | Premier impact exactement à50% | Ticks |
|---:|---:|---|---:|
| 1 | 60% | False | 2230 |
| 1 | 50% | True | 2230 |
| 1 | 40% | False | 2230 |
| 18 | 60% | False | 2224 |
| 18 | 50% | True | 2224 |
| 18 | 40% | False | 2224 |

Attendu courant :dégâts physiques d'une attaque ordinaire selon l'AD et l'armure,avec régénération au tick ;dégâts magiques par l'API générique selon la RM. Observé :18attaques,écart résiduel inférieur à0,004,aucun supplément magique ;six événements API magiques de20bruts mitigés correctement. Les deux premiers impacts au seuil sont exactement à50% après régénération. Les cas40% restent sous le seuil ;les cas60% restent au-dessus pendant les trois impacts. Les cas50% passent sous le seuil après le premier.

Second impact à46ticks niveau1 ou30ticks niveau18 ;troisième à312/309ticks. Échantillons299/300/301conservés. Aucun premier proc signifie que cette attente ne prouve pas une expiration de recharge native. Le moment natif du test de seuil,les paliers6–10%,le changement de cible et les propriétaires multiples restent ouverts.

162refus publics et18refus API conservent les snapshots. Douze trajets publics sans réémission. Neuf apports XP et huit préparations de PV via API serveur sont explicitement tracés ;les huit préparations observées utilisent apply_damage avec dégâts vrais et aucune n'emprunte la branche heal du diagnostic. Le point heal reste une frontière inspectée,non un soin exécuté dans ce lot. Aucune position,horloge,rang,statistique ou PV n'est injecté directement. Aucun sort Zed ne réussit dans ces contrôles.

Binaire F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-zed-contempt-probe.exe ;6072320octets ;SHA-256 e580595bc1b87ab5f6010e531f0c7f44d8fe269e5dee1c1624f854f9b0ef1d83. Compilation du vrai F:/OpenLeague/crates/core/src/lib.rs avec profile.test=false,dépendances/checksums alignés sur Cargo.lock.1158entrées moteur/ressources identiques avant/après. Aucun code de jeu ni asset modifié.

## Vérification de livraison

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | d2dcdbdd5d071fd29cb996e7ca04a42ca5a93211e86cf7971ab0e3ed7357dffb |
| RUN | 0 | d6d60d909a70a6007607ab6193659f2bcd687a6b4e4fe6c36c3b4de428fe5919 |
| prepare | 0 | 04c0749ae1cefbac6295bf4615e9528245c3327676adc70a807d8bbe09025d5d |
| check | 0 | 0b05dcf2a7ee68f576a0738fe5636bcf130945357a1df53048cf03b65a3bf906 |
| publish | 0 | 4804872bccacf529a958d1c7264a587191d3078af7e454f2d6612bd2b960af58 |
| audit | 0 | 9066116b79f3ccbe26fba351cf0bebad9142c44c3f9dfbc27a8e4a0365454289 |

Découverte,inspection,BUILD/RUN et quatre étapes de livraison réussis.60associations falsifiées et quatre graphes invalides refusés. Trois fragments courts changent,42212restent identiques. Les instructions complètes des quatre destinataires sont relues par Store.task/copy_text avec résolution des sources,questions et dépendances.

Les deux bases conservent42603autres lignes du catalogue,42607états manuels et23historiques. Intégrité et synchronisation idempotente vérifiées. Revue indépendante :5312ancres/empreintes exactes,aucun problème,pour99295sources enregistrées. Elle ne rehache pas toutes les sources historiques et ne mesure pas l'achèvement du jeu.

## Fichiers et preuves

Registres modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json,docs/fidelity_sources_4_20.json. Reçu F:\OpenLeague\docs\reference_requirement_trace_sources\zed-passive-contempt-links-v655.json. Vérification F:\OpenLeague\docs\fidelity_zed_passive_contempt_links_v655.json. Bases :F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json,docs/completion_plan.json,docs/resume_checkpoint.json,docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision655_Zed_discovery\OBSERVATIONS.json. Diagnostic F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision655_Zed_passive_probe\OBSERVATIONS.json. Inspection F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision655_Zed_inspection/OBSERVATIONS.json. Audit F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision655_Zed/DELIVERY_AUDIT.json. Revue F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision656_trace_review\REVIEW.json. Scripts et binaire conservés.

Neuf copies privées archivées avec SHA décompressés vérifiés avant retrait des seuls doublons bruts ;gain logique 2509534561octets. Reçu F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision655_Zed/snapshot-archives/VERIFIED.json. Sources enregistrées et bases actives intactes ;restauration explicite par revision655_restore_validation_snapshots.py,non exécutée après archivage.

## Limites et suite

Les sources existent partiellement ;le déclencheur et la recharge du passif ne sont pas reliés à un producteur courant accepté. Les valeurs textuelles ne deviennent pas des callbacks natifs. Rendu,HUD,audio,réseau et sauvegarde nécessitent des contrôles séparés. Ni Zed ni le jeu ne sont déclarés terminés.

Continuer SYS-01.2-02 depuis revision656_trace_review/REVIEW.json. V655 Zed Contempt for the Weak publié et audité :16sources natives,48associations,20points/40liens. Alias ZedPassiveToolTip,texte sous50%PV et6–10%PVmax magique,10s par cible ;paliers,f1 et ordre du seuil ouverts. Six cas niveaux1/18 :18attaques publiques sans supplément magique,dont deux premiers impacts exactement à50% ;second à46/30ticks,troisième à312/309ticks. Six contrôles magiques API réussis ;162refus publics+18API sans mutation,13362ticks,neuf apports XP et huit préparationsPV API,1158entrées conservées. Recharge non qualifiée car aucun proc. Candidats ZedPassive/Akali et ZedNewPassive/Ziggs conservés,passif W distinct ;72lignes DDF sans producteur passif. Prochain lot :Ziggs PASSIF,contrat encore au chargeur partagé selon revue actuelle ;inspecter Short Fuse et les réductions de recharge avant diagnostic. Snapshots V655 archivés/restaurables par revision655_restore_validation_snapshots.py. Goal actif. Première découverte Ziggs exécutée0 :revision656_Ziggs_discovery/OBSERVATIONS.json,74ressources natives,29références communautaires,9exclusions,17limites NEWTABLE et aucun DDF dans ce périmètre. Alias ZiggsPassiveBuff ;texte12s,réduction4s par compétence,150%sur structures,variables f1/f2 encore à relier. ZiggsPassiveAttack porte aussi des textes PLACEHOLDER à conserver comme tels. Aucun diagnostic moteur Ziggs exécuté.
