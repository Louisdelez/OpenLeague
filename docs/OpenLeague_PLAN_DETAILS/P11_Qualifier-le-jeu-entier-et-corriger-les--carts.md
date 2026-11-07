# P11 — Qualifier le jeu entier et corriger les écarts

[Revenir au plan principal](../OpenLeague_PLAN_DE_TRAVAIL_A_Z.md)

**Résultat à obtenir :** La couverture fonctionnelle, les interactions, la fidélité et les budgets techniques sont vérifiés.

**Condition de fin :** Tous les kits requis et les parcours passent la recette ; aucun défaut bloquant ni comportement obligatoire inconnu ; validation humaine de fidélité consignée.

**Prérequis de phase :** P06, P07, P08, P09, P10.

Les cases sont une vue du registre des tâches. Reporter leur statut et leurs preuves dans le registre JSON pour conserver une seule source de suivi. Un lot contient au maximum six tâches.

## P11-L0001 — Construire outils de diagnostic, sauvegardes, traces et vérification des exécutables lancés.

**Prérequis du lot :** P01-L0010.

- [ ] **OL-03-013** — Évaluer le candidat d’archives de tests et son graphe Cargo avant toute installation

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0002 — Vérifier chaque champion séparément puis en affrontements avec les interactions pertinentes.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-06-013** — Exécuter les scénarios complets de chaque fiche champion
- [ ] **OL-06-014** — Exécuter les interactions par familles de mécanismes
- [ ] **OL-06-015** — Fermer les erreurs de ciblage, rang, visibilité et annulation trouvées en affrontement

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0003 — Qualifier les fonctions natives de spectateur et leur délai, caméra, informations et commandes.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-21-001** — Dater les fonctions de spectateur disponibles en 4.20
- [ ] **OL-21-002** — Qualifier délai, caméra et champs visibles
- [ ] **OL-21-003** — Distinguer les outils de diagnostic ajoutés des fonctions historiques

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0004 — Porter le spectateur et la navigation entre joueurs/équipes.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-21-004** — Implémenter abonnement spectateur avec délai autoritaire
- [ ] **OL-21-005** — Achever changement de joueur et vue d’équipe
- [ ] **OL-21-006** — Qualifier scoreboard, HUD et commandes du spectateur

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0005 — Mettre en place les enregistrements nécessaires à la reproduction des bugs et aux vérifications.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-21-007** — Enregistrer commandes, seed, ticks et versions pour reproduction
- [ ] **OL-21-008** — Rejouer un incident avec contrôles d’intégrité
- [ ] **OL-21-009** — Qualifier stockage borné, fichier tronqué et fin de session

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0006 — Qualifier les fonctions de replay de la version avant toute revendication de fidélité historique.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-21-010** — Vérifier les capacités de replay réellement présentes en 4.20
- [ ] **OL-21-011** — Relier les modules natifs déjà étudiés à un usage complet démontré
- [ ] **OL-21-012** — Tester un parcours complet ou conserver explicitement l’absence de preuve

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0007 — L’enregistrement de diagnostic peut être ajouté ; qualifier séparément les fonctionnalités de replay réellement présentes en 4.20.

**Prérequis du lot :** P11-L0003.

- [ ] **EX-21-01** — L’enregistrement de diagnostic peut être ajouté ; qualifier séparément les fonctionnalités de replay réellement présentes en 4.20.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0008 — Achever textes, polices, glyphes, voix et formats des langues présentes.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-22-001** — Inventorier toutes les langues réellement fournies par la référence
- [ ] **OL-22-002** — Achever chaînes, pluriels, nombres, polices et glyphes
- [ ] **OL-22-003** — Vérifier débordements, caractères manquants et textes de toutes les interfaces

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0009 — Achever résolution, plein écran, redimensionnement, qualité graphique et sauvegarde des options.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-22-004** — Achever résolution, plein écran et redimensionnement
- [ ] **OL-22-005** — Achever qualité graphique et sélection de backend
- [ ] **OL-22-006** — Qualifier focus, alt-tab, fermeture et conservation des options

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0010 — Vérifier lisibilité, contrastes, remappage, volumes et aides disponibles dans le référentiel.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-22-007** — Qualifier AZERTY/QWERTY et remappage
- [ ] **OL-22-008** — Qualifier taille UI, contrastes et lisibilité
- [ ] **OL-22-009** — Qualifier volumes et aides disponibles dans le périmètre historique

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0011 — Vérifier les machines, GPU et périphériques ciblés sans dépendance à l’environnement de développement.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-22-010** — Définir la matrice de GPU et Windows pris en charge
- [ ] **OL-22-011** — Tester WebView2, audio, clavier et souris sur machine propre
- [ ] **OL-22-012** — Éliminer toute dépendance au poste de développement

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0012 — Vérifier clavier AZERTY/QWERTY, résolutions, échelles UI et paramètres conservés après relancement du jeu.

**Prérequis du lot :** P11-L0008.

