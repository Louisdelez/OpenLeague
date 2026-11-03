# AUD-17.4-07-EMOTES-01 — Danse, provocation, rire et blague

2026-10-30 ; projet F:\OpenLeague ; goal SYS-01.2-02. Parents SYS-17.4-07 (commandes de chat) et SYS-17.4-08 (saisie/commandes de combat). Inconnues conservées OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38 et OLU-e87ab149-2826-528a-9bc4-4fbe77da6b15. Référence LoL4.20.0.315 PUBLIC/Releases/4.20 EUW/en_GB, catalogue4.20.1.

## 1. Question, sortie et décision

Question : comment les quatre commandes déclenchent-elles une requête native, et quels consommateurs/ressources existent actuellement dans OpenLeague ?

Le tour précédent est classé **progrès** : déclencheurs pause/reprise et raccordement à leur mécanisme existant audités. Nouveau lot cohérent : quatre wrappers utilisant un même helper, ses gardes/champs sortants, les ressources candidates et les frontières Rust. Sortie : identifiants établis, retours distingués, ressources préservées et écarts précisément décrits. Exclusions : implémentation d’émotes, serveur Riot, réception/rendu natifs complets, admission de tous les skins et validation visuelle.

**Audit terminé pour cette frontière de requête et cet inventaire de candidats.** Implémentation : aucune modification ; aucun raccordement d’émote identifié dans les schémas et le sélecteur inspectés. Vérification : statique, métadonnées et identités. Acceptation humaine : non demandée. Les parents et le goal restent ouverts.

Prérequis : les registres tâches/lots sont relus par identité ; D17-SYS-17-4 requiert D09-SYS-09-4, non déclaré acquis ici. Les ressources nécessaires à la question sont disponibles. Aucun statut, objectif ou critère normatif modifié.

## 2. Sources et provenance

PE original : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe ;15973880octets ; SHA-256 **402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862**.

Réutilisation du catalogue F:\OpenLeague-work\audit-units\AUD-17.4-07-COMMANDS-01\commands-catalogue.json, SHA567a26d25c715de378f2782b5db6629cecaccdd12efb18ff6bacbb11947710f0. Les noms, alias et champs de callback restent inchangés ; aucune nouvelle extraction des films.

Déclarations d’entrée : DATA\cfg\defaults\Input.ini du déploiement original, SHA930f1499991e9c4973e81086a26c944b7330058970c4227a614b897eae09fec1. Ce sont des défauts déclarés, sans preuve de sélection effective ni trace complète de leur gestionnaire C++.

Ressources locales : F:\OpenLeague\data\4.20\animation_manifest.json ; F:\OpenLeague\assets\champions\annie.glb, aatrox.glb, ezreal_joint_identity_local.glb. Le reçu ancien F:\OpenLeague\docs\animation_binding_validation.json décrit122modèles et920liaisons de rôles, avec limites de nom/indice ; il n’est pas réexécuté et ne qualifie pas les émotes.

Python, pefile et Capstone existants, identifiés dans la preuve, lisent les octets originaux et les métadonnées GLB. Aucun nouveau PE, téléchargement, installation, session REA ou processus de jeu. Le répertoire W ci-dessous est F:\OpenLeague-work\audit-units\AUD-17.4-07-EMOTES-01.

## 3. Contrats et consommateurs

### Déclencheurs et requête

| Commande | Champ0x18 du catalogue | Indice poussé vers0x825880 | Déclaration de touche native |
|---|---|---:|---|
| dance |0x7A4200|0|GameEvents/evtEmoteDance=[Ctrl][3]|
| taunt |0x7A4290|1|GameEvents/evtEmoteTaunt=[Ctrl][2]|
| laugh |0x7A43B0|2|GameEvents/evtEmoteLaugh=[Ctrl][4]|
| joke |0x7A4320|3|GameEvents/evtEmoteJoke=[Ctrl][1]|

Le lien commande→indice est établi par les instructions et le catalogue. Le lien complet des événements clavier vers ce helper reste à qualifier ; la proximité des noms ne remplace pas cette preuve.

