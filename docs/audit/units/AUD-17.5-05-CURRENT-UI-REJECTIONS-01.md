# AUD-17.5-05-CURRENT-UI-REJECTIONS-01

## Résultat et portée

SYS-17.5-05 : les six callers ordinaires des API nommées sont audités côté sources : clavier/souris,apprentissage,inventaire,minimap,boutique,pause. Leurs gardes et retours ne sont pas une même catégorie de refus. **Inventaire courant prêt pour relecture ; aucun parcours GUI/UDP ou achèvement fonctionnel revendiqué.**

Audit,implémentation,vérification technique et acceptation humaine restent distincts. Goal,critères normatifs,logiciel,suivi et bases inchangés.

## Preuves et population

Tâche et quatre prérequis D17-SYS-17-5conservés ouverts. Audits apprentissage,inventaire,minimap,boutique,pause réutilisés avec empreintes,observations et limites ;pas de test ni reader ancien rejoué,aucun ancien reçu code0 inventé. Les canaux serveur et le diagnostic F3 proviennent des lots de refus déjà acceptés.

Query client/src :22hits =6callers UI,3probes optionnels,4lignes API/délégation,9lignes de tests. Query de dépendances :2définitions. Contrôle incrémental des constructions directes :29lignes,dont2constructeurs API ordinaires,22lignes de tests/gates,3définitions de métadonnées,1garde de disponibilité et1définition de sélection. Les probes sont activés par environnement ;ils ne deviennent pas des gestes humains ou une recette du jeu.

## Callers et feedback réel

### MAIN

Garde/non-envoi : Input/UI/ready/terminal gates,missing cursor/camera/ray/floor can return without an Action. Minimap-covered targeted intent reports a fixed local target prompt.

Erreur d’envoi : Returned error goes to connection.report.

Présentation : Known common F3/log/session-status path;the debug label says Serveur even for a locally produced prompt/error.

Limite : Silence on a gate or absent gesture is not automatically an authoritative server rejection or an established UX defect.

### LEARNING

Garde/non-envoi : Pointer/UI/ready gate and action_at eligibility/bounds Option can omit an Action;eligible error is discarded to None.

Erreur d’envoi : This handler eprintln logs the returned error and does not call connection.report itself.

Présentation : Success records public packet metadata. Shared API may independently switch to recovery/status on transport error.

Limite : Do not claim an absence of every client message from the eprintln branch alone;native feedback policy and actual reachability remain unqualified.

### INVENTORY

Garde/non-envoi : Ordered capture/identity/geometry gates are retained from the drag audit;gesture is consumed,not automatically resent by this handler.

Erreur d’envoi : Returned error is reported;optional trace encodes it as sent:false.

Présentation : Common report plus opt-in diagnostic trace.

Limite : sent:false is an API Err label,not proof that the server received no datagram or rejected the swap.

### MINIMAP

Garde/non-envoi : Bad inverse/nonwalkable ground skips a Move locally. Camera intents are local camera controls,not server Move rejections.

Erreur d’envoi : Move send error is reported and breaks this intent loop.

Présentation : Common report;camera-control errors have their separate console path.

Limite : A nonwalkable skipped intent is distinct from an authoritative unreachable/dead/stunned refusal.

### SHOP

Garde/non-envoi : Closed/not-ready/no selected player/item/quote/affordability/stale inventory can yield selected_action None.

Erreur d’envoi : Returned error goes to report;the handler clears search focus before sending.

Présentation : Button/selection states from the existing shop audit and common diagnostic;no normal refusal notification inferred.

Limite : The quote Option removes local reason detail. Whether a disabled/no-op action should display a message needs the admitted UI policy.

### PAUSE

Garde/non-envoi : Unavailable identity/time or pending/resuming state can refuse locally without a send.

Erreur d’envoi : Tracked-send Err becomes Feedback::Unavailable;pending sequence recorded only on Ok.

Présentation : Dedicated label uses generic unavailable/timeout/no resend wording;authoritative rejection correlation from prior pause audit remains distinct.

Limite : The generic non-sent label does not itself prove network non-delivery for every post-attempt failure.

## Étapes à ne pas confondre

- **NO-ACTION** — No Action chosen or local input gate;not a wire outcome.

- **PRE-SEND-ERROR** — Readiness/sequence/serialization can fail before the datagram attempt. Actual failure-stage reachability is not exercised.

- **ATTEMPT-UNCERTAIN** — A datagram call has been attempted. The API error alone is not an authoritative server rejection or non-delivery proof;sequence may already be consumed.

- **POST-SEND-METADATA-BRANCH** — Legacy serde_json::to_value is after successful datagram. Its error branch exists in source;reachability for current Action types is not established or simulated.

- **LOCAL-OK-METADATA** — API Ok returns local/public-for-this-client metadata,not server acceptance or global public disclosure authorization.

- **AUTHORITATIVE-REJECTION** — Only the previously audited matching server response identifies an authoritative refusal;UI presentation/correlation/privacy work remains open.

