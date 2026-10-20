# P03 — Terminer les systèmes communs du moteur

[Revenir au plan principal](../OpenLeague_PLAN_DE_TRAVAIL_A_Z.md)

**Résultat à obtenir :** La simulation possède les mécanismes nécessaires aux contenus du jeu.

**Condition de fin :** Statistiques, combat, progression, navigation, vision et protocole commun passent leurs scénarios de référence.

**Prérequis de phase :** P02.

Les cases sont une vue du registre des tâches. Reporter leur statut et leurs preuves dans le registre JSON pour conserver une seule source de suivi. Un lot contient au maximum six tâches.

## P03-L0001 — Implémenter statistiques de base, croissance, bonus, ratios, arrondis et ordre des modificateurs.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-04-001** — Qualifier statistiques et croissance aux niveaux 1 à 18
- [ ] **OL-04-002** — Qualifier bonus additifs, multiplicatifs, plafonds et valeurs négatives
- [ ] **OL-04-003** — Qualifier arrondis et ordre de recalcul lors d’un gain de niveau ou changement d’objet

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0002 — Achever attaques, cadence, portée, wind-up, critiques, projectiles et effets à l’impact.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-04-004** — Qualifier acquisition de cible, portée et rayon des attaques
- [ ] **OL-04-005** — Qualifier wind-up, annulation, cadence et reset d’attaque
- [ ] **OL-04-006** — Qualifier critique, vol de vie et effets à l’impact
- [ ] **OL-04-007** — Achever le trajet visuel des projectiles de tours et sbires sans décaler les dégâts serveur

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0003 — Achever dégâts physiques, magiques et bruts, pénétrations, résistances, soins et boucliers.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-04-008** — Qualifier séparément dégâts physiques, magiques et bruts
- [ ] **OL-04-009** — Qualifier pénétration fixe, pourcentage, réduction et résistances négatives
- [ ] **OL-04-010** — Qualifier soins, réduction des soins, boucliers et ordre de consommation

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0004 — Achever ralentissement, silence, immobilisation, étourdissement, peur, charme, provocation, projection et suppression.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-04-011** — Définir les transitions de ralentissement et immobilisation
- [ ] **OL-04-012** — Implémenter ou terminer peur, charme et provocation
- [ ] **OL-04-013** — Implémenter ou terminer projection et suppression
- [ ] **OL-04-014** — Qualifier silence, étourdissement, ténacité et interruptions de chaque contrôle

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0005 — Achever invulnérabilité, immunités, inciblabilité, interruption, purification et réduction des contrôles.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-04-015** — Qualifier invulnérabilité, inciblabilité et immunités par type
- [ ] **OL-04-016** — Qualifier purification et exceptions non purifiables
- [ ] **OL-04-017** — Tester la libération des contrôles à la mort, transformation et déconnexion

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0006 — Achever ciblage, zones, canalisations, charges, recasts, déplacements forcés et effets simultanés.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-04-018** — Qualifier filtres de cibles et géométrie des zones
- [ ] **OL-04-019** — Achever canalisations, recasts, charges et interruptions
- [ ] **OL-04-020** — Définir l’ordre stable des effets simultanés et de leurs événements
- [ ] **OL-04-021** — Qualifier déplacements forcés et annulations aux obstacles

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0007 — Achever mort, attribution des éliminations/assistances, résurrection, rappel et réapparition.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-04-022** — Qualifier élimination, assistance, exécution et récompenses
- [ ] **OL-04-023** — Qualifier temps de mort, résurrection, rappel et réapparition
- [ ] **OL-04-024** — Valider le récapitulatif de mort privé et le nettoyage des états

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0008 — Tester ordre des effets simultanés, arrondis, résistances négatives, pénétration, réduction, vol de vie, effets à l’impact et dégâts périodiques.

**Prérequis du lot :** P03-L0001.

- [ ] **EX-04-01** — Tester ordre des effets simultanés, arrondis, résistances négatives, pénétration, réduction, vol de vie, effets à l’impact et dégâts périodiques.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P03-L0009 — Respecter les règles de visibilité, de mort et d’impact d’un projectile déjà lancé.

**Prérequis du lot :** P03-L0001.

- [ ] **EX-04-02** — Respecter les règles de visibilité, de mort et d’impact d’un projectile déjà lancé.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P03-L0010 — Distribuer les points de compétence et valider leurs dépenses au serveur.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-05-001** — Qualifier attribution des points lors de chaque niveau
- [ ] **OL-05-002** — Refuser côté serveur les dépenses doubles, retardées ou impossibles

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0011 — Implémenter rangs, restrictions par niveau, ultimes et exceptions des champions à transformation.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-05-003** — Qualifier limites de rang QWER et niveaux d’ultime
- [ ] **OL-05-004** — Énumérer les compétences initiales gratuites et rangs atypiques
- [ ] **OL-05-005** — Qualifier les rangs liés entre formes et compétences secondaires

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0012 — Calculer coûts, récupération, durées et puissance selon le rang et les statistiques.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-05-006** — Qualifier coûts, recharge et réduction de recharge par rang
- [ ] **OL-05-007** — Qualifier ratios, durées et mises à jour pendant un effet actif
- [ ] **OL-05-008** — Afficher les mêmes valeurs dans le HUD et la simulation

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0013 — Implémenter mana, énergie, rage, chaleur, vie utilisée comme ressource et autres ressources natives.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-05-009** — Implémenter et tester mana et énergie
- [ ] **OL-05-010** — Implémenter et tester rage, chaleur, fureur et ressources secondaires
- [ ] **OL-05-011** — Qualifier compétences payées en vie, sans ressource et à coût conditionnel

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0014 — Répliquer niveaux, rangs et points ; rendre fonctionnels les boutons et raccourcis d’apprentissage.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-05-012** — Répliquer rangs, points et niveau sans information périmée
- [ ] **OL-05-013** — Qualifier boutons, raccourcis et retours de refus d’apprentissage
- [ ] **OL-05-014** — Tester reconnexion avec rangs et ressources conservés

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0015 — Documenter les exceptions : compétences disponibles au niveau initial, ultimes à rangs atypiques, transformations et ressources secondaires.

