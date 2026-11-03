# AUD-17.4-08-CHAT-FOCUS-01 — Focus du chat et combat

Date : 2026-10-30. Projet : F:\OpenLeague. Goal SYS-01.2-02 ; tâche SYS-17.4-08 ; exigence OLF-f51fd482-c241-572e-a85e-10ecbe4003f3 ; inconnue OLU-e87ab149-2826-528a-9bc4-4fbe77da6b15.

## 1. Exigence et décision bornée

Exigence entière auditée : « Empêcher les saisies de chat de déclencher des commandes de combat ». Son critère produit existant exige intégration dans le vrai consommateur, comparaison 4.20 et succès/refus/limites documentés. Il demeure inchangé et non satisfait dans le jeu actuel.

Question : distinguer focus du champ, drapeau logique d’ouverture, destinataire courant des entrées et gardes actuelles de combat. Critères du lot : sources identifiées ; vrais consommateurs inspectés ; refus et frontières natifs vérifiés ; lacunes et corrections précises ; sept rubriques relues. Arrêt avant arbitrage complet du dispatcher, transmission au film et transition Windows. Ces bornes d’audit ne modifient aucun critère normatif.

| Dimension | Décision |
|---|---|
| Audit | Terminé avec preuves pour l’état courant après relecture finale ; source native partielle et absence actuelle délimitée documentées. |
| Implémentation | Gardes boutique/inventaire/contexte présentes ; état de chat et protection correspondante non identifiés dans les consommateurs inspectés. |
| Vérification | 110 contrôles sur 13 cas natifs bornés : huit refus/retours précoces complets et cinq préfixes arrêtés ; aucun clavier, combat ou film réel exécuté. |
| Acceptation humaine | Non demandée ; aucune acceptation produit inférée. |

Cette clôture documentaire ne coche pas la tâche a_faire, ne ferme pas l’inconnue du registre et ne déclare aucune fonctionnalité ou totalité du goal terminée. Les autres exigences de chat restent distinctes.

## 2. Sources historiques et identités

Référence LoL 4.20.0.315, EUW, en_GB. PE original :

`D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`

15 973 880 octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; ImageBase0x400000. Adresses ci-dessous : VA, fins exclusives. Sept fonctions contiguës, 279 instructions, fins RET. Aucun nouveau binaire.

| Fonction | Instructions | Rôle source |
|---|---:|---|
| 7AD4B0–7AD4C8 |9| garde E9, puis tail-call793DC0, sinon AL0 |
| 7AD4D0–7AD4E8 |9| garde E9, puis tail-call793EE0, sinon AL0 |
| 793DC0–793ED2 |92| identité du destinataire courant puis branche d’entrée de tag1 |
| 793EE0–793FB6 |80| même identité puis branche de tag0 |
| 791BD0–791BD4 |2| getter manager+0x20 |
| 7ACEC0–7ACF0E |20| E9=1 avant demandes d’ouverture/texte |
| 823450–823520 |67| fermeture logique, requêtes du film et transition de mode ; voies Windows exclues de l’exécution |

Vtable chat0x10B8310 : slots+0x18/+0x1C→7AD4B0/7AD4D0. Vtable gestionnaire0x10B68B4 : slot+0x24→791BD0. Littéraux : Text_Entry_Open, Chat_SetInputText, Text_Entry_Close, ClearChatInterrupts, AddChatInterrupt. Leur appel n’est pas une réception prouvée du film.

Sources AS2 extraites antérieurement des deux HudChat.gfx natifs : menu/ChatBox.as127–148 acquiert Selection.setFocus ;149–167 efface/masque ;470–521 traite Enter/ChatSend et les interruptions. Menu_SC4/ChatBox.as111–127 délègue à ChatBoxGraphicBase.as37–69, qui acquiert le focus et le retire explicitement par Selection.setFocus(null). Le fragment de fermeture menu ne contient pas cet appel : ne pas généraliser la politique SC4.

