# SYS-01.2-02 — contrat local de géométrie du brouillard de spawn, V368

Cette livraison intègre uniquement le lien des trois canaux du JSON de géométrie reconstruit vers le corps courant local_configuration113. Deux associations sont intégrées, SYS-15.1-02 et SYS-01.2-02. Les nouvelles associations native_inputs sont vides ; les anciens liens natifs du registre restent intacts.

Référence générale PUBLIC4.20.0.315 / Releases/4.20, EUW/en_GB, build du2014-11-17 à17:46:45 ; fuseau/déploiement inconnus, catalogue4.20.1 distinct. Elle n'établit pas une provenance native pour cette géométrie locale. Projet F:/OpenLeague, privé F:/OpenLeague-work, E conservé.

## Qualification locale acquise

V364 a réexaminé30 entrées :170 contrôles de collecte, cinq d'interprétation et118 de sceau séparés. Les anciens lots existants, les asymétries WORLD Idle, le corps Complex partagé et les frontières HUD/Relic sont crédités. Un seul prochain groupe local était proposé.

V367 est une qualification fraîche du même auteur, sans tierce revue revendiquée. FINAL10405octets, SHA8ba597a5d7066868a56a047b83304a4b3b06ff6ca984bc41b82136097688aec9, propres codes outil/sous-processus/collecteur0.100 contrôles/17 identités,19 ancres et deux définitions source-only. Les19 contrôles du modèle Python, deux nominaux et12 refus restent distingués des tests Rust, qui n'ont pas été exécutés.

registration_ready=false sépare qualification et publication. Aucun manque indispensable n'est recensé pour ce seul lien local ; la géométrie originale, le pivot, le rayon et les UV historiques restent inconnus. L'original V367 et ses flags restent figés. Sa baseline98552/2406 date d'avant la publication On V365.

La préparation V368 a réellement passé ses contrôles privés, sans base ni exécution des wrappers ROOT :77 contrôles source/20 identités,19 ancres production/deux définitions source-only. Deux sélecteurs nominaux, sept refus de sélecteur, dix de contenu et cinq gardes typées sont séparés des19 contrôles du modèle Python inclus dans la revue source. Capture/rebase52, AST/symtable51 et sceau62 restent des étapes distinctes ; aucune somme ne devient un taux de complétude.

Le vrai FINAL scellé est lié au reçu ROOT. Son gate a passé un nominal et dix refus contrôlés. Les deux erreurs privées de wrapper AST, l'une de normalisation de chemin et l'autre de comparaison de citations littérales dans le wrapper AST, sont conservées avec leurs versions corrigées. Elles ne sont pas des défauts du jeu.

La rebase reconstitue exactement le delta On V36510/1 depuis ses sauvegardes brutes :98552/2406 devient98562/2407. Le lookup frais current/history/origin distingue l'unique source de code F existante, le nouveau JSON F et la copie E de même contenu. L'assemblée V368 écarte la copie géométrie E et le datasetv2 comme nouveaux nœuds payload, tout en conservant leurs crédits et la projection V367 originale.

V366 FINAL indépendant de la livraison On et sa liaison documentaire ont été acquis avant publication. Les quatre identités de registres sont contrôlées juste avant le premier écrit public. L'original V367 conserve registration_ready=false ; la nouvelle assemblée de publication ne change ni sa qualification ni les inconnues natives.

## Provenance exacte et crédits

Le fichier courant data/4.20/spawn_mist/fogcircle-reconstructed-native-v3.json a171838octets et SHA37aaacf5bce1a7e5c333de66e6d7a0ebe185080249a71cdceca5c7a0cfd15198. Son nom et celui de vertices_native_xyz ne changent pas son origine : asset_origin est une reconstruction locale et native_profile_baked reste false.

La copie E:/mapslol3v3/map10_spawn_mist_reconstructed_v3/fogcircle-reconstructed-native.json a les mêmes octets. Elle demeure une identité physique distincte de F. Le reçu de provenance geometry-provenance.json2522octets/SHA1b2de0ed63798b632e6d47c66a7378a0c21323bc193c91d5bc7e86b4024668f1 et le manifest7154octets/SHAbfddbee1f98c3cfc8f043af6364f2dabf0a9f84c264484bda3a2056169ae8b60 décrivent cette dérivation locale. Ils ne remplacent pas un fichier original manquant.

