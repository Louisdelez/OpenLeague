# AUD-17.3-06-TEAM-VOTE-01 — Audit complet du vote d’abandon

Contrôle du2026-10-31,projet F:\OpenLeague,goal SYS-01.2-02. Tâche SYS-17.3-06 : « Créer et résoudre un vote d’abandon selon les règles historiques ». Exigence OLF-d43940f8-8d91-5ecb-ac6d-a597c8611b47 ; inconnue OLU-e478cd59-a2e1-59d1-9ff9-735d85ec3462. Référence LoL4.20.0.315 PUBLIC/Releases/4.20 EUW/en_GB,catalogue4.20.1 distinct.

## 1. Question, périmètre et décision

Question : quelles sources et quels consommateurs couvrent les règles,la création,les votes,la résolution,la présentation,la fin et la reprise du scrutin ? Ce lot complète le périmètre documentaire parent. L’ancien AUD-17.3-06-SURRENDER-01 avait terminé la frontière des commandes,des bits et des consommateurs de retrait ; il ne qualifiait pas toute l’interface native ni le service de vote. Ses acquis sont réutilisés sans nouvelle analyse des222instructions natives.

**Audit parent terminé sous condition de relecture indépendante des sept rubriques. Fonctionnalité non terminée.** Le reçu delivery-readback.json établit cette décision après contrôles ; team-vote-proof.json garde audit_scope_closed=false en attendant. Le vote n’est pas ajouté au jeu. Implémentation : aucun contrat/service de scrutin nommé retrouvé dans les consommateurs inspectés ; retrait,fin Nexus,résultats et retour existent. Vérification : export statique nouveau,lectures/identités,réutilisation de huit tests antérieurs ; aucun vote réel ni nouvelle partie. Acceptation humaine : non donnée. Goal global et tâche fonctionnelle restent ouverts.

Critère propre au petit lot : toutes les clauses du parent ont une source et un consommateur exacts ou une absence bornée avec manque et condition de reprise ; chaque écart réutilise les huit corrections V1–V8 existantes. Aucun objectif,critère normatif,registre ou état du suivi n’est changé.

Prérequis : D17-SYS-17-3 comporte neuf tâches et requiert D20-SYS-20-3 « Connexion et reconnexion »,encore a_faire et dépendant de D20-SYS-20-1. Un audit documentaire n’acquiert pas ces fonctionnalités par présomption. Le tour précédent est un progrès : SYS-17.3-05 a sa relecture285contrôles réussis,avec preuves avancées réutilisées,et reste fonctionnellement ouvert.

## 2. Sources, provenance et preuves réutilisées

### Frontière native déjà acquise

Le PE original15973880octets,SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862,est conservé dans D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy. Son identité est vérifiée sans exécution.

Le reçu AUD-17.3-06-SURRENDER-01/surrender-proof.json,SHA-256 731c41507851f8305f0eec26494ebd5a355169026c24a4a718cb878057a18354,et sa relecture9040a8b2141bb08f8a534e02822750a6342c17e07968d48ff8559612227f6b5e sont réutilisés. Le rapport antérieur et ses86contrôles restent inchangés. Les consommateurs actuels qu’il cite ont toujours les mêmes identités.

Acquis conservés : surrender0x7A3CB0→helper0x7E3100,nosurrender0x7A3DA0 ; requêtes6octets avec bit final0=oui/non ; contexte+0xF6 choisissant A4ouFB sur le chemin positif ; marqueur/liste de dédoublonnage local ; AL=1 possible sans envoi. Le global d’identité et les sept autres bits restent non qualifiés. A4/FB vont au défaut dans le répartiteur entrant précis0x5882C6,ce qui n’exclut pas un autre message ou consommateur reçu. Aucune réanalyse native ni session REA identique n’est relancée.

### Nouvelle piste native : Surrender.gfx

La question non couverte du panneau a une source nommée : DATA/menu/Surrender.gfx et DATA/Menu_SC4/Surrender.gfx dans le même déploiement. Les deux sont traités,car la sélection effective en partie n’est pas qualifiée. Aucun des deux n’est déclaré automatiquement « la variante3v3 ».

