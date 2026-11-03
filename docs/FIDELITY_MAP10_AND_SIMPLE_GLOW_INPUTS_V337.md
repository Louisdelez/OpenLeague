# SYS-01.2-02 — Map10 et Nexus SimpleGlowOn : sources et consommateurs actuels V337

Ce lot raccorde deux qualifications de portée distincte à trois fiches ordinaires du plan. Le contrat initial et son gate null sont conservés comme étape datée ; le FINAL V334 réel a ensuite permis le préflight et les commandes root ci-dessous.

Les identités viennent des qualifications immuables V335/V336 ; les validations de préparation et de livraison relisent les fichiers ciblés et leurs données. Les résultats détaillés ci-dessous distinguent ces nouveaux contrôles des preuves héritées.

Les qualifications V335 Map10 et V336 SimpleGlowOn ont leurs propres codes réels 0 et limites distinctes. Le préflight V337 rebase leurs snapshots pré-V332 par le seul ajout de 25 sources et un lecteur, reconstruit exactement à partir des quatre sauvegardes brutes, de la projection combinée immuable et du FINAL indépendant V334 exact, SHA-256 19f0000acb61ea1adfd501a5b1f642540fe4e2845a3be4192c7a723e68dd7e06. Les propres codes 0 du gate et son schéma sont contrôlés ; aucun zéro d’un reçu imbriqué ne suffit.

Préflight privé V2 : 6313 contrôles sans erreur, 43 identités et simulation pure. Ses 79 ancres et 11 définitions de tests sont dédupliquées, source-only. Aucun registrar/audit de livraison/SQLite/test Rust/natif/GPU exécuté par la préparation. Le premier refus privé V1/code1 portait sur la forme synthétique de présence d’assessment ; V2 a corrigé ce lecteur privé, en préservant script/logs/reçu1. Le diagnostic de transport SyntaxError du sealer avant processus reste séparé, sans défaut produit ni exécution native inventée.

## Map10 : chargement typé et sélection des receivers

V335 qualifie le JSON map10_receiver_tree et deux corps réellement appelés : le Default client désérialise et conserve l'arbre typé ; le corps core sélectionne des indices à partir des bornes XZ, des plages, du type de matériau et de la qualité signée. Le loader n'est pas une preuve de sélection à lui seul et la sélection ne prouve aucun rendu GPU.

Le stockage qualifié comprend 1 365 nœuds, 2 351 objets, 18 352 composantes numériques et un sous-ensemble de 73 408 octets. Le catalogue contient 13 descripteurs, dont 12 champs stockés et une métadonnée de hash non désérialisée. Les 2 730 composantes Y des nœuds sont stockées sans être lues par select. Ces nombres ne sont pas des nombres de drivers ou de consommateurs.

Identités héritées :

- F:\OpenLeague\data\4.20\map10_receiver_tree.json — 624 872 octets ; SHA-256 233413f3c861c4d4bc354fee12b10a7b88392ceaa0746c83272d4b8874bebd3d.
- D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\LEVELS\Map10\scene\room.nvr — 60 132 968 octets ; SHA-256 89e873ec32356312b53628c9773c803b0e6e864a206ac2aafc6a584c8ae27082; source existante OLS-f0e2cbdb-3bdf-5aed-8d5f-9be22646e5bd.
- F:\OpenLeague\crates\client\src\projected_terrain.rs — 16 210 octets ; SHA-256 d4c11cea0f06c270e7777498306e7237998df0d07c8891023bf0ffece9545049; source existante OLS-5ad1f5a4-ec46-58ac-8a2c-af544dd1f81b.
- F:\OpenLeague\crates\core\src\native_projected_receivers.rs — 3 537 octets ; SHA-256 5f428473bedd7cfbd93096d4264f30928f5d29899266120ba6498adb2cbd55a0; source existante OLS-20c6db19-7eb6-5f9a-a852-1aae39ddba22.
- Contrat historique F:\OpenLeague\data\4.20\map10_receiver_tree_contract.json — 907 854 octets ; SHA-256 a87fa1c17c84d4dd10063c95e976eccdfbdbaac8086c6484f46dfda5b73e983f.

