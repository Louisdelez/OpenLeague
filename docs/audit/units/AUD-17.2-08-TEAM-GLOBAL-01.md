# AUD-17.2-08-TEAM-GLOBAL-01 — Canaux du chat et permissions

Date : 2026-10-30. Projet : F:\OpenLeague. Goal SYS-01.2-02. Tâche SYS-17.2-08 ; exigence OLF-66cec52c-f885-5227-8725-761c85544389 ; inconnue OLU-5abd1f66-bc04-5d6c-a130-33387ecf2888.

## 1. Exigence et décision

Exigence entière auditée : « Afficher le chat d’équipe et le chat global selon les permissions ». Le critère produit existant exige un vrai consommateur, la référence4.20 et les succès/refus/limites documentés. Il reste inchangé et non satisfait dans le jeu actuel.

Question : relier les routes de canaux et le filtre client d’affichage à leurs sources, puis distinguer préférence locale, authentification, destinataires et autorité serveur. Critères du lot : sources identifiées ; consommateurs actuels ou absence délimitée ; cas nominal/limite/refus source vérifiés ; conditions de reprise et corrections ; sept rubriques relues. Arrêt avant l’implémentation du service virtuel+0x78, l’exécution du parser partagé, le film et le serveur. Ces bornes ne modifient aucun critère normatif.

| Dimension | Résultat |
|---|---|
| Audit | Terminé avec preuves pour l’état courant après relecture finale. Les routes client et limites de qualification des permissions sont explicites. |
| Implémentation | Chargement de configuration présent ; messages équipe/global, destinataires et affichage selon permission non identifiés dans les consommateurs inspectés. |
| Vérification |149 contrôles sur21cas bornés : trois callbacks complets sans HUD et18fragments ; aucune livraison réelle ou permission serveur qualifiée. |
| Acceptation humaine | Non demandée ; aucun parcours produit accepté implicitement. |

Clôture documentaire seulement : la tâche reste a_faire et l’inconnue open dans leurs registres. Aucun autre chat, champion, jeu ou goal global n’est déclaré fonctionnellement terminé.

## 2. Sources, identités et provenance

Référence LoL4.20.0.315, EUW, en_GB. Client original :

`D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`

15 973 880octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; ImageBase0x400000. Adresses VA ; fins exclusives. Dix intervalles contigus,395instructions ; huit fonctions finissant sur RET et deux fragments explicitement bornés.

| Intervalle | Source qualifiée |
|---|---|
|7A3BE0–7A3CA8| handler de commande all : préférence/branche d’information ou requête du service |
|7AC910–7AC9D2| association des callbacks FSCommand aux boutons et ChatSend |
|7ACA00–7ACA1D| callback Press_SendTeam→8247D0 si propriétaire présent |
|7ACA20–7ACA3D| callback Press_SendAll→8248B0 si propriétaire présent |
|7ACA40–7ACAE6| ChatSend : choix selon modes/entrées, retour traité ; chemins de plateforme non exécutés |
|8247D0–8248A2| route équipe : compare/retire le préfixe exact avant parser partagé |
|8248B0–82499B| route global : assure le préfixe avant le même parser |
|7AB9E0–7ABA33| valeur chat+EB et clé de préférence normale/spectateur |
|7AA511–7AA581| fragment de filtrage d’affichage de messages marqués |
|825035–82503F| clé d’information sur canal global masqué ; pas tout le helper |

Littéraux : ChatSend, Press_SendAll, Press_SendTeam, Chat, ShowAllChannelChat, ShowAllChannelChatSpectator, flash_hud_Chat_Info_AllChannelHidden et préfixe `/all ` de cinq octets. Leur lien source ne prouve pas des droits serveur.

AS2 hérité des deux films HudChat.gfx exacts : onSendTeamPress/onSendAllPress transmettent le texte et Press_SendTeam/Press_SendAll ; Enter émet ChatSend. DDW.Communication.Comm.send appelle fscommand seulement dans la branche isGfx. Il s’agit de l’interface film→hôte, pas d’un paquet réseau déjà identifié. Les films et l’extraction sont identifiés dans le reçu historique ; aucun export rejoué.

Preuves réutilisées :

