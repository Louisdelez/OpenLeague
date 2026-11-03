# SYS-01.2-02 — lecteurs des58ressources non déclarées (V194)

Les58ressources assets/data absentes du manifeste mais présentes dans la liste de liaison Cargo disposent toutes d’au moins un include exact dans le code actuel :112ancres dans56fichiers. Les chemins relatifs sont normalisés et les octets des58ressources concordent avec V193. Les sources des lecteurs sont épinglées séparément.

Exemples inspectés : environment_lighting.json est lu dans map_fog.rs ; champion_resources.json dans les barres HUD et lifecycle.rs ; experience_curve_map10.json dans la progression et le HUD ; le manifeste audio dans pcm_audio.rs. Ces lectures montrent une dépendance de compilation concrète, sans prouver que chaque branche s’exécute pendant une partie.

Les fichiers Cargo historiques et les ancres lexicales courantes restent deux niveaux de preuve distincts. Aucun pack, manifeste ou état de tâche modifié ; fermeture des dépendances dynamiques, cfg et build frais restent ouverts. Preuve : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision194/UNDECLARED_RESOURCE_CONSUMERS.json. Suite : intégrer la liste et ses consommateurs de diagnostic à SYS02.5-04.
