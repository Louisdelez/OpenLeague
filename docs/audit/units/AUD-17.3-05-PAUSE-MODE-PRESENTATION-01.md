# AUD-17.3-05-PAUSE-MODE-PRESENTATION-01 — Présentation de la pause selon le mode

Contrôle documentaire du 2026-10-31, projet F:\OpenLeague, goal parent SYS-01.2-02. Tâche SYS-17.3-05 : « Afficher la pause uniquement dans les modes qui l’autorisent ». Exigence OLF-b5c361dd-09fd-5580-81b6-a753cf6af42c ; inconnue OLU-2a42f895-f3fd-5921-befe-af1213bce54f. Référence LoL4.20.0.315 PUBLIC/Releases/4.20, EUW/en_GB ; catalogue4.20.1 distinct.

## 1. Périmètre, critère de sortie et décision

Question : quelle règle autorise la pause, quel consommateur choisit sa présentation, et quels écarts précis empêchent de qualifier cet objectif complet ? Le lot couvre le décideur serveur, le réglage du launcher, les DTO de session, le bouton/touche et l’état affiché, leurs limites de vie, les sources natives retenues et les preuves d’exécution déjà disponibles. Le réglage du serveur et le contrôle visible sont deux rôles distincts.

**Audit documentaire terminé pour ce périmètre, sous contrôle des sept rubriques de la relecture indépendante. Fonctionnalité complète non terminée.** Le fichier delivery-readback.json est le reçu de clôture documentaire ; le reçu initial conserve audit_scope_closed=false jusqu’à cette relecture. Le goal global reste actif. Aucune acceptation humaine, aucune implémentation de permission ou correction produit n’est ajoutée par cet audit.

Critère du petit lot : une chaîne source→décision→capacité→présentation précise ou une rupture explicitement localisée, un attendu/observé honnête par branche, des preuves réutilisées avec leur portée réelle, et des corrections atomiques avec une entrée de reprise. Ce critère appartient à cette unité d’audit ; aucun critère normatif ni objectif du goal n’est modifié.

Prérequis relus : D17-SYS-17-3 comprend neuf tâches et requiert D20-SYS-20-3 « Connexion et reconnexion » ; ce dernier reste a_faire et requiert D20-SYS-20-1. La présence de ces lots ne vaut pas validation fonctionnelle de leurs prérequis. SYS-17.3-05 et son inconnue restent ouverts dans les registres conservés.

## 2. Sources natives et preuves existantes réutilisées

### Référence native et limite de permission

Le PE original est League of Legends.exe,15973880 octets, SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862, dans le déploiement RADS de D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy.

AUD-17.4-07-PAUSE-RESUME-01 est réutilisé sans relancer son analyse. Son reçu pause-resume-proof.json, SHA-256 ae939401c1427d1f0a49a1a412fb5a3d5674c63610d33da28fcad149e24b2984, conserve83contrôles et les callbacks pause0x7A4060/resume0x7A4130. Les clés natives game_console_chatcommand_pause_sent et game_console_chatcommand_resume_sent et leurs deux locales sont identifiées. Leurs identités sont relues. Le statut d’envoi de requête ne prouve pas l’autorisation d’un mode, la réception serveur ni un changement d’état accepté.

Le contrat entrant data/4.20/game_clock_pause_incoming_contract.json,14776octets, SHA-256 460dddf80bf91c115031486130f9eec749913d3d8ecfef46d8bd092b8450dc24, garde complete=false. A1/0A y décrivent des directives entrantes ; les callbacks sortants et leurs tailles ne constituent pas une règle de droit par mode. Constructeur/budget et délai de reprise ne fournissent pas davantage cette permission.

L’association conservée docs/reference_match_screens_sources/match_screens-links.json indique native_bindings=[] et historical_server_policy_qualified=false pour ce sujet ; full_task_scope_complete=false. Son ancienne phrase « Accepted clock state gates local pause presentation » désigne le flux d’état de l’horloge, pas une permission historique de mode. Aucune matrice native mode/file/rôle n’est qualifiée. Il serait incorrect de remplir ce manque avec une liste supposée de modes autorisés.