Le helper0x825880–0x82594D, fin exclue, prépare un tampon de6octets : octet0=0x48 ; octets1–4=valeur lue par la chaîne de pointeurs du personnage ; octet5=indice0à3. Les six octets sont initialisés avant l’appel vtable+0x30 du récepteur0x2D787B8, arguments longueur,tampon,1,0. L’identité sémantique portée par les quatre octets et le framing/service complet restent non qualifiés.

Gardes statiques : contexte0x2D791A4 présent et initialisé attendu ; certaines combinaisons du résultat virtuel et du marqueur+0x17 interdisent la requête ; personnage absent, drapeau+0x69 de son sous-objet non nul, indice non signé>3 ou autre prédicat virtuel vrai mènent au retour AL=0. L’invariant de contexte absent/non initialisé passe par diagnostic et écriture nulle dans ces instructions : ce chemin n’est pas présenté comme un refus gracieux, ni exécuté.

Réutilisation de la preuve de pause : pour la classe représentée par la vtable0x10DEAC4, le slot+0x10 est0x99C930 et retourne byte+0x15==1. Les anciens probes identifient+0x15 comme paused et+0x17 comme marqueur. Cette lecture précise une garde **sous cette liaison de classe** ; la sélection effective du contrôleur en partie reste ouverte. Les autres prédicats ne sont pas arbitrairement renommés mort,étourdissement,cooldown ou permission.

Le helper retourne normalement1 après la demande d’envoi et0 sur ses gardes. Chacun des quatre wrappers remplace ensuite AL par1 au retour normal. Le résultat n’est donc pas une preuve d’envoi accepté, de diffusion serveur ou d’animation jouée.

### Réception distincte

La lecture des tables originales du répartiteur0x5882C6 montre que l’opcode0x48 donne l’index0x7B puis la cible0x58830A, sortie AL=0. Ce constat concerne **ce répartiteur entrant seulement** ; il ne démontre pas une absence globale de réception d’émotes. Il interdit de supposer que recopier la requête sortante dans ce chemin produit directement une animation. La réponse serveur et son consommateur restent à retrouver.

### Ressources candidates et rendu Rust

Le manifeste comporte122champions. Une recherche de sous-chaînes dans leurs noms de clips trouve des candidats dance/taunt/laugh chez122champions et joke chez89. Les33sans nom contenant joke ne sont pas déclarés privés d’une ressource ou d’une fonctionnalité : alias de graphe, animation partagée, audio et sélection de skin restent ouverts.

Aucune des quatre clés de rôle n’est explicitement présente dans les122entrées roles inspectées. Le consommateur F:\OpenLeague\crates\client\src\animation.rs:358–377 charge le manifeste et sélectionne pour Ezreal le modèle local joint_identity. :410–454 charge le GLB, crée un graphe à partir des clips et construit les rôles nommés. :790–833 choisit des rôles de mort,sort,déplacement,attaque,idle,etc. Aucun chemin d’émote n’est identifié dans ce sélecteur et les schémas Action/ClientPacket/Input/ServerMessage inspectés.

Les noms de métadonnées de trois GLB réels concordent dans le même ordre avec le manifeste : Annie18clips, Aatrox42, Ezreal sélectionné52. Annie et Aatrox possèdent notamment plusieurs clips de danse, dont boucle ou amorce ; Ezreal mélange base,cyber ettpa. Son seul candidat contenant joke est ezreal_cyber_joke. Ce nom ne suffit pas à l’admettre pour le modèle de base. Aucun fallback de skin ou rôle n’est inventé.

La présence de tous les clips dans un graphe ne relie pas une commande à un rôle valide. Courbes,cibles osseuses,sélection native de skin/graphe,lecture visuelle et interruptions ne sont pas vérifiées par ces métadonnées. Les119autres contenus GLB ne sont pas fraîchement examinés dans ce lot.

