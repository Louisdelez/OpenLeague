# V1505 — Maokai : contrat connu de Sap Magic

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-MAOKAI-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Maokai-PASSIF-SIMULATION-CONTRAT, exigence OLF-f2598a89-9636-5a9a-a717-7dd58c2ddeab, parent SYS-01.2-02. Audit de 31 branches connues ; SOURCE reste a_qualifier. Phase D06 et six prérequis conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB, date littérale 2014-11-17 à17:46:45 ; fuseau et déploiement inconnus. Catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/maokai-passive-sap-magic-links-v600.json du 26 octobre2026 : 1465409 octets, SHA256 e347ef72db3d40fa32658731ca5c27ce1509fe346a6b4468231f8e6629ff0d23. Rapport FIDELITY_MAOKAI_PASSIVE_SAP_MAGIC_LINKS_V600.md : 18244 octets, SHA256 03cd464d27ad3a6cf75bada100acce6e55a25671865041b098ff84524c3f4465. Candidat du cache et fichier actuel identiques.

62 identités natives, 26 références communautaires séparées, 14 preloads. 26 Lua parcourus historiquement : 25 initialisations littérales, 80 globals, aucun prototype enfant ; une limite NEWTABLE àpc10 dans MaokaiTrunkLineMissile, sans corruption déduite. CharScript natif/communautaire et maokaisapmagic.luaobj vides, sans absence globale de callback inférée. Aucun serveur exécuté par cette lecture.

MaokaiSapMagicPass/Maokai_Passive.dds liés. Description4231 : chaque sort proche donne une charge ; cinq charges puis prochain coup de base soignant7%PVmax. Buffs2267Hot/2268Melee prêt/2269Pass distincts ; @f1@, rayon et éligibilité restent ouverts. Quinze clés en_GB : quatorze présentes, dont JesterBasicAttack11613 vide ; MaokaiBasicAttack-description absente. Neuf bindings BuffData résolus. Bushwhack11437/9341 décrit Nidalee.

SpellData hérité : rayon600, portée900, coût60, coefficient0,4 et icône Nidalee_Bushwhack ; aucune règle SapMagic adoptée. Coefficients Melee nuls ne signifient pas soin nul. Six niveaux absents ; mana40/60/80% reste texte hérité sans progression du soin. Ready Maokai_PassiveReady.dds et Maokai_SapMagicReady.dds distinctes, effets main/yeux conservés. Noms HitSound/SwingSound/EAggroSound et preloads global_heal ne prouvent pas lecture audio ou invocation. PersistsThroughDeath sur Pass ne qualifie pas la persistance des charges. Six chemins candidats absents seulement. Aucun nouvel accès D:, F-work ou EXE.

## 3. Consommateurs réels

29 entrées concordent avec V600 : 19 Rust, deux lecteurs Python et huit JSON ; avec en_GB, 30 identités vérifiées. 39 fenêtres dont32 communes, quatre récapitulatif, AnnieQ45–94, compteurAnnie1–25 et stuns1–38. 30 ancres dont29 entry_boundary_only/provides_feature_consumer=false. Recherche Maokai/SapMagic sur19 Rust : zéro occurrence, sans absence globale ou relecture des1158 dépendances revendiquée.

Learn/Cast/CastAt refusent Maokai. Attaques, Garen/Trundle, dégâts, mitigation, vol de vie, régénération et récapitulatif sont conservés. healing::heal existe : refus montants invalides/source inconnue/cible morte, plafond PVmax, réduction Ignite et amplification TrundleW. Cette API n’est pas un producteur SapMagic ; sa disponibilité ne prouve pas les interactions natives.

