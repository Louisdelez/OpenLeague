# V1472 — Fizz : contrat connu de Nimble Fighter

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-FIZZ-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Fizz-PASSIF-SIMULATION-CONTRAT, exigence OLF-bdcca387-2083-5457-a39a-c04410e27500, parent SYS-01.2-02. Audit borné de dix-huit branches connues couvrant dégâts d’attaques reçus et traversée des unités. Tâche complète, fonctionnalité et goal ouverts ; SOURCE a_qualifier, phase D06, six prérequis du lot, dépendance et propriétaires d’inconnues conservés.

Référence PUBLIC4.20.0.315 EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Aucune mécanique récente substituée.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/fizz-passive-nimble-fighter-links-v569.json :575400octets, SHA256 21c26224a0450f8269fded9d57300b371a7ce564856b163f85710f99501b0b04. Rapport FIDELITY_FIZZ_PASSIVE_NIMBLE_FIGHTER_LINKS_V569.md :SHA256 5940564f09be8d6a035f27d5ff3b19b6c63a7485ce534fa52b53e6a470128a56. V569 du25octobre2026 réutilisé ; aucune nouvelle publication de ses anciens liens.

Sept identités natives parmi huit candidats :définition, fontconfig, CharScript/preload et FizzPassive INIBIN/Lua/preload. Membership hérité des manifestes sélectionnés, sans nouveau décodage, accès D:/F-work/EXE ni priorité de chargement démontrée. Deux Lua entièrement parsés historiquement, trois globals littéraux, aucun prototype enfant ; deux preloads, huit références communautaires distinctes du serveur natif.

Trois clés en_GB retrouvées :tooltip1911, description4187, nom. Une liaison de tooltip. Passive1LuaName=FizzPassive ; texte traversée des unités et réduction des dégâts physiques des attaques de base, tooltip @f1@. Producteur f1, seuils de niveau et ordre inconnus ; champs Passive1Level absents sans substitution.

FizzPassive déclare BuffName/PersistsThroughDeath/NonDispellable, sans BuffTextureName. L’icône du personnage FizzPassive.dds est présente en métadonnées :aucune texture manquante déduite. FizzPassiveDisplayIcon déclare FizzSeastoneTrident/FizzSeastonePassive.dds, avec Spell2=FizzSeastonePassive ; candidat exclu de l’autorité Nimble Fighter, sans réécriture d’alias.

Rayon natif de navigation :chaîne"30" ; GameplayCollisionRadius absent. Navigation, corps et immunité aux unités sont trois contrats distincts.

## 3. Consommateurs réels

Vingt-six entrées concordent avec V569 :18Rust, deux lecteurs Python, six JSON. Sélections héritées :définitions/croissance et collision Fizz/Annie/Garen/Ahri, objet1029, profils attaque/critique d’Annie. Vingt-sept identités courantes gardées avec le miroir en_GB.

Quarante fenêtres :32communes réutilisées et huit sur sélection des alliés, placement, route, réservations, arrondi/préfixe, dispatch, rayons et vitesse. Vingt-neuf ancres enregistrées, dont28frontières entry_boundary_only, provides_feature_consumer=false pour Nimble Fighter.

basic_attack_hit/apply_damage/mitigate suivent l’attaque physique et l’armure ordinaires, sans terme propre à Fizz identifié dans ces corps. Régénération et boucliers restent des mécanismes séparés.

allies sélectionne même équipe, identité distincte ; living_bodies retient joueurs vivants/finis et rayons de navigation. placement et route utilisent ces corps ; advance_allied_motion construit deux lots d’équipe puis réserve leurs mouvements balayés. Aucun bypass Fizz identifié. La traversée ennemie générale découle de cette séparation ; elle ne prouve pas le passif.

collision::pathfinding_radius conserve son admission finie/positive/≤50 ; body_radius utilise séparément un défaut communautaire65, ou40pour valeur non positive. Aucun rayon zéro inventé pour traverser. fit_step arrondit vers le budget ; prefix garde terrain/piliers, puis TerrainBlocked peut annuler le chemin. La pénalité de traversée Garen reste spécifique à Garen.

