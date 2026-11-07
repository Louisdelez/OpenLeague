# SYS-01.2-02 — Textures des huit sbires, V489

Le 24 octobre 2026, travail sur F:/OpenLeague. La livraison précédente V488 constitue un progrès vérifié : huit liens modèles publiés, anomalie de squelette identifiée et limites conservées. Ce lot poursuit la traçabilité sur huit fiches WORLD-*-PRESENT-TEXTURE. Aucun asset ni comportement du jeu n'est modifié.

## Résultat attendu et observé

Relier chaque texture native au modèle réellement sélectionné et au code qui la charge et l'affiche, comparer les contenus accessibles, documenter les limites.

Les huit noms MeshSkin.Texture correspondent aux DDS disponibles et au PNG intégré au GLB sélectionné par world_animation_manifest.json. Pour Red_Minion_Wizard, la casse du nom natif diffère ; la correspondance est explicitement insensible à la casse, les chemins exacts restent enregistrés.

Les huit textures sont en DXT1, 512 × 512. Après décodage du niveau principal avec Pillow 12.3.0, les **2 097 152 pixels RGBA correspondent exactement** aux PNG intégrés. Aucun pixel modifié ; SHA des tableaux RGBA identiques pour chaque paire. Les **14 813 UV** correspondent exactement dans l'ordre des sommets. Les SHA des DDS, GLB, PNG intégrés et images décodées restent séparés.

| Modèle | Pixels identiques | UV | Alpha natif/PNG | Champ mipCount DDS |
|---|---:|---:|---|---:|
| Blue_Minion_Basic | 262144 | 1861 | 255 uniquement | 10 |
| Blue_Minion_Wizard | 262144 | 1471 | 0 à 255 | 10 |
| Blue_Minion_MechCannon | 262144 | 1826 | 0 à 255 | 0 |
| Blue_Minion_MechMelee | 262144 | 2831 | 255 uniquement | 0 |
| Red_Minion_Basic | 262144 | 1358 | 255 uniquement | 0 |
| Red_Minion_Wizard | 262144 | 1360 | 255 uniquement | 0 |
| Red_Minion_MechCannon | 262144 | 1494 | 255 uniquement | 0 |
| Red_Minion_MechMelee | 262144 | 2612 | 255 uniquement | 10 |

Le champ mipCount=0 est rapporté tel quel ; il ne signifie pas absence du niveau principal. Les dix niveaux annoncés par trois DDS n'ont pas tous été comparés. Le convertisseur sélectionne explicitement Mips[0] pour produire le PNG ; la conservation ou génération effective des niveaux réduits dans le moteur actuel reste à qualifier.

## Matériaux et limites précises

Les huit GLB contiennent chacun un matériau, une texture et une image PNG intégrée. TEXCOORD_0 porte la couleur de base. Les matériaux utilisent KHR_materials_unlit, doubleSided=true, sans alphaMode explicite ni sampler explicite. Le défaut glTF opaque et sa conversion actuelle sont distingués de la politique native.

Deux images contiennent des pixels transparents, celles du mage bleu et du canon bleu. Le chemin acteur courant copie le matériau et désactive son alpha-test natif ; le shader prend alors la branche standard. Ce constat demande une comparaison avec le shader historique avant toute correction. Des pixels transparents dans un DDS ne prouvent pas à eux seuls que le jeu historique découpait le modèle avec cet alpha.

Les huit INIBIN déclarent SelfIllumination autour de 0.6 (valeur décodée exacte conservée). Un matériau glTF unlit n'est pas une reproduction démontrée de ce champ ni de l'éclairage natif. Texture1/2/3, GlossTexture et ReflectionMap sont absents dans les fichiers examinés ; aucune ressource supplémentaire n'est inventée sur cette seule absence.

Les normales diffèrent : pour sept modèles, écart maximal brut de l'ordre de 1.19e-7 à 2.38e-7. Sur Red_Minion_Wizard, huit normales natives nulles deviennent (0,1,0), sommets 42,45,182,214,225,547,548,567. Pour les normales natives non nulles, comparaison avec leur normalisation scalaire : écart maximal inférieur à 1.1e-7. Le convertisseur appelle SanitizeVertexAttributes ; cette cohérence n'est pas une preuve de sa recette binaire ni de l'effet visuel. Aucune corruption globale n'est déduite de ces différences.

L'écart de squelette du Blue_Minion_Basic identifié en V488 reste ouvert et intact. Le présent lot ne le répare pas.

## Chemin source et consommateurs