### Révision de la preuve la plus avancée

Le premier reçu de ce lot a comparé le runtime pack22 : sept lignes de tests restent associées à des sources ciblées actuelles identiques, sept autres concernent l’ancienne version ordinary_pause, et les quatre noms de tests du bouton n’apparaissent pas dans ce run précis. Cette observation est conservée telle quelle ; elle ne prouve pas que les quatre tests n’ont jamais été exécutés.

Une piste nouvelle, les empreintes différentes des deux fichiers ordinary_pause, a conduit à la recherche bornée des dossiers pause/HUD d’E:\mapslol3v3 et de F:\OpenLeague-work, puis de2846documents JSON/MD de premier niveau de docs de taille≤1Mo avec ces empreintes/noms précis. Le censusv784 a confirmé l’identité du consommateur. Le dossier nommé Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2 fournit la preuve avancée.

Son runtime_build.json, SHA-256 31ec67495ea4165b6ce1c91dc0c766b60ebb47f2bafca72451b2e34c10710edd, est lié à une compilation réellement terminée code0, un read0 distinct terminé code0 et une promotion qualifiée pour son périmètre technique. La qualification a88e09dcf409a10a7ce12b4c6fc02733234a8e7fb5c53c15e2b3dbb329067487 pointe les journaux conservés. Dix-huit lignes de tests ciblés sont effectivement « ok » :11ordinary_pause,3session_connection,3pause serveur et1politique du launcher. Six fichiers de source ciblés correspondent exactement aux empreintes de ce run, dont les deux fichiers du bouton actuels. **La limite des quatre tests absents du pack22 est donc résolue par réutilisation**, sans nouvelle compilation ni répétition de tests.

Cette concordance ne requalifie pas toutes les dépendances ni tous les binaires actuels de F. Les valeurs ordinary_GUI_qualified=false et render_qualified=false du runtime/promotion sont conservées ; elles n’effacent pas les observations locales spécifiques décrites ci-dessous.

### Captures réellement relues, sans nouvelle partie

Le dossier Ezreal_E_arrival_heads_pause_Q_flash_ordinary_GUI_observation_v2/acd4bdc3caee4049a9aafe289f5ed836 contient Root_closed_observation.json, Root_observed_steps.json et la réservation. Leurs liens vers le même runtime, les étapes, les métadonnées et images ont été vérifiés. Quatre images historiques ont été effectivement ouvertes avec view_image le31octobre, et non simplement déduites de leur nom :

| Image et date conservée | Texte visible | Bouton | Horloge HUD |
|---|---|---|---|
| 01_game_running.jpg ;2026-10-20T12:31:52.499Z | Partie en cours / demander une pause | Pause |0:11|
| 02_pause_acknowledged.jpg ;2026-10-20T12:32:08.506Z | PARTIE EN PAUSE / demander la reprise | Reprendre |0:31|
| 04_resume_waiting_for_server.jpg ;2026-10-20T12:32:23.626Z | Reprise en cours / attente du serveur | Reprise en cours |0:31|
| 05_running_after_resume.jpg ;2026-10-20T12:32:36.095Z | Partie en cours / demander une pause | Pause |0:34|

Le reçu d’étapes affirme des entrées ordinaires, sans injection ni mode diagnostic. Les captures montrent ce parcours nominal local. Le JPEG03 est strictement identique au JPEG02 : il ne constitue pas à lui seul une mesure temporelle indépendante ni une preuve de durée de gel. Aucun intervalle de clic, délai natif ni performance n’est mesuré ici.

Le reçu fermé garde pause_reaction_qualified=false, ordinary_pause_observed_automatically=false, ordinary_GUI_qualified=false, render_qualified=false et native_timing_parity_qualified=false. On conserve ces drapeaux et on rapporte séparément les états visibles effectivement relus ; aucune promotion globale de qualité n’est inventée. Les captures ne montrent aucun mode interdit ou inconnu, ni une permission d’origine Riot.

