# SYS-01.2-02 — Teemo : sources et consommateurs VFX du passif, V1409

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-TEEMO-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé sur ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et frontières

`CH-Teemo-PASSIF-PRESENTATION-VFX`, `OLF-ef5eb585-ddb6-59a0-be6d-4971563408ae` : relier Camouflage aux sources et consommateurs réels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK et consommateurs enregistrés conservés. Inconnues VFX OLU-f0abb199-2f48-5c89-b872-dfd76851b677 et SOURCE OLU-471ae9a4-8eff-5744-a60c-941b316a289f ouvertes. Prérequis D06/lot consultés sans satisfaction revendiquée. HUDV1281 réutilisé sans seconde clôture ; parent, QWER et goal distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral du 2014-11-17 à17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/teemo-passive-camouflage-links-v638.json`, 3987120 octets, SHA `b3d4894357ad67190caf104ffcfffdf6b91cc302ba74a0253859428cea1e4745`. Métadonnées réutilisées sans nouveau décodage natif : 46 identités, 138 associations, 30 sites ; 13 INIBIN, 22 Lua, neuf preloads, DDF/font.

Définition Camouflage/Teemo_Camouflage.dds ; ancienne description de portée de vision distincte, PARType/Passive1/six niveaux absents. BaseMP267.2000122, croissance chaîne40. Buff1768 : immobile2s puis furtivité ; sortie avec +40% vitesse d’attaque pendant3s. Description4288 précise absence d’action/furtivité indéfinie ; Stealth1769 décrit l’état furtif. Trois BuffData résolus exactement, TrapLimiter2784 distinct ; Kha’Zix hors contrat, aucun alias automatique. Font miroir inchangé, sans nouvelle analyse des lignes.

22 Lua : 14 initialisations littérales, 27 globals, huit limites NEWTABLE, zéro prototype enfant selon reçus ; chemins complets conservés. Camouflage211 déclare icône/nom/persistance/non-dissipation ; CharScript109 initialise Teemo_EagleEye.dds, distinct. Check56 vide ne qualifie pas un producteur. Stealth156 a son propre BuffName. Buff161 et TeemoCamouflageStealthTT161 déclarent littéralement CamoflagueBuff/BlindMonk_BlindingStrike.dds ; faute conservée, sans importer Lee Sin ni déduire le dispatch Map10 du nomTT.

Deux vues AutoBuff/quatre champs : BantamTrapTarget utilise Global_Poison.troy, ToxicShotParticle Global_poison.troy, avec attache head ; casse conservée, contextes QWER distincts. DDF8 : deux liens BantamTrap @cooldownchampion, coefficients textuels35/31/27 et31/27, aucune formule Camouflage. Producteurs communautaires Camouflage/Camoflague non retrouvés dans l’arbre inspecté, CharScript vide et Q projectile commenté ; recherches bornées, aucune absence mondiale ou exécution C# déduite.

Neuf preloads : 2306 octets reconstruits exactement en CRLF depuis Discovery conservé ; 32 références (six particules, 25 sorts, un personnage). Char405 précharge six sorts dont Camouflage/Check/TrapLimiter. Camouflage156 précharge Check/Stealth. Stealth294 précharge Buff, globalstealthscreentint, Check et varianteTT : quatre dépendances de type Spell, sans création ni provider de teinte qualifié. Trap835 conserve le nom de sort avec espace "noxious trap" et personnage teemomushroom. Poison, pièges et MoveQuick restent distincts.

Ancienne assertion de preloads vides réfutée : script17906octets/SHAa03b1b47… conservé et revérifié, inspection initiale1 puis inspection_preload corrigée. Cet échec d’inspection ne prouve pas une panne du moteur ; aucun décodage natif rejoué.

Un DDS partagé E relu : DATA/Spells/Icons2D/Teemo_Camouflage.dds, 4224 octets, 64×64 DXT5, compteur de mips brut0, membre0.0.0.25, SHA387270df…. Lookup/provider/pixels ouverts ; aucun DDS EagleEye/BlindMonk ou payload Troy ouvert. Mana courant : source_sha256 communautairefba16034… distinct du natif1d24a1b7… ; PARType absent ne déclare pas Mana.

## 3. Consommateurs actuels

15 fichiers relus, dont13 Rust/deux lecteurs Python ; 36 ancres exactes. Quatorze fichiers de frontières/SOURCE, 27 contextes, miroir font, 14 mécanismes VFX communs et deux fichiers d’animation ordinaire concordants. Aucun producteur nommé Teemo/Camouflage/CamoflagueBuff dans ces13 Rust ; recherche bornée, sans absence globale revendiquée.

vision.rs:79/93 délègue visible_to à visible_point_to, sans état Camouflage identifié. snapshot_for:137 filtre les joueurs ; snapshot_for_atomic:208 reprend cette projection sur la même simulation immuable. Brouillard/buissons/LOS et révélation Ignite sont des mécanismes distincts. Attaques/projectiles physiques, cadence statistique et HUD génériques ne qualifient pas furtivité, bonus de sortie, teinte, création/owner, pose, horloge, arrêt ou pixels.

## 4. Attendu et observé

Deux diagnostics conservés : immobile puis attaque, ou immobile puis déplacement80unités et attaque. Chaque attente dure181ticks avec182 échantillons, état initial compris. Relecture actuelle : 364 lignes d’indicateurs positives, positions fixes/terrainflags0, ticks séquentiels ; acteur Teemo complet identique au début/à la fin. Quatorze lignes de seuil concordent, dont offsets59/60/61/181. Le déplacement public80 et son arrivée sont relus. Attendu textuel : entrée après2s sans action ; entrée non observée selon ces indicateurs.

Les projections ennemies complètes ne sont pas conservées à chaque trame. Présence standard/atomique, visibilité point et LOS sont des indicateurs enregistrés après assertions, sans relecture actuelle de payloads complets ni replay LOS/navigation. Les assertions d’absence de commande/destination/cible/windup intermédiaires restent celles du collecteur. Équipe invalide/joueur inconnu sont des contrôles du collecteur, pas un mode spectateur ou une validation réseau ; ancienne formulation corrigée conservée.

Six projectiles ordinaires, dégâts≈39.8758545 et cadence43ticks ; cinq arrivées sans réordre, 54 refus par flags. Sorts Teemo refusés, sans être prérequis du déclencheur immobile. Aucune entrée furtive observée : sortie réelle, bonus40%/3s et expiration non exercés. Cadence ordinaire43 ne démontre pas l’absence d’un bonus après sortie réelle. Paires PV cible adjacentes à l’impact absentes, soin/restitution sous plafond non qualifiés ; aucune garde NPC universelle.

43/43 documentaires qualifiés, 67/67 cohérence même agent ; anciens73/73 et69/69 hérités. Premier collecteur42/43 : indicateur point_visible_to_enemy confondu avec nom de méthode ; seul contrôle corrigé vers visible_point_to, autres42 et fenêtres source inchangés. Six productions réussies et cet échec conservés. BUILD/RUN historiques0 ; binaire6256640/SHA1b9c9031… inerte, aucun nouveau jeu exécuté.

## 5. Écarts et limites

Entrée furtive non observée selon le diagnostic ; conditions historiques complètes, délais/interruptions/révélation/buissons, variantes/providers et lifecycle ouverts. Bonus de sortie non exercé. Payloads complets par audience, transport, recettes, teinte/lookup/création/owners/poses/horloges/arrêts et pixels non qualifiés. Aucun nouveau build/jeu/natif/REA/GPU/réseau ; V564/Nami et autres clauses conservés. Relecture même agent, aucune validation indépendante/humaine.

## 6. Corrections et reprise

corrections_and_restart.json contient cinq clauses dans les tâches existantes : politique ; entrée furtive/filtrage ennemi ; sortie/bonusAS ; événements/payloads par audience ; consommateurs VFX. STEALTH-STATE-01 et EXIT-AS-01 restent distincts. Fins : entrée nominale/frontières/actions/révélation/refus, vues propre/alliée/ennemie et projections complètes datées ; puis sortie réelle, bonus40%/3s/cadence/arrondis/composition/expiration ; recettes/teinte/variants/lifecycle et pixels selon contrat qualifié. Reprise sur source, mapping/callsite, recette/payload/capture précis, dérive ou autorisation fonctionnelle distincte. Aucun correctif produit exécuté.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_teemo_passive_vfx_20261106 : evidence_review_corrected.json fait autorité, original42/43 conservé ; coherence_review, qualifications héritées, gardes et journaux. next_lot.json cible Thresh, ligne de couverture vérifiée ; chercher ses audits existants.

Une unité de liaison bornée close ; zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. Rapport et ajouts CURRENT/HANDOFF seulement, après sauvegardes exactes et contrôle des sept protégés. Goal/Plan/UI/bases/registres/produit conservés.
