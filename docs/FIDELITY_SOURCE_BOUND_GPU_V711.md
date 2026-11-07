# SYS-01.2-02 — Sources actuelles et initialisation GPU : V711

UTC : 2026-10-28T14:25:21.831280+00:00. Projet : F:/OpenLeague. Référence native : LoL PUBLIC 4.20.0.315, EUW/en_GB ; catalogue 4.20.1 distinct. Cette livraison relie les preuves V708 et V710 aux consommateurs existants de SYS-17.3-01 et SYS-01.2-02. Le module sélectionné et un chemin GPU privé sont vérifiés ; le client ordinaire et la fidélité de la scène de chargement restent à qualifier.

## Résultats attendus et observés

| Vérification | Attendu | Observé |
|---|---|---|
| Sources vendor → bibliothèque privée | Compiler le crate actuel sans écraser le cache partagé | V708 : bibliothèque privée distincte ; inventaire des 88 fichiers exact avant/après |
| Dépendances | Identifier les artefacts réellement utilisés | 42 dépendances directes cache pinées et inchangées ; elles ne sont pas recompilées |
| Réglages du backend | Distinguer masques et Option | V708 : Some(63), Some(2), Some(10), Some(0), Some(0) ; vide/invalide ne valent pas None |
| Backend désactivé | Cycle de plugin sans renderer | V708 : build/ready/finish/cleanup réussis, ready=true sans RenderApp/Device ; portée exacte avant/après conservée |
| Initialisation Vulkan réelle | RenderCreation::Automatic crée des ressources utilisables | V710 corrigé : Device/Queue/Adapter/Info dans mainWorld ; Instance dans renderWorld, absente de mainWorld |
| Opérations GPU simples | Deux passes clear puis relecture exacte | Rouge et vert, 2×2 Rgba8Unorm, quatre pixels identiques aux valeurs attendues pour chaque passe |
| Masque backend vide | Refus explicite de trouver un adaptateur | Processus enfant code101, message « Unable to find a GPU! », avant les observations built/finished |
| Libération appelée | unmap/destroy/drop retournent | Observé ; libération physique, absence de fuite et trace driver non démontrées |

Adaptateur fraîchement observé : NVIDIA GeForce RTX 3060, backend Vulkan, vendor 4318, device 9476, driver NVIDIA 610.88. Aucun adaptateur d'un ancien reçu n'est présenté comme une observation nouvelle.

## Contrat source et limites d'exécution

V708 compile directement vendor/bevy_render/src/lib.rs avec les features morph, multi_threaded, reflect_auto_register et webgl. Flags diagnostiques : opt-level=0, debuginfo=0, debug-assertions=on et metadata privée. L'inventaire88 inclut les fichiers du crate ; il ne signifie pas que chaque fichier conditionnel est compilé ou exécuté. Les 42 dépendances directes identifiées restent du cache, sans reconstruction ni authentification source du graphe transitif complet.

Les pilotes lient explicitement la nouvelle bibliothèque privée et composent les plugins publics directement, sans cached bevy_internal/DefaultPlugins. Cette composition ne qualifie pas la fonction main ou le profil du client normal. Aucune mise à jour App, schedule de rendu Bevy, caméra, scène, asset du jeu, shader de dessin, draw call ou fenêtre n'est exécuté. Les deux passes clear utilisent directement le Device/Queue obtenus par le RenderPlugin. Ce sont des opérations GPU synthétiques, pas une frame du jeu ou une comparaison visuelle avec LoL.

Le contrat de RenderResources::unpack_into place Instance dans renderWorld seulement. Le premier pilote V710 attendait à tort sa présence dans mainWorld : Vulkan avait franchi build, puis l'assertion après finish échoue101. Le résultat globalfalse/code2, le binaire et le journal sont conservés. Un pilote distinct corrige seulement l'assertion du banc et réussit. Aucun asset ou défaut du jeu n'est déduit de ce premier échec.

La matrice V708 datée reste 3 rôles statiques/5 profils contrôlés/1 appel non exercé. V711 ajoute le soutien du profil Vulkan V710 pour l'appel initialize_renderer : 3 statiques/6 profils contrôlés, toujours sans tracé indépendant des instructions et sans promotion des rôles globaux. Les deux types restent des références structurelles.

## Binaires et ressources identifiés

| Artefact | Octets | SHA-256 |
|---|---:|---|
| bibliothèque vendor privée V708 | 59186412 | 92e2ab23ffd43859256ba9727d7338804508c02a3a0695cbaf6a51d5f4962acf |
| pilote V708 | 45702144 | 26db6c5a327ac7cd13a7c683c652c9f88d5a41a81d6cf3a4f58581897b8097f6 |
| premier pilote V710, échec conservé | 45814784 | 31f8c9e51b3de78f89c2da3b7840a2f37a25e0e474d8d5ae216fce0e747910b1 |
| pilote V710 corrigé | 45814272 | 3e06d39d877fea43140c365f66adb2ce500d41a873ff9923daaa7a4405c77174 |

