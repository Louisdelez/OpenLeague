# AUD-17.3-02-PLAYER-LOADING-PROGRESS-01 — progression réelle du chargement par joueur

Preuves du 2026-10-30T22:53:07.295290+00:00 au 2026-10-30T22:53:10.226675+00:00. Projet F:\OpenLeague ; référence LoL4.20.0.315, EUW/en_GB, catalogue4.20.1. Audit documentaire uniquement. Le goal, ses critères, les registres, le jeu, le suivi et ses bases ne sont pas modifiés.

Résultat établi : des témoins de ressources CPU/GPU et une barrière de transport existent, mais aucun report de progression réelle par joueur ni son affichage n’est identifié dans les interfaces et routes inspectées. Les octets d’un record natif et l’événement AIR de fin ne donnent pas, à eux seuls, un pourcentage de chargement. La clôture documentaire de ce parent dépend de la relecture indépendante ; la fonctionnalité reste ouverte.

## R1 — Exigence, périmètre et entrées

**SYS-17.3-02 — Afficher la progression réelle de chargement des joueurs** ; exigence `OLF-a8f39d48-e879-5c03-8dea-b581081d013e` ; inconnue `OLU-f33fe80b-ae0a-5026-b723-8c2f2221f2ff`. Le registre conserve `a_faire`, implementation_complete=false, acceptance_complete=false et l’inconnue `open`. Aucun critère normatif modifié.

Lot D17-SYS-17-3 « Écrans et états de partie » ; prérequis D20-SYS-20-3 « Connexion et reconnexion » toujours `a_faire`, dépendant de D20-SYS-20-1. La lecture du prérequis ne le valide pas. SYS-17.3-01 conserve les cartes champion/skin/équipe ; SYS-17.3-03 les erreurs ; SYS-17.3-07 la reconnexion ; SYS-17.3-09 la fermeture/retour. SYS-01.1-06 porte le référentiel d’états et ses inconnues de pont entre événements.

Le présent périmètre couvre producteur réel, unité/dénominateur, identité des participants, transport/projection, affichage, indisponibilité/refus et durée de vie. Il ne réduit pas la tâche au statut playing ni à un compteur local. Hors portée : implémenter ces corrections, modifier une application/base, lancer Rust/LoL/REA/GPU, installer, migrer ou reconstruire des ressources.

Tour précédent classé **progress** : AUD-17.3-01-LOADING-PRESENTATION-01 a clos son audit documentaire après285contrôles producteur et231de relecture ; skins de session, cartes et continuation Standard restent ouverts. Son reçu indépendant est vérifié. Les1178paires d’assets et51régions natives déjà établies ne sont pas réexaminées à l’identique : réutilisation des identités et cinq liens de régions utiles à cette question.

## R2 — Sources et preuve de leur portée

### AIR et Maestro : fin de chargement distincte de pourcentages individuels

Le contrat historique `docs/reference_loading_return_4_20.json` est comparé au SHA de son reçu de vérification. Trois références parentes correspondent encore : client4.20, buildsfrontend et routesAIR. Sept sources sont relues dans les snapshots et leurs copies de review actuelles F ; les anciens chemins E demeurent de la provenance, sans remplacement silencieux.
- `air.GameEvent` — `F:\OpenLeague\docs\reference_loading_return_sources\air\GameEvent.as` ; entrée d’origine `lib/ClientLibChampionSelection.dat`.
- `air.MasterGameController` — `F:\OpenLeague\docs\reference_loading_return_sources\air\MasterGameController.as` ; entrée d’origine `lib/ClientLibGame.dat`.
- `air.MaestroConstants` — `F:\OpenLeague\docs\reference_loading_return_sources\air\MaestroConstants.as` ; entrée d’origine `lib/ClientLibServices.dat`.
- `air.MaestroController` — `F:\OpenLeague\docs\reference_loading_return_sources\air\MaestroController.as` ; entrée d’origine `lib/ClientLibSystem.dat`.
- `air.MaestroServiceImpl` — `F:\OpenLeague\docs\reference_loading_return_sources\air\MaestroServiceImpl.as` ; entrée d’origine `mod/ser/mod_ser.dat`.
- `air.LolGamePreloadController` — `F:\OpenLeague\docs\reference_loading_return_sources\air\LolGamePreloadController.as` ; entrée d’origine `lib/ClientLibGame.dat`.
- `air.ClientConfig` — `F:\OpenLeague\docs\reference_loading_return_sources\air\ClientConfig.as` ; entrée d’origine `lib/ClientLibSystem.dat`.

