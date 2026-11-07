# SYS-01.2-02 — dérivation du champ material_factors (V203)

Le champ material_factors de environment_lighting.json est reconstruit depuis les indicateurs de matériaux du NVR natif et les identités mesh/matériau du GLB courant, selon la règle du producteur inspecté :8avec couleur secondaire (flag16),4sinon ; seuls les matériaux type0 sans flag8 sont retenus.

1971liaisons mesh et70matériaux concordent exactement. Les indices natifs sont validés ; les relations de noms exacts ou préfixes tronqués sont recensées séparément :{'exact_current_label_rule': 1665, 'truncated_prefix_of_current_label_rule': 306}. Règle locale AlphaTest_ conditionnée par flag4 retrouvée dans tools/qualify_map10_shader_fields.py ; aucune règle de troncature historique imposée. Trois refus passent : facteur changé, matériau manquant, matériau ajouté. Empreintes du NVR,GLB,JSON et producteur conservées.

La preuve qualifie ce champ précis, pas le fichier complet, les couleurs par sommet, les shaders, gamma, lightmaps ou rendu. Aucun export, Blender, GPU ni jeu exécuté ; aucun asset changé. Preuve : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision203/ENVIRONMENT_MATERIAL_FACTOR_DERIVATION.json. Suite : intégrer les nouveaux liens de provenance et ce champ dérivé aux fiches concernées.
