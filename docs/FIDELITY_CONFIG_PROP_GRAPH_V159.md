# SYS-01.2-02 — config.prop, preuve native reliée

Le patcher fourni LoLPatcher.exe (SHA-256 fd4a4edcd45694e08779373286afdaa6870cd86f9847e4fc9db1d0bd556914cb) lit data/config.prop en mode rb. Les diagnostics le déclarent facultatif. La branche de taille nulle sort avant allocation, lecture et parsing.

Contrôles frais : empreinte du binaire, quatre régions, sept ancres, cinq cas dont quatre refus de faits altérés. Le fichier natif deploy/data/config.prop existe toujours et reste vide. Aucun processus original lancé ni fichier réparé.

Les tâches EMPTY-035-CLASSIFY, EMPTY-035-RESOLVE et SYS-01.2-02 sont enrichies. Les deux tâches EMPTY disposent du lien exact vers la branche native ; aucun consommateur Rust fictif ajouté. Les lecteurs du plan et de copie vérifient trois fiches par base, avec intégrité SQLite et42606états manuels préservés. Les anciennes preuves, données hors périmètre et inconnues sont conservées.

Limites : résolution historique du chemin absolu, provenance du fichier archivé et consommateur Rust ordinaire non qualifiés. La branche facultative ne suffit pas à clôturer la classification complète ou à décider une réparation. La validation structurelle globale du graphe ne rehash pas ses97015sources.

Preuve : docs/fidelity_config_prop_graph_v159.json.
Source détaillée : docs/reference_empty_config_sources/config-prop-v159.json.
Scripts et sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision159.