Exporter installé réutilisé : Java21 et JVM d’Eclipse Adoptium sous C:\Program Files\Eclipse Adoptium\jdk-21.0.10.7-hotspot ; ffdec.jar sous E:\MinecraftMOBA\tools\ffdec. Les trois composants sont relus contre les identités de l’export Scoreboard précédent. Aucun téléchargement ni installation. Commande conservée dans le reçu : java -Djava.awt.headless=true -jar ffdec.jar -onerror abort -importAssets yes,local -export script <nouveau dossier d’audit> <Surrender.gfx original>.

Deux exports terminés code0 ;28fichiers chacun,56au total. Sources,arguments exacts,horaires,journaux,producteur,Java/JVM/JAR et sorties sont identifiés dans surrender-extraction-receipt.json. Les scripts sont lus ; ActionScript/GFx et jeu original ne sont pas exécutés. Les DDS de même préfixe sont inventoriés avec identité :12pour menu,1pour Menu_SC4. Ce sont des ressources candidates identifiées ; leur rendu et leur montage effectif ne sont pas qualifiés.

| Variante native | Identité | Contrat de globals enregistré | Ressources DDS de même préfixe |

| menu | 21068octets ; 3034f0e5fa7ec2e4b3cdb22073b3b63f4a20802b44a1524e56b42d67f5912aac | 25 globals | 12 |
| Menu_SC4 | 21507octets ; 7f67a6a4b682dd5e1bde81bad5909968f63e2877b118fa003f302b5ee100caf9 | 26 globals | 1 |

Les25/26globals comprennent commandes de présentation et dimensions ; leur nombre n’est pas un nombre de fonctions de gameplay. La variante Menu_SC4 ajoute notamment SetColorBlindMode. Les différences exactes de source sont conservées ; elles ne sont pas fusionnées en une interface imaginaire.

### Layout et textes originaux

Le HUD.zip original et sa copie data/4.20/archives/menu/HUD.zip correspondent à76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c. Cinq sections [Surrender] sont trouvées,avec empreintes de membres et contenu. HudResolutionDefaults.ini donne XPos100,YPos65,Scale1.0,MinScale0.6,AnchorLR ; des sections de résolution peuvent être vides,ce qui n’est pas une corruption établie. Layout et cascade effective restent distincts.

Les fontconfig_en_GB/fr_FR natifs du même déploiement sont relus par identité. Clés flash_surrender_* et game_announcement_OnSurrender* : oui/non,confirmation,titre ; début,vote déjà émis,trop tôt,spam,comptage,compte à rebours,échec et accord,avec @ForVotes@,@AgainstVotes@,@RemainingTime@. Ces textes prouvent des entrées lexicales et familles de messages ; ils ne prouvent aucune valeur de quorum,de délai ni le producteur serveur réel. Le dictionnaire effectivement sélectionné en partie n’est pas qualifié.

## 3. Contrat de vue natif précis et ses limites

| Rôle | Consommateur natif exporté | Ce qui est établi |
|---|---|---|
| Initialisation | Riot/Surrender/Main.as | Crée root « layoutMc »,enregistre les entrées via CommandParser et l’ajoute au GameManager. Choix du movie par l’hôte non qualifié. |
| Configuration | CommandParser.genFunctions/parseCommand | SetPlayerCount,SetPlayerState,SetTimerDuration,InvokeYes,InvokeNo,Reset et commandes de layout/blink sont reliées à root. Ce sont des entrées de présentation appelées de l’extérieur. |
| Compteurs | Surrender.setPlayerCount/setPlayerState | Nombre parsé par parseInt ; largeur/visibilité des indicateurs dérivées de l’entrée. menu sélectionne frame état+1 ; Menu_SC4 emploie empty/yes/yes_CB/no et stocke l’état visuel. Aucun calcul de quorum autoritaire. |
| Geste oui/non | setCommNames ; DefaultButton.release→releaseButton→sendClickMessage ; Comm.send | commName SurrenderYes/SurrenderNo ; au relâchement,le code emploie pressPrefix « Press_ »,donc Press_SurrenderYes/Press_SurrenderNo,et non une déduction à partir du nom releasePrefix. Comm transmet fscommand si GameManager.isGfx. Ce chemin ne prouve pas le handler C++ reçu ni un vote accepté. |
| Confirmation locale | onGreenPress/onRedPress ; InvokeYes/InvokeNo | Masque les boutons,affiche flash_surrender_confirmYes/No,arrête le blink. Ces fonctions ne contiennent pas Comm.send ; elles ne constituent pas une confirmation de serveur. L’ordre dynamique entre listeners et hôte n’est pas exécuté ici. |
| Compte à rebours | setTimerDuration/onTimer | totalMs vient de parseInt(value),startTime de getTimer(),intervalle50 ; ratio temps écoulé/durée fourni. Expiration sur ratio strictement>1,masquage des barres,clearInterval puis surrenderTimedOut. Ce retour UI ne résout pas le vote serveur. |
| Fermer/réinitialiser | onReleaseClose/reset | Fermer masque root et émet closeSurrender ; ce n’est ni non,ni reddition. Reset réaffiche boutons/efface confirmation et totalMs. La durée de vie des intervalles et la validation des entrées répétées/invalides restent à qualifier dans le contexte d’hôte. |

