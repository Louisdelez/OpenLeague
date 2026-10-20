# P12 — Construire et vérifier la livraison autonome

[Revenir au plan principal](../OpenLeague_PLAN_DE_TRAVAIL_A_Z.md)

**Résultat à obtenir :** Le jeu livré s’installe et fonctionne hors de l’environnement de développement.

**Condition de fin :** Installation propre, paquet de ressources, mise à jour, réparation, sauvegarde/restauration, désinstallation et recette finale passent depuis le paquet livré.

**Prérequis de phase :** P11.

Les cases sont une vue du registre des tâches. Reporter leur statut et leurs preuves dans le registre JSON pour conserver une seule source de suivi. Un lot contient au maximum six tâches.

## P12-L0001 — Produire installeur Windows, paquet de ressources et serveur local autonomes.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-24-001** — Produire un build de livraison et son manifeste
- [ ] **OL-24-002** — Embarquer launcher, serveur et toutes les ressources requises
- [ ] **OL-24-003** — Créer installeur Windows et paquet autonome sans chemins de développement

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P12-L0002 — Achever mises à jour vérifiées, sauvegarde/restauration, réparation et désinstallation.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-24-004** — Qualifier mise à jour atomique et contrôle d’intégrité
- [ ] **OL-24-005** — Qualifier réparation et sauvegarde/restauration
- [ ] **OL-24-006** — Qualifier désinstallation sans effacer les sauvegardes utilisateur sans choix explicite

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P12-L0003 — Tester installation propre, relancement du jeu, mise à jour et récupération d’une installation endommagée.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-24-007** — Installer sur un compte Windows propre
- [ ] **OL-24-008** — Tester installation hors ligne après récupération des packs
- [ ] **OL-24-009** — Tester fichiers manquants, corrompus et mise à jour interrompue

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P12-L0004 — Fournir commandes de lancement, contrôles, documentation et registre final des preuves.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-24-010** — Rédiger installation, lancement, commandes et dépannage
- [ ] **OL-24-011** — Fournir registre des sources, reconstructions et preuves
- [ ] **OL-24-012** — Vérifier notices et périmètre de diffusion avant toute distribution autorisée

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P12-L0005 — Rejouer l’acceptation finale depuis le paquet livré et vérifier toutes les empreintes.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-24-013** — Rejouer toute l’acceptation depuis le paquet livré
- [ ] **OL-24-014** — Vérifier qu’aucune tâche obligatoire ou anomalie majeure reste ouverte
- [ ] **OL-24-015** — Clôturer seulement après acceptation technique et humaine documentée

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P12-L0006 — Vérifier ressources et chemins indépendants des répertoires de développement ; ne pas distribuer un exécutable lié au seul PC actuel.

**Prérequis du lot :** P12-L0001.

- [ ] **EX-24-01** — Vérifier ressources et chemins indépendants des répertoires de développement ; ne pas distribuer un exécutable lié au seul PC actuel.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

