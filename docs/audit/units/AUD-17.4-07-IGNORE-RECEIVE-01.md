# AUD-17.4-07-IGNORE-RECEIVE-01 — Filtre d’émetteur ignoré dans la présentation native

Date : 2026-10-30. Projet : F:\OpenLeague. Goal parent : SYS-01.2-02. Tâches existantes : SYS-17.4-07, SYS-17.2-08 et SYS-17.2-09.

## 1. Question précise, critères et décision limitée

Question issue du lot ignore : où une lecture de la collection d’ignorance empêche-t-elle la présentation du message et peut-on observer la bascule avant/après ajout et retrait avec les octets originaux ?

Critères du lot : identifier la porte native et les cibles de saut ; relier ses wrappers et leur enregistrement ; observer les chemins nominaux/refus et transitions locales en émulation ; conserver les consommateurs et preuves existants ; nommer les frontières réseau, UI et cycle de vie ; vérifier les sept rubriques et la conservation. Ces critères propres au lot ne changent pas les critères normatifs du goal ou du plan.

| Dimension | Décision |
|---|---|
| Audit | Terminé pour ce filtre de présentation, ses appels et ses transitions locales documentés, après relecture de livraison. |
| Implémentation | Aucun code produit modifié. Pas de filtre de chat local identifié dans les interfaces/corpus conservés. |
| Vérification | 147contrôles réussis ;11exécutions du fragment de filtrage et3mutations de collection d’origine. Aucun pipeline complet exécuté. |
| Acceptation humaine | Non demandée ; aucune fonctionnalité ou partie acceptée implicitement. |

Le nom du lot « receive » désigne la piste de réception recherchée, pas une qualification de tout le réseau. L’origine réseau exacte des événements, l’authentification de l’émetteur, les messages privés XMPP, l’affichage effectif et le cycle de vie restent hors périmètre et ouverts en §5. Le filtre trouvé intervient dans la présentation, après une préparation du texte ; il ne démontre pas un blocage du transport ou de tous les traitements du message.

Un seul lot actif. Arrêt aux méthodes virtuelles du service émettant les callbacks et à l’entrée du chat HUD ; pas de nouvel import complet du client ou de recherche générale sans piste nouvelle. Les anciens tests de collection ne sont pas simplement rejoués : la question nouvelle est leur effet observable sur la porte native.

## 2. Sources, identités et preuves héritées

Référence : LoL4.20.0.315, EUW, en_GB. Le processus du jeu original n’est pas lancé.

`D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`

15 973 880octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; ImageBase0x400000. Les adresses sont les VA de ce fichier.

| Source sélectionnée | Intervalle, fin exclusive | Portée qualifiée |
|---|---|---|
| Fonction partagée de présentation | 7AA4B0–7AAD45 | Décodage529instructions ; porte et sauts, appels de sortie et épilogue. Les providers et chaque mécanisme de formatage ne sont pas intégralement qualifiés. |
| Premier wrapper de callback | 7A9FD0–7AA015 | Appel vers7AA4B0,30instructions. |
| Second callback | 7AA020–7AA464 | Décodage286instructions ; seule sa frontière d’appel vers la présentation est qualifiée ici. |
| Wrapper d’arguments explicites | 7AA470–7AA4A3 | Appel vers7AA4B0,21instructions. |
| Caller de texte/statut local | 7AAD50–7AAE63 |87instructions ; seul son chemin d’appel sélectionné est qualifié. |
| Préfixe de constructeur | 7A9180–7A92FA |96instructions ; initialisation et demandes d’enregistrement. Fragment explicite, pas constructeur entier qualifié. |
| Forwarder du HUD | 8287F0–828816 |13instructions ; objet chat+0x110 vers7ACF10. |

Total :7intervalles et1 062instructions, dont un préfixe de fonction. Les instructions, octets et SHA-256 de chacun sont dans le reçu. Les six autres intervalles se terminent par RET ; aucune conclusion de fin de fonction n’est attribuée au préfixe.

Preuves réutilisées :

