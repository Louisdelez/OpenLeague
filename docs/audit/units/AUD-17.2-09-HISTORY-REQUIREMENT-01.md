# AUD-17.2-09-HISTORY-REQUIREMENT-01 — Audit de l’historique borné du chat

Date : 2026-10-30. Projet : F:\OpenLeague. Goal : SYS-01.2-02. Exigence : SYS-17.2-09, OLF-e582b80c-47cd-55a3-94d7-b89d04be544b. Inconnue existante : OLU-83a927ae-fc5f-5c43-bb2a-cdeee4a6114b.

## 1. Exigence, critères appliqués et décision

Exigence entière examinée : « Conserver l’historique de messages avec une taille bornée ». Le critère produit existant impose son intégration dans le vrai consommateur, sa comparaison à la référence 4.20 et la documentation des succès, refus et limites. Il demeure inchangé et non satisfait dans le jeu actuel.

Cet audit applique les sept rubriques d’AUDIT_CHARTER.md : sources, consommateurs réels ou absence délimitée, attendu/observé, limites, corrections et relecture. Il réunit les preuves déjà acquises pour répondre à l’exigence, sans exiger une reconstruction complète du moteur afin de constater le consommateur manquant. L’arrêt est fixé après cette vérification documentaire ; aucun runtime, code produit ou registre n’est modifié.

| Dimension | Décision et limite |
|---|---|
| Audit de l’exigence | Terminé avec preuves pour l’état courant, après relecture finale des sept rubriques. La source de rétention et l’absence délimitée de son consommateur actuel sont établies ; les inconnues sont nommées. |
| Implémentation | Chargement des octets Chat.ini présent ; historique du chat non identifié dans le corpus gameplay/launcher et les interfaces inspectées. L’exigence fonctionnelle reste à faire. |
| Vérification | 166 contrôles de consolidation réussis ; preuves natives héritées, analyse statique AS2 et consommateurs actuels distingués. Aucun nouveau test du jeu ou d’ActionScript. |
| Acceptation humaine | Non demandée ; aucune acceptation produit inférée. |

La décision clôt l’audit documentaire de SYS-17.2-09, sans cocher la tâche, changer son état a_faire, résoudre l’inconnue dans le registre, fermer SYS-17.2-08/SYS-17.4-07 ou déclarer le goal global terminé. Les anciens rapports de fragments restent exacts dans leur portée ; la présente décision consolidée ne réécrit aucune preuve.

| Clause de l’exigence auditée | Conclusion traçable |
|---|---|
| Stocker des messages de chat | Tableau du film identifié ; consommateur de données utilisateur absent du périmètre courant inspecté, §2–3. |
| Borner la taille | Défaut du film de 100 messages ; distinct de la capacité de la file native, §2 et §4. |
| Ordre et dépassement | Insertion au début puis retrait du dernier pour le film ; refus de nouvelle entrée au garde de la file native pleine, §4. |
| Effacement, masquage et cycle | Effacement et masquage sourcés ; cycle nouvelle partie/reconnexion encore indéterminé et reprise explicite, §5. |
| Réel consommateur et comparaison 4.20 | Entrées actuelles et frontière de configuration examinées ; fonctionnement HUD/réseau non prouvé, §3–5. |
| Succès, refus et limites | Cas hérités bornés et conclusions statiques séparés des tests futurs, §4. |
| Action restante | Corrections petites et identifiées sous la tâche existante, §6. |

## 2. Sources historiques et provenance

Référence : League of Legends 4.20.0.315, EUW, en_GB. PE original 15 973 880 octets, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, sous :

`D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy`.

Deux films natifs exacts sont disponibles, extraits antérieurement avec FFDec, sans nouvelle extraction :

