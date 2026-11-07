# SYS-01.2-02 — UV et chaîne de shaders des acteurs, V528

25 octobre 2026 — Projet F:\OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue officiel 4.20.1 distinct. Build daté littéralement du 2014-11-17 à 17:46:45 ; fuseau et date de déploiement non établis.

## Résultat intégré

Les **122 fiches CH-*-MODELE-UV** relient maintenant les coordonnées SKN aux UV du GLB effectivement choisi, puis aux convertisseurs TEXCOORD, sélecteurs de jeu UV, transforms, samplers et shaders courants. **122 fiches MODELE-RIG** reçoivent aussi une correction nécessaire de leur entrée de vertex shader : la chaîne normale des acteurs utilise FogMaterial et le shader environment_fow_vertex.

**2 075 liens** sont ajoutés : 1 953 pour les UV et 122 pour le vrai point de skinning des acteurs. Quatorze consommateurs sont ajoutés : treize points UV et un point de skinning. Les quatre consommateurs existants de requête/rattachement de modèle et d’override Ezreal sont conservés dans leur périmètre applicable. Aucun UV, modèle, texture, shader ou paramètre du jeu n’est modifié.

## Correction de qualification du lot précédent

Dans V527, le point de skinning du vertex standard de Bevy mesh.wgsl avait été lié trop généralement comme entrée de vertex de l’acteur. L’inspection de actor_fow.rs et map_fog.rs montre le remplacement de StandardMaterial par **ExtendedMaterial<StandardMaterial, FogExtension>**. FogExtension choisit **assets/shaders/environment_fow_vertex.wgsl**, dont l’entrée propre appelle skinning::skin_model à la ligne 90 et transmet les UV à la ligne 118.

Le consommateur **OLC-188acf67-46cf-520b-8e6a-49849dab3aca** garde son identité, son fichier, sa ligne et sa source. Il est requalifié en **référence du vertex PBR standard** avec provides_feature_consumer=false pour ce périmètre normal ActorFog. Son ancien enregistrement complet est conservé dans qualification_history avec la raison, la date et le reçu correctif ; la preuve V527 n’est pas réécrite.

Le vrai consommateur acteur **OLC-0fb3f0ee-f922-522d-9545-4682f2c1836d** est ajouté aux 122 fiches RIG après leur premier lien existant. L’ordre relatif de tous les anciens liens reste conservé. Cette insertion rend la correction visible dans les trois premiers consommateurs du texte copiable. Le shader courant continue d’appeler le skin_model de la bibliothèque verrouillée ; la correction porte sur son **entrée appelante**, sans réparer un rig ou modifier le GPU.

Les questions de Veigar, notamment OLU-29dbb803-7d62-54e9-a39e-acfedede9e66 chez CH-Veigar-MODELE-RIG, restent intactes. Le joint natif34 toe droit et les33 influences associées ne sont pas restaurés ou acceptés par ce travail de traçabilité.

## UV mesurés, coordonnées et samplers

La découverte déjà exécutée est conservée et ses entrées sont recontrôlées par SHA : **597 877 sommets, 151 sous-maillages, 122 modèles**. Les paires UV0 sont des F32/VEC2 non normalisés et correspondent en bits aux UV des maillages natifs sélectionnés. L’asset particulier **champions/ezreal_joint_identity_local.glb** reste pris en compte.

**168 sommets sur15 champions** ont des coordonnées hors carré unité. Ils sont déjà présents dans les sources natives et restent inchangés. Un dépassement ne devient pas un défaut à corriger sur la seule base d’un test [0,1]. La liste, les matériaux et les bornes sont conservés dans la découverte et le reçu. Aucun clamp n’est appliqué.

Les 151 matériaux inspectés utilisent KHR_materials_unlit et le jeu TEXCOORD_0 pour leurs textures de couleur. Aucun sampler explicite ni KHR_texture_transform n’est déclaré dans ce corpus. La source verrouillée gltf-json1.4.1 fournit le défaut WrappingMode::Repeat, le lecteur gltf choisit son sampler par défaut et Bevy transfère ce mode vers address_mode_u/v. Ce défaut **appartient au chargeur glTF courant** : il ne qualifie pas la politique de sampler native du client LoL.

