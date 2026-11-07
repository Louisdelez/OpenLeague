# SYS-01.2-02 — Syndra : sources et consommateurs VFX du passif, V1406

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-SYNDRA-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé sur ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et frontières

`CH-Syndra-PASSIF-PRESENTATION-VFX`, `OLF-a7676975-a3ab-57e1-9621-fd7ac71bba00` : relier Transcendent aux sources et consommateurs réels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK et consommateurs enregistrés conservés. Inconnues VFX OLU-f23ab871-632f-5e24-bcc8-4693092de2c2 et SOURCE OLU-11e53818-8985-5cbb-b58d-1e06a70703aa ouvertes. Prérequis D06/lot consultés sans satisfaction revendiquée. HUDV1278 réutilisé sans seconde clôture ; parent, QWER et goal distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/syndra-passive-transcendent-links-v635.json`, 3121055 octets, SHA `ed23a68f0ce554d5cdeb9681541b31a5ecd3ef0430a49a84df29cfe024ed6d3d`. Métadonnées réutilisées sans nouveau décodage natif : 116 identités, 348 associations, 11 sites ; 32 INIBIN, 51 Lua, 31 preloads, DDF/font.

Définition : SyndraPassive/SyndraPassive.dds ; Passive1 et quatre marqueurs de niveau chaînes "0", description vide, "5 Astral Spirts" conservé sans seuil déduit. Mana334, croissance50 et vitesse330 restent chaînes ; PARType absent. Font2740/4285 : au rang maximal, Q +15% dégâts contre champions, W +33% durée du slow, E +50% largeur, R +75 portée. Deux BuffData exactement résolus sans alias. Prédicat, producteurs, bases, ordre et arrondis inconnus. Miroir font inchangé, sans nouvelle analyse des lignes.

51 Lua : 35 initialisations littérales, 89 globals, 16 limites NEWTABLE, zéro prototype enfant selon reçus ; chemins complets conservés. Passive183 déclare icône/nom/persistance ; CharScript56 vide ne qualifie pas l’activation. Deux vues AutoBuff/trois champs : RCastTime446 référence Syndra_R_Spheres_ready/spine avec BuffName Time Bomb ; WSlow263 déclare GLOBAL_SLOW.TROY. Ces déclarations ne produisent pas les bonus R+75/W+33. Time Bomb, BurningAgony, SkarnerImpaleBuff et IreliaTranscendentBlades restent contextes étrangers.

DDF16 : seul SyndraW;f2→@text×1.5 non vide, sans durée maximale déduite ni remplacement du33%. E/E5 LineWidth=0 ne définit pas leur géométrie effective ; R CastRange1–3="675.0000" n’exécute pas le bonus75. Limites communautaires Q visuel, W sans saisie, E stun inconditionnel, R7/8/9 sphères fixes conservées, sans exécution C#.

31 preloads : 13203 octets reconstruits exactement en CRLF depuis Discovery conservé ; 180 références (64 particules, 98 sorts, 18 personnages). Char797 précharge dialogues q5/w5/e5/r3 ; Passive97 précharge recalloverride. Q501/QSpell1233 mêlent dépendances lv5 et base, sphères/idle/explosion. W1302/WDebuff1056 référencent heldtarget/tether/explosion lv5 et base. E346/E5348 préchargent des missiles distincts ; les trails lv5/base figurent aussi dans EMissile. RVisual594 conserve les noms sensibles à la casse Syndra_Base_R_Lv3_idleTrail et variante enemy. Ces arêtes ne prouvent ni prédicat de rang, sélection, création, owner ou recette.

Un DDS partagé E relu : DATA/Spells/Icons2D/SyndraPassive.dds, 2872 octets, 64×64 DXT1/sept mips, membre0.0.0.120, SHAb75628fd…. Lookup/provider/pixels ouverts ; aucun payload Troy ouvert. Mana courant : source_sha256 communautaire c9c6a61c… distinct du natif8eeb150e… ; PARType absent ne déclare pas Mana.

## 3. Consommateurs actuels

Sept fichiers relus, dont cinq Rust/deux lecteurs Python ; 17 ancres exactes. Six fichiers de frontières/SOURCE et24 contextes concordants. Deux consommateurs HUD supplémentaires réutilisés après garde d’identité, sans nouvelle lecture sémantique ; 14 mécanismes VFX communs et deux fichiers d’animation ordinaire inchangés. Aucun producteur nommé Syndra/Transcendent dans ces cinq Rust, sans absence globale revendiquée.

progression.rs:159 refuse Syndra avant points/rangs ; learn renvoie Result<(),String>, next_rank Result<u8,String>. lib.rs:621 route Learn ; spells.rs:120 et annie_w.rs:49 refusent ses casts. HUD ranks:7 exclut Syndra ; learning:9 appelle maxima avant next_rank, obstacle distinct. Rangs/cooldowns/Mana génériques ne qualifient pas Transcendent. Présence des mécanismes VFX communs ne prouve ni création, pose, horloge, arrêt ou pixels.

## 4. Attendu et observé

Attendu : états maximaux et variantes attribuables, distincts des bonus gameplay. Diagnostic conservé Syndra/Annie niveaux1–18 : 144 prédictions, Syndra72Learn/144Cast-CastAt refusés/rangs0000 ; Annie18Learn acceptés/54 refusés/rangs5553, Q5 au niveau9. Zéro tick, combat, déplacement ou achat ; aucun effet maximal Syndra exercé. Le refus d’apprentissage ne démontre pas l’absence d’un bonus sur un sort maximisé.

Relecture actuelle bornée : niveaux Syndra1/9/18, douze tentatives refusées et24 refus Cast/CastAt, snapshots complets avant/après identiques. Contrôle Annie Q5 au niveau9 et état final5553 concordants. XP diagnostique finale20245/niveau18, sans mutation directe des rangs. Les 144 prédictions et36 attributions XP restent héritées, sans rejeu complet ; API serveur non assimilée à une progression naturelle ou commande réseau.

Ancien audit : bootstrap1 sur suffixe v634 corrigé en v635 ; flux bruts initiaux non séparément conservés, limite explicite. Initial182/200 comparait incorrectement valeur de prédiction et réussite sans valeur ; correction des18seuls checks Annie, observé/pass uniquement, revérifiée. Ancien200/200 et95/95 réutilisés ; producteurs historiques non rejoués.

Actuel : 47/47 documentaires après qualification ciblée, 66/66 cohérence même agent. Premier collecteur46/47 : extrait annie_w arrêté à37, refus à49 ; seul extrait/check étendu, autres46checks inchangés. Six productions réussies et cet échec conservés ; erreur de préparation de gabarit également consignée. BUILD/RUN historiques0 ; binaire5478912/SHA6d6c7d24… inerte. Aucun nouveau jeu exécuté.

## 5. Écarts et limites

Apprentissage et admission HUD manquants ; quatre améliorations maximales non exercées. Producteurs, sphères/cibles, durées/géométrie, arrondis/ordre, lifecycle, recettes/payloads, lookup, création/owner/attache/horloge/arrêt, transport et pixels ouverts. Refus Syndra aux niveaux inspectés : snapshots comparés ; autres refus par flags, aucune garde NPC universelle. Aucun nouveau build/jeu/natif/REA/GPU/réseau ; V564/V606/Nami et autres clauses conservés. Relecture même agent, aucune validation indépendante/humaine.

## 6. Corrections et reprise

corrections_and_restart.json réutilise quatre tâches SOURCE/SIMULATION/NETWORK/VFX : politique/recettes ; admission de rang et état maximal ; événements owner/slot ; consommateurs des variantes Q5/W5/E5/R3. Les quatre corrections Q-DAMAGE/W-DURATION/E-WIDTH/R-RANGE du HUD restent dans leurs tâches QWER, sans clôture implicite. Fins : transitions QWE4→5/R2→3, valeurs/frontières/cibles/refus, lifecycle, synchronisation et pixels selon contrat qualifié. Reprise sur source, mapping/callsite, recette/payload/capture précis, dérive ou autorisation fonctionnelle distincte. Aucun correctif produit exécuté.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_syndra_passive_vfx_20261106 : evidence_review_corrected.json fait autorité, original evidence_review.json46/47 conservé ; coherence_review, qualifications, gardes et journaux. next_lot.json cible Talon, ligne de couverture vérifiée ; chercher ses audits existants.

Une unité de liaison bornée close ; zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. Rapport et ajouts CURRENT/HANDOFF seulement, après sauvegardes exactes et contrôle des sept protégés. Goal/Plan/UI/bases/registres/produit conservés.
