# Passifs — couverture documentaire préalable des effets visuels

2026-11-05 · V1314 · AUD-SYS-01.2-02-PASSIF-VFX-COVERAGE-PREFLIGHT-01

## 1. Exigence et périmètre

SYS-01.2-02, OLF-3a11ace9-485c-55ae-8dff-2533902a5839. Identifier les preuves VFX existantes, vérifier leurs consommateurs actuels et sélectionner un lien précis restant à examiner. Périmètre :122IDs CH-*-PASSIF-PRESENTATION-VFX du snapshot gelé ;1098autres rôles et reste du goal exclus. Ce n'est pas un nouvel audit individuel de122renderers.

Audit préalable clôturable après publication vérifiée. Implémentation non modifiée, partielle pour Annie ; vérification documentaire/statique, anciens contrôles hérités ; acceptation humaine non donnée. Tâches, dépendances NETWORK, six prérequis de lots et inconnues conservés, sans prérequis déclaré accepté.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Sources réutilisées :

- V669, 2026-10-27T09:19:18.499402+00:00,4434580octets,SHA4888b15a9b1b81f6a1b8434bd9a958f9ea178a53624b772f838fdb6c929f3a0b :121fiches,382sources liées,cinq frontières de résolution.
- V668, 2026-10-27T08:45:09.340359+00:00,89618octets,SHA1c10e5a7e5ff026f759c98fd0798578bdf33369aeb47c5592ac2131cdd81c6f9 :Annie,huit ressources,dix points dont huit implémentations partielles.

Les382liaisons,385ressources/candidats examinés par V669 et les huit ressources Annie conservent leurs preuves historiques. Aucun fichier natif D, Troy, DDS ou banque n'est relu. Les contrôles V66916/11refus et provider9/5refus, ainsi que V66898champs/quatre textures/11contrôles dont8refus restent hérités. Aucun nouveau décodage, comparaison de pixels ou sonde Rust.

Les observations natives distinguent267champs absents,37vides et20nommés ; nommer un effet ne prouve ni activation ni nécessité. Indicateurs désactivés, métadonnées de skins et candidats multiples restent explicites. Les sept noms sans candidat dans l'ancien scan ne sont pas déclarés assets manquants.

## 3. Consommateurs réels et réutilisation

Seize CIDs enregistrés,16ancres exactes vérifiées :chargeur initial, cinq frontières communes V669 et dix points Annie V668. Quinze fichiers de code/données inspectés, 10 chemins d'entrées compilées distincts ;neuf comparaisons avec des identités V668/V669 concordent. Les autres entrées courantes sont épinglées, sans prétendre disposer d'un ancien pin pour chacune.

map_resource_provider résout des noms et enregistre les catalogues ; ce n'est pas un renderer complet. Les481requêtes historiques uniques donnent142résolutions et339sans résultat dans ce profil, pour504associations :ces nombres ne sont pas un inventaire d'assets manquants. Les wrappers et Bevy ne sont pas réexécutés ; un chemin logique ne prouve pas l'ouverture du Troybin.

Les mêmes498fichiers Rust du client existent et leurs octets concordent avec les pins V669. Cela autorise la réutilisation de ses observations lexicales bornées, sans refaire la recherche121fois ; cela n'exclut pas un chargement dynamique ou d'autres chemins non couverts.

Annie conserve la sélection snapshot vivant/pyromania>=4, le matériau, la texture de base, les quads, l'horloge, le retrait d'éligibilité et le shader. Les variantes Freljord, ready2, attaches, blend/audiences et fidélité native restent ouvertes. Le diagnostic courant vérifie encore le parent E:\OpenLeague\logs à la ligne113 ; il n'est pas exécuté sur F.

## 4. Attendu, observé et contrôles

