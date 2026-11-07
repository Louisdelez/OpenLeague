# AUD-17.3-03-LOADING-ERROR-RETURN-01 — erreur de chargement et retour au client

Preuves du 2026-10-30T23:07:54.849768+00:00 au 2026-10-30T23:07:56.939798+00:00. Projet F:\OpenLeague ; LoL4.20.0.315, EUW/en_GB, catalogue4.20.1. Audit documentaire uniquement : aucun changement du goal, de ses critères, des registres, du jeu, de Plan ou de ses bases.

Résultat : les erreurs de lancement/processus ont déjà une projection et des actions de récupération ; le JS actuel correspond aux anciens essais injectés. Le parcours complet erreur de ressource requise→message→retour n’est pas qualifié. Deux modules Rust ont évolué depuis le reçu ancien ; ces écarts et la portée statique du reçu plus récent sont conservés. Clôture documentaire seulement après relecture R1–R7 ; fonctionnalité et inconnue restent ouvertes.

## R1 — Exigence, périmètre et prérequis

**SYS-17.3-03 — Afficher une erreur de chargement sans bloquer le retour au client** ; exigence `OLF-8f498060-37bc-584a-81e8-76d5862a5d52` ; inconnue `OLU-63e81cd3-e23e-5cd5-b985-7b0c61d22ee2`. `a_faire`, implementation_complete=false, acceptance_complete=false et inconnue open inchangés. Aucun critère normatif modifié.

D17-SYS-17-3 dépend de D20-SYS-20-3 « Connexion et reconnexion », toujours a_faire. Le retour dans la fenêtre du launcher, la reprise d’une partie conservée, le drain du serveur et l’autorisation d’une nouvelle partie sont des résultats différents. Les clauses de SYS-17.3-01, SYS-17.3-07, SYS-17.3-09 et SYS-01.1-06 sont réutilisées sans les clore depuis ce lot.

Périmètre parent : familles d’échec, erreur source, texte/état rendu, actions et sortie, propriété des processus, refus pertinents et limites historiques/actuelles. Hors portée : corriger un logiciel, lancer un jeu/client/launcher, altérer un asset, exécuter Rust/AIR/REA/GPU, installer, migrer ou ouvrir une base. Le tour précédent est classé **progress** : le parent documentaire SYS-17.3-02 a été clos avec161contrôles et245de relecture ; son implémentation reste ouverte.

## R2 — Sources historiques et preuves existantes

### AIR : restaurer le client n’impose pas toujours le lobby

Contrat réutilisé : `docs/reference_loading_return_4_20.json`, identique à la preuve précédente. Quatre snapshots d’origine AIR sont identifiés, avec chemin d’origine, entrée de bibliothèque et empreinte : ApplicationController, LolGamePreloadController, MasterGameController, InGameController. Fragments A043/A096/A101/A104 vérifiés contre les SHA d’extraits enregistrés. Aucune exécution AIR/native nouvelle.

- A043, crash/abandon du préchargement : désactive _shouldPreload et _currentlyPreloading, retire les handlers. Ce chemin n’est pas un dialogue natif de chargement observé.
- A101, crash/abandon : le replay a une garde distincte. Sinon minimized=false et maximizeClient(). NO_GAME ou GAME_OVER conduisent au LOBBY ; l’autre branche va vers RECONNECT. Ne pas renvoyer arbitrairement toute partie en cours dans un nouveau lobby.
- A096, nettoyage : callbacks/roster/partie et credentials courants/pending nettoyés ; état NO_GAME, arrêt du préchargement selon sa propre règle.
- A104, reconnexion : référence conservée comme chemin séparé ; la définition de source ne vaut ni service historique disponible ni nouvelle exécution de retour.

Le texte exact d’un message natif de ressource, sa boîte de dialogue et l’événement qui relie cet échec au crash/abandon AIR restent **non qualifiés**. La recherche bornée dans ces quatre snapshots retrouve les handlers nommés de crash, pas une chaîne identifiée loadingError/loadError/loadFailed/loadingFailed→dialogue→retour. Cela ne prouve pas qu’aucun dialogue n’existait dans tout le client. Reprise : callsite/émetteur ou capture4.20nommée d’une erreur de chargement précise.

### Réutiliser les contrôles correspondant réellement au code actuel

