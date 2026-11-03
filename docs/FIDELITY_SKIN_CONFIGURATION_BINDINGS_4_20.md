# Configurations natives de skins — SYS-01.2-02/03/06

Référence : client4.20.0.315PUBLIC EUW/en_GB ; identités du catalogue officielDataDragon4.20.1.668skins/10688tâches sont contrôlés. Une configuration doit porter un ChampionSkinID natif exactement égal à l’identité officielle. Aucun ID déduit d’un nom de fichier, héritage implicite ou fallback sur le skin de base.

Deux dispositions sont inspectées : `DATA/Characters/Champ/Skins/Base|SkinNN/*.inibin` sectionMeshSkin et `DATA/Characters/Champ/Champ.inibin` sectionsMeshSkin/MeshSkinN. 334identités n’utilisent que la dispositionlegacy. ExempleAkali84001 : sectionMeshSkin1, TextureAkali_Yellow_TX_CM.dds, SimpleSkinAkali.skn ; le fichier absent au chemin moderne n’est pas une absence de configuration. 656identités ont un lien unique,5des configurations équivalentes sur tous les champs nommés,7des configurations contradictoires.

Les7cas sontRenekton0..6 : mêmeChampionSkinID, échelles modernes généralement1.55999994(et1.480000019pourSkin4) contre1.6legacy ; différence de casse du nom de base. Aucune priorité par position de dossier ni mélange des champs n’est appliqué.112questions d’exigences attendent une preuve du loader/consommateur effectif.

5344questions d’absence de configuration sont résolues avec preuve/historique.5344questions génériques supplémentaires restent ouvertes pour les rôles et consommateurs précis ; elles ne prétendent plus que le fichier est absent et gardent leur ancien texte. Les8736questions non_base_skin_dispatch restent ouvertes. La configuration, la présence d’un modèle et les liens du catalogue ne qualifient ni disponibilité historique/possession, ni animation/VFX/audio, ni sélection en jeu, ni respawn/reconnexion. Aucune métadonnée de complétude ou caseSKIN n’est modifiée.

Relecture : `python -B tools/project-plan/native_skin_reference.py --root E:/OpenLeague`. Les consignes copiées donnent le sélecteur exact. 83tests et la vérification complète24206sources/34ancres passent ; preuves dans `docs/fidelity_registry_skin_revision_4_20.json`.