| Film natif sous DATA | Identité native | Source de rétention extraite |
|---|---|---|
| menu/HudChat.gfx | 25 576 octets ; SHA-256 e290c76affb1bed36449283eb8262cc60a3cf8f0bcb2d9e9022b256939b7c2dd ; OLS-7657e78b-62f3-5040-8c7d-a71f1762bdc1 | ChatBox.as, défaut ligne29, initialisation54, addMessage177–186, clear455–461, bouton570 ; SHA-256 af7617ec2fe116070ec293df2a24c93345fb086fd9c9e273b95dfed574bef72b |
| Menu_SC4/HudChat.gfx | 29 521 octets ; SHA-256 deb87e15957e05a24302c61321c0319315f2026c07b850ca6babd27fb946c4bc ; OLS-fa778ee9-1951-5a47-87fd-c5b64c28a28f | ChatBox.as, défaut24, addMessage163–171, clear315–321, bouton384 ; SHA-256 2385c16b5e8a5a1691228fdb0a1e328bf43194536006fce252a457d85b86ba87 |

Les chemins complets, fragments et reçus d’extraction sont dans la preuve principale. Les films correspondent aux membres RADS sélectionnés du projet lol_game_client 0.0.1.7 ; l’identité de contenu ne qualifie pas leur priorité effective au runtime. Les deux variantes partagent la règle de rétention sélectionnée ; leur présentation diffère.

Rétention du film : messageAmountLimit=100 par défaut ; tableau neuf dans le constructeur ; ajout au début par splice(0,0,...) ; si longueur supérieure à la limite, un pop enlève le plus ancien. Cette règle conserve au plus 100 messages sous l’invariant nominal d’un tableau neuf puis d’ajouts unitaires avec limite inchangée. Ce n’est pas une borne de caractères, d’octets ou de lignes visibles, ni une garantie de réparation d’un tableau corrompu ou d’une limite modifiée extérieurement.

Le clear vide le tableau par splice(0), relance le rendu et ajuste l’interaction. Le timeout sélectionné masque la boîte et ne modifie pas le tableau. L’existence des variables messageLifeSpan/timeoutInterval=10000 n’établit pas une suppression des messages après dix secondes. La durée d’affichage ne doit pas être transformée en durée de rétention.

Sources natives complémentaires héritées :

- 7ACF10 : admission dans une file en attente ; garde count>=capacité, nouvelle entrée sautée sans éviction de l’ancienne. GamePermanent.cfg contient MaxChatBufferSize=100 et MaxChatsToProcessPerFrame=2 ; fallback du code pour la capacité : 25. Valeurs effectives et montage restent non qualifiés.
- 7ABD50 : sélection du quota et retrait des entrées ; requêtes Chat_Box_Open et Add_Message avant consommation ; aucun acquittement de réception du film établi.
- 793AA0/79CD40 : conversion et frontière virtuelle du film. Un appel préparé n’est pas une réception, un affichage ou une rétention.
- 78B360, 791B20/791B60 et les sites du propriétaire : état d’entrée, liste du gestionnaire et cycle partiel, distincts de la disponibilité du film et de la rétention visible.

Preuves conservées et réutilisées :

- [Sources du chat](F:/OpenLeague-work/audit-units/AUD-17.2-08-CHAT-01/chat-contract-proof.json), SHA-256 `b37673bddaf069bcbcef483c419db9ecd7186d11104a4e847923a430dc8c8906`.
- [Buffer natif](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-BUFFER-01/native-buffer-proof.json), SHA-256 `62317d47095d3706861c2921281ddbb0888a5f2bb3379564ab5256237883d0e6` ; 28 cas hérités, non rejoués.
- [Pont du film](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-FILM-BRIDGE-01/native-film-bridge-proof.json), SHA-256 `b5695ff3e45da0be7d5a0f2e9dcce78786d082ae43381c987ea2fa9e0759e47b` ; huit cas hérités, non rejoués.
- [Propriétaire et gestionnaire](F:/OpenLeague-work/audit-units/AUD-17.2-09-NATIVE-OWNER-LIFETIME-01/native-owner-lifetime-proof.json), SHA-256 `edd27ca923c7d785eb19f40ac7d5e510c399eb1066e3ad0ec145c4bf619d8609` ; 27 cas hérités, non rejoués.

## 3. Consommateurs actuels et absence délimitée

Le vrai chemin présent est `crates/client/src/native_zip_provider.rs:74` : lecture requise de HUD/defaults/Chat.ini, stockage en Vec<u8> dans StartupHud, puis retour de cette configuration. `crates/client/src/main.rs:601` en journalise la taille. Ni ces octets, ni leur chargement, ni le test de taille ne stockent des messages d’un joueur dans un historique HUD.

