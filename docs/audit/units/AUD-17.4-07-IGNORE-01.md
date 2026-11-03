# AUD-17.4-07-IGNORE-01 — Commande ignore, état en partie, adaptateur social et HUD

Date : 2026-10-30. Projet : F:\OpenLeague. Goal parent : SYS-01.2-02. Exigence fonctionnelle réutilisée : SYS-17.4-07.

## 1. Périmètre, critères précis et décision

Question : à partir du handler original0x7A3810, quel état est inversé par `/ignore`, quels effets sont demandés au jeu, au service social et au HUD, et quels succès apparents ne démontrent aucun changement ?

Critères de sortie du lot : établir les identités et frontières du handler et des effets sélectionnés ; distinguer les états et les retours ; vérifier les routines originales de collection sur des fixtures explicites ; examiner les consommateurs réels avec un motif nouveau motivé par ce code ; réutiliser les preuves du parseur ; documenter les manques, corrections et sept rubriques ; vérifier la conservation. Ces critères décrivent ce lot et ne modifient aucun critère normatif du goal ou du plan.

| Dimension | Résultat limité |
|---|---|
| Audit | Terminé pour les frontières du handler et des effets documentés, après reçu de livraison. |
| Implémentation | Aucun code produit modifié. Aucun consommateur local de chat ignore/mute identifié dans le corpus et les interfaces inspectés. |
| Vérification | 239contrôles réussis, dont les résultats de14appels aux routines originales de collection en émulation isolée. Aucun handler complet exécuté. |
| Acceptation humaine | Non demandée ; aucun fonctionnement du jeu accepté implicitement. |

Exclus : alimentation réelle du provider et des comptes, filtre de réception des messages, persistance de blocage de compte, protocole XMPP complet, accusé serveur, traitement de la file HUD différée, interfaces visuelles en fonctionnement et tests de partie. Les frontières exclues ont des entrées de reprise précises en §5. Elles ne sont pas déclarées résolues.

Un seul lot actif. Arrêt de recherche aux providers, au sink virtuel du service et à la file différée HUD ; ces consommateurs demandent leurs propres questions et preuves. La grammaire et les envois privés déjà analysés ne sont pas relancés à l’identique.

## 2. Sources, identités et réutilisation

Référence : LoL4.20.0.315, région EUW, locale en_GB ; fr_FR utilisée pour comparaison lexicale. Client original lu sans lancement du processus :

`D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`

15 973 880octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; ImageBase0x400000. Les adresses ci-dessous sont des VA de ce fichier.

| Fonction | Intervalle, fin exclusive | Objet |
|---|---|---|
| 7A3810 | 7A3810–7A39E8 | Handler ignore,142instructions. |
| 7AB020 | 7AB020–7AB0FF | Nom vers état ignoré en partie,80instructions. |
| 7A6EC0 | 7A6EC0–7A7174 | Application de l’état demandé,213instructions. |
| 7AAE70 | 7AAE70–7AAEAA | Appartenance d’une valeur opaque32bits. |
| 7AAEB0 | 7AAEB0–7AAEF7 | Ajout unique de cette valeur. |
| 7AAF00 | 7AAF00–7AAF4D | Retrait de cette valeur. |
| 7AB100 / 7AB1E0 | 7AB100–7AB1D3 / 7AB1E0–7AB2B3 | Wrappers de résolution par nom avant ajout/retrait. |
| 7A7E70 | 7A7E70–7A8061 | État local social et enveloppe toggleIgnore. |
| 813180 | 813180–813209 | Recherche de ligne HUD ou file de noms. |
| 8124D0 | 8124D0–8125D6 | Demande SetPlayerMutedStatus. |
| 849D40 / 5CCD60 | 849D40–849DA6 / 5CCD60–5CCDBA | Append et erase de vecteur32bits. |

13intervalles,1 060instructions ; longueurs contiguës et fins RET vérifiées. Le reçu conserve chaque intervalle, ses octets/empreinte et ses instructions, pas seulement son nom.

Preuves héritées et identifiées avant réutilisation :