Piège de source évité : menu a DEBUG=false et un bloc de démonstration avec3joueurs ; Menu_SC4 a un bloc gfxPlayer avec5joueurs. Le SetTimerDuration("2000") de ces blocs n’est pas une durée historique de scrutin. Les valeurs3,5,2000 et le seuil visuel de clignotement ne deviennent ni taille d’équipe,ni quorum,ni temps minimal du mode.

Aucun appelant serveur de SetTimerDuration/SetPlayerCount ni récepteur de création/résolution du vote n’est qualifié par ce seul export. Les règles4.20Map10 de temps minimal,durée,renouvellement,majorité,éligibilité,absents,égalité et relation pause/horloge demeurent inconnues. Les invariants d’entrée de l’UI n’établissent pas un refus gracieux des valeurs invalides : parseInt,indices et durée n’ont pas ici une validation métier démontrée. Aucune exécution d’entrée malformée ni bug runtime ne sont prétendus.

## 4. Consommateurs actuels et couverture de toutes les clauses

Le corpus courant relu comprend1 168sources : crates/*/src/**/*.rs,launcher/src-tauri/src/**/*.rs et fichiers.js/.html de premier niveau de launcher/web. Appartenance et chaque contenu correspondent au reçu de référence. La recherche surrender|nosurrender|forfeit|concede|vote|scrutin|reddition ne donne aucun résultat. La conclusion est bornée à ces noms et aux consommateurs effectivement inspectés ; un résultat vide n’est pas présenté comme une preuve sémantique universelle d’absence.

Les schémas Action,ClientPacket,ServerPacket,Input,Welcome,StateEnvelope et Snapshot sont lus,avec source et lignes. Ils portent commandes,pauses,horloge,session et état de jeu ; aucun contrat de scrutin identifié dans ce trajet. Un retrait d’hôte,un drain de launcher ou une victoire Nexus ne comblent pas ce manque.

| Clause du parent / correction réutilisée | Consommateur ou frontière actuelle | Résultat de l’audit |
|---|---|---|
| Règles V1 | Anciennes requêtes natives + UI/langues/layout ; aucun décideur serveur natif qualifié | Règles inconnues,entrée de reprise précise ; aucun chiffre inventé. |
| État V2 | core/lib.rs:209–384 et core/session_transport.rs:70–152 | Pas de scrutin nommé ni identité/échéance de vote dans les schémas inspectés. |
| Création V3 | Actions/transport ci-dessus ; nouveaux globals natifs ; aucune entrée courante nommée | Aucun service de création/admission identifié. |
| Votes V4 | Callbacks natifs déjà audités,Press_SurrenderYes/No côté vue | Intention et retour local décrits ; collecte/dédoublonnage autoritaires manquants dans le trajet courant inspecté. |
| Résolution V5 | Surrender.onTimer et absence de message de vote courant | Timeout UI distinct d’un verdict de majorité ; source du décideur manquante. |
| Fin V6 | world.rs:414 ; lib.rs:684–721 ; match_results.rs:15–28 ; result_store.rs ; server/main.rs:208–223 | Fin Nexus,capture unique,persistance et sortie possédée existent. Pas de cause de reddition dans MatchResult. |
| Interface V7 | Nouvel export de source ; résultat actuel match_results_ui.rs et native_endgame_ui.rs | Vue du scrutin native identifiée,aucun consommateur de scrutin courant nommé. Les écrans de résultat existants restent conservés. |
| Reprise V8 | server/reconnect.rs et session_host.rs ; contexte de session DTO ; session_departure.rs | Reprise/départ existent ; aucun état de scrutin à réconcilier identifié dans ce trajet. |

