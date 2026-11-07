# V1508 — MonkeyKing / Wukong : contrat connu de Stone Skin

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-MONKEYKING-PASSIF-SIMULATION-CONTRAT-01 ; tâche CH-MonkeyKing-PASSIF-SIMULATION-CONTRAT ; exigence OLF-aeff0dbb-d0c7-52bc-ab53-c09ff88bb9ef ; parent SYS-01.2-02. Audit de 31 branches connues. SOURCE reste a_qualifier ; phase D06 et six prérequis conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB ; date littérale 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/monkeyking-passive-stone-skin-links-v603.json du 26 octobre 2026 : 1638923 octets, SHA256 6f664a92eef3bc0b451a932b915788fcfe56fa73f613d700fad9f723e562c98c. Rapport FIDELITY_MONKEYKING_PASSIVE_STONE_SKIN_LINKS_V603.md : 22744 octets, SHA256 a8af7ad45c21ebfbce4cc78568dd8f4181ebed50254dfefc516ea461c5dbc3a1. Candidat du cache et fichier actuel concordants.

64 identités natives normales, 24 références communautaires séparées et 16 preloads. 23 NightmareBotMonkeyKing exclus, sans adoption des règles Doom Wukong. 27 Lua parcourus historiquement : 17 initialisations littérales, 46 globals, aucun prototype enfant, dix limites NEWTABLE. Ces limites ne prouvent pas une corruption. CharScript natif/communautaire vide, sans absence globale de serveur déduite.

Huit clés en_GB présentes, six bindings BuffData résolus. Description4234 et nom4410 lient Stone Skin ; buff2303 indique armure/RM augmentées de @f1@ par champion ennemi proche. Montant, niveaux, rayon et éligibilité restent ouverts. Quinze champs SpellData, dont six Effect1Level, sont absents ; six niveaux passifs, Passive1Desc et trois descriptions de progression aussi. Aucun zéro inventé.

Icône du personnage MonkeyKingStoneSkin.dds ; buff Cassiopeia_PetrifyingGaze.dds. PersistsThroughDeath/NonDispellable ne qualifient pas le cycle au décès. Clones Decoy/Nimbus avec alias AkaliShadowDance et impacts Q avec Wolfman_SeverArmor restent contexte sans mécanique étrangère ni classification de clones déduite.

Seize DDF QWER : Cyclone1,2AD, CrushingBlow1,1AD, Nimbus0,8ADbonus et treize lignes vides. Ces f1 ne produisent pas celui du passif. Six chemins candidats absents seulement : les vrais CharScript sont sous Scripts, les sorts dans DATA/Spells. Preloads/particules ne prouvent ni invocation ni rendu/audio. Aucun nouvel accès D:, F-work ou EXE.

## 3. Consommateurs réels

32 entrées concordent avec V603 : 19 Rust, deux lecteurs Python et onze JSON ; avec en_GB, 33 identités vérifiées. 41 fenêtres dont32 communes, quatre récapitulatif, vision1–204, occupation517–558/635–785, AnnieQ45–94 et test d’alias521–543. 29 ancres dont28 entry_boundary_only/provides_feature_consumer=false.

Recherche MonkeyKing/StoneSkin/Wukong sur19 Rust : une occurrence, attacks.rs539. Son contexte cfg(test) refuse « wukong » comme alias de présentation ; elle ne produit pas Stone Skin. Ce constat n’est pas une absence globale ou une relecture des1158 dépendances.

stats calcule base/croissance/objets avec Garen, Annie, Exhaust et Trundle. apply_damage lit stats puis pénétration, mitigation et boucliers. Ces acquis ne produisent pas un bonus par ennemi. visible_to et les profils de vision1350 restent distincts du rayon/éligibilité du passif. La navigation avance les positions et demande un nouvel ordre après un Move arrêté, sans cause exacte des interruptions résolue. Learn/Cast/CastAt refusent MonkeyKing ; ce refus n’explique pas seul le résultat après les transitions d’ennemis réellement exercées.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer quantité par ennemi, rayon, comptage, défenses finales et dégâts reçus. Observé : 112/112 contrôles documentaires qualifiés, 121/121 cohérences du même agent. Cinq opérations journalisées : quatre réussites et contract01=1, conservé. Il attendait à tort zéro occurrence ; contract02=0 qualifie le test d’alias sans effacer le résultat. Code/logs et literal_search_qualification.json conservés. Aucun nouveau build, test Rust, jeu, REA ou capture.

