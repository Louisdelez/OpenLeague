# AUD-17.3-06-SURRENDER-01 — Commandes de reddition et frontière du vote

2026-10-30 ; F:\OpenLeague ; goal SYS-01.2-02. Référence LoL4.20.0.315 PUBLIC/Releases/4.20 EUW/en_GB, catalogue4.20.1.

## 1. Question, critères et décision

Question : comment /surrender et /nosurrender déclenchent-ils une requête, et quels consommateurs actuels doivent accueillir un véritable vote d’équipe ?

Le tour précédent est un **progrès** : commandes d’émotes reliées à leur helper, ressources candidates inventoriées et consommateurs délimités. Nouveau lot unique : deux callbacks de reddition, contexte positif et champs sortants, puis distinction entre scrutin, retrait de connexion et fin de partie.

Sortie : commandes, gardes, bits et branches documentés ; consommateurs existants inspectés ; tâches et inconnues réutilisées ; manque du service et de ses règles précisément formulé. Exclusions : implémentation de vote, règles serveur originales, rendu/réseau et qualification de cérémonie après reddition.

**Audit terminé pour cette frontière.** Implémentation : aucun ajout ; pas de service de vote identifié dans le périmètre actuel inspecté. Les mécanismes de départ et de résultat existants sont préservés. Vérification : statique/d’identité seulement. Acceptation humaine : non demandée. Les exigences fonctionnelles et le goal restent ouverts.

Parents réutilisés :

- SYS-17.3-06 « Créer et résoudre un vote d’abandon selon les règles historiques », inconnue **OLU-e478cd59-a2e1-59d1-9ff9-735d85ec3462**.
- SYS-17.4-07 « Implémenter les commandes de chat historiquement applicables au serveur local », inconnue OLU-2407a043-c8a9-556b-be02-b93f1f6d5b38.

Prérequis : D17-SYS-17-3 requiert D20-SYS-20-3 (connexion/reconnexion) ; D17-SYS-17-4 requiert D09-SYS-09-4. Ces lots restent recensés a_faire et ne sont pas déclarés acquis par une lecture documentaire. Aucun goal, statut ou critère normatif modifié.

## 2. Sources et preuves réutilisées

PE original : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe ;15973880octets ; SHA-256 **402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862**.

Catalogue réutilisé : F:\OpenLeague-work\audit-units\AUD-17.4-07-COMMANDS-01\commands-catalogue.json, SHA567a26d25c715de378f2782b5db6629cecaccdd12efb18ff6bacbb11947710f0. Il rattache le champ0x18 de surrender à0x7A3CB0 et celui de nosurrender à0x7A3DA0 ; leurs alias lexicaux et deux locales sont conservés. Les textes d’aide ne constituent pas une preuve de quorum, de délai ou d’autorité serveur.

La preuve F:\OpenLeague-work\audit-units\AUD-17.4-07-EMOTES-01\pause-predicate-proof.json est réutilisée par SHA83b3b5536e5557692397c968a7c93feca50b5738a975a1c86d0a7bd12f833ffc : pour la classe de contrôleur à vtable0x10DEAC4, le slot+0x10 lit l’état paused. La sélection effective de cette classe en partie reste conditionnelle, sans généralisation de permission serveur.

Ancienne association : F:\OpenLeague\docs\reference_match_screens_sources\match_screens-links.json liait déjà SYS-17.3-06 à reconnect::abandon en précisant qu’un retrait d’hôte n’est pas un scrutin d’équipe. Ce constat est vérifié sur le code courant ; le reçu et l’inconnue ne sont pas réécrits.

Héritage résultat : F:\OpenLeague\docs\match_results_progress.json, daté2026-10-05T16:28:00.997899+00:00. Les huit empreintes de sources qu’il cite ne concordent plus avec les fichiers actuels. Ses tests et sa capture à gagnant injecté sont conservés comme résultats historiques, sans requalification du runtime actuel et sans déduction d’une régression à partir de la seule différence d’empreinte.

