# AUD-17.2-08-CHAT-01 — Chat : sources natives et consommateurs actuels

Date : 2026-10-30. Projet physique : F:\OpenLeague. Parent du goal : SYS-01.2-02. Référence : client 4.20.0.315 PUBLIC/Releases/4.20, EUW, en_GB ; catalogue 4.20.1. La date de compilation historique ne prouve ni le fuseau ni la date de déploiement.

## 1. Périmètre, question et critères de sortie

Question : les sources natives disponibles et le client/serveur Rust actuels permettent-ils de qualifier le chat équipe/global, son historique, ses commandes et son focus ?

Unité unique couvrant la frontière ressources/interface/hôte et sa comparaison au code actuel pour quatre tâches existantes :

| Tâche | Objectif | Inconnue conservée |
|---|---|---|
| SYS-17.2-08 | Chat équipe/global selon les permissions | OLU-5abd1f66-bc04-5d6c-a130-33387ecf2888 |
| SYS-17.2-09 | Historique borné | OLU-83a927ae-fc5f-5c43-bb2a-cdeee4a6114b |
| SYS-17.4-07 | Commandes de chat historiques applicables au serveur local | OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38 |
| SYS-17.4-08 | Saisie de chat ne déclenchant pas le combat | OLU-e87ab149-2826-528a-9bc4-4fbe77da6b15 |

Sortie attendue : identifier les films et leurs interfaces ; établir la limite et l’éviction de l’historique dans leurs scripts ; distinguer présentation, hôte et serveur ; rechercher les consommateurs Rust réels ; décrire les écarts et leur reprise. Exclusions : implémentation du chat, exécution de LoL/ActionScript, reverse du gestionnaire C++, protocole historique complet, essais réseau/rendu et acceptation humaine.

Entrées : sources locales présentes, reçus existants, registre des tâches et ordre des lots lus directement comme JSON. Le lot D17-SYS-17-2 requiert D13-SYS-13-3 « Confidentialité de l’état de jeu » ; D17-SYS-17-4 requiert D09-SYS-09-4 « Caméra et commandes au sol ». Ces deux prérequis d’implémentation sont encore recensés a_faire. Ils ne sont pas déclarés acquis par cet audit documentaire. La phase D17 et les quatre tâches n’ont pas de dépendance directe supplémentaire dans leurs champs depends_on. Les entrées lues et ces enregistrements sont conservés dans la preuve.

Décision limitée : **audit de cette frontière terminé avec preuves**. Implémentation : chargement des réglages présent ; chat fonctionnel non identifié dans le périmètre inspecté. Vérification : analyse statique et identités réussies ; chat réel non exécuté. Acceptation humaine : non demandée. Les quatre tâches fonctionnelles et le goal restent ouverts. Aucun statut, objectif, critère normatif ou registre de l’application n’est modifié.

## 2. Sources, provenance et limites

### Films originaux et provenance déjà enregistrée

Base native : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA.

| Fichier sous cette base | Octets | SHA-256 | Source existante |
|---|---:|---|---|
| menu\HudChat.gfx | 25576 | e290c76affb1bed36449283eb8262cc60a3cf8f0bcb2d9e9022b256939b7c2dd | OLS-7657e78b-62f3-5040-8c7d-a71f1762bdc1 |
| Menu_SC4\HudChat.gfx | 29521 | deb87e15957e05a24302c61321c0319315f2026c07b850ca6babd27fb946c4bc | OLS-fa778ee9-1951-5a47-87fd-c5b64c28a28f |

Les deux entrées de F:\OpenLeague\docs\fidelity_sources_4_20.json portent kind=exact_selected_core_reference_payload, projet RADS lol_game_client, project_release=0.0.1.7 ; member_release respectivement 0.0.0.37 et 0.0.0.183. Les SHA-256, tailles et MD5 sélectionnés concordent avec les fichiers relus. Le champ runtime_precedence_qualified reste false pour les deux. Ces identités ne choisissent pas le film réellement monté en partie.