Reçu de qualification hérité : `E:\mapslol3v3\launcher_join_local_qualification_v2\20261011T232459-b89e9b8e5d67474db51aee653009c6c3\receipt.json`. L’empreinte **f4f58340d72d2bedbf94b88a847a537c2ea7d76594f053d6a5dc4eba1cf64ad6** de launcher/web/app.js est exactement celle des trois groupes testés. Leurs harnais exécutés, reçus disponibles et résultat inline sont vérifiés ; aucun essai n’est rejoué.

| Groupe hérité | Contrôles | Ce qu’il couvre | Limite |
|---|---:|---|---|
| js_recovery | 12 | Erreur de spawn visible/réessayable, reprise/abandon, pas de deuxième serveur pendant session active | DOM/Tauri/statuts injectés ; aucun enfant natif |
| js_status | 11 | Erreur actuelle distincte de l’historique, réactivation correcte après reprise, refus pendant observation incertaine | Le producteur Rust des statuts est séparé |
| js_join | 17 | Client rejoint, absence d’abandon du serveur, échec de reprise et retour au choix après fermeture normale | Aucune fenêtre, socket ou erreur réelle de chargement exécutée |

Total : **40 contrôles JavaScript hérités**, avec leur source exacte. Le groupe js_join conserve son résultat dans le reçu de qualification ; son separate_receipt vaut null, aucun reçu autonome n’est inventé. Les conditions/injections ne sont pas une acceptation du parcours Tauri réel ni de l’interface historique.

### Deux modules Rust ont changé : la preuve ne change pas de portée

sessions.rs et sessions_joined.rs diffèrent du candidat qualifié ancien. Le diff est conservé dans current_backend_identity_review : intégration LoggedChild, diagnostics structurés, wrappers de spawn et reprise. Les trois fichiers de tests statut/recovery/joined sont identiques, mais leur stabilité ne requalifie pas automatiquement le backend changé. Aucun test Rust nouveau exécuté.

La recherche d’une preuve plus récente a été bornée aux2847documents JSON/Markdown directs de docs inférieurs à1MiB. Une limite de longueur de commande Windows a empêché le premier lancement de rg ; des lots disjoints ont ensuite terminé la recherche. La piste V785 identifie bien le consommateur diagnostics actuel à source identique, avec la qualification explicite **other anchors statically inspected**. Ses exécutions de fixtures downloader ne sont pas des exécutions de ces branches de retour. Aucun vieux reçu n’est remplacé ni promu en recette courante.

## R3 — Erreur source → visibilité → retour réel

Le corpus de **1 168 fichiers** Rust/launcher est inchangé en membres et contenus. Les commandes Tauri play/join_local/session_status/resume_session/abandon_session, leur routage, les deux modes d’ownership et le JS consommateur sont inspectés. L’ancienne association du registre sur current_errors est conservée, complétée dans ce rapport sans réécriture.

| Famille | Erreur / origine | Visibilité actuelle | Retour ou limite |
|---|---|---|---|
| launch_precheck | Missing executable, unavailable local port or invalid selection | Tauri Err -> action.catch launchError + session message | finally clears pending; refresh permits next allowed action based on ownership Source branches and exact-JS inherited injected tests; no missing executable/port induced now. |
| startup_bootstrap | Server adopted before client spawn/pipe write; failure recorded | Run.launch_error -> current_errors -> state error/message | Spawn/pipe branches retain ownership; drain only in named branches; next launch waits retired No current native startup-failure return scenario observed; current Rust differs from older qualification. |
| resource_failure | Asset failure fixed diagnostic code; portrait eprintln; minion declared fallback | Diagnostic metadata/log code exists; app renders session.message only, no required-resource error banner identified | Critical vs optional classification and error-to-return contract not qualified Do not call every optional widget failure fatal; no assets corrupted or fallback parity accepted. |
| owned_client_crash | Observed non-success client exit, owned server still live | Current error takes precedence; message includes exit code | can_resume or can_abandon according to retained owned identity; can_play only after full retirement Current sources and old same-JS controls; changed LoggedChild backend not freshly executed. |
| server_exit_first | Owned server exited while client still observed not exited | Explicit instruction to close client remains current | Manual client close then retirement; never replace PID or report idle while owner unresolved No guarantee of immediate fresh-match readiness or external server ownership. |
| status_or_observation_unavailable | try_wait/lock/status invoke failure | Observation error or Suivi indisponible; frontend launch actions disabled | Owner retained; subsequent successful poll can restore allowed actions; no false idle Unresolved invoke and return/foreground route not qualified by old DOM tests; no unsafe force-kill implied. |
| joined_client_failure | Non-success exit of client attached to somebody else local server | Joined error state and restart/loss warning | Resume only; can_abandon=false/server_owned=false; normal own child close re-enables local choice Do not drain/stop foreign server; close guard retains live or unobserved joined child. |
| normal_exit_drain | Normal owned exit and explicit abandon | Draining message; complete retired status enables new choice | Owned stdin EOF -> server drain, both observed exits before can_play Normal return/runtime and terminal layout are different from loading-error acceptance; related SYS17.3.09 remains open. |

