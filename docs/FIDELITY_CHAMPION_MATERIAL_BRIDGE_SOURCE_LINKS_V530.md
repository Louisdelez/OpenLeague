# SYS-01.2-02 — Matériaux de base et conversion StandardMaterial, V530

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue officiel 4.20.1 distinct. Build littéral du 2014-11-17 à 17:46:45 ; fuseau et déploiement non établis.

## Résultat intégré

Les **122 fiches CH-*-MODELE-MATERIAUX** relient les configurations et ressources natives sélectionnées aux vrais consommateurs actuels. **122 fiches MODELE-TEXTURES** sont enrichies de l’étape intermédiaire glTF vers StandardMaterial. **3 173 liens**, seize nouveaux CID, quatre nouvelles identités physiques et trois documents de source sont ajoutés. Les tâches restent a_faire et aucune ressource, pixel, image, animation, shader ou code produit n’est modifié.

Le chargeur Bevy 0.19 produit d’abord **GltfMaterial**, puis le gestionnaire PBR convertit ses champs en **StandardMaterial**, crée le sous-asset /std et insère son handle dans MeshMaterial3d. Cette étape est maintenant explicite dans les fiches matériaux et textures. Elle complète les liens V529 sans invalider ou réécrire ses observations.

Le groupe DefaultPlugins et les options PBR par défaut installent cette passerelle dans le code actuel ; les fonctions de conversion, création et insertion sont identifiées. Les champs couleur, texture, UV, unlit, alpha, double-sided et cull sont copiés. ActorFog clone le matériau dans FogMaterial. ExtendedMaterial délègue l’alpha à sa base lorsque l’extension ne la remplace pas ; il spécialise d’abord la base, puis l’extension. Avec le mode acteur zéro, le code native_environment_draw conserve le pipeline de base. Les routes de fragment alpha/unlit sont reliées aux fichiers réels.

Les sources des dépendances sont comparées aux membres des archives dont les hashes correspondent à Cargo.lock. Leurs chemins et fonctions sont ceux de la résolution Windows offline héritée, dont les entrées sont revérifiées. Ce n’est pas une nouvelle compilation, instanciation de plugins ou exécution GPU.

## Attendu et observé

| Contrôle | Attendu dans le périmètre | Observé |
| --- | --- | --- |
| Matériaux sélectionnés | Inventorier tous les objets des vrais GLB de base | 151 objets, 122 modèles ; override Ezreal conservé |
| Paramètres courants | Lire ce que le GLB transmet au chargeur | 151 opaques, unlit et double-face |
| Source de l’auto-éclairage | Garder les valeurs natives, sans les remplacer par un booléen | 122 champs SelfIllumination/getters hérités identifiés |
| Passerelle glTF/PBR | Relier les champs au matériau attaché à l’entité | Conversion, création /std et insertion réelles reliées |
| Shaders natifs | Identifier ce qui existe, puis limiter la sélection démontrée | Sept fichiers disponibles et conformes aux manifestes ; sélection par champion non qualifiée |
| Brillance/reflet | Chercher les noms effectivement présents dans les configs | 24 requêtes, 31 candidats DDS, tous conformes aux manifestes ; quatre requêtes multiples |
| Consommation auxiliaire courante | Inspecter les liaisons des matériaux sélectionnés | Base color seulement ; aucune liaison gloss/reflection inventée |
| Limites V529 | Ne pas fermer ses questions grâce au mode opaque | Les 22 questions texture restent exactement conservées |

## Sources natives présentes et limites de sélection

Les cinq sources HLSL examinées sont LIT_PS, LIT_VS, LIT_PROP_VS, LIT_AND_WHITE_WITH_DEPTH_VS et DEFAULT_PS ; deux binaires candidats LIT_PS_0 et DEFAULT_PS_0 sont également identifiés. Les sept fichiers sont conformes aux projets natifs sélectionnés. La présence de sources et de binaires portant des noms proches ne prouve pas leur équivalence de compilation, les defines effectifs ou la variante choisie pour un champion.

**LIT_PS.ps_2_0** déclare SELF_ILLUMINATION à c24 et l’inclut dans son expression d’albedo. **DEFAULT_PS.ps_2_0** renvoie un texel diffus. Les anciens commentaires des vertex shaders parlant de SKIN_PARAMETERS.w ne démontrent pas à eux seuls l’usage réel d’un paramètre. Aucun de ces exemples n’est imposé comme variante historique des 122 champions.

L’auto-éclairage n’est pas assimilé au drapeau unlit. Les valeurs natives héritées, la valeur renvoyée par le lecteur local et sa projection numérique sont séparées. Pour **LeeSin**, la projection locale de 0.9 vaut **6666663f**, le getter natif hérité vaut **6766663f** : l’écart d’un ULP reste visible. Les chaînes **Velkoz ".7"** et **Zac "1.0"** gardent leur type. Aucun getter natif n’est réexécuté dans ce lot, aucune valeur native remplacée.

