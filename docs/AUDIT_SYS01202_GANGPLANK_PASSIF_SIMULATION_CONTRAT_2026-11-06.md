# V1474 — Gangplank : contrat connu de Grog-Soaked Blade

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-GANGPLANK-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Gangplank-PASSIF-SIMULATION-CONTRAT, exigence OLF-f3e66cbc-efe0-5348-85e3-4f79bb37ebd5, parent SYS-01.2-02. Audit borné de vingt branches connues : déclencheurs, poison magique, ralentissement, cumuls et consommateurs sélectionnés. Tâche complète, fonctionnalité et goal ouverts ; SOURCE a_qualifier, phase D06, six prérequis du lot, dépendance et propriétaires d’inconnues conservés.

Référence PUBLIC 4.20.0.315 EUW/en_GB, date littérale 2014-11-17 17:46:45 ; fuseau/déploiement inconnus, catalogue officiel 4.20.1 distinct. Aucun passif moderne substitué.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/gangplank-passive-grog-soaked-blade-links-v570.json : 677612 octets, SHA256 f93dd62f9d85ec5abc4b34fa56215a5111d99aa7d554e653015f99c8a027ce11. Rapport FIDELITY_GANGPLANK_PASSIVE_GROG_SOAKED_BLADE_LINKS_V570.md : SHA256 9dabfd1bb11274700eb6306954f95e8c76fff444cc191dba79a52be6f3ec8dee. Preuves V570 du 26 octobre 2026 réutilisées, sans republier leurs liens.

Treize identités natives retenues parmi dix-sept candidats ; quatre exclusions, douze références communautaires. Membership hérité, sans nouveau décodage, accès D:/F-work/EXE ou priorité de montage démontrée. Quatre clés en_GB retrouvées, deux bindings ; deux preloads.

Passive1LuaName=Scurvy, icône Pirate_GrogSoakedBlade.dds, slot1=Parley et slot2=RemoveScurvy. Tooltip 2595 : ralentissement 7 %, dégâts magiques @f1@ chaque seconde pendant trois secondes, trois cumuls maximum. Description 4189 : attaques de base et Parrrley. Valeur f1, progression et combinaison exacte restent inconnues ; 21 % de ralentissement n’est pas déduit automatiquement.

Cinq Lua entièrement parsés historiquement sans prototypes enfants : quatre initialisations littérales, vingt globals. Parley reste indéterminé sur NEWTABLE au pc12 ; ce n’est ni une corruption démontrée ni un corps vide. CharScript vide qualifié. Scurvy déclare IsDamagingSpell=false ; ScurvyStrike déclare true et IsDeathRecapSource=true. Ces rôles distincts et leurs flags ne sont pas des callbacks exécutés.

ScurvyStrikeParticle référence Global_Slow.troy et l’icône du passif, sans preuve de rendu. PirateScurvy/RemoveScurvy INIBIN/Lua sont exclus de l’autorité poison : noms et icône W distincts. Le Q communautaire et son projectile commenté ne démontrent pas tous les hooks natifs d’impact.

## 3. Consommateurs réels

Vingt-neuf entrées concordent avec V570 : vingt Rust, deux lecteurs Python, sept JSON. Sélections héritées : définitions/croissance Gangplank/Annie, Cape1033, profils attaque/critique Gangplank, règles Ignite/Exhaust. Trente identités gardées avec le miroir en_GB.

Trente-sept fenêtres : 32 communes réutilisées, cinq sur ralentissements, vitesse et invocateurs. Vingt-neuf ancres enregistrées, dont 28 frontières entry_boundary_only, provides_feature_consumer=false pour Grog-Soaked Blade. Aucun mécanisme générique promu en poison Gangplank.

basic_attack_hit/apply_damage livrent les dégâts physiques ordinaires ; aucun producteur Grog identifié dans ces corps inspectés. slows choisit le plus fort effet vivant et rafraîchit par tag. prepare_slow, commit_slow_for_surviving_target et grant_slow constituent une API serveur ; aucune commande client n’accorde un effet arbitraire. L’admission NPC actuelle est une reconstruction limitée aux définitions de lane/Monster et Tibbers, pas une immunité native établie.

effective_speed_with_slow compose le ralentissement avec la vitesse courante. join_with_summoners/cast_summoner_on dispatchent Épuisement et Embrasement. Épuisement appelle grant_slow ; Embrasement possède son calendrier propre, premier tick immédiat et dégâts True. Ces politiques ne deviennent pas le poison magique ni ses cumuls.

