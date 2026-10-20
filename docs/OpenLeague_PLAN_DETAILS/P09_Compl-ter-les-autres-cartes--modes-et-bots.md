# P09 — Compléter les autres cartes, modes et bots

[Revenir au plan principal](../OpenLeague_PLAN_DE_TRAVAIL_A_Z.md)

**Résultat à obtenir :** Chaque carte et mode appartenant à 4.20 possède un parcours complet jouable.

**Condition de fin :** Disponibilité datée, terrain, navigation, unités, objectifs, règles, bots et résultats sont validés par mode.

**Prérequis de phase :** P03, P06, P08.

Les cases sont une vue du registre des tâches. Reporter leur statut et leurs preuves dans le registre JSON pour conserver une seule source de suivi. Un lot contient au maximum six tâches.

## P09-L0001 — Qualifier les modes disponibles en 4.20 à partir de Map1, Map8, Map11, Map12 et des configurations natives.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-11-001** — Qualifier le statut 4.20 de Map1, Map8, Map11 et Map12
- [ ] **OL-11-002** — Identifier les modes permanents, tutoriels et modes temporaires datés
- [ ] **OL-11-003** — Écarter les variantes internes uniquement sur preuve de non-disponibilité

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P09-L0002 — Importer puis vérifier terrains, navigation, bâtiments, objectifs, camps et règles de chaque mode disponible.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-11-004** — Importer terrain et minimap de chaque carte requise
- [ ] **OL-11-005** — Importer navigation et structures de chaque carte requise
- [ ] **OL-11-006** — Implémenter camps, objectifs et interactions spécifiques à chaque carte

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P09-L0003 — Porter chronologie, récompenses, règles de sélection, objets autorisés et conditions de fin.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-11-007** — Qualifier sélection, objets et composition des équipes par mode
- [ ] **OL-11-008** — Qualifier chronologie, récompenses et conditions de victoire par mode
- [ ] **OL-11-009** — Jouer une partie complète de chaque mode réellement disponible

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P09-L0004 — Valider les modes temporaires identifiés dans le référentiel, avec leurs restrictions propres.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-11-010** — Fixer le périmètre daté des événements et modes temporaires
- [ ] **OL-11-011** — Implémenter chaque règle événementielle retenue et ses assets
- [ ] **OL-11-012** — Tester leurs restrictions et leur sortie propre vers le client

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P09-L0005 — Cartes, variantes, modes saisonniers et tutoriels doivent être datés ; chaque présence incertaine reste à qualifier.

**Prérequis du lot :** P09-L0001.

- [ ] **EX-11-01** — Cartes, variantes, modes saisonniers et tutoriels doivent être datés ; chaque présence incertaine reste à qualifier.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P09-L0006 — Achever les bots nécessaires aux modes d’entraînement et coopération, avec capacités et achats.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-12-010** — Définir les niveaux de bots historiques réellement requis
- [ ] **OL-12-011** — Implémenter navigation, ciblage et usage de compétences des bots
- [ ] **OL-12-012** — Implémenter achats, retraite, rappel et coopération des bots
- [ ] **OL-12-013** — Tester tutoriels et coopération jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P09-L0007 — Distinguer IA des bots champions, unités invoquées, monstres et tours ; leurs priorités ne sont pas interchangeables.

**Prérequis du lot :** P05-L0009.

- [ ] **EX-12-01** — Distinguer IA des bots champions, unités invoquées, monstres et tours ; leurs priorités ne sont pas interchangeables.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P09-L0008 — Map1 — terrain, monde et mode — partie 1/2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MAP-Map1-SCOPE** — Map1 : Dater modes, variantes et disponibilité réelle — disponibilité 4.20 à classifier
- [ ] **MAP-Map1-TERRAIN** — Map1 : Importer/valider terrain, textures et minimap — disponibilité 4.20 à classifier
- [ ] **MAP-Map1-NAV** — Map1 : Qualifier navigation, collisions et hauteurs — disponibilité 4.20 à classifier
- [ ] **MAP-Map1-WORLD** — Map1 : Implémenter bâtiments, unités, objectifs et événements propres — disponibilité 4.20 à classifier
- [ ] **MAP-Map1-RULES** — Map1 : Implémenter économie, chronologie, objets et victoire par mode — disponibilité 4.20 à classifier
- [ ] **MAP-Map1-UI** — Map1 : Relier choix de carte/mode, HUD, annonces et chargement — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.

