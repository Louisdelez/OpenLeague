# SYS-01.2-02 — Initialisation et arrêt IO audio, V777

Projet F:/OpenLeague. Référence LoL PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct. Date locale30octobre2026. Tâches SYS-01.2-02 et SYS-02.2-07 enrichies, toujours partielles.

## Résultat vérifié

Le parcours comprend maintenant les instructions natives de B37F20,704590,704700,B37A40, le worker B3D090 jusqu'à son attente, puis le destructeur704620 après les31préfixes ambiants et l'arrêt des workers de banque et de mixage. Les octets x86 exécutés restent ceux du PE ; mémoire physique, services Windows, COM, horloge, événements et transport des threads sont explicitement fournis par le banc Unicorn. Aucun processus historique du jeu n'est lancé.

| Vérification | Attendu et observé |
| --- | --- |
| Réglages IO |48octets produits par B37F20 ;8octets sentinelles conservés |
| Wrapper |28octets CRT et un second objet28octets ; constructeur704590, initialisation704700 retour1 |
| Périphérique nominal |208octets, vtable FF3400 ; resolver publié par B38150, slot0 créé par B37A40 |
| Cache IO |Bloc2MiB fourni au pool29, métadonnées4096octets et indices256octets |
| Worker IO |Entrée B3D090, attente sur stop/travail, puis retour0 après arrêt natif |
| Destruction |Signal, attente coopérative, fermeture de5handles IO ;7allocations libérées et resolver remis à zéro |
| Résidu IO |Vecteur de4octets conservé, capacité1 et slot nul ; pas de teardown global |
| Média |Six banques et leurs doublons,31préfixes ;784sorties mixées et713buffers décodés identiques à V776 |
| Comparaison WAV |31WAV,730112échantillons PCM16, écart maximal1 |
| Octets natifs |5441blocs exécutés recoupés avec le PE |
| Allocations du parcours |3865créations,2204libérations,1661restantes |
| Limites IO |21profils exécutés puis relus ;6retours1,15retours2 |
| Résistance des vérificateurs |26altérations de preuves rejetées |

Le solde des allocations après destruction ajoute seulement un vecteur4octets pool23 par rapport à l'histogramme V776. Les objets globaux du moteur, banques, mémoire/stream et ADB restent présents. Ce rapprochement ne prouve pas une fermeture complète du moteur.

## Scénarios IO et anomalies natives conservées

Les21profils couvrent : défaut, backend alternatif, deux flags simultanés, aucun backend, granularité nulle, lookahead négatif, limites du compte asynchrone0/1/1024/1025, cinq refus d'allocation, quatre refus de création d'événement, refus de thread et refus de pool.

Les profils défaut, alternatif, deux flags, compte1 et1024 réussissent ; le flag1 prend la priorité quand les deux flags sont présents. Les réglages invalides et les refus de services concernés retournent2. Après ces15échecs, le pointeur global resolver contient encore l'adresse du wrapper alors que son allocation a été libérée : le destructeur ignore le nettoyage IO lorsque son flag d'initialisation est nul. Ce comportement observé reste une limite, pas une implémentation Rust validée ni une exigence à recopier aveuglément.

Le quatrième événement (ready) n'est pas vérifié par l'initialisation : son absence laisse un retour1. Le premier WaitForMultipleObjectsEx reçoit un handle nul et le service fourni retourne WAIT_FAILED ; le code natif effectue ensuite une deuxième attente sur trois handles valides. Il atteint l'attente et peut être arrêté normalement dans ce profil. Il ne faut pas présenter tous les retours1 comme des états complets.

Les10profils ADB V776 sont relus comme preuves héritées ; ils ne sont pas comptés parmi les21exécutions IO nouvelles. Les six contrôles du parcours média ont été rejoués avec la nouvelle composition.

## REA et provenance

REA6.4.0, SDK2.3.1, Ghidra12.1.4, Java21. Session achevée, preuves exportées et fermeture confirmée ;14fonctions,523instructions et24références vérifiées par lecture des octets du PE. Binaire original et copie d'analyse possèdent la même empreinte avant/après. Les temporaires Ghidra sont supprimés par le fournisseur à la fermeture ; seuls les fichiers explicitement conservés sont présentés comme preuves.

Fonctions analysées : B39580,B382A0,B3CEF0,B3CF70,B3D3F0,B3D330,B3B2E0,B3C6A0,B389D0,B3C230,704620,704830,706A20,B3DBB0.704830 consulte l'objet à+14, appelle ses méthodes virtuelles+1C puis+24 et compare la quantité lue : callback de positionnement/lecture, pas destructeur. Cette fonction et706A20 ne sont qualifiées ici que statiquement. Les types reconstruits du décompilateur ne sont pas des types sources garantis.

