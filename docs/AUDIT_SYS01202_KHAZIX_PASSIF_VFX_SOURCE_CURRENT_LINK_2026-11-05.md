# Kha’Zix — liaison du passif et des effets visuels

## 1. Exigence et portée

2026-11-05, V1363 ; `AUD-SYS-01.2-02-KHAZIX-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Khazix-PASSIF-PRESENTATION-VFX` ; `OLF-a58f3b00-9b6d-550b-be64-888752fad8af`. Relier déclarations applicables et consommateurs actuels, puis préciser les corrections. Seule cette liaison bornée est clôturée ; la tâche VFX complète reste ouverte.

Audit : terminé pour ce périmètre. Implémentation : Menace invisible non établie dans les corps inspectés, acquis génériques conservés. Vérification : statique documentaire réussie ; runtime non réexécuté. Acceptation humaine : non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/khazix-passive-unseen_threat-links-v589.json`, copie E immuable référencée dans initial_scope.json :1352627 octets, SHA-256 `1b039a0cf78f903a873c163203c16a332a222245147430c69c8877c0343b6f3c`.29 identités et rôles ; référence LoL4.20/EUW/en_GB héritée. Les chemins D restent des données, sans accès direct. V1234 source64/64, consommateurs47/47 et intégration40/40 restent historiques.

Onze Lua structurels, deux initialisations vides et zéro affectation qualifiée : CharScript56 et RInternalCD56. Neuf limites NEWTABLE : Passive/PDamage pc16, PSlow14, R/REvo18, RStealth6 et trois attaques pc0. Les chunks d’attaque partagent leur contenu mais gardent leurs identités. buff conserve un objet de limite, pas un BuffName inventé. Aucune absence native d’AutoBuff ou d’effet ne se déduit de ces lectures partielles ; pas de corruption ou callback serveur exécuté.

Description4216 liée et tooltip2174 : quand l’équipe ennemie ne voit pas Kha’Zix, prochaine attaque contre champion ennemi avec bonus magique et ralentissement2s. f1/f2/f3 restent ouverts. Valeurs brutes3/35/4/3/Coefficient0 non reliées à ces paramètres ; quatre formules PDamage vides parmi40 lignes DDF. Trois bindings manquants, dont GreenTerrorBasicAttack, et six candidats absents restent des constats bornés, sans alias automatique. R/REvo, furtivité, isolation et contexte Rengar sont distincts.

Six preloads,2763 octets/37 références : variantes gauche/droite, cible, slow, textures évoluées et R. Déclarations de dépendances, pas activation ou recette complète. Captures E666319/884870 vérifiées. Une DDS2872 octets64×64/DXT1/mip7, membre126 ; ni sélection effective ni pixels actuels qualifiés. Sept chaînes de locale, quinze références communautaires secondaires. Lecteurs Lua/INIBIN enregistrés conservés, non exécutés ici.

## 3. Consommateurs réels

Dix-sept entrées complètes :15 Rust et deux JSON,39 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `lib.rs:744` ; `damage.rs:53` ; `attacks.rs:157` ; `lifesteal.rs:4` ; `regeneration.rs:32` ; `shop.rs:261` ; `shop.rs:215` ; `lifecycle.rs:33` ; `attacks.rs:103` ; `damage.rs:38` ; `penetration.rs:4` ; `penetration.rs:9` ; `vision.rs:48` ; `vision.rs:79` ; `vision.rs:95` ; `vision.rs:137` ; `slows.rs:12` ; `slows.rs:78` ; `slows.rs:74` ; `movement.rs:53` ; `vision.rs:30` ; `vision.rs:32` ; `vision.rs:83` ; `vision.rs:96` ; `vision.rs:93` ; `vision.rs:115` ; `attacks.rs:152` ; `lifecycle.rs:83` ; `projected_live.rs:168` ; `progression.rs:164` ; `spells.rs:120`.

Racines `F:/OpenLeague/crates/core/src/`, projected_live dans `crates/client/src/`, règles dans `data/4.20/`. La vision actuelle utilise équipes, alliés, sources vivantes, rayons, ligne de vue et révélation Ignite. Sans interactions, la branche actuelle retourne visible ; cette politique locale n’est pas le contrat historique complet. Rayon Kha’Zix : champ explicite absent, résolution du défaut1350. Les JSON2041/65798 octets documentent les limites de brouillard, révélation, furtivité et activation des sources.

La garde d’attaque visible_to(p.team,target) demande si l’attaquant voit la cible. Menace invisible demande si l’équipe ennemie voit le propriétaire : sens différent, pas événement de disponibilité établi. Dégâts, ralentissements, vitesse, régénération et nettoyage génériques restent acquis ; sorts/rangs Kha’Zix refusés et projection inspectée pour Annie.

Recherche bornée Khazix/UnseenThreat/particule passive : zéro occurrence dans les15 corps Rust ; deux libellés attendus dans le JSON de rayons. Pas d’absence globale déduite.22 comparaisons sélectionnées et92 contextuelles chevauchantes concordent ;14 mécanismes VFX et deux animations ordinaires réutilisés.

## 4. Attendu, observé et contrôles

Attendu : relier sources, acquis et lacunes sans transformer visibilité locale, constante ou preload en comportement natif complet. Observé :118/118 contrôles documentaires et109/109 de cohérence séparée du même agent sur témoins sauvegardés. Aucune relecture indépendante ou validation humaine.

Deux cas V589 hérités, AP0/20 avec Amplifying Tome : huit impacts MELEE physiques ordinaires,32 refus inchangés,240 ticks cachés et360 ticks finaux. Aucun bonus magique, slow ou changement de vitesse observé dans ces cas ; coefficients natifs indéterminés. Rangs/délais restent zéro, acteurs vivants niveau1.

Relecture qualifiée des tableaux V1234 conservée, non recalculée ici : par cas,2164 échantillons de visibilité avec projections concordantes,1860 frames de mouvement séparées,30 ticks cachés initiaux puis90 au retour,180 ticks finaux visibles. Attentes cachées immobiles/régénération et fins visibles sont disjointes des déplacements/attaques. Vitesse cible330 ; attaque ennemie sur Kha’Zix invisible refusée sans mutation. Ces observations établissent un cycle local, pas la furtivité ou le fog4.20 natif, ni une acceptation réseau.

Binaire historique6120960 octets/SHA `13e1b546ed5a5b4defae0fef81f979a9a6a6fe09d612a86bcddf879e938e7f64`, BUILD/RUN0 conservés comme données ; aucun binaire rouvert ou déclaré équivalent au courant. Dates documentaires et contrôle actuel distincts. Aucun nouveau build, jeu, décodage natif, GPU, REA, sonde, réseau, HUD, VFX ou audio exécuté.

## 5. Écarts et inconnues

Vision native, disponibilité, état initial, consommation/réarmement, formule dynamique, fraction de slow, ordre, catégories et cycle de vie restent ouverts. Recette, création, sélection effective, attache, pose et rendu non qualifiés. Neuf limites du lecteur ne sont pas une preuve d’absence d’effet. Inconnues et V564 conservés ; anciens binaires/stockages inertes, sans DB, cache, backup, récupération ou nettoyage.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : unseen-threat-visibility-resource-applicability ; qualified-ready-attack-magic-slow-event ; qualified-ready-target-resource-render. Objectifs, prérequis, critères et conditions précis. Aucune correction produit implicite.

Prochain lot : CH-KogMaw-PASSIF-PRESENTATION-VFX, identité et reçu dans next_lot.json. Reprendre sur source, appel, événement ou dérive précise ; aucun recensement global ou replay inchangé. Aucun gain temporel chiffré.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_khazix_passive_vfx_20261105/`, evidence_review.json, coherence_review.json, operations, journals, puis result.json et reçus de publication. Sept rubriques et publication contrôlées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2350 entrées sales groupées conservées. Publication : nouveau rapport et ajouts exacts CURRENT/HANDOFF avec archives. Goal, Plan/UI/bases, registres, produit et assets inchangés. Parent, jeu, fonctionnalité, autres clauses et acceptation restent ouverts.
