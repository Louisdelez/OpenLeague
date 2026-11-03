# SYS-01.2-02 — Configuration et démarrage audio natifs, V778

Projet : F:/OpenLeague. Référence : LoL PUBLIC4.20.0.315, EUW/en_GB ; catalogue4.20.1 distinct. Date locale :30octobre2026. Tâches SYS-01.2-02 et SYS-02.2-07 enrichies ; elles restent partielles.

## Résultat et portée

Le constructeur704B10 et le démarrage704E60 sont exécutés depuis le PE original dans un banc Unicorn. Le démarrage appelle réellement706A20 : le cache, le chargement, le parseur, les recherches et les conversions natives lisent Audio.ini dans la même mémoire que le moteur audio. Les valeurs ne sont pas recopiées artificiellement depuis une observation séparée.

Le démarrage atteint AL=1 et positionne le flag propriétaire+0C. Un second appel retourne1 sans recharger la configuration, créer de nouvelles allocations ou modifier l'objet. L'objet audio par défaut de40octets est créé via7055D0/707080 ;706310 et7063A0 sont parcourus. Aucun chargement de banque n'était préinscrit dans la liste du propriétaire.

La sortie du journal998430 est fournie par le banc. Son format observé est « AudioManager: Wwise Version %s initialized. » et son argument est « v2013.2.2 ». Cette observation identifie la chaîne utilisée ; elle ne qualifie ni le logger réel ni un périphérique audio. Les services physiques Windows, COM, mémoire et threads restent explicitement fournis. Aucun processus historique du jeu n'est lancé.

## Valeurs de référence et contrôles

| Champ | Valeur par défaut native | Valeur effectivement lue |
| --- | --- | --- |
| Setup_Wwise/ListenerHeight |500 |1350 |
| Setup_Wwise/ListenerRotation |0 |−5 |
| Memory/MaxMemoryPoolCount |20 |40 |
| Memory/DefaultPoolSizeMB |16 |8, converti en8388608octets |
| Memory/LowLevelPoolSizeMB |16 |16, converti en16777216octets |

La différence du pool principal est concrète : la création native reçoit8Mio dans ce parcours, contre16Mio dans les réglages par défaut précédemment fournis au banc. Les autres pools observés sont64Kio,2Mio IO,64Mio de sortie et16Mio bas niveau. Les conséquences sur les médias doivent encore être vérifiées en composant ce démarrage avec le parcours précédent.

- Lecture isolée :5974adresses d'instructions recoupées avec le PE ;20octets de résultat et8octets sentinelles préservés.
- Démarrage composé :1023blocs natifs observés et7063adresses de configuration recoupés avec le PE. Un bloc observé ne signifie pas que chaque instruction qu'il contient a été exécutée après une interception de service.
-13profils de configuration : original, fichier absent, fichier vide, clés partielles, casse différente, valeurs alternatives, texte numérique invalide, zéros, valeurs négatives, dépassement du décalage en Mio, suffixes après nombre, initialiseurs de hash omis et notation scientifique.
-12altérations de preuve rejetées par les vérificateurs, notamment mauvais pool, hash absent, écrasement sentinelle, faux retour, transition non revenue, réinitialisation inventée, diagnostic masqué et octets natifs altérés.

Le fichier absent ou vide donne500/0/20/16Mio/16Mio. Une clé absente conserve son défaut. Les nombres invalides présents deviennent0 ; les préfixes numériques avec suffixes sont acceptés. Les entiers négatifs deviennent des mots32bits ; le décalage gauche20 des tailles déborde modulo2^32 :4096Mio donne0,4097Mio donne1Mio. Ces limites natives restent documentées ; elles ne constituent pas une validation d'entrée sûre à reproduire aveuglément.

Les cinq initialiseurs527400,527470,5274E0,527550,5275C0 sont exécutés explicitement. Ils produisent les hash4214787660,860919971,4105135959,1323416170,1338411083. Leur omission contrôlée laisse les valeurs par défaut malgré le fichier présent. L'ordre global de démarrage CRT reste non qualifié.

## Sources, REA et consommateurs

REA6.4.0 avec SDK2.3.1, Ghidra12.1.4 et Java21 :17fonctions,1133instructions et460références analysées puis recoupées avec le PE. Session fermée et preuves exportées. Le binaire original et sa copie d'analyse gardent la même empreinte avant/après.

Binaire : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe.
SHA256 :402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

