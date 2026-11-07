# V1493 — Kennen : contrat connu de Mark of the Storm

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-KENNEN-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Kennen-PASSIF-SIMULATION-CONTRAT, exigence OLF-47212077-142f-59f3-8176-6a8e5eddfe4e, parent SYS-01.2-02. Audit borné de26 branches connues, distinct de la résolution de toutes les politiques historiques. SOURCE reste a_qualifier ; phase D06, six prérequis du lot et propriétaires d’inconnues conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315, EUW/en_GB, date littérale2014-11-17 à17:46:45 ; fuseau et déploiement inconnus, catalogue officiel4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/kennen-passive-mark_of_storm-links-v588.json du26 octobre2026 :1050254 octets, SHA256 4493b3d6b8e8bea4b641470006d00af2ff061f0b881814f977313d0c3bbe12d0. Rapport FIDELITY_KENNEN_PASSIVE_MARK_OF_STORM_LINKS_V588.md :16526 octets, SHA256 48967197c2a52ce5915451538fe1175a80ee5fb34e8a69cc75c95c2057a6c783. Cache de rapports vide, MD existant retrouvé au chemin explicite ; aucun cache modifié ni asset déclaré absent sur cette seule base.

32 identités natives,16 références communautaires distinctes, neuf preloads. Onze Lua entièrement parsés historiquement, zéro prototype enfant, onze initialisations littérales et32 globals. CharScript communautaire vide ; aucune preuve de serveur historique. Preloads et métadonnées ne sont ni callbacks ni rendu.

Dix clés en_GB présentes vérifiées. PassLev1Desc1 lie directement la description4215 : marques6,25 secondes, seuil3, étourdissement1 seconde, gain25 énergie, diminution si nouveau stun dans7 secondes. Coefficient réduit, consommation, ordre et renouvellement restent ouverts. Sept buffs liés, dont MoSDiminish2165 sans coefficient. W11643 décrit une attaque renforcée toutes les5 attaques : compteur distinct des3 marques par cible.

Passive1LuaName=KennenMarkOfStorm.lua, buff KennenMarkOfStorm, icône Kennen_MarkOfStorm.dds. Compilé KennenMarkofStorm.luaobj présent historiquement, sans preuve de résolution runtime d’alias. Cinq chemins candidats absents : deux preloads, DDF, source globale .lua et INIBIN sous le personnage ; aucune absence globale ou corruption déduite.

Ancienne description de dégâts au seuil, icône Teemo du CharScript et SpellToggleSlot=3 de E restent non adoptés. Le3 ne devient pas automatiquement R Rust. Buff retenu : nom et icône seulement, sans flags inventés. Six champs de niveaux passifs absents. PARType=Energy, BaseMP200, croissance0, BaseStaticMPRegen10 ; coûts Mana interrogés absents, sans défaut inventé. Aucun nouvel accès D:/F-work/EXE ni décodage natif.

## 3. Consommateurs réels

29 entrées concordent avec V588 :18 Rust, deux lecteurs Python, neuf JSON. Avec le miroir en_GB,30 identités gardées.35 fenêtres dont32 communes réutilisées ; ajouts : stuns.rs1–38, annie_passive.rs1–25 et annie.rs45–94.29 ancres enregistrées dont28 entry_boundary_only/provides_feature_consumer=false. Tous les renvois de branches aboutissent aux fenêtres contrôlées.

progression exclut items.mana pour Energy ; lifecycle distingue Mana/Energy, regeneration calcule le taux et plafonne la récupération. Ces mécanismes réels ne produisent pas le remboursement25. Learn/Cast/CastAt de Kennen restent refusés.

grant_stun reçoit des événements serveur, applique exclusions, durée modifiée, remplacement par tag, interruption et contribution. disabled_cast_rules.json est réellement consommé ; règle absente explicitement refusée. Pyromania vérifie champion=Annie, quatre charges puis consommation et tag propre. Ce code fonctionne partiellement ; il ne devient pas MarkOfStorm. Ajustement Courage et diminution Kennen restent distincts.