Chaîne constatée dans ces sources :

1. MaestroServiceImpl déclare GAMECLIENT_GAME_LOADING_COMPLETE=33. Son handler crée `new Event(MaestroConstants.GAME_LOADING_COMPLETE)` ; aucun report de joueur ou pourcentage n’est contenu dans ce constructeur d’événement.
2. MaestroController.onGameLoadingComplete dispatch `this._gameLoadingComplete.dispatch()` ; fragment historique A088 relu octet de texte par octet.
3. GameEvent déclare COMPLETE_LOAD_SCREEN. MasterGameController ajoute puis retire son listener ; son handler A086 appelle completePreload(), passe currentState à PLAYING_GAME et termine la sélection.
4. Le pont de l’événement Maestro33 vers l’émetteur COMPLETE_LOAD_SCREEN reste **non qualifié**. Aucun de ces états n’est déclaré preuve de progression réelle de tous les joueurs.

Les deux inconnues antérieures sont conservées textuellement dans le reçu : émetteur/pont COMPLETE_LOAD_SCREEN ; pourcentages natifs par joueur et séquencement de disponibilité de tous. La recherche historique dans9139exports est héritée, **non rejouée**. Install/update/download progress, messages de ressources, préchargement demandé et initialisation de LoadingScreenBackground ont des objets différents ; aucune conversion vers une progression de partie n’est autorisée par leur nom.

### Record natif : réutiliser la preuve, conserver les champs opaques

L’ancienne préparation `docs/replay_loading_record_preparation/loading_record_manifest.json`, datée2026-10-10, épingle six fichiers désormais relus sur F. Le fixture comporte **1 600 anciens appels natifs** :800Standard57D650et800Tutorial5B3230,256flags, neufclés, quatremotifs et deuxfills. Son résultat rapporte0appelUI,0allocation et153adresses d’instructions. Les contextes d’arbres/recipients sont explicitement préparés, pas une session historique.

Relecture fraîche des résultats enregistrés : les1600records de destination et les1600traces d’écriture respectent sixmots32puisunoctet, avec remise à zéro de record+16si bit0du flag. Les observations enregistrées non_target_bytes_unchanged, payload_unchanged et stack_bytes_popped=8sont conservées. **Aucun oracle natif n’est exécuté ici**, aucune nouvelle comparaison de l’arène entière16384octets n’est revendiquée.

Les cinq régions exécutables sont reliées aux51régions déjà vérifiées du PE4.20 ; le SHA du PE original est à nouveau identique. Le fixture et la fonction Rust actuelle conservent le retour anticipé si la chaîne SSO du record est non vide, avant provider/UI. Les motifs IEEE non finis sont des bits copiés dans ce test : ils ne prouvent ni validité d’un pourcentage NaN, ni refus numérique historique. Le mot remis à zéro n’est pas nommé terminé/prêt faute de preuve de son sens.

La branche Tutorial qui recopie des champs via x87_f32_roundtrip et échantillonne une horloge reste séparée de Standard. Une interprétation flottante ne donne pas d’unité, dénominateur, producteur de progression ou règle d’agrégation. Ces informations restent à qualifier, sans inventer 0..100.

## R3 — Consommateurs actuels et maillons manquants

Le corpus de **1 168 fichiers** Rust/launcher est identique en membres et contenus au reçu référencé. Recherche bornée, motif exact conservé dans `new_bounded_query` : loading_progress, load_progress, asset_progress, player_progress, loaded_players, loadingPercent, LoadProgress, COMPLETE_LOAD_SCREEN, LoadingProgress. Aucun résultat. L’absence demeure limitée aux termes, types et routes examinés, pas une preuve universelle sur tout code possible.

