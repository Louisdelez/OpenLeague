# SYS-18.1-01 — inventaires patcher et AIR distincts

2026-11-01T16:14:38.382931+00:00

Audit des définitions de sources terminé avec constats, sous réserve de la relecture distincte. Reconstruction du launcher partielle ; aucune fonctionnalité complète, frame native ou acceptation humaine revendiquée. Statut normatif toujours a_faire.

Inventorier les écrans du patcher séparément des écrans du client AIR
Le résultat « Inventorier les écrans du patcher séparément des écrans du client AIR » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.

## Référence et périmètre
Six pages P18..P23 n’ont pas de copie individuelle sous review ; leurs octets et ancrages sont présents dans les conteneurs conservés. Absence de copie de commodité distinguée d’un asset historique manquant. Aucune récupération/export nécessaire ici.
Jeu4.20.0.315, patcher0.4.0.122/release0.0.0.11, AIR4.20.14_11_18_18_52/release0.0.1.119 et catalogue4.20.1 restent distincts. Aucun fuseau ou déploiement EUW inventé.
L’ancien document de builds garde la limite du candidat récupéré0.0.1.76 divergent. Le contrat AIR ultérieur et le fichier actuel927octets/MD5332b2a5cb3619cab02c8682a847e0ee9 identifient le membre exact source0.0.1.67 admis au manifeste119. Ses valeurs1.0.0/AIR3.7 ne sont toujours ni le build PvP.net ni un runtime exécuté. Aucun ancien reçu modifié.
25entrées patcher comprennent shell, états, modales, dialogues et fallback ;51groupes AIR comprennent états et vues conditionnelles, internes ou distantes. Aucun total76écrans publics ou reconstruits déduit.
Les lecteurs Python sont des consommateurs documentaires de l’inventaire. Le frontend Tauri courant est une préparation locale française avec six commandes ; aucun lien d’équivalence historique complet n’est établi. La query nommée sans résultat reste bornée à ce code, pas une preuve compilée globale.

Les racines historiques E restent dans les documents d’origine. Le rebinding explicite de cet audit lit le projet/récupérations sur F et le client natif sur D ; aucun document source ni chemin d’application modifié.

