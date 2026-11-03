# AUD-17.4-07-CHAT-HOST-01 — Callbacks natifs du chat

Contrôle du 2026-10-30. Projet : F:\OpenLeague. Goal parent : SYS-01.2-02. Référence : LoL 4.20.0.315 PUBLIC/Releases/4.20, EUW/en_GB ; catalogue 4.20.1.

## 1. Question, périmètre et clôture limitée

Question : à quels callbacks C++ correspondent les appels des films HudChat, et que prouve leur retour sur l’acceptation d’un message ?

Lot issu d’AUD-17.2-08-CHAT-01, dont la nouvelle extraction fournit une piste précise : Press_SendTeam, Press_SendAll, ChatSend et ChatInterrupt. Le tour précédent est classé **progrès** : ressources/interfaces retrouvées, consommateurs Rust délimités et preuve livrée. Aucun processus ancien n’est supposé vivant.

Critères de fin : établir la liaison littéral→callback par les instructions ; examiner les wrappers équipe/global/Entrée, leurs branches normales et leurs gardes ; recouper REA avec les octets originaux ; distinguer retour de callback et livraison ; conserver les consommateurs et préciser les suites.

**Audit terminé pour cette frontière statique.** Les tâches SYS-17.4-07, SYS-17.4-08 et SYS-17.2-08 restent ouvertes. Le catalogue de commandes utilisateur, le serveur et le blocage du combat sont hors clôture. Implémentation : aucun ajout ; consommateur Rust de chat toujours non identifié dans les routes déjà auditées. Vérification : statique seulement. Acceptation humaine : non demandée.

Prérequis relus par réutilisation d’identité du registre des tâches et de l’ordre des lots : D17-SYS-17-2 requiert D13-SYS-13-3 (confidentialité) ; D17-SYS-17-4 requiert D09-SYS-09-4 (caméra/commandes au sol). Ces prérequis d’implémentation restent a_faire ; ils ne sont pas déclarés acquis par l’audit. Aucun goal, critère normatif, plan, statut ou base modifié.

## 2. Sources, provenance et méthode

Source native : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe.

Identité relue : 15973880 octets, SHA-256 **402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862**, PE32, base 0x400000. Cette observation n’exécute pas le client original.

Preuves réutilisées, inchangées :

- F:\OpenLeague\docs\audit\units\AUD-17.2-08-CHAT-01.md ; SHA-256 8fd13548a9f9a54a3a30b809b979b1c511ba13bf6329d321f703c08392f4710f.
- F:\OpenLeague-work\audit-units\AUD-17.2-08-CHAT-01\chat-contract-proof.json ; SHA-256 b37673bddaf069bcbcef483c419db9ecd7186d11104a4e847923a430dc8c8906. L’extraction des deux films n’est pas répétée. Les identités RADS et la sélection effective non qualifiée restent héritées de ce lot.

Répertoire de ce lot, noté W ci-dessous : **F:\OpenLeague-work\audit-units\AUD-17.4-07-CHAT-HOST-01**.

REA 6.4.0/Ghidra 12.1.4 déjà installés ont été utilisés par une session MCP locale privée pilotée en Node. Aucun connecteur REA n’était exposé dans les outils de la session. Aucun téléchargement ni installation. Le modèle des requêtes et de fermeture provient du script local revision743_rea_slice.mjs ; aucun ancien script de publication, de Store ou de migration n’est exécuté.

Un conteneur d’analyse déjà produit dans ce lot conserve six régions exactes du PE aux mêmes adresses virtuelles, avec des en-têtes et remplissages synthétiques : W\CHAT_HOST_analysis_container.exe, 17408 octets, SHA-256 152c477e136364db67d767c16be38bc891df0cc2c0e19f7240f5d858ceb52973. W\CONTAINER.json décrit les régions et leurs limites. Il ne représente pas le client complet et n’est pas lancé comme programme ; ses copies privées d’entrée REA servent à l’analyse uniquement.

Première session REA, 14:15:25–14:15:48 UTC : enregistrement 0x7AC910 analysé ; 0x7AC9E0 non reconnu comme procédure ; résultat terminal conservé, code 1. Fermeture du binaire, client et transport confirmée. L’analyse n’est pas présentée comme entièrement réussie.