- [Lot ignore](F:/OpenLeague/docs/audit/units/AUD-17.4-07-IGNORE-01.md) et [reçu](F:/OpenLeague-work/audit-units/AUD-17.4-07-IGNORE-01/ignore-proof.json), SHA-256 `21f90ad5ef2f81d9e3164547a87dddad9ec492af7cc4e6fb4fd6357cb576754a` : collection, commande, adaptateur social et frontière HUD. Empreintes des routines natives7AAE70/7AAEB0/7AAF00/7AB020/849D40/5CCD60 recontrôlées ; pas de nouveau test exhaustif identique de ces routines.
- [Audit chat initial](F:/OpenLeague-work/audit-units/AUD-17.2-08-CHAT-01/chat-contract-proof.json), SHA-256 `b37673bddaf069bcbcef483c419db9ecd7186d11104a4e847923a430dc8c8906` : fiches parentes, widgets et historique AS2 borné. Cette preuve ne devient pas une nouvelle exécution des films.
- Corpus de consommateurs et fragments d’interfaces du lot ignore : liste et SHA-256 conservés, voir §3. Aucun nouveau balayage lexical inchangé.

La recherche des références est bornée aux octets des sections exécutables du PE et aux appels directs relatifs E8. Les candidats vers7AAE70 sont7AA68D et7AB0A8 ; vers7AA4B0 :7AA00A,7AA3B1,7AA49A. Chaque site est validé comme instruction CALL à l’intérieur d’un intervalle décodé connu, et non accepté sur le seul motif binaire. Sections, tailles et empreintes de la recherche sont enregistrées. Les appels indirects, l’inlining et autres chemins ne sont pas exclus par cette recherche.

Outils déjà présents identifiés : Python, pefile2024.8.26, Capstone5.0.7, Unicorn2.1.4 et leurs DLL. Aucun logiciel installé ni nouveau binaire d’analyse écrit ; le PE est uniquement lu/mappé en mémoire. REA/Ghidra, extraction de films et anciens tests inchangés ne sont pas relancés.

## 3. Consommateurs réels et contrat de la porte native

### Installation des callbacks et appels partagés

Le préfixe0x7A9180 initialise la collection aux offsets+0x0C/+0x10/+0x14 à0 et le mot+0x20 à1, donc l’octet+0x20 non nul. Il construit ensuite deux objets portant le contexte aux offsets+4 et leur cible+8 :0x7A9FD0 et0x7AA020. Il les passe aux méthodes virtuelles+0x6C/+0x70 du service global0x2D787B8. Le chemin normal d’allocation et l’initialisation du service sont des préconditions, pas une activation runtime observée.

Ces deux callbacks appellent la fonction partagée0x7AA4B0, directement ou via leurs arguments construits. Le wrapper0x7AA470 l’appelle aussi ; il est utilisé par un chemin local/statut0x7AAD50. Ce partage montre qu’on ne peut pas assimiler toute invocation à un paquet réseau de joueur. L’identité exacte du service, la source événementielle et le framing des paquets ne sont pas établis ici.

### Filtre : état actif, texte préparé et appartenance

La fonction0x7AA4B0 effectue d’abord des traitements et une préparation du texte. La porte retenue commence à0x7AA641, sur des frontières d’instruction vérifiées :

1. Lire le gestionnaire via la locale de pile ESP+0x20. Si l’octet gestionnaire+0x20 vaut0, sauter à0x7AACDC.
2. Si la longueur de la chaîne déjà préparée à ESP+0xE8 vaut0, sauter aussi à0x7AACDC.
3. Passer le premier argument de la fonction, EBP+8, à0x7AAE70 sur ce même gestionnaire. C’est la valeur opaque32bits comparée aux entrées de sa collection.
4. Si AL vaut1,0x7AA694 saute à0x7AACD0, début du nettoyage ; sinon continuer à0x7AA69A.

Cette comparaison lie précisément la collection modifiée par les helpers d’ignore au filtre. La correspondance entre cette valeur, un joueur réseau et un compte authentifié dépend toujours des producteurs et de l’événement amont.

### Ce que le saut contourne réellement

À partir de0x7AACD0, la fonction ne revient pas au corps de construction. Elle contourne notamment la traduction/assemblage suivant la porte, l’appel0x7AB2C0, les sorties0x6F75C0/0x6F78A0 sélectionnées et l’appel0x8287F0 en0x7AAC9B.