- [Sources du chat](F:/OpenLeague-work/audit-units/AUD-17.2-08-CHAT-01/chat-contract-proof.json), SHA-256 `b37673bddaf069bcbcef483c419db9ecd7186d11104a4e847923a430dc8c8906` : films, configuration, UI et consommateurs.
- [Filtre de réception/ignore](F:/OpenLeague-work/audit-units/AUD-17.4-07-IGNORE-RECEIVE-01/ignore-receive-proof.json), SHA-256 `3a0c0ea2460a247ca899a16aef6e3da04eed9ec44dd71a34d00e24859e72a4f9` : fonction7AA4B0 et portée de présentation ; aucun nouveau réseau déduit.
- [Catalogue des commandes](F:/OpenLeague-work/audit-units/AUD-17.4-07-COMMANDS-01/commands-catalogue.json), SHA-256 `567a26d25c715de378f2782b5db6629cecaccdd12efb18ff6bacbb11947710f0` : association historique du handler all et des alias, pas sa livraison.
- [Historique consolidé](F:/OpenLeague-work/audit-units/AUD-17.2-09-HISTORY-REQUIREMENT-01/history-requirement-proof.json), SHA-256 `57f1f97759a5da21a5d44558d4d2cadbc2af4356a73368d9790cb3b0dbc1dd23` : corpus, interfaces et stockage distinct.
- [Focus](F:/OpenLeague-work/audit-units/AUD-17.4-08-CHAT-FOCUS-01/chat-focus-proof.json), SHA-256 `e028beb51ada9ee1442735dfc32a4b1cae7f2926ea00cd3c976537da05278209` ; [relecture corrigée](F:/OpenLeague-work/audit-units/AUD-17.4-08-CHAT-FOCUS-01/delivery-readback-v2.json), SHA-256 `070c73e7929182c76fbdf14f928e30ba61ad1701df82691a73658bd1082a851a` : autre exigence, absence courante et garde-fous conservés.

Outils existants : Python, pefile2024.8.26, Capstone5.0.7, Unicorn2.1.4, identifiés avec DLL. Aucun téléchargement, installation, nouveau PE ou import REA/Ghidra.

## 3. Contrat natif et consommateurs actuels

### Routes équipe/global et portée du retour

Le callback équipe appelle8247D0, le callback global8248B0. Les deux retournent1 même si le propriétaire HUD global est nul et qu’aucun appel n’a lieu : trois chemins complets observés incluent aussi ChatSend sans HUD. Ce retour signifie un traitement local, pas un succès d’envoi.

Les routes8247D0/8248B0 passent par le buffer global2D62DF8 puis le parser7A7260. Leurs comparaisons portent sur les cinq premiers octets préparés et le littéral `/all `. La route équipe retire ce préfixe exact quand il est présent ; la route global l’ajoute s’il est absent. Les copies/concaténations et le parser ne sont pas exécutés dans ce lot. Les capacités0x100/0xFF de ces buffers ne deviennent pas une limite universelle de texte ou de paquet. La comparaison stricte testée n’établit pas la politique de casse de tous les alias du parser.

Le handler7A3BE0 teste le champ+0x54 d’un fournisseur, puis chat+EB. Dans la branche sélectionnée il appelle le helper d’information825000, auquel est reliée la clé AllChannelHidden ; sinon il prépare le texte et l’argument1 pour le service virtuel+0x78. Aucun récepteur concret de ce service, format réseau, autorité ou accusé serveur n’est qualifié ici. Le producteur et la signification exacte du champ+0x54 restent ouverts.

### Préférence d’affichage et réception

7AB9E0 enregistre une valeur dans chat+EB puis sélectionne ShowAllChannelChat ou ShowAllChannelChatSpectator selon un autre prédicat du service. Ces clés et le lien au même champ sont identifiés, sans exécution du setter complet.

Le fragment7AA511–7AA581 compare une identité d’entrée à une référence32bits fournie par le contexte natif. Son sens joueur/compte n’est pas établi ; les fixtures ne l’appellent pas « mon joueur ». Si la comparaison le permet et le bit0x100 du paramètre de drapeaux est présent, il consulte le champ fournisseur+0x54 ; avec ce garde actif et un propriétaire HUD présent, chat+EB=0 mène au retour sélectionné7AAD1D, avant les étapes ultérieures de présentation.

Le bit0x100 désigne ici la branche marquée utilisant cette préférence ; il n’est pas promu en enum universelle de canal. Garde fournisseur désactivé, HUD absent, identité de référence égale ou bit absent peuvent franchir ce filtre. Leur effet ne prouve ni autorisation réseau ni présence d’un message affiché.

Le filtrage ignore source du lot précédent et ce filtrage de visibilité sont distincts. Le réseau a pu recevoir le message avant ces branches ; les logs, stockage serveur et autres routes ne sont pas qualifiés par un saut de présentation.

### Consommateurs locaux réellement inspectés

