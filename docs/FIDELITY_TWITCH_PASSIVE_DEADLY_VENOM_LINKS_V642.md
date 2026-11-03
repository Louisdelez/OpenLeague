# SYS-01.2-02 — Twitch / Deadly Venom, V642

Date UTC 2026-10-26T22:23:28.203665+00:00. Référence PUBLIC4.20.0.315,EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau et date de déploiement non établis ;catalogue4.20.1 distinct.

V642 Twitch / Deadly Venom :54 sources natives vérifiées,162 associations,20 points de code et40 liens. Contrat natif :dégâts bruts chaque seconde pendant six secondes,jusqu’à six cumuls ;producteur f1 non résolu. E natif physique par cumul ;E communautaire magique avec trois cumuls fixes malgré commentaire six. 21 Lua sans fonctions enfants,dont7 limites NEWTABLE ;BuffData Hide sans traduction exacte ;11 preloads,20 lignes DDF dont seule Expunge f1=bonusAD0.25 renseignée. Deux cas réels niveaux1/18 :sept projectiles chacun,dégâts physiques seuls,aucun poison pendant les attaques ni181ticks suivants. Témoin Ignite positif :cinq dégâts de14 aux ticks0/30/60/90/120,distinct du poison Twitch. 58 refus sans mutation,deux apports XP serveur explicites,six déplacements sans réordre. BUILD/RUN0 ;1158 entrées du moteur conservées. Aucun code de jeu modifié,aucune case ou inconnue fermée.

## Résultat intégré

Trois fiches CH-Twitch-PASSIF-SOURCE, CH-Twitch-PASSIF-SIMULATION-CONTRAT et CH-Twitch-PASSIF-SIMULATION reçoivent les sources et preuves détaillées ; SYS-01.2-02 reçoit la synthèse. Quatre sources de preuve sont ajoutées. Les20 points courants sont liés aux deux tâches de simulation comme frontières ou témoin explicite, sans être présentés comme l'implémentation du poison. Les lecteurs de sources déjà présents sur SOURCE restent des lecteurs de sources.

Toutes les anciennes associations, statuts, critères et acceptations sont conservés. Trois questions propres et quatre dépendances restent ouvertes ou inchangées. L'identité des questions, le registre des identifiants et la hiérarchie sont inchangés octet par octet ; aucune case cochée.

## Sources et contrat natif

54 sources natives :20 INIBIN,21 Lua,11 preloads,un DDF etle fichier de textes. Toutes concordent par taille etSHA-256 avec le registre etavec les membres du manifeste RADS sélectionné. Quinze candidats de skins,recommandations d'objets ettaunts sont explicitement exclus du périmètre mécanique. Les25 sources communautaires sont identifiées séparément etcomparées au registre.

