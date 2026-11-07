# V1503 — Malphite : contrat connu de Granite Shield

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-MALPHITE-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Malphite-PASSIF-SIMULATION-CONTRAT, exigence OLF-d15b205f-7859-5b81-aa1c-70eec5d564a9, parent SYS-01.2-02. Audit de 32 branches connues, consolidant V548 et V598 sans les republier. SOURCE reste a_qualifier ; phase D06 et six prérequis conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB, date littérale 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus. Catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçus docs/reference_requirement_trace_sources/ : malphite-passive-granite-shield-links-v598.json, 1285759 octets, SHA256 f74841ed9134cce9e0bcd2f707e6f6a36eb04c244d883a7bf4eef2ce228be4c4 ; malphite-passive-shield-links-v548.json, 519892 octets, SHA256 10a7106e12be58df8e8c0a71adfd3d7a768352f9496963494f9b784d3cecd6da.

Rapports FIDELITY_MALPHITE_PASSIVE_GRANITE_SHIELD_LINKS_V598.md, 17358 octets, SHA256 7ee86169615af6b41fed14011c1ed8c912a27e1756f356178bcabaace218b7bf ; FIDELITY_MALPHITE_PASSIVE_SHIELD_LINKS_V548.md, 12994 octets, SHA256 445c46e69a1b567c7da61ca9a53b802178e5aa55131941e894e8a6bb551414ed. Le cache ne proposait que V548 ; les deux rapports existants sont conservés.

V598 : 39 identités natives, 12 preloads, 13 Lua structurellement parcourus, sans prototype enfant : quatre initialisations littérales, dix globals, neuf limites NEWTABLE. Limites du lecteur, sans corruption déduite. 17 sources communautaires distinctes dans 22 liens conservés, dont cinq reprises V548 ; aucune suppression de registre.

Huit clés en_GB vérifiées, toutes présentes. Bindings directs : recharge2251, effet2255, Shield2256, Q2599, description4228 et nom. Description : 10 % des PV maximum, dix secondes sans être touché. Shield : ne pas subir de dégâts, @f1@/@f2@ non résolus. La distinction coup reçu/dégâts effectifs reste ouverte. Textes2254/2630 conservés comme contexte V548 sans binding effectif démontré.

Shield et BeenHit gardent icônes normale/grise et noms distincts ; Removal conserve effet vide/persistance/non-dissipation, sans politique de respawn déduite. ShieldEffect : constantes priorité3/Skin06 et NEWTABLEpc8, pas affectations ou priorité exécutée. Passive1=9, texte Jax, mana40/60/80% et niveaux3/7/11/15/absent/absent restent sans adoption. Quatre DDF Landslide (armure0.3, puissance0.2, deux vides), sans formule de bouclier. Six chemins candidats absents seulement. Particule leona_basicattack_hit.troy et cycles de preloads restent dépendances, sans rendu accepté. Aucun nouvel accès D:, F-work ou EXE ni décodage natif.

## 3. Consommateurs réels

27 entrées concordent avec V598 : 17 Rust, deux lecteurs Python et huit JSON ; avec en_GB, 28 identités vérifiées. 38 fenêtres dont 32 communes, quatre récapitulatif, AnnieQ45–94 et shop314–322. 42 ancres dont 41 entry_boundary_only/provides_feature_consumer=false ; les 15 ancres V548 sont incluses, sans double promotion.

grant_shield valide montant/tag/durée/cible et remplace le même tag ; advance_shields nettoie ; absorb_shields consomme d’abord les expirations proches. Ce sont des acquis génériques, sans producteur Malphite. Le tri local par expiration ne démontre pas la politique native ; la constante 3 reste non qualifiée. apply_damage expose dégâts bruts, après mitigation, absorption et perte de vie : leur sélection pour le reset reste à qualifier.

refresh_item_caps actualise maxPV et plafonne vie/mana, sans recalcul de bouclier dans ce corps inspecté. AnnieQ fournit les dégâts magiques entrants acceptés. Attaques, Garen/Trundle, mitigation, régénération et récapitulatif restent conservés. Learn/Cast/CastAt refusent Malphite ; cela n’explique pas à lui seul l’absence du passif naturel. Recherche Malphite/Granite sur 17 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des 1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer bouclier naturel, événement diagnostique fourni, absorption, reset et recharge. Observé : 120/120 contrôles documentaires, 128/128 cohérences du même agent. Aucun nouveau build, test Rust, jeu, REA ou capture.

