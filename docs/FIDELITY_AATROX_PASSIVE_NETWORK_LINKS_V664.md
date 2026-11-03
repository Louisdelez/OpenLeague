# SYS-01.2-02 — Aatrox : sources et consommateurs réseau, V664

Date UTC : 2026-10-27T06:31:07.511819+00:00. Référence : PUBLIC 4.20.0.315, EUW/en_GB. Build littéral du 17 novembre 2014 à 17:46:45 ; fuseau et déploiement non établis. Catalogue 4.20.1 distinct.

V664 Aatrox / Blood Well réseau :10sources natives,10associations,27points actuels reliés. Trois connexions UDP locales,22états projetés,16 refus,3246 ticks. Visibilité,doublons,autorité et reconnexion contrôlés ;mort puis retour normal480ticks,aucune résurrection Blood Well qualifiée. Premier BUILD101 conservé,correction privée BUILD/RUN0. Cases,notes et questions conservées.

## Résultat intégré

La fiche CH-Aatrox-PASSIF-NETWORK et la synthèse SYS-01.2-02 reçoivent les preuves et instructions. Dix sources natives et vingt-sept points actuels sont reliés. Les fonctions génériques d’autorité, de projection et de transport existent et ont été exercées ; elles ne fournissent pas une implémentation complète du Puits de sang. Les descripteurs restent entry_boundary_only et provides_feature_consumer=false pour cette fonctionnalité complète.

La question propre à la fiche et sa dépendance CH-Aatrox-PASSIF-SIMULATION sont conservées, ainsi que la question portée par cette dépendance. Prérequis de phase/lot et critères sont enregistrés sans acceptation implicite. Les identifiants, la hiérarchie et le registre des inconnues restent identiques en octets. Aucun code de jeu ni asset modifié.

## Prérequis et correction de projection

Le package conserve six prérequis dans `package.requires_packages`. Le champ synthétique `required_packages` de l’inspection privée était vide à tort : il utilisait une autre clé optionnelle. Les instructions copiables des deux bases contiennent déjà les six packages ;aucun prérequis du plan n’a été supprimé. Le complément F:\OpenLeague\docs\fidelity_aatrox_network_prerequisites_v664.json donne les packages,leurs états et leurs nombres de tâches implémentées/acceptées, sans validation implicite. L’ancienne inspection est conservée et son champ vide ne doit pas être interprété comme une absence de prérequis.

## Sources natives

Les dix identités du lot V456 sont revérifiées sur les fichiers actuels et sur le registre. L’appartenance RADS déjà établie est conservée ; elle ne démontre ni la priorité de chargement ni le schéma réseau du passif.

| Ressource | Octets | SHA-256 |
|---|---:|---|
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Aatrox\Aatrox.inibin | 1997 | 4d1949dc1ddbd27fd37c2b5dc6d2aa635a738f7bf4547314ae4ddc445eac2483 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Aatrox\CharScriptAatrox.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Aatrox\Spells\AatroxPassive.inibin | 45 | fb0c449261b4e5af69afc33834e995d1d86b5ac133c1c5410ed74d27a9ec9e93 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Aatrox\Spells\AatroxPassive.luaobj | 254 | 561f4207cde3e6b19f40d6a9cfd352e621ecc36f59920fbc248ed34383a16476 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Aatrox\Spells\AatroxPassiveActivate.inibin | 53 | 2c2b25e6d007b4f4ddf7c405de79cdb262bb99990767fb3dc99e09943f80e6f1 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Aatrox\Spells\AatroxPassiveActivate.luaobj | 229 | f7a1db73208bacd67e362255da162baff2a331df6d86e8b6dae39c0a4ffae013 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Aatrox\Spells\AatroxPassiveDeath.inibin | 1064 | 7707bd4bd22a733e242112d2adbb17ce3566d26de1fccd3d054da6c634c80f3e |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Aatrox\Spells\AatroxPassiveDeath.luaobj | 217 | b660dc91bda3559359b618319c7ef82d5d4acee6e118f6374876fbed22a9a344 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Aatrox\Spells\AatroxPassiveReady.inibin | 50 | dd86a142d8131eccb6cd87083b794f1da88e32a4a0def12d9e09208075095fc1 |
| D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Aatrox\Spells\AatroxPassiveReady.luaobj | 217 | b660dc91bda3559359b618319c7ef82d5d4acee6e118f6374876fbed22a9a344 |

