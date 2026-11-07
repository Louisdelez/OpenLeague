# V1479 — Hecarim : contrat connu de Warpath

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-HECARIM-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Hecarim-PASSIF-SIMULATION-CONTRAT, exigence OLF-c9d49a8f-b47f-5bbb-a3f7-0ceee5477704, parent SYS-01.2-02. Audit borné de seize branches connues : conversion vitesse bonus→dégâts d’attaque et passage à travers les unités. SOURCE a_qualifier, phase D06, six prérequis du lot et propriétaires d’inconnues conservés ; tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC 4.20.0.315 EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/hecarim-passive-warpath-links-v575.json :870738octets, SHA256 b3d01734c7760e189ba9abe252080fabaafaa495aea918b9fd7f5cc82301272f, du26octobre2026. Rapport FIDELITY_HECARIM_PASSIVE_WARPATH_LINKS_V575.md :SHA256 907780d34fc753abcd4d6fde4de4c8d2c87029617b9d2b27b73ed9774ddc954e. Identités/provenances réutilisées ; aucun nouveau décodage ou accès D:/F-work/EXE.

Onze identités natives aux rôles distincts, huit références communautaires séparées, deux preloads. Quatre Lua entièrement parsés historiquement sans prototype enfant ; trois initialisations littérales qualifiées et20globals. Ramp reste limité sur NEWTABLE pc10 : aucune corruption ou exécution serveur démontrée.

Quatre clés en_GB vérifiées : tooltip Warpath1984, Ramp1985, description4199 et nom. Warpath décrit le passage à travers les unités et des dégâts d’attaque égaux à f2% du bonus de vitesse ; f1 affiche les dégâts bonus. Fournisseurs, coefficients par niveau, base exacte et arrondis inconnus.

Icône du personnage Hecarim_Passive.dds distincte du buff Hecarim_Warpath.dds ; rôles conservés sans unification automatique ou texture absente déduite. PersistsThroughDeath et IsDamagingSpell sont des métadonnées, pas des règles exécutées de réapparition ou de dégâts.

Ramp/DevastatingCharge est une capacité active distincte. Le DDF contient16entrées RapidSlash/Ramp/W/Ult et aucune HecarimPassive. Coefficients0.6/0.5/1.0 de dégâts bonus actifs non adoptés comme f2. Cette absence locale ne démontre pas l’absence de formule partout. Descriptions héritées de critique et vitesse d’attaque non adoptées. Preloads d’animations/particules ne prouvent pas leur rendu.

## 3. Consommateurs réels

Trente et une entrées concordent avec V575 :vingt Rust,deux lecteurs Python,neuf JSON. Avec le miroir en_GB,32identités gardées. Trente-neuf fenêtres :32communes réutilisées et sept ciblées sur AD,vitesse,rayons,occupation alliée et contrôle Soin. Trente ancres enregistrées dont29frontières entry_boundary_only, provides_feature_consumer=false pour Warpath. Tous les renvois de branches aboutissent à une fenêtre contrôlée.

ad_components calcule base+croissance,objet,autel,ajustement TrundleQ et bonus=total−base. attack_damage_components et stats_progression ne convertissent pas la vitesse dans les corps inspectés. La vitesse suit sa propre composition :définition,objets,modificateurs,ralentissements et plafonds.

allies filtre les autres corps de même équipe. living_bodies et l’entrée advance_allied_motion utilisent les rayons de navigation du champion et un budget dérivé de movement_speed/TICK_RATE. Aucune exemption Hecarim identifiée dans ces chemins. Rayon navigation et corps de gameplay restent distincts ; les autres catégories d’unités ne sont pas qualifiées.

Soin public passe par cast_summoner_on/cast_heal, ajoute sa vitesse pendant son délai propre. Recherche littérale Hecarim/Warpath sur vingt Rust sélectionnés :zéro occurrence, sans absence globale ou inspection des1158dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire :séparer conversion Warpath, contrôles d’objets/Soin et collision générique. Observé :78/78contrôles documentaires et100/100cohérences du même agent ; quatre opérations productrices réussies. Aucun nouveau build,test Rust,jeu ou REA.

