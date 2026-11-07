# SYS-01.2-02 — Tryndamere : Battle Fury et HUD, V1285

5 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-TRYNDAMERE-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Tryndamere-PASSIF-PRESENTATION-HUD`, `OLF-50454b13-7788-5cbb-b0d4-1ec3b45a0278` : relier icône, texte, ressource et état critique aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false ; dépendance NETWORK, inconnue `OLU-817135c5-99f0-54b4-9b50-96d1e02b76ca` ouverte. Six contrats et prérequis D06/D06-CH-Tryndamere consultés sans satisfaction revendiquée. V537 et propriétaires des questions conservés ; aucune nouvelle clôture d’Ashe, de QWER ou du parent SIMULATION.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/ashe-tryndamere-passive-boundary-links-v537.json`, 370589 octets/SHA `134107704ce06d179a91ace60f29ad192ee2bf3479e1fe9a2a3ca45285004432`, UTC documentaire 2026-10-25T15:44:19.588821+00:00.

HUD enregistré : définition/CharScript, un catalogue. SOURCE : cinq relations/trois identités/six sites. Font supplémentaire V537 conservée ; union16 ancres/huit fichiers. Sept archives,465003 octets, sélectionnées sur E avant lectures F/OpenLeague-work ; aucune relecture native des INIBIN/Lua/font ni des1158 dépendances historiques.

Définition1799 octets/SHA `4535a4c3d7617442e754311ef57c5ba4972770cbf89be3f93cd6ca0a7d1a7aa8` : alias littéral **Battle Fury**, icône Tryndamere_Passive.dds, PARType **Battlefury**, clé de nom native. Passive1Desc absent ; anciens niveaux1/4/7 non promus en politique actuelle. Candidat exact Spells/Battle Fury.inibin avec espace ; clé tooltip Battle_Fury avec underscore conservée distinctement. CharScript56 vide sans callback enfant ; aucun corps serveur récupéré par ces métadonnées.

Font miroir d’identité native vérifiée :1705 décrit5 Fury par frappe normale ou10 par critique,10 supplémentaires par élimination, perte5/seconde après8 secondes hors combat et +0,35 point de critique par Fury ; bonus courant @f1@. Description4292 mentionne consommation par Bloodlust ; nom4468 résolu. Ce sont des textes natifs, pas une exécution serveur ni une politique complète d’événements/arrondis.

DDS propre HUD/Icons2D :2176 octets,64×64 DXT1, compteur brut de mips0, SHA `d427686caa181ef7c5884a027d085fb3763b7f06a8f2ca9094b68a7f4108eba5`, membre0.0.0.237 du projet0.0.1.7. Taille/MD5 concordants ; unique stat/lecture SOURCE après sélection E. Aucun DDS étranger/particule lu ; provider/pixels ouverts. Le hash resource.source_sha256 identifie le StatsJSON décodé4799 octets, distinct de l’INIBIN ; resource_provenance.json.

## 3. Consommateurs actuels

16 ancres exactes,26 fichiers code/configuration ;16 entrées communes et14 identités comparables V537 inchangées. Les dix frontières V537 restent entry_boundary_only/provides_feature_consumer=false.

progression.rs:92 calcule critique depuis profil de base, croissance et objets ; attacks/critical/lifesteal traitent préparation, tirage et frappe. Ces chemins génériques ne deviennent pas Battle Fury. lib.rs:563 initialise mana depuis def.mana ; lifecycle limite la restauration Mana/Energy. La réapparition remplit Mana/Energy/Wind, remet sinon le scalaire à0 : acquis partiel conservé, avec test Tryndamere dédié, non exécuté ici.

Le type courant Battlefury n’entre pas dans les branches Mana des barres et nombres HUD. Ces chemins omettent donc sa jauge/nombre de ressource ; aucune présentation complète de Fury déduite du scalaire mana100. Les maxima QWER ne prennent pas Tryndamere en charge. Widget passif Ezreal et libellé diagnostic Annie restent spécifiques.