| Origine / maillon | Acquis constaté | Limite / manque |
|---|---|---|
| original native record | 57D650/5B3230 existing1600oracle;25raw bytes copied; bit0resets word16 ; No percentage/units/denominator/peer report semantics, allocation/UI/network execution qualified by that oracle. | Named original payload writer and rendering reader with participant, units and source fields. |
| AIR completion event | MaestroServiceImpl type33 -> Event(GAME_LOADING_COMPLETE) -> signal; MasterGameController onLoadScreenComplete changes view ; Completion IPC event alone has no percentage; bridge to COMPLETE_LOAD_SCREEN emitter remains unknown. | Reuse SYS01.1.06; named emitter/bridge needed, not progress fabricated from state PLAYING_GAME. |
| process state | launcher sessions.status state playing/reconnecting/error ; Child/process ownership and status; no individual asset progress. | Real per-participant data and view, never process alive=>100%. |
| transport ready | BootstrapBarrier + client.ready + snapshot commit ; Context/ordinal/frame readiness and refusals exist; not resource or pixel completion. | Preserve these checks, add a distinct progress contract if authorized. |
| local resources | AssetServer dependency checks, WorldInstanceReady and CPU/GPU tickets in capture observer ; Real optional diagnostic availability/missing and identity/freshness checks; no per-peer percentages or success-pixel claim. | Measured required resource set/stages/units, not image file count or screenshot readiness as completion. |
| per-player transport and state | Input/ClientMessage/ServerMessage/Snapshot/Roster inspected ; Participant/session/team exist; no named progress field/report is identified. | Typed bounded report, identity/audience/sequence and unavailable/error semantics. |
| presentation and lifetime | prior loading screen audit and current source corpus/query ; Complete six-card loading UI not identified; no percentage renderer identified. | Per-participant actual values or explicit unavailable, stale/reconnect/retirement and end-of-loading rules. |

La readiness actuelle est précise et utile : BootstrapBarrier.ready exige une frame et applied≥required ; contextes étrangers et frames périmées ont des refus explicites. Client.ready exige absence d’échec/demande en attente, presented non nul, presented==delivered et barrière prête. Le chemin main reçoit et valide puis commite `state.snapshot` avant `connection.presented(delivery)`. Cela ne vérifie pas que les ressources de chaque autre joueur sont chargées, ni qu’un pixel a été rendu.

Acquis de ressources conservé : le helper six_gui_capture_readiness n’est installé que sous OPENLEAGUE_SIX_GUI_OBSERVATION. Il vérifie dépendances AssetServer, WorldInstanceReady et témoins CPU/GPU. Le scope lie PID/session/player/epoch, modèle, carte, fenêtre, caméra et instances ; la fraîcheur utilise les séries de source, pas une attente arbitraire. `resources_ready=missing.is_empty()` et les tickets exacts sont des observations de disponibilité pour captures, sans pourcentage ni preuve de succès des pixels. Désactivé, le helper retourne indisponible, pas une réussite.

Les enums Input/ClientMessage/ServerMessage, la définition entière Snapshot et RosterEntry sont inspectés. Ils transportent commandes, horloges, état et identités ; aucun champ/report de progression de chargement n’est identifié. Le score, les PV, les compteurs ou des JSON de sorts ne deviennent pas des reports de chargement par hypothèse. Le while de simulation examiné est gardé par pause/temps/catchup, sans barrière de tous les joueurs chargés dans ce bloc ; aucune fidélité de séquencement natif n’en est déduite.

Le statut launcher playing reste un statut de processus. Le diagnostic de ressources local, la barrière de transport, l’événement de complétion AIR et la copie native sont des preuves de natures différentes. L’ancien lien de registre « playing n’est pas une progression » est conservé et complété par ces véritables consommateurs ; le registre n’est pas réécrit.

