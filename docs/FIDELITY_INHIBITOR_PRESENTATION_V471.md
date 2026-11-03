# SYS-01.2-02 — Présentation des inhibiteurs, V471

Dix fiches sont enrichies : PRESENT, PRESENT-MODEL, PRESENT-TEXTURE, PRESENT-ANIM et PRESENT-AUDIO pour TT_OrderInhibitor et TT_ChaosInhibitor. Les références et les consommateurs précis sont intégrés au plan. Les questions de fidélité complète restent ouvertes.

## Modèles et textures effectivement sélectionnés

La réception des snapshots appelle nexus_ceremony::destroyed. Pour les inhibiteurs, ce prédicat lit le type de structure et health<=0. Lors d’un changement, le client retire l’ancienne entité, choisit l’alias avec ou sans suffixe _destroyed et demande un modèle au catalogue fusionné. L’état redevenu vivant sélectionne ainsi l’alias intact. Ce chemin est vérifié par lecture du code, sans nouvelle observation graphique.

Le catalogue sélectionne les quatre fichiers ci-dessous. Les anciens chemins des définitions monde restent recensés séparément : ils ne sont pas les chemins GLB utilisés par cette demande au catalogue.

| Alias | GLB sélectionné | Texture native | Pixels décodés |
|---|---|---|---|
| TT_OrderInhibitor | structures/native_intact_tt_orderinhibitor.glb | Inhibitor_diff.dds | 512 × 512, RGBA identiques |
| TT_OrderInhibitor_destroyed | structures/native_tt_orderinhibitor_d.glb | OrderInhibitor_D.dds | 512 × 512, RGBA identiques |
| TT_ChaosInhibitor | structures/native_intact_tt_chaosinhibitor.glb | Chaos_Inhibitor_diff.dds | 512 × 512, RGBA identiques |
| TT_ChaosInhibitor_destroyed | structures/native_tt_chaosinhibitor_d.glb | ChaosInhibitor_D.dds | 512 × 512, RGBA identiques |

Les comparaisons portent sur tous les pixels après décodage CPU par Pillow. Elles n’attestent pas l’espace colorimétrique du rendu, les UV, le shader, l’éclairage, les masques ou les effets. Chaque GLB contient un matériau de base KHR_materials_unlit à double face. Aucun lecteur de matériau propre au Nexus n’est utilisé pour qualifier les inhibiteurs.

Les noms de maillage, squelette, texture et l’échelle 1.0 sont lus dans les fichiers INIBIN sélectionnés et correspondent aux sources d’export. Les formes intactes et détruites ont chacune 10 articulations et un clip. L’exporteur n’est pas réexécuté ; les entrées et sorties enregistrées sont vérifiées par identité.

Les anciennes empreintes de GLB statiques dans map10_destroyed_asset_recovery.json précèdent l’ajout des animations. Les GLB actuels correspondent au reçu destroyed_animation_binding.json. Cette succession est conservée, sans présenter les anciennes empreintes comme des fichiers actuels corrompus.

## Animation et limites

Les formes intactes utilisent inhibitor_idle, dont la dernière clé est 4.875 secondes ; les formes détruites utilisent Inhibitor_Idle, dernière clé 2.4166667461395264 secondes. Ces bornes sont celles des clés GLTF, pas directement des durées natives : la vitesse de lecture est configurée séparément. Les noms, indices, plages des accès aux temps et valeurs des horloges courantes ont été vérifiés pour les quatre modèles.

Le gestionnaire de scène prête commence par idle et applique structure_animation_clock. Le sélecteur de rôle demande death quand la santé est nulle, hors exception de cérémonie du Nexus. Les alias détruits proposent idle/death/attack sur le même clip ; la politique de boucle dépend du rôle. Le lecteur de rôles peut refuser un rôle absent et clamp_finished conserve la dernière pose des animations sans boucle. Ces chemins de code sont liés aux fiches ; les tests et expériences antérieurs cités par leurs consommateurs restent hérités, non rejoués dans V471.

Les poses complètes, interpolations, événements, effets de destruction, éventuelles autres variantes et transitions intact/détruit/réapparu doivent encore être comparés et observés en partie. Une table de rôles valide et des horloges enregistrées ne suffisent pas à accepter ces comportements.

## Audio : frontière conservée explicitement

Le reçu existant de SYS-16.3-05 n’établit pas de média ou déclencheur natif propre à ces annonces. Le consommateur précis retrouvé programme respawn_at dans le cœur de simulation ; il ne déclenche ni ne lit de son et reste marqué entry_boundary_only/provides_feature_consumer=false.

Les deux fiches AUDIO conservent ce lien limité. Le lien historique au chargeur générique Map10 reste stocké, mais le lecteur du plan le présente hors de la portée démontrée de l’audio. Les recherches bornées dans les chemins inspectés ne démontrent pas une absence globale d’implémentation. Il reste à identifier les événements et médias de destruction/réapparition, les relier au lecteur sonore effectif, puis vérifier déclenchement, arrêt et mixage en partie.

## Contrôles exécutés et intégration

- Quatre GLB, quatre configurations et leurs ressources natives hachées ; quatre comparaisons exactes de textures ; noms/indices de clips, articulations et accès aux temps vérifiés.
- Six refus du collecteur : mauvais asset, mauvais indice, en-tête GLB incorrect, GLB tronqué, pixel modifié et accès aux temps hors limites.
- Onze sélecteurs nominaux et douze sélecteurs invalides refusés.
- Comparaison du lecteur réel sur 42 214 fiches : dix textes de traçabilité changés, 42 204 identiques ; autres sorties hors SYS inchangées.
- Sept refus publics : trois questions invalides et quatre tentatives de qualification de portée incohérente.
- Les quatre chemins de publication sont associés aux quatre empreintes de référence avant écriture. Publication et audit indépendant réussis.
- Onze fiches actualisées par base, SYS inclus ; 42 606 états/notes et 23 historiques exactement conservés, 42 595 autres lignes du catalogue identiques, intégrité SQLite correcte.

Le lot ajoute 60 liens natifs, 46 liens vers les consommateurs, deux nouvelles ancres d’animation et trois sources documentaires. Dix questions propres sont ajoutées, aucune n’est résolue. Deux liens audio génériques sont requalifiés sans être effacés. Les sources, inconnues et preuves antérieures sont conservées. Le graphe compte 98 616 sources, 2 419 consommateurs, 25 361 inconnues ouvertes et 5 517 résolues.

Aucun code de gameplay, asset, case, statut ou critère d’acceptation n’est modifié. Aucun build Rust, client graphique, moteur natif, exporteur ou playback audio n’est exécuté dans ce lot. Les contrôles exécutés sont les parseurs et comparateurs CPU, les lecteurs du plan, les contrôles de refus et les audits SQLite. Les deux tests de cœur V470 restent hérités et séparés de la présente vérification visuelle documentaire.

## Livrables et reprise

Registres et bases existants actualisés ; reçu docs/reference_inhibitor_sources/inhibitor-presentation-v471.json ; preuve docs/fidelity_inhibitor_presentation_v471.json. Les scripts revision471_delivery.py prepare/publish/audit, revision471_check.py et revision471_finish.py, sauvegardes et preuves détaillées se trouvent dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision471/ et son parent.

L’inventaire particulier du chargeur Map10 comporte 490 associations à examiner, 46 partiellement qualifiées et quatre exclusions audio conservées. Ce n’est pas un pourcentage d’achèvement du jeu. Continuer avec les tours et fontaines, leurs ressources et leurs vrais consommateurs, puis les autres structures/camps. Le Goal et SYS-01.2-02 restent actifs.
