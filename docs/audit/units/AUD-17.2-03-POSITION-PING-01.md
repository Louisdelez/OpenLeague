# AUD-17.2-03-POSITION-PING-01 — Envoi d’un ping de position

L’audit établit une **absence du chemin de ping de position dans le code courant inspecté**. Le client sait déplacer la caméra et envoyer `Move` depuis la minimap ; les commandes typées, leur admission et les réponses serveur ne représentent aucun ping de position. Ce résultat ferme la question d’audit délimitée, après relecture indépendante, mais laisse la fonctionnalité à réaliser.

## R1 — Exigence et frontières

- Tâche : **SYS-17.2-03**, « Envoyer un ping de position valide ».
- Exigence : **OLF-7818480d-f67c-5124-aac0-fc1b48761fa9**.
- Inconnue d’origine : **OLU-c526fa62-b709-5dfc-bc87-0c36b65f0354**, conservée `open`.
- Référence : LoL 4.20.0.315 PUBLIC Releases/4.20, EUW, en_GB ; catalogue 4.20.1. Le fichier d’entrée par défaut est une source d’écriture historique, sans preuve de priorité effective au chargement.
- Registre conservé : `a_faire`, `implementation_complete=false`, `acceptance_complete=false`. Aucun critère normatif modifié.

Le lot suit le geste, la position, le message typé, l’identité admise et la sortie destinée au bénéficiaire. Le cas nominal attendu est un ping à une position valide, transmis selon un contrat identifié ; les refus applicables et la politique historique ne sont pas inventés. Les médias, effets et sons des variantes relèvent de SYS-17.2-04. Aucun port de fonctionnalité, aucune modification du goal, du suivi, de ses registres ou bases n’est autorisé ici.

D17 contient 40 tâches ; ce lot concerne une seule des neuf tâches de D17-SYS-17-2. La phase et le lot n’ont pas de dépendance `depends_on` ; le lot requiert D13-SYS-13-3, « Confidentialité de l’état de jeu », lui-même dépendant de D13-SYS-13-1 et encore `a_faire`. Cela ne bloque pas le constat d’absence ; l’admission et les destinataires du futur ping devront respecter cette frontière. Aucun décompte d’audits ne constitue un pourcentage de jeu terminé.

## R2 — Sources originales, provenance et manques

Les sources suivantes sont lues dans le déploiement original sélectionné, sous `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/`.

| Source | Identité SHA-256 | Résultat borné |
|---|---|---|
| `DATA/cfg/defaults/Input.ini` — 30 938 octets | `930f1499991e9c4973e81086a26c944b7330058970c4227a614b897eae09fec1` | Huit lignes de ping dans `[GameEvents]`, lignes 396–403. |
| `DATA/cfg/input.ini` — 305 octets | `aead4280d339159623dbe8f39784bde4b87a6b05afc6d95f2feccec7ba99073a` | Fichier `[Quickbinds]` présent ; aucune entrée de ping. Cela ne prouve pas la priorité ou l’ensemble des surcharges natives. |
| `DATA/menu/hud/ping.ini` — 655 octets | `9b87d3efbaca0b57ee2639c777302bc6a03429c7c6934991b0aed866e93adf01` | Treize références de libellés vérifiées, réutilisées de V122. |

Les graphies `evnt` et `evt` sont conservées exactement :

| Événement `[GameEvents]` | Valeur originale |
|---|---|
| `evntPlayerPingCursor` | `[g]` |
| `evntPlayerPing` | `[alt][Button 1]` |
| `evntPlayerPingDanger` | `[ctrl][Button 1]` |
| `evntPlayerPingCursorDanger` | `[v]` |
| `evtPlayerPingOMW` | `[<Unbound>]` |
| `evtPlayerPingMIA` | `[<Unbound>]` |
| `evtPlayerPingRadialDanger` | `[<Unbound>]` |
| `evtPlayerPingComeHere` | `[<Unbound>]` |

Ces valeurs décrivent les associations par défaut, sans qualification du callback natif, de son arbitrage entre clic et roue, de la conversion de coordonnées ou du profil réellement chargé. La simple présence des quatre entrées `<Unbound>` ne signifie pas l’absence des variantes dans le jeu original.

