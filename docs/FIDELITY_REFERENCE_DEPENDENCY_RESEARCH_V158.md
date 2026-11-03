# SYS-01.2-02 — Références externes, contrôle V158

93 documents des 12 dépôts ont été relus et leurs SHA-256 comparés au catalogue conservé. Tous concordent. Une empreinte volontairement incorrecte est refusée. Aucun accès réseau ni code amont exécuté ; la provenance distante reste celle du contrôle V55 conservé.

Deux consommateurs sont identifiés avec empreinte et ligne : crates/client/src/main.rs:507 utilise Bevy ; crates/client/examples/selector7_depth_gpu_probe.rs:4 utilise wgpu. Le manifeste distingue la dépendance normale Bevy et la dépendance de développement wgpu.

Cargo.lock contient Bevy 0.19.0 et wgpu 29.0.4. Les snapshots fournis déclarent respectivement 0.20.0-dev et 30.0.0. Décision locale : conserver les versions verrouillées ; chaque recommandation devra être comparée à leur API avant adoption. La présence des documents ne prouve pas cette adoption, ni une règle native LoL 4.20.

Aucune compilation, exécution GPU ou validation du jeu réalisée. Aucun état de tâche ni graphe sémantique modifié. Les dix autres décisions et les associations précises restent à qualifier. Git status échoue actuellement avec « this operation must be run in a work tree » ; aucun changement Git effectué.

Preuve : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision158/REFERENCE_DEPENDENCY_RESEARCH.json
Script reproductible : même répertoire, audit_reference_dependencies.py.

## Intégration des décisions

Douze décisions bornées au livrable de traçabilité, sources versionnées et consommateurs précis, intégrées aux12fiches REF-ADOPT et à SYS-01.2-02. Treize lectures/copies conformes par base ;42606états manuels et historique conservés ; intégrité SQLite ok. Preuve docs/fidelity_reference_decision_task_links_v158.json. Les décisions ne clôturent pas l’adoption générale ni les liens sémantiques du graphe. Suite : qualifier ces associations dans le graphe et conserver les inconnues de portée complète.

La mention précédente « aucun graphe modifié » reste exacte ; le registre de tâches et ses deux bases ont ensuite été enrichis, sans changement de statut.

## Intégration au graphe

Douze références reliées au lecteur installé reference_adoption_decisions.py, avec source versionnée et décision locale précise. Douze résolutions, cas nominal et onze refus vérifiés. Graphe97014sources/1764consommateurs ;25321inconnues conservées. Treize fiches/copies/traces conformes par base ;42606états manuels conservés. Trois nouvelles sources rehashées ; validation structurelle globale sans rehash des97014sources. Aucune adoption générale ni fidélité native acceptée. Preuve docs/fidelity_reference_decision_graph_v158.json. Suite : qualifier les liens EMPTY/LOCALE et les limites restantes, sans confondre lecteur de décisions et implémentation du jeu.