- [Catalogue](F:/OpenLeague-work/audit-units/AUD-17.4-07-COMMANDS-01/commands-catalogue.json), SHA-256 `567a26d25c715de378f2782b5db6629cecaccdd12efb18ff6bacbb11947710f0` : ignore slot18 →0x7A3810 ; alias lexicaux en_GB ignore,ig,mute,squelch ; fr_FR ajoute ignorer. La disponibilité des alias dépend toujours du provider/montage qualifié séparément.
- [Audit du parseur](F:/OpenLeague/docs/audit/units/AUD-17.4-07-RECIPIENT-PARSER-01.md) et [reçu](F:/OpenLeague-work/audit-units/AUD-17.4-07-RECIPIENT-PARSER-01/recipient-parser-proof.json), SHA-256 `53170328f50bffddac9d5c4af456cf7811248f97e06f941e4e366b104ec5bec4` : noms, quotes, mots-clés, sélection@ et limites. Les11empreintes d’intervalles sont recontrôlées, sans réexécuter les20appels de helpers précédents.
- [Audit whisper/reply](F:/OpenLeague/docs/audit/units/AUD-17.4-07-WHISPER-REPLY-01.md) et [reçu](F:/OpenLeague-work/audit-units/AUD-17.4-07-WHISPER-REPLY-01/whisper-reply-proof.json), SHA-256 `62e2eee1c6c74ff0f863ace81c93a8566fd743d9052b4e49d5d4202552b01608` : interfaces actuelles et corpus1 168fichiers, séparation traitement/envoi/livraison. Leurs identités sont réutilisées après conservation.

Les deux sources de locale originales sont conservées par empreinte. Clés effectivement demandées dans ce chemin : `flash_hud_Chat_UserNotFoundAnywhere` ligne220, `flash_hud_Chat_Info_Ignore_Add` ligne204 et Remove ligne207. Les clés List ligne205 et Message ligne206 ne sont que des ressources voisines, sans appel attribué à ces fonctions. Message annonce une mise en sourdine limitée à la session de partie ; ce texte ne prouve pas la durée de vie réelle de l’état ni sa remise à zéro.

Littéraux séparément identifiés : `toggleIgnore`, `summoner`, `SetPlayerMutedStatus`, ponctuation ` <` et `>`. Leurs adresses et les valeurs lexicales en_GB/fr_FR sont dans le reçu.

Outils installés déjà présents : Python, pefile2024.8.26, Capstone5.0.7, Unicorn2.1.4 ; exécutables, modules et DLL identifiés. Aucun nouvel outil installé, nouveau binaire créé, import REA/Ghidra ou export ActionScript relancé : les sources originales et preuves existantes répondent à la question retenue.

## 3. Consommateurs natifs et locaux : quatre étapes distinctes

### Commande : inversion de l’état en partie

0x7A3810 appelle le parseur partagé0x7A4FE0 avec un vecteur de destinataires et une sortie texte. Pour chaque entrée de24octets, il appelle0x7AB020 si le gestionnaire en partie0x2D62D10 existe ; sinon il prend faux. L’instruction SETE inverse ce résultat, puis appelle0x7A6EC0 avec le nom et l’état souhaité. Le retour de cette application n’est pas utilisé pour décider de la réussite de la boucle.

Le handler retourne normalement1 après un parseur vrai, même avec un vecteur vide. Si le parseur est faux et que la sortie texte est vide, retour0. S’il est faux mais que la sortie texte est non vide, il demande UserNotFoundAnywhere avec le type4, puis retourne1. L’atteignabilité de cette dernière combinaison de sorties dépend du parseur/provider ; le handler seul ne la démontre pas.

### État en partie : collection de valeurs opaques

0x7AB020 résout le nom via le provider, compare une sentinelle puis appelle0x7AAE70. La collection du gestionnaire est lue via ses offsets+0x0C/+0x10. Ses entrées font4octets. Leur identité exacte n’est pas promue en identifiant réseau ou compte authentifié.

0x7AAE70 vérifie l’appartenance ;0x7AAEB0 refuse les doublons et ajoute sinon ;0x7AAF00 enlève la première occurrence trouvée et compacte les suivantes. Les wrappers0x7AB100/0x7AB1E0 font la résolution par nom avant ces appels.

0x7A6EC0 effectue une résolution préalable. Si elle donne la sentinelle, il saute toutes les modifications et retourne1. Sinon, pour l’état vrai il ajoute seulement si la cible est connue et non déjà ignorée ; pour l’état faux il retire seulement si la cible est connue et déjà ignorée. Les conditions et retours locaux ne sont pas des décisions d’autorisation serveur.

### Adaptateur social : état souhaité comparé à une autre liste

Après les gardes précédentes,0x7A6EC0 appelle0x7A7E70 avec le service global0x2D788DC et le même état souhaité. Cet adaptateur utilise une liste de noms différente, aux offsets+0x1C/+0x20 du service.