## Consommateurs actuels

| Fichier et ligne | Ancre |
|---|---|
| crates/core/src/lib.rs:155 | `pub struct Champion {` |
| crates/core/src/lib.rs:209 | `pub struct Snapshot {` |
| crates/core/src/lib.rs:303 | `pub enum ClientPacket {` |
| crates/core/src/lib.rs:321 | `pub enum ServerPacket {` |
| crates/core/src/vision.rs:137 | `pub fn snapshot_for(` |
| crates/core/src/vision.rs:208 | `pub fn snapshot_for_atomic(` |
| crates/server/src/session_host.rs:57 | `pub fn handle(` |
| crates/server/src/session_host.rs:158 | `pub fn states(` |
| crates/core/src/session_wire.rs:21 | `pub fn encode(` |
| crates/core/src/session_wire.rs:77 | `pub fn push(` |
| crates/client/src/session_client.rs:142 | `pub fn frame(` |
| crates/client/src/session_client.rs:176 | `pub fn take_ready_states(` |
| crates/client/src/session_connection.rs:205 | `pub fn decode_datagram(` |
| crates/core/src/lib.rs:533 | `pub fn join(` |
| crates/core/src/lib.rs:598 | `pub fn command(` |
| crates/core/src/damage.rs:53 | `pub fn apply_damage(` |
| crates/core/src/lifecycle.rs:33 | `pub(crate) fn advance_respawns(` |
| crates/core/src/lifecycle.rs:24 | `pub(crate) fn restores_resource(` |
| crates/core/src/regeneration.rs:32 | `pub(crate) fn advance_regeneration(` |
| crates/core/src/progression.rs:68 | `pub fn stats(` |
| crates/server/src/reconnect.rs:173 | `pub fn prepare_input<` |
| crates/client/src/session_client.rs:98 | `pub fn welcome(` |
| crates/client/src/session_client.rs:196 | `pub fn input(` |
| crates/client/src/session_client.rs:188 | `pub fn presented(` |
| crates/client/src/main.rs:969 | `fn receive(` |
| crates/core/src/wire.rs:5 | `pub fn state_datagrams(` |
| crates/core/src/wire.rs:42 | `pub fn push(` |

Le diagnostic exécute le core et les modules réels reconnect, clock_delivery, pause, session_host et session_client. Connection.decode_datagram et le main.receive graphique sont inspectés statiquement, pas exécutés. Cette distinction est conservée dans le reçu et les consignes.

## Contrat et travail restant dans la fiche

OBJECTIF SYS-01.2-02 : relier CH-Aatrox-PASSIF-NETWORK aux sources natives et au chemin actuel de données. Cette fiche ne dispose que d’un chargeur de définition avant ce lot. Conserver ses acquis,sa question et sa dépendance CH-Aatrox-PASSIF-SIMULATION,sans déclarer le passif ou le réseau complet.

Référence PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau/déploiement inconnus,catalogue4.20.1 distinct. Dix ressources natives du lot V456 sont rehashées et rapprochées du registre courant. Passive1LuaName=AatroxPassive,icôneAatrox_Passive.dds,PARType=BloodWell. Les chunks natifs sont des métadonnées et ne fournissent pas ici de callback serveur ou de schéma de paquet du Puits de sang. Préserver les anciens constats sur les alias Death/Ready,les libellés Disintegrate et le source_sha256 du catalogue de ressources dont le producteur n’est pas établi.