`ping.ini` référence `Offense` (3 champs), `Danger` (5), `Throttled` (1), `General` (4). Le champ `PingThrottled=game_ping_[Throttled]_PingThrottled` est un **libellé**, sans quota numérique, fenêtre temporelle, destinataire ou callback serveur qualifié. Aucune traduction affichée en en_GB ni aucun son ne sont démontrés par ces identifiants.

Preuves réutilisées : `docs/reference_minimap_communication_sources/minimap_communication-links.json`, reçu du 23 octobre 2026 à 06:30:49 UTC, et ses deux recherches V122. Son association à SYS-17.2-03 était explicitement une frontière d’entrée, pas une implémentation. Les identités des recherches natives, consommateurs et tests/log sont contrôlées ; elles ne sont pas réexécutées comme des preuves nouvelles.

Manquent encore : le callback original de ping et son contexte chargé ; les règles natives de validité de position, de cadence et de destinataires ; une observation historique suffisamment identifiée pour qualifier ces règles. Une nouvelle recherche exige une entrée nommée : xref/callback, capture originale datée avec coordonnées/profil, paquet ou configuration gouvernant la règle. Aucune recherche REA ou communautaire répétée sans cette piste ; aucune installation.

## R3 — Consommateurs actuels et recherche d’absence

Le corpus de référence de l’audit `AUD-17.2-09-NATIVE-BUFFER-01` est réutilisé : **1 168 fichiers courants**, appartenance exacte et empreintes inchangées. Périmètre reproductible : tous les `crates/*/src/**/*.rs`, `launcher/src-tauri/src/**/*.rs` et les `.js`/`.html` directement dans `launcher/web`. Les sources des dépendances, binaires cachés et autres logiciels de la machine sont hors de cette conclusion.

La recherche `(?i)(?<![a-z])(?:ping|smartping|positionping)[a-z_]*` donne dix lignes : le commentaire de minimap « ping unported » et neuf lignes du service/rejeu audio ou de ses tests autour de `PingTimeForReconnectMessage`. Ce délai de reconnexion audio n’est pas un ping de position. La recherche `(?:evnt|evt)PlayerPing|PingThrottled|ping\.ini` ne donne aucun consommateur de ces noms dans ce corpus. Les motifs et résultats exacts sont conservés dans le reçu ; un résultat textuel négatif est corroboré par la lecture des types et traitements réels ci-dessous.

| Maillon inspecté | Consommateur réel | Observation |
|---|---|---|
| Système d’entrée enregistré | `crates/client/src/native_minimap.rs:31` | `input::input` est réellement enregistré dans `InputSet`, avant `commands`. |
| Intention de minimap | `crates/client/src/native_minimap_input.rs:9` | `Intent` contient seulement `Camera(Vec2)` et `Move(Vec2)` ; aucun intent de ping. |
| Geste et identité | même fichier, lignes 17–112 | Presses ordonnées, fenêtre, rectangle, focus, identité session/joueur/époque, UI et état de partie filtrent les gestes ; gauche → caméra, droite → `Action::Move`. Aucun choix de modificateur de ping. |
| Conversion de position | `crates/client/src/native_minimap_geometry.rs:39` | Inversion de la projection Map10 par défaut, curseur fini dans le rectangle ; minimum X/Z nul, pan centré, zoom 1. Frontières de projection historique déjà suivies par MM-PROJECTION-01. |
| Commandes de jeu | `crates/core/src/lib.rs:280` | Treize variantes `Action`, aucune de ping. Les paquets legacy encapsulent ces mêmes actions. |
| Envoi actuel | `crates/client/src/session_connection.rs:131` | `send_action` exige `ready()`, puis `Input::Command(action)` en session ou `ClientPacket::Command` en legacy ; aucun ping explicite. |
| Types de session | `crates/core/src/session_transport.rs:79` | `Input` = Command, PauseRequest, ClockAck, Heartbeat, Leave. `ServerMessage` n’a aucun événement de ping. Le transport est explicitement local, distinct du protocole Riot historique. |
| Décodage UDP réel | `crates/server/src/main.rs:63` | Décode d’abord `ClientMessage`, puis éventuellement les paquets legacy ; aucun DTO de ping ne peut être admis par ces types. |
| Admission et traitement | `crates/server/src/session_host.rs:121` | Prépare/commet l’entrée authentifiée et appelle `game.command(accepted.context.player, action)`. `Heartbeat => Ok(())` ne porte ni position ni événement de destinataire. |
| Sortie par destinataire | même fichier, lignes 153–166 | Horloges et instantanés `snapshot_for_atomic`/`current_state_packets` ; aucune route de ping dans les types et le corpus inspectés. |
| Commandes du monde | `crates/client/src/main.rs:1366` | Compétences, invocateurs, objets, déplacement et contrôle du pet ; aucune branche d’envoi de ping. Alt a déjà un emploi pour le pet d’Annie. V intervient aussi dans la saisie du magasin ; on ne déclare pas ces touches universellement inactives. |