Acquis frontend : action.catch conserve launchError ; finally libère launchPending puis rafraîchit le statut. En cas d’erreur de processus, la reprise/abandon dépendent des capacités renvoyées, pas seulement de state=error. Les diagnostics anciens restent distincts de current_errors. Si session_status échoue, les actions sont désactivées et « Suivi de la session indisponible » s’affiche ; aucun idle n’est inventé. Le polling500ms peut ensuite rétablir les capacités quand une réponse valide revient. Un invoke qui ne se résout jamais et le retour/foreground utilisateur dans cette situation ne sont pas qualifiés par ces preuves.

Acquis backend host : adoption du serveur avant pipe/spawn du client ; erreurs conservées ; drain par fermeture du stdin propriétaire, sans kill. Le client sorti en erreur peut conserver sa partie et sa capacité de reprise ; nouvelle partie seulement après retrait complet des enfants observés. Si le serveur sort avant le client, le message demande de fermer ce dernier. L’abandon est refusé tant que le client est actif. Une observation incertaine conserve l’owner et ne peut autoriser une nouvelle session par hypothèse.

Acquis joined : server_owned=false, can_abandon=false ; ce launcher ne possède pas le serveur. Le close guard conserve un enfant vivant/non observé ; reprise après sortie en erreur observée. Le retour ne doit ni drainer ni remplacer le serveur d’un autre launcher. La libération de réservation et son ACK restent une question distincte d’un processus fermé, portée par les tâches de session/reconnexion.

Acquis et limite de diagnostic de ressource : sessions_output reconnaît asset_load_failed, process_panic, session_bootstrap_failed et session_transport_failed dans des lignes, garde des codes fixes et des métadonnées bornées. LoggedChild.observe utilise try_wait ; une ligne d’erreur n’est pas transformée ici en échec de processus. Le JS affiche session.message et ne lit pas client_diagnostics. Un code classé ne prouve donc pas une bannière de chargement visible ou une sortie proposée.

Les routes de ressource existantes sont conservées : native_hud_portraits omet/logue un portrait indisponible ; native_minion_mips traite LoadState::Failed en conservant un état PNG_retained_DDS_load_failed. Ne pas qualifier ce fallback comme fidèle ou complet, ni transformer chaque erreur optionnelle de widget en arrêt fatal. La recherche AssetLoadFailedEvent/LoadState::Failed/AssetEvent::Failed dans le client trouve ce module de sbires ; son absence ailleurs est limitée à ces types et aux routes inspectées. Une chaîne de chargement critique vers une erreur utilisateur complète reste à qualifier.

Fragments et empreintes, dans current_consumer_fragments :
- `F:\OpenLeague\launcher\web\app.js:1` — frontend (jusqu’à52).
- `F:\OpenLeague\launcher\src-tauri\src\main.rs:1` — tauri_commands (jusqu’à14).
- `F:\OpenLeague\launcher\src-tauri\src\main.rs:68` — tauri_close (jusqu’à80).
- `F:\OpenLeague\launcher\src-tauri\src\sessions.rs:129` — current_error_projection (jusqu’à147).
- `F:\OpenLeague\launcher\src-tauri\src\sessions.rs:148` — owned_lifecycle (jusqu’à181).
- `F:\OpenLeague\launcher\src-tauri\src\sessions.rs:182` — owned_status (jusqu’à200).
- `F:\OpenLeague\launcher\src-tauri\src\sessions.rs:286` — owned_resume_abandon (jusqu’à313).
- `F:\OpenLeague\launcher\src-tauri\src\sessions.rs:332` — owned_start (jusqu’à374).
- `F:\OpenLeague\launcher\src-tauri\src\sessions_joined.rs:23` — joined_close (jusqu’à36).
- `F:\OpenLeague\launcher\src-tauri\src\sessions_joined.rs:74` — joined_status (jusqu’à99).
- `F:\OpenLeague\launcher\src-tauri\src\sessions_output.rs:93` — output_codes (jusqu’à113).
- `F:\OpenLeague\launcher\src-tauri\src\sessions_output.rs:294` — output_observe_diagnostics (jusqu’à328).
- `F:\OpenLeague\crates\client\src\native_hud_portraits.rs:19` — portrait_failure (jusqu’à27).
- `F:\OpenLeague\crates\client\src\native_minion_mips.rs:78` — minion_texture_failure (jusqu’à101).

