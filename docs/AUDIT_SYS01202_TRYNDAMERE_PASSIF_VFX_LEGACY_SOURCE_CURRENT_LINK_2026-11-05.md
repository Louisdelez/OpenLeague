# Tryndamere — sources et consommateurs des VFX du passif

2026-11-05 · V1330 · AUD-SYS-01.2-02-TRYNDAMERE-PASSIF-VFX-LEGACY-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-Tryndamere-PASSIF-PRESENTATION-VFX, OLF-58b342ef-93a9-5ee8-ad9d-d6698bba7fc0. Relier les vues historiques disponibles et les consommateurs actuels pour Battle Fury. Contrat : effets de lancement, trajet et impact applicables ; dépendance CH-Tryndamere-PASSIF-NETWORK et prérequis D06/lot conservés, sans satisfaction implicite.

Fin de cet audit : provenance/portée, chemin actuel ou manque borné, vérifications et corrections précises. Audit documentaire terminé après publication vérifiée ; comportement spécialisé non établi dans les corps sélectionnés, acquis génériques et reset partiel conservés ; vérification statique, acceptation humaine non donnée. Inventaire VFX complet et exécution graphique exclus. Les deux associations Ashe sont préservées sans nouvel audit ni clôture.

## 2. Sources, identités et limites

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Copie V1322 de ashe-tryndamere-passive-boundary-links-v537.json : 370589 octets, SHA 134107704ce06d179a91ace60f29ad192ee2bf3479e1fe9a2a3ca45285004432, vérifiée avant lecture. V537 vise SIMULATION-CONTRAT/SIMULATION, pas un inventaire VFX exhaustif.

Métadonnées V1285 réutilisées : définition 1799 octets, SHA 4535a4c3d7617442e754311ef57c5ba4972770cbf89be3f93cd6ca0a7d1a7aa8 ; LuaName « Battle Fury », PARType Battlefury, icône Tryndamere_Passive.dds. Passive1Desc absent, distinct d’une chaîne vide ; valeurs anciennes 1/4/7 conservées sans politique de rang déduite.

CharScriptTryndamere.luaobj : 56 octets, SHA 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0, lecture complète, une instruction, zéro enfant, globals et témoins vides. Littéraux structurellement qualifiés, symboles moteur non résolus ; pas de corps serveur. Même contenu qu’un autre CharScript ne fusionne pas leurs identités. Cette vue ne prouve aucune absence globale d’effet.

Spells/Battle Fury.inibin, avec espace : 43 octets, SHA 53425253b03718bab833c766a83dae7fe849d0f1866e2cd66ef07674eedbe97d ; hash 2287725201→game_buff_tooltip_Battle_Fury. L’underscore du tooltip ne devient pas automatiquement un alias de fichier. Les lignes en_GB 1705/4292/4468 donnent règles textuelles, consommation Bloodlust et nom ; @f1@ reste littéral. Aucun texte n’est une recette de particule ou exécution serveur.

DDS hérité : 2176 octets, 64×64 DXT1, compteur brut de mips 0, SHA d427686caa181ef7c5884a027d085fb3763b7f06a8f2ca9094b68a7f4108eba5. Icône et effet en monde restent distincts. Le SHA resource.source_sha256 porte sur le StatsJSON décodé, pas l’INIBIN. Aucun natif, DDS, Lua ou font relu/décodé ce lot.

## 3. Consommateurs actuels et réemploi

Six fichiers relus : crates/core/src/attacks.rs, progression.rs, critical.rs, spells.rs, lifecycle.rs et crates/client/src/projected_live.rs ; onze ancres exactes. Les 26 entrées code/configuration du précédent audit HUD et les 14 identités communes VFX concordent. Anciennes conclusions HUD et frontières réutilisées sous ces empreintes, sans nouveau census global.

stats compose critique de profil, croissance et objets ; roll_critical refuse les entrées non finies/non positives et garantit chance>=1 avant SplitMix64 reconstruit. Tirage, frappe et projectile génériques ne produisent pas Battle Fury dans les corps inspectés. Recherche nommée nulle dans les six préfixes de production, sans absence globale affirmée.

lifecycle conserve le remplissage Mana/Energy/Wind puis zéro pour les autres ressources à la réapparition. Le test Tryndamere dédié reste du code de test, non exécuté ici ; le reset partiel n’est ni effacé ni assimilé à un compteur complet. projected_live sélectionne Annie Q. Les anciennes barres Mana et le widget Ezreal ne deviennent pas un rendu Fury.

## 4. Attendu, observé et contrôles

Attendu nominal statique : qualifier les vues disponibles, préserver les acquis, borner le lien visuel manquant. Observé : 56/56 contrôles documentaires et 40/40 cohérences séparées du même agent ; onze ancres et gardes d’identités concordantes. Refus lus : valeurs critiques invalides et branche Annie spécialisée ; aucune branche exécutée.

V1285 HUD 89/89 et cohérence 75/75 hérités, non recomptés. V537 : frappe normale au tick 799, +1,75 point de critique attendu d’après le texte, zéro observé ; mesures aux ticks 800/829/1009 également zéro. Écart conservé, non corrigé/rejoué. Snapshot mana100 n’est pas un compteur Fury qualifié ; sept secondes après frappe ne testent pas la décroissance après huit secondes. Deux diagnostics et leurs binaires restent hérités, pas de nouvelle preuve native/runtime.

Deux échecs de préparation conservés : resume confiné avec champs Git nuls, puis attente de label MATERIAL_PINS au lieu du contrat historique MATERIAL_INPUTS. Lecture Git avec permissions vérifiées et comparaison du SHA du résultat ont permis les reprises, sans redémarrer un jeu. Aucun build, test Rust, jeu, réseau, GPU, REA, lecteur natif ou accès/stat/résolution D nouveau.

## 5. Écarts et inconnues

Applicabilité visuelle, inventaire secondaire complet, recette, compteur/gains/cap/décroissance/f1, ordre, owner/skin, audiences, attache, cadence, montage et rendu ouverts. Définition, tooltip, icône ou critique générique ne suffisent pas à conclure. Questions VFX/SOURCE et consommateurs inscrits conservés exactement.

V1322 immuable ; zéro tâche SOURCE/SIMULATION/NETWORK/VFX complète, feature, inconnue, acceptation ou goal clos. Aucun pourcentage de jeu déduit ; vérifications aux lectures, sans garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Tryndamere-PASSIF-PRESENTATION-VFX : native-visual-applicability-contract, Fury-state-owner-world-binding et resource-lifecycle-render-acceptance. Objectifs, prérequis, fins et reprises dans corrections_and_restart.json ; corrections POLICY/STATE/CRITICAL de V1285 référencées sans duplication ou implémentation implicite. SOURCE, HUD, QWER et NETWORK gardent leurs critères.

Reprendre sur source/copie attribuable, lecteur, appel, capture ou dérive pertinente. Une texture générée ne résout pas une recette inconnue. Prochain lot : CH-Azir-PASSIF-PRESENTATION-VFX, reçu secondaire V559 déjà conservé, particularités de son passif et consommateurs nécessaires.

## 7. Livraison, relecture et conservation

Preuves E:/mapslol3v3/audit_sys01202_tryndamere_passive_vfx_20261105 : initial_scope, inspection, current_inspection, evidence_review, coherence_review, gardes et journaux, originaux échoués inclus. Sept rubriques examinées ; relecture séparée du même agent, ni revue indépendante ni acceptation humaine.

Publication limitée au rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes, sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2317 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