V598 hérité : deux parties publiques Map10 base/Rubis1028+150PV. MaxPV574.2000122070312/724.2000122070312 ; références théoriques10%57.42000198364258/72.42000579833984, sans bouclier généré. Six impacts physiques Annie→Malphite et deux Q acceptés80bruts/60mana, tolérance mitigation/régénération0,002. 102 refus atomiques Malphite, snapshots inchangés. 602 ticks d’attente depuis le dernier impact Q, offsets299/300/301, listes vides ; aucun grant artificiel dans ces cas. Malphite vivant niveau1, mana plafonné282.20001220703125, rangs/recharges nuls. Dégâts nuls/absorbés/DoT/reset exact non qualifiés.

V548 hérité : trois cas, neuf fenêtres301ticks avec vie non décroissante et bouclier nul ; ces échantillons ne tracent pas exhaustivement les événements de dégâts. Dans le troisième cas seulement, grant diagnostique57.42000198364258 au tick1418, durée600, expiration déclarée2018. Impacts1429/1477 : absorption45.11301803588867 puis12.306983947753906, débordement32.8060302734375. Absorption générique établie ; activation native et expiration2018 non testées. Neuf refus Attack et cinq refus grant atomiques conservés. Les600ticks ne sont pas une durée native.

Binaires identifiés uniquement en données : V598 : 6056960 octets, SHA256 30c15bba6e5e23530c89688d5e21e1e0476e0f4137a95b47436fae94c2e6e236 ; V548 : 6023680 octets, SHA256 e2c25e99023107e7a5a8a543972f15c9385ddcf9e23a1c93631386a874c9a39f. BUILD/RUN0 hérités, sans accès actuel ; chaînes/locks/dépendances non requalifiés. Échec actuel contract01 de comptage lignes/sources conservé, contract02 qualifié réussi ; aucun défaut produit corrigé.

## 5. Écarts et conclusions ouvertes

Restent activation/producteur, capacité/arrondi/f1f2/PV variables, événement hit/dégât et sources/reset/absorption, recharge/remplissage/rupture/expiration, types/défenses/priorité, refus/procs/W/ordre/niveaux/lifecycle, attribution/intégration/présentation.

Question propre OLU-ae4cf334-7460-567d-8573-5b10e0d47667 distincte de SOURCE OLU-8dac155d-6819-563a-af30-6e9c0780bab5. Dépendances/propriétaires conservés, aucune inconnue fermée. V564/BattleTraining et anciens échecs non corrigés.

## 6. Corrections et reprise

32 fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-MALPHITE-GRANITE-, suffixe -01 : METADATA-ALIASES, LUA-EFFECT, INITIAL-ACTIVATION, NATURAL-PRODUCER, CAPACITY10, CAPACITY-ROUNDING, DYNAMIC-F1F2, MAXHP-CHANGES, HIT-VS-DAMAGE, SOURCE-ELIGIBILITY, ZERO-DAMAGE, ABSORBED-DAMAGE, TIMER10, REPEATED-RESET, PARTIAL-RESTORE, BREAK-OVERFLOW, SHIELD-EXPIRY, DAMAGE-KINDS, MITIGATION, STACKING-PRIORITY, REFRESH-ATOMICITY, CRITICAL-ITEMS, SPELL-ADMISSION, W-ARMOR, TICK-ORDER, LEVELS, LIFECYCLE, ATTRIBUTION-RECAP, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche liée, prérequis, travail, critère positif et condition de reprise distincts.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios avec bouclier naturellement produit, vraie interruption, dix secondes, absorption/priorité/PV variables ; aucun grant fourni pour déclarer le passif fidèle. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_malphite_passive_simulation_contract_20261107. Date Europe/Zurich, reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2489 entrées préexistantes conservées. Prochain Malzahar depuis122 paires : 65 candidats hors57 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, aucune installation/migration.
