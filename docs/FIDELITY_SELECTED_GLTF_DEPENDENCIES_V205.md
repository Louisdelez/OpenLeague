# SYS-01.2-02 — dépendances des modèles sélectionnés (V205)

{
  "selected_root_records": 174,
  "unique_model_paths": 166,
  "models_with_storage_references_verified": 166,
  "errors": 0,
  "external_reference_records": 0,
  "embedded_images": 400,
  "negative_controls": 8
}

Le nouveau lecteur tools/project-plan/gltf_dependency_evidence.py relit les conteneurs locaux,URIs de buffers/images et plages de bufferViews. La sélection suit les manifestes fusionnés de Catalog,le modèle Ezreal substitué au code,les placements ambiants et les appels carte/relique. Les cinq ancres de sélection et les sources sont vérifiées. Ce calcul de politique au source est distinct d’une exécution Rust.

Le nominal diagnostique vérifie un buffer externe et une image inline ;huit refus contrôlent URI distante,sortie de racine,fichier absent,base64 invalide,plage de vue,stockage image ambigu,buffer tronqué et en-têteGLB tronqué. Les erreurs sur les modèles réels restent dans la preuve ;aucune réparation ou réussite inventée.

Les URI internes vérifiées affinent la fermeture des ressources connues,avec extensions non qualifiées et chargements alternatifs explicitement ouverts. Aucun asset ou état de tâche modifié. Preuve : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision205/SELECTED_GLTF_DEPENDENCIES.json. Suite : intégrer le lecteur,les chemins et leurs dépendances à SYS02.5-04 ;examiner les erreurs observées.