Pyromania compte les sorts propres d’Annie : Q à l’impact, W/R à la libération, E à l’acceptation ; ce n’est pas un observateur de sorts proches de Maokai. Q committe le coût puis applique dégâts/Pyromania à l’impact. Stuns possède interruption et nettoyage d’expiration ; ces acquis ne prouvent pas les règles du passif.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer sorts proches, charges, attaque admissible et soin. Observé : 108/108 contrôles documentaires, 122/122 cohérences du même agent, quatre productions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V600 hérité : deux parties publiques Map10 Maokai/Annie, base puis rubis+150PV. PVmax572.2000122070312/722.2000122070312 ; références7%40.05400085449219/50.55400085449219, pas soins observés. Cinq Q ennemis acceptés par cas à150unités, raw80/coût60 : dix Q, six impacts de mêlée Maokai, 54 refus atomiques préservant les snapshots.

Chaque cas attend432ticks de recharge et38ticks pour nettoyer le stun du cinquième Q avant les attaques. Ce stun vient du compteur Annie ;38 est une attente locale, pas durée native SapMagic. Avant première attaque : PV294,53778/572,20001 et444,53778/722,20001 ; déficit277,66223 supérieur aux deux références de soin. Le plafond PV ne peut donc expliquer l’absence de soin supplémentaire. Attaques non critiques confirmées par windup/cible/libération, dégâts et régénération séparés avec tolérance0,002. Au premier impact, supplément de soin exactement0 dans les deux cas.

Les360ticks de fin ne qualifient pas durée/expiration des charges. Mana327.2799987792969 pleine, rangs/recharges Maokai nuls, champions vivants niveau1 ; aucun sort Maokai accepté. Ce refus ne suffit pas à expliquer le résultat après les sorts ennemis et attaques effectivement exercés. 150unités est une distance testée, sans rayon maximal ni admissibilité native entièrement qualifiés. Aucun état ou appel healing::heal artificiellement injecté.

Exécutable identifié uniquement en données : 6053888 octets, SHA256 303b190c553d5adbce29ce7d94a7fd7afa4e0989da52d5606dd93e21f58f9b10. BUILD/RUN0 hérités, sans accès actuel ; chaîne/lock/1158 entrées non requalifiés. Aucun défaut produit corrigé.

## 5. Écarts et conclusions ouvertes

Compteur initial/seuil/plafond, types de lancers, rayon/distance, consommation, cibles/annulations, producteur7%/f1, capturePVmax, modificateurs/plafond/ordre, coexistence, contrôles/lifecycle et projection/présentation restent à qualifier.

Propre OLU-a21f5243-616f-5056-9cf4-ddd47352a3db distincte de SOURCE OLU-06d4ed7c-a906-570b-81e9-1da635f14288. Propriétaires/dépendances conservés, aucune inconnue fermée. V564/BattleTraining et anciens échecs non corrigés.

## 6. Corrections et reprise

31 fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-MAOKAI-SAPMAGIC-, suffixe -01 : METADATA, LUA, SPELL-ADMISSION, INITIAL-COUNTER, CAST-ELIGIBILITY, PROXIMITY-RADIUS, COUNT-BOUNDARY, MULTIHIT-RECAST, COUNT-FIVE, READY-OVERFLOW, ATTACK-ELIGIBILITY, CONSUMPTION-BOUNDARY, REFUSAL-CANCEL, TARGET-LOSS, HEAL-SEVEN, TOOLTIP-F1, MAXHP-SAMPLING, HEAL-MODIFIERS, FULLHP-ZERO, DAMAGE-HEAL-ORDER, MULTI-CASTERS, MULTI-MAOKAI, CONTROL, LEVELS, LIFECYCLE, TICK-ORDER, ATTRIBUTION, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche existante liée, prérequis, travail, critère positif et reprise distincts.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios publics avec charges/état prêt réellement observés, attaque/soin, frontières et refus ; aucune injection pour déclarer fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_maokai_passive_simulation_contract_20261107. Date Europe/Zurich, reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2491 entrées préexistantes conservées. Prochain MasterYi depuis122 paires : 63 candidats hors59 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et ajouts CURRENT/HANDOFF avec sauvegarde préalable et contrôle après écriture. Goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, installation ou migration.
