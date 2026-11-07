# V1478 — Graves : contrat connu de True Grit

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-GRAVES-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Graves-PASSIF-SIMULATION-CONTRAT, exigence OLF-2653c17e-e014-5ec4-a29d-fc94cb8fc61c, parent SYS-01.2-02. Audit borné de dix-huit branches connues : combat, cumuls et défenses dans les consommateurs sélectionnés. SOURCE a_qualifier, phase D06 et six prérequis du lot conservés ; tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC 4.20.0.315 EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus. Catalogue officiel 4.20.1 distinct ; aucun passif moderne substitué.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/graves-passive-true-grit-links-v574.json : 839185 octets, SHA256 a4709268897e1d0d6c862c12fb025315250b8da7fdfcf70eda16ff79303200ab, du26octobre2026. Rapport FIDELITY_GRAVES_PASSIVE_TRUE_GRIT_LINKS_V574.md : SHA256 3e1e9b0fb4c57e038ddad909d6a832ccb44b0bd4847561bb92155f40607ed501. Identités/provenances réutilisées sans nouveau décodage ni accès D:/F-work/EXE.

Quinze identités natives et leurs rôles distincts conservés ; dix références communautaires séparées. Définition, buffs, preloads, compteur et ShotAttack ne sont pas interchangeables. Icône GravesTrueGrit.dds, métadonnée PersistsThroughDeath=true : aucune conservation de cumuls après mort démontrée.

Six Lua entièrement parsés historiquement sans prototype enfant, six initialisations littérales et26globals ; aucun callback serveur exécuté. Trois preloads, un FX binaire identifié uniquement par les preuves antérieures ; format/rendu non qualifiés. GravesTrueGrit.troy est une référence d’effet, pas un rendu observé.

Cinq clés en_GB retrouvées : deux tooltips liés, description et nom ; GritStacks ligne1966 constitue un contexte textuel sans binding supplémentaire inventé. Tooltip ligne1964 : bonus f1 d’armure et RM chaque seconde de combat, dix cumuls maximum ; combat décrit par dégâts infligés/reçus dans les trois dernières secondes. Montant f1, progression et fournisseur inconnus. Six champs Passive1Level recherchés absents, sans valeur zéro déduite.

Alias Pineapple/Pineapple.dds, RumbleDangerZone/Rumble_Junkyard Titan2.dds et chemin ShotAttack conservés avec rôles connexes non qualifiés. Descriptions héritées de critique alliée et vitesse d’attaque10/15/20% non adoptées comme True Grit. Quickdraw communautaire reste un buff de vitesse d’attaque distinct.

## 3. Consommateurs réels

Vingt-cinq entrées concordent avec V574 : seize Rust, deux lecteurs Python, sept JSON. Avec le miroir en_GB,26identités gardées. Trente-trois fenêtres :32communes réutilisées et une sur les contributions/récompenses. Vingt-trois ancres enregistrées, dont22frontières entry_boundary_only, provides_feature_consumer=false pour True Grit.

stats_progression compose base/croissance, objets, traitements GarenW/Annie/Exhaust et ajustement TrundleR ; aucun ajout de cumuls Graves identifié dans le corps inspecté. Les chemins dégâts/mitigation/pénétration consomment les défenses génériques. Le registre record_champion_contribution mémorise source/tick pour les assistances/récompenses via assist_seconds : ce n’est pas l’état de combat de True Grit.

Connexion, commandes, tick, régénération, achat, snapshot et réapparition restent des mécanismes génériques. Recherche littérale Graves/TrueGrit sur seize Rust sélectionnés : zéro occurrence, sans absence globale ou inspection des1158dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : relier cadence, états et bonus aux sources sans assimiler les impacts aux cumuls. Observé :65/65contrôles documentaires et91/91cohérences du même agent ; aucun nouveau build, test Rust, jeu ou REA.

