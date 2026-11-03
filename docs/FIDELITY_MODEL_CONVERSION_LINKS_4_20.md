# Conversion des modèles — liens V109

Les étapes préparatoires ci-dessous sont conservées ;la preuve de livraison finale fixe le résultat de l’intégration.

# V109 — structure des GLB actuels

164 entrées effectives correspondent à156 fichiers GLB distincts. Lecture de chacun :en-tête/version/longueur,chunks JSON/BIN,accessors utilisés,indices de primitives,indices de matériaux,joints des influences positives,composantes finies position/UV/poids,poids négatifs et somme des quatre poids. Aucun échec de lecture,indice invalide détecté,poids négatif ou somme hors tolérance1e-3 dans ce périmètre. Les hashes de tous les GLB examinés sont conservés dans current-glb-structure.json.

Limites :ce lecteur ne compare pas encore aux SKN/SKL natifs et ne valide ni hiérarchie complète,matrices inverses,poses,animations,textures,shaders ou rendu. Les attributs absents ne constituent pas automatiquement un refus ;certains modèles sont statiques. Les accessors sparse sont explicitement non pris en charge. La présence de quatre composantes ne prouve pas la conservation native des influences.

Lecture du convertisseur :CreateGltfSkeleton construit les nœuds par nom et parent,remappe les influences et refuse un index supérieur à255. SanitizeVertexSkinningAttributes remappe les joints pour les poids positifs ;il ne normalise pas ici les poids. CreateGltfMesh découpe les plages de sommets,rebascule les indices et associe le matériau de chaque plage. Les matériaux sont Unlit/DoubleSide avec BaseColor. Le traitement UV copie les vecteurs,décodant les valeurs half si nécessaire. Ces constats statiques doivent être comparés aux exports réels,et ne qualifient pas tout le convertisseur.

Premier lancement interrompu au moment de produire le reçu :pin(__file__) recevait une chaîne au lieu de Path. Version initiale conservée ;conversion explicite ajoutée,puis contrôle complet relancé avec code0. Aucun fichier de jeu modifié. Les résultats historiques précédents restent distincts.

Suite :comparaison nominale native→GLB des noms/parents,indices/poids/UV,matériaux et échelles,puis associations SYS-14.2. V108 reste la dernière intégration,Goal actif.


# V109 — comparaison native des122 modèles canoniques

122 requêtes actuelles de modèles champions comparées aux chemins SKN de l’inventaire d’export. Pour chaque plage :positions,quatre poids,UV,indices de triangles remis dans l’espace global et nom du matériau. Tous les champs comparés sont exactement égaux sur les122 modèles. Le modèle local Ezreal effectivement sélectionné remplace son entrée de manifeste dans ce contrôle.

Preuves :native-mesh-comparison.json,avec empreintes des122 SKN et122 GLB,comparaisons par plage et script compare_native_meshes.py. Les sources natives sont celles référencées par l’inventaire ;ce contrôle ne recertifie pas leur appartenance RADS. Aucun export ni fichier de jeu modifié.

Le lecteur SKN admet strictement les versions0/2/4 avec minor1 et les dispositions de sommets inspectées ;aucun cas rencontré n’a été refusé. Il ne reproduit pas le prédicat permissif de version du convertisseur historique. Comparaison de valeurs float décodées,non comparaison bit-à-bit de l’intégralité des fichiers.

Ne sont pas démontrés :ordre/hiérarchie/noms des os,remappage des identifiants d’influence,matrices inverses,normales,poses,animations,textures,mipmaps,shaders,échelles en scène,autres formes et668skins. La conservation des poids ne prouve pas qu’ils sont attachés aux bons os. Prochaine étape :comparaison des rigs/influences,puis liaisons SYS-14.2 avec les limites correspondantes. V108 reste dernière intégration,Goal actif.


# V109 — comparaison des squelettes et influences

Les122 SKL de l’inventaire ont été décodés en lecture seule,formats modernes0 et legacy1/2 selon les sources inspectées. Les122 GLB effectivement sélectionnés ont été comparés pour les noms d’os,liens parent/enfant et destinations nommées des influences de poids positif.

120 modèles concordent dans ce périmètre. Ezreal et Veigar ne sont pas qualifiés par cette comparaison :noms d’os dupliqués. Le dictionnaire indexé par nom perd la distinction entre ces identités. Les écarts de parent affichés dans native-rig-comparison.json sont donc des diagnostics d’ambiguïté du comparateur,non une preuve de corruption de l’asset. Ezreal possède notamment plusieurs R_PARENTING_HAND_LOC,Veigar plusieurs toe. Le modèle local Ezreal est précisément distinct du modèle exporté standard.

Les destinations comparées par nom sont égales pour tous les poids positifs,mais ce constat ne distingue pas les os homonymes dans les deux cas ambigus. Il faut suivre les identifiants natifs,la table d’influences et l’ordre des joints GLTF pour les qualifier. Les120 résultats sans collision de noms restent valides dans leur périmètre. Aucune matrice de liaison,pose ou animation qualifiée.

Preuves :compare_native_rigs.py et native-rig-comparison.json,avec source du format,SKL,SKN,GLB et reçus précédents identifiés. Aucun export ni fichier de jeu modifié. Suite :lever l’ambiguïté par identifiants,consulter les preuves locales Ezreal existantes,puis qualifier les cas de refus et intégrer les liens SYS-14.2. V108 dernière intégration,Goal actif.


