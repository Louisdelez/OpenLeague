# V1486 — Jinx : contrat connu de Get Excited!

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-JINX-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Jinx-PASSIF-SIMULATION-CONTRAT, exigence OLF-b00dcf14-d122-52c9-ae76-03c3a3c3b79d, parent SYS-01.2-02. Audit borné de dix-huit branches connues et des consommateurs sélectionnés. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. La tâche complète, la fonctionnalité et le goal restent ouverts.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus, catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/jinx-passive-get_excited-links-v582.json du 26 octobre 2026 : 921588 octets, SHA256 2a884ae7135cf251c8903f57fc649e41e7f1e33b6747f52e5deba91cb4c82d16. Rapport FIDELITY_JINX_PASSIVE_GET_EXCITED_LINKS_V582.md : 16099 octets, SHA256 93b392c2866c838ac940a20053a4f022382ab14260c81132a54b18b57ffd4d94. La liste de rapports du cache était vide ; ce rapport existant a été retrouvé au chemin explicite puis épinglé, sans modifier le cache ni conclure à un asset manquant.

Quinze identités natives aux rôles distincts, huit références communautaires séparées, quatre preloads. Six Lua entièrement parsés historiquement, sans prototype enfant, six initialisations littérales et onze globals. Aucune exécution serveur ; CharScript natif et classe communautaire vides ne démontrent pas la mécanique.

Quatre clés en_GB vérifiées, dont deux bindings de buffs : Kill ligne 2114, Marker ligne 2115. Texte : champion, tour ou inhibiteur endommagé par Jinx dans les trois dernières secondes puis tué/détruit ; bonus de 175 % de vitesse décroissant sur quatre secondes. Courbe et base du pourcentage restent inconnues. Description ligne 4207 consultée par clé explicite : PassLev1Desc1 est absent, sans liaison inventée. Six champs de niveau absents.

Le personnage nomme JinxPassiveMarker, icône Jinx_Passive.dds et vitesse 325. Marker/Bowmaster_Bullseye.dds, Kill/Jinx_Passive.dds et moniteur JinxCatchMe/Jinx_Hidden.dds gardent leurs rôles. Persistance déclarée ne prouve pas le lifecycle ; effet Jinx_Passive_Buff et preload root ne prouvent ni rendu ni immobilisation.

DDF72 lignes dont seize Vi, sans entrée JinxPassive ; Q/minigun, coefficients totalattackdamage et contextes Caitlyn/Vi restent séparés du bonus de déplacement. Preuves réutilisées sans nouveau décodage ni accès D:/F-work/EXE.

## 3. Consommateurs réels

Trente et une entrées concordent avec V582 : dix-neuf Rust, deux lecteurs Python, dix JSON. Avec le miroir en_GB, 32 identités gardées. Trente-six fenêtres, dont 32 communes réutilisées et quatre sur vitesse, déplacement, contributions/récompenses et or ambiant. Vingt-cinq ancres enregistrées, dont 24 frontières entry_boundary_only/provides_feature_consumer=false. Tous les renvois des branches aboutissent aux fenêtres contrôlées.

Le moteur possède de vrais dégâts, morts, attribution, récompenses et progression XP. apply_damage enregistre la contribution puis appelle reward_champion_death ; le registre de récompenses applique une fenêtre générique de quinze secondes, différente des trois secondes de dégâts du texte Jinx. Les contributions de contrôle et les inconnues d’attribution ne deviennent pas son prédicat d’activation.

movement_speed et le déplacement vitesse/30 ne contiennent aucune contribution Get Excited identifiée. L’or ambiant est une fonction distincte ; world::damage_unit reste une frontière statique pour les structures. Ces composants réels sont conservés sans être promus en passif Jinx.

Recherche littérale Jinx/GetExcited sur dix-neuf Rust sélectionnés : zéro occurrence. Pas d’absence globale ni d’inspection des 1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer dégâts récents, kills, assistance générique, récompenses et accélération. Observé : 75/75 contrôles documentaires, 103/103 cohérences du même agent, quatre opérations productrices réussies. Aucun nouveau build, test Rust, jeu ou REA.

V582 hérité : deux cas publics base/bottes 1001, Jinx contre Annie, deux éliminations par cas avec réapparition naturelle d’Annie entre elles. Quarante-huit baisses de vie avec projectiles source/cible témoins, quatre kills sans assistant, récompenses 400 puis 300 séparées de l’or ambiant. Vitesse 325 ou 350, inchangée à chaque kill et pendant les observations suivantes.

Trente-quatre refus publics avec snapshots inchangés ; 720 ticks après kills, vingt pas mesurés. Chaque fenêtre de 180 ticks couvre six secondes : cinq pas puis Stop, résidu vitesse/30 inférieur à 0,005. Les gains XP ordinaires sont conservés, sans supposer un niveau inchangé après le second kill. Témoins Jinx non étendus aux anciens cas Draven partiellement non attribués.

Aucune accélération observée dans ces cas ; cela ne valide pas les assistances, la limite des trois secondes, les structures ou une courbe native nulle. La réapparition d’Annie ne qualifie pas la mort/réapparition de Jinx pendant son buff. Plafonds locaux, attribution fine et mécanismes Q demeurent distincts.

Exécutable V582 identifié uniquement en données : 6056960 octets, SHA256 73641609917d7aab84f0acc1650d89a0a7d4e54e30c8dbc933c70f3f1e1b1ea1. Aucun accès/lancement ; verrou, toolchain et 1158 entrées non revalidés.

Ancien PREPARE code 1 pendant saturation de F:, trois récupérations interrompues, logs et livraisons qualifiées conservés sans reclassement en succès global. Cette reprise observe l’espace E/F avant les petites copies documentaires ; elle ne requalifie pas les sauvegardes historiques et ne relance aucun nettoyage, compression ou copie de base.

## 5. Écarts et conclusions ouvertes

Restent fenêtre de dégâts, déclencheurs/catégories, attribution, dégâts absorbés/annulés, base des 175 %, courbe/arrondis sur quatre secondes, refresh/cumuls, composition, niveaux, lifecycle, intégration, Q séparé, icônes/aliases, réplication et présentation.

Question OLU-377a9df8-e778-55e3-aa8e-47859d2d4299, dépendances et propriétaires SOURCE conservés. Aucune inconnue fermée ; déplacement V564 et limites de BattleTraining non corrigés.

## 6. Corrections et reprise

Dix-huit fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-JINX-GET-EXCITED-, suffixe -01 : RECENT-DAMAGE, FATAL-TRIGGERS, STRUCTURE-TRIGGERS, CATEGORIES, ATTRIBUTION, ABSORBED-DAMAGE, BONUS-BASE, DECAY-CURVE, REFRESH, COMPOSITION, NUMERIC, LIFECYCLE, INTEGRATION, Q-SEPARATION, ICON-ALIASES, PROJECTION, PRESENTATION, VERIFICATION. Chacune possède objectif unique, tâche liée, prérequis, travail, fin distincte et condition de reprise.

Reprendre sur source nouvelle faisant autorité, fournisseur retrouvé, consommateur modifié ou cas supporté indispensable non couvert. Aucune correction fonctionnelle enregistrée ou implémentée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_jinx_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2472 entrées groupées préexistantes conservées. Prochain Kalista depuis 122 paires ; 82 candidats hors 40 unités nommées, sans compte complet déduit. La suggestion historique Karma ne remplace pas cette sélection courante.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication : rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan/UI/bases, registres, produit/assets inchangés ; aucune installation/migration. Réutilisation ciblée, sans gain temporel mesuré.
