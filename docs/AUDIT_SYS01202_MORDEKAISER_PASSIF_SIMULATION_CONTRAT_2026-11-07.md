# V1509 — Mordekaiser : contrat connu d’Iron Man

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-MORDEKAISER-PASSIF-SIMULATION-CONTRAT-01 ; tâche CH-Mordekaiser-PASSIF-SIMULATION-CONTRAT ; exigence OLF-767b8f21-04c5-5cc6-bf02-7032bce36d4d ; parent SYS-01.2-02. Audit de 36 branches connues. SOURCE reste a_qualifier ; phase D06 et six prérequis conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB ; date littérale 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/mordekaiser-passive-iron-man-links-v604.json du 26 octobre 2026 : 1415184 octets, SHA256 d3ca325409ff2003c210c8bccb95b4fd277321306138d52daabf965691eeae7c. Rapport FIDELITY_MORDEKAISER_PASSIVE_IRON_MAN_LINKS_V604.md : 20854 octets, SHA256 30c195136bab1aeecc369ff8a9c44aee713166649a9574e687ea71ef3f7e9d31. Candidat du cache et fichier actuel concordants.

57 identités natives, 23 références communautaires séparées et 13 preloads. 24 Lua parcourus historiquement : tous littéraux, 42 globals, aucun prototype enfant ou limite NEWTABLE. Cette lecture n’exécute pas les callbacks du serveur. CharScript natif/communautaire vide, sans absence globale de serveur déduite.

Neuf clés en_GB vérifiées : huit présentes, Jester-description absente. Six bindings BuffData résolus. Description4235 et buff2311 lient Iron Man : @f2@% des dégâts de compétence convertis en bouclier temporaire, plafond @f1@PV, décroissance3%/seconde, conversion moitié contre les sbires. f1/f2, progression, base/cadence/délai/plancher de décroissance restent ouverts. La règle sbires ne s’étend pas automatiquement à tous les non-champions.

PARType=Shield, BaseMP chaîne120.0, croissanceMP chaîne0, régénération0. PARName/Max/Start/RegenRate/Enabled, six niveaux passifs et quinze champs SpellData dont six Effect1Level sont absents. BaseMP120 ne prouve ni plafond natif ni charge initiale. Passive1Desc lie Jester introuvable ; PassLev1Desc1 lie Mordekaiser, textes mana40/60/80% conservés sans progression de bouclier déduite.

Buff IronMan avec icône Mordekaiser_IronMan et PersistsThroughDeath ; NonDispellable absent, jamais false inventé. Persistance ne qualifie pas charge au respawn. Quatre DDF Q, deux non vides :1,65/1,0ADbonus ; ces f1/f2 ne produisent pas ceux du passif. Ratio0,5 du guide et priorité10 de ChildrenOfTheGrave restent contexte R. Nautilus/Malady, Viktor/InfernalGuardianGuide et FallenAngel/TormentedSoil restent alias sans mécanique étrangère adoptée.

Six chemins candidats absents seulement ; vrais CharScript sous Scripts et IronMan sous DATA/Spells. Preloads ne prouvent ni invocation ni rendu/audio. Aucun nouvel accès D:, F-work ou EXE.

## 3. Consommateurs réels

28 entrées concordent avec V604 : 18 Rust, deux lecteurs Python et huit JSON ; avec en_GB, 29 identités vérifiées. 40 fenêtres dont32 communes, quatre récapitulatif, shop314–322, occupation517–558/635–785 et AnnieQ45–94. 33 ancres dont32 entry_boundary_only/provides_feature_consumer=false. Recherche Mordekaiser/IronMan sur18 Rust : zéro occurrence, sans absence globale ni relecture des1158 dépendances revendiquée.

join initialise mana=def.mana et une liste shields distincte, vide. uses_mana/restores_resource excluent Shield des bonus de mana et de la restauration Mana/Energy ; stats et refresh_item_caps gèrent les plafonds ordinaires. La ressource120 n’est pas un bouclier absorbant.

grant_shield existe : refus montants invalides/tag vide/durée nulle/cible inconnue ou morte, remplacement du même tag, expiration fixe. absorb_shields trie par expiration puis consomme les charges ; cet ordre générique ne qualifie pas Iron Man ou la priorité10 de R. apply_damage applique mitigation avant absorption. Ces acquis ne constituent pas le producteur de conversion et décroissance du passif.

