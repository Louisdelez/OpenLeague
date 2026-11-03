# SYS-01.2-02 — Initialisation ADB et callbacks natifs, V776

Projet F:/OpenLeague. Référence LoL PUBLIC4.20.0.315, EUW/en_GB. Date locale30octobre2026. Tâches SYS-01.2-02 et SYS-02.2-07 enrichies ; leur achèvement global reste ouvert.

## Contrat et résultat

Le caller704E60 place ADB130 et ADB260 entre AEA510 et7062A0. Ce lot exécute cette étape dans le banc natif qui charge déjà les six banques originales et leurs doublons, puis31préfixes ambiants. Les requêtes sont exécutées par les instructions x86 originales en environnement Unicorn. Les services mémoire, Windows, COM, temps et transports de threads restent des adaptateurs déclarés.

ADB130 écrit les bits3F800000 (float1.0), sans toucher les quatre octets sentinelles suivants. ADB260 alloue un propriétaire de1octet dans le pool17, appelle ADB1D0, puis enregistre ADB3C0 dans un tableau et ADB9F0/ADE700 dans deux emplacements globaux. ADB1D0 copie le réglage ou utilise1.0 si le pointeur est nul, crée un événement et initialise ses compteurs. Les adresses des instructions qui publient ces champs sont conservées et recoupées avec le PE.

Le nom fonctionnel du sous-système ADB reste prudent : ces résultats établissent des comportements et des liens d'appels, pas une attribution inventée à un module complet.

| Vérification | Attendu et observé |
| --- | --- |
| Initialisation ADB | Retour1, propriétaire publié, événement4406, trois callbacks enregistrés |
| Callback de frame | ADB3C0 exécuté815fois ; liste active vide dans tous ces appels |
| Deux autres callbacks | Enregistrés, aucun appel ADB9F0/ADE700 dans ce parcours |
| Banques | Six originales,12admissions incluant les doublons ; workers banque et mix exécutés puis arrêtés |
| Sorties | 784sorties mixées et713buffers décodés, identiques bit à bit à V775 et V773 |
| Comparaison WAV | 31WAV,730112échantillons PCM16, écart maximal1 |
| Blocs natifs | 5254 blocs exécutés comparés aux octets du PE |
| Allocations | 3857 créations,2197 libérations,1660restantes |
| Contrôles du parcours média | Six limites héritées rejouées ; dix profils ADB supplémentaires |
| Falsifications |18altérations de preuves rejetées |

La liste de callbacks grandit pendant les médias : le callback existant B3ED30 rejoint ADB3C0. Le tableau final contient deux pointeurs, dans une allocation de8octets. Par rapport à V775, l'histogramme des allocations restantes ajoute un propriétaire de1octet et un tableau de8octets, et retire un tableau de4octets. Ce rapprochement agrégé ne prouve pas l'identité de chaque allocation. L'événement ADB et les propriétaires globaux restent vivants : aucun teardown global n'est revendiqué.

## Dix profils de limites

- Réglages par défaut et pointeur nul : retour1 et bits1.0.
- Réglages0,2.0 et bitsNaN : copiés tels quels, retour1. Ce test ne qualifie pas leur utilisation ultérieure.
- Échec d'allocation du propriétaire : retour2, pas de propriétaire, événement ni callback.
- Échec d'allocation du tableau : retour1 malgré l'absence de ADB3C0 ; propriétaire, événement et deux autres callbacks conservés. Le banc ne transforme pas ce comportement natif en refus inventé.
- Échec de CreateEvent via le parent : retour2, ADB090 exécuté et propriétaire libéré ; pas de fuite d'allocation mesurée dans ce profil. Les effets sur la file native sont conservés dans les événements.
- Deuxième initialisation : retour1, propriétaire/événement réutilisés, nouveau réglage ignoré et ADB3C0 ajouté une deuxième fois.
- Échec de CreateEvent par appel direct à ADB1D0 : retour2.

## Corrections du banc et preuves conservées

Le premier essai de composition s'arrêtait sur une ancienne assertion exigeant une liste de callbacks vide. L'assertion a été remplacée par les callbacks réellement publiés ; le reçu d'échec est conservé. Un premier script des limites avait un problème d'échappement d'un littéral d'octets ; les dix profils ont été rejoués après correction et la tentative invalide reste séparée.

5642D0 avait auparavant été interceptée comme service fourni. La lecture du PE montre que son corps est un simple RET (C3). La composition finale et les profils de limites exécutent cette instruction sans interception. Il ne faut plus décrire cette adresse comme un constructeur de verrou. Le premier audit d'association a également détecté un écart entre clés entières en mémoire et clés textuelles JSON pour les décomptes de statuts. Les clés JSON sont désormais explicites, sans changement des observations natives ; l'échec est conservé. Un passage intermédiaire avec l'ancien adaptateur est conservé séparément ; le reçu final utilisé est revision776_adb_media_native/OBSERVATIONS.json.