## Inventaire lié aux sources et consommateurs
Le consommateur documentaire de chaque ligne est un lecteur de contrat Python. Le frontend Tauri est une préparation locale distincte, pas la reconstruction validée de la ligne.
- PATCHER::P01 — Fenêtre principale et contrôles de fenêtre ; shell ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/0.
- PATCHER::P02 — Présentation du patcher rénové au premier lancement ; popup ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/1.
- PATCHER::P03 — Retrait facultatif de Pando Media Booster ; popup ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/2.
- PATCHER::P04 — Mise à jour et progression ; main_state ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/3.
- PATCHER::P05 — À jour, lancement disponible et disponibilité du service ; main_state ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/4.
- PATCHER::P06 — Options et diagnostic ; modal ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/5.
- PATCHER::P07 — Sélection de région et langue ; modal ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/6.
- PATCHER::P08 — Accord EULA ; modal ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/7.
- PATCHER::P09 — Accord de type NDA / disclaimer ; modal ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/8.
- PATCHER::P10 — Erreur et envoi de journaux ; modal ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/9.
- PATCHER::P11 — À propos / mentions de copyright ; modal ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/10.
- PATCHER::P12 — Enregistrer les journaux et résultat ; native_dialog_and_status ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/11.
- PATCHER::P13 — Confirmation de réparation complète ; native_dialog ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/12.
- PATCHER::P14 — Corruption détectée / proposition de réparation douce ; native_dialog ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/13.
- PATCHER::P15 — Confirmation de fermeture avec PvP.net actif ; native_dialog ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/14.
- PATCHER::P16 — Incidents, statut et bandeau de service ; main_state ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/15.
- PATCHER::P17 — Accueil éditorial ; routed_view ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/16.
- PATCHER::P18 — Article d’actualité 1 ; routed_view ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/17.
- PATCHER::P19 — Article d’actualité 2 ; routed_view ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/18.
- PATCHER::P20 — Article d’actualité 3 ; routed_view ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/19.
- PATCHER::P21 — Article de notes de patch de l’accueil ; routed_view ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/20.
- PATCHER::P22 — Vue dédiée des notes de patch ; routed_view ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/21.
- PATCHER::P23 — Rotation et fiches des champions gratuits ; routed_view ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/22.
- PATCHER::P24 — Erreur de chargement JavaScript ; fallback_page ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/23.
- PATCHER::P25 — Avertissements d’installation et de désinstallation ; resource_defined_native_warning ; tools/project-plan/patcher_reference.py::verify ; source F:\OpenLeague\docs\reference_patcher_routes_4_20.json/screens/24.
- AIR::bootstrap — Démarrage, fenêtre et erreurs fatales ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/0.
- AIR::chrome — Cadre, barre de navigation et commandes de fenêtre ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/1.
- AIR::login — Connexion, identifiants, préférences de musique et animation ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/2.
- AIR::login-status — Attente de connexion, file, erreurs et bannissement ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/3.
- AIR::summoner-name — Création ou changement du nom d’invocateur ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/4.
- AIR::summoner-icon — Choix de l’icône d’invocateur ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/5.
- AIR::questionnaire — Questionnaire de niveau initial ; feature_gated ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/6.
- AIR::tutorial — Proposition de tutoriel et fin de tutoriel ; feature_gated ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/7.
- AIR::partner-block — Blocage bêta partenaire et avertissement de durée ; region_or_partner_gated ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/8.
- AIR::home — Accueil, actualités, parties vedettes et aide débutant ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/9.
- AIR::choose-game — Choix PvP, coop, personnalisé, tutoriel et options de file ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/10.
- AIR::arranged-team — Salon de groupe normal/classé et invitations ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/11.
- AIR::queue — File de matchmaking, partie trouvée et confirmation ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/12.
- AIR::queue-refusal — Dodge, refus classé, LeaverBuster et attente imposée ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/13.
- AIR::custom-browser — Liste et recherche des parties personnalisées ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/14.
- AIR::custom-create — Création de partie personnalisée ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/15.
- AIR::custom-lobby — Salon personnalisé, équipes, bots et spectateurs ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/16.
- AIR::tournament — Saisie de code tournoi ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/17.
- AIR::team-builder — Team Builder : capitaine, invité et joueur solo ; feature_gated ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/18.
- AIR::champ-select — Sélection, bans, ordre des joueurs, carte et verrouillage ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/19.
- AIR::champ-loadout — Skins, sorts, runes, maîtrises, échange et reroll ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/20.
- AIR::spectate-select — Sélection et délai spectateur ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/21.
- AIR::game-reconnect — Partie en cours, lancement et reconnexion ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/22.
- AIR::end-game — Résultats, statistiques, graphes, score et discussion ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/23.
- AIR::profile — Profil, recherche d’invocateur et aperçu ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/24.
- AIR::profile-stats — Statistiques, classements et statistiques de champions ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/25.
- AIR::match-history — Historique ancien/nouveau, détails, chronologie et graphes ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/26.
- AIR::champ-inventory — Collection et filtre des champions ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/27.
- AIR::champ-detail — Fiche champion : aperçu, capacités, histoire, conseils, achat ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/28.
- AIR::runes — Livre, pages, statistiques et combineur de runes ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/29.
- AIR::masteries — Livre, pages et arbre de maîtrises ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/30.
- AIR::summoner-spells — Catalogue et détail des sorts d’invocateur ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/31.
- AIR::item-sets — Objets, recettes, ensembles, import et associations ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/32.
- AIR::leagues — Ligues, promotions, séries et statistiques classées ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/33.
- AIR::ranked-teams — Équipes classées : création, gestion, profil et historique ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/34.
- AIR::store — Boutique embarquée, navigateur et page indisponible ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/35.
- AIR::friends — Amis, ignorés, récents, notes et notifications ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/36.
- AIR::chat — Conversations privées, salons, groupe et barre ancrée ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/37.
- AIR::invites — Notifications et acceptation des invitations ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/38.
- AIR::reporting — Signalement de joueur et honneur ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/39.
- AIR::gifting — Cadeau de fin de partie : liste, détail, confirmation et erreur ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/40.
- AIR::celebration — Promotions et remise d’icônes ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/41.
- AIR::season-rewards — Récompenses de saison et progression ; feature_gated ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/42.
- AIR::education-feedback — Aide contextuelle, astuces et sondage ; feature_gated ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/43.
- AIR::preferences — Options audio, discussion, notifications et transitions ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/44.
- AIR::support — Aide et soumission de journaux ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/45.
- AIR::transfer — Transfert de compte et états de résultat ; service_dependent ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/46.
- AIR::alerts — Messages, confirmation, erreur et attente ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/47.
- AIR::shutdown — Arrêt programmé, désactivation du jeu et fermeture ; source_defined ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/48.
- AIR::hidden-lore-watch — Anciens points d’entrée histoire et replays ; internal_or_hidden ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/49.
- AIR::developer — Journal et panneau développeur ; internal_or_hidden ; tools/project-plan/air_reference.py::verify ; source F:\OpenLeague\docs\reference_air_routes_4_20.json/screens/50.