| Ressource native | Octets | SHA-256 |
|---|---:|---|
| CharScriptTwitch.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| CharScriptTwitch.preload | 953 | cce6eae97c0217b3444d767e4b24d5daee47f912461ea736577bf48cc612acd3 |
| Twitch.ddf | 889 | 88f6f9de9ec94bb62ba304ccc3875c9baf0b7e7a2a0d9b9d960680c9633ddae2 |
| Twitch.inibin | 1441 | 905c10cf60a003a1fcce7334c1b6b6c7114ed51a75b0136a35f8fa7f76375355 |
| Deadly_Venom.inibin | 78 | ee9fb580f01d6afb08895a78c15d8e2f0eb26ecc8ea2f02a4a4ed5798e27c0c6 |
| Deadly_Venom.luaobj | 158 | 6954c68150a929ff76c491b97670c812b602a6d683083ad8954d42a595169050 |
| TwitchAmbushBuff.inibin | 48 | e246ab897e4af1ac352b8c930e9bc848da55e1c1d11c973faeed0f2ccb9dcac6 |
| TwitchBasicAttack.inibin | 1267 | bb46be88a984dfcceb05c2425240f972e96c85273643b44b9facd8e466ccfbbd |
| TwitchBasicAttack.luaobj | 160 | badfe7c6c981d478016a29a7b5958b5515e657e407579feaa6fa169219e72221 |
| TwitchBasicAttack2.inibin | 1286 | 85bf59c638678d61dc4cfa1a3a14265e5bc77b3472253588d366c54dade641ef |
| TwitchBasicAttack2.luaobj | 160 | badfe7c6c981d478016a29a7b5958b5515e657e407579feaa6fa169219e72221 |
| TwitchBasicAttack3.inibin | 1286 | 93875d2ac90a4b3ae0c9b7486ae6444f73c7e582856a758a70c2448c768634e1 |
| TwitchBasicAttack3.luaobj | 160 | badfe7c6c981d478016a29a7b5958b5515e657e407579feaa6fa169219e72221 |
| TwitchCritAttack.inibin | 1281 | 17bfc1c8d55d24c1ea8fd8c6c3110cb285cf9700a94de47f0e4653f3f0770876 |
| TwitchCritAttack.luaobj | 160 | badfe7c6c981d478016a29a7b5958b5515e657e407579feaa6fa169219e72221 |
| TwitchDeadlyVenom.inibin | 254 | 5e6e2987987d4c228f19cbb5024825b104381f90485d9217df08ac38f912b9dd |
| TwitchDeadlyVenom.luaobj | 154 | 72650934f97f5bd0041a8ab23489a4f9045dde221d4c50f2d9347b32f2b37f30 |
| TwitchDeadlyVenomDamageMarker.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| TwitchDeadlyVenomDamageMarker.preload | 639 | d9cdecf2a08a5700c60f549afbb125b71aca7f68e21bdf60c4700f867fe1d9db |
| TwitchDeadlyVenomInternal.inibin | 1457 | 8defd0e55e60f5c791eef73c9dbdf58f7ff38d5e32e83fc957ceaa11edee2168 |
| TwitchDeadlyVenomInternal.luaobj | 185 | d4343a69f28d0707e9dbbcf6b81e811a0ab59e904cf9fb14e52f1ade69080d37 |
| TwitchDeadlyVenomInternal.preload | 104 | 7a8fce2108c9ae70961ef58580db077c4c3f09df54c88b3c99c96f5b639a98b3 |
| TwitchDeadlyVenomMarker.inibin | 55 | b27d74ad0849a2ea32c898bffba6e88a26218543331e99022dfafdfb1cf2d3b7 |
| TwitchDeadlyVenomMarker.luaobj | 231 | 04920ce63c89da18ba5f40601b107ad2d72b1ebabce7dd485fda21ad66e826e8 |
| TwitchEParticle.inibin | 1104 | 693dd3fd1be32f7c17ae30684a680d042d26ce61a4702c182aa6eceaf73905bf |
| TwitchEParticle.luaobj | 288 | 16fed6ca508e98c794f3674697c5c19e409266937b80b2f9cc66f7806a1c7c3e |
| TwitchExpunge.inibin | 1288 | 090ea81c03cae4859467ae9b1548196f4d7446b9b203e1dc4eaa2dc75027901f |
| TwitchExpunge.luaobj | 504 | 483d2f4dce5f06b07e51ecc89fbb2245db4fbfdbb04018f63064b792fd9985c6 |
| TwitchExpunge.preload | 102 | 44537a0cef9a75abdee90343d922907b18a066962bdfd536d923221f223eebce |
| TwitchFullAutomatic.inibin | 894 | 8d9274a8a13f910f13c0bb8026bc407e90ecc55b72ae9a9f9b3f8c15c44b3a34 |
| TwitchFullAutomatic.luaobj | 920 | 2c5762012d8beae40720cf87480ca91a47fed422e3b12d9d4c2d161ebfc9074f |
| TwitchHide.inibin | 36 | d75bbac3b79cfa2866f98f25bfbe63e000d80cbcc89732ccefdd5232937aab86 |
| TwitchHide.luaobj | 88 | 8cd18a49badc84da02e18c46eac09965eb799b7af6a3de9834f36ec8ed061776 |
| TwitchHideInShadows.inibin | 1166 | 873faac25ac285a2c396b1d010289c6f9ee31e1b42054a18121f19fd29e4ca85 |
| TwitchHideInShadows.luaobj | 393 | 07be632475902e143cf7547bb3e0038040d6e898f6af2aebd342a88939dbd52f |
| TwitchHideInShadows.preload | 313 | 48536b85072d0c17989baecc4dac416105698a243d5d27d451bcbaf6656786b8 |
| TwitchHideInShadowsBuff.luaobj | 373 | 82bec7f5f6a48bf1c499d6ae5adae6dc4c92ffe033a54d00ab85b3769aed486f |
| TwitchHideInShadowsBuff.preload | 114 | 6ab70083c5836259d6e637af561169e51c814ec9ce0c87124916af4ca08e11ea |
| TwitchHideInShadowsInternal.luaobj | 93 | 7728996c94680f49f857f807ed28401940bffa1a1f7adb6611c791626f13047d |
| TwitchHideInShadowsInternal.preload | 336 | f583469ea38127813abaf0ee8a841df7bd3ef0e73d83e2a5e4e32e6e6cbadebe |
| TwitchSprayAndPrayAttack.inibin | 1548 | c79ef4a0d81954d06ac85b3a270cdcfb26a70c5c8a66df852f47622d7c103fd1 |
| TwitchSprayAndPrayAttack.luaobj | 631 | f81e29b4f4471f0bd4a66f5f062ca91bbc9e66e4c1278330f5ebc04d7b223c0e |
| TwitchSprayAndPrayAttack.preload | 272 | 111409c54c446f4148f6367adf6e76f881ea8e284cd2f357909a32109e81982f |
| TwitchUlt.inibin | 48 | c4dabe2bb65ae57caf24ee263249b10094f5b828c2b2d980e591118e9f67dd39 |
| TwitchVenomCask.inibin | 1203 | a976047d5ddff4b4f45a049cd60223c4322d95c7df58d4b715aa4913c066462f |
| TwitchVenomCask.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| TwitchVenomCask.preload | 331 | 4415368d37d405bd3ce4b56dfcce46ae3fed06904e8b0e9b3faeffcb13a939e3 |
| TwitchVenomCaskDebuff.inibin | 1179 | fc9b9f2c8da4bb5bed681c995f885794db94a1a3ff0ac7ff3debba0e17200509 |
| TwitchVenomCaskDebuff.luaobj | 209 | d677046e28c13d7ef37ceca7f86b6ffd8c4ef290dce4d5cd0c2760229b77157e |
| TwitchVenomCaskDebuff.preload | 108 | dbfff0657a885346bd8bbf79be3b450bd41c51dbc8935cb8b538cb52d13ee0f1 |
| TwitchVenomCaskMissile.inibin | 1213 | 7b689c486f775567b92a41c49e66d9e885863547752b986ab2d4eb6cb818a26a |
| TwitchVenomCaskMissile.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| TwitchVenomCaskMissile.preload | 382 | 839f84c94c106291998088356a1200c10d170b1935b600d1e980d784dc88c674 |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |

Le marqueur TwitchDeadlyVenomMarker lie son DynamicTooltip au texte indiquant @f1@ dégâts bruts chaque seconde pendant6secondes,jusqu'à6cumuls. Le producteur de f1,la table par niveau,le premier tick,le rafraîchissement,l'ordre,l'empilement multisource etles exceptions ne sont pas établis. Les marqueurs INIBIN de niveau etPassive1/Passive1Desc absents restent absents.

Les neuf liaisons BuffData donnent huit correspondances exactes etune limite :TwitchHide.inibin demande game_buff_tooltip_Hide,absent du fichier anglais fourni. TwitchHideInShadows possède sa propre clé ;aucune substitution automatique n'est faite. La première inspection exigeait à tort neuf correspondances etéchouait ;la correction conserve cette différence etles deux scripts.

Les21 Lua n'ont aucune fonction enfant ;sept initialisations rencontrent NEWTABLE,limite conservée du lecteur de littéraux. CharScriptTwitch estvide à la racine. Deadly_Venom etTwitchDeadlyVenom partagent un nom de buff mais des textures différentes ;le buff interne s'appelle « Deadly Venom » avec un espace. La priorité effective des alias n'est pas qualifiée. Les flags de persistance du marqueur du champion ne démontrent pas la persistance du poison de la victime.

