# SYS-01.2-02 — autres ressources runtime et icônes (V207)

{
  "unique_selected_paths": 52,
  "inspected": 52,
  "errors": 0,
  "formats": {
    "wav": 3,
    "font": 2,
    "png": 44,
    "wgsl_source": 3
  },
  "undeclared": 0,
  "declared_hash_mismatches": 0,
  "item_icons_compared": 33,
  "pixel_identical": 0,
  "nonliteral_calls_not_exhaustively_resolved": 15
}

Les chemins littéraux assets.load,les dix états de fin de partie,les33identifiants connus de boutique et la police de la boutique sont reliés aux sources. PNG vérifiés/décodés RGBA,WAV lus jusqu’au compte complet de frames,polices chargées avec un masque diagnostique FreeType ;WGSL lu UTF8 sans compilation. Python/Pillow/bibliothèques natives sont épinglés. Neuf refus passent ;nominal WAV séparé passe.

Les33PNG d’icônes sont comparés aux DDS natifs déclarés avec dimensions,hash RGBA,pixels divergents et erreurs par canal. Aucune égalité pixel parfaite ;aucune corruption ni remplacement déduit. Le texte de portée32objets du registre d’icônes est conservé avec son recensement réel33 et la comparaison du hash de boutique.

Preuve : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision207/RUNTIME_ASSET_FORMATS_AND_ICONS.json. Script : revision207_runtime_assets.py dans le répertoire parent. Les appels non littéraux restent listés pour reprise. Aucun asset,pack ou statut modifié ;aucun Bevy/GPU ou écoute exécuté. Suite : intégrer les lecteurs et liens précis,qualifier les chemins restants et les différences d’icônes sans les masquer.