Fragments exacts, chemins et identités sont dans current_consumer_fragments, notamment :
- `F:\OpenLeague\crates\core\src\session_transport.rs:184` — bootstrap_barrier (jusqu’à207).
- `F:\OpenLeague\crates\client\src\session_client.rs:45` — client_transport_ready (jusqu’à65).
- `F:\OpenLeague\crates\client\src\main.rs:1331` — main_commit (jusqu’à1339).
- `F:\OpenLeague\crates\client\src\six_gui_capture_readiness.rs:1` — asset_probe_install (jusqu’à56).
- `F:\OpenLeague\crates\client\src\six_gui_capture_readiness.rs:537` — resource_status (jusqu’à563).
- `F:\OpenLeague\crates\client\src\six_gui_capture_readiness_types.rs:6` — resource_scope (jusqu’à22).
- `F:\OpenLeague\crates\client\src\six_gui_capture_readiness_types.rs:47` — resource_freshness (jusqu’à79).
- `F:\OpenLeague\crates\core\src\lib.rs:209` — snapshot (jusqu’à278).
- `F:\OpenLeague\crates\core\src\session_transport.rs:78` — transport_input (jusqu’à95).
- `F:\OpenLeague\crates\server\src\main.rs:190` — server_tick (jusqu’à209).
- `F:\OpenLeague\crates\core\src\audio_loading_screen_packet.rs:126` — native_record_copy (jusqu’à179).

## R4 — Attendu, observé et contrôles exécutés

**161 contrôles documentaires réussis** avec verify_player_loading.py. La relecture indépendante est livrée séparément. Ces comptes ne sont pas des tests de progression en partie.

| Cas | Attendu | Observé |
|---|---|---|
| Sources | Réutiliser les bonnes sources datées, avec limites | 7snapshots/reviews,3références parentes, contrat/receipt et sixfichiers du fixture relus |
| Nominal natif ancien | Ne pas convertir copie en sémantique de chargement | 1600destinations/traces enregistrées reproduites ;0UI/0allocations dans la sonde héritée |
| Complétion AIR | Qualifier la chaîne disponible sans inventer son pont | Event33/signal/handler trouvés ; émetteur COMPLETE_LOAD_SCREENtoujours ouvert |
| Transport valide/refus | Préserver contexte/fraîcheur et commit existants | Gardes réelles et erreurs statiques relues, aucun nouveau test réseau exécuté |
| Ressources locales | Préserver la mesure existante et sa portée | Helper capture présent, scope/tickets/missing ; aucune valeur partagée par joueur |
| Vrai zéro / inconnu / fin | Ne pas inventer un résultat de fonction absente | Aucun comportement runtime nouveau pour ces cas ; ils sont des contrôles futurs explicités R6 |
| Présentation3v3 | Ne pas déclarer une vue sans données ni capture | Aucun renderer de progression individuelle identifié sur routes inspectées |
| Conservation | Préserver logiciels gelés, contexte et registres | 25fichiers et cinqregistres conservés ; aucun accès à une base |

Non exécutés maintenant : jeu, client/serveur/launcher, réseau, Rust/cargo, originalLoL, REA, AIR/Maestro, GPU, screenshots, contrôle de souris/clavier, décodage/import d’assets, installation ou migration. Les1600cas sont **hérités**, la relecture de leurs octets est fraîche. Aucun nouveau passage des1178assets ni de la recherche9139exports. Les inconnues de producteur/pourcentage ne sont pas résolues par ces contrôles documentaires.

## R5 — Écarts précis et conditions de reprise

| Manque | Entrée nécessaire à la reprise | Borne d’arrêt / résultat attendu |
|---|---|---|
| Producteur natif | Caller/writer identifié du payload vers57D650et reader du champ vers son affichage, ou capture historique corrélée par participant | Qualifier source/unité/participant, pas répéter la copie des mêmes25octets |
| Émetteur de complétion | Appel nommé qui relie GameLoadingComplete33à COMPLETE_LOAD_SCREEN, dans le contexte réel | Réutiliser SYS-01.1-06 ; ni événement déclaré ni PLAYING_GAMEne suffit à tous les joueurs prêts |
| Mesure de ressources | Ensemble requis et contrat des étapes, unités et dénominateur pour une sélection/partie | Réutiliser les vrais témoins ; pas interpolation temporelle, compteur de fichiers du dépôt ou readiness de screenshot |
| Report et audience | DTO/protocole autorisé reliant auteur, session, joueur, epoch et ordre | Valeurs distinctes par joueur ; absence et erreur distinctes de0et100 |
| Validité numérique | Unité, borne, précision, fin et politique d’indisponibilité sourcées ; équivalent local identifié séparément | Non fini/négatif/hors unité n’ont aucun résultat supposé natif ; pas clamp de secours inventé |
| Sixcartes | Vue de SYS-17.3-01 et projection de reports réellement produite | Afficher la donnée réelle ou indisponible, jamais propre valeur locale sur toutes les cartes |
| Retard et reprise | Règle de fraîcheur, génération/ressources et contexte repris/retiré | Ne pas réutiliser vieux100% ; statut périmé, erreur, nouveau contexte et fin explicités |

