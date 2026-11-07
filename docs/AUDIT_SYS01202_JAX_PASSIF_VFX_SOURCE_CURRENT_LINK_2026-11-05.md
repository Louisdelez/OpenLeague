# Jax — liaison bornée du passif AS et des effets visuels

## 1. Exigence et portée

2026-11-05, V1353 ; `AUD-SYS-01.2-02-JAX-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; SYS-01.2-02 ; `CH-Jax-PASSIF-PRESENTATION-VFX` ; `OLF-6d1af36e-89b5-5a3a-af5f-13f0501990fe`. Relier les déclarations applicables aux consommateurs nécessaires. Audit terminé pour cette liaison bornée ; tâche complète, inventaire, fonctionnalité et acceptation ouverts.

Implémentation : producteur de cumuls Jax et activation visuelle non établis dans les corps inspectés. Vérification documentaire réussie ; essais historiques hérités sans nouvelle exécution du jeu. Acceptation humaine non demandée.

## 2. Sources et provenance

Répertoire `F:/OpenLeague/docs/reference_requirement_trace_sources/` : jax-passive-source-cadence-links-v538.json393493octets/SHA256 `38fb5a3eb5075071663ef05e5a7c17c0a4f7fb64ba818ef374de5e8a2ef207b9` ; jax-passive-relentless_assault-links-v580.json949177octets/SHA256 `0959092692f046b63be383d0113650ddbf2cff38e20a2a2226d927ed735ba04d`. Copies E externes conservées. Référence LoL4.20.0.315/EUW/en_GB héritée ; catalogue4.20.1 distinct. Aucun accès D, chemins natifs inertes.

V538 :14 identités/42 associations ; V580 :21/63. Treize ressources communes concordent en taille/SHA, sans priorité de provider déduite. V538 conserve RelentlessBarrier.inibin49octets ; union SOURCE22 identités. Les versions ont des rôles distincts, aucune sélection automatique de la plus récente.

Sept Lua structurels sans enfants, six initialisations/24 affectations. CharScript56 vide ; JaxPassive260 et RelentlessAssault270 persistants ; AS357 sans champ persistence, absence non false. AS a deux AutoBuff vides. Speed321 déclare RelentlessBarrier avec JaxRelentlessAssault_buf.troy et deux champs secondaires vides ; déclaration défensive non aura passive. Debuff142/debug=true n’a pas de BuffName. Attack253 limité par NEWTABLEpc6, sans corruption démontrée.

Cinq preloads906octets/onze références dérivées du texte conservé ; global_haste et relentlessassault_tar sont des noms, non une activation. Deux FX identifiés sans décodage/rendu. Douze entrées DDF R/Q/E et troisième coup magique/défense active restent distincts du passif AS. Anciennes descriptions AD/mana,scalar9,rangs3/7/11/15 puisnull non formule. Dix références communautaires secondaires.

Tooltip2096 annonce f1% AS,2.5secondes,max6 ; coefficient et politique ouverts. AS2098 et R2099 restent distincts. Clé exacte avec underscore absente, voisine2097 conservée sans alias automatique. Neuf lignes en_GB héritées. Trois DDS4224octets/64×64/DXT5/mipbrut0,deux contenus,membres40/25/25 : personnage/AS MasterOfArms,source/R CoupDeGrace. Homonymes Malphite/Shen contextuels non lus. Lookup,variante,pixels et besoin d’effet spécifique ouverts ; aucune reconstruction graphique présumée.

## 3. Consommateurs réels

Seize Rust complets,42 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:46` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `attacks.rs:157` ; `attacks.rs:26` ; `attacks.rs:141` ; `lifesteal.rs:4` ; `damage.rs:53` ; `damage.rs:38` ; `regeneration.rs:10` ; `regeneration.rs:32` ; `shop.rs:215` ; `shop.rs:261` ; `lib.rs:744` ; `lifecycle.rs:33` ; `attacks.rs:103` ; `lib.rs:639` ; `progression.rs:119` ; `attacks.rs:285` ; `attacks.rs:303` ; `attacks.rs:326` ; `shop.rs:239` ; `combat.rs:4` ; `ezreal_passive.rs:75` ; `ezreal_passive.rs:53` ; `ezreal_w.rs:201` ; `trundle_w.rs:89` ; `trundle_w.rs:80` ; `critical.rs:19` ; `projected_live.rs:168` ; `progression.rs:120` ; `progression.rs:125` ; `progression.rs:126` ; `progression.rs:127` ; `attacks.rs:33` ; `lifecycle.rs:83`.