- [ ] **EX-22-01** — Vérifier clavier AZERTY/QWERTY, résolutions, échelles UI et paramètres conservés après relancement du jeu.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0013 — Tester toutes les fonctions, entités et transitions du référentiel avec résultats et preuves.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-23-001** — Attribuer un scénario d’acceptation à chaque exigence obligatoire
- [ ] **OL-23-002** — Relier résultats et captures aux SHA des binaires et ressources
- [ ] **OL-23-003** — Conserver les fonctions non testées comme inconnues et les échecs comme ouverts

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0014 — Construire la matrice d’interactions pertinente entre champions, sorts, objets, contrôles et objectifs.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-23-004** — Classifier les interactions par familles de mécanismes
- [ ] **OL-23-005** — Ajouter un cas spécifique pour chaque exception de champion ou objet
- [ ] **OL-23-006** — Tester simultanéité, purge, mort, changement de forme et perte de vision

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0015 — Effectuer parties complètes des deux équipes, modes, bots, abandons et reconnexions.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-23-007** — Jouer tous les modes jusqu’à victoire et défaite
- [ ] **OL-23-008** — Jouer abandon, timeout, reconnexion et reprise du launcher
- [ ] **OL-23-009** — Vérifier que résultats et récompenses sont uniques et persistants

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0016 — Mesurer CPU, GPU, mémoire, chargements et réseau ; fixer puis vérifier les budgets sur le PC cible.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-23-010** — Mesurer CPU, GPU, RAM, VRAM, chargement et réseau sur le PC cible
- [ ] **OL-23-011** — Fixer les budgets après mesure, dont objectif 1080p/60 FPS et tick 30 Hz
- [ ] **OL-23-012** — Profiler et corriger les dépassements puis remesurer

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0017 — Faire des essais prolongés, répétitions de parties et tests de fuite de ressources.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-23-013** — Exécuter des parties prolongées avec ressources bornées
- [ ] **OL-23-014** — Répéter lancements, matchs et fermetures
- [ ] **OL-23-015** — Contrôler dérive de mémoire, handles, sons, entités et caches

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0018 — Comparer les références visuelles et comportementales ; corriger puis rejouer les régressions.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-23-016** — Comparer image, animation, comportement et audio aux références
- [ ] **OL-23-017** — Faire valider humainement les parcours et la fidélité
- [ ] **OL-23-018** — Rejouer les régressions sur le paquet final après la dernière correction

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P11-L0019 — Lier les preuves aux SHA des exécutables : les anciens essais world/respawn/relic/altar sont à rejouer sur la version finale.

**Prérequis du lot :** P11-L0013.

- [ ] **EX-23-01** — Lier les preuves aux SHA des exécutables : les anciens essais world/respawn/relic/altar sont à rejouer sur la version finale.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0020 — Seuils proposés à confirmer après mesure : 60 FPS en 1080p sur PC cible, tick serveur 30 Hz sans retard durable, pas de croissance mémoire continue sur essais prolongés.

**Prérequis du lot :** P11-L0013.

- [ ] **EX-23-02** — Seuils proposés à confirmer après mesure : 60 FPS en 1080p sur PC cible, tick serveur 30 Hz sans retard durable, pas de croissance mémoire continue sur essais prolongés.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0021 — Aatrox — acceptation finale du kit

**Prérequis du lot :** P08-L0023, P08-L0029, P08-L0024, P08-L0025, P08-L0026, P08-L0027, P08-L0028.

- [ ] **CH-Aatrox-KIT** — Aatrox : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0022 — Ahri — acceptation finale du kit

**Prérequis du lot :** P08-L0030, P08-L0036, P08-L0031, P08-L0032, P08-L0033, P08-L0034, P08-L0035.

- [ ] **CH-Ahri-KIT** — Ahri : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0023 — Akali — acceptation finale du kit

**Prérequis du lot :** P08-L0037, P08-L0043, P08-L0038, P08-L0039, P08-L0040, P08-L0041, P08-L0042.

- [ ] **CH-Akali-KIT** — Akali : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0024 — Alistar — acceptation finale du kit

**Prérequis du lot :** P08-L0044, P08-L0050, P08-L0045, P08-L0046, P08-L0047, P08-L0048, P08-L0049.

- [ ] **CH-Alistar-KIT** — Alistar : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0025 — Amumu — acceptation finale du kit

**Prérequis du lot :** P08-L0051, P08-L0057, P08-L0052, P08-L0053, P08-L0054, P08-L0055, P08-L0056.

- [ ] **CH-Amumu-KIT** — Amumu : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0026 — Anivia — acceptation finale du kit

**Prérequis du lot :** P08-L0058, P08-L0064, P08-L0059, P08-L0060, P08-L0061, P08-L0062, P08-L0063.

- [ ] **CH-Anivia-KIT** — Anivia : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0027 — Annie — acceptation finale du kit

**Prérequis du lot :** P08-L0065, P08-L0071, P08-L0066, P08-L0067, P08-L0068, P08-L0069, P08-L0070.

- [ ] **CH-Annie-KIT** — Annie : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0028 — Ashe — acceptation finale du kit

**Prérequis du lot :** P08-L0072, P08-L0078, P08-L0073, P08-L0074, P08-L0075, P08-L0076, P08-L0077.