La recherche délimitée dans1149fichiers Rust sous crates/client/src,core/src,server/src utilise les cinq mots entiers dance,taunt,laugh,joke,emote, sans résultat. Les fichiers et empreintes sont conservés. Ce résultat lexical est complété par la lecture des schémas et du sélecteur ; il n’est pas une preuve dynamique ou exhaustive d’absence de tout comportement.

## 4. Contrôles réellement exécutés

Producteur final W\verify_emotes_v2.py, lancé avec Python -X utf8 -E -B. Fin2026-10-30T15:13:03.463608+00:00 : **code0 ;96contrôles statiques/d’identité réussis**. Cinq fonctions complètes,235instructions, plus fenêtres du répartiteur. Le complément pause-predicate-proof.json conserve les quatre instructions du getter, sans relancer les anciens probes.

| Cas | Attendu | Observé et portée |
|---|---|---|
| Quatre commandes nominales | Indice distinct et helper commun |0/1/2/3,wrapper et appel exacts ; source uniquement|
| Indice hors plage | Déterminer la garde |CMP3/JA vers AL=0 ; aucun appel natif exécuté|
| Contexte invalide | Distinguer invariant et refus normal |Diagnostic/écriture nulle identifié ; aucun essai de crash|
| Refus du helper | Déterminer le retour propagé |AL=0 du helper masqué par AL=1 du wrapper ; aucun refus serveur observé|
| Requête et réception | Ne pas supposer un loopback |6octets sortants ; ce dispatcher entrant va à la sortie fausse pour0x48|
| Ressources nominales | Conserver les acquis disponibles |122entrées inventoriées ; trois séquences de noms GLB concordantes|
| Noms/skins ambigus | Ne pas déclarer un rôle admis |Exemples boucle/amorce et cyber_joke explicités ;33cas sans sous-chaîne restent inconnus|
| Consommateur Rust | Inspecter schémas et sélection réels |Variantes/rôles d’émote non identifiés dans ces frontières ; recherche bornée documentée|
| Conservation | Préserver le travail existant |19fichiers gelés,six contextes,registres et sources contrôlés inchangés|

**Rectification de relecture :** j’ai initialement interprété l’affichage JSON/repr échappé comme une erreur de regex. Les motifs effectivement stockés dans v1 et v2 sont identiques, corrects et détectent les contrôles positifs ; leur préfixe a les codepoints92,98,40,100. V2 ajoute des contrôles positifs/négatifs, sans corriger de bug du motif. La phrase contraire conservée dans ses limits est une erreur d’interprétation, remplacée par W\search-interpretation-correction.json. Les deux reçus originaux sont conservés. Leurs résultats natifs/GLB et la recherche ne sont pas invalidés par cette mauvaise lecture de l’affichage.

Non exécuté : jeu, code natif isolé, ActionScript, tests Rust/Cargo, réseau, saisie, rendu, écoute audio, captures et acceptation humaine. Les cas du tableau sont des inspections statiques, pas des tests en partie. Aucun logiciel, asset ou fonctionnalité n’est reconstruit ici.

## 5. Résolu et conditions de reprise

Résolu : table commande/indice/déclaration clavier ; helper et requête sortante ; gardes et retour masqué ; limite du dispatcher entrant ; inventaire lexical122champions et trois témoins GLB ; frontières de consommation Rust.

Ouvert avec entrée de reprise :

- Contrôleur,identité et autres prédicats : lien de classe/runtime ou callers qualifiés ; aucune règle de gameplay inventée à partir d’un offset.
- Serveur et réception : message de réponse et consommateur exacts,autorité/validation/diffusion ; l’opcode sortant seul ne les décrit pas.
- Skin/graphe/ressource : descripteur natif du skin sélectionné,graphe et ANM correspondants pour chaque champion ; nom candidat conservé tant que cette liaison manque.
- Rôle,interruption et son : comportement observé ou contrat source concernant amorce/boucle,arrêt,mort,mouvement,attaque,sort,pause et voix. Une courbe ou un clip présent ne suffit pas.
- Entrée/retour utilisateur : parseur,alias,modificateurs et focus qualifiés,consommateur des refus identifié. Le retour1 du wrapper ne vaut pas succès.