Recherche littérale Kennen/MarkOfStorm/mark_of_storm sur18 Rust sélectionnés : zéro occurrence, sans recherche d’absence globale ni relecture des1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : distinguer déclencheur de marque, W appris, énergie dépensée et contrôle générique. Observé :98/98 contrôles documentaires,109/109 cohérences du même agent, quatre productions réussies. Aucun nouveau build, test Rust, jeu, REA ou capture.

V588 hérité : deux parties publiques base/Saphir1027,12 impacts physiques avec projectile source/cible témoin non critique,30 refus et360 ticks finaux. Saphir coûte400or, bonus local200mana ; énergie maximale200 inchangée. Kennen niveau1, W non appris, rangs/délais0. Aucun déclencheur valide de marque exercé. Énergie toujours plafonnée : taux calculé10/s, aucune récupération depuis déficit ou remboursement25 mesuré. Aucun stun ne suffit donc pas à démontrer un échec d’un déclencheur valide.

Troisième partie distincte : Annie apprend Q et lance cinq Q publics, cinq impacts magiques témoins,424 ticks d’attente. Quatre charges Pyromania puis cinquième Q consommant les charges ; Kennen étourdi38 ticks locaux, soit arrondi de1,25s. Cinq refus de Q en délai et trois refus Move/Attack/Cast sous contrôle ; retrait à expiration, déplacement accepté et mouvement observé ensuite. Total38 refus sans mutation. Ces38 ticks ne sont pas la seconde native de Kennen ; aucun test de diminution ou de remboursement hors plafond.

Exécutable V588 identifié uniquement en données :6081024 octets, SHA256 ef3ef2b20a4254095280d718f6ca1516c463d0e1a20a28807894451f3df094af. BUILD/RUN0 hérités, sans accès/lancement actuel ni requalification de toolchain/lock/dépendances. Échecs antérieurs KatarinaV586, KassadinV585 et stockageV582 conservés.

## 5. Écarts et conclusions ouvertes

Restent alias/texte ancien, admission QWER, producteurs Q/W/E/R, cibles/propriétaires, seuil/consommation, durée/refresh, stun/diminution, composition de contrôles, remboursement/plafond, événements simultanés, ordre, rangs/coûts, lifecycle, intégration, réseau et présentation.

Question propre OLU-292aebc2-ddbb-5fcb-a46e-c614bd356af4 distincte de SOURCE OLU-e1ee61ff-a1c3-5cbf-9b02-84484af8719c. Propriétaires conservés, aucune inconnue fermée ; V564/BattleTraining non corrigés.

## 6. Corrections et reprise

26 fiches corrections_and_restart.json, préfixe COR-SYS-01.2-02-KENNEN-MARKOFSTORM-, suffixe -01 : NAME-BINDINGS, LEGACY-DAMAGE, SPELL-ADMISSION, Q-PRODUCER, W-FIFTH-ATTACK, W-ACTIVE, E-CONTACT, R-PRODUCER, ELIGIBILITY, OWNERSHIP, THREE-MARKS, MARK-DURATION, MARK-REFRESH, STUN-BASE, DIMINISH, CONTROL-COMPOSITION, ENERGY-REFUND, ENERGY-CAP, MULTI-EVENT, TICK-ORDER, RANKS-RESOURCES, LIFECYCLE, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche liée, prérequis, travail, critère positif distinct et condition de reprise pour chacune.

Reprise sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Futurs contrôles : vrais sorts acceptés, W appris, dépense publique d’énergie, seuil, expiration et répétition ; pas d’injection de marques/énergie pour déclarer la fidélité. Arrondi local6,25s explicite, sans preuve historique déduite. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_kennen_passive_simulation_contract_20261106. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2479 entrées groupées préexistantes conservées. Prochain Khazix depuis122 paires ;75 candidats hors47 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Méthode accélérée : reçus réutilisés, lectures groupées,32 fenêtres communes vérifiées ; aucun gain temporel mesuré. Aucune installation/migration.