Les trois binaires historiques enregistrés existent encore à leurs chemins E et correspondent à leurs empreintes : client169930752octets/bcd6f4d07f09fd3a8d1374d3b79a292a6ed155b32e521628b471421f333bdf71 ; serveur6757888/f466c544fe60ef8df65415304b2e3ed1b49b9040019bbeb049225972b2b3fb94 ; launcher13874688/3020b37365964e0e5eb55f5be5aedf71822bd3c0fa30c46bab94ca8bdedaebea. Ce sont des identités historiques conservées, pas une autorisation de relancer le projet sur E ni une qualification du runtime actuel sur F. Aucun de ces exécutables n’a été lancé.

## 3. Consommateurs réels et chaîne actuelle

| Rôle | Source/consommateur actuel | Résultat établi et limite |
|---|---|---|
| Décision locale de permission | crates/server/src/main.rs:37 ; session_host.rs:136 ; main.rs:116 | Seul OPENLEAGUE_ALLOW_PAUSE égal à la chaîne1 active la pause ; même booléen global transmis au chemin authentifié et au chemin ancien. Absence/autre valeur suit la branche de refus, d’après le code lu. Aucune sélection par mode/rôle identifiée dans ce décideur. |
| Choix du launcher | launcher/src-tauri/src/sessions.rs:4–10 et test de politique :497 | Le constructeur de serveur possédé fixe explicitement OPENLEAGUE_ALLOW_PAUSE=1. Le test existant couvre ce constructeur ; il ne prouve pas les permissions d’un serveur rejoint ou du serveur historique. |
| Propagation de droit | core/session_transport.rs:70–152 ; core/lib.rs:209–278 | Welcome,StateEnvelope,ClockEnvelope,Snapshot et les réponses inspectées n’annoncent pas de capacité de pause explicite dans ce trajet. État accepté et disponibilité de connexion ne sont pas une permission. |
| Présentation du contrôle | client/ordinary_pause.rs:173–235 ; plugin réellement installé main.rs:710 | setup crée deux racines, texte et bouton. drive met à jour texte/couleur ; aucun masque de visibilité par permission de mode dans ce module. Le booléen enabled vient de ready+horloge prête+session vivante. |
| État reçu | native_effect_clock.rs:48–102 ; ordinary_pause.rs:30–58 | Le tuple est ordinal,paused,resume_pending ; Running/Paused/Resuming est une phase d’horloge, pas un mode de jeu. Une nouvelle directive appliquée commande les transitions ; une simple requête envoyée ne les anticipe pas. |
| Refus et durée de vie | ordinary_pause.rs:60–140 ; main.rs:1343–1346 ; session_connection.rs:150 | Bootstrap prêt,identité,pending,contexte/epoch/séquence,finitude/monotonie,focus et shop protègent l’entrée. Le refus désactivé devient Feedback::Disabled ; ce retour ne désactive pas durablement le bouton Running. |

La recherche de symboles OPENLEAGUE_ALLOW_PAUSE|allow_pause|pause_permission|pause_allowed|can_pause est relue dans1 168fichiers du corpus Rust/launcher défini, avec appartenance et contenu inchangés : sept occurrences, dans le serveur et le constructeur/test du launcher, aucune dans le client. Cette absence est bornée à ces symboles et aux chemins effectivement inspectés ; elle n’affirme pas une absence sémantique universelle de toute règle dans tous les fichiers du projet.

Le défaut de raccordement est précis : connection.ready() et clock.presentation_ready() établissent une capacité technique à demander/présenter, puis live impose session correspondante et absence de résultat final. Rien dans ce chemin n’ajoute un droit par mode. Le refus serveur protège l’action mais ne rend pas le contrôle conditionnel avant sa première demande.

