# V1471 — Fiora : contrat connu de Duelist

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-FIORA-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Fiora-PASSIF-SIMULATION-CONTRAT, exigence OLF-0a0fd7c8-3795-5d06-a2d9-5f3ebcebceb1, parent SYS-01.2-02. Audit borné de vingt branches connues et des consommateurs sélectionnés. SOURCE demeure a_qualifier ; phase D06, six prérequis du lot, dépendance et propriétaires d’inconnues conservés. Tâche complète, fonctionnalité et goal restent ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Aucun passif moderne de points vitaux substitué.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/fiora-passive-duelist-links-v662.json :2846777octets, SHA256 072515317cf632a1b1da6b27d9c19c336222edaeebe9a9ee80d56d2e6097b6e9. Rapport FIDELITY_FIORA_PASSIVE_DUELIST_LINKS_V662.md : SHA256 1683e01fbb4c6518572e93e6fdcb32d3472ba5707861ff0413d098e68d44180a. V662 du27octobre2026 réutilisé, sans nouvelle publication de ses liens antérieurs.

Vingt-et-une identités natives sélectionnées ; le rapport recense64candidats,26références communautaires et quatre exclusions. Définition Fiora.inibin :2592octets, SHA256 a762b0b53b83bcecef9612f80164d5738d1a240c1832912bd21553cc5fe58ac9. Membership hérité, aucune nouvelle ouverture de D:, F-work ou ancien EXE.

Quatre clés en_GB retrouvées :1899/1900/4186/4362. Le tooltip demande dégâts physiques, récupération @f1@PV sur six secondes et quatre cumuls contre champions. La description dit dégâts sans type ; conserver cette différence. f1 et sa progression restent inconnus. Le DDF contient huit lignes dont deux renseignées : FioraQ;f1 bonusattackdamage×0.6 et FioraDance;f1×1.2 ; aucune n’est une formule du soin.

Vingt-huit Lua complètement parsés historiquement sans prototypes enfants :22initialisations littérales qualifiées,115globals au total, six limites NEWTABLE conservées. Les trois variantes d’attaque sélectionnées ont une initialisation indéterminée, pas un corps vide démontré. Six vues CharScript/Duelist/Hot/particules/Run portent38globals. CharScript est vide qualifié ; les trois Hot ont les mêmes octets et BuffName, sans preuve de trois cumuls.

PersistsThroughDeath/NonDispellable et effets d’activation vides sont des métadonnées. Preloads/particules ne prouvent ni soin, ni conservation à la mort, ni affichage. Le source_sha256 du type de ressource pointe vers Stats/Fiora/Fiora.json communautaire, SHA f1855695fc2c7840d474d4ce6aedfb7e4f957222aaf13defc52a7350ea876507 ; il ne désigne pas l’INIBIN a762.

## 3. Consommateurs réels

Vingt-deux entrées sélectionnées concordent avec V662 :16Rust, deux lecteurs Python, quatre JSON. Sélections héritées : définitions/croissance Fiora/Annie, types de ressources, politique de refus des casts. Vingt-trois identités courantes gardées avec le miroir en_GB.

Trente-trois fenêtres :32communes réutilisées et une garde Garen supplémentaire. Vingt-deux ancres enregistrées, dont21frontières entry_boundary_only, provides_feature_consumer=false pour Duelist ; des descripteurs réemploient la même fonction catalogue. Aucun soin générique promu en passif Fiora.

basic_attack_hit livre les dégâts physiques via apply_damage puis calcule le vol de vie ordinaire. heal applique received_multiplier, plafondPV, gardes de source/cible/vie/valeurs finies ; Ignite et TrundleW restent distincts de Duelist. regeneration_rates calcule base/croissance/objets. advance_regeneration ajoute le passif Garen, dont la garde champion!=garen retourne zéro pour Fiora.