## R4 — Attendu, observé, vérification réellement exécutée

**138 contrôles documentaires réussis** avec verify_loading_error.py. Ils vérifient le périmètre, les identités, les extraits, le réemploi exact des40contrôlesJS, la divergence des deux modules et les limites de source. La relecture indépendante est séparée ; aucun contrôle documentaire n’est nommé recette de jeu.

| Cas | Attendu | Observé et portée |
|---|---|---|
| Lancement rejeté | Message et actions réessayables sans lancer un second serveur | JS source exacte + contrôles injectés hérités ; aucune panne réelle induite |
| Crash host | Erreur visible avec reprise/abandon selon owner, pas nouvelle partie immédiate | Source actuelle et anciens statuts JS ; backend modifié non rejoué |
| Crash joined | Ne pas offrir abandon/kill du serveur | Source et17contrôlesJS injectés ; pas crash/recovery réel observé ici |
| Erreur de ressource | Classifier gravité/source puis message et route de retour | Code diagnostique/fallback présent ; chaîne critique complète non qualifiée |
| Superviseur/statut indisponible | Ne pas inventer succès/idle ni perdre owner | Texte/gates et retry de polling identifiés ; invoke sans réponse et retour visuel restent ouverts |
| Historique AIR | Respecter replay/fin/en-cours et restaurer le client | Trois branches source distinctes ; popup natif/événement/visuel non exécutés |
| Preuve ancienne | Réutiliser seulement la portée et version couvertes | Même JS f4f… ; deux modules Rust diffèrent, V785 reste statique pour diagnostics |
| Conservation | Aucune modification hors nouveaux livrables | 25fichiers protégés, cinqregistres et Git identiques |

Non exécutés maintenant : compilation/tests Rust, tests JS/DOM, launcher/Tauri, jeu/client/serveur, réseau, originalLoL, AIR, REA, GPU ou capture/entrée OS. Aucun asset n’a été altéré ni décodé ; aucun exécutable courant n’est annoncé accepté. Aucun téléchargement, installation, migration, relance de suivi ou accès de base. Les40contrôlesJS sont hérités et leurs fichiers relus, pas fraîchement exécutés.

## R5 — Manques précis et conditions de reprise

| Manque | Entrée nécessaire à la reprise | Résultat attendu / arrêt |
|---|---|---|
| Erreur critique Map10 | Événement du loader et ressource requise nommée, contexte d’exécution isolé | Gravité, message localisé et sortie observés ; pas corruption des assets réels |
| Portrait optionnel/requis | Politique native ou locale explicite de gravité et représentation de l’absence | Ne pas inventer image, réussite complète ou arrêt de partie |
| Retour host | Binaire/source actuels et panne déterministe de chargement avec owner déclaré | Erreur→action→retour, ancien enfant observé sorti, drain et retrait contrôlés |
| Retour joined | Deux rôles identifiés et panne du seul client rejoint | Même serveur conservé ; reprise/fermeture propres sans autorité hôte |
| Statut sans réponse | Contrat d’échec/attente du backend et scénario contrôlé | Attente/récupération/sortie visibles selon contrat, owner inconnu jamais converti en idle |
| UI historique | Callsite/émetteur ou capture4.20d’un message nommé | Texte/locale/actions et route source comparés ; pas style reconstruit déclaré fidèle sans témoin |
| Backend changé | Qualification actuelle de LoggedChild/spawn/observe/close et dépendances identifiées | Réutiliser les tests existants et40contrôlesJS, vérifier seulement les écarts ; pas ancien reçu global réétiqueté |

