# P10 — Reconstruire le client historique et ses services locaux

[Revenir au plan principal](../OpenLeague_PLAN_DE_TRAVAIL_A_Z.md)

**Résultat à obtenir :** Le patcher et les parcours du client AIR historique sont reproduits dans le launcher Tauri.

**Condition de fin :** Comptes, collection, social, salons, sélection, progression, erreurs, lancement et retour de partie utilisent des services locaux réels et persistants.

**Prérequis de phase :** P03.

Les cases sont une vue du registre des tâches. Reporter leur statut et leurs preuves dans le registre JSON pour conserver une seule source de suivi. Un lot contient au maximum six tâches.

## P10-L0001 — Reconstruire chaque écran historique, ses transitions, textes, images, sons et états.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-18-001** — Établir la liste distincte des écrans du patcher et du client AIR
- [ ] **OL-18-002** — Extraire images, polices, sons et transitions des SWF natifs
- [ ] **OL-18-003** — Reproduire chaque écran en Tauri avec comparaison à taille identique

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P10-L0002 — Achever connexion, profil, progression de compte, collection, pages et paramètres.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-18-004** — Créer connexion locale et erreurs de session
- [ ] **OL-18-005** — Achever profil, niveau de compte et progression
- [ ] **OL-18-006** — Achever collection, pages et paramètres persistants

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P10-L0003 — Achever amis, présence, invitations, salons, chat, files et sélection de champion.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-18-007** — Achever amis, présence et invitations
- [ ] **OL-18-008** — Achever salons, chat et préparation d’équipe
- [ ] **OL-18-009** — Achever files, bannissements, sélection, verrouillage et délais historiques

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P10-L0004 — Achever achat/déblocage et monnaie du serveur local avec persistance et règles vérifiées.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-18-010** — Qualifier catalogue de compte et monnaies locales
- [ ] **OL-18-011** — Achever déblocage des champions, skins et pages
- [ ] **OL-18-012** — Qualifier transactions, inventaire et reprise après interruption

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P10-L0005 — Achever validation des fichiers, réparation, mise à jour, lancement et retour après partie.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-18-013** — Achever vérification et réparation des fichiers
- [ ] **OL-18-014** — Achever téléchargement interrompu, mise à jour et retour arrière
- [ ] **OL-18-015** — Qualifier lancement, match déjà actif, crash et retour en fin de partie

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P10-L0006 — Transmettre champion, skin, runes, maîtrises, sorts invocateur, équipe et mode au moteur.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-18-016** — Transmettre skin, runes et maîtrises en plus du champion
- [ ] **OL-18-017** — Transmettre équipe, carte, mode et sorts invocateur
- [ ] **OL-18-018** — Contrôler la cohérence de bout en bout sur plusieurs clients

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P10-L0007 — Séparer le patcher historique et le client AIR historique dans l’inventaire des écrans.

**Prérequis du lot :** P10-L0001.

- [ ] **EX-18-01** — Séparer le patcher historique et le client AIR historique dans l’inventaire des écrans.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P10-L0008 — Prévoir les erreurs de connexion, maintenance, téléchargement interrompu, mauvaise version, partie déjà active et retour après crash.

**Prérequis du lot :** P10-L0001.

- [ ] **EX-18-02** — Prévoir les erreurs de connexion, maintenance, téléchargement interrompu, mauvaise version, partie déjà active et retour après crash.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P10-L0009 — Implémenter stockage durable, comptes, sessions, authentification et permissions du serveur local.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-19-001** — Créer schéma de stockage et migrations des comptes locaux
- [ ] **OL-19-002** — Achever authentification, sessions expirées et permissions
- [ ] **OL-19-003** — Tester sauvegarde/restauration sans perdre la progression

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P10-L0010 — Implémenter collections, monnaies, déblocages, statistiques et historique des parties.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-19-004** — Persister collections, monnaies et déblocages
- [ ] **OL-19-005** — Persister statistiques et historique des parties
- [ ] **OL-19-006** — Garantir transactions et idempotence des récompenses

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P10-L0011 — Implémenter présence, amis, salons et chat avec validation des entrées.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-19-007** — Persister relations d’amis et présence
- [ ] **OL-19-008** — Implémenter salons et chat avec bornes et validation
- [ ] **OL-19-009** — Tester déconnexion/reconnexion et permissions des participants

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P10-L0012 — Implémenter files, équipes, allocation de parties, annulation et gestion des joueurs absents.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-19-010** — Implémenter files et allocation de match local
- [ ] **OL-19-011** — Implémenter constitution et annulation des équipes
- [ ] **OL-19-012** — Traiter sélection abandonnée, joueur absent et session orpheline

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P10-L0013 — Qualifier règles de classement, ligues et progression natives puis porter celles du référentiel.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-19-013** — Documenter ce qui est connu des ligues et équipes classées 4.20
- [ ] **OL-19-014** — Définir l’équivalent local des services serveur non récupérés
- [ ] **OL-19-015** — Implémenter progression et classement retenus sans prétendre posséder les algorithmes internes Riot

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P10-L0014 — Définir les services locaux équivalents ; les règles internes des serveurs Riot absentes ne doivent pas être présentées comme récupérées.

**Prérequis du lot :** P10-L0009.

- [ ] **EX-19-01** — Définir les services locaux équivalents ; les règles internes des serveurs Riot absentes ne doivent pas être présentées comme récupérées.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P10-L0015 — Ajouter transactions, migrations, sauvegarde/restauration, sessions expirées, validation d’entrée et permissions.

**Prérequis du lot :** P10-L0009.

- [ ] **EX-19-02** — Ajouter transactions, migrations, sauvegarde/restauration, sessions expirées, validation d’entrée et permissions.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

