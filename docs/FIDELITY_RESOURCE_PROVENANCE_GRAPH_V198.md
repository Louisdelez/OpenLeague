# SYS-01.2-02 — ressources compilées, origines et lecteurs reliés (V198)

SYS02.5-04 et SYS01.2-02 relient maintenant58ressources courantes à112includes exacts dans56fichiers. Les identités de source et les lignes ont été revérifiées. Quatre ressources sont des copies exactes du client natif (terrainMap10 et trois TroybinEzreal) ; experience_curve_map10.json est identique à la copie du serveur communautaire. Ses22valeurs et les24valeurs de death_times_map10 concordent séparément avec les INIBIN natifs après conversion numérique explicite binary32. Cette comparaison ne constitue pas une identité de format ou une politique serveur originale.

L’audit V197 a relu182références déclarées avec SHA, toutes concordantes.34fichiers ne disposent d’aucune identité native/communautaire directe ni référence source/SHA selon les schémas inspectés. Les métadonnées identifient des entrées déclarées, sans qualifier une transformation complète. Ces limites restent dans les associations.

Livraison :2fiches/copies/traces par base,2pointeurs JSON+2refus,112ancres,58empreintes et5comparaisons d’octets/distinctions d’origine vérifiés.42606états manuels et historique conservés. Anciennes sources/consommateurs/associations et inconnues conservés ; aucun champ fonctionnel ni case clôturé. La validation globale reste structurelle sans rehash exhaustif du catalogue.

Livrables : docs/reference_event_lookup_sources/resource-provenance-v198.json ; docs/fidelity_resource_provenance_graph_v198.json ; registres sources/trace/tâches et les deux bases du plan. Sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision198/before-resource-provenance-graph. Preuves détaillées V194/V197 conservées.

Restent à qualifier : dérivations des fichiers, activation cfg/call, dépendances dynamiques et distribution complète. Aucun pack ni code du jeu changé. Les données communautaires gardent leur origine explicite.