## P09-L0009 — Map1 — terrain, monde et mode — partie 2/2

**Prérequis du lot :** P09-L0008.

- [ ] **MAP-Map1-MATCH** — Map1 : Jouer victoire/défaite, reconnexion et résultats persistants — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P09-L0010 — Map8 — terrain, monde et mode — partie 1/2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MAP-Map8-SCOPE** — Map8 : Dater modes, variantes et disponibilité réelle — disponibilité 4.20 à classifier
- [ ] **MAP-Map8-TERRAIN** — Map8 : Importer/valider terrain, textures et minimap — disponibilité 4.20 à classifier
- [ ] **MAP-Map8-NAV** — Map8 : Qualifier navigation, collisions et hauteurs — disponibilité 4.20 à classifier
- [ ] **MAP-Map8-WORLD** — Map8 : Implémenter bâtiments, unités, objectifs et événements propres — disponibilité 4.20 à classifier
- [ ] **MAP-Map8-RULES** — Map8 : Implémenter économie, chronologie, objets et victoire par mode — disponibilité 4.20 à classifier
- [ ] **MAP-Map8-UI** — Map8 : Relier choix de carte/mode, HUD, annonces et chargement — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.

## P09-L0011 — Map8 — terrain, monde et mode — partie 2/2

**Prérequis du lot :** P09-L0010.

- [ ] **MAP-Map8-MATCH** — Map8 : Jouer victoire/défaite, reconnexion et résultats persistants — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P09-L0012 — Map11 — terrain, monde et mode — partie 1/2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MAP-Map11-SCOPE** — Map11 : Dater modes, variantes et disponibilité réelle — disponibilité 4.20 à classifier
- [ ] **MAP-Map11-TERRAIN** — Map11 : Importer/valider terrain, textures et minimap — disponibilité 4.20 à classifier
- [ ] **MAP-Map11-NAV** — Map11 : Qualifier navigation, collisions et hauteurs — disponibilité 4.20 à classifier
- [ ] **MAP-Map11-WORLD** — Map11 : Implémenter bâtiments, unités, objectifs et événements propres — disponibilité 4.20 à classifier
- [ ] **MAP-Map11-RULES** — Map11 : Implémenter économie, chronologie, objets et victoire par mode — disponibilité 4.20 à classifier
- [ ] **MAP-Map11-UI** — Map11 : Relier choix de carte/mode, HUD, annonces et chargement — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.

## P09-L0013 — Map11 — terrain, monde et mode — partie 2/2

**Prérequis du lot :** P09-L0012.

- [ ] **MAP-Map11-MATCH** — Map11 : Jouer victoire/défaite, reconnexion et résultats persistants — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P09-L0014 — Map12 — terrain, monde et mode — partie 1/2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MAP-Map12-SCOPE** — Map12 : Dater modes, variantes et disponibilité réelle — disponibilité 4.20 à classifier
- [ ] **MAP-Map12-TERRAIN** — Map12 : Importer/valider terrain, textures et minimap — disponibilité 4.20 à classifier
- [ ] **MAP-Map12-NAV** — Map12 : Qualifier navigation, collisions et hauteurs — disponibilité 4.20 à classifier
- [ ] **MAP-Map12-WORLD** — Map12 : Implémenter bâtiments, unités, objectifs et événements propres — disponibilité 4.20 à classifier
- [ ] **MAP-Map12-RULES** — Map12 : Implémenter économie, chronologie, objets et victoire par mode — disponibilité 4.20 à classifier
- [ ] **MAP-Map12-UI** — Map12 : Relier choix de carte/mode, HUD, annonces et chargement — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.

## P09-L0015 — Map12 — terrain, monde et mode — partie 2/2

**Prérequis du lot :** P09-L0014.

- [ ] **MAP-Map12-MATCH** — Map12 : Jouer victoire/défaite, reconnexion et résultats persistants — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

