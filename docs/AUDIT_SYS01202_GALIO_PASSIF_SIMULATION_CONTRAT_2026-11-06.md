# V1473 — Galio : contrat connu de Peau runique

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-GALIO-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Galio-PASSIF-SIMULATION-CONTRAT, exigence OLF-1e819f22-81d4-583a-927a-4530a0c2cd6a, parent SYS-01.2-02. Audit borné de seize branches connues, des sources et des consommateurs sélectionnés. La tâche complète, la fonctionnalité et le goal restent ouverts. SOURCE demeure a_qualifier ; phase D06, six prérequis du lot, dépendance et propriétaires des inconnues conservés.

Référence PUBLIC 4.20.0.315 EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau et déploiement inconnus, catalogue 4.20.1 distinct. Aucune mécanique récente substituée.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/galio-passive-conversion-links-v546.json : 428850 octets, SHA256 f2251457c241927378d456266e7e3ec89a9891c28c9265175610ece1ff4b4692. Rapport FIDELITY_GALIO_PASSIVE_CONVERSION_LINKS_V546.md : SHA256 b9cae4861ab9d368b62a45efe5085ab2018423f02dc3381ad53a6c52cda770ea. V546 du 25 octobre 2026 réutilisé, sans republier ses anciens liens.

Six identités natives : définition, fontconfig, GalioRunicSkin INIBIN/Lua et CharScript/preload. Membership hérité des manifestes sélectionnés ; aucun nouveau décodage ou accès à D:, F-work ou EXE. La priorité du chargeur historique n’est pas établie.

Trois clés en_GB retrouvées, dont tooltip ligne 1930 et description 4188 ; une liaison de tooltip. La description précise 50 % de la résistance magique totale convertie en puissance. Passive1LuaName et BuffName désignent GalioRunicSkin ; le fournisseur dynamique @f1@ reste inconnu.

Le rapport V546 indique deux Lua complètement parsés sans prototype enfant. Le reçu ne fournit pas leurs vues détaillées par chunk : aucune nouvelle vérification des opcodes ou valeur de global Lua n’est revendiquée. Ses quatre métadonnées de buff sont conservées, dont la casse Nondispellable, texture Galio_RunicSkin.dds et persistance. Elles ne prouvent pas leurs effets à l’exécution. Le preload mentionne galiorunicskin et apbonusdamagetotowers sans démontrer conversion ou affichage.

L’ancien Passive1Desc décrit un tiers d’armure/RM, distinct du texte lié. Passive1=9 et niveaux 3/7/11 restent littéraux, sans activation inférée. Les quatre PassLev1Desc identiques ne prouvent pas quatre rangs. SpellBlock=32.099998474121094 et croissance 1.25 sont présents ; BaseSpellBlock absent ne vaut pas zéro. Sources communautaires distinctes du serveur original.

## 3. Consommateurs réels

Vingt-deux entrées concordent avec V546 : seize Rust, deux lecteurs Python, quatre JSON. Sélections héritées : définition/croissance Galio, objets 1029/1033/1052, configuration des autels Map10. Vingt-trois identités courantes gardées avec le miroir en_GB.

Trente-quatre fenêtres : 32 communes réutilisées, deux supplémentaires sur les autels et plafonds d’achat. Onze ancres enregistrées, dont dix frontières entry_boundary_only, provides_feature_consumer=false pour Peau runique. Source, chargeur et statistiques génériques ne deviennent pas producteurs du passif.

stats calcule AP à partir des objets multipliés par altar_damage_multiplier. La RM compose base, croissance, objets, défense Annie, réduction Exhaust et ajustement TrundleR. Aucun terme de conversion Galio n’est identifié dans ces corps inspectés. Le multiplicateur d’autels dépend de deux autels possédés ; son ordre avec une conversion native demeure inconnu.

