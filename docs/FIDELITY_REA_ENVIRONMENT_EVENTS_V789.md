# SYS-01.2-02 — Événements audio environnementaux, V789

Projet : F:/OpenLeague. Exigence détaillée : SYS-02.2-07, « Valider les banques et médias audio natifs ». Ce lot relie les actions, voix et médias de trois événements à leurs consommateurs Rust actuels. Il ne clôt ni cette exigence entière ni le goal.

## Sources et analyse REA

REA 6.4.0, Ghidra 12.1.4 et Java 21.0.10 analysent une copie isolée exacte du PE x86 League of Legends.exe : 15973880 octets, SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Les octets originaux et les assets sont conservés. Le dépôt de l’outil est https://github.com/morluto/rea. Les huit liens natifs ajoutés identifient le PE, Audio.ini et six banques ; leurs empreintes sont celles des sources déjà recensées. Il ne s’agit pas de huit ressources découvertes supplémentaires.

| Fonction REA | Observation | Instructions |
| --- | --- | ---: |
| 0xB05F00 | Dispatch immédiat ou différé selon le délai | 107 |
| 0xB06B10 | Exécution et nettoyage différés ; analyse statique seulement ici | 31 |
| 0xB2D240 | Probabilité, propriété16 et admission de la voix | 131 |
| 0xB05050 | Tirage pondéré ; analyse statique seulement pour ces profils non pondérés | 14 |
| 0xB1A960 | Résolution des identifiants d’actions et liste chaînée de l’événement | 85 |

Les 368 instructions sont recoupées par Capstone dans les octets du PE ; 11 références sont conservées, avec validation des cibles des CALL/JMP directs. Session REA fermée proprement, sans erreur d’outil ; empreintes avant/après identiques. Ce décompilateur ne reconstitue pas à lui seul le jeu complet.

## Exécutions natives isolées

Le constructeur et l’initialisation audio, six banques, l’objet2000001, PostEvent706850, sa publication AEB000, les workers de mixage, les décodeurs puis l’arrêt705080 et la destruction704C30 exécutent les instructions originales dans Unicorn. Allocateurs, pools, TLS, verrous, horloge, COM et transport des threads/événements sont fournis par le harnais. Aucun processus du jeu original, émetteur de jeu ordinaire ou matériel audio n’est exécuté. Les blocs atteints sont recoupés avec le PE. Ni les décisions aléatoires ni les gains natifs ne sont forcés.

| Profil | Résultat observé | Frames | Premier signal | Échantillons PCM comparés |
| --- | --- | ---: | ---: | ---: |
| bigchains, graine initiale1700000000 | 2 voix | 56 | 54 | 113664 |
| bigchainsbase, même graine | 2 voix | 36 | 34 | 75776 |
| brazierchain, même graine | 2 refus probabilistes, aucune voix | 8 | absent | 0 |
| brazierchain, horloge déclarée epoch0 | 2 voix | 2 | 0 | 16384 |

La seconde horloge est un contexte d’essai explicite, pas une affirmation sur l’horloge historique. Le code original initialise lui-même sa graine à partir du service d’horloge fourni. Un playing_id égal à1 peut être retourné sans aucune voix après refus probabiliste.

| Événement | Action | Graine à la porte | Son / média choisi |
| --- | ---: | ---: | --- |
| bigchains3282059833 | 1039678573 | 1700000000 | 567219536 / 400899600 |
| bigchains3282059833 | 650629985 | 4012821443 | 566280987 / 800678156 |
| bigchainsbase2293336866 | 576555959 | 1700000000 | 91624717 / 400899600 |
| bigchainsbase2293336866 | 242485587 | 4012821443 | 609493361 / 51118002 |
| brazierchain1392698701 | 1049381235 | 1700000000 | refus, probabilité50% |
| brazierchain1392698701 | 415219389 | 67307386 | refus, probabilité25% |
| brazierchain1392698701 epoch0 | 1049381235 | 0 | 407149979 / 931355143 |
| brazierchain1392698701 epoch0 | 415219389 | 3539360597 | 900501484 / 556739449 |

Total : 8 actions, 6 voix, 205824 échantillons comparés à cinq WAV distincts, erreur PCM16 maximale1. Cela vérifie les échantillons décodés avant mixage ; les buffers de sortie mixés sont conservés et leur intégrité vérifiée, sans qualification de toute la mathématique du mixage. Les quatre profils réussis libèrent leurs 7570 allocations suivies : 0 restante. Le premier profil court échoué est exclu de ce bilan. Chaque arrêt réussi ferme21 handles simulés et termine3 workers.

## Échecs et corrections du dispositif de mesure

