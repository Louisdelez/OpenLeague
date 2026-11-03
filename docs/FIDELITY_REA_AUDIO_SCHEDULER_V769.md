# SYS-01.2-02 — Ordonnancement audio natif, V769

Projet : F:/OpenLeague. Référence : LoL PUBLIC 4.20.0.315, EUW/en_GB. Fiches enrichies : SYS-01.2-02 et SYS-02.2-07. Leurs objectifs complets restent ouverts.

## Résultat attendu et observé

Le parcours B06950 ordonne maintenant les banques, objets, voix, décodeur, mixage et libérations natifs dans le banc isolé. Les corps aval ne sont pas remplacés par des callbacks simulés. L'horloge physique reste un adaptateur explicitement avancé selon la période du périphérique de secours.

| Contrôle | Observation |
| --- | --- |
| Appels B06950 | 804 sur31 médias, dont31 sans quota |
| Frames traitées | 742 actives et31 arrêts ;compteur final773 |
| Horloge adaptée | 1000→17233ms, incrément21ms par passage positif |
| Quota nul | Commandes et actions échues parcourues ;aucun post/mix ni incrément du compteur ;notification de contrôle conservée |
| Listener | Huit flags initiaux déclenchent un masque255 vers B09B60 ;flags ensuite remis à zéro |
| Sortie | 773 soumissions de1024frames,61actives positives et31arrêts nuls |
| Comparaison V768 | Les742 empreintes de sortie active sont identiques |
| Décodeur | 712buffers,729088échantillons PCM16 ;écart maximal1unité contre31WAV identifiés |
| Intégrité native | 4675blocs comparés aux octets du PE original |
| Durée de vie | 3844allocations,2213libérations,1631restantes ;aucun teardown global annoncé |
| Limites/refus | Six profils de refus/limites hérités rejoués ;huit falsifications de preuve rejetées |

À quota positif, les deux managers sont avancés puis les listeners sont notifiés avant AF3F80 et B0FDB0. B0F5F0 exécute aussi la préparation de sortie et le retrait des bus ;AF3AA0 nettoie les notifications et les voix à l'intérieur de l'ordonnanceur. Une dernière passe commandes/actions échues suit la frame. Le drainage manuel suivant l'arrêt ne fait plus rien. Un simple appel B0DFC0 ne démontrait pas cette chaîne complète.

## REA, source et consommateurs actuels

REA6.4.0 avec Ghidra12.1.4 a analysé12 fonctions,1717 instructions et13 références. Session exportée et fermée sans erreur. Source PE SHA256 :402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. L'original reste inchangé ;REA travaille sur une copie d'analyse.

Les fonctions demandées sont B0FB40,B0FDB0,B09B60,AF3F80,AF5B10,B14140,B06C60,B07E50,B0F5F0,B0EA90,B1C590 etB15110. Les deux dernières sont analysées statiquement ;leurs branches optionnelles restent désactivées dans ce banc. La lecture statique B06950 de V768 est conservée et son corps est exécuté ici.

Trois consommateurs précis sont reliés :audio_normal_frame::run_locked, audio_fallback_device::quota et audio_listener_backend::flush_changes. Le dispatch des quatre services Post déjà inscrit est réutilisé. Le code existe ;ces liens ne prouvent pas que son backend complet est branché dans le jeu ordinaire. Aucun code produit ni asset n'est modifié et aucun nouveau Rust/client n'est exécuté.

## Contexte fourni et limites

Le banc exécute le x86 original dans Unicorn. Allocations physiques, verrous, TLS, atomiques et horloge sont adaptés. Common0x98, manager de transitions vide0x20 et affectation du périphérique sélectionné sont fournis. Le périphérique de secours lui-même est construit par le code natif. Les files commandes/actions échues sont vides ;la file de notifications de contrôle est réelle et non vide au début. Callbacks,worker optionnel et callback final sont absents. Les positions restent nulles, les gains et pitch restent natifs.

Les31 médias résidents et leurs préfixes ne couvrent pas tous les sons. Un cas atteint la borne80 à sa première frame positive79. Quotas multiples avec voix actives, positions réelles, événements ordinaires, autres médias/locales, streaming, seek, boucles, concurrence et bootstrap complet restent ouverts. Aucun périphérique physique ou écoute accepté ;1631 allocations de banques, sorties et capacités restent vivantes.

Le premier validateur omettait le champ entry présent dans le contexte capturé et supposait une file vide sans quota. Un validateur distinct corrige ces attentes :il exige le contexte complet et la conservation de la notification en attente. L'échec initial reste conservé ;ce n'est pas un défaut du produit.

## Contrôles et preuves

- revision769_rea_audio_scheduler/observations/a937511c-24ea-4719-a111-24a10429843a/receipt.json :session REA, copies et empreintes.
- revision769_scheduler_explore/OBSERVATIONS.json :premier média, essai réussi.
- revision769_scheduler_checked/OBSERVATIONS.json :31médias et limites natives.
- revision769_scheduler_validation/FAILED.json :erreur du premier validateur conservée.
- revision769_scheduler_validation_corrected/OBSERVATIONS.json :relecture des octets, quotas, ordre et tampons.
- revision769_scheduler_associations/OBSERVATIONS.json :liens source et huit falsifications rejetées.
- revision769_delivery/VERIFIED.json et INDEPENDENT_READBACK.json :publication et relecture des deux bases.

Dossier de preuves :F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Preuve intégrée :docs/fidelity_rea_audio_scheduler_v769.json. Les états manuels, notes, historiques et inconnues restent conservés.

## Suite

Qualifier le bootstrap parent et ses entrées effectives, puis le backend concret des services Post du Rust, les positions/listeners réels et le transport physique. Cette tâche de traçabilité n'est pas une déclaration de jeu complet.