Après un refus correctement corrélé « pause disabled by local match host », pending est effacé et Feedback::Disabled est affiché. button_label ne lit pas ce feedback : avec available=true et observed=Running, il retourne encore (Pause,true). La demande suivante peut être reproposée. C’est un résultat de lecture du branchement réel ; aucun nouveau clic de refus n’a été exécuté pendant ce lot.

La présentation de l’état accepté doit rester séparée de la capacité de demander une pause. Un joueur peut devoir voir une pause décidée par le serveur même s’il ne peut pas en demander une. Le sens natif exact de « uniquement dans les modes » et le choix masquer/désactiver doivent venir de la source de présentation/permission qualifiée, puis du contrat choisi. Cet audit n’invente pas ce contrat.

## 4. Attendu, observé et contrôles réellement exécutés

| Cas | Attendu du consommateur / objectif | Observé et portée |
|---|---|---|
| Serveur local autorisé,demande nominale | Une demande ne devient pause affichée qu’à réception de l’état accepté | Code actuel,18anciens tests ciblés avec sources correspondantes, quatre captures du nominal local relues ; pas de nouvelle partie. |
| Hôte désactivé | L’action est refusée, sans fausse pause | Deux gardes serveur explicites et retour corrélé client ; la visibilité par mode n’est pas satisfaite par ce seul refus. Lecture et preuve de transport ciblée conservée ; pas de nouveau refus en réseau. |
| Refus désactivé suivi d’une nouvelle entrée | La présentation respecte le contrat de permission | Feedback affiché mais bouton Running encore éligible dans la source ; correction ouverte. Le contrat de renouvellement du droit reste à définir. |
| Permission absente/inconnue ou ancien protocole | Ne pas déduire un droit historique du seul bootstrap ou de l’état Running | Aucune capacité dédiée dans les DTO inspectés ; le branchement du bouton ne la connaît pas. Affichage conditionnel inconnu non qualifié. |
| Reprise différée | Attendre l’ordinal final plutôt qu’un compte à rebours local | Tests et captures Reprise en cours puis Partie en cours réutilisés ; chronométrie native non mesurée. |
| Rejet étranger/ancienne epoch,pending/timeout | Corréler sans rejouer ni changer une pause acceptée | Code et essais ordinary_pause/session_connection conservés ; ne pas stocker un droit global à partir d’un rejet étranger. |
| Bootstrap,horloge défaillante,session/fin | Ne pas envoyer quand indisponible ou partie terminée | Gardes ready/horloge/live et terminal serveur identifiées ; le module garde des libellés d’indisponibilité, pas de permission native. |
| Focus/shop/gestes répétés | Aucun rejeu du geste après réouverture | Source actuelle et anciens tests ciblés11ordinary_pause réutilisés ; ces gardes ne remplacent pas le mode. |
| Original 4.20,mode/rôle exact | Source exacte et décideur qualifiés | Source de cette règle manquante ; ni opcode,ni budget,ni callback,ni capture locale ne résout ce manque. |

Commandes réellement exécutées, Python existant avec -X utf8 -E -B :

1. verify_pause_mode.py : code1, erreur de borne d’extrait de lecture. L’extrait commençait à181 après la création du texte à176. Pas un défaut produit. Script exécuté et erreur conservés dans producer-attempt-1-failed.json.
2. verify_pause_mode_v2.py : seule modification173au lieu de181 pour le début de cet extrait ; **142 contrôles documentaires réussis**, code0 ; nouveau reçu pause-mode-proof.json. Le premier script reste intact.
3. verify_retained_pause_evidence.py : **64 contrôles documentaires réussis**, code0 ; complément retained-pause-evidence.json qui résout explicitement la limite de tests de la première preuve.
4. verify_delivery.py : relecture indépendante des sept rubriques ; son reçu distinct delivery-readback.json contient le nombre exact, chaque attendu/observé et la décision de clôture. Le lecteur n’exécute aucun producteur ancien.