Chemin réel inspecté :Champion et Snapshot dans core/lib.rs ;création du champion,commande,statistiques,dégâts et réapparition ;snapshot_for et snapshot_for_atomic pour l’audience ;Host.handle et Registry.prepare_input pour propriété/session/séquence ;Host.states,Sender.encode et Assembler.push pour les trames OLSR ;Client.welcome,frame,take_ready_states,presented,input ;Connection.decode_datagram et main.receive côté client. OLST StateAssembler/state_datagrams restent un codec historique local distinct. OLSR/OLST ne sont pas présentés comme le protocole filaire Riot. Les27points sont des consommateurs génériques vérifiés ou des frontières inspectées,aucun n’est promu en producteur complet du passif.

Le diagnostic compile le vrai core et inclut sans réécriture cinq modules actuels :reconnect,clock_delivery,pause,session_host,session_client. Binaire non-test,Cargo.lock et checksums alignés,1163entrées code/ressources conservées. Première compilation échouée101 :la taille du tableau aléatoire du nonce n’était pas explicite dans le diagnostic privé. La copie nonce_typed corrige uniquement cette annotation et réussit BUILD/RUN0 ;échec,source et logs antérieurs restent conservés. Aucun code de jeu modifié.

Trois sockets clients réels et une socket serveur sur127.0.0.1,ports éphémères ;Aatrox,Annie adverse et Garen allié. Le générateur aléatoire OS fournit les capacités,aucune clé ou enveloppe privée brute n’est journalisée. Host reçoit les requêtes sérialisées via UDP et Client reçoit les fragments via UDP. L’horodatage Host est une entrée monotone contrôlée du diagnostic ;le tick de simulation avance normalement. Aucun processus serveur/client graphique complet,Bevy,HUD,GPU ou audio n’est lancé.

Huit étapes et22projections :positions initiales cachées ;rapprochement par commandes Move authentifiées ;attaque ordinaire d’Aatrox ;éloignement et nouvelle perte de vision ;mort imposée par une API serveur de dégâts vrais ;tick précédant le retour normal ;retour normal ;reconnexion du même joueur sous une nouvelle époque de session. Les états reçus correspondent exactement à snapshot_for_atomic du destinataire. Les ennemis invisibles sont absents de players ;le roster public garde les identités. L’allié voit Aatrox. Les22trames sont réassemblées en ordre inverse avec doublon avant/après complétion,sans double livraison. Un aller-retour OLST vérifie seulement le codec,ni son superviseur réseau ni le client graphique.

411datagrammes,30requêtes clientes,3246ticks. Un achat1001 retire325or,le doublon est refusé sans nouvel achat.16refus de commandes :contexte de joueur étranger,endpoint étranger,doublon de séquence,douze Learn/Cast/CastAt Aatrox non implémentés et ancienne époque après reconnexion. Les snapshots restent inchangés lors de ces refus. Cinq contrôles de transport :en-tête invalide,contexte étranger,remplacement d’une ancienne trame incomplète par la suivante au même tick,fragment contradictoire qui invalide son ordinal,ancienne époque après reconnexion. Le remplacement et le conflit sont exercés directement dans l’assembleur réel ;les autres contrôles et les22trames passent par UDP et le client de session réel. Après60secondes de temps Host contrôlé,les routes sont détachées,les joueurs conservés ;la récupération d’Aatrox garde exactement son état avec epoch+1. Les autres joueurs restent détachés dans ce scénario.

État réellement transporté pour Aatrox :mana générique105.6 au départ,inchangé après marche et attaque ;champion_resources marque BloodWell,mais le consommateur de régénération ne restaure que Mana/Energy. La mort de contrôle produit health0 et respawn_at=tick+480 ;aucune vie avant l’échéance,puis retour normal et mana0. Ce contrôle utilise apply_damage serveur,non un paquet donnant autorité de dégâts au client. Il ne déclenche ni ne qualifie l’accumulation par coûts de vie,la dépense de réserve,la vitesse d’attaque bonus ou la résurrection passive. Le mana sérialisé ne constitue donc pas un état de Puits de sang complet.