0x8287F0 charge le HUD global, son objet chat+0x110 et, si cet objet existe, appelle0x7ACF10 avec texte et flags. Cette frontière chat HUD est établie ; le corps complet de7ACF10, ses buffers, horodatage et rendu ne sont pas qualifiés ici. Les flags ne sont pas traduits automatiquement en permissions serveur. Le littéral All présent dans le formatage ne prouve pas à lui seul tous les canaux et droits historiques.

L’épilogue de0x7AA4B0 met AL à1, y compris après les chemins désactivé, texte vide ou émetteur ignoré. Il s’agit d’un retour « traité », pas d’un accusé d’affichage ou de livraison. Le filtre ne supprime pas la préparation déjà effectuée avant lui et ne démontre pas l’absence de tout log ou de toute autre voie de présentation.

### Consommateurs actuels inspectés et conservés

Aucun changement depuis les preuves précédentes :1 168fichiers de `crates/*/src` en Rust, `launcher/src-tauri/src` en Rust et `launcher/web` en JS/HTML ; liste et empreintes revalidées. Aucun nouveau symbole n’exigeait de refaire leurs recherches identiques.

Le constat borné est donc réutilisé : aucun consommateur local nommé de chat ignore/mute dans ce corpus ; pas de commande ou livraison de chat identifiée dans Action/ClientPacket/ServerPacket de `crates/core/src/lib.rs`, Input/ClientMessage/ServerMessage de `crates/core/src/session_transport.rs`, ni dans le bridge réel `launcher/src-tauri/src/main.rs:72`. Les fragments et résultats du lot antérieur sont reliés au reçu.

Cela ne prouve pas l’absence dans tout outil, dépendance, asset généré ou service externe. Les mécanismes de session et de transport présents ne sont pas remplacés et ne sont pas déclarés manquants.

## 4. Contrôles exécutés, résultats attendus et observés

Exécution finale : `verify_ignore_receive.py`, du 2026-10-30T16:23:47Z au16:23:50Z, code0 ;147/147 contrôles réussis.

Une première tentative du nouveau script avait une erreur de syntaxe Python : le mot réservé continue était utilisé comme nom d’argument de dictionnaire. Arrêt au parsing avant tout audit ou reçu ; correction limitée à ce script, mention conservée dans le reçu. Ce n’est pas une anomalie du client ou du jeu, et cette tentative n’est pas annoncée comme un test réussi.

Méthode : émulation du fragment original0x7AA641, avec ESP/EBP, champs de contexte, vecteur et longueur préparée fournis explicitement. Aucun patch de code ni stub de callee. Les instructions du PE et le vrai helper d’appartenance sont exécutés. Le harness s’arrête AVANT l’instruction de continuation ou de nettoyage aux labels0x7AA69A/0x7AACD0/0x7AACDC. Il n’exécute ni le prologue/prétraitement ni le reste du formateur et n’invente pas les objets nécessitant une destruction complète.

Les mutations utilisent les routines natives7AAEB0/7AAF00 et leurs callees sur un vecteur réservé de16entrées. Valeurs opaques de fixture, pas comptes/émetteurs authentifiés. Toutes écritures bornées aux fixtures et à la pile ; aucune écriture de l’image native ou appel OS. Limites100000instructions et2secondes par invocation. La relecture compare chaque instruction observée aux octets du PE original.

| Cas de porte originale | Attendu | Observé |
|---|---|---|
| Liste vide, octet actif1, longueur5 | Continuer la présentation | 7AA69A. |
| Émetteur42 dans la liste | Sauter le corps suivant | 7AACD0. |
| Autre valeur41 ignorée, émetteur42 | Continuer | 7AA69A. |
| Fixture adverse avec doublon42 | Sauter | 7AACD0 ; aucun doublon créé par ce test. |
| Octet actif0, émetteur pourtant ignoré | Saut désactivé avant le test d’appartenance | 7AACDC. |
| Longueur préparée0 | Saut texte vide avant appartenance | 7AACDC. |
| Octet actif2 | Non nul suffit, pas strictement égal à1 | 7AA69A. |

Transition liée, même collection conservée entre étapes :

