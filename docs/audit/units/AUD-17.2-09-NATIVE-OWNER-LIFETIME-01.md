# AUD-17.2-09-NATIVE-OWNER-LIFETIME-01 — Gestionnaire et propriétaire du chat

Date : 2026-10-30. Projet : F:\OpenLeague. Goal parent : SYS-01.2-02. Exigences parentes : SYS-17.2-09 et SYS-17.4-07, conservées ouvertes.

## 1. Question, périmètre et décision

Question issue du lot précédent : le marqueur d’échec +0xE5 empêche-t-il l’inscription du chat dans le gestionnaire ou ses appels de vidage par le propriétaire ? Identifier les frontières de retrait et distinguer les autres fenêtres.

Critères de ce lot : relier les fonctions d’inscription/retrait à la vtable du vrai gestionnaire ; observer leurs chemins sûrs ; identifier l’initialisation du marqueur, les appels du propriétaire du chat et le destinataire du test explicite d’échec ; conserver les acquis et nommer les limites. Le lot s’arrête avant allocation, destruction virtuelle et drain non qualifiés. Ces critères bornent cet audit et ne modifient aucun critère normatif du goal ou du plan.

| Dimension | Résultat |
|---|---|
| Audit | Terminé pour les liens, champs et chemins sélectionnés, sous réserve de la relecture de livraison. |
| Implémentation | Aucun code produit modifié. Aucun adaptateur exact de ces liens historiques identifié dans le corpus actuel délimité. |
| Vérification | 150 contrôles réussis sur 27 cas bornés : 12 méthodes de liste jusqu’au retour, 15 fragments/arrêts explicites. |
| Acceptation humaine | Non demandée ; aucun parcours du jeu considéré accepté. |

Résultat utile : le gestionnaire conserve une liste de pointeurs sans lire le marqueur d’échec du destinataire dans ses méthodes d’inscription/retrait. Le fragment du constructeur exécuté après un échec inscrit encore ce pointeur. Le test explicite +0xE5 retrouvé à 820D08 concerne RadialMenu, champ propriétaire +0x13C ; il ne démontre pas un traitement identique du chat, champ +0x110. Les trois sites locaux de drain sélectionnés testent le mode et/ou le pointeur du chat. Leurs préconditions amont restent distinctes.

Aucun bug en fonctionnement, fuite, perte de messages ou accès après libération n’est conclu : ce lot n’exécute ni les constructeurs complets, ni le propriétaire complet, ni le moteur de film, ni la destruction réelle.

## 2. Sources, identités et preuves réutilisées

Référence : LoL 4.20.0.315, EUW, en_GB. Client original lu sans être lancé :

`D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`

15 973 880 octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; ImageBase 0x400000. Toutes les adresses sont ses VA. 20 intervalles, 670 instructions ; les 10 fragments ne sont pas présentés comme des fonctions entières. Les intervalles complets sont contigus et finissent sur RET.

| Intervalle, fin exclusive | Nature | Instructions | Rôle source |
|---|---|---|---|
| 0x78d1c0–0x78d240 | function | 41 | cached manager getter; constructor branch static only |
| 0x78deb0–0x78e0f8 | function | 142 | manager constructor and vtable identity; static only |
| 0x791b20–0x791b53 | function | 23 | manager register unique pointer |
| 0x791b60–0x791ba3 | function | 31 | manager remove first pointer and compact |
| 0x6b5e10–0x6b5e73 | function | 45 | pointer append helper; growth calls not executed |
| 0x78af8f–0x78af98 | fragment | 1 | word E4 initialization clears byte E5 |
| 0x78b067–0x78b074 | fragment | 5 | base constructor post-load manager registration |
| 0x7ab810–0x7ab96d | function | 84 | concrete chat constructor |
| 0x7ab970–0x7ab9ad | function | 25 | concrete chat deleting destructor wrapper; static |
| 0x7abad0–0x7abb79 | function | 47 | concrete chat destruction chain; static |
| 0x792300–0x7923ea | function | 76 | base destruction chain; static |
| 0x820c30–0x820d3a | function | 79 | radial-menu owner configuration and E5 rejection; static |
| 0x83d7e0–0x83d81e | fragment | 22 | radial-menu constructor prefix identifies source |
| 0x81f78f–0x81f7ac | fragment | 8 | replay chat constructor call and owner assignment |
| 0x81fd0a–0x81fd1a | fragment | 6 | flipped chat constructor call |
| 0x81fd5a–0x81fd76 | fragment | 9 | ordinary chat constructor call and owner assignment |
| 0x8229b0–0x8229c8 | fragment | 7 | owner local drain gate mode!=5 |
| 0x822c0f–0x822c27 | fragment | 7 | owner local drain gate mode==5 |
| 0x822dba–0x822dc9 | fragment | 5 | owner local drain pointer gate |
| 0x82148d–0x8214a7 | fragment | 7 | chat owner virtual destruction then pointer clear |

