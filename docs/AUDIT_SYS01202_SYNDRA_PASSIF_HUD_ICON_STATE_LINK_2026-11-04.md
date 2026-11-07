# SYS-01.2-02 — Syndra : Transcendent et HUD, V1278

4 novembre 2026. Unité `AUD-SYS-01.2-02-SYNDRA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Syndra-PASSIF-PRESENTATION-HUD`, `OLF-26549bbc-c282-52e9-82d4-dc3f200aaa25` : relier état de rang maximal, effets, icône et texte aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-0b4318ed-2f46-5377-ab48-5fa8f01c84b5` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/D06-CH-Syndra consultés sans satisfaction revendiquée. Parent PRESENTATION, gameplay QWER et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/syndra-passive-transcendent-links-v635.json`, 3121055 octets, SHA `ed23a68f0ce554d5cdeb9681541b31a5ecd3ef0430a49a84df29cfe024ed6d3d`, UTC documentaire 2026-10-26T19:40:19.307987+00:00, sans attribution à l’heure d’exécution.

HUD enregistré : une définition/un catalogue. SOURCE : 122 relations, 116 identités, six sites/trois fichiers. V635 : 116 membres/348 associations, 11 sites/quatre fichiers ; union six fichiers/17 ancres. Aucun ID SOURCE supplémentaire ; registres gelés conservés. Réutilisation sans relecture native : 32 INIBIN, 51 Lua, 31 preloads, DDF et font.

Passive1LuaName=SyndraPassive, icône SyndraPassive.dds. Passive1 et quatre marqueurs de niveau sont chaînes "0", deux autres absents ; Passive1Desc vide, "5 Astral Spirts" conservé sans seuil inventé. Mana "334.0", croissance "50", vitesse "330", portée d’attaque "550" restent des chaînes. PARType absent. CharScript/Scripts vide56octets ; trois candidats alternatifs absents sans absence globale déduite.

Font2740/4285 concordent : **au rang maximal**, Q +15% dégâts contre champions, W +33% durée du ralentissement, E +50% largeur, R +75 portée. Deux BuffData exactement résolus. Producteurs, prédicat de rang, géométrie, ordre et arrondis non qualifiés. DDF16lignes : seul W;f2=@text×1.5 non vide ; ne pas transformer ce texte en durée maximale ni remplacer33% par un autre ratio. E/E5 sont distincts, LineWidth=0 dans les champs sélectionnés ne prouve aucune largeur effective ; R CastRange1–3="675.0000" n’exécute pas le bonus75.

51Lua sans fonctions enfants, seize limites NEWTABLE ; Q5/W5/E5/R3 preloads et persistance ne prouvent ni activation ni lifecycle. Noms étrangers Time Bomb/BurningAgony/SkarnerImpaleBuff et IreliaTranscendentBlades exclus des règles Syndra. 37 références communautaires comparatives : Q sphère visuelle, W sans saisie, E stun inconditionnel, R7/8/9 sphères fixes ; aucune autorité native revendiquée.

Un DDS partagé nécessaire `DATA/Spells/Icons2D/SyndraPassive.dds` : 2872octets, 64×64 DXT1/septmips, SHA `b75628fd0e2436faeb1b9db5fe2f91f2cb3a531d78ef32aefc974f352e3c422f`. Projet RADS0.0.1.7/membre0.0.0.120, taille/MD5 concordants ; sélection E avant unique stat/lecture SOURCE. Aucun DDS étranger/particule lu. Provider/pixels ouverts ; miroir font et témoin Ahri réutilisés.

Mana courant : source_sha256 identifie StatsJSON communautaire 7123octets/SHA `c9c6a61c45843164dc2430bc4aa5577e5af8216b613e5356caa98a6d82e88b8b`, distinct de l’INIBIN natif 2058octets/SHA `8eeb150e78825c8e0b308c8cf7ac34b9b24326789ee7e554e214b8dd34535883` ; resource_provenance.json.

## 3. Consommateurs actuels

17 ancres héritées exactes, deux consommateurs HUD complémentaires et 24 fichiers code/configuration vérifiés ; 16 entrées communes inchangées. Aucun producteur nommé Syndra/Transcendent dans le périmètre Rust sélectionné, recherche bornée.

progression.rs:159 refuse Syndra avant points/rangs ; learn:150 applique next_rank et renvoie Result<(),String>, prédicteur Result<u8,String>. lib.rs:621 route Action::Learn ; spells.rs:101 et annie_w.rs:29 refusent ses casts. award_experience:131 fournit une API serveur, sans commande réseau XP.