- [ ] **CH-Ashe-KIT** — Ashe : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0029 — Azir — acceptation finale du kit

**Prérequis du lot :** P08-L0079, P08-L0085, P08-L0080, P08-L0081, P08-L0082, P08-L0083, P08-L0084.

- [ ] **CH-Azir-KIT** — Azir : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0030 — Blitzcrank — acceptation finale du kit

**Prérequis du lot :** P08-L0086, P08-L0092, P08-L0087, P08-L0088, P08-L0089, P08-L0090, P08-L0091.

- [ ] **CH-Blitzcrank-KIT** — Blitzcrank : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0031 — Brand — acceptation finale du kit

**Prérequis du lot :** P08-L0093, P08-L0099, P08-L0094, P08-L0095, P08-L0096, P08-L0097, P08-L0098.

- [ ] **CH-Brand-KIT** — Brand : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0032 — Braum — acceptation finale du kit

**Prérequis du lot :** P08-L0100, P08-L0106, P08-L0101, P08-L0102, P08-L0103, P08-L0104, P08-L0105.

- [ ] **CH-Braum-KIT** — Braum : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0033 — Caitlyn — acceptation finale du kit

**Prérequis du lot :** P08-L0107, P08-L0113, P08-L0108, P08-L0109, P08-L0110, P08-L0111, P08-L0112.

- [ ] **CH-Caitlyn-KIT** — Caitlyn : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0034 — Cassiopeia — acceptation finale du kit

**Prérequis du lot :** P08-L0114, P08-L0120, P08-L0115, P08-L0116, P08-L0117, P08-L0118, P08-L0119.

- [ ] **CH-Cassiopeia-KIT** — Cassiopeia : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0035 — Chogath — acceptation finale du kit

**Prérequis du lot :** P08-L0121, P08-L0127, P08-L0122, P08-L0123, P08-L0124, P08-L0125, P08-L0126.

- [ ] **CH-Chogath-KIT** — Chogath : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0036 — Corki — acceptation finale du kit

**Prérequis du lot :** P08-L0128, P08-L0134, P08-L0129, P08-L0130, P08-L0131, P08-L0132, P08-L0133.

- [ ] **CH-Corki-KIT** — Corki : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0037 — Darius — acceptation finale du kit

**Prérequis du lot :** P08-L0135, P08-L0141, P08-L0136, P08-L0137, P08-L0138, P08-L0139, P08-L0140.

- [ ] **CH-Darius-KIT** — Darius : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0038 — Diana — acceptation finale du kit

**Prérequis du lot :** P08-L0142, P08-L0148, P08-L0143, P08-L0144, P08-L0145, P08-L0146, P08-L0147.

- [ ] **CH-Diana-KIT** — Diana : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0039 — DrMundo — acceptation finale du kit

**Prérequis du lot :** P08-L0149, P08-L0155, P08-L0150, P08-L0151, P08-L0152, P08-L0153, P08-L0154.

- [ ] **CH-DrMundo-KIT** — DrMundo : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0040 — Draven — acceptation finale du kit

**Prérequis du lot :** P08-L0156, P08-L0162, P08-L0157, P08-L0158, P08-L0159, P08-L0160, P08-L0161.

- [ ] **CH-Draven-KIT** — Draven : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0041 — Elise — acceptation finale du kit

**Prérequis du lot :** P08-L0163, P08-L0173, P08-L0164, P08-L0165, P08-L0166, P08-L0167, P08-L0168, P08-L0169, P08-L0170, P08-L0171, P08-L0172.

- [ ] **CH-Elise-KIT** — Elise : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0042 — Evelynn — acceptation finale du kit

**Prérequis du lot :** P08-L0174, P08-L0180, P08-L0175, P08-L0176, P08-L0177, P08-L0178, P08-L0179.

- [ ] **CH-Evelynn-KIT** — Evelynn : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0043 — Ezreal — acceptation finale du kit

**Prérequis du lot :** P08-L0181, P08-L0187, P08-L0182, P08-L0183, P08-L0184, P08-L0185, P08-L0186.

- [ ] **CH-Ezreal-KIT** — Ezreal : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0044 — FiddleSticks — acceptation finale du kit

**Prérequis du lot :** P08-L0188, P08-L0194, P08-L0189, P08-L0190, P08-L0191, P08-L0192, P08-L0193.

- [ ] **CH-FiddleSticks-KIT** — FiddleSticks : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0045 — Fiora — acceptation finale du kit

**Prérequis du lot :** P08-L0195, P08-L0201, P08-L0196, P08-L0197, P08-L0198, P08-L0199, P08-L0200.

- [ ] **CH-Fiora-KIT** — Fiora : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0046 — Fizz — acceptation finale du kit

**Prérequis du lot :** P08-L0202, P08-L0208, P08-L0203, P08-L0204, P08-L0205, P08-L0206, P08-L0207.

- [ ] **CH-Fizz-KIT** — Fizz : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0047 — Galio — acceptation finale du kit

**Prérequis du lot :** P08-L0209, P08-L0215, P08-L0210, P08-L0211, P08-L0212, P08-L0213, P08-L0214.