Il teste si le nom est présent. Si cette présence égale l’état demandé, il ne construit aucune enveloppe et retourne normalement1. Sinon il ajoute/enlève le nom localement, puis construit une enveloppe d’opération `toggleIgnore`, champ `summoner`, et la passe à un sink virtuel slot+4. Aucun booléen explicite d’état demandé n’est sérialisé par les appels sélectionnés de cette enveloppe. Aucun accusé de réception n’est vérifié à cet endroit.

La modification locale précède l’appel au sink. Les chemins examinés ne prouvent pas une transaction atomique, un rollback, la persistance d’un blocage de compte ou la politique serveur. Ne pas déduire ces mécanismes du nom toggleIgnore. Le service est utilisé sans garde de pointeur nul à cet endroit ; l’initialisation est une précondition, pas un refus gracieux qualifié.

### HUD et statut : demande d’affichage distincte

Si l’objet HUD correspondant est disponible,0x813180 tente de retrouver la ligne du joueur par son nom. Quand le drapeau chargé+0x29 est non nul et qu’une ligne correspond, il appelle0x8124D0 : booléen converti en texte, commande `SetPlayerMutedStatus`, paramètres de ligne transmis à0x813080. Cela identifie une demande UI, pas son application observée dans un film.

Si le drapeau chargé vaut0, le nom est ajouté à la file+0x6C. Cette branche n’enregistre pas l’état demandé dans la file ; le consommateur de vidage doit être suivi avant d’affirmer sa règle, sa correction ou un défaut.

0x7A6EC0 demande enfin le statut Add ou Remove, suivi du nom entre chevrons, type4 ; retour normal1. Cette présentation n’est pas un accusé serveur et ne prouve pas qu’un message entrant sera filtré.

### Consommateurs locaux actuels inspectés

Le corpus précédent est intégralement conservé, liste et SHA-256 : tous les `.rs` sous `crates/*/src`, ceux de `launcher/src-tauri/src`, plus `.js` et `.html` de `launcher/web`, soit1 168fichiers. Les anciennes recherches de messagerie ne sont pas répétées.

Une nouvelle recherche est motivée par les symboles originaux de ce lot : motif insensible à la casse `\b(toggleIgnore|SetPlayerMutedStatus|muted|ignore_player|mute_player|chat_ignore|chat_mute)\b`. Contrôles positifs et négatif enregistrés. Résultat : zéro occurrence dans ce corpus.

Les interfaces réelles héritées et identifiées restent la corroboration : Action/ClientPacket/ServerPacket dans `crates/core/src/lib.rs`, Input/ClientMessage/ServerMessage dans `crates/core/src/session_transport.rs`, bridge Tauri de `launcher/src-tauri/src/main.rs:72`. Aucun parseur/routage de chat privé ou commande ignore/mute n’y est identifié. Les sources du launcher sont incluses.

Recherche d’absence bornée, sans conclusion sur toutes dépendances, outils, assets générés ou services externes. Les Mutex, attributs Rust ignore, textes de diagnostic « ignored », blocages de gameplay et mises en sourdine audio ne sont pas une implémentation d’ignore du chat. La tâche audio SYS-16.4-03 et les tâches de salon SYS-19.3-03/04 ne sont pas substituées à cette exigence ; leurs titres ont été examinés, sans mutation du plan.

## 4. Vérifications exécutées et attendu/observé

`verify_ignore.py` exécuté du 2026-10-30T16:12:11Z au16:12:14Z, code0 :239/239 contrôles réussis. Le nombre couvre sources, témoins statiques,14appels de collection, pile et retours, recherche, conservation ; il n’est pas un taux de jeu terminé.

| Cas statique | Attendu et observé sur le code original |
|---|---|
| I1 : parseur vrai, liste non vide | Prédicat en partie inversé puis application par entrée24octets ; retour de l’application ignoré par le handler. |
| I2 : parseur vrai, liste vide | Aucun effet ; retour « traité »1. |
| I3 : parseur faux, texte vide | Retour0 sans statut de succès. |
| I4 : parseur faux, texte non vide | UserNotFoundAnywhere puis retour1 ; combinaison de sorties non exécutée. |
| I5 : cible absente du résultat provider de l’application | Tous effets sautés, retour1. |
| I6 : ajout demandé sur cible connue non ignorée | Wrapper d’ajout vers routine unique ; autres étapes ensuite demandées. |
| I7 : retrait demandé sur cible connue ignorée | Wrapper de retrait vers collection ; autres étapes ensuite demandées. |
| I8 : liste sociale déjà égale à l’état demandé | Aucun envoi d’enveloppe, retour1. |
| I9 : liste sociale différente | Changement local avant toggleIgnore/summoner et appel du sink ; aucun ACK qualifié. |
| I10 : ligne HUD chargée et trouvée | Demande SetPlayerMutedStatus ; application visuelle non observée. |
| I11 : HUD non chargé | Nom mis en file ; booléen non stocké par cette branche ; règle au vidage ouverte. |
| I12 : service global nul | Déréférencement attendu par la structure du code ; aucun essai de pointeur invalide ou refus gracieux revendiqué. |

