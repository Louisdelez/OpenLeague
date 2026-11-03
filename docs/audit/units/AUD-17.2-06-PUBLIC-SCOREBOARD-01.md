# AUD-17.2-06-PUBLIC-SCOREBOARD-01 — Scoreboard public, audit parent

Le jeu dispose déjà d’un roster local public avec identité/équipe/champion/KDA et d’un transport de snapshots. Aucun tableau public live ni commande d’ouverture O/Tab/X correspondante n’est identifié dans le code courant. Le lot complète l’ancien audit de frontière avec l’export réel des deux films originaux, une matrice par champ et la distinction entre données disponibles, autorisation native inconnue et consommateur manquant. Il ne réalise pas le scoreboard.

## R1 — Exigence complète et fragment antérieur

- **SYS-17.2-06**, « Afficher les statistiques publiques dans le scoreboard ».
- Exigence **OLF-8745397c-d845-510d-b47b-2c4f89dc9803**.
- Inconnue **OLU-275fd9bf-dedc-56fc-84e7-ed13167aac19**, conservée `open`.
- Registre `a_faire`, implémentation et acceptation `false` ; aucun critère normatif modifié.
- Référence LoL 4.20.0.315 PUBLIC Releases/4.20, EUW, en_GB, catalogue 4.20.1.

Le fragment **AUD-17.2-06-SCORE-01** avait clos seulement l’audit entrée/ressource/frontière du consommateur : il excluait les colonnes et permissions natives complètes ainsi que l’exécution/décompilation des films. Il n’est pas converti rétroactivement en audit parent complet. Ce complément examine ces clauses par les scripts originaux et les producteurs/permissions/valeurs manquantes, avec conditions de reprise précises pour les règles de l’hôte non retrouvées.

Le résultat documentaire couvre : sources et colonnes candidates, autorité/audience, transport et consommateurs réels, ouverture/maintien/fermeture et cycle des lignes, cas nominaux/refus/limites, corrections réutilisées ou proposées. Ni F3 ni les résultats terminaux ne servent de substitut. Les inconnues d’autorité native ne sont pas présentées comme résolues par un film client.

D17-SYS-17-2 contient neuf tâches. Le prérequis D13-SYS-13-3 « Confidentialité de l’état de jeu », encore `a_faire`, dépend de D13-SYS-13-1. Il doit gouverner les champs exposés et leurs destinataires, sans déduire « public dans LoL » d’un champ Rust nommé pub. Goal, critères de clôture et logiciel du suivi restent hors modification.

## R2 — Sources historiques et nouvel examen des colonnes

Les sources, bindings et lexiques du fragment sont réutilisés après contrôle d’identité ; aucune recherche identique de vocabulaire n’est relancée. Le registre de sources et les deux contenus RADS restent ceux déjà recensés, sans présumer de priorité de chargement.

| Ressource originale | Octets / SHA-256 | Export exécuté dans ce lot |
|---|---|---|
| `DATA/menu/Scoreboard.gfx` | 14 743 / `dee7a0f8f29de0ef63326bec2d65834a584ac93cc72ba1e49d261aff044e93f3` | Code 0, 24 fichiers de scripts. |
| `DATA/Menu_SC4/Scoreboard.gfx` | 20 167 / `b5d81535368cd674a1514925fc5e8765fd3c5cf2aad237e4608f05a9ff832dbd` | Code 0, 25 fichiers de scripts. |