Ces manques empêchent la fonctionnalité complète ; leur source ou absence bornée, les consommateurs présents et les reprises sont établis pour l’audit documentaire. Les variables opaques restent inconnues. Pas de recherche communautaire ou de nouveau passage REA sans piste nommée et décision discriminante ; les anciens arrêts ne sont pas rejoués automatiquement.

## R6 — Corrections réutilisées et nouvelles petites unités

Liens existants réutilisés : `SYS-01.1-06`, `SYS-17.3-01`, `SYS-17.3-03`, `SYS-17.3-07`, `SYS-17.3-09`, `D20-SYS-20-3`, `LOAD-CARDS-RENDER-LIFETIME-01`. Aucun statut, case, note, historique ou base du plan n’est modifié. Six compléments **proposed_not_applied**, chacun rattaché au parent et à son inconnue ; aucune implémentation implicitement autorisée.

### LOAD-PROGRESS-NATIVE-PRODUCER-01

Objectif : Identifier le producteur original d’un report de progression par participant.

Écart : Les25octets de record et event33ne qualifient pas nombre/unité/dénominateur.

Travail / consommateur : Partir du writer de payload vers57D650 et du reader de rendu, fixer provenance participant, unité, borne et absence; conserver les champs encore opaques.

Critères de fin : Un trajet nommé source->payload->record->lecteur démontre un report avec sa signification; rien n’est nommé pourcentage sur un simple motif de float.

Entrée nécessaire à la reprise : Nouvel appel/xref/trace ou capture historique nommant ce payload et son consommateur; ne pas rejouer les1600cas de copie.

Dépendances : `SYS-01.1-06`.

Preuves attendues : Source/contract and identities, expected/observed nominal and missing/refusal cases; current integration/render/network evidence only after separately authorized implementation. Native parity stays unqualified for explicit local alternatives.

Sources et bornes : fragments R2/R3 et identités du reçu ; état `proposed_not_applied`. Traiter un participant/report/cas nominal et les refus de cette fiche avant élargissement.

### LOAD-PROGRESS-RESOURCE-MEASURE-01

Objectif : Définir et mesurer les ressources requises du participant local.

Écart : Les témoins CPU/GPU de capture ne fournissent ni progression complète ni poids natifs.

Travail / consommateur : Qualifer ensemble requis, étapes et dénominateur; réutiliser les vrais événements/états de dépendances, garder source et cache distincts; tout équivalent local est explicitement versionné.

Critères de fin : Valeurs issues de travail réel; chargement partiel, ressource absente, ensemble inconnu et achèvement distincts; aucune progression depuis durée ou1178fichiers.

Entrée nécessaire à la reprise : Contrat de progression qualifié et liste des ressources réellement requises pour une sélection/partie, distinct du diagnostic capture.

Dépendances : `LOAD-PROGRESS-NATIVE-PRODUCER-01`.

Preuves attendues : Source/contract and identities, expected/observed nominal and missing/refusal cases; current integration/render/network evidence only after separately authorized implementation. Native parity stays unqualified for explicit local alternatives.

Sources et bornes : fragments R2/R3 et identités du reçu ; état `proposed_not_applied`. Traiter un participant/report/cas nominal et les refus de cette fiche avant élargissement.

### LOAD-PROGRESS-SESSION-REPORT-01

Objectif : Transmettre et projeter un report du participant avec son identité de session.

Écart : DTO actuels portent commandes/horloge/état sans progression dédiée.

Travail / consommateur : Définir report typé, auteur et audience; lier player/session/epoch et ordre frais; serveur conserve valeur et disponibilité par participant sans confondre ClockAck et assetReady.

Critères de fin : Deux joueurs avec valeurs différentes restent distincts; faux auteur, contexte étranger et ancien report refusés; pas de100%surWelcome ou heartbeat.

Entrée nécessaire à la reprise : Contrat de mesure et protocole de report autorisé; réutiliser contexte/authentification existants sans exposer des capacités.

