# P02 — Récupérer et réparer les ressources

[Revenir au plan principal](../OpenLeague_PLAN_DE_TRAVAIL_A_Z.md)

**Résultat à obtenir :** Les ressources nécessaires sont identifiées, importables et traçables.

**Condition de fin :** Chaque ressource requise est exploitable ou garde une anomalie bloquante explicite ; chaque réparation et reconstruction est tracée.

**Prérequis de phase :** P01.

Les cases sont une vue du registre des tâches. Reporter leur statut et leurs preuves dans le registre JSON pour conserver une seule source de suivi. Un lot contient au maximum six tâches.

## P02-L0001 — Inventorier fichiers, formats, dépendances et empreintes du client et des ressources serveur disponibles.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-02-001** — Conserver l’inventaire du client original et identifier ses archives imbriquées
- [ ] **OL-02-002** — Inventorier séparément scripts serveur fournis, exports et données du client
- [ ] **OL-02-003** — Étendre les empreintes aux sources natives effectivement consommées par les imports

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0002 — Qualifier les fichiers vides, références non résolues et différences entre exports et sources.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-02-004** — Qualifier individuellement les 67 fichiers natifs de taille nulle
- [ ] **OL-02-005** — Ouvrir et valider les en-têtes, tailles et dépendances des formats binaires utiles
- [ ] **OL-02-006** — Recenser textures, matériaux, os, clips et événements non résolus

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0003 — Rechercher les originaux 4.20 manquants dans les archives et communautés avec preuve de version.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-02-007** — Chercher les ressources manquantes dans les archives natives déjà présentes
- [ ] **OL-02-008** — Consulter les références communautaires fournies en exigeant version et provenance
- [ ] **OL-02-009** — Comparer toute récupération communautaire aux contrats 4.20 avant adoption

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0004 — Restaurer modèles, UV, textures, squelettes, animations et sons ; étiqueter toute reconstruction.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-02-010** — Réparer les UV et textures avec sauvegarde des originaux
- [ ] **OL-02-011** — Réparer rigs et animations avec contrôle des os et événements
- [ ] **OL-02-012** — Reconstituer seulement les dépendances réellement absentes et étiqueter la reconstruction
- [ ] **OL-02-013** — Comparer les réparations dans Blender et dans la fenêtre du jeu

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0005 — Conserver les originaux et produire des imports reproductibles avec rapports par ressource.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-02-014** — Rendre chaque conversion native → ressource moteur reproductible
- [ ] **OL-02-015** — Déclarer chaque nouvelle ressource et son SHA dans un pack de distribution
- [ ] **OL-02-016** — Tester un import depuis une copie propre des seules entrées déclarées

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0006 — Garder pour chaque ressource provenance, SHA-256, format, version, dépendances et statut : native, réparée ou reconstruite.

**Prérequis du lot :** P02-L0001.

- [ ] **EX-02-01** — Garder pour chaque ressource provenance, SHA-256, format, version, dépendances et statut : native, réparée ou reconstruite.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P02-L0007 — Comparer une texture reconstruite et son matériau sous le même angle et éclairage que la référence ; une génération IA seule ne prouve pas la fidélité.

**Prérequis du lot :** P02-L0001.

- [ ] **EX-02-02** — Comparer une texture reconstruite et son matériau sous le même angle et éclairage que la référence ; une génération IA seule ne prouve pas la fidélité.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P02-L0008 — Qualifier les animations vides et écarts d’export, puis récupérer ou reconstruire celles réellement nécessaires.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-14-013** — Réconcilier l’ancien bilan de 56 rôles avec le contrôle actuel de huit rôles
- [ ] **OL-14-014** — Classifier les dix affectations actuellement absentes sans inventer de clip
- [ ] **OL-14-015** — Récupérer ou reconstruire les clips obligatoires puis tester les transitions

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0009 — Ressource vide : Logs\Network Logs\2016-04-06T02-13-19_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-001-CLASSIFY** — Logs\Network Logs\2016-04-06T02-13-19_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-001-RESOLVE** — Logs\Network Logs\2016-04-06T02-13-19_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0010 — Ressource vide : Logs\Network Logs\2016-04-14T00-48-54_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-002-CLASSIFY** — Logs\Network Logs\2016-04-14T00-48-54_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-002-RESOLVE** — Logs\Network Logs\2016-04-14T00-48-54_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0011 — Ressource vide : Logs\Network Logs\2016-04-15T01-35-35_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-003-CLASSIFY** — Logs\Network Logs\2016-04-15T01-35-35_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-003-RESOLVE** — Logs\Network Logs\2016-04-15T01-35-35_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0012 — Ressource vide : Logs\Network Logs\2016-04-15T01-36-01_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-004-CLASSIFY** — Logs\Network Logs\2016-04-15T01-36-01_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-004-RESOLVE** — Logs\Network Logs\2016-04-15T01-36-01_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0013 — Ressource vide : Logs\Network Logs\2016-04-15T01-38-49_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-005-CLASSIFY** — Logs\Network Logs\2016-04-15T01-38-49_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-005-RESOLVE** — Logs\Network Logs\2016-04-15T01-38-49_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0014 — Ressource vide : Logs\Network Logs\2016-04-15T01-39-44_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-006-CLASSIFY** — Logs\Network Logs\2016-04-15T01-39-44_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-006-RESOLVE** — Logs\Network Logs\2016-04-15T01-39-44_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0015 — Ressource vide : Logs\Network Logs\2016-04-15T01-41-33_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-007-CLASSIFY** — Logs\Network Logs\2016-04-15T01-41-33_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-007-RESOLVE** — Logs\Network Logs\2016-04-15T01-41-33_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0016 — Ressource vide : Logs\Network Logs\2016-04-15T01-49-08_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-008-CLASSIFY** — Logs\Network Logs\2016-04-15T01-49-08_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-008-RESOLVE** — Logs\Network Logs\2016-04-15T01-49-08_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0017 — Ressource vide : Logs\Network Logs\2016-04-15T01-49-36_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-009-CLASSIFY** — Logs\Network Logs\2016-04-15T01-49-36_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-009-RESOLVE** — Logs\Network Logs\2016-04-15T01-49-36_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0018 — Ressource vide : Logs\Network Logs\2016-04-15T02-08-27_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-010-CLASSIFY** — Logs\Network Logs\2016-04-15T02-08-27_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-010-RESOLVE** — Logs\Network Logs\2016-04-15T02-08-27_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0019 — Ressource vide : Logs\Network Logs\2016-04-15T02-20-31_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-011-CLASSIFY** — Logs\Network Logs\2016-04-15T02-20-31_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-011-RESOLVE** — Logs\Network Logs\2016-04-15T02-20-31_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0020 — Ressource vide : Logs\Network Logs\2016-04-15T02-30-51_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-012-CLASSIFY** — Logs\Network Logs\2016-04-15T02-30-51_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-012-RESOLVE** — Logs\Network Logs\2016-04-15T02-30-51_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0021 — Ressource vide : Logs\Network Logs\2016-04-15T02-33-41_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-013-CLASSIFY** — Logs\Network Logs\2016-04-15T02-33-41_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-013-RESOLVE** — Logs\Network Logs\2016-04-15T02-33-41_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0022 — Ressource vide : Logs\Network Logs\2016-04-26T01-06-48_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-014-CLASSIFY** — Logs\Network Logs\2016-04-26T01-06-48_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-014-RESOLVE** — Logs\Network Logs\2016-04-26T01-06-48_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0023 — Ressource vide : Logs\Network Logs\2016-04-26T01-24-01_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-015-CLASSIFY** — Logs\Network Logs\2016-04-26T01-24-01_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-015-RESOLVE** — Logs\Network Logs\2016-04-26T01-24-01_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0024 — Ressource vide : Logs\Network Logs\2016-04-26T01-24-59_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-016-CLASSIFY** — Logs\Network Logs\2016-04-26T01-24-59_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-016-RESOLVE** — Logs\Network Logs\2016-04-26T01-24-59_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0025 — Ressource vide : Logs\Network Logs\2018-07-07T21-34-59_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-017-CLASSIFY** — Logs\Network Logs\2018-07-07T21-34-59_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-017-RESOLVE** — Logs\Network Logs\2018-07-07T21-34-59_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0026 — Ressource vide : Logs\Network Logs\2018-07-07T21-46-49_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-018-CLASSIFY** — Logs\Network Logs\2018-07-07T21-46-49_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-018-RESOLVE** — Logs\Network Logs\2018-07-07T21-46-49_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0027 — Ressource vide : Logs\Network Logs\2018-07-07T22-14-06_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-019-CLASSIFY** — Logs\Network Logs\2018-07-07T22-14-06_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-019-RESOLVE** — Logs\Network Logs\2018-07-07T22-14-06_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0028 — Ressource vide : Logs\Network Logs\2018-07-08T01-48-38_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-020-CLASSIFY** — Logs\Network Logs\2018-07-08T01-48-38_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-020-RESOLVE** — Logs\Network Logs\2018-07-08T01-48-38_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0029 — Ressource vide : Logs\Network Logs\2020-02-24T18-03-37_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-021-CLASSIFY** — Logs\Network Logs\2020-02-24T18-03-37_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-021-RESOLVE** — Logs\Network Logs\2020-02-24T18-03-37_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0030 — Ressource vide : Logs\Network Logs\2020-02-24T18-05-59_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-022-CLASSIFY** — Logs\Network Logs\2020-02-24T18-05-59_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-022-RESOLVE** — Logs\Network Logs\2020-02-24T18-05-59_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0031 — Ressource vide : Logs\Network Logs\2020-02-24T20-07-23_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-023-CLASSIFY** — Logs\Network Logs\2020-02-24T20-07-23_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-023-RESOLVE** — Logs\Network Logs\2020-02-24T20-07-23_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0032 — Ressource vide : Logs\Network Logs\2026-04-18T12-45-40_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-024-CLASSIFY** — Logs\Network Logs\2026-04-18T12-45-40_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-024-RESOLVE** — Logs\Network Logs\2026-04-18T12-45-40_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0033 — Ressource vide : Logs\Network Logs\2026-04-18T12-58-46_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-025-CLASSIFY** — Logs\Network Logs\2026-04-18T12-58-46_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-025-RESOLVE** — Logs\Network Logs\2026-04-18T12-58-46_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0034 — Ressource vide : Logs\Network Logs\2026-04-25T15-32-30_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-026-CLASSIFY** — Logs\Network Logs\2026-04-25T15-32-30_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-026-RESOLVE** — Logs\Network Logs\2026-04-25T15-32-30_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0035 — Ressource vide : Logs\Network Logs\2026-04-25T16-12-34_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-027-CLASSIFY** — Logs\Network Logs\2026-04-25T16-12-34_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-027-RESOLVE** — Logs\Network Logs\2026-04-25T16-12-34_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0036 — Ressource vide : Logs\Network Logs\2026-04-25T16-17-47_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-028-CLASSIFY** — Logs\Network Logs\2026-04-25T16-17-47_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-028-RESOLVE** — Logs\Network Logs\2026-04-25T16-17-47_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0037 — Ressource vide : Logs\Network Logs\2026-04-25T21-19-23_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-029-CLASSIFY** — Logs\Network Logs\2026-04-25T21-19-23_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-029-RESOLVE** — Logs\Network Logs\2026-04-25T21-19-23_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0038 — Ressource vide : Logs\Network Logs\2026-04-25T21-23-48_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-030-CLASSIFY** — Logs\Network Logs\2026-04-25T21-23-48_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-030-RESOLVE** — Logs\Network Logs\2026-04-25T21-23-48_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0039 — Ressource vide : Logs\Network Logs\2026-04-26T15-47-54_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-031-CLASSIFY** — Logs\Network Logs\2026-04-26T15-47-54_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-031-RESOLVE** — Logs\Network Logs\2026-04-26T15-47-54_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0040 — Ressource vide : RADS\first_time

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-032-CLASSIFY** — RADS\first_time : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-032-RESOLVE** — RADS\first_time : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0041 — Ressource vide : RADS\projects\lol_launcher\releases\0.0.0.227\S_OK

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-033-CLASSIFY** — RADS\projects\lol_launcher\releases\0.0.0.227\S_OK : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-033-RESOLVE** — RADS\projects\lol_launcher\releases\0.0.0.227\S_OK : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0042 — Ressource vide : RADS\projects\lol_patcher\releases\0.0.0.11\S_OK

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-034-CLASSIFY** — RADS\projects\lol_patcher\releases\0.0.0.11\S_OK : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-034-RESOLVE** — RADS\projects\lol_patcher\releases\0.0.0.11\S_OK : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0043 — Ressource vide : RADS\projects\lol_patcher\releases\0.0.0.11\deploy\data\config.prop

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-035-CLASSIFY** — RADS\projects\lol_patcher\releases\0.0.0.11\deploy\data\config.prop : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-035-RESOLVE** — RADS\projects\lol_patcher\releases\0.0.0.11\deploy\data\config.prop : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0044 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\S_OK

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-036-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\S_OK : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-036-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\S_OK : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0045 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\Localization_Errors.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-037-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\Localization_Errors.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-037-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\Localization_Errors.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0046 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\AzirSoldier\Skins\Base\Animations\AzirSoldier_Idle2.anm

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-038-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\AzirSoldier\Skins\Base\Animations\AzirSoldier_Idle2.anm : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-038-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\AzirSoldier\Skins\Base\Animations\AzirSoldier_Idle2.anm : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0047 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\AzirSoldier\Skins\Base\Animations\_1.anm

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-039-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\AzirSoldier\Skins\Base\Animations\_1.anm : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-039-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\AzirSoldier\Skins\Base\Animations\_1.anm : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0048 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\braum_base_e_shield_break_02.scb

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-040-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\braum_base_e_shield_break_02.scb : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-040-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\braum_base_e_shield_break_02.scb : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0049 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\braum_base_q_lamb_mis.scb

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-041-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\braum_base_q_lamb_mis.scb : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-041-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\braum_base_q_lamb_mis.scb : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0050 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\Braum_Base_R_ice_shard .anm

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-042-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\Braum_Base_R_ice_shard .anm : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-042-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\Braum_Base_R_ice_shard .anm : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0051 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\Braum_Base_R_ice_shard .skl

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-043-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\Braum_Base_R_ice_shard .skl : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-043-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\Braum_Base_R_ice_shard .skl : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0052 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\Braum_Base_R_ice_shard .skn

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-044-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\Braum_Base_R_ice_shard .skn : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-044-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Base\Particles\Braum_Base_R_ice_shard .skn : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0053 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Skin01\Particles\braum_Skin01_e_shield_break_02.scb

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-045-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Skin01\Particles\braum_Skin01_e_shield_break_02.scb : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-045-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Skin01\Particles\braum_Skin01_e_shield_break_02.scb : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0054 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Skin01\Particles\braum_Skin01_q_lamb_mis.scb

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-046-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Skin01\Particles\braum_Skin01_q_lamb_mis.scb : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-046-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Braum\Skins\Skin01\Particles\braum_Skin01_q_lamb_mis.scb : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0055 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Chogath\Sounds\Skin02\Sounds\Chogath_Skin02_EventLookupTable.csv

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-047-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Chogath\Sounds\Skin02\Sounds\Chogath_Skin02_EventLookupTable.csv : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-047-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Chogath\Sounds\Skin02\Sounds\Chogath_Skin02_EventLookupTable.csv : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0056 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\KogMaw\Skins\Skin08\Animations\Kogmaw_Skin08_ Rumble.anm

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-048-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\KogMaw\Skins\Skin08\Animations\Kogmaw_Skin08_ Rumble.anm : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-048-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\KogMaw\Skins\Skin08\Animations\Kogmaw_Skin08_ Rumble.anm : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0057 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\KogMaw\Skins\Skin08\Animations\KogMaw_skin08_TurnBase.anm

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-049-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\KogMaw\Skins\Skin08\Animations\KogMaw_skin08_TurnBase.anm : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-049-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\KogMaw\Skins\Skin08\Animations\KogMaw_skin08_TurnBase.anm : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0058 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Maokai\Skins\Base\Particles\Maokai_Base_W_Rootsup.skl

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-050-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Maokai\Skins\Base\Particles\Maokai_Base_W_Rootsup.skl : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-050-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Maokai\Skins\Base\Particles\Maokai_Base_W_Rootsup.skl : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0059 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Maokai\Skins\Base\Particles\Maokai_Base_W_Rootsup.skn

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-051-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Maokai\Skins\Base\Particles\Maokai_Base_W_Rootsup.skn : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-051-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Maokai\Skins\Base\Particles\Maokai_Base_W_Rootsup.skn : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0060 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Rumble\Skins\skin03\Particles\rumble_skin03_ult_ground_hold.scb

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-052-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Rumble\Skins\skin03\Particles\rumble_skin03_ult_ground_hold.scb : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-052-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\Rumble\Skins\skin03\Particles\rumble_skin03_ult_ground_hold.scb : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0061 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\ZyraThornPlant\Animations\Zyra_Plant_Blossom_Skin02_Buffbones.anm

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-053-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\ZyraThornPlant\Animations\Zyra_Plant_Blossom_Skin02_Buffbones.anm : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-053-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Characters\ZyraThornPlant\Animations\Zyra_Plant_Blossom_Skin02_Buffbones.anm : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0062 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_AP_healthIcon.skl

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-054-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_AP_healthIcon.skl : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-054-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_AP_healthIcon.skl : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0063 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_AP_healthIcon.skn

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-055-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_AP_healthIcon.skn : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-055-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_AP_healthIcon.skn : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0064 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_AP_healthIcon_geo.skl

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-056-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_AP_healthIcon_geo.skl : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-056-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_AP_healthIcon_geo.skl : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0065 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_AP_healthIcon_geo.skn

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-057-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_AP_healthIcon_geo.skn : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-057-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_AP_healthIcon_geo.skn : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0066 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_healingIcon_idle.anm

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-058-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_healingIcon_idle.anm : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-058-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\HA_healingIcon_idle.anm : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0067 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\SRU_chaos_mm_death_melee_anim.anm

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-059-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\SRU_chaos_mm_death_melee_anim.anm : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-059-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\SRU_chaos_mm_death_melee_anim.anm : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0068 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\SRU_Gromp_Death_Mesh_explo3.anm

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-060-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\SRU_Gromp_Death_Mesh_explo3.anm : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-060-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\SRU_Gromp_Death_Mesh_explo3.anm : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0069 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\SRU_order_mm_death_base_anim.anm.anm

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-061-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\SRU_order_mm_death_base_anim.anm.anm : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-061-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\SRU_order_mm_death_base_anim.anm.anm : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0070 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\SRU_pallybase_nexus_crystalEmitter.anm

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-062-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\SRU_pallybase_nexus_crystalEmitter.anm : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-062-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Particles\SRU_pallybase_nexus_crystalEmitter.anm : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0071 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\LEVELS\map11\Light.dat

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-063-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\LEVELS\map11\Light.dat : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-063-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\LEVELS\map11\Light.dat : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0072 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\Logs\Network Logs\2018-07-03T09-58-49_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-064-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\Logs\Network Logs\2018-07-03T09-58-49_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-064-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\Logs\Network Logs\2018-07-03T09-58-49_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0073 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\Logs\Network Logs\2018-07-03T09-59-16_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-065-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\Logs\Network Logs\2018-07-03T09-59-16_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-065-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\Logs\Network Logs\2018-07-03T09-59-16_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0074 — Ressource vide : RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\Logs\Network Logs\2018-07-03T10-00-03_netlog.txt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-066-CLASSIFY** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\Logs\Network Logs\2018-07-03T10-00-03_netlog.txt : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-066-RESOLVE** — RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\Logs\Network Logs\2018-07-03T10-00-03_netlog.txt : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0075 — Ressource vide : RADS\system\user.cfg

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **EMPTY-067-CLASSIFY** — RADS\system\user.cfg : identifier consommateurs et caractère intentionnel/obligatoire du fichier vide — disponibilité 4.20 à classifier
- [ ] **EMPTY-067-RESOLVE** — RADS\system\user.cfg : récupérer/réparer si requis, sinon justifier son classement ; vérifier les consommateurs — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (asset) : Ressource native ou reconstruction tracée ; dépendances résolues ; import reproductible ; présence dans le pack et rendu ordinaire vérifiés.