Audio.ini :258octets, SHA256 d94ce3ae7defaecb25a124da0b96d7a93e6a54bb31f75b5514f36e19a0101367 ; source déjà recensée OLS-bd781c10-6d43-52ab-a3a4-b8f01117328a, correspondance au manifeste conservée. Locale.cfg :37octets, SHA256053f2ad45a7d6c808ba0b394f6a101e985099a953e5a2c7575ab44467804b42f ; son absence des deux manifestes sélectionnés reste ouverte. La lecture en_GB ne résout pas sa provenance ni l'ordre réel des montages.

Quatre ancres existantes audio_bank_command_worker.rs/audio_bank_command_queue.rs sont revérifiées. Elles restent en aval et ne prouvent pas le démarrage audio Rust. Les modules native_game_cfg_text.rs,native_config_cache.rs,native_config_resource_dispatch.rs,native_config_cache_reload.rs sont inspectés : parseur, cache et distribution partiels existent. La recherche bornée dans crates ne retrouve pas les cinq clés audio ni les adresses du caller ; cela ne prouve pas une absence globale. Aucun nouveau consommateur n'est inventé. Aucun code produit, asset, build ou test Rust n'est modifié/exécuté dans ce lot.

## Tentatives conservées

La première composition tentait de remapper une page déjà utilisée par le banc de configuration. La suivante atteignait un malloc CRT40octets non adapté ; ce service d'allocation est désormais explicite. La troisième atteignait le journal réel et un accès mémoire non mappé dans ses dépendances ; la sortie diagnostic isolée est déclarée comme limite. Ces échecs du banc ne sont pas présentés comme des bugs du jeu original.

La première série de copies de configuration était refusée par la garde de lecture, car sa racine déclarée restait le dossier historique sur D. La série corrigée déclare la racine privée sur F ; les13cas ont été exécutés à nouveau. Les fichiers D n'ont pas été modifiés. Les scripts et reçus d'échec sont conservés.

## Livraison et preuves

Sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :

- revision778_audio_config/OBSERVATIONS.json : lecture native du fichier historique.
- revision778_caller_diagnostic/OBSERVATIONS.json : constructeur, démarrage et second appel.
- revision778_config_boundaries_scoped/OBSERVATIONS.json :13profils frais, copies privées explicitement distinguées du fichier original.
- revision778_caller_associations/OBSERVATIONS.json : validation,12refus, sources et consommateurs.
- revision778_rea_audio_caller/observations/1a34f858-f4ab-44f9-aac8-0ef0c405d8a5/receipt.json : session REA.
- revision778_delivery : préparation, deltas exacts réversibles, vérification et relecture des bases.

Fichiers intégrés : ce rapport et docs/fidelity_rea_audio_caller_v778.json ; trois registres de tâches/sources/traçabilité ; couverture,plan,reprise,docs/ai et REA_WORKFLOW.md. Deux fiches des bases projet et bureau sont actualisées, avec préservation des autres tâches, cases, notes et historique. Les reçus de livraison déterminent le succès effectif de cette publication.

## Limites et prochaine action

Trois créations de workers sont demandées mais différées ; aucun worker ni média n'est exécuté dans ce nouveau caller.56allocations restent vivantes. Le teardown global705080 n'est pas exécuté. Les preuves V777 de31préfixes, workers et IO sont antérieures et séparées, sans revendication de réexécution ici. Les branches d'échec complètes du caller et ses listes de banques non vides restent ouvertes, ainsi que les services physiques et l'intégration au runtime Rust. Pas d'acceptation humaine ni de complétude du jeu.

Continuer SYS-01.2-02 sur F avec REA. V778 qualifie le caller704E60 avec706A20 et les cinq initialiseurs de hash explicites, Audio.ini réel et objet audio par défaut ; diagnostic998430 fourni. Prochaine étape : composer ce caller avec le parcours de banques/médias/worker déjà qualifié, vérifier les effets du pool principal réel8Mio, puis le teardown705080 et ses dépendances. Retrouver ou relier le consommateur Rust ordinaire ; les quatre modules de configuration inspectés ne prouvent pas le démarrage audio. Garder ouverts journal réel, bootstrap CRT et ordre des initialiseurs, provenance/precedence de locale.cfg, threads/TLS/allocateurs/périphérique physiques, files IO et transferts, listes ADB et événements applicatifs, clips complets/autres médias/locales/commandes1..11. V777 média et IO reste une preuve antérieure, non rejouée dans V778. Préserver sources, preuves, cases, notes et historiques ; deltas ciblés sur F.
