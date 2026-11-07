# SYS-01.2-02 — Soraka : sources et consommateurs VFX du passif, V1404

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-SORAKA-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé sur ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et frontières

`CH-Soraka-PASSIF-PRESENTATION-VFX`, `OLF-06682544-8ed9-5915-85ef-b1366feab536` : relier Salvation aux sources et consommateurs réels. Contrat,consommateurs et inconnues conservés ;implémentation/acceptation false,dépendance NETWORK ouverte. Inconnues VFX ['OLU-0af90e2c-dfae-5122-a3ed-aa7041c91eb6'] et SOURCE ['OLU-b6e45b19-35cb-52cb-9656-caabac3af1a6'] ouvertes. Prérequis D06/lot consultés sans satisfaction revendiquée. HUDV1276 réutilisé ;audit Q-VFX existant distinct,aucune seconde clôture Q/HUD. Parent,QWER et goal restent ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315,EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ;catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/soraka-passive-salvation-links-v633.json`,2668660 octets,SHA `fe82f93e26d1d9ba5c0f13b6f3248e10a0d9fd1f3bea9b9e0188f21f19be4491`. Métadonnées réutilisées sans nouveau décodage natif :74 identités,222 associations,29 sites ;18 INIBIN,29 Lua,25 preloads,DDF/font.

Définition :Passive1LuaName="Consecration Self" avec espace,icône Soraka_Passive.dds,vitesse325,PARType absent. Description Starcall/Infuse/Astral Blessing et niveaux8/15 conservés comme contexte ancien. Font1792 lie exactement70% de vitesse bonus vers un champion allié sous40%PV,dans2500 unités. SorakaPassive2684 et description4282 moins précis. Cinq BuffData exactement résolus,sans alias automatique. Garde du miroir font inchangé,sans nouvelle analyse des lignes.

29 Lua :14 initialisations littérales,21 globals,15 limites NEWTABLE,zéro prototype enfant selon reçus ;chemins complets conservés. Aura221 déclare Consecration Self,Soraka_Consecration.dds,persistance/non-dispellable ;NoParticle154 déclare Consecration. Marker/Orient110 n’indiquent que root. CharScript/Falloff56 vides ne qualifient pas callback/expiration. Passive282 contient soraka_base_passive_speed.troy,mais sa vue littérale est refusée à NEWTABLEpc6 :aucun mapping évalué déduit.

Quatre vues AutoBuff/cinq champs :Marker/Orient root,EPacify LOC_Silence/head et StarBuff Jayce_Wall_Accel_Buf. Silence E,Recall Syndra/Draven et Jayce restent distincts. DDF16 lignes,unique lien InfuseWrapper;f1→mana×0.05,aucune formule Salvation. Limites communautaires QHaste/Qcentre,Wpaiement/soin,Eancien etR conservées,sans moteur C# exécuté.

25 preloads :6197 octets reconstruits exactement en CRLF depuis Discovery conservé ;75 références (54 particules,18 sorts,trois personnages). Char639 référence Aura,Passive,Marker/Orient et contextes W/R/Recall. Passive97 précharge Falloff. Marker188 précharge orianaballindicatornear et passive_cross. Orient286 précharge cross,passive_indicatior et indicator_medium ;orthographe "indicatior" conservée,sans correction/alias silencieux. NoParticle105 précharge pourtant consecrationaura_tar. Ces dépendances ne prouvent pas sélection,création,orientation ou recette.

Un DDS E relu :Soraka_Passive,2176 octets,64×64 DXT1/mip0,membre0.0.0.251,SHA718bc762…. Ancien provider Soraka_Consecration ouvert ;quatre occurrences étrangères héritées du HUD,non relues,aucun alias current/legacy déduit. Aucun payload Troy ouvert. Mana courant :source_sha256 communautaire50c3a8e5…,distinct du natifc6d7f0e3… ;PARType absent ne déclare pas Mana.

## 3. Consommateurs actuels

17 fichiers relus,dont15 Rust/deux lecteurs Python ;35 ancres exactes. Seize fichiers de frontières/SOURCE,29 contextes,miroir font,14 mécanismes VFX communs et deux fichiers d’animation ordinaire concordants. Aucun producteur nommé Soraka/Salvation/Consecration dans ces15 Rust,sans absence globale revendiquée.

movement.rs:53–56 compose vitesse de base,objet et modificateurs existants ;progression.rs:118 expose cette vitesse ;spells.rs:120 refuse les sorts non implémentés. Positions,équipes et pools existent,sans événement Salvation ou consommateur d’orientation démontré. Les mécanismes VFX communs ne prouvent ni recette,lookup,owner,pose,horloge,arrêt ou pixels.

## 4. Attendu et observé

Attendu :bonus conditionnel,déplacement et effets attribuables. Quatre profils conservés base/Bottes×allié sain/blessé ;26 projectiles Annie blessent Garen,240 trames de marche,huit ordres,112 refus,douze arrivées,deux achats,sans vente/rachat ni injection d’état.

Relecture géométrique actuelle :240 paires X/Z,continuité,pas,cosinus,distances et ratios concordants. Sur60 trames vers l’allié blessé :cosinus>0.99,PV≈21.92–22.42%,distance<801 ;conditions textuelles nominales exercées sans bonus observé. Distances sur30ticks :324.990234375/349.9951171875,vitesses325/350,identiques sain/blessé et vers/opposé. Tolérance0.02 sur la distance,écarts conservés. Ce contrôle géométrique ne définit pas l’angle natif.

26 impacts/PV/ratios et calcul physique avec armure relus ;chaque contribution de régénération non recalculée. Refus contrôlés par flags,pas par garde NPC universelle. Aucun sort Soraka accepté ;ce refus n’empêche pas d’exercer le déclencheur de mouvement.

43/43 contrôles documentaires,96/96 cohérence même agent ;anciens96/96 et89/89 hérités. Six productions journalisées réussies et une première cohérence échouée,conservée :catalogue dans les29 contextes,absent des17 entrées ciblées ;reprise avec capture exacte et garde actuelle. Deux erreurs de préparation/contexte également conservées. Premier BUILD historique101/E0382 distinct du BUILD/RUN owned0. Binaire6095872/SHA62390fa1… inerte ;aucun nouveau jeu exécuté.

## 5. Écarts et limites

Activation/retrait conditionnels non observés ;angle,sélection/visibilité,seuils/range exacts,ordre des softcaps,interaction,lifecycle,provider/alias et transport ouverts. Recettes/payloads,création/owner,pose/orientation,horloges/arrêts et pixels non qualifiés. Aucun nouveau build/jeu/natif/REA/GPU/réseau ;V564/Nami et autres clauses conservés. Cohérence même agent,aucune validation indépendante/humaine.

## 6. Corrections et reprise

corrections_and_restart.json contient quatre clauses SOURCE/SIMULATION/NETWORK/VFX :qualifier politique/recettes ;produire activation/retrait ;transporter allié/direction/horloge ;relier speed/marker/orient à leurs consommateurs. Fins précises :sain/blessé,vers/opposé,39.99/40/40.01%,autour2500,virages,multi-alliés,visibilité,objets/slows,lifecycle,reconnexion et pixels selon contrat qualifié. Conserver les quatre contrôles publics. Reprendre seulement sur source,mapping/callsite,recette/payload/capture précise,dérive ou autorisation fonctionnelle distincte. Aucun correctif produit ici.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_soraka_passive_vfx_20261106 :evidence_review/coherence_review,gardes,journaux et coherence_failure_resolution.json. next_lot.json cible Swain,ligne de couverture vérifiée ;chercher ses audits existants avant reprise.

Une unité de liaison bornée close ;zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. Rapport et ajouts CURRENT/HANDOFF uniquement,après sauvegardes exactes et contrôle des sept protégés. Goal/Plan/UI/bases/registres/produit conservés.