Réutilisation du reçu OLS-ea56e35a-41ab-573c-8fb6-cf3d83b3045c : F:\OpenLeague\docs\reference_native_skin_loader_sources\core-reference-coverage-and-urf-correction.json, SHA-256 e1d00324c012e28ff0eee102ca8f57bf8929f93f589c4627862ac45d07d4e9df. Les chemins E:\OpenLeague des preuves antérieures sont historiques ; leur correspondance physique F est explicite. Aucune reconstruction du registre ni nouvelle analyse globale des manifestes.

### Extraction nouvelle et délimitée

Nouvelle piste nécessaire : les anciens liens ne décrivaient que Chat.ini. Les deux HudChat.gfx présents peuvent préciser le contrat de leur interface. Arrêt fixé à leurs scripts et à leur comparaison aux consommateurs Rust ; pas de relance sans changement ou question nouvelle.

Le 2026-10-30 de 13:57:52 à 13:57:59 UTC, FFDec/Java déjà installés ont exporté uniquement les scripts : 30 fichiers pour menu, 32 pour Menu_SC4, deux codes de sortie 0. Aucun téléchargement ni installation. Commandes exactes, horaires, journaux, identités d’entrée/sortie et des outils dans :

F:\OpenLeague-work\audit-units\AUD-17.2-08-CHAT-01\chat-extraction-receipt.json

SHA-256 : b05d0c01c2c35ed6c56f6e07aa8333f89f78af93044e68b7c2d91a53f4c8fc2c.

Outils exécutés :

- C:\Program Files\Eclipse Adoptium\jdk-21.0.10.7-hotspot\bin\java.exe ; 50344 octets ; SHA-256 bd3d87dfb44651a1c61c995e08ca4fcadb458437a373d46941381f9aeff9d6a0.
- E:\MinecraftMOBA\tools\ffdec\ffdec.jar ; 5075015 octets ; SHA-256 090ab695053ad94cba6408574c7d7eea20ec60b6ae789ee6056a23f45106762f.
- JVM identifiée séparément dans le reçu ; les composants transitifs du runtime ne sont pas tous instrumentés.

Les fichiers originaux sont identiques avant/après. Il s’agit d’une décompilation AS2, sans exécution de ces scripts ou du jeu. Les conditions imposées par le C++ hôte restent hors de cette preuve.

### Contrats effectivement trouvés

Sous F:\OpenLeague-work\audit-units\AUD-17.2-08-CHAT-01\extracted\<variante>\scripts\__Packages :

- Riot\Hud\GameComponents\ChatBox.as : messageAmountLimit=100 dans les deux candidats. addMessage insère en tête, puis retire le dernier élément si la taille dépasse la limite ; onClearHistoryPress vide le tableau. Le script retient donc au plus 100 messages sous cette valeur par défaut, avec éviction du plus ancien. Les fonctions de rendu parcourent ce tableau. Analyse statique ; aucun test ActionScript exécuté.
- messageLifeSpan=10000 apparaît une seule fois par corpus exporté, à sa déclaration. ChatMessage ne conserve aucun timestamp ni durée de vie. Le timeoutInterval=10000 est distinct, configurable par l’hôte, et masque la fenêtre ; il ne vide pas le tableau. Aucune durée de conservation de dix secondes n’est déduite de ces déclarations.
- Valeurs d’affichage par défaut : 8 lignes normales et 26 étendues. SetChatLineCount et SetChatExpandedLineCount permettent à l’hôte de les changer. Les 33/44 de menu\Riot\Hud\Main.as sont dans la branche DEBUG, initialement false ; aucune valeur effective en partie n’en est déduite.
- Riot\Hud\Communication\CommandParser.as expose les entrées hôte→film : Add_Message, Text_Entry_Open/Close, Chat_SetInputText, Set_Message_Color, réglages d’affichage et AddChatInterrupt/ClearChatInterrupts. Ce CommandParser est le répartiteur d’interface ; il ne démontre pas une grammaire de commandes tapées par le joueur.
- onSendTeamPress et onSendAllPress transmettent le texte avec le pressPrefix du bouton et les suffixes SendTeam/SendAll. Le préfixe par défaut de DefaultButton est Press_. Entrée transmet ChatSend ; la recherche de motifs fournis par l’hôte transmet ChatInterrupt avec motif, texte et caret. Le vocabulaire historique de ces motifs reste inconnu.
- DDW\Communication\Comm.as appelle fscommand(msg,arg) dans la branche isGfx ; les autres branches sont locales. C’est une frontière film→hôte. Aucun routage serveur, destinataire, contrôle de permission ou refus de message n’est qualifié par ces appels.
- Menu_SC4 ajoute SetRestrictedChatEnabled/Message/Color. ChatBoxGraphicBase.as règle la visibilité, le texte et la couleur d’un message de restriction ; aucune autorité réseau n’en est déduite.
- ChatMessage.as est identique entre les deux variantes : SHA-256 f0745065101384d75e6f67b6f3031a85f066c043e1d8db40a125034fa0b6c527. Il applique un traitement d’entités avec une liste de balises autorisées. Cette observation ne qualifie pas complètement l’assainissement du contenu ou le rendu HTML du moteur.

