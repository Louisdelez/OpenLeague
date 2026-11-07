# Heimerdinger — liaison bornée de Repair Bots et des effets visuels

## 1. Exigence et portée

2026-11-05, V1349 ; `AUD-SYS-01.2-02-HEIMERDINGER-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Heimerdinger-PASSIF-PRESENTATION-VFX` ; `OLF-d7446fd9-c6ab-55a1-b50b-dafba1d713f9`. Relier les déclarations source/destinataire applicables aux consommateurs nécessaires. Audit terminé pour cette liaison bornée ; inventaire complet, fonctionnalité, runtime et acceptation restent ouverts.

Implémentation : producteur d’aura Repair Bots non établi dans les corps inspectés ; mécanismes génériques conservés. Vérification : statique documentaire réussie, essais historiques non réexécutés. Acceptation humaine : non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/heimer-passive-repair_bots-links-v576.json` ; copie E externe822284octets, SHA256 `5318db42215c8a134d319633fda3520fff6c4db013b3c3ad35fa9e229c9a2d0b`. Référence LoL4.20.0.315/EUW/en_GB héritée ; catalogue4.20.1 distinct. Dix identités/rôles natifs,30 associations historiques de trois tâches. Aucun accès D ; chemins natifs inertes.

Trois Lua structurels et littéraux/cinq affectations, sans enfants ni callbacks exécutés. CharScript56 vide ; source196 déclare HeimerdingerPassive/Heimerdinger_Passive.dds/PersistsThroughDeath=true ; destinataire167 TechmaturgicalRepairBots partage l’icône mais ne déclare pas PersistsThroughDeath. Absence non false, aucune règle de mort transférée. Pas d’AutoBuff reconnu, sans absence générale d’effet déduite.

Deux preloads2103octets/29 noms, comparés aux captures E434270/577247octets ; référence source→techmaturgicalrepairbots non invocation. Les références actives/skins/VO ne qualifient pas l’aura. DDF16 entrées actives sans passif dans ce fichier, sans formule globale absente déduite. Huit références communautaires secondaires. Champs de description et rangs null, aucun zéro ou rang fabriqué.

Deux bindings exacts1992/2756 : f1 en PV/5s pour champions alliés proches et H-28G ; buff reçu/SourceName distinct. Nom4376 lié ; description4200 candidate sans liaison de champ, Q4201/NanoRepairBots4377 non adoptés. Un DDS2176octets/64×64/DXT1/mipbrut0, membre0.0.0.204 sous core0.0.1.7 ; basename commun non lookup/sélection/pixels prouvés, mip0 non corruption. Aucun besoin de reconstruction graphique établi.

## 3. Consommateurs réels

Quatorze Rust complets,29 ancres : `lib.rs:685` ; `regeneration.rs:10` ; `regeneration.rs:16` ; `regeneration.rs:32` ; `regeneration.rs:42` ; `regeneration.rs:44` ; `healing.rs:9` ; `healing.rs:16` ; `healing.rs:39` ; `garen_passive.rs:27` ; `garen_passive.rs:31` ; `annie_r.rs:14` ; `annie_r.rs:26` ; `annie_r.rs:82` ; `annie_r.rs:91` ; `annie_r.rs:76` ; `annie_r.rs:119` ; `annie_r.rs:125` ; `world.rs:265` ; `spells.rs:5` ; `spells.rs:120` ; `lifecycle.rs:33` ; `lifecycle.rs:83` ; `progression.rs:164` ; `damage.rs:53` ; `attacks.rs:157` ; `shop.rs:215` ; `annie_w.rs:49` ; `projected_live.rs:168`.

Racines : `F:/OpenLeague/crates/core/src/`, sauf projected_live dans client/src. regeneration_rates assemble base/croissance/objets ; advance_regeneration ajoute Garen, applique les modificateurs reçus et borne HPmax. La garde Garen exclut les autres champions. Soin discret distinct. Aucun producteur Repair Bots identifié dans ces corps ; le taux local PV/s ne fournit pas f1 PV/5s.

Tibbers possède définition/création, régénération propre, ordres et aura de dégâts magiques ennemis ; ce n’est pas une aura de régénération alliée ni H-28G. Refus casts/progression génériques et projection Annie restent distincts. Recherche nommée sur les quatorze textes : zéro hit, sans absence globale déduite.23 comparaisons sélectionnées et81 contextuelles chevauchantes concordent ;14 mécanismes VFX et2 animations ordinaires réutilisés sans présentation passive qualifiée.

## 4. Attendu, observé et contrôles

Attendu : conserver source/destinataire, unités, applicabilité et frontières génériques. Observé :76/76 contrôles documentaires,88/88 de cohérence séparée du même agent ; pas de second décodeur indépendant. V1221 source61/61, consommateurs58/58 et intégration40/40 hérités. L’origine des58 contrôles et la clarification ultérieure nom/description sans relance du collecteur sont conservées exactement ; pas de tests nouvellement exécutés par ce libellé.

V576 : deux cas publics alliés Heimerdinger/Ahri, Annie ennemie ; dix impacts projectiles,30refus,1200ticks de suivi,186de déplacement. Taux Ahri1.301599979PV/s ou1.952399969 avec1006(+50%), à250 puis1250.999634unités et pendant déplacement. Distances non rayon natif ; objet non f1, refus Learn/Cast/CastAt non déclenchement réussi.

Trois diagnostics BUILD0/RUN101 conservés : arrivée initiale, destinations ramenées au centre occupé, comparateur Hecarim/Ahri bloqué. Variante qualifiée : seulement deux cas Heimerdinger, BUILD/RUN0 hérités ; aucun correctif de navigation déduit, V564 ouvert. Binaire6043648octets/SHAcc9ce770ae29e10c909d612489e306d65a876d1156f49e8a6317902773990e8f et24 identités d’artefacts échoués conservés comme données inertes ; aucun binaire/F-work rouvert.

Anciennes corrections de préflight45, attendu de variante active, textes et filtre de préparation conservées. Variante active E/InventoryIcon2 HeimerdingerE_E2.dds non résolue dans l’import courant, pas asset passif manquant. Six opérations documentaires journalisées ; aucun nouveau build, jeu, natif, GPU, REA ou probe.

## 5. Écarts et inconnues

f1/formule/niveaux/unités/arrondis, rayon/cadence, auto-application, H-28G/champions, sources multiples/cumuls, entrée/sortie et mort/réapparition restent ouverts. Applicabilité, recette, attache, pose, sélection et pixels restent à qualifier. Aucun effet passif présumé manquant. Contrat et IDs d’inconnues conservés ; aucune tâche VFX complète ou inconnue fermée.

## 6. Corrections et reprise

Réutiliser la tâche existante avec repair-bots-visual-applicability-source, source-recipient-aura-world-link et applicable-resource-attachment-render-lifecycle. Objectifs, prérequis, critères nominaux/refus et reprises dans corrections_and_restart.json. Exiger l’applicabilité avant un éventuel effet ; aucun code produit corrigé implicitement. Reprendre sur source/callsite/événement ou dérive précise, sans répéter un essai inchangé.

Prochain lot : CH-Irelia-PASSIF-PRESENTATION-VFX, sources conservées dans next_lot.json. Réutiliser la consolidation V1346 et les mécanismes communs sans nouveau recensement global ni acquisition présumée.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_heimerdinger_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, corrections_and_restart.json, operations/journals et reçus. Relecture du même agent, sans acceptation indépendante ou humaine.

Seule liaison bornée clôturable ; tâche complète, inventaire, feature, inconnues et goal ouverts. Publication documentaire : rapport et ajouts CURRENT/HANDOFF avec archives exactes ; goal/Plan/UI/bases/registres/code/assets inchangés.