Attendu :122IDs, dépendances et questions rapprochés des preuves121+1, consommateurs et réutilisation vérifiés, prochain lien concret sélectionné. Observé :636/636contrôles documentaires ;516/516identités courantes, snapshot amont et sept registres protégés concordants, aucune dérive. Phase d'empreintes :524chemins uniques/933469434octets lus en flux, sans interprétation des grands registres. Les captures des entrées effectivement lues par les producteurs sont conservées séparément ;aucun gain avant/après chiffré.

Premier bootstrap code1 :format des prérequis Annie supposé enveloppé par package. Original et journaux conservés ;reprise code0 avec field.required_package_ids, en réutilisant les deux primaires et le snapshot retenus sur E. Aucun résultat de fonctionnalité changé pour passer le contrôle.

Aucun build, test Rust/Bevy, jeu, REA, VM, réseau, GPU, probe de résolution ou recherche native nouvellement exécuté. Les anciens audit_command et identités d'observations Fwork restent des données, pas des commandes à rejouer. Anciennes écritures de registres/bases V668/V669 non reproduites.

## 5. Écarts et limites

Disponibilité de ressource, résolution, ouverture/conversion, déclenchement, attache, rendu, visibilité et acceptation sont des étapes distinctes. L'icône HUD d'Ezreal et ses effets R ne sont pas promus en VFX du passif. BloodSlash Shared n'établit pas la priorité native/skin ; CyberEzreal/ZiggsSnowday/KhazixSkin02 restent des métadonnées non qualifiées.

Ce lot réutilise deux périmètres existants et clôt seulement leur examen préalable. Aucune clôture individuelle, tâche VFX complète, feature, inconnue, acceptation ou goal. Empreintes stables pendant lecture, pas garantie globale contre toute modification concurrente.

## 6. Corrections et prochain lot

Réutiliser les121fiches V669 et AnnieV668 ;ne pas refaire le scan12065Troy, les498recherches textuelles ou les probes inchangées. Reprendre une observation seulement sur source nouvelle, dérive, changement pertinent ou clause précise non couverte.

Prochain lot :CH-Akali-PASSIF-PRESENTATION-VFX, OLF-6cbf2fa0-a1e6-5f8b-acb8-c1046e7a06f4. Deux mentions natives documentées :akali_twinDisciplines_DMG_buf.troy→L_hand et akali_twinDisciplines_AP_buf.troy→R_hand, provenant d'AkaliTwinDisciplines.luaobj ;Troybin candidats présents historiquement. Les conditions, variantes, conversion et dispatch de scène restent à relier.

COR-AKALI-PASSIF-VFX-SOURCE-TRIGGER-RENDER-01, proposition liée à cette tâche existante :identifier l'état et le déclencheur réel, suivre le chemin consommateur vers chacune des attaches/ressources, documenter absences et limites, puis définir les vérifications attendues. Fin d'audit :source→état→consommateur établi ou manque précisément borné, avec critères de correction ;pas une affirmation de rendu complet sans preuve. Réutiliser V669 et les preuves du passif avant acquisition nouvelle.

COR-ANNIE-READY-DIAGNOSTIC-ROOT-01 :condition préalable à tout futur diagnostic F, adapter séparément la racine autorisée puis vérifier succès/refus de chemins ;aucune correction produit réalisée ici. Ready2, Freljord et fidélité restent dans CH-Annie-PASSIF-PRESENTATION-VFX.

## 7. Livraison et cohérence

Preuves E:/mapslol3v3/audit_sys01202_passive_vfx_preflight_20261105 :initial_scope,current_preflight_evidence,current_identity_verification,coverage_review,bootstrap_schema_qualification,journaux. Relecture séparée du même agent, pas indépendante ni acceptation humaine. Sept rubriques relues avant décision.

Publication limitée au présent rapport et ajouts CURRENT/HANDOFF sauvegardés exactement ;sept registres à maintenir identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2301entrées sales groupées conservées. Goal/Plan/UI/bases/produit/assets inchangés. Aucun pourcentage global d'achèvement ;goal actif.