Recherche littérale Gangplank/Scurvy/Parley/Grog sur vingt Rust sélectionnés : zéro occurrence, sans preuve d’absence globale ou rejeu des 1158 dépendances.

## 4. Attendu, observé et contrôles

Attendu documentaire : sources, valeurs écrites, appels et limites concordants. Observé : 64/64 contrôles documentaires et 96/96 cohérences du même agent ; quatre opérations productrices réussies. Aucun nouveau build, jeu, REA ou diagnostic exécuté.

V570 hérité : quatre essais publics sans injection directe d’état ni dégâts artificiels. Séries 1/3/4/4 impacts, soit douze coups physiques de mêlée au niveau 1 ; brut rapporté 59.0400009155, cadence 46 ticks. Les pertes correspondent selon V570 à la mitigation physique et régénération, résidu inférieur à 0.002. Aucun nouveau recalcul des séries float32 ici.

Les trois premiers coups couvrent 92 ticks. Trois secondes représentent 90 ticks courants : si chaque charge expire indépendamment, la série ne garantit pas trois charges simultanées. Un refresh commun aurait un autre résultat ; son modèle reste inconnu. Ces essais ne valident donc ni simultanéité ni plafond natifs.

Chaque cas conserve vitesse cible 335, aucune perte supplémentaire après correction de régénération, puis 180 ticks après Stop, soit 720 au total. RM cible 30/30/30/55 ; la Cape1033 est un témoin, pas une mitigation démontrée du poison absent. Soixante refus atomiques hérités ; Parrrley n’est pas exécuté par ces essais.

Cinquième cas public distinct : Épuisement fait 335→234.5→335 après 75 ticks ; Embrasement donne cinq applications de 14 bruts, total 70 True, suivies sur 150 ticks. Régénération corrigée avec réduction de soin selon V570 ; quatre refus supplémentaires. Ces invocateurs n’établissent ni f1, ni déclencheur, ni trois cumuls du passif.

Ancien diagnostic initial : compilation E0559, champ target utilisé avec Summoner au lieu de SummonerTarget ; aucune première exécution. Sources et journaux conservés, successeur séparé corrigeant le diagnostic seul. Aucun défaut du jeu inféré ni réparation revendiquée ici.

Exécutable qualifié V570 uniquement identifié en données : 6067712 octets, SHA256 7ad0d1f901bc353b3de406515d9daffa69507027e161db940fa9bafcb85936ed. Aucun accès, hash ou lancement ; build/toolchain/verrou/1158 entrées non revalidés. Navigation V564 et échecs antérieurs préservés, sans réaudit ou correction.

## 5. Écarts et conclusions ouvertes

Restent : montant/progression f1, impacts et Parrrley éligibles, cadence/premier tick/expiration, gain, refresh, simultanéité, cap, combinaison des slows, auteurs multiples, cibles, crédit, résistances/boucliers et cycle de vie. Métadonnées et absence de proc ne tranchent pas ces règles.

Projection, compteur/timer, HUD, VFX/audio et transport nécessitent leurs preuves propres. Question OLU-cc102ce9-a811-5a29-a385-6d7ae11bf131 et dépendances SOURCE conservées chez leurs propriétaires ; aucune inconnue fermée. Aucun modèle ou texture manquant démontré.

## 6. Corrections et reprise

Seize fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-GANGPLANK-GROG-SOAKED-BLADE-, suffixe -01 : AMOUNT-LEVELS, AA-TRIGGER, PARLEY, CADENCE, STACK-GAIN, SIMULTANEOUS-STACKS, REFRESH, CAP, SLOW-COMBINATION, MAGIC-MITIGATION, TARGETS, CREDIT, LIFECYCLE, PROJECTION, PRESENTATION, VERIFICATION.

Chaque fiche possède objectif unique, tâche liée, prérequis, travail, fin distincte et déclencheur de reprise. Reprendre sur source nouvelle, identité modifiée, appel nouveau ou cas supporté nécessaire non couvert. Corrections fonctionnelles et essais supplémentaires relèvent d’un périmètre autorisé distinct.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_gangplank_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca ; 2460 entrées groupées préexistantes conservées. Prochaine sélection exacte Garen depuis 122 paires ; 94 candidats hors 28 unités nommées, sans compte de tâches complètes déduit. Préserver son producteur partiel existant.

Audit borné terminé après examen des sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Publication limitée au rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés. Goal, Plan, interface, bases, registres, produit/assets inchangés ; aucune installation ou migration.
