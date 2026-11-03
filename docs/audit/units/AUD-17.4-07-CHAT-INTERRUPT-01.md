# AUD-17.4-07-CHAT-INTERRUPT-01 — Saisie et accès au registre de commandes

Date : 2026-10-30. Projet : F:\OpenLeague. Goal parent : SYS-01.2-02. Référence : LoL4.20.0.315 PUBLIC/Releases/4.20, EUW/en_GB ; catalogue4.20.1.

## 1. Question, frontières et décision

Question : que transporte ChatInterrupt, quelles conditions donnent accès à son traitement et jusqu’où le résultat remonte-t-il ?

Piste nouvelle issue d’AUD-17.4-07-CHAT-HOST-01 : le callback enregistré est 0x7ACAF0, dont le corps n’était pas encore audité. Le tour précédent est classé **progrès** : correspondances film→C++ établies, gardes/retours identifiés et anomalie de borne résolue dans une preuve séparée. Les anciennes sessions REA sont terminées ; aucune attente ou relance implicite.

Sortie : relier producteur AS2, callback, séparateurs, garde de commande et appels intermédiaires ; vérifier les branches pertinentes sur les octets originaux ; conserver consommateurs/évidence et nommer ce qui manque. Limites : aucune récupération du catalogue complet de commandes ou des handlers ; aucune implémentation, exécution du jeu, du code natif ou de l’ActionScript, aucun réseau/rendu.

**Audit terminé pour ce contrat de saisie et cette frontière du répartiteur.** Implémentation : aucune modification fonctionnelle ; les six consommateurs Rust examinés précédemment sont inchangés. Vérification : sources et instructions statiques seulement. Acceptation humaine : non demandée. SYS-17.4-07, SYS-17.2-08, SYS-17.4-08 et le goal global restent ouverts.

Prérequis : les registres de tâches et d’ordre des lots sont identiques à ceux relus au lot précédent. D17-SYS-17-2 requiert D13-SYS-13-3 (confidentialité), D17-SYS-17-4 requiert D09-SYS-09-4 (caméra/commandes au sol). Ces prérequis d’implémentation ne sont pas déclarés acquis. L’audit de lecture dispose des entrées nécessaires.

## 2. Sources et preuves réutilisées

Source originale : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe ; 15973880 octets, SHA-256 **402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862**, base0x400000. Identité vérifiée à nouveau.

Réutilisation par empreinte :

- F:\OpenLeague-work\audit-units\AUD-17.2-08-CHAT-01\chat-contract-proof.json ; SHA-256 b37673bddaf069bcbcef483c419db9ecd7186d11104a4e847923a430dc8c8906. Les deux exports ChatBox.as restent identiques au reçu d’extraction. Aucun nouvel export des films.
- F:\OpenLeague-work\audit-units\AUD-17.4-07-CHAT-HOST-01\host-static-proof-v2.json ; SHA-256 121f71f572935d32b19264e3f612283d3b4579b5b13e6e7d049366f57cc5dd2d. L’enregistrement ChatInterrupt→0x7ACAF0, la provenance de l’image et les limites de REA sont conservés.

La nouvelle lecture utilise pefile/Capstone déjà présents dans F:\OpenLeague\tools\pythonlibs, avec Python existant. Les versions, modules, DLL Capstone, producteur et binaire sont identifiés dans le reçu. Aucun téléchargement, installation, nouveau PE ou conteneur d’analyse. Le conteneur antérieur reste inchangé et n’est pas exécuté.

REA n’est pas relancé : son résultat sur l’enregistrement est réutilisé ; le conteneur réduit antérieur ne représente pas ce callback. Aucune nouvelle décompilation REA de ces fonctions n’est revendiquée. La lecture directe des octets originaux répond à la question, sans répéter un import ou étendre le conteneur.

## 3. Producteur, consommateurs et contrat observé

### Producteur AS2

