# Cho’Gath — Carnivore : sources VFX et consommateurs actuels

6 novembre 2026 · V1441 · AUD-SYS-01.2-02-CHOGATH-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence et périmètre

CH-Chogath-PASSIF-PRESENTATION-VFX, OLF-17950375-73b7-5716-9ea7-a720bc90843b : relier les effets applicables de lancement, trajet et impact aux sources et consommateurs réels, ou préciser le manque. D06 et prérequis hérités ; CH-Chogath-PASSIF-NETWORK reste requis. Statut a_faire, implémentation et acceptation conservés.

Audit documentaire de liaison terminé ; fonctionnalité non terminée ; vérification statique et résumés historiques réutilisés ; acceptation humaine non donnée. SOURCE V551 et HUD ne sont pas clôturés à nouveau. Ce lot ne termine ni Carnivore, ni Cho’Gath, ni SYS-01.2-02.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Reçu V551 :509602octets, SHA d44fd571bacc31b0f8984f37bd4a1f38b5f473fc9afd52cb393b3c2a66a69b9d. Copie figée et identité F concordantes. Sept identités/memberships natifs, distincts des dix relations SOURCE. Aucun chemin D rouvert.

Carnivore.luaobj215 déclare quatre globals : BuffName Carnivore, GreenTerror_TailSpike.dds, PersistsThroughDeath et NonDispellable. CharScript56 est vide. Deux Lua littéraux entièrement consommés, sans callback enfant, code non exécuté. Aucun AutoBuff reconnu ne prouve pas l’absence de VFX. Nom/icône/persistance ne définissent ni événement de kill ni recette visuelle.

La définition lie Carnivore et l’icône. Passive1, Passive1Desc et trois niveaux sondés restent absents, sans défaut inventé. Texte1774 :f1 PV/f2 mana après kill ; description4175 :croissance avec le niveau ; nom4351 :Carnivore. Fournisseurs et formule non résolus.

Deux preloads182/788, total970octets : identité et rôles hérités. Les noms historiques chogath_battlecast_heal.troy et globallifesteal_buf.troy ne prouvent ni soin, ni vol de vie, ni sélection de skin. Aucun brut ou inventaire typé retenu ici. Deux DDS4224, total8448, 64×64 DXT5/mip0, même SHA bed31f6628be11f24cb0a9adaaa49f4e4532b969214d8dbfc507824a709dcafb. Deux chemins distincts, sans priorité/provider/pixels qualifiés. V166 Skin02/CSV vide reste un contexte de provider séparé, sans promotion en Carnivore.

## 3. Consommateurs réels

Dix-huit Rust actuels inspectés,17ancres V551 retrouvées dans12chemins. Join/stats, attaques, dégâts/mort, crédit, XP, soin et régénération sont des frontières réelles, sans producteur Carnivore établi. Le récepteur trundle_passive_damage_death filtre explicitement Trundle ; sa table communautaire2–6% et ses deux appels dégâts/world ne deviennent pas Carnivore. Soin commun et plafonds ne qualifient pas la restauration de mana.

Owner/spatial, classes de particules, HUD QWER/Ezreal, HP/Mana et animations ordinaires restent des acquis partagés. Aucun ne démontre un effet Carnivore complet. Quarante-cinq comparaisons sur40fichiers concordent :14partagés, deux animations,16HUD, douze contextes V551 et miroir en_GB. Égalité d’identité seulement.

Recherche nommée dans les préfixes des18Rust :zéro hit, portée bornée. Le premier #[cfg(test)] de damage.rs11 appartient à from_magic ; il ne délimite pas tout le code de production. Contrôle complémentaire des méthodes exactes : appels Trundle damage135/world401, aucun nom Carnivore dans ces méthodes. Aucun constat d’absence mondiale.

## 4. Attendu, observé et contrôles

Attendu : kill éligible → attribution/restauration → effet/ressource → owner/cible/temps → rendu, ou lacune précise. Observé : déclarations et frontières génériques identifiées, chaîne spécifique non établie. **34/34 contrôles documentaires qualifiés,101/101 cohérences du même agent.** HUD hérité :41source/31consommateur/28intégration/16postpublication, non rejoué.

V551 hérité : deux cas Cho’Gath/Trundle contre Garen, chacun quatre coups entrants,14sortants et un kill ; niveaux1, vol de vie0, XP165/or400. Cho au tick1569 : supplément de soin0 sous plafond ; Trundle au1532 :12.325592PV selon sa reconstruction communautaire. Trente ticks suivants chacun :régénération seule. Mana plein, restauration non observable ;14refus publics dont quatre Cast Cho’Gath. Mort d’unité world inspectée statiquement, non exercée dans ce diagnostic. Résumés conservés, sans snapshots bruts, recalcul flottant ou runtime nouveau. Ancien EXE6052352/SHA5ebedc19, métadonnée inerte.

Six productions : cinq réussies, evidence01 échouée33/34 conservée. Un seul prédicat sur la coupure de damage.rs est qualifié par les deux méthodes exactes ;33autres inchangés. L’erreur d’affichage cp1252 du root est conservée, relecture UTF-8 réussie. Recherche supplémentaire AUDIT_*.md hors AUDIT_SYS01202*.md :rg1, zéro candidat, nominal borné. Aucun build, jeu, analyse native, REA, GPU, installation ou migration.

## 5. Écarts et inconnues

Corps serveur, f1/f2/niveaux, cibles/crédit/ordre, PV/mana/modificateurs, recettes/variants/skins, provider/attaches/arrêt, audiences et rendu restent ouverts. VFX OLU-7690bd3a-b821-56a4-8d12-9967ce668f53 et SOURCE OLU-084a0bf1-119e-5707-964b-ba99b06b4e9e conservés. COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 ouverte : inventaire secondaire/applicabilité exhaustive non qualifiés. Aucun besoin de reconstruction graphique démontré.

## 6. Corrections et reprise

corrections_and_restart.json sépare politique native/recettes, producteur de restauration, réseau/audiences et VFX/rendu. Réutiliser SOURCE, SIMULATION, NETWORK et PRESENTATION-VFX ; aucun ajout au registre. Chaque objectif comporte prérequis, fin et reprise. Un premier cas exige PV et mana manquants, sans attendre tout le kit.

Reprendre sur source/capture/callsite nouveau ou dérive ; implémentation soumise au périmètre autorisé. Ne pas rejouer un kill avec mana plein pour qualifier le mana. Chogath est la dernière des sept lignes non rapprochées dans V1434 ; cela ne prouve pas la couverture complète. next_lot.json prescrit un rapprochement incrémental des122IDs et sept nouvelles livraisons, sans nouvelle clôture individuelle par agrégation.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_chogath_passive_vfx_20261106 : scope, inspection, evidence brut/qualified, qualification du prédicat, cohérence, identités, corrections, reprise et journaux. Sept rubriques relues ; même agent, sans revue indépendante ni acceptation humaine. Seul l’audit de liaison borné est clôturable.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF avec sauvegardes exactes. Sept registres protégés ; main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca et2427entrées groupées conservés. Goal, Plan/UI, bases, code, assets et statuts inchangés.