Racine originale : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/`.

Java 21 et le JAR JPEXS déjà présents ont été réutilisés, avec les mêmes SHA que l’export du chat. Commandes exactes, Java/JAR/JVM identifiés, dates, sorties et **49 scripts** sont dans `scoreboard-extraction-receipt.json`. Aucune installation, aucun film original modifié, aucune exécution ActionScript ou du client natif. Ce n’est pas un inventaire instrumenté de toutes les dépendances transitives du décompilateur.

L’export de Menu_SC4 réussit avec les octets d’origine : l’écart de longueur décompressée **776 octets** recensé par SCORE-01 persiste. Le succès de JPEXS est une preuve d’acceptation par ce parseur, sans expliquer l’écart ou qualifier le lecteur natif, la sélection du film ou les pixels. SCORE-CFX-LENGTH-01 et SCORE-MOVIE-SELECTION-01 restent ouverts.

### Contrats des scripts effectivement lus

Les deux films utilisent le namespace Riot.ScoreboardOdin tout en possédant une branche MODE_CLASSIC ; le nom du namespace ne rend pas ce scoreboard exclusivement ODIN. Les méthodes testClassic/testOdin et les joueurs/objets de démonstration, appelés sous `_global.gfxPlayer`, ne constituent ni des valeurs de partie, ni des règles serveur, ni des tests exécutés.

| Clause du script | menu | Menu_SC4 | Limite |
|---|---|---|---|
| API exportée Main | 16 fonctions | 19 fonctions | Arguments fournis par l’hôte, pas permissions de transmission. |
| Fonctions supplémentaires | — | SetPlayerChampionName, SetColorBlindMode, UpdateDragonKills | Leur présence ne signifie pas activation dans Map10 ou consommation actuelle. |
| MAX_PLAYERS_ON_TEAM | 5 | 6 | Plafond de présentation, pas capacité du match ni taille d’équipe 3v3 déduite. |
| Icônes d’objets de ligne | 6 | 7 | La septième icône n’autorise pas un septième équipement en Map10. |
| setIcon | type/index/chemin | type/index/compte/chemin | En SC4, compte >0 écrit ; sinon chaîne vide. Comptes ≠ charges natives qualifiées. |
| Événement de mort | SetPlayerDeathTimer | idem | Clamp des secondes négatives à zéro, visibilité/texte/styles ; source/horloge/audience côté hôte non qualifiées. |
| Score de ligne | SetPlayerPoints → playerScore/txtScore | idem | Pas une preuve de sens universel CS, score personnel ou KDA. Tri décroissant uniquement dans la branche ODIN. |
| KDA | txtKDA initialisé « 0/0/0 » | idem | Initialisation graphique, sans producteur de valeur observé dans ces méthodes ; ne prouve pas un KDA réel à zéro. |
| AddStat / UpdateStat dans Main | corps vides | corps vides | Leurs noms et les classes StatsManager/StatsColumn ne prouvent pas une implémentation complète des colonnes côté hôte. |

Main init diffère par les chaînes/états et SC4 ajoute les icônes dragons 0..5 avec affichage saturé au-delà de 5. Les setters initiaux sont mis dans delayedInvokes puis raccordés aux fonctions globales à la frame suivante. C’est un contrat de film exporté, pas un ordre réseau ou une autorisation de rejouer des données de session actuelle. Les corps exacts des fonctions sont épinglés dans le reçu.

### Reprises natives précises, sans interprétation arbitraire

Le binaire original de 15 973 880 octets est vérifié SHA-256 **402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862**. Une recherche ASCII terminée NUL, délimitée aux noms nouvellement récupérés, donne ces points de départ :

| Nom | Offset de fichier |
|---|---|
| SetTeamScore | `0xcbedf0` |
| SetPlayerIcon | `0xcbed08` |
| SetPlayerLevel | `0xcbecdc` |
| SetPlayerPoints | `0xcbecec` |
| SetPlayerDeathTimer | `0xcbed48` |
| UpdateDragonKills | `0xcbeda0` |

Les littéraux exacts NUL txtKDA/txtScore ne sont pas trouvés par cette recherche. Aucun xref, appelant, branche de permission ou packet natif n’est qualifié à partir de ces seules positions. Nouvelle recherche à reprendre sur ces points/callers ou une trace contrôlée de champ/destinataire, pas par répétition des mêmes regex.

Les bindings originaux sont conservés : `[GameEvents] evtShowScoreBoard=[o]`, `[HUDEvents] evtHoldShowScoreBoard=[Tab]`, `[GameEvents] evtToggleScoreboardGoldDisplay=[x]`. Section, surcharge et sens runtime ne sont pas intervertis. Le libellé en_GB de la dernière touche dit « Toggle Scoreboard Items » ; ni le nom GoldDisplay ni ce libellé ne prouvent une colonne d’or ennemi autorisée. Les 106 clés lexicales du fragment couvrent plusieurs contextes : ce ne sont pas 106 colonnes implémentées. La valeur vide flash_scoreboard_alive est conservée.

## R3 — Consommateurs réels et matrice des champs

Le corpus de **1 168 fichiers** est identique par appartenance et SHA au corpus déjà audité. Le résultat négatif O/Tab/X et les occurrences scoreboard de fin de partie de SCORE-01 sont réutilisés, sans nouveau balayage inchangé. Une seule nouvelle recherche fondée sur les setters GFx exportés et noms de compteurs persistants n’identifie aucun branchement correspondant dans ce corpus.

- `vision::RosterEntry` contient id, champion, team et Score. Le producteur remplit explicitement kills/deaths/assists et les streaks ; le roster est conservé quand le corps ennemi est retiré par vision. C’est la politique locale actuelle, sans certification générale de la politique Riot historique.
- `Champion` porte niveau, santé, mana, or courant, six slots/comptes, respawn_at, rangs/cooldowns et invocateurs. Ces champs appartiennent au corps filtré ; ils ne deviennent pas automatiquement des colonnes publiques ou des valeurs conservées hors vision.
- Les snapshots/frames sont déjà transportés et commis au client ; les preuves exactes de session_wire/recipient/client_commit de SYS-17.2-05 sont réutilisées. Pas de nouveau test réseau.
- `session_host::apply` distingue Detached (route/delivery retirées, joueur conservé) et Retired (remove_player). Le vrai `crates/core/src/attacks.rs:103` termine par `self.players.remove(&id)`. Le roster est construit depuis Simulation.players ; départ définitif et déconnexion temporaire ne produisent pas le même cycle. Le résultat final, capturé une fois, est un état séparé.
- Le résumé de `match_results_ui.rs:24` lit MatchResult après la fin et n’est visible que si résultat présent et vue finale dismissed. F3 à `main.rs:1553` bascule le texte de débogage. Aucun consommateur live de scoreboard identifié.

Matrice complète des **13 groupes de champs candidats examinés** : les sources de colonnes inconnues restent indiquées, sans qualifier cette liste comme schéma natif exhaustif de tous les modes. Une extension du schéma exige son appelant/contrat exact ; aucune valeur plausible ajoutée pour compléter la grille.

| Groupe | Source native / source actuelle | Permission et résultat restant |
| **Identité/équipe/champion** | AddPlayer(team,name,champion,icons,current,muteable,spells) ; SetPlayerChampionName supplémentaire SC4. Actuel : RosterEntry id/champion/team ; absence de display name/account/skin dans ce DTO. | Roster actuel public selon politique locale ; sélection/audience native non qualifiée. Reste : Ligne stable par session/id ; noms/icônes et valeurs indisponibles distincts, pas de nom de compte inventé. |
| **Kills/deaths/assists** | txtKDA initialisé0/0/0 dans les deux films ; setter host courant de cette propriété non retrouvé par export seul. Actuel : RosterEntry.score produit par champion_kills ; legacy default masque absent vs zéro. | Disponible sans corps visible dans la projection actuelle ; ce fait ne prouve pas une politique Riot complète. Reste : Raccorder ligne K/D/A autorisée ; préserver indisponible pour ancien payload ; classifier toute absence. |
| **Niveau** | SetPlayerLevel→txtLevel ; paramètre fourni par hôte. Actuel : Champion.level uniquement dans corps conservé par vision ; pas dans RosterEntry. | Permission/dernière observation native non qualifiée ; visibilité ne vaut pas contrat scoreboard. Reste : Projection dédiée ou canal existant autorisé, age/source et absence sans zéro inventé. |
| **Délai de mort** | SetPlayerDeathTimer ; valeurs négatives ramenées0 et styles/visibilité mis à jour. Actuel : Champion.respawn_at dans corps ; événement mort ne fournit pas à lui seul un deadline public. | Audience ennemie/alliée et horloge natives non qualifiées. Reste : Deadline autorisé et horloge ; rendu/stale/respawn cohérents, aucune déduction depuis timer local seul. |
| **Objets et comptes** | setIcon menus6emplacements vs SC4 7et aIconCount ;0/valeur négative donne texte de compte vide dans SC4. Actuel : Champion.inventory6 et inventory_counts6 ; slots/charges/typeMap10 déjà audités ailleurs. | Information hors vision non fournie par roster ; cache/last-known de scoreboard non identifié. Reste : Une politique par audience/état ; slot graphique7 ne prouve pas une 7e place équipée enMap10 ni des charges natives. |
| **Icônes des sorts d’invocateur** | Deux mcImageSpell dans les deux films, importés dans init ; l’image est fournie par hôte. Actuel : Champion.summoners dans corps ; pas dans roster. | Publicité et durée de connaissance selon contexte natives non qualifiées. Reste : Projection autorisée, icône source/loadout corrects et absence ; pas de cooldown inventé à partir de l’icône. |
| **Disponibilité ultime** | Vocabulaire en_GB ultimate_ready/not_ready et icon7 ; export ne qualifie pas la source hôte. Actuel : Champion.ranks/cooldowns si corps visible, pas de champ public dédié. | Allié/ennemi/spectateur et rang0/contrôles non qualifiés. Reste : Contrat de disponibilité/audience précis ; ne pas exposer cooldown privé ni convertir absence en NO. |
| **Sbires tués/CS** | Vocabulaire icon6 et compteur source txtScore/SetPlayerPoints ; sens exact par mode à qualifier côtéhôte. Actuel : Aucun compteur persistant CS identifié par recherche nommée ; nombre d’unités vivantes et or ne sont pas CS. | Stat/attribution/visibilité natives non qualifiées. Reste : Réutiliser HUD-COUNTER-MinionKillsStat-01 puis qualifier projection scoreboard et style, séparément des récompenses. |
| **Totaux d’équipe** | SetTeamScore et champsFriendly/Enemy ; ODIN masque certains éléments. Actuel : Somme possible des Score du roster courant mais pas un total persistant d’équipe garanti après retrait. | Type de score par mode et règle native de départ non qualifiés. Reste : Source autoritative persistante ou agrégation prouvée ; équipes et départ/reprise sans perte de score silencieuse. |
| **Points personnels/bâtiments** | Score propre playerScore/SetPlayerPoints ; tri décroissant uniquementMODE_ODIN ; vocabulaire icon8/9 vient de contextes différents. Actuel : Pas de compteur personnel/bâtiments nommé identifié ; kill_streak est une autre donnée. | Modes applicables et producteurs non qualifiés ; aucun score universel inventé. Reste : Traiter chaque mode/stat selon source ; profil Classic/ODIN pas interchangeable ; égalités de tri explicites. |
| **Compteur/icônes dragons** | UpdateDragonKills et icônes0..5 avec saturation visuelle >5 dans SC4 seul. Actuel : Pas de compteur dragons identifié dans jeu actuel ; Map10 n’est pas une preuve d’objectif dragon. | Règle par carte/mode native non qualifiée. Reste : Qualifier uniquement modes applicables et source d’autorité ; ne pas activer depuis présence de l’asset. |
| **Mode X/or/objets** | evtToggleScoreboardGoldDisplay=[x], libellé traduit ToggleScoreboardItems ; aucune API explicite Gold dans les exports. Actuel : Champion.gold est or courant du corps ; MatchResult.gold_remaining est terminal, pas or total ou colonne live. | Permission et signification natives non qualifiées. Reste : Réutiliser SCORE-GOLD-MODE-01 ; sélecteur/valeur/audience avant tout affichage, pas exposition de gold ennemi par nom du binding. |
| **État dimmé/muet/joueur local** | SetPlayerDimmedStatus/MutedStatus, current marker ; visuels et événements de bouton source. Actuel : ID local et roster disponibles ; pas de champ scoreboard pubdim/mute ; permissions chat distinctes. | Ne pas confondre mute d’interface, déconnexion et audience native. Reste : État/mapping/interaction qualifiés sans changer simulation ; partie contrôle/clavier demeure séparée. |

L’état indisponible n’est pas un vrai zéro. `#[serde(default)]` sur le Score d’un ancien roster perd cette distinction après désérialisation ; cette limite est déjà établie dans SCORE-01 et reçoit ici une reprise précise. Les champs hors roster requièrent une projection ou un canal existant autorisé, éventuellement une dernière observation explicitement datée ; aucune copie du Champion entier dans une ligne déclarée publique.