Les deux variantes déclarent Key.addListener(this). Cette déclaration ne prouve ni les événements reçus ni leur consommation globale. readyForInput/filterInput concernent la logique interne du champ ; aucun blocage de combat n’est déduit de ces seuls noms.

Preuves réutilisées et épinglées :

- [Sources du chat](F:/OpenLeague-work/audit-units/AUD-17.2-08-CHAT-01/chat-contract-proof.json), SHA-256 `b37673bddaf069bcbcef483c419db9ecd7186d11104a4e847923a430dc8c8906` : films, extraction AS2 et corpus initial.
- [Gestionnaire/propriétaire](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-OWNER-LIFETIME-01/native-owner-lifetime-proof.json), SHA-256 `edd27ca923c7d785eb19f40ac7d5e510c399eb1066e3ad0ec145c4bf619d8609` : cache et vtables originaux, constructeur et états distincts.
- [Historique consolidé](F:/OpenLeague-work/audit-units/AUD-17.2-09-HISTORY-REQUIREMENT-01/history-requirement-proof.json), SHA-256 `57f1f97759a5da21a5d44558d4d2cadbc2af4356a73368d9790cb3b0dbc1dd23` ; [relecture](F:/OpenLeague-work/audit-units/AUD-17.2-09-HISTORY-REQUIREMENT-01/delivery-readback.json), SHA-256 `9902d313fe206f70e4dab30b4ef1142cddf2822b33bc7867af98c903cc9abd56` : inventaire courant et recherche étendue au launcher. Pas de replay de ces anciens cas.

Python, pefile2024.8.26, Capstone5.0.7 et Unicorn2.1.4 existants et identifiés ; aucune installation, extraction supplémentaire ou import REA/Ghidra.

## 3. Contrat et consommateurs réels

E9 est initialement nul par l’écriture DWORD+E8 dans le constructeur concret, source héritée. 7ACEC0 le pose à1 avant le premier appel du film ;823450 le remet à0 avant sa première requête de fermeture. Ce drapeau logique n’est pas une observation du focus effectivement acquis.

Les deux méthodes virtuelles retournent AL0 si E9=0. Sinon leurs corps de base demandent le destinataire courant au vrai gestionnaire et comparent son identité au chat : différent→AL0 sans forwarding ; identique→continuation de traitement d’entrée. L’arbitre amont et l’utilisation de ces retours pour consommer/propager une entrée vers le combat restent non qualifiés. Ni AL0 ni AL1 ne démontrent ici une action de combat autorisée/interdite ou un affichage.

| État | Rôle distinct |
|---|---|
| Selection.setFocus | demande de focus du champ dans le film |
| chat+E9 | état logique de saisie, garde de deux méthodes |
| manager+0x20 | destinataire comparé par identité |
| état générique+0x98 | participation aux entrées, preuve héritée ; pas le mode de saisie |
| film+4 | pointeur du pont ; pas une garantie de focus ou de chargement |

Consommateurs actuels examinés :

- `crates/client/src/spell_input.rs:47–58` collecte en PreUpdate après InputSystems ; clear_frame vide les intentions du frame et reset retire les états après perte de fenêtre/focus. Aucun état de chat identifié. Les tests existants ne sont pas réannoncés comme exécutés.
- `crates/client/src/main.rs:819–843` ordonne shop_ui::update avant commands dans Update. `main.rs:1366–1387` applique inventaire, certains survols du HUD d’apprentissage, shop.focused, connexion et victoire avant consommation des raccourcis. Aucun état de chat dans cette garde.
- `shop_ui.rs:355–358` relie l’éditeur à f.query/f.focused. `shop_text_input.rs:20–76` traite activation, répétitions, identité session/fenêtre, Ctrl+V/AltGr et Entrée/Échap pour la boutique. Sa limite de64 caractères et celles du collage ne sont pas des limites de chat.

Le garde de boutique est conservé et ne constitue pas le consommateur de chat demandé. Aucun renommage du magasin ne serait une preuve d’implémentation.