## Contrôles, attendu et observé
Exécutés : lecture pure des7conteneurs conservés/457membres, identités des18sources patcher,186originaux AIR et9139exports, appartenance sur disque,198ancrages, liens par groupe et fenêtres des vrais consommateurs ; query nommée de route conservée (code1=aucun hit, stderr vide). Aucun ancien programme de vérification relancé.
L’ancien reçu déclare deux inventaires statiques réussis, sans reçu autonome de code processus fourni : aucun code0 ancien n’est inventé. Le premier essai de préparation actuel a manqué le nom pathlib dans son helper ; corrigé avant la lecture réussie (session72311, sortie terminale code0). Il n’a ni produit de fichier F ni exécuté le jeu.

### SEPARATE-INVENTORIES
Attendu : Inventaires distincts et ancrés aux octets/sources.
Observé : 25patcher,51groupes AIR ;457membres,186originaux,9139exports et198ancrages conformes aux identités déclarées.
Portée : Static metadata/file identity only.

### NO-PUBLIC-PROMOTION
Attendu : Garder les disponibilités et exclusions.
Observé : 28groupes service-dependent,5feature-gated,1region/partner,2internal/hidden ;15source-defined ne signifie pas public observé. Cinq candidats exclus,2dépendances absentes et3erreurs de décompilation restent consignés.
Portée : No original services or AIR execution.

### WRONG-SOURCE-REFUSALS
Attendu : Lecteurs d’inventaire rejettent mauvais contrat, source/ancre divergente et observation promue.
Observé : Gardes exactes relues dans patcher_reference.verify et air_reference.verify. Aucun appel de ces anciens vérificateurs ou test de mutation rejoué ici.
Portée : Source comparison, not newly executed product rejection.

### CURRENT-ROUTE-BOUNDARY
Attendu : Identifier le vrai consommateur sans transformer un asset commun en écran natif.
Observé : Un index HTML, frontendDist../web,JS et six commandes Tauri relus ; query nommée routes/fenêtres code1 sans hits ni stderr. Préparation locale différente, pas de fidélité AIR/patcher revendiquée.
Portée : Bounded source/metadata, no GUI.

Non exécutés : logiciel natif, AIR/AS/PE, launcher, Rust, rendu/GPU/OS, services/auth/transaction/réseau, nouvelle extraction/export ou décompilation, anciens tests/lecteurs, REA.

## Manques et conditions de reprise

### HISTORICAL-AVAILABILITY
Disponibilité publique EUW datée, contenus distants, activation de fonctionnalités/partenaires et choix de profil ne découlent pas des classes présentes.
Reprise : Configuration/services ou capture historique datée liée au même build/région/locale pour le groupe précis ; garder l’état source-defined/conditionnel en attendant, sans recherche générale répétée.

### SOURCE-BOUNDARIES
Deux entrées de dépendances déclarées absentes, trois exports de framework/styles avec erreur, vendor/asset bundles non récupérés dans l’inventaire patcher et exclusion des candidats hors manifeste restent des limites.
Reprise : Reprendre uniquement le membre original ou rôle/provider nommé dans les contrats ; les fichiers source conservés ne prouvent pas un démarrage complet ni tous les graphismes/timelines.

### SCREEN-RECONSTRUCTION
Les définitions d’écrans ne sont pas toutes reproduites dans la préparation locale actuelle ; navigation, dimensions, graphismes/typos, médias et services restent à leur portée propre.
Reprise : Réutiliser les tâches18.1.02..08 et les lots D18.2..6 existants au niveau du vrai écran. Aucune nouvelle tâche générale ni critère réécrit.