Le DDF contient20entrées,avec seule Expunge;f1 renseignée :bonusattackdamage,coefficient0.25. Elle concerne E etne résout pas f1 du passif. CharScript.preload nomme la chaîne venom/internal/damagemarker ;le marqueur de dégâts référence six compteurs visuels. Ce sont des dépendances de ressources,pas des preuves d'affichage ni de gestion des cumuls.

## Écarts communautaires

Le CharScript communautaire estvide. W appelle TwitchVenom pour6secondes avec un argument2 ;E cherche ce buff,fixe int stacks=3 malgré un commentaire annonçant6,applique des dégâts magiques puis retire le buff. Le texte natif de E décrit des dégâts physiques par cumul. Trois occurrences exactes TwitchVenom sont retrouvées dans les scripts C# inspectés,uniquement ces appels ;aucun producteur n'y est retrouvé. Cette recherche bornée ne prouve pas une absence dans tout serveur possible. Aucun C# n'a été exécuté ni promu comme règle native ou consommateur Rust.

## Consommateurs actuels et diagnostic exécuté

| Point courant | Ancre vérifiée |
|---|---|
| crates/core/src/lib.rs:533 | pub fn join( |
| crates/core/src/lib.rs:598 | pub fn command( |
| crates/core/src/lib.rs:685 | pub fn advance( |
| crates/core/src/lib.rs:744 | pub fn snapshot( |
| crates/core/src/progression.rs:68 | pub fn stats( |
| crates/core/src/progression.rs:150 | pub fn learn( |
| crates/core/src/progression.rs:159 | pub fn next_rank( |
| crates/core/src/spells.rs:101 | pub fn cast( |
| crates/core/src/annie_w.rs:29 | pub fn cast_at( |
| crates/core/src/progression.rs:131 | pub fn award_experience( |
| crates/core/src/attacks.rs:141 | fn attack_target_valid( |
| crates/core/src/attacks.rs:157 | pub(crate) fn advance_attacks( |
| crates/core/src/lifesteal.rs:4 | pub(crate) fn basic_attack_hit( |
| crates/core/src/damage.rs:53 | pub fn apply_damage( |
| crates/core/src/regeneration.rs:32 | pub(crate) fn advance_regeneration( |
| crates/core/src/summoners.rs:32 | pub fn join_with_summoners( |
| crates/core/src/summoners.rs:47 | pub fn cast_summoner_on( |
| crates/core/src/summoner_ignite.rs:14 | pub(crate) fn cast_ignite( |
| crates/core/src/summoner_ignite.rs:25 | fn apply_ignite_tick( |
| crates/core/src/summoner_ignite.rs:34 | pub(crate) fn advance_ignite( |

Le chemin attack→projectile→basic_attack_hit→apply_damage utilise ici les dégâts physiques courants. Le tick applique notamment Ignite etrégénération avant les attaques ;la recherche littérale Twitch/DeadlyVenom dans les sources Rust inspectées ne trouve aucun nom,mais le diagnostic etla lecture des vrais chemins apportent la preuve bornée ci-dessous.

| Niveau | Projectiles | Ticks de la série | Ticks après dernier impact | Dégâts observés par impact,régénération déduite | Refus |
|---:|---:|---:|---:|---:|---:|
| 1 | 7 | 277 | 181 | 41.134033203125 | 27 |
| 18 | 7 | 178 | 181 | 53.4344482421875 | 27 |

Aux deux niveaux,les sept impacts correspondent aux seuls dégâts physiques attendus avec résidu inférieur à0.002PV. Les ticks entre impacts etles181ticks après le dernier ne montrent aucun dégât supplémentaire. Cela établit l'écart dans ces scénarios ;cela ne qualifie ni la cadence native,ni le cap à6,ni un passif achevé. Le septième impact n'est pas présenté comme un test réussi de saturation d'un compteur absent.

Twitch etAnnie rejoignent la carte10 etse déplacent par commandes publiques. Le cas niveau18 fournit100000XP à chacun par deux appels explicites award_experience du serveur ;ce n'est pas une progression naturelle. Aucune position,PV,rang ou niveau n'est injecté directement. Six trajets publics au total,sans réordre ;6818ticks de simulation sur les deux cas etle témoin,y compris déplacements.

Le témoin séparé utilise Ignite via SummonerTarget :cinq dégâts de14PV,total70,aux temps relatifs0/30/60/90/120 ;la réduction de régénération est prise en compte etle buff disparaît à150ticks. Ce témoin valide l'observation des dégâts périodiques actuels ;il n'est ni le poison Twitch ni la qualification historique de la cadence reconstruite d'Ignite. Sa fenêtre surveillée couvre181ticks.

58 refus publics avec snapshot inchangé :27 dans chaque cas Twitch (apprentissage,lancements,ciblage etidentité) et4 pourles cibles invalides ou le délai d'Ignite. Le diagnostic compile le vrai openleague_core non-test depuis F:/OpenLeague,avec les identités etchecksums de dépendances alignés surCargo.lock. Les1158 entrées du moteur etressources littérales sont identiques avant/après.

Binaire exécuté :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-twitch-deadly-venom-probe.exe ;6076928 octets ;SHA-256 6c937b15f0bedbc3a5dcb4f901fe9d7a9ea8cf4e9b11ecdc587f40436270b7cc.

Découverte :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision642_Twitch_discovery\OBSERVATIONS.json. Diagnostic :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision642_Twitch_passive_probe\OBSERVATIONS.json. Inspection corrigée :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision642_Twitch_inspection_tooltip/OBSERVATIONS.json.

## Vérification de l'intégration

| Commande/étape | Code retour | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 8c5e656210f3add3bc079dc90f0aebbb7c15fa2b6a6d363f2b03cdba276b6aa3 |
| RUN | 0 | af6a108012b3059f0ee687e0d0353700d8519860374f52cd0b8fb3dc238ebea4 |
| prepare | 0 | 44a9641c9b64313a6fbe72efb60c07956cf30ab702a429dfd8c2cbe7ff61313d |
| check | 0 | f6c60c97292eb711708008d233e66c1474aea5b4697c3f52e06ea47efe1a3298 |
| publish | 0 | ad92af77fc1abaa9eeacad1beeda400bb66b986adf4128f278357da8b667a573 |
| audit | 0 | 7183a53e121c2bec4612f2e7c43a337e3afe4e16f4e906dd206dcd0e0798e208 |

72 associations volontairement invalides sont rejetées par la garde de livraison ;quatre graphes invalides par le vrai validateur. Le contrôle CHECK_SPACE reprend exactement le même code que CHECK avec un nouveau nom de base de travail ;la première copie avait échoué faute de place. Les copies complètes des quatre tâches sont relues via Store.task/copy_text,avec dépendances etrésolution des sources/questions. Trois résumés courts changent ;les42212autres restent identiques.

Deux bases vérifiées :quatre lignes ciblées modifiées,42603autres lignes,42607états manuels et23historiques conservés ;synchronisation ordinaire idempotente. Le contrôle global indépendant confirme5043ancres etidentités de consommateurs sans divergence,sur99243sources enregistrées. Il ne constitue pas un rehash intégral de toutes les sources historiques ou un taux d'achèvement du jeu.

## Fichiers modifiés et incidents conservés

Registres :docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json etdocs/fidelity_sources_4_20.json. Reçus :docs/reference_requirement_trace_sources/twitch-passive-deadly-venom-links-v642.json etdocs/fidelity_twitch_passive_deadly_venom_links_v642.json. Bases :runtime/project-plan/plan.sqlite3 etbase de l'application installée. Couverture/reprise :docs/coverage.json,docs/completion_plan.json,docs/resume_checkpoint.json,docs/ai/CURRENT.md etdocs/ai/HANDOFF.md.

Les scripts etpreuves privés sont conservés sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20. La première inspection échouée surla traduction Hide reste distincte de la correction. Le premier générateur de livraison a échoué surun séparateur de lignes avant de produire la livraison ;des commandes de préparation ont également échoué surdes guillemets PowerShell/Python avant de produire leurs scripts. Ces incidents n'ont pas modifié le jeu oules registres. Les champs de version d'un script de livraison encore inexécuté ontété corrigés avant son premier lancement. L'en-tête hérité du lanceur Python mentionne encore Teemo ;le source Rust,le manifeste,le reçu etle binaire effectivement exécutés identifient bien Twitch. BUILD/RUN du jeu ont tous deux réussi dès leur exécution.

Le premier CHECK a échoué avec SQLite « database or disk is full » pendant la copie du candidat : F avait zéro octet libre. Sa copie incomplète et son journal ont été préservés dans C:/Users/loicd/AppData/Local/Temp/OpenLeague-recovery-v642 avec SHA identique avant retrait des deux fichiers de travail sur F. Les tentatives de compression NTFS puis de déplacement des copies de validation ne suffisaient pas : les vérifications de lecture rencontraient encore le disque plein. Le cache Cargo incremental régénérable de 4,77 Go a donc été vidé après vérification du chemin, de l'absence de liens et de compilateur actif ; exécutables, rlib, sources et preuves conservés. Les copies de validation partiellement déplacées ont ensuite été restaurées sur F. Le projet, les bases actives et le dossier de validation restent sur F aux emplacements attendus ; les copies temporaires C sont conservées. Au contrôle final, 127 fichiers de V640/V641/V642 sont comparés au contenu initial et identiques, le couple SQLite incomplet compris. Les retours 0 de compact ne suffisaient pas à prouver cette conservation ; seule la vérification finale après libération du cache fait preuve. Il ne restait alors que 34885632 octets ; cinq autres anciens caches incrémentaux régénérables ont été retirés avec les mêmes protections, donnant 12813635584 octets libres avant la reprise. Reçus : E:/mapslol3v3/revision642_storage_recovery/EXPLICIT_VERIFIED.json et OLDER_INCREMENTAL_CACHES_AFTER.json. Le premier CHECK et ses erreurs restent conservés ; CHECK_SPACE utilise un nouveau fichier SQLite, les mêmes gardes et aucun contournement des contrôles.

Après audit, neuf copies de validation privées non enregistrées comme sources ont été archivées en gzip : six candidats JSON, deux sauvegardes SQLite et la base candidate contrôlée. Chaque archive décompressée a le SHA-256 exact du fichier brut avant retrait de ce doublon. Gain logique : 2391184159 octets. Les archives restent sur F dans F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision642_Twitch/snapshot-archives/VERIFIED.json. Pour rejouer les scripts d'audit V642 qui attendent les anciens chemins bruts, exécuter explicitement F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision642_restore_validation_snapshots.py ; il refuse les chemins étrangers et conserve les archives. Ce script de restauration n'a pas été exécuté après archivage ; la décompression et ses empreintes ont été vérifiées par le créateur d'archives. Les sources enregistrées, exécutables, reçus et bases actives sont exclus de l'archivage.

## Limites et suite

Aucun code de jeu ouasset modifié. Pas de client graphique,son,réseau ouserveur historique exécuté. Restent à qualifier :f1 ettable native,cadence précise,rafraîchissement etempilement,sources multiples,types de cibles,boucliers/immunités,mort/retour,déconnexion,W/E,R etprésentation. L'association etle diagnostic de lacune ne valident pas la fidélité du passif.

Continuer SYS-01.2-02 depuis revision643_trace_review/REVIEW.json. V642 Twitch publié/audité :54 sources,162 associations,20 points,40 liens ;deux séries de sept attaques physiques seules niveaux1/18,sans DOT pendant ni181ticks après,Ignite témoin5hits ;58 refus,6818ticks totaux,six trajets sans réordre. Producteur natif f1 et poison actuel non qualifiés ;E communautaire trois cumuls magiques divergent du texte physique ;Hide sans traduction exacte,sept limites NEWTABLE. Prochain lot :TwistedFate PASSIF/Loaded Dice,dont contrat reste au chargeur partagé seul ;vérifier sources,récompenses/or et vrais consommateurs avant diagnostic. Ne pas dupliquer Tryndamere V537 ni Trundle V534/V535/V641. Stockage :caches incrémentaux régénérables retirés ;neuf snapshots privés V642 archivés en gzip vérifié,pour rejouer son audit restaurer via revision642_restore_validation_snapshots.py. Sources enregistrées et bases actives inchangées par archivage. Éviter de multiplier les copies privées brutes après validation,conserver contenu et restauration vérifiée. Goal actif.
