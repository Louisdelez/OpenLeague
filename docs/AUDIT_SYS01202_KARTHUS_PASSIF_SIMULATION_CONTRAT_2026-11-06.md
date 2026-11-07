# V1489 — Karthus : contrat connu de Death Defied

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-KARTHUS-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Karthus-PASSIF-SIMULATION-CONTRAT, exigence OLF-01e1c023-6caa-5873-9c71-b077072aed87, parent SYS-01.2-02. Audit borné de21 branches connues avec leurs constats de cohérence, distincts des corrections proposées. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315, EUW/en_GB, date littérale2014-11-17 à17:46:45 ; fuseau et déploiement inconnus, catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/karthus-passive-death_defied-links-v584.json du26 octobre2026 :1028232 octets, SHA256 79e51616d286e7e5a43e6ad19f44c2fae734423322becb90de5899e6fb5d225e. Rapport FIDELITY_KARTHUS_PASSIVE_DEATH_DEFIED_LINKS_V584.md :15177 octets, SHA256 695f0b80ff78c3c0419f4503cca0635daeedd00f1096e7a647381b821fdf9f2c. Liste de rapports vide dans le cache, mais MD existant retrouvé au chemin explicite et épinglé ; aucun cache modifié ni asset déclaré absent sur cette seule base.

Vingt-sept identités natives ordinaires aux rôles distincts, neuf références communautaires séparées, huit preloads. Huit Lua entièrement parsés historiquement, sans prototype enfant, sept initialisations littérales et29 globals. FallenOne2 rencontre NEWTABLE pc12 : limite du lecteur, sans corruption établie. Aucune exécution serveur ; CharScript vide ne démontre pas la mécanique.

Passive1LuaName=Death Defied, avec espaces, icône Karthus_Passive.dds. Description directement liée ligne4211 : lancement des sorts mort pendant sept secondes. Sept clés en_GB vérifiées, six présentes. Tooltip1823 : après dégâts mortels, lancement gratuit pendant sept secondes ; buff1824 : esprit continuant de lancer des sorts. game_buff_tooltip_Defile manque, sans remplacement par la clé distincte KarthusDefile présente. Six champs de niveaux absents.

Buff exact Death Defied Buff, persistant/non dissipable ; ces flags ne prouvent pas les callbacks. Six variantes mortes ont leurs triplets identifiés : LayWasteDeadA1/A2/A3, WallOfPain2, Defile2, FallenOne2. SpellToggleSlot=3 de Defile2 ne devient pas automatiquement R. Preloads avatar/root/restauration des sorts vivants restent des dépendances, sans gameplay ou rendu accepté.

Cinq chemins candidats absents dans l’inspection retenue, dont DDF et KarthusDeathDefied exact dans deux répertoires. Recherche ciblée, sans absence universelle ni règle zéro inventée ; alias de preload non résolu. Deux ressources NightmareBot exclues ; Lich_Defied.dds ne remplace pas l’icône ordinaire. Aucun nouvel accès D:/F-work/EXE ni décodage natif.

## 3. Consommateurs réels

Vingt-huit entrées concordent avec V584 : seize Rust, deux lecteurs Python, dix JSON. Avec le miroir en_GB,29 identités gardées. Trente-trois fenêtres dont32 communes réutilisées, plus champion_kills.rs:1. Vingt-deux ancres enregistrées, dont21 entry_boundary_only/provides_feature_consumer=false ; tous les renvois des branches aboutissent aux fenêtres contrôlées.

command refuse health<=0 ; cast et cast_at possèdent aussi leurs gardes de mort, puis refusent Karthus vivant. next_rank refuse sa progression. Un simple contournement de command ne suffirait donc pas à réaliser le contrat.

apply_damage efface les effets et inscrit immédiatement tick+base_death_ticks ; le crédit de mort ordinaire est réel. lifecycle restaure vie/mana, position et effets à l’échéance. regeneration ne traite que les vivants. Le délai local niveau1 vaut16 secondes, soit480 ticks à30Hz, distinct des sept secondes natives. Ces mécanismes partiels existants restent conservés ; aucun état spirituel ou lancement gratuit Karthus identifié dans les chemins inspectés.

Recherche littérale Karthus/DeathDefied sur16 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer transition spirituelle, sorts gratuits, crédit de mort et réapparition. Observé :93/93 contrôles documentaires et99/99 cohérences du même agent. Aucun nouveau build, test Rust, jeu, REA ou capture.

V584 hérité : deux parties publiques, Karthus victime/Annie attaquante. Base516PV contre Rubis1028 à400or/+150PV, soit666PV. Trente-et-un impacts avec projectiles Annie→Karthus témoins, deux morts, chaque partie créditant une seule première élimination à400 ; victime niveau1.

164 refus sans mutation, dont110 pendant la mort aux offsets0/1/209/210/211. Cast QWER, CastAt QWER, Move/Attack/Stop refusés mort ; sorts et apprentissage également refusés vivant. Ces offsets encadrent210 ticks sur l’horloge locale, sans qualifier l’ordre d’expiration natif.

960 ticks observés après mort ; deux réapparitions ordinaires après480 ticks. Jusqu’à479, vie nulle, position/mana/échéance stables ; à480, retour base et ressources restaurées, déplacement de nouveau accepté. Douze refus de sorts/apprentissage vérifiés après réapparition. Mana stable pendant un refus ne prouve pas le coût gratuit d’un lancement accepté : aucun sort postmortem admis.

Exécutable V584 identifié uniquement en données :6031872 octets, SHA256 f527d4c1a50cc57602770e26876eb94c52cde364f052ca3a7913d8d3cd1b4a45. Aucun accès/lancement ; verrou, toolchain et1158 entrées non revalidés.

Cinq opérations documentaires, quatre réussies et une échouée : la première cohérence comparait la question SOURCE à celle du contrat. Assertion erronée conservée, qualification séparée puis succès ; questions et propriétaires n’avaient pas été modifiés. Ancien refus de préparation V584 sur mention historique de Karma et échecs antérieurs conservés, non rejoués.

## 5. Écarts et conclusions ouvertes

Restent état spirituel, transition létale, admission QWER/variantes, coûts/délais, durée et expiration, Defile/R, actions et cibles, crédit/horloge de réapparition, restitution, lifecycle, aliases, réplication et présentation.

Question propre OLU-309d2e7c-1d38-5e87-acbb-7ce51f57231c distincte de SOURCE OLU-89343a33-4b60-592d-8207-63dfea76c9bf. Dépendances/propriétaires conservés, aucune inconnue fermée ; V564/BattleTraining non corrigés.

## 6. Corrections et reprise

21 fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-KARTHUS-DEATH-DEFIED-, suffixe -01 : ALIVE-SPELLS, SPIRIT-STATE, LETHAL-TRIGGER, DURATION, FREE-COSTS, COOLDOWNS, Q-VARIANTS, W-VARIANT, E-TOGGLE, R-CHANNEL, ACTION-POLICY, TARGET-POLICY, DEATH-CREDIT, RESPAWN-CLOCK, RESTORE-EXIT, LIFECYCLE, SOURCE-ALIASES, BOT-SEPARATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche liée, prérequis, travail, fin distincte et reprise pour chacune.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas supporté indispensable non couvert. Premier scénario fonctionnel futur : vraie transition létale, sorts postmortem acceptés et coûts mesurés, puis expiration/réapparition. Aucune correction fonctionnelle enregistrée ou implémentée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_karthus_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2475 entrées groupées préexistantes conservées. Prochain Kassadin depuis122 paires ;79 candidats hors43 unités nommées, sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Aucune installation/migration ; aucun gain temporel mesuré.