reconnect::abandon retire un bail individuel (retired=true,resumable=false) et produit Transition::Retired. session_host::apply retire route,acteur et livraison. Le launcher abandon() demande run.drain() pour un serveur possédé et refuse d’abandonner un serveur rejoint. Ces opérations ne collectent pas un vote d’équipe et ne doivent pas servir de raccourci de reddition.

La capture de résultat garde le premier résultat et sélectionne les métadonnées du Nexus perdant sans prédicat de santé. nexus_ceremony.rs lit ce destroyed_nexus et change sa présentation selon skin_due_for ; native_endgame_ui choisit victoire/défaite d’après l’équipe du participant et le gagnant. Une future cause « reddition » doit donc définir cette politique,plutôt que corriger arbitrairement une cérémonie valide pour la victoire Nexus. Ce n’est pas un bug de reddition reproduit : le producteur de reddition n’existe pas dans le trajet identifié. Injecter winner seul prouve au mieux une transition de test,aucun scrutin.

## 5. Vérifications, attendu/observé et réutilisation avancée

Les huit empreintes différentes du très ancien docs/match_results_progress.json restent conservées comme observation historique. Elles ne sont pas interprétées comme une absence de tests actuels. La preuve plus avancée Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2 est réutilisée via son runtime31ec67495ea4165b6ce1c91dc0c766b60ebb47f2bafca72451b2e34c10710edd,sa qualification,sa compilation terminale code0,son read0 distinct code0 et ses journaux terminaux.

**Huit anciens tests ciblés effectivement « ok » sont réutilisés** : deux résultats core,deux UI de résultats,trois départ/retour et un stockage. Six sources ciblées sont exactement celles de cette exécution : match_results.rs,world.rs,lib.rs,result_store.rs,match_results_ui.rs,session_departure.rs. Leurs dépendances complètes,binaires et rendu courant ne sont pas requalifiés. Le test de Nexus emploie la chaîne de dépendances et un appel direct de dégâts ; un autre test injecte winner. Ces tests ne simulent ni un vote réel ni une acceptation de reddition.

| Cas | Attendu à qualifier | Observé maintenant / preuve et limite |
|---|---|---|
| Demande et réponse oui/non | Intention liée au bon scrutin,acceptation distinguée du retour local | Commandes natives conservées et nouveau chemin de vue décrit ; aucune admission de scrutin actuelle exécutée. |
| Délai minimal/mode/équipe/partie finie | Refus explicite selon la règle du mode | Pas de règle originale chiffrée qualifiée ni service courant identifié ; cas et entrée manquante documentés. |
| Vote dupliqué/ancien/étranger | Une voix réelle unique pour le bon contexte | Garde locale native connue,mais aucune preuve de dédoublonnage autoritaire de vote ; reconnexion générique non promue en vote. |
| Majorité/échec/expiration | Résolution serveur une seule fois sur horloge définie | UI reçoit durée et états ; messages lexicaux succès/échec existent ; quorum et résolution serveur inconnus. |
| Fermer/confirmation/invocation | Ne pas transformer une vue locale en décision d’équipe | Close cache et notifie ; confirmation ne fait pas Comm.send ; InvokeYes/No appellent le retour local. Lecture statique,ordre d’événements non exécuté. |
| Entrée invalide/durée0/indice erroné/appels répétés | Contrat d’entrée et refus précis | Parse et accès visibles ; validation métier et durée de vie d’intervalles ouvertes. Aucun test ActionScript ni refus gracieux inventé. |
| Résolution→fin et persistance | Résultat immuable publié une fois avant départ,politique de cérémonie explicite | Résultats/stockage/départ couverts par huit essais conservés et sources correspondantes ; raccordement de reddition et cause manquent. |
| Déconnexion/reprise/pause | Votes et échéance réconciliés sans rejouer,horloge définie | Services de session et horloge existent séparément ; intégration au scrutin non identifiée. |

Exécuté réellement pendant le lot : extract_surrender.py,code0,les deux sous-commandes FFDec code0 et56scripts nouveaux ; verify_team_vote.py,code0,**249 contrôles documentaires réussis**. La relecture indépendante verify_delivery.py fournit son propre reçu avec le nombre exact,les sept rubriques et chaque attendu/observé.

Non exécutés maintenant : tests Rust/Cargo,jeu,natif isolé,ActionScript/GFx,UDP,deux clients,vote réel,rendu,GPU,clics,captures et acceptation humaine. FFDec exporte du texte ; ce n’est pas une exécution ActionScript. Les249contrôles ne sont pas249nouveaux tests de jeu. Aucun résultat de vote ou instantané de fin n’a été fabriqué.

