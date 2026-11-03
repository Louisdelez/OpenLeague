# SYS-01.2-02 — Initialisation des composants audio, V772

Projet : F:/OpenLeague. Référence : LoL PUBLIC 4.20.0.315, EUW/en_GB. Fiches : SYS-01.2-02 et SYS-02.2-07. Leurs objectifs complets restent ouverts.

## Résultat attendu et observé

Remplacer la préparation manuelle des composants de la sonde par leur parent natif AEA9D0, vérifier ses publications et ses refus, puis relier ces contrats aux consommateurs Rust existants. Aucun code produit ni asset n’est modifié. Aucun nouveau binaire Rust ou client historique n’est exécuté.

AEA9D0 alloue, construit, initialise et publie les dix objets suivants. Les fonctions enfants sont exécutées dans une mémoire x86 isolée ; les services physiques sont explicitement adaptés.

| Global publié | Taille de l’objet | Constructeur / initialisation |
| --- | ---: | --- |
| 14A7A08 | 8800 | AE9D50 / AF64A0 |
| 14A7A3C | 2388 | B10320 / B115C0 |
| 14A7A38 | 52 | AE9E30 / B148A0 |
| 14A79C4 | 1228 | AF8960 / AF9740 |
| 14A7A2C | 192 | AE9E90 / AF49B0 |
| 14A7A18 | 48 | AE9EC0 / B14AF0 |
| 14A7A04 | 808 | B09760 / B09A90 |
| 14A7A24 | 28 | AF5450 / AF5950 |
| 14A7A40 | 16 | 7B4190 / B140C0 |
| 14A7A34 | 108 | AF66C0 / AF6B80 |

AF49B0 publie en plus le registre de callbacks à 14A7A30, dans l’objet de 192 octets à l’offset 0x9C. Le parcours final conserve cette publication native. L’initialisation seule effectue 22 allocations et initialise 18 sections critiques. Le parent copie 56 octets de paramètres vers la sortie lorsqu’elle est fournie ; les octets sentinelles suivants restent intacts. Les paramètres proviennent ici des zéros de l’image, avec variantes scalaires explicitement déclarées dans les essais de limites. Le producteur historique de ces paramètres n’est pas encore qualifié.

## Composition avec les médias

Les deux allocations initiales d’enregistrement des plugins sont capturées dans une phase séparée, avant les 22 allocations des composants. Les banques originales sont ensuite chargées, puis AEA640 crée le contexte commun et le worker de mixage comme à l’étape précédente.

| Vérification | Attendu et observé |
| --- | --- |
| Médias | 31 préfixes résidents, chacun produit un signal |
| Sorties actives | 784, toutes identiques bit à bit à V771 |
| Décodage | 713 buffers identiques à V771 ; 730112 échantillons PCM16 |
| Comparaison aux WAV | 31 fichiers identifiés ; écart maximal de 1 unité PCM16 |
| Ordonnancement | 846 suspensions coopératives, dont 31 quotas nuls ; 815 frames traitées |
| Horloge | Avance fournie de 21 ms par frame ; attente native demandée de 10 ms |
| Mixage | 62 frames actives non nulles ; 722 silencieuses |
| Intégrité native | 5023 blocs du parcours comparés aux octets du PE |
| Allocations du parcours | 3850 allocations, 2193 libérations, 1657 restantes |
| Contrôle des preuves | 16 falsifications rejetées |

Les 124 fichiers float32 et 75 fichiers PCM16 non nuls retenus sont vérifiés par empreinte. Il s’agit de préfixes bornés, pas de la lecture intégrale de chaque clip. Aucune borne de 80 frames n’est atteinte ; le maximum est 76.

## Un second worker et ses limites

AF9740 appelle AFC790 puis AF8B90 pour demander le thread AF8C80, nommé AK::BankManager. Son argument est le manager de banques. Le transport CreateThread est différé : le corps de ce worker n’est pas exécuté. Son handle 0x4472 reste vivant. Le second thread demandé est B20D10, AK::EventManager ; son corps s’exécute sur une pile émulée distincte et son arrêt, signal, attente et fermeture sont vérifiés. Les cinq créations d’événements reçoivent des handles distincts.

Aucun thread Windows physique ni parallélisme réel n’est revendiqué. Les deux usages de CreateThread ne sont pas confondus avec le bridge CRT actuel, et l’exception de nommage est consommée par un adaptateur. Le TLS CRT reste partagé dans ce banc.

## Refus et initialisations partielles

Les 59 profils couvrent les 22 positions d’allocation avec remplissages 00 et A5, trois refus d’événement, les refus de thread/priorité/affinité, le signal refusé, la fréquence, une sortie nulle, des capacités explicites, un ancien handle et les appels répétés. Les blocs natifs de ces profils sont vérifiés sur le PE : 350 blocs.

Résultats du premier appel : 39 retours 52, 5 retours 2 et 15 retours 1. Ces valeurs décrivent le comportement observé, pas une qualification globale.

