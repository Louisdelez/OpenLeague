# V1488 — Karma : contrat connu de Gathering Fire

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-KARMA-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Karma-PASSIF-SIMULATION-CONTRAT, exigence OLF-861c6201-f26b-580e-bc53-83436bb6b75a, parent SYS-01.2-02. Audit borné de dix-huit branches connues et des consommateurs sélectionnés. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. La tâche complète, la fonctionnalité et le goal restent ouverts.

Référence PUBLIC 4.20.0.315, EUW/en_GB, date littérale 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus, catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/karma-passive-gathering_fire-links-v583.json du 26 octobre 2026 : 906451 octets, SHA256 878136aa8f843898c4e7068b6e1997e305f3725616a13f1a91151686934e362d. Rapport FIDELITY_KARMA_PASSIVE_GATHERING_FIRE_LINKS_V583.md : 13891 octets, SHA256 f570122a63b78d43d5c1292d8ffbeafe67082a2822e4c1a1bbca6923b11445fb. Liste des rapports vide dans le cache, mais rapport existant retrouvé au chemin explicite et épinglé ; aucun cache modifié ni asset déclaré manquant.

Douze identités natives aux rôles distincts, huit références communautaires séparées, trois preloads. Quatre Lua entièrement parsés historiquement, sans prototype enfant, trois initialisations littérales et douze globals ; KarmaMantra rencontre NEWTABLE pc6. Limite du lecteur, sans corruption établie ni exécution serveur. La classe communautaire CharScriptKarma vide ne démontre pas une mécanique native.

Dix clés en_GB vérifiées. PassLev1Desc1 lie directement la description ligne4210 : dégâts de capacités aux champions ennemis, moitié d’effet pour les attaques ordinaires. Deux bindings de buffs résolus lignes2139/2145 ; valeurs numériques @f1@/@f2@ inconnues. Mantra est décrit disponible niveau1 sans point, avec amélioration de la prochaine capacité sous huit secondes. Ses délais natifs 45/42/39/36 secondes sont distincts de cette fenêtre et du remboursement.

Six champs de niveaux passifs absents. DDF28 lignes, quatre passives à liens/coefficients vides. Cooldown1=8 du passif, effets18/36/54/72 et30/60/90/120, Chakra30/25/20, anciennes descriptions HP/mana et compteur à charges restent sans liaison à f1/f2. Icône personnage Karma_Passive.dds distincte du buff KarmaInnerFlame.dds ; persistance et flags ne prouvent pas les callbacks. Aucun ancien candidat adopté automatiquement.

Preuves réutilisées, sans nouvel accès D:/F-work/EXE ni décodage natif.

## 3. Consommateurs réels

Vingt-sept entrées concordent avec V583 : dix-sept Rust, deux lecteurs Python, huit JSON. Avec le miroir en_GB, 28 identités gardées. Trente-quatre fenêtres dont32 communes réutilisées, et deux sur cooldown.rs:1 et ezreal_q.rs:190. Vingt ancres enregistrées, dont19 entry_boundary_only/provides_feature_consumer=false. Tous les renvois des branches aboutissent aux fenêtres contrôlées.

progression::next_rank refuse Karma ; la grille générique d’ultime6/11/16 ne suffit pas à Mantra. cast et cast_at refusent les sorts de Karma. Le shop et stats agrègent réellement la CDR ; cooldown::ticks applique une réduction à la création du délai, puis le cast inscrit tick+durée. Ces mécanismes partiels existants sont conservés sans être promus en Gathering Fire.

Les attaques ordinaires atteignent apply_damage par basic_attack_hit. Aucun producteur de remboursement Karma identifié dans ces chemins. refund_ezreal_q_hit possède une soustraction plafonnée au tick courant pour un autre sort : constat statique, sans adoption de sa formule ou de son plancher pour Karma. Lifecycle et snapshot sont des frontières, sans qualification du passif.

Recherche littérale Karma/GatheringFire/Mantra sur17 Rust sélectionnés : zéro occurrence. Cela complète l’inspection des consommateurs ; aucune absence globale ni relecture des1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : séparer admission de Mantra, délai armé, dégâts éligibles et remboursement. Observé : 93/93 contrôles documentaires et103/103 cohérences du même agent. Aucun nouveau build, test Rust, jeu, REA ou capture.

V583 hérité : deux cas publics Karma contre Annie, base/Codex3108. Douze impacts physiques avec projectiles source/cible témoins non critiques ; résidu AD/armure/régénération inférieur à0,002, champions vivants. CDR0/10 %, AP0/30. Trente-quatre refus sans mutation, dont Mantra sans cible avant/après attaques ;180 ticks après attaques. Niveau1, rangs et délais tous à zéro : aucun délai Mantra armé. Ces observations ne mesurent ni montant ni absence isolée de remboursement sur un délai actif.

Deux contrôles GarenQ distincts : lancements acceptés, délais240/216 ticks, deux relances refusées,180 ticks de décompte naturel. Total36 refus publics ;180 ticks Karma et180 Garen. Réduction générique à la création, pas remboursement sur hit.

Exécutable V583 identifié uniquement en données : 6049792 octets, SHA256 f0f2927e2383981625873442b3a45169212159eaf776716083d7dc2df2a7266e. Aucun accès/lancement ; toolchain, verrou et1158 entrées non revalidés.

Cinq opérations documentaires : quatre réussies, une échouée. Le premier contrôle cherchait task_ids dans les seuls en-têtes projetés ; KeyError conservé. Qualification séparée vers le paquet complet déjà retenu, puis contrôle réussi. Scripts, journaux et code1 initiaux restent exacts ; aucun échec runtime du jeu déduit. L’ancienne erreur de citation V583 et son correctif sont également conservés, non rejoués.

## 5. Écarts et conclusions ouvertes

Restent disponibilité/progression de Mantra, f1/f2, hits éligibles, catégories et propriété des dégâts, DoT/multicibles, absorption/annulation, ordre temporel/CDR, plancher, répétition, amélioration, lifecycle, réplication et présentation.

Question OLU-cf55698b-785c-5a3d-918b-df3f2afcc756, SOURCE, dépendances et propriétaires conservés. Aucune inconnue fermée ; V564 et BattleTraining non corrigés.

## 6. Corrections et reprise

Dix-huit fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-KARMA-GATHERING-FIRE-, suffixe -01 : MANTRA-ADMISSION, MANTRA-RANKS, REFUND-VALUES, ABILITY-HITS, BASIC-ATTACK-HITS, TARGET-CATEGORIES, DAMAGE-ELIGIBILITY, OWNERSHIP, TEMPORAL-ORDER, CDR-COMPOSITION, FLOOR, REPEATED-HITS, EMPOWERMENT, LEGACY-SEPARATION, LIFECYCLE, PROJECTION, PRESENTATION, VERIFICATION. Chacune possède objectif unique, tâche existante liée, prérequis, travail, fin distincte et condition de reprise. Mantra est relié aux tâches R existantes.

Reprendre sur source primaire nouvelle, consommateur modifié ou scénario supporté indispensable non couvert. Premier contrôle fonctionnel futur : vrai Mantra lancé puis hits publics, sans injecter un délai fictif. Aucune correction fonctionnelle enregistrée ou implémentée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_karma_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2474 entrées groupées préexistantes conservées. Prochain Karthus depuis122 paires ;80 candidats hors42 unités nommées, sans compte complet déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication : rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan/UI/bases, registres, produit/assets inchangés ; aucune installation/migration. Réutilisation ciblée, sans gain temporel mesuré.