Corps réels associés, avec réemploi des sources de code déjà enregistrées :

- crates/client/src/projected_terrain.rs:50, needle 'receivers:serde_json::from_str(include_str!', rôle current_Map10_receiver_tree_Default_loader ; source OLS-5ad1f5a4-ec46-58ac-8a2c-af544dd1f81b.
- crates/core/src/native_projected_receivers.rs:25, needle 'pub fn select(&self', rôle current_Map10_projected_receiver_selection_body_reader ; source OLS-20c6db19-7eb6-5f9a-a852-1aae39ddba22.

Le contrat historique map10_receiver_tree_contract.json contient 195 cas fournis pour des rectangles/qualités : aucun de ces cas n'est rejoué ici. V196 et les acquis natifs/RADS existants doivent être crédités et conservés ; le lookup global courant/history/origin a confirmé les seuls nouveaux nœuds nécessaires. Deux corps et un JSON sont associés ; leurs IDs figurent dans la preuve de livraison.

Qualification V335 : 3 820 contrôles antérieurs, 39 ancres, sept définitions de tests source-only. Ces résultats hérités sont distincts des validations actuelles ci-dessous.

## Nexus : seul groupe SimpleGlowOn

V336 qualifie un JSON commun aux côtés Order/Chaos et un corps partagé de Profile, ligne 47. Sa route ordinaire construit les paramètres SimpleGlowOn ; elle ne qualifie pas les onze autres JSON Nexus, Crown, BaseGlow ou l'ensemble de l'interpréteur Troy.

Les 29 champs connus se répartissent entre six entrées scalaires retenues, une durée Order stockée sans lecture ordinaire et 22 gardes/littéraux. Les payloads natifs contiennent 15 clés connues Order et 14 Chaos, soit 515 et 494 octets ; une clé native inconnue est conservée à part. Cette partition ne devient pas un nombre de drivers indépendants.

Identités héritées :

- F:\OpenLeague\data\4.20\simple_glow_profiles.json — 2 689 octets ; SHA-256 7f5d9d6a521dfbd37e46c5247bf17bf3a6a034ab7881dc20f79ca90f933a8a7e.
- D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\Order_Nexus_Crystal_Glow_on.troybin — 515 octets ; SHA-256 f52b34b15c6addf0d4b2843833af9c0052155daf4a14c9901c28d7c701321b9a; source existante OLS-50eb3541-1567-5d46-94dd-249a8af9fc32.
- D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\Chaos_Nexus_Crystal_Glow_on.troybin — 494 octets ; SHA-256 f6c576b308b90289e26ca5632389bd3342a770ba986ee9adcee97ab2005443a3; source existante OLS-276d0827-c119-59f9-a6ff-53bab7987375.
- F:\OpenLeague\crates\client\src\nexus_glow_simple.rs — 14 033 octets ; SHA-256 0d084ac1be21e1f0e22ba9571b51bf68aaac6707157f313f60439639b4b433a2; source existante OLS-9a6487ff-951d-52cc-8a25-667af5905d51.

Corps réel associé :

- crates/client/src/nexus_glow_simple.rs:47, needle 'Ok(Self{side,rate:read', rôle current_Nexus_SimpleGlowOn_profile_parameter_body_reader ; source OLS-9a6487ff-951d-52cc-8a25-667af5905d51.

Les deux p-life sont des booléens natifs exportés en nombre 1 dans le JSON, puis retenus par l'adaptateur scalaire actuel. Les deux p-numframes ont la même frontière booléen natif/JSON numérique 1, mais servent de gardes et de littéraux d'atlas. Cette conversion ne démontre ni le getter booléen/numérique d'origine ni une équivalence de calcul flottant natif.

Order e-life est le signed16 -1 natif : le loader le consulte, le garde et le stocke ; aucune lecture ordinaire du membre de durée n'est qualifiée. Chaos n'a pas cette clé native/JSON : Option None est locale, et le timing f32::MAX indépendant ne devient pas un défaut historique prouvé. color_v est un littéral local choisi par Side ; p-colorscale est comparé à [1,color_v], la couleur n'est pas copiée du JSON.

