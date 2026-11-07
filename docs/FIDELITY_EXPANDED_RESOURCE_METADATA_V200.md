# SYS-01.2-02 — schémas de provenance explicites étendus (V200)

{
  "resources": 58,
  "declared_references": 944,
  "reference_mismatches": 0,
  "resources_with_declared_references": 29,
  "decoded_export_bridges": 122,
  "resources_without_explicit_hashed_reference_or_bridge": 28
}

Le relevé V197 est conservé ; le nouveau couvre en plus source/sha256,mesh/config et leurs SHA,resource/sha256 absolu,default_source et les dictionnaires de banques. Chaque référence est relue avec son origine. Les divergences restent visibles, sans réparation arbitraire.

Le contrat existant resource_hud-links explique les122lignes de champion_resources : source_sha256 est le hash du JSON Stats décodé local, resource est le chemin logique INIBIN natif. Les122JSON décodés et122INIBIN sont épinglés séparément, les chemins MetaData.ResourcePath comparés. Aucun convertisseur ni test historique n’est relancé.

Preuve : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision200/EXPANDED_RESOURCE_SOURCE_METADATA.json. Script : revision200_expanded_resource_metadata.py dans le répertoire parent. Suite : vérifier les transformations ciblées, dont les facteurs de matériaux, puis intégrer les liens de provenance supplémentaires aux fiches. Cases et packs conservés.