La recherche littérale sans résultat dans le code courant n’est pas une preuve d’absence de lecteur indirect. Les étapes natives de sélection des shaders, de transfert des constantes et de rendu effectif restent à qualifier.

## Ressources de brillance et de reflet

Les douze configurations qui déclarent GlossTexture et ReflectionMap sont : **braum, garen, kalista, leona, lissandra, nami, orianna, sejuani, skarner, trundle, velkoz, zac**. Les requêtes Texture1/2/3 n’ont pas été trouvées dans ces configurations sélectionnées ; cette recherche porte sur ces noms précis et ne prouve pas l’absence de tout autre champ ou ressource possible.

Le scan du deploy fourni conserve les **24 requêtes** et les **31 fichiers** dont le basename correspond exactement, casse ignorée. Tous les candidats ont une identité et une appartenance au manifeste vérifiées. Les entêtes DDS sont recensés ; toutes les faces, mips et pixels ne sont pas décodés ou acceptés par cette inspection. Quatre requêtes ont plusieurs candidats :

| Champion | Champ | Candidats |
| --- | --- | ---: |
| orianna | GlossTexture | 3 |
| orianna | ReflectionMap | 3 |
| sejuani | ReflectionMap | 2 |
| zac | ReflectionMap | 3 |

Tous sont conservés avec leurs chemins et hashes. L’ordre lexical sert à présenter les résultats, jamais à choisir une ressource. Aucun ordre d’alias/cache/overlay natif n’est inventé. Les matériaux des GLB actuels ne lient que la couleur de base ; l’usage natif de la variante REFLECTIVE et l’intégration correcte de ces ressources restent ouverts.

**Une question est ajoutée chez chacun des 122 propriétaires MODELE-MATERIAUX** : relier la vraie variante native, les defines, constantes, ressources et états de rendu à la conversion courante, puis les comparer dans un rendu contrôlé. Pour les douze cas auxiliaires, les ressources et candidats sont explicitement inclus. La question exprime une qualification encore manquante, pas une déclaration que les fichiers ou tout le renderer seraient absents.

## Alpha et rendu courant

Le fragment ActorFog appelle alpha_discard. Le code verrouillé de cette fonction fixe l’alpha à 1 pour OPAQUE ; la branche unlit utilise ensuite la couleur de base au lieu de apply_pbr_lighting. Il s’agit d’une route de **code source**, pas d’une capture GPU. Cela ne résout ni l’écart alpha de KhaZix/Thresh ni l’usage alpha du client natif. Les 20 questions de mips et les deux questions de décodeur V529 restent ouvertes, chez les mêmes propriétaires, sans modification de leurs objets.

Les modes de transparence dynamiques, prépasses, ombres, lumières, autres skins/formes, paramètres originaux et sorties GPU ne sont pas acceptés par ce lot.

## Contrôles réellement exécutés et reprises

Inspection principale, reprise auxiliaire, préparation, contrôle privé, publication et audit : **codes 0**. Huit refus bornés : enum alpha invalide, index d’image hors table, doubleSided non booléen, facteur couleur de mauvaise taille et quatre demandes de basename avec chemin/valeur vide. Ils qualifient les analyseurs d’audit, pas un refus global de glTF/Bevy.

Trente refus propres protègent propriétaire, consommateurs, portée, valeurs LeeSin, candidats Sejuani, absence de liaison auxiliaire courante et questions V529. Quatre refus publics protègent références absentes, acceptation inventée et inconnue étrangère. Le premier collecteur auxiliaire avait à tort exigé un candidat unique pour Sejuani : **code 1**, script et log conservés. La reprise recense tous les candidats du deploy et refuse d’en choisir un. Le premier contrôle privé avait aussi exigé que les 244 extraits condensés changent : **code 1** conservé. Les 122 extraits textures restent identiques parce que seuls leurs trois premiers consommateurs sont affichés ; leurs résolutions complètes sont bien enrichies. Le contrôle corrigé attend donc 122 extraits matériaux modifiés, vérifie les mêmes 244 objets enrichis et garde le candidat/reçu inchangé. Un premier lanceur PowerShell n’avait pas démarré le collecteur ; il a été corrigé avant les commandes consignées. Aucun résultat de ce lancement n’est présenté comme une vérification réussie.

Les comparaisons numériques et ressources natives sont héritées ou statiques selon le reçu. Aucun jeu, moteur original, nouveau client, compilateur de shader, build Rust, Blender, GPU, audio ou réseau n’est exécuté ici. Python et rg, commandes, exécutables/outils et sources sont identifiés dans l’environnement et les reçus. Aucun téléchargement nécessaire.

## Intégrité des registres et du plan