join, Buy/Sell, buy_item/sell_item, shop::bonuses, refresh_item_caps et advance sont des chemins réels. Le rafraîchissement plafonne les réserves de PV/mana ; il ne fournit pas la conversion. Une future correction doit établir les dépendances RM/AP sans appel récursif de stats ni mutation persistante des bases.

Recherche littérale Galio/RunicSkin sur seize Rust sélectionnés : zéro occurrence, sans preuve d’absence globale ni rejeu des 1158 dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire : textes, identités, appels, observations et limites concordants. Observé : 41/41 contrôles documentaires et 72/72 cohérences du même agent ; quatre opérations productrices réussies. Aucun nouveau build, jeu ou REA exécuté.

V546 hérité : deux simulations publiques Map10, Galio puis Ahri au niveau 1. Achats/ventes de Cape 1033, Tome 1052 et Armure 1029 ; trente ticks de stabilité par cas. Aucun champ de statistique, expérience, or ou passif directement injecté selon le rapport.

Galio : RM initiale 32.099998474121094 puis 57.099998474121094 avec la Cape ; AP reste 0. Le texte correspondrait à 16.049999237060547 puis 28.549999237060547 AP, delta 12.5. Ces calculs textuels ne résolvent pas l’activation native initiale ou les niveaux 3/7/11.

Le Tome ajoute 20 AP ; l’Armure ajoute 15 armure sans AP/RM. Les ventes restaurent les valeurs antérieures. Ahri passe de 30 à 55 RM avec la Cape, reste à AP 0, reçoit 20 AP du Tome puis retrouve ses valeurs. Aucune prédiction du passif Galio n’est attribuée à Ahri.

Dix refus publics individuels avec snapshots conservés : joueur/objet inconnu, case invalide/vide et or insuffisant. Le contrôle positif des objets ne prouve pas la conversion. Les deux horizons de trente ticks stables ne valent pas acceptation du passif.

Exécutable V546 uniquement identifié en données : 5998592 octets, SHA256 36803f17bedd74d09c5212be070a35fc50b10eca3892407103f1071f4dd2f52a. Aucun accès, hash ou lancement ; build, verrou, toolchain et 1158 entrées non revalidés ici. Aucun natif historique, rendu, audio ou réseau exécuté.

## 5. Écarts et conclusions ouvertes

Restent : fournisseur f1, activation initiale, niveaux, définition/sampling de RM totale, modificateurs temporaires, ordre des multiplicateurs AP/autels, résistances négatives, arrondis et cycle de vie. La divergence au texte dans les scénarios de niveau 1 ne tranche pas ces règles historiques.

Projection des statistiques, valeur dynamique affichée et transport nécessitent leurs preuves propres. Question OLU-041a500f-22cb-5d0e-8c60-1b1e72272874 et dépendances SOURCE conservées chez leurs propriétaires ; aucune inconnue fermée. Aucun manque de modèle ou texture démontré.

## 6. Corrections et reprise

Douze fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-GALIO-RUNIC-SKIN-, suffixe -01 : AUTHORITY-F1, ACTIVATION, LEVELS, MR-COMPONENTS, TEMPORARY-MODIFIERS, MR-LIMITS, AP-MULTIPLIERS, NONRECURSIVE-CONSUMER, ITEM-REVERSAL, LIFECYCLE, PROJECTION, VERIFICATION.

Chaque fiche possède objectif unique, tâche liée, prérequis, travail, fin distincte et déclencheur de reprise. Reprendre sur source nouvelle, identité modifiée, appel nouveau ou cas supporté nécessaire non couvert. Corrections fonctionnelles et essais supplémentaires relèvent d’un périmètre autorisé distinct.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_galio_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca ; 2459 entrées groupées préexistantes conservées. Prochaine sélection exacte Gangplank depuis 122 paires ; 95 candidats hors 27 unités nommées, sans compte de tâches complètes déduit.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan, interface, bases, registres, produit/assets inchangés ; aucune installation ou migration.