La seule occurrence nommée dans les sources Rust sélectionnées est lifecycle.rs:142, à l’intérieur du test de réapparition. Aucun producteur ou widget nommé dans le code de production inspecté ; recherche bornée, sans absence mondiale inférée.

## 4. Attendu, observé et contrôles

Deux diagnostics V537 distincts : vrai core/Map10, déplacements publics, aucun champ injecté. Préparation normale non critique libérée au tick799 ; Garen passe616.280029296875→568.1555786132812 PV. Texte natif :5×0,35=**1,75 point** de critique attendu ; observé0. Trois mesures supplémentaires aux ticks800/829/1009 restent0 ; mana100 est un scalaire, pas un compteur Fury qualifié.210 ticks=sept secondes : aucune décroissance après8 secondes testée.

Témoin Garen :0→8 % après achat1051→0 après vente ; joueur inconnu, cible inconnue et cible propre refusés dans les archives. Chaque RUN brut contient six/trois objets JSON ; tous les progrès sont conservés et le résultat final égale OBS. BUILD/RUN hérités0 ; aucun rejeu ici.

Binaires hérités non recopiés/non rehashés :5973504 octets/SHA `4670977346ebb26c7d662c6456a91e2e507d0f0019195e4b35b66cc9ddf2c31c` ;5961216 octets/SHA `1ddcfe2547dfac613ffe9ae43db3d33b52d4b797194d4f32fbce356990d7f27f`. Chemins et commandes détaillés dans les preuves.

89/89 contrôles corrigés,75/75 cohérence séparée du même agent. Premier lecteur arrêté sur un objet de progression : original/logs conservés, lecture de flux corrigée sur copies retenues. Résultat initial88/89 conservé ; seul le hit du test est requalifié,88 autres contrôles identiques. Une préparation de reçu et une fenêtre exploratoire ont échoué avant correction, sans modification produit. Ni nouveau build/jeu/VM/REA/rendu/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Compteur autoritaire, gains critiques/éliminations, cap, décroissance, consommation Q, f1, ordre/arrondis/lifecycle historiques, transport et pixels restent ouverts. Le défaut observé concerne le gain critique après une frappe normale dans ces diagnostics ; il n’est pas corrigé. Réapparition partielle existante préservée. Les questions SOURCE/SIMULATION restent chez leurs propriétaires.

## 6. Corrections et reprise

`COR-TRYNDAMERE-BATTLE-FURY-POLICY-01` : qualifier événements, cap, temps hors combat, arrondis et f1. Fin : contrat sourcé sans assimilation mana100/Fury ni ancienne table1/4/7.

`COR-TRYNDAMERE-BATTLE-FURY-STATE-01` : produire l’état autoritaire et ses transitions ; conserver le reset de réapparition existant. Fin : frappe normale/critique/élimination, frontières temporelles et invalides vérifiés ; consommation Bloodlust dans sa tâche propre, sans bloquer le gain de base sur QWER.

`COR-TRYNDAMERE-BATTLE-FURY-CRITICAL-01` : relier le bonus qualifié aux statistiques et au tirage, sans remplacer le catalogue partagé. Fin : gain1,75 point du cas nominal, bornes/interactions validées selon contrat ; RNG reconstruit distinct de Riot.

`COR-TRYNDAMERE-BATTLE-FURY-HUD-BINDINGS-01` : intégrer jauge/nombre Battlefury, icône, textes et f1 depuis l’état autoritaire. Fin : transitions, audiences, tooltip et pixels observés ; aucun rang appris/cooldown inventé. Reprendre sur source/callsite nouveau, dérive ou autorisation fonctionnelle.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_tryndamere_passive_hud_20261105` : archives, evidence_review_corrected/coherence_review, qualifications, DDS, prérequis et journaux. Contrôle hook7/7 réutilisé ; limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes et sept protégés contrôlés à la publication. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