- [ ] **CH-Galio-KIT** — Galio : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0048 — Gangplank — acceptation finale du kit

**Prérequis du lot :** P08-L0216, P08-L0222, P08-L0217, P08-L0218, P08-L0219, P08-L0220, P08-L0221.

- [ ] **CH-Gangplank-KIT** — Gangplank : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0049 — Garen — acceptation finale du kit

**Prérequis du lot :** P04-L0002, P04-L0008, P04-L0003, P04-L0004, P04-L0005, P04-L0006, P04-L0007.

- [ ] **CH-Garen-KIT** — Garen : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0050 — Gnar — acceptation finale du kit

**Prérequis du lot :** P08-L0223, P08-L0229, P08-L0224, P08-L0225, P08-L0226, P08-L0227, P08-L0228.

- [ ] **CH-Gnar-KIT** — Gnar : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0051 — Gragas — acceptation finale du kit

**Prérequis du lot :** P08-L0230, P08-L0236, P08-L0231, P08-L0232, P08-L0233, P08-L0234, P08-L0235.

- [ ] **CH-Gragas-KIT** — Gragas : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0052 — Graves — acceptation finale du kit

**Prérequis du lot :** P08-L0237, P08-L0243, P08-L0238, P08-L0239, P08-L0240, P08-L0241, P08-L0242.

- [ ] **CH-Graves-KIT** — Graves : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0053 — Hecarim — acceptation finale du kit

**Prérequis du lot :** P08-L0244, P08-L0250, P08-L0245, P08-L0246, P08-L0247, P08-L0248, P08-L0249.

- [ ] **CH-Hecarim-KIT** — Hecarim : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0054 — Heimerdinger — acceptation finale du kit

**Prérequis du lot :** P08-L0251, P08-L0257, P08-L0252, P08-L0253, P08-L0254, P08-L0255, P08-L0256.

- [ ] **CH-Heimerdinger-KIT** — Heimerdinger : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0055 — Irelia — acceptation finale du kit

**Prérequis du lot :** P08-L0258, P08-L0264, P08-L0259, P08-L0260, P08-L0261, P08-L0262, P08-L0263.

- [ ] **CH-Irelia-KIT** — Irelia : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0056 — Janna — acceptation finale du kit

**Prérequis du lot :** P08-L0265, P08-L0271, P08-L0266, P08-L0267, P08-L0268, P08-L0269, P08-L0270.

- [ ] **CH-Janna-KIT** — Janna : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0057 — JarvanIV — acceptation finale du kit

**Prérequis du lot :** P08-L0272, P08-L0278, P08-L0273, P08-L0274, P08-L0275, P08-L0276, P08-L0277.

- [ ] **CH-JarvanIV-KIT** — JarvanIV : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0058 — Jax — acceptation finale du kit

**Prérequis du lot :** P08-L0279, P08-L0285, P08-L0280, P08-L0281, P08-L0282, P08-L0283, P08-L0284.

- [ ] **CH-Jax-KIT** — Jax : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0059 — Jayce — acceptation finale du kit

**Prérequis du lot :** P08-L0286, P08-L0296, P08-L0287, P08-L0288, P08-L0289, P08-L0290, P08-L0291, P08-L0292, P08-L0293, P08-L0294, P08-L0295.

- [ ] **CH-Jayce-KIT** — Jayce : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0060 — Jinx — acceptation finale du kit

**Prérequis du lot :** P08-L0297, P08-L0303, P08-L0298, P08-L0299, P08-L0300, P08-L0301, P08-L0302.

- [ ] **CH-Jinx-KIT** — Jinx : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0061 — Kalista — acceptation finale du kit

**Prérequis du lot :** P08-L0304, P08-L0310, P08-L0305, P08-L0306, P08-L0307, P08-L0308, P08-L0309.

- [ ] **CH-Kalista-KIT** — Kalista : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0062 — Karma — acceptation finale du kit

**Prérequis du lot :** P08-L0311, P08-L0317, P08-L0312, P08-L0313, P08-L0314, P08-L0315, P08-L0316.

- [ ] **CH-Karma-KIT** — Karma : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0063 — Karthus — acceptation finale du kit

**Prérequis du lot :** P08-L0318, P08-L0324, P08-L0319, P08-L0320, P08-L0321, P08-L0322, P08-L0323.

- [ ] **CH-Karthus-KIT** — Karthus : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0064 — Kassadin — acceptation finale du kit

**Prérequis du lot :** P08-L0325, P08-L0331, P08-L0326, P08-L0327, P08-L0328, P08-L0329, P08-L0330.

- [ ] **CH-Kassadin-KIT** — Kassadin : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0065 — Katarina — acceptation finale du kit

**Prérequis du lot :** P08-L0332, P08-L0338, P08-L0333, P08-L0334, P08-L0335, P08-L0336, P08-L0337.

- [ ] **CH-Katarina-KIT** — Katarina : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0066 — Kayle — acceptation finale du kit

**Prérequis du lot :** P08-L0339, P08-L0345, P08-L0340, P08-L0341, P08-L0342, P08-L0343, P08-L0344.