La vtable du gestionnaire est 0x10B68B4 : slot+0x10→791B20, slot+0x18→791B60. Le constructeur 78DEB0 l’installe. Le getter 78D1C0 fournit le cache global 0x2D78CB4 ; ses branches d’allocation restent statiques. La vtable du chat 0x10B8310 conserve slot+0x28→7ABD50.

Littéraux : HudChat.swf ; PlayerHudChatReplay ; PlayerHudChatFlipped ; PlayerHudChat. Le constructeur distinct 83D7E0 transmet RadialMenu.swf et PingCommandRadial au même constructeur de base. Ces noms établissent des identités source, pas leur montage ni leur affichage.

Preuves réutilisées sans replay :

- [États natifs du film](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-MOVIE-STATE-01/native-movie-state-proof.json), SHA-256 `9878a6ddc5aff238f289ef00764e6914e6f5c82bdf03e1adb05b130f934fa5c1` ; [relecture](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-MOVIE-STATE-01/delivery-readback.json), SHA-256 `65376cf95046df986ef4a96c327ed09b2c7e13ec7a8838c738a66356df715cdb` : écritures +4/+0x98/+0x80/+0xE5, garde de release sur pointeur nul et vtable concrète. Leurs 26 cas ne sont pas réexécutés.
- [Buffer natif et inventaire des consommateurs](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-BUFFER-01/native-buffer-proof.json), SHA-256 `62317d47095d3706861c2921281ddbb0888a5f2bb3379564ab5256237883d0e6` : 1 168 sources et référence aux interfaces réelles précédemment inspectées.
- [Interfaces et réception antérieures](F:/OpenLeague-work/audit-units/AUD-17.4-07-IGNORE-RECEIVE-01/ignore-receive-proof.json), SHA-256 `3a0c0ea2460a247ca899a16aef6e3da04eed9ec44dd71a34d00e24859e72a4f9` : fragments typés réutilisés, vérifiés par leurs identités et leur corpus actuel, pas une nouvelle qualification de réception.

Outils existants : Python, pefile 2024.8.26, Capstone 5.0.7, Unicorn 2.1.4 et leurs DLL, identifiés dans le reçu. Aucun téléchargement, installation, nouveau PE, import REA/Ghidra ou reconstruction d’asset.

## 3. Liens natifs et consommateurs actuels

### Liste du gestionnaire

791B20 utilise begin+0x3C, end+0x40, capacity+0x44. Il compare les pointeurs déjà présents ; seul un absent est ajouté par 6B5E10. Il ne déréférence pas l’objet destinataire pour lire son film, son marqueur d’échec ou son état d’entrée. Un pointeur nul est accepté dans les fixtures ; aucune règle de refus n’est inventée. Cela ne prouve pas qu’un caller réel lui fournit null.

791B60 recherche la première égalité, compacte le suffixe via le vrai helper CRT C97610 puis diminue end de quatre octets. Absent ou vide : retour sans mutation. Aucun appel virtuel de destruction de l’objet n’apparaît dans ce corps ; il s’agit du retrait de liste, pas d’une preuve globale d’ownership.

### Initialisation et inscription après chargement

78AF8F écrit le WORD +0xE4=1, soit octet E4=1 et E5=0. Cette écriture combinée précise l’initialisation que la recherche de seuls accès byte E5 ne couvre pas. Le lot antérieur établit ensuite E5=1 lors du retour false de chargement.

Après ce traitement, 78B067 appelle le getter du gestionnaire, puis slot+0x10 à 78B071. Aucun saut n’écarte cet appel sur E5 dans ce fragment. Avec cache de gestionnaire et stockage disponibles fournis, le fragment original inscrit effectivement le pointeur de fixture malgré E5=1 et film+4=0. Ni l’échec de chargement lui-même ni le constructeur complet ne sont exécutés ici.

### Propriétaires distincts