V574 hérité : cinq cas publics repos, attaques émises, attaques reçues, réception avec Cloth1029 et avec Mantle1033 ; aucun changement direct d’état selon les preuves. Quarante impacts physiques avec projectiles témoins,75refus atomiques,1500ticks de suivi. Niveau1, aucun critique ; résidu physique corrigé de régénération inférieur à0.002 selon V574, sans nouveau recalcul float32.

Armure24.375999450683594, RM30 ; objets apportent séparément15armure et25RM. Statistiques inchangées à chaque tick observé après achat. Ces gains sont des contrôles d’objets, pas des cumuls du passif.

Dix attaques émises couvrent432ticks, intervalles48 ; dix reçues couvrent468ticks, intervalles52. Ces intervalles sont inférieurs aux90ticks des trois secondes textuelles et les séries dépassent dix secondes. Ils sont compatibles avec un combat régulier décrit par le texte, sans qualifier la totalité du prédicat natif. Dix impacts ne prouvent pas dix cumuls. Les300ticks après arrêt par cas ne vérifient pas l’expiration d’un bonus absent. RM observée, aucun dégât magique exécuté.

Exécutable V574 identifié uniquement en données :6035968octets, SHA256 124c1fcf7fe842c3153872aadb7113bc377cd9716d548319eab889a57182c536. Aucun accès/lancement ; verrou,toolchain et1158entrées non revalidés. Défaut déplacement V564 non corrigé par ces routes.

Cinq opérations documentaires, quatre réussies. contract01 a rencontré KeyError:stats dans le préparateur d’audit ; contract02 corrige vers stats_progression et ajoute les gardes de renvois. Original et journaux conservés ; aucun échec du jeu déduit.

## 5. Écarts et conclusions ouvertes

Restent f1/niveaux, dégâts admissibles, entrée/sortie de combat, premier incrément, frontières1s/3s, refresh, plafond/perte des cumuls, addition défensive et ordre des modificateurs, mitigation magique, cycle de vie, limites numériques, réplication et présentation.

Question OLU-cb895fdb-fa6f-5414-80d6-e24d16391c65 et dépendances/propriétaires SOURCE conservés. Aucune inconnue fermée ; métadonnées et contrôles génériques ne valident pas le passif.

## 6. Corrections et reprise

Seize fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-GRAVES-TRUE-GRIT-, suffixe -01 : AMOUNT-LEVELS, DAMAGE-ELIGIBILITY, COMBAT-ENTRY, PERIOD, COMBAT-EXIT, REFRESH, CAP, DEFENSES, MITIGATION, MODIFIER-ORDER, LIFECYCLE, NUMERIC-LIMITS, PROJECTION, PRESENTATION, ALIAS-ROLES, VERIFICATION. Chacune possède objectif unique, tâche liée, prérequis, travail, fin distincte et condition de reprise.

Reprendre sur source nouvelle faisant autorité, fournisseur retrouvé, consommateur modifié ou cas supporté indispensable non couvert ; aucune correction fonctionnelle enregistrée/implémentée ici.

## 7. Livraison et qualification

Preuves :E:/mapslol3v3/audit_sys01202_graves_passive_simulation_contract_20261106. Erratum contract_branch_anchor_errata.json : GnarV1476 Mini_stats/Mega_stats et GragasV1477 maxHP pointaient vers stats ; lire stats_progression. Les trois renvois corrigés aboutissent à la fenêtre existante épinglée, strictement identique. Ce supplément corrige ces index documentaires ; les contrôles initiaux ne validaient pas leur résolution. Rapports/reçus d’origine conservés, aucun comportement natif réexécuté ou nouvel audit complet antérieur fermé. Tous les renvois Graves sont maintenant contrôlés.

Git main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2464entrées groupées préexistantes conservées. Prochain Hecarim depuis122paires ;90candidats hors32unités nommées, sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ou acceptation humaine. Publication :rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal,Plan/UI/bases,registres,produit/assets inchangés ; aucune installation/migration.