Les contrôles documentaires de ce lot ne sont pas206nouveaux tests de jeu. Les18tests sont des exécutions antérieures réellement relues dans les journaux, avec comparaison des sources ; aucune exécution Rust/Cargo n’est répétée. Non exécutés maintenant : jeu,natif,ActionScript,réseau,GPU,tests de rendu,clics,captures nouvelles et acceptation humaine. Les quatre images sont des captures héritées effectivement vues maintenant, pas des captures prises maintenant.

## 5. Résolu, manques et conditions de reprise

Résolu dans l’audit : décideur global local identifié, activation du serveur possédé établie, absence de droit explicite localisée dans le trajet réel, confusion mode de jeu/phase d’horloge levée, effet exact du refus désactivé décrit, consommateur du bouton réel conservé. L’ancien manque de preuve des quatre tests du bouton est résolu par la preuve avancée ; le nominal local a des états visibles conservés et relus. Aucun écart fonctionnel corrigé dans le jeu par ce lot.

| Reste ouvert | Entrée nécessaire à la reprise | Recherche à éviter en attendant |
|---|---|---|
| Règles originales mode/file/rôle et overrides | Provider/métadonnée/consommateur 4.20 nommé, règle serveur originale ou observation discriminante avec contexte de mode/rôle | Nouvelle liste de liens de pause sans consommateur,réanalyse identique des callbacks ou des budgets |
| Capacité admise et présentation conditionnelle | Politique qualifiée ou choix local explicite,contrat lié à session/version,attendu de visibilité | Assimiler bootstrap,clock Running ou map10 à une permission |
| Refus et renouvellement du droit | Portée du refus et mise à jour de politique définies avec producteur serveur | Répéter le refus sans modifier le consommateur ou préciser son attendu |
| Mode interdit/inconnu sur le parcours installé | Correction fonctionnelle autorisée,consommateur changé et cas négatif précis | Recompiler les mêmes18tests et reprendre les mêmes images du seul nominal |

Les sources disponibles permettent de terminer cette unité documentaire malgré ces manques. La tâche fonctionnelle SYS-17.3-05 et OLU-2a42f895-f3fd-5921-befe-af1213bce54f restent ouvertes ; le goal SYS-01.2-02 n’est pas déclaré complet.

## 6. Corrections petites, réutilisées et non appliquées

Les sous-lots SYS-17.4-07/K2-pause-feedback et K2-pause-session de l’audit antérieur sont réutilisés pour la corrélation et la durée de vie. D20-SYS-20-3 reste le lot existant de connexion/reconnexion. Pas de nouveau service de pause ; conserver mécanisme local et acquis. Les quatre propositions ci-dessous sont des corrections documentaires de cette tâche, statut proposed_not_applied ; elles ne changent ni le plan,ni le goal,ni ses critères de clôture.


### PAUSE-MODE-POLICY-01 — Établir une politique de pause explicite par mode et rôle

La permission actuelle est un booléen global local ; aucune matrice historique 4.20 n’est qualifiée.

Travail : Identifier le provider/métadonnée/consommateur 4.20 de la règle ; distinguer une politique locale nommée des droits historiques ; relier mode et rôle effectifs à la décision de l’hôte.

Critère de fin proposé : Chaque mode visé a une source et un décideur identifiés ; mode/rôle inconnu reste explicitement inconnu ou refusé, sans droits historiques inventés.

Entrée de reprise : Source 4.20 précise de règle ou de métadonnée de partie, callsite/provider nommé ou observation discriminante avec identité du mode et rôle.

Réutilisation/dépendances : D20-SYS-20-3, AUD-17.4-07-PAUSE-RESUME-01.

Preuve attendue : Table source→mode/rôle→décision et cas autorisé/interdit/inconnu, avec provenance et limites.


### PAUSE-CAPABILITY-PRESENTATION-01 — Raccorder permission de session et présentation des commandes