Ces cas sont des témoins statiques conditionnels. Le handler, le provider, le service social et le HUD n’ont pas été exécutés.

Émulation réellement exécutée : seules les entrées0x7AAE70,0x7AAEB0,0x7AAF00, avec leurs callees originaux0x849D40 et0x5CCD60 sur les chemins observés. PE mappé en mémoire, aucun patch/stub ou appel OS. Objet de contexte synthétique explicite avec vecteur de valeurs opaques32bits et capacité réservée de16entrées ; aucune allocation/réallocation. Écritures bornées aux buffers et à la pile ; instruction et timeout bornés. Chaque appel atteint la sentinelle et nettoie ses4octets d’argument. La relecture finale compare chaque instruction exécutée au fichier PE original.

| Tests de collection originale | Attendu | Observé |
|---|---|---|
| Appartenance, vide/présent/absent/valeur0xFFFFFFFF | faux/vrai/faux/vrai ; état conservé | Conforme dans les4cas. |
| Ajout dans vide puis ajout distinct | vrai et entrée ajoutée | Conforme dans les2cas. |
| Ajout d’un doublon | faux et collection inchangée | [10,20] reste [10,20]. |
| Retrait, vide ou absent | faux et collection inchangée | Conforme dans les2cas. |
| Retrait premier/milieu/dernier/unique | vrai ; compactage et fin mis à jour | [20,30], [10,30], [10,20], [] respectivement. |
| Fixture préexistante avec doublon | première occurrence seulement retirée | [10,10,20] devient [10,20]. Ce cas adverse ne prouve pas que l’ajout unique crée des doublons. |

14appels distincts. Les valeurs sont des fixtures, pas des comptes valides ou authentifiés. Ces essais ne qualifient ni alimentation du provider, cycle de vie, réception de messages, concurrence, permissions ou persistance.

Non exécutés : handler complet, provider réel, sink/réseau, processus LoL, ActionScript, serveur de jeu, interface visuelle, build/tests Rust et acceptation humaine. Les contrôles et extractions hérités ne sont pas annoncés comme nouvellement exécutés.

## 5. Écarts et conditions précises de reprise

Résolu dans ce lot : état effectivement inversé par la commande, distinction des deux collections, gardes des effets, sémantique des routines32bits observées, enveloppe sociale et frontière de la demande HUD. Les retours « traité » sans changement sont explicités.

| Ouvert | Impact | Entrée nécessaire et condition de reprise |
|---|---|---|
| Filtrage de réception selon l’état ignoré | Impossible d’affirmer que les messages entrants sont réellement supprimés | Xrefs des lectures de la collection via0x7AAE70 et chemin d’arrivée du message, puis essai/message avant et après bascule avec source identifiée. |
| Provider et identités | Nom vers valeur opaque et sentinelles non qualifiés en partie | Implémentations virtuelles et producteurs du répertoire, cible connue/inconnue, doublons de noms et séparation joueur/compte. |
| Service social et accusé | Effet local et commande sink ne prouvent pas un blocage accepté | Corps du sink, événements de réception/ACK et règles locales explicitement définies ; deux comptes et refus observables. |
| Réinitialisation/persistance | Le texte annonce une session, sans preuve de cycle de vie | Constructeur/destructeur/remise à zéro de la collection, retour/reconnexion/nouvelle partie ; distinguer état de partie et compte. |
| File HUD+0x6C | État appliqué après chargement non établi | Producteur et consommateur de vidage ; ajout puis retrait avant chargement, lignes multiples, rendu observé. Aucun bug conclu à partir du seul stockage de nom. |
| Initialisation et erreurs | Pas de refus gracieux démontré pour service/provider nul | Invariants d’initialisation documentés et traitement local explicite en futur runtime ; ne pas tester un crash du client pour clore cet audit. |
| Implémentation locale | Pas de fonctionnalité ignore/mute de chat identifiée | Service de messages et consommateurs HUD/input disponibles, puis réalisation distincte de SYS-17.4-07 et qualification de la réception. |

L’inconnue existante SYS-17.4-07 → OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38 reste ouverte et inchangée. Les tâches de routage SYS-19.3-05 et SYS-19.3-07 et leurs inconnues ne sont pas clôturées par ce fragment. Aucun nouveau pourcentage de complétude n’est calculé.