Dépendances : `LOAD-PROGRESS-RESOURCE-MEASURE-01`, `D20-SYS-20-3`.

Preuves attendues : Source/contract and identities, expected/observed nominal and missing/refusal cases; current integration/render/network evidence only after separately authorized implementation. Native parity stays unqualified for explicit local alternatives.

Sources et bornes : fragments R2/R3 et identités du reçu ; état `proposed_not_applied`. Traiter un participant/report/cas nominal et les refus de cette fiche avant élargissement.

### LOAD-PROGRESS-VALUE-VALIDITY-01

Objectif : Distinguer report valide, vrai zéro et donnée indisponible.

Écart : Aucune unité ni politique de précision/borne fournie par les contrats actuels.

Travail / consommateur : Une fois l’unité fixée, qualifier valeur/plage/format, fin réelle et erreur; refuser les entrées invalides selon contrat identifié, sans déduire un refus natif depuis la copie IEEE.

Critères de fin : Cas absent,0réel,partiel,fin,nonfini,négatif et hors unité ont chacun résultat attendu/observé; inconnu ne devient ni0ni100, pas de clamp silencieux sans source.

Entrée nécessaire à la reprise : Contrat des valeurs natif ou local explicitement distinct et versionné, avant d’appliquer des bornes supposées.

Dépendances : `LOAD-PROGRESS-NATIVE-PRODUCER-01`, `LOAD-PROGRESS-SESSION-REPORT-01`.

Preuves attendues : Source/contract and identities, expected/observed nominal and missing/refusal cases; current integration/render/network evidence only after separately authorized implementation. Native parity stays unqualified for explicit local alternatives.

Sources et bornes : fragments R2/R3 et identités du reçu ; état `proposed_not_applied`. Traiter un participant/report/cas nominal et les refus de cette fiche avant élargissement.

### LOAD-PROGRESS-PER-PLAYER-VIEW-01

Objectif : Afficher la progression réelle sur chaque carte de joueur Map10.

Écart : La carte complète et son report ne sont pas raccordés; playing ne mesure pas le chargement.

Travail / consommateur : Relier la vue existante à l’état par participant; localiser format/unité et absence; afficher sixidentités et leurs valeurs réelles sans recopier la valeur locale partout.

Critères de fin : Sixjoueurs3+3identifiés une fois, valeurs différentes et inconnu lisibles; arrivée/erreur/sortie mises à jour; capture et état producteur corrélés, fin de chargement selon règle prouvée.

Entrée nécessaire à la reprise : Vue champion/skin/équipe autorisée et projections de reports; garder progression globale du projet hors du jeu.

Dépendances : `LOAD-CARDS-RENDER-LIFETIME-01`, `LOAD-PROGRESS-SESSION-REPORT-01`, `LOAD-PROGRESS-VALUE-VALIDITY-01`.

Preuves attendues : Source/contract and identities, expected/observed nominal and missing/refusal cases; current integration/render/network evidence only after separately authorized implementation. Native parity stays unqualified for explicit local alternatives.

Sources et bornes : fragments R2/R3 et identités du reçu ; état `proposed_not_applied`. Traiter un participant/report/cas nominal et les refus de cette fiche avant élargissement.

### LOAD-PROGRESS-SESSION-LIFETIME-01

Objectif : Invalider et réconcilier les reports lors de perte/reprise ou nouvelle session.

Écart : Les garanties de transport/frame et capture scope ne sont pas des garanties du futur report.

Travail / consommateur : Définir fraîcheur et état périmé, reconnexion et génération de ressources; séparer dernier report de chargement réel, reset/retirement et événement de fin.

Critères de fin : Retard, doublon, permutation, déconnexion, même joueur repris, session différente et erreur conservent identité/absence; aucun vieux100%réutilisé ni fin inférée du timer.

Entrée nécessaire à la reprise : Report/projection implémenté et règles natives ou locales déclarées de reprise/fin; réutiliser tâches de reconnexion/erreur existantes.

Dépendances : `LOAD-PROGRESS-SESSION-REPORT-01`, `SYS-17.3-03`, `SYS-17.3-07`, `SYS-17.3-09`.

