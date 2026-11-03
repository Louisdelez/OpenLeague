# SYS-17.5-05 — revue de clôture de l’audit des refus

Unité `AUD-17.5-05-PARENT-CLOSURE-REVIEW-01` ; UTC 2026-11-01T12:09:42.750025+00:00 ; goal SYS-01.2-02, toujours actif.

Décision : audit de cette exigence terminé avec constats, sous réserve du reçu de relecture distincte `delivery-readback.json` et de son exécution code 0. Fonctionnalité partielle, confidentialité et rendu non qualifiés, acceptation humaine non revendiquée. Le statut normatif reste `a_faire`.

## 1. Contrat et périmètre
Afficher les motifs des commandes rejetées sans révéler d’état privé

Le résultat « Afficher les motifs des commandes rejetées sans révéler d’état privé » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.

La revue porte sur le code et les ressources identifiés, pas une recette complète de LoL. Préconditions D17-SYS-17-5 et ses quatre lots amont conservés. Les cinq sous-lots avaient laissé leur parent ouvert : leurs fichiers ne sont pas réécrits. La clôture présente vient de la confrontation de toutes les clauses, pas de leur nombre.

## 2. Référence historique
Fichier original : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\menu\fontconfig_en_GB.txt` ; SHA256 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3.
391 lignes de la recherche par préfixe sont des aliases/aides de chat et des diagnostics techniques, pas 391 cas de refus gameplay. La recherche de valeurs donne quatre lignes ; lecture adjacente : un cinquième libellé de refus et une invitation de ciblage.
- Ligne 12075 : `tr "game_spellcaststatus_cooldown" = "That spell is not ready yet!"`
- Ligne 12076 : `tr "game_spellcaststatus_disabled" = "You cannot cast that right now!"`
- Ligne 12077 : `tr "game_spellcaststatus_notlearned" = "You have not learned that spell yet!"`
- Ligne 12078 : `tr "game_spellcaststatus_outofmana" = "Not enough mana to cast that!"`
- Ligne 12079 : `tr "game_spelltargeting_invalid" = "Invalid target selected; select a valid target."`
- Ligne 12080 : `tr "game_spelltargeting_select" = "Select target(s)."`

Static original en_GB data, not evidence of the actually mounted file or the native dispatch/selection of this message.
Semantic candidates only: no native enum or current-code equivalence inferred from text.
Five refusal labels plus one targeting prompt do not inventory all historic refusals.
No inventory phrase match in the value query does not establish absence of inventory feedback.

18 familles de constructeurs natifs ne sont pas les 13 variantes Action courantes et ne sont pas toutes les commandes runtime. Aucune proportion de jeu complet ne s’en déduit.

## 3. Clauses, consommateurs et limites

### REFERENCE — source 4.20 ou contrat local explicitement identifié
Données en_GB : cinq libellés de refus et une invitation de ciblage ; commandes natives et pause réutilisées. Le contrat réel des producteurs Rust est identifié ; dispatch, sélection/montage natif et permissions historiques non qualifiés.
Aucun texte ne prouve la règle serveur de divulgation ou la parité de formulation.
Preuves : native_commands, channels, historical.

### PRODUCERS — motifs des commandes rejetées : producteurs réels
Attack, six arbres owner et quatre racines sorts, Move/Stop, ACK/pause, legacy Join et refus structurés sont reliés à leurs frontières Result et aux gardes. Treize variantes Action courantes sont un dénominateur local, pas toutes les commandes de LoL.
Frontières serde/IO, fautes non propagées, gardes défensives et atteignabilité demeurent identifiées, sans vocabulaire tiers complet ni preuve formelle.
Preuves : route, owner, spell, channels.

### DISPLAY — Afficher les motifs dans le consommateur réel
report conserve/logge le motif brut ; diagnostic F3 sous gardes, effacement sur état ready, pause avec retour générique ; six callers UI ordinaires et refus sans action examinés.
Canal normal, durée, localisation, persistance et recette visuelle ne sont pas qualifiés.
Preuves : route, channels, ui.

### ORIGIN-CORRELATION — ne pas confondre refus, statut et issue de commande
Refus structuré input sans nonce dirigé vers receiver handshake-only ; six étapes d’issue distinguées. Err et sent:false ne prouvent pas une non-livraison ; Ok local ne prouve pas une acceptation serveur.
Pas de panne réseau ou de branche défensive injectée ; corrélation et catégorie publique restent à décider et vérifier.
Preuves : channels, ui.

### PRIVATE-STATE — sans révéler d’état privé
Contexte et 512 octets ne sont pas une preuve de confidentialité. Témoin Attack, dix cas sorts, données owner/catalogue, DTO structurée et frontières de métadonnées sont distingués. Le motif conditionnel Trundle E contient un identifiant issu d’un recensement sans filtre de visibilité.
Différences conditionnelles de sources, pas une fuite observée ni une preuve globale de non-interférence. Public pour un client ne signifie pas publiable à tous.
Preuves : route, owner, spell, channels, ui.

### MISSING-COMMANDS — conserver la portée historique et les consommateurs absents
Dix-huit familles de constructions natives recensées statiquement ; pas tous les appels runtime. Absence délimitée de chat jouable et slash bindings constatée ; pause mécanique distincte. Réutiliser SYS-17.2-08/09 et SYS-17.4-07/08 ainsi que K1,K2, sans inventer un refus qui n’a pas de consommateur.
18 familles et 13 variantes Action ne sont pas comparables ; aucun pourcentage ou réduction implicite du jeu.
Preuves : native_commands, chat_absence, channels.

### EXPECTED-OBSERVED — succès, refus, limites et preuves réellement vérifiés
Correspondances exactes des fenêtres et sources, gardes, chemins nominaux/refus et décisions conditionnelles relues ; reçus producteur/lecteur acceptés de chacun des cinq lots.
Aucun nouveau test Rust, jeu natif, rendu, socket, panne ou cas de fuite ; traces héritées ne sont pas des exécutions fraîches.
Preuves : route, owner, spell, channels, ui, historical.

### CORRECTIONS — actions restantes uniques avec critères de fin et reprise
Six corrections existantes exactes conservées, chacune proposée non appliquée. Tâches chat déjà existantes conservées. Aucun nouveau doublon de correction.
Les dépendances à la tâche parente sont des liens d’origine et non un ordre exécutable de réalisation ; ne pas inventer un DAG ni une autorisation produit.
Preuves : route, spell, channels, ui, chat_absence.

### TRACEABILITY — livrable, source, preuves et inconnues reliés
Pointeurs de champs et empreintes, ancien échec lexical conservé, matrice des frontières et sept rubriques ; uniquement un ajout documentaire externe aux registres gelés.
Aucun statut normatif, case, note, goal, registre ou base modifié ; clôture documentaire distincte.
Preuves : route, owner, spell, channels, ui, historical.

## 4. Contrôles réellement exécutés / réutilisés
Contrôles présents : empreintes, tâche canonique, prérequis, correspondance des fenêtres au code, observations historiques, cohérence des pointeurs et critères. Les exécutions des cinq anciens producteurs et lecteurs sont héritées, non relancées.
- route : `F:\OpenLeague-work\audit-units\AUD-17.5-05-REJECTION-PRIVACY-01\rejection-privacy-proof.json` ; producteur 286 contrôles / code 0 ; lecteur 493 contrôles / code 0.
- owner : `F:\OpenLeague-work\audit-units\AUD-17.5-05-DELEGATED-REJECTIONS-01\delegated-rejections-proof.json` ; producteur 438 contrôles / code 0 ; lecteur 823 contrôles / code 0.
- spell : `F:\OpenLeague-work\audit-units\AUD-17.5-05-TARGETED-REJECTIONS-01\targeted-rejections-proof.json` ; producteur 622 contrôles / code 0 ; lecteur 1181 contrôles / code 0.
- channels : `F:\OpenLeague-work\audit-units\AUD-17.5-05-REMAINING-REJECTION-CHANNELS-01\remaining-channels-proof.json` ; producteur 503 contrôles / code 0 ; lecteur 745 contrôles / code 0.
- ui : `F:\OpenLeague-work\audit-units\AUD-17.5-05-CURRENT-UI-REJECTIONS-01\current-ui-rejections-proof.json` ; producteur 505 contrôles / code 0 ; lecteur 739 contrôles / code 0.

Échec documentaire antérieur conservé : premier producteur des sorts code 1 (prédicat lexical InvalidPoint/Point), puis v2 acceptée code 0. Ce n’est pas un défaut du jeu. Les anciens lots commandes/chat n’ont pas de reçu autonome fourni ; aucun code 0 ne leur est fabriqué.
Non exécutés ici : jeu, Rust, GUI, rendu, socket, panne, fuite, émulation logique originale, REA, nouvel export ou désassemblage.

## 5. Frontières anciennes et manques restants
- `REJECTION-DELEGATED-TREES` : source_audit_frontier_resolved ; owner, spell, channels, ui.
- `REJECTION-DISCLOSURE-CONTRACT` : implementation_verification_or_historical_policy_open ; entrée et reprise originales conservées.
- `REJECTION-PLAYER-PRESENTATION` : implementation_verification_or_historical_policy_open ; entrée et reprise originales conservées.
- `DELEGATED-TARGETED-TREES` : source_audit_frontier_resolved ; spell.
- `DELEGATED-NATIVE-AND-PRESENTATION` : implementation_verification_or_historical_policy_open ; entrée et reprise originales conservées.
- `SPELL-PUBLIC-DISCLOSURE-POLICY` : implementation_verification_or_historical_policy_open ; entrée et reprise originales conservées.
- `SPELL-RUNTIME-AND-FAULTS` : implementation_verification_or_historical_policy_open ; entrée et reprise originales conservées.
- `OTHER-REJECTION-CHANNELS` : source_audit_frontier_resolved ; channels, ui.
- `CHANNEL-NATIVE-POLICY` : implementation_verification_or_historical_policy_open ; entrée et reprise originales conservées.
- `CHANNEL-INPUT-ROUTING` : implementation_verification_or_historical_policy_open ; entrée et reprise originales conservées.
- `CHANNEL-LOCAL-UI-REFUSALS` : source_audit_frontier_resolved ; ui.
- `UI-NORMAL-FEEDBACK-POLICY` : implementation_verification_or_historical_policy_open ; entrée et reprise originales conservées.
- `UI-SEND-OUTCOME-UNCERTAINTY` : implementation_verification_or_historical_policy_open ; entrée et reprise originales conservées.
- `UI-PARENT-AUDIT-COVERAGE` : source_audit_frontier_resolved ; this_review.

### HISTORICAL-DISCLOSURE
Règle 4.20 de choix, permissions et projection des motifs ; dispatch/montage effectif des textes non qualifiés.
Reprise : Nouvelle piste native précise ou observation historique identifiée ; à défaut, politique locale versionnée explicitement admise. Réutiliser libellés et commandes acquis, sans recherche générale répétée.

### PUBLIC-REASONS
Décisions publiques Attack et dix cas sorts, dont refus Trundle E contenant un identifiant ; aucune fuite réseau observée ni non-interférence prouvée.
Reprise : Reprendre les trois corrections de divulgation avec état public de référence et paire atteignable ; produit/exécution seulement sous périmètre distinct autorisé.

### NORMAL-PLAYER-FEEDBACK
Canal normal, traduction, retrait et corrélation ; refus d’entrée routé comme handshake et étapes d’envoi/traces à qualifier.
Reprise : Reprendre les trois corrections présentation, routage et issue d’envoi avec contrat explicite, puis vrai consumer, nominal/refus/ancien/étranger et captures/réseau adaptés.

### ABSENT-HISTORICAL-CONSUMERS
Chat jouable, historique et bindings de commandes/focus manquent dans les recherches délimitées héritées.
Reprise : SYS-17.2-08/09, SYS-17.4-07/08 et K1,K2 existants ; contrat d’identité/canal/permissions et chemin frontend→host→destinataire. Ne pas créer de doublon.

### RUNTIME-PRIVACY-ACCEPTANCE
Rendu réel, livraison/acceptation, fautes et non-interférence non vérifiés ; atteignabilité de toutes les branches défensives non établie.
Reprise : Cas admis, build/assets/état public nommés et autorisation distincte du produit ; séparer source, exécution native, Rust/réseau, rendu et acceptation humaine.

## 6. Corrections existantes exactes — non appliquées
Aucun nouvel ID : les six définitions originales sont conservées dans la preuve, avec leur champ source. Leurs dépendances au parent identifient leur origine, sans prétendre fournir un ordre exécutable.

### HUD-ATTACK-REJECTION-DISCLOSURE-01
Qualifier la divulgation du motif de refus pour la seule commande Attack.
Critère original : Pour deux états ne différant que par une cible non publique absente/résolue invisible, la réponse publique suit le contrat choisi sans oracle. Cible publique valide/invalide, contexte étranger et limite de message restent vérifiés. Source, état public et décisions comparées sont nommés.
Reprise originale : Contrat de divulgation 4.20 ou politique locale explicitement admise, scénarios appariés correspondant au témoin conditionnel, puis autorisation produit distincte.
Source : `F:\OpenLeague-work\audit-units\AUD-17.5-05-REJECTION-PRIVACY-01\rejection-privacy-proof.json` /new_proposed_corrections/0.

### HUD-REJECTION-PRESENTATION-01
Qualifier un canal normal de retour de refus de commande.
Critère original : Un refus public identifié est lisible dans le contexte attendu sans F3 selon contrat ; une réponse étrangère/ancienne et un changement de contexte ne réaffichent pas un motif périmé ; effacement et succès sont explicitement vérifiés.
Reprise originale : Politique de présentation native ou locale nommée et motif public qualifié, puis autorisation produit distincte.
Source : `F:\OpenLeague-work\audit-units\AUD-17.5-05-REJECTION-PRIVACY-01\rejection-privacy-proof.json` /new_proposed_corrections/1.

### HUD-SPELL-REJECTION-DISCLOSURE-CONTRACT-01
Définir la projection publique des motifs pour les quatre routes de sorts auditées.
Critère original : Les dix cas nommés ont une décision source/politique et une catégorie publiable ou un refus explicite de qualification ; chaque inconnue restante a son entrée précise. Le contrat sépare détails internes et motif reçu/loggé côté client,sans permission native inventée.
Reprise originale : Source historique précise de divulgation,ou politique locale explicitement admise ; ne pas refaire une recherche générale sans piste nouvelle.
Source : `F:\OpenLeague-work\audit-units\AUD-17.5-05-TARGETED-REJECTIONS-01\targeted-rejections-proof.json` /new_proposed_corrections/0.

### HUD-TRUNDLE-E-PUSH-REJECTION-DISCLOSURE-01
Qualifier et corriger si nécessaire le motif de poussée refusée du pilier Trundle E.
Critère original : Sur la paire admise contenant une unité non publique touchée par un segment invalide,le motif public et les logs accessibles au client ne divulguent pas son identifiant selon le contrat ; nominal,cible déjà publique,ancien/étranger et récupération vérifiés séparément.
Reprise originale : Politique de divulgation et scénario atteignable précis ; travail produit et exécution autorisés séparément.
Source : `F:\OpenLeague-work\audit-units\AUD-17.5-05-TARGETED-REJECTIONS-01\targeted-rejections-proof.json` /new_proposed_corrections/1.

### HUD-SESSION-INPUT-REJECTION-ROUTE-01
Qualifier le routage d’un refus structuré d’entrée après admission.
Critère original : Un rejet d’entrée authentifiée courante suit le canal et le motif admis ;réponse étrangère/ancienne,handshake en attente et absence de handshake restent séparés et testés. Aucun secret/contexte étranger affiché par assouplissement de la validation.
Reprise originale : Contrat local ou source de politique de retour nommée,contexte et corrélation de refus définis ;travail produit/exécution autorisés séparément.
Source : `F:\OpenLeague-work\audit-units\AUD-17.5-05-REMAINING-REJECTION-CHANNELS-01\remaining-channels-proof.json` /new_proposed_corrections/0.

### HUD-COMMAND-SEND-OUTCOME-01
Qualifier les issues de l’API ordinaire d’envoi et leur traduction en traces/feedback.
Critère original : Pré-envoi,tentative,retour de métadonnées et réponse serveur sont distingués pour les deux modes ;les traces ne prétendent pas prouver une non-livraison depuis Err. Tout cas de branche défensive non atteignable reste marqué comme tel. Nominal,refus local,erreur d’envoi,contexte ancien et réponse serveur sont vérifiés au bon niveau lors de l’intervention produit.
Reprise originale : Contrat local d’issue et de présentation explicitement admis,puis autorisation produit/exécution distincte ;réutiliser les sources/API identifiées.
Source : `F:\OpenLeague-work\audit-units\AUD-17.5-05-CURRENT-UI-REJECTIONS-01\current-ui-rejections-proof.json` /new_proposed_corrections/0.

Tâches chat réutilisées : SYS-17.2-08/09 et SYS-17.4-07/08, corrections K1,K2 déjà présentes. Pas de correction doublonnée pour une absence déjà recensée.

## 7. Relecture et décision documentaire
- Rubrique 1 : Exigence, prérequis et portée historique/courante distinctes ; neuf clauses confrontées.
- Rubrique 2 : Original en_GB et sources historiques héritées identifiées ; données ne qualifient pas dispatch, montage ou politique. Manque et reprise explicites.
- Rubrique 3 : Producteurs et UI réels identifiés ; absence chat/slash bornée et reproductible héritée.
- Rubrique 4 : Contrôles de source et cinq reçus réels réutilisés ; aucune nouvelle exécution produit, réseau ou rendu.
- Rubrique 5 : Quatorze frontières anciennes traitées ; cinq catégories historiques/produit/vérification encore ouvertes avec entrée de reprise.
- Rubrique 6 : Six corrections exactes et tâches chat réutilisées ; aucun nouveau doublon nécessaire. Aucune correction exécutée.
- Rubrique 7 : Fichiers datés, pin et pointeurs ; producteur puis lecteur distinct. Statuts antérieurs conservés, aucune agrégation en pourcentage.

Chaque clause a une source/absence bornée, un comportement ou une inconnue explicite et une reprise ; les entrées produit manquantes sont des conclusions d’audit, pas des clauses laissées inexplorées. La charte permet de clore cet audit sans réaliser la fonctionnalité.
Les inconnues de politique historique et les travaux produit restent ouverts ; aucune clause d’audit non examinée n’a été identifiée après confrontation. Une nouvelle source ou évolution du corpus justifiera une réouverture ciblée.

Livrables ajoutés : ce rapport et le dossier `F:\OpenLeague-work\audit-units\AUD-17.5-05-PARENT-CLOSURE-REVIEW-01` (spécification, entrées, recherches déjà exécutées conservées, producteur, preuve, lecteur et reçus). Tous les fichiers préexistants sont conservés. Aucun goal, critère normatif, code produit, registre, Plan ou base modifié.

Prochain petit lot : `AUD-17.5-06-TEXT-FOCUS-BASELINE-01` pour SYS-17.5-06 ; inventaire de preuves lisibilité/focus/débordement avant un cas nouveau. Pas d’arrêt conditionné à la réalisation de toutes les corrections de ce parent.
