# AUD-17.3-07-CONNECTION-STATUS-01 — Perte de connexion et tentative de reprise

Audit du2026-10-31,F:\OpenLeague,goal SYS-01.2-02. Parent SYS-17.3-07 « Afficher la perte de connexion et la tentative de reprise ». Exigence OLF-6f1276b5-523c-54fb-8eff-2dceca61b7c5 ; inconnue OLU-c01cd64b-d69c-5323-9632-8c375604b367. Référence LoL4.20.0.315 PUBLIC/Releases/4.20 EUW/en_GB ; catalogue4.20.1 distinct.

## 1. Périmètre et décision

Question : comment une coupure détectée devient-elle état de reprise/synchronisation,puis texte effectivement présenté par le client courant ? Ce lot couvre toute la clause de présentation : entrée initiale,perte,tentative,synchronisation,prêt,échec,indisponibilité,mode ancien et durée de vie du texte. Les mécanismes réseau sont inspectés en tant que producteurs,avec réutilisation de leurs preuves ; l’implémentation complète du lot D20 n’est pas requalifiée.

**Audit documentaire parent terminé sous contrôle de la relecture indépendante. Fonctionnalité complète non terminée.** Le statut local et son consommateur existent réellement ; ils ne sont pas déclarés absents. Les limites concernent notamment première connexion,mode ancien,source/rendu natifs,localisation et parcours de coupure dans le même processus. Le reçu producteur garde audit_scope_closed=false ; delivery-readback.json établit la clôture documentaire après ses sept rubriques.

Implémentation : partielle locale existante,aucun code changé. Vérification : lectures et identités130contrôles,20anciens essais ciblés relus,2images historiques effectivement vues ; aucune nouvelle exécution de jeu ou de test. Acceptation humaine : non donnée. Ni le parent fonctionnel,ni le jeu,ni le goal global ne sont déclarés terminés.

Critère de sortie du petit lot : chaîne réelle détecteur→état→ready→texte/visibilité,différences de mode et preuves de portée exacte ; chaque manque a une correction précise et une entrée de reprise. Ce cadrage appartient à cette seule unité et ne change aucun critère normatif.

Prérequis : D17-SYS-17-3 requiert D20-SYS-20-3 « Connexion et reconnexion »,encore a_faire,qui requiert D20-SYS-20-1. Les six tâches D20 sont réutilisées selon leur rôle,elles ne sont pas acceptées par présomption. Le tour précédent est un progrès : audit parent du scrutin terminé avec nouvelle source et huit tests réutilisés ; un renvoi documentaire incorrect y a été découvert et corrigé ci-dessous.

## 2. Correction d’un renvoi du lot précédent

Dans AUD-17.3-06-TEAM-VOTE-01,la proposition SYS-17.3-06/V6-fin renvoyait à SYS-17.3-07 pour le consommateur de résultat/cérémonie. **Ce numéro était erroné.** Le registre normatif relu indique :07=perte de connexion/reprise ;08=« Afficher les résultats de victoire et défaite ».

team-vote-task-reference-erratum.json conserve l’ancienne correction et les identités exactes du rapport,de la preuve et de sa relecture. Il fournit la correction effective : dépendance et entrée de reprise de V6 vers **SYS-17.3-08 pour les résultats**. La cérémonie de reddition reste à qualifier dans V6 ; le seul titre08 n’en prouve pas la réalisation. La présentation de reconnexion07 concerne la reprise V8,elle ne remplace pas le consommateur de résultat V6.

Les sources,constats et sorties du lot précédent restent conservés. Son ancien renvoi ne doit plus servir de preuve de couverture de V6. Aucune ancienne preuve réécrite,aucune coche ou dépendance du registre modifiée ; c’est une correction documentaire précise,distincte d’une correction fonctionnelle.

## 3. Sources natives et limites de la référence

Le PE original15973880octets,SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862,est relu par identité dans le déploiement RADS original sur D. Aucune exécution ni nouvelle décompilation native. Les fontconfig_en_GB et fr_FR du même déploiement sont identifiés par leurs empreintes déjà acquises et relus à leurs lignes exactes.