Les fragments actuels relus comprennent Snapshot, Action, ClientPacket/ServerPacket dans `crates/core/src/lib.rs`, les messages de `session_transport.rs` et les consommateurs client. Ils ne fournissent pas ici de collection, producteur, projection ou action de chat pour alimenter cet historique. Le filtre de focus examiné dans main/shop protège la boutique ; il ne constitue pas une saisie de chat.

Corpus : 1 168 fichiers Rust sous crates/*/src et launcher/src-tauri/src, plus JS/HTML de launcher/web. Chemins et SHA-256 sont conservés par rapport à l’inventaire natif précédent. La recherche historique chat|whisper|saymessage|message_history|team_message est réutilisée pour les 1 158 fichiers communs inchangés. Les dix fichiers de launcher auparavant hors de cette recherche sont seuls recherchés à nouveau : aucune occurrence. Les sept anciennes occurrences sont relues : Chat.ini, diagnostic de taille, libellé français Châtiment et objet LastWhisper ; aucun historique utilisateur.

Nouvelle piste vérifiée : les collections génériques VecDeque/history pourraient cacher une implémentation sans nom de chat. La recherche trouve 107 fichiers et 337 lignes ; elle n’est pas assimilée à une analyse sémantique exhaustive de tous ces systèmes. Les déclarations typées pertinentes examinées sont conservées dans la preuve :

| Consommateur existant | Données réellement conservées |
|---|---|
| session_client | StateEnvelope en attente, protocole de reprise |
| clock_delivery | commandes ClockControl et ordinaux |
| death_recap / attack_presentation | Hit et événements d’attaque Stored |
| world | routes de Point |
| sessions du launcher | erreurs et processus |
| sondes inventaire et coordonnées | JSON de diagnostic |

Ces collections restent des acquis ; aucune n’est promue en historique du chat. La conclusion est bornée aux sources, interfaces et routes inspectées : consommateur d’historique de chat non identifié. Elle ne déduit pas l’absence de tout historique, toute interface ou tout mécanisme de reprise du projet.

## 4. Attendu, observé et contrôles exécutés

`verify_history_requirement.py`, Python existant avec `-X utf8 -E -B`, code0 : 166/166 contrôles de consolidation réussis. Date exacte dans le reçu. Le présent lot ne crée pas un modèle de chat pour le tester à la place du jeu.

| Cas ou frontière | Attendu sur la source/contrat | Observé et force de preuve |
|---|---|---|
| Historique neuf | tableau vide | Initialisation AS2 source identifiée ; pas exécutée au runtime. |
| Ajout nominal | nouveau message à l’indice0 | Fragment addMessage conservé dans les deux variantes ; analyse statique. |
| Film au passage100→101 | retrait du dernier, conservation nominale des100 plus récents | Ordre splice/condition/pop vérifié dans la source ; aucun test réel de 101 messages affichés revendiqué. |
| Clear | suppression du tableau puis rendu | Source et liaison du bouton identifiées ; bouton non cliqué. |
| Timeout/fermeture de saisie | masquage distinct de suppression | Fragments sélectionnés ne détruisent pas l’historique ; aucun essai visuel. |
| File native, capacité fournie100 | 0/99 passent la garde ;100/101 sont sautés | Quatre observations du reçu natif hérité ; le passage de cette garde seul ne prouve pas l’admission complète. |
| Fallback25, capacité0/max, texte nul | gardes et cas limites documentés | Cinq autres cas de garde hérités ; aucun nouveau replay. |
| Quota0/1/2/supérieur au compte | minimum unsigned au fragment | Huit cas hérités ; pas de fréquence réelle par frame déduite. |
| Stockage/retrait natifs | entrées conservées/compactées selon le chemin | Autres cas du lot buffer hérités ; distincts du tableau AS2. |
| Réception du film et cycle réel | réception, rendu et reprise à prouver | Non exécutés et toujours ouverts. |
| Consommateur local | vraie collection alimentée et utilisée par le HUD | Non identifié ; pas de test fonctionnel possible sur un consommateur absent du périmètre. |

Contrôles frais : empreintes des preuves/sources/films/configuration ; fragments AS2 et code courant ; identifiant stable, inconnue et registres lus comme données ; extension de recherche aux dix sources nouvelles ; typage des collections candidates ; conservation des instructions et logiciels gelés ; état Git. Les observations natives héritées sont relues et leurs reçus épinglés, sans les annoncer comme nouvellement exécutées.

Non exécutés : FFDec/REA/Ghidra à nouveau, émulation native, ActionScript, jeu original ou local, serveur/réseau, clics/UI/rendu, tests/build Rust, acceptation humaine. Les lectures auxiliaires de présentation ne remplacent aucun de ces contrôles.

## 5. Écarts, inconnues et reprise

Le registre conserve status=open pour OLU-83a927ae-fc5f-5c43-bb2a-cdeee4a6114b et l’ancien texte « capacity and eviction policy unqualified ». Sa condition demandait la source propre à cette exigence et le consommateur courant. Les preuves actuelles identifient désormais la borne par défaut et l’éviction dans les deux sources du film, ainsi que la frontière réelle du chargeur de configuration et l’absence délimitée du consommateur d’historique.

Cette sous-question de source est donc répondue dans les preuves isolées ; la fidélité fonctionnelle et l’inconnue du registre ne sont pas déclarées résolues. Aucune donnée gelée n’est réécrite. Ce décalage documentaire est explicitement conservé pour une future intégration autorisée.

| Écart ou inconnue | Condition précise de reprise |
|---|---|
| Historique utilisateur absent dans les consommateurs inspectés | Implémentation autorisée sur un vrai HUD/flux de messages ; identité de la collection, producteur et consommateur ; tests0/1/100/101, ordre et clear. |
| Configuration effective historique | Montage/priorité des films et de GamePermanent.cfg observés ; distinguer default du film100, capacité de file100 et fallback25. |
| Requête vers réception/rendu | Vrai récepteur virtuel C8 et résultat d’Add_Message ; méthode présente/absente/erreur, observation de rétention dans le film. |
| Cycle nouvelle partie/reconnexion | Producteurs de création/destruction/réutilisation de l’objet et politique historique ou locale explicite ; empêcher le mélange de sessions ; observer deux identités de session. |
| Entrées filtrées/permissions | Reprendre les exigences de réception/ignore déjà identifiées ; un message ignoré ne doit pas être ajouté par le chemin concerné ; autres origines inventoriées. Pas de droit serveur déduit du tableau. |
| Texte et conversion | Réutiliser le convertisseur existant après requalification de sa version ; distinguer capacité de stockage UTF16, nombre de messages et rendu. |
| Durée de vie et erreurs | Reprendre les callers précis du lot owner ou une vraie observation d’échec/remplacement ; aucune fuite ou perte en fonctionnement présumée. |

Ces inconnues limitent la fidélité et l’implémentation. Elles n’empêchent pas de constater l’état actuel et de satisfaire les sept rubriques de l’audit documentaire de cette exigence. Les mêmes helpers, recherches E5 et émulations du buffer ne sont pas à répéter sans changement de source ou observation nouvelle.

Après cette consolidation, une autre exigence peut être auditée. SYS-17.2-09 n’a pas à rester le sujet actif jusqu’à reconstruction du moteur. Le goal global continue de couvrir toutes les autres exigences ; il reste incomplet et actif.

## 6. Petites corrections proposées sous la tâche existante

Aucune fiche n’est insérée dans le plan ni exécutée dans ce lot. Les identifiants complets sont conservés : les anciens libellés courts H2 recouvraient deux sujets distincts et ne doivent pas être fusionnés.

| Référence documentaire | Objectif unique | Critères futurs vérifiables |
|---|---|---|
| SYS-17.2-09/H1 stockage borné, lié à H1-FILTERED-HISTORY | Collection de messages réellement utilisée par le HUD | 0/1/100/101 ; ordre ; éviction du plus ancien ; capacité nominale ; branchement producteur/consommateur ; preuve sur le vrai HUD. Le filtre reste lié à sa tâche propre. |
| SYS-17.2-09/H2-NATIVE-QUEUE | File d’attente séparée de l’historique | Avant/à/après capacité ; nouveau refus sans effacer l’ancien ; quota et ordre source/local-policy explicites ; pas de succès déduit du seul franchissement d’une garde. |
| SYS-17.2-09/H3-FLAGS-AND-TIMING | Entrées marquées et cadence de consommation | Producteur du bit0x80 et horloge identifiés ; effets tête/milieu ; compteur et délai ; aucune catégorie de message inventée. |
| SYS-17.2-09/H4-HISTORY-LIFECYCLE, alias explicite de l’ancien « H2 cycle d’historique » | Réinitialisation ou conservation selon la session | Nouvelle partie, remplacement, déconnexion et reconnexion selon contrat historique retrouvé ou décision locale tracée ; aucun mélange de sessions. Ne remplace pas H2-NATIVE-QUEUE. |
| SYS-17.2-09/H5-CLEAR, précision documentaire proposée | Action utilisateur d’effacement | Vide après clear, nouveau message accepté ensuite ; collection réellement consommée ; absence d’effacement au seul masquage. |
| SYS-17.2-09/B3-METHOD-DELIVERY, réutilisé | Réception effective du message côté HUD | Succès, méthode absente et erreur ; état reçu observé ; affichage qualifié séparément. |
| SYS-17.2-09/B1-CONVERTER-REUSE, réutilisé | Réutilisation de la conversion actuelle | Version et capacité utiles qualifiées ; cas texte/limite identifiés ; aucun codec dupliqué ou succès de rendu inféré. |

Prérequis existant : D17-SYS-17-2 requiert D13-SYS-13-3. Le consommateur d’affichage dépend d’une livraison autorisée et d’un contexte de session ; ces dépendances ne sont pas déclarées terminées par cet audit. Les dimensions de transport, confidentialité, filtres et rendu restent liées à leurs propres exigences. Aucun offset, architecture du film ou nouveau besoin fonctionnel n’est imposé comme modification du critère normatif.

## 7. Livraison, relecture et conservation

Fichiers nouveaux uniquement :

- Présent rapport : `F:\OpenLeague\docs\audit\units\AUD-17.2-09-HISTORY-REQUIREMENT-01.md`.
- [verify_history_requirement.py](F:/OpenLeague-work/audit-units/AUD-17.2-09-HISTORY-REQUIREMENT-01/verify_history_requirement.py), 15 324 octets ; SHA-256 `f805adbdf10e9e322dddf83fbf8873d1fd12e1006cd77c0913cc526a18a79b5c`.
- [history-requirement-proof.json](F:/OpenLeague-work/audit-units/AUD-17.2-09-HISTORY-REQUIREMENT-01/history-requirement-proof.json), 227 865 octets ; SHA-256 `57f1f97759a5da21a5d44558d4d2cadbc2af4356a73368d9790cb3b0dbc1dd23`.
- Relecture finale : `F:\OpenLeague-work\audit-units\AUD-17.2-09-HISTORY-REQUIREMENT-01\delivery-readback.json`. Elle peut porter la clôture documentaire de cette exigence lorsque ses sept rubriques sont vérifiées. Le reçu principal antérieur conserve audit_scope_closed=false.

Relecture : identité de la tâche et de l’exigence, sept rubriques et clauses, sources et consommateurs, limites et actions atomiques, résultats de consolidation et portée héritée, conservation et absence de modification des critères/statuts. Aucun décompte de liens ou de contrôles n’est converti en taux de jeu terminé.

Conservés : 19 fichiers logiciels gelés, six documents d’instructions/contexte/méthode, registres, sources natives, preuves antérieures et 1 168 fichiers du corpus courant. HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, mêmes 76 fichiers suivis déjà modifiés ; aucun stage, commit, reset, nettoyage ou retrait.

Aucune modification du goal, de ses critères, du plan, de l’application de suivi, de son interface ou de ses bases. Runtime non invoqué, bases non ouvertes ; aucune installation, migration ou relance. Le lot précédent est une progression vérifiée ; celui-ci apporte une clôture d’audit au niveau d’une exigence, avec implémentation, runtime et acceptation encore ouverts.
