# SYS-01.2-02 — autres chemins runtime et formats intégrés (V209)

Les53ressources connues hors glTF (44PNG,3WAV,2polices,3WGSL,1DDS),les15politiques bornées de chemins non littéraux et le modèle forms/trundlewall.glb sont reliés aux consommateurs précis de SYS02.5-04 et SYS01.2-02. Avec V206,le périmètre glTF connu atteint167chemins. La sélection est observée au source ;les variantes arbitraires et autres orthographes de chargement restent ouvertes.

V207 relit52ressources,conformes au manifeste :PNG vérifiés/décodés,Pillow FreeType sur masques de glyphes diagnostiques,WAV jusqu’aux frames déclarées,WGSL UTF8 sans compilation. Neuf refus de formats/chemins passent. V208 revalide ces52sorties avec le lecteur étendu et vérifie le DDS Garen,le modèle du pilier et un refus DDS supplémentaire. Python,Pillow et leurs modules binaires sont identifiés ;aucune équivalence avec le renderer ou le runtime historique n’est déduite. Le lecteur V207 initial est archivé avec son SHA exact.

Les33PNG d’objets ont les mêmes dimensions que les DDS natifs comparés ;le plus grand écart observé est1/255 par canal RGBA. La comparaison V207 et ses identités sont conservées et les identités relues à la livraison. Aucune corruption ou nécessité de remplacement n’est établie ;l’arrondi est une hypothèse. L’étiquette descriptive32objets du catalogue source est signalée face aux33entrées réelles ;le hash de boutique concorde.

Livraison :2fiches/copies/traces par base,2pointeurs+2refus,identités des53ressources et du modèle,33DDS et ancres vérifiés.42606états manuels et historique conservés. Sources,consommateurs,associations,inconnues et autres champs antérieurs conservés. Validation globale structurelle, sans rehash exhaustif du registre.

Fichiers : tools/project-plan/runtime_asset_evidence.py ; docs/reference_event_lookup_sources/runtime-assets-v209.json ; docs/fidelity_runtime_assets_graph_v209.json ; registres sources/trace/tâches et les deux bases. Sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision209/before-runtime-assets-graph. Preuves V207/V208 conservées ;documents de reprise actualisés.

Aucun asset,pack,code de jeu,Bevy/GPU ou écoute modifié/exécuté. Restent ouverts :autres récepteurs/accès fichiers,valeurs runtime hors ensembles connus,activation cfg/call,codecs/shaders/renderer/audio historiques et fermeture dynamique générale. Aucun jeu ou tâche générale déclaré terminé.
