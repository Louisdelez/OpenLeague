# V1499 — Lissandra : contrat connu d’Iceborn

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-LISSANDRA-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Lissandra-PASSIF-SIMULATION-CONTRAT, exigence OLF-6a9af42f-180e-5928-ab3a-789c23036ce6, parent SYS-01.2-02. Audit borné de25 branches connues, distinct de la résolution de toutes les politiques historiques. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315, EUW/en_GB, date littérale2014-11-17 à17:46:45 ; fuseau et déploiement inconnus, catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/lissandra-passive-iceborn-links-v594.json du26 octobre2026 :1110969 octets, SHA256 42346eb013b50a07b702444a4c54ae281bce98726c06b7961cd9b0085101e1de. Rapport FIDELITY_LISSANDRA_PASSIVE_ICEBORN_LINKS_V594.md :15968 octets, SHA256 09d1764783fac8e154e32194e21ffd7eb9a4361adaa286212464ba817905d8f3. Cache de rapports vide, MD existant retrouvé au chemin explicite ; aucune fausse absence d’asset ou modification de cache.

32 identités natives,16 références communautaires distinctes, huit preloads sélectionnés. Onze Lua entièrement parsés historiquement, zéro prototype enfant : cinq initialisations littérales et17 globals, six limites NEWTABLE Ready6/Q6/W8/E16/R8/WFrozen14. Limites du lecteur, sans corruption ou absence de callbacks déduite. CharScript communautaire vide, sans autorité du serveur Riot.

Onze clés en_GB vérifiées : dix présentes, PassiveBuff absent. Description4222 et passif2216 lient prochaine capacité sans Mana toutes les18 secondes et réduction1 seconde quand une capacité de Lissandra gêne le déplacement d’un ennemi ; contrôles issus d’objets explicitement exclus. Ready2217 décrit la prochaine capacité gratuite. Le fichier PassiveBuff existe, sa clé exacte absente n’est pas remplacée par Ready. Neuf liaisons de buffs dont huit résolues ; Q/W/E/R et ralentissements restent du contexte, sans politique événementielle serveur démontrée.

Passive et PassiveBuff gardent leurs noms distincts et PersistsThroughDeath ; ces littéraux ne définissent pas disponibilité/recharge après mort. LissandraSlow conserve BuffName=Slow, Chronokeeper_Timestop.dds et GLOBAL_SLOW.TROY. RSlow déclare DoesntTriggerSpellCasts=true, IsDamagingSpell=true et SpellDamageRatio1 ; aucun callback de réduction déduit.

BaseMP304 ; six niveaux passifs absents, sans défaut inventé.24 lignes DDF vides pour les capacités, sans formule numérique déduite. Cinq chemins candidats absents limités ; fichiers présents conservés. Ready/Start sont des dépendances visuelles déclarées, pas du rendu accepté. Aucun nouvel accès D:/F-work/EXE ni décodage natif.

## 3. Consommateurs réels

29 entrées concordent avec V594 :19 Rust, deux lecteurs Python, huit JSON. Avec le miroir en_GB,30 identités gardées.36 fenêtres dont32 communes réutilisées ; ajouts cooldown1–14, slows1–82, stuns1–38 et movement1–81.25 ancres enregistrées dont24 entry_boundary_only/provides_feature_consumer=false ; renvois de branches résolus.

Learn/Cast/CastAt refusent Lissandra. Attaques à distance, stats/objets, mitigation et régénération expliquent les contrôles ordinaires. cooldown::ticks applique la CDR ordinaire avec borne et minimum locaux ; cette fonction ne prouve pas un délai Iceborn.

prepare_slow et commit_slow_for_surviving_target sont des récepteurs génériques, avec validation, durée modifiée et application conditionnée à la survie/identité examinée. grant_stun a sa source, ses exclusions et ses contributions. movement utilise les ralentissements présents. Ces acquis ne produisent pas un événement de capacité Lissandra ni une réduction passive.

Entrée Slow : tag/fraction/expiration, sans propriétaire ni type capacité/objet ; entrée Stun : source mais pas catégorie de provenance. Ces entrées seules ne suffisent pas pour Iceborn. Qualification à faire au producteur/callsite approprié ; aucune absence globale de provenance ni défaillance reproduite revendiquée. Correction CC-PROVENANCE dédiée.

