# SYS-01.2-02 — V1294 Viktor : Hex Core, icônes et HUD

## 1. Périmètre et prérequis

2026-11-05. Unité `AUD-SYS-01.2-02-VIKTOR-PASSIF-HUD-ICON-STATE-LINK-01` ; tâche `CH-Viktor-PASSIF-PRESENTATION-HUD`, exigence `OLF-f90d9214-cd41-57fc-8a7e-c61976facb6b`, inconnue `OLU-0a33bdc2-3d3e-5ed3-88eb-c741fd1855f4`. Audit documentaire borné terminé ; tâche HUD, fonctionnalité, inconnues, acceptation humaine et goal ouverts. Les six contrats sont conservés, HUD `a_faire`, implementation_complete/acceptance_complete=false ; dépendance NETWORK et prérequis D01 non acceptés. Phase D06, lot D06-CH-Viktor : détails dans `phase_package_prerequisites.json`.

Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Aucun registre, Plan, UI, base, goal, produit ou asset modifié.

## 2. Sources, provenance et limites natives

Réutilisation de [V650](reference_requirement_trace_sources/viktor-passive-glorious-evolution-links-v650.json), SHA-256 `e988dc9ab138315e193830e064147043d52c70184ec591841917e9be4570b08c`, horodatage hérité `2026-10-27T01:27:12.553185+00:00` : 37 sources directes, 41 relations SOURCE/37 IDs ; 17 INIBIN, 15 Lua, quatre preload, font. Les 48 voisins, 35 Lua et huit limites de lecture restent du contexte. Aucun corps serveur déduit des métadonnées client.

Viktor.inibin : 1424 octets, SHA `b054dbaa0d56dfa53c5687c8d7b0ce67c07c7eb6b3deec7cd2080d3b56299a89`, alias ViktorBlah, icône Viktor_Passive.dds. CharScript et quatre scripts d’objets sont vides. APPerLev déclare ViktorStormTimer/ViktorChaosStormGuide, sans producteur d’AP établi ; sept augmentations déclarent les icônes mk-1/mk-2/perfect et PersistsThroughDeath, sans lifecycle exécuté. AtmasImpalerDummySpell/Disintegrate/DeathfireGrasp restent des références de contexte.

Ordre 3200/3196/3197/3198 : AP/niveau 3/4/5/6, AP fixe 0/20/40/60, mana 0/150/300/500, prix incrémentaux 0/1000/1000/1000, recette chaînée ; RequiredChampion=Viktor, CanBeSold=0, MaxStack=1. Prototype SpecialRecipe=1/InStore=0 ; upgrades InStore=1. Font miroir vérifié : noms/description passive 4480/4304, descriptions objets 6826/6823/6824/6825 ; 14 clés exactes, tooltips « Cannot Be Sold » et @f1@. Producteur, ordre de calcul et binding f1 restent ouverts.

resource_provenance : cinq DDS sélectionnés sur E avant lecture SOURCE exacte, 10880 octets, tous 64×64 DXT1/mip0, membres 0.0.0.251 du manifeste choisi 0.0.1.7 ; tailles/MD5/SHA et en-têtes concordants. Les quatre InventoryIcon viennent du décodage local dont les empreintes INIBIN concordent avec V650 ; aucun INIBIN/Lua/font natif relu. Extension de portée nécessaire `COR-SYS01202-AUDIT-DDS-DECLARED-ITEM-ICON-PATH-SCOPE-01` : seuls ces fichiers déclarés sous Items/Icons2D. Pas d’énumération D par root. Guide et stem exact ViktorBlah absents des 70286 membres choisis ; aucune absence universelle ni alias automatique. Pixels, priorité runtime et GPU non qualifiés.

## 3. Consommateurs réels

Trente ancres héritées vérifiées ; 32 fichiers code/configuration, 16 communs et 16 identités V650 inchangés. `lib.rs:569` initialise six cases vides. `shop.rs:46/99/215` charge le catalogue, refuse l’objet absent et agrège ses bonus ; `progression.rs:87` utilise l’AP des objets. Les quatre définitions et entrées d’admission Map10 sont absentes ; cela ne prouve pas une interdiction historique Map10.

Dix repères HUD supplémentaires : `native_hud_inventory.rs:17/22` lit l’inventaire autoritaire et exige le catalogue ; lignes80–87 chargent les DDS par id/asset/taille, ligne104 refuse l’image absente. `native_inventory_icons.json` ne contient aucun des quatre IDs. `shop_ui.rs:57/368/427/431/434` possède catalogue filtré, sélection, description/regen, recettes et vente. Ce HUD générique est conservé ; aucune présentation Hex Core/f1/choix d’augmentation établie. La recherche Viktor/HexCore est vide dans les seuls fichiers Rust examinés. La référence source_sha256 des ressources de mana est distincte de l’INIBIN natif ; ne pas les confondre.