Outils Python/pefile/Capstone existants, producteurs/modules/DLL hachés. Lecture de quatre fonctions complètes,222instructions. Aucun nouveau PE, installation, session REA ou exécution du jeu/code natif.

## 3. Consommateurs natifs et actuels

### Chemin positif

0x7A3CB0–0x7A3DA0, fin exclue : le callback vérifie un octet global via0x2D789B4, le HUD0x2D77E54 et son contexte+0xE8. Sous les gardes du contrôleur, il appelle0x7E3100 si le contexte existe et si le prédicat virtuel permet le chemin.

0x7E3100–0x7E31B5 lit un identifiant du personnage, un marqueur local+0xF4 et une liste d’identifiants aux offsets+0xE8/+0xEC. Marqueur déjà posé ou identifiant présent dans la liste évitent l’appel d’envoi dans ce helper. Le marqueur peut ensuite être posé localement sans confirmation serveur. Le prédicat0x7E30D0 examine ce marqueur et l’étendue de la liste ; son résultat influence+0xF5. Les noms fonctionnels exacts de ces champs et leur remise à zéro ne sont pas entièrement qualifiés.

Le helper prépare6octets : opcode0xA4 si contexte+0xF6 vaut0, sinon0xFB ; dword de0x2D62CBC aux offsets1–4 ; bit0 de l’octet5 mis à1. Les autres bits du dernier octet ne sont pas explicitement initialisés par ces stores. L’identité sémantique du dword reste inconnue. L’appel de transport utilise vtable+0x30, longueur,tampon,1,0.

Le callback peut retourner AL=1 après avoir sauté l’appel, notamment selon le prédicat du contrôleur ou l’absence du contexte secondaire ; certains gardes externes mènent à AL=0. Ce résultat ne confirme pas qu’une requête a quitté le client ni qu’un scrutin a été accepté.

### Chemin négatif

0x7A3DA0–0x7A3E9E utilise l’octet global et le contrôleur, puis prépare directement6octets : opcode0xA4, même source dword, bit0 final mis à0. Il ne réutilise pas la boucle de dédoublonnage du contexte positif. Le retour normal AL=1 peut également suivre une branche sans envoi.

Le mode alternatif0xFB n’est pas renommé « vote anticipé », « remake » ou autrement sur sa seule valeur. La signification du champ+0xF6 et les autres chemins d’interface restent ouverts. Les invariants de contrôleur absent/non initialisé comportent diagnostics et écriture nulle dans ces corps ; aucun essai de crash ni qualification de refus gracieux.

Dans le répartiteur entrant0x5882C6 déjà identifié, les opcodes0xA4 et0xFB donnent chacun la cible par défaut0x58830A. Cela borne **ce répartiteur** et empêche de supposer une réponse immédiate à partir de la requête. Le message serveur de création/mise à jour/résolution du vote n’est pas retrouvé dans ce lot.

Aucun de ces corps ne fournit les seuils, la durée, la majorité ou les règles propres au mode3v3. Les marqueurs et la liste côté client ne sont pas l’autorité du scrutin serveur.

### État d’OpenLeague

Recherche reproductible des sous-chaînes surrender,nosurrender,forfeit,concede,vote dans1149fichiers Rust sous crates/client/src,core/src,server/src, avec contrôles positifs/négatifs : aucun résultat. La lecture des schémas Action,ClientPacket,Input etServerMessage et du Snapshot inspecté ne révèle pas de contrat de scrutin. Cette absence est bornée à la recherche et aux consommateurs examinés ; aucun comportement dynamique global n’est prétendu prouvé.

F:\OpenLeague\crates\server\src\reconnect.rs:216–222 retire un bail sur instruction d’hôte de confiance, désactive sa reprise et produit Transition::Retired. session_host.rs:37–49 retire route,acteur et livraison. F:\OpenLeague\crates\core\src\attacks.rs:103–120 nettoie les états du joueur puis le retire. Ces consommateurs ne constituent pas une collecte/résolution de votes d’équipe.

