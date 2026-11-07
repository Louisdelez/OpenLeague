# Garen — reçu ancien et liaison des VFX de Persévérance

2026-11-05 · V1327 · AUD-SYS-01.2-02-GAREN-PASSIF-VFX-LEGACY-SOURCE-CURRENT-LINK-01

## 1. Exigence et frontières

SYS-01.2-02 ; CH-Garen-PASSIF-PRESENTATION-VFX, OLF-aeb4847c-a135-5d5c-a857-5fd1cff056c1. Qualifier la structure du petit reçu ancien laissé non mappé par V1322 et ses consommateurs pertinents. Conserver le critère complet des effets de lancement, trajet et impact applicables, la dépendance NETWORK, les phases et lots. Aucun prérequis accepté implicitement.

Audit de ce lien documentaire clôturable après publication vérifiée. Implémentation partielle conservée ; vérification statique/documentaire ; acceptation humaine non donnée. Inventaire natif exhaustif, décodages, correction du jeu et rendu exécuté exclus. L’ancien audit HUD V1217 reste distinct, non recompté.

## 2. Sources, provenance et portée

PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus, catalogue 4.20.1 distinct. Copie V1322 réutilisée : garen_passive_source_audit.json, 3613 octets, SHA 0f326982606a4eb8b69fdfde68f628f253ee1dc3943b6ec4b5e6077eef3b5a54. Source complete=false et native_script_body_present=false conservés, sans transformation en tâche achevée.

/native_sources contient quatre descriptions : CharScriptGaren, GarenPassive, GarenPassiveCooldown, GarenPassiveHeal. Comptes d’instructions 1/13/9/13, zéro fonction enfant, quatre lectures structurelles complètes rapportées. Les 22 entrées de constantes sont conservées comme constantes, sans affectations globales reconstruites ni callback serveur déduit. Le reçu ne donne pas ici la taille de chaque Lua ; les SHA et limites restent explicites.

SHA hérités : CharScript7402c822…, Passive911a0020…, Cooldownd9996e37…, Heal1c014063…. Les noms Garen_Perseverance.dds, Garen_PerseveranceCD.dds et Garen_Passive.dds sont des références dans les tables de constantes. V1217 distingue trois DDS et trois contenus ; icône ne signifie pas texture de particule en monde. Aucune nouvelle lecture D, interprétation Lua, ouverture DDS ou mesure de pixels.

Le reçu ancien cite fontconfig_en_US ; la preuve en_GB de V1217 reste distincte. Tooltips dynamique et statique contradictoires conservés ; producteurs f1/f2/f3 inconnus. Les paliers locaux proviennent d’une copie republiée de notes 4.17 attribuées à Riot et du texte dynamique, pas d’un serveur original qualifié ni d’une vérification web nouvelle.

## 3. Consommateurs réels préservés

Six entrées courantes inspectées : garen_passive.rs, regeneration.rs, damage.rs, lib.rs, projected_live.rs et garen_passive_rules.json. Identités concordantes avec V1217 ou les preuves communes ; 14 identités de mécanismes VFX partagés inchangées. Quatorze ancres exactes relient le contrat inclus, sélection de palier, getter, interruption, événement de capacité, régénération et timestamp.

garen_passive_per_second et note_garen_damage sont des producteurs spécifiques partiels réels. Le getter exclut joueur inconnu, autre champion, mort et partie finie ; Some(at) impose un délai relatif au niveau courant, None ne le bloque pas. advance_regeneration ajoute le taux passif à la base/objets avant multiplicateur de soins et plafond HP. damage appelle note_garen_damage. perseverance_interrupted_at est conservé et initialisé à None.

projected_live filtre Annie et sa ressource Q ; il ne constitue pas une liaison de Persévérance. Son corps ne contient pas les noms spécifiques recherchés. Les modules Garen Q/W et les aides communes ne sont pas promus en VFX du passif. Aucune absence globale de consommateurs, ressources ou chargement dynamique déduite. Associations enregistrées conservées, sans modification du registre.

## 4. Attendu, observé et vérifications

Attendu : structure et constantes qualifiées, producteur partiel préservé, lien visuel établi ou manque précisément borné. Observé : 42/42 contrôles documentaires et 56/56 de cohérence séparée du même agent réussissent sur le reçu original et six entrées courantes retenues.

Cas nominal statique : paliers 1/11/16, délais 9/6/4 secondes et taux locaux 0.004/0.008/0.02 HPmax/seconde importés par le code ; ajout du soin identifié. Limites/refus lus : getter nul pour les états exclus, exemptions alliés/sbires et monstres ordinaires après niveau 11, refus événement cible inconnue/morte ou partie finie. Ces branches ne sont pas exécutées ce tour.

Les anciens quatre contrôles core et six réseau restent hérités ; aucun binaire historique n’est requalifié. Aucun build, test Rust, jeu, GPU, réseau, REA, probe, interprétation native ou comparaison de pixels nouvellement exécuté.

## 5. Écarts et inconnues

Les constantes ne fournissent pas les valeurs des flags ni la recette complète. Ni zéro fonction enfant ni lecture structurelle complète ne récupèrent la logique serveur. Corps natif, événements de toutes les capacités, cadence, boucliers, sources environnementales et transitions de niveau/mort/retour restent partiellement reconstruits.

La machine locale d’interruption/soin n’établit pas applicabilité visuelle, sélection attente/soin, owner/skin, audience, attache, ouverture/montage ou rendu. Aucun effet inventé depuis l’icône ou le taux de soin. V1322 demeure immuable ; ce supplément qualifie la structure ancienne. Aucune tâche SOURCE/VFX complète, feature, inconnue, acceptation ou goal close. Vérification d’identités aux lectures, sans garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Garen-PASSIF-PRESENTATION-VFX : clauses native-visual-contract, state-presentation-link et render-cycle-acceptance. Préconditions, objectifs, fins et reprises dans corrections_and_restart.json. Fin : applicabilité/recette étayée ou absence bornée justifiée ; état et consommateur reliés ; ressources, cycle et audiences vérifiés avant acceptation visuelle. SOURCE/SIMULATION-CONTRAT/NETWORK et HUD conservent leurs propres critères.

Reprendre sur source, appel, capture ou lecteur nouvellement qualifié, dérive ou anomalie pertinente. Pas de replay inchangé ; préserver la mécanique partielle et ne pas forcer une reconstruction de texture sans recette qualifiée. Prochain lot : CH-Ezreal-PASSIF-PRESENTATION-VFX, qualifier les vues natives/contextuelles du reçu V665 déjà retenu, puis les consommateurs nécessaires.

## 7. Livraison et cohérence

Preuves : E:/mapslol3v3/audit_sys01202_garen_passive_vfx_20261105, fichiers initial_scope, inspection, current_inspection, evidence_review, coherence_review, corrections_and_restart et journaux. Relecture séparée du même agent, non indépendante ni acceptation humaine ; sept rubriques examinées. Formulation héritée du contrat de lot corrigée avant collecte, original sauvegardé ; tâche et frontières inchangées. Qualification de l’étiquette Galio réutilisée sans réécriture.

Publication limitée au rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2314 entrées sales groupées préexistantes conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, relance, suppression ou mutation Git.
