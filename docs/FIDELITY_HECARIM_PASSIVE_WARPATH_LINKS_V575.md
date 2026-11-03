# SYS-01.2-02 — Hecarim : Warpath, V575

Date UTC : 2026-10-26T01:28:11.938449+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 2014-11-17 à 17:46:45; fuseau et déploiement non établis. Catalogue officiel 4.20.1 distinct.

## Résultat intégré

CH-Hecarim-PASSIF-SOURCE, CH-Hecarim-PASSIF-SIMULATION-CONTRAT et CH-Hecarim-PASSIF-SIMULATION sont enrichies par 33 associations vers 11 ressources natives aux rôles distincts et 58 liens vers 29 points de code actuels. SYS-01.2-02 référence ce lot. Trois questions propres et quatre dépendances conservées. Les prérequis de phase/lot sont consultés sans être déclarés satisfaits pour l’acceptation du gameplay.

**Les bonus de vitesse testés ne produisent aucun bonus de dégâts d’attaque chez Hecarim. Le comportement de collision observé ne qualifie pas son passage natif à travers les unités.** Les points de code restent `entry_boundary_only` et `provides_feature_consumer=false` pour Warpath. Aucun gameplay ou asset modifié.

## Sources et limites

| Ressource | Identifiant |
|---|---|
| Hecarim.inibin | OLS-052bbb16-2c48-5c43-8ad5-f4ffb9ac6c14 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptHecarim.luaobj | OLS-c7ed141f-56d1-5079-a754-1ce59e360fea |
| CharScriptHecarim.preload | OLS-17fc23c1-8233-56ee-9bfa-3dd1d56b0481 |
| HecarimPassive.inibin | OLS-aaf60716-8985-5f93-99fb-5036253657a3 |
| HecarimPassive.luaobj | OLS-bc454b21-f8ce-54b3-94d6-d3edf268cf85 |
| HecarimRamp.inibin | OLS-43958908-50e5-5b8b-a64e-667bd0fd155b |
| HecarimRamp.luaobj | OLS-05670386-6c7b-50bb-883b-aad650e17480 |
| HecarimRamp.preload | OLS-8564e09f-49fa-582a-8bbb-f3cac28d595e |
| HecarimRampSpeed.luaobj | OLS-69fa8bd2-211c-5376-a6eb-cac297044329 |
| Hecarim.ddf | OLS-dc0b3432-ecb5-5a2f-a752-016ad4d28978 |

Les 11 ressources sont vérifiées en taille/SHA256 contre le registre et en taille/MD5 contre les manifestes RADS sélectionnés. L’ordre effectif de montage historique reste distinct. `native_metadata.source_roles` détaille chaque rôle; les données E/Ramp et DDF restent un contexte connexe, sans être adoptées comme règles du passif.

Hecarim.inibin désigne HecarimPassive. Le tooltip en_GB ligne 1984 décrit le passage à travers les unités et des dégâts d’attaque égaux à `f2` pour cent du bonus de vitesse de déplacement; `f1` affiche le bonus de dégâts courant. La description ligne 4199 confirme la conversion d’une part de la vitesse bonus. Les producteurs de ces deux paramètres et leur progression par niveau ne sont pas qualifiés.

La définition du personnage référence `Hecarim_Passive.dds`, alors que le Lua du buff référence `Hecarim_Warpath.dds`. Cette différence est conservée; aucune substitution automatique ni absence de texture n’en est déduite. Le buff déclare `PersistsThroughDeath=true`, ce qui ne suffit pas à qualifier le calcul ou la réinitialisation des statistiques à la réapparition.

Quatre chunks Lua sont entièrement lus, sans prototype enfant. Trois initialisations littérales sont reconnues. Le lecteur littéral de HecarimRamp.luaobj rencontre NEWTABLE au pc10 : limite du lecteur, pas corruption démontrée. Aucun callback du serveur historique exécuté.

Les deux preloads sont conservés. Celui du personnage référence notamment le passif et des animations W/ArcadeQ; celui de Ramp référence vitesse, attaque et particules E. Le second binding de tooltip, ligne 1985, décrit Devastating Charge : gain de vitesse et attaque renforcée selon la distance parcourue. E/Ramp est une capacité active distincte de Warpath.

Hecarim.ddf contient 16 entrées pour RapidSlash, Ramp, W et Ult, sans entrée HecarimPassive. Les coefficients 0,6 / 0,5 / 1,0 de dégâts bonus associés à ces sorts actifs ne fournissent pas le pourcentage `f2` du passif. L’absence d’une entrée dans ce DDF n’est pas une preuve d’absence de sa formule dans toutes les sources possibles.