## REA

REA6.4.0 avec SDK2.3.1, Ghidra12.1.4 et Java21 : 13 fonctions,531 instructions,39 références. Le binaire de référence est importé dans une copie d'analyse, jamais modifié. Session exportée et fermée ; intégrité avant/après et octets des fonctions recoupés.

Fonctions ciblées :704590,704700,B37F20,B37A40,B37FD0,B3A850,B3B6F0,ADB1D0,ADB090,ADB3C0,ADB9F0,ADE700,5C7740. 704700 publie le pointeur du wrapper via B38150 avant de créer le périphérique. Les constructeurs B3A850/B3B6F0 installent les vtables FF3400/FF350C ; les entrées+10 donnent B3B2E0/B3C6A0 et+14 B389D0/B3C230. La lecture des octets de5C7740 montre une allocation28octets, trois liens vers le même objet et le mot0101 à+0C ; son rôle applicatif reste à qualifier. Les fonctions IO sont des preuves statiques pour la prochaine composition. Leurs corps et appels ne prouvent pas une exécution du wrapper entier. L'import global a émis des diagnostics sur d'autres adresses ; la validation porte séparément sur les fonctions ciblées et leurs octets. Les fichiers temporaires du fournisseur sont nettoyés à la fermeture.

## Consommateurs et couverture

Quatre ancres déjà recensées dans audio_bank_command_worker.rs et audio_bank_command_queue.rs sont relues. Les42liens sources sont vérifiés : PE et six banques,31WAV, manifeste et trois fichiers Rust. Sept sources natives forment les relations supplémentaires de cette association. Les ancres Rust couvrent le worker et la file en aval ; elles ne deviennent pas une implémentation de l'initialisation ADB par cette preuve. Une recherche textuelle bornée des adresses ADB/IO dans crates ne trouve pas de correspondance ; ce résultat ne démontre pas une absence globale d'implémentation.

Aucun code produit, asset, test Rust ou build modifié/exécuté dans ce lot. Pas de client Windows ordinaire lancé, pas de sortie audio physique, pas de threads Windows ni TLS distinct. Positions/identifiants et temps sont des entrées de test explicites. Les31préfixes s'arrêtent après le premier signal plus une frame, avec borne80 ; ils ne qualifient ni clips entiers, ni autres médias/locales, ni streaming/seek/boucles. Les listes actives non vides et événements applicatifs restent ouverts.

## Livrables

- docs/FIDELITY_REA_AUDIO_ADB_V776.md et docs/fidelity_rea_audio_adb_v776.json.
- Registres docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json.
- Documents coverage.json, completion_plan.json, resume_checkpoint.json, ai/CURRENT.md, ai/HANDOFF.md, ai/DECISIONS.md et REA_WORKFLOW.md.
- Deux fiches des bases du projet et du bureau : preuves/instructions actualisées ; cases, notes, historique et autres tâches préservés.

Preuves sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision776_adb_media_native/OBSERVATIONS.json, revision776_adb_boundaries_checked/OBSERVATIONS.json, revision776_media_validation/OBSERVATIONS.json, revision776_media_associations_final/OBSERVATIONS.json et revision776_delivery. Session REA : revision776_rea_startup_dependencies/observations/c0c21378-64f7-4b11-a0a3-8b750b3beb95/receipt.json.

Binaire original : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe. SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

## Suite

Continuer SYS-01.2-02 sur F avec REA. V776 qualifie ADB130/ADB260/ADB1D0 avant les plugins et les callbacks de frame à liste vide. Prochaine étape : composer le wrapper IO704590/704700 et B37A40 avec les réglages B37F20, qualifier ses constructeurs B3A850/B3B6F0 puis les initialisateurs virtuels B3B2E0/B3C6A0 et leurs nettoyages B389D0/B3C230, puis le caller704E60 avec configuration706A20 effective et le teardown global. Les fonctions IO sont analysées statiquement en V776, pas exécutées dans la composition. Ne pas inventer la fonction de5C7740, ni les événements ADB9F0/ADE700 non exercés. Retrouver ou relier le consommateur Rust ordinaire. Garder ouverts les listes actives non vides, allocateurs physiques, TLS distinct, threads et périphérique réels, événements applicatifs, autres médias/locales, clips complets, streaming/seek/boucles et commandes1..11. Préserver preuves, cases, notes et historiques ; deltas ciblés sur F.