V603 hérité : deux parties publiques à six joueurs, Wukong/Ahri/Ryze alliés, Annie/Ashe/Ezreal ennemis. Sans objet puis Cloth1029+15armure/NullMagic1033+25RM, prix300+500 dans825or. Défenses24.8799991607666/32.099998474121094 puis39.87999725341797/57.099998474121094 constantes, aucun bonus observé.

Séquence ennemis0/0/1/2/3/3/2/1/0, alliés0/2/2/2/2/2/2/2/2. Neuf phases30ticks par cas :18 phases,540ticks ; six impacts physiques non critiques, deux Q Annie raw80/coût60,54refus atomiques. Mitigation/régénération concordent avec résidu inférieur à0,002. Ennemis proches150/300/450, éloignés1800/1950/2100 ; proches visibles. Rayon600 strictement observationnel, sans bord natif ou invisibilité qualifiés.

28 trajets et quatre reprises publiques Stop/Move ; installation899ticks par cas, aucune reprise dans les phases suivantes. Trois essais antérieurs restent BUILD0/RUN101 : deux installations successives arrêtées sur Annie, puis installation simultanée où4/6 atteignent la tolérance1. Reprises finales ne réparent pas la navigation ; leur cause n’est pas assimilée à V564. Aucun état, dégât ou XP injecté.

Exécutable final identifié seulement en données : 6129664 octets, SHA256 f9089daa656c4671ef681d34e66f78784eb91d4aa90cc72486e1eb54d2aec27d. BUILD/RUN0 finaux hérités ; chaîne/lock/1158 entrées non requalifiés. Aucun défaut produit corrigé ici.

## 5. Écarts et conclusions ouvertes

Montant/f1/progression, rayon/métrique/bord, classes/visibilité/clones, comptage/cap/cadence, production/composition des bonus, dégâts/pénétration/arrondis, coexistence/lifecycle et projection/présentation restent ouverts. Interruptions de déplacement à diagnostiquer séparément.

Propre OLU-54b724a7-69ee-5b01-b2af-de99570a1e0d distincte de SOURCE OLU-f246e96f-adc4-588d-848f-cc3e18534bc2. Propriétaires/dépendances conservés, aucune inconnue fermée. V564/BattleTraining restent ouverts.

## 6. Corrections et reprise

31 fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-MONKEYKING-STONESKIN-, suffixe -01 : METADATA, LUA, F1-AMOUNT, LEVELS, RADIUS, COUNT-ELIGIBILITY, VISIBILITY, CLONES, COUNT-IDENTITY, COUNT-TRANSITIONS, COUNT-LIMIT, UPDATE-CADENCE, BONUS-PRODUCER, STACKING, ITEMS, PHYSICAL, MAGICAL, TRUE-DAMAGE, SHIELDS-ZERO, REDUCTIONS, ROUNDING, TICK-ORDER, SPELL-ADMISSION, QWER-CONTROL, MULTI-OWNER, LIFECYCLE, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION, NAV-DIAGNOSTIC. Objectif unique, tâche existante liée, prérequis, travail, critère positif et reprise distincts.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs scénarios avec rayon/montant sourcés, comptage et défenses réellement produits, sans injection pour déclarer fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_monkeyking_passive_simulation_contract_20261107. Date Europe/Zurich, reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2494 entrées préexistantes conservées. Prochain Mordekaiser depuis122 paires :60 candidats hors62 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et ajouts CURRENT/HANDOFF, avec sauvegarde et relecture. Goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, installation ou migration.