Les anciennes descriptions de critique d’alliés et de vitesse d’attaque restent enregistrées sans adoption comme règles. Les champs Passive1Level1..6 recherchés sont absents; aucune valeur zéro n’est inventée. Huit références communautaires sont conservées séparément; CharScriptHecarim.cs est vide. Les autres scripts/JSON ne démontrent pas l’exécution originale de Warpath.

## Vitesse, statistiques et attaques réellement testées

Cinq simulations Map10 utilisent les commandes publiques : état de base, bottes 1001, Soin, bottes avec Soin, puis épée longue 1036 comme contrôle de dégâts séparé. Hecarim bleu et Annie rouge atteignent des positions centrales par Move puis Stop. Aucun changement direct de santé, position, niveau, XP, rang, ressource ou effet; aucun événement artificiel de dégâts.

| Cas | Dégâts d’attaque observés | Vitesse avant / pendant / après | Impacts | Refus | Suivi, ticks |
|---|---:|---|---:|---:|---:|
| item_None_heal_false | 61.375999 | 345.000000 / 345.000000 / 345.000000 | 6 | 15 | 90 |
| item_Some(1001)_heal_false | 61.375999 | 370.000000 / 370.000000 / 370.000000 | 6 | 15 | 90 |
| item_None_heal_true | 61.375999 | 345.000000 / 441.799988 / 345.000000 | 6 | 16 | 90 |
| item_Some(1001)_heal_true | 61.375999 | 370.000000 / 467.799988 / 370.000000 | 6 | 16 | 90 |
| item_Some(1036)_heal_false | 71.375999 | 345.000000 / 345.000000 / 345.000000 | 6 | 15 | 90 |

Les bottes apportent +25 vitesse. Le Soin public active le bonus de vitesse courant de 30% pendant 30 ticks; les valeurs finales tiennent compte des plafonds du contrat local. Le bonus temporaire expire exactement au tick 30 dans les captures, avec retour à 345 ou 370. Au moins un impact de mêlée a lieu pendant le bonus dans chacun des deux cas Soin. Avant, pendant et après, les dégâts d’attaque restent 61,375999. L’épée longue apporte séparément +10 dégâts, soit 71,375999, et les impacts suivent cette augmentation.

Attendu pour les voies génériques : chaque impact de mêlée correspond au windup du snapshot précédent, à sa cible et à son tick de libération, sans critique. Les dégâts physiques attendus sont `brut × 100 / (100 + armure)`, corrigés de la régénération de la cible. Observé : 30 impacts ainsi identifiés, résidu inférieur à 0,002. Les cinq suivis de 90 ticks, soit 450 ticks au total, n’ajoutent que la régénération attendue.

Les 77 refus atomiques comprennent 15 commandes par cas — joueur inconnu, attaque de soi, slot invalide, Learn/Cast/CastAt pour les quatre capacités — et deux relances de Soin pendant son délai. Les snapshots sont inchangés. Les capacités Hecarim restent explicitement refusées dans les chemins testés.

Le bonus de Soin et les plafonds de vitesse sont des **contrats locaux**, pas une validation de Warpath historique. movement_rules.json signale sa reconstruction communautaire non qualifiée; heal_rules.json conserve notamment son conflit de cooldown 240/300 secondes. La base exacte que Warpath doit convertir — avant ou après plafonds, modificateurs et ralentissements — reste ouverte. Les tests n’adoptent pas implicitement la vitesse affichée comme base native du pourcentage `f2`.

## Passage à travers les unités : comparaison réelle

Quatre simulations supplémentaires comparent Hecarim et Garen. Pour un allié, la destination demandée est le centre occupé par Annie au départ. Pour un ennemi, les deux champions sont positionnés par Move dans la zone centrale puis le mobile reçoit une destination 250 unités au-delà d’Annie. Les positions du bloqueur restent constantes.

| Cas | Somme des rayons navigation | Distance minimale au centre | Distance finale | Destination atteinte |
|---|---:|---:|---:|---|
| hecarim_ally_occupied_path | 80.0 | 80.000000 | 80.000000 | False |
| garen_ally_occupied_path | 65.0 | 65.000000 | 65.000000 | False |
| hecarim_enemy_occupied_path | 80.0 | 3.004350 | 250.000061 | True |
| garen_enemy_occupied_path | 65.0 | 3.004350 | 250.000061 | True |

Hecarim s’arrête à 80 unités du centre allié, Garen à 65; aucun n’atteint le centre occupé. Les deux traversent le centre de l’ennemi à environ 3,004 unités et atteignent leur destination. Le passage à travers un ennemi est donc un comportement partagé par le contrôle Garen; il ne valide pas une propriété spécifique d’Hecarim.