Le source send_action consomme la séquence avant la tentative dans les deux modes. En legacy,la conversion de métadonnées vient après datagram ;sa branche Err est présente,mais son atteignabilité pour les types Action courants n’est pas démontrée. Le code secure peut activer recovery/status lorsqu’un datagram échoue. Le handler apprentissage ne relaie pas lui-même son Err à report,mais cela ne prouve pas qu’aucun statut partagé ne puisse changer.

Les métadonnées public_log omettent les clés transport ;elles restent celles de ce client et ne prouvent pas que tous les inputs puissent être diffusés à tous les joueurs. Un Ok local ne signifie pas acceptation serveur. Le Serveur du diagnostic F3 peut aussi contenir un prompt ou une erreur locale.

## Précision de preuve

HUD-SEND-TRACE-ERR-SEMANTICS-01 : sent:false dans la trace inventaire étiquette Result::Err. Ce champ seul ne prouve ni absence de datagramme côté noyau/serveur,ni refus autoritaire. L’avertissement existe déjà dans le commentaire source. Aucune erreur physique injectée ou non-livraison observée ;anciens fichiers et critères conservés.

Le probe six distingue son rejet préalable d’admission de l’Err de send(action),qui est propagé ;ne pas lui attribuer à tort le même réseau-non-envoyé pour tout Err API.

## Corrections et notes conservées

HUD-REJECTION-PRESENTATION-01 est réutilisé sans changer sa définition ni ses critères. Notes d’exécution : relier chaque caller au canal normal choisi,qualifier les silences selon la politique de geste,et séparer origine locale/serveur,durée et contexte.

HUD-COMMAND-SEND-OUTCOME-01 — Qualifier les issues de l’API ordinaire d’envoi et leur traduction en traces/feedback.

Écart : Result<Value,String> et sent:false confondent le résultat local avec les étapes possibles de soumission ;un échec après tentative ne prouve pas un refus serveur ou une absence de livraison.

Travail : Définir le contrat des six étapes source nommées ici,puis faire porter au résultat/trace la provenance et l’incertitude admises. Conserver les séquences consommées et l’absence de renvoi automatique ;ne pas inventer une acceptation serveur depuis Ok.

Fin : Pré-envoi,tentative,retour de métadonnées et réponse serveur sont distingués pour les deux modes ;les traces ne prétendent pas prouver une non-livraison depuis Err. Tout cas de branche défensive non atteignable reste marqué comme tel. Nominal,refus local,erreur d’envoi,contexte ancien et réponse serveur sont vérifiés au bon niveau lors de l’intervention produit.

Reprise : Contrat local d’issue et de présentation explicitement admis,puis autorisation produit/exécution distincte ;réutiliser les sources/API identifiées.

Proposition documentaire seulement,non appliquée. Les corrections de confidentialité des refus serveur et de routage post-admission restent indépendantes et conservées.

## Manques et reprise

- **UI-NORMAL-FEEDBACK-POLICY** — Canal normal,visibilité du motif et comportement des gardes silencieuses restent à décider/qualifier face au contrat natif ou local. Les six handlers sont identifiés,aucune absence totale de feedback ou panne graphique n’est démontrée. Reprise : Réutiliser HUD-REJECTION-PRESENTATION-01 et les notes nominatives ;choisir des cas admis et vérifier le vrai canal sous autorisation produit séparée.

- **UI-SEND-OUTCOME-UNCERTAINTY** — Aucune livraison UDP,acceptation serveur,atteignabilité de chaque branche de métadonnées ou non-interférence globale n’a été exécutée/vérifiée. Reprise : HUD-COMMAND-SEND-OUTCOME-01 avec étapes et politique explicites ;les labels historiques restent conservés et ne sont pas une preuve physique.

- **UI-PARENT-AUDIT-COVERAGE** — Ce sous-audit ne décide pas à lui seul si toute la portée de SYS-17.5-05est auditée :les sources natives manquantes et les clauses des lots précédents doivent être réunies et comparées au contrat complet. Reprise : Revue de clôture documentaire du parent à partir des cinq lots de refus et des contrôles hérités ;ne pas substituer la fin d’implémentation à la fin d’audit ni déclarer la confidentialité du jeu qualifiée.

## Livrables et contrôles

Nouveaux fichiers uniquement sous F:/OpenLeague-work/audit-units/AUD-17.5-05-CURRENT-UI-REJECTIONS-01/ et ce rapport.25fenêtres et5fenêtres d’affichage héritées,14invariants,receipts et classes de callers vérifiés par producteur puis lecteur distinct. Codes/comptes réellement obtenus dans producer-execution.json et reader-execution.json.

Cinq registres,25fichiers protégés et1168sources comparés avant/après ;modifications Git antérieures conservées. Aucune installation,migration,reprise d’application,exécution originale/AS/Rust/GUI/réseau,émulation,source exportée ou ancienne query/test/reader rejoué.

Clôture de ce sous-audit seulement après lecteur. Le parent SYS-17.5-05et le goal restent ouverts. Prochain lot : AUD-17.5-05-PARENT-CLOSURE-REVIEW-01.