Par base : **245 destinataires**, **42 362 autres lignes catalogue exactes**, **42 607 états manuels**, **23 historiques exacts**. Store.task, copie, résolution, dépendances, résumé, questions propriétaires et intégrité OK ; synchronisation normale idempotente. Les lecteurs unlit et passerelle des matériaux apparaissent dans les trois premiers liens copiables. Pour les textures, les trois liens de passerelle sont ajoutés en conservant l’ordre relatif de tous les anciens liens ; le texte condensé ne montre pas tous les consommateurs, la résolution complète et le reçu les exposent.

Les **122 extraits condensés matériaux changent**, **42 093 restent exacts**, dont les 122 extraits textures dont les liens supplémentaires restent dans la résolution complète. Les **244 objets de trace ciblés** sont enrichis ; 41 970 autres objets tâche/trace sont identiques. Les 122 classifications documentaires des matériaux deviennent partial_with_open_questions ; leurs statuts de tâche restent inchangés. IDs et hiérarchie sont exacts en octets. Anciens objets d’inconnues, sources et consommateurs conservés, y compris la requalification ActorFog V528 et son historique, le rig Veigar, les UV hors unité et les autres écarts antérieurs. Aucun statut de tâche, critère, case ou note utilisateur changé.

Réexamen global frais : **42 215 exigences**, **98 790 sources**, **2 706 CID**, **526 fichiers de consommateurs**, zéro divergence d’ancre ou d’octets. Les 17 auxiliaires voulus restent présents. Questions : **26 064 ouvertes**, **5 517 résolues**. Les **8 744 fiches CH** avec chargeur partagé seul constituent une file à qualifier, sans absence d’implémentation démontrée. Les catégories se recoupent ; elles ne mesurent pas un pourcentage de jeu terminé. Aucun nouveau hash physique global des 98 790 sources revendiqué.

## Fichiers et preuves

- Registres modifiés : docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, fidelity_unknowns_4_20.json et completion_tasks_2026-10-20.json.
- Reçu : docs/reference_requirement_trace_sources/champion-material-bridge-source-links-v530.json ; preuve : docs/fidelity_champion_material_bridge_source_links_v530.json.
- Inspections : revision530_material_inspection/OBSERVATIONS.json et revision530_auxiliary_material_inspection_retry/OBSERVATIONS.json sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.
- Sauvegardes, candidats, contrôles, publication, audit : revision530_material ; commandes revision530_material_COMMAND_*.json/.log.
- Réexamen : revision531_trace_review/REVIEW.json ; échec auxiliaire conservé dans revision530_auxiliary_material_inspection et ses commandes.
- Couverture et reprise mises à jour : docs/coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md, sans supprimer leurs champs antérieurs.
- Bases : F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3 ; seules données de catalogue/instructions des destinataires et métadonnées de version changées.

## Suite du Goal

La découverte des packs a aussi été exécutée en lecture seule : les 122 modèles sélectionnés correspondent au manifeste et aux membres des quatre archives concernées du cache configuré ; les quatre tailles/hashes d’archive sont exacts. Aucune URI glTF externe dans ces modèles. Cette preuve distingue fichiers déployés, déclarations et membres réels. Les autres membres, une restauration complète et les consommateurs PACK restent à qualifier ; aucun lien PACK n’est publié, aucun pack extrait ou téléchargé. Résultat : revision531_pack_discovery/DISCOVERY.json.

Poursuivre SYS-01.2-02 depuis revision531_trace_review/REVIEW.json : 8 744 fiches CH ont encore le chargeur partagé seul, file de qualification sans absence d’implémentation démontrée. Examiner les 122 CH-*-MODELE-PACK depuis revision531_pack_discovery/DISCOVERY.json : 122 modèles sélectionnés déclarés et exacts dans les membres de quatre archives du cache configuré ; hashes des quatre archives exacts, aucune URI glTF externe. Cette découverte n’a publié aucun lien PACK et ne qualifie pas une restauration complète. Vérifier vrai contrat et lecteurs du pack, tables complètes/tailles/attributs, distribution/téléchargement, dépendances de modèle et métadonnées effectives (override Ezreal inclus) avant de publier les liens ; ne pas assimiler assets ou manifeste à une archive vérifiée. Ne pas télécharger/reconstruire le jeu ou réparer les assets dans cette tâche de correspondance. Préserver V530 : 122 questions matériaux sur variante/defines/constantes/état natifs non qualifiés, 31 candidats DDS pour 24 requêtes dont quatre ambiguës, sept shaders disponibles, LeeSin un ULP et types Velkoz/Zac. Ne pas assimiler unlit à SelfIllumination ni choisir un candidat par ordre lexical. Préserver les 22 questions texture V529, route/historique ActorFog V528, Veigar joint 34/33 influences, 168 UV hors unité, 46 arrivées V523/92 questions, 17 auxiliaires et tous les états utilisateur. V530 publié et audité : ne pas republier. Goal entier actif.
