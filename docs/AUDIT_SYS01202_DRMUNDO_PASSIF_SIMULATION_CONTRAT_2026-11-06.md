# V1466 — Dr. Mundo : contrat connu de Adrenaline Rush

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-DRMUNDO-PASSIF-SIMULATION-CONTRAT-01, tâche CH-DrMundo-PASSIF-SIMULATION-CONTRAT, exigence OLF-d5950640-3cb8-5ca8-aaf8-5fe84bc778be, parent SYS-01.2-02. Audit borné de treize branches connues et des consommateurs sélectionnés. Tâche complète, fonctionnalité et goal restent ouverts ; SOURCE a_qualifier, phases, lots, dépendances et inconnues conservés.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue 4.20.1 distinct. Aucune mécanique récente substituée.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/mundo-passive-healing-links-v542.json : 393747 octets, SHA256 f0ecfdacc8f27f8fb15207f9fc58bc4b04dc69992dd18abcee6b5dcac6b529e4. Rapport FIDELITY_DRMUNDO_PASSIVE_HEALING_LINKS_V542.md : SHA256 677551a20b1f2d943441bc4d70aaf7f3202acc4f7c7e6116e9d4e3021fbae51a. V542 réutilisé ; aucun audit SOURCE daté distinct fourni par la projection candidate, sans conclusion d’absence globale.

Six identités natives : définition, font, Nevershade INIBIN/Lua, CharScript Lua/preload. Deux parses Lua complets sans callback enfant sont une preuve héritée du rapport V542 ; les détails individuels de vues littérales ne figurent pas dans les métadonnées de ce reçu. Aucun détail de décodage inventé. Le buff déclare quatre valeurs : nom Nevershade, texture, persistance et non-dispel ; leur exécution reste non démontrée.

Trois clés en_GB retrouvées : un binding de tooltip V542, description et nom. Lignes 2349/4181 : 0,3% de vie maximale chaque seconde. 0,003 est une conversion arithmétique du texte, pas une cadence serveur prouvée.

Passive1=1 conservé ; ancienne phrase 20/30/40% de dégâts sous 40%PV non adoptée. BaseStaticHPRegen=1.5520000457763672, BaseFactorHPRegen chaîne «0», BaseHPRegen absent : aucun zéro implicite ni preuve d’absence du passif. Icônes DrMundo_AdrenalineRush.dds et DrMundo_AdrenalineRush2.dds distinctes, sans alias/priorité inventés. Preload et trois références communautaires ne prouvent pas le gameplay ; CharScript communautaire vide selon V542. Aucun nouvel accès natif, D/F-work ou ancien EXE.

## 3. Consommateurs réels

Dix-sept entrées — douze Rust, deux lecteurs Python, trois JSON — concordent avec V542 ; vingt identités courantes gardées. Deux sélections JSON héritées : croissance Mundo et Cristal1028. La sélection actuelle champions.json relie les définitions Mundo/Garen ; elle ne fournit pas une formule native du passif.

Vingt-cinq fenêtres : 23 communes réutilisées, deux supplémentaires pour refresh_item_caps et la garde du passif Garen. Onze ancres : catalogue et dix frontières génériques, sans producteur Adrenaline Rush qualifié.

regeneration_rates calcule base, croissance et pourcentage de régénération des objets. advance_regeneration filtre les vivants, ajoute garen_passive_per_second, applique received_multiplier et divise par TICK_RATE avant plafond. La fonction Garen retourne zéro si champion différent de garen ; ce chemin ne produit donc pas le supplément Mundo.

stats calcule max_health depuis base, croissance et objets. refresh_item_caps met à jour le maximum puis conserve/plafonne les PV courants ; acheter +150PV ne les remplit pas. healing.rs porte les multiplicateurs Ignite/Trundle et les gardes du soin générique. Ces politiques courantes ne qualifient pas automatiquement le passif natif.

Recherche bornée aux douze Rust : zéro occurrence DrMundo/Nevershade/Adrenaline, sans preuve d’absence globale. Aucun rejeu des 1158 dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire : identités, lignes, règles écrites et limites cohérentes. Observé : 42/42 contrôles documentaires, 54/54 cohérences du même agent. Cinq opérations journalisées : quatre réussites et un échec de sélection de fenêtre conservé. Aucun build ni essai de jeu relancé.

V542 hérité : deux fenêtres de 180 ticks, niveau1, vivant et sous le maximum, après six/sept frappes ennemies ordinaires. Ticks 1059→1239 et 1107→1287 ; PV 321.228515625→330.539428711 et 428.099365234→437.410278320. Régénération de base 1.5520000458PV/s ; supplément observé nul aux 360 ticks selon le diagnostic conservé.

Maximum 582.520019531 puis 732.520019531 avec Cristal1028, coût400, +150PV et 0%régénération. Le texte donnerait 1.7475600243 puis 2.1975600719PV/s, variation +0.45PV/s non observée. Les sommes -10.4864501953/-13.1890869141 restent des différences locales par tick face au prochain état hypothétique, pas une seconde simulation contrefactuelle cumulée.

Deux contrôles de pleine vie de 30ticks, six refus Attack et deux regeneration_rates=None hérités du rapport restent dans ce périmètre, sans rejeu. Binaire qualifié historique uniquement identifié en données : 5948416 octets, SHA256 6068f6e674df413fc1a91e81f6b390f0d5d79c3c46d23677641a1a519cf2e28e ; aucun accès, hash ou lancement.

## 5. Écarts et erreurs préservées

Manquent : corps/producteur effectif, cadence/quantification/arrondi, échantillonnage du maximum, addition à la base et multiplicateurs, niveaux supérieurs, autres changements du maximum, dégâts/coûts/mort/réapparition et projections. Les métadonnées de persistance ou le facteur chaîne0 ne tranchent pas ces politiques.

V542 conserve le premier driver supposant à tort que +150PV maximum remplit immédiatement les PV, ainsi qu’une erreur de parenthèse du premier script d’inspection. Corrections distinctes héritées ; aucun défaut du jeu déduit de ces erreurs d’outillage.

Dans ce lot, contract01 sélectionnait lignes28..42 de garen_passive.rs : déclaration ligne27 omise, méthode suivante incluse. contract02 sélectionne exactement27..41. Seul ce sélecteur change ; original, échec, diff et qualification conservés. Aucun code ni source native modifié.

## 6. Corrections et reprise

Dix fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-DRMUNDO-ADRENALINE-, suffixe -01 : AUTHORITY, RATE-PRODUCER, MAX-HEALTH, TICK-TIMING, MODIFIERS, CAPS, LIFECYCLE, HEALTH-EVENT-ORDER, PROJECTION, VERIFICATION.

Chaque fiche possède objectif, tâche V542 réellement associée, prérequis, travail, fin distincte et condition de reprise. Reprendre sur source précise, dérive, contradiction ou comportement supporté non vérifié ; correction fonctionnelle et nouvelle exécution sous autorisation distincte. Conserver les erreurs historiques, refus et limites de calcul.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_drmundo_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2452 entrées groupées modifiées conservées. Prochaine sélection Elise depuis les 122 paires existantes, distincte d’une clôture.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité, inconnues et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan, interface, bases, registres, produit et assets inchangés ; aucun nouveau runtime, REA, rendu, audio, réseau ou logiciel installé.