Recherche Lissandra/Iceborn sur19 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer capacité acceptée gratuite, état prêt, timer armé, contrôle admissible et réduction. Observé :92/92 contrôles documentaires,109/109 cohérences du même agent, quatre productions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V594 hérité : deux parties publiques Map10 Lissandra/Annie, base puis Codex3108 donnant30AP et10 % CDR. Trois attaques à distance par cas puis Stop,541 ticks d’attente ; six impacts physiques avec projectile Lissandra→Annie témoin non critique. Mitigation/régénération conformes dans la tolérance0,002, participants vivants niveau1, sans mort/fin de partie.

Avant attaques puis aux offsets539/540/541 après Stop, quatre séquences Learn/Cast/CastAt QWER :102 refus atomiques au total avec autres contrôles invalides. Snapshots inchangés, rangs et recharges nuls. Pendant les 1 082 ticks d’attente cumulés : mana toujours plafonné à304, aucun ralentissement/stun, aucun sort accepté ni coût dépensé.

Ces frontières encadrent18 secondes à30Hz locaux. Stop n’est pas une origine prouvée de recharge passive. Aucun état prêt consommé, timer armé ou contrôle de capacité appliqué ; attendre ne mesure donc pas un cycle Iceborn. Mana inchangé sur refus ne prouve pas la gratuité. Les statistiques Codex ne qualifient pas l’effet de CDR ordinaire sur le passif.

L’exclusion native vise les contrôles de déplacement provenant d’objets ; elle ne tranche pas, à elle seule, l’effet d’un bonus CDR d’objet. Les deux questions restent distinctes. Snapshots locaux, transport/HUD/animations/audio non qualifiés.

Exécutable V594 identifié uniquement en données :6034432 octets, SHA256 87969cf38558b5209af8283e55e6a9ad363c5b447f5f1630e9ad3ff6d1593205. BUILD/RUN0 hérités, sans accès/lancement actuel ; toolchain/lock/1158 entrées non requalifiés. Échecs antérieurs conservés.

## 5. Écarts et conclusions ouvertes

Restent états/texte Buff, tables Lua, admission, disponibilité initiale, consommation gratuite/mana insuffisant/refus, origine et délai18 secondes, provenance/admissibilité/multiplicité des contrôles, réduction1 seconde/plancher, exclusion objets et CDR ordinaire, concurrence/ordre/niveaux/lifecycle, intégration, réseau et présentation.

Question propre OLU-dbfb0872-bcba-5554-aec5-661ea46782dd distincte de SOURCE OLU-bc32c17d-6edc-581c-8946-c8d74b20ffbf. Dépendances/propriétaires conservés, aucune inconnue fermée ; V564/BattleTraining non corrigés.

## 6. Corrections et reprise

25 fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-LISSANDRA-ICEBORN-, suffixe -01 : METADATA-STATE, LUA-METADATA, SPELL-ADMISSION, INITIAL-READY, FREECAST-CONSUMPTION, INSUFFICIENT-MANA, REFUSAL-ATOMICITY, TIMER-START, TIMER18-BOUNDARY, CC-PROVENANCE, CC-ELIGIBILITY, CC-REFRESH, CC-MULTITARGET, ONESECOND-REDUCTION, FLOOR-READY, ITEM-EXCLUSION, ITEM-CDR, MULTIPLE-EVENTS, TICK-ORDER, RANKS-LEVELS, LIFECYCLE, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche liée, prérequis, travail, critère positif distinct et condition de reprise pour chacune.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios : vrais sorts publics gratuits avec faible Mana, timer démarré par l’événement qualifié, contrôle effectif de capacité avec provenance, réduction et refus ; contrôles objets/CDR séparés. Pas d’injection de prêt/timer/mana pour déclarer la fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_lissandra_passive_simulation_contract_20261106. Unité démarrée le6 novembre2026 UTC ; horodatages UTC conservés malgré le passage au7 en Europe/Zurich. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2485 entrées groupées préexistantes conservées. Prochain Lucian depuis122 paires ;69 candidats hors53 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Reçus et32 fenêtres communes réutilisés, lectures groupées ; aucun gain temporel mesuré, aucune installation/migration.
