# V1507 — Miss Fortune : contrat connu de Strut

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-MISSFORTUNE-PASSIF-SIMULATION-CONTRAT-01 ; tâche CH-MissFortune-PASSIF-SIMULATION-CONTRAT ; exigence OLF-a6790d5b-5f6b-59f4-9e5f-bfce5e9a96af ; parent SYS-01.2-02. Audit de 32 branches connues. SOURCE reste a_qualifier ; phase D06 et six prérequis conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB ; date littérale 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/missfortune-passive-strut-links-v602.json du 26 octobre 2026 : 1405571 octets, SHA256 5b2dd4979d4a5411cf20b0651fc715c4ce691abb71046f8cefe5e047d6c6d4cb. Rapport FIDELITY_MISSFORTUNE_PASSIVE_STRUT_LINKS_V602.md : 19726 octets, SHA256 fb348695541cee3726956ec7a5f2e99839c12de021f529d9b0fc95c4ed65aafd. Le candidat du cache correspond au fichier actuel.

62 identités natives, 25 références communautaires séparées, 13 preloads. 27 Lua parcourus historiquement : 18 initialisations littérales, 45 globals, aucun prototype enfant et neuf limites NEWTABLE. Ces limites ne prouvent pas une corruption. CharScript natif/communautaire vide, sans absence globale de serveur déduite.

Description4233 : après cinq secondes sans être attaquée, bonus25 de déplacement puis +8 par seconde, plafond70. Buff2291 parle d’impact en combat ; cooldown2287 de dégâts reçus. Attaque, impact et dégâts ne sont pas automatiquement équivalents. Dix clés en_GB présentes/non vides ; neuf bindings BuffData sur huit clés distinctes, Strut et Stacks partageant leur tooltip sans fusion d’identités.

Vitesse de base325 et icône MissFortune_Strut ; Passive1LuaName=Draw a Bead reste alias historique, sans règle Tristana adoptée. Six niveaux, Passive1Desc et trois descriptions de progression absents, sans défaut inventé. Strut, Stacks et cooldown espacé sont distincts ; icône grisée du debuff et NonDispellable conservés. PersistsThroughDeath sur Strut ne qualifie pas le timer au respawn.

MissFortunePassive/PassiveStack sont Impure Shots W, avec icônes propres et IsDeathRecapSource sur Passive : ils ne représentent pas Strut. Leurs paramètres16s/50mana/rayon210/portée600/coefficient0,05000000074505806 restent contexte W. Douze lignes DDF, une non vide BulletTime f1=0,35ADbonus : aucune formule Strut déduite. Six chemins candidats absents seulement. Preloads et particules ne prouvent ni invocation, ni rendu/audio. Aucun nouvel accès D:, F-work ou EXE.

## 3. Consommateurs réels

28 entrées concordent avec V602 : 19 Rust, deux lecteurs Python et sept JSON ; avec en_GB, 29 identités vérifiées. 40 fenêtres dont32 communes, quatre récapitulatif, mouvement1–82, occupation517–558/635–785 et AnnieQ45–94. 26 ancres dont25 entry_boundary_only/provides_feature_consumer=false. Recherche MissFortune/Strut sur19 Rust : zéro occurrence, sans absence globale ni relecture des1158 dépendances revendiquée.

movement_speed combine base/objets, Garen, Heal, relique, Trundle, ralentissements et traversée de spin. Les caps locaux220/415/490 et ratios0,5/0,8/0,5 restent reconstruction, historical_qualification=false. stats.move_speed appelle exactement movement_speed : valeurs concordantes, pas deux producteurs indépendants.

