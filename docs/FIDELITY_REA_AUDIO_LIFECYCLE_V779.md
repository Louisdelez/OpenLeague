# SYS-01.2-02 — Caller audio, médias et fermeture séparée, V779

Projet : F:/OpenLeague. Référence : LoL PUBLIC 4.20.0.315, EUW/en_GB ; catalogue 4.20.1 distinct. Date locale : 30 octobre 2026. Les tâches SYS-01.2-02 et SYS-02.2-07 restent partielles.

## Résultats vérifiés

Le premier parcours exécute le constructeur704B10 et le démarrage704E60 avec la lecture native706A20 du véritable Audio.ini, puis les six banques et les31préfixes ambiants déjà étudiés. Le code du client s'exécute dans Unicorn ; les services physiques et la sortie de diagnostic998430 restent fournis par le banc.

Un second parcours, distinct et sans banques chargées, démarre trois workers coopératifs, exécute l'arrêt705080, répète l'arrêt, puis détruit le propriétaire via704C30. Il ne faut pas confondre ce résultat avec un arrêt après lecture des médias : cette composition reste à vérifier.

| Contrôle | Attendu et observé |
| --- | --- |
| Réglages du caller |1350,−5,40pools,8Mio principal,16Mio bas niveau |
| Lecture de configuration | Cache, parseur, conversions et cinq initialiseurs de hash natifs ; mêmes octets que le PE |
| Parcours média |31préfixes,784sorties mixées,713buffers décodés |
| Comparaison V777 |784/784 sorties et713/713buffers identiques ; aucun décalage du premier signal |
| Comparaison aux WAV |31WAV,730112échantillons PCM16, écart maximal1 |
| Allocation du parcours média |3870créations,2204libérations,1666allocations suivies restantes après les arrêts partiels |
| Octets natifs du parcours média |5585blocs observés, plus les adresses du lecteur de configuration, recoupés avec le PE |
| Arrêt séparé, état vide |60allocations audio suivies et60libérations ; les trois dernières appartiennent au propriétaire et à ses deux sentinelles |
| Workers de cet arrêt | Commandes de fin, signal, attente coopérative puis retour0 des trois workers |
| Handles simulés |15créations et15fermetures observées ; aucun restant dans ce modèle |
| Arrêt répété | Retour1 sans réinitialisation ni nouvel événement de service |
| Vérificateurs |18altérations de preuve rejetées |

La table mémoire native passe de1440 à2880octets, cohérente avec40descripteurs au lieu de20. Les cinq allocations supplémentaires du parcours média sont le propriétaire132octets, ses sentinelles24/44octets, l'objet audio40octets et son nœud24octets. Les différences d'allocations sont vérifiées par rejeu complet des créations et libérations.

Le pic de charge utile demandée au pool principal est120109octets. Cette mesure exclut les en-têtes, la fragmentation, les réservations de pools et les données des banques mappées séparément. Elle ne qualifie pas la capacité ou l'implémentation de l'allocateur natif, même si l'argument de création est bien8Mio.

## Fermeture native et refus

AE9FF0 appelle AEA070 pour déposer la commande5, puis dépose la commande8. Chaque requête désigne le callback AEA250. Le banc suspend l'appelant, fait avancer le worker de banque, observe le callback natif et son SetEvent, puis consomme l'événement automatique avant de rendre l'attente. Le résultat1 n'est pas fourni avant le signal observé.

Le code poursuit ensuite ADBBE0, AEB790, l'arrêt du mixage et de la banque, la désinscription COM, la fermeture des objets et du wrapper IO, puis ADA720. Le flag du propriétaire, les globals principaux audio, les indicateurs mémoire/COM et les références COM observées reviennent à zéro. Les trois allocations CRT du propriétaire restent après705080 puis disparaissent lors du destructeur704C30.

Trois profils frais qualifient les limites de ce parcours vide :

| Refus fourni | Retour natif AE9FF0 | Retour705080 | Effet observé |
| --- | --- | --- | --- |
| Premier événement indisponible |2 |1 | Aucune commande5/8 déposée |
| Second événement indisponible |2 |1 | Commande5 exécutée, pas de commande8 |
| Allocation60octets de la file refusée |52 |1 | Commande5 demandée, admission refusée, aucun callback de fin |

Le propriétaire ignore donc ces refus de vidage dans son retour. Les états vides testés libèrent les allocations suivies, mais cela ne prouve pas la sûreté de la même séquence avec des banques chargées. Le premier vérificateur du refus mémoire attendait2 à tort ; l'observation52 a été conservée, puis un nouveau script a vérifié le scénario jusqu'à la destruction du propriétaire.

## Limites physiques explicites

La création et la destruction des pools sont des services adaptés. La destruction est acceptée dans le banc seulement pour un pool demandé et devenu vide. Les identifiants21,17,29,23 sont détruits explicitement. Le pool19 est demandé mais aucune destruction explicite n'est observée ; les adaptateurs de création ne remplissent pas la table native de descripteurs. La durée de vie réelle de cette réservation et le fonctionnement complet du gestionnaire mémoire restent ouverts.

