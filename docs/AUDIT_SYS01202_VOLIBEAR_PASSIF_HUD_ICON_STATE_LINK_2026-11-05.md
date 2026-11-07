# SYS-01.2-02 — V1296 Volibear : seuil, soin, icônes et HUD

## 1. Périmètre et prérequis

2026-11-05, F:/OpenLeague. Unité `AUD-SYS-01.2-02-VOLIBEAR-PASSIF-HUD-ICON-STATE-LINK-01`, tâche `CH-Volibear-PASSIF-PRESENTATION-HUD`, exigence `OLF-d0d20920-6ab9-5122-b0b0-6b2308305d7f`, inconnue `OLU-5b9dcace-e96d-5d5f-8280-ff342c3452da`. Audit documentaire borné terminé ; six contrats et questions conservés, HUD a_faire/implementation_complete=false/acceptance_complete=false, dépendance NETWORK ouverte. D06/D06-CH-Volibear et prérequis D01 dans phase_package_prerequisites.json ; aucune sortie de phase ou acceptation présumée. Goal SYS-01.2-02 actif.

Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Aucun Plan/UI/base/registre/goal/code produit/asset modifié.

## 2. Provenance et limites natives

[V541 conservé](reference_requirement_trace_sources/volibear-passive-healing-links-v541.json),410323octets/SHA `07fb259c26b5d63d4b9236310b4bfe15c4471bd758b2f8adc624874e65924ce4`, UTC hérité `2026-10-25T17:08:25.679166+00:00`. SOURCE16relations/13IDs ; définition, trois INIBIN de buffs, cinq Lua, trois preloads et font ; memberships antérieurs concordants. Volibear.inibin2574octets/SHA `ba743bd501478c0766e1c3a3f159b8dd93cf4421ec11658d589cee398fed9390`, alias VolibearPassiveBuff, icône VolibearPassive.dds ; Passive1/Name/Desc/PassLev1Desc1 absents, non inventés.

Trois clés BuffData exactes en_GB aux2914/2915/2916 :passage sous30%PV,soin de @f1@% des PVmax sur6secondes,recharge2minutes ; f1 et disponibilité initiale inconnus.120secondes est une conversion arithmétique du texte, sans exécution de recharge démontrée.

Cinq Lua sans callback enfant :Buff220octets conserve exactement `VolibearPassive.dds ` avec espace final ; CD221 déclare VolibearPassiveGray.dds ; Heal253 déclare l’icône normale/volibear_passive_heal.troy ; HealCheck221 référence Blitzcrank_ManaBarrier.dds et OnPreDamagePriority=8 ; CharScript56 est vide. Persistance/non-dissipation et preloads sont des métadonnées, pas des règles de mort, un callback exécuté ou un bouclier de Volibear.

resource_provenance : trois DDS sélectionnés sur E avant lectures SOURCE exactes,15456octets,64×64 DXT5 ; normal propre Info/partagé5616octets/mip7, même SHA `39431236702c5826a1fa819450985302fb69d98d9059233a264d607a12c577dd` ; gris partagé4224/mip1,SHA `2852ff208c1ffea4b458705f3cac2c08b4ef376d5d22b5d14d9ac011a301d1c2`. Membres0.0.0.62 du manifeste choisi0.0.1.7 ; tailles/MD5/SHA/en-têtes concordants. Aucune métadonnée native relue ni énumération D par root. Nom avec espace absent comme basename exact des70286membres examinés ; pas de trim implicite ou substitution. Définition et Heal justifient indépendamment l’icône normale. Blitzcrank et effets restent en contexte ; priorité d’alias/pixels/GPU non qualifiés.

## 3. Consommateurs réels

Seize ancres héritées sur huit fichiers,27fichiers code/configuration ;16communs et15identités V541 inchangés. Action::Attack→attacks.rs→lifesteal::basic_attack_hit→damage::apply_damage→perte de PV ; tick→regeneration_rates/advance_regeneration ; UseItem→use_item/advance_consumables. Régénération générique et branche Garen existantes conservées. Aucun producteur Volibear identifié dans les fichiers Rust examinés ; cette portée ne prouve pas une absence universelle.

Le HUD générique existe :native_hud_bars.rs:10 lit health/max_health ; native_hud_widgets.rs:90 produit HPStat. La ressource locale est Mana ; sa provenance source_sha256 reste distincte de l’INIBIN natif. Capacité et présentation génériques ne qualifient ni f1, ni état disponible/soin/recharge Volibear, ni le rendu natif.

## 4. Résultats attendus, observés et contrôles