| Étape | Attendu | Observé |
|---|---|---|
| Porte avant ajout | Continuer | 7AA69A. |
| Ajout natif42 | Retour1, collection[42] | Conforme. |
| Porte après ajout | Sauter | 7AACD0. |
| Ajout natif du doublon42 | Retour0, collection inchangée | Conforme. |
| Porte après refus du doublon | Toujours sauter | 7AACD0. |
| Retrait natif42 | Retour1, collection vide | Conforme. |
| Porte après retrait | Continuer de nouveau | 7AA69A. |

Total :11exécutions de porte et3mutations,14invocations. La pile et la conservation de la collection pendant chaque porte sont vérifiées. C’est une composition locale des routines originales, pas la commande complète avec résolution de nom ni un parcours réseau. Un passage à7AA69A ne prouve pas l’affichage : d’autres gardes et sorties existent ensuite.

Contrôles non exécutés : formateur complet, callbacks/service réels, événement réseau, décodage/authentification de paquet, messages privés XMPP, ActionScript, buffers HUD, processus LoL, simulation Rust ou tests/build, partie à plusieurs clients, rendu et acceptation humaine. Aucun résultat hérité n’est promu en nouvelle exécution.

## 5. Résolu, encore ouvert et reprise précise

Résolu par rapport au lot ignore : un consommateur effectif de la collection est identifié ; son saut contourne la présentation et l’entrée chat HUD de ce chemin ; les transitions ajout/refus du doublon/retrait changent la décision de cette porte originale. Les retours « traité » et les autres causes de saut sont séparés.

| Clause restant ouverte | Impact | Entrée nécessaire et condition de reprise |
|---|---|---|
| Service0x2D787B8 et événements des slots6C/70 | Origine réseau exacte et couverture des messages non prouvées | Implémentation des méthodes d’enregistrement/invocation, producteur des arguments et liaison avec le décodeur de messages, avec entrée connue/invalide explicitement identifiée. |
| Valeur d’émetteur EBP+8 | Absence de qualification d’identité/authentification | Producteurs du premier argument et résolution du provider, sentinelles, collisions et usurpation documentées. |
| Autres chemins et XMPP privé | Pas de garantie universelle de sourdine | Identifier leur réception propre et lecture de la liste adéquate ; ne pas inférer la suppression privée du filtre de présentation de partie. |
| Prétraitement, censure et options all-chat | Peut modifier ou supprimer le texte avant/après la porte | Question distincte sur les helpers et les champs/flags effectifs ; pas de répétition de la porte pour qualifier ces mécanismes. |
| Buffers/history et affichage final | Le saut d’un chemin ne qualifie pas toutes écritures d’historique | Producteur de buffer dans7ACF10 puis route native→film ; essais d’historique avant/après ignore et absence d’ajout par le chemin ignoré, avec source/montage réel. |
| Cycle de vie de la collection | L’initialisation vide ne prouve pas une remise à zéro à la reconnexion | Constructor/destructor et sites de réutilisation du gestionnaire ; nouvelle partie/reconnexion et état attendu observés. |
| Mise à jour différée du HUD | Toujours ouverte depuis le lot ignore | Consommateur de la file+0x6C de l’autre objet HUD ; ajout/retrait avant chargement puis état appliqué. |
| Produit local | Aucun filtre de chat privé/partie fonctionnel identifié | Services/input/HUD locaux reliés et identité explicite, puis tests à plusieurs clients ; exécution distincte de l’audit. |

Inconnues parentes conservées : SYS-17.4-07 → OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38 ; SYS-17.2-08 → OLU-5abd1f66-bc04-5d6c-a130-33387ecf2888 ; SYS-17.2-09 → OLU-83a927ae-fc5f-5c43-bb2a-cdeee4a6114b. Les tâches fonctionnelles et leurs autres clauses restent ouvertes, sans changement de registre.

Piste suivante terminable : suivre les producteurs de messages et la route7ACF10→buffer/HUD pour séparer réception, filtrage et conservation ; ou qualifier la file HUD différée à partir de son consommateur, dans un autre lot. Ces pistes sont nommées précisément ; aucune recherche générale ou nouvelle accumulation de liens sans question n’est requise.

## 6. Corrections réutilisées et petits livrables proposés

Pas de nouvelle exigence concurrente. Les références ci-dessous sont documentaires, sous les tâches existantes, sans insertion dans le plan ou modification de critères normatifs.