- Six profils de refus d’allocation retournent tout de même 1 : échec de l’objet par défaut, de son nœud ou de ses positions, chacun testé avec deux remplissages. B09A90 conserve son résultat d’initialisation principal ; l’objet par défaut peut manquer ou rester sans stockage de position.
- Le premier refus CreateEvent, dans l’initialisation de la banque, n’est pas propagé jusqu’au résultat global. Les deuxième et troisième refus produisent 2.
- Le résultat de SetEvent n’est pas propagé. Le résultat booléen de QueryPerformanceFrequency n’est pas testé ; le profil de refus fournit explicitement zéro à la sortie. Cela ne détermine pas le contenu réel de cette sortie lors d’un échec Windows.
- Après le refus du pool RTPC de 192 octets, le global du manager reste publié. Un second appel saute sa construction et son initialisation, retourne 1 et laisse le pool absent. La réussite de la relance ne répare donc pas cet état dans le profil testé.
- Deux répétitions après initialisation nominale ne réallouent rien. Les tailles de capacité 7 et 5 sont également exercées, en plus du repli natif 255.
- AF8960 remet le global du thread de banques à zéro lors de sa construction ; le profil avec un ancien handle ne prouve pas la fermeture de cet ancien thread.

Aucune récupération transactionnelle ni fermeture globale n’est déduite de ces essais.

## Consommateurs Rust actuels

Quatre ancres exactes sont ajoutées dans deux sources existantes, dont les empreintes étaient déjà enregistrées :

- `audio_init_rtpc_owner::FreshInitializationOwner::create` : propriétaire des objets 8800/2388 et du pool 192, avec services fournis.
- `audio_init_rtpc_owner::Failure::reclaim` : nettoyage local explicite des allocations non publiées et verrous. Ce contrat ne représente pas le comportement natif de conservation des globals partiels.
- `audio_action_registry_initialization::construct` : constructeur AF66C0 de 108 octets.
- `audio_action_registry_initialization::initialize` : pools AF6B80 de 96 et 128 octets et conservation de l’état partiel en cas d’échec.

Les implémentations existantes sont conservées. Leur présence et ces liens de source ne qualifient pas le démarrage ordinaire du jeu Rust. Aucun test Rust nouveau n’est annoncé ; les preuves antérieures restent datées et distinctes.

## REA et identité

REA 6.4.0, SDK 2.3.1, Ghidra 12.1.4 et Java 21 : 21 fonctions, 813 instructions et 27 références. Session exportée et fermée sans erreur ; les adresses et les octets sont contrôlés indépendamment avec le PE.

Binaire : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe`.
SHA256 : `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

## Corrections du banc conservées

Les premiers essais ont révélé des limites de capture : adaptateur réservé au thread de mixage, signal limité à un seul événement, double branchement du compteur de temps et omission des deux allocations de plugins avant la phase d’initialisation. Chaque essai et chaque correction sont conservés séparément. Le parcours final capture les allocations et conserve le registre de callbacks natif. Aucun octet du PE n’est modifié.

Deux préparations de l’audit sont aussi conservées : comparaison de clés numériques devenues chaînes en JSON, puis contrôle REA encore fixé aux 12 fonctions de la révision précédente. Le contrôle final exige bien 21 fonctions et conserve les vérifications de sources, instructions et références.

## Fichiers et preuves

Dossier de preuves : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20`.

- `revision772_rea_audio_managers/observations/d028042f-1bcd-4c74-b6fd-d29cf82bac06/receipt.json` : session REA.
- `revision772_managers_events/OBSERVATIONS.json` : parent nominal isolé.
- `revision772_managers_boundaries/OBSERVATIONS.json` : 59 profils de limites.
- `revision772_managers_media_complete/OBSERVATIONS.json` : parcours final des 31 médias.
- `revision772_managers_validation_complete/OBSERVATIONS.json` : validation des états, sources, sorties et limites.
- `revision772_managers_associations_full/OBSERVATIONS.json` : liens Rust et 16 falsifications.
- `revision772_delivery/VERIFIED.json`, `INDEPENDENT_READBACK.json`, `FINAL_VERIFIED.json` : intégration et relecture.

Le reçu structuré `docs/fidelity_rea_audio_managers_v772.json` relie aussi les essais intermédiaires et les échecs conservés. Les registres sources/exigences/tâches, documents de couverture/reprise et deux bases locales sont enrichis par deltas ciblés. Les autres tâches, cases, notes, historiques, prérequis et inconnues sont conservés.

## Suite

Qualifier AEA510, la production des paramètres, le pool et le stream manager, puis le corps AF8C80 du worker de banques. Les producteurs Rust ordinaires, le TLS distinct, les attentes et transports Windows, l’audio physique, les autres médias/locales, le streaming, le seek, les boucles, la concurrence et le teardown global restent ouverts. Ni ces deux tâches ni le jeu entier ne sont déclarés terminés.
