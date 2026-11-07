# Karma — liaison bornée du passif et des effets visuels

## 1. Exigence et portée

2026-11-05, V1357 ; `AUD-SYS-01.2-02-KARMA-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Karma-PASSIF-PRESENTATION-VFX` ; `OLF-1eade638-1ddc-5998-a0c7-98d97231f863`. Relier les déclarations applicables aux consommateurs actuels et définir les corrections nécessaires. Seule cette liaison est clôturée ; tâche VFX complète, implémentation et acceptation restent ouvertes.

Audit : terminé pour ce périmètre. Implémentation : passif non établi dans les corps inspectés, acquis génériques conservés. Vérification : statique documentaire réussie ; runtime non réexécuté. Acceptation humaine : non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/karma-passive-gathering_fire-links-v583.json`, copie E immuable référencée dans `initial_scope.json` : 906451 octets, SHA-256 `878136aa8f843898c4e7068b6e1997e305f3725616a13f1a91151686934e362d`. Douze identités natives et rôles ; référence LoL4.20/EUW/en_GB héritée. Aucun accès D : les chemins natifs restent des données. V1228 source69/69, consommateurs64/64 et intégration40/40 restent historiques.

Quatre Lua structurels, trois initialisations/12 affectations. CharScript118octets contient deux flags : il n’est pas vide, contrairement au candidat communautaire. KarmaPassive184 lie KarmaPassive/KarmaInnerFlame.dds/persistence ; Chakra284 conserve sept flags. Mantra239 est limité par NEWTABLEpc6, sans preuve de corruption ou exécution serveur. Aucun AutoBuff reconnu dans ces quatre vues ne démontre une absence globale d’effet.

Texte : dégâts de compétence contre champion ennemi réduisent Mantra ; demi-effet des attaques de base, f1/f2 ouverts. Description4210 liée par PassLev1Desc1. Disponibilité Mantra niveau1 sans point, cooldown45/42/39/36 et empowerment8s sont distincts. HP/mana hérités, passif8/7/6/5, effets18/36/54/72 et30/60/90/120, DDF Chakra30/25/20 ne deviennent pas des remboursements ; quatre lignes DDF passif sont vides sur28.

Trois preloads707octets/neuf références : refresh passif, activation R et anciens noms une/deux charges séparés. Identités et textes confrontés aux captures E455468/625088octets. Une DDS2176octets64×64/DXT1/mipbrut0, membre0.0.0.155 : métadonnées héritées, pas sélection ou pixels actuels. KarmaInnerFlame.dds n’avait pas été localisée dans les scopes antérieurs sélectionnés ; pas absence globale ni alias automatique. Dix lignes de locale et huit candidats communautaires secondaires conservés.

## 3. Consommateurs réels

Quinze entrées complètes,14 Rust et le JSON local cooldown_rules :31 ancres, `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:46` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `shop.rs:215` ; `shop.rs:261` ; `lib.rs:744` ; `lifecycle.rs:33` ; `attacks.rs:157` ; `damage.rs:53` ; `cooldown.rs:11` ; `cooldown.rs:10` ; `lifesteal.rs:4` ; `ezreal_q.rs:190` ; `spells.rs:90` ; `progression.rs:164` ; `spells.rs:120` ; `cooldown.rs:13` ; `ezreal_q.rs:15` ; `ezreal_q.rs:104` ; `ezreal_q.rs:224` ; `ezreal_q.rs:225` ; `ezreal_q.rs:243` ; `ezreal_q.rs:193` ; `lifecycle.rs:83` ; `projected_live.rs:168`.

Racines `F:/OpenLeague/crates/core/src/`, projected_live dans `crates/client/src/`, règles dans `data/4.20/`. Les gardes de sorts/rangs refusent Karma avant une création de Mantra. La règle générique applique réduction bornée0..0.4 et minimum0, puis ceil à30Hz lors du lancement ; elle n’est pas un remboursement par impact. Le JSON419octets indique explicitement la reconstruction et les limites serveur.

Le helper EzrealQ rembourse les délais actifs de30ticks, bornés au tick courant. La garde champion est chez ses appelants : lancement Ezreal, vol propriétaire/équipe/session et impact physique accepté ; elle n’est pas dans le helper. Ce chemin ne fournit pas Gathering Fire. Dégâts, vol de vie, régénération, snapshot et reset génériques restent distincts. Projection inspectée pour Annie.

Recherche bornée Karma/GatheringFire : zéro occurrence dans ces15 textes, sans absence globale déduite.22 comparaisons sélectionnées/86 contextuelles chevauchantes concordent ;14 mécanismes VFX et2 animations ordinaires réutilisés, sans prouver événement, attache ou rendu passif.

## 4. Attendu, observé et contrôles

Attendu : source, limites et consommateurs précis reliés sans transformer des métadonnées en comportement exécuté. Observé :101/101 contrôles documentaires et96/96 de cohérence séparée du même agent ; témoins sauvegardés comparés, sans relecture indépendante ou second décodeur.

V583 hérité : deux cas Karma/Annie,12 impacts physiques ordinaires,34 refus,180ticks finaux ; Mantra refusé avant/après, rangs/délais zéro et aucun cooldown armé. Cela ne mesure ni montant ni échec isolé du remboursement. Codex3108 apporte10%CDR/30AP, distinct du passif.

Deux témoins GarenQ créent240/216ticks avec0/10%CDR, deux refus et180ticks observés ; date absolue de disponibilité constante pendant le décompte naturel. Total36 refus/360ticks, sans fusionner les périmètres. Binaire historique6049792octets/SHA `f0f2927e2383981625873442b3a45169212159eaf776716083d7dc2df2a7266e`, BUILD/RUN0 conservés comme données. Aucun binaire ou stockage rouvert. Dates des reçus distinctes de ce contrôle.

Erreur préparatoire de recherche de deux noms de gabarits conservée et résolue. Collect01 refusé par argparse pour rôle invalide, avant exécution ; collect02/root réussit. Journaux et script antérieur conservés. Aucun nouveau build, jeu, décodage natif, GPU, REA ou probe.

## 5. Écarts et inconnues

f1/f2, éligibilité détaillée, attribution, ordre CDR/remboursement, borne, arrondi, rangs, relances et lifecycle restent ouverts. Recette, sélection effective, création, attache, pose et rendu non qualifiés. V564 et les inconnues enregistrées sont conservés. Les anciens reçus stockage/Jinx/Jax restent inertes, sans DB, cache, backup, récupération ou nettoyage.

## 6. Corrections et reprise

Trois clauses de la tâche existante : gathering-fire-visual-applicability-source ; armed-Mantra-eligible-hit-refund-event ; resource-attachment-render-lifecycle. Objectifs, prérequis, critères et conditions précis dans `corrections_and_restart.json`. Aucune correction produit implicite.

Prochain lot : CH-Karthus-PASSIF-PRESENTATION-VFX, identité et reçu V584 dans next_lot.json. Réutiliser preuves et mécanismes inchangés ; reprendre uniquement sur source, appel, événement ou dérive précise. Aucun gain temporel mesuré, inventaire global ou replay inchangé nécessaire.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_karma_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, operations et journals, puis result.json et reçus de publication. Les sept critères et la publication ont leurs contrôles séparés.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2344 entrées sales groupées conservées. Publication : un nouveau rapport et ajouts exacts CURRENT/HANDOFF avec archives. Goal, Plan/UI/bases, registres, produit et assets inchangés. Seule liaison bornée clôturable ; jeu, parent, fonctionnalité et acceptation ouverts.
