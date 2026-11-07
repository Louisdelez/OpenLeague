# V1476 — Gnar : contrat connu de Rage Gene

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-GNAR-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Gnar-PASSIF-SIMULATION-CONTRAT, exigence OLF-d0c02604-fd8b-5eb9-ac0d-5d7b0fa6d083, parent SYS-01.2-02. Audit borné de vingt branches connues : rage, attaques/combat, formes et consommateurs sélectionnés. SOURCE a_qualifier, six prérequis du lot D06 et propriétaires d’inconnues conservés ; tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC 4.20.0.315 EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus. Catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Deux reçus docs/reference_requirement_trace_sources réutilisés : gnar-passive-rage-gene-links-v571.json, 752263 octets, SHA256 81a7e3ead5505fba27a315e28af96f2014490bd4a0f0336c0172360d35ee0936 ; gnar-passive-respawn-rage-links-v572.json, 960202 octets, SHA256 c3e80b2a3fdaffaa14b9f121e8492c30cbfc8c239dbae3e4bb9389f880fd72da. Datés du 26 octobre 2026, avec leurs deux rapports FIDELITY correspondants. Aucun nouveau décodage natif ni accès D:/F-work/EXE.

Vingt-quatre identités natives héritées parmi 26 candidats, treize références communautaires, sept preloads. Gnar/GnarBig déclarent Gnarfury, GnarPassive et Gnar_Passive.dds. BaseMP=100 est une capacité ; PARStart/PARMax recherchés absents ne prouvent pas la quantité initiale native.

Neuf Lua entièrement parsés historiquement, sans prototype enfant : quatre initialisations littérales qualifiées, cinq globals. Cinq limites NEWTABLE conservées : FuryGeneration pc6, FuryHigh pc10, Transform pc8, TransformSoon pc8, TransformTired pc10. Les constantes AutoCooldownByLevel,20/18/16/14/12 et RocketTristana ne deviennent pas une durée de fatigue ; aucune corruption ni exécution serveur démontrée. PersistsThroughDeath est une métadonnée, pas une transition exécutée.

Neuf clés en_GB vérifiées : cinq tooltips, noms/descriptions Gnar et GnarBig. Tooltip principal : combat/attaques génèrent la rage ; à son maximum, prochaine capacité déclenche une transformation de 15 secondes. Mini : f1 vitesse, f2 portée, f3 vitesse d’attaque ; Mega : f4 santé, f5 défenses, f7 dégâts de base, f8 régénération par cinq secondes. Fournisseurs, niveaux et composition inconnus. Description GnarBig « Fury » et orthographe « surviviability » conservées.

Valeurs de définition Gnar/GnarBig distinctes : santé 540/610, dégâts 48/54, armure 23/26.5, RM 30/33, navigation 30/50, rayon gameplay 55/80, IsMelee No/Yes. Portée 150 et vitesse 325 communes ne sont pas les valeurs finales dynamiques de Mini. Spell1..4 restent GnarQ/W/E/R ; références GnarBigQWE du preload ne prouvent pas un remplacement de kit.

WProc/Hyper et son icône Gnar_W_Debuff.dds restent exclus de l’autorité de Rage Gene. Aucune ressource visuelle manquante déduite.

## 3. Consommateurs réels

Vingt-cinq entrées concordent avec V572 : dix-sept Rust, deux lecteurs Python, six JSON. Avec le miroir en_GB, 26 identités gardées. Trente-quatre fenêtres : 32 communes réutilisées et deux ciblées collision/vitesse. Vingt-cinq ancres enregistrées, dont 24 frontières entry_boundary_only, provides_feature_consumer=false ; aucun mécanisme générique promu en Rage Gene.

join initialise mana: def.mana, donc 100 localement. lifecycle.restores_resource ne retient que Mana/Energy ; Gnarfury ne reçoit pas la régénération générique. advance_respawns remet Mana/Energy/Wind au plein et les autres types à zéro. Le comportement ne qualifie pas une initialisation native de rage.