Huit clés pertinentes par locale : flash_message_reconnect,game_announcement_OnReconnect,game_messagebox_caption_connectionretry,game_messagebox_caption_disconnect,game_messagebox_text_disconnect,game_messagebox_text_reconnect,game_messagebox_text_reconnectfail et game_messagebox_text_disconnectduringload. Elles distinguent tentative,retour,échec,perte et frontière de chargement. Leurs valeurs sont dans la preuve,avec numéros de lignes. Le texte de question de reconnexion n’établit pas le callback du bouton ni son résultat réel.

Le HUD.zip courant est identique à la référence native76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c. Les membres HUD/Elements/MessageBox.ini et MessageBox_fr_fr.ini sont identifiés ; Type/Name à deux-points,widgets et compte de types sont relevés. Le premier décrit une boîte générique,le second une surcharge de texte. Leur présence ne prouve pas que cette boîte soit sélectionnée pour la coupure réseau ni la cascade/locale effective.

La recherche de noms reconnect|connection|disconnect au premier niveau de DATA/menu et DATA/Menu_SC4 ne trouve pas de movie de ce nom. Cette absence est strictement une recherche de noms : elle ne signifie pas que la présentation originale,un message générique ou ses assets manquent. Les avertissements PVP.net chat,AFK et spectateur sont distincts ; aucun n’est utilisé comme preuve du parcours joueur en partie.

Restent non qualifiés : appelant C++ exact des clés,message/événement reçu,provider de localisation,choix de vue/dialogue,gestes retry/exit et comparaison visuelle du même état original. Entrée de reprise : callsite/provider nommé ou observation originale discriminante du même contexte. Une présence de clé ou un nouvel export du HUD générique ne suffit pas.

## 4. Chaîne actuelle vers le texte visible

| Rôle | Consommateur réel | Résultat établi |
|---|---|---|
| Détection locale sécurisée | client/session_connection.rs:7–8,115–126,165–206 | SILENCE=5s et RETRANSMIT=2s sont des politiques locales. Erreur d’envoi/réception ou absence de nouveau trafic accepté peut placer recover_socket ; ce n’est pas une mesure du délai Riot historique. |
| Requête de reprise | session_connection::maintain_session ; session_client::recover/context_response | Remplace le socket local,demande le contexte du même joueur,puis prépare Resume quand Detached ; Busy attend. Pas de Leave ni nouveau Join implicite lors d’une interruption de ce chemin. |
| Barrière de synchronisation | session_client.rs:44–68,69–139,175–208 ; core/session_transport.rs:184–207 | ready exige absence d’échec/de pending,frame présenté non nul égal au livré et barrière prête. Welcome,assemblage ou ACK seuls ne déclarent pas le client prêt. |
| Commit effectif | client/main.rs:1327–1340 | Snapshot affecté avant connection.presented(delivery). Un succès ready retire ensuite l’ancienne rejection. Les essais de composants utilisent ce type de frontière de commit ; cela ne mesure pas l’affichage GPU. |
| Statut public | session_connection.rs:98–111 | Sépare fatal,closed,échec de handshake,reprise,synchronisation et connexion. Chaînes françaises locales ; aucun credential transmis au texte. |
| Consommateur de présentation | main.rs:1545–1582 | Quand !ready,labels remplace Text par session_status et impose Display::Flex,puis retourne avant le garde F3. Quand prêt,le garde debug reprend la main ; résultat final masque ce label dans cette branche. |
| Objet et inscription | main.rs:929–954,819–836 | PlayerLabel est réellement créé,avec layout local en bas d’écran et largeur maximale95%,puis labels est inscrit dans Update. Ce n’est pas une maquette détachée. Rendu,occlusions,ordonnancement précis et dimensions réelles restent à observer. |
| Garde d’entrée | session_connection.rs:132–163 | send_action refuse quand !ready en renvoyant le statut ; pause et identité de geste ont leurs barrières. La disponibilité d’un dernier snapshot ne réactive pas les commandes à elle seule. |

La recherche des noms de clés natives et de session_status dans1 168sources Rust/launcher est conservée,avec appartenance et contenu du corpus inchangés. Elle retrouve le consommateur actuel ; elle ne démontre pas une absence sémantique universelle de tout sélecteur natif dynamique.

### Phases établies et écarts précis