Le loader actuel ne vérifie ni le SHA de la source ni group.slot. Les gardes de classe, nom, clés et valeurs ne constituent donc pas une vérification d'identité SHA à l'exécution. Aucun correctif de loader n'est proposé dans ce lot.

Qualification V336 : 298 contrôles antérieurs, 40 ancres et quatre définitions de tests source-only. Le refus privé V1 et les diagnostics d'assemblage sont conservés ; le collecteur V2 et son scellement ont réellement terminé code 0 selon le reçu V336. Aucun test source-only n'est compté comme exécuté.

## Cibles et préservation

Trois sélecteurs sont vérifiés, avec portée explicite :

- CH-Ezreal-R-PRESENTATION-VFX reçoit seulement Map10, /associations/0.
- SYS-15.1-02 reçoit seulement Nexus SimpleGlowOn, /associations/1.
- SYS-01.2-02 reçoit les deux groupes, /associations.

Le contrôle de livraison refuse un groupe Glow sélectionné pour R, un groupe Map sélectionné pour SYS-15.1-02 et une sélection partielle du goal. Il ne faut pas forcer un ancien nombre de refus lorsque les sélecteurs d'un lot à trois cibles exigent d'autres cas.

Toutes les anciennes frontières, lecteurs partiels, scopes/flags, assessments, questions, états manuels, notes et historiques sont préservés. Aucun unknown n’est résolu par cette livraison. gameplay_accepted, full_scope et goal_complete restent false. Les implémentations et acceptations ouvertes des trois cibles restent ouvertes ; les détails datés de phase/lot figurent dans PREREQUISITE_SCOPE_REVIEW.json.

## Publication et contrôles exécutés

Registrar root V337 puis audit de livraison réellement exécutés, chacun code outil 0. Les scripts, sessions/chunks et preuve brute observée sont dans ROOT_EXECUTION_RECEIPT.json. Audit source : 6317 contrôles, 43 identités ciblées, 79 ancres et 11 définitions source-only. Trois sélecteurs nominaux passent, six associations incorrectes sont refusées : groupes croisés, cible non liée, counts et objectif partiel.

Le delta ajoute27 sources et trois corps distincts, deux pour Map10 et un pour SimpleGlowOn. Deux JSON courants sont identifiés : Map OLS-93d1b4b1-53d8-5457-9abd-c75d3b415832, Glow OLS-7bcfea14-448d-55c3-a1a3-c5690538d2f2. Les 98 455 anciennes sources et2 396 consommateurs, tous préfixes/edges/scopes/flags/assessments et inconnues sont exacts. Les quatre sauvegardes brutes sont vérifiées taille/SHA, le delta complet est reconstruit et comparé. Le registre des inconnues garde son SHA.

Seules trois fiches sont enrichies : R-VFX reçoit Map10, SYS-15.1-02 reçoit Glow, le goal reçoit l’union. Deux bases strictement RO puis vrais Store.task/copy/resolve :42 606 états manuels et23 historiques exacts chacune, instructions générées/stockées, copies complètes avec notes et chemins absolus JSON échappés vérifiés, integrity_check=ok. Aucune case ni acceptation modifiée. Les unités18 352 composantes Map10 et29 champs Glow ne sont pas additionnées comme drivers.

D01 référence est techniquement renseigné ; les implémentations/acceptations des trois cibles et le réseau R restent ouverts. PREREQUISITE_SCOPE_REVIEW.json conserve l’observation actuelle des phases/lots et huit fichiers rehashés ; ces liens ne lèvent aucun prérequis de comportement ou rendu. La publication est sauvegardée et séquentielle : trois remplacements JSON optimistes et deux transactions DB séparées, pas une transaction globale ni rollback/rerun automatique. Les octets bruts exacts après registrar sont conservés avant l’audit, sans reconstruction de fins de ligne. Aucun nouveau test Rust, build, instruction native, émulation, VM, générateur ou GPU.