## 4. Attendu, observé et contrôles exécutés

173/173 contrôles documentaires ; seconde lecture séparée du même agent 95/95. Réexamen des archives E, sans nouveau build/jeu/VM/REA ni replay natif. Onze archives, 3489792 octets ; binaire historique 6034944 octets/SHA `ba4d8b7fed82f2904e13959a584a7c1d1998aaf83a52a7d0c3106e364558e3a4`, non relu ; 1158 dépendances non recopiées/requalifiées.

RUN brut concordant avec OBS : niveaux1/18, inventaires vides et AP0, contre AP prototype attendu3/54 selon le texte. Une attribution XP diagnostique, aucune progression naturelle validée. Soixante-dix refus publics avec flags d’invariance, huit quotes refusées ; aucun achat Hex Core. Annie rencontre aussi « item behavior not implemented », avant restriction champion.

Douze commandes témoins 1029→1031, déplacement de case, vente, achat/vente1052 : coûts/recettes/bonus recalculés depuis catalogue et snapshots ; or 825→525→75→75→600→165→470, AP20 puis0. Le consommateur quote renvoie consumed_slots=[0], qui contient1029 avant upgrade. Ces témoins ne prouvent ni upgrade ni invendabilité Hex Core. Quatre sorts Learn/Cast/CastAt refusés avant/après. Deux fois90 ticks : assertions du collecteur et snapshots finaux, sans180 frames brutes ; aucun test d’expiration/augmentation native.

Échec initial BUILD0/RUN101 conservé : assertion [1029] au lieu de [0]. Comparaison exacte : deux lignes du collecteur changées, assertion du slot et clé consumed_slots ; code jeu inchangé. Collecteur corrigé BUILD/RUN0 hérité, sans réexécution.

## 5. Écarts ouverts

Prototype non accordé, définitions/recettes/bonus/icônes absents des catalogues courants ; AP par niveau, éligibilité/invendabilité Hex Core, choix/effets d’augmentation, synchronisation et rendu natif non établis. L’origine Guide et la sémantique serveur/f1 demeurent inconnues. Fonctionnalité absente documentée ; zéro tâche complète, inconnue, feature ou acceptation close.

## 6. Corrections précises et reprise

- `COR-VIKTOR-GLORIOUS-EVOLUTION-POLICY-01` : établir source/contrat versionné pour ordre AP/f1 et lifecycle ; finir avec valeurs et limites explicites.
- `COR-VIKTOR-PROTOTYPE-GRANT-01` : attribuer exactement un3200 à l’entrée de Viktor ; vérifier absence de double attribution et autre champion.
- `COR-VIKTOR-HEXCORE-CATALOG-01` : définir les quatre objets et recettes ; vérifier prix, consommation de case, restriction et refus de vente sans mutation.
- `COR-VIKTOR-LEVEL-AP-01` : recalculer le bonus de chaque niveau/stade sans cumul ; confronter niveaux1/18 et transition à une source qualifiée.
- `COR-VIKTOR-AUGMENT-CHOICE-01` : produire et synchroniser un choix admissible ; vérifier transition et refus de répétition avant extension aux autres sorts.
- `COR-VIKTOR-GUIDE-ICON-SOURCE-01` : retrouver le payload/résolveur exact ou borner la référence inutilisée sur preuve.
- `COR-VIKTOR-HUD-BINDINGS-01` : relier DDS, case et f1/augmentation à l’état réel ; finir avec rendu et transitions contrôlés.

Reprendre seulement sur source primaire nouvelle, changement vérifié de consommateur ou test nécessaire autorisé. Prochain candidat documentaire : Vladimir ; réutiliser ses preuves existantes.

## 7. Livraison et garde-fous

Rapport et appendices CURRENT/HANDOFF seuls publiables ; octets antérieurs archivés et sept documents protégés comparés avant/après. Dossier `E:/mapslol3v3/audit_sys01202_viktor_passive_hud_20261105` : evidence_review, coherence_review, DDS/histoire, journaux de lectures et reçus d’opérations, result/publication/postpublication. Journaux limités aux producteurs Python instrumentés ; contexte exploratoire, dispatch et empaquetage final exclus, sans garantie OS/TOCTOU. Relecture par le même agent, sans validation indépendante ou humaine. Travail existant conservé sur main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca` ; 2281 entrées sales groupées à la reprise.