| Situation lue | Libellé/état courant | Limite |
|---|---|---|
| link.fatal | Synchronisation impossible,invite à revenir au lanceur | Un texte de retour n’est pas un bouton ni un parcours de sortie validé ; SYS-17.3-09 reste distinct. |
| link.closed | Partie quittée | L’affichage avant sortie effective reste non observé ici. |
| client.failure | Reconnexion indisponible | Refus terminal distinct du pending ; pas de nouvelle admission automatique. |
| recover_socket ou client.context=None | Reconnexion en cours | **La première entrée sécurisée sans contexte prend aussi cette branche.** Le libellé ne distingue donc pas correctement connexion initiale et reprise. |
| Contexte accepté mais !client.ready | Synchronisation de la partie | Le statut attend commit et horloge requis ; ne pas le convertir en gameplay prêt sur simple Welcome. |
| Legacy,id absent | Connexion à la partie | Le mode ancien n’a pas le handshake privé. |
| Legacy,id présent | Connecté | ready y dépend de l’id ; la perte de réseau n’applique pas la même barrière de liveness. |

Pour legacy,network_interrupted signale seulement « Local network unavailable ». maintain_session retourne après son ancien renvoi Join,avant le contrôle SILENCE du mode sécurisé. ready reste vrai si id présent et lien non fermé/fatal ; le label de reprise ne s’impose donc pas selon le mécanisme sécurisé. C’est un écart de couverture de ce mode dans les branches lues,aucun nouveau test de coupure ni verdict global sur tout UDP.

Les datagrammes OLSR dupliqués ne remettent pas à zéro l’attente de trafic uniquement parce qu’ils arrivent : last_received avance si received_frame_ordinal augmente après validation. Reprise dans la même session conserve le dernier état de jeu jusqu’au commit suivant ; conservation d’image/état ne vaut pas état frais ou commandes autorisées. Les réponses étrangères,nonces anciens et barrières incomplètes ont des refus de composants conservés.

## 5. Preuves d’exécution réutilisées et portée réelle

### Composants actuels associés à une exécution conservée

Le runtime avancé Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2,SHA-256 31ec67495ea4165b6ce1c91dc0c766b60ebb47f2bafca72451b2e34c10710edd,est réutilisé par ses références vérifiées : promotion,compilation terminale,read0 distinct,qualification et journal client terminal code0.

**20 lignes de tests ciblés réellement « ok »** sont relues :11session_client et9session_connection,concernant retransmission,contexte,epoch,barrière,commit,horloge appliquée,interruption et mode ancien. Les cinq sources ciblées session_connection.rs,session_connection_tests.rs,session_client.rs,session_client_tests.rs et main.rs correspondent exactement à leurs empreintes d’exécution. Aucun essai répété.

Ces tests prouvent leurs assertions de composants et de trafic UDP local contrôlé. Leur nom et leur journal ne prouvent pas un texte rendu,un délai de coupure réel de5s ni un parcours GUI complet. Une chaîne session_status présente dans un module exécuté n’implique pas que chaque branche et chaque phrase aient une assertion visuelle. Toutes les dépendances et tous les binaires actuels de F ne sont pas requalifiés.

### Ancien parcours réel de crash/reprise conservé séparément

Le résumé docs/smite_and_authenticated_reconnection.json indique ordinary_local_recovery_qualified=true dans son périmètre historique. Son run nommé reconnect_launcher_runtime_v3/run_002/receipt.json,SHA-256 b8074a6828c73e15895b9b5feafe40f44d9139d7a3e4459f631ab93d8d835cea,est relu plutôt que déduit d’un ancien candidat marqué non implémenté. Ses tentatives échouées antérieures sont conservées.

Le run réussi atteste des sous-périmètres : reprise du même joueur après crash sous pause,rejet d’une ancienne epoch sur un pair auxiliaire,commande ordinaire après reprise et drain serveur possédé. Deux clients sont arrêtés par injections explicites exit71 ; le serveur finit0 et les ressources possédées sont closes. Il ne s’agit pas de sorties normales des deux clients. Ni epoch/ACK/barrière exacts dans la GUI,ni fidélité réseau Riot,ni jeu complet ne sont qualifiés. Un nouveau client a sa propre origine d’horloge ; ce scénario n’est pas une reprise socket dans le même processus.

Deux captures originales de ce run ont été réellement ouvertes avec view_image le31octobre,et vérifiées contre leurs empreintes :

