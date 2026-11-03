# SYS-01.2-02 — sources Startup Main et GemSparkle des Nexus, V357

Cette livraison intègre seulement les liens de deux familles distinctes vers leurs corps actuels : Startup Gem/GemInside et Startup GemSparkle. SYS-15.1-02 et SYS-01.2-02 reçoivent leur union ; chaque famille garde son propre reçu et sa propre preuve. Aucun autre effet n'est implicitement qualifié.

Référence PUBLIC 4.20.0.315 / Releases/4.20, EUW/en_GB, build du 2014-11-17 à 17:46:45 ; fuseau et déploiement non établis ; catalogue 4.20.1 distinct. Projet F:/OpenLeague et travail privé F:/OpenLeague-work ; E conservé.

## Qualifications distinctes et limites d'auteur

Main : primaire V354 (46 contrôles et 28 assertions de sceau séparés), puis qualification V355, FINAL SHA8c1b518c5831710faad4b7e056c9213dcb2f83b7c0f8efdfd767672dc6e82885, propres codes outil/sous-processus/collecteur 0. V355 garde 471 contrôles source, 44 de lookup, 24 de finalisation et 13 de projection distincts ; deux nominaux et sept refus. Les erreurs privées de chemins et de comparaison d'un hash préfixé 0x restent conservées. Aucune divergence native ni panne produit n'en est déduite.

