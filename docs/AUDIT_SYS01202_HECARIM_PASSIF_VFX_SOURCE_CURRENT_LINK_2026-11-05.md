# Hecarim — liaison bornée de Warpath et des effets visuels

## 1. Exigence et portée

2026-11-05, V1348 ; `AUD-SYS-01.2-02-HECARIM-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Hecarim-PASSIF-PRESENTATION-VFX` ; `OLF-3726200e-9121-5794-b895-a1a0b78c626b`. Relier les déclarations applicables aux consommateurs courants nécessaires. Audit terminé pour cette liaison bornée ; inventaire complet, fonctionnalité, runtime et acceptation restent ouverts.

Implémentation : conversion vitesse bonus→AD et exemption de collision Warpath non établies dans les corps inspectés ; mécanismes génériques conservés. Vérification : statique documentaire réussie, essais historiques non réexécutés. Acceptation humaine : non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/hecarim-passive-warpath-links-v575.json` ; copie E externe870738octets, SHA256 `b3d01734c7760e189ba9abe252080fabaafaa495aea918b9fd7f5cc82301272f`. Référence LoL4.20.0.315/EUW/en_GB héritée ; catalogue4.20.1 distinct. Onze identités/rôles natifs,33 associations historiques de trois tâches. Aucun accès D ; chemins natifs inertes.

Quatre Lua structurels sans enfants ; trois initialisations/20affectations. CharScript56 vide ; Passive286 six champs dont IsDamagingSpell/DoesntTriggerSpellCasts/PersistsThroughDeath=true, sans règle serveur qualifiée. Ramp283 reste limité par NEWTABLEpc10, sans corruption démontrée. RampSpeed762 déclare trois effets E et attaches CENTER/Weapon/BUFFBONE_GLB_WEAPON_1, aux pc15/17/19/21/23/25 ; contexte actif, pas recette Warpath. Absence d’AutoBuff dans le passif reconnu non absence générale d’effets.

Deux preloads663octets/neuf références, dont deux particules E ; déclarations comparées aux captures E437349/597875octets. DDF16 entrées actives sans entrée passive dans ce fichier : coefficients actifs non f2, pas absence globale de formule. Huit références communautaires secondaires. Rangs null non convertis en zéro ; textes anciens non adoptés.

Deux déclarations DDS aux noms Hecarim_Passive/Hecarim_Warpath, même contenu5616octets/64×64/DXT5/mip7, membre0.0.0.87 sous core0.0.1.7 ; aucun alias fusionné, sélection/pixels ouverts. Deux bindings/quatre chaînes1984/1985/4199/4375 :1984 f2% de vitesse bonus et f1 AD courant,1985 DevastatingCharge distinct. Formules, niveaux et base avant/après plafonds restent inconnus.

## 3. Consommateurs réels

Quinze Rust complets,31 ancres : `lib.rs:685` ; `progression.rs:40` ; `progression.rs:61` ; `progression.rs:90` ; `progression.rs:118` ; `movement.rs:19` ; `movement.rs:38` ; `movement.rs:44` ; `movement.rs:46` ; `movement.rs:53` ; `movement.rs:55` ; `movement.rs:60` ; `ally_occupancy.rs:79` ; `ally_occupancy.rs:85` ; `ally_occupancy.rs:96` ; `ally_occupancy.rs:102` ; `ally_occupancy.rs:110` ; `collision.rs:22` ; `collision.rs:29` ; `shop.rs:215` ; `summoner_heal.rs:21` ; `summoner_heal.rs:22` ; `trundle_q.rs:105` ; `attacks.rs:157` ; `damage.rs:53` ; `lifecycle.rs:33` ; `world.rs:350` ; `spells.rs:5` ; `spells.rs:120` ; `annie_w.rs:49` ; `projected_live.rs:168`.

Racines : `F:/OpenLeague/crates/core/src/`, sauf projected_live dans client/src. AD assemble base/croissance/objets/autels/TrundleQ ; vitesse assemble base/objets/Garen/Soin/relique/TrundleW/ralentissements/plafonds. La vitesse affichée n’alimente pas la formule AD inspectée. Occupation filtre les alliés vivants et utilise pathfinding_radius ; body_radius et defaults communautaires65/40 sont distincts. Pas d’exemption Hecarim identifiée dans ces corps. Casts Hecarim refusés dans les branches inspectées ; projection Annie distincte.

Recherche Hecarim/Warpath sur les quinze textes : zéro hit, sans absence globale déduite.25 comparaisons sélectionnées et83 contextuelles chevauchantes concordent ;14 mécanismes VFX et2 animations ordinaires réutilisés, pas présentation Warpath qualifiée.

## 4. Attendu, observé et contrôles

Attendu : distinguer passif, capacité active, conversion, passage et présentation génériques. Observé :80/80 contrôles documentaires et89/89 de cohérence séparée du même agent ; pas de second décodeur indépendant. V1220 source60/60, consommateurs55/55 et intégration40/40 hérités, non rejoués.

V575 : cinq cas publics niveau1,30 impacts de mêlée,77 refus,450ticks de suivi. Vitesses345/370 puis441.799988/467.799988 avec Soin ; AD61.375999 inchangé, objet1036 séparément+10AD. Retour vitesse au tick30 ne qualifie ni f2 ni base native ; Soin30%/30ticks et plafonds locaux, conflit cooldown240/300s conservé.

Quatre collisions publiques héritées : allié Hecarim arrêté80=50+30 de navigation, Garen65=35+30 ;80 observé ne prouve pas usage du rayon gameplay80. Tous deux traversent l’ennemi, minimum3.004350, destination250.000061 : contrôle générique, pas Warpath validé. Autres catégories et V564 ouverts.

Binaire6084096octets/SHA9c0bf4fbb737d84019e0b0306ab6d9bd5ac8b06890182ea497d0ef394de0889f, build/run0 hérités, jamais rouverts. Bootstrap initial échoué sur pointeur vers futur result.json local : original/ledger/erreur conservés, seul PREV corrigé vers Graves. Aucun manque de source native déduit. Sept opérations journalisées dont cet échec ; aucun nouveau build, jeu, natif, GPU, REA ou probe.

## 5. Écarts et inconnues

f1/f2, niveaux, base de vitesse bonus, ordre des plafonds/modificateurs/ralentissements, arrondi et recalcul restent ouverts ; passage par catégories/équipes, terrain/obstacles et cycle mort/réapparition aussi. Une ressource ou un effet passif spécifique n’est pas présumé manquant. Applicabilité, recette, attache, pose, sélection et pixels restent à qualifier. Contrat et IDs d’inconnues conservés ; aucune tâche VFX complète ou inconnue fermée.

## 6. Corrections et reprise

Réutiliser la tâche existante avec warpath-visual-applicability-source, bonus-speed-AD-ghosting-world-link et applicable-resource-attachment-render-lifecycle. Objectifs, prérequis, critères et conditions de reprise dans corrections_and_restart.json. Exiger une preuve d’applicabilité avant d’ajouter un effet ; aucun code produit corrigé implicitement. Reprise sur source/callsite/événement ou dérive précise, sans répétition inchangée.

Prochain lot : CH-Heimerdinger-PASSIF-PRESENTATION-VFX, sources conservées identifiées dans next_lot.json. Réutiliser la consolidation V1346 et les mécanismes communs sans recensement global ni acquisition présumée.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_hecarim_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, corrections_and_restart.json, operations/journals et reçus. Relecture du même agent, sans acceptation indépendante ou humaine.

Seule liaison bornée clôturable ; tâche complète, inventaire, feature, inconnues et goal ouverts. Publication documentaire : rapport et ajouts CURRENT/HANDOFF avec archives exactes ; goal/Plan/UI/bases/registres/code/assets inchangés.