Recherche littérale sur18Rust sélectionnés :zéro Fizz/NimbleFighter, sans conclusion d’absence globale ou rejeu des1158dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire :sources, appels, limites et observations concordants. Observé :62/62contrôles documentaires,97/97cohérences du même agent ; quatre opérations productrices réussies. Aucun nouveau build, jeu, REA ou diagnostic exécuté.

V569 hérité :six simulations publiques sans injection directe de position/santé/ressources/rangs/effets ni dégâts artificiels. Deux scénarios d’attaques entrantes au niveau1, six impacts chacun,30refus atomiques. Armure22.41200066 puis37.41200256 avec achat1029(+15). Les impacts sont associés aux projectiles Annie du snapshot précédent.

Brut rapporté50.40999985, pertes après comptabilisation de régénération41.18060303/36.68530273. Relecture arithmétique des nombres du rapport conforme à brut×100/(100+armure), tolérance0.002 ; aucune nouvelle reconstitution des séries float32 ou exécution d’impacts. L’armure témoin n’est pas une réduction du passif ; autres niveaux/critiques/cibles non qualifiés.

Quatre parcours mouvement hérités :Fizz/Garen bloqués aux centres alliés, minima60/65unités, sommes des rayons de navigation ; destination non atteinte après300ticks. Traversée ennemie pour les deux, minima4.3369140625/3unités, destination atteinte250unités au-delà. Ce témoin commun ne valide pas l’immunité Fizz. Sbires, monstres, familiers, structures et toutes configurations terrain ne sont pas couverts.

Exécutable V569 uniquement identifié en données :6047744octets, SHA256 09787d54f6ef4adbfc96946b7b4bfa916a6dc8865414e77a5676888fdaf06e16. Aucun accès, hash ou lancement ;1158entrées/build/toolchain non revalidés. Les anciennes preuves V568 et son échec restent conservées. Navigation V564 demeure ouverte ; ces routes réussies ne la corrigent pas.

## 5. Écarts et conclusions ouvertes

Restent :f1, progression, attaques/composantes éligibles, ordre armure/boucliers/onhit, bornes et attribution. Pour la collision :catégories d’unités, alliés/ennemis, spawn/réapparition, réservations concurrentes et séparation du terrain. Métadonnées de persistance ne qualifient pas mort/session/dissipation.

Snapshot générique ne vaut pas transport, HUD, animation/VFX/audio ou acceptation native. Question propre OLU-83edb877-1fed-5e4e-a098-8b7b793845be et dépendances SOURCE conservées chez leurs propriétaires ;aucune inconnue fermée. Aucun manque de texture/géométrie prouvé.

## 6. Corrections et reprise

Quatorze fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-FIZZ-NIMBLE-FIGHTER-, suffixe -01 :AMOUNT, ATTACK-TYPES, REDUCTION-ORDER, TARGET-REDUCTION, UNIT-CATEGORIES, ALLIED-PASSAGE, ENEMY-CONTROL, SPAWN, RESERVATIONS, TERRAIN, LIFECYCLE, PROJECTION, PRESENTATION, VERIFICATION.

Chaque fiche possède objectif, tâche liée, prérequis, travail, fin distincte et déclencheur de reprise. Reprendre sur source nouvelle, identité modifiée, appel nouveau ou cas supporté nécessaire non couvert. Corrections fonctionnelles et essais supplémentaires relèvent d’un périmètre autorisé distinct.

## 7. Livraison et qualification

Preuves :E:/mapslol3v3/audit_sys01202_fizz_passive_simulation_contract_20261106. Git main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca ;2458entrées groupées préexistantes conservées. Prochaine sélection exacte Galio depuis122paires ;96candidats hors26unités nommées, sans compte de tâches complètes déduit.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan, interface, bases, registres, produit/assets inchangés ; aucune installation ou migration.