advance_allied_motion consomme vitesse/30, vérifie les segments et committe la position. fit_step ajuste le budget flottant ; ce constat ne corrige ni ne requalifie V564. Dégâts Annie, mitigation, régénération et récapitulatif existent sans producteur Strut démontré. Learn/Cast/CastAt refusent Miss Fortune ; ces refus ne suffisent pas à expliquer l’absence de bonus pendant les attentes réellement exercées.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer activation, montée, plafond, impact/dégâts, retrait actif et réarmement. Observé : 105/105 contrôles documentaires et 117/117 cohérences du même agent. Quatre producteurs journalisés réussissent. Une préparation locale a échoué sur une parenthèse avant création du script ; original conservé, correction syntaxique seule dans qualify_missfortune_coherence_syntax_20261107.py, preuve coherence_preparation_qualification.json. Aucun nouveau build, test Rust, jeu, REA ou capture.

V602 hérité : deux parties publiques Map10 MissFortune/Annie, base puis bottes1001+25. Vitesse325/350 constante, aucun bonus Strut. Chaque cas : deux fenêtres331ticks avant/après un Q Annie réellement reçu, quatre trajets mesurés. Total1324ticks d’attente, deux Q raw80/coût60, huit trajets, 216 pas dont208 complets et huit finaux partiels. Les destinations sont atteintes ; budget vitesse/30 tolérance0,003 et dommages/régénération résidu inférieur à0,002.

21 offsets par fenêtre :149/150/151 puis chaque seconde jusqu’à329/330/331, autour de5 à11secondes à30Hz. Ils ne fixent pas l’ordre natif de première incrémentation ou du plafond. Le dégât reçu est observé ; aucun bonus n’était actif, donc retrait et réarmement restent non qualifiés.

54 refus atomiques préservent les snapshots ; mana275.8399963378906 pleine, rangs/recharges nuls, champions vivants niveau1, sans victoire/mort. Aucun état/timer injecté. Exécutable identifié seulement en données : 6057472 octets, SHA256 262a20e7cb4e690fa49c48767b82643cc83f83e52ab4e96efc3a9721774c197b. BUILD/RUN0 hérités ; chaîne/lock/1158 entrées non requalifiés. Deux anciens échecs V602, générateur et fichier absent, restent conservés comme échecs.

## 5. Écarts et conclusions ouvertes

Origine/délai/incréments/plafond, événements/catégories de reset, retrait actif/réarmement, arrondis/caps/modificateurs, mouvement/contrôles/actions, coexistence/lifecycle et projection/présentation restent ouverts.

Propre OLU-2b9d13b4-6e97-55b7-96d5-ca8711cdb577 distincte de SOURCE OLU-f8d1b519-bdbf-5a1d-b34a-1e797c13ab6e. Dépendances/propriétaires conservés, aucune inconnue fermée. V564/BattleTraining et anciens échecs non corrigés.

## 6. Corrections et reprise

32 fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-MISSFORTUNE-STRUT-, suffixe -01 : METADATA, W-SEPARATION, LUA, INITIAL-STATE, DELAY-FIVE, FIRST-INCREMENT, BASE-BONUS25, RAMP-EIGHT, CAP-SEVENTY, RESET-EVENTS, RESET-SOURCES, ZERO-SHIELD-IMMUNE, ACTIVE-REMOVAL, REARM, TICK-ORDER, ITEM-STACKING, SLOW-STACKING, CAP-ORDER, STAT-CHANGES, ACTUAL-MOTION, STATIONARY-BLOCKED, DASH-TELEPORT, CONTROL, SPELL-ADMISSION, ATTACK-CAST-INTERACTION, REFUSAL-ATOMICITY, MULTI-OWNER, LIFECYCLE, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Chaque fiche possède objectif unique, tâche existante liée, prérequis, travail, critère positif et reprise.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios publics avec vrai bonus actif avant reset, sans injection pour déclarer fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_missfortune_passive_simulation_contract_20261107. Date Europe/Zurich, reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2493 entrées préexistantes conservées. Prochain MonkeyKing depuis122 paires :61 candidats hors61 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et ajouts CURRENT/HANDOFF avec sauvegarde et relecture. Goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, installation ou migration.