Sparkle : primaire V358 (194 contrôles source et 13 de metadata, avec les deux refus privés d'ancres conservés), puis qualification fraîche du même auteur V359, sans revue tierce revendiquée. FINAL SHA9538c04b4cb04e2461f00c85cfe1636a00387be240245050e4ca8654c7431797, propres codes 0 : 194 source, 13 metadata, 48 mapping et dix de projection, deux nominaux et huit refus. Les trois définitions source-only incluent un World synthétique et des textures fixtures ; elles ne sont pas une observation GPU.

Les deux qualifications conservent registration_ready=false. Elles n'identifient aucun manque indispensable pour le seul lien borné source/corps ; la publication et ses contrôles propres sont une étape distincte. Leurs originaux restent figés, sans modifier leurs flags de native factory, provider/getter/default, FP, animation ou GPU.

Le catalogue dédupliqué de 70 ancres et six définitions source-only a été revérifié sur les fichiers réels, sans exécution de ces tests.

La préparation V357 a réellement passé son propre préflight/simulation, code0 : 549 contrôles source / 42 identités finies / 70 ancres physiques / six définitions source-only. Quatre nominaux et 20 refus de sélecteur, de contenu ou d'union incomplète ont passé. Les contrôles statiques et de sceau restent des étapes distinctes ; aucun test Rust exécuté. Le code d'AST V3 a d'abord refusé sa propre liste de globals incomplète (__file__/__name__), corrigée dans le réviseur privé V4 sans modifier les wrappers ou le produit.

La rebase reconstruit les quatre sauvegardes brutes V353 et son delta exact11/1 entre les anciennes qualifications datées98516/2403 et l'état courant98527/2404. Le lookup current/history/origin et les rehash ciblés ont été faits sur cette baseline stable. Les deux qualifications d'origine et leurs readinessfalse restent figées ; seules les nouvelles assemblées normalisées atteignent leur étape d'intégration. La simulation n'a ouvert aucune base ni exécuté aucun mutateur root.

Avant la première publication, le registrar vérifie en plus le FINAL indépendant V361 exact, ses propres codes0 et ses erreurs0. Cette revue de la livraison Idle précédente a été acquise et reliée ; aucune identité publique datée de son ancien checkpoint n'est exigée comme hash courant après annexe.

## Sources exactes

Deux ressources TROY natives de 3 212 octets : Order_Nexus.troybin SHA3bd8e42d991f4d76a74f933f3b18bbfdd403a18b85c4980b2378780bbd8c385d, source OLS-3e3b3f69-82c7-5c76-8327-f4cdce2d6e2c ; Chaos_Nexus.troybin SHAa97a6d80686689fa43b19a3ffea9455bf8e928e6c307f103ba0f095756452493, OLS-dd218de8-79fc-5156-9f8d-641ca72e19d9. Leurs MD5 actuels correspondent aux crédits d'appartenance sélectionnée existants ; les manifestes ne sont pas fraîchement rejoués et la priorité runtime n'est pas qualifiée.

Quatre JSON courants sous data/4.20/nexus_complex :
- groups.json, 23 872 octets, SHA2c737bb010a5a101279fdd055514635707a47a373e87c8a40a4ec9efb5d1cd24 ;
- chaos_groups.json, 22 812 octets, SHA35370260eab4a97e4d8e8013a92a92aeffc352c621f26eaeeef001aaf18b4c58 ;
- startup_sparkle_group.json, 10 683 octets, SHA5a9876b60fdf8cec9449cd262964b24c02d3865fe99ef76f21e53caa371caccd ;
- chaos_startup_sparkle_group.json, 10 683 octets, SHA72717dec80db574f864421f11f10fe4981776e224f12cbb1f902d7bce278d47c.

Le code partagé crates/client/src/nexus_complex_live.rs, 29 243 octets, SHA510d7c2b3f80e2858923d9694b0f89a3e18bd7c280761a29dc4188045f2c6843, est déjà source OLS-ade5ccbe-9b48-54eb-bb89-fd41b8c312c4. Les crédits V196 et deux copies historiques E de chaque famille sont conservés ; leurs anciens flags runtime/parité false restent false. Une absence de nœud JSON exact ne signifie pas une absence d'implémentation.

## Main : corps partagé 77

profiles_for commence à 47 et construit les profils à 77 pour GemInside/Gem, groupes natifs 1/5. Les 130 stockages se répartissent en 84 entrées conservées, 28 gardes/littéraux et 18 champs non lus par le corps sélectionné. Les 24 booléens natifs exportés en nombres JSON ne deviennent pas des floats natifs ni des drivers indépendants.

Le lecteur garde notamment les identités, p-type/mode/vie/débit/single/mesh, les vecteurs, rotations, intégration Particle-Velocity Once et couleurs. Life89/emitterlife1 sont des littéraux locaux après garde ; Euler, mouvement et application sur la vie restent des politiques actuelles. p-meshtex, certains flags/linger et métadonnées source/slot/conversion ne pilotent pas ce corps. Les textures sont choisies ailleurs par TextureSet.

La garde 73–75 contrôle birth.table.len()==1 et les probabilités rotation/displacement/lifetime-color constantes1. Elle ne chaîne pas birth.probabilities. Cette absence n'est pas remplacée par la règle du groupe Sparkle.

## Startup GemSparkle : corps partagé 126

startup_sparkle_profile_for commence à 88 et construit à 126. Les deux exports ont chacun 33 champs : 66 stockages, dont 40 entrées de paramètres, 22 gardes/littéraux et quatre valeurs e-life/pass gardées puis stockées sans lecture ordinaire trouvée dans le périmètre. Huit booléens natifs sont exportés numériques, sans preuve d'égalité des getters/FP natifs.

System/GroupPart3 nomme le groupe gem_sparkle ; il est distinct du On groupe2. GroupPart3Type est absent des deux TROY fournis. Ce constat et le commentaire Rust ne prouvent pas le default Complex effectif de la factory historique.

Les gardes 113–115 chaînent ici les probabilités de naissance et de couleur de vie. UV sample_birth, flags, origines et rate sont lus/contrôlés selon le code courant ; ni état aléatoire historique ni horloge, sampler ou tri natifs ne sont acceptés.

## Route et frontières conservées

main676 → Plugin → setup → startup_all_profiles_for131/132 appelle les deux lecteurs avant les textures. Order, On ou une erreur de texture/source peut empêcher la suite et Chaos ; le Profile complet n'est inséré qu'après succès de setup345. synchronize368 filtre les requêtes slot1 puis agrège les groupes de la ressource ; les groupes natifs 1/5 et3 ne sont pas des requêtes indépendantes de ces numéros.

Le vieux lecteur frontière338 et OnGemSparkle218 conservent leurs flags et liens exacts. Idle Spec35, les autres glows, Rays/spinlines, On principal et les tâches WORLD restent hors des ajouts de ce lot. Les corps77 et126 ont chacun une identité ; les deux côtés ne créent pas deux corps par famille.

Le registrar root puis l'audit de livraison ont réellement terminé avec le code0, selon ROOT_EXECUTION_RECEIPT.json. L'audit de livraison vérifie 545 contrôles source et 42 identités ciblées, 70 ancres et six définitions source-only ; quatre nominaux et 20 refus passent. Les compteurs de préparation et de livraison restent distincts.

Le delta exact ajoute 25 sources et deux corps partagés, dont quatre nœuds JSON et deux reçus publics à deux associations chacun. Main77 est OLC-ea376c4a-3386-5c16-8ce0-9cdbb4af967e et StartupSparkle126 OLC-0373c4ec-9ba4-550f-a5ae-002b7f9faa8e. SYS15 et le goal ont chacun l'union des deux familles ; tous les98527anciens enregistrements source,2404consommateurs et leurs flags/scopes/liens restent exacts. Les tâches WORLD, SYS02, R-VFX et toute autre tâche hors des deux cibles sont inchangées. Les inconnues restent exactes.

Les deux bases physiquement distinctes sont vérifiées en mode=ro/query_only avec les vrais Store.task/copy_text/resolve, sans initialisation/synchronisation. Seules deux fiches changent chacune ; 42606 états manuels et notes, 23 historiques et les catalogues hors cible restent exacts. Les instructions complètes, leur copie avec notes éventuelles et les deux chemins receipt/proof structurés, absolus et JSON-échappés sont contrôlés. Aucune case ou acceptation ajoutée.

La publication reste séquentielle : deux reçus publics, trois remplacements JSON optimistes puis deux transactions DB distinctes. Aucune transaction globale ni reprise automatique n'est revendiquée. Les quatre sauvegardes brutes et la preuve brute copiée avant audit sont conservées.

## Fichiers et suite

Intégration : les deux reçus de famille, la preuve V357, ce rapport, trois registres et deux bases du plan. Couverture, plan et reprise sont mis à jour. Reçus root et sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision357.

Graphe structurel : 98552 sources / 2406 consommateurs ; 25321 questions ouvertes / 5517 résolues. Il s'agit d'une validation structurelle globale avec rehash ciblé, sans rehash global de toutes les ressources.

Suite : revue indépendante de cette livraison après acquisition du reçu root/checkpoint ; qualification On principal169 V362 depuis le triage V360 acquis, en conservant la needle complète et les52stockages20entrées/4littérauxstockésnonlus/28gardes-politiques. Ces unités ne sont pas un total de drivers. Aucun changement de gameplay dans ce lot.

Chemins publics intégrés : docs/reference_nexus_startup_main_sources/nexus-startup-main-v357.json, docs/reference_nexus_startup_sparkle_sources/nexus-startup-sparkle-v357.json, docs/fidelity_nexus_startup_main_and_sparkle_graph_v357.json et docs/FIDELITY_NEXUS_STARTUP_MAIN_AND_SPARKLE_GRAPH_V357.md. Les ajouts, codes root réellement observés et preuves DB sont détaillés ci-dessus.

Le gate précédent est V353 réellement publié/audité : 11 sources/un corps ajoutés, graphe98 527/2 404, trois fiches et deux DB préservées. Son audit indépendant V361 est acquis et relié avant cette mutation root. Les identités datées des rapports publics ne deviennent pas une obligation d'immuabilité après annexe ; les reçus privés exacts du gate restent figés.

Aucun nouveau test Rust/build, binaire natif, GPU ou ancien générateur n'est revendiqué. Les inconnues sur provider/getter/default/FP, horloges, FoW, animation, rendu et comportement complet restent ouvertes. Les prérequis incomplets et l'acceptation humaine manquante ne sont pas levés. SYS-01.2-02 et le jeu restent ouverts ; aucune coche n'est ajoutée. L'archive SYS-03.4-07 reste inconnue, AnvilKit piste seulement.

## Relecture de livraison V363

La relecture de livraison distincte du préparateur et du publisher a réellement passé, avec ses propres codes outil/sous-processus/collecteur0 :822 contrôles,62 identités ciblées,70 ancres et six définitions source-only. Quatre nominaux,20 refus et12 cas de forme passent. Le supplément root/checkpoint a56 contrôles et15 identités séparés ; ni ce compteur ni les43 contrôles de préparation ne sont ajoutés aux822.

Le delta reconstruit exactement25 sources/deux corps, quatre JSON/deux reçus et les deux fiches en union. Les anciens enregistrements, préfixes, flags, scopes, assessments, autres fiches et inconnues restent exacts. Les deux bases distinctes sont relues strictement en mode=ro/query_only avec les vrais Store/task/copy/resolve ;42606 états manuels et notes et23 historiques restent identiques dans chacune. Les unités Main130=84/28/18 et Sparkle66=40/22/4, leurs24/huit booléens et leurs gardes de naissance différentes sont conservées.

L'auteur de cette revue avait aussi rédigé V355/V359 : sa relecture des sources ne constitue donc pas une tierce qualification. Les relations historiques des qualifications sont préservées : V355 était tierce relativement à V354, V359 du même auteur que V358. Le refus privé de préparationV1(code1/ef75a5), qui avait confondu ces relations, est conservé ; aucun produit modifié. Le diagnostic root privé1/dcd96b reste conservé dans le supplément.

Les deux copies brutes74972octets sont distinguées de la preuve publique de checkpoint79137octets. Les SHA de checkpoint sont des observations datées après l'ajout de cette annexe. Les versions pré-annexe des sept documents ont été sauvegardées en octets exacts dans revision357/pre-independent-link-versions avec reçu de préservation.

Reçu : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision363_independent_nexus_startup_families_delivery/FINAL_EXECUTION_RECEIPT.json. Aucun mutateur rejoué, test Rust/build/natif/GPU ou générateur exécuté. Aucune acceptation du comportement natif, du Nexus complet ou du jeu.