Les trois CALL directs retrouvés du constructeur 7AB810 sont 81F798, 81FD13 et 81FD63. Les fragments valident les identifiants replay/flipped/ordinaire et les affectations du chat au champ propriétaire +0x110. Les branches choisissant ces variantes ne sont pas qualifiées en fonctionnement.

Le constructeur distinct 83D7E0 crée RadialMenu. Dans 820C30, son résultat va au champ propriétaire +0x13C ; le test à 820D08 lit E5. Non nul : appel du destructeur virtuel, remise à zéro de +0x13C et du drapeau +0x264 après son retour. Cette politique locale ne doit pas être attribuée au chat par analogie de base commune.

Sites locaux du propriétaire du chat :

| Fragment | Garde immédiate | Appel sélectionné |
|---|---|---|
| 8229B0–8229C8 | mode propriétaire +0x80 différent de 5 et pointeur +0x110 non nul | slot+0x28 → 7ABD50 |
| 822C0F–822C27 | mode égal à 5 et pointeur non nul | même slot |
| 822DBA–822DC9 | pointeur non nul | même slot |

Le sens historique du mode 5 et les gardes amont des fonctions entières restent ouverts. Ces fragments ne lisent pas directement E5 ou film+4. Leur atteinte avec les fixtures proposées n’établit pas l’atteignabilité après un vrai chargement raté.

### Destruction et frontière encore ouverte

82148D–8214A7 teste le pointeur du chat, demande sa destruction virtuelle puis met +0x110 à zéro. La vtable mène à 7AB970, qui appelle 7ABAD0. Cette chaîne appelle 7923F0 avant les nettoyages, de nouveau après installation de la vtable de base, puis passe par 792300 qui appelle encore 7923F0.

La garde du helper 7923F0 sur film nul, sa mise à zéro du film après release et son slot manager+0x18 sont des preuves héritées. Le corps statique 792300 n’ajoute pas ici de retrait inconditionnel du gestionnaire. Les nettoyages, callbacks et callers peuvent changer le cycle ; leur effet n’est pas deviné. Liste, enregistrement, propriété, suppression du film et ordonnanceur ne sont pas confondus.

### Consommateurs locaux réellement inspectés

Le corpus actuel, 1 168 fichiers `crates/*/src` Rust, `launcher/src-tauri/src` Rust et `launcher/web` JS/HTML, conserve ses chemins et empreintes. Les interfaces héritées restent identifiées : `crates/core/src/lib.rs:280` Action, :303 ClientPacket, :321 ServerPacket ; `crates/core/src/session_transport.rs:80` Input, :92 ClientMessage, :146 ServerMessage ; `launcher/src-tauri/src/main.rs:72` commandes Tauri enregistrées.

Seules les nouvelles identités sont recherchées : 791b20, 791b60, 78d1c0, PingCommandRadial, PlayerHudChatReplay, RadialMenu.swf. Témoins positifs et négatif réussis ; zéro occurrence. Cela borne l’absence d’adaptateur historique exact identifié. Ce n’est pas une affirmation d’absence de tout UI, input, calendrier d’update ou service de session. Les consommateurs existants sont conservés.

## 4. Vérifications exécutées et limites observées

Commande : Python existant, options `-X utf8 -E -B`, script isolé `verify_native_owner_lifetime.py`. Exécution : 2026-10-30T17:31:07Z–17:31:10Z, code 0. 150/150 contrôles réussis ; 27 cas.

Émulation d’octets originaux sans patch ni stub. Contextes, listes avec capacité fournie, pile et chaîne d’exception à zéro sont des fixtures. Le seul override global est la DONNÉE 0x2D78CB4 : cache du gestionnaire fourni. Aucune écriture CPU de l’image PE ; les écritures sont restreintes aux fixtures/pile. Limites : 100 000 instructions et deux secondes par invocation. Le reçu conserve les adresses/octet de chaque instruction distincte observée, pas une chronologie exhaustive des instructions répétées.