### NATIVE-VISUAL-AND-HUMAN-ACCEPTANCE
Aucune nouvelle observation native/AIR, capture à dimensions comparables, auth, transaction, action réseau ou acceptation humaine.
Reprise : Artefacts/builds/assets/région/locale et cas autorisé précisément fixé ; conserver SYS-18.1-08 et les critères originaux, sans transformer cette lecture en preuve de rendu.

## Travail existant réutilisé
- SYS-18.1-02 — Extraire les images du patcher depuis les fichiers fournis ; état/critère conservés. Critère : Le résultat « Extraire les images du patcher depuis les fichiers fournis » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.
- SYS-18.1-03 — Extraire images et atlas des SWF du client AIR ; état/critère conservés. Critère : Le résultat « Extraire images et atlas des SWF du client AIR » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.
- SYS-18.1-04 — Extraire et identifier les polices historiques ; état/critère conservés. Critère : Le résultat « Extraire et identifier les polices historiques » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.
- SYS-18.1-05 — Extraire sons et transitions de l’interface AIR ; état/critère conservés. Critère : Le résultat « Extraire sons et transitions de l’interface AIR » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.
- SYS-18.1-06 — Mesurer dimensions et ancrages des écrans de référence ; état/critère conservés. Critère : Le résultat « Mesurer dimensions et ancrages des écrans de référence » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.
- SYS-18.1-07 — Créer les routes Tauri correspondant aux écrans historiques confirmés ; état/critère conservés. Critère : Le résultat « Créer les routes Tauri correspondant aux écrans historiques confirmés » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.
- SYS-18.1-08 — Comparer chaque écran reconstruit à la référence de même taille ; état/critère conservés. Critère : Le résultat « Comparer chaque écran reconstruit à la référence de même taille » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.

L’inventaire séparé existe et ses sources sont confirmées. Les travaux de reconstruction, médias, dimensions, navigation et captures appartiennent aux tâches existantes ; les inconnues natives restent qualifiées, sans nouvelle tâche générale ni critère changé.

## Sept rubriques et décision
- 1 : Tâche exacte et prérequis D18 indépendants ; inventaire séparé, pas reconstruction de tout le launcher.
- 2 : Builds, manifestes et octets sources ; disponibilités et exclusions héritées explicites.
- 3 : Lecteurs documentaires et frontend Tauri réels distingués ;76définitions liées individuellement.
- 4 : Identités et ancrages actuels, ancien reçu réutilisé ; refus en source et contrôles non exécutés nommés.
- 5 : Inconnues publiques/distantes, dépendances et graphismes restent des constats avec entrée de reprise.
- 6 : Tâches de réalisation existantes et critères exacts réutilisés ; aucun doublon ou nouvelle correction nécessaire.
- 7 : Preuve datée, matrice et relecture distincte ; statuts/goal/app/base conservés.

L’objectif d’inventaire est confronté à ses sources, ses lecteurs, ses frontières et au consommateur courant. Les disponibilités inconnues et la reconstruction non réalisée restent des conclusions d’audit avec reprises ; la clôture ne certifie pas le fonctionnement ou l’exhaustivité des écrans publics de2014.
La clôture de cet audit d’inventaire ne ferme ni D18, ni les manques HUD restants, ni SYS-01.2-02. Aucun pourcentage de jeu terminé ne se déduit de ces comptes.
Fichiers ajoutés uniquement : ce rapport et F:\OpenLeague-work\audit-units\AUD-18.1-01-PATCHER-AIR-SCREEN-INVENTORY-01 (entrées, observations, snapshot, scripts, preuve et reçus). Goal, critères, code produit, UI/suivi, registres et bases conservés.
Prochain lot : AUD-18.1-02-PATCHER-MEDIA-PROVENANCE-01 — Qualifier les images du patcher déjà récupérées, leurs identités/décodages et vrais consommateurs ; distinguer extraction en mémoire, fichiers conservés, médias installés et rendu.

Premier producteur documentaire code1 conservé : supposait une copie review pour chaque page. V2 utilise les octets originaux des conteneurs déjà vérifiés et distingue explicitement les six copies de commodité absentes. Ce n’est pas un échec du jeu ni une restauration d’assets.