Chat.ini : membre HUD/defaults/Chat.ini, 1773 octets, SHA-256 0d3a57325f350cbc40be289d5f8a817b2673db208f588a5e06bdc827fe5747f4. Les copies dans le HUD.zip original, le HUD.zip local et le fichier natif décompressé concordent. Les deux archives ont le SHA-256 76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c. Les 55 entrées concernent présentation, polices et couleurs, dont TeamChat, AllChat, Whisper et variantes Spectator/Colorblind. Elles ne définissent ni historique ni envoi ni permission serveur.

Input.ini natif : GameEvents/evtChatHistory=[z] ; ChatEvents/evtChatConsoleReturn=[Return], [NumEnter]. Le fichier fourni cfg/input.ini n’apporte pas de redéfinition de chat identifiée. Les entrées CheatEvents restent classées comme telles. Aucun binding Shift+Entrée ou catalogue de commandes serveur n’est inventé à partir de ces données. Identités et sections exactes dans la preuve.

## 3. Consommateurs réels et recherche d’absence bornée

Recherche reproductible dans **1199 fichiers crates/**/*.rs**, inventoriés et hachés, motif insensible à la casse : chat|whisper|saymessage|message_history|team_message. Sept occurrences, toutes classées :

- F:\OpenLeague\crates\client\src\native_zip_provider.rs:17,74,118,160 : champ d’octets, chargement de Chat.ini, restitution des octets et test de longueur. Le test existant est lu, pas réexécuté.
- F:\OpenLeague\crates\client\src\main.rs:601 : journal du nombre d’octets ; :1667 : libellé français « Chatiment » du sort Smite, sans rapport avec la messagerie.
- F:\OpenLeague\crates\core\src\penetration.rs:1 : description de l’objet LastWhisper, sans service de messages privés.

La précédente unité AUD-22.1-04-HUD-01 est réutilisée : son reçu et ses 498 fichiers client sont identiques, ses neuf routes ordinaires de texte restent identifiées. Aucun HUD de chat n’y avait été qualifié. Cette réutilisation évite un nouvel inventaire complet des textes natifs.

Lecture directe complémentaire :

- F:\OpenLeague\crates\core\src\lib.rs:280–328 : Action, ClientPacket et ServerPacket ne comportent pas de variante de chat. Le Snapshot lu séparément ne porte pas d’historique de messages.
- F:\OpenLeague\crates\core\src\session_transport.rs:79–95,146–151 : Input, ClientMessage et ServerMessage de la session reprise ne comportent pas de message de chat. Les types Command(Action), heartbeat et horloge ne remplacent pas ce contrat.
- F:\OpenLeague\crates\client\src\main.rs:1381 bloque les commandes lorsque shop.focused, et conserve les autres protections existantes. Aucun état de focus de chat n’est identifié dans cette route.
- F:\OpenLeague\crates\client\src\shop_ui.rs:357 relie le lecteur de texte à f.query. F:\OpenLeague\crates\client\src\shop_text_input.rs:20–42,63–76 traite la recherche du magasin : perte de fenêtre/focus, ordre des événements, Entrée/Échap qui retirent le focus. Les limites de requête et de presse-papiers appartiennent au magasin ; elles ne déterminent pas une limite de chat. Aucun accès au presse-papiers exécuté dans ce lot.