Les totaux d’équipe ne sont pas qualifiés par la somme naïve du roster restant après retrait de joueurs. De même, les 128 événements d’élimination ne sont ni un compteur historique complet ni un modèle de scoreboard. Le nombre d’unités vivantes, l’or gagné et les kills de champion ne sont pas des sbires tués.

## R4 — Attendu, observé et contrôles exécutés

**229 contrôles documentaires réussis**, auxquels s’ajoutent la relecture indépendante. Export de sources réellement exécuté sur les deux films avec code 0 ; scripts/commandes/logs/outils et originaux identifiés. Aucun script ActionScript ni callback natif exécuté.

| Cas | Attendu pour la fonctionnalité | Observé et limite |
|---|---|---|
| Match en cours et ouverture O/Tab | Tableau live des champs autorisés, fermeture/relâchement corrects. | Bindings originaux disponibles ; aucun widget/input live actuel identifié. Pas d’ouverture graphique exécutée. |
| Ennemi caché | Identité/KDA et autres valeurs selon contrat, privé/absent/dernier connu distincts. | Roster local conservé, corps filtré ; règle native des autres colonnes non qualifiée, aucun tableau affiché. |
| Score manquant dans ancien message | Indisponible explicite. | serde default produit zéro ; pas de vérification fonctionnelle de disponibilité corrigée. |
| Départ/reprise/retrait | Identité/session et lignes selon contrat. | Branches Detached/Retired et données courantes établies par source ; aucune séquence UI courante exécutée. |
| Film/cas natif menu vs SC4 | API/ressources réellement choisies et interprétation qualifiée. | Deux exports réussis ; 16/19 APIs et 6/7 slots différents. Ni démo ni plafond de présentation ne qualifient le match. |
| Colonne invalide, ressource absente ou mauvaise session | Refus explicite, sans privé révélé ou valeur fabriquée. | Consommateur scoreboard absent ; refus des couches générales/ports ne devient pas refus de scoreboard exécuté. |
| Fin de partie | Résultat figé distinct du tableau en cours. | Résumé terminal présent ; ancien test nommé dans le code reste source de test, sans nouvelle exécution. |

