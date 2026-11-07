# SYS-01.2-02 — fonctions builder et médias ambiants (V213)

{
  "builder_texture_paths": 21,
  "families": {
    "terrain_builder": 11,
    "shop_foundry_load_with_settings": 8,
    "bounded_material_builder_constants": 6
  },
  "ambient_WAVs": 31,
  "native_WEM_payloads_verified": 31,
  "native_banks": 3,
  "cloud_levels": 11,
  "negative_controls": 7,
  "current_Rust_tests_passed": 1
}

Les textures terrain/fog,les8atlas Foundry et les constantes de matériauxGaren/Nexus sont relues via leurs chemins précis. Les31WAV concordent avec le manifeste et les31WEM sont identiques aux régions DATA des banques natives référencées par DIDX. Les offsets sont relatifs au chunkDATA. L’appartenance des banques aux projets sélectionnés est conservée.

Le KTX2 des nuages conserve exactement les11niveaux BC1 du DDS source selon le contrat local ;7refus contrôlent offsets/IDs/SHA/frames et intégrité/plages KTX. Le test Rust ciblé réel passe :1test,0échec,Rust1.96.1,1542autres filtrés. Le binaire exécuté,les outils,les entrées et le journal sont épinglés. Rust1.94a été refusé par Bevy(minimum1.95) ;V211a passé le test mais son collecteur a échoué,ce journal est conservé. V212enregistre code0. Aucun dépendance ou source de jeu changée.

Preuve : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision213/BUILDER_AND_AMBIENT_DEPENDENCIES.json. Script : revision213_builder_ambient_dependencies.py dans le répertoire parent. Les199avertissements existants restent au journal ;pas de GPU,écoute ni jeu exécuté. Le convertisseur WEM→WAV et la fidélité du mix natif restent ouverts. Suite : intégrer les sources/lecteurs de ces familles et l’évidence de toolchain aux fiches appropriées.
