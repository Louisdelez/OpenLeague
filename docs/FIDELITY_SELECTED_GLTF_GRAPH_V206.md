# SYS-01.2-02 — dépendances glTF des chemins connus intégrées (V206)

Le lecteur gltf_dependency_evidence.py et cinq points précis de sélection sont liés à SYS02.5-04 et SYS01.2-02. La sélection au source reproduit les manifestes fusionnés de Catalog,la substitution Ezreal,les placements ambiants et les appels de carte/relique :174enregistrements,166chemins uniques. L’exécution de Catalog::default ou d’AssetServer n’est pas revendiquée.

Sur ces166modèles actuels,les conteneurs,références buffer/image et plages de bufferViews sont vérifiés ;400images incorporées,aucune URI de fichier externe,aucune erreur de stockage relevée. Le lecteur est qualifié par un nominal séparé (buffer externe,image inline) et huit refus :URI distante,sortie de racine,fichier absent,base64 invalide,plage de vue,stockage ambigu,buffer et GLB tronqués. Ces diagnostics sont indépendants des assets réels.

Livraison :2fiches/copies/traces par base,2pointeurs JSON+2refus,166identités et6ancres vérifiées.42606états manuels et historique conservés. Anciens graphes,preuves et inconnues préservés ;aucune tâche générale clôturée. Validation globale structurelle,sans rehash de toutes les sources du catalogue.

Livrables : tools/project-plan/gltf_dependency_evidence.py ; docs/reference_event_lookup_sources/selected-gltf-v206.json ; docs/fidelity_selected_gltf_graph_v206.json ; registres sources/trace/tâches et les deux bases du plan. Sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision206/before-selected-gltf-graph. Preuve complète V205 conservée.

La portée reste limitée aux modèles connus et aux URI/plages examinées :noms demandés arbitraires et fallback,skins/variantes,extensions glTF,codecs,shaders,autres sites de chargement et dépendances dynamiques complètes restent ouverts. Aucun asset,pack,jeu ou renderer exécuté/modifié par cette vérification.