| Capture héritée | Constat visible relu | Ce qu’elle ne prouve pas |
|---|---|---|
| 07_resume_offered.png | Launcher : Client interrompu,codeSome(71),Reprendre la partie,Abandonner la partie conservée | Aucun état de coupure dans un client resté ouvert ; ancien texte/launcher,équivalence aux sources actuelles non présumée. |
| 08_resumed_under_pause.png | Jeu avec Garen et map,horloge1:01,gold500,HP617/617,cooldownE après relance | Pas d’overlay de connexion perdue/tentative visible dans cette image,ni de mesure de barrière/latence. |

Les binaires historiques sont identifiés dans le reçu : clienta1521e1a2513757c03bda5b21165618a70a0797e9b1c80faeebf4d6b26396006,serveur70efc8743ca99b53ed44ed9cdc0c0801a6f5f5fd96385f6521c2d4c724e1027f,launchere95de30522f076726b3753fdc9cc9297003ff735228929b294e1c4a7e5f7b9c3. Ils sont une identité enregistrée historique,pas les binaires actuels affirmés de F. La comparaison aux cinq sources courantes est conservée ; aucune différence d’empreinte n’est transformée automatiquement en régression. Aucun de ces binaires n’a été exécuté maintenant.

### Attendu/observé et contrôles du lot

| Cas | Attendu précis | Observé et limite |
|---|---|---|
| Première entrée sécurisée | Texte de connexion initiale distinct | Branche actuelle dit déjà reconnexion ; correction de phase proposée. Lecture statique. |
| Coupure sécurisée | Geste bloqué,perte/reprise visible | recover_socket ferme ready ; labels force Flex. Essais de composants conservés ; visibilité pendant vraie coupure non observée ici. |
| Busy/Detached/requête répétée | Contexte du même joueur,sans Leave/nouveau Join | Assertions protocolaires relues ; ne prouvent pas le choix UI natif. |
| Welcome sans état présenté/horloge manquante | Synchronisation et commandes fermées | Barrière et commit lus,essais ciblés réutilisés ; ACK auxiliaire historique distinct d’un EffectClock réel de GUI. |
| Succès après commit | Même identité,reprise des entrées,disparition du message | Sources et essais associés ; durée/lisibilité du changement dans le même processus non mesurées. |
| Nonce/epoch/état étrangers ou ancien trafic | Pas de fausse reprise ni prolongation indue de liveness par duplicat OLSR | Refus et contrôles de composants conservés,pas de nouveau scénario hostile lancé. |
| Échec irrécupérable/fatal | Erreur distincte et action de sortie correcte | Chaînes présentes ; parcours visuel/action de retour couvert séparément par SYS-17.3-09,non terminé ici. |
| Legacy,id conservé,réseau perdu | Support/refus explicite,aucun faux Connecté | Contrat actuel différent : log seulement et ready par id. Pas de coupure legacy exécutée. |
| F3,HUD,fin,locale et fenêtre | Statut lisible pendant indisponibilité | Garde F3 après !ready dans le code ; contexte visuel/occlusion/localisation non qualifié. |

Exécuté maintenant : verify_connection_status.py avec Python existant -X utf8 -E -B,code0,**130 contrôles documentaires réussis** ; comparaison de sources et reçus,lecture de deux images héritées,création d’un erratum. Le lecteur indépendant verify_delivery.py fournit un reçu distinct avec son nombre exact et ses sept rubriques.

Non exécutés maintenant : tests Rust/Cargo,jeu,natif,ActionScript,réseau/GPU,coupure réelle,reconnexion graphique,clics ou captures nouvelles. Aucun paquet ni résultat de reconnexion fabriqué. Les130contrôles documentaires ne sont pas130nouveaux tests réseau. Aucun sous-agent.

## 6. Résolu, manques et petites corrections

Résolu : chaîne de présentation réelle identifiée ; reprise et synchronisation distinguées de l’acceptation de commande ; références lexicales natives disponibles ; portée du mode ancien et défaut du libellé initial localisés ; preuve avancée20tests et ancien parcours GUI correctement séparés ; renvoi V6-fin erroné corrigé vers08pour les résultats. Aucun écart fonctionnel corrigé pendant le lot.