Aucune recherche communautaire ou reconstruction n’est justifiée par les33seules absences de sous-chaîne joke. La prochaine entrée est le sélecteur natif/skin ou la réponse réseau nommée, pas un nouvel inventaire identique de noms.

## 6. Corrections réutilisées et lots atomiques

Réutiliser SYS-17.4-07/K2-dance,K2-taunt,K2-laugh,K2-joke et SYS-17.4-08/F1,F2. Aucun nouvel enregistrement de tâche ou de case.

| Petit lot documentaire futur | Résultat et critère de fin |
|---|---|
| K2-<commande>/intention | Alias et indice exact,acteur/session autorisés ; valeur invalide ou indisponible refusée clairement ; une intention ne déclare pas une animation déjà jouée|
| K2-<commande>/synchronisation | Contrat serveur/réception établi ou contrat local explicitement nommé ; deux clients observent le même événement sans double exécution ; refus et changement de session contrôlés|
| K2-<commande>/clip-<champion> | Une liaison par champion et skin admis : graphe,nom,indice,cibles et rôle vérifiés ; variantes/candidats ambigus restent ouverts ; aucun choix automatique du premier nom trouvé|
| K2-<commande>/cycle | Amorces/boucles,fin et interruptions conformes au contrat ; échec ou ressource non admise explicite ; animation/voix distinctes et preuves réelles de lecture|
| F1/F2-emotes | Saisie de chat,Ctrl et touches1–4 ne déclenchent pas de commandes de combat involontaires ; focus perdu,répétition et fermeture contrôlés ; consommateurs du magasin et des sorts conservés|

Ces propositions découpent les écarts ; elles ne modifient ni le goal ni ses critères normatifs. Aucune correction fonctionnelle exécutée. L’audit s’arrête à la frontière décrite ; chaque commande et chaque ressource réclame son propre résultat d’implémentation/vérification.

## 7. Livraison et relecture

Seul nouveau fichier du dépôt : F:\OpenLeague\docs\audit\units\AUD-17.4-07-EMOTES-01.md.

Nouveaux fichiers isolés dans W : verify_emotes.py et verify_emotes_v2.py ; emote-proof.json et emote-proof-v2.json ; resource-candidates.json et resource-candidates-v2.json ; pause-predicate-proof.json ; search-interpretation-correction.json. Les versions initiales et la rectification sont conservées.

Preuves finales :

- emote-proof-v2.json :333668octets ; SHA-256 **c41a86e0f420876cb063913861241617dec97bf18453d2072443572522e743c3**. Producteur v2 :12168octets ; SHA2110e340727dd64c1b11a51699becb00240d1e6fc4f1db180aea7b1718490260.
- resource-candidates-v2.json :144347octets ; SHA-256 **5003120a0ccce9e66bf3acc95e021f369776c220ca2510289458dedfb0ab7716**. Inventaire par champion,noms,indices,candidats et échantillons.
- pause-predicate-proof.json :2570octets ; SHA-256 **83b3b5536e5557692397c968a7c93feca50b5738a975a1c86d0a7bd12f833ffc** ; lien de classe conditionnel et preuves héritées.
- search-interpretation-correction.json :1908octets ; SHA-256 **58d6cbf01e6c6af5f32bb83fc75828d59e939505112194a3255d78765c18a7bc** ; à lire avec les limites de v2.

Les trois GLB sont hachés dans l’inventaire ; aucune modification de leurs octets. Git observé : HEAD8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,76modifications suivies préexistantes (-uno). Aucun add/commit/reset/checkout/clean. Goal,critères normatifs,application de suivi,registres,bases et19fichiers gelés préservés ; aucune base ouverte ni application relancée.

Les sept rubriques sont relues : portée et exclusions,sources identifiées,consommateurs et recherche bornée,attendu/observé/non-exécuté,limites/reprise,corrections atomiques existantes,livrables/conservation. La clôture de cet audit ne termine ni les quatre commandes,ni les animations des122champions,ni le jeu,ni le goal global.