- Natif : DATA/Characters/{nom}/{nom}.inibin, .dds et .skn sous le deploy fourni LoL 4.20. Tous les chemins, tailles et SHA exacts sont dans le reçu.
- Sélection actuelle : data/4.20/world_animation_manifest.json puis assets/forms/{nom_en_minuscules}.glb, demande et première scène dans crates/client/src/animation.rs.
- crates/client/src/main.rs : actor_fow::bind programmé après animation::load_models.
- crates/client/src/actor_fow.rs : copie du StandardMaterial dans FogMaterial ; texture conservée, configuration de la branche acteur explicite.
- crates/client/src/map_fog.rs : sélection de shaders/native_environment_fog.wgsl.
- assets/shaders/native_environment_fog.wgsl : lecture via pbr_input_from_standard_material, branche alpha et branche unlit, puis traitements de brouillard/visibilité.
- Sources locales des dépendances Bevy 0.19.0, version relevée dans Cargo.lock : lecture du PNG intégré, contexte sRGB pour la couleur de base, conversion des modes alpha et transfert de GltfMaterial vers StandardMaterial. Sources statiques identifiées, aucun chargeur Bevy exécuté dans ce lot.
- E:/mapslol3v3/StructureExport/Program.cs et sources LeagueToolkit : conversion DDS Mips[0] en PNG, matériau unlit/double face et assainissement des attributs. Il s'agit d'outils communautaires et de provenance historique, pas du code natif de Riot.

Six nouvelles ancres, trois ancres de chargement V488 réutilisées et les associations antérieures conservées. Huit questions ouvertes propres aux textures, sans résolution artificielle.

## Contrôles exécutés

1. Décodage statique des huit DDS et PNG intégrés, comparaison RGBA exacte, vérification des références matériau/image, UV et normales.
2. Cinq refus sur copies en mémoire : mauvais en-tête DDS, DDS tronqué, indice d'image absent, buffer PNG hors limites, signature PNG invalide. Les ressources originales sont identiques après contrôle.
3. Neuf sélecteurs nominaux (huit fiches et SYS), dix sélecteurs invalides refusés ; trois refus du lecteur public : mauvais propriétaire de question, faux statut résolu, condition absente.
4. 42 214 instructions comparées : huit modifiées, 42 206 identiques. Préfixes, critères et dépendances antérieurs conservés.
5. Publication puis relecture indépendante des quatre registres et deux bases SQLite : neuf lignes documentaires par base, 42 597 autres lignes identiques, 42 606 états/notes et 23 entrées d'historique préservés.

Aucun nouveau build, runtime de jeu, rendu GPU, audio ou exécution du client historique. Le décodage Pillow du niveau principal ne valide ni le décodeur GPU natif ni son espace couleur, filtrage, mips ou rendu final. Les routines de refus qualifient le collecteur utilisé ; elles ne prouvent pas les refus du moteur du jeu.

## Échecs et environnement

La première préparation a refusé une source absente du registre au chemin F:/OpenLeague/assets/shaders/native_environment_fog.wgsl. L'échec est conservé dans revision489_prepare_failure01.py ; le shader a ensuite été enregistré sous son chemin actuel, sans substituer sa copie historique. Le refus a eu lieu avant création du dossier de préparation et toute publication.

La commande de reprise en sandbox a renvoyé Git indisponible ; une lecture Git autorisée a confirmé la branche et les modifications préexistantes. Aucun stage, reset ni commit. Deux chemins de recherche supposés (fog_material.rs, map_fog.wgsl) n'existaient pas ; les imports réels ont conduit à map_fog.rs et native_environment_fog.wgsl. Cette recherche ne prouve pas une fonction manquante.

## Livrables et suite

- docs/reference_minion_behavior_sources/minion-texture-v489.json : sources, liens et limites par fiche.
- docs/fidelity_minion_texture_v489.json : preuve de publication.
- Registres docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json, fidelity_unknowns_4_20.json enrichis ; couverture, plan et reprise mis à jour sans effacer les preuves antérieures.
- F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision489_texture_inspection/TEXTURE_OBSERVATIONS.json et NORMAL_OBSERVATIONS.json : observations originales et analyse complémentaire des normales.
- Même racine, revision489/ : préparation, contrôle candidat, audit des bases, environnement, inventaire restant, checkpoint. Scripts revision489_textures.py, revision489_normals.py, revision489_delivery.py, revision489_check.py et revision489_finish.py.

Suite : fiches d'animations des huit sbires. Les pixels et UV présents ne valent pas acceptation du rendu. Conserver les inconnues de matériau, transparence, éclairage, normales et mipmaps dans les tâches. Le sous-inventaire lié au chargeur passe à 151 fiches à reprendre, 365 partielles, 24 exclusions conservées dont12 audio ; ce n'est ni le reste de tout le jeu, ni une preuve que les fiches à reprendre sont dépourvues de liens précis. Goal actif, aucune case cochée automatiquement.

Bilan enregistré : 24 liens natifs, 78 liens consommateurs, 6 nouvelles ancres, 6 sources et 8 questions ouvertes. 85 fichiers directement épinglés. Graphe : 98657 sources, 2524 consommateurs, 25700 questions ouvertes, 5517 résolues avec historique.

Reprise documentaire : la publication et son audit étaient terminés avec code0. Le script de clôture a ensuite échoué sur pin(str) après écriture du rapport, de la couverture et des notes, avant les reçus finaux. revision489_finish.py fautif est conservé. Reprise explicite des seules étapes restantes avec conversion Path, sans nouvelle publication ni changement des bases.