À compléter :identifier/implémenter le producteur des états Blood Well et ses transitions ;définir les champs,événements et audiences autorisées de réserve,recharge,activation et résurrection ;règles de mise à jour,ordre,pertes,expiration,doublons,mort et récupération. Qualifier les politiques natives ou nommer explicitement les équivalents locaux si elles manquent. Tester les vrais effets passifs en multiclient après implémentation,en incluant visibilité et changement d’époque ;contrôler le main.receive complet,présentation/HUD et compatibilité des routes locales. Ne pas utiliser les tests de transport générique pour fermer ces inconnues. Préserver critères,notes,cases et preuves antérieures.


## Résultats attendus et observés

| Contrôle | Résultat observé |
|---|---|
| Audience : propriétaire, allié et ennemi | 22 états reçus identiques aux projections du serveur ; acteurs cachés absents de players, identités publiques dans roster |
| Perte puis retour de visibilité | Rapprochement et éloignement par commandes publiques authentifiées, présence/absence vérifiées |
| Ordre et doublons | Fragments inversés et dupliqués ; une seule livraison par trame |
| Commandes étrangères ou anciennes | 16 refus au total, dont 12 commandes de sorts Aatrox indisponibles ; snapshots inchangés |
| En-têtes, contexte, perte de fragments, conflit | Cinq contrôles ; une trame invalide n’est pas livrée comme nouvel état |
| Reconnexion | Même joueur et même état, nouvelle époque ; anciennes trame et commande refusées |
| Mort et retour | Contrôle de dégâts serveur, mort normale puis retour après 480 ticks ; ce n’est pas une résurrection passive |
| Ressource d’Aatrox | Valeur générique initiale 105.6, inchangée après marche/attaque ; zéro après retour normal |
| Ancienne route locale OLST | Aller-retour du codec seulement ; supervision réseau et rendu non exécutés |

Trois connexions UDP locales, 411 datagrammes, 30 requêtes clientes et 3 246 ticks de simulation. Clés générées par le système et non journalisées. Le temps Host est une entrée diagnostique monotone distincte du tick du jeu. Aucun état de gameplay injecté directement après la création ; la session77 est initialisée dans le constructeur du diagnostic et le décès utilise l’API serveur explicite.

## Binaire, erreurs conservées et contrôles

Binaire : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-aatrox-network-probe-nonce-typed.exe. Taille : 7764480 octets. SHA-256 : 0ac813656b1846e09334e67ae6827a50cec87b301629b2eb9a04a02de4b81fed.

Le premier BUILD s’est terminé avec code101 sur E0284 : taille du nonce non explicite dans le diagnostic privé. Sa source et son journal sont conservés sous revision664_Aatrox_network_probe. La copie nonce_typed précise16octets et réussit. Ce défaut du diagnostic n’est pas attribué au moteur. Le binaire réussi est non-test, lié au vrai core ; les paquets et checksums correspondent au Cargo.lock courant. Les1163entrées sont identiques avant/après.

| Étape réussie | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 31fb93fdbfdec0c639090fdb50b8743fa66a55f262adffa305b5d26bb3020de4 |
| RUN | 0 | cd0fb5e36aeec7ffc848b07da14488ba8d56bad163e631fbf9965dfc142c6b4f |
| prepare | 0 | 95d776cd37a48192f92b702d3340bcf44069d22a24fbfe55bf243dbfffe1bc41 |
| check | 0 | 0be44ab96cbf11e70ab29fd96e35d34e313a1ceeff9e4b2fd6b9219d1c0f4e5e |
| publish | 0 | 9f93a199860284888c916262c2eab9650ccfabedace6b3185ba67da5d8501f4b |
| audit | 0 | be8e3146e85fd5cd8bb07daa95e38c06ec8508afafebec466acfa05290731296 |