Le chargement lit le canal et la transform de texture ; le remplacement ActorFog clone le StandardMaterial, y compris ses propriétés UV, puis synchronise sa base lors des changements. Le vertex courant transmet out.uv=vertex.uv. Le fragment ActorFog appelle pbr_input_from_standard_material ; le fragment PBR importé applique la transform UV et échantillonne la texture avec son sampler. Le lecteur de canaux courant distingue UV0/UV1 et avertit avec repli UV0 pour les autres sélecteurs. L’inspection du corpus ne prétend pas exécuter ce repli.

Les UV du modèle et les coordonnées monde utilisées pour le brouillard, le terrain ou les cartes de visibilité sont distingués. Les valeurs du brouillard ne remplacent pas les UV de couleur du champion. Les variantes de pipeline, prépasses, bindless, filtres, mipmaps, interpolation et rendu effectif restent des périmètres non acceptés.

## Provenance et contrôles réellement exécutés

Les lecteurs Bevy0.19, gltf1.4.1 et gltf-json1.4.1 inspectés correspondent aux membres des archives locales .crate, elles-mêmes au SHA-256 de Cargo.lock. Les chemins résolus Windows proviennent de la résolution précédente verrouillée/hors ligne, dont les métadonnées et entrées sont recontrôlées. Il ne s’agit pas d’une nouvelle compilation ou d’une identité d’exécutable en cours.

Quatre identités de fichiers existants sont ajoutées : le vertex ActorFog de l’espace F, le lecteur de sampler Bevy, pbr_fragment.wgsl et le défaut de wrapping gltf-json. Les autres ancres réutilisent leurs identités enregistrées. Tous ces fichiers restent inchangés.

L’analyseur de preuves refuse sur copies mémoire : accessor UV débordant, buffer tronqué, normalisation hors de son périmètre F32 qualifié et index de texture hors table. Le refus de normalisation décrit cet analyseur borné ; il ne signifie pas que Bevy ou glTF refuse globalement tous les formats normalisés.

**53 cas falsifiés sont refusés** : mauvais propriétaire, lecteur retiré, fausse exécution client/GPU, UV hors unité déclarés corrompus, clamp inventé, sampler courant promu en politique native, fausse acceptation complète. Des cas ciblés refusent l’effacement des UV hors unité, l’invention d’un sampler déclaré, le remplacement de la vraie entrée acteur par la référence standard, la promotion répétée de l’ancien vertex et l’effacement de son historique. **Quatre refus du lecteur public** couvrent consommateur absent, source absente, fausse acceptation et inconnue appartenant à une autre exigence.

Les 42 215 fragments de traçabilité sont comparés : **244 changent, 41 971 restent exacts**. Les **41 970 autres objets tâche/trace** sont conservés. Identités, hiérarchie et registre complet d’inconnues restent exacts en octets. La qualification d’un seul descripteur de consommateur est corrigée avec son historique ; les autres descripteurs existants restent exacts. Aucune question, case ou acceptation n’est fermée.

La copie privée puis les deux bases réelles sont vérifiées avec Store.task, copy_text, summary, dépendances et rt.resolve. Par base : **245 destinataires**, **42 362 autres lignes catalogue**, **42 607 états/notes** et **23 historiques** exacts. Les nouvelles entrées acteur sont visibles dans le texte condensé ; le graphe complet et le reçu restent nécessaires pour tous les lecteurs UV. La question Veigar est retrouvée chez son propriétaire. Intégrité SQLite OK ; synchronisation normale suivante idempotente.

Préparation, contrôle, publication et audit finissent au code0. Les transactions restent séquentielles ; aucune atomicité globale fichiers/deux bases n’est revendiquée. **Aucun nouveau build, client original, jeu courant, GPU, réseau ou audio n’est exécuté.** Les mesures UV et le rattachement des sources ne constituent pas une validation visuelle ou une acceptation des textures, des poses ou de tous les skins et formes.

