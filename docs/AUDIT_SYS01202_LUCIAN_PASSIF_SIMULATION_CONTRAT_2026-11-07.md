# V1500 — Lucian : contrat connu de Lightslinger

## 1. Exigence et périmètre

Unité AUD-SYS-01.2-02-LUCIAN-PASSIF-SIMULATION-CONTRAT-01, tâche CH-Lucian-PASSIF-SIMULATION-CONTRAT, exigence OLF-d45aab03-37e5-570d-a343-1bc763bdd5ee, parent SYS-01.2-02. Audit de 30 branches connues ; SOURCE reste a_qualifier. Phase D06 et six prérequis conservés. Tâche complète, fonctionnalité et goal ouverts.

Référence PUBLIC4.20.0.315 EUW/en_GB, date littérale 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct.

## 2. Sources et limites

Reçu docs/reference_requirement_trace_sources/lucian-passive-lightslinger-links-v595.json du 26 octobre 2026 : 1155725 octets, SHA256 80bbe5244aff041208f64f89373332f4878c70a079fc3e196c3e46fb8106bad2. Rapport FIDELITY_LUCIAN_PASSIVE_LIGHTSLINGER_LINKS_V595.md : 14357 octets, SHA256 a918964aac095caad87e00d05a76590f950309017f5301f54e1499f60f2e0a28. Rapport retrouvé malgré la liste vide du cache ; aucune absence d’asset déduite.

35 identités natives et 19 références communautaires séparées, six preloads. Treize Lua parcourus historiquement, zéro prototype enfant : quatre initialisations littérales, onze globals, neuf limites NEWTABLE (PassiveAttack8, Shot8, Dummy0, Q4, W8, R10, BasicAttack0, BasicAttack2 0, CritAttack0). Limites du lecteur, sans corruption déduite. CharScript communautaire vide, sans autorité serveur Riot.

Sept clés en_GB vérifiées, six présentes. Passif ligne 2223 : après un lancement de sort terminé, prochaine attaque dans les six secondes en double tir ; second tir avec @f1@ non résolu contre champions/structures, dégâts complets contre sbires/monstres et effets à l’impact. Description 4225 moins détaillée, sans priorité inventée. Buff armé 2224 ; Q 2225 répète le passif, sans formule Q déduite. Clé game_buff_tooltip_LucianE absente, fichier E présent ; cinq liaisons de buffs, quatre résolues, aucune substitution.

Passive conserve 25.dds, PersistsThroughDeath et NonDispellable. PassiveBuff conserve Lucian_Passive.dds, IsDamagingSpell=false et IsDeathRecapSource=true ; E conserve Draven_Bloodrage.dds et son drapeau récapitulatif. Ces métadonnées ne définissent ni charge ni attribution effective.

Shot/Dummy : Coefficient=1.2000000000000002, CastRange=950, coût/recharge nuls et icône 1041_Long_Staff.dds ; aucune formule ou portée passive adoptée. 84 lignes DDF dont dix non vides, anciens noms/tests distincts, aucune entrée Passive. Six niveaux passifs absents. Sept chemins candidats absents seulement. Dépendances Rageblade/Hurricane et particules/son ne prouvent pas leur exécution. Aucun nouvel accès D:, F-work ou EXE ni décodage natif.

## 3. Consommateurs réels

25 entrées concordent avec V595 : 16 Rust, deux lecteurs Python et sept JSON ; avec en_GB, 26 identités vérifiées. 36 fenêtres, dont 32 communes réutilisées. Ajouts death_recap.rs : source1–36, regroupement94–182, capture184–199, commit/projection200–213. 23 ancres enregistrées dont 22 entry_boundary_only/provides_feature_consumer=false ; renvois des branches résolus.

Learn/Cast/CastAt refusent Lucian. Attaques ordinaires, profils critiques, projectiles, mitigation, pénétration, boucliers, vol de vie, riposte et crédit de combat sont des acquis conservés. Les branches Garen/Trundle ne sont pas Lightslinger. Validation du windup et durée de vie d’un projectile libéré sont distinctes ; aucune équivalence du second tir déduite.

Le récapitulatif local capture l’acteur connu selon la visibilité avant impact, regroupe par acteur et additionne par type de dégâts. Source distingue Champion/Unit/Unknown/Other, sans identité de capacité. IsDeathRecapSource ne démontre pas ce raccordement. La correction RECAP-ATTRIBUTION demande une correspondance explicite ; aucun défaut du récapitulatif existant ou échec passif reproduit revendiqué.

Recherche Lucian/Lightslinger sur 16 Rust sélectionnés : zéro occurrence, sans absence globale ni relecture des 1158 dépendances revendiquée.