V575 hérité :cinq simulations publiques Hecarim/Annie, niveau1, sans injection directe selon les preuves. Base, Boots1001,Soin,Boots+Soin et Sword1036 ;30impacts de mêlée avec windup témoin,77refus atomiques et450ticks de suivi. Résidu physique corrigé de régénération inférieur à0.002 selon V575, sans nouveau recalcul float32.

Base :vitesse345,AD61.375999450683594. Bottes :vitesse370,ADidentique. Soin :vitesse441.79998779296875 ; bottes+Soin :467.79998779296875 ; ADidentique dans les deux cas. Au moins un impact survient pendant chaque bonus. Retour exact à345/370 au tick30 selon les captures héritées. Sword apporte séparément10AD, soit71.3759994506836 ; ce contrôle n’est pas Warpath.

movement_rules.json indique sa reconstruction communautaire non qualifiée ; heal_rules.json donne30% pendant1seconde et conserve le conflit240/300secondes de cooldown. La vitesse finale affichée après plafonds n’est pas automatiquement la base native à convertir.

Quatre comparaisons de collision publiques Hecarim/Garen :alliés bloquent les deux à80/65unités ; ennemis traversés par les deux, distance minimale3.004350423812866 et destination atteinte. Passage ennemi partagé avec Garen, donc aucune preuve spécifique de Warpath. Les80unités alliées sont50+30rayons de navigation Hecarim+Annie ; égalité avec le rayon gameplay80 ne prouve pas son emploi.

Exécutable V575 identifié uniquement en données :6084096octets, SHA256 9c0bf4fbb737d84019e0b0306ab6d9bd5ac8b06890182ea497d0ef394de0889f. Aucun accès/lancement ; verrou,toolchain et1158entrées non revalidés. Les routes centrales ne corrigent pas le défaut déplacement V564.

## 5. Écarts et conclusions ouvertes

Restent f1/f2,niveaux,quantité de vitesse bonus admissible,ordre pré/postplafonds et ralentissements,conversion sans récursion des stats,consommation AD par dégâts réels,passage par catégorie/équipe,terrain/obstacles,déplacements forcés,mort/réapparition,limites numériques,réplication et présentation.

Question OLU-b42621ed-f239-5f6c-a863-c3fc60b78b01 et dépendances/propriétaires SOURCE conservés. Aucune inconnue fermée ; ni le contrôle Soin ni la traversée ennemie générique ne valident Warpath.

## 6. Corrections et reprise

Seize fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-HECARIM-WARPATH-, suffixe -01 :F2-LEVELS,F1-DISPLAY,BONUS-BASIS,ITEMS,TEMPORARY-SPEED,AD-COMPOSITION,DAMAGE,GHOST-TEAMS,GHOST-TERRAIN,MOVEMENT-STATE,LIFECYCLE,NUMERIC-LIMITS,ICONS,PROJECTION,PRESENTATION,VERIFICATION. Chacune possède objectif unique,tâche liée,prérequis,travail,fin distincte et condition de reprise.

Reprendre sur source nouvelle faisant autorité,fournisseur retrouvé,consommateur modifié ou cas supporté indispensable non couvert ; aucune correction fonctionnelle enregistrée/implémentée ici.

## 7. Livraison et qualification

Preuves :E:/mapslol3v3/audit_sys01202_hecarim_passive_simulation_contract_20261106. Reprise depuis le result_qualified.json de Graves concordant avec sa publication ; préparations originales et erratum Gnar/Gragas conservés sans nouvel audit antérieur clos.

Git main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2465entrées groupées préexistantes conservées. Prochain Heimerdinger depuis122paires ;89candidats hors33unités nommées, sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète,fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent,sans revue indépendante ni acceptation humaine. Publication :rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal,Plan/UI/bases,registres,produit/assets inchangés ; aucune installation/migration. Réutilisation ciblée sans gain de temps mesuré.