Une création de second conteneur avec appels synthétiques a été refusée par le contrôle automatique, car elle dépassait le périmètre d’écriture retenu pour scripts, rapports et reçus. La commande n’a pas été exécutée et le second conteneur n’existe pas. Aucun contournement ni demande répétée de création de PE. La solution retenue utilise le conteneur existant et la lecture directe de l’original.

Seconde session REA, 14:19:04–14:19:20 UTC : interrogation des cinq fonctions restantes effectivement découvertes ; toutes résolues et analysées, code 0 ; bundle exporté et trois fermetures confirmées. Les résultats de la première fonction sont réutilisés. Aucun processus de cette analyse ne reste en attente selon les deux retours terminaux.

Limites de REA : les adresses d’helpers omis contiennent du remplissage dans le conteneur ; Ghidra y infère parfois __break/hasNoReturn. Ces inférences ne qualifient pas le runtime historique. Le pseudocode de ChatSend est même déclaré void malgré MOV EAX,1/RET8 dans l’original. Les instructions originales et leurs conventions de pile priment sur ces signatures reconstruites.

## 3. Consommateurs natifs et actuels

À 0x7AC910, la même séquence construit l’adaptateur par 0x65C4C0 puis enregistre le nom par 0x7931E0. Les cinq couples reposent sur les adresses poussées, les littéraux exacts et les deux appels ; aucun rapprochement par seul nom.

| Appel du film | Adresse du littéral | Callback enregistré | Corps traité |
|---|---|---|---|
| Press_Close | 0x10B91F8 | 0x7AC9E0 | Lecture originale ; appelle 0x824630 |
| Press_SendAll | 0x10B9244 | 0x7ACA20 | Wrapper et préparation 0x8248B0 |
| Press_SendTeam | 0x10B9254 | 0x7ACA00 | Wrapper et préparation 0x8247D0 |
| ChatSend | 0x10B9228 | 0x7ACA40 | Branches du wrapper |
| ChatInterrupt | 0x10B9234 | 0x7ACAF0 | Adresse seulement ; corps hors lot |

Les callbacks équipe/global comparent [0x2D77E54] à zéro. S’il est nul, ils sautent l’appel de préparation et retournent normalement EAX=1, RET8. Sinon, ils transmettent le deuxième argument de callback à 0x8247D0/0x8248B0 ; après un retour normal de ce helper, ils retournent également 1. **Ce 1 n’est donc pas une preuve de message livré, ni même un indicateur distinct de rejet lorsque ce global est absent.** Les exceptions et erreurs des helpers restent non qualifiées.

ChatSend : global nul → sortie commune ; global présent → appel 0x8A33D0, lecture de deux prédicats de bits, puis sélection selon [global+0x80]. État 5 : argument transmis à 0x824690. États 0/6 : si le prédicat DL est faux, appel 0x8235C0 ou 0x823520 selon CL ; sinon sortie. Autres états : sortie. La sortie normale affecte EAX=1 puis appelle le helper de cookie et finit par RET8. Les bits ne sont pas renommés « Shift » ou « Control » sans qualification de leur producteur.

Préparation équipe/global : le littéral exact **/all **, terminé par NUL, est à 0x10C1544. Les deux fonctions comparent un temporaire terminé à l’offset +5 avec ce littéral. La branche équipe correspondante utilise la source globale +5 ; la branche globale opposée utilise le littéral puis un appel 0xC9CD83 avec le tampon. Cela identifie une normalisation du préfixe dans ces chemins, avec helpers de copie/conversion/concaténation encore non qualifiés. Aucun alias /ALL, longueur autorisée, encodage, refus d’argument ou protocole serveur n’est déduit. Les deux chemins rejoignent 0x7A7260 puis 0x824630 ; le rôle complet de ces helpers reste ouvert.

Complément focus : 0x7ACEC0 écrit byte [objet+0xE9]=1 avant l’appel d’interface Text_Entry_Open. Ce champ ne démontre pas à lui seul la suppression des actions de combat.

Consommateurs actuels : six fichiers relus par identité contre le corpus déjà audité, tous inchangés : F:\OpenLeague\crates\client\src\main.rs, native_zip_provider.rs, shop_ui.rs, shop_text_input.rs ; F:\OpenLeague\crates\core\src\lib.rs et session_transport.rs. Le chargement de Chat.ini est conservé. La saisie et le garde shop.focused concernent le magasin. Les schémas et les routes inspectés ne fournissent pas de chat intégré. Aucun nouveau consommateur ni lien de registre n’est inventé.