Ces écarts empêchent la fonctionnalité terminée. Ils n’empêchent pas la conclusion documentaire sourcée de ce lot : huitfamilles, consommateurs et reprises sont explicites. Les inconnues restent ouvertes. Aucune recherche supplémentaire inchangée, simulation d’asset corrompu, installation ou exécution réelle n’est déclenchée implicitement.

## R6 — Corrections nécessaires, réemploi et petites unités

Tâches/corrections existantes réutilisées : `SYS-01.1-06`, `SYS-17.3-01`, `SYS-17.3-07`, `SYS-17.3-09`, `D20-SYS-20-3`, `LOAD-STANDARD-PROVIDER-01`, `LOAD-CARDS-RENDER-LIFETIME-01`. Aucun statut n’est coché ou changé. Sept fiches **proposed_not_applied** sont documentées sous le même parent et la même inconnue :

### LOAD-ERROR-CRITICAL-MAP-01

Objectif : Relier une erreur de ressource Map10 requise à son message et sa sortie.

Écart : Codes diagnostiques et traces existent sans chaîne complète required-resource->UI->retour qualifiée.

Travail / consommateur : Identifier un échec réel de chargement de la carte dans un contexte isolé; qualifier source/phase/sévérité, afficher message localisé et route de sortie qui conserve les propriétaires.

Critères de fin : Cas carte requise indisponible ou invalide: source et erreur visibles, chargement non marqué réussi, action de retour réellement observée, pas nouvelle session pendant propriétaires actifs.

Entrée nécessaire à la reprise : Contrat des ressources requises et événement réel du loader plus consommateur UI autorisé; aucune corruption des assets de production.

Dépendances : `SYS-17.3-01`, `SYS-17.3-09`.

Preuves attendues : Exact current source/binary identities, expected/observed named failure and recovery path, retained owners and returned UI; mock/source/static evidence kept separate from actual game/window/runtime acceptance.

Sources : fragments R2/R3, fichiers de qualification, diff et matrice du reçu. État : proposed_not_applied ; aucune modification de code ou de suivi autorisée implicitement.

### LOAD-ERROR-PORTRAIT-SEVERITY-01

Objectif : Qualifier séparément le portrait indisponible et la gravité de son erreur.

Écart : Le renderer omet/logue le portrait; il ne prouve pas une erreur fatale de chargement ni un fallback natif.

Travail / consommateur : Qualifier rôle optionnel/requis et message indisponible; garder source/nom exact et absence explicite sans image inventée ni arrêt de toute partie par hypothèse.

Critères de fin : Un champion nommé, texture absente/décodage refusé et retour/dégradation selon contrat; UI indique la bonne limite et conserve les autres joueurs.

Entrée nécessaire à la reprise : Politique native ou locale explicitement distincte de gravité/affichage pour le portrait choisi.

Dépendances : `SYS-17.3-01`.

Preuves attendues : Exact current source/binary identities, expected/observed named failure and recovery path, retained owners and returned UI; mock/source/static evidence kept separate from actual game/window/runtime acceptance.

Sources : fragments R2/R3, fichiers de qualification, diff et matrice du reçu. État : proposed_not_applied ; aucune modification de code ou de suivi autorisée implicitement.

### LOAD-ERROR-OWNED-RETURN-01

Objectif : Qualifier le retour après échec du client dont ce launcher possède le serveur.

Écart : Gates de reprise/abandon existent, mais pas de parcours réel complet d’erreur de chargement actuel.

Travail / consommateur : Reprendre états/code actuels, provoquer échec nommé en copie d’exécution, afficher erreur puis exercer reprise et abandon selon autorité; vérifier drain et retirement sans tuer PID arbitraire.

Critères de fin : Échec->message->action->retour observé; aucun doublon de serveur, ancien enfant reaped, nouvelle partie seulement après retrait complet; historique conservé.

Entrée nécessaire à la reprise : Binaire/source actuels et scénario d’échec de chargement déterministe avec propriétaire serveur déclaré.

Dépendances : `SYS-17.3-09`, `D20-SYS-20-3`.

Preuves attendues : Exact current source/binary identities, expected/observed named failure and recovery path, retained owners and returned UI; mock/source/static evidence kept separate from actual game/window/runtime acceptance.

Sources : fragments R2/R3, fichiers de qualification, diff et matrice du reçu. État : proposed_not_applied ; aucune modification de code ou de suivi autorisée implicitement.

### LOAD-ERROR-JOINED-RETURN-01