« Zéro allocation suivie » concerne uniquement le suivi audio du banc. Les buffers du banc de configuration, la mémoire du processus, les callbacks de fin de processus et les ressources physiques n'en font pas partie. Les15handles, le COM, les événements et les threads sont simulés. Aucun son matériel, lancement du processus historique, thread Windows concurrent ou fermeture complète du jeu n'est qualifié.

Les31préfixes ne sont pas les clips complets. Streaming, seek, boucles, autres médias/locales, files IO peuplées, événements applicatifs et ordre réel du bootstrap CRT restent ouverts. Les13profils de configuration V778 sont des preuves héritées, non réexécutées dans ce lot.

## REA, sources et consommateurs courants

REA6.4.0, SDK2.3.1, Ghidra12.1.4, Java21 :14fonctions,696instructions et70références analysées et recoupées avec le PE. Session fermée et preuves exportées. Fonctions :705080,7056A0,7066A0,AE9FF0,ADBBE0,AEB790,ADA720,5D48B0,B0F700,AF4360,AFC8D0,AF8AB0,B05940,B09200.

Binaire original : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe.
SHA256 :402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

Les44liens sources sont relus : PE, six banques, Audio.ini, Locale.cfg,31WAV, manifeste et trois fichiers Rust. Les neuf sources natives sont reliées aux observations. La correspondance d'Audio.ini au manifeste est conservée ; la provenance non résolue de Locale.cfg et la priorité des montages restent ouvertes.

Les quatre ancres existantes de file/worker de banque sont conservées. Une cinquième ancre identifie précisément run_with_common dans crates/core/src/audio_bank_command_worker.rs : il traite les sélecteurs0 et1, tandis que5 et8 atteignent l'erreur explicite « bank worker command selector not qualified ». Cette constatation est statique. Elle ne constitue ni une nouvelle implémentation ni une exécution Rust réussie. Aucun code produit ou asset n'est modifié, aucun build ou test Rust n'est lancé dans V779.

## Tentatives et preuves conservées

Les premières tentatives de fermeture ont exposé successivement une attente d'événement non prise en charge, la désinscription COM absente du faux périphérique et la destruction de pools autres que29 non modélisée. Chaque échec reste conservé avec sa position native et ses observations. Ces manques du banc ne sont pas déclarés comme des bugs du jeu.

Le premier vérificateur des pics d'allocation réutilisait le nom d'une variable de données média ; il échouait avant la comparaison. Le vérificateur corrigé possède un fichier et un reçu séparés. Les observations d'exécution n'ont pas été réécrites.

Sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :

- revision779_caller_media/OBSERVATIONS.json : parcours avec médias.
- revision779_media_validation_accounted/OBSERVATIONS.json : vérification initiale corrigée.
- revision779_shutdown_owner/OBSERVATIONS.json : cycle sans banques puis destruction.
- revision779_event_first_failure, revision779_event_second_failure, revision779_bank_queue_oom_checked : refus fraîchement exécutés.
- revision779_shutdown_validation.json et revision779_associations/OBSERVATIONS.json : validations finales, sources, nouveau consommateur et18refus d'altération.
- revision779_rea_audio_shutdown/observations/8ffae5c1-4a92-479b-b33a-14d64ade9861/receipt.json : session REA fermée.
- revision779_delivery : deltas réversibles, conservation des bases et relecture indépendante.

Livraison : ce rapport, docs/fidelity_rea_audio_lifecycle_v779.json, registres de sources/exigences/tâches, deux fiches des bases projet/bureau et documents de couverture/reprise. Les cases, notes, historiques et toutes les autres tâches sont conservés. Les reçus de livraison déterminent le succès effectif de l'intégration.

## Prochaine action

Continuer SYS-01.2-02 sur F avec REA. V779 compose le vrai caller704E60/Audio.ini avec31préfixes et qualifie séparément le teardown705080 puis704C30 sans banques chargées. Prochaine étape : composer le même teardown avec les banques/médias chargés, en qualifiant les commandes5/8, leurs effets et interactions avec le worker de mixage ; vérifier les refus dans cet état peuplé. Le banc adapte encore la création/destruction des pools et ne remplit pas les descripteurs natifs : le pool19 demandé ne possède pas de destruction explicite observée. Qualifier cette frontière avant de conclure à une fermeture complète des ressources. Relier les consommateurs Rust correspondants ; run_with_common accepte0/1 et refuse5/8, sans test Rust nouveau. Garder ouverts logger réel, CRT/ordre des initialiseurs, provider/locale, concurrence/TLS, IO/transfert, événements applicatifs et clips complets. Les13profils de configuration V778 sont hérités. Préserver preuves, cases, notes et historiques ; deltas ciblés sur F.