- [ ] **CH-Kayle-KIT** — Kayle : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0067 — Kennen — acceptation finale du kit

**Prérequis du lot :** P08-L0346, P08-L0352, P08-L0347, P08-L0348, P08-L0349, P08-L0350, P08-L0351.

- [ ] **CH-Kennen-KIT** — Kennen : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0068 — Khazix — acceptation finale du kit

**Prérequis du lot :** P08-L0353, P08-L0359, P08-L0354, P08-L0355, P08-L0356, P08-L0357, P08-L0358.

- [ ] **CH-Khazix-KIT** — Khazix : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0069 — KogMaw — acceptation finale du kit

**Prérequis du lot :** P08-L0360, P08-L0366, P08-L0361, P08-L0362, P08-L0363, P08-L0364, P08-L0365.

- [ ] **CH-KogMaw-KIT** — KogMaw : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0070 — Leblanc — acceptation finale du kit

**Prérequis du lot :** P08-L0367, P08-L0373, P08-L0368, P08-L0369, P08-L0370, P08-L0371, P08-L0372.

- [ ] **CH-Leblanc-KIT** — Leblanc : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0071 — LeeSin — acceptation finale du kit

**Prérequis du lot :** P08-L0374, P08-L0380, P08-L0375, P08-L0376, P08-L0377, P08-L0378, P08-L0379.

- [ ] **CH-LeeSin-KIT** — LeeSin : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0072 — Leona — acceptation finale du kit

**Prérequis du lot :** P08-L0381, P08-L0387, P08-L0382, P08-L0383, P08-L0384, P08-L0385, P08-L0386.

- [ ] **CH-Leona-KIT** — Leona : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0073 — Lissandra — acceptation finale du kit

**Prérequis du lot :** P08-L0388, P08-L0394, P08-L0389, P08-L0390, P08-L0391, P08-L0392, P08-L0393.

- [ ] **CH-Lissandra-KIT** — Lissandra : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0074 — Lucian — acceptation finale du kit

**Prérequis du lot :** P08-L0395, P08-L0401, P08-L0396, P08-L0397, P08-L0398, P08-L0399, P08-L0400.

- [ ] **CH-Lucian-KIT** — Lucian : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0075 — Lulu — acceptation finale du kit

**Prérequis du lot :** P08-L0402, P08-L0408, P08-L0403, P08-L0404, P08-L0405, P08-L0406, P08-L0407.

- [ ] **CH-Lulu-KIT** — Lulu : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0076 — Lux — acceptation finale du kit

**Prérequis du lot :** P08-L0409, P08-L0415, P08-L0410, P08-L0411, P08-L0412, P08-L0413, P08-L0414.

- [ ] **CH-Lux-KIT** — Lux : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0077 — Malphite — acceptation finale du kit

**Prérequis du lot :** P08-L0416, P08-L0422, P08-L0417, P08-L0418, P08-L0419, P08-L0420, P08-L0421.

- [ ] **CH-Malphite-KIT** — Malphite : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0078 — Malzahar — acceptation finale du kit

**Prérequis du lot :** P08-L0423, P08-L0429, P08-L0424, P08-L0425, P08-L0426, P08-L0427, P08-L0428.

- [ ] **CH-Malzahar-KIT** — Malzahar : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0079 — Maokai — acceptation finale du kit

**Prérequis du lot :** P08-L0430, P08-L0436, P08-L0431, P08-L0432, P08-L0433, P08-L0434, P08-L0435.

- [ ] **CH-Maokai-KIT** — Maokai : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0080 — MasterYi — acceptation finale du kit

**Prérequis du lot :** P08-L0437, P08-L0443, P08-L0438, P08-L0439, P08-L0440, P08-L0441, P08-L0442.

- [ ] **CH-MasterYi-KIT** — MasterYi : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0081 — MissFortune — acceptation finale du kit

**Prérequis du lot :** P08-L0444, P08-L0450, P08-L0445, P08-L0446, P08-L0447, P08-L0448, P08-L0449.

- [ ] **CH-MissFortune-KIT** — MissFortune : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0082 — MonkeyKing — acceptation finale du kit

**Prérequis du lot :** P08-L0451, P08-L0457, P08-L0452, P08-L0453, P08-L0454, P08-L0455, P08-L0456.

- [ ] **CH-MonkeyKing-KIT** — MonkeyKing : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0083 — Mordekaiser — acceptation finale du kit

**Prérequis du lot :** P08-L0458, P08-L0464, P08-L0459, P08-L0460, P08-L0461, P08-L0462, P08-L0463.

- [ ] **CH-Mordekaiser-KIT** — Mordekaiser : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0084 — Morgana — acceptation finale du kit

**Prérequis du lot :** P08-L0465, P08-L0471, P08-L0466, P08-L0467, P08-L0468, P08-L0469, P08-L0470.

- [ ] **CH-Morgana-KIT** — Morgana : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0085 — Nami — acceptation finale du kit

**Prérequis du lot :** P08-L0472, P08-L0478, P08-L0473, P08-L0474, P08-L0475, P08-L0476, P08-L0477.