Conclusion bornée : chargement de la ressource de présentation présent ; consommateurs d’envoi/réception, historique et focus de chat **non identifiés** par cette recherche et ces routes inspectées. Cette recherche lexicale et structurelle n’est pas une preuve dynamique de toute absence dans un programme quelconque.

## 4. Vérifications, attendu et observé

Commande réellement exécutée le 2026-10-30 à 14:06:18–14:06:22 UTC :

    C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe -X utf8 -E -B F:\OpenLeague-work\audit-units\AUD-17.2-08-CHAT-01\audit_chat_contract.py

Code de sortie **0**, **41 contrôles statiques/d’identité réussis**, aucun échec. Python : SHA-256 f8b45d63047da9d9adf09892e4cc4317b859e86a93a478cc9616bc69d3b176e5. Ce nombre mesure les assertions du vérificateur, pas des tests de chat jouable.

| Cas / limite | Attendu | Observé | Portée |
|---|---|---|---|
| Entrée nominale native Add_Message | Insertion dans l’historique et rendu | Routage hôte→Hud→ChatBox et insertion présents | Sources AS2 |
| Dépassement de capacité | Éviction au-delà de la borne | Insertion en tête puis pop si >100 dans les deux scripts | Sources AS2 ; pas d’exécution du 101e message |
| Effacement | Tableau vide puis rendu | splice(0) et renderMessages présents | Sources AS2 |
| Temps et visibilité | Ne pas confondre masquage et éviction | Timeout de visibilité séparé ; aucune utilisation supplémentaire de messageLifeSpan dans les exports | Corpus AS2 délimité |
| Envoi équipe/global/Entrée | Identifier la frontière réelle | Appels film→hôte identifiés ; aucune livraison réseau prouvée | Source, pas de test entre clients |
| Restriction/refus | Ne pas accepter un affichage comme permission | Affichage SC4 identifié ; refus serveur et politique exacte non qualifiés | Limite explicite |
| Commandes de chat | Ne pas confondre API d’interface et syntaxe utilisateur | CommandParser et ChatInterrupt distingués ; grammaire historique non résolue | Aucun succès de commande revendiqué |
| Entrée de texte et combat | Qualifier le consommateur exact | Focus du magasin conservé ; focus de chat non identifié | Lecture du code Rust |
| Réutilisation | Ressources et preuves identiques | 62 exports, entrées/outils/journaux, provenance RADS et ancien corpus HUD vérifiés | Identités fraîches, anciens tests non relancés |
| Restriction utilisateur | Préserver les fichiers gelés et le cadrage | 19 fichiers logiciels et six fichiers contexte/méthode identiques | Contrôle de fichiers, aucune ouverture de base |

Contrôles non exécutés : tests Rust/Cargo, ActionScript/Scaleform, lancement du client original ou local, captures, serveur/deux clients, saisie de messages, permissions, spam, reconnexion, rendu multilingue, presse-papiers, installation ou migration. L’absence de ces essais empêche de déclarer la fonctionnalité vérifiée.

Quelques lectures exploratoires ont produit une sortie terminal tronquée ; elles ne servent pas de preuve exhaustive. Le vérificateur utilise des sélecteurs délimités, conserve les identités et fragments nécessaires, et ne dépend pas de ces sorties tronquées.

## 5. Écarts et inconnues maintenus ouverts

Résolu dans ce périmètre documentaire : ressources exactes retrouvées ; capacité et éviction de l’historique identifiées dans les deux scripts ; interfaces hôte/film et branche d’affichage de restriction identifiées ; consommateurs locaux et fausses occurrences séparés. L’ancienne mention « capacité non qualifiée » est précisée ici pour les scripts, sans clore l’inconnue du comportement intégré.

Restent ouverts :