Les acquis de fin de partie existent :

- F:\OpenLeague\crates\core\src\world.rs:414–416 affecte le gagnant lors de la destruction du Nexus.
- lib.rs:685–720 capture les résultats et arrête l’avancée normale dès qu’un gagnant existe.
- match_results.rs:15–27 garde le premier résultat capturé ; MatchResult contient gagnant,tick,joueurs et métadonnées Nexus, sans cause de fin ou état de vote explicite.
- F:\OpenLeague\crates\server\src\main.rs:210–220 persiste ce résultat et attend les conditions d’arrêt de la session ; result_store.rs est identifié, pas exécuté.

Le champ destroyed_nexus est actuellement sélectionné par équipe perdante sans filtre de santé dans capture_final_results. Son adéquation après une reddition doit être définie avec le contrat de cérémonie. Ce constat n’est ni un bug de reddition reproduit ni une preuve qu’un vote est déjà implémenté. Affecter seulement winner ne qualifie pas un scrutin, sa fin et son retour utilisateur.

## 4. Attendu/observé et contrôles exécutés

W désigne F:\OpenLeague-work\audit-units\AUD-17.3-06-SURRENDER-01. Commande : Python existant -X utf8 -E -B sur W\verify_surrender.py. Résultat au2026-10-30T15:32:27.253826+00:00 : **code0 ;86contrôles statiques/d’identité réussis**.

| Cas | Attendu | Observé et limite |
|---|---|---|
| Catalogue nominal | Relier les deux noms à leurs callbacks | Pointeurs0x18 exacts et catalogue inchangé |
| Intention positive/négative | Distinguer les champs transmis |6octets,bit0=1ou0,contexte alternatif conservé ; pas d’envoi exécuté|
| Garde locale et répétition | Décrire ce qui évite un appel |Marqueur/liste du helper positif,contrôleur et garde externe ; pas de dédoublonnage serveur prouvé|
| Retour de callback | Éviter un faux succès |AL=1 possible après saut de l’envoi ; aucune acceptation serveur observée|
| Invariant de contexte | Distinguer erreur d’invariant/refus |Diagnostic/écriture nulle identifiés ; non exécutés|
| Réponse reçue | Ne pas inventer le message de scrutin |A4/FB mènent au défaut dans ce dispatcher ; autre réception ouverte|
| Abandon d’hôte | Inspecter le consommateur réel |Retrait individuel identifié ; ne couvre pas la tâche de vote|
| Fin de partie | Conserver l’existant sans le transformer en vote |Victoire Nexus,capture,persistance et métadonnées relevées ; aucun nouveau test de match|
| Preuve ancienne | Vérifier sa portée actuelle |8empreintes de source différentes ; anciens tests/capture non réattribués aux sources actuelles|
| Conservation | Préserver le travail gelé |19fichiers gelés,six contextes et registres contrôlés inchangés|

Non exécuté : jeu, ActionScript, émulation native, tests Rust/Cargo, serveur/deux clients, vote réel, résolution, fichiers de résultats runtime, rendu/captures et acceptation humaine. Le tableau décrit des instructions et branches lues ; aucun refus ou quorum n’est présenté comme testé en partie.

## 5. Résolu, manques et reprise

Résolu : déclencheurs positifs/négatifs, bits et gardes côté client, contexte positif distinct, absence de contrat de scrutin dans les interfaces inspectées, distinction retrait individuel/vote, mécanismes terminaux existants et limites de leurs preuves héritées.

Manques ouverts : règles4.20Map10 de délai/quorum/éligibilité ; autorité par équipe et cas de déconnexion ; type/état du scrutin ; messages de création,mise à jour,refus et résultat ; UI,timeout,reconnexion ; causalité de fin et cérémonie/persistance après reddition. Aucune valeur moderne ou générique n’est substituée aux règles non établies.

