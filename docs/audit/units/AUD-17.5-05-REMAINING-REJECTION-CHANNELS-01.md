# AUD-17.5-05-REMAINING-REJECTION-CHANNELS-01

## Résultat et frontière

SYS-17.5-05 : sources des canaux restants Move/Stop,pause/ACK,session structurée et legacy raccordées jusqu’au traitement client. **Sous-audit de sources prêt pour relecture ; fonctionnalité et confidentialité globale non terminées.** Les non-envois locaux/UI restent un lot distinct à poursuivre.

Audit,implémentation,vérification réseau/rendu et acceptation humaine sont indépendants. Aucun paquet,serveur,client,Rust,AS,GUI ou calcul original exécuté/émulé.

## Référence,prérequis et preuves héritées

Tâche et quatre prérequis D17-SYS-17-5conservés ouverts. Dix délégations de command déjà auditées,refus Attack,stockage/log et F3 réutilisés. L’audit session/pause conserve son reçu de relecture et les limites de ses anciens contrôles ; aucun programme antérieur relancé ni ancien code0 inventé.

La référence4.20 A1/0A et les notices localisées d’envoi pause/resume ne prouvent pas la politique serveur de permissions ou de divulgation. La ressource de spawn embarquée et la frontière serde_json sont identifiées ; leurs Display ne deviennent pas des motifs natifs récupérés.

## Formes et producteurs réels

Source courante :13Action,5ClientPacket legacy,4ServerPacket legacy et12RejectionCode structurés. La recherche incrémentale des fabriques legacy/gameplay recense8sites de production (7legacy,1GameplayRejection) et2hits de tests séparés. Les fabriques SessionRejected du Host et le fallback Unavailable sont raccordés séparément.

Un refus structuré de session contient code,nonce optionnel et Context optionnel ;aucun String libre ni Secret32dans ce DTO. StaleEpoch est le seul mapping inspecté qui fournit current ;son producteur recherche la clé de récupération avant ce retour. Le constat ne prouve ni constant-time ni sûreté cryptographique/opérationnelle globale.

## Matrice des canaux

### MOVE-STOP

Producteur : Bound actor state and dynamic path Option become fixed Strings;windup error propagated.

Récepteur : GameplayRejection or legacy Rejected depending actual transport;known generic client route reused.

Attendu/observé dans le code : Move rejects casting ultimate/unreachable destination/noncancelable windup;Stop rejects uncancellable ultimate/windup. Source checks only.

Limite : Path feedback can depend on active pillars. Public collision/feedback policy and actual runtime behavior remain unqualified.

### SECURE-PAUSE

Producteur : Mode bool/match final/pause state and aggregate delivery capacity select fixed reasons.

Récepteur : Accepted input semantic error is SessionGameplayRejected with accepted context and sequence.

Attendu/observé dans le code : allow_pause false and finished match return named reasons;pause controller can reject already/not paused,budget,resume scheduled or delivery full.

Limite : Native mode/role permission is not recovered. Delivery pressure is aggregate state,not formal privacy proof.

### SECURE-ACK

Producteur : Registry/PreparedAck rejects before commit via structured SessionRejected;later delivery failure has gameplay String route.

Récepteur : Preflight code rejection uses nonce None;post-acceptance error uses gameplay context/sequence.

Attendu/observé dans le code : Invalid ordinal preflight versus delivery acknowledge are different stages. A duplicate already-acked delivery ordinal returns Ok;no runtime reachability claim for every later error.

Limite : Codes/strings contain no actual ordinal value on these inspected failure branches;capability/security and network delivery not operationally verified.

### STRUCTURED-SESSION

Producteur : Internal registry variants project to twelve wire codes;only StaleEpoch carries current Context,after recovery-key lookup in its producer.

Récepteur : Client.rejection accepts only matching pending handshake nonce;Busy waits,StaleEpoch/ReplayExpired recover,others set generic failure status.

Attendu/observé dans le code : An active ready client has no pending handshake. An input rejection produced with nonce None reaches unsolicited handshake rejection,not a normal matching command reason.

Limite : No raw free-text code/secret in this DTO;this does not prove formal secrecy,constant-time comparison or original4.20policy.

### INTERNAL-TRANSPORT

Producteur : Host static internal failures are server-log details;outer main emits Unavailable with no Context.

Récepteur : Typed handshake handling or generic decoding error;not raw host internal reason text on the rejection wire.

Attendu/observé dans le code : Explicit static failure projection retained;no packet,allocation fault or server process executed.

Limite : Server logs and client diagnostics are distinct surfaces. Full OS/IO-fault UX is outside this finite source lot.

### LEGACY-ACK

Producteur : Matching peer/session ACK error is eprintln only;foreign/unknown ACK is ignored.

Récepteur : No ServerPacket::Rejected is constructed in that arm;do not claim a visible player notification.

Attendu/observé dans le code : Source arm ends continue after log. No fresh ACK test or delivery executed.

Limite : Legacy transport is a separate local mode,not historical wire parity or authenticated secure-session proof.

### LEGACY-ACTION-AND-PAUSE

Producteur : Fresh connected legacy Command forwards game.command String;PauseRequest forwards local host/controller reason.

Récepteur : Legacy reason.len()<=512 yields Incoming::Rejected,then known report/F3/pause-specific handling.