Dans les deux exports sous F:\OpenLeague-work\audit-units\AUD-17.2-08-CHAT-01\extracted\<menu ou Menu_SC4>\scripts\__Packages\Riot\Hud\GameComponents\ChatBox.as, le motif inscrit par l’hôte est recherché dans la saisie, en relation avec le caret. L’appel contient une concaténation sans mécanisme d’échappement visible :

    ChatInterrupt : motif + "," + saisie + "," + caret

Les séparateurs et les gardes réels priment sur une interprétation du nom « interrupt ». Le catalogue des motifs fournis par l’hôte reste inconnu.

### Callback et helpers originaux

Cinq fonctions complètes sont conservées dans la preuve, avec **638 instructions décodées** :

| Fonction | Région, fin exclue | Contrat statique constaté |
|---|---|---|
| ChatInterrupt | 0x7ACAF0–0x7ACDB2 | Lit le deuxième argument du callback, examine les découpages et transmet conditionnellement un mot |
| Helper de découpage | 0x99A380–0x99A51B | Recherche une sous-chaîne séparatrice et construit un vecteur de fragments ; gestion des allocations externe |
| Écriture de valeurs16bits | 0x99BE50–0x99BF46 | Appelle un décodeur externe et écrit valeurs16bits ou branches de paire de substitution ; encodage complet non qualifié |
| Appelant intermédiaire | 0x7A7180–0x7A7255 | Construit une chaîne, initialise si nécessaire via0x857530, puis appelle0x7A33F0 |
| Garde/répartiteur | 0x7A33F0–0x7A35B1 | Vérifie longueur et premier octet '/', consulte une table et appelle un handler sélectionné |

Le callback commence par TEST du payload et branche directement à la sortie normale si le pointeur est nul. Sinon, le premier découpage utilise la virgule exacte à0x1086474. Un résultat d’au plus un élément saute le traitement suivant. Le deuxième élément de ce vecteur est découpé avec l’espace exact à0x1088BB8. Le code prépare son premier élément par une conversion, puis n’appelle0x7A7180 que si ce second vecteur comporte au moins deux éléments et si la longueur du deuxième est nulle. Cela ne signifie pas simplement « toute commande tapée » ni « toute saisie terminée par un espace » ; plusieurs espaces et fragments supplémentaires demandent leur propre qualification.

Le corps inspecté exploite explicitement la saisie portée par le deuxième segment. Aucun usage sémantique distinct du motif et du caret n’est établi dans ce corps. Le format ne doit pas être traité comme un protocole générique à champs échappés. Effets de virgules, guillemets et entrées mal formées non exécutés.

Les paramètres0x1FF/0x200 et le contrôle après doublement contre0x400 concernent cette préparation temporaire. Ils ne démontrent pas une longueur maximale de message de chat. Le décodeur0x99C2B0, le helper0xC9E21C, leurs erreurs, règles Unicode et locales restent ouverts.

### Garde '/' et retour

À0x7A3427, une longueur inférieure à2 mène à AL=0. À0x7A3440, un premier octet différent de0x2F mène à la même sortie. Le chemin suivant recherche un espace, extrait le nom et passe par des helpers de transformation/recherche vers la table owner+0x20. Leurs contrats complets ne sont pas inférés de leurs noms.

Si le résultat comparé est égal à la tête/sentinelle de cette table, la branche affecte BL=1 sans appeler le handler virtuel. Sinon, un objet est construit via0x7A3330, sa méthode vtable+8 est appelée et son AL est converti en booléen par TEST/SETNE. Ce résultat est un comportement du répartiteur local inspecté ; il ne prouve ni la politique serveur ni un refus explicite de commande inconnue.

L’appelant0x7A7180 ne transmet pas ce résultat AL comme contrat explicite jusqu’au callback. ChatInterrupt termine normalement par EAX=1, y compris dans les branches sans traitement. Ce retour ne doit pas servir d’accusé d’acceptation ou de livraison d’un message.

### Consommateurs Rust conservés