La validation `terrain.ground(point)` appartient au déplacement `Move`. Elle ne doit pas être copiée automatiquement vers un ping : la légalité d’une position non marchable reste à qualifier. De même, la règle commune `Simulation::command` « champion dead » et la pause des commandes ne constituent pas une preuve de restriction native des pings.

Le constat ne dépend pas seulement du commentaire « unported », d’un répertoire absent ou d’un mot introuvable : les variantes typées et leurs points d’envoi, décodage, admission et sortie sont inspectés. Aucun chemin nominal de ping de position n’y est représenté.

## R4 — Attendu, observé et vérifications

**Exécuté dans ce lot : 171 contrôles documentaires réussis**, portant sur les critères, identités, champs originaux, corpus exact, consommateurs et conservation. Le lecteur indépendant ajoute sa décision dans `delivery-readback.json`. Ces contrôles n’exécutent ni le code Rust ni le client original.

| Cas | Attendu pour la fonctionnalité | Observé et portée de preuve |
|---|---|---|
| Ping ordinaire sur un point valide | Message de position explicite, admission et destinataires identifiés. | Chemin absent dans les types/traitements courants. Aucun ping nominal exécuté. |
| Clics existants de minimap | Conserver caméra et déplacement. | Source : intentions Camera/Move ; tests adjacents datés réutilisés. Aucun résultat de ping n’en découle. |
| Raccourcis originaux G / Alt+Button1 | Contrat de déclenchement chargé identifiable. | Lignes originales par défaut retrouvées ; aucun consommateur correspondant dans le corpus courant. Chargement natif non exécuté. |
| Point non fini/hors carte, contexte étranger ou ancien | Refus de ping selon contrat explicite. | Aucun payload/handler de ping ; les garde-fous du déplacement et de la session restent des acquis adjacents, pas des refus de ping vérifiés. |
| JSON artificiel d’un ping inconnu | Comportement réel du décodage documenté. | Lecture statique seulement : forme non représentable dans les enums ; après échec du décodage session, un pair interdisant legacy peut être ignoré ; un pair legacy connu peut recevoir « malformed or unsupported packet ». Aucun datagramme injecté, aucun refus spécifique promis. |
| Rafale, équipes, doublons, reconnexion, pause/mort | Politique historique ou adaptation locale déclarée et contrôles bornés. | Libellé Throttled présent ; budget et route d’événements absents. Les règles ne sont pas inventées. |

Quatre tests adjacents sont réutilisés parmi les **19 tests CPU** réussis le **23 octobre 2026 à 06:28:12 UTC**, code 0, journal vérifié :

1. `epoch_gate_resize_and_focus_loss_cancel_drag_without_later_replay` ;
2. `ordered_short_clicks_have_one_intent_and_block_underlying_world_for_the_frame` ;
3. `native_inverse_moves_only_to_actual_walkable_cells_without_nearest_substitution` ;
4. `actual_input_sends_one_move_keeps_self_cast_and_closes_on_connection_failure`.

Le dernier vérifie une émission UDP locale de **Move**, puis une commande de compétence et l’arrêt après défaillance contrôlée. Il ne qualifie pas un ping, son destinataire, un clic physique Windows ou le transport de ping sécurisé. Les dix fichiers épinglés par ce reçu ancien sont toujours identiques ; tous ses consommateurs transitifs ne sont pas épinglés. Les métadonnées du binaire ancien sont conservées, sans nouveau hachage ni nouvelle exécution.

