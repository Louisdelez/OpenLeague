# Aatrox — Puits de sang, sources conservées et liaison VFX, V1321

## 1. Exigence et portée

Unité `AUD-SYS-01.2-02-AATROX-PASSIF-VFX-SOURCE-CURRENT-LINK-01`, parent SYS-01.2-02 ; tâche `CH-Aatrox-PASSIF-PRESENTATION-VFX`, exigence `OLF-9d4a3492-f0a3-5362-b8a2-0f1b6c0b9d9b`. Phase D06, lot D06-CH-Aatrox, six prérequis et dépendance NETWORK examinés sans satisfaction revendiquée. Contrat `a_faire`, implémentation/acceptation false ; inconnue `OLU-c80496d0-5fe8-5066-826c-bbd2654533b8` conservée.

Clôture limitée à l’audit documentaire des sources conservées et de leur liaison aux routes courantes. Les dix ressources connues ne constituent pas un inventaire exhaustif des recettes visuelles ni un serveur original. Réanimation, tâche VFX complète, champion et goal restent ouverts. Vérification statique ; acceptation visuelle humaine à valider.

## 2. Sources et limites des déclarations

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Primaire `reference_aatrox_passive_sources/aatrox-passive-source-boundaries-v456.json`, 116072 octets/SHA256 `82f927382e0e049d7e42c4510eeade78a1504aa0892af19f05b1aeaeca2e6fb5`. Réutiliser V456, V1194 HUD, V664 NETWORK et l’ancien audit SOURCE-CONSUMER/ACCEPTANCE sans nouvelle clôture de leurs périmètres.

V456 conserve dix identités : cinq INIBIN et cinq Lua. Aatrox.inibin,1997octets/SHA `4d1949dc1ddbd27fd37c2b5dc6d2aa635a738f7bf4547314ae4ddc445eac2483`, déclare AatroxPassive, Aatrox_Passive.dds et BloodWell. Les cinq chunks contiennent 17 affectations encodées, aucun prototype callback ou CALL ; aucune exécution native. CharScript vide ; aucune déclaration AutoBuff dans ce corpus retenu.

AatroxPassive.luaobj,254octets/SHA `561f4207cde3e6b19f40d6a9cfd352e621ecc36f59920fbc248ed34383a16476`, porte icône, nom, persistance, NonDispellable et OnPreDamagePriority=4. Cette priorité n’établit ni interception fatale exécutée ni durée. Activate utilise Aatrox_Passive_Cooldown.dds.

Death et Ready restent deux sources distinctes : `OLS-80c559c5-f036-5910-b8c6-8a19624f0c68` et `OLS-70ee8110-2fb5-5a89-bd1b-d19e69df9184`. Leurs chunks217octets sont identiques/SHA `b660dc91bda3559359b618319c7ef82d5d4acee6e118f6374876fbed22a9a344` et nomment tous deux AatroxPassiveReady. Ne pas les renommer ou déduire une séquence de réanimation de leurs noms de fichiers.

Cinq textes en_GB déjà vérifiés dans V1194 décrivent stockage des coûts PV, restauration lors de dégâts fatals et phase de trois secondes. Valeurs de texte, @f2@ et @SourceName@ restent distincts d’une politique serveur qualifiée. Aucun nouveau décodage, lecture DDS/font native, pixel ou test HUD ici.

V669, `reference_requirement_trace_sources/passive-vfx-links-v669.json`, SHA `4888b15a9b1b81f6a1b8434bd9a958f9ea178a53624b772f838fdb6c929f3a0b`, réutilisé via V1314 vérifié : Disintegrate_tar.troy/HaveAfterEffect="0", deathFireGrasp_tar.troy/HaveHitEffect="0" et deathFireGrasp_mis.troy sans indicateur associé qualifié. Les champs Disintegrate de l’INIBIN Death ne sont ni une preuve de comportement Aatrox ni une corruption démontrée. Préserver casse/types et chaînes "0", sans activation par vérité de chaîne.

Trois candidats Troy identifiés historiquement et membres du projet sélectionné, sans sélection runtime ni ouverture actuelle. Identités et memberships restent dans evidence_review_qualified.json. Les noms candidats et l’absence d’AutoBuff dans cinq chunks ne constituent pas une recette exhaustive de résurrection. Origine du script serveur, étapes visuelles et priorités de montage restent ouvertes.

## 3. Consommateurs réels

Huit ancres uniques, neuf fichiers code/configuration inspectés ; trois enregistrements V456 damage/lifecycle/lib concordent en octets/empreintes. Le compteur historique «consommateurs réutilisés» ne remplace pas le nombre de ces trois enregistrements. Provider et initialisation main.rs sont des frontières de noms : 17 anciennes requêtes, trois chemins logiques .troy, 14 sans résultat ; aucun compte de14assets manquants ni ouverture Troybin déduits.