Entrées de reprise précises : source4.20du mode ou trace contrôlée décrivant ces règles ; sémantique du champ+0xF6 et classe/runtime du contexte ; message de réception réellement relié au service ; contrat serveur local explicitement nommé lorsque l’historique reste inconnu, avec fidélité laissée ouverte ; consommateur final de résultat/cérémonie à qualifier pour cette cause.

Aucun asset absent n’est déclaré à partir de cette seule lecture. L’interface native de scrutin n’est pas auditée visuellement ici. Aucun nouveau lien communautaire accumulé ; les prochaines recherches partent de ces entrées nommées.

## 6. Corrections réutilisées et petits lots

Réutiliser SYS-17.3-06 pour le service de vote et SYS-17.4-07/K2-surrender,K2-nosurrender pour les commandes. Identifiants ci-dessous proposés uniquement dans cette documentation ; aucun registre ni case modifié.

| Lot sous SYS-17.3-06 | Résultat unique et critère de fin |
|---|---|
| V1-règles-mode | Éligibilité,délai,majorité,durée et renouvellement sourcés pour4.20Map10 ; inconnues distinctes d’un choix local ; aucune règle inventée comme référence|
| V2-état | Scrutin serveur identifié par session,équipe,identifiant,type et échéance ; acteurs/votes uniques ; événements invalides refusés explicitement|
| V3-création | Une demande autorisée ouvre un seul scrutin ; trop tôt,mode interdit,partie finie et scrutin déjà présent traités selon le contrat établi|
| V4-votes | Intention oui/non liée à l’identité réelle ; doublon,mauvaise équipe,ancien scrutin et changement de session contrôlés ; déconnexion conforme à la règle|
| V5-résolution | Majorité et timeout déterministes,une résolution unique ; résultat et refus observés sur clients ; aucun départ individuel utilisé comme raccourci de vote|
| V6-fin | Résolution acceptée reliée à la fin autoritaire,au résultat figé et à la persistance ; cause et cérémonie Nexus définies ; aucun succès fondé seulement sur un winner injecté|
| V7-interface | Affichage du scrutin,compteurs,temps et refus par son vrai consommateur ; votes/fin/pending distincts ; aucune acceptation déduite d’un retour1 de callback|
| V8-reprise | État de vote réconcilié après reconnexion sans duplication ; ancien vote/refus rejeté ; acteurs/résultat final conservés selon le contrat|

K2-surrender et K2-nosurrender doivent déléguer à ce service identifié, avec alias et acteur vérifiés ; syntaxe invalide et commande non supportée doivent produire un résultat explicite. L’audit des règles précède une implémentation historique ; une politique locale éventuelle garde sa qualification distincte. Aucune correction fonctionnelle exécutée sous ce goal d’audit.

## 7. Livraison et relecture

Seul nouveau fichier du dépôt : F:\OpenLeague\docs\audit\units\AUD-17.3-06-SURRENDER-01.md.

Nouveaux fichiers isolés dans W :

- verify_surrender.py :11517octets ; SHA-256 a7521fd0a614fa70144b23c41350a39ccc7fee648cc342ce107e44959df00b6e.
- surrender-proof.json :338150octets ; SHA-256 **731c41507851f8305f0eec26494ebd5a355169026c24a4a718cb878057a18354**. Sources,222instructions,tâches/prérequis,champs,fragments actuels,inventaire de recherche et comparaison de l’héritage y figurent.

Git avant écriture : HEAD8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,76modifications suivies préexistantes (-uno). Aucun add/commit/reset/checkout/clean. Les sources et anciens reçus sont conservés ; les19fichiers gelés et les six fichiers de contexte/cadrage restent identiques. Goal,critères normatifs,application de suivi,registres et bases inchangés ; aucune base ouverte ni application relancée.

Relecture des sept rubriques : portée/sortie,sources/provenance,consommateurs réels,attendu/observé/non-exécuté,manques/reprise,corrections atomiques existantes,livrables/conservation. Clôture limitée à cet audit ; vote d’abandon,commandes,jeu et goal global non déclarés terminés.