## 4. Attendu, observé et contrôles

Attendu documentaire : séparer sort terminé, charge réelle, premier/second tir, expiration et effets. Observé : 97/97 contrôles documentaires et 102/102 cohérences du même agent. Aucun nouveau build, test Rust, jeu, REA ou capture.

V595 hérité : deux parties publiques Map10 Lucian/Annie, base puis épée longue1036 donnant10AD. AD 52.040000915527344 puis 62.040000915527344 ; trois attaques à distance par cas et six projectiles Lucian→Annie témoins non critiques. Mitigation/régénération dans la tolérance 0,002, participants vivants niveau1, sans mort/fin de partie.

102 refus atomiques, snapshots inchangés : commandes invalides et Learn/Cast/CastAt QWER avant attaques puis aux offsets179/180/181 après Stop. Rangs et recharges nuls. 181 ticks d’attente par cas, soit362 ; Mana plafonné298.8800048828125, aucun ralentissement/stun. Stop n’est pas un déclenchement passif ; ces frontières à30Hz n’exercent pas une expiration sans charge armée. Ni second tir, critique passif, classes sbire/monstre/structure ou onhit qualifiés. Sword10AD ne résout pas @f1@.

Exécutable identifié uniquement en données : 6034944 octets, SHA256 14379fe38a5e149d16823afe2b28a7afd5682c7df2b22e62449e7aad44d1ebc6. BUILD/RUN0 hérités ; aucun accès actuel, chaîne/lock/1158 entrées non requalifiés.

Deux échecs actuels de contrôles documentaires conservés : contract01 omettait Known ligne95 ; contract02 utilisait attack_damage au lieu du champ boutique damage. Scripts qualifiés distincts, contract03 réussi ; aucun défaut du jeu corrigé. Erreurs d’affichage en lecture seule conservées séparément.

## 5. Écarts et conclusions ouvertes

Restent admission/fin des sorts, armement/rafraîchissement, six secondes, consommation/ordonnancement des tirs, @f1@ et classes de cibles, critiques/onhit/objets/récursions, validation/collision, annulation/cadence, attribution/crédit, ordre/niveaux/lifecycle, intégration/réseau/présentation.

Question propre OLU-1eccb022-bda1-56ca-beed-1dc920c0baaf distincte de SOURCE OLU-d2dbadd5-09fb-5708-af22-2fb0b9535c19. Dépendances/propriétaires conservés, aucune inconnue fermée. V564/BattleTraining et anciens échecs non corrigés.

## 6. Corrections et reprise

30 fiches dans corrections_and_restart.json, préfixe COR-SYS-01.2-02-LUCIAN-LIGHTSLINGER-, suffixe -01 : METADATA, LUA, SPELL-ADMISSION, CAST-COMPLETION, ARMING-REFRESH, WINDOW6, FIRST-CONSUMPTION, SECOND-SCHEDULE, TARGET-CLASSES, DAMAGE-FORMULA, CRITICAL, ONHIT, ITEM-PROCS, RECURSION, LIFESTEAL, MITIGATION, PER-SHOT-VALIDATION, COLLISION, TARGET-LOSS, STOP-CANCEL, ATTACK-CADENCE, RECAP-ATTRIBUTION, KILL-CREDIT, TICK-ORDER, LEVELS, LIFECYCLE, INTEGRATION, PROJECTION, PRESENTATION, VERIFICATION. Objectif unique, tâche existante liée, prérequis, travail, critère positif et condition de reprise distincts.

Reprendre sur source primaire nouvelle, consommateur modifié ou cas indispensable non couvert. Scénarios futurs avec vrais sorts publics terminés, charge armée, deux tirs témoins, frontières six secondes depuis ce déclenchement et matrices cibles/critique/onhit ; aucune charge injectée pour déclarer la fidélité. Aucune correction fonctionnelle enregistrée ou réalisée ici.

## 7. Livraison et qualification

Preuves : E:/mapslol3v3/audit_sys01202_lucian_passive_simulation_contract_20261107. Date documentaire Europe/Zurich, horodatages des reçus UTC. Git main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2486 entrées groupées préexistantes conservées. Prochain Lulu depuis122 paires : 68 candidats hors54 unités nommées, sans compte global déduit.

Audit borné terminé après sept rubriques ; tâche complète, fonctionnalité et goal ouverts. Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Même agent, sans revue indépendante ni acceptation humaine. Rapport et ajouts CURRENT/HANDOFF sauvegardés puis vérifiés ; goal, Plan/UI/bases, registres, produit/assets inchangés. Aucun gain temporel mesuré, aucune installation/migration.