Le premier essai bigchains observait seulement3 frames et n’obtenait pas encore de signal non nul. Son assertion échoue avant l’arrêt, avec deux voix créées. L’échec et ses octets restent conservés. L’extension à80 frames maximum, arrêt une frame après le premier signal, permet d’observer le signal en frame54 ; elle ne modifie pas le code natif.

Quatre indications passives de propriétaire de voix étaient inversées dans les deux premiers profils à deux voix : le collecteur utilisait sa dernière voix globale. Les données brutes sont conservées. Les relations retenues se fondent sur parent+8 → décodeur et décodeur+12 → voix, recoupées avec les objets et les instructions originales de0xB0CEB0. Les anciens indices et captures globales ne sont pas promus en preuve de propriété. Le profil epoch0 corrige seulement ce collecteur passif, à l’entréeB15BC0 appelée parB0CEE8, avec EBX comme voix.

Un premier vérificateur supposait aussi un tableau de pointeurs dans le préfixe de24 octets de l’événement. REA établit une liste chaînée. La version corrigée contrôle le contenu HIRC intégral, le premier pointeur et les deux récepteurs natifs des portes dans l’ordre ; elle ne prétend pas disposer d’une capture du second pointeur. Le vérificateur initial est conservé.

Cinq preuves altérées sont refusées : propriétaire du décodeur absent, média de la factory substitué, seconde porte effacée, empreinte des échantillons altérée et fausse affirmation d’exécution de l’émetteur de jeu. Ce sont des refus de preuves, distincts des refus natifs et des refus Rust.

## Consommateurs Rust réellement exécutés

Ajout de crates/core/tests/audio_environment_contract_observation.rs. Le code de production reste inchangé. NativeSelector::action, NativeRandom::probability et Dispatcher::post_immediate_event exécutent les quatre cas comparés aux traces natives ; l’ordre des deux actions, leurs résultats et les états RNG sont vérifiés. Deux nouvelles ancres identifient la sélection et la probabilité, avec périmètre limité. Toutes les anciennes ancres sont conservées.

Commande : cargo test --locked --offline -p openleague-core --test audio_environment_contract_observation -- --nocapture.

Résultat : code0, 2 tests réussis, 0 échec ; quatre observations comparées. Le second test vérifie le refus local d’un événement et d’une action inconnus, sans changer la graine17 ni la file. Ces refus ne sont pas attribués à l’exécutable historique. Les24 avertissements Rust existants restent dans le journal. Le reçu identifie le compilateur, le binaire de test et les sources vérifiées avant/après. Aucun test de lecture sur un périphérique audio n’est revendiqué.

## Intégration et conservation

Deux fiches (SYS-01.2-02 et SYS-02.2-07) sont enrichies, via trois registres et les bases du projet/de l’application. Les anciens liens, états manuels, cases, notes, historiques et prérequis sont conservés. Aucun statut d’implémentation ou d’acceptation n’est promu ; le registre des inconnues reste inchangé. Deltas ciblés réversibles, sans copie intégrale supplémentaire des bases. Les documents de couverture/reprise et REA_WORKFLOW sont mis à jour.

Preuves dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :

- revision789_event_bigchains_extended/OBSERVATIONS.json et revision789_event_bigchainsbase_extended/OBSERVATIONS.json.
- revision789_event_brazierchain_extended/OBSERVATIONS.json et revision789_event_brazierchain_epoch0/OBSERVATIONS.json.
- revision789_event_bigchains/FAILED.json, revision789_observation_window_extension.json et revision789_epoch0_context.json : essai échoué et changements de mesure.
- revision789_rea_environment_events/observations/1d32cf78-55b3-4672-a50c-07a4dccd224a/receipt.json : session REA terminée.
- revision789_current_environment/RECEIPT.json et ses journaux : vrais tests Rust.
- revision789_associations/OBSERVATIONS.json : liens, empreintes, résultats et limites.
- revision789_delivery/ : publication, deltas et relecture indépendante.

Livrable lié au registre : docs/fidelity_rea_environment_events_v789.json.

## Limites et suite

Continuer SYS-01.2-02 sur F avec REA : relier les consommateurs partiels sans promouvoir leur périmètre. Après V789, examiner le parent audio7067B0, ses branches bound/unbound706850/706910 et704A00, puis les autres limites encore ouvertes (callback4, streaming/IO, pool19, émetteurs du jeu, backend audio Rust, concurrence). Les cinq exigences Battle Training sans source native ni base locale explicite restent ouvertes faute de nouvelle entrée historique ; les recherches V462/V463/V464/V506 ne doivent pas être répétées sans source nouvelle. Conserver cases, notes, historiques, preuves et autres associations V784/V786/V788.