Attaques et dégâts exécutent les chemins physiques ordinaires. Statistiques, portée, vitesse, mêlée/projectile et collision restent indexées par champion dans les corps inspectés, sans transition de forme identifiée. Recherche littérale bornée sur dix-sept Rust : zéro occurrence Gnar/RageGene/Gnarfury ; aucune absence globale ou inspection des 1158 dépendances revendiquée.

champion_resources.source_sha256=11b6cb16… correspond au Stats/Gnar.json communautaire conservé ; le Gnar.inibin sélectionné vaut 140d97cc…. Provenances distinctes, sans substitution silencieuse.

## 4. Attendu, observé et contrôles

Attendu documentaire : intégrer la preuve plus récente levant la saturation et conserver les autres limites. Observé : 74/74 contrôles documentaires et 97/97 cohérences du même agent. Aucun nouveau build, jeu, test Rust ou REA.

V571 hérité : trois cas repos/émission/réception, 0/6/6 impacts, ressource 100→100, 48 refus et 1800 ticks de suivi. Jauge saturée : gain non mesurable ; aucune transformation commencée, donc pas d’expiration qualifiée.

V572 hérité : trois morts publiques après 14 impacts chacune, soit 42 préparatoires ; réapparition après 480 ticks, ressource 100→0. Puis 0/6/6 impacts, ressource 0→0, 54 refus atomiques et 1800 ticks de suivi. Gains nuls observés hors saturation dans ces cas ; formule native et déclenchement de transformation restent inconnus. Déplacements et combat publics, sans injection directe selon les preuves conservées.

Deux anciens diagnostics de voie BUILD0/RUN101 conservés. Au tick3048, baisse corrigée de 10.0654296875 sans projectile Gnar préalable ; sbires présents, source exacte non qualifiée. Successeur en zone centrale BUILD/RUN0, sans supprimer les règles. Aucun échec effacé ou réattribué au passif.

Exécutables uniquement identifiés en données : V571 6035456 octets/SHA256 ec128b083d2590af2c7ed71960e4b3be051a8ed3f517ca12fe957a65b371d517 ; V572 6059520 octets/SHA256 94b11682bd9e9c5a3361e988862ea1ca19430fcabbaf04db850293b31d3a2b45. Aucun accès/lancement ; verrou, toolchain et 1158 entrées non revalidés.

Cinq opérations documentaires, quatre réussies : bootstrap01 attendait 24 descripteurs au lieu des 25 enregistrés, catalogue compris. Original/journaux conservés ; bootstrap02 corrige uniquement ce compte attendu, sans changer les identifiants ou le code produit.

## 5. Écarts et conclusions ouvertes

Restent initialisation, gains combat/attaques, décroissance, seuil, déclencheur, durée/expiration, fatigue, paramètres de formes, remplacement du kit, cycle de vie, limites numériques, réplication et présentation. Refus de rejoindre comme gnarbig distinct d’une transition interne. V564 déplacement non corrigée.

Question OLU-3c8b7e75-6ac0-51e7-b6a1-e8748f58df49, dépendances et propriétaires SOURCE conservés ; aucune inconnue fermée. Source absente ou partielle reste indéterminée.

## 6. Corrections et reprise

Dix-huit fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-GNAR-RAGE-GENE-, suffixe -01 : INITIAL-RAGE, COMBAT-GAIN, ATTACK-GAIN, DECAY, THRESHOLD, ABILITY-TRIGGER, DURATION, FATIGUE, MINI-STATS, MEGA-STATS, FORM-PROFILES, ABILITY-SWAP, LIFECYCLE, PROVENANCE, PROJECTION, PRESENTATION, NUMERIC-LIMITS, VERIFICATION.

Chaque fiche possède objectif unique, tâche liée, prérequis, travail, fin distincte et condition de reprise. Reprendre sur nouvelle source faisant autorité, fournisseur retrouvé, consommateur modifié ou cas supporté nécessaire non couvert ; aucune correction enregistrée/implémentée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_gnar_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2462 entrées groupées préexistantes conservées. Gragas sélectionné depuis 122 paires ; 92 candidats hors 30 unités nommées, sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans acceptation humaine ou revue indépendante. Publication limitée au rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan/UI/bases, registres, produit/assets inchangés ; aucune installation/migration. Analyses communes réutilisées, aucun gain de temps mesuré.