Welcome/Snapshot et ordinary_pause ne portent pas de permission explicite ; disponibilité de connexion et état d’horloge sont confondus avec possibilité de proposer la demande.

Travail : Propager une capacité explicite liée au contexte/session/version vers le client ; définir la présentation attendue, puis utiliser le même garde pour bouton et touche ; préserver les directives de pause réellement reçues indépendamment du droit d’en demander une.

Critère de fin proposé : Permission autorisée/interdite/inconnue pilote la présentation et le geste selon le contrat ; aucun droit hérité après changement d’identité, aucune pause reçue masquée par un simple défaut de capacité de demande.

Entrée de reprise : Politique de PAUSE-MODE-POLICY-01 ou politique locale explicitement choisie, contrat de capacité et règle de visibilité qualifiés ; autorisation de modification fonctionnelle distincte.

Réutilisation/dépendances : PAUSE-MODE-POLICY-01, SYS-20.3-01, SYS-17.4-07/K2-pause-session.

Preuve attendue : Tests de DTO/contexte, absence et ancien protocole, changement d’epoch, bouton/touche, et contrôle visible en mode interdit.


### PAUSE-DISABLED-FEEDBACK-01 — Traiter le refus corrélé sans reproposer aveuglément la demande

Feedback::Disabled est enregistré et affiché, mais button_label ignore ce feedback et retourne encore Pause/true en Running.

Travail : Réutiliser K2-pause-feedback/session ; décider la durée de validité du refus dans le contexte de session, appliquer le contrat de permission à l’entrée et au libellé sans déduire une règle globale d’un refus non corrélé.

Critère de fin proposé : Un refus désactivé correspondant à la requête ne produit aucune fausse pause ni boucle de demande ; réponses étrangères/anciennes ignorées, changement de contexte retire l’ancien refus selon contrat.

Entrée de reprise : Contrat de portée et de renouvellement du refus établi avec le producteur serveur, puis intervention fonctionnelle autorisée.

Réutilisation/dépendances : SYS-17.4-07/K2-pause-feedback, SYS-17.4-07/K2-pause-session, PAUSE-CAPABILITY-PRESENTATION-01.

Preuve attendue : Rejet exact/étranger/ancien, reprise de session, clic et touche après refus, observation du texte et du nombre de paquets.


### PAUSE-POLICY-PARCOURS-01 — Qualifier les branches de mode et l’affichage réellement installé

Les11tests de pause actuels et le parcours local nominal ont des preuves héritées plus avancées désormais réutilisées ; la visibilité par mode interdit/inconnu, les droits historiques et le parcours négatif de permission restent non qualifiés.

Travail : Réutiliser les18essais ciblés et les quatre captures conservées ; après correction fonctionnelle autorisée, tester seulement les branches de permission modifiées, contexte/epoch, ancien protocole, fin et gestes ; observer les modes autorisé/interdit/inconnu sans relancer le nominal inchangé pour créer un doublon.

Critère de fin proposé : Tests actuels identifiés terminés et contrôle de visibilité/gestes/réponses sur le parcours réel ; résultats natifs et locaux étiquetés, rendu et politique non déduits du seul succès unitaire.

Entrée de reprise : Consommateur de permission ou de présentation modifié, politique et attendu définis, binaires identifiés ; nouveau cas négatif discriminant plutôt que répétition du nominal déjà conservé.

Réutilisation/dépendances : PAUSE-CAPABILITY-PRESENTATION-01, PAUSE-DISABLED-FEEDBACK-01.

Preuve attendue : Sources/binaires exacts, journaux terminaux, attendu/observé par branche et capture de visibilité autorisée/interdite ; limites historiques conservées.


## 7. Livraison, conservation et relecture