## Réexamen et textures suivantes

Le réexamen en lecture seule **F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision529_trace_review\REVIEW.json** vérifie le graphe de42 215 exigences et **2 683 ancres avec les octets de519 fichiers courants**, sans divergence. Les17 auxiliaires intentionnels sont conservés. La file CH avec chargeur partagé seul passe à **8 988** : qualification de liens restante, sans absence d’implémentation démontrée. Les98 777 sources ne sont pas toutes rehachées dans ce réexamen.

Une découverte des textures a également été exécutée : **F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision529_texture_discovery\DISCOVERY.json**. Les122 images de couleur embarquées ont les mêmes dimensions que la texture native d’inventaire comparée. Dans **Pillow12.3.0**, les RGBA du mip0 sont identiques pour120 images. KhaZix a287 pixels et Thresh3969 pixels avec une différence maximale de1, **uniquement en alpha** ; RGB reste égal. Ces résultats ne sont pas un oracle du décodeur natif ou du GPU et ne qualifient pas encore la texture native effective, tous les mipmaps ou la fidélité visuelle. Aucun pixel n’est normalisé, réparé ou déclaré corrompu.

La découverte lit112 DDS DXT1,8 DXT5,1 DXT3 et1 DDS sans FourCC. Le dernier doit être qualifié par ses flags et masques, sans conclure à un fichier manquant ou invalide. Ces preuves ne sont pas encore liées aux122 tâches MODELE-TEXTURES.

## Livrables et état final

Modifiés : docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json, docs/completion_tasks_2026-10-20.json et les deux bases du plan. Couverture, plan de complétion, checkpoint, CURRENT.md et HANDOFF.md reçoivent ce contexte après sauvegarde des versions précédentes. IDs, hiérarchie et inconnues restent inchangés en octets.

Ajoutés : docs/reference_requirement_trace_sources/champion-UV-actor-route-links-v528.json ; docs/fidelity_champion_UV_actor_route_links_v528.json ; présent rapport. Six identités de sources sont ajoutées : quatre fichiers de source existants et deux documents de preuves. Aucun code produit, asset, shader, pack ou manifeste n’est modifié.

Graphe final : **42 215 exigences,98 777 sources,2 683 consommateurs,25 920 questions ouvertes,5 517 résolues** avec historique. Les écarts et limites antérieurs restent conservés : Veigar, les écarts numériques,46 arrivées manquées V523/92 questions et V522 Gnar. Aucun champion ou jeu complet n’est déclaré terminé.

Travail : revision528_uv_inspection, revision528_uv et revision529_texture_discovery sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20. La preuve V527 et l’ancienne qualification du vertex restent conservées. Ne pas republier ce lot.

Poursuivre SYS-01.2-02 depuis F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision529_trace_review/REVIEW.json : 8 988 fiches CH ont encore le chargeur partagé seul ; file de qualification, sans absence d’implémentation démontrée. Traiter les122 CH-*-MODELE-TEXTURES à partir de revision529_texture_discovery/DISCOVERY.json :122 images embarquées, dimensions égales,120 mip0 RGBA exacts dans Pillow12.3.0 ; KhaZix287pixels etThresh3969pixels diffèrent seulement en alpha de1. Ne pas qualifier ces différences de corruption ou les normaliser sans source native/oracle. Vérifier les champs Texture des configurations sélectionnées, membership native, provenance de conversion, mip chains, format DDS sans FourCC via flags/masques, espaces couleur/alpha et vrais décodeurs/lecteurs/renderers ; ne pas utiliser le hash DDS comme hash PNG. Préserver la correction ActorFog V528 : shader environment_fow_vertex actuel, ancien cache mesh.wgsl en référence avec historique V527, Veigar native34/33 influences et question propriétaire inchangés,168 UV natifs hors unité non clampés. Les politiques de sampler actuelles ne sont pas celles du moteur original. Garder les17 auxiliaires, écarts numériques,46 arrivées manquées V523/92 questions,V522 Gnar et tous les états manuels. Publication V528 terminée : ne pas la répéter. Goal entier actif.
