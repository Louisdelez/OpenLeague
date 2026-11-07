# AUD-17.5-01-CHAT-SCORE-ABSENCE-01

UTC : 2026-10-31T03:49:53.221989+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 ; inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Périmètre
Audit de quatre frontières absentes du frontend actuel : entrée/envoi chat, historique, focus chat, tableau de scores live. Les données/configurations et le tableau terminal existants sont conservés. Zéro contrôle courant de chat/tableau live ajouté au compteur : cinq déclarations natives d’entrée ne sont pas cinq contrôles implémentés. Audit documentaire à relire ; implémentation absente sur ces frontières, vérification statique/héritée, acceptation humaine non demandée. Parent et goal restent ouverts.

## R2 — Sources et preuves antérieures
Référence4.20.0.315 EUW/en_GB ; build2014-11-17 17:46:45, fuseau/déploiement non établis. Quatre audits clos score/team-global/history/focus sont repris avec leurs empreintes et lecteurs. La relecture focus-v2 est effective ; première relecture échouée et premier rapport restent conservés. Sa correction portait seulement sur la casse d’une phrase naturelle de reprise, pas sur les noms techniques ni les résultats natifs.

PE, Input.ini original,8fichiers chat/movie/AS2 et configuration historique,2movies scoreboard et8sources AS2 de colonnes sont identifiés dans la preuve.34cas d’analyse native isolée déjà conservés (21team-global,13focus) ne sont pas réexécutés ; certains s’arrêtent à une frontière de service/movie non résolue. Pas d’AS2,natif,REA,JPEXS,jeu ou réseau exécuté ici.

| Événement natif | Section | Valeur source |
|---|---|---|
| evtShowScoreBoard | GameEvents | [o] |
| evtChatHistory | GameEvents | [z] |
| evtToggleScoreboardGoldDisplay | GameEvents | [x] |
| evtHoldShowScoreBoard | HUDEvents | [Tab] |
| evtChatConsoleReturn | ChatEvents | [Return], [NumEnter] |

O et Tab sont des déclarations distinctes ; Return/NumEnter appartient à ChatEvents, pas une preuve qu’Entrée ouvre globalement le chat. Provider/priorité et permissions effectives inconnus. Les16/19API de scoreboard et lignes de démo ne fixent ni taille d’équipe,ni colonnes autorisées,ni variante réellement choisie.

## R3 — Consommateurs et états
native_zip_provider charge Chat.ini et main affiche Chat_bytes. Le protocole courant Input ne porte que Command/PauseRequest/ClockAck/Heartbeat/Leave ; Action porte le gameplay existant, aucun chemin chat fonctionnel n’a été identifié dans l’analyse bornée conservée. Le corpus1168 et ses consommateurs sont inchangés : réutilisation de recherche, pas nouvelle collecte globale de liens. Shop.focused/overlay existants dans commands ne constituent pas un focus chat.

RosterEntry expose identité/équipe/KDA ; Champion complet est filtré par vision selon son contrat actuel. Le texte HUDdebug affiche le joueur courant. match_results_ui affiche un résultat final figé après dismissed ; aucun de ces consommateurs n’est un tableau live interactif. Le chargement de movies ou d’une configuration ne donne pas de contrôle actif/désactivé/refusé utilisable.

| Frontière | Source native / limite | Actuel et état constaté | Reprise |
|---|---|---|---|
| CHAT-ENTRY-AND-SEND | ChatEvents Return/NumEnter declaration and AS2 entry/send callbacks; parser7A7260/service+78 unresolved | No playable chat field/open/send/close channel consumer in retained bounded1168-source analysis; Chat.ini loaded only ; Active/disabled/refused GUI states absent, not tested; no current request/ack to display | SYS-17.2-08 +SYS-17.4-07: named native or versioned local input/channel/recipient contract, explicit sender identity and actual frontend→host→recipient path |
| CHAT-HISTORY | AS2 default100 retained messages; pending queue capacity separate; hide timeout does not delete history | No current message history/display consumer; no provenance-to-live buffer binding ; Z declaration is not working history; no current scroll/clear/fade/retention UI states | SYS-17.2-09: bind authoritative event identity to finite history and specify current scope/session/capacity/visibility policy; source100not100screenlines |
| CHAT-FOCUS | Text focus,logicalE9,input98,movie4 and manager-current-receiver are distinct predicates; corrected v2 reader authoritative | Gameplay commands gate shop and other existing overlays, not chat focus ; No current chat-owned keyboard capture/release or suppression proof; shop editor is not substitute | SYS-17.4-08: explicit focused field + session/window owner and actual keyboard/combat conflict/refusal/close/reopen cases; preserve menu/SC4 release differences |
| LIVE-SCOREBOARD | O toggle/Tab hold/X gold declarations,16/19AS2 APIs, unknown native host disclosure/provider/variant | Public roster score and local diagnostic KDA exist; terminal result table exists; no ordinary live interactive scoreboard ; No current live show/hold/release/drag/mute/gold-toggle states to qualify; no renderer success inferred from roster | SCORE-LIVE-RENDER-01 +SCORE-HOST-COLUMNS-01 +SCORE-END-TO-END-01: typed public-column authority and distinct live UI lifecycle with source/recipient/context evidence |

Focus texte, flag logiqueE9, input générique98, présence movie4 et identité du récepteur courant sont distincts. E9 et le manager gardent deux méthodes virtuelles ; cela ne prouve pas toute la suppression combat. Menu/SC4 acquièrent le focus ; seule la source SC4 sélectionnée explicite sa libération à la fermeture. Préférence client all-chat/bit100 de branche ne sont ni permission serveur ni enum universel des canaux. La capacité de queue native est distincte de l’historique AS2 : défaut100messages retenus, pas100octets/caractères/lignes visibles ; timeout masque sans vider.

