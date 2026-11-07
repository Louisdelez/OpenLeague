# Dr. Mundo — source ancienne et liaison des VFX du passif

2026-11-05 · V1325 · AUD-SYS-01.2-02-DRMUNDO-PASSIF-VFX-LEGACY-SOURCE-CURRENT-LINK-01

## 1. Exigence et frontières

SYS-01.2-02 ; CH-DrMundo-PASSIF-PRESENTATION-VFX, OLF-cda44bf5-d8fe-58f4-b418-777217ad535a. Qualifier la vue ancienne du buff V542 laissée non mappée par V1322 et ses consommateurs pertinents. Conserver le critère complet des effets de lancement, trajet et impact applicables, la dépendance NETWORK, les phases et les lots. Aucun prérequis accepté implicitement.

Audit de ce lien documentaire clôturable après publication vérifiée. Implémentation non modifiée ; vérification statique/documentaire ; acceptation humaine non donnée. Inventaire natif exhaustif, nouveaux décodages, correction du jeu et rendu exécuté exclus. V542 et V1210 HUD restent des acquis distincts, non recomptés.

## 2. Sources, provenance et limites

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus, catalogue 4.20.1 distinct. Copie V1322 réutilisée : mundo-passive-healing-links-v542.json, 393747 octets, SHA f0ecfdacc8f27f8fb15207f9fc58bc4b04dc69992dd18abcee6b5dcac6b529e4. Identité vérifiée avant usage, aucun nouvel asset récupéré.

Le pointeur /native_metadata/buff expose quatre valeurs : BuffName=Nevershade, BuffTextureName=DrMundo_AdrenalineRush.dds, PersistsThroughDeath=true et NonDispellable=true. Nevershade.luaobj : 217 octets, SHA 283ee285c030820b23947a47b9a79317306551964c9020eac287d5cd810187af. La carte plate est reconnue ; elle ne fournit pas ici de contrat exhaustif du lecteur ou de callback serveur. L’absence d’AutoBuff dans cette carte ne prouve pas l’absence d’effet natif.

La définition conserve Passive1=1 et Passive1LuaName=Nevershade. Passive1Icon nomme DrMundo_AdrenalineRush2.dds, distinct du nom du buff. V1210 identifie trois DDS au même contenu ; ni alias effectif ni sélection native n’en découlent. Les références preload nevershade/apbonusdamagetotowers restent héritées, sans recette exécutée.

Les textes en_GB annoncent 0,3 % des PV maximum par seconde ; 0.003 est une conversion arithmétique, pas une cadence serveur récupérée. BaseStaticHPRegen=1.5520000457763672, BaseFactorHPRegen chaîne "0" et BaseHPRegen nul restent distincts. Ancienne description de dégâts sous faible santé non adoptée. Aucun accès D, décodage ou contrôle de pixels nouveau.

## 3. Consommateurs réels

Cinq fichiers courants inspectés : regeneration, healing, progression, lib et projected_live. Leurs identités concordent avec V1210 ou les preuves communes ; 14 identités de mécanismes VFX partagés sont inchangées. Dix ancres exactes relient calcul des taux de base/croissance/objets, avancée de régénération, supplément Garen, multiplicateur de soins, plafond de PV et calcul du maximum.

Les soins génériques, Ignite et Trundle restent présents. Ces voies ne sont pas promues en producteur Nevershade. projected_live filtre explicitement Annie et sa ressource Q ; il ne devient pas un renderer Mundo. Recherche nommée DrMundo/dr_mundo/Mundo/Nevershade/AdrenalineRush : aucun hit dans les cinq fichiers. Conclusion bornée, sans absence globale de code, alias, ressources ou chargement dynamique.

Les consommateurs enregistrés sont conservés, sans nouvelle association de registre. Catalogue, affichage HP/soins, icônes HUD et VFX en monde restent des périmètres distincts.

## 4. Attendu, observé et contrôles

Attendu : reconnaître les valeurs/types et leur provenance, puis établir le chemin courant ou sa limite précise. Observé : 42/42 contrôles documentaires et 38/38 de cohérence séparée du même agent réussissent sur le reçu original et cinq entrées courantes retenues.

Cas nominal statique : régénération de base et soins identifiés, filtre des vivants et plafonnement aux PV maximum présents. Refus lus dans heal : montant non fini/négatif et cible morte. Ces branches ne sont pas exécutées ce tour. La seule occurrence 0.003 de regeneration.rs est une tolérance de test Garen, ligne 83 ; aucun coefficient correspondant dans la partie de production. Ce nombre ne démontre donc pas l’implémentation du passif.

Les profils diagnostiques V542 sont hérités, non rejoués. Son ancienne hypothèse erronée achat de PV maximum/remplissage est conservée comme erreur de diagnostic, pas bug du jeu. Les valeurs locales et identités du binaire ne sont pas qualifiées par un nouveau lancement. Aucun build, test Rust, jeu, GPU, réseau, REA, probe ou lecture native ce tour.

## 5. Écarts et inconnues

Applicabilité d’un effet en monde, recette, état autoritaire, owner/skin, audiences, attache, cadence, ouverture/montage et rendu restent ouverts. Les flags du buff ne donnent ni comportement de mort ni persistance exécutée. Aucun effet continu ou d’impact n’est inventé depuis le seul mot Nevershade, une icône ou une variation de santé.

V1322 demeure immuable ; ce supplément qualifie une vue plate partielle, pas tout l’inventaire secondaire. Aucune tâche SOURCE/VFX complète, feature, inconnue, acceptation ou goal close. Vérification d’identités aux lectures, sans garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-DrMundo-PASSIF-PRESENTATION-VFX avec les clauses source-applicability-recipe, state-consumer-link et resource-selection-render. Préconditions, objectifs uniques, critères de fin et reprises dans corrections_and_restart.json. Fin : applicabilité et recette étayées ou absence bornée justifiée ; état et consommateur reliés ; ressources, sélection, cycle et audiences vérifiés avant acceptation visuelle. SOURCE/SIMULATION-CONTRAT/NETWORK et HUD conservent leurs propres critères.

Reprendre sur source, appel, capture ou lecteur nouvellement qualifié, dérive ou anomalie pertinente. Pas de rejeu inchangé ; refaire une texture ne résout pas une recette inconnue. Prochain lot : CH-Galio-PASSIF-PRESENTATION-VFX, vue ancienne buff V546 déjà retenue et consommateurs nécessaires.

## 7. Livraison et cohérence

Preuves : E:/mapslol3v3/audit_sys01202_drmundo_passive_vfx_20261105, fichiers initial_scope, inspection, current_inspection, evidence_review, coherence_review, corrections_and_restart et journaux. Relecture séparée du même agent, non indépendante ni acceptation humaine ; sept rubriques examinées.

Publication limitée au présent rapport et ajouts CURRENT/HANDOFF avec sauvegardes exactes ; sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2312 entrées sales groupées préexistantes conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, relance, suppression ou mutation Git.