Préparation, contrôle candidat, publication et audit indépendants réussis.20associations falsifiées et4graphes invalides refusés. Un fragment d’instructions change,42214restent identiques. Les deux fiches sont relues avec Store.task/copy_text et résolution des dépendances. Dans chaque base :42605autres lignes,42607états manuels et23historiques conservés ;intégrité et synchronisation idempotente vérifiées.

Revue globale :5521ancres et empreintes actuelles exactes,aucun problème.99331sources enregistrées,42215exigences actives,26189questions ouvertes,5517résolues avec historique. Cette revue ne rehache pas toutes les sources historiques et ne mesure pas l’achèvement du jeu.

## Fichiers et preuves

Modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json,docs/fidelity_sources_4_20.json ;deux lignes dans chacune des bases projet et desktop. Reçu :F:\OpenLeague\docs\reference_requirement_trace_sources\aatrox-passive-network-links-v664.json. Preuve :F:\OpenLeague\docs\fidelity_aatrox_passive_network_links_v664.json. Couverture,plan,reprise,CURRENT.md et HANDOFF.md actualisés avec sauvegarde.

Diagnostic :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision664_Aatrox_network_probe_nonce_typed\OBSERVATIONS.json. Inspection :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision664_Aatrox_network_inspection/OBSERVATIONS.json. Audit :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision664_Aatrox_network/DELIVERY_AUDIT.json. Revue globale :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision665_trace_review\REVIEW.json. Neuf copies privées archivées avec contrôle du SHA décompressé ;gain logique 2611712128octets. Reçu d’archive :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision664_Aatrox_network/snapshot-archives/VERIFIED.json ;restauration par revision664_network_restore_validation_snapshots.py. Bases actives et preuves enregistrées conservées.

## Limites et suite

Les sources de métadonnées sont présentes. Le producteur complet du Puits de sang,son état de réserve,ses dépenses,recharges et transitions de résurrection ne sont pas qualifiés. Le schéma filaire et les audiences natifs du passif restent inconnus dans ce lot. Le transport local fonctionne sur les cas exécutés ;le rendu,le HUD,les vrais effets passifs et leur recette multiclient restent à vérifier après implémentation.

Continuer SYS-01.2-02 depuis revision665_trace_review/REVIEW.json. V664 Aatrox PASSIF-NETWORK relié à10sources natives et27points actuels,une question et sa dépendance conservées. Diagnostic réel core+5modules serveur/client :trois endpoints UDP loopback,22projections,411datagrammes,30requêtes,16refus de commandes,5contrôles transport,3246ticks ;1163entrées conservées,BUILD/RUN0. Première compilation101 nonce non typé conservée dans revision664_Aatrox_network_probe ;copie nonce_typed réussie. Aucun Puits de sang complet qualifié :mana générique105.6 initial,puis0 après mort/retour normal480ticks. Visibilité et reconnexion locale testées ;main.receive graphique et politique native restent non exécutés/non établis.121fiches PASSIF-NETWORK restent au chargeur partagé. Prochaine :CH-Ezreal-PASSIF-NETWORK,réutiliser les preuves du transport commun sans les attribuer à son producteur Rising Spell Force ;qualifier ezreal_passive_self_projection,le journal de contacts et le consommateur HUD existants puis prévoir une matrice de projection des champions pour éviter de répéter des contrôles identiques. Les sites précis doivent conserver leur portée et les exceptions de producteurs existants. Aucun PASSIF-SIMULATION-CONTRAT au seul chargeur partagé ne signifie pas passifs terminés. Surveiller espace F avant nouvelles copies de bases ;archiver uniquement des copies privées explicitement vérifiées/restaurables. Goal actif. Première collecte Ezreal enregistrée, reçue et vérifiée :49sources natives,22références communautaires et14fichiers actuels revérifiés ;quatre fiches et les vrais requires_packages conservés. Preuve revision665_Ezreal_network_discovery/OBSERVATIONS.json. Aucun diagnostic runtime Ezreal nouveau exécuté dans cette collecte.