| Groupe | Cas | Attendu | Observé |
|---|---:|---|---|
| Inscriptions | 5 | ajout absent, doublon inchangé, pointeur distinct ajouté, null ajouté/dédoublonné | Conforme ; 5 méthodes jusqu’au retour ; aucun allocateur. |
| Capacité épuisée | 1 | atteindre la frontière de croissance sans modifier la liste | Arrêt avant CALL 6B5E59 ; allocateur non exécuté, aucun refus inventé. |
| Retraits | 7 | vide/absent inchangé ; suppression unique/premier/milieu/dernier et compactage ; première occurrence seulement | Conforme jusqu’au retour, vrai CRT exécuté. Le doublon forgé est une limite de fixture, pas une duplication issue de l’API d’ajout. |
| Initialisation E4/E5 | 2 | E4=1 et E5=0, quelle que soit l’ancienne fixture E5 | Conforme sur le fragment avant le prochain call. |
| Inscription après échec supposé | 1 | enregistrer l’objet E5=1, film nul | Conforme via vrai getter en cache, vtable, 791B20 et append ; arrêt avant épilogue du constructeur. |
| Garde du menu radial | 2 | E5=0 atteint la sortie locale ; E5=1 atteint le destructeur virtuel | Conforme ; arrêt AVANT le destructeur, objet de fixture, pas menu réellement construit. |
| Après destruction radiale supposée | 1 | propriétaire +0x13C=0 et drapeau +0x264=0 | Conforme au fragment post-callee ; destruction non exécutée. |
| Gates du propriétaire chat | 8 | mode/pointeur choisissent l’appel ou le saut local | Conforme ; cible vtable 7ABD50 identifiée pour 3 cas, arrêt avant le drain. E5=1 et film nul restent des fixtures. |

12 cas sont des méthodes originales de liste exécutées jusqu’au retour. Les 15 autres sont des fragments, préfixes ou arrêts explicites : aucun n’est promu en opération externe réussie.

Recherche auxiliaire E5 : 149 occurrences brutes du disp32 E5 dans les sections exécutables, quatre instructions candidates à accès byte obtenues avec les deux formes de préfixe sélectionnées. 78B060 et 820D08 sont reliées par les fonctions identifiées ; B9EDB3 vise la pile ; C02FE0 reste une candidate non attribuée sémantiquement. Cette recherche n’établit pas l’absence globale d’autres lecteurs : accès combinés, alias, indexation ou formes non recherchées restent possibles. Le WORD +E4 ci-dessus illustre précisément cette limite.

Non exécutés : allocation/croissance, factory, renderer, dispatcher/abonnements, drain, destructeurs virtuels et nettoyages complets, update complet du propriétaire, ActionScript, réseau, jeu LoL, tests/build Rust et acceptation humaine. Une lecture auxiliaire de présentation des interfaces a rencontré une clé `fragments` absente pour Tauri ; sa structure `registered_commands` a ensuite été inspectée. Aucun artefact, test natif ou fichier produit n’a été altéré par cette erreur de lecture.

## 5. Résolu, ouvert et conditions de reprise

Résolu pour ce lot : l’initialisation E5=0 est localisée ; admission/retrait de la liste sont reliés au vrai gestionnaire et observés ; l’inscription post-échec est démontrée dans le fragment borné ; le seul test d’échec sélectionné chez le propriétaire est attribué au menu radial ; trois sites de drain et la chaîne de destruction du chat sont identifiés sans leur prêter un succès réel.

| Reste ouvert | Effet sur la conclusion | Entrée et condition exacte de reprise |
|---|---|---|
| Cycle réel après chargement raté du chat | Les fixtures ne prouvent ni maintien en update ni nettoyage | Constructeur complet et chemin du propriétaire menant aux gates 8229C5/822C24/822DC6, état film/E5/entrée/identité observé après échec réel. |
| Durée de vie de la liste +0x3C | Une liste de pointeurs n’est pas un propriétaire qualifié | Callers et lecteurs de cette liste, suppressions indirectes, callbacks/792300 et shutdown ; absence de nouvel accès après destruction à démontrer sur un cycle réel. |
| Allocations et capacité | Pas de politique OOM prouvée | Branche 6B6730 et contrats allocator/erreur si ce périmètre devient nécessaire ; ne pas convertir l’arrêt en refus observé. |
| Interprétation du mode 5 et ordonnanceur | Pas de fréquence par frame ni politique de chargement déduite | Fonctions entières contenant les trois sites, producteurs du champ +0x80 et règles temporelles ; conserver l’étiquette opaque jusque-là. |
| Disponibilité/réception du film | Pointeur, inscription et appel ne prouvent pas le rendu | Factory 790210, résolution SWF/GFX, vrai récepteur virtuel C8, méthode absente/erreur/succès et observation dans le film. |
| Adaptation actuelle Rust | Les liens historiques ne sont pas une implémentation | Réutiliser les interfaces existantes et le convertisseur déjà identifié, qualifier leurs versions et brancher un vrai consommateur dans un lot d’implémentation autorisé. |