BloodWell courant concorde au type natif, mais son source_sha256 diffère de l’INIBIN ; sémantique du producteur non établie. Champion.effects/Snapshot.players et d’autres passifs existent. Aucun champ Aatrox/BloodWell nommé dans Effects ; aucune route nommée identifiée dans le code sélectionné. Une mention Aatrox est un test de régénération, sans liaison passive.

apply_damage pose un délai générique de réapparition ; lifecycle restaure au point de réapparition et remet les ressources nonMana à zéro. Ces routes ne démontrent pas l’interception/réanimation BloodWell. Le traitement de mort Trundle demeure présent. Pas d’exclusion de tout mécanisme générique/dynamique hors périmètre.

Quatorze identités communes V1315 inchangées permettent de réutiliser primitives spatiales, matrices fournies, arrêt d’owner et route Annie. Relic expose des sous-catalogues DDS de9/17entrées, pas les trois Troy ; refus dérivés statiquement. Le catalogue Map10 précis de26définitions n’a pas leurs références, sans absence globale d’assets. Ancienne recherche HUD1219Rust non rejouée ni promue en preuve globale actuelle.

## 4. Attendu, observé et contrôles

Attendu : conserver les identités/ambiguïtés Death–Ready, vérifier les routes et borner les manques. Observé : 44/44 contrôles qualifiés, 39/39 cohérence séparée du même agent, sans revue indépendante. Nominal : trois frontières inchangées et dix sources conservées. Limites : affectations non exécutées, résolution logique distincte d’une ouverture et mort ordinaire distincte d’une réanimation qualifiée.

Deux échecs intermédiaires conservés : premier collecteur arrêté par variable réutilisée/KeyError avant résultat ; correction d’une seule ligne, reprise sur copies E. Puis43/44 sur un comptage attendu2/observé3 ; un seul prédicat qualifié à partir des trois records retenus, les43autres et tout le payload inchangés. Les scripts, journaux et codes1 restent accessibles ; aucune reprise native.

Aucun nouveau build, binaire exécuté, jeu, GPU, REA, UDP, source native, ancien probe ou décodage. Les25/25 contrôles source et22/22 consommateurs V1194 sont hérités ; ils ne deviennent pas de nouvelles observations VFX.

## 5. Écarts ouverts

Réserve/coûts, interception fatale, activation/recharge, réanimation, synchronisation autoritative, recette visuelle effective, ressources/montage/skin, conversion, attaches, propriétaire, cycle de vie, audiences et fidélité non qualifiés. Persistance et priorité littérales ne définissent pas le cycle graphique. HUD, SOURCE, simulation, NETWORK et acceptation restent distincts.

## 6. Corrections et reprise

Réutiliser CH-Aatrox-PASSIF-PRESENTATION-VFX et ses dépendances SOURCE/SIMULATION/NETWORK ; préserver les critères HUD antérieurs. Propositions documentaires sans changement de registre :

- `COR-AATROX-PASSIF-VFX-RECIPE-01` : identifier les déclarations/callers réellement applicables à réserve, disponibilité et réanimation ; vérifier Death/Ready/Activate séparément, sans déduction depuis les noms.
- `COR-AATROX-PASSIF-VFX-STATE-PRODUCER-01` : relier état autoritatif et interception fatale aux événements visuels ; vérifier réserve insuffisante, cooldown, activation et absence de doublons en conservant la mort ordinaire/Trundle.
- `COR-AATROX-PASSIF-VFX-RESOURCE-ATTACH-01` : identifier/ouvrir les ressources applicables, montage/skin, matrices et owner ; vérifier ambiguïtés/refus sans substitution Disintegrate arbitraire.
- `COR-AATROX-PASSIF-VFX-LIFECYCLE-RENDER-01` : vérifier phases, arrêt, réapparition, audience/reconnexion et comparaison native ; binaires/assets/captures nommés, acceptation humaine séparée.
- Réutiliser `COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01` pour inventorier les recettes secondaires conservées et les manques, sans clôture collective implicite.

Reprendre avec inventaire/artéfact source nommé, contrat autoritatif, callsite, capture pertinente ou dérive d’entrée ; aucune répétition inchangée.

## 7. Livraison et suite

Preuves datées : `E:/mapslol3v3/audit_sys01202_aatrox_passive_vfx_20261105`, contrats, journaux avant lecture, reprises et qualification. Publication : ce rapport et ajouts sauvegardés à CURRENT/HANDOFF. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2308entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit inchangés.

Prochain lot `AUD-SYS-01.2-02-PASSIF-VFX-SECONDARY-SOURCE-COVERAGE-01` : examiner les reçus SOURCE des122tâches VFX, identifier couverture réelle Effect/Event/attaches ou format partiel/nonqualifié, conserver périmètres V669 et limites Yasuo/Aatrox ; aucune clôture individuelle ou fonctionnelle déduite de cette consolidation.