1. Sélection effective menu/Menu_SC4 et valeurs éventuellement imposées par le C++ hôte. Entrée de reprise : trace datée du film monté ou chaîne de sélection qualifiée sur le binaire 4.20 identifié.
2. Gestionnaire C++ de ChatSend, Press_SendTeam/All, ChatInterrupt et événements d’entrée ; catalogue et grammaire des commandes historiques. Entrée : correspondances de callbacks/code et règles de dispatch qualifiées, ou observation contrôlée de la référence ; une simple chaîne de caractères ou un nom d’API ne suffit pas.
3. Permission équipe/global, destinataires, restrictions et refus, confidentialité, longueur/encodage, débit et erreurs réseau. Entrée : contrat source/trace exact ou décision locale explicitement documentée quand l’historique reste inconnu. Ne pas transformer un contrat local en fidélité native.
4. Implémentation Rust d’un message et de son cycle de vie. Entrée : tâche fonctionnelle autorisée séparément et contrat de transport identifié ; consumer client/serveur réellement relié.
5. Capture de saisie de chat et suppression des intentions de combat, avec états de fermeture, perte de focus et session. Entrée : mode de saisie réel, routage des événements et vérification du consommateur de commandes final.
6. Conformité visuelle, rendu des entités/balises, Unicode, comportement au scroll et à la reconnexion. Entrée : implémentation et environnement de test identifiés ; essais propres à ces clauses.

Ces inconnues n’empêchent pas de clore l’identification de cette frontière ; elles empêchent de clore les exigences fonctionnelles et les clauses natives hors périmètre. Le présent audit ne déclare aucun actif manquant pour les constats établis. Il documente les contrats et consommateurs encore non qualifiés.

## 6. Corrections et conditions de reprise, sans changement de plan

Réutilisation des quatre tâches existantes. Les suffixes ci-dessous identifient uniquement des sous-lots proposés dans ce compte rendu ; aucune tâche/case n’est créée dans l’application. Chaque sous-lot doit produire un résultat autonome avant le suivant. Les corrections ne sont pas exécutées ici.

| Sous-lot documentaire sous la tâche existante | Travail restant et consommateur | Critère de fin et contrôle attendu |
|---|---|---|
| SYS-17.2-08 / C1 contrat de message | Définir canal, identité d’auteur, destinataires et refus dans les schémas core et le serveur ; distinguer règle historique connue et choix local | Contrat précis sourcé ; un message équipe n’atteint que les destinataires autorisés ; canal/auteur invalide refusé explicitement |
| SYS-17.2-08 / C2 livraison | Relier envoi/réception serveur-client au contrat retenu ; dépend de C1 et de la confidentialité D13-SYS-13-3 | Deux clients d’une équipe et un adversaire identifiés ; envoi équipe/global, refus et isolation observés ; versions/logs/bornes de livraison fournis |
| SYS-17.2-08 / C3 affichage | Ajouter le consommateur HUD de messages et restrictions, à partir des styles et du film sélectionné | Canaux/auteurs/erreurs visibles, contenu rendu conformément au contrat ; captures nominales et limites, aucun succès fictif si transport échoue |
| SYS-17.2-09 / H1 stockage borné | Implémenter la file du consommateur de chat ; réutiliser la borne native de 100 si elle est retenue après qualification du montage | Cas 0/1/100/101, ordre et éviction du plus ancien ; capacité toujours bornée ; preuve sur la file utilisée par le HUD, pas une fixture isolée |
| SYS-17.2-09 / H2 cycle d’historique | Relier affichage normal/étendu, effacement et masquage ; expliciter la politique de nouvelle partie/reconnexion | Masquer ne supprime pas ; effacer vide ; événements de session appliquent la politique documentée ; essais sur le consommateur réel |
| SYS-17.4-07 / K1 grammaire | Identifier les handlers natifs puis décider une liste fermée de commandes réellement applicables au serveur local | Une fiche par commande retenue : syntaxe, arguments, acteur/droits, effet et refus ; alias non établi conservé inconnu ; aucune commande CheatEvents adoptée sans preuve |
| SYS-17.4-07 / K2 dispatch | Relier le parseur de saisie à chaque handler autorisé ; dépend de K1 et du transport | Nominal, mauvais argument, permission refusée et commande inconnue ; erreurs explicites ; aucune commande non implémentée annoncée comme réussie |
| SYS-17.4-08 / F1 focus | Ajouter un mode de saisie de chat dans la route d’événements et son état session/fenêtre ; préserver le magasin et les protections présentes | Ouverture, fermeture, perte de focus, changement de session et répétition de touche documentés ; intention déjà tenue traitée explicitement |
| SYS-17.4-08 / F2 combat | Bloquer au consommateur final les actions de combat/déplacement pendant le mode chat ; dépend de F1 et de D09-SYS-09-4 | Saisir Q/W/E/R, raccourcis, Entrée/Échap et interactions pointeur ne déclenche aucune action interdite ; contrôle avant/après fermeture ; preuve client et serveur réel |