Les preuves précédentes de compteurs, kills et résultats conservent leur date et portée ; pas de relance d’un build ou de tests inchangés pour faire apparaître un widget absent. Le fragment initial et ses deux lecteurs (dont première erreur de section HUDEvents) sont conservés.

**Non exécutés maintenant :** tests/compilation Rust, serveur/clients ou réseau, entrée OS, rendu GPU/capture de pixels, exécution originale, REA, lecture audio. Exécutés : Python de lecture/contrôle, Git de lecture, Java/JPEXS pour exporter les sources. L’export est une nouvelle analyse de données, pas une validation de parcours, de code ActionScript ou de publication native.

## R5 — Corrections existantes conservées et compléments précis

Ces huit reprises de SCORE-01 restent les mêmes IDs, sans duplication dans le suivi :

| ID existant | Résultat de reprise |
|---|---|
| SCORE-INPUT-01 | O/Tab, bascule/maintien, relâchement/focus et priorité UI, avec source native ou contrat local explicite. |
| SCORE-PUBLIC-ROWS-01 | Lignes session/id/champion/équipe/KDA autorisées et données manquantes traitées. |
| SCORE-ROSTER-LIFETIME-01 | Conservation/retrait des lignes lors de départ, reconnexion et fin, sans doublon. |
| SCORE-COLUMN-PUBLIC-01 | Une colonne hors roster par résultat : autorité/audience/absent/actuel/dernier connu et changement de vision. |
| SCORE-GOLD-MODE-01 | Sens exact du mode X, source de valeur et audience ; l’API récupérée ne tranche pas le binding. |
| SCORE-MOVIE-SELECTION-01 | Appelant/profil et ressource sélectionnée ; ne pas choisir SC4 par son nom. |
| SCORE-CFX-LENGTH-01 | Expliquer l’écart776 au niveau du bon lecteur ; export permissif réussi est une preuve nouvelle partielle. |
| SCORE-LOCALE-RENDER-01 | Titres/colonnes utiles en en_GB/fr_FR et pixels/focus/DPI/tri du cas après raccordement ; chaîne vide conservée. |

