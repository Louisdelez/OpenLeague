# Galio — source ancienne et liaison des VFX du passif

2026-11-05 · V1326 · AUD-SYS-01.2-02-GALIO-PASSIF-VFX-LEGACY-SOURCE-CURRENT-LINK-01

## 1. Exigence et frontières

SYS-01.2-02 ; CH-Galio-PASSIF-PRESENTATION-VFX, OLF-108ffe68-f8d2-5282-a591-102bcbde09ca. Qualifier la vue ancienne du buff V546 laissée non mappée par V1322 et ses consommateurs pertinents. Conserver le critère complet des effets de lancement, trajet et impact applicables, la dépendance NETWORK, les phases et les lots. Aucun prérequis accepté implicitement.

Audit de ce lien documentaire clôturable après publication vérifiée. Implémentation non modifiée ; vérification statique/documentaire ; acceptation humaine non donnée. Inventaire natif exhaustif, nouveaux décodages, correction du jeu et rendu exécuté exclus. V546 et V1215 HUD restent des acquis distincts, non recomptés.

## 2. Sources, provenance et limites

PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus, catalogue 4.20.1 distinct. Copie V1322 réutilisée : galio-passive-conversion-links-v546.json, 428850 octets, SHA f2251457c241927378d456266e7e3ec89a9891c28c9265175610ece1ff4b4692. Identité vérifiée avant usage, aucun nouvel asset récupéré.

Le pointeur /native_metadata/buff expose BuffName=GalioRunicSkin, BuffTextureName=Galio_RunicSkin.dds, PersistsThroughDeath=true et Nondispellable=true. La graphie Nondispellable reste exacte : aucune normalisation vers NonDispellable ou équivalence de parser déduite. GalioRunicSkin.luaobj : 214 octets, SHA ac562233c9d06990c45a1f3fb97d06595f10ec263d653b785cb5c5112f2ceb43. La carte plate reconnue ne fournit pas ici de contrat exhaustif du lecteur ou de callback serveur. Sans AutoBuff reconnu dans cette carte, aucun effet natif n’est déclaré absent.

Définition et buff nomment la même icône et le même LuaName. V1215 identifie deux DDS au même contenu ; égalité des octets ne prouve ni alias effectif ni priorité. Les références preload galiorunicskin/apbonusdamagetotowers restent déclaratives, non recettes exécutées.

Les textes en_GB annoncent 50 % de RM totale ; le producteur @f1@ reste inconnu. Ancienne description AP par tiers d’armure/RM, Passive1=9 et niveaux 3/7/11 conservés sans adoption ni rang qualifié. SpellBlock=32.099998474121094, croissance 1.25, BaseSpellBlock nul restent distincts. Aucun accès D, décodage, shader, comparaison de pixels ou lecture DDS nouveau.

## 3. Consommateurs réels

Quatre fichiers courants inspectés : progression, shop, lib et projected_live. Leurs identités concordent avec V1215 ou les preuves communes ; 14 identités de mécanismes VFX partagés sont inchangées. Neuf ancres exactes relient les champs Stats AP/RM, stats(), sommes d’objets et calculs courants.

Dans stats(), AP=items.ability_power × altar_damage_multiplier ; la RM conserve base, croissance, objets et modificateurs existants. Le calcul AP lu n’utilise pas la RM. Cela préserve les consommateurs génériques sans prétendre réaliser la conversion Runic Skin. Les noms Galio/GalioRunicSkin/RunicSkin/Galio_RunicSkin n’apparaissent pas dans les quatre fichiers examinés ; ce constat n’est pas une absence globale.

projected_live filtre explicitement Annie et sa ressource Q. Providers, attaches, horloges et registres communs ne deviennent pas une liaison Galio par leur seule présence. Consommateurs enregistrés conservés, sans nouvelle association de registre. Icône HUD, AP/RM affichées et effet en monde restent distincts.

## 4. Attendu, observé et contrôles

Attendu : reconnaître valeurs/types et provenance, puis établir le chemin courant ou sa limite précise. Observé : 44/44 contrôles documentaires et 38/38 de cohérence séparée du même agent réussissent sur le reçu original et quatre entrées courantes retenues.

Cas nominal statique : valeurs buff/définition rapprochées, calculs AP/RM et sommes d’objets identifiés. Limites : ni conversion MR→AP spécifique dans l’affectation AP lue, ni état/recette/rendu Runic Skin établi dans ce périmètre. Le filtre de projected_live admet Annie ; aucune exécution du refus d’un owner Galio n’est revendiquée. Flags de persistance et répétition des descriptions ne démontrent ni callback ni rangs.

Les profils diagnostiques V546, leurs modificateurs et limites d’ordre restent hérités, non rejoués. Identités de sources et anciennes observations de binaires ne constituent pas une nouvelle exécution. Aucun build, test Rust, jeu, GPU, réseau, REA, probe ou lecture native ce tour.

## 5. Écarts et inconnues

Applicabilité d’un effet en monde, recette, état autoritaire, activation initiale, owner/skin, audiences, attache, cadence, ouverture/montage et rendu restent ouverts. Le coefficient 0.5 textuellement référencé ne résout pas @f1@, l’ordre des multiplicateurs ou la politique serveur. Nondispellable et PersistsThroughDeath sont des déclarations conservées, non comportements exécutés.

Aucun effet continu ou d’impact n’est inventé depuis Runic Skin, son icône ou une statistique. V1322 demeure immuable ; ce supplément qualifie une vue plate partielle. Aucune tâche SOURCE/VFX complète, feature, inconnue, acceptation ou goal close. Vérification d’identités aux lectures, sans garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Galio-PASSIF-PRESENTATION-VFX avec les clauses source-applicability-recipe, state-consumer-link et resource-selection-render. Préconditions, objectifs uniques, fins et reprises dans corrections_and_restart.json. Fin : applicabilité et recette étayées ou absence bornée justifiée ; état et consommateur reliés ; ressources, sélection, cycle et audiences vérifiés avant acceptation visuelle. SOURCE/SIMULATION-CONTRAT/NETWORK et HUD conservent leurs critères.

Reprendre sur source, appel, capture ou lecteur nouvellement qualifié, dérive ou anomalie pertinente. Pas de replay inchangé ; une texture recréée ne résout pas une recette inconnue. Prochain lot : CH-Garen-PASSIF-PRESENTATION-VFX, qualifier le petit reçu source ancien déjà retenu puis les consommateurs réellement cités.

## 7. Livraison et cohérence

Preuves : E:/mapslol3v3/audit_sys01202_galio_passive_vfx_20261105, fichiers initial_scope, inspection, current_inspection, evidence_review, coherence_review, corrections_and_restart et journaux. Relecture séparée du même agent, non indépendante ni acceptation humaine ; sept rubriques examinées.

Publication limitée au rapport et ajouts CURRENT/HANDOFF avec sauvegardes exactes ; sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2313 entrées sales groupées préexistantes conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, relance, suppression ou mutation Git.