Corpus courant : 1 168 sources Rust/JS/HTML, empreintes conservées. Recherche de chat réutilisée depuis le lot précédent pour1 158sources communes et dix sources launcher ; aucune répétition inchangée. Nouvelle recherche limitée aux quatre adresses, Text_Entry_Open/Close et ChatBoxGraphicBase : aucun adaptateur exact trouvé, contrôles positifs/négatif réussis. La conclusion d’absence est bornée à ces sources et interfaces, sans nier tous les systèmes d’entrée du projet.

## 4. Attendu, observé et vérifications

Python existant, `-X utf8 -E -B verify_chat_focus.py`,2026-10-30T17:53:52Z–17:53:56Z, code0 :110/110 contrôles réussis sur13cas. Aucun patch/stub. Le cache global0x2D78CB4 est une donnée fournie avec vtable originale et destinataire choisi. Objets/pile/chaîne d’exception sont des fixtures. Aucune écriture CPU de l’image PE. Limites100000instructions/deux secondes. Les traces consignent les instructions distinctes et leurs octets, pas toute la chronologie répétée.

| Cas | Attendu et observé | Limite |
|---|---|---|
| Deux slots, E9=0 | AL0, deux retours complets conformes | aucun film ou combat |
| Deux slots ouverts, destinataire nul | AL0 après vrai getter, deux retours conformes | chaîne d’exception restaurée |
| Deux slots ouverts, autre destinataire | même refus d’identité, deux retours conformes | aucune transmission |
| Deux slots ouverts, même destinataire | continuation atteinte, deux préfixes conformes | arrêt avant traduction/caractère/film |
| Ouverture depuis E9=0 ou1 | E9=1, film nul, deux préfixes conformes | arrêt avant premier call ; focus AS2 non exécuté |
| Chat absent/inactif et drapeau265 fourni1 | AL0, deux retours complets conformes | sens global de265 non inventé |
| Fermeture depuis E9=1 | E9=0 avant requête, un préfixe conforme | arrêt avant792D60 ; aucun service Windows |

Huit chemins complets de refus/retour précoce ne sont pas huit séquences de combat bloquées. Cinq préfixes restent des arrêts explicites. Le focus réel, IME et les touches physiques ne sont pas remplacés par des fixtures présentées comme preuve réelle.

Autres contrôles frais : identités, décodages, vtables, littéraux, sources AS2, code courant, registres lus comme données, conservation. Non exécutés : clavier/souris réels, film, propagation dispatcher/combat, IME/collage/AltGr en chat, Windows, réseau/serveur, tests/build Rust, jeu complet et acceptation humaine.

La première génération du rapport a échoué avant toute écriture à cause d’un import manquant dans son formateur. Elle n’a altéré aucun artefact ; la présente génération et la relecture lui succèdent. Les110contrôles natifs/documentaires étaient déjà réussis et ne sont pas rejoués pour cet incident.

## 5. Manques et conditions de reprise

L’inconnue garde sa formulation V124 et status=open : le garde du magasin ne qualifie pas le chat. Le lot ajoute les ancres natives et la frontière exacte de leur preuve, sans fermer le registre.

| Manque/inconnue | Entrée et résultat nécessaires |
|---|---|
| Mode réel de chat absent du consommateur inspecté | Champ/état relié à fenêtre et session, consommé par la route finale d’actions ; aucune substitution du focus boutique. |
| Arbitrage natif complet | Callers des slots+18/+1C, ordre et utilisation des retours ; suivre une même touche entre édition et combat. |
| Focus réel contre E9 | Ouvertures/fermetures réussies et ratées, perte de fenêtre et remplacement ; observer champ, destinataire et commandes séparément. |
| Transition au même frame | Ordre KeyboardInput/activation, touche tenue/répétition ; aucune intention ancienne rejouée après fermeture ; réutiliser clear_frame/reset. |
| IME, AltGr, collage, rebindings | Événements et configuration identifiés ; texte observé sans action interdite, sans reprendre les bornes du magasin comme limites du chat. |
| Protection finale | Actions émises observées côté client et serveur avant/pendant/après saisie. Politique des clics volontaires et exceptions qualifiée distinctement. |
| Session | Deux identités et perte/reprise de focus ; aucun état de saisie ou raccourci hérité à tort. |

