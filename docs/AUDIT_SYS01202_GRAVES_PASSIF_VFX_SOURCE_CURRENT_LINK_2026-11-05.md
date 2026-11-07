# Graves — liaison bornée du passif et des effets visuels

## 1. Exigence et portée

2026-11-05, V1347 ; `AUD-SYS-01.2-02-GRAVES-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Graves-PASSIF-PRESENTATION-VFX` ; `OLF-2ab05ffd-822a-550c-8584-3d957ac1153c`. Relier les déclarations applicables de True Grit aux consommateurs courants nécessaires. Audit terminé pour cette liaison bornée ; inventaire complet, fonctionnalité, runtime et acceptation restent ouverts.

Implémentation : producteur True Grit non établi dans les corps inspectés, acquis génériques conservés. Vérification : statique documentaire réussie, scénarios historiques non réexécutés. Acceptation humaine : non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/graves-passive-true-grit-links-v574.json` ; copie E externe839185octets, SHA256 `a4709268897e1d0d6c862c12fb025315250b8da7fdfcf70eda16ff79303200ab`. Référence LoL4.20.0.315/EUW/en_GB héritée ; catalogue4.20.1 distinct. Quinze identités et rôles natifs,45 associations historiques de trois tâches. Aucun accès D ; chemins natifs inertes.

Six Lua entièrement lus, six initialisations/26affectations, sans enfant ni exécution serveur. CharScript141 déclare Pineapple/Pineapple.dds ; Passive255 déclare GravesPassive/GravesTrueGrit.dds et PersistsThroughDeath=true. Grit286 : AutoBuffActivateEffect=GravesTrueGrit.troy au pc9 ; ni création, attache, pose ou rendu démontrés. Stack411 conserve RumbleDangerZone/Rumble_Junkyard Titan2.dds et six champs AutoBuff vides : pas absence générale d’effets. Counter228 DoesntTriggerSpellCasts=false et ShotAttack127 true ne qualifient pas l’éligibilité. ExtraSpell2/ShotAttack et son FX sont du contexte ; format/rendu FX ouverts. Aucun rework moderne adopté.

Trois preloads484octets/six références de sorts, comparés aux captures E458141/602028octets. Chaînes de chargement non productrices. Deux DDS distincts5616octets/64×64/DXT5/mip7, membre0.0.0.52 sous core0.0.1.7, sélection/pixels ouverts. Deux bindings et cinq chaînes1964/1965/1966/4197/4373 :1966 reste candidate sans binding supplémentaire ; les deux f1 ne sont pas fusionnés. Six rangs null non convertis en zéro ; textes anciens critique alliée/+10/+15/+20%attaque non adoptés. Dix références communautaires secondaires ; CharScript communautaire vide ne rend pas le natif vide. Quickdraw distinct.

## 3. Consommateurs réels

Douze Rust complets,25 ancres : `lib.rs:685` ; `progression.rs:68` ; `progression.rs:74` ; `progression.rs:80` ; `progression.rs:101` ; `progression.rs:106` ; `damage.rs:53` ; `damage.rs:85` ; `damage.rs:91` ; `damage.rs:97` ; `damage.rs:99` ; `damage.rs:111` ; `champion_kills.rs:26` ; `champion_kills.rs:29` ; `garen_passive.rs:42` ; `garen_passive.rs:46` ; `lifecycle.rs:33` ; `lifecycle.rs:83` ; `attacks.rs:157` ; `penetration.rs:9` ; `world.rs:350` ; `spells.rs:5` ; `spells.rs:120` ; `annie_w.rs:49` ; `projected_live.rs:168`.

Racines : `F:/OpenLeague/crates/core/src/`, sauf projected_live dans client/src. Stats combine base/croissance/objets/Garen/Annie/Exhaust/Trundle, sans producteur True Grit dans la formule inspectée. Damage applique pénétration, mitigation, boucliers et HP ; contribution aux éliminations et assist_seconds ne définissent pas son combat3s. note_garen_damage retourne pour un champion autre que Garen. Reset générique à la mort/réapparition ne qualifie pas la politique native du passif. Casts ciblé/point refusent Graves dans les branches inspectées ; projection examinée Annie.

Recherche nommée Graves/TrueGrit sur les douze textes : aucun hit, sans absence globale déduite.21 comparaisons sélectionnées et87 contextuelles chevauchantes concordent ;14 mécanismes VFX et2 animations ordinaires réutilisés, sans nouveau producteur ou rendu True Grit qualifié.

## 4. Attendu, observé et contrôles

Attendu : conserver les déclarations et distinguer effets, combat/cumuls/défenses et mécanismes génériques. Observé :72/72 contrôles documentaires,83/83 de cohérence séparée du même agent ; pas de second décodeur indépendant.

V1219 source65/65, consommateurs51/51 et intégration40/40 restent hérités. V574 : cinq cas publics niveau1,40 impacts physiques,75 refus,1500ticks de suivi. Armure24.375999/RM30 ; objets1029/1033 ajoutent15armure/25RM, statistiques ensuite constantes. Séquences432/468ticks, intervalles48/52 sous90 : dix impacts ne sont pas dix cumuls. Ni bonus créé, ni expiration qualifiée ; aucun dégât magique. Binaire6035968octets/SHA124c1fcf7fe842c3153872aadb7113bc377cd9716d548319eab889a57182c536, build/run0 hérités, jamais rouverts.

Un contrôle préparatoire a échoué sur égalité brute de chemins f:/F:. Original conservé ; seul prédicat de correspondance Windows précisé avec taille/SHA exacts. Les21/87 hashes concordaient déjà. Anciennes corrections SOURCE, garde Garen, configurations et archives maintenues. Sept opérations documentaires journalisées, dont une préparation de rapport échouée sur le compte81 recopié au lieu des83 contrôles réellement réussis, puis corrigée ; reçus terminaux font autorité. Aucun nouveau build, jeu, natif, GPU, REA ou probe.

## 5. Écarts et inconnues

Texte : période1s, plafond10, dégâts dans les3dernières secondes ; f1, premier incrément, sources/cibles admissibles, dégâts nuls/absorbés/périodiques, frontières, refresh/perte et cycle de vie ouverts. Recette, attache, pose, ressource choisie et pixels restent indéterminés. Identifiants d’inconnues et contrat sont conservés ; aucune tâche VFX complète ou inconnue clôturée.

## 6. Corrections et reprise

Réutiliser la tâche existante avec true-grit-visual-applicability-source, combat-stack-defense-world-link et resource-attachment-render-lifecycle. Objectifs, prérequis, critères nominaux/refus et reprises dans corrections_and_restart.json. Aucun code produit modifié implicitement. Reprendre sur source/callsite/événement qualifié ou dérive précise, sans répétition inchangée.

Prochain lot : CH-Hecarim-PASSIF-PRESENTATION-VFX, sources conservées identifiées dans next_lot.json. Réutiliser la consolidation V1346 et les mécanismes communs, sans nouveau recensement global ou acquisition présumée.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_graves_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, corrections_and_restart.json, operations/journals et reçus de publication. Relecture du même agent, sans acceptation indépendante ou humaine.

Seule liaison bornée clôturable ; tâche complète, inventaire, feature, inconnues et goal ouverts. Publication documentaire : ce rapport et ajouts CURRENT/HANDOFF sauvegardés exactement. Goal/Plan/UI/bases/registres/code/assets inchangés.
