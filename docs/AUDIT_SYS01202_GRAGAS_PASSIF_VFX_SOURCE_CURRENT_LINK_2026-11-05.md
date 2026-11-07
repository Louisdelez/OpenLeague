# Gragas — liaison bornée du passif et des effets visuels

## 1. Exigence et portée

2026-11-05, V1345 ; `AUD-SYS-01.2-02-GRAGAS-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Gragas-PASSIF-PRESENTATION-VFX` ; `OLF-3290de2d-0a7b-577a-865a-635cff4aafc4`. Qualifier les déclarations conservées et les consommateurs courants nécessaires à leur liaison. L’inventaire VFX complet, l’implémentation et l’acceptation ne sont pas clôturés.

Audit : terminé pour cette liaison bornée. Implémentation : passif non qualifié par ces preuves ; acquis génériques conservés. Vérification : statique documentaire réussie, runtime non réexécuté. Acceptation humaine : non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/gragas-passive-happy-hour-links-v573.json`, copie immuable E référencée dans `initial_scope.json` : 875740 octets, SHA-256 `c27c66f723d83b10f76e29c0685cacb754c44fd80349e92a263b168f8aa6a968`. Référence LoL4.20/EUW/en_GB héritée. Les chemins natifs D restent des chaînes documentaires ; aucun accès direct. V1218 source59/59, consommateurs51/51 et intégration40/40 restent historiques, non réexécutés.

Sept Lua structurels, six initialisations littérales/30 affectations ; CharScript56 vide. Passive187 : BuffName=GragasPassive, BuffTextureName=GragasPassiveHeal.dds, PersistsThroughDeath=true ; ce flag n’est pas une exécution serveur. W548 reste limité par NEWTABLE au pc16. Q/QToggle DoesntTriggerSpellCasts=false/true ne définit pas les sorts éligibles. QToggle conserve Flash Frost/Cryophoenix ; textes hérités Alistar/400/600/rangs10 non adoptés comme règles.

Un preload231octets contient `rengar_base_w_heal.troy`, apbonusdamagetotowers et gragaspassive. Le nom Rengar est un candidat littéral Gragas, pas une corruption à renommer ni une invocation prouvée. Captures E529081/640516octets vérifiées. Deux DDS4224octets identiques64×64/DXT5/mip1, membre0.0.0.207 ; sélection et pixels non vérifiés ici. Quatre chaînes1960/1961/4196/4372, quatre bindings dont W/E sans entrée dans la fonte sélectionnée : pas deux sorts absents. Quatre candidats W actifs exclus, quatorze références communautaires secondaires. Aucun AutoBuff reconnu ne prouve une absence générale d’effet.

## 3. Consommateurs réels

Dix fichiers Rust complets, 21 ancres : `lib.rs:685` ; `spells.rs:5` ; `spells.rs:101` ; `spells.rs:120` ; `annie_w.rs:29` ; `annie_w.rs:49` ; `progression.rs:150` ; `progression.rs:159` ; `progression.rs:164` ; `healing.rs:9` ; `healing.rs:16` ; `healing.rs:39` ; `regeneration.rs:10` ; `regeneration.rs:32` ; `regeneration.rs:42` ; `garen_passive.rs:27` ; `garen_passive.rs:31` ; `summoner_heal.rs:33` ; `summoner_heal.rs:77` ; `trundle_w.rs:90` ; `projected_live.rs:168`.

Racines : `F:/OpenLeague/crates/core/src/`, sauf projected_live dans `crates/client/src/`. Les corps targeted cast, point cast et progression refusent Gragas dans les branches inspectées. Le soin générique applique les modificateurs reçus et borne aux HP maximum ; régénération de base/items/Garen, soin d’invocateur et TrundleW ne prouvent pas Happy Hour. Garen possède une garde champion ; la projection inspectée vise Annie.

Recherche bornée Gragas/HappyHour/rengar_base_w_heal : zéro occurrence dans ces dix textes, sans conclusion d’absence globale.31 comparaisons sélectionnées/24 chemins uniques et87 contextuelles chevauchantes concordent ;14 mécanismes VFX communs et2 fichiers d’animation ordinaire réutilisés. L’animation ordinaire n’établit ni événement Happy Hour ni attache ou rendu.

## 4. Attendu, observé et contrôles

Attendu : déclarations, limites, acquis et gardes réels reliés sans promouvoir un preload en effet exécuté. Observé :67/67 contrôles documentaires et74/74 de cohérence séparée du même agent ; témoins sauvegardés comparés, sans second décodeur indépendant.

Deux cas V573 hérités : HPmaximum583.52001953125 puis733.52001953125 après ruby1028 ;10 impacts entrants,40 refus,600ticks finaux. Le soin90 est Summoner Heal, pas Happy Hour. Aucun sort Gragas accepté n’exerce le déclencheur ; le simple temps écoulé ne teste pas l’expiration du délai interne. Le conflit Heal local240s/7200ticks contre natif300s reste ouvert. Dates des reçus et dates de ce contrôle sont distinctes. Les anciennes corrections de pins/compteurs/générateur restent conservées.

Aucun nouveau build, jeu, décodage natif, GPU, REA ou probe. Les sept critères et la publication seront contrôlés séparément par leurs reçus.

## 5. Écarts et inconnues

Le texte4%HPmaximum/8s ne résout pas f1, événements éligibles, relances, modificateurs, arrondi ou cycles de vie. Recette complète, appel de création, ressource sélectionnée, pose, destinataire et rendu restent indéterminés. Aucune inconnue du registre ni tâche VFX complète n’est fermée ; identifiants et contrat conservés dans `evidence_review.json`.

## 6. Corrections et reprise

Réutiliser la tâche existante avec trois clauses : happy-hour-visual-applicability-source ; accepted-cast-heal-delay-world-link ; resource-attachment-render-lifecycle. Objectifs, prérequis, critères et entrées de reprise précis dans `corrections_and_restart.json`. Aucun code produit corrigé implicitement.

Prochaine étape : consolidation bornée des audits suffisamment documentés avant une nouvelle recherche. Réutiliser les instantanés avec contrôle d’identité ; ne relancer que sur dérive, nouvelle source ou question non répondue. C’est l’application de la recherche utilisateur18a5e039, déjà évaluée dans `E:/mapslol3v3/research_acceleration_fit_20261105/decision.json` : ni nouveau cache logiciel ni installation. Aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves et commandes : `E:/mapslol3v3/audit_sys01202_gragas_passive_vfx_20261105/`, notamment evidence_review.json, coherence_review.json, operations, journals, puis result.json et reçus de publication. Relecture limitée au même agent, sans acceptation indépendante.

Seule cette liaison bornée est clôturable. Le parent, le jeu, la fonctionnalité, les autres clauses et l’acceptation restent ouverts. Publication prévue : un nouveau rapport et ajouts exacts CURRENT/HANDOFF avec archives ; goal, Plan/UI/bases, registres et produit inchangés.