Les vrais points présents restent le chargement Chat.ini dans `crates/client/src/native_zip_provider.rs:74`, son stockage de configuration et le diagnostic `main.rs:601`. Ils ne produisent ni message de joueur ni destinataires. Snapshot/Action/ClientPacket/ServerPacket dans `crates/core/src/lib.rs` et Input/ClientMessage/ServerMessage dans `session_transport.rs` sont relus par fragments identifiés ; aucun canal/flux d’affichage du chat requis n’y est identifié.

Corpus courant :1 168sources Rust, JS et HTML. Recherche de chat héritée conservée pour1 158sources communes et dix sources launcher, sans nouvelle recherche inchangée. Une recherche nouvelle des callbacks, de ShowAllChannelChat et des quatre routes natives ne trouve aucun adaptateur exact ; témoins positifs/négatif réussis. La conclusion d’absence est délimitée à ces sources et interfaces ; les règles existantes de session, combat et confidentialité ne sont pas niées ni remplacées.

## 4. Vérifications réellement exécutées

Python existant, `-X utf8 -E -B verify_team_global_chat.py`, code0 :149/149 contrôles sur21cas. Dates exactes dans le reçu. Octets originaux, aucun patch/stub ; globals2D7878C et2D77E54 fournis comme données de fixtures. Contextes, pile, identité de référence et buffer préparé sont explicites. Aucune écriture CPU dans l’image PE ; seules fixtures/pile sont modifiées. Limites100000instructions/deux secondes.

| Groupe | Cas | Attendu/observé | Limite |
|---|---:|---|---|
| Handler all, fournisseur54/showEB |4| une combinaison atteint le helper d’information, trois l’entrée de préparation du service | arrêts avant helper/service ; aucun refus serveur ou envoi observé |
| Réception marquée |8| deux combinaisons masquées, six continuations conformes | contextes préparés ; arrêt avant retour/présentation ultérieure ; pas de rendu |
| Boutons sans propriétaire |2| retour1 sans appel | chemins complets, aucun message transmis |
| Boutons avec propriétaire |2| bon pointeur de texte avant les deux cibles distinctes | arrêts avant8247D0/8248B0 |
| ChatSend sans propriétaire |1| retour1 sans service | chemin complet, helper de cookie original seulement |
| Comparaison de préfixe préparé |4| `/all ` correspond ; `/ALL `, `hello`, `/all` ne correspondent pas | comparaison originale seule ; copie initiale, suppression et parser non exécutés |

Les huit cas de réception couvrent égalité de référence, absence du bit, garde fournisseur off, HUD absent, show0/1/2 et bit supplémentaire. Le cas show2 vérifie « non nul », pas la production réelle d’états non canoniques. HUD présent suppose ici chat+0x110 non nul ; aucune garantie globale de durée de vie ou bug de pointeur nul n’est déduit.

Trois callbacks sont complets ;18cas sont des fragments ou préfixes, jamais18livraisons. Les traces consignent les instructions distinctes observées et leurs octets, pas toute la chronologie répétée. Les autres contrôles portent sur sources, vtables indirectes nommées, littéraux, AS2, consommateurs, registres lus comme données et conservation.

Non exécutés : helper d’information, parser7A7260, service+0x78, copies complètes des routes, film/FSCommand réel, serveur/réseau, sélection effective de destinataires, trois clients, tests/build Rust, jeu complet, acceptation humaine. Les preuves anciennes ne sont pas annoncées comme nouvellement exécutées.

## 5. Écarts et conditions précises de reprise

L’inconnue du registre reste ouverte : le chargement Chat.ini ne qualifie ni permissions ni livraison. Le présent lot ajoute les routes de canaux et la préférence client, sans transformer celle-ci en politique d’autorisation.

| Manque/inconnue | Condition de reprise |
|---|---|
| Message et auteur authentifié | Vrai schéma core/transport et serveur local ; auteur dérivé de la session, canal invalide et usurpation refusés explicitement, identité tracée. |
| Destinataires et permissions historiques | Source serveur/observation4.20 autorisée ou contrat local explicitement distingué ; équipes, adversaires, spectateur et restrictions identifiés. Le client et ses booléens ne suffisent pas. |
| Parser et service natifs | Examiner7A7260, implémentation réelle du slot+0x78 et producteurs des contextes ; limites, codes d’erreur et portée des retours qualifiés. |
| Identité de référence/bit0x100/fournisseur54 | Producteurs et callers précis ; qualifier les significations plutôt que nommer les fixtures comme comptes/joueurs/canaux connus. |
| Livraison autorisée | Deux clients alliés et un adversaire identifiés, messages équipe/global, refus/isolation/doublons ; observation côté serveur et destinataires. |
| Affichage et préférence | Vrai HUD alimenté ; canal/auteur visibles, ShowAllChannelChat normal/spectateur selon contrat, messages masqués sans confondre autorisation et visibilité ; rendu et erreurs observés. |
| Ordre avec ignore/historique/focus | Relier les consommateurs déjà sourcés aux exigences propres ; aucune réussite d’envoi/historique/focus déduite de ces callbacks. |