Initialisation, état d’effets, dispatch, attaques, progression, Learn/Cast/CastAt, tick, snapshot et cycle de vie ne fournissent pas de producteur Duelist identifié dans ces corps inspectés. Recherche littérale Fiora/Duelist sur16Rust :zéro occurrence, sans conclusion d’absence globale ou rejeu des1158dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire :identités, textes, appels, observations et limites cohérents. Observé :56/56contrôles documentaires,87/87cohérences du même agent. Cinq opérations productrices :quatre réussies, un échec conservé. bootstrap01 supposait selector présent dans les quatre ressources JSON ; bootstrap02 ajoute uniquement les sélecteurs explicites. Scripts/journaux conservés, sources et observations identiques ; aucun défaut du jeu inféré.

V662 hérité :Fiora/Annie niveaux1/18 contre Annie18, quatre simulations,12768ticks. Six apports XP serveur préparent les niveaux ; huit trajets Move/Stop publics sans réémission. Vingt préparations healAPI puis dégâts vrais40%PVmax créent le déficit dePV. Ces préparations ne sont pas un parcours entièrement public ni un proc du passif.

Vingt-quatre attaques publiques :une isolée, quatre rapprochées puis cinquième par simulation. Premier→quatrième :135/90/156/126ticks, tous sous180ticks courants. Vingt-quatre horizons de181ticks, référence et phases après coups/contrôles API. Les preuves antérieures reconstituent les additions float32 et observent seulement la régénération ordinaire, avec propriétaire toujours sous son plafond. Aucun nouveau recalcul des séries historiques ici.

Les douze événements serveur de dégâts physiques/magiques/vrais ont leurs mitigations vérifiées dans V662 ; ils ne sont pas des sorts Fiora réussis ni une qualification des types déclencheurs. Quatre heal25 restaurent25PV comme témoins séparés ;25 ne vaut pas f1. Soixante refus publics et40API sans mutation sont hérités.

Une cinquième attaque sans proc ne valide pas le cap natif. f1 inconnu ne devient pas zéro ; l’absence de supplément observé reste distincte d’une reconstruction numérique ou acceptation du passif. Témoin Annie et vol de vie nul ne sont pas des effets Duelist.

Exécutable non-test V662 uniquement identifié en données :6116352octets, SHA256 267c7eecac4910c920a86c86a002c66ef0af46578a87ef330530505dbc78d16c. Aucun accès, hash ou lancement ; build/1158entrées/toolchain non revalidés. Aucun nouveau jeu, réseau, rendu, audio ou REA exécuté.

## 5. Écarts et conclusions ouvertes

Restent :f1/progression, dégâts déclencheurs et crédit, autres cibles, gain/rafraîchissement/cap/durée des cumuls, calendrier/arrondi du soin, modificateurs et plafonds, mort/réapparition/dissipation/session, interactions Q/W/E/R. Métadonnées et absence de proc ne résolvent pas ces règles.

Projection du compteur/timer, réplication et présentation nécessitent leurs preuves propres. Questions propres OLU-9dd513f3-4e7d-51bf-b4fa-e4a7051d3eda et dépendances SOURCE conservées chez leurs propriétaires ; aucune inconnue fermée. Aucun manque de modèle ou texture prouvé.

## 6. Corrections et reprise

Dix-sept fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-FIORA-DUELIST-, suffixe -01 :AMOUNT, LEVELS, TRIGGER, CREDIT, TARGETS, STACK-GAIN, REFRESH, CAP-FIFTH, DURATION, CADENCE, MODIFIERS, HEALTH-CAPS, LIFECYCLE, QWER, PROJECTION, PRESENTATION, VERIFICATION.

Chaque fiche possède objectif, tâche liée, prérequis, travail, fin distincte et condition de reprise. Reprendre sur source nouvelle, dérive, appel nouveau ou cas supporté nécessaire non couvert. Corrections fonctionnelles et essais supplémentaires relèvent d’un périmètre autorisé distinct ; aucune modification des bases ou registres du plan ici.

## 7. Livraison et qualification

Preuves :E:/mapslol3v3/audit_sys01202_fiora_passive_simulation_contract_20261106. Git main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca ;2457entrées groupées préexistantes conservées. Prochaine sélection exacte Fizz depuis122paires ;97candidats hors25unités nommées, sans compte de tâches complètes déduit.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan, interface, bases, registres, produit/assets inchangés ; aucune installation ou migration.