Le prochain petit lot documentaire peut suivre les lectures de la collection depuis0x7AAE70 jusqu’au chemin de réception, car c’est une piste nouvelle précise issue de ce lot. Pas de recherche communautaire générale ou de répétition du parseur sans source, anomalie ou hypothèse nouvelle.

## 6. Corrections réutilisées, subdivisées et non exécutées

Les références ci-dessous subdivisent documentairement la tâche existante SYS-17.4-07 ; aucune insertion dans le plan ou changement de critères normatifs. Les dépendances sont identifiées, jamais présumées terminées.

| Référence stable proposée sous le parent | Résultat unique attendu | Critères de clôture future |
|---|---|---|
| SYS-17.4-07/I1-COMMAND | Relier la commande à la résolution et à l’état en partie | Deux bascules successives, inconnu, liste vide, plusieurs cibles ; état réel et retour de traitement distincts ; parseur déjà documenté réutilisé. |
| SYS-17.4-07/I2-STATE | Fournir la collection d’ignorance par joueur et son cycle de vie | Ajout sans doublon/retrait absent idempotents ; identités définies ; nouvelle partie et reprise documentées ; aucune autorisation déduite d’une valeur opaque. |
| SYS-17.4-07/I3-SERVICE | Relier l’état souhaité au service local de messages | État déjà atteint sans mutation/envoi supplémentaire ; changement et refus observables ; aucun accusé fictif ou transaction implicite entre couches. Dépend du routage privé/permissions des tâches sociales existantes. |
| SYS-17.4-07/I4-HUD | Relier le statut de sourdine à la ligne UI et à sa file différée | Chargé/non chargé, ligne absente, bascules avant chargement ; état final affiché à partir d’un producteur identifié ; aucune commande de combat issue du chat. |
| SYS-17.4-07/I5-RECEIVE | Qualifier et relier la suppression des messages entrants | Message autorisé avant, supprimé après ajout, rétabli après retrait ; audiences et historique séparés ; absence d’effet sur simulation de jeu observée dans le consommateur réel. |

Prérequis du plan lus et conservés dans les preuves héritées : D17-SYS-17-4 requiert D09-SYS-09-4 ; les services sociaux D19-SYS-19-3 requièrent D19-SYS-19-1. Aucun blocage persistant de compte n’est assimilé à une commande de chat en partie. Si un futur contrat de blocage de compte exige une tâche distincte manquante, elle devra être proposée explicitement, sans détourner une tâche audio ou de salon.

## 7. Livraison, identités et conservation

Fichiers nouveaux uniquement :

- Présent rapport : `F:\OpenLeague\docs\audit\units\AUD-17.4-07-IGNORE-01.md`.
- [verify_ignore.py](F:/OpenLeague-work/audit-units/AUD-17.4-07-IGNORE-01/verify_ignore.py), 18 334octets ; SHA-256 `0b1d32cdd9be0c19eb43b50cad1f4001a9b4ad747ccceb2564bb55722387d13a`.
- [ignore-proof.json](F:/OpenLeague-work/audit-units/AUD-17.4-07-IGNORE-01/ignore-proof.json), 740 280octets ; SHA-256 `21f90ad5ef2f81d9e3164547a87dddad9ec492af7cc4e6fb4fd6357cb576754a`.
- Reçu final : `F:\OpenLeague-work\audit-units\AUD-17.4-07-IGNORE-01\delivery-readback.json`, créé après ce rapport. Le premier reçu garde audit_scope_closed=false car il précède la relecture ; la clôture limitée est portée par le reçu de livraison sans réécrire la preuve.

19fichiers logiciels gelés,6documents d’instructions/contexte/méthode et2registres JSON comparés aux empreintes héritées ; même corpus1 168sources. Git avant/après : HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, mêmes76fichiers suivis déjà modifiés. Aucun stage, commit, reset ou nettoyage. Les reçus et travaux antérieurs restent conservés.

Relecture de livraison : identité du rapport/script/reçu, résultats239contrôles et14cas, octets de chaque instruction émulée, appel exclusif des deux helpers de collection sur les chemins observés, sept rubriques, séparation statique/émulation/runtime et conservation. Les résultats effectifs sont donnés par le reçu final.

Aucun changement du goal, de ses critères normatifs, du logiciel de suivi ou de ses bases. Aucune base ouverte, installation, migration, relance ou restauration. Aucune fonctionnalité ou tâche parente terminée. Bilan : un lot d’audit borné clôturé, zéro fonctionnalité implémentée ou qualifiée en partie ; la durée/persistance, la réception et le retour serveur restent explicitement ouverts.