Les chemins absolus, commandes rustc, features, environnements enfant, sources et logs sont dans les observations privées V708/V710 sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Les fichiers red.rgba et green.rgba contiennent chacun les16octets relus. Le padding de copie n'est pas qualifié. Aucun environnement utilisateur persistant n'est modifié. Ce lecteur d'associations ne rejoue pas les tests GPU ou natifs.

## Registre, plan et conservation

Deux fiches reçoivent la preuve et les instructions copiables complètes. Les17 descripteurs de frontières existants et l'ancien rôle main matériau sont revérifiés puis conservés. Aucun nouveau consommateur, rôle fonctionnel, code ou asset du jeu n'est ajouté. 276 sources nouvelles sont enregistrées ; un lien natif hérité est conservé comme comparaison de portée, sans équivalence entre catégorie native et bit moderne Vulkan.

Graphe : 100282 sources, 5622 consommateurs, 42215 exigences actives, 26189 inconnues ouvertes et5517 résolues antérieures. Ce contrôle du graphe n'est pas un rehachage du catalogue complet ; les pins de cette livraison sont vérifiés séparément. OLU-ac85c18c-d131-517e-83a7-d0987d643c48 reste ouverte, avec ancien texte/condition en historique et recherche ajoutée.

Les deux bases publiées conservent chacune42605 autres lignes,42607 états manuels et23 historiques. Store.task/copy/summary/trace sont vérifiés réellement ; le bloc copiable est décodé comme JSON puis comparé exactement au contexte enregistré. Aucun prérequis, case, note ou acceptation n'est promu. REG/TR/SRC/UNK sont actualisés ; IDS et ordre des phases/lots restent byte-identiques.

## Vérifications réellement exécutées

Les revues V708/V710 refusent13 falsifications de portée/résultat, dont remplacement de bibliothèque, prétention d'un client ou schedule exécuté, pixels altérés, mauvais World d'Instance et libération physique inventée. Le candidat refuse5 mutations ; l'inversion documentaire exacte, l'inversion SQLite logique et l'idempotence du sync sont vérifiées. Il s'agit de contrôles de preuve et de livraison, sans acceptation du gameplay.

| Étape | Code attendu | Observé | SHA-256 journal |
|---|---:|---:|---|
| V708_SOURCE_BOUND_COMPONENT | 0 | 0 | 442edaaa7b8f6a94a4045fe253cc85629b183b65f5d1e521546f2967d7b8c6c1 |
| V708_SOURCE_BOUND_REVIEW | 0 | 0 | 5d632c540990503f3b3c6172b9c2da6af29b3747366b8ba2649ce14653370052 |
| V708_CONSUMER_SCOPE_MATRIX | 0 | 0 | 1618dd79b10031cfc1fe2eca6d0d966aab4528ff1e419f0892abe51fd887ac8e |
| V708_SOURCE_BINDING_CHECKPOINT | 0 | 0 | d790baa3861a72a56747a24840311264067ab58a8db44a41db45230d4025ddf3 |
| V710_VULKAN_PLUGIN | 0 | 2 | e914a9e14f5187c4a12f7858fecbdf20dfe70359540d30b91622c74e767ca344 |
| V710_VULKAN_PLUGIN_CHECKED | 0 | 0 | 4c14f92c95252bbb8bb10b35b0cbf1dd884a2af016a2f6982e49cf901d14a6bb |
| V710_VULKAN_REVIEW | 0 | 0 | ff37aa36f1aa8f560e0b92dd47d8422171c740220ae9a75df4b82eac3ba20c47 |
| V711_DELIVERY_SEQUENCE | 0 | 1 | fc3a574a427dd04aee3d38a75de9125d817e2619921d7e48e0f7e1eab2024fe2 |
| V711_FINISH_SEQUENCE_CHECKED | 0 | 1 | d9fc6fed20354714a88f19e40e0705446cae7060ed1d4c72c765414fd28a955f |
| V711_ASSOCIATIONS | 0 | 0 | d2eeb6c61279e02958f419fa01d65bc6855b929ed0dd01082d60f2cb4ccc4178 |
| V711_STORAGE | 0 | 0 | 680bc67a06aa5f463265a0294bf14c529867ccb1a882a1b9d01807c8cb97cfa3 |
| V711_PREPARE | 0 | 0 | e708857a09c84d4748139424fc12966cff71a5b641d5fe40f6167ed92e77698e |
| V711_CHECK | 0 | 0 | ced9e91b178f5ff29e4f80cbd5e4ab23460dc07693caabb805233087070d50e3 |
| V711_PUBLISH | 0 | 0 | f7aa1e4f692936196ed1876cd1321ef0ae604236fe7f269aa8981f764e934ed8 |
| V711_DELIVERY_AUDIT | 0 | 0 | 65f85d6641d2a022668eaf13b8e8955486922979bcaf02b097375f03a9cfb967 |