**Non exécutés maintenant :** compilation ou tests Rust, jeu/client/serveur, trafic réseau, saisie OS, rendu GPU, lecture audio, processus natif, REA. Aucun cas de test de ping de position existant n’est revendiqué. Relancer les dix-neuf tests inchangés n’apporterait pas l’implémentation absente.

Les explorations ayant échoué sont conservées comme limites de méthode dans le reçu : premier motif trop large capturant « wrapping », lookbehind initial sans `rg -P`, chemins supposés `crates/protocol`/`crates/net` inexistants. Le motif corrigé et les vrais types `core/session_transport.rs` servent à la conclusion ; aucune absence n’est déduite des échecs d’outil.

## R5 — Écarts et conditions de reprise

Sept corrections proposées, statut **`proposed_not_applied`**, découpent la tâche existante. Elles ne sont ni ajoutées au registre normatif ni réalisées. Le reçu contient pour chacune objectif, manque, critères de fin, prérequis, preuve attendue et entrée de reprise.

| ID / objectif unique | Critère de fin et preuve attendue | Entrée nécessaire à la reprise / dépendances |
|---|---|---|
| **PING-POS-CONTRACT-01** — Contrat historique du ping ordinaire | Relier déclencheur, callback chargé, espace de coordonnées et limites ; qualifier les cas observables et conserver les inconnues serveur. Une simple ligne de binding ne suffit pas. | Callback/xref natif nommé, capture originale datée avec profil/carte/coordonnées ou paquet identifiable. Conserver la distinction défaut/surcharge et la graphie evnt. |
| **PING-POS-INPUT-01** — Un geste produit une seule intention de ping | Convertir un geste éligible minimap/monde dans le système réellement enregistré ; lier session/époque/fenêtre, annuler sur UI/focus/DPI/changement d’identité, éviter conflit caméra/Move et répétition de pression. Tests positifs et refus, contrôles existants conservés. | Politique de déclenchement/coordonnées qualifiée ou explicitement locale ; code actuel d’entrée. PING-POS-CONTRACT-01 ; MM-PROJECTION-01 pour la frontière de fidélité de projection. |
| **PING-POS-WIRE-01** — Payload de ping local explicite | Représentation typée, version, sérialisation/décodage bornés ; identité issue du contexte authentifié. Cas nominal, coordonnées invalides, types/versions inconnus et compatibilité/refus legacy explicites, sans journaux de credentials. | Intention définie, schéma fini et modèle de séquence/rejeu. Distinction explicite du protocole Riot ; PING-POS-INPUT-01 pour le producteur. |
| **PING-POS-ADMISSION-01** — Admission serveur d’un point valide | Produire un événement identifié selon carte/cycle de partie ; refuser les cas invalides/étrangers sans modifier navigation ou combat. Preuves serveur attendues/observées. | PING-POS-WIRE-01 ; politique explicite pour point, pause, mort et fin. Ne pas hériter sans justification des contraintes de Move ou de Simulation::command. |
| **PING-POS-THROTTLE-01** — Borner les rafales par émetteur | Budget/horloge sourcés ou politique locale déclarée ; seuil, expiration, refus, mémoire et reprise vérifiés. Cas avant/au/après seuil, deux joueurs, pause et reconnexion. | Callback/configuration/capture de cadence historique ou contrat local explicitement approuvé ; PING-POS-ADMISSION-01. Le libellé PingThrottled ne fournit aucun nombre. |
| **PING-POS-DELIVERY-01** — Livraison aux destinataires éligibles | Audience, identifiant d’événement, durée/file bornées, perte/doublon/réordre et fin d’époque explicites ; aucune résurrection d’une ancienne session. Observer émetteur, allié et ennemi. | Événement admis, preuve d’audience/durée ou politique locale documentée ; PING-POS-ADMISSION-01 et PING-POS-THROTTLE-01. Ne pas assimiler Heartbeat/ACK d’horloge à une livraison de ping. |
| **PING-POS-END-TO-END-01** — Parcours actuel geste→destinataire | Serveur et au moins deux clients locaux identifiés ; geste nominal, refus et limites de reconnexion observés ; pas de déplacement/cast parasite. Captures/traces des binaires et ressources courants, pas de promotion d’un test ancien en acceptation du jeu. | Entrée, payload, admission, rafales et livraison implémentés et vérifiés séparément ; session de test locale. Effets/sons historiques restent SYS-17.2-04. |