Nouveaux fichiers uniquement. Dans le dépôt, seul ce rapport AUD-17.3-05-PAUSE-MODE-PRESENTATION-01.md est créé. Sous F:\OpenLeague-work\audit-units\AUD-17.3-05-PAUSE-MODE-PRESENTATION-01 : cadrage audit-unit.json,producteur initial,échec conservé,version2,preuve initiale,lecteur du complément,complément,lecteur indépendant et son futur reçu. Tous sont créés de manière exclusive ; aucun reçu antérieur remplacé. Le complément fournit les corrections effectives et prime uniquement sur la limite de preuve des tests du premier reçu, sans effacer cette limite historique.

Les19 fichiers logiciels gelés de l’intervention précédente,les six documents de contexte/méthode et les cinq registres normatifs restent identiques. Appartenance/contenu du corpus de1 168sources vérifiés. Git : HEAD8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,branchemain,76modifications suivies préexistantes ; statut suivi exact conservé. Aucun add/commit/reset/checkout/clean.

Goal et critères inchangés. Application de suivi/interface inchangées. Aucune base ouverte,aucun appel de serveur Plan/work_cli/Store,aucune installation,migration,suppression ni relance d’application. Les binaires E sont lus pour identité seulement ; le projet de travail reste F. Le contexte de reprise et les registres ne sont pas réécrits.

Relecture indépendante R1–R7 : périmètre/prérequis ; identité/provenance/limites des sources et preuves avancées ; consommateurs réels et recherche bornée ; attendu/observé et non-exécuté ; manques et reprise ; corrections précises réutilisées ; livraison/datation/conservation. audit_scope_closed=false dans les deux reçus producteurs ; seul delivery-readback.json peut établir la clôture documentaire après ses sept rubriques. Aucune déclaration de fonctionnalité,champion,jeu ou goal complet.

Identités des nouveaux livrables avant relecture :


- F:\OpenLeague-work\audit-units\AUD-17.3-05-PAUSE-MODE-PRESENTATION-01\audit-unit.json ; 2151 octets ; SHA-256 1a4518cfc19cd4c2265807d312972b6c6d985cac78788262f3f9c51deda9b1f6

- F:\OpenLeague-work\audit-units\AUD-17.3-05-PAUSE-MODE-PRESENTATION-01\verify_pause_mode.py ; 22386 octets ; SHA-256 94bca7443c389c5ea858ab9fc9237e6a2ba5028b1fcf234e83b8c74b21dee84d

- F:\OpenLeague-work\audit-units\AUD-17.3-05-PAUSE-MODE-PRESENTATION-01\producer-attempt-1-failed.json ; 969 octets ; SHA-256 aba86c0b1eb06948dcb8864acf7e5a9dfedd86e062ad0f04f1e10c3f0f268c2a

- F:\OpenLeague-work\audit-units\AUD-17.3-05-PAUSE-MODE-PRESENTATION-01\verify_pause_mode_v2.py ; 22386 octets ; SHA-256 785fdfa253986d9a67b4a863a89d7b31297dbbe90384173318cbe96a2c401411

- F:\OpenLeague-work\audit-units\AUD-17.3-05-PAUSE-MODE-PRESENTATION-01\pause-mode-proof.json ; 164625 octets ; SHA-256 a6f7dc1a9d9e4ff1605f8f86183fe6fa0b4579938af0c300fc0df8634b0a3f88

- F:\OpenLeague-work\audit-units\AUD-17.3-05-PAUSE-MODE-PRESENTATION-01\verify_retained_pause_evidence.py ; 10809 octets ; SHA-256 e6d90e07191a6615004a8b83d5010ccd3f508bbcdd69de8e8ec6fc2f1f5331e5

- F:\OpenLeague-work\audit-units\AUD-17.3-05-PAUSE-MODE-PRESENTATION-01\retained-pause-evidence.json ; 56817 octets ; SHA-256 39e443cb6ab5b9cf0c74b85e6478029a7da48edbb0a386bad21db11d270ffc90


Le reçu indépendant porte l’identité du rapport et de son lecteur ; aucune identité circulaire ni succès anticipé n’est inséré dans une ancienne preuve.