L'orchestration initiale V711_DELIVERY_SEQUENCE échoue1 après une publication réussie0 : elle tente de recréer PROGRESS.json déjà présent alors que le helper protège les preuves avec open(x). Le premier PROGRESS, le script et le journal d'échec restent conservés. Une première reprise échoue aussi avant toute mutation : sa garde cherchait la clé passed alors que PUBLISHED.json porte published=true et verification_pending=true. Les deux échecs des scripts restent conservés. L'audit et la fin documentaire sont ensuite appelés directement avec leurs reçus distincts ; la publication n'est pas répétée. Aucun défaut de donnée ou de jeu n'est déduit de cette erreur du script d'enchaînement.

V710 initial : le runner global retourne2 ; chaque processus Vulkan et vide a retourné101. Après correction du banc : runner0, Vulkan0, refus vide101 attendu. Les essais V706 et leur premier prérequis ImagePlugin manquant restent conservés. Les 5 fichiers historiques fermés/audités sont compressés sans perte, octets/taille/SHA/sidecars conservés ; aucune suppression ou base active touchée. Le scratch de publication reste sur F avec garde4GiB avant préparation.

## Fichiers modifiés et livrables

- docs/completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json et fidelity_unknowns_4_20.json : delta borné et vérifié.
- runtime/project-plan/plan.sqlite3 et base de l'application du bureau : deux lignes de contenu actualisées, états manuels conservés.
- docs/fidelity_source_bound_gpu_v711.json et docs/reference_requirement_trace_sources/source-bound-gpu-v711.json : preuve et reçu.
- Le présent rapport ; coverage.json, completion_plan.json, resume_checkpoint.json ; docs/ai/CURRENT.md, HANDOFF.md et décision datée : reprise actualisée avec sauvegardes, anciens champs conservés.
- Lecteurs, sources Rust, binaires et journaux privés V710/V711 dans F:/OpenLeague-work ; aucun artefact partagé remplacé.

## Inconnues encore ouvertes et suite

Manquent encore les preuves du client normal, son build/configuration, le graphe complet des dépendances et la scène de chargement réelle (portrait, UV, sampler, couleur, shader et image rendue). Le bootstrap natif, ses catégories0/1/2, la création/inscription978820, les signatures, l'ownership et le lifetime restent distincts et ouverts. Le retour natif PE2/fabrique nulle ne prouve pas une texture créée ou un manager prêt. Les résidus DXT83 non acceptés, alpha opaque, identité DLL2014, différence Kalista288octets et12noms de ressources non résolus restent conservés. Rien dans ce lot ne permet d'annoncer un écran, un champion ou le jeu complet terminé.

Continuer SYS-01.2-02 sur F:/OpenLeague. V711 a intégré/audité V708 et V710 : liaison du crate vendor bevy_render courant vers bibliothèque privée, six contrôles settings/None, création Automatic Vulkan réelle et deux clear/readbacks exacts. 17 frontières et ancien main matériau conservés ; deux fiches et deux bases auditées sans changement manuel. La bibliothèque V708 utilise 42 dépendances directes cache, pas un rebuild complet ou le profil ordinaire. Prochaine preuve : inspecter et qualifier le chemin du client ordinaire et sa scène de chargement réelle, avec binaire/build/configuration/backend observés ; distinguer schedule Bevy, scène/portrait, shader/sampler/UV/couleur, image rendue et lifetime. Les trois rôles main/groupe/macro restent statiques. Garder None distinct de Some(vide), les échecs de banc V706/V710 et leurs correctifs séparés. Qualifier séparément bootstrap natif9B3D00/9C1430/callers/ordre,création normale/inscription978820/signature/ownership,nom portrait/transport et cleanup sans mapping inventé des catégories natives0/1/2. Conserver acquis et limites ARGB8/DXT,résidus83 non acceptés,alpha opaque,DLL2014,Kalista288octets et12noms ouverts. Réserve4GiB sur F avant publication ; compression seulement de preuves fermées/auditées et sans perte. Lire chaque gros JSON une fois. Goal actif ; aucun écran ou jeu complet accepté.