Six fichiers réutilisés et vérifiés inchangés : F:\OpenLeague\crates\client\src\main.rs, native_zip_provider.rs, shop_ui.rs, shop_text_input.rs ; F:\OpenLeague\crates\core\src\lib.rs et session_transport.rs. Les acquis restent le chargement de Chat.ini et la saisie/focalisation du magasin ; aucun raccordement nouveau au callback ou au répartiteur n’est ajouté. La recherche bornée antérieure dans1199fichiers Rust n’est pas présentée comme répétée ici, ni comme une preuve dynamique d’absence globale.

## 4. Attendu, observé et vérifications

Commande exécutée :

    C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe -X utf8 -E -B F:\OpenLeague-work\audit-units\AUD-17.4-07-CHAT-INTERRUPT-01\verify_interrupt_static.py

Résultat au2026-10-30T14:31:47.615394+00:00 : **code0,104contrôles statiques/d’identité réussis, aucun échec**. Ce compteur ne représente pas104tests de chat jouable.

| Cas | Attendu | Observé | Limite |
|---|---|---|---|
| Producteur nominal | Contrat exact de la charge utile | Même concaténation motif,saisie,caret dans les deux films | Export lu, pas d’ActionScript exécuté |
| Payload nul | Sortie sans parsing | JE0x7ACD88, EAX=1 et RET8 | Inspection de branche |
| Premier vecteur de taille≤1 | Aucun appel au répartiteur | CMP1/JBE saute la préparation du mot | Contrat normal du helper ; aucune injection/OOM exécutée |
| Deuxième vecteur trop petit ou deuxième mot non vide | Aucun transfert0x7A7180 | CMP2/JB et CMP longueur0/JNE sautent l’appel | Lecture statique, pas de test de saisie |
| Condition d’accès satisfaite | Transfert du mot préparé | Appel0x7A7180 puis0x7A33F0 | Conversion et handlers non entièrement qualifiés |
| Longueur<2 ou absence de '/' | Rejet à la garde du répartiteur | AL=0 ; ce résultat ne devient pas un refus explicite du callback initial | Aucun retour serveur observé |
| Résultat de recherche égal à la tête | Pas d’appel virtuel de handler dans cette branche | BL=1 puis retour bas AL | Sémantique complète du lookup et politique inconnues |
| Handler sélectionné | Observer la frontière de résultat | Appel vtable+8, TEST AL/SETNE BL | Handler concret hors lot |
| Conservation | Préserver sources et preuves | Deux reçus, exports, six consommateurs,19fichiers gelés, six contextes et registres inchangés | Aucune ouverture de base |

Non exécuté : jeu, conteneur comme programme, émulation native, ActionScript, Rust/Cargo, saisie réelle, réseau, deux clients, rendu, captures et acceptation humaine. Les branches du tableau sont des cas statiques, pas des résultats de test dynamique. Aucune installation, migration ou relance d’application.

## 5. Résolu, inconnues et conditions de reprise

Résolu : charge utile exacte du producteur ; séparateurs natifs ; gardes avant transfert ; adresse et conditions d’entrée du répartiteur '/' ; différence entre retour du handler, retour du répartiteur et retour normal du callback. Les anciennes preuves sont conservées.

Ouvert, avec entrées nécessaires :

- Catalogue réel et motifs de saisie : analyser l’initialisation0x857530 et les insertions de la table utilisée par0x7A33F0. Identifier sur preuve chaque nom, alias, handler et motif ; ne pas déduire un catalogue des seuls noms de fonctions.
- Politique des commandes et erreurs : qualifier la recherche0x5BD730 et la construction0x7A3330 pour accéder aux handlers concrets. Pour chaque commande retenue, établir arguments, droits, effets et refus. La branche retour1 sans handler ne prouve pas une réponse d’erreur au joueur.
- Découpage et conversion : qualifier helpers/erreurs, cas limites d’espaces/virgules et Unicode avant de transposer ce format. Un test de port Python ne remplacerait pas une observation native ou le consommateur réel.
- Autorité et livraison : disposer du chemin exact vers le service concerné et de son contrat ; ensuite tester équipe/global, refus et confidentialité sur clients identifiés. Aucun de ces résultats n’est fourni par ce callback.
- Protection du combat : mode de saisie réel et commande finale à relier, puis essais de touches/pointeur, fermeture, focus et changement de session. Le champ ou retour d’interface ne suffit pas.