Source : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe.
SHA256 :402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

## Consommateurs courants

Les42liens sources hérités sont revérifiés : PE et six banques,31WAV, manifeste et trois fichiers Rust. Sept sources natives sont reliées à cette preuve. Quatre ancres des modules audio_bank_command_worker.rs et audio_bank_command_queue.rs sont conservées et vérifiées sur les fichiers actuels. Elles sont en aval ; elles ne prouvent pas que le bootstrap IO natif est reproduit par le client Rust ordinaire.

La recherche bornée dans crates et la lecture des candidats sont enregistrées. audio_device_factory.rs concerne le périphérique de sortie B260B0 et audio_replay_stream_transport.rs le transport8F6D00 ; leur nom ne justifie pas de les assimiler à la fabrique IO B37A40. Aucune absence globale d'implémentation n'est déduite de cette recherche textuelle. Aucun code produit, asset, build ou test Rust modifié/exécuté dans ce lot.

## Tentatives conservées et correction du banc

Les premiers essais ont rencontré un pool IO non pris en charge, puis un événement initialement signalé non pris en charge. Les adaptateurs déclarent maintenant explicitement ces services et le bloc2MiB réellement fourni au cache. Un essai avec signal de travail sans requête associée atteint la borne de10000000instructions : il reste séparé du démarrage et de l'arrêt nominaux, sans prétendre démontrer un blocage d'un thread Windows réel.

Le premier test event_4 attendait à tort un retour immédiat du worker après le premier WAIT_FAILED. Les instructions natives et la trace montrent la deuxième attente. Le nouveau script conserve le premier échec et rejoue les21profils avec cette attente correcte. Les observations natives anciennes n'ont pas été réécrites.

## Preuves, contrôles et fichiers

Sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :

- revision777_io_media/OBSERVATIONS.json : composition et octets natifs.
- revision777_io_worker_checked/OBSERVATIONS.json : vie IO isolée.
- revision777_io_boundaries_checked/OBSERVATIONS.json :21profils nouveaux.
- revision777_media_validation/OBSERVATIONS.json : allocations, sorties, WAV, workers et limites.
- revision777_media_associations/OBSERVATIONS.json : REA,42liens,4ancres et26refus de falsification.
- revision777_rea_io_initialization/observations/8fcbf50b-c797-42df-a275-11d02b631b7d/receipt.json : session REA fermée.
- revision777_delivery : deltas ciblés, relecture des bases et vérification finale.

Contrôles exécutés : revision777_io_boundaries_checked.py, revision777_media_validate.py, revision777_media_associations.py, puis scripts de livraison/relecture/vérification finale identifiés dans leurs reçus. Les exécutions natives initiales et REA sont identifiées séparément par leurs reçus ; aucun relancement silencieux n'est revendiqué.

Fichiers intégrés : docs/FIDELITY_REA_AUDIO_IO_V777.md, docs/fidelity_rea_audio_io_v777.json ; registres fidelity_sources_4_20.json,fidelity_requirement_trace_4_20.json,completion_tasks_2026-10-20.json ; couverture,plan,reprise,docs/ai et REA_WORKFLOW.md. Deux fiches des bases projet/bureau actualisées avec conservation des états manuels, autres tâches, notes et historique. Les reçus indépendants déterminent si la publication a effectivement réussi.

## Limites et suite

Pas de file IO non vide ni de transfert de fichier, pas de threads physiques ou TLS séparés, pas d'audio physique. Les services sont coopératifs et le TLS CRT fourni est partagé. Les31préfixes ne prouvent ni les clips entiers ni tous les médias/locales. ADB3C0 est appelé815fois avec liste vide ; ADB9F0/ADE700 sont enregistrés, pas exercés. Les inconnues et prérequis restent ouverts. Aucune acceptation utilisateur ni complétude du jeu n'est déclarée.

Continuer SYS-01.2-02 sur F avec REA. V777 compose l'initialisation IO, l'attente du worker et son destructeur avec les31préfixes ; les services physiques restent fournis. Prochaine étape : qualifier le caller704E60 avec configuration706A20 effective, puis le teardown global et le consommateur Rust ordinaire.704830 est un callback seek/read, pas un destructeur : sa lecture statique ne prouve pas le transfert. Conserver les limites du quatrième événement non vérifié, du resolver restant après échec et du réveil sans requête ayant atteint le budget d'instructions. Garder ouverts files IO non vides, fichiers/seek/transfert, allocateurs physiques, threads/TLS distincts, périphérique réel, listes ADB non vides, événements applicatifs, clips complets, autres médias/locales et commandes1..11. Les10profils ADB V776 sont hérités, pas rejoués. Préserver sources, preuves, cases, notes et historiques ; deltas ciblés sur F.