Les rayons de navigation natifs restent distincts des corps de gameplay. Hecarim déclare navigation 50 et gameplay 80; les 80 unités du test allié sont **50 + 30**, somme des rayons de navigation d’Hecarim et d’Annie. Elles ne prouvent pas l’emploi du rayon gameplay 80. Les sbires, monstres, obstacles temporaires et autres conditions de passage restent à qualifier.

## Consommateurs actuels

Les liens couvrent le calcul de dégâts de base/croissance/objets, ses lecteurs, les statistiques, la vitesse, ses modificateurs et plafonds, les commandes, les attaques, les dégâts, la régénération, les achats, le Soin de contrôle et les fonctions d’occupation alliée. Le calcul AD inspecté prend base, croissance, objet, autel et ajustement explicite; il n’applique pas la conversion de vitesse d’Hecarim. Le filtre d’occupation distingue les équipes sans exemption Hecarim dans les chemins inspectés.

Le cycle de réapparition est seulement lu statiquement. Les effets réseau, HUD, animation, VFX et audio ne sont pas acceptés à partir de ces snapshots. Les tests de géométrie centraux ne corrigent pas le défaut de déplacement V564, qui reste ouvert.

## Identité et livraison vérifiée

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-hecarim-passive-warpath-probe.exe`. Taille : 6084096 octets. SHA256 : `9c0bf4fbb737d84019e0b0306ab6d9bd5ac8b06890182ea497d0ef394de0889f`.

BUILD/RUN code 0, openleague_core non-test. Verrou privé aligné sur les identités/checksums du verrou racine. Les 1 158 entrées core/ressources et la chaîne des preuves antérieures sont inchangées, y compris Graves V574 et les diagnostics échoués conservés par ses prédécesseurs. Aucun client ou serveur historique exécuté.

Discovery, inspection, prepare, check, publish et audit : code 0. Les contrôles refusent 72 associations invalides et quatre graphes invalides. Trois fragments de trace enrichis, 42 212 conservés. Les lecteurs réels Store.task/copy_text/summary/dépendances et la résolution de trace sont vérifiés sur les deux bases SQLite : quatre destinataires, 42 603 autres lignes du catalogue, 42 607 états manuels et 23 événements historiques conservés. Intégrité et synchronisation normale idempotente vérifiées. Identifiants, hiérarchie et registre des inconnues sont identiques en octets.

Revue globale fraîche : 42 215 exigences, 98 976 sources, 3 431 consommateurs; 3 431 ancres exactes et aucune divergence de leurs fichiers courants. Les 26 189 inconnues ouvertes et 5 517 résolues restent inchangées. Cette revue ne re-hashe pas toutes les sources et ne mesure pas un pourcentage de jeu terminé.

## Travail restant

- Qualifier `f1`, `f2`, la progression par niveau, la base exacte de vitesse bonus et les arrondis.
- Intégrer la conversion dans les statistiques et les dégâts réels; vérifier achats/ventes, effets temporaires, ralentissements, plafonds et niveaux.
- Qualifier le passage à travers les unités par catégories et équipes, puis son intégration aux déplacements sans traverser le terrain interdit.
- Vérifier mort/réapparition, fin de partie et interactions; la persistance déclarée du buff n’est pas une politique complète.
- Qualifier séparément réseau, HUD, présentation, animations, VFX et audio.
- Conserver les inconnues d’icônes, le contexte E/Ramp et le défaut de déplacement V564.

## Fichiers et reprise

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu : docs/reference_requirement_trace_sources/hecarim-passive-warpath-links-v575.json. Preuve : docs/fidelity_hecarim_passive_warpath_links_v575.json. Couverture, plan, checkpoint, CURRENT, HANDOFF et deux bases mis à jour avec sauvegardes. Scripts/journaux : préfixe revision575_Hecarim sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Aucun statut, case ou inconnu fermé automatiquement.

Continuer SYS-01.2-02 depuis revision576_trace_review/REVIEW.json. HecarimV575 publiée/auditée :3fiches,11ressources,33associations,29points/58liens limités. Cinq cas vitesse/AD et4collisions publics :30impacts mêlée,77refus,450ticks;vitesse345/370/environ441.8/467.8 sans bonusAD,épée1036 +10AD distincte. Hecarim/Garen bloqués par allié à80/65 et tous deux traversent ennemi;pas preuve Warpath. f1/f2,base vitessebonus,ghosting et lifecycle ouverts. Icônes personnage/buff distinctes;DDF16entrées actives sanspassif;Ramp NEWTABLE pc10. Préserver INPUTS_BEFORE.previous_artifacts V575 et chaîne antérieure. Aucun statut/case/inconnu fermé. Poursuivre un autre passif après inspection réelle,par exemple Heimerdinger. Défaut déplacementV564 ouvert;goal actif.
