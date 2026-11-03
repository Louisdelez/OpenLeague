# SYS-01.2-02 — De l’événement natif à la voix, V782

Projet : F:/OpenLeague. Référence : LoL PUBLIC4.20.0.315, EUW/en_GB ; catalogue4.20.1 distinct. Les tâches SYS-01.2-02 et SYS-02.2-07 restent partielles.

## Résultat et contrat observé

Le test appelle le wrapper original706850 avec le nom `Play_sfx_TT_Shopkeeper_idle2`, un objet audio enregistré2000001, cookie0 et âge0. Le getter7072F0, le hashAEA430 et PostEventAEA950/AEA880 exécutent leurs instructions natives. La banque originale relie l’événement910296306 à l’action733518497 (type0x403), au conteneur8083, au son636243997 et au média306723203. Les objets HIRC chargés et les octets sérialisés de la banque sont vérifiés.

Un premier essai a retourné l’identifiant1 sans créer de voix après80cycles de workers : la frame n’était pas publiée. Cet échec est conservé ; ce n’est ni un succès audio ni la preuve d’un défaut du jeu. L’essai suivant appelle réellement AEB000→B08440, qui publie un paquet de8octets et incrémente le compteur de frame. B06C60 consomme alors les commandes ; B05F00 déclenche l’action et les fabriques natives créent la voix. Aucun appel direct de fabrique ne la remplace dans le scénario principal.

Le stockage C++ de l’objet wrapper et de la chaîne est fourni au banc. Le créateur et l’émetteur ordinaires du jeu ne sont pas exécutés. Le nom vide revient avant même le getter d’objet. B06B10 est analysé statiquement mais n’est pas exécuté sur cette action immédiate.

## Vérifications réellement exécutées

| Cas / résultat attendu | Observation |
| --- | --- |
| Événement valide, objet enregistré, publication de frame : voix créée | Identifiant1, une voix et signal non nul sur2frames |
| Échantillons décodés cohérents avec le média du projet | 6appels,6 144échantillons PCM16 contigus ; erreur maximale1 par rapport au WAV |
| Nom vide : rejet immédiat | Retour0, aucun getter, aucune voix ni décodage |
| Nom inexistant : événement absent | Retour0, aucune voix ni décodage |
| Objet non enregistré : admission à vérifier après mise en file | Retour1, mais aucune voix ni décodage après consommation |
| Absence de publication de frame | Premier essai conservé :80cycles,160entrées de consommation, aucune fabrique |
| Arrêt global de la voix active | B17E00 appelé pendant705080 ;6attentes banque→mix avec signal,1itération chacune |
| Allocation et libération suivies | 1 791/1 791, zéro après704C30 ;21handles simulés fermés ;3workers terminent avec0 |
| Second arrêt | Retour1 sans nouvel événement de service |
| Identité d’exécution | 7 138blocs natifs comparés aux octets du PE, plus les contrôles de configuration hérités du banc |
| Intégrité des validateurs | 14altérations des preuves ou contrats rejetées |

Les trois profils limites utilisent chacun les banques originales, la publication de frame, deux cycles de workers et l’arrêt. Ils équilibrent respectivement1 737,1 737 et1 738allocations suivies. L’identifiant retourné par PostEvent ne prouve donc pas, à lui seul, l’admission d’une voix.

La publication traite aussi les commandes d’initialisation déjà en attente, dont l’enregistrement natif de l’objet2. Le registre avant arrêt contient0,2 et2000001. Un premier validateur attendait seulement0 et2000001 ; un autre supposait un getter pour le nom vide. Leurs scripts, échecs et corrections restent conservés. Les observations natives n’ont pas été modifiées pour les satisfaire.

## REA et consommateurs actuels

REA/Ghidra a analysé706850,AEA950,AEA880,AEA430,B06C60,B05F00,B06B10 etB1A960 :8fonctions,1 752instructions,28références. Les octets, les fichiers exportés et la fermeture de session sont vérifiés. B1A960 correspond à l’ordre des actions sérialisées chargé depuis la banque originale.

Douze ancres actuelles sont inspectées. Une ancre statique est ajoutée pour `audio_event_post::dispatch` ; le code existant délègue Post et Seek à des closures. Les ancres existantes de `audio_action_dispatch::post_immediate_event`, `audio_common_queue::consume_with_dispatch` et `publish_frame` sont reliées à cette preuve. La sélection d’actions sur contrat fourni, le transport de queue et la publication de frame ne démontrent pas une chaîne Rust complète de lecture. Le consommateur de commandes de banque inspecté refuse toujours les sélecteurs5/8. Aucun nouveau build ou test Rust n’est revendiqué.

## Sources et preuves

- PE : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe` ; SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- Banque événements : `NPC_Map10_SFX_events.bnk`,17 282octets, SHA256 `613e6c75090ed1277e2e737cce1d5f24431be9d1fb5835cc71ad4816e0353e26`.
- WAV du projet : `assets/audio/ambient/306723203.wav`,504 880octets, SHA256 `c25b0fed8cfa00d59db9bf983a56e16924f5efb3ddee4f636c90faf61ecd7c89`.
- Racine des preuves : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20`.
- `revision782_event_voice_probe/FAILED.json` : essai sans publication.
- `revision782_event_voice_frame/OBSERVATIONS.json` : chaîne nominale et arrêt.
- `revision782_event_empty_name`, `revision782_event_unknown_event`, `revision782_event_unregistered_object` : profils limites.
- `revision782_registry_validator_failure.json` et `revision782_contract_validator_failure.json` : erreurs des validateurs conservées.
- `revision782_rea_event_voice/observations/cbf1b42c-d4c6-437a-b136-6eb5603b1ae0/receipt.json` : session REA.
- `revision782_associations/OBSERVATIONS.json` : contrôles, sources et consommateurs.
- `revision782_delivery` : publication, delta réversible et relecture indépendante des registres et des deux bases.

## Limites

Une voix résidente mono, un événement, cookie0 et âge0 seulement. Les autres événements, émetteurs/constructeurs du jeu, callbacks, âge/seek, délais, boucles, streaming, voix simultanées et autres locales restent ouverts. L’arrêt appelle ici B17E00 avant la fin du clip ; sa différence avec le parcours direct V781 est constatée, sans attribution non vérifiée à un champ précis.

Heap/pools, verrous, TLS, horloge, COM et transports de threads/événements sont adaptés. Aucun jeu historique ni périphérique audio réel n’est lancé. Le zéro d’allocations exclut les mappings des banques, la mémoire de configuration/processus, réservations physiques et ressources Windows. Pool19/descripteurs restent ouverts.

Cette révision modifie les preuves, les liens source/consommateur, deux fiches dans les registres et les deux bases, ainsi que couverture/reprise. Aucun code Rust ou asset modifié. Cases, notes, historiques, inconnues, prérequis et autres tâches conservés. Aucun statut de jeu complet ou d’acceptation humaine n’est accordé.

## Suite

Continuer SYS-01.2-02 sur F avec REA. V782 qualifie un événement résident du marchand avec stockage wrapper/string fourni, cookie0 et âge0 ; ne pas généraliser au créateur/emitter du jeu. Prochaine étape : qualifier les autres événements et les callbacks/cookies et âge/seek sur cette chaîne, puis les refus avec voix active et le streaming/IO. Relier les consommateurs Rust ordinaires ; dispatch événement et transport de queue ne prouvent pas la création de voix intégrée ; arrêt global5/8 encore refusé. Garder ouverts descripteurs physiques/pool19, concurrence/TLS, provider/locale et autres exigences. Préserver sources, preuves, cases, notes et historiques.