Inconnues conservées sans mutation : SYS-17.2-09 → OLU-83a927ae-fc5f-5c43-bb2a-cdeee4a6114b ; SYS-17.4-07 → OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38. Une cause de perte de messages ou de pointeur pendant n’est pas déclarée.

La piste ne justifie pas de répéter les mêmes recherches E5, list helpers ou tests de buffer. La reprise exige les fonctions/callers nommés, une nouvelle observation de cycle réel ou une source actuelle modifiée. La qualification du cycle complet peut rester un audit séparé ; les nouvelles preuves présentes satisfont uniquement le lot défini en §1.

## 6. Corrections documentaires et tâches réutilisées

Propositions sous identifiants existants, sans modification de plan, statut ou critère normatif :

| Référence | Résultat précis restant à livrer | Critères futurs et dépendances |
|---|---|---|
| SYS-17.2-09/B2-MOVIE-STATE | Séparer disponibilité du film, état d’entrée et échec | Contrat de chargement courant et erreur affichée/consommée ; ne pas généraliser la politique RadialMenu au chat ni conclure à partir de E5 seul. |
| SYS-17.2-09/B2-LIFETIME | Qualifier inscription, retrait et durée de vie du vrai consommateur | Cycle chargement échoué/réussi, remplacement et destruction ; identité stable ; retrait ou empêchement d’update prouvé ; aucune nouvelle lecture d’objet détruit. Les helpers purs de liste sont désormais sourcés et ne nécessitent pas de nouveau remplacement. |
| SYS-17.2-09/B3-METHOD-DELIVERY | Relier drain et réception effective de Add_Message | Vrai récepteur et résultat ; refus/absence/succès ; source et rendu séparés, sans déclarer une requête reçue ou affichée par son seul envoi. |
| SYS-17.4-07/I4-HUD | Adapter les états et commandes au vrai HUD courant | Consommateur local identifié, erreurs explicites et observations distinctes ; pas de succès d’activation/drain inféré de la seule présence dans une liste. |

Prérequis hérités conservés : D17-SYS-17-2 requiert D13-SYS-13-3 ; D17-SYS-17-4 requiert D09-SYS-09-4. Aucun prérequis terminé par ce lot. Aucun besoin de recréer intégralement les offsets/classes/film historiques n’est ajouté aux critères du produit.

## 7. Livraison et conservation

Fichiers nouveaux uniquement :

- Présent rapport : `F:\OpenLeague\docs\audit\units\AUD-17.2-09-NATIVE-OWNER-LIFETIME-01.md`.
- [verify_native_owner_lifetime.py](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-OWNER-LIFETIME-01/verify_native_owner_lifetime.py), 22 172 octets ; SHA-256 `bc667ca1ac4dab744dae22c6bd93a28f73089e64771da87910c0582052753b7e`.
- [native-owner-lifetime-proof.json](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-OWNER-LIFETIME-01/native-owner-lifetime-proof.json), 446 079 octets ; SHA-256 `edd27ca923c7d785eb19f40ac7d5e510c399eb1066e3ad0ec145c4bf619d8609`.
- Relecture indépendante : `F:\OpenLeague-work\audit-units\AUD-17.2-09-NATIVE-OWNER-LIFETIME-01\delivery-readback.json`, créée après le rapport. Le reçu principal conserve `audit_scope_closed=false`, étant antérieur à cette livraison ; seule la relecture finale peut porter la clôture limitée.

Relecture prévue : identités, 150 contrôles, 27 cas et séparation 12/15, comparaison des octets observés au PE, vtables et littéraux, sept rubriques, consommateurs réutilisés, conditions de reprise, empreintes citées et conservation. Le résultat effectivement obtenu figure dans le reçu final.

Les 19 fichiers logiciels gelés, six documents d’instructions/contexte/méthode, deux registres JSON et 1 168 sources sont conservés par empreintes. HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, mêmes 76 fichiers suivis déjà modifiés. Aucune restauration, suppression, opération Git d’écriture ou remplacement de preuve.

Goal, critères normatifs, application de suivi, interface et bases inchangés. Runtime du suivi non invoqué, bases non ouvertes. Aucune installation, migration, relance ou nouveau binaire. Le lot précédent constituait une progression vérifiée ; le présent lot apporte une nouvelle liaison source/consommateur, pas une attente ni une clôture du goal global. Les fonctionnalités et tâches parentes restent ouvertes ; aucun pourcentage du jeu n’est calculé.