Preuves attendues : Source/contract and identities, expected/observed nominal and missing/refusal cases; current integration/render/network evidence only after separately authorized implementation. Native parity stays unqualified for explicit local alternatives.

Sources et bornes : fragments R2/R3 et identités du reçu ; état `proposed_not_applied`. Traiter un participant/report/cas nominal et les refus de cette fiche avant élargissement.

### Quatre dimensions séparées

| Dimension | Conclusion |
|---|---|
| Audit | Périmètre parent documenté : producteur/mesure, identité/transport, affichage et limites/refus/lifecycle. Clôture uniquement après R1–R7 indépendants. |
| Implémentation | Pas de chaîne complète de progression par joueur identifiée. Acquis partiels : ressources de capture, transport/commit, ports de record et états. |
| Vérification | Réussite documentaire161contrôles et relecture des preuves ; comportement de progression/rendu/réseau non exécuté ici. |
| Acceptation humaine | Aucune acceptation de la fonctionnalité demandée ni revendiquée. |

Aucun écart fonctionnel corrigé dans ce lot. Résolu pour l’audit : séparation sourcée des différentes notions de prêt/fin et identification des maillons réellement absents ou non qualifiés. Restent ouverts la tâche, l’inconnue et le goal global. Aucun taux de jeu terminé, temps restant ou pourcentage factice n’est dérivé des comptes de contrôles ou fichiers.

## R7 — Livrables, conservation et relecture

Nouveaux fichiers uniquement :
- [audit-unit.json](F:/OpenLeague-work/audit-units/AUD-17.3-02-PLAYER-LOADING-PROGRESS-01/audit-unit.json) — périmètre préalable.
- [verify_player_loading.py](F:/OpenLeague-work/audit-units/AUD-17.3-02-PLAYER-LOADING-PROGRESS-01/verify_player_loading.py) — lecteur d’audit.
- [player-loading-proof.json](F:/OpenLeague-work/audit-units/AUD-17.3-02-PLAYER-LOADING-PROGRESS-01/player-loading-proof.json) — reçu source/consommateur et contrôles.
- [AUD-17.3-02-PLAYER-LOADING-PROGRESS-01.md](F:/OpenLeague/docs/audit/units/AUD-17.3-02-PLAYER-LOADING-PROGRESS-01.md) — rapport.
- [verify_delivery.py](F:/OpenLeague-work/audit-units/AUD-17.3-02-PLAYER-LOADING-PROGRESS-01/verify_delivery.py) — lecteur indépendant.
- [delivery-readback.json](F:/OpenLeague-work/audit-units/AUD-17.3-02-PLAYER-LOADING-PROGRESS-01/delivery-readback.json) — décision documentaire séparée.

Reçu brut : 327660octets, SHA-256 **4ea759245cce46bb4528a6da5b47b8e956b2e0499bbe87309d032f781a9d4905**. Son audit_scope_closed=false est intentionnel ; le producteur ne clôture pas son propre audit. La relecture vérifie les sept rubriques avec sources et limites ; seule sa décision peut clore ce lot documentaire.

Git main, HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,76fichiers suivis déjà modifiés : état conservé. **19 fichiers logiciels gelés**, **six documents de contexte/méthode**, **cinq registres normatifs** et pièce jointe du goal inchangés. Aucune base ouverte, aucun Store/work_cli/serveur de suivi démarré, aucun retrait automatique, installation, migration, lancement ou suppression.

Relecture : identités, sourceAIR et champs des anciens cas natifs, vrais fragments et absence bornée, contre-exemples, sixcorrections et quatre dimensions. --check-only n’écrit aucun reçu. Ne pas répéter ces contrôles après réussite sans changement, anomalie ou entrée nouvelle.

```powershell
& 'C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -X utf8 -E -B 'F:\OpenLeague-work\audit-units\AUD-17.3-02-PLAYER-LOADING-PROGRESS-01\verify_delivery.py' --check-only
```

Condition d’arrêt : conclure ce lot documentaire après relecture puis choisir une autre exigence non auditée. Reprendre les inconnues seulement avec l’entrée de R5 ; ne pas convertir une incertitude native persistante en blocage répétitif de l’audit global. Le goal, son statut, ses critères et les bases ne sont pas modifiés.
