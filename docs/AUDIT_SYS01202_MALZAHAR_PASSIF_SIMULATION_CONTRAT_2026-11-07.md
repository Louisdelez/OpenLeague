# V1504 — Malzahar : contrat connu de Summon Voidling

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-MALZAHAR-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Malzahar-PASSIF-SIMULATION-CONTRAT, exigence OLF-b95143dc-a1d0-582e-9c02-f2d81412ce81, parent SYS-01.2-02. Audit de 36 branches connues ; SOURCE reste a_qualifier. Phase D06 et six prérequis conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB, date littérale 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus. Catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/malzahar-passive-summon-voidling-links-v599.json du 26 octobre 2026 : 1567772 octets, SHA256 98933be5a2f3e3d3cd8e211c7ee6907c077a571fc0257eac8004e726571af761. Rapport FIDELITY_MALZAHAR_PASSIVE_SUMMON_VOIDLING_LINKS_V599.md : 17674 octets, SHA256 aa9f0d28d822786a4b7314821bca02e75e466d85a7bc1adf7fd05f1147e09fa9. Candidat du cache et fichier actuel concordent exactement.

57 identités natives, 25 références communautaires séparées, 13 preloads. 23 Lua parcourus historiquement : initialisations littérales complètes, 80 globals, aucun prototype enfant ou limite NEWTABLE. Cette lecture n’exécute pas le serveur. CharScript natif et communautaire vides, sans absence globale de callback déduite. Treize NightmareBotMalzahar exclus du contrat standard, sans qualification nouvelle de leurs contenus.

Onze clés en_GB vérifiées, toutes présentes, neuf bindings BuffData. Description4229 : après quatre sorts, créature incontrôlable durant 21 secondes ; PV200+50×niveau et dégâts20+5×niveau. Buff1680 : @f1@/@f2@/@f3@ non résolus, croissance à7secondes (+50% dégâts/armure), frénésie à14secondes (+100% vitesse d’attaque). Compteur1681, prêt au prochain sort1682, créature1683, croissance1684 et frénésie1685 restent des états distincts. MaleficVisions1677 indique une affinité de cible, sans priorité d’IA complète.

AlZaharSummonVoidling.luaobj déclare le buff Ready ; Count déclare SummonVoidlingBuff ; Detonation déclare SummonVoidling et persistance. Ces noms/persistances ne fixent pas le compteur initial ou le cycle au décès. Phase3 déclare des effets sur les deux mains, sans horloge exécutée. NautilusPassive/Malady et EzrealEssenceFluxDebuff/FallenAngel sont conservés sans adoption de leur gameplay.

Créature native : bases PV chaîne200, croissancePV0, dégâts20.0, armure30, résistance50, portée125, vitesse460, rayons20/10. Ces valeurs ne démontrent pas le calcul final selon le niveau, l’AD bonus ou le moment de capture. Six niveaux passifs absents ; six chemins candidats absents seulement. Preloads et ifhasbuffcheck restent dépendances, sans invocation ou rendu accepté. Aucun nouvel accès D:, F-work ou EXE ni décodage natif.

## 3. Consommateurs réels

31 entrées concordent avec V599 : 19 Rust, deux lecteurs Python et dix JSON ; avec en_GB, 32 identités vérifiées. Annie_passive.rs est un ajout ciblé au corpus initial, identifié dans additional_current_inputs.json. 39 fenêtres dont 32 communes, quatre récapitulatif, AnniePet1–118, constructeur265–346 et compteurAnnie1–25. 30 ancres dont 29 entry_boundary_only/provides_feature_consumer=false ; renvois des branches résolus.

Learn/Cast/CastAt refusent Malzahar. Attaques, Garen/Trundle, dégâts, mitigation, vol de vie et récapitulatif sont des acquis conservés. Pyromania est un vrai compteur limité à Annie : Q à l’impact, W/R à la libération, E à l’acceptation ; consommation selon caractère offensif. Il ne qualifie pas les événements de comptage de Malzahar.

Le constructeur générique exige une définition, initialise pet=None et ne fournit pas un calcul de niveau du propriétaire : le niveau moyen calculé reste inutilisé pour cette composition. Le catalogue Map10 inspecté ne contient pas de Voidling ; le chargeur insère explicitement annietibbers. Ce constat n’est pas un audit global d’assets.