Les qualifications V335/V336 ont une baseline datée pré-V332 à 98 430 sources et 2 395 consommateurs. Avant cette publication, la baseline après le seul append V332 de25 sources et un lecteur était98 455/2 396. Ces compteurs sont baseline_only. La réconciliation exacte par quatre sauvegardes brutes, projection combinée immuable et FINAL V334 est vérifiée ; elle préserve les anciens acquis sans exiger l’identité des fiches datées complètes avec les fiches enrichies.

Le catalogue documentaire dédupliqué hérité comporte 79 ancres sur 79 lignes physiques, 11 définitions de tests et 42 entrées de sourcepin physique. Ce catalogue hérité est dédupliqué puis recontrôlé ; il ne représente aucune exécution de tests. Ne pas additionner les composantes Map10 et les champs Glow comme des drivers. La déduplication conserve les identités physiques, les selectors et les rôles.

Trois nouveaux lecteurs et deux nœuds JSON sont associés après lookup global frais current/history/origin et vérification des corps. Aucun include ou wrapper de frontière n’est promu artificiellement en corps de feature. Les identités E, F, originaux natifs et copies gelées conserveront leurs chemins physiques propres.

Aucune disponibilité historique effective, priorité de provider/overlay, initialisation native, getter natif, équivalence FP, géométrie actuelle, GPU ou fidélité complète n'est acceptée. Les 195 cas Map restent historiques sans replay et les tests restent source-only.

## Fichiers et suite conditionnelle

Fichiers intégrés : docs/reference_map10_and_simple_glow_sources/Map10-and-SimpleGlowOn-inputs-v337.json, docs/fidelity_map10_and_simple_glow_inputs_v337.json, présent rapport, trois registres sources/trace/tâches et deux bases. Couverture, plan, reprise et notes AI sont actualisés. Sources, qualifications, scripts, sauvegardes et refus privés : revision335_map10_receiver_qualification, revision336_nexus_simple_glow_qualification, revision337_map10_and_simple_glow_preparation et revision337 sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.

Graphe après publication : 98482 sources,2399consommateurs,25321questions ouvertes et5517résolues. Validation globale structurelle, rehash ciblé seulement. F:/OpenLeague, main / 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,76 modifications suivies préexistantes conservées ; aucun stage/commit/reset.

Suite : V341 indépendant sur signal final avant nouvelle mutation du graphe. V342 prépare seulement le futur lot Nexus ComplexGlow Startup V339 et GemSparkle V343, preuves séparées et gates réels requis ; aucun autre groupe implicite. Le présent lot ne termine ni le R ni le Nexus ni SYS-01.2-02 ni le jeu. Archive candidate SYS-03.4-07 inconnue, AnvilKit piste seulement. Goal actif.

Fichiers publics intégrés :

- docs/reference_map10_and_simple_glow_sources/Map10-and-SimpleGlowOn-inputs-v337.json
- docs/fidelity_map10_and_simple_glow_inputs_v337.json
- docs/FIDELITY_MAP10_AND_SIMPLE_GLOW_INPUTS_V337.md

Les scripts structurels, le contrat initial et son gate null restent intacts dans revision337_map10_and_simple_glow_preparation. Cette livraison ajoute les associations aux trois fiches, les preuves des commandes root et une revue datée des prérequis. Le brouillon et son reçu documentaire restent conservés. Les propres codes root, preuves brutes et contrôles de livraison réellement observés sont conservés dans les reçus cités ci-dessus ; l’étape documentaire initiale reste immuable dans le dossier privé.

Preuves de qualification immuables utilisées pour cette livraison :

- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision335_map10_receiver_qualification\MAP10_RECEIVER_QUALIFICATION.json — 531 969 octets ; SHA-256 577079a666632b92285697a82be3d7d850cce31ca8d17c61cb48533f2198b664.
- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision335_map10_receiver_qualification\REGISTRY_ASSOCIATIONS.json — 105 787 octets ; SHA-256 c86220d8a58d62b6a3c02c43f07beea59b825caefd02322e1a3bb26b46f10c19.
- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision335_map10_receiver_qualification\FINAL_EXECUTION_RECEIPT.json — 7 714 octets ; SHA-256 406b74671b6239b44f3ebb737ae5dc3b3efb7999650592e927baa5b983e8c8b3.
- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision336_nexus_simple_glow_qualification\SIMPLE_GLOW_ON_QUALIFICATION.json — 240 520 octets ; SHA-256 fa603976b5581fc7b9c3e5b4536cbe6a0ce709f11e5d5ec097dc4aebf4485e20.
- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision336_nexus_simple_glow_qualification\REGISTRY_ASSOCIATIONS.json — 110 150 octets ; SHA-256 2204449be8d36f0d0d4b66560bae26838bac369e281e5cf1240f599b715ea322.
- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision336_nexus_simple_glow_qualification\FINAL_EXECUTION_RECEIPT.json — 15 220 octets ; SHA-256 10913399627a23b93added15bc0d9bfaf3fee3754102ddb1232405300ae0073a.
- F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision336_nexus_simple_glow_qualification\BOOL_EXPORT_BOUNDARY_READBACK.json — 3 810 octets ; SHA-256 2fca1605b605da7d9363ea1a1b7e869069219cd924185d4fb68b01dbfb78481d.

## Relecture indépendante V341

Codes outil, sous-processus et collecteur réellement observés à 0 : 7373 contrôles sans erreur et 80 identités ciblées. Les observations externes complémentaires restent comptées séparément dans le supplément scellé. Les quatre sauvegardes brutes et le delta de 27 sources / trois lecteurs sont exacts ; les 98 455 anciennes sources, 2 396 consommateurs et leurs liens, scopes, flags, assessments et questions sont conservés.

Trois fiches seulement sont enrichies : R-VFX reçoit les deux lecteurs Map10, SYS-15.1-02 le lecteur SimpleGlowOn, et SYS-01.2-02 leur union. Trois sélecteurs nominaux et six associations incorrectes refusées. Deux bases ouvertes strictement en lecture seule, puis vrais Store.task, copy_text et resolve : 42 606 états manuels, 23 historiques et notes/copies exacts chacune. Aucune coche ni acceptation modifiée.

Map10 conserve ses 18 352 composantes stockées, dont 2 730 composantes Y sans lecture par le sélecteur ; les 195 cas historiques ne sont pas rejoués. SimpleGlowOn garde ses 29 champs, séparés en six paramètres retenus, une durée stockée sans lecture ordinaire et 22 gardes ou valeurs locales. Les booléens natifs et les nombres de l'export courant restent distincts. Les unités de ces deux groupes ne sont jamais additionnées comme des drivers.

Le catalogue comprend 79 ancres physiques et 11 définitions de tests inspectées en source seulement. Aucun test Rust, build, instruction native ou GPU exécuté par cette relecture. Les refus privés réels et leurs corrections restent dans le reçu FINAL ; ils ne sont pas des défauts produit ni des succès réétiquetés. Les commandes root ne sont pas rejouées.

Reçu FINAL : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision341_independent_map10_simple_glow_delivery\FINAL_EXECUTION_RECEIPT.json, SHA-256 f2d77d11a5e7896bac04186cb9241545e49072a5b8c3fdf3407e19097399bb46. Rapport : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision341_independent_map10_simple_glow_delivery\INDEPENDENT_MAP10_SIMPLE_GLOW_DELIVERY_REVIEW.json. Les octets publics exacts antérieurs à cette annexe sont dans F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision337\pre-independent-link-versions. Ce rattachement ne modifie aucun des quatre registres ni aucune base.

Suite : préparer le lot V342 ComplexGlow Startup (V339) et On GemSparkle (V343), avec leurs preuves et gates réels, un lookup courant et le seul rebase V337 de 27 sources / trois lecteurs. Les autres groupes ne sont pas couverts implicitement. SYS-01.2-02, le rendu complet et le jeu restent ouverts ; le candidat d'archive SYS-03.4-07 n'est toujours pas identifié.