V196 conserve le crédit de contenu/include exact sous /associations/0/artifacts/0/resources/147 et /associations/0/artifacts/1/resources/412. Une absence de nœud JSON direct ou de consommateur précis n'est pas une absence d'implémentation.

Le code courant crates/client/src/spawn_mist_live.rs,26163octets, SHA0064b43c28aba70b7c28be187dc6cab47f8f088c7937b05c3bdc8de9a801641b, est la source F existanteOLS-f278f52a-2b53-5768-84ae-552745fe6555. Le corps précis113 est distinct des Profile91 et Host13 déjà qualifiés en V352 dans leurs autres modules.

## Trois canaux, un corps de lecture et de rétention

Le bloc108–114 lit /vertices_native_xyz (769 lignes de trois coordonnées), /uv (769 paires) et /triangles (1440 triplets d'indices). Le helper vec3 à109 est du câblage, pas un second corps à enregistrer. Les nombres passent par as_f64 puis f32 ; les indices par as_u64 puis u32::try_from. Les formes, longueurs, valeurs finies et bornes sont contrôlées selon le code courant et ReconstructedGeometry::bake85.

À113, bake(identity) est utilisé pour valider, puis son résultat transformé est jeté. Configuration114 retient les tableaux convertis de ReconstructedGeometry. La division XYZ/20 dans bake n'est donc pas une transformation déjà appliquée aux tableaux conservés par ce lecteur. Les installations suivantes peuvent appeler bake à nouveau ; elles restent hors de ce lien.

Le lecteur ne vérifie ni schema/version/SHA ni asset_origin/radius_choice/pivot_choice/native_profile_baked/uv_reconstruction_choice. Ces métadonnées sont comparées à l'extérieur pour la provenance, mais ne deviennent pas des gardes runtime inventés. Les acceptations/refus du modèle Python reflètent ce contrat déclaré ; ils ne sont pas une exécution de Rust ou du renderer.

Route statique : main677 → Plugin78/build79 → Startup initialize119 → local_configuration122 → lecture108–113 → Configuration114. Les refus State/Configuration/Resources déjà installés ou des profils, placements et sources antérieurs peuvent empêcher cette lecture. Le refus de GPU absent à123 vient après si ces étapes passent. Aucune activation ordinaire ni observation du rendu n'est démontrée.

## Conservation du registre et limites

Les anciens Profile91/Host13, tous les lecteurs Nexus et les autres sources, préfixes, flags, scopes, assessments, inconnues et états manuels sont conservés. Ce lot ne qualifie aucun float/getter/provider/factory natif, shaderDP4, GPU, fidélité visuelle ou géométrie originale. Les anciennes preuves spatiales/native576 ou historiques GPU sont du contexte, pas des contrôles réexécutés.

Le registrar ROOT puis l'audit de livraison ont réellement terminé avec le code0. L'audit vérifie 77 contrôles source / 20 identités physiques ciblées,19 ancres production/deux définitions source-only ; deux sélecteurs nominaux, sept refus de sélecteur et dix de contenu. Les cinq gardes de résultat structurel sont conservées séparément. Le modèle Python reste une aide de lecture et de comparaison, pas un test Rust/natif.

Le delta exact ajoute15 sources et un corps113 (OLC-1332ce84-ccc3-585d-a1c6-c5a6e4abc815), dont un seul nœud JSON de géométrie F et un reçu à deux associations. SYS-15.1-02 et SYS-01.2-02 reçoivent chacun les trois canaux. Les98562 anciennes sources et2407 consommateurs sont intacts ; tous anciens liens native_inputs sont strictement égaux et les nouveaux restent vides. Les anciens Profile91/Host13, les autres tâches, flags, scopes, assessments, notes et inconnues sont conservés.

Les deux bases physiquement distinctes vérifient réellement Store.task/copy_text/resolve via des connexions SQLite mode=ro/query_only et un Store sans initialisation. Deux fiches changent par base ;42606 états manuels et notes,23 historiques et catalogues hors cible restent exacts. Les instructions et leur copie complète, avec notes éventuelles et chemins absolus receipt/proof JSON-échappés, sont comparées. Aucune case ou acceptation n'est ajoutée.

La publication reste séquentielle : reçu public, trois remplacements JSON avec contrôles de concurrence, puis deux transactions DB distinctes BEGIN IMMEDIATE. Elle n'est pas globalement atomique. Toute erreur réelle arrête le lot sans relance ni rollback automatique. La preuve brute du registrar a été copiée en octets exacts avant l'audit ; sauvegardes, observations et versions antérieures sont conservées.

## Fichiers et suite

Intégration : reçu local de géométrie, preuve V368, ce rapport, trois registres et deux bases du plan. Les documents de couverture, plan et reprise sont actualisés. Les scripts, observations de commandes et sauvegardes restent dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision368.

Graphe structurel : 98577 sources / 2408 consommateurs ;25321 inconnues ouvertes / 5517 résolues. Le contrôle global est structurel, source_hashes_verified vaut l'entier0 ; les20 identités ciblées sont rehashées séparément.

Suite : revue indépendante V370 de cette livraison après acquisition du vrai ROOT/checkpoint. Le triage V369 a parcouru42214 exigences actives, sans promouvoir les flags absents en implémentation manquante. Il a identifié28 fiches modes sans source/contrat lié, dont cinq Tutorial. La qualification privée V371 recherche d'abord le contrat d'admission Tutorial et les sources existantes ; aucun nouveau lot natif n'est prêt sur ce seul constat.

Chemins publics intégrés : docs/reference_spawn_mist_geometry_sources/spawn-mist-reconstructed-geometry-v368.json, docs/fidelity_spawn_mist_reconstructed_geometry_graph_v368.json et docs/FIDELITY_SPAWN_MIST_RECONSTRUCTED_GEOMETRY_GRAPH_V368.md. Codes root, changements et vérifications DB réellement observés sont détaillés ci-dessus.

V365 On est réellement publié/audité10/1, graphe98562/2407. Son FINAL indépendant V366 et sa liaison documentaire ont été acquis avant cette mutation. Les identités publiques des checkpoints restent des observations datées après ajout d'annexe ; seuls les reçus privés exacts du gate sont figés.

Aucun test Rust/build, natif, GPU ou générateur exécuté dans ce lot. Les prérequis incomplets et l'acceptation humaine absente restent tels quels. SYS-01.2-02 et le jeu restent ouverts, sans coche automatique. Archive SYS-03.4-07 inconnue, AnvilKit piste seulement.

## Relecture indépendante V370

Le relecteur distinct des auteursV364/V367/V368 confirme la livraison avec ses propres codes outil/sous-processus/collecteur0 :232 contrôles,40 identités ciblées,19 ancres et deux définitions Rust non exécutées. Les19 contrôles du modèle Python sont inclus dans la portée source du contrôle principal ; ce ne sont pas19 tests Rust. Deux nominaux/sept refus de sélecteur/dix contenus/cinq gardes typées et huit formes propres sont conservés avec leur recouvrement, sans somme de cas uniques inventée. Le supplément ROOT68/17, la préparation42 et la structure21 restent des étapes séparées.

Le delta intégral depuis les quatre sauvegardes brutes est exactement15sources/un corps113, un JSON F/un reçu/deux fiches. Tous anciens native_inputs sont strictement égaux et les nouveaux restent vides. Profile91/Host13, les anciens records/préfixes/flags/scopes/assessments, les autres fiches et inconnues sont exacts. La copie E et le datasetv2 restent des identités/crédits distincts sans nouveau nœud payload de copie.

Les deux bases physiquement distinctes sont relues en mode=ro/query_only avec les vrais Store.task/copy/resolve :42606 états manuels et notes/23 historiques exacts chacune. Les deux copies brutes9311octets restent distinctes de la preuve de checkpoint12658octets. Les sept versions documentaires avant annexe sont conservées en octets exacts dans revision368/pre-independent-link-versions avec reçu.

Le résultat bake(identity) est bien écarté à113 ;Configuration114 conserve les tableaux convertis avant /20. Les métadonnées, choix de rayon/pivot, winding et bornes UV ne sont pas de nouvelles gardes runtime. La géométrie originale, le provider, getter, FP, GPU et rendu complet restent inconnus.

Aucun refus privé propre à V370 ; les deux diagnostics AST hérités V368 sont conservés, sans rejeu ni transformation en succès. La description de la seconde erreur dans le rapport ROOT est précisée : le wrapper comparait une citation littérale simple à une expression écrite avec des guillemets doubles. Le garde source native_inputs était inchangé ; ce n'était pas un changement d'identité de support.

Reçu : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision370_independent_spawn_mist_geometry_delivery/FINAL_EXECUTION_RECEIPT.json. Aucun mutateur ROOT, test Rust/build, natif, GPU ou générateur rejoué. Les SHA publics de checkpoint demeurent des observations datées après cette annexe.