- [ ] **CH-Nami-KIT** — Nami : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0086 — Nasus — acceptation finale du kit

**Prérequis du lot :** P08-L0479, P08-L0485, P08-L0480, P08-L0481, P08-L0482, P08-L0483, P08-L0484.

- [ ] **CH-Nasus-KIT** — Nasus : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0087 — Nautilus — acceptation finale du kit

**Prérequis du lot :** P08-L0486, P08-L0492, P08-L0487, P08-L0488, P08-L0489, P08-L0490, P08-L0491.

- [ ] **CH-Nautilus-KIT** — Nautilus : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0088 — Nidalee — acceptation finale du kit

**Prérequis du lot :** P08-L0493, P08-L0502, P08-L0494, P08-L0495, P08-L0496, P08-L0497, P08-L0498, P08-L0499, P08-L0500, P08-L0501.

- [ ] **CH-Nidalee-KIT** — Nidalee : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0089 — Nocturne — acceptation finale du kit

**Prérequis du lot :** P08-L0503, P08-L0509, P08-L0504, P08-L0505, P08-L0506, P08-L0507, P08-L0508.

- [ ] **CH-Nocturne-KIT** — Nocturne : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0090 — Nunu — acceptation finale du kit

**Prérequis du lot :** P08-L0510, P08-L0516, P08-L0511, P08-L0512, P08-L0513, P08-L0514, P08-L0515.

- [ ] **CH-Nunu-KIT** — Nunu : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0091 — Olaf — acceptation finale du kit

**Prérequis du lot :** P08-L0517, P08-L0523, P08-L0518, P08-L0519, P08-L0520, P08-L0521, P08-L0522.

- [ ] **CH-Olaf-KIT** — Olaf : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0092 — Orianna — acceptation finale du kit

**Prérequis du lot :** P08-L0524, P08-L0530, P08-L0525, P08-L0526, P08-L0527, P08-L0528, P08-L0529.

- [ ] **CH-Orianna-KIT** — Orianna : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0093 — Pantheon — acceptation finale du kit

**Prérequis du lot :** P08-L0531, P08-L0537, P08-L0532, P08-L0533, P08-L0534, P08-L0535, P08-L0536.

- [ ] **CH-Pantheon-KIT** — Pantheon : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0094 — Poppy — acceptation finale du kit

**Prérequis du lot :** P08-L0538, P08-L0544, P08-L0539, P08-L0540, P08-L0541, P08-L0542, P08-L0543.

- [ ] **CH-Poppy-KIT** — Poppy : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0095 — Quinn — acceptation finale du kit

**Prérequis du lot :** P08-L0545, P08-L0551, P08-L0546, P08-L0547, P08-L0548, P08-L0549, P08-L0550.

- [ ] **CH-Quinn-KIT** — Quinn : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0096 — Rammus — acceptation finale du kit

**Prérequis du lot :** P08-L0552, P08-L0558, P08-L0553, P08-L0554, P08-L0555, P08-L0556, P08-L0557.

- [ ] **CH-Rammus-KIT** — Rammus : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0097 — Renekton — acceptation finale du kit

**Prérequis du lot :** P08-L0559, P08-L0565, P08-L0560, P08-L0561, P08-L0562, P08-L0563, P08-L0564.

- [ ] **CH-Renekton-KIT** — Renekton : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0098 — Rengar — acceptation finale du kit

**Prérequis du lot :** P08-L0566, P08-L0572, P08-L0567, P08-L0568, P08-L0569, P08-L0570, P08-L0571.

- [ ] **CH-Rengar-KIT** — Rengar : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0099 — Riven — acceptation finale du kit

**Prérequis du lot :** P08-L0573, P08-L0579, P08-L0574, P08-L0575, P08-L0576, P08-L0577, P08-L0578.

- [ ] **CH-Riven-KIT** — Riven : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0100 — Rumble — acceptation finale du kit

**Prérequis du lot :** P08-L0580, P08-L0586, P08-L0581, P08-L0582, P08-L0583, P08-L0584, P08-L0585.

- [ ] **CH-Rumble-KIT** — Rumble : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0101 — Ryze — acceptation finale du kit

**Prérequis du lot :** P08-L0587, P08-L0593, P08-L0588, P08-L0589, P08-L0590, P08-L0591, P08-L0592.

- [ ] **CH-Ryze-KIT** — Ryze : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0102 — Sejuani — acceptation finale du kit

**Prérequis du lot :** P08-L0594, P08-L0600, P08-L0595, P08-L0596, P08-L0597, P08-L0598, P08-L0599.

- [ ] **CH-Sejuani-KIT** — Sejuani : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0103 — Shaco — acceptation finale du kit

**Prérequis du lot :** P08-L0601, P08-L0607, P08-L0602, P08-L0603, P08-L0604, P08-L0605, P08-L0606.

- [ ] **CH-Shaco-KIT** — Shaco : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0104 — Shen — acceptation finale du kit

**Prérequis du lot :** P08-L0608, P08-L0614, P08-L0609, P08-L0610, P08-L0611, P08-L0612, P08-L0613.