Réutilisations : HUD-COUNTER-MinionKillsStat-01 pour le producteur CS, SYS-13.3-02 pour la confidentialité des champs, SYS-13.3-07 pour les participants, SYS-17.1-08 pour compteurs, SYS-17.4-01 pour clavier. Les producteurs et inventaires existants doivent être inspectés avant création de mécanismes concurrents.

**14 compléments `proposed_not_applied`**, hors registres normatifs, ont chacun objectif unique, manque, critère de fin, dépendances et preuve attendue dans le reçu :

| ID / objectif | Critère de fin | Entrée nécessaire à la reprise |
| **SCORE-HOST-COLUMNS-01** — Relier les colonnes aux vrais producteurs et permissions natifs. | Suivre les xrefs hôte vers paramètres/propriétés/packet du profil sélectionné ; table autorité→champ→destinataire→affichage avec état absent/actuel/dernier connu. | Six littéraux hôte avec offsets exacts et films/AS2 identifiés ; capture contrôlée ou trace native discriminante. Dépendances : SCORE-MOVIE-SELECTION-01 ; n’inférer aucune permission d’un argument client ou d’un vocabulaire. |
| **SCORE-LEGACY-AVAILABILITY-01** — Préserver absence de Score versus vrai zéro dans les anciens messages. | Conserver compatibilité et rendre disponibilité explicite à l’admission/projection/widget ; absence ne s’affiche pas comme 0/0/0 observé. | Contrat versionné/local explicite des anciens payloads et propriétaire de l’état de disponibilité. Dépendances : SCORE-PUBLIC-ROWS-01 ; aucune migration de base nécessaire ou autorisée ici. |
| **SCORE-FIELD-LEVEL-01** — Qualifier la colonne Niveau. | Source d’autorité et audience de cette colonne établies ; disponibilité/last-known explicites, consommateur réel raccordé puis cas nominal et refus contrôlés pour son mode. | SetPlayerLevel→txtLevel ; paramètre fourni par hôte. Entrée nécessaire : appelant natif/trace de cette colonne ou adaptation locale explicitement nommée ; producteur actuel décrit dans la matrice. Dépendances : SCORE-COLUMN-PUBLIC-01 ; SCORE-HOST-COLUMNS-01 ; réutiliser les producteurs existants avant ajout. |
| **SCORE-FIELD-DEATH-TIMER-01** — Qualifier la colonne Délai de mort. | Source d’autorité et audience de cette colonne établies ; disponibilité/last-known explicites, consommateur réel raccordé puis cas nominal et refus contrôlés pour son mode. | SetPlayerDeathTimer ; valeurs négatives ramenées0 et styles/visibilité mis à jour. Entrée nécessaire : appelant natif/trace de cette colonne ou adaptation locale explicitement nommée ; producteur actuel décrit dans la matrice. Dépendances : SCORE-COLUMN-PUBLIC-01 ; SCORE-HOST-COLUMNS-01 ; réutiliser les producteurs existants avant ajout. |
| **SCORE-FIELD-ITEMS-01** — Qualifier la colonne Objets et comptes. | Source d’autorité et audience de cette colonne établies ; disponibilité/last-known explicites, consommateur réel raccordé puis cas nominal et refus contrôlés pour son mode. | setIcon menus6emplacements vs SC4 7et aIconCount ;0/valeur négative donne texte de compte vide dans SC4. Entrée nécessaire : appelant natif/trace de cette colonne ou adaptation locale explicitement nommée ; producteur actuel décrit dans la matrice. Dépendances : SCORE-COLUMN-PUBLIC-01 ; SCORE-HOST-COLUMNS-01 ; réutiliser les producteurs existants avant ajout. |
| **SCORE-FIELD-SUMMONERS-01** — Qualifier la colonne Icônes des sorts d’invocateur. | Source d’autorité et audience de cette colonne établies ; disponibilité/last-known explicites, consommateur réel raccordé puis cas nominal et refus contrôlés pour son mode. | Deux mcImageSpell dans les deux films, importés dans init ; l’image est fournie par hôte. Entrée nécessaire : appelant natif/trace de cette colonne ou adaptation locale explicitement nommée ; producteur actuel décrit dans la matrice. Dépendances : SCORE-COLUMN-PUBLIC-01 ; SCORE-HOST-COLUMNS-01 ; réutiliser les producteurs existants avant ajout. |
| **SCORE-FIELD-ULTIMATE-01** — Qualifier la colonne Disponibilité ultime. | Source d’autorité et audience de cette colonne établies ; disponibilité/last-known explicites, consommateur réel raccordé puis cas nominal et refus contrôlés pour son mode. | Vocabulaire en_GB ultimate_ready/not_ready et icon7 ; export ne qualifie pas la source hôte. Entrée nécessaire : appelant natif/trace de cette colonne ou adaptation locale explicitement nommée ; producteur actuel décrit dans la matrice. Dépendances : SCORE-COLUMN-PUBLIC-01 ; SCORE-HOST-COLUMNS-01 ; réutiliser les producteurs existants avant ajout. |
| **SCORE-FIELD-MINIONS-01** — Qualifier la colonne Sbires tués/CS. | Source d’autorité et audience de cette colonne établies ; disponibilité/last-known explicites, consommateur réel raccordé puis cas nominal et refus contrôlés pour son mode. | Vocabulaire icon6 et compteur source txtScore/SetPlayerPoints ; sens exact par mode à qualifier côtéhôte. Entrée nécessaire : appelant natif/trace de cette colonne ou adaptation locale explicitement nommée ; producteur actuel décrit dans la matrice. Dépendances : SCORE-COLUMN-PUBLIC-01 ; SCORE-HOST-COLUMNS-01 ; réutiliser les producteurs existants avant ajout. |
| **SCORE-FIELD-TEAM-TOTALS-01** — Qualifier la colonne Totaux d’équipe. | Source d’autorité et audience de cette colonne établies ; disponibilité/last-known explicites, consommateur réel raccordé puis cas nominal et refus contrôlés pour son mode. | SetTeamScore et champsFriendly/Enemy ; ODIN masque certains éléments. Entrée nécessaire : appelant natif/trace de cette colonne ou adaptation locale explicitement nommée ; producteur actuel décrit dans la matrice. Dépendances : SCORE-COLUMN-PUBLIC-01 ; SCORE-HOST-COLUMNS-01 ; réutiliser les producteurs existants avant ajout. |
| **SCORE-FIELD-MODE-SCORE-01** — Qualifier la colonne Points personnels/bâtiments. | Source d’autorité et audience de cette colonne établies ; disponibilité/last-known explicites, consommateur réel raccordé puis cas nominal et refus contrôlés pour son mode. | Score propre playerScore/SetPlayerPoints ; tri décroissant uniquementMODE_ODIN ; vocabulaire icon8/9 vient de contextes différents. Entrée nécessaire : appelant natif/trace de cette colonne ou adaptation locale explicitement nommée ; producteur actuel décrit dans la matrice. Dépendances : SCORE-COLUMN-PUBLIC-01 ; SCORE-HOST-COLUMNS-01 ; réutiliser les producteurs existants avant ajout. |
| **SCORE-FIELD-DRAGONS-01** — Qualifier la colonne Compteur/icônes dragons. | Source d’autorité et audience de cette colonne établies ; disponibilité/last-known explicites, consommateur réel raccordé puis cas nominal et refus contrôlés pour son mode. | UpdateDragonKills et icônes0..5 avec saturation visuelle >5 dans SC4 seul. Entrée nécessaire : appelant natif/trace de cette colonne ou adaptation locale explicitement nommée ; producteur actuel décrit dans la matrice. Dépendances : SCORE-COLUMN-PUBLIC-01 ; SCORE-HOST-COLUMNS-01 ; réutiliser les producteurs existants avant ajout. |
| **SCORE-FIELD-STATUS-01** — Qualifier la colonne État dimmé/muet/joueur local. | Source d’autorité et audience de cette colonne établies ; disponibilité/last-known explicites, consommateur réel raccordé puis cas nominal et refus contrôlés pour son mode. | SetPlayerDimmedStatus/MutedStatus, current marker ; visuels et événements de bouton source. Entrée nécessaire : appelant natif/trace de cette colonne ou adaptation locale explicitement nommée ; producteur actuel décrit dans la matrice. Dépendances : SCORE-COLUMN-PUBLIC-01 ; SCORE-HOST-COLUMNS-01 ; réutiliser les producteurs existants avant ajout. |
| **SCORE-LIVE-RENDER-01** — Afficher le tableau live distinct du HUDdebug et du résultat final. | Un tableau réel consomme seulement les lignes/champs autorisés avec mode/layout/ordre, style et retrait corrects ; focus/maintien/bascule ne déclenchent pas combat. | Contrat/profil sélectionné et données publiques prêts ; sources graphiques/lexicales identifiées. Dépendances : SCORE-INPUT-01, SCORE-PUBLIC-ROWS-01, SCORE-LOCALE-RENDER-01 ; limites par colonne restent ouvertes. |
| **SCORE-END-TO-END-01** — Vérifier le scoreboard avec destinataires réels et changements de visibilité. | Serveur/au moins deux clients identifiés : matchen cours, KDA misàjour, ennemi caché sans champ privé, départ/reprise et ouverture/fermeture réels observés ; résultat final séparé. | Consommateurs live et permissions des champs du cas implémentés ; binaires/assets/reference identifiés. Dépendances : SCORE-LIVE-RENDER-01 ; SCORE-ROSTER-LIFETIME-01 ; cas par colonne concernée. |