Ouverts : référence native du même état et son provider,phases/langue de l’UI locale,perte legacy,presentation sur client réellement installé pendant coupure dans le même processus,occlusions et transitions terminales. Les tâches réseau SYS-20.3-01/02/03/04/05 et retour SYS-17.3-09 sont réutilisées selon leur vrai rôle. Pas de réécriture de protocole requise par la seule absence d’une qualification de vue.

Les propositions ci-dessous sont proposed_not_applied. Elles restent documentaires : aucun objectif,critère normatif,case,note ou schéma de base changé. Une entrée native manquante ne bloque pas la clôture de l’audit si sa portée et sa reprise sont correctement documentées ; elle maintient la fidélité et la fonctionnalité ouvertes.


### RECONNECT-PHASE-LABEL-01 — Distinguer entrée initiale,perte,reprise et synchronisation

Écart : Un client sécurisé sans contexte initial affiche déjà Reconnexion en cours,comme une vraie reprise.

Travail : Réutiliser les états de handshake existants pour une phase publique explicite ; rendre le libellé à partir de cette phase sans exposer credentials ou détails privés.

Critère de fin proposé : Premier Join=connexion initiale ; interruption=perte/reprise ; Welcome noncommitté=synchronisation ; prêt seulement après commit/barrière ; refus terminal distinct.

Entrée de reprise : Consommateurs session_status/labels modifiés dans une intervention fonctionnelle autorisée ; contrat des transitions et textes fixé.

Réutilisation : SYS-20.3-01, SYS-20.3-03.

Preuve attendue : Source et consommateur exacts,attendu/observé par phase et limites ; exécution identifiée si nécessaire,technique distincte de validation humaine.


### RECONNECT-LEGACY-STATUS-01 — Qualifier l’affichage de perte du mode UDP ancien

Écart : Legacy reste ready si id présent ; interruption y signale seulement un log et maintain retourne avant SILENCE.

Travail : Définir explicitement la politique de liveness/support legacy ; faire apparaître son indisponibilité sans promettre une reprise authentifiée qu’il ne possède pas,conserver protocole et commandes existants.

Critère de fin proposé : Un défaut legacy ne reste pas présenté comme Connecté par simple présence de l’id ; support ou refus explicite,aucun fallback d’identité ni reprise fictive.

Entrée de reprise : Décision de support legacy et signal de perte fiable définis,puis intervention fonctionnelle autorisée.

Réutilisation : SYS-20.3-04.

Preuve attendue : Source et consommateur exacts,attendu/observé par phase et limites ; exécution identifiée si nécessaire,technique distincte de validation humaine.


### RECONNECT-NATIVE-VIEW-01 — Qualifier la référence native de présentation

Écart : Textes et MessageBox générique identifiés,mais provider/selector/callsite d’affichage original non qualifié.

Travail : Relier les clés perte/reconnexion/échec à leur appelant et vue4.20 ; distinguer jeu,chargement,PVPchat et spectateur ; comparer cette référence au PlayerLabel local.

Critère de fin proposé : Source→déclencheur→vue/choix/réponse qualifiés pour le contexte requis,ou politique locale explicitement nommée avec fidélité ouverte.

Entrée de reprise : Callsite/provider4.20 nommé ou observation originale contrôlée du même état ; ne pas réexporter le HUD générique sans nouvelle piste.

Réutilisation : SYS-17.3-03, SYS-20.3-01.

Preuve attendue : Source et consommateur exacts,attendu/observé par phase et limites ; exécution identifiée si nécessaire,technique distincte de validation humaine.


### RECONNECT-LOCALIZED-MESSAGE-01 — Raccorder les messages au profil de langue voulu

Écart : session_status renvoie des chaînes françaises locales sur une référence EUW/en_GB ; présence lexicale native ne prouve pas son utilisation.

Travail : Choisir les messages par phase et locale du contrat retenu,raccorder dictionnaire et rendu effectifs ; garder les chaînes locales signalées tant que les équivalences natives sont ouvertes.

Critère de fin proposé : en_GB/fr_FR demandés sélectionnent le bon texte rendu ; clé absente et fallback explicites,sans contenu de protocole privé ni fausse réussite.

Entrée de reprise : Provider de localisation et contrat de phase disponibles ; source exacte des messages et cas de fallback définis.

Réutilisation : RECONNECT-PHASE-LABEL-01, RECONNECT-NATIVE-VIEW-01.