Ces inconnues sont des clauses hors de la clôture de cette unité ; elles gardent les parents fonctionnels ouverts. Aucun fichier/actif manquant n’est inventé. Pas de recherche communautaire répétée : la prochaine piste est locale, nommée et directement reliée au consommateur.

## 6. Corrections réutilisées et petits lots proposés

Aucun nouveau goal, tâche, statut ou case. Réutilisation des tâches et inconnues existantes :

| Parent | Petit résultat à produire | Critères de fin |
|---|---|---|
| SYS-17.4-07 / K1 ; OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38 | Recenser les insertions du registre à partir0x857530 et le lien nom→handler | Inventaire délimité et sourcé ; noms/alias confirmés, chemins conditionnels et non-résolus explicites ; aucun handler réputé implémenté à partir de l’inventaire |
| SYS-17.4-07 / K1 puis K2 | Une fiche puis une implémentation autorisée par commande retenue | Syntaxe/arguments/droits/effet/refus définis ; nominal, invalide et non-supporté contrôlés au consommateur réel ; aucun succès fictif fondé sur le callback1 |
| SYS-17.2-08 / C1,C2 ; OLU-5abd1f66-bc04-5d6c-a130-33387ecf2888 | Contrat distinct d’admission et de livraison | Destinataires et permission établis ; succès/erreur réellement observés avec deux équipes ; confidentialité vérifiée |
| SYS-17.4-08 / F1,F2 ; OLU-e87ab149-2826-528a-9bc4-4fbe77da6b15 | Consommateur de focus puis suppression des intentions de combat | États d’entrée/sortie/session documentés ; Q/W/E/R et pointeur contrôlés sur la commande finale, avec magasin préservé |

Les petits lots C/K/F existent déjà dans AUD-17.2-08-CHAT-01 ; ces précisions documentent leur reprise et n’ajoutent pas de doublon dans le plan. Aucune correction fonctionnelle exécutée ici. Arrêt du présent lot à la frontière nommée du registre, avant l’exploration des handlers.

## 7. Livraison et relecture

Seul nouveau fichier du dépôt : F:\OpenLeague\docs\audit\units\AUD-17.4-07-CHAT-INTERRUPT-01.md, ce rapport.

Nouveaux fichiers isolés :

- F:\OpenLeague-work\audit-units\AUD-17.4-07-CHAT-INTERRUPT-01\verify_interrupt_static.py ;10243octets ; SHA-256 b5e029c0b911f68d887e9e2eb872e366c440e03d2332d84af5b09f1f87fe6688.
- F:\OpenLeague-work\audit-units\AUD-17.4-07-CHAT-INTERRUPT-01\interrupt-static-proof.json ;167520octets ; SHA-256 **f901b835c1f68aadeec817e8d57013f25e1094d0725160a5e29eabfd93fe3e17**. Contient identités, instructions, fragments AS2, cas non exécutés, critères, tâches parentes et limites.

Git observé avant écriture : HEAD8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca et76modifications suivies préexistantes (-uno). Aucun add/commit/reset/checkout/clean ou retrait. Les19fichiers gelés restent identiques à leur inventaire ; AGENTS,CURRENT,HANDOFF,DECISIONS,AUDIT_CHARTER et AUDIT_METHOD restent identiques. Aucun goal, critère normatif, application de suivi, registre ou base modifié ; aucune base ouverte. Les refus et anomalies des lots antérieurs restent conservés ; aucune nouvelle tentative de création de PE.

Relecture des sept rubriques : périmètre et exclusions explicites ; sources et identités réutilisées ; chaîne réelle et consommateurs délimités ; attendu/observé/non-exécuté séparés ; inconnues et reprises précises ; corrections existantes et critères ; livrables datés et conservation vérifiable. La clôture porte uniquement sur cette unité d’audit, pas sur le chat intégré, le catalogue complet, un champion, le jeu ou le goal global.