Chaque champ garde son résultat nominatif ; un tableau KDA minimal ne termine pas tous les champs. L’entrée historique manquante est précise : appelant natif des setters/propriétés ou capture discriminante d’une colonne et d’un destinataire. Sans elle, conserver la règle native inconnue et nommer toute adaptation locale ; ne pas répéter l’export ou les mêmes empreintes à l’identique.

## R6 — Décision d’audit, implémentation, vérification, acceptation

| Dimension | Résultat borné |
|---|---|
| Audit parent | L’ancien fragment est complété par scripts, colonnes/permissions, cycle et reprises. Les sept rubriques peuvent être clôturées après relecture indépendante, avec les inconnues historiques documentées. |
| Implémentation | Partielle : roster/projection/transport et résumé final présents ; tableau live et permissions complètes des autres champs manquants ou non qualifiés. |
| Vérification | Export et contrôles de sources/données réussis ; aucune ouverture/colonne du scoreboard courant vérifiée visuellement. |
| Acceptation humaine | Aucune acceptation de fonctionnalité revendiquée. |

Restent ouverts SYS-17.2-06, son inconnue, les huit reprises héritées et les quatorze compléments. Le reçu principal garde `audit_scope_closed=false` ; le lecteur indépendant peut clôturer cet audit documentaire parent, pas une fonctionnalité ou le jeu. Aucun achèvement global ou pourcentage déduit des champs, fichiers ou tests. Goal actif/incomplet, texte/critères/statuts inchangés.