## 4. Attendu, observé et contrôles réellement exécutés

Vérificateur final : W\verify_host_static_v2.py, exécuté avec Python -X utf8 -E -B le 2026-10-30 à 14:22:54 UTC. **Code 0 ; 726 assertions statiques et d’identité réussies.** La majorité sont des comparaisons d’artefacts ou d’instructions, pas des tests de jeu.

| Contrôle | Attendu | Observé et limite |
|---|---|---|
| Rattachement film→C++ | Noms, callbacks et appels cohérents | Cinq couples identifiés dans l’enregistrement ; quatre corps de callback examinés, ChatInterrupt exclu |
| Nominal équipe/global | Transmettre l’argument dans la branche présente | PUSH [EBP+0xC], appel du helper distinct, retour normal1 ; inspection statique |
| Global absent | Déterminer si le retour distingue un refus | Appel sauté et retour1 ; aucune livraison ou erreur serveur observée |
| Sélection ChatSend | Décrire les états et sorties sans inventer les touches | États0/5/6, prédicats CL/DL et sortie commune identifiés ; helpers externes non exécutés |
| Sources et instructions | Comparer REA et original | 257 instructions REA sur six procédures, toutes rattachées aux octets originaux mappés ; 298 instructions originales lues sur huit fonctions |
| Complétude du pseudocode | Garder les omissions visibles | REA couvre 69/69,9/9,9/9,52/53,56/63,62/69 instructions selon la fonction ; les queues originales sont conservées séparément |
| Conservation | Préserver le périmètre gelé | 19 fichiers logiciels, six fichiers de contexte/méthode, registres des tâches/lots et anciens livrables inchangés |

Anomalie trouvée par le premier vérificateur : borne de fin 0x8248A0 pour la fonction équipe, au lieu de 0x8248A2 ; deux opérandes du RET4 étaient hors de la région sélectionnée. W\host-static-proof.json conserve les deux assertions en échec, code1. Le script v2 lit la fonction originale complète et passe ; le conteneur initial n’est pas modifié. REA avait omis cette queue après un helper déclaré non retournant : aucune qualification REA de ce retour complet n’est revendiquée.

Non exécuté : jeu original/local, conteneur comme programme, ActionScript, émulation native, tests Rust, serveur et deux clients, saisie réelle, réseau, captures, presse-papiers, installation, migration, ouverture de base et acceptation humaine. Les cas nominal/limites de ce rapport sont des inspections de branches, pas des essais dynamiques.

## 5. Résolu et ouvert

Résolu : correspondances film→C++ ; séparation des helpers équipe/global ; garde du global absent et sens limité du retour1 ; branches ChatSend ; localisation de la préparation /all ; divergence entre pseudocode réduit et instructions originales détectée ; erreur de borne identifiée et corrigée dans une preuve distincte.

Restent ouverts :

- Corps 0x7ACAF0 et grammaire des commandes tapées. Reprise : audit borné du callback et de ses appels à partir de cette adresse, avec régions complètes et distinction syntaxe/effet serveur.
- Helpers 0x9936C0,0x9935D0,0xC9CD83 : conversion/copie, limites et erreurs. Reprise : qualifier chaque contrat utile aux chemins de préfixe ; ne pas inférer une longueur de chat du seul immédiat0x100.
- 0x8A33D0 et prédicats d’entrée : nom et producteur des touches. Reprise : source des bits et appels exacts, sans attribuer un nom à un simple offset.
- 0x824690,0x824630,0x7A7260 : chemin d’envoi/fermeture/dispatch et refus. Reprise : vérifier leurs corps originaux complets et suivre une autorité de permission jusqu’au destinataire ; pas de succès réseau à partir du retour du wrapper.
- Sélection du film, permissions serveur, confidentialité, séquence de session, historique intégré, rendu et protection du combat. Reprise : sources/consommateurs précis puis fonctionnalité autorisée et essais correspondants. Les conditions détaillées et sous-lots antérieurs restent valables.