86/86 contrôles documentaires ; seconde passe séparée du même agent 70/70. Cinq archives1484091octets, RUN brut identique à OBS ; BUILD/RUN0 hérités. Binaire historique5943808octets/SHA `f080fab31c970b35875a1f371631b06ecb1a2d8476677fcd0a90631ae697f7a7`, non relu/rejoué ;1158dépendances non requalifiées. Aucun nouveau build, jeu, VM native, REA, réseau ou GPU.

Deux cas niveau1,ordinaire et potion2003 témoin :quatre déplacements publics,20paires brutes de frappes ordinaires non critiques avec windup/release concordants. Neuf frappes avant la fenêtre au-dessus du seuil,une après,par cas. Au tick1364,203,260986328125→157,51654052734375PV sur584,47998046875,soit34,77638125%→26,94986070%. Pas d’injection directe de dégâts/soin.

Quatre fenêtres180ticks donnent720pairesPV brutes recalculées en f32 :attente de base,résidu et soin de potion indépendamment. Au-dessus du seuil,résidus nuls dans les deux cas. En dessous,cas ordinaire157,5165405→167,2257080PV,résidus nuls ; potion157,5165405→227,2247925PV,+59,99908447265625PV au-delà de la base,soit0,3333282470703125par tick. Taux de base1,618399977684021PV/s concordant avec la donnée courante.

La potion est consommée publiquement au1364 ; compteur449→270,expiration non atteinte. Aucun soin natif supplémentaire observé dans ce scénario ; sans disponibilité initiale prouvée,aucune conclusion universelle sur les déclencheurs. Égalité exacte30%,montant f1,recharge120s et deuxième activation non testés. Arrêt/absence de cible ennemie et absence de fin de partie sont des assertions du collecteur,sans snapshots mondiaux complets à chaque tick. Les3088ticks ne sont pas tous archivés en frames.

Huit refus enregistrés :joueur/cible inconnus,cible propre et usage avant blessure. Dernier refus="empty inventory slot" sans potion,"health already full" avec potion ; l’objet reste présent au début de la première fenêtre. Pas de comparaison brute individuelle de tous les états de refus.

## 5. Écarts ouverts

f1/disponibilité initiale,producteur de soin,priorité/égalité/ordre des dégâts,mort,réduction/amplification,recharge/réactivation et synchronisation restent inconnus ou non implémentés dans le périmètre examiné. Normalisation de l’espace et sélection des variantes native/GPU non établies. Aucun bouclier déduit de Blitzcrank. Ancien nom de vérificateur contenant lifesteal n’ajoute aucun test de vol de vie.

## 6. Corrections et reprise

- `COR-VOLIBEAR-CHOSEN-STORM-POLICY-01` :qualifier f1,disponibilité et ordre autoritaire sur source/contrat versionné ; conserver les inconnues explicites.
- `COR-VOLIBEAR-DAMAGE-TRIGGER-01` :lier un dommage ordinaire au franchissement admissible ; vérifier au-dessus/en dessous/égalité/létal selon contrat qualifié.
- `COR-VOLIBEAR-HEAL-STATE-01` :produire le soin sur6s sans doubler la base ; vérifier la quantité qualifiée et les modificateurs,avec potion témoin séparée.
- `COR-VOLIBEAR-COOLDOWN-STATE-01` :lier début/fin/réactivation selon autorité établie ; contrôler refus et retour disponible.
- `COR-VOLIBEAR-TEXTURE-PATH-01` :établir le traitement du nom avec espace et la priorité normale/grisée ; aucune normalisation silencieuse.
- `COR-VOLIBEAR-HUD-BINDINGS-01` :relier disponible/soin/recharge,f1 et icônes à l’état réel ; vérifier transitions/rendu,en conservant les barres et HPStat.

Reprendre seulement sur nouvelle source primaire,changement vérifié de consommateur ou test nécessaire autorisé. Prochain candidat :Warwick.

## 7. Livraison et garde-fous

Rapport et appendices CURRENT/HANDOFF seuls publiables ; octets antérieurs archivés,sept documents protégés comparés avant/après. Preuves E:/mapslol3v3/audit_sys01202_volibear_passive_hud_20261105 :evidence_review,coherence_review,captures DDS/histoire,journaux,result/publication/postpublication. Journaux limités aux producteurs Python instrumentés ; contexte exploratoire,dispatch/empaquetage exclus,sans garantie OS/TOCTOU. Recherche exploratoire initiale health.rs corrigée vers regeneration.rs,aucun fichier supprimé déduit. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2283entrées sales groupées conservées. Zéro tâche complète,inconnue,feature ou acceptation close ; relecture du même agent,sans acceptation indépendante/humaine.