## R7 — Livrables, preuves et conservation

Nouveaux fichiers uniquement : sous `F:/OpenLeague-work/audit-units/AUD-17.2-06-PUBLIC-SCOREBOARD-01/`, fiche `audit-unit.json`, `extract_scoreboard.py`, deux logs ffdec, 49 scripts sous extracted, `scoreboard-extraction-receipt.json`, `verify_scoreboard.py`, `scoreboard-proof.json`, `verify_delivery.py`, `delivery-readback.json`. Rapport : ce fichier sous `F:/OpenLeague/docs/audit/units/`. Tous les exports sont listés et identifiés par le reçu ; aucun original recopié pour le corriger.

Reçu principal SHA-256 **4503b305619331e47a5eabb3f100e8eb58c87e4b3e0b709602d0789b28b0cb1e**, contrôles du **2026-10-30T22:10:22.293617+00:00**. Reçu d’export SHA-256 **976837ef425faac0f19e9f1327c0bfc5ee24b062f1820b844a663264df9d1f19**. Le lecteur indépendant identifie aussi le retrait réel de Simulation.players dans attacks.rs. Aucun reçu ancien remplacé ou test ancien redaté.

Conservation vérifiée : **19 fichiers logiciels gelés**, **six documents de contexte/méthode**, **cinq registres normatifs**, Git HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, main, 76 fichiers suivis déjà modifiés. Aucune base ouverte, aucun serveur Plan ou jeu démarré, aucune installation/migration, aucune modification du goal ou des critères de clôture.

Relecture nécessaire après changement identifié : Python existant `-X utf8 -E -B`, `verify_delivery.py --check-only` sans écriture. Export/lecteur de production utilisent des créations exclusives et ne doivent pas être relancés sur les reçus existants. Prochain lot : terminer l’audit parent **SYS-17.2-07** des infobulles, en réutilisant TOOLTIP-01 et les limites de champs/locale établies, sans promouvoir le fragment en fonctionnalité complète.