Les inconnues limitent fidélité et implémentation ; elles n’empêchent pas de constater et documenter l’état courant selon les sept rubriques. Source disponible mais partielle, consommateur courant non identifié dans les bornes examinées, comportement et manques nommés : l’audit documentaire peut être clos, la fonctionnalité reste ouverte. Aucune demande générale d’assets supplémentaires ne remplace ces entrées précises.

Réutiliser ces preuves. Ne pas répéter les mêmes gardes ou recherches sans modification, nouveau caller ou observation réseau pertinente. Le goal global reste actif et incomplet.

## 6. Corrections petites sous les identifiants existants

Propositions documentaires seulement ; aucune tâche ajoutée/cochée, aucune modification des critères normatifs ou du logiciel.

| Référence | Objectif unique | Critères futurs |
|---|---|---|
| SYS-17.2-08 / C1 contrat de message, réutilisé | Canal, auteur, destinataires et refus | Contrat sourcé ou choix local tracé ; auteur de session ; canal/auteur invalides refusés ; message équipe limité aux autorisés. |
| SYS-17.2-08 / C2 livraison, réutilisé | Transport réel conforme à C1 | Deux alliés et un adversaire, équipe/global, refus et isolation ; identités des versions, logs et limites ; dépend de confidentialitéD13-SYS-13-3. |
| SYS-17.2-08 / C3 affichage, réutilisé | Consommateur HUD réel | Canal/auteur/erreur visibles selon le contrat ; captures nominales/limites ; aucun succès fictif quand le transport échoue. |
| SYS-17.2-08/C3-VISIBILITY, précision proposée | Préférence locale d’affichage | Normal/spectateur et messages marqués qualifiés ; réglage visible vérifié distinctement des droits du serveur ; ne pas afficher un contenu non livré/autorisé. |

Le besoin produit n’est pas redéfini par les offsets/classes d’origine. Les acquis actuels de session, protocole et HUD doivent être réutilisés. Prérequis hérité : D17-SYS-17-2 requiert D13-SYS-13-3 ; aucun prérequis déclaré terminé ici.

## 7. Livraison et conservation

Fichiers nouveaux uniquement :

- Présent rapport : `F:\OpenLeague\docs\audit\units\AUD-17.2-08-TEAM-GLOBAL-01.md`.
- [verify_team_global_chat.py](F:/OpenLeague-work/audit-units/AUD-17.2-08-TEAM-GLOBAL-01/verify_team_global_chat.py),17 157octets ; SHA-256 `8adf16b8d0b0280a53de50962ac82637b1fd48a5f6ce165d88b64abb96aa8721`.
- [team-global-chat-proof.json](F:/OpenLeague-work/audit-units/AUD-17.2-08-TEAM-GLOBAL-01/team-global-chat-proof.json),270 247octets ; SHA-256 `48877ea06d9a4445be78736944bc3a88eb50c11e1f950535bff9c5b9cbea1b22`.
- Relecture finale : `F:\OpenLeague-work\audit-units\AUD-17.2-08-TEAM-GLOBAL-01\delivery-readback.json`. Le reçu principal antérieur conserve audit_scope_closed=false ; la relecture finale peut porter la clôture documentaire de l’exigence.

La relecture examine les149contrôles,21cas et distinction3/18, octets originaux, sources/consommateurs, sept rubriques et limites, corrections et identifiants, empreintes citées et conservation. Aucun nombre de contrôles ou de liens n’est converti en taux de jeu terminé.

Conservés :19fichiers logiciels gelés,6documents d’instructions/contexte/méthode, registres, preuves et1 168sources ; HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, mêmes76fichiers suivis déjà modifiés. Aucune écriture Git, restauration, suppression ou nettoyage.

Goal, critères normatifs, plan, application de suivi, interface et bases inchangés. Runtime non invoqué, bases non ouvertes ; aucune installation, migration, relance ou nouveau binaire. Le lot précédent est une progression vérifiée. La présente clôture documentaire ne ferme aucune fonctionnalité ni le goal global.
