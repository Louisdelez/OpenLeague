# P01 — Fixer le cadre et préparer le travail

[Revenir au plan principal](../OpenLeague_PLAN_DE_TRAVAIL_A_Z.md)

**Résultat à obtenir :** Un référentiel 4.20, des versions d’outils et un suivi de travail cohérents sont prêts.

**Condition de fin :** Périmètre daté, fonctions recensées, sources liées aux exigences, critères de fin définis, pointeur courant cohérent.

**Prérequis de phase :** Aucun.

Les cases sont une vue du registre des tâches. Reporter leur statut et leurs preuves dans le registre JSON pour conserver une seule source de suivi. Un lot contient au maximum six tâches.

## P01-L0001 — Recenser toutes les fonctions du client, du launcher, des modes et des services dans une matrice versionnée.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-01-001** — Fixer la date, la région et les numéros de build de la référence 4.20
- [ ] **OL-01-002** — Inventorier séparément patcher, client AIR, chargement, partie et après-partie
- [ ] **OL-01-003** — Énumérer profils, ligues, équipes classées, tutoriels, boutique et services de compte

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P01-L0002 — Relier chaque fonction à ses fichiers natifs, références, comportement attendu et preuve disponible.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-01-004** — Créer une table exigence → fichier natif → comportement attendu → preuve
- [ ] **OL-01-005** — Donner un SHA et une origine à chaque référence utilisée
- [ ] **OL-01-006** — Marquer les divergences entre sources client, Data Dragon et scripts communautaires

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P01-L0003 — Séparer les contenus sortis en 4.20, variantes inutilisées et éléments provenant d’autres versions.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-01-007** — Comparer le roster local aux 122 identifiants du catalogue officiel 4.20.1
- [ ] **OL-01-008** — Dater chaque carte et mode présent dans les fichiers sans le présumer activé
- [ ] **OL-01-009** — Classer chaque skin, objet et variante : sorti, interne, obsolète ou inconnu

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P01-L0004 — Définir les critères et scénarios d’acceptation avant de clôturer chaque fonction.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-01-010** — Définir les niveaux de preuve source, simulation, réseau, image, audio et acceptation
- [ ] **OL-01-011** — Définir une fiche de scénario avec entrée, résultat attendu et cas de refus
- [ ] **OL-01-012** — Rendre impossible la clôture avec une exigence obligatoire inconnue ou une preuve périmée

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P01-L0005 — Recenser également tutoriels, entraînement, profils, ligues, équipes classées, boutique de compte et écrans de patch lorsqu’ils appartiennent à 4.20.

**Prérequis du lot :** P01-L0001.

- [ ] **EX-01-01** — Recenser également tutoriels, entraînement, profils, ligues, équipes classées, boutique de compte et écrans de patch lorsqu’ils appartiennent à 4.20.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P01-L0006 — Ne pas assimiler une fonction des versions modernes à une fonction historique.

**Prérequis du lot :** P01-L0001.

- [ ] **EX-01-02** — Ne pas assimiler une fonction des versions modernes à une fonction historique.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P01-L0007 — Verrouiller Rust, Bevy, Tauri et le transport UDP actuellement présent ; évaluer toute nouvelle bibliothèque avant adoption.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-03-001** — Consigner les versions effectives Rust, Bevy, wgpu et Tauri verrouillées
- [ ] **OL-03-002** — Documenter les modifications locales de Bevy animation et rendu
- [ ] **OL-03-003** — Conserver le transport UDP existant et mesurer tout remplacement avant décision

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P01-L0008 — Définir temps fixe, unités, coordonnées, identifiants et propriété serveur des données.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-03-004** — Définir le tick, les horloges de partie, pause et présentation
- [ ] **OL-03-005** — Documenter les axes, unités, hauteurs, angles et transformations Blender → moteur
- [ ] **OL-03-006** — Définir les identifiants privés/publics et leur durée de vie

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P01-L0009 — Séparer simulation, rendu, réseau, import et données sans perdre les modifications existantes.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-03-007** — Séparer les contrats de simulation des politiques locales de présentation
- [ ] **OL-03-008** — Identifier les lectures compile-time et les dépendances aux chemins du développeur
- [ ] **OL-03-009** — Définir les interfaces versionnées entre données, simulation, client et services

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P01-L0010 — Construire outils de diagnostic, sauvegardes, traces et vérification des exécutables lancés.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-03-010** — Rendre le checkpoint courant unique et réconcilier les champs historiques contradictoires
- [ ] **OL-03-011** — Conserver les échecs et les preuves sans les republier comme résultats courants
- [ ] **OL-03-012** — Réduire les copies de rapports et produire un index de preuves consultable

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P01-L0011 — Stabiliser d’abord la pile réellement présente : Rust, Bevy et transport UDP propre ; Lightyear reste une option à évaluer, pas une dépendance installée annoncée.

**Prérequis du lot :** P01-L0007.

- [ ] **EX-03-01** — Stabiliser d’abord la pile réellement présente : Rust, Bevy et transport UDP propre ; Lightyear reste une option à évaluer, pas une dépendance installée annoncée.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P01-L0012 — Versionner schémas de données et protocole ; documenter les changements nécessaires à une migration.

**Prérequis du lot :** P01-L0007.

- [ ] **EX-03-02** — Versionner schémas de données et protocole ; documenter les changements nécessaires à une migration.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