- [ ] **CH-Shen-KIT** — Shen : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0105 — Shyvana — acceptation finale du kit

**Prérequis du lot :** P08-L0615, P08-L0621, P08-L0616, P08-L0617, P08-L0618, P08-L0619, P08-L0620.

- [ ] **CH-Shyvana-KIT** — Shyvana : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0106 — Singed — acceptation finale du kit

**Prérequis du lot :** P08-L0622, P08-L0628, P08-L0623, P08-L0624, P08-L0625, P08-L0626, P08-L0627.

- [ ] **CH-Singed-KIT** — Singed : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0107 — Sion — acceptation finale du kit

**Prérequis du lot :** P08-L0629, P08-L0635, P08-L0630, P08-L0631, P08-L0632, P08-L0633, P08-L0634.

- [ ] **CH-Sion-KIT** — Sion : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0108 — Sivir — acceptation finale du kit

**Prérequis du lot :** P08-L0636, P08-L0642, P08-L0637, P08-L0638, P08-L0639, P08-L0640, P08-L0641.

- [ ] **CH-Sivir-KIT** — Sivir : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0109 — Skarner — acceptation finale du kit

**Prérequis du lot :** P08-L0643, P08-L0649, P08-L0644, P08-L0645, P08-L0646, P08-L0647, P08-L0648.

- [ ] **CH-Skarner-KIT** — Skarner : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0110 — Sona — acceptation finale du kit

**Prérequis du lot :** P08-L0650, P08-L0656, P08-L0651, P08-L0652, P08-L0653, P08-L0654, P08-L0655.

- [ ] **CH-Sona-KIT** — Sona : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0111 — Soraka — acceptation finale du kit

**Prérequis du lot :** P08-L0657, P08-L0663, P08-L0658, P08-L0659, P08-L0660, P08-L0661, P08-L0662.

- [ ] **CH-Soraka-KIT** — Soraka : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0112 — Swain — acceptation finale du kit

**Prérequis du lot :** P08-L0664, P08-L0670, P08-L0665, P08-L0666, P08-L0667, P08-L0668, P08-L0669.

- [ ] **CH-Swain-KIT** — Swain : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0113 — Syndra — acceptation finale du kit

**Prérequis du lot :** P08-L0671, P08-L0677, P08-L0672, P08-L0673, P08-L0674, P08-L0675, P08-L0676.

- [ ] **CH-Syndra-KIT** — Syndra : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0114 — Talon — acceptation finale du kit

**Prérequis du lot :** P08-L0678, P08-L0684, P08-L0679, P08-L0680, P08-L0681, P08-L0682, P08-L0683.

- [ ] **CH-Talon-KIT** — Talon : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0115 — Taric — acceptation finale du kit

**Prérequis du lot :** P08-L0685, P08-L0691, P08-L0686, P08-L0687, P08-L0688, P08-L0689, P08-L0690.

- [ ] **CH-Taric-KIT** — Taric : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0116 — Teemo — acceptation finale du kit

**Prérequis du lot :** P08-L0692, P08-L0698, P08-L0693, P08-L0694, P08-L0695, P08-L0696, P08-L0697.

- [ ] **CH-Teemo-KIT** — Teemo : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0117 — Thresh — acceptation finale du kit

**Prérequis du lot :** P08-L0699, P08-L0705, P08-L0700, P08-L0701, P08-L0702, P08-L0703, P08-L0704.

- [ ] **CH-Thresh-KIT** — Thresh : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0118 — Tristana — acceptation finale du kit

**Prérequis du lot :** P08-L0706, P08-L0712, P08-L0707, P08-L0708, P08-L0709, P08-L0710, P08-L0711.

- [ ] **CH-Tristana-KIT** — Tristana : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0119 — Trundle — acceptation finale du kit

**Prérequis du lot :** P08-L0713, P08-L0719, P08-L0714, P08-L0715, P08-L0716, P08-L0717, P08-L0718.

- [ ] **CH-Trundle-KIT** — Trundle : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0120 — Tryndamere — acceptation finale du kit

**Prérequis du lot :** P08-L0720, P08-L0726, P08-L0721, P08-L0722, P08-L0723, P08-L0724, P08-L0725.

- [ ] **CH-Tryndamere-KIT** — Tryndamere : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0121 — TwistedFate — acceptation finale du kit

**Prérequis du lot :** P08-L0727, P08-L0733, P08-L0728, P08-L0729, P08-L0730, P08-L0731, P08-L0732.

- [ ] **CH-TwistedFate-KIT** — TwistedFate : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0122 — Twitch — acceptation finale du kit

**Prérequis du lot :** P08-L0734, P08-L0740, P08-L0735, P08-L0736, P08-L0737, P08-L0738, P08-L0739.

- [ ] **CH-Twitch-KIT** — Twitch : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0123 — Udyr — acceptation finale du kit

**Prérequis du lot :** P08-L0741, P08-L0747, P08-L0742, P08-L0743, P08-L0744, P08-L0745, P08-L0746.

- [ ] **CH-Udyr-KIT** — Udyr : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0124 — Urgot — acceptation finale du kit