Preuve attendue : Source et consommateur exacts,attendu/observé par phase et limites ; exécution identifiée si nécessaire,technique distincte de validation humaine.


### RECONNECT-REAL-LOSS-VIEW-01 — Observer les états de perte et reprise sur le client installé

Écart : 20tests de composants et vieux redémarrage après crash ne prouvent pas l’affichage lors d’une coupure réseau dans le même processus.

Travail : Après correction ou cas nouveau autorisé,observer perte,tentative,synchronisation,prêt et refus avec états/gestes réels ; conserver l’identité,barrière de commit et absence de Leave implicite.

Critère de fin proposé : Captures et événements corrélés montrent chaque état attendu,aucun bouton/commande actif trop tôt,disparition correcte après succès et lecture claire sous HUD/fin/F3/tailles testées.

Entrée de reprise : Changement ciblé ou nouveau cas discriminant,binaires identifiés et dispositif de coupure contrôlé local autorisé ; ne pas rejouer les20tests inchangés faute de nouveauté.

Réutilisation : RECONNECT-PHASE-LABEL-01, RECONNECT-LEGACY-STATUS-01, SYS-20.3-03, SYS-20.3-04.

Preuve attendue : Source et consommateur exacts,attendu/observé par phase et limites ; exécution identifiée si nécessaire,technique distincte de validation humaine.


## 7. Livraison et conservation

Nouveaux fichiers uniquement. Dans le dépôt,seul docs/audit/units/AUD-17.3-07-CONNECTION-STATUS-01.md est créé. Sous F:\OpenLeague-work\audit-units\AUD-17.3-07-CONNECTION-STATUS-01 : audit-unit.json,verify_connection_status.py,team-vote-task-reference-erratum.json,connection-status-proof.json,verify_delivery.py et son futur delivery-readback.json. Les producteurs et reçus exécutés sont conservés sans remplacement ; aucun rapport antérieur modifié.

Les19fichiers logiciels gelés et les six contextes/méthodes sont identiques ; cinq registres normatifs et corpus courant1 168sources inchangés. Git : HEAD8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,branchemain,76modifications suivies préexistantes ; statut suivi exact conservé. Aucun add/commit/reset/clean/checkout.

Goal et critères inchangés. Suivi/UI/bases inchangés. Aucune base ouverte,aucun Plan/work_cli/Store,aucune installation,migration,suppression ni relance d’application. Les sources originales sur D et les preuves historiques sur E sont seulement lues ; le projet de travail reste F.

Relecture R1–R7 : périmètre/prérequis ; sources natives et preuves historiques/avancées avec leurs limites ; consommateurs actuels/branches/query bornée ; attendu/observé et contrôles/non-exécuté ; écarts/reprise ; cinq corrections précises et renvoi erroné corrigé ; identités/dates/conservation. audit_scope_closed=false dans le producteur ; seul le reçu indépendant peut établir parent_documentary_scope_closed après succès des sept rubriques. L’inconnue et le parent fonctionnel restent ouverts,aucune complétude du goal global.

Identités nouvelles avant relecture :


- F:\OpenLeague-work\audit-units\AUD-17.3-07-CONNECTION-STATUS-01\audit-unit.json ; 2277octets ; SHA-256 18bce8c5e3e2a57797dc27440d95ea8996a6b16a73eb4adef17eddaec59d6fa3

- F:\OpenLeague-work\audit-units\AUD-17.3-07-CONNECTION-STATUS-01\verify_connection_status.py ; 25158octets ; SHA-256 b80c8fe9123d5fb9cd759586964eb0e763208ddd44a7a6782642a25e90e0baa4

- F:\OpenLeague-work\audit-units\AUD-17.3-07-CONNECTION-STATUS-01\team-vote-task-reference-erratum.json ; 4754octets ; SHA-256 4e49f8861ea5892b4030c69c06f3b7f40e2d8c0d9839033287ba86679bec665d

- F:\OpenLeague-work\audit-units\AUD-17.3-07-CONNECTION-STATUS-01\connection-status-proof.json ; 164677octets ; SHA-256 508b78a4845f515664efd679ee89a7a8583d37c26451ec817432d2673dee772b


L’identité du rapport et celle du lecteur sont portées par le reçu indépendant,sans référence circulaire ni succès ajouté à une ancienne preuve.