## 4. Attendu, observé et contrôles

Attendu documentaire : séparer ressource, dégâts de compétence admissibles, génération, plafond, décroissance et absorption. Observé : 118/118 contrôles documentaires, 123/123 cohérences du même agent ; quatre productions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V604 hérité : deux parties publiques Mordekaiser/Annie, base puis Ruby1028+150PV/Sapphire1027+200mana, prix400+400 dans825or. PVmax555.4000244140625/705.4000244140625 ; ressource/plafond120 et régénération0 dans les deux cas. Six attaques ordinaires sortantes, six physiques entrantes et deux Q Annie raw80/coût60, sans absorption préalable. Mitigation/régénération : résidu inférieur à0,002.

54 refus atomiques conservent les snapshots. Aucun sort Mordekaiser accepté : le déclencheur de dégâts de compétence n’est pas exercé. Les attaques ordinaires ne prouvent pas un échec de conversion. Aucun état injecté dans ces deux cas ; champions vivants niveau1, rangs/recharges nuls. Deux fenêtres61ticks par cas,244ticks ; offsets29/30/31/59/60/61, ressource120 et shields vide. Attente sans bouclier actif ne qualifie pas sa décroissance.

Troisième simulation séparée : API autoritaire grant_shield, tags LOCAL_GENERIC/NOT_IRON_MAN ; elle est exclue de l’affirmation « sans injection » des cas publics. Sept événements invalides refusés sans mutation. Charge50/durée60 : troisième Q Annie,50absorbés puis reliquat aux PV après mitigation, ressource120. Charge80/durée30 :80inchangé aux offsets1..29, absent30/31. Expiration fixe vérifiée, aucune décroissance3% démontrée. Quatre trajets dans les cas publics, deux dans ce contrôle, sans reprise Move.

Exécutable identifié seulement en données : 6107648 octets, SHA256 f270d2f8073b114a3ca0455a5ed7d1dbf746784a34bab6048b1ca2f25f264b19. BUILD/RUN0 hérités ; chaîne/lock/1158 entrées non requalifiés. Aucun défaut produit corrigé ici.

## 5. Écarts et conclusions ouvertes

f1/f2/progression, sorts/coûts/dégâts admissibles, base/agrégation de conversion, charge/cap, base/délai/cadence/plancher de décroissance, absorption/priorités/modificateurs, lifecycle/coexistence et projection/présentation restent ouverts.

Propre OLU-e6b4c4a7-57f9-5b05-8352-04b55f407c77 distincte de SOURCE OLU-8606cc2e-411a-5709-bc61-9a760b2451a6. Propriétaires/dépendances conservés, aucune inconnue fermée. Anciens échecs Wukong, V564 et BattleTraining non requalifiés.

## 6. Corrections et reprise

36 fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-MORDEKAISER-IRONMAN-, suffixe -01 : METADATA, LUA, F1-CAP, F2-CONVERSION, LEVELS, SPELL-ADMISSION, HEALTH-COSTS, DAMAGE-ELIGIBILITY, DAMAGE-BASIS, MINION-HALF, MULTI-TARGET, PERIODIC, PROC-OWNERSHIP, CONVERSION-ORDER, INITIAL-STATE, RESOURCE-BRIDGE, CHARGE-CAP, DECAY-BASIS, DECAY-DELAY, DECAY-CADENCE, DECAY-FLOOR, SIMULTANEOUS-CHANGE, ABSORPTION, SHIELD-PRIORITY, TRUE-DAMAGE, ZERO-IMMUNITY, STAT-MODIFIERS, ITEMS, QWER-INTERACTIONS, LIFECYCLE, MULTI-OWNER, ATTRIBUTION, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche existante liée, prérequis, travail, critère positif et reprise distincts.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios publics avec vrais sorts acceptés puis génération/cap/décroissance/absorption, sans charge artificielle pour déclarer fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_mordekaiser_passive_simulation_contract_20261107. Date Europe/Zurich, reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2495 entrées préexistantes conservées. Prochain Morgana depuis122 paires :59 candidats hors63 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et ajouts CURRENT/HANDOFF, avec sauvegarde et relecture. Goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, installation ou migration.