## 6. Résolu, écarts et conditions de reprise

Résolu dans l’audit : couverture de toutes les clauses du parent,contrat de vue de deux variantes natives et ressources candidates identifiées,chaîne bouton→Press_→fscommand précisée,confirmations et timeout locaux séparés de l’autorité,frontières retrait/scrutin/résultat établies. La limite fondée seulement sur les anciens SHA de résultats est dépassée par huit essais réels ultérieurs et six sources identiques. Aucun écart fonctionnel corrigé pendant cet audit.

Restent ouverts : politique originale4.20Map10,classe/runtime du contexte et significationF6/FB,handler hôte des messages de vue,récepteur de création/mise à jour/résolution,service autoritaire et schémas,interface actuelle et sa sélection de variante,fin par reddition/cérémonie,reprise et parcours réel. Pas d’asset déclaré absent à partir de la seule absence de symbole courant ; pas de ressource reconstruite sans provenance.

Entrées de reprise : une source/constante/provider4.20 nommée pour chaque règle ; une chaîne d’appel ou observation discriminante liant le contexte réel,la variante et les messages ; à défaut,une politique locale explicitement décidée et versionnée laissant la fidélité historique ouverte. L’implémentation exige ensuite une intervention fonctionnelle autorisée distincte. Ne pas relancer la même décompilation de callbacks,le même export de56fichiers ou les huit tests inchangés sans nouvelle entrée,modification ou anomalie.

### Huit corrections existantes réutilisées,non appliquées

Les identifiants V1–V8 viennent de la section6 d’AUD-17.3-06-SURRENDER-01. Le détail ci-dessous affine leurs consommateurs,preuves et entrées de reprise ; aucun nouveau registre ni objectif du goal n’est créé. Les commandes réutilisent aussi SYS-17.4-07/K2-surrender et K2-nosurrender. Chaque proposition est proposed_not_applied.


#### SYS-17.3-06/V1-règles-mode — Qualifier les règles 4.20 du mode

Écart : Aucune valeur de délai minimal,quorum,durée,cooldown,éligibilité ou traitement des absents n’est qualifiée par le panneau.

Travail : Identifier source ou trace contrôlée 4.20Map10 ; séparer chaque paramètre et sa règle d’horloge ; distinguer un éventuel choix local explicite.

Critère de fin proposé : Règles et exceptions sourcées par mode/équipe/rôle ; tout paramètre inconnu reste ouvert,aucun3/5/2000de démonstration utilisé comme règle.

Entrée de reprise : Provider/constante/trace 4.20 précise nommée ou politique locale explicitement décidée,avec fidélité historique ouverte.

Dépendances réutilisées : D20-SYS-20-3.

Preuve attendue : Source/contrat identifié,attendu/observé des branches de ce seul résultat,journal terminal si exécution et consommateurs exacts ; vérification technique et acceptation humaine séparées.


#### SYS-17.3-06/V2-état — Définir l’état autoritaire du scrutin

Écart : Pas de schéma de vote identifié dans Input/Welcome/State/Snapshot/Action inspectés.

Travail : Définir session,équipe,ID de scrutin,phase,échéance et version ; distinguer intention,accusé/refus,état accepté et événement de résolution.

Critère de fin proposé : Identités et transitions explicites ; état invalide/ancien/étranger refusé ; aucune autorité donnée au compteur visuel.

Entrée de reprise : Règles V1 ou contrat local versionné autorisé,producteur et consommateurs nommés.

Dépendances réutilisées : V1-règles-mode, D20-SYS-20-3.

Preuve attendue : Source/contrat identifié,attendu/observé des branches de ce seul résultat,journal terminal si exécution et consommateurs exacts ; vérification technique et acceptation humaine séparées.


#### SYS-17.3-06/V3-création — Créer un seul scrutin autorisé

Écart : Callback et UI envoient des intentions ; ni service de création ni admission par mode/temps retrouvés.

Travail : Relier /surrender et son alias qualifié au producteur serveur ; vérifier délai/mode/fin/doublon et autorité d’équipe,avec refus explicites.

Critère de fin proposé : Une demande admissible crée un seul scrutin identifié ; trop tôt,mode interdit,partie finie et scrutin déjà actif ont le résultat du contrat.

Entrée de reprise : Consommateur V2 disponible et paramètres V1 établis ; intervention fonctionnelle autorisée séparément.

Dépendances réutilisées : V1-règles-mode, V2-état, SYS-17.4-07/K2-surrender.

Preuve attendue : Source/contrat identifié,attendu/observé des branches de ce seul résultat,journal terminal si exécution et consommateurs exacts ; vérification technique et acceptation humaine séparées.


#### SYS-17.3-06/V4-votes — Enregistrer une intention oui/non authentifiée

Écart : Les bits des callbacks et Press_SurrenderYes/No ne prouvent ni unicité serveur ni vote accepté.

Travail : Réutiliser les intentions positives/négatives et l’identité admise ; refuser mauvaise équipe,doublon,ancien scrutin ou epoch,et définir la déconnexion selon V1.

Critère de fin proposé : Un vote éligible modifie une seule fois le bon scrutin ; aucun compteur issu d’un client et aucun callback retournant1 ne devient une acceptation.

Entrée de reprise : V2/V3 disponibles,règle d’éligibilité V1 et contrat de dédoublonnage fixés.

Dépendances réutilisées : V2-état, V3-création, SYS-17.4-07/K2-nosurrender.

Preuve attendue : Source/contrat identifié,attendu/observé des branches de ce seul résultat,journal terminal si exécution et consommateurs exacts ; vérification technique et acceptation humaine séparées.


#### SYS-17.3-06/V5-résolution — Résoudre majorité et échéance une seule fois

Écart : Timer AS getTimer et événement surrenderTimedOut ne donnent pas le décideur serveur ni le quorum.

Travail : Résoudre sur l’autorité serveur selon V1 ; traiter succès,échec,égalité éventuelle,timeout et déconnexion ; notifier une issue stable et corrélée.

Critère de fin proposé : Une seule résolution déterministe ; vote après clôture refusé ; majorité et expiration observées selon l’horloge définie,indépendamment du timer visuel.

Entrée de reprise : Règles V1 qualifiées,état V2 et votes V4 disponibles ; cas frontières définis avant test.

Dépendances réutilisées : V1-règles-mode, V4-votes.

Preuve attendue : Source/contrat identifié,attendu/observé des branches de ce seul résultat,journal terminal si exécution et consommateurs exacts ; vérification technique et acceptation humaine séparées.


#### SYS-17.3-06/V6-fin — Relier la reddition à la fin et au résultat

Écart : Fin Nexus et résultats immuables existent ; cause de fin absente et cérémonie sélectionne les métadonnées du Nexus perdant sans prédicat de santé.

Travail : Réutiliser capture/persistance/retour existants ; définir cause et cérémonie de reddition puis raccorder uniquement la résolution acceptée,avant retrait des acteurs.

Critère de fin proposé : Résultat unique,participants figés et publication non écrasante ; politique Nexus explicite ; ni winner injecté seul ni retrait individuel ne prouve la reddition.

Entrée de reprise : V5 disponible,contrat cause/cérémonie décidé et consommateur SYS-17.3-07 qualifié pour cette cause.

Dépendances réutilisées : V5-résolution, SYS-17.3-07.

Preuve attendue : Source/contrat identifié,attendu/observé des branches de ce seul résultat,journal terminal si exécution et consommateurs exacts ; vérification technique et acceptation humaine séparées.


#### SYS-17.3-06/V7-interface — Raccorder la présentation du scrutin

Écart : Les deux Surrender.gfx exposent un contrat de vue natif mais aucun consommateur de scrutin courant nommé n’a été retrouvé.

Travail : Qualifier la variante et les entrées SetPlayerCount/State/TimerDuration,Reset et confirmations ; raccorder oui/non/refus,annonces et durée à l’état accepté,conserver retour local distinct du succès.

Critère de fin proposé : Votes,compteurs,temps,refus et fin affichés sur le parcours réel ; sélection de variante sourcée ; invalides traités explicitement ; closing UI ne devient pas un vote négatif ou une reddition.

Entrée de reprise : V2–V5 disponibles et provider/choix de variante qualifié ; source de règle de pause/horloge définie ; modification fonctionnelle autorisée.

Dépendances réutilisées : V2-état, V4-votes, V5-résolution, SYS-17.4-07/K2-surrender.

Preuve attendue : Source/contrat identifié,attendu/observé des branches de ce seul résultat,journal terminal si exécution et consommateurs exacts ; vérification technique et acceptation humaine séparées.


#### SYS-17.3-06/V8-reprise — Réconcilier le vote après reconnexion

Écart : Reconnexion existe,mais aucun état de scrutin à réconcilier dans les DTO inspectés.

Travail : Réutiliser le contexte de session admis ; restaurer phase,votes et échéance autoritaires,sans rejouer création ni vote,et retirer l’ancien scrutin à changement de session/fin.

Critère de fin proposé : Reprise dans le même scrutin sans double vote ; ancienne epoch/refus ignorés ; résultat final figé et départ conservés selon contrat.

Entrée de reprise : V2/V5 et lot D20 disponibles,état de reprise et politique des absents V1 établis.

Dépendances réutilisées : V2-état, V5-résolution, D20-SYS-20-3.

Preuve attendue : Source/contrat identifié,attendu/observé des branches de ce seul résultat,journal terminal si exécution et consommateurs exacts ; vérification technique et acceptation humaine séparées.


## 7. Livraison et conservation

Nouveaux fichiers uniquement. Seul nouveau document du dépôt : docs/audit/units/AUD-17.3-06-TEAM-VOTE-01.md. Les autres livrables sont isolés dans F:\OpenLeague-work\audit-units\AUD-17.3-06-TEAM-VOTE-01 : cadrage,extracteur,deux journaux et56scripts exportés,reçu d’export,lecteur d’audit,preuve,lecteur indépendant et son reçu. Chaque écriture est une création exclusive ; anciens scripts,rapports,reçus et ressources conservés.

Les19fichiers logiciels gelés,les six documents de contexte/méthode et les cinq registres normatifs restent identiques ; corpus courant1 168sources contrôlé sans modification. Git HEAD8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,branchemain,76modifications suivies préexistantes et statut exact conservés. Aucun add/commit/reset/clean/checkout. Aucun sous-agent.

Goal et critères normatifs inchangés. Suivi/interface/bases inchangés. Aucune base ouverte,aucun appel Plan/work_cli/Store,aucune installation,migration,suppression ni relance d’application. Seul le processus d’export headless de l’outil existant a traité les sources. Le projet de travail reste F ; les ressources originales restent sur D et l’outil historique reste en lecture sur E.

Relecture R1–R7 : périmètre parent complet et prérequis ; sources/provenance/export/limites ; consommateurs réels ou recherche bornée ; attendu/observé/contrôles/non-exécuté ; manques et conditions de reprise ; huit corrections atomiques réutilisées ; identités/dates/conservation. audit_scope_closed=false dans le producteur. Le reçu indépendant établit parent_documentary_scope_closed après succès de ses sept rubriques. SYS-17.3-06,son inconnue et le goal global ne sont pas déclarés fonctionnellement terminés.

Identités des nouveaux fichiers avant relecture :


- F:\OpenLeague-work\audit-units\AUD-17.3-06-TEAM-VOTE-01\audit-unit.json ; 2366octets ; SHA-256 e26aab5bb1ddda0c1f9b790f747e420ef22a09235560201b12899fae61124cab

- F:\OpenLeague-work\audit-units\AUD-17.3-06-TEAM-VOTE-01\extract_surrender.py ; 3155octets ; SHA-256 25dd37e1b1cdcecb8dd8f0c509c395cf3752b20ff3df56fc934b362d0fb4ce83

- F:\OpenLeague-work\audit-units\AUD-17.3-06-TEAM-VOTE-01\surrender-extraction-receipt.json ; 25183octets ; SHA-256 5b38d9b5dde5c1c53411c1ae4718f33e6359b8c4af9772d7efd5691416d0a8e5

- F:\OpenLeague-work\audit-units\AUD-17.3-06-TEAM-VOTE-01\verify_team_vote.py ; 27020octets ; SHA-256 96fe8960dd7c003a43976e59d0dd9ecc6a56928a4d583fbe8a21fae3f90f765c

- F:\OpenLeague-work\audit-units\AUD-17.3-06-TEAM-VOTE-01\team-vote-proof.json ; 306601octets ; SHA-256 ff7eba15bb3fdd545bee64c9f461945338ad20f4cbe4e8160a66564711b0cfd2


Le reçu indépendant porte les identités du rapport et de son propre lecteur. Pas d’identité circulaire ni réécriture d’une preuve antérieure.