native_hud_ranks.rs:7 exclut Syndra de maxima. native_hud_learning.rs:9 appelle maxima avant next_rank : second obstacle réel au HUD d’apprentissage. native_hud_spells.rs:21 utilise rang/cooldown génériques, native_hud_bars.rs:11 Mana générique. Ces acquis ne constituent pas un affichage Transcendent.

## 4. Attendu, observé et contrôles

Deux diagnostics existants, Syndra/Annie, niveaux1–18 : 144 prédictions recalculées depuis courbe XP et règle locale, comparaison séquentielle avant/après de chaque rang. Syndra : 72Learn et144Cast/CastAt refusés, rangs0/0/0/0. Annie :18Learn acceptés,54refusés, rangs5/5/5/3 ; Q5 atteint au niveau9. Attendu du code courant conforme, sans qualifier le contrat historique Syndra.

36attributions XP diagnostiques par award_experience : 17 seuils puis1000 au plafond pour chaque cas, XP19245→20245/niveau18 conservé. Aucun rang injecté directement. Total278refus de commandes et10refus XP ; slots invalides/joueur inconnu, zéro/négatif/NaN/infini contrôlés. Refus Syndra de chaque niveau : snapshots bruts identiques ; autres refus par flags enregistrés, aucune garde NPC universelle.

Zéro tick de simulation/combat/déplacement/achat. Les quatre améliorations au rang maximal restent **non exercées** ; refus d’apprentissage ne prouve pas absence de bonus sur un sort maximal. Progression naturelle, réseau, rendu/sons/animations non vérifiés.

Historique15fichiers/13195518octets,13empreintes anciennes/deux identités nouvelles ; RUN brut identique au relevé. Binaire 5478912octets/SHA `6d6c7d24b82e4139c4502c352a3169fbd2e24f7e5ce68eca9e7b59dcb6ad2067` inerte, BUILD/RUN0 hérités.

Contrôles200/200 après correction ciblée, cohérence95/95 séparée du même agent. Bootstrap initial1 : suffixe v634 erroné, original/journal conservés, seule référence corrigée en v635 ; bootstrap02=0. evidence01=1 : comparaison incorrecte rang/prédiction contre réussite sans valeur,182/200 ; seules18comparaisons Annie corrigées après relecture des144transitions. Original, logs et rank_result_type_qualification.json conservés ; qualification01=0. Aucun nouveau jeu/build/VM/REA ni revue indépendante/humaine.

## 5. Écarts et inconnues

Apprentissage Syndra et table HUD non admis. Quatre producteurs de bonus, transitions, sphères/cibles, durées/géométrie, arrondis/ordre, lifecycle, provider/icônes/texte, transport et pixels ouverts. Métadonnées et choix communautaires ne résolvent pas ces inconnues. V564/V606/Nami et autres clauses conservés.

## 6. Corrections et reprise

Réutiliser SOURCE/SIMULATION-CONTRAT/SIMULATION/NETWORK/HUD. `COR-SYNDRA-TRANSCENDENT-POLICY-01` : qualifier prédicat de rang et quatre bonus. Fin : contrat historique sourcé, cibles, bases, opérations et arrondis explicites.

`COR-SYNDRA-RANK-ADMISSION-01` : apprentissage autoritaire puis table HUD. Fin : rangs admissibles, points/niveaux, refus et cohérence client/serveur vérifiés selon contrat, sans copier Annie comme preuve historique.

Dans les tâches QWER existantes : `COR-SYNDRA-TRANSCENDENT-Q-DAMAGE-01`, dégâts champion +15% ; `COR-SYNDRA-TRANSCENDENT-W-DURATION-01`, ralentissement +33% ; `COR-SYNDRA-TRANSCENDENT-E-WIDTH-01`, largeur +50% ; `COR-SYNDRA-TRANSCENDENT-R-RANGE-01`, portée +75. Fin individuelle : transition QWE4→5/R2→3, frontière/cible, valeur/arrondi et refus pertinents observés, avec prérequis de sort effectif.

`COR-SYNDRA-TRANSCENDENT-HUD-BINDINGS-01` : icône/texte/état amélioré autoritaires. Fin : transitions, transport et pixels observés. Reprendre sur artefact/callsite historique nouveau, dérive ou autorisation fonctionnelle ; aucune réparation produit ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_syndra_passive_hud_20261104` : evidence_review_corrected.json, coherence_review.json, qualification initiale, DDS/histoire, resource_provenance.json, phase_package_prerequisites.json et journaux. Hook7/7 réutilisé, limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes/sept protégés vérifiés à la publication. Une unité documentaire close, zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