Unit.pet est de type AnniePet. Tibbers dispose de création, propriétaire, ordres, régénération, suivi/téléportation et expiration propres. Leur présence ne produit pas une créature Malzahar ; une future réutilisation exige isolation, sans défaut de contrôle Malzahar reproduit ici. Recherche Malzahar/Voidling/AlZahar sur 19 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des 1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer quatre lancers éligibles, création réelle, statistiques, âge et phases. Observé : 112/112 contrôles documentaires, 119/119 cohérences du même agent, quatre productions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V599 hérité : deux parties publiques Map10 Malzahar/Annie, base puis épée1036+10AD. AD54.70000076293945 puis64.69999694824219 ; six impacts physiques et six identités de projectile du propriétaire, résidu mitigation/régénération inférieur à0,002. L’épée modifie le champion, sans vérifier l’héritage d’une créature absente.

246 refus atomiques préservent les snapshots : joueur inconnu, auto-ciblage, slot invalide et Learn/Cast/CastAt QWER. Aucun sort Malzahar accepté ni consommation de Mana. Mana plafonné325.6000061035156, rangs/recharges nuls, champions vivants niveau1, sans contrôle, mort ou victoire. Aucun pet ni unité Voidling observé.

Deux attentes631ticks après Stop, soit1262 ; offsets209/210/211,419/420/421,629/630/631 encadrent localement7/14/21secondes à30Hz. Sans quatre sorts acceptés, création ou horloge de créature armée, ces attentes ne vérifient ni croissance, ni frénésie, ni expiration. Stop ne constitue pas une naissance de créature. L’IA, les attaques de créature et leurs interactions restent non exercées.

Exécutable identifié uniquement en données : 6057472 octets, SHA256 9de2b41239abe6ede81fa6941f71ff40386a8488c88548a5054f8c125e6b41f9. BUILD/RUN0 hérités, sans accès actuel ; chaîne/lock/1158 entrées non requalifiés. Anciens échecs conservés ; aucun défaut produit corrigé.

## 5. Écarts et conclusions ouvertes

Restent admission/compteur/éligibilité/ordre, invocation/placement/isolation, bases/niveau/AD bonus/capture, âges/phases, IA/contrôle/déplacement/cadence/cibles, dégâts/procs/attribution, coexistence/lifecycle et intégration/présentation.

Question propre OLU-8683670f-b296-5504-807a-3358e7041e2e distincte de SOURCE OLU-9cd25feb-d350-5c4d-a8ec-78f1c4b54e72. Dépendances/propriétaires conservés, aucune inconnue fermée. V564/BattleTraining et anciens échecs non corrigés.

## 6. Corrections et reprise

36 fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-MALZAHAR-VOIDLING-, suffixe -01 : METADATA, LUA, SPELL-ADMISSION, INITIAL-COUNTER, CAST-ELIGIBILITY, COUNT-BOUNDARY, READY-FOURTH, REFUSAL-ATOMICITY, COUNTER-ORDER, SPAWN-IDENTITY, SPAWN-PLACEMENT, PET-ISOLATION, STATS-BASE, LEVEL-SCALING, BONUS-AD, STAT-SAMPLING, AGE7-GROW, AGE14-FRENZY, AGE21-EXPIRY, PHASE-COMPOSITION, AI-VISIONS, UNCONTROLLABLE, PATH-TARGETLOSS, ATTACK-CADENCE, TARGET-CLASSES, DAMAGE-DEFENSES, PROCS-HEALING, ATTRIBUTION-REWARDS, MULTI-VOIDLING, COUNTER-LIFECYCLE, PET-LIFECYCLE, TICK-ORDER, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche existante liée, prérequis, travail, critère positif et condition de reprise distincts.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Scénarios futurs avec quatre vrais sorts publics, créature identifiée, statistiques et âge depuis naissance, phases/IA/expiration observées ; aucune injection de compteur ou pet pour déclarer la fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_malzahar_passive_simulation_contract_20261107. Date Europe/Zurich, reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2490 entrées préexistantes conservées. Prochain Maokai depuis122 paires : 64 candidats hors58 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, aucune installation/migration.