Aucune recherche externe ou analyse REA générale relancée. La nouvelle piste concrète pour une éventuelle unité native suivante est le rattachement des callbacks maintenant identifiés au C++ hôte. Arrêt de cette recherche dès qu’un handler et sa frontière sont qualifiés, ou à une dépendance précisément nommée ; ne pas repartir sur une exploration globale du runtime sans lien à cette question.

## 7. Livraison identifiée, conservation et relecture

Fichiers nouveaux du lot, tous isolés :

- F:\OpenLeague\docs\audit\units\AUD-17.2-08-CHAT-01.md — ce compte rendu, seul nouveau fichier dans le dépôt.
- F:\OpenLeague-work\audit-units\AUD-17.2-08-CHAT-01\extract_chat_sources.py — producteur de l’extraction ; SHA-256 04d47d2c3d53652d40f9975c027308845a4233d0fa20732d60117519fcc1819d.
- F:\OpenLeague-work\audit-units\AUD-17.2-08-CHAT-01\chat-extraction-receipt.json et ffdec-menu.log / ffdec-Menu_SC4.log — extraction fraîche, terminée.
- F:\OpenLeague-work\audit-units\AUD-17.2-08-CHAT-01\extracted\menu et extracted\Menu_SC4 — 62 fichiers sources dérivés, tous hachés dans le reçu ; aucune ressource d’origine remplacée.
- F:\OpenLeague-work\audit-units\AUD-17.2-08-CHAT-01\audit_chat_contract.py — vérificateur isolé ; 16613 octets ; SHA-256 8e78ca1f6d838d7492e21ae2aba280a2e7d4e7bf7cbc850cace762dcf24ecf79.
- F:\OpenLeague-work\audit-units\AUD-17.2-08-CHAT-01\chat-contract-proof.json — 518814 octets ; SHA-256 b37673bddaf069bcbcef483c419db9ecd7186d11104a4e847923a430dc8c8906 ; 41/41 contrôles statiques/d’identité, fin 2026-10-30T14:06:22.621043+00:00.

État Git observé avant livraison : main, HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 1943 entrées préexistantes. Cet état n’est pas une version propre du jeu. Aucun add, commit, reset, checkout ou nettoyage. Les identités des fichiers effectivement consommés dans ce lot sont dans la preuve.

Conservation : les 19 fichiers préparés lors de l’intervention annulée restent identiques à F:\OpenLeague-work\audit-method-20261030\WITHDRAWAL_INVENTORY.json. Les six fichiers de cadrage/contexte restent identiques. Aucun lancement d’OpenLeague Plan, de CLI de travail ou de Store ; aucune base ouverte, aucun état de case modifié. Les bases ne sont pas réauditées par ouverture ou requête. Aucun changement du goal ni de ses critères ; aucune installation, migration, relance ou retrait automatique. Aucun fichier logiciel existant modifié.

Relecture des sept rubriques : périmètre et exclusions explicites ; provenance/identités et sélection non résolue ; consommateurs et recherche d’absence bornés ; attendu/observé et non-exécuté séparés ; inconnues et reprises nommées ; corrections rattachées aux tâches existantes avec critères précis ; livrables datés/hachés et conservation vérifiable. Aucun résultat de cet audit ne signifie que les quatre fonctionnalités, le goal global, un champion ou le jeu sont terminés.