**Prérequis du lot :** P03-L0010.

- [ ] **EX-05-01** — Documenter les exceptions : compétences disponibles au niveau initial, ultimes à rangs atypiques, transformations et ressources secondaires.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P03-L0016 — Aligner géométrie, coordonnées, minimap et simulation sur chaque carte.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-09-001** — Comparer minimap, navigation et géométrie visible de Map10
- [ ] **OL-09-002** — Qualifier les hauteurs et limites jouables de chaque autre carte
- [ ] **OL-09-003** — Tester les deux bases et les chemins symétriques

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0017 — Achever rayons natifs, chemins, poursuites, obstacles, blocage entre unités et cas aux bords.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-09-004** — Qualifier rayons corporels, virages et poursuite
- [ ] **OL-09-005** — Qualifier évitement allié/ennemi et blocage entre unités
- [ ] **OL-09-006** — Qualifier recalcul de chemin et absence de traversée des obstacles

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0018 — Achever dash, saut, téléportation, traversée conditionnelle et déplacements forcés.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-09-007** — Qualifier dash et saut contre murs et obstacles temporaires
- [ ] **OL-09-008** — Qualifier téléportation et recherche d’un point d’arrivée valide
- [ ] **OL-09-009** — Qualifier recul, attraction et annulations pendant un déplacement

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0019 — Vérifier caméra, clics et sélection de cibles dans toutes les zones jouables.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-09-010** — Tester clic-sol et clic-cible sur tous les secteurs
- [ ] **OL-09-011** — Qualifier caméra libre, suivi, limites et zoom
- [ ] **OL-09-012** — Tester clavier AZERTY/QWERTY et sélection d’unités superposées

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0020 — Vérifier dimensions corporelles, virages, évitement, poursuite, attaques pendant mouvement, obstacles temporaires et passages de mur.

**Prérequis du lot :** P03-L0016.

- [ ] **EX-09-01** — Vérifier dimensions corporelles, virages, évitement, poursuite, attaques pendant mouvement, obstacles temporaires et passages de mur.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P03-L0021 — Achever vision par équipe, obstacles, buissons et mémoire des informations visibles.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-13-001** — Qualifier vision par équipe et obstacles du terrain
- [ ] **OL-13-002** — Qualifier entrée/sortie des buissons et visibilité des attaques
- [ ] **OL-13-003** — Qualifier mémoire du terrain et derniers états connus

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0022 — Achever balises, révélations, invisibilité et règles des unités furtives.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-13-004** — Implémenter balises et durées de vie historiques par carte
- [ ] **OL-13-005** — Qualifier invisibilité, révélation et détection
- [ ] **OL-13-006** — Tester interactions des pièges, invocations et objectifs avec la vision

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0023 — Filtrer les informations réseau et interfaces selon la visibilité autorisée.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-13-007** — Filtrer chaque champ des paquets par audience autorisée
- [ ] **OL-13-008** — Qualifier apparitions/disparitions et identifiants publics d’effets
- [ ] **OL-13-009** — Empêcher HUD, minimap, audio et projectiles de révéler une unité cachée

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0024 — Vérifier toutes les interactions de champions, objets et objectifs avec la vision.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-13-010** — Croiser champions et sources de vision dans la matrice d’interactions
- [ ] **OL-13-011** — Tester pertes de vision pendant un cast et après lancement d’un projectile
- [ ] **OL-13-012** — Qualifier reconnect/spectateur sans fuite de l’état privé

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P03-L0025 — Achever brouillard graphique, terrain exploré, mémoire des bâtiments et derniers états connus sans transmettre l’état secret actuel.

**Prérequis du lot :** P03-L0021.

- [ ] **EX-13-01** — Achever brouillard graphique, terrain exploré, mémoire des bâtiments et derniers états connus sans transmettre l’état secret actuel.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P03-L0026 — Vérifier invisibilité, détection, révélations par attaque et leur durée, balises et restrictions par carte.

**Prérequis du lot :** P03-L0021.

- [ ] **EX-13-02** — Vérifier invisibilité, détection, révélations par attaque et leur durée, balises et restrictions par carte.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P03-L0027 — Achever protocole versionné, commandes validées, propriété des entités et synchronisation.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-20-001** — Versionner messages et schémas compatibles
- [ ] **OL-20-002** — Valider propriété, séquence, portée et coût de chaque commande
- [ ] **OL-20-003** — Qualifier snapshots, événements et changement de contexte de partie

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