La preuve statique actuelle suffit à clore cette frontière. Elle ne suffit pas à terminer les trois tâches parentes ni leur audit complet. Aucun actif absent n’est inventé ; les inconnues portent ici sur les contrats, consommateurs et observations encore non qualifiés.

## 6. Corrections réutilisées et prochaines sorties précises

Aucun doublon de tâche créé et aucune mise à jour du suivi. Réutilisation documentaire :

| Tâche et inconnue existantes | Correction / petit lot restant | Critère de fin |
|---|---|---|
| SYS-17.4-07 ; OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38 | Sous-lot K1 existant : qualifier le corps ChatInterrupt et la grammaire avant un dispatch Rust | Pour chaque commande retenue : syntaxe, argument, droit, effet et refus sourcés ; inconnues explicites ; commande non supportée refusée |
| SYS-17.2-08 ; OLU-5abd1f66-bc04-5d6c-a130-33387ecf2888 | C1/C2 existants : séparer retour d’interface, admission serveur et livraison destinataire | Contrat de message et permission identifié ; preuve équipe/global avec clients de chaque équipe ; aucun affichage de succès fondé sur return1 seul |
| SYS-17.4-08 ; OLU-e87ab149-2826-528a-9bc4-4fbe77da6b15 | F1/F2 existants : relier un mode réel de chat au consommateur final de commandes | Q/W/E/R, raccourcis et pointeur contrôlés en saisie, fermeture, perte de focus et changement de session ; magasin préservé |

Le découpage et les conditions d’autorisation d’implémentation sont conservés dans AUD-17.2-08-CHAT-01. Ici, aucune correction fonctionnelle n’est exécutée. Pas de recherche externe ou d’exploration générale du runtime. Une future analyse REA doit tenir compte de la région incomplète et des flags no-return avant de prétendre qualifier les queues ; aucune relance identique n’est nécessaire pour les correspondances déjà acquises.

## 7. Livraison, identités et relecture

Seul nouveau fichier du dépôt : F:\OpenLeague\docs\audit\units\AUD-17.4-07-CHAT-HOST-01.md, ce rapport. Les autres nouveaux fichiers sont isolés dans W : prepare_container.py, CONTAINER.json, conteneur d’analyse initial, rea_chat_host.mjs, rea_chat_host_remaining.mjs, verify_host_static.py, verify_host_static_v2.py, les deux preuves statiques et observations\<session> contenant requêtes/réponses, bundle, journaux et reçus. Les deux tentatives et leurs erreurs restent présentes.

Preuve finale : **W\host-static-proof-v2.json**, 1041822 octets ; SHA-256 **121f71f572935d32b19264e3f612283d3b4579b5b13e6e7d049366f57cc5dd2d**. Producteur v2 : 13031 octets ; SHA-256 66e2ced8ff10103bb11957c1853ad6dba3758d9d68557e2dd502aae5f5e41ef5. Les outils Python, pefile, Capstone et sa DLL sont identifiés dans cette preuve ; les commandes, versions et fermetures REA dans les reçus de session.

Reçus REA : observations\d9aa05fe-6708-4f91-9811-13df07ca54a7\receipt.json, SHA-256 224a781fcb58d47bf198409585721cba711bdceaff94a626abec094115ea3c3c ; observations\c94d8758-9f61-4aa7-8c48-1f7ff64cfba5\receipt.json, SHA-256 2071bca4d676d77523b0b7502d1434951cd00f05217f382024ee3fae792f7386.

Git observé avant écriture : HEAD8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,76 fichiers suivis modifiés préexistants (mesure -uno, différente du total incluant non-suivis du lot précédent). Aucun ajout à l’index, commit, reset, checkout, nettoyage ou synchronisation. Le jeu et le Plan ne sont pas redémarrés. Aucune base ouverte, aucun état/case/notes/historique changé. Les 19 fichiers de l’intervention gelée restent identiques à leur inventaire ; les six fichiers de cadrage/contexte sont identiques.

Relecture : les sept rubriques couvrent question/frontière, provenance et erreurs, consommateurs natifs/actuels, attendu/observé/non-exécuté, inconnues et reprise, corrections existantes avec critères, livrables et conservation. **Audit de cette frontière clos ; fonctionnalités, parents et goal global non déclarés terminés.**