# SYS-01.2-02 — Sources et composants des modèles parents, V532

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 17 novembre 2014 à 17:46:45 ; fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct des builds de client.

## Résultat intégré

Les **122 fiches CH-*-MODELE** relient maintenant les entrées natives et les composants actuels de leurs sept sous-tâches MESH/RIG/UV/TEXTURES/MATERIAUX/PORTRAITS/PACK. **6 275 liens natifs** et **8 053 liens actuels** sont ajoutés. Ces derniers se décomposent en **7 320 liens de composants partiels** et **733 liens de contexte ou frontière**. Aucun nouveau point de code n'est créé : les descripteurs et portées existants sont réutilisés sans promotion.

Les **854 dépendances**, les **145 questions appartenant aux enfants**, les critères et les statuts de tâche restent conservés. Une question propre est ajoutée à chacun des 122 parents : **l'import reproductible de l'artefact sélectionné et l'acceptation de son rendu ordinaire natif/actuel restent non qualifiés par les preuves trouvées**. Ce constat ne signifie pas qu'une implémentation est absente. La trace des parents devient partial_with_open_questions ; leurs tâches restent partiel_a_requalifier, implementation_complete=false et acceptance_complete=false. Aucune case, note ou validation utilisateur modifiée.

## Contrat et observations

| Attendu | Observation | Limite conservée |
| --- | --- | --- |
| Sources et composants des sept dépendances | 854 liens enfants présents, 60 composants positifs distincts par parent | Leur union ne constitue pas un validateur complet du parent |
| Source native actuelle correctement reliée | 6 275 arêtes dédupliquées par parent, provenance de chaque enfant conservée | Nombre d'arêtes, pas nombre de fichiers physiques uniques |
| Modèle réellement sélectionné | Les 122 GLB actuels sont relus, Ezreal utilise ezreal_joint_identity_local.glb | Présence et octets exacts ne valident pas matériaux/poses/rendu |
| Dépendances buffer/image | Vrai helper gltf_dependency_evidence.inspect exécuté sur les 122 GLB | Fermeture dynamique complète et validation codec/GPU explicitement fausses |
| Acceptation du parent | Critères, composants partiels et questions sont exposés dans le consommateur du plan | Import reproductible actuel et rendu comparé natif/actuel encore ouverts |
| Historique conservé | Rapports Garen, animation, portraits et sélection shader identifiés | Aucun rapport ancien n'est généralisé à tous les modèles actuels |

Cinq nouvelles sources physiques de contexte, l'inspection et le reçu rejoignent le registre, soit sept enregistrements source. Tous les anciens objets source et consommateur restent identiques. Aucun fichier modèle, texture, animation ou code de jeu n'est modifié dans ce lot.

## Consommateurs réels et portée

animation.rs:420 charge la ressource sélectionnée. load_models attend un modèle chargé et sa première scène, construit le graphe depuis ses animations, filtre les rôles dont l'indice n'est pas utilisable et installe les racines du monde/brouillard. L'observateur d'instance attache ensuite graphe et transitions aux AnimationPlayer. Ce chemin réel explique le chargement partiel ; il ne constitue pas une comparaison native/actuelle de toutes les poses ou du rendu.

Les composants de géométrie, rig, UV, textures, matériaux, portraits et packs conservent leurs qualifications V526–V531. Le chemin ActorFog actuel n'est pas remplacé par l'ancien mesh.wgsl de référence. Les cinq descripteurs de portraits restent des frontières partielles ; leur présence dans la source actuelle est conservée. L'override Ezreal reste un contexte de sélection. IDs de contexte conservés exactement : OLC-592004f8-fd00-5df7-a0dc-59b5f3e28b0e, OLC-42ab625c-d0ab-5eff-a455-8fba1e8e1421, OLC-ebe12ec7-9881-5ba2-b1da-fb57aa015b01, OLC-8e11c1f5-b2bb-5a46-bba8-da557f7b7fb4, OLC-4ac38df8-b4dd-5de2-a44d-9f3705493807, OLC-1613f21b-149d-5048-9d26-e119d0536f5a, OLC-188acf67-46cf-520b-8e6a-49849dab3aca.

Les questions des enfants ne sont ni copiées dans le champ des inconnues du parent, ni fermées, ni réattribuées. Le reçu parent expose leurs propriétaires et conserve ses sept dépendances ; la résolution de chacune de ces questions est vérifiée sur sa fiche d'origine. La nouvelle question parent vise son propre critère d'import/rendu.

## Preuves anciennes et limites précises

- **model_loading_validation.json** : ancien contrôle Garen seul, douze secondes et graphe attaché ; sa portée annonce la stabilité du chargement, pas l'apparence ou les 122 modèles sélectionnés actuels.
- **animation_binding_validation.json** : ancien relevé de 122 modèles, 920 associations et 56 entrées nulles/non qualifiées. Un rôle nul ne démontre pas un fichier ANM natif manquant ; ce relevé reste distinct des 55 ambiguïtés d'attaques examinées antérieurement.
- **native_hud_portraits_progress.json** : ancien inventaire de 122 portraits et observations garen/vulkan, ahri/dx12. Le code de portraits existe. Ses limites de producteur AvatarImage, formes, teinte de mort, sampler/gamma et équivalence framebuffer restent ouvertes. Deux observations de portraits ne valident pas les modèles de tous les champions.
- **skinned_shader_selection_contract.json** : vingt cas hérités d'un sous-ensemble du sélecteur natif avec entrées fournies. L'exécutable natif est rehaché et correspond au SHA du contrat ; aucun natif n'est exécuté. Les producteurs effectifs et l'éligibilité amont, toutes variantes et constantes GPU ne sont pas acceptés par ce sous-ensemble.
- **verify_loaded_vertex_meshes.py** vise le maillage de la carte twisted_treeline ; il n'est pas utilisé comme preuve d'acceptation des champions.

Les inconnues de rig Veigar, mips/alpha, matériaux et animations restent ouvertes. L'exactitude des packs V531 est conservée sans répéter la restauration de 3,7 Go. Aucune fidélité complète des modèles, tous skins/formes, shaders, sons, sorts ou gameplay n'est déduite de ce résultat.

## Vérifications réellement exécutées

Le helper public de dépendances inspecte les 122 GLB sélectionnés : buffers/images incorporés, aucune URI externe ; les identités correspondent au lot des packs. Huit refus diagnostiques sont exécutés avec le vrai helper : URI distante, traversée de répertoire, antislash, version glTF non qualifiée, dépassement bufferView, image ambiguë, base64 invalide et GLB tronqué. Ces fichiers artificiels ne représentent aucune ressource native ou disponibilité du jeu.

Préparation, contrôle privé, publication et audit séparé retournent **0**. Trente faux constats propres sont refusés, dont changement de propriétaire, suppression de composant/dépendance/question, promotion des frontières, union déclarée complète, ancienne observation Garen/portraits généralisée, rôle nul assimilé à une animation absente, ou import/rendu inventé. Quatre refus publics vérifient les identifiants source/consommateur absents, l'acceptation de jeu inventée et une question étrangère.

L'inspection préliminaire échouée est conservée : son attente de cardinalité des contextes omettait les cinq frontières de portraits. L'inspection qualifiée utilise les listes réelles, conserve tous leurs descripteurs et vérifie les six contextes ordinaires, sept pour Ezreal. Aucun échec n'est présenté comme succès produit.

Les 122 extraits de trace changent ; **42 093 autres extraits restent exacts**. **42 092 autres objets tâche/trace** sont identiques. IDs et hiérarchie sont exacts en octets ; tous les anciens objets d'inconnues sont identiques, avec seulement 122 nouveaux objets parent ajoutés. Le fichier des inconnues enrichi n'est donc pas annoncé identique en octets.

Dans chacune des deux bases : **123 destinataires**, **42 484 autres lignes catalogue exactes**, **42 607 états manuels** et **23 historiques exacts**. Store.task, copie, résolution, résumé, sept dépendances, propriétaires des questions, intégrité SQLite et synchronisation normale idempotente sont vérifiés.

Réexamen global frais : **42 215 exigences**, **98 800 sources**, **2 710 consommateurs**, **526 fichiers actuels**, toutes ancres et identités de consommateurs exactes, zéro divergence. **26 186 questions ouvertes**, **5 517 résolues**, **17 auxiliaires intentionnels conservés**. **8 500 fiches CH** ont encore uniquement le chargeur partagé : file à examiner, pas preuve de fonctionnalité absente ni pourcentage de jeu terminé. Aucun nouveau hash physique global des 98 800 sources revendiqué.

Python, scripts, arguments, entrées et journaux sont identifiés dans les reçus. Aucun jeu, nouveau client, natif, VM Lua, GPU, build Rust, Blender ou réseau exécuté dans ce lot. Seul le lecteur public borné de dépendances a été exécuté sur les modèles actuels.

## Fichiers et preuves

- Modifiés : docs/completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json, fidelity_unknowns_4_20.json ; deux bases du plan, données manuelles préservées.
- Reçu : docs/reference_requirement_trace_sources/champion-model-parent-partial-links-v532.json ; preuve : docs/fidelity_champion_model_parent_partial_links_v532.json.
- Inspection : revision532_model_parent_inspection_qualified/OBSERVATIONS.json ; sauvegardes/candidat/contrôles/publication/audit : revision532_model_parent ; commandes revision532_model_parent_COMMAND_*.json/.log.
- Contexte de rendu/chargement/shader/portraits identifié dans le reçu, avec les SHA et portées héritées. Exécutable historique rehaché, pas lancé.
- Réexamen : revision533_trace_review/REVIEW.json ; prochaine découverte : revision533_passive_source_discovery/DISCOVERY.json.
- Couverture, plan, reprise, CURRENT et HANDOFF sont actualisés avec sauvegardes et conservation des champs antérieurs. Les IDs, critères, états et hiérarchie ne sont pas réécrits.

## Suite du Goal

La découverte des 122 tâches PASSIF-SOURCE est exécutée en lecture seule. 112 fichiers candidats déclarés exactement, 115 chunks Lua inspectés structurellement ; 61 déclarations ne trouvent pas de nom de fichier exact dans leur répertoire ciblé. Ce dernier nombre n'est pas un inventaire d'assets manquants. Les sources sont contrôlées sur les manifestes natifs sélectionnés. Quatre implémentations passives partielles actuelles ont été identifiées ; aucune n'est exécutée ou acceptée dans cette découverte, aucun lien de passif n'est publié.

Poursuivre SYS-01.2-02 depuis revision533_trace_review/REVIEW.json : 8 500 fiches CH au chargeur partagé seul restent à qualifier, sans absence d’implémentation déduite. Prochain lot : les 122 CH-*-PASSIF-SOURCE, découverts dans revision533_passive_source_discovery/DISCOVERY.json. Les champs INIBIN, déclarations exactes, chunks sérialisés et contexte catalogue 4.20.1 sont inspectés sans exécution de VM. Examiner précisément les vrais lecteurs de qualification, règles, valeurs et exceptions avant les liens ; conserver les questions propriétaires et distinguer description/métadonnées d’un callback serveur. Quatre implémentations passives partielles actuelles existent (Annie/Ezreal/Garen/Trundle) ; préserver leurs politiques locales et exceptions, sans les généraliser aux122. V532 publié/audité : ne pas republier. Les122parents MODELE gardent854dépendances,145questions enfants et122questions parent nouvelles sur import/rendu non qualifiés. Préserver le rig Veigar joint34/33influences,22questions textures,122matériaux,168UV hors unité,46arrivées V523/92questions et17auxiliaires. V531 :1347copies exactes dans revision531_pack_runtime/restored,ne pas refaire les copies ;RADS distinct des ZIP actuels. Goal actif.