Attendu/observé dans le code : Previously securely admitted peers cannot use this path. Old sequence/unknown peer is silently ignored by these branches.

Limite : 512counts String bytes,not a content privacy projection;the same target-dependent Strings audited previously remain relevant.

### LEGACY-JOIN-LEAVE-MALFORMED

Producteur : Seven legacy rejection construction sites cover malformed admitted peer,departure limits,pause,closing/admission,join Result and Command.

Récepteur : Same bounded legacy String path. Join may include embedded spawn JSON parse/Point-conversion Display;secure join masks game join errors as InvalidRequest instead.

Attendu/observé dans le code : Duplicate summoner,unknown champion/full lobby/spawn failure and local participant/departure limit roots are identified.

Limite : Build-data diagnostics and admission capacity are not a guarantee of native wording or all local UI/non-send refusals.

## Écart de routage après admission

SESSION-INPUT-REJECTION-HANDSHAKE-ONLY : le serveur rejette prepare_input ou PreparedAck avec rejected(None,error),donc sans nonce de handshake. Client.rejection ne traite que JoinResumable/Resume/ContextQuery en attente et exige leur nonce. ready() exige pending=None : ce refus peut donc devenir le diagnostic fixe « unsolicited handshake rejection ». Une réponse à nonce discordant devient « stale handshake rejection ». Aucun parcours réseau ou écran défaillant n’a été exécuté.

Le récepteur de datagrammes transmet ces erreurs à connection.report ;F3/log/effacement sont les chemins déjà qualifiés. Les codes terminaux de handshake deviennent un statut générique de reconnexion ;Busy attend,StaleEpoch/ReplayExpired réamorcent la récupération. Ne pas présenter tous les codes comme des motifs de commande visibles.

## Correction proposée,non appliquée

HUD-SESSION-INPUT-REJECTION-ROUTE-01 — Qualifier le routage d’un refus structuré d’entrée après admission.

Écart : Le producteur envoie SessionRejected sans nonce de handshake,puis le client utilise le seul récepteur de refus de handshake ;un client ready obtient un diagnostic générique unsolicited plutôt que le motif de commande corrélé.

Travail : Distinguer le rejet d’entrée du refus de connexion,avec contrat de contexte/corrélation et projection publique décidés. Conserver le rejet des réponses de handshake étrangères/anciennes ; ne pas simplement supprimer leur garde de nonce.

Fin : Un rejet d’entrée authentifiée courante suit le canal et le motif admis ;réponse étrangère/ancienne,handshake en attente et absence de handshake restent séparés et testés. Aucun secret/contexte étranger affiché par assouplissement de la validation.

Reprise : Contrat local ou source de politique de retour nommée,contexte et corrélation de refus définis ;travail produit/exécution autorisés séparément.

Les corrections Attack-only,présentation utilisateur,contrat de divulgation des sorts et Trundle E restent inchangées dans les preuves précédentes. Cette correction traite le routage avant l’UI ;elle ne remplace pas ces travaux.

## Manques et reprise

- **CHANNEL-NATIVE-POLICY** — La référence native réutilisée qualifie des champs A1/0A et notices d’envoi ;elle ne qualifie ni les permissions serveur historiques ni la divulgation des motifs. Reprise : Source/observation historique précise ou politique locale versionnée explicitement admise. Réutiliser les gaps/corrections existants sans refaire de recherche générale inchangée.

- **CHANNEL-INPUT-ROUTING** — Refus d’entrée sans nonce et receiver handshake-only sont raccordés ;le contrat produit de corrélation et de retour au joueur reste à choisir/vérifier. Reprise : HUD-SESSION-INPUT-REJECTION-ROUTE-01,avec contexte et projection publique définis,puis autorisation produit distincte.

- **CHANNEL-LOCAL-UI-REFUSALS** — Les non-envois locaux,erreurs send_action/commandes et leur présentation propre à chaque consumer UI ne sont pas intégralement audités ici. Les erreurs de transport/rendu et la confidentialité globale ne sont pas vérifiées en exécution. Reprise : Prochain lot sur les non-envois/diagnostics UI,à partir des locators main1444/1448/1458/1500 et des contrôles HUD déjà audités,sans refaire les dix délégations ou les fabriques réseau.

## Livrables et contrôles

Nouveaux fichiers uniquement sous F:/OpenLeague-work/audit-units/AUD-17.5-05-REMAINING-REJECTION-CHANNELS-01/ et ce rapport.30fenêtres actuelles et5fenêtres d’affichage/réception héritées sont vérifiées ;queries exactes archivées,classification production/tests,forme des DTO,gardes et18invariants contrôlés. Producteur puis lecteur distinct : codes et comptes effectifs dans producer-execution.json et reader-execution.json.

Cinq registres,25fichiers protégés et1168sources comparés avant/après ;modifications Git antérieures conservées. Aucun goal,critère normatif,code produit,application,Plan,UI,registre ou base modifié. Aucune installation,migration,reprise d’application,source native nouvelle,exécution produit,émulation ou ancien test/query/lecteur rejoué.

Après lecteur : ce sous-audit documentaire seulement. SYS-17.5-05et le goal restent ouverts. Prochain lot : AUD-17.5-05-CURRENT-UI-REJECTIONS-01.