Objectif : Qualifier le retour après échec du client rejoint sans autorité serveur.

Écart : Les règles joined diffèrent des règles host et refusent abandon de serveur.

Travail / consommateur : Observer erreur puis reprise/fermeture du seul client rejoint; close guard et récupération doivent préserver le serveur et le client hôte.

Critères de fin : Message compréhensible, aucune action d’abandon hôte exposée, serveur externe conservé, sortie du client observée et choix local disponible; absence d’ACK de release non masquée.

Entrée nécessaire à la reprise : Deux rôles locaux identifiés et échec nommé du client rejoint; ne pas assimiler l’ancien arrêt normal à un crash.

Dépendances : `SYS-17.3-07`, `SYS-17.3-09`.

Preuves attendues : Exact current source/binary identities, expected/observed named failure and recovery path, retained owners and returned UI; mock/source/static evidence kept separate from actual game/window/runtime acceptance.

Sources : fragments R2/R3, fichiers de qualification, diff et matrice du reçu. État : proposed_not_applied ; aucune modification de code ou de suivi autorisée implicitement.

### LOAD-ERROR-STATUS-UNAVAILABLE-01

Objectif : Qualifier une indisponibilité du suivi de session pendant le retour.

Écart : Frontend ferme les gates si invoke échoue; owner inconnu ne doit pas devenir idle, et retour/attente bloquée non qualifiés.

Travail / consommateur : Distinguer observation incertaine, erreur rendue, demande en attente et reprise de polling; définir une sortie utilisateur compatible avec propriété réelle.

Critères de fin : Échec de statut puis récupération ou attente bornée selon contrat explicite; aucune nouvelle session sur owner incertain, aucun verrou persistant caché, état/action visibles.

Entrée nécessaire à la reprise : Contrat de réponse/échec du backend et scénario contrôlé de blocage ou reprise; pas de reset/kill des propriétaires comme raccourci.

Dépendances : `SYS-17.3-09`.

Preuves attendues : Exact current source/binary identities, expected/observed named failure and recovery path, retained owners and returned UI; mock/source/static evidence kept separate from actual game/window/runtime acceptance.

Sources : fragments R2/R3, fichiers de qualification, diff et matrice du reçu. État : proposed_not_applied ; aucune modification de code ou de suivi autorisée implicitement.

### LOAD-ERROR-HISTORIC-UI-01

Objectif : Qualifier le message et la route historiques d’une erreur de chargement nommée.

Écart : AIR restore/reconnect/lobby est sourcé; dialogue natif, texte et événement asset->crash ne sont pas établis.

Travail / consommateur : Trouver un appel/émetteur natif ou capture4.20nommée; relier texte/locale et actions; conserver les branches replay/NO_GAME/GAME_OVER/en-cours distinctes.

Critères de fin : Un scénario historique nommé avec source/texte/action et retour cohérent; aucune généralisation à toutes erreurs et aucun style moderne imposé comme fidèle.

Entrée nécessaire à la reprise : Nouvelle source/callsite ou capture historique discriminante du message de chargement, plutôt que recherche générique répétée.

Dépendances : `SYS-01.1-06`.

Preuves attendues : Exact current source/binary identities, expected/observed named failure and recovery path, retained owners and returned UI; mock/source/static evidence kept separate from actual game/window/runtime acceptance.

Sources : fragments R2/R3, fichiers de qualification, diff et matrice du reçu. État : proposed_not_applied ; aucune modification de code ou de suivi autorisée implicitement.

### LOAD-ERROR-CURRENT-BACKEND-VERIFY-01

Objectif : Qualifier les branches d’échec du backend actuel après intégration LoggedChild.

Écart : Deux modules diffèrent du reçu ancien; tests sources inchangés et JS identique ne requalifient pas ce backend exécuté.

Travail / consommateur : Réutiliser les40contrôlesJS et tests Rust existants; vérifier précisément spawn/observe/diagnostics/reprise/close du code actuel, effets de diagnostic indisponible et fermeture sans attente indue.

Critères de fin : Identités actuelles et résultats attendus/observés sur host/joined; échec optionnel de diagnostics préserve l’ancien contrat, ownership conservé et sortie terminée; GUI reste une preuve distincte.

Entrée nécessaire à la reprise : Environnement de qualification autorisé, sources et dépendances actuelles; V785statique ne prouve pas une exécution de ces branches.