Ces fiches sont indépendantes quant à leur résultat vérifiable, avec les dépendances déclarées. Un payload peut être vérifié sans qualifier la fidélité du son ; une admission peut l’être sans déclarer toute l’interface terminée. Les inconnues historiques ne sont pas remplacées par une valeur plausible.

## R6 — Réutilisation et dimensions de clôture

- **SYS-17.2-03** reste le parent d’implémentation existant : aucun doublon de tâche ni changement de case.
- **SYS-17.2-04** conserve les variantes visuelles/audio et leurs propres critères ; ce lot ne les clôture pas.
- **MM-PROJECTION-01** conserve les écarts de contrôleur/projection déjà isolés par l’audit de minimap ; aucune nouvelle projection inventée.

| Dimension | Conclusion bornée |
|---|---|
| Audit | Les sept rubriques peuvent être clôturées pour l’exigence précise après succès de la relecture indépendante : les acquis et l’absence du chemin sont établis. |
| Implémentation | **Absente pour le ping de position dans le chemin inspecté** ; caméra, Move et transport général sont des acquis adjacents conservés. |
| Vérification | Source/documentation contrôlées ; tests adjacents hérités identifiés ; ping et parcours courant non exécutés. |
| Acceptation humaine | Aucune acceptation de fonctionnalité revendiquée. |

Restent ouverts la tâche, son inconnue d’origine, les sept corrections proposées et les clauses historiques non qualifiées. L’audit global SYS-01.2-02 et le jeu ne sont pas terminés. Le reçu principal garde `audit_scope_closed=false` ; seul le lecteur indépendant peut conclure sur la portée de ce lot, sans modification du goal ni conversion de statuts.

## R7 — Livrables, conservation et reprise reproductible

Nouveaux fichiers uniquement, tous liés à ce lot :

- `F:/OpenLeague-work/audit-units/AUD-17.2-03-POSITION-PING-01/audit-unit.json` : question, frontières et sorties fixées avant les conclusions ;
- `verify_ping.py` : lecteur documentaire isolé ; utilitaires copiés par AST du lecteur précédent, sans importer/exécuter son producteur ;
- `position-ping-proof.json` : critères, sources, recherches, fragments exacts, scénarios, corrections et conservation ;
- `F:/OpenLeague/docs/audit/units/AUD-17.2-03-POSITION-PING-01.md` : ce compte rendu ;
- `verify_delivery.py` et `delivery-readback.json` : relecture indépendante et décision bornée.

Identité du reçu principal : **33960325639bfbd7c601788b0edac3ba8912c6cbc4148496a96259fd3e1ede5b**. Date d’exécution documentaire : **2026-10-30T21:31:03.753549+00:00**. Les identités détaillées, commandes héritées et contrôles attendus/observés sont dans ce reçu ; sa date ne renouvelle pas les tests du 23 octobre.

La vérification constate la conservation des **19 fichiers logiciels gelés**, des **six documents de contexte/méthode** et des **cinq registres normatifs**. Git conserve HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, branche `main`, les 76 fichiers suivis déjà modifiés et leur état exact. Aucun ancien reçu, aucun fichier source produit et aucun état manuel remplacé ; aucune base ouverte, aucun serveur Plan démarré, aucune installation/migration/reprise de processus. Le goal et les critères de clôture restent inchangés.

Pour une relecture nécessaire après changement identifié, utiliser le Python existant avec `-X utf8 -E -B` et `verify_delivery.py --check-only` ; ce mode n’écrit pas de reçu. Ne pas réexécuter le producteur contre son reçu exclusif. Reprise fonctionnelle : choisir une correction ci-dessus et réunir son entrée précise. Prochain lot d’audit adjacent : **SYS-17.2-04**, variantes de ping, en réutilisant ces preuves d’absence d’envoi sans répéter les recherches inchangées.