**Prérequis du lot :** P08-L0748, P08-L0754, P08-L0749, P08-L0750, P08-L0751, P08-L0752, P08-L0753.

- [ ] **CH-Urgot-KIT** — Urgot : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0125 — Varus — acceptation finale du kit

**Prérequis du lot :** P08-L0755, P08-L0761, P08-L0756, P08-L0757, P08-L0758, P08-L0759, P08-L0760.

- [ ] **CH-Varus-KIT** — Varus : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0126 — Vayne — acceptation finale du kit

**Prérequis du lot :** P08-L0762, P08-L0768, P08-L0763, P08-L0764, P08-L0765, P08-L0766, P08-L0767.

- [ ] **CH-Vayne-KIT** — Vayne : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0127 — Veigar — acceptation finale du kit

**Prérequis du lot :** P08-L0769, P08-L0775, P08-L0770, P08-L0771, P08-L0772, P08-L0773, P08-L0774.

- [ ] **CH-Veigar-KIT** — Veigar : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0128 — Velkoz — acceptation finale du kit

**Prérequis du lot :** P08-L0776, P08-L0782, P08-L0777, P08-L0778, P08-L0779, P08-L0780, P08-L0781.

- [ ] **CH-Velkoz-KIT** — Velkoz : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0129 — Vi — acceptation finale du kit

**Prérequis du lot :** P08-L0783, P08-L0789, P08-L0784, P08-L0785, P08-L0786, P08-L0787, P08-L0788.

- [ ] **CH-Vi-KIT** — Vi : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0130 — Viktor — acceptation finale du kit

**Prérequis du lot :** P08-L0790, P08-L0796, P08-L0791, P08-L0792, P08-L0793, P08-L0794, P08-L0795.

- [ ] **CH-Viktor-KIT** — Viktor : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0131 — Vladimir — acceptation finale du kit

**Prérequis du lot :** P08-L0797, P08-L0803, P08-L0798, P08-L0799, P08-L0800, P08-L0801, P08-L0802.

- [ ] **CH-Vladimir-KIT** — Vladimir : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0132 — Volibear — acceptation finale du kit

**Prérequis du lot :** P08-L0804, P08-L0810, P08-L0805, P08-L0806, P08-L0807, P08-L0808, P08-L0809.

- [ ] **CH-Volibear-KIT** — Volibear : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0133 — Warwick — acceptation finale du kit

**Prérequis du lot :** P08-L0811, P08-L0817, P08-L0812, P08-L0813, P08-L0814, P08-L0815, P08-L0816.

- [ ] **CH-Warwick-KIT** — Warwick : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0134 — Xerath — acceptation finale du kit

**Prérequis du lot :** P08-L0818, P08-L0824, P08-L0819, P08-L0820, P08-L0821, P08-L0822, P08-L0823.

- [ ] **CH-Xerath-KIT** — Xerath : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0135 — XinZhao — acceptation finale du kit

**Prérequis du lot :** P08-L0825, P08-L0831, P08-L0826, P08-L0827, P08-L0828, P08-L0829, P08-L0830.

- [ ] **CH-XinZhao-KIT** — XinZhao : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0136 — Yasuo — acceptation finale du kit

**Prérequis du lot :** P08-L0832, P08-L0838, P08-L0833, P08-L0834, P08-L0835, P08-L0836, P08-L0837.

- [ ] **CH-Yasuo-KIT** — Yasuo : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0137 — Yorick — acceptation finale du kit

**Prérequis du lot :** P08-L0839, P08-L0845, P08-L0840, P08-L0841, P08-L0842, P08-L0843, P08-L0844.

- [ ] **CH-Yorick-KIT** — Yorick : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0138 — Zac — acceptation finale du kit

**Prérequis du lot :** P08-L0846, P08-L0852, P08-L0847, P08-L0848, P08-L0849, P08-L0850, P08-L0851.

- [ ] **CH-Zac-KIT** — Zac : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0139 — Zed — acceptation finale du kit

**Prérequis du lot :** P08-L0853, P08-L0859, P08-L0854, P08-L0855, P08-L0856, P08-L0857, P08-L0858.

- [ ] **CH-Zed-KIT** — Zed : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0140 — Ziggs — acceptation finale du kit

**Prérequis du lot :** P08-L0860, P08-L0866, P08-L0861, P08-L0862, P08-L0863, P08-L0864, P08-L0865.

- [ ] **CH-Ziggs-KIT** — Ziggs : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0141 — Zilean — acceptation finale du kit

**Prérequis du lot :** P08-L0867, P08-L0873, P08-L0868, P08-L0869, P08-L0870, P08-L0871, P08-L0872.

- [ ] **CH-Zilean-KIT** — Zilean : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P11-L0142 — Zyra — acceptation finale du kit

**Prérequis du lot :** P08-L0874, P08-L0880, P08-L0875, P08-L0876, P08-L0877, P08-L0878, P08-L0879.

- [ ] **CH-Zyra-KIT** — Zyra : Valider le kit complet en affrontement et en partie jusqu’aux résultats

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