| Référence stable | Résultat précis restant à réaliser | Critères de fin futurs |
|---|---|---|
| SYS-17.4-07/I5-RECEIVE | Relier un filtre local au chemin réel de présentation des messages | Même émetteur et message : présenté avant ajout, aucune présentation sur le chemin filtré après ajout, présenté après retrait ; autre émetteur inchangé ; états désactivé/vide distingués ; identity/source de décision explicites. Le contrat natif de la porte est désormais prouvé, pas son implémentation locale. |
| SYS-17.4-07/I2-STATE | Définir l’identité et le cycle de vie de la collection locale | Ajout unique/retrait absent ; séparation partie/compte ; état attendu à la nouvelle partie et reprise, avec consommateurs réels. L’initialisation native seule ne clôture pas ce résultat. |
| SYS-17.4-07/I3-SERVICE | Relier service et états/permissions | Traitement local, tentative, ACK et refus distincts ; aucune audience ni identité librement choisie par le client. Les contrats des tâches sociales restent des prérequis. |
| SYS-17.4-07/I4-HUD | Afficher l’état muet via source et file différée qualifiées | Ligne chargée/absente, bascules avant chargement et état final observé ; ne pas déduire la règle de la seule file de noms. |
| SYS-17.2-09/H1-FILTERED-HISTORY | Qualifier l’historique réel face au filtre de présentation | Producteur et limites de buffer identifiés ; aucun ajout par la route filtrée ; autres entrées/systèmes recensés ; rendu/reprise et bornes vérifiés. Réutiliser les preuves AS2 de taille bornée, sans les substituer au buffer natif ou à la réception. |

Prérequis hérités : D17-SYS-17-4 requiert D09-SYS-09-4 ; D17-SYS-17-2 requiert D13-SYS-13-3. Les relations et fiches parentes sont conservées dans le reçu, pas déclarées réalisées. Aucun comportement serveur Riot n’est inventé et aucune correction de fonctionnalité n’est exécutée implicitement.

## 7. Livraison datée et conservation

Fichiers nouveaux uniquement :

- Présent rapport : `F:\OpenLeague\docs\audit\units\AUD-17.4-07-IGNORE-RECEIVE-01.md`.
- [verify_ignore_receive.py](F:/OpenLeague-work/audit-units/AUD-17.4-07-IGNORE-RECEIVE-01/verify_ignore_receive.py),17 415octets ; SHA-256 `6f5bbbaee56c003580e5d95b25d8bcf7b22614e83b1e374a329a919d5388562f`.
- [ignore-receive-proof.json](F:/OpenLeague-work/audit-units/AUD-17.4-07-IGNORE-RECEIVE-01/ignore-receive-proof.json),715 068octets ; SHA-256 `3a0c0ea2460a247ca899a16aef6e3da04eed9ec44dd71a34d00e24859e72a4f9`.
- Reçu de relecture finale : `F:\OpenLeague-work\audit-units\AUD-17.4-07-IGNORE-RECEIVE-01\delivery-readback.json`, créé après ce rapport. Le premier reçu conserve audit_scope_closed=false car il précède la livraison ; la décision limitée est portée par le reçu final sans écraser les premières preuves.

Conservation vérifiée :19fichiers logiciels gelés,6documents d’instructions/contexte/méthode,2registres JSON et le corpus1 168sources. Aucun ancien fichier ou reçu réécrit. Git : même HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, mêmes76fichiers suivis déjà modifiés ; aucun stage, commit, reset ou nettoyage.

Relecture : identités rapport/script/reçu, succès147contrôles,14invocations avec11portes, correspondance des octets exécutés au PE, cibles d’arrêt et des calls observés, sept rubriques, limites statique/fragment/runtime et conservation. Le reçu final enregistre les résultats effectivement observés.

Aucune modification du goal, de ses critères normatifs, de l’application de suivi, de son interface ou de ses bases. Le runtime du suivi n’est pas invoqué et les bases ne sont pas ouvertes ; les fichiers gelés sont seulement lus pour comparaison d’empreinte. Aucune installation, migration, relance ou restauration. Bilan : un lot d’audit clôturé, aucune fonctionnalité ou tâche parente déclarée terminée et aucun taux global de jeu terminé.