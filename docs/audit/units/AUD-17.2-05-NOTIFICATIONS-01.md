# AUD-17.2-05-NOTIFICATIONS-01 — Notifications d’objectifs et d’éliminations

Le serveur produit déjà des événements d’élimination et les transporte dans les instantanés. L’audit ne trouve pas de consommateur de ces événements dans le client ni de raccordement des annonces natives au HUD courant. Les états d’objectifs, les sons d’autels, les helpers de formatage et les résultats terminaux existent ; ces acquis ne sont pas une notification visuelle en partie. L’audit est clôturable après relecture indépendante, avec une fonctionnalité partielle et les corrections ouvertes.

## R1 — Exigence et frontières

- **SYS-17.2-05**, « Afficher les notifications d’objectifs et d’éliminations ».
- Exigence **OLF-26ecdaa8-1417-5d0b-bf98-10e8157839ec**.
- Inconnue **OLU-607f028f-1117-51ab-82f8-6f0266e95baf**, conservée `open`.
- État normatif conservé `a_faire`, `implementation_complete=false`, `acceptance_complete=false`. Aucun critère normatif modifié.
- Référence LoL 4.20.0.315 PUBLIC Releases/4.20, EUW, en_GB, catalogue 4.20.1. La présence de modèles localisés et de chemins audio n’établit pas leur rendu en en_GB.

Portée : source de notification, producteur et données de contexte, transport/destinataire, formatage/queue/style/chat réellement consommés, contrôles attendus/observés, manques et reprise. L’audio est traité comme acquis adjacent et frontière de durée ; la clôture du moteur audio n’est pas ajoutée à cet objectif d’affichage. Aucun développement du jeu, aucun changement du goal, du suivi, de ses critères, registres ou bases.

Cette tâche appartient à D17-SYS-17-2 (neuf tâches), phase D17. Préparation : D13-SYS-13-3 « Confidentialité de l’état de jeu », encore `a_faire`, requiert D13-SYS-13-1. L’audience historique des notifications reste à qualifier ; le fait que kill_events ne soit pas filtré actuellement n’est pas qualifié ici comme vulnérabilité ou règle native correcte.

## R2 — Référentiel historique et limites

Racine : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/cfg/defaults/`.

Les cinq fichiers Announcements sont lus. Les sections/valeurs brutes, positions, catégories, modèles et champs absents ou vides sont conservés dans le reçu. Les noms et les champs GameMode ne démontrent pas la sélection effective, l’héritage ou les priorités entre fichiers.

| Fichier | Octets / SHA-256 | Sections / champs / sections candidates du lot |
| Announcements_ARAM.ini | 79603 / `d7aa28817aa1be61e8416bb49e3d5d4caff9c3eb31c92afa4e5e0587f50f9f48` | 72 / 1706 / 31 |
| Announcements_ASCENSION.ini | 58970 / `32ee43fd4b9a1d8106ac6adac9aa6b86b9cb596bf6fa21673c9a2f545fb20abd` | 57 / 1222 / 28 |
| Announcements_CLASSIC.ini | 90140 / `34165f547988b7dd0608bde1b4a4de8194f73300353bf9cb0566b5e805b9b2a4` | 80 / 1957 / 39 |
| Announcements_FIRSTBLOOD.ini | 60727 / `a1a7d85f8496ae53c60437d3a9cb7b0a0b377c6bcff40ea3ffc735e0a7643252` | 80 / 1354 / 43 |
| Announcements_ODIN.ini | 70692 / `9b899becb6a9d00c4c1772c070f6ea0f644e3ab2137b8120984826e0dd569626` | 80 / 1460 / 40 |

La sélection d’audit retient les noms On* contenant Kill/Ace/Dampener/Turret/Capture/Ascend/Relic/Point/Boss/FirstBlood/VictoryThreshold. Le motif exact, tous les noms de sections et les sections retenues sont enregistrés. Il y a **59 sections nommées distinctes**, réparties sur les cinq profils. C’est une classification lexicale d’audit, **pas 59 opcodes ni 59 événements indépendants**. Les sections Set, variantes spectateur et seuils peuvent dépendre d’un sélecteur/héritage non récupéré ; les sections hors objectifs/éliminations restent recensées mais hors de cette tâche.

La source CLASSIC comporte notamment les catégories Epic/Major/Minor, les styles de multi-élimination et les champs FontDescName, fades, DurationWithoutSound, MinDuration/MaxNumber/Position/Priority. `ExecutionBufferSize=2` ne prouve pas une capacité totale de file égale à deux ; les commentaires et valeurs écrites ne sont pas l’évaluateur natif. QuietPeriod, obsolescence, persistance et durées doivent être reliés aux consommateurs réels avant de devenir des règles implémentées.

Distinctions natives utiles, sans invention de sortie :

| Section CLASSIC | Champs réellement écrits | Conséquence documentaire |
|---|---|---|
| OnFirstBlood | Text, ChatMessage, catégorie LargeZoomIn, priorité 92 | Première élimination n’est pas simplement un compteur K/D/A. Le déclencheur/choix du profil reste à relier. |
| OnChampionKill | Text dynamique selon source/destination, catégorie Major, priorité 69 | Les rôles de victime/tueur et le destinataire local comptent ; les seuls IDs ne constituent pas un texte affiché. |
| OnTurretDie / OnDampenerDie | Text avec équipe/nom traduit, et chemins Sounds | Destruction de structure distincte d’un décès de champion. |
| OnKillSpiderBoss | ChatMessage, ChatMsgPersistent=1, priorité 74 ; aucun Text | Aucun champ de bannière à inventer parce que Category=Major. |
| OnCaptureAltar | ChatMessage avec équipe/autel, ChatMsgPersistent=1, priorité 74 ; aucun Text | Réutiliser le chemin chat/persistance, pas une bannière uniforme supposée. |
| OnKillSpiderBoss_Spectator | Text et ChatMessage, priorité 78, chemins sonores | Diffère de la section ordinaire ; le suffixe ne prouve pas à lui seul la sélection du mode spectateur. |
| OnCaptureAltar_Spectator | Text et ChatMessage, priorité 78 ; AllySound et Sounds présents mais vides | Une clé vide est conservée ; aucun son de remplacement n’est choisi. |

**FIRSTBLOOD / OnTurretDie est une section vide**, ligne 1024. Son absence d’affectation ne signifie pas automatiquement suppression, héritage ou bannière vide. La priorité/héritage natifs restent à qualifier. Cette distinction a déclenché le refus du premier lecteur, puis une correction conservatrice de celui-ci ; les sources originales n’ont pas été modifiées.

Le gradient original `DATA/Menu_SC4/Announcements/announceTextGradientTexture.tga` existe, 284 octets, SHA-256 **ae183bda389aac9b0d6084ddedf049e07cb394e531c45d81c6516cb60e0974de**. Identité seulement : pas de rendu ni de preuve de choix effectif. Les clés Text/ChatMessage et FontDescName sont des références, pas des traductions/glyphes/callbacks vivants déjà acceptés.

Les ports de l’annonceur existants sont conservés : familles ordonnées, rôles tueur/victime, noms, équipes/couleurs, icônes, styles et valeurs. Leurs preuves historiques sont réutilisées avec leurs frontières (acteurs/facettes/SSO/caches, initialisation/registre, queue, écoute/rendu). Aucun nouveau travail REA ni nouvelle décompilation identique. Pour reprendre : callback/source de sélection ou de queue nommé, profil/mode/destinataire établi, ou capture originale datée qui discrimine la règle. L’absence de cette entrée est documentée, sans prolonger indéfiniment la recherche.

## R3 — Producteurs, transport et consommateurs réels

Corpus exact conservé : **1 168 fichiers** `crates/*/src/**/*.rs`, `launcher/src-tauri/src/**/*.rs`, `.js`/`.html` au premier niveau de launcher/web. Empreintes et appartenance identiques au corpus antérieur. Trois recherches précises sont conservées : kill_events (quatre lignes, toutes dans core), catalogue natif/ExecutionBufferSize (zéro), appels de formateur/catalogue (huit, aucun client). Aucun résultat d’absence n’est déduit d’un répertoire supposé inexistant.

| Étape | Source actuelle inspectée | Résultat |
|---|---|---|
| Mort réelle de champion | `crates/core/src/damage.rs:129` | La transition vivant→zéro appelle reward_champion_death via combat_owner. Ce producteur n’est pas absent. |
| Événement d’élimination | `crates/core/src/champion_kills.rs:7` | sequence, tick, victim, killer optionnel, assists, first_blood, killer_gold ; rôles/rewards reconstruits en partie. Pas de noms/portraits embarqués dans Event. |
| Conservation | même fichier, lignes 50–51 | Séquence incrémentée et VecDeque limité aux **128 événements** les plus récents. Pas de flux de notification fiable ou d’historique complet démontré. |
| Export | `crates/core/src/lib.rs:784` | Clone ce journal dans Snapshot.kill_events ; équipe/identité des joueurs dans roster. Les déconnexions et acteurs retirés restent à gérer pour un affichage tardif. |
| Projection destinataire | `crates/core/src/vision.rs:137` | snapshot_for part de snapshot et filtre d’autres canaux ; ne transforme pas kill_events. snapshot_for_atomic conserve ce journal. Ce fait ne tranche pas l’audience native correcte. |
| Transport réel | `crates/server/src/session_host.rs:158`, `crates/core/src/session_wire.rs:21` | snapshot_for_atomic par route ; encodage du frame complet en JSON puis décodage typé de StateEnvelope. Le fallback de taille ne retire pas expressément kill_events ; il peut refuser un état encore trop grand. Aucun nouveau transport exécuté ici. |
| Réception client | `crates/client/src/main.rs:1331` | Snapshot admis et commis dans Match. Aucun consommateur client de kill_events trouvé ; transporter la donnée n’est pas afficher sa notification. |
| Objectifs | `crates/core/src/interactions.rs:29`, `altars.rs:103` | État de carte/autels, propriétaire et dernier captured_tick existent. Aucun flux d’annonces d’objectifs identifié ; un dernier état ne reconstruit pas toutes les transitions intermédiaires. |
| Acquis audio d’objectif | `crates/client/src/map_audio.rs` | Sons de relique/autel déjà branchés. Un cue audio ne vaut pas notification Text/ChatMessage affichée. |
| HUD de débogage | `crates/client/src/main.rs:1685` | Valeurs K/D/A/états courants. Une valeur changée ne constitue pas le journal d’une élimination. |
| Résultat final | `crates/client/src/match_results_ui.rs:24` | Texte depuis MatchResult ; visible lorsque résultat présent et vue terminale refermée. Aucune notification live d’objectif/kill n’en découle. |
| Ports de formatage | `audio_announcer_ordered_formatter.rs`, `audio_announcer_outer_callbacks.rs` | Fonctions et familles réellement implémentées dans core ; pas d’appel client identifié pour les notifications de la simulation. Fournisseurs et propriété vivants restent une intégration distincte. |
| Catalogue sonore | `audio_announcer_catalog.rs` | Planifie banques/actions/alternatives ; n’établit ni sélection de notification ni lecture normale. |
| Service de rejeu | `crates/client/src/native_replay_service.rs` | Construction/attachement à un runtime canonique/diagnostics/retrait présents. La branche autonome refuse l’enregistrement d’acteurs non connecté ; ce cycle de service ne consomme pas Snapshot.kill_events. Aucun sous-système entier n’est déclaré absent. |

Les données reçues ne possèdent pas encore un consommateur de notification avec identité d’événement, première réception/reprise, déduplication, trous, priorité et retrait. La confidentialité, l’ordre, les pertes et l’éviction au-delà de 128 ne sont donc pas qualifiés par la seule présence du VecDeque. Les objectifs requièrent leur propre source de transition ; pas de bannière générique fabriquée depuis une différence de PV ou de propriétaire.

## R4 — Vérifications, attendu et observé

**128 contrôles documentaires réussis** dans la seconde version du producteur. Identités, critères, cinq fichiers/modes, section vide, contrats écrits, corpus, routes de données, preuves antérieures et conservation contrôlés. La relecture indépendante possède son propre reçu et conditionne la clôture documentaire.

| Cas | Attendu pour la fonctionnalité | Observé et limite |
|---|---|---|
| Élimination ordinaire / first blood | Transition→événement admis→sortie propre au contexte, une fois. | Producteur et champ reçu établis par source ; pas de consommateur visuel actuel. Aucun nouveau kill/affichage exécuté. |
| Vilemaw/autel ordinaire | ChatMessage persistant selon source et contexte, sans Text inventé. | Sources et état d’objectif présents ; route de notification chat non identifiée. |
| Spectateur / autres modes | Choix du profil et des champs différents qualifié. | Cinq sources lues ; sélecteur/héritage non exécutés. Section vide FIRSTBLOOD conservée. |
| Doublon, perte, >128, arrivée tardive/reconnexion | Politique explicite, aucun ancien événement rejoué à tort, manque observable. | Pas de consommateur de journal ; ring borné seul et copies répétées ne prouvent aucune garantie de notification. |
| Mauvaise session/équipe, acteur absent, ressource invalide | Refus et conservation de l’audience, sans nom/icône de remplacement arbitraire. | Couches génériques de session/formatage existent ; pas de refus de notification live exécuté. |
| Concurrence, priorité, fin/expiration | Queue/catégorie/fade/style et retrait observés. | Paramètres natifs disponibles ; pas de queue graphique ou capture de notification qualifiée. |

Preuves réutilisées et précisément limitées :

- `docs/champion_kill_network_validation.json`, **4 octobre 2026, 08:17:46 UTC** : dix contrôles déclarés réussis sur trois clients UDP locaux, attaque/navigation/Exhaust, instantanés de récompenses/assists/respawn. Ancien SHA du serveur conservé comme métadonnée, pas re-haché ni exécuté. Cela ne vérifie pas une bannière ou le client graphique courant.
- `docs/champion_kill_live_validation.json`, **4 octobre 2026, 08:20:40 UTC** : capture réelle alors en 1280×800 avec **KDA 0/0/0**. Le reçu dit explicitement que ce n’est pas une capture d’élimination ; aucune notification ne s’en déduit. Anciennes captures non réinspectées dans ce lot.
- `docs/announcer_ordered_formatter_validation.json`, **10 octobre 2026, 06:28:56 UTC** : 52 tests isolés déclarés ; journal conservé et SHA actuel identique à celui du reçu. **Quatre sources épinglées ont changé** depuis : ordered_formatter, actor_wrapper, object_lookup et core/lib. Le résultat ancien ne qualifie pas leur état courant ni le HUD ; le détail des différences d’empreintes est conservé, sans relance répétitive.
- `announcer_registered_formatter_validation.json` et `announcer_audio_graph_progress.json` : preuves datées partielles, frontières de registres/stockage/providers/queue/son conservées. Pas de nouvelle qualification de ces modules ou du moteur audio.
- Audit `AUD-17.1-08-COUNTERS-01` réutilisé pour la séparation journal128 / KDA / texte de débogage / résultats ; il ne devient pas un audit de notification affichée.

**Échec conservé** : le premier lecteur regroupait uniquement les affectations et omettait OnTurretDie vide en FIRSTBLOOD ; il a refusé `[79,1354,42]` au lieu de `[80,1354,43]`. `verify_notifications.py` et `attempt-01-failure.json` sont gardés. `verify_notifications_v2.py` initialise les sections à partir des en-têtes et garde explicitement vide/absent ; le critère n’est pas abaissé et la source reste identique.

**Non exécutés maintenant :** compilation/tests Rust, jeu/serveur/réseau, saisie OS, REA/processus natif, rendu GPU ou capture visuelle, audio/écoute. Les recherches initiales de chemins supposés structures/units/rewards/session_frames/state_transport étaient infructueuses ; les vrais damage/altars/lib/session_wire ont été inspectés ensuite. Un chemin non trouvé n’est pas une preuve d’absence d’implémentation.

## R5 — Reprises précises et clôturables

**67 propositions `proposed_not_applied` hors registre** : huit résultats communs distincts et 59 cas nominativement reliés aux sources. Chaque fiche du reçu porte objectif, écart, critères de fin, entrée de reprise, dépendances et preuve attendue. Les IDs ne sont pas des tâches ajoutées au suivi.

| Résultat commun / ID | Critère de fin | Entrée nécessaire à la reprise |
| **NOTIF-MODE-SELECTION-01** — Qualifier la sélection des sources et variantes par mode/contexte. | Relier mode, profil, mutateur, spectateur et section/Set au vrai sélecteur natif ou à une adaptation locale déclarée ; refuser le contexte inconnu sans mélange silencieux. | Callback/registre natif ou capture originale discriminant mode/spectateur/mutateur ; cinq sources identifiées. Dépendances : Données de référence 4.20 ; préserver distinction On* / Set* / catégorie et absence vs vide. |
| **NOTIF-KILL-RECEIPT-01** — Consommer sans doublon les événements d’élimination reçus. | Créer un consommateur après admission du frame avec identité session/époque+séquence, première réception/reprise explicites, détection de trou/éviction128 et retrait à fin de session ; aucun événement déduit des seuls compteurs. | Contrat de reprise/fiabilité et audience qualifié ou local explicite ; producteur/transport réels disponibles. Dépendances : NOTIF-MODE-SELECTION-01 ; D13-SYS-13-3 pour audience ; préserver chemin d’état et champs existants. |
| **NOTIF-OBJECTIVE-EVENTS-01** — Produire les transitions d’objectifs destinées aux notifications. | Émettre un événement borné par transition réelle et objectif identifié, avec source/équipe/contexte nécessaires ; ne pas reconstruire arbitrairement l’historique depuis le dernier état visible. | Contrats natifs ou adaptations déclarées par objectif et actualisation des producteurs réels. Dépendances : NOTIF-MODE-SELECTION-01 ; boucles d’objectifs existantes à inspecter ; événements nominatifs séparés ci-dessous. |
| **NOTIF-LIVE-FORMAT-01** — Raccorder les familles de formatage existantes aux acteurs et templates reçus. | Réutiliser les ports et fournir acteurs/équipes/local/mode/skin/icônes/langue avec propriété/cache clairs ; préserver octets/erreurs au lieu de remplacer les tokens ou textes invalides. | Événement admis et fournisseurs vivants identifiés ; contrôles natifs hérités relus selon leurs versions. Dépendances : NOTIF-KILL-RECEIPT-01 ou NOTIF-OBJECTIVE-EVENTS-01 ; défauts de locale/source restent explicites. |
| **NOTIF-QUEUE-01** — Appliquer la durée, priorité et obsolescence d’une notification. | Qualifier et appliquer priorité/catégorie/MaxNumber/QuietPeriod/obsolescence/fades et durée sans son ; borner actifs/file et distinguer horloges/pause/reprise. | Évaluateur natif ou capture chronométrée discriminante ; catégories et sections disponibles. Dépendances : NOTIF-MODE-SELECTION-01 et événement admis ; ne pas appeler buffer2 une preuve de capacité totale native. |
| **NOTIF-VISUAL-STYLE-01** — Afficher une notification dans le vrai HUD avec ses ressources. | Raccorder Text/FontDescName/couleurs/icônes/gradient/position/ancre/fade au rendu actuel et retirer les nœuds ; ne pas inventer Text quand seule ChatMessage est écrite. | Sélection/formatage/queue qualifiés et sources de police/atlas ; référence de pixels ou limite déclarée. Dépendances : NOTIF-LIVE-FORMAT-01, NOTIF-QUEUE-01 ; UI déjà présente réutilisée après inspection. |
| **NOTIF-CHAT-ROUTE-01** — Acheminer ChatMessage et sa persistance sans inventer de bannière. | Raccorder au vrai canal/historique qualifié ; préserver les champs absents/vides et l’audience, donner une sortie correcte au cas sans Text ni son. | Contrat d’audience/persistance et chemin chat implémenté ; sources exactes par section. Dépendances : SYS-17.2-08, SYS-17.2-09 ; NOTIF-LIVE-FORMAT-01 ; sélections joueur/spectateur distinctes. |
| **NOTIF-END-TO-END-01** — Vérifier le parcours d’une notification avec clients et serveur actuels. | Exécuter séparément un kill réel et un objectif réel avec destinataires identifiés ; constater donnée admise→texte/icône/chat→expiration/reprise, puis garder le résultat nominatif pour chaque variante concernée. | Implémentations/contrats nominatifs prêts et binaires/assets identifiés ; référence originale comparable ou limites nommées. Dépendances : Fiches de cas et consommateurs applicables ; pas de nouvelle installation/déploiement implicite. |

Pour chaque cas source ci-dessous, le livrable est propre à cette section et aux contextes nommés : relier son vrai déclencheur/variante aux champs exacts, fournir les acteurs/données, choisir Text/ChatMessage/aucune sortie selon le contrat, puis vérifier nominal et contexte refusé, priorité/doublon/expiration et différence de mode. Entrée : source native identifiée plus callback/observation discriminant ce cas ; dépendances : sélection de mode, réception de kill ou producteur d’objectif, puis format/queue/style ou chat selon les champs. Une section Set ou vide n’est pas transformée en événement indépendant. Le reçu conserve ce contrat et ses preuves attendues séparément pour chacun des 59 IDs.

| Cas source | Modes où la section est recensée | ID de reprise |
| OnAce | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-ACE-01 |
| OnCaptureAltar | CLASSIC, FIRSTBLOOD | NOTIF-CASE-ON-CAPTURE-ALTAR-01 |
| OnCaptureAltar_Spectator | CLASSIC, FIRSTBLOOD | NOTIF-CASE-ON-CAPTURE-ALTAR-SPECTATOR-01 |
| OnCapturePointCaptured_A | ODIN | NOTIF-CASE-ON-CAPTURE-POINT-CAPTURED-A-01 |
| OnCapturePointCaptured_B | ODIN | NOTIF-CASE-ON-CAPTURE-POINT-CAPTURED-B-01 |
| OnCapturePointCaptured_C | ODIN | NOTIF-CASE-ON-CAPTURE-POINT-CAPTURED-C-01 |
| OnCapturePointCaptured_D | ODIN | NOTIF-CASE-ON-CAPTURE-POINT-CAPTURED-D-01 |
| OnCapturePointCaptured_E | ODIN | NOTIF-CASE-ON-CAPTURE-POINT-CAPTURED-E-01 |
| OnCapturePointNeutralized_A | ODIN | NOTIF-CASE-ON-CAPTURE-POINT-NEUTRALIZED-A-01 |
| OnCapturePointNeutralized_B | ODIN | NOTIF-CASE-ON-CAPTURE-POINT-NEUTRALIZED-B-01 |
| OnCapturePointNeutralized_C | ODIN | NOTIF-CASE-ON-CAPTURE-POINT-NEUTRALIZED-C-01 |
| OnCapturePointNeutralized_D | ODIN | NOTIF-CASE-ON-CAPTURE-POINT-NEUTRALIZED-D-01 |
| OnCapturePointNeutralized_E | ODIN | NOTIF-CASE-ON-CAPTURE-POINT-NEUTRALIZED-E-01 |
| OnChampionAscended | ASCENSION | NOTIF-CASE-ON-CHAMPION-ASCENDED-01 |
| OnChampionDoubleKill | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-CHAMPION-DOUBLE-KILL-01 |
| OnChampionKill | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-CHAMPION-KILL-01 |
| OnChampionPentaKill | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-CHAMPION-PENTA-KILL-01 |
| OnChampionQuadraKill | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-CHAMPION-QUADRA-KILL-01 |
| OnChampionTripleKill | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-CHAMPION-TRIPLE-KILL-01 |
| OnChampionUnrealKill | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-CHAMPION-UNREAL-KILL-01 |
| OnDampenerDie | ARAM, CLASSIC, FIRSTBLOOD | NOTIF-CASE-ON-DAMPENER-DIE-01 |
| OnDampenerRespawn | ARAM, CLASSIC, FIRSTBLOOD | NOTIF-CASE-ON-DAMPENER-RESPAWN-01 |
| OnDampenerRespawnSoon | ARAM, CLASSIC, FIRSTBLOOD | NOTIF-CASE-ON-DAMPENER-RESPAWN-SOON-01 |
| OnFirstBlood | ARAM, CLASSIC, FIRSTBLOOD | NOTIF-CASE-ON-FIRST-BLOOD-01 |
| OnKillDragon | CLASSIC, FIRSTBLOOD | NOTIF-CASE-ON-KILL-DRAGON-01 |
| OnKillDragon_Spectator | CLASSIC, FIRSTBLOOD | NOTIF-CASE-ON-KILL-DRAGON-SPECTATOR-01 |
| OnKillSpiderBoss | CLASSIC, FIRSTBLOOD | NOTIF-CASE-ON-KILL-SPIDER-BOSS-01 |
| OnKillSpiderBoss_Spectator | CLASSIC, FIRSTBLOOD | NOTIF-CASE-ON-KILL-SPIDER-BOSS-SPECTATOR-01 |
| OnKillWorm | CLASSIC, FIRSTBLOOD | NOTIF-CASE-ON-KILL-WORM-01 |
| OnKillWorm_Spectator | CLASSIC, FIRSTBLOOD | NOTIF-CASE-ON-KILL-WORM-SPECTATOR-01 |
| OnKilledUnitOnKillingSpree | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLED-UNIT-ON-KILLING-SPREE-01 |
| OnKilledUnitOnKillingSpreeDoubleKill | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLED-UNIT-ON-KILLING-SPREE-DOUBLE-KILL-01 |
| OnKilledUnitOnKillingSpreePentaKill | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLED-UNIT-ON-KILLING-SPREE-PENTA-KILL-01 |
| OnKilledUnitOnKillingSpreeQuadraKill | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLED-UNIT-ON-KILLING-SPREE-QUADRA-KILL-01 |
| OnKilledUnitOnKillingSpreeSet1 | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLED-UNIT-ON-KILLING-SPREE-SET1-01 |
| OnKilledUnitOnKillingSpreeSet2 | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLED-UNIT-ON-KILLING-SPREE-SET2-01 |
| OnKilledUnitOnKillingSpreeSet3 | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLED-UNIT-ON-KILLING-SPREE-SET3-01 |
| OnKilledUnitOnKillingSpreeSet4 | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLED-UNIT-ON-KILLING-SPREE-SET4-01 |
| OnKilledUnitOnKillingSpreeSet5 | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLED-UNIT-ON-KILLING-SPREE-SET5-01 |
| OnKilledUnitOnKillingSpreeSet6 | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLED-UNIT-ON-KILLING-SPREE-SET6-01 |
| OnKilledUnitOnKillingSpreeTripleKill | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLED-UNIT-ON-KILLING-SPREE-TRIPLE-KILL-01 |
| OnKilledUnitOnKillingSpreeUnrealKill | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLED-UNIT-ON-KILLING-SPREE-UNREAL-KILL-01 |
| OnKillingSpree | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLING-SPREE-01 |
| OnKillingSpreeSet1 | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLING-SPREE-SET1-01 |
| OnKillingSpreeSet2 | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLING-SPREE-SET2-01 |
| OnKillingSpreeSet3 | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLING-SPREE-SET3-01 |
| OnKillingSpreeSet4 | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLING-SPREE-SET4-01 |
| OnKillingSpreeSet5 | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLING-SPREE-SET5-01 |
| OnKillingSpreeSet6 | ARAM, ASCENSION, CLASSIC, FIRSTBLOOD, ODIN | NOTIF-CASE-ON-KILLING-SPREE-SET6-01 |
| OnMinionAscended | ASCENSION | NOTIF-CASE-ON-MINION-ASCENDED-01 |
| OnMinionKillVictoryThreshold1 | FIRSTBLOOD | NOTIF-CASE-ON-MINION-KILL-VICTORY-THRESHOLD1-01 |
| OnMinionKillVictoryThreshold2 | FIRSTBLOOD | NOTIF-CASE-ON-MINION-KILL-VICTORY-THRESHOLD2-01 |
| OnTurretDie | ARAM, CLASSIC, FIRSTBLOOD (vide) | NOTIF-CASE-ON-TURRET-DIE-01 |
| OnTurretKillVictoryThreshold1 | FIRSTBLOOD | NOTIF-CASE-ON-TURRET-KILL-VICTORY-THRESHOLD1-01 |
| OnTurretKillVictoryThreshold2 | FIRSTBLOOD | NOTIF-CASE-ON-TURRET-KILL-VICTORY-THRESHOLD2-01 |
| OnVictoryPointThreshold1 | ODIN | NOTIF-CASE-ON-VICTORY-POINT-THRESHOLD1-01 |
| OnVictoryPointThreshold2 | ODIN | NOTIF-CASE-ON-VICTORY-POINT-THRESHOLD2-01 |
| OnVictoryPointThreshold3 | ODIN | NOTIF-CASE-ON-VICTORY-POINT-THRESHOLD3-01 |
| OnVictoryPointThreshold4 | ODIN | NOTIF-CASE-ON-VICTORY-POINT-THRESHOLD4-01 |

Le détail complet est dans `proposed_corrections` et `native_case_sections` du reçu, par ID et occurrence de mode. Un cas vérifié ne clôture pas les autres. Les inconnues de déclenchement, héritage, langue, audience et interprétation de la queue restent des entrées de reprise nommées, sans recherche identique en boucle.

## R6 — Réutilisation et dimensions distinctes

- **SYS-17.2-05** reste le parent ; aucune case/identité changée.
- **SYS-17.2-08 / SYS-17.2-09** : permission/canal et historique/persistance de chat réutilisés pour ChatMessage/ChatMsgPersistent.
- **SYS-17.1-08** : compteurs/KDA et journal existants conservés, sans promotion en bannière.
- **SYS-17.2-06** : scoreboard public traité séparément ; résumé terminal conservé.

| Dimension | Résultat |
|---|---|
| Audit | Question délimitée couverte par les sept rubriques ; clôture après succès de la relecture indépendante. |
| Implémentation | Partielle : producteur d’éliminations/transport/états d’objectifs/helpers présents ; consommation et présentation live manquantes ou non qualifiées. |
| Vérification | Sources/données vérifiées ; preuves anciennes réutilisées avec dates/écarts ; aucune notification courante affichée vérifiée. |
| Acceptation humaine | Aucune acceptation de fonctionnalité revendiquée. |

Restent ouverts la tâche, l’inconnue d’origine et les 67 propositions. Le reçu principal garde `audit_scope_closed=false` ; le lecteur indépendant peut fermer seulement cet audit, sans modification du goal ni du plan. Le jeu et le goal global ne sont pas terminés ; aucun pourcentage de jeu n’est dérivé du nombre de sections, contrôles ou fiches.

## R7 — Preuves, conservation et prochaine reprise

Nouveaux fichiers uniquement dans `F:/OpenLeague-work/audit-units/AUD-17.2-05-NOTIFICATIONS-01/` : `audit-unit.json`, premier lecteur `verify_notifications.py`, son `attempt-01-failure.json`, seconde version `verify_notifications_v2.py`, `notifications-proof.json`, lecteur `verify_delivery.py`, `delivery-readback.json`. Rapport : ce fichier sous `F:/OpenLeague/docs/audit/units/`.

Reçu principal : SHA-256 **bd9eb10c3ddfc8574e5b617c3dc9c34ec70f743771172dd094ea742f3e9d40c5**, contrôles du **2026-10-30T21:56:23.850688+00:00**. Les dates des preuves héritées restent celles du 4/10 octobre. Les sources et versions, commandes anciennes, fragments, attendu/observé, refus de lecteur, propositions et conditions de reprise sont conservés ; aucun ancien travail remplacé.

Les **19 fichiers logiciels gelés**, **six documents de contexte/méthode**, **cinq registres normatifs** et l’état Git suivi sont identiques : HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, main, 76 fichiers déjà modifiés. Aucune base ouverte, aucun service Plan lancé, aucune installation/migration/reprise du jeu. Goal et critères de clôture inchangés.

Relecture nécessaire après un changement identifié : Python existant avec `-X utf8 -E -B` et `verify_delivery.py --check-only`, sans écriture de reçu. Ne pas relancer le producteur exclusif contre son reçu existant. Prochain lot : compléter l’audit **SYS-17.2-06** du scoreboard public en réutilisant le fragment SCORE-01 et les présents acquis, sans assimiler un résultat final à un tableau en partie.