Dépendances : `LOAD-ERROR-OWNED-RETURN-01`, `LOAD-ERROR-JOINED-RETURN-01`.

Preuves attendues : Exact current source/binary identities, expected/observed named failure and recovery path, retained owners and returned UI; mock/source/static evidence kept separate from actual game/window/runtime acceptance.

Sources : fragments R2/R3, fichiers de qualification, diff et matrice du reçu. État : proposed_not_applied ; aucune modification de code ou de suivi autorisée implicitement.

### Quatre dimensions séparées

| Dimension | Conclusion |
|---|---|
| Audit | Parent documenté : erreur, visibilité, actions/retour, autorité/refus et limites par famille. Clôture uniquement après relecture R1–R7. |
| Implémentation | Partielle : gestion des erreurs de processus et récupération existent ; erreur critique de chargement jusqu’au retour complet non qualifiée. |
| Vérification | Réussite documentaire138contrôles ;40contrôlesJS hérités applicables à la même source. Backend actuel, scénario réel et fidélité native restent distincts. |
| Acceptation humaine | Aucune acceptation de la fonctionnalité demandée ou revendiquée. |

Aucun écart fonctionnel corrigé. Résolu pour l’audit : différencier le chemin réellement visible de lancement/processus des simples diagnostics d’assets ; préserver l’acquis JS et identifier la divergence Rust avec la preuve plus récente de portée statique. Tâche, inconnue et goal global restent ouverts ; aucun pourcentage de jeu terminé ne découle de ce résultat.

## R7 — Livrables, identités, conservation et relecture

Nouveaux fichiers uniquement :
- [audit-unit.json](F:/OpenLeague-work/audit-units/AUD-17.3-03-LOADING-ERROR-RETURN-01/audit-unit.json) — périmètre avant investigation.
- [verify_loading_error.py](F:/OpenLeague-work/audit-units/AUD-17.3-03-LOADING-ERROR-RETURN-01/verify_loading_error.py) — lecteur producteur.
- [loading-error-proof.json](F:/OpenLeague-work/audit-units/AUD-17.3-03-LOADING-ERROR-RETURN-01/loading-error-proof.json) — preuves et résultats structurés.
- [AUD-17.3-03-LOADING-ERROR-RETURN-01.md](F:/OpenLeague/docs/audit/units/AUD-17.3-03-LOADING-ERROR-RETURN-01.md) — présent rapport.
- [verify_delivery.py](F:/OpenLeague-work/audit-units/AUD-17.3-03-LOADING-ERROR-RETURN-01/verify_delivery.py) — lecteur indépendant.
- [delivery-readback.json](F:/OpenLeague-work/audit-units/AUD-17.3-03-LOADING-ERROR-RETURN-01/delivery-readback.json) — décision documentaire de relecture.

Reçu brut : 332674octets, SHA-256 **0322b97ec2321ce689ff2d24fe3078304f1433c0869f8e12bfce9bb7f8d72a92**. audit_scope_closed=false y est intentionnel ; le lecteur indépendant vérifie les sept rubriques et peut clore uniquement le périmètre documentaire.

Git main/HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca ;76fichiers suivis déjà modifiés conservés. **19 fichiers logiciels gelés**, **six documents de contexte/méthode**, **cinq registres normatifs** et pièce jointe du goal inchangés. Aucune base ouverte ; aucun Store/work_cli/serveur de suivi appelé ; aucun retrait, reset, suppression, installation, migration ou redémarrage. Les nouveaux scripts ne modifient aucune source applicative.

Relecture : sources/extraitsAIR, identité du JS réellement testé,40assertions héritées et leurs limites, deuxdiffs Rust et V785statique, huitfamilles de retour, refus et septcorrections, quatre dimensions et conservation. --check-only n’écrit pas de nouveau reçu ; pas de répétition après réussite sans entrée nouvelle.

```powershell
& 'C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -X utf8 -E -B 'F:\OpenLeague-work\audit-units\AUD-17.3-03-LOADING-ERROR-RETURN-01\verify_delivery.py' --check-only
```

Condition d’arrêt : conclure ce lot après relecture puis avancer vers une exigence non auditée. Les reprises spécifiques sont R5, sans changer le goal, ses critères, son statut ni les bases. Ne pas confondre audit terminé, implémentation terminée, vérification runtime et acceptation humaine.