Ces inconnues limitent fidélité et implémentation. Elles n’empêchent pas de renseigner les sept rubriques sur l’exigence dans son état actuel : sources partielles nommées, consommateurs, observations bornées, manques et actions vérifiables. La fonctionnalité reste ouverte ; l’audit documentaire peut être clos. Les recherches ne sont pas répétées sans nouveau caller, modification ou observation. Le goal global demeure actif et incomplet.

## 6. Corrections petites, identifiants conservés

Propositions documentaires sous la tâche existante ; aucune fiche insérée ni critère normatif réécrit.

| Référence | Objectif unique | Critères futurs |
|---|---|---|
| SYS-17.4-08 / F1 focus, réutilisé | Mode réel de saisie distinct de la boutique | Ouverture/fermeture, identité fenêtre/session, destinataire et champ observés ; touche tenue/répétition traitées explicitement. |
| SYS-17.4-08 / F2 combat, réutilisé | Protection au vrai consommateur d’actions | Saisir touches/raccourcis sans action interdite ; contrôle avant/après ; preuve client/serveur ; préserver inventaire, boutique, connexion et fin de partie. |
| SYS-17.4-08/F1-TRANSITION, précision proposée | Transition sans intention rejouée | Activation/perte de focus et événement au même frame ; touche tenue/relâchée ; ordre réel et clear_frame/reset réutilisés. |
| SYS-17.4-08/F1-TEXT-INPUT, précision proposée | Composition/édition réelle du texte | IME, AltGr, collage, répétition et annulation ; résultat de texte et absence d’action issue de cette saisie. |

Les propositions F1/F2 antérieures sont conservées. F2 mentionnait déplacement/interactions pointeur : ce texte n’est pas une preuve que le natif interdit tout clic volontaire. La politique historique/locale doit être qualifiée avant réalisation ; aucun critère existant n’est changé ici.

Prérequis hérité : D17-SYS-17-4 requiert D09-SYS-09-4. Commandes et ordre PreUpdate/Update actuels sont des acquis. Aucune reconstruction intégrale des classes/offsets historiques n’est ajoutée au besoin produit.

## 7. Livraison et conservation

Fichiers nouveaux uniquement :

- Présent rapport : `F:\OpenLeague\docs\audit\units\AUD-17.4-08-CHAT-FOCUS-01.md`.
- [verify_chat_focus.py](F:/OpenLeague-work/audit-units/AUD-17.4-08-CHAT-FOCUS-01/verify_chat_focus.py),17 027 octets ; SHA-256 `c48f85cbd7952b21699f95a6d6b309c7063f2f0025428a12be5947dd60956c73`.
- [chat-focus-proof.json](F:/OpenLeague-work/audit-units/AUD-17.4-08-CHAT-FOCUS-01/chat-focus-proof.json),191 777 octets ; SHA-256 `e028beb51ada9ee1442735dfc32a4b1cae7f2926ea00cd3c976537da05278209`.
- Relecture finale : `F:\OpenLeague-work\audit-units\AUD-17.4-08-CHAT-FOCUS-01\delivery-readback.json`. Le reçu principal antérieur conserve audit_scope_closed=false ; la relecture peut porter la clôture documentaire après examen des sept rubriques.

La relecture vérifie110contrôles,13cas et séparation8/5, octets exécutés, sources/vtables, consommateurs, limites/actions, empreintes et conservation. Les totaux ne deviennent pas des taux de fidélité ou de jeu terminé.

Conservés :19fichiers logiciels gelés,6documents d’instructions/contexte/méthode, registres, preuves et1 168sources ; HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, mêmes76fichiers suivis déjà modifiés. Aucun stage/commit/reset, retrait, nettoyage ou restauration.

Goal, critères, plan, application de suivi, interface et bases inchangés. Runtime non invoqué, bases non ouvertes. Aucune installation, migration, relance ou nouveau binaire. Le lot précédent est une progression vérifiée ; la présente clôture d’audit ne ferme aucune fonctionnalité ni le goal global.