Racines `F:/OpenLeague/crates/core/src/`, sauf projected_live dans client/src. Cadence = base divisée par croissance/objets/TrundleW/EzrealW/Ezrealpassif−Exhaust,dénominateur min0.05,round,min12ticks. Windup ceil/min1 et programmation tick+cadence réels. Aucun producteur de cumuls Jax établi dans cette formule inspectée. TrundleW et Ezrealpassif ont leurs gardes propres ; pas de transfert de politique. Attaque physique,poursuite,présentation ordinaire et projection Annie distinctes.

Recherche Jax/Relentless sur seize textes : zéro hit, sans absence globale déduite.29 comparaisons sélectionnées dont cinq V538 et92 contextuelles chevauchantes concordent ;14 mécanismes VFX et2 animations ordinaires réutilisés, sans rendu passif qualifié.

## 4. Attendu, observé et contrôles

Attendu : distinguer les deux versions,AS/R/Barrier,arrondis et présentation. Observé :110/110 contrôles documentaires,127/127 de cohérence séparée du même agent. V1225 source66/66,consommateurs66/66,intégration42/42 hérités ; projection de cinq alias E distincte du collecteur66/66 et readback14/14 non rejoués. Pas de décodeur indépendant.

V580 : deux cas publics Map10 base/Dague1042,18 impacts,30 refus,420ticks pause/suivi hérités. Huit attaques continues chacun,sept intervalles47 ou41ticks ; après120ticks,neuvième coup à cadence identique puis90ticks. Dague15%AS locale non passif ; dégâts ordinaires/régénération,résidu<0.002. V538 distinct :huit coups47ticks,Stop1/30/90 et achat/vente Dague47→41→47. Arrondis peuvent masquer de petits gains ; sans f1,pas d’échec numérique natif qualifié. Huit coups ne prouvent pas max6 ; pause sans état créé ne prouve pas expiration2.5s.

Binaires hérités V5385954560/SHA `6b9faba974fb8f8c9dbbe6a8613c083522d6d4f003e418cc1df6951053ac51ae` et V5806018048/SHA `472a02372d57fd1a7574c3cab3ad83600beb380a06967c4c1e36fda3ce0356ab`, jamais rouverts. BUILD/RUN0 historiques. Sept captures E incluent correction compteur3→4,ancienne preuve/audit et deux scripts inertes. Quatre IDs toujours conservés ;extra uniquement SIMULATION. Anciennes erreurs source/HUD et alias conservés.

Une exploration d’affichage a échoué sur literal_references absent du schéma Jax ; noms ensuite dérivés du texte sans modifier le reçu. Six opérations documentaires journalisées réussies ;aucun nouveau build,jeu,natif,GPU,REA,probe ou réseau. V564 ouvert.

## 5. Écarts et inconnues

f1/par cumul/total,niveaux,déclencheur/cibles,refresh,expiry,cap,ordre,arrondis et lifecycle ouverts. Applicabilité,activation,recette,attache,pose,lookup,pixels et audiences restent à qualifier. Source persistante non cycle destinataire ;Speed/Barrier et R non substituts du passif. Aucun inventaire complet,tâche VFX,inconnue ou acceptation fermé.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : relentless-assault-passive-visual-applicability,attack-speed-stack-event-cadence,applicable-effect-selection-attachment-render-lifecycle. Chacune possède objectif,prérequis,critères et reprise. Qualifier f1 et événements avant correction du jeu ;ne pas répéter les mêmes mesures entières pour conclure sur le natif.

Prochain lot CH-Jayce-PASSIF-PRESENTATION-VFX ;sources conservées dans next_lot.json. Réutiliser consolidation V1346 et mécanismes communs,sans nouveau recensement global.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_jax_passive_vfx_20261105/` : evidence_review,coherence_review,corrections_and_restart,operations/journals,reçus. Relecture du même agent,sans acceptation indépendante ou humaine.

Seule liaison bornée close ;tâche complète,feature,inconnues et goal ouverts. Publication :rapport et ajouts CURRENT/HANDOFF avec archives exactes ;goal/Plan/UI/bases/registres/code/assets inchangés.