## R4 — Attendu et observé
Exécuté maintenant : lecture/empreintes/cohérence de sources et de preuves, table des déclarations natives et rattachement aux tâches. Les34cas natifs sont hérités ; aucun test natif relancé. Deux tests Rust hérités du tableau terminal sont retrouvés dans le journal code0 et reliés aux sources conservées ; ils prouvent leur propre périmètre, pas un chat ou scoreboard live. Zéro test d’acceptation des interfaces absentes. Aucun envoi de message, clipboard, clavier physique ou capture GUI.

| Cas | Attendu | Observé | Limite |
|---|---|---|---|
| C1 | Do not infer chat from loaded Chat.ini | startup_hud loads bytes and main logs size; existing source queries/corpus preserve no current chat control path. | Native assets/resource loader are not sender/recipient/UI. |
| C2 | Distinguish event declarations and their context | Input rows provide O/Tab/X/Z and Return/NumEnter; latter in ChatEvents context. | No global Enter-opens-chat or active keymap/permissions inferred; keys may have unrelated local uses. |
| C3 | Keep native low-level predicates distinct | 13focus native cases plus corrected reader retained; E9/current receiver gate two methods. | No whole-game combat suppression/native GUI or current chat input proved. |
| C4 | Client preference is not server admission/audience | 21retained isolated command/receive cases retain markedbit100 andprefix boundaries; unresolved parser/service stays open. | Not a universal channel enum,authenticated server routing or new network test. |
| C5 | Retained messages distinct from pending native buffer | Existing audit identifies default100 prepend/pop and hide-without-delete; config/8source files preserved. | Runtime capacity/precedence/session lifecycle and renderer unqualified. |
| C6 | Public roster fields do not imply live table controls | Roster id/champion/team/score has serde default; full player body visibility separate per old field matrix. | Not all native columns public; zero/absent legacy and retirement/last-known rules open. |
| C7 | Keep end-of-game table separate | Two retained terminal UI tests pass; result+View.dismissed controls visibility. | Adjacent terminal tests are zero chat/live-scoreboard acceptance tests. |
| C8 | Record absent states honestly | Four control-boundary comparisons explicitly say unimplemented/current GUI absent; no active/refused message invented. | Documentary closure only; original tasks,all-HUD census and goal remain open. |

## R5 — Manques et conditions de reprise
Manquent : champ de saisie/capture/libération, événements typés et autorité d’envoi, destinataires/canaux, historique et cycle de vue, tableau live et colonnes publiables, provider/bindings natifs effectifs. Le parser7A7260 et service+78 restent ouverts ; aucune permission/forme de wire n’est inventée. Déclarations O/Tab/X/Z/Return ne rendent pas ces touches universellement inertes dans les autres fonctions locales.

Reprise chat : contrat natif nommé ou politique locale versionnée, identité/canal/permissions explicités, puis une saisie réelle et un trajet frontend→host→destinataire avec nominal/refus/focus/session. Reprise histoire : capacité/identité/ordre/clear/timeout/session explicites en conservant sources100messages. Reprise score : choisir colonne et autorité/publique-vue, puis show/hold/release et retrait/session sans exploiter un acteur privé. Ne pas promouvoir le résultat terminal en scoreboard live. Aucune analyse native répétée sans nouvelle adresse/provider/trace discriminante.

## R6 — Corrections réutilisées
Cinq tâches réelles du registre sont réutilisées sans statut changé : SYS-17.2-06, SYS-17.2-08, SYS-17.2-09, SYS-17.4-07, SYS-17.4-08. Trois fiches précises existantes du score : SCORE-HOST-COLUMNS-01, SCORE-LIVE-RENDER-01, SCORE-END-TO-END-01. Leurs critères sont conservés dans la preuve, les tableaux ci-dessus fixent les clauses de reprise de cet objectif. Aucune nouvelle fiche dupliquée ni correction produit appliquée : les tâches/fiches nommées possèdent déjà ces objectifs.

Les quatre frontières sont auditées comme absences ; elles ne deviennent pas des contrôles implémentés ni des réussites fonctionnelles. Les76IDs courants documentés précédemment restent76 ; aucune hausse artificielle par5bindings/34cas natifs/2tests adjacents. Dénominateur HUD complet inconnu, aucun pourcentage. Reste : SYS-17.5-01 remains open: exhaustive control census and remaining options/inspection/recall/other controls; no denominator/percentage. Chat source work,focus/history and live score frontend implementation remain open in existing named tasks; no new duplicate correction needed. Native input/provider/column disclosure and actual frontend/host/recipient/GUI acceptance missing; unknowns preserved, no repeated broad search without new lead.

## R7 — Livraison et conservation
Nouveaux fichiers uniquement : audit-unit.json, verify_chat_score_absence.py, chat-score-absence-proof.json, verify_delivery.py, delivery-readback.json et ce rapport. Clôture documentaire du sous-lot après lecture séparée des sept rubriques ; producteur audit_scope_closed=false, parent_documentary_scope_closed=false ; fonctionnalité et goal non terminés.

Cinq registres normatifs,25fichiers protégés (19logiciels gelés +6documents),1168sources et état suivi Git conservés. Aucune modification du goal/des critères, du code produit, de Plan/UI/bases ; aucune base ouverte, installation/migration/restart, exécution native/Rust/jeu/réseau/GUI. Aucun écrasement des anciennes preuves ni retrait implicite.

Preuve : F:\OpenLeague-work\audit-units\AUD-17.5-01-CHAT-SCORE-ABSENCE-01\chat-score-absence-proof.json. Relecture : F:\OpenLeague-work\audit-units\AUD-17.5-01-CHAT-SCORE-ABSENCE-01\delivery-readback.json.