# V109 — homonymes résolus et défaut Veigar

Comparaison supplémentaire par chemin complet des ancêtres. Chaque influence native est résolue via son ID et la table SKL ;chaque influence GLTF via son index dans skin.joints. Cela évite le dictionnaire par nom qui masquait les homonymes.

Ezreal :72 os natifs,72 os actuels,chemins complets uniques,aucun chemin absent/supplémentaire et aucune différence de destination pour4700 influences positives. Le modèle local effectivement sélectionné conserve ces identités dans le périmètre testé. Les matrices/poses restent hors contrôle.

Veigar :50 os natifs contre49 actuels. Un chemin natif manque et33 influences positives vont vers un autre chemin d’os. Le reçu conserve chaque sommet,lane,chemin attendu et observé. Le convertisseur examiné réutilise le premier nœud trouvé par nom ;ce mécanisme est cohérent avec la fusion des deux os toe,mais aucune nouvelle exportation n’a été exécutée ici. Le défaut constaté reste ouvert ;ne pas déduire sa résolution des poids scalaires identiques.

Les120 modèles précédemment concordants et Ezreal donnent121 comparaisons sans écart dans les seuls noms/parents/influences examinés. Veigar reste non conforme. Aucune affirmation sur l’intégralité des668 skins ou le rendu.

Preuves :homonymous-joint-comparison.json,compare_homonymous_joints.py et reçus précédents conservés. Aucun asset modifié. Suite :lier explicitement le défaut aux exigences SYS-14.2-01/02,compléter les autres preuves du lot et intégrer le registre avec inconnues ouvertes. La réparation de l’asset n’est pas effectuée par cette tâche de liens de sources. Goal actif,V108 dernière intégration.


# V109 — échelles actuelles et refus du calculateur

Dix tests existants réussis via test_native_base_scale_catalogue.py,chargé sans modification avec ROOT explicitement positionné sur F:/OpenLeague. Les tests exercent les122 liaisons,les256 vecteurs hérités de précision du byte compressé et les refus du calculateur. Log et sources dans scale-test-receipt.json.

Comparaison séparée du manifeste actuel :repair calcule sur copies,zéro changement proposé et122 valeurs float32 conformes aux références retenues. Résultat détaillé current-scale-comparison.json. Cette observation actualise le statut des anciens écarts de précision pour ce catalogue ;elle ne réécrit pas leurs preuves historiques ni ne clôture automatiquement leurs inconnues.

Les références de getters natifs sont héritées ;aucune instruction originale réexécutée ici. Les chemins de source restent des entrées explicites de qualification,pas une preuve de priorité historique des providers. Les sept ambiguïtés de configuration des skins restent distinctes. Aucune vérification nouvelle du GPU,de la taille physique ou des collisions. Aucun catalogue ni asset modifié.

Le parcours actuel animation::request retourne la scale du catalogue pour le rendu. Le lien à la simulation et les variantes exigent des preuves séparées. Les contrôles de maillage/rig précédents restent en vigueur,avec défaut Veigar ouvert. Suite :assembler les six associations SYS-14.2,qualifier le lecteur puis intégrer les preuves au registre et aux deux bases. V108 dernière intégration,Goal actif.


## Livraison

559 fichiers,977 contrôles source et29 cas lecteur dont28 refus. Le défaut Veigar est intégré dans les constats et inconnues des exigences01/02,sans clôture. Aucun asset n’est modifié. Voir docs/fidelity_registry_model_conversion_links_revision_4_20.json pour les contrôles effectifs des deux bases.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-14.2-01 | 121 canonical rigs agree on tested names/parent paths and positive-weight destinations;Veigar has49/50 joints and33 changed influence destinations. | Repair/qualify Veigar identity preservation;verify bind matrices,all forms/skins and animated poses. |
| SYS-14.2-02 | 122 canonical meshes preserve scalar weights;121 rigs preserve tested destinations,Veigar has33 differing positive-weight destinations. | Scalar weight equality is not sufficient;qualify the Veigar correction and all remaining rigs/skin variants. |
| SYS-14.2-03 | 122 canonical models match native positions,UV,rebased triangle indices and material names exactly in decoded comparison. | Qualify other variants,all material semantics,normals and complete rendering;156-file structure census is not native equivalence. |
| SYS-14.2-04 | Native skin resolver exposes Texture and related fields;offline exporter writes mip0 PNG and Unlit/DoubleSide BaseColor materials. | No full inherited texture/variant dependency graph,mip fidelity or complete shader equivalence qualified. |
| SYS-14.2-05 | Ten scale calculator tests pass on F;current122 catalogue values already match retained reference float32 results with zero proposed changes. | Retained getters are conditional source bindings;physical dimensions/collision independence,all skins and GPU size remain unqualified. |
| SYS-14.2-06 | Exporter inventory supplies separate rigs for related resources,while current request selects by model name;related_form_or_summon is not owner/transform proof. | Qualify each alternate form/skin with its own identity,rig and actual dispatch;do not transfer canonical-only results to all forms. |

Reçu : docs/reference_model_conversion_sources/model_conversion-links.json. Livraison : docs/fidelity_registry_model_conversion_links_revision_4_20.json. Les six tâches et le Goal restent ouverts.
