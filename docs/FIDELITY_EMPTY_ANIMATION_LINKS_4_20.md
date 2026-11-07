# Sources et validateurs de trois animations vides — V53

Trois fichiers ANM vides correspondent exactement aux membres sélectionnés. Leur contenu ne démontre pas une troncature après distribution. Les huit champs natifs décodés utilisent p-animation, avec sections healthIcon, flash et DeathGeo ; un second lecteur confirme type12, offsets et valeurs.

HA_healingIcon_idle.anm et SRU_chaos_mm_death_melee_anim.anm sont cités par leur nom exact. Six autres valeurs citent SRU_order_mm_death_base_anim.anm, à une seule extension : ce membre distinct fait 27 780 octets. Le fichier vide recensé a deux extensions .anm.anm. Le sélecteur de chaque source conserve ces rôles séparément. La résolution effective d'extension/provider n'est pas déduite de la présence des chemins plats.

Le SDK existant et inchangé identifie les trois zéros comme Unknown puis refuse Load ; il accepte séparément le membre à une extension. Ses sources Identify/Load et UncompressedAnimationAsset sont reliées à la DLL par les contrôles PDB hérités, avec DLL et deux documents source relus. Aucun ancien import ou test terminé rejoué ; ni poses, rig, renderer, ni chargement original qualifiés.

La chaîne native lit le littéral p-animation et possède trois références candidates dans le code ; les fenêtres de deux d'entre elles couvrent un appel au getter8B0630. Les frontières complètes des fonctions, transformations de noms, activation, cache et fallback restent ouverts. Aucun programme historique ou instruction native originale exécuté.

23 contrôles de preuve passent, dont 21 refus. Les six exigences CLASSIFY/RESOLVE et leurs questions restent ouvertes. Les consommateurs actuels liés sont les lecteurs de métadonnées/offsets et le SDK de validation ; aucun consommateur de gameplay fabriqué. Aucune ressource remplie/reconstruite et aucune acceptation humaine.

Reçu : docs/reference_empty_animation_sources/empty-animation-links.json. Livraison : docs/fidelity_registry_empty_animation_links_revision_4_20.json. Les six objectifs initiaux et toutes les preuves précédentes sont conservés ; Goal actif.
