# SYS-01.2-02 — dépendances Cargo et lecteurs intégrés (V196)

Le lecteur tools/project-plan/cargo_resource_dependencies.py est relié à SYS02.5-04 et à SYS01.2-02. Les preuves réelles V195 portent sur deux dep-info :189ressources de liaison (131déclarées,58hors manifeste) et463ressources de tests directs (212déclarées,251hors manifeste), aucun fichier absent ni SHA divergent parmi les déclarées. Les58ressources hors manifeste de la liaison ont112includes exacts dans56sources actuelles. Aucun statut de fonctionnalité fermé.

Le lecteur explicite son périmètre, recherche les includes exacts, conserve les identités et signale les ressources absentes/modifiées. Huit refus (syntaxes/portée invalides) et trois contrôles sur fichiers diagnostiques séparés passent. Il ne lance pas Cargo ni le jeu. Les dates dep-info, les macros lexicales et la lecture courante restent des preuves distinctes de l’exécution et de la fermeture dynamique.

Livraison :2fiches/copies/traces dans chacune des2bases,2pointeurs JSON et2refus vérifiés ; empreintes et ancre du lecteur vérifiées.42606états manuels et historique conservés. Anciens consommateurs, sources, associations, inconnues et autres champs des tâches inchangés. Validation structurelle globale effectuée, sans rehash exhaustif du registre.

Fichiers : tools/project-plan/cargo_resource_dependencies.py ; docs/reference_event_lookup_sources/cargo-dependency-v196.json ; docs/fidelity_cargo_dependency_graph_v196.json ; registres sources/trace/tâches ; CURRENT/HANDOFF et resume_checkpoint. Sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision196/before-cargo-dependency-graph.

Restent ouverts : origine et rôle de chaque ressource hors manifeste, dépendances dynamiques, fermeture et distribution complètes, build frais et autres exigences. Les packs n’ont pas été changés. Le candidat d’archives SYS03.4-07 reste non identifié après clarification utilisateur ; poursuivre les travaux indépendants.