## P02-L0076 — Animation azir — rôle spell1

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ROLE-01** — azir, spell1 : déterminer si clip absent, rôle passif, alias ou liaison particulière ; résoudre puis observer

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P02-L0077 — Animation fiora — rôle spell2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ROLE-02** — fiora, spell2 : déterminer si clip absent, rôle passif, alias ou liaison particulière ; résoudre puis observer

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P02-L0078 — Animation fiora — rôle spell3

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ROLE-03** — fiora, spell3 : déterminer si clip absent, rôle passif, alias ou liaison particulière ; résoudre puis observer

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P02-L0079 — Animation garen — rôle spell2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ROLE-04** — garen, spell2 : déterminer si clip absent, rôle passif, alias ou liaison particulière ; résoudre puis observer

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P02-L0080 — Animation karma — rôle spell4

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ROLE-05** — karma, spell4 : déterminer si clip absent, rôle passif, alias ou liaison particulière ; résoudre puis observer

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P02-L0081 — Animation khazix — rôle spell4

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ROLE-06** — khazix, spell4 : déterminer si clip absent, rôle passif, alias ou liaison particulière ; résoudre puis observer

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P02-L0082 — Animation quinn — rôle spell2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ROLE-07** — quinn, spell2 : déterminer si clip absent, rôle passif, alias ou liaison particulière ; résoudre puis observer

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P02-L0083 — Animation varus — rôle spell2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ROLE-08** — varus, spell2 : déterminer si clip absent, rôle passif, alias ou liaison particulière ; résoudre puis observer

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P02-L0084 — Animation vayne — rôle spell2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ROLE-09** — vayne, spell2 : déterminer si clip absent, rôle passif, alias ou liaison particulière ; résoudre puis observer

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P02-L0085 — Animation vayne — rôle spell4

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ROLE-10** — vayne, spell4 : déterminer si clip absent, rôle passif, alias ou liaison particulière ; résoudre puis observer

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P02-L0086 — Référence fournie : bevyengine/bevy

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **REF-01-AUDIT** — bevyengine/bevy : vérifier les extraits récupérés au commit 90942be05dcb7bdafd1935c61dcb486156d3937f et leur utilité réelle
- [ ] **REF-01-ADOPT** — bevyengine/bevy : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0087 — Référence fournie : chrisgliddon/bevy-skills

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **REF-02-AUDIT** — chrisgliddon/bevy-skills : vérifier les extraits récupérés au commit b1b4da5744ebbd5c526342b2351967411cd5ca61 et leur utilité réelle
- [ ] **REF-02-ADOPT** — chrisgliddon/bevy-skills : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0088 — Référence fournie : ChronoCoders/spawn

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **REF-03-AUDIT** — ChronoCoders/spawn : vérifier les extraits récupérés au commit 34a4c4b0e9cb71cf4d016cc5e15a3a418fbaf523 et leur utilité réelle
- [ ] **REF-03-ADOPT** — ChronoCoders/spawn : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0089 — Référence fournie : criticaldeveloper/codex-game-studio

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **REF-04-AUDIT** — criticaldeveloper/codex-game-studio : vérifier les extraits récupérés au commit 1452f7a7240db07cd3cb9decda062da54d3d3438 et leur utilité réelle
- [ ] **REF-04-ADOPT** — criticaldeveloper/codex-game-studio : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0090 — Référence fournie : dimforge/rapier

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **REF-05-AUDIT** — dimforge/rapier : vérifier les extraits récupérés au commit 846c463e47ef654d6a6ce6fa0e455f3a1e98c2ec et leur utilité réelle
- [ ] **REF-05-ADOPT** — dimforge/rapier : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0091 — Référence fournie : gfx-rs/wgpu

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **REF-06-AUDIT** — gfx-rs/wgpu : vérifier les extraits récupérés au commit dd033bfb7fb3690eb2e80a971877a1ef8ecabe59 et leur utilité réelle
- [ ] **REF-06-ADOPT** — gfx-rs/wgpu : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0092 — Référence fournie : ketd/AnvilKit

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **REF-07-AUDIT** — ketd/AnvilKit : vérifier les extraits récupérés au commit 62ea6b1a11f6a722f655926f65b9c8926eb95430 et leur utilité réelle
- [ ] **REF-07-ADOPT** — ketd/AnvilKit : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0093 — Référence fournie : leonardomso/rust-skills

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **REF-08-AUDIT** — leonardomso/rust-skills : vérifier les extraits récupérés au commit fd2a861ab0406a4ac536a55274d14ea6fd1ca9c9 et leur utilité réelle
- [ ] **REF-08-ADOPT** — leonardomso/rust-skills : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0094 — Référence fournie : Luminary-Analytics/plinth

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **REF-09-AUDIT** — Luminary-Analytics/plinth : vérifier les extraits récupérés au commit afca7930192c5b3979abf03eafcd236287a655fc et leur utilité réelle
- [ ] **REF-09-ADOPT** — Luminary-Analytics/plinth : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0095 — Référence fournie : mike007jd/game-superpowers

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **REF-10-AUDIT** — mike007jd/game-superpowers : vérifier les extraits récupérés au commit 3925ffb92d405b34fd1be23fde79fec3f4dc6af0 et leur utilité réelle
- [ ] **REF-10-ADOPT** — mike007jd/game-superpowers : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0096 — Référence fournie : poorvith-mp/skills-gamedev

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **REF-11-AUDIT** — poorvith-mp/skills-gamedev : vérifier les extraits récupérés au commit e8b87e9086fbf2322b1c216c2d2de85954bf4015 et leur utilité réelle
- [ ] **REF-11-ADOPT** — poorvith-mp/skills-gamedev : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P02-L0097 — Référence fournie : qiuaoru-coder/game-design-agent-skills

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **REF-12-AUDIT** — qiuaoru-coder/game-design-agent-skills : vérifier les extraits récupérés au commit 29e8c759ca26c6bd4f337744b647dc728bf322b6 et leur utilité réelle
- [ ] **REF-12-ADOPT** — qiuaoru-coder/game-design-agent-skills : appliquer les recommandations utiles à un livrable précis, ou documenter pourquoi aucune dépendance supplémentaire n’est nécessaire

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

