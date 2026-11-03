# P07 — Compléter objets, runes, maîtrises et sorts invocateur

[Revenir au plan principal](../OpenLeague_PLAN_DE_TRAVAIL_A_Z.md)

**Résultat à obtenir :** Toutes les configurations de jeu requises possèdent des effets réels et persistants.

**Condition de fin :** Chaque entrée de catalogue a un statut historique prouvé ; les contenus requis fonctionnent de la sélection du launcher à la simulation.

**Prérequis de phase :** P03.

Les cases sont une vue du registre des tâches. Reporter leur statut et leurs preuves dans le registre JSON pour conserver une seule source de suivi. Un lot contient au maximum six tâches.

## P07-L0001 — Qualifier la liste exacte des objets par carte, leurs prix, recettes, ventes et restrictions.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-07-001** — Classifier les 280 entrées d’objets officielles et les 849 ressources natives
- [ ] **OL-07-002** — Qualifier disponibilité et restrictions par carte, champion et mode
- [ ] **OL-07-003** — Qualifier prix, recettes, revente et objets internes non achetables

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P07-L0002 — Achever achats atomiques, crédits des composants, inventaire, déplacements de slots et objets de départ.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-07-004** — Qualifier crédit des composants et achat atomique
- [ ] **OL-07-005** — Qualifier inventaire plein, piles et déplacements de slots
- [ ] **OL-07-006** — Qualifier annulation d’achat, vente et restrictions de zone

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P07-L0003 — Porter passifs uniques, actifs, charges, consommables, transformations et interactions.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-07-007** — Porter les passifs et groupes uniques objet par objet
- [ ] **OL-07-008** — Porter les actifs, charges et recharges partagées
- [ ] **OL-07-009** — Porter les transformations et consommables avec effets réels

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P07-L0004 — Achever les objets spécifiques aux champions, dont les augmentations de Viktor.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-07-010** — Qualifier les augmentations de Viktor 4.20
- [ ] **OL-07-011** — Qualifier les objets de quête ou exclusifs à un champion
- [ ] **OL-07-012** — Tester les restrictions et remboursements des objets spécifiques

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P07-L0005 — Achever recherche, filtres, recommandations, infobulles et raccourcis de la boutique.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-07-013** — Achever recherche et filtres de boutique
- [ ] **OL-07-014** — Achever arbre de recettes et recommandations historiques
- [ ] **OL-07-015** — Achever descriptions, infobulles, raccourcis et états indisponibles

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P07-L0006 — Ajouter annulation d’achat lorsque prévue, restrictions de zone, combinaison atomique, consommables, actifs et récupération partagée.

**Prérequis du lot :** P07-L0001.

- [ ] **EX-07-01** — Ajouter annulation d’achat lorsque prévue, restrictions de zone, combinaison atomique, consommables, actifs et récupération partagée.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0007 — Qualifier toutes les runes, tous les arbres de maîtrises et leurs restrictions 4.20.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-08-001** — Qualifier les 296 entrées de runes officielles par palier et type
- [ ] **OL-08-002** — Qualifier les 57 maîtrises, leurs rangs et prérequis
- [ ] **OL-08-003** — Reproduire les arbres et restrictions historiques des pages

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P07-L0008 — Enregistrer les pages puis transmettre leur sélection au serveur et appliquer leurs effets.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-08-004** — Persister plusieurs pages de runes et maîtrises avec validation
- [ ] **OL-08-005** — Transmettre la page sélectionnée dans le contrat de session
- [ ] **OL-08-006** — Appliquer tous les modificateurs au serveur et contrôler leur cumul

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P07-L0009 — Porter tous les sorts invocateur, récupération, ciblage, règles de carte et interactions.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-08-007** — Qualifier les 13 entrées officielles de sorts invocateur par carte
- [ ] **OL-08-008** — Terminer les cinq sorts déjà présents et retirer les coefficients provisoires non qualifiés
- [ ] **OL-08-009** — Implémenter Flash, Fantôme, Téléportation et les autres sorts requis manquants
- [ ] **OL-08-010** — Qualifier les variantes de Châtiment et leurs interactions 4.20

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P07-L0010 — Vérifier que les configurations affichées dans le launcher sont celles réellement utilisées en partie.

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **OL-08-011** — Comparer le loadout affiché, envoyé, admis et appliqué
- [ ] **OL-08-012** — Refuser les pages et sorts incompatibles avant l’entrée en partie
- [ ] **OL-08-013** — Conserver les choix à la reconnexion et après redémarrage du launcher

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (work) : Livrable nommé produit, différence avec l’état courant documentée, contrôle pertinent passé et preuve actuelle reliée ; les critères du lot historique restent obligatoires.

## P07-L0011 — Vérifier disponibilité par carte et restrictions historiques ; inclure pages, limites et application serveur réelle.

**Prérequis du lot :** P07-L0007.

- [ ] **EX-08-01** — Vérifier disponibilité par carte et restrictions historiques ; inclure pages, limites et application serveur réelle.

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0012 — Objet 1001 — Boots of Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1001-SCOPE** — Objet 1001 — Boots of Speed : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1001-SERVER** — Objet 1001 — Boots of Speed : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1001-SHOP** — Objet 1001 — Boots of Speed : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1001-ACCEPT** — Objet 1001 — Boots of Speed : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0013 — Objet 1004 — Faerie Charm

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1004-SCOPE** — Objet 1004 — Faerie Charm : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1004-SERVER** — Objet 1004 — Faerie Charm : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1004-SHOP** — Objet 1004 — Faerie Charm : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1004-ACCEPT** — Objet 1004 — Faerie Charm : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0014 — Objet 1006 — Rejuvenation Bead

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1006-SCOPE** — Objet 1006 — Rejuvenation Bead : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1006-SERVER** — Objet 1006 — Rejuvenation Bead : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1006-SHOP** — Objet 1006 — Rejuvenation Bead : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1006-ACCEPT** — Objet 1006 — Rejuvenation Bead : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0015 — Objet 1011 — Giant's Belt

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1011-SCOPE** — Objet 1011 — Giant's Belt : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1011-SERVER** — Objet 1011 — Giant's Belt : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1011-SHOP** — Objet 1011 — Giant's Belt : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1011-ACCEPT** — Objet 1011 — Giant's Belt : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0016 — Objet 1018 — Cloak of Agility

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1018-SCOPE** — Objet 1018 — Cloak of Agility : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1018-SERVER** — Objet 1018 — Cloak of Agility : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1018-SHOP** — Objet 1018 — Cloak of Agility : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1018-ACCEPT** — Objet 1018 — Cloak of Agility : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0017 — Objet 1026 — Blasting Wand

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1026-SCOPE** — Objet 1026 — Blasting Wand : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1026-SERVER** — Objet 1026 — Blasting Wand : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1026-SHOP** — Objet 1026 — Blasting Wand : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1026-ACCEPT** — Objet 1026 — Blasting Wand : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0018 — Objet 1027 — Sapphire Crystal

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1027-SCOPE** — Objet 1027 — Sapphire Crystal : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1027-SERVER** — Objet 1027 — Sapphire Crystal : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1027-SHOP** — Objet 1027 — Sapphire Crystal : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1027-ACCEPT** — Objet 1027 — Sapphire Crystal : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0019 — Objet 1028 — Ruby Crystal

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1028-SCOPE** — Objet 1028 — Ruby Crystal : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1028-SERVER** — Objet 1028 — Ruby Crystal : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1028-SHOP** — Objet 1028 — Ruby Crystal : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1028-ACCEPT** — Objet 1028 — Ruby Crystal : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0020 — Objet 1029 — Cloth Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1029-SCOPE** — Objet 1029 — Cloth Armor : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1029-SERVER** — Objet 1029 — Cloth Armor : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1029-SHOP** — Objet 1029 — Cloth Armor : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1029-ACCEPT** — Objet 1029 — Cloth Armor : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0021 — Objet 1031 — Chain Vest

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1031-SCOPE** — Objet 1031 — Chain Vest : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1031-SERVER** — Objet 1031 — Chain Vest : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1031-SHOP** — Objet 1031 — Chain Vest : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1031-ACCEPT** — Objet 1031 — Chain Vest : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0022 — Objet 1033 — Null-Magic Mantle

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1033-SCOPE** — Objet 1033 — Null-Magic Mantle : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1033-SERVER** — Objet 1033 — Null-Magic Mantle : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1033-SHOP** — Objet 1033 — Null-Magic Mantle : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1033-ACCEPT** — Objet 1033 — Null-Magic Mantle : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0023 — Objet 1036 — Long Sword

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1036-SCOPE** — Objet 1036 — Long Sword : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1036-SERVER** — Objet 1036 — Long Sword : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1036-SHOP** — Objet 1036 — Long Sword : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1036-ACCEPT** — Objet 1036 — Long Sword : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0024 — Objet 1037 — Pickaxe

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1037-SCOPE** — Objet 1037 — Pickaxe : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1037-SERVER** — Objet 1037 — Pickaxe : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1037-SHOP** — Objet 1037 — Pickaxe : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1037-ACCEPT** — Objet 1037 — Pickaxe : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0025 — Objet 1038 — B. F. Sword

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1038-SCOPE** — Objet 1038 — B. F. Sword : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1038-SERVER** — Objet 1038 — B. F. Sword : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1038-SHOP** — Objet 1038 — B. F. Sword : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1038-ACCEPT** — Objet 1038 — B. F. Sword : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0026 — Objet 1039 — Hunter's Machete

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1039-SCOPE** — Objet 1039 — Hunter's Machete : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-1039-SERVER** — Objet 1039 — Hunter's Machete : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-1039-SHOP** — Objet 1039 — Hunter's Machete : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-1039-ACCEPT** — Objet 1039 — Hunter's Machete : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0027 — Objet 1042 — Dagger

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1042-SCOPE** — Objet 1042 — Dagger : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1042-SERVER** — Objet 1042 — Dagger : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1042-SHOP** — Objet 1042 — Dagger : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1042-ACCEPT** — Objet 1042 — Dagger : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0028 — Objet 1043 — Recurve Bow

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1043-SCOPE** — Objet 1043 — Recurve Bow : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-1043-SERVER** — Objet 1043 — Recurve Bow : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-1043-SHOP** — Objet 1043 — Recurve Bow : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-1043-ACCEPT** — Objet 1043 — Recurve Bow : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0029 — Objet 1051 — Brawler's Gloves

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1051-SCOPE** — Objet 1051 — Brawler's Gloves : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1051-SERVER** — Objet 1051 — Brawler's Gloves : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1051-SHOP** — Objet 1051 — Brawler's Gloves : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1051-ACCEPT** — Objet 1051 — Brawler's Gloves : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0030 — Objet 1052 — Amplifying Tome

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1052-SCOPE** — Objet 1052 — Amplifying Tome : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1052-SERVER** — Objet 1052 — Amplifying Tome : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1052-SHOP** — Objet 1052 — Amplifying Tome : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1052-ACCEPT** — Objet 1052 — Amplifying Tome : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0031 — Objet 1053 — Vampiric Scepter

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1053-SCOPE** — Objet 1053 — Vampiric Scepter : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1053-SERVER** — Objet 1053 — Vampiric Scepter : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1053-SHOP** — Objet 1053 — Vampiric Scepter : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1053-ACCEPT** — Objet 1053 — Vampiric Scepter : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0032 — Objet 1054 — Doran's Shield

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1054-SCOPE** — Objet 1054 — Doran's Shield : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-1054-SERVER** — Objet 1054 — Doran's Shield : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-1054-SHOP** — Objet 1054 — Doran's Shield : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-1054-ACCEPT** — Objet 1054 — Doran's Shield : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0033 — Objet 1055 — Doran's Blade

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1055-SCOPE** — Objet 1055 — Doran's Blade : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1055-SERVER** — Objet 1055 — Doran's Blade : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1055-SHOP** — Objet 1055 — Doran's Blade : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1055-ACCEPT** — Objet 1055 — Doran's Blade : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0034 — Objet 1056 — Doran's Ring

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1056-SCOPE** — Objet 1056 — Doran's Ring : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-1056-SERVER** — Objet 1056 — Doran's Ring : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-1056-SHOP** — Objet 1056 — Doran's Ring : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-1056-ACCEPT** — Objet 1056 — Doran's Ring : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0035 — Objet 1058 — Needlessly Large Rod

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1058-SCOPE** — Objet 1058 — Needlessly Large Rod : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1058-SERVER** — Objet 1058 — Needlessly Large Rod : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1058-SHOP** — Objet 1058 — Needlessly Large Rod : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-1058-ACCEPT** — Objet 1058 — Needlessly Large Rod : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0036 — Objet 1062 — Prospector's Blade

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1062-SCOPE** — Objet 1062 — Prospector's Blade : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-1062-SERVER** — Objet 1062 — Prospector's Blade : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-1062-SHOP** — Objet 1062 — Prospector's Blade : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-1062-ACCEPT** — Objet 1062 — Prospector's Blade : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0037 — Objet 1063 — Prospector's Ring

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1063-SCOPE** — Objet 1063 — Prospector's Ring : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-1063-SERVER** — Objet 1063 — Prospector's Ring : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-1063-SHOP** — Objet 1063 — Prospector's Ring : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-1063-ACCEPT** — Objet 1063 — Prospector's Ring : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0038 — Objet 1074 — Doran's Shield (Showdown)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1074-SCOPE** — Objet 1074 — Doran's Shield (Showdown) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-1074-SERVER** — Objet 1074 — Doran's Shield (Showdown) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-1074-SHOP** — Objet 1074 — Doran's Shield (Showdown) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-1074-ACCEPT** — Objet 1074 — Doran's Shield (Showdown) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0039 — Objet 1075 — Doran's Blade (Showdown)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1075-SCOPE** — Objet 1075 — Doran's Blade (Showdown) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-1075-SERVER** — Objet 1075 — Doran's Blade (Showdown) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-1075-SHOP** — Objet 1075 — Doran's Blade (Showdown) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-1075-ACCEPT** — Objet 1075 — Doran's Blade (Showdown) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0040 — Objet 1076 — Doran's Ring (Showdown)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1076-SCOPE** — Objet 1076 — Doran's Ring (Showdown) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-1076-SERVER** — Objet 1076 — Doran's Ring (Showdown) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-1076-SHOP** — Objet 1076 — Doran's Ring (Showdown) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-1076-ACCEPT** — Objet 1076 — Doran's Ring (Showdown) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0041 — Objet 1080 — Spirit Stone

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-1080-SCOPE** — Objet 1080 — Spirit Stone : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-1080-SERVER** — Objet 1080 — Spirit Stone : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-1080-SHOP** — Objet 1080 — Spirit Stone : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-1080-ACCEPT** — Objet 1080 — Spirit Stone : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0042 — Objet 2003 — Health Potion

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2003-SCOPE** — Objet 2003 — Health Potion : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-2003-SERVER** — Objet 2003 — Health Potion : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-2003-SHOP** — Objet 2003 — Health Potion : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-2003-ACCEPT** — Objet 2003 — Health Potion : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0043 — Objet 2004 — Mana Potion

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2004-SCOPE** — Objet 2004 — Mana Potion : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-2004-SERVER** — Objet 2004 — Mana Potion : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-2004-SHOP** — Objet 2004 — Mana Potion : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-2004-ACCEPT** — Objet 2004 — Mana Potion : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0044 — Objet 2009 — Total Biscuit of Rejuvenation

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2009-SCOPE** — Objet 2009 — Total Biscuit of Rejuvenation : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2009-SERVER** — Objet 2009 — Total Biscuit of Rejuvenation : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2009-SHOP** — Objet 2009 — Total Biscuit of Rejuvenation : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2009-ACCEPT** — Objet 2009 — Total Biscuit of Rejuvenation : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0045 — Objet 2010 — Total Biscuit of Rejuvenation

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2010-SCOPE** — Objet 2010 — Total Biscuit of Rejuvenation : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2010-SERVER** — Objet 2010 — Total Biscuit of Rejuvenation : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2010-SHOP** — Objet 2010 — Total Biscuit of Rejuvenation : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2010-ACCEPT** — Objet 2010 — Total Biscuit of Rejuvenation : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0046 — Objet 2037 — Elixir of Fortitude

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2037-SCOPE** — Objet 2037 — Elixir of Fortitude : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2037-SERVER** — Objet 2037 — Elixir of Fortitude : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2037-SHOP** — Objet 2037 — Elixir of Fortitude : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2037-ACCEPT** — Objet 2037 — Elixir of Fortitude : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0047 — Objet 2039 — Elixir of Brilliance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2039-SCOPE** — Objet 2039 — Elixir of Brilliance : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2039-SERVER** — Objet 2039 — Elixir of Brilliance : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2039-SHOP** — Objet 2039 — Elixir of Brilliance : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2039-ACCEPT** — Objet 2039 — Elixir of Brilliance : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0048 — Objet 2040 — Ichor of Rage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2040-SCOPE** — Objet 2040 — Ichor of Rage : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2040-SERVER** — Objet 2040 — Ichor of Rage : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2040-SHOP** — Objet 2040 — Ichor of Rage : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2040-ACCEPT** — Objet 2040 — Ichor of Rage : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0049 — Objet 2041 — Crystalline Flask

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2041-SCOPE** — Objet 2041 — Crystalline Flask : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2041-SERVER** — Objet 2041 — Crystalline Flask : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2041-SHOP** — Objet 2041 — Crystalline Flask : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2041-ACCEPT** — Objet 2041 — Crystalline Flask : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0050 — Objet 2043 — Vision Ward

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2043-SCOPE** — Objet 2043 — Vision Ward : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2043-SERVER** — Objet 2043 — Vision Ward : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2043-SHOP** — Objet 2043 — Vision Ward : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2043-ACCEPT** — Objet 2043 — Vision Ward : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0051 — Objet 2044 — Stealth Ward

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2044-SCOPE** — Objet 2044 — Stealth Ward : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2044-SERVER** — Objet 2044 — Stealth Ward : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2044-SHOP** — Objet 2044 — Stealth Ward : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2044-ACCEPT** — Objet 2044 — Stealth Ward : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0052 — Objet 2045 — Ruby Sightstone

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2045-SCOPE** — Objet 2045 — Ruby Sightstone : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2045-SERVER** — Objet 2045 — Ruby Sightstone : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2045-SHOP** — Objet 2045 — Ruby Sightstone : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2045-ACCEPT** — Objet 2045 — Ruby Sightstone : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0053 — Objet 2047 — Oracle's Extract

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2047-SCOPE** — Objet 2047 — Oracle's Extract : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2047-SERVER** — Objet 2047 — Oracle's Extract : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2047-SHOP** — Objet 2047 — Oracle's Extract : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2047-ACCEPT** — Objet 2047 — Oracle's Extract : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0054 — Objet 2048 — Ichor of Illumination

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2048-SCOPE** — Objet 2048 — Ichor of Illumination : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2048-SERVER** — Objet 2048 — Ichor of Illumination : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2048-SHOP** — Objet 2048 — Ichor of Illumination : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2048-ACCEPT** — Objet 2048 — Ichor of Illumination : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0055 — Objet 2049 — Sightstone

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2049-SCOPE** — Objet 2049 — Sightstone : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2049-SERVER** — Objet 2049 — Sightstone : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2049-SHOP** — Objet 2049 — Sightstone : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2049-ACCEPT** — Objet 2049 — Sightstone : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0056 — Objet 2050 — Explorer's Ward

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2050-SCOPE** — Objet 2050 — Explorer's Ward : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2050-SERVER** — Objet 2050 — Explorer's Ward : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2050-SHOP** — Objet 2050 — Explorer's Ward : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2050-ACCEPT** — Objet 2050 — Explorer's Ward : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0057 — Objet 2051 — Guardian's Horn

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2051-SCOPE** — Objet 2051 — Guardian's Horn : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2051-SERVER** — Objet 2051 — Guardian's Horn : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2051-SHOP** — Objet 2051 — Guardian's Horn : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2051-ACCEPT** — Objet 2051 — Guardian's Horn : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0058 — Objet 2052 — Poro-Snax

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2052-SCOPE** — Objet 2052 — Poro-Snax : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2052-SERVER** — Objet 2052 — Poro-Snax : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2052-SHOP** — Objet 2052 — Poro-Snax : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2052-ACCEPT** — Objet 2052 — Poro-Snax : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0059 — Objet 2053 — Raptor Cloak

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2053-SCOPE** — Objet 2053 — Raptor Cloak : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2053-SERVER** — Objet 2053 — Raptor Cloak : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2053-SHOP** — Objet 2053 — Raptor Cloak : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2053-ACCEPT** — Objet 2053 — Raptor Cloak : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0060 — Objet 2137 — Elixir of Ruin

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2137-SCOPE** — Objet 2137 — Elixir of Ruin : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2137-SERVER** — Objet 2137 — Elixir of Ruin : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2137-SHOP** — Objet 2137 — Elixir of Ruin : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2137-ACCEPT** — Objet 2137 — Elixir of Ruin : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0061 — Objet 2138 — Elixir of Iron

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2138-SCOPE** — Objet 2138 — Elixir of Iron : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2138-SERVER** — Objet 2138 — Elixir of Iron : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2138-SHOP** — Objet 2138 — Elixir of Iron : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2138-ACCEPT** — Objet 2138 — Elixir of Iron : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0062 — Objet 2139 — Elixir of Sorcery

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2139-SCOPE** — Objet 2139 — Elixir of Sorcery : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2139-SERVER** — Objet 2139 — Elixir of Sorcery : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2139-SHOP** — Objet 2139 — Elixir of Sorcery : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2139-ACCEPT** — Objet 2139 — Elixir of Sorcery : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0063 — Objet 2140 — Elixir of Wrath

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-2140-SCOPE** — Objet 2140 — Elixir of Wrath : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-2140-SERVER** — Objet 2140 — Elixir of Wrath : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-2140-SHOP** — Objet 2140 — Elixir of Wrath : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-2140-ACCEPT** — Objet 2140 — Elixir of Wrath : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0064 — Objet 3001 — Abyssal Scepter

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3001-SCOPE** — Objet 3001 — Abyssal Scepter : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3001-SERVER** — Objet 3001 — Abyssal Scepter : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3001-SHOP** — Objet 3001 — Abyssal Scepter : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3001-ACCEPT** — Objet 3001 — Abyssal Scepter : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0065 — Objet 3003 — Archangel's Staff

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3003-SCOPE** — Objet 3003 — Archangel's Staff : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3003-SERVER** — Objet 3003 — Archangel's Staff : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3003-SHOP** — Objet 3003 — Archangel's Staff : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3003-ACCEPT** — Objet 3003 — Archangel's Staff : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0066 — Objet 3004 — Manamune

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3004-SCOPE** — Objet 3004 — Manamune : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3004-SERVER** — Objet 3004 — Manamune : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3004-SHOP** — Objet 3004 — Manamune : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3004-ACCEPT** — Objet 3004 — Manamune : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0067 — Objet 3005 — Atma's Impaler

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3005-SCOPE** — Objet 3005 — Atma's Impaler : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3005-SERVER** — Objet 3005 — Atma's Impaler : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3005-SHOP** — Objet 3005 — Atma's Impaler : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3005-ACCEPT** — Objet 3005 — Atma's Impaler : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0068 — Objet 3006 — Berserker's Greaves

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3006-SCOPE** — Objet 3006 — Berserker's Greaves : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3006-SERVER** — Objet 3006 — Berserker's Greaves : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3006-SHOP** — Objet 3006 — Berserker's Greaves : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3006-ACCEPT** — Objet 3006 — Berserker's Greaves : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0069 — Objet 3007 — Archangel's Staff (Crystal Scar)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3007-SCOPE** — Objet 3007 — Archangel's Staff (Crystal Scar) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3007-SERVER** — Objet 3007 — Archangel's Staff (Crystal Scar) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3007-SHOP** — Objet 3007 — Archangel's Staff (Crystal Scar) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3007-ACCEPT** — Objet 3007 — Archangel's Staff (Crystal Scar) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0070 — Objet 3008 — Manamune (Crystal Scar)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3008-SCOPE** — Objet 3008 — Manamune (Crystal Scar) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3008-SERVER** — Objet 3008 — Manamune (Crystal Scar) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3008-SHOP** — Objet 3008 — Manamune (Crystal Scar) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3008-ACCEPT** — Objet 3008 — Manamune (Crystal Scar) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0071 — Objet 3009 — Boots of Swiftness

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3009-SCOPE** — Objet 3009 — Boots of Swiftness : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3009-SERVER** — Objet 3009 — Boots of Swiftness : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3009-SHOP** — Objet 3009 — Boots of Swiftness : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3009-ACCEPT** — Objet 3009 — Boots of Swiftness : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0072 — Objet 3010 — Catalyst the Protector

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3010-SCOPE** — Objet 3010 — Catalyst the Protector : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3010-SERVER** — Objet 3010 — Catalyst the Protector : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3010-SHOP** — Objet 3010 — Catalyst the Protector : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3010-ACCEPT** — Objet 3010 — Catalyst the Protector : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0073 — Objet 3020 — Sorcerer's Shoes

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3020-SCOPE** — Objet 3020 — Sorcerer's Shoes : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3020-SERVER** — Objet 3020 — Sorcerer's Shoes : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3020-SHOP** — Objet 3020 — Sorcerer's Shoes : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3020-ACCEPT** — Objet 3020 — Sorcerer's Shoes : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0074 — Objet 3022 — Frozen Mallet

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3022-SCOPE** — Objet 3022 — Frozen Mallet : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3022-SERVER** — Objet 3022 — Frozen Mallet : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3022-SHOP** — Objet 3022 — Frozen Mallet : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3022-ACCEPT** — Objet 3022 — Frozen Mallet : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0075 — Objet 3023 — Twin Shadows

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3023-SCOPE** — Objet 3023 — Twin Shadows : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3023-SERVER** — Objet 3023 — Twin Shadows : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3023-SHOP** — Objet 3023 — Twin Shadows : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3023-ACCEPT** — Objet 3023 — Twin Shadows : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0076 — Objet 3024 — Glacial Shroud

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3024-SCOPE** — Objet 3024 — Glacial Shroud : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3024-SERVER** — Objet 3024 — Glacial Shroud : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3024-SHOP** — Objet 3024 — Glacial Shroud : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3024-ACCEPT** — Objet 3024 — Glacial Shroud : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0077 — Objet 3025 — Iceborn Gauntlet

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3025-SCOPE** — Objet 3025 — Iceborn Gauntlet : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3025-SERVER** — Objet 3025 — Iceborn Gauntlet : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3025-SHOP** — Objet 3025 — Iceborn Gauntlet : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3025-ACCEPT** — Objet 3025 — Iceborn Gauntlet : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0078 — Objet 3026 — Guardian Angel

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3026-SCOPE** — Objet 3026 — Guardian Angel : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3026-SERVER** — Objet 3026 — Guardian Angel : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3026-SHOP** — Objet 3026 — Guardian Angel : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3026-ACCEPT** — Objet 3026 — Guardian Angel : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0079 — Objet 3027 — Rod of Ages

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3027-SCOPE** — Objet 3027 — Rod of Ages : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3027-SERVER** — Objet 3027 — Rod of Ages : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3027-SHOP** — Objet 3027 — Rod of Ages : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3027-ACCEPT** — Objet 3027 — Rod of Ages : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0080 — Objet 3028 — Chalice of Harmony

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3028-SCOPE** — Objet 3028 — Chalice of Harmony : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3028-SERVER** — Objet 3028 — Chalice of Harmony : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3028-SHOP** — Objet 3028 — Chalice of Harmony : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3028-ACCEPT** — Objet 3028 — Chalice of Harmony : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0081 — Objet 3029 — Rod of Ages (Crystal Scar)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3029-SCOPE** — Objet 3029 — Rod of Ages (Crystal Scar) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3029-SERVER** — Objet 3029 — Rod of Ages (Crystal Scar) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3029-SHOP** — Objet 3029 — Rod of Ages (Crystal Scar) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3029-ACCEPT** — Objet 3029 — Rod of Ages (Crystal Scar) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0082 — Objet 3031 — Infinity Edge

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3031-SCOPE** — Objet 3031 — Infinity Edge : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3031-SERVER** — Objet 3031 — Infinity Edge : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3031-SHOP** — Objet 3031 — Infinity Edge : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3031-ACCEPT** — Objet 3031 — Infinity Edge : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0083 — Objet 3035 — Last Whisper

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3035-SCOPE** — Objet 3035 — Last Whisper : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3035-SERVER** — Objet 3035 — Last Whisper : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3035-SHOP** — Objet 3035 — Last Whisper : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3035-ACCEPT** — Objet 3035 — Last Whisper : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0084 — Objet 3040 — Seraph's Embrace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3040-SCOPE** — Objet 3040 — Seraph's Embrace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3040-SERVER** — Objet 3040 — Seraph's Embrace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3040-SHOP** — Objet 3040 — Seraph's Embrace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3040-ACCEPT** — Objet 3040 — Seraph's Embrace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0085 — Objet 3041 — Mejai's Soulstealer

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3041-SCOPE** — Objet 3041 — Mejai's Soulstealer : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3041-SERVER** — Objet 3041 — Mejai's Soulstealer : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3041-SHOP** — Objet 3041 — Mejai's Soulstealer : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3041-ACCEPT** — Objet 3041 — Mejai's Soulstealer : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0086 — Objet 3042 — Muramana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3042-SCOPE** — Objet 3042 — Muramana : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3042-SERVER** — Objet 3042 — Muramana : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3042-SHOP** — Objet 3042 — Muramana : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3042-ACCEPT** — Objet 3042 — Muramana : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0087 — Objet 3043 — Muramana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3043-SCOPE** — Objet 3043 — Muramana : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3043-SERVER** — Objet 3043 — Muramana : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3043-SHOP** — Objet 3043 — Muramana : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3043-ACCEPT** — Objet 3043 — Muramana : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0088 — Objet 3044 — Phage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3044-SCOPE** — Objet 3044 — Phage : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3044-SERVER** — Objet 3044 — Phage : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3044-SHOP** — Objet 3044 — Phage : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3044-ACCEPT** — Objet 3044 — Phage : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0089 — Objet 3046 — Phantom Dancer

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3046-SCOPE** — Objet 3046 — Phantom Dancer : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3046-SERVER** — Objet 3046 — Phantom Dancer : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3046-SHOP** — Objet 3046 — Phantom Dancer : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3046-ACCEPT** — Objet 3046 — Phantom Dancer : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0090 — Objet 3047 — Ninja Tabi

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3047-SCOPE** — Objet 3047 — Ninja Tabi : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3047-SERVER** — Objet 3047 — Ninja Tabi : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3047-SHOP** — Objet 3047 — Ninja Tabi : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3047-ACCEPT** — Objet 3047 — Ninja Tabi : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0091 — Objet 3048 — Seraph's Embrace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3048-SCOPE** — Objet 3048 — Seraph's Embrace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3048-SERVER** — Objet 3048 — Seraph's Embrace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3048-SHOP** — Objet 3048 — Seraph's Embrace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3048-ACCEPT** — Objet 3048 — Seraph's Embrace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0092 — Objet 3050 — Zeke's Herald

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3050-SCOPE** — Objet 3050 — Zeke's Herald : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3050-SERVER** — Objet 3050 — Zeke's Herald : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3050-SHOP** — Objet 3050 — Zeke's Herald : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3050-ACCEPT** — Objet 3050 — Zeke's Herald : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0093 — Objet 3056 — Ohmwrecker

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3056-SCOPE** — Objet 3056 — Ohmwrecker : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3056-SERVER** — Objet 3056 — Ohmwrecker : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3056-SHOP** — Objet 3056 — Ohmwrecker : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3056-ACCEPT** — Objet 3056 — Ohmwrecker : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0094 — Objet 3057 — Sheen

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3057-SCOPE** — Objet 3057 — Sheen : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3057-SERVER** — Objet 3057 — Sheen : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3057-SHOP** — Objet 3057 — Sheen : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3057-ACCEPT** — Objet 3057 — Sheen : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0095 — Objet 3060 — Banner of Command

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3060-SCOPE** — Objet 3060 — Banner of Command : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3060-SERVER** — Objet 3060 — Banner of Command : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3060-SHOP** — Objet 3060 — Banner of Command : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3060-ACCEPT** — Objet 3060 — Banner of Command : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0096 — Objet 3065 — Spirit Visage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3065-SCOPE** — Objet 3065 — Spirit Visage : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3065-SERVER** — Objet 3065 — Spirit Visage : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3065-SHOP** — Objet 3065 — Spirit Visage : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3065-ACCEPT** — Objet 3065 — Spirit Visage : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0097 — Objet 3067 — Kindlegem

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3067-SCOPE** — Objet 3067 — Kindlegem : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3067-SERVER** — Objet 3067 — Kindlegem : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3067-SHOP** — Objet 3067 — Kindlegem : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3067-ACCEPT** — Objet 3067 — Kindlegem : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0098 — Objet 3068 — Sunfire Cape

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3068-SCOPE** — Objet 3068 — Sunfire Cape : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3068-SERVER** — Objet 3068 — Sunfire Cape : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3068-SHOP** — Objet 3068 — Sunfire Cape : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3068-ACCEPT** — Objet 3068 — Sunfire Cape : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0099 — Objet 3069 — Talisman of Ascension

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3069-SCOPE** — Objet 3069 — Talisman of Ascension : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3069-SERVER** — Objet 3069 — Talisman of Ascension : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3069-SHOP** — Objet 3069 — Talisman of Ascension : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3069-ACCEPT** — Objet 3069 — Talisman of Ascension : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0100 — Objet 3070 — Tear of the Goddess

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3070-SCOPE** — Objet 3070 — Tear of the Goddess : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3070-SERVER** — Objet 3070 — Tear of the Goddess : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3070-SHOP** — Objet 3070 — Tear of the Goddess : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3070-ACCEPT** — Objet 3070 — Tear of the Goddess : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0101 — Objet 3071 — The Black Cleaver

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3071-SCOPE** — Objet 3071 — The Black Cleaver : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3071-SERVER** — Objet 3071 — The Black Cleaver : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3071-SHOP** — Objet 3071 — The Black Cleaver : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3071-ACCEPT** — Objet 3071 — The Black Cleaver : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0102 — Objet 3072 — The Bloodthirster

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3072-SCOPE** — Objet 3072 — The Bloodthirster : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3072-SERVER** — Objet 3072 — The Bloodthirster : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3072-SHOP** — Objet 3072 — The Bloodthirster : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3072-ACCEPT** — Objet 3072 — The Bloodthirster : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0103 — Objet 3073 — Tear of the Goddess (Crystal Scar)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3073-SCOPE** — Objet 3073 — Tear of the Goddess (Crystal Scar) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3073-SERVER** — Objet 3073 — Tear of the Goddess (Crystal Scar) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3073-SHOP** — Objet 3073 — Tear of the Goddess (Crystal Scar) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3073-ACCEPT** — Objet 3073 — Tear of the Goddess (Crystal Scar) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0104 — Objet 3074 — Ravenous Hydra (Melee Only)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3074-SCOPE** — Objet 3074 — Ravenous Hydra (Melee Only) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3074-SERVER** — Objet 3074 — Ravenous Hydra (Melee Only) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3074-SHOP** — Objet 3074 — Ravenous Hydra (Melee Only) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3074-ACCEPT** — Objet 3074 — Ravenous Hydra (Melee Only) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0105 — Objet 3075 — Thornmail

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3075-SCOPE** — Objet 3075 — Thornmail : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3075-SERVER** — Objet 3075 — Thornmail : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3075-SHOP** — Objet 3075 — Thornmail : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3075-ACCEPT** — Objet 3075 — Thornmail : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0106 — Objet 3077 — Tiamat (Melee Only)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3077-SCOPE** — Objet 3077 — Tiamat (Melee Only) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3077-SERVER** — Objet 3077 — Tiamat (Melee Only) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3077-SHOP** — Objet 3077 — Tiamat (Melee Only) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3077-ACCEPT** — Objet 3077 — Tiamat (Melee Only) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0107 — Objet 3078 — Trinity Force

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3078-SCOPE** — Objet 3078 — Trinity Force : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3078-SERVER** — Objet 3078 — Trinity Force : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3078-SHOP** — Objet 3078 — Trinity Force : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3078-ACCEPT** — Objet 3078 — Trinity Force : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0108 — Objet 3082 — Warden's Mail

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3082-SCOPE** — Objet 3082 — Warden's Mail : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3082-SERVER** — Objet 3082 — Warden's Mail : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3082-SHOP** — Objet 3082 — Warden's Mail : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3082-ACCEPT** — Objet 3082 — Warden's Mail : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0109 — Objet 3083 — Warmog's Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3083-SCOPE** — Objet 3083 — Warmog's Armor : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3083-SERVER** — Objet 3083 — Warmog's Armor : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3083-SHOP** — Objet 3083 — Warmog's Armor : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3083-ACCEPT** — Objet 3083 — Warmog's Armor : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0110 — Objet 3084 — Overlord's Bloodmail

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3084-SCOPE** — Objet 3084 — Overlord's Bloodmail : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3084-SERVER** — Objet 3084 — Overlord's Bloodmail : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3084-SHOP** — Objet 3084 — Overlord's Bloodmail : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3084-ACCEPT** — Objet 3084 — Overlord's Bloodmail : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0111 — Objet 3085 — Runaan's Hurricane (Ranged Only)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3085-SCOPE** — Objet 3085 — Runaan's Hurricane (Ranged Only) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3085-SERVER** — Objet 3085 — Runaan's Hurricane (Ranged Only) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3085-SHOP** — Objet 3085 — Runaan's Hurricane (Ranged Only) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3085-ACCEPT** — Objet 3085 — Runaan's Hurricane (Ranged Only) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0112 — Objet 3086 — Zeal

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3086-SCOPE** — Objet 3086 — Zeal : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3086-SERVER** — Objet 3086 — Zeal : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3086-SHOP** — Objet 3086 — Zeal : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3086-ACCEPT** — Objet 3086 — Zeal : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0113 — Objet 3087 — Statikk Shiv

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3087-SCOPE** — Objet 3087 — Statikk Shiv : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3087-SERVER** — Objet 3087 — Statikk Shiv : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3087-SHOP** — Objet 3087 — Statikk Shiv : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3087-ACCEPT** — Objet 3087 — Statikk Shiv : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0114 — Objet 3089 — Rabadon's Deathcap

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3089-SCOPE** — Objet 3089 — Rabadon's Deathcap : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3089-SERVER** — Objet 3089 — Rabadon's Deathcap : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3089-SHOP** — Objet 3089 — Rabadon's Deathcap : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3089-ACCEPT** — Objet 3089 — Rabadon's Deathcap : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0115 — Objet 3090 — Wooglet's Witchcap

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3090-SCOPE** — Objet 3090 — Wooglet's Witchcap : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3090-SERVER** — Objet 3090 — Wooglet's Witchcap : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3090-SHOP** — Objet 3090 — Wooglet's Witchcap : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3090-ACCEPT** — Objet 3090 — Wooglet's Witchcap : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0116 — Objet 3091 — Wit's End

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3091-SCOPE** — Objet 3091 — Wit's End : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3091-SERVER** — Objet 3091 — Wit's End : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3091-SHOP** — Objet 3091 — Wit's End : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3091-ACCEPT** — Objet 3091 — Wit's End : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0117 — Objet 3092 — Frost Queen's Claim

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3092-SCOPE** — Objet 3092 — Frost Queen's Claim : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3092-SERVER** — Objet 3092 — Frost Queen's Claim : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3092-SHOP** — Objet 3092 — Frost Queen's Claim : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3092-ACCEPT** — Objet 3092 — Frost Queen's Claim : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0118 — Objet 3093 — Avarice Blade

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3093-SCOPE** — Objet 3093 — Avarice Blade : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3093-SERVER** — Objet 3093 — Avarice Blade : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3093-SHOP** — Objet 3093 — Avarice Blade : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3093-ACCEPT** — Objet 3093 — Avarice Blade : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0119 — Objet 3096 — Nomad's Medallion

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3096-SCOPE** — Objet 3096 — Nomad's Medallion : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3096-SERVER** — Objet 3096 — Nomad's Medallion : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3096-SHOP** — Objet 3096 — Nomad's Medallion : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3096-ACCEPT** — Objet 3096 — Nomad's Medallion : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0120 — Objet 3097 — Targon's Brace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3097-SCOPE** — Objet 3097 — Targon's Brace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3097-SERVER** — Objet 3097 — Targon's Brace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3097-SHOP** — Objet 3097 — Targon's Brace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3097-ACCEPT** — Objet 3097 — Targon's Brace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0121 — Objet 3098 — Frostfang

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3098-SCOPE** — Objet 3098 — Frostfang : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3098-SERVER** — Objet 3098 — Frostfang : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3098-SHOP** — Objet 3098 — Frostfang : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3098-ACCEPT** — Objet 3098 — Frostfang : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0122 — Objet 3100 — Lich Bane

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3100-SCOPE** — Objet 3100 — Lich Bane : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3100-SERVER** — Objet 3100 — Lich Bane : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3100-SHOP** — Objet 3100 — Lich Bane : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3100-ACCEPT** — Objet 3100 — Lich Bane : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0123 — Objet 3101 — Stinger

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3101-SCOPE** — Objet 3101 — Stinger : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3101-SERVER** — Objet 3101 — Stinger : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3101-SHOP** — Objet 3101 — Stinger : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3101-ACCEPT** — Objet 3101 — Stinger : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0124 — Objet 3102 — Banshee's Veil

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3102-SCOPE** — Objet 3102 — Banshee's Veil : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3102-SERVER** — Objet 3102 — Banshee's Veil : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3102-SHOP** — Objet 3102 — Banshee's Veil : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3102-ACCEPT** — Objet 3102 — Banshee's Veil : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0125 — Objet 3104 — Lord Van Damm's Pillager

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3104-SCOPE** — Objet 3104 — Lord Van Damm's Pillager : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3104-SERVER** — Objet 3104 — Lord Van Damm's Pillager : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3104-SHOP** — Objet 3104 — Lord Van Damm's Pillager : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3104-ACCEPT** — Objet 3104 — Lord Van Damm's Pillager : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0126 — Objet 3105 — Aegis of the Legion

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3105-SCOPE** — Objet 3105 — Aegis of the Legion : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3105-SERVER** — Objet 3105 — Aegis of the Legion : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3105-SHOP** — Objet 3105 — Aegis of the Legion : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3105-ACCEPT** — Objet 3105 — Aegis of the Legion : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0127 — Objet 3106 — Madred's Razors

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3106-SCOPE** — Objet 3106 — Madred's Razors : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3106-SERVER** — Objet 3106 — Madred's Razors : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3106-SHOP** — Objet 3106 — Madred's Razors : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3106-ACCEPT** — Objet 3106 — Madred's Razors : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0128 — Objet 3108 — Fiendish Codex

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3108-SCOPE** — Objet 3108 — Fiendish Codex : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3108-SERVER** — Objet 3108 — Fiendish Codex : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3108-SHOP** — Objet 3108 — Fiendish Codex : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3108-ACCEPT** — Objet 3108 — Fiendish Codex : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0129 — Objet 3110 — Frozen Heart

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3110-SCOPE** — Objet 3110 — Frozen Heart : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3110-SERVER** — Objet 3110 — Frozen Heart : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3110-SHOP** — Objet 3110 — Frozen Heart : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3110-ACCEPT** — Objet 3110 — Frozen Heart : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0130 — Objet 3111 — Mercury's Treads

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3111-SCOPE** — Objet 3111 — Mercury's Treads : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3111-SERVER** — Objet 3111 — Mercury's Treads : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3111-SHOP** — Objet 3111 — Mercury's Treads : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3111-ACCEPT** — Objet 3111 — Mercury's Treads : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0131 — Objet 3112 — Orb of Winter

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3112-SCOPE** — Objet 3112 — Orb of Winter : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3112-SERVER** — Objet 3112 — Orb of Winter : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3112-SHOP** — Objet 3112 — Orb of Winter : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3112-ACCEPT** — Objet 3112 — Orb of Winter : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0132 — Objet 3113 — Aether Wisp

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3113-SCOPE** — Objet 3113 — Aether Wisp : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3113-SERVER** — Objet 3113 — Aether Wisp : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3113-SHOP** — Objet 3113 — Aether Wisp : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3113-ACCEPT** — Objet 3113 — Aether Wisp : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0133 — Objet 3114 — Forbidden Idol

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3114-SCOPE** — Objet 3114 — Forbidden Idol : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3114-SERVER** — Objet 3114 — Forbidden Idol : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3114-SHOP** — Objet 3114 — Forbidden Idol : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3114-ACCEPT** — Objet 3114 — Forbidden Idol : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0134 — Objet 3115 — Nashor's Tooth

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3115-SCOPE** — Objet 3115 — Nashor's Tooth : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3115-SERVER** — Objet 3115 — Nashor's Tooth : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3115-SHOP** — Objet 3115 — Nashor's Tooth : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3115-ACCEPT** — Objet 3115 — Nashor's Tooth : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0135 — Objet 3116 — Rylai's Crystal Scepter

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3116-SCOPE** — Objet 3116 — Rylai's Crystal Scepter : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3116-SERVER** — Objet 3116 — Rylai's Crystal Scepter : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3116-SHOP** — Objet 3116 — Rylai's Crystal Scepter : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3116-ACCEPT** — Objet 3116 — Rylai's Crystal Scepter : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0136 — Objet 3117 — Boots of Mobility

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3117-SCOPE** — Objet 3117 — Boots of Mobility : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3117-SERVER** — Objet 3117 — Boots of Mobility : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3117-SHOP** — Objet 3117 — Boots of Mobility : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3117-ACCEPT** — Objet 3117 — Boots of Mobility : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0137 — Objet 3122 — Wicked Hatchet

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3122-SCOPE** — Objet 3122 — Wicked Hatchet : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3122-SERVER** — Objet 3122 — Wicked Hatchet : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3122-SHOP** — Objet 3122 — Wicked Hatchet : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3122-ACCEPT** — Objet 3122 — Wicked Hatchet : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0138 — Objet 3123 — Executioner's Calling

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3123-SCOPE** — Objet 3123 — Executioner's Calling : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3123-SERVER** — Objet 3123 — Executioner's Calling : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3123-SHOP** — Objet 3123 — Executioner's Calling : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3123-ACCEPT** — Objet 3123 — Executioner's Calling : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0139 — Objet 3124 — Guinsoo's Rageblade

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3124-SCOPE** — Objet 3124 — Guinsoo's Rageblade : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3124-SERVER** — Objet 3124 — Guinsoo's Rageblade : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3124-SHOP** — Objet 3124 — Guinsoo's Rageblade : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3124-ACCEPT** — Objet 3124 — Guinsoo's Rageblade : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0140 — Objet 3128 — Deathfire Grasp

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3128-SCOPE** — Objet 3128 — Deathfire Grasp : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3128-SERVER** — Objet 3128 — Deathfire Grasp : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3128-SHOP** — Objet 3128 — Deathfire Grasp : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3128-ACCEPT** — Objet 3128 — Deathfire Grasp : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0141 — Objet 3131 — Sword of the Divine

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3131-SCOPE** — Objet 3131 — Sword of the Divine : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3131-SERVER** — Objet 3131 — Sword of the Divine : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3131-SHOP** — Objet 3131 — Sword of the Divine : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3131-ACCEPT** — Objet 3131 — Sword of the Divine : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0142 — Objet 3134 — The Brutalizer

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3134-SCOPE** — Objet 3134 — The Brutalizer : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3134-SERVER** — Objet 3134 — The Brutalizer : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3134-SHOP** — Objet 3134 — The Brutalizer : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3134-ACCEPT** — Objet 3134 — The Brutalizer : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0143 — Objet 3135 — Void Staff

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3135-SCOPE** — Objet 3135 — Void Staff : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3135-SERVER** — Objet 3135 — Void Staff : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3135-SHOP** — Objet 3135 — Void Staff : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3135-ACCEPT** — Objet 3135 — Void Staff : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0144 — Objet 3136 — Haunting Guise

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3136-SCOPE** — Objet 3136 — Haunting Guise : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3136-SERVER** — Objet 3136 — Haunting Guise : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3136-SHOP** — Objet 3136 — Haunting Guise : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3136-ACCEPT** — Objet 3136 — Haunting Guise : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0145 — Objet 3137 — Dervish Blade

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3137-SCOPE** — Objet 3137 — Dervish Blade : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3137-SERVER** — Objet 3137 — Dervish Blade : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3137-SHOP** — Objet 3137 — Dervish Blade : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3137-ACCEPT** — Objet 3137 — Dervish Blade : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0146 — Objet 3139 — Mercurial Scimitar

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3139-SCOPE** — Objet 3139 — Mercurial Scimitar : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3139-SERVER** — Objet 3139 — Mercurial Scimitar : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3139-SHOP** — Objet 3139 — Mercurial Scimitar : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3139-ACCEPT** — Objet 3139 — Mercurial Scimitar : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0147 — Objet 3140 — Quicksilver Sash

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3140-SCOPE** — Objet 3140 — Quicksilver Sash : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3140-SERVER** — Objet 3140 — Quicksilver Sash : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3140-SHOP** — Objet 3140 — Quicksilver Sash : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3140-ACCEPT** — Objet 3140 — Quicksilver Sash : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0148 — Objet 3141 — Sword of the Occult

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3141-SCOPE** — Objet 3141 — Sword of the Occult : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3141-SERVER** — Objet 3141 — Sword of the Occult : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3141-SHOP** — Objet 3141 — Sword of the Occult : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3141-ACCEPT** — Objet 3141 — Sword of the Occult : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0149 — Objet 3142 — Youmuu's Ghostblade

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3142-SCOPE** — Objet 3142 — Youmuu's Ghostblade : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3142-SERVER** — Objet 3142 — Youmuu's Ghostblade : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3142-SHOP** — Objet 3142 — Youmuu's Ghostblade : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3142-ACCEPT** — Objet 3142 — Youmuu's Ghostblade : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0150 — Objet 3143 — Randuin's Omen

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3143-SCOPE** — Objet 3143 — Randuin's Omen : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3143-SERVER** — Objet 3143 — Randuin's Omen : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3143-SHOP** — Objet 3143 — Randuin's Omen : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3143-ACCEPT** — Objet 3143 — Randuin's Omen : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0151 — Objet 3144 — Bilgewater Cutlass

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3144-SCOPE** — Objet 3144 — Bilgewater Cutlass : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3144-SERVER** — Objet 3144 — Bilgewater Cutlass : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3144-SHOP** — Objet 3144 — Bilgewater Cutlass : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3144-ACCEPT** — Objet 3144 — Bilgewater Cutlass : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0152 — Objet 3145 — Hextech Revolver

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3145-SCOPE** — Objet 3145 — Hextech Revolver : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3145-SERVER** — Objet 3145 — Hextech Revolver : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3145-SHOP** — Objet 3145 — Hextech Revolver : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3145-ACCEPT** — Objet 3145 — Hextech Revolver : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0153 — Objet 3146 — Hextech Gunblade

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3146-SCOPE** — Objet 3146 — Hextech Gunblade : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3146-SERVER** — Objet 3146 — Hextech Gunblade : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3146-SHOP** — Objet 3146 — Hextech Gunblade : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3146-ACCEPT** — Objet 3146 — Hextech Gunblade : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0154 — Objet 3151 — Liandry's Torment

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3151-SCOPE** — Objet 3151 — Liandry's Torment : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3151-SERVER** — Objet 3151 — Liandry's Torment : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3151-SHOP** — Objet 3151 — Liandry's Torment : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3151-ACCEPT** — Objet 3151 — Liandry's Torment : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0155 — Objet 3152 — Will of the Ancients

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3152-SCOPE** — Objet 3152 — Will of the Ancients : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3152-SERVER** — Objet 3152 — Will of the Ancients : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3152-SHOP** — Objet 3152 — Will of the Ancients : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3152-ACCEPT** — Objet 3152 — Will of the Ancients : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0156 — Objet 3153 — Blade of the Ruined King

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3153-SCOPE** — Objet 3153 — Blade of the Ruined King : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3153-SERVER** — Objet 3153 — Blade of the Ruined King : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3153-SHOP** — Objet 3153 — Blade of the Ruined King : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3153-ACCEPT** — Objet 3153 — Blade of the Ruined King : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0157 — Objet 3154 — Wriggle's Lantern

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3154-SCOPE** — Objet 3154 — Wriggle's Lantern : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3154-SERVER** — Objet 3154 — Wriggle's Lantern : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3154-SHOP** — Objet 3154 — Wriggle's Lantern : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3154-ACCEPT** — Objet 3154 — Wriggle's Lantern : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0158 — Objet 3155 — Hexdrinker

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3155-SCOPE** — Objet 3155 — Hexdrinker : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3155-SERVER** — Objet 3155 — Hexdrinker : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3155-SHOP** — Objet 3155 — Hexdrinker : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3155-ACCEPT** — Objet 3155 — Hexdrinker : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0159 — Objet 3156 — Maw of Malmortius

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3156-SCOPE** — Objet 3156 — Maw of Malmortius : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3156-SERVER** — Objet 3156 — Maw of Malmortius : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3156-SHOP** — Objet 3156 — Maw of Malmortius : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3156-ACCEPT** — Objet 3156 — Maw of Malmortius : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0160 — Objet 3157 — Zhonya's Hourglass

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3157-SCOPE** — Objet 3157 — Zhonya's Hourglass : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3157-SERVER** — Objet 3157 — Zhonya's Hourglass : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3157-SHOP** — Objet 3157 — Zhonya's Hourglass : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3157-ACCEPT** — Objet 3157 — Zhonya's Hourglass : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0161 — Objet 3158 — Ionian Boots of Lucidity

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3158-SCOPE** — Objet 3158 — Ionian Boots of Lucidity : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3158-SERVER** — Objet 3158 — Ionian Boots of Lucidity : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3158-SHOP** — Objet 3158 — Ionian Boots of Lucidity : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3158-ACCEPT** — Objet 3158 — Ionian Boots of Lucidity : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0162 — Objet 3159 — Grez's Spectral Lantern

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3159-SCOPE** — Objet 3159 — Grez's Spectral Lantern : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3159-SERVER** — Objet 3159 — Grez's Spectral Lantern : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3159-SHOP** — Objet 3159 — Grez's Spectral Lantern : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3159-ACCEPT** — Objet 3159 — Grez's Spectral Lantern : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0163 — Objet 3160 — Feral Flare

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3160-SCOPE** — Objet 3160 — Feral Flare : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3160-SERVER** — Objet 3160 — Feral Flare : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3160-SHOP** — Objet 3160 — Feral Flare : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3160-ACCEPT** — Objet 3160 — Feral Flare : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0164 — Objet 3165 — Morellonomicon

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3165-SCOPE** — Objet 3165 — Morellonomicon : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3165-SERVER** — Objet 3165 — Morellonomicon : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3165-SHOP** — Objet 3165 — Morellonomicon : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3165-ACCEPT** — Objet 3165 — Morellonomicon : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0165 — Objet 3166 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3166-SCOPE** — Objet 3166 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3166-SERVER** — Objet 3166 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3166-SHOP** — Objet 3166 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3166-ACCEPT** — Objet 3166 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0166 — Objet 3167 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3167-SCOPE** — Objet 3167 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3167-SERVER** — Objet 3167 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3167-SHOP** — Objet 3167 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3167-ACCEPT** — Objet 3167 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0167 — Objet 3168 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3168-SCOPE** — Objet 3168 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3168-SERVER** — Objet 3168 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3168-SHOP** — Objet 3168 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3168-ACCEPT** — Objet 3168 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0168 — Objet 3169 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3169-SCOPE** — Objet 3169 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3169-SERVER** — Objet 3169 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3169-SHOP** — Objet 3169 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3169-ACCEPT** — Objet 3169 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0169 — Objet 3170 — Moonflair Spellblade

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3170-SCOPE** — Objet 3170 — Moonflair Spellblade : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3170-SERVER** — Objet 3170 — Moonflair Spellblade : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3170-SHOP** — Objet 3170 — Moonflair Spellblade : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3170-ACCEPT** — Objet 3170 — Moonflair Spellblade : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0170 — Objet 3171 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3171-SCOPE** — Objet 3171 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3171-SERVER** — Objet 3171 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3171-SHOP** — Objet 3171 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3171-ACCEPT** — Objet 3171 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0171 — Objet 3172 — Zephyr

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3172-SCOPE** — Objet 3172 — Zephyr : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3172-SERVER** — Objet 3172 — Zephyr : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3172-SHOP** — Objet 3172 — Zephyr : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3172-ACCEPT** — Objet 3172 — Zephyr : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0172 — Objet 3174 — Athene's Unholy Grail

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3174-SCOPE** — Objet 3174 — Athene's Unholy Grail : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3174-SERVER** — Objet 3174 — Athene's Unholy Grail : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3174-SHOP** — Objet 3174 — Athene's Unholy Grail : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3174-ACCEPT** — Objet 3174 — Athene's Unholy Grail : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0173 — Objet 3175 — Head of Kha'Zix

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3175-SCOPE** — Objet 3175 — Head of Kha'Zix : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3175-SERVER** — Objet 3175 — Head of Kha'Zix : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3175-SHOP** — Objet 3175 — Head of Kha'Zix : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3175-ACCEPT** — Objet 3175 — Head of Kha'Zix : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0174 — Objet 3180 — Odyn's Veil

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3180-SCOPE** — Objet 3180 — Odyn's Veil : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3180-SERVER** — Objet 3180 — Odyn's Veil : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3180-SHOP** — Objet 3180 — Odyn's Veil : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3180-ACCEPT** — Objet 3180 — Odyn's Veil : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0175 — Objet 3181 — Sanguine Blade

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3181-SCOPE** — Objet 3181 — Sanguine Blade : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3181-SERVER** — Objet 3181 — Sanguine Blade : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3181-SHOP** — Objet 3181 — Sanguine Blade : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3181-ACCEPT** — Objet 3181 — Sanguine Blade : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0176 — Objet 3184 — Entropy

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3184-SCOPE** — Objet 3184 — Entropy : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3184-SERVER** — Objet 3184 — Entropy : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3184-SHOP** — Objet 3184 — Entropy : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3184-ACCEPT** — Objet 3184 — Entropy : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0177 — Objet 3185 — The Lightbringer

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3185-SCOPE** — Objet 3185 — The Lightbringer : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3185-SERVER** — Objet 3185 — The Lightbringer : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3185-SHOP** — Objet 3185 — The Lightbringer : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3185-ACCEPT** — Objet 3185 — The Lightbringer : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0178 — Objet 3187 — Hextech Sweeper

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3187-SCOPE** — Objet 3187 — Hextech Sweeper : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3187-SERVER** — Objet 3187 — Hextech Sweeper : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3187-SHOP** — Objet 3187 — Hextech Sweeper : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3187-ACCEPT** — Objet 3187 — Hextech Sweeper : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0179 — Objet 3188 — Blackfire Torch

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3188-SCOPE** — Objet 3188 — Blackfire Torch : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3188-SERVER** — Objet 3188 — Blackfire Torch : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3188-SHOP** — Objet 3188 — Blackfire Torch : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3188-ACCEPT** — Objet 3188 — Blackfire Torch : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0180 — Objet 3190 — Locket of the Iron Solari

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3190-SCOPE** — Objet 3190 — Locket of the Iron Solari : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3190-SERVER** — Objet 3190 — Locket of the Iron Solari : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3190-SHOP** — Objet 3190 — Locket of the Iron Solari : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3190-ACCEPT** — Objet 3190 — Locket of the Iron Solari : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0181 — Objet 3191 — Seeker's Armguard

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3191-SCOPE** — Objet 3191 — Seeker's Armguard : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3191-SERVER** — Objet 3191 — Seeker's Armguard : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3191-SHOP** — Objet 3191 — Seeker's Armguard : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3191-ACCEPT** — Objet 3191 — Seeker's Armguard : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0182 — Objet 3196 — The Hex Core mk-1

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3196-SCOPE** — Objet 3196 — The Hex Core mk-1 : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3196-SERVER** — Objet 3196 — The Hex Core mk-1 : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3196-SHOP** — Objet 3196 — The Hex Core mk-1 : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3196-ACCEPT** — Objet 3196 — The Hex Core mk-1 : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0183 — Objet 3197 — The Hex Core mk-2

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3197-SCOPE** — Objet 3197 — The Hex Core mk-2 : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3197-SERVER** — Objet 3197 — The Hex Core mk-2 : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3197-SHOP** — Objet 3197 — The Hex Core mk-2 : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3197-ACCEPT** — Objet 3197 — The Hex Core mk-2 : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0184 — Objet 3198 — Perfect Hex Core

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3198-SCOPE** — Objet 3198 — Perfect Hex Core : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3198-SERVER** — Objet 3198 — Perfect Hex Core : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3198-SHOP** — Objet 3198 — Perfect Hex Core : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3198-ACCEPT** — Objet 3198 — Perfect Hex Core : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0185 — Objet 3200 — Prototype Hex Core

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3200-SCOPE** — Objet 3200 — Prototype Hex Core : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3200-SERVER** — Objet 3200 — Prototype Hex Core : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3200-SHOP** — Objet 3200 — Prototype Hex Core : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3200-ACCEPT** — Objet 3200 — Prototype Hex Core : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0186 — Objet 3204 — Quill Coat

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3204-SCOPE** — Objet 3204 — Quill Coat : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3204-SERVER** — Objet 3204 — Quill Coat : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3204-SHOP** — Objet 3204 — Quill Coat : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3204-ACCEPT** — Objet 3204 — Quill Coat : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0187 — Objet 3205 — Quill Coat

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3205-SCOPE** — Objet 3205 — Quill Coat : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3205-SERVER** — Objet 3205 — Quill Coat : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3205-SHOP** — Objet 3205 — Quill Coat : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3205-ACCEPT** — Objet 3205 — Quill Coat : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0188 — Objet 3206 — Spirit of the Spectral Wraith

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3206-SCOPE** — Objet 3206 — Spirit of the Spectral Wraith : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3206-SERVER** — Objet 3206 — Spirit of the Spectral Wraith : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3206-SHOP** — Objet 3206 — Spirit of the Spectral Wraith : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3206-ACCEPT** — Objet 3206 — Spirit of the Spectral Wraith : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0189 — Objet 3207 — Spirit of the Ancient Golem

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3207-SCOPE** — Objet 3207 — Spirit of the Ancient Golem : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3207-SERVER** — Objet 3207 — Spirit of the Ancient Golem : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3207-SHOP** — Objet 3207 — Spirit of the Ancient Golem : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3207-ACCEPT** — Objet 3207 — Spirit of the Ancient Golem : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0190 — Objet 3208 — Spirit of the Ancient Golem

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3208-SCOPE** — Objet 3208 — Spirit of the Ancient Golem : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3208-SERVER** — Objet 3208 — Spirit of the Ancient Golem : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3208-SHOP** — Objet 3208 — Spirit of the Ancient Golem : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3208-ACCEPT** — Objet 3208 — Spirit of the Ancient Golem : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0191 — Objet 3209 — Spirit of the Elder Lizard

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3209-SCOPE** — Objet 3209 — Spirit of the Elder Lizard : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3209-SERVER** — Objet 3209 — Spirit of the Elder Lizard : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3209-SHOP** — Objet 3209 — Spirit of the Elder Lizard : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3209-ACCEPT** — Objet 3209 — Spirit of the Elder Lizard : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0192 — Objet 3211 — Spectre's Cowl

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3211-SCOPE** — Objet 3211 — Spectre's Cowl : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3211-SERVER** — Objet 3211 — Spectre's Cowl : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3211-SHOP** — Objet 3211 — Spectre's Cowl : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3211-ACCEPT** — Objet 3211 — Spectre's Cowl : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0193 — Objet 3222 — Mikael's Crucible

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3222-SCOPE** — Objet 3222 — Mikael's Crucible : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3222-SERVER** — Objet 3222 — Mikael's Crucible : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3222-SHOP** — Objet 3222 — Mikael's Crucible : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3222-ACCEPT** — Objet 3222 — Mikael's Crucible : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0194 — Objet 3250 — Enchantment: Homeguard

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3250-SCOPE** — Objet 3250 — Enchantment: Homeguard : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3250-SERVER** — Objet 3250 — Enchantment: Homeguard : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3250-SHOP** — Objet 3250 — Enchantment: Homeguard : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3250-ACCEPT** — Objet 3250 — Enchantment: Homeguard : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0195 — Objet 3251 — Enchantment: Captain

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3251-SCOPE** — Objet 3251 — Enchantment: Captain : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3251-SERVER** — Objet 3251 — Enchantment: Captain : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3251-SHOP** — Objet 3251 — Enchantment: Captain : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3251-ACCEPT** — Objet 3251 — Enchantment: Captain : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0196 — Objet 3252 — Enchantment: Furor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3252-SCOPE** — Objet 3252 — Enchantment: Furor : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3252-SERVER** — Objet 3252 — Enchantment: Furor : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3252-SHOP** — Objet 3252 — Enchantment: Furor : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3252-ACCEPT** — Objet 3252 — Enchantment: Furor : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0197 — Objet 3253 — Enchantment: Distortion

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3253-SCOPE** — Objet 3253 — Enchantment: Distortion : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3253-SERVER** — Objet 3253 — Enchantment: Distortion : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3253-SHOP** — Objet 3253 — Enchantment: Distortion : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3253-ACCEPT** — Objet 3253 — Enchantment: Distortion : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0198 — Objet 3254 — Enchantment: Alacrity

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3254-SCOPE** — Objet 3254 — Enchantment: Alacrity : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3254-SERVER** — Objet 3254 — Enchantment: Alacrity : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3254-SHOP** — Objet 3254 — Enchantment: Alacrity : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3254-ACCEPT** — Objet 3254 — Enchantment: Alacrity : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0199 — Objet 3255 — Enchantment: Homeguard

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3255-SCOPE** — Objet 3255 — Enchantment: Homeguard : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3255-SERVER** — Objet 3255 — Enchantment: Homeguard : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3255-SHOP** — Objet 3255 — Enchantment: Homeguard : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3255-ACCEPT** — Objet 3255 — Enchantment: Homeguard : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0200 — Objet 3256 — Enchantment: Captain

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3256-SCOPE** — Objet 3256 — Enchantment: Captain : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3256-SERVER** — Objet 3256 — Enchantment: Captain : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3256-SHOP** — Objet 3256 — Enchantment: Captain : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3256-ACCEPT** — Objet 3256 — Enchantment: Captain : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0201 — Objet 3257 — Enchantment: Furor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3257-SCOPE** — Objet 3257 — Enchantment: Furor : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3257-SERVER** — Objet 3257 — Enchantment: Furor : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3257-SHOP** — Objet 3257 — Enchantment: Furor : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3257-ACCEPT** — Objet 3257 — Enchantment: Furor : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0202 — Objet 3258 — Enchantment: Distortion

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3258-SCOPE** — Objet 3258 — Enchantment: Distortion : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3258-SERVER** — Objet 3258 — Enchantment: Distortion : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3258-SHOP** — Objet 3258 — Enchantment: Distortion : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3258-ACCEPT** — Objet 3258 — Enchantment: Distortion : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0203 — Objet 3259 — Enchantment: Alacrity

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3259-SCOPE** — Objet 3259 — Enchantment: Alacrity : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3259-SERVER** — Objet 3259 — Enchantment: Alacrity : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3259-SHOP** — Objet 3259 — Enchantment: Alacrity : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3259-ACCEPT** — Objet 3259 — Enchantment: Alacrity : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0204 — Objet 3260 — Enchantment: Homeguard

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3260-SCOPE** — Objet 3260 — Enchantment: Homeguard : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3260-SERVER** — Objet 3260 — Enchantment: Homeguard : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3260-SHOP** — Objet 3260 — Enchantment: Homeguard : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3260-ACCEPT** — Objet 3260 — Enchantment: Homeguard : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0205 — Objet 3261 — Enchantment: Captain

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3261-SCOPE** — Objet 3261 — Enchantment: Captain : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3261-SERVER** — Objet 3261 — Enchantment: Captain : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3261-SHOP** — Objet 3261 — Enchantment: Captain : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3261-ACCEPT** — Objet 3261 — Enchantment: Captain : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0206 — Objet 3262 — Enchantment: Furor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3262-SCOPE** — Objet 3262 — Enchantment: Furor : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3262-SERVER** — Objet 3262 — Enchantment: Furor : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3262-SHOP** — Objet 3262 — Enchantment: Furor : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3262-ACCEPT** — Objet 3262 — Enchantment: Furor : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0207 — Objet 3263 — Enchantment: Distortion

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3263-SCOPE** — Objet 3263 — Enchantment: Distortion : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3263-SERVER** — Objet 3263 — Enchantment: Distortion : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3263-SHOP** — Objet 3263 — Enchantment: Distortion : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3263-ACCEPT** — Objet 3263 — Enchantment: Distortion : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0208 — Objet 3264 — Enchantment: Alacrity

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3264-SCOPE** — Objet 3264 — Enchantment: Alacrity : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3264-SERVER** — Objet 3264 — Enchantment: Alacrity : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3264-SHOP** — Objet 3264 — Enchantment: Alacrity : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3264-ACCEPT** — Objet 3264 — Enchantment: Alacrity : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0209 — Objet 3265 — Enchantment: Homeguard

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3265-SCOPE** — Objet 3265 — Enchantment: Homeguard : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3265-SERVER** — Objet 3265 — Enchantment: Homeguard : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3265-SHOP** — Objet 3265 — Enchantment: Homeguard : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3265-ACCEPT** — Objet 3265 — Enchantment: Homeguard : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0210 — Objet 3266 — Enchantment: Captain

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3266-SCOPE** — Objet 3266 — Enchantment: Captain : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3266-SERVER** — Objet 3266 — Enchantment: Captain : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3266-SHOP** — Objet 3266 — Enchantment: Captain : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3266-ACCEPT** — Objet 3266 — Enchantment: Captain : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0211 — Objet 3267 — Enchantment: Furor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3267-SCOPE** — Objet 3267 — Enchantment: Furor : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3267-SERVER** — Objet 3267 — Enchantment: Furor : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3267-SHOP** — Objet 3267 — Enchantment: Furor : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3267-ACCEPT** — Objet 3267 — Enchantment: Furor : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0212 — Objet 3268 — Enchantment: Distortion

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3268-SCOPE** — Objet 3268 — Enchantment: Distortion : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3268-SERVER** — Objet 3268 — Enchantment: Distortion : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3268-SHOP** — Objet 3268 — Enchantment: Distortion : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3268-ACCEPT** — Objet 3268 — Enchantment: Distortion : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0213 — Objet 3269 — Enchantment: Alacrity

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3269-SCOPE** — Objet 3269 — Enchantment: Alacrity : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3269-SERVER** — Objet 3269 — Enchantment: Alacrity : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3269-SHOP** — Objet 3269 — Enchantment: Alacrity : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3269-ACCEPT** — Objet 3269 — Enchantment: Alacrity : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0214 — Objet 3270 — Enchantment: Homeguard

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3270-SCOPE** — Objet 3270 — Enchantment: Homeguard : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3270-SERVER** — Objet 3270 — Enchantment: Homeguard : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3270-SHOP** — Objet 3270 — Enchantment: Homeguard : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3270-ACCEPT** — Objet 3270 — Enchantment: Homeguard : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0215 — Objet 3271 — Enchantment: Captain

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3271-SCOPE** — Objet 3271 — Enchantment: Captain : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3271-SERVER** — Objet 3271 — Enchantment: Captain : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3271-SHOP** — Objet 3271 — Enchantment: Captain : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3271-ACCEPT** — Objet 3271 — Enchantment: Captain : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0216 — Objet 3272 — Enchantment: Furor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3272-SCOPE** — Objet 3272 — Enchantment: Furor : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3272-SERVER** — Objet 3272 — Enchantment: Furor : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3272-SHOP** — Objet 3272 — Enchantment: Furor : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3272-ACCEPT** — Objet 3272 — Enchantment: Furor : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0217 — Objet 3273 — Enchantment: Distortion

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3273-SCOPE** — Objet 3273 — Enchantment: Distortion : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3273-SERVER** — Objet 3273 — Enchantment: Distortion : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3273-SHOP** — Objet 3273 — Enchantment: Distortion : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3273-ACCEPT** — Objet 3273 — Enchantment: Distortion : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0218 — Objet 3274 — Enchantment: Alacrity

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3274-SCOPE** — Objet 3274 — Enchantment: Alacrity : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3274-SERVER** — Objet 3274 — Enchantment: Alacrity : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3274-SHOP** — Objet 3274 — Enchantment: Alacrity : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3274-ACCEPT** — Objet 3274 — Enchantment: Alacrity : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0219 — Objet 3275 — Enchantment: Homeguard

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3275-SCOPE** — Objet 3275 — Enchantment: Homeguard : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3275-SERVER** — Objet 3275 — Enchantment: Homeguard : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3275-SHOP** — Objet 3275 — Enchantment: Homeguard : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3275-ACCEPT** — Objet 3275 — Enchantment: Homeguard : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0220 — Objet 3276 — Enchantment: Captain

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3276-SCOPE** — Objet 3276 — Enchantment: Captain : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3276-SERVER** — Objet 3276 — Enchantment: Captain : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3276-SHOP** — Objet 3276 — Enchantment: Captain : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3276-ACCEPT** — Objet 3276 — Enchantment: Captain : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0221 — Objet 3277 — Enchantment: Furor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3277-SCOPE** — Objet 3277 — Enchantment: Furor : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3277-SERVER** — Objet 3277 — Enchantment: Furor : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3277-SHOP** — Objet 3277 — Enchantment: Furor : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3277-ACCEPT** — Objet 3277 — Enchantment: Furor : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0222 — Objet 3278 — Enchantment: Distortion

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3278-SCOPE** — Objet 3278 — Enchantment: Distortion : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3278-SERVER** — Objet 3278 — Enchantment: Distortion : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3278-SHOP** — Objet 3278 — Enchantment: Distortion : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3278-ACCEPT** — Objet 3278 — Enchantment: Distortion : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0223 — Objet 3279 — Enchantment: Alacrity

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3279-SCOPE** — Objet 3279 — Enchantment: Alacrity : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3279-SERVER** — Objet 3279 — Enchantment: Alacrity : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3279-SHOP** — Objet 3279 — Enchantment: Alacrity : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3279-ACCEPT** — Objet 3279 — Enchantment: Alacrity : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0224 — Objet 3280 — Enchantment: Homeguard

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3280-SCOPE** — Objet 3280 — Enchantment: Homeguard : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3280-SERVER** — Objet 3280 — Enchantment: Homeguard : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3280-SHOP** — Objet 3280 — Enchantment: Homeguard : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3280-ACCEPT** — Objet 3280 — Enchantment: Homeguard : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0225 — Objet 3281 — Enchantment: Captain

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3281-SCOPE** — Objet 3281 — Enchantment: Captain : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3281-SERVER** — Objet 3281 — Enchantment: Captain : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3281-SHOP** — Objet 3281 — Enchantment: Captain : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3281-ACCEPT** — Objet 3281 — Enchantment: Captain : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0226 — Objet 3282 — Enchantment: Furor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3282-SCOPE** — Objet 3282 — Enchantment: Furor : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3282-SERVER** — Objet 3282 — Enchantment: Furor : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3282-SHOP** — Objet 3282 — Enchantment: Furor : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3282-ACCEPT** — Objet 3282 — Enchantment: Furor : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0227 — Objet 3283 — Enchantment: Distortion

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3283-SCOPE** — Objet 3283 — Enchantment: Distortion : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3283-SERVER** — Objet 3283 — Enchantment: Distortion : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3283-SHOP** — Objet 3283 — Enchantment: Distortion : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3283-ACCEPT** — Objet 3283 — Enchantment: Distortion : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0228 — Objet 3284 — Enchantment: Alacrity

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3284-SCOPE** — Objet 3284 — Enchantment: Alacrity : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3284-SERVER** — Objet 3284 — Enchantment: Alacrity : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3284-SHOP** — Objet 3284 — Enchantment: Alacrity : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3284-ACCEPT** — Objet 3284 — Enchantment: Alacrity : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0229 — Objet 3290 — Twin Shadows

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3290-SCOPE** — Objet 3290 — Twin Shadows : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3290-SERVER** — Objet 3290 — Twin Shadows : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3290-SHOP** — Objet 3290 — Twin Shadows : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3290-ACCEPT** — Objet 3290 — Twin Shadows : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0230 — Objet 3301 — Ancient Coin

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3301-SCOPE** — Objet 3301 — Ancient Coin : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3301-SERVER** — Objet 3301 — Ancient Coin : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3301-SHOP** — Objet 3301 — Ancient Coin : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3301-ACCEPT** — Objet 3301 — Ancient Coin : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0231 — Objet 3302 — Relic Shield

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3302-SCOPE** — Objet 3302 — Relic Shield : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3302-SERVER** — Objet 3302 — Relic Shield : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3302-SHOP** — Objet 3302 — Relic Shield : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3302-ACCEPT** — Objet 3302 — Relic Shield : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0232 — Objet 3303 — Spellthief's Edge

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3303-SCOPE** — Objet 3303 — Spellthief's Edge : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3303-SERVER** — Objet 3303 — Spellthief's Edge : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3303-SHOP** — Objet 3303 — Spellthief's Edge : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3303-ACCEPT** — Objet 3303 — Spellthief's Edge : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0233 — Objet 3340 — Warding Totem (Trinket)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3340-SCOPE** — Objet 3340 — Warding Totem (Trinket) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3340-SERVER** — Objet 3340 — Warding Totem (Trinket) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3340-SHOP** — Objet 3340 — Warding Totem (Trinket) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3340-ACCEPT** — Objet 3340 — Warding Totem (Trinket) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0234 — Objet 3341 — Sweeping Lens (Trinket)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3341-SCOPE** — Objet 3341 — Sweeping Lens (Trinket) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3341-SERVER** — Objet 3341 — Sweeping Lens (Trinket) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3341-SHOP** — Objet 3341 — Sweeping Lens (Trinket) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3341-ACCEPT** — Objet 3341 — Sweeping Lens (Trinket) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0235 — Objet 3342 — Scrying Orb (Trinket)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3342-SCOPE** — Objet 3342 — Scrying Orb (Trinket) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3342-SERVER** — Objet 3342 — Scrying Orb (Trinket) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3342-SHOP** — Objet 3342 — Scrying Orb (Trinket) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3342-ACCEPT** — Objet 3342 — Scrying Orb (Trinket) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0236 — Objet 3345 — Soul Anchor (Trinket)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3345-SCOPE** — Objet 3345 — Soul Anchor (Trinket) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3345-SERVER** — Objet 3345 — Soul Anchor (Trinket) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3345-SHOP** — Objet 3345 — Soul Anchor (Trinket) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3345-ACCEPT** — Objet 3345 — Soul Anchor (Trinket) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0237 — Objet 3361 — Greater Stealth Totem (Trinket)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3361-SCOPE** — Objet 3361 — Greater Stealth Totem (Trinket) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3361-SERVER** — Objet 3361 — Greater Stealth Totem (Trinket) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3361-SHOP** — Objet 3361 — Greater Stealth Totem (Trinket) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3361-ACCEPT** — Objet 3361 — Greater Stealth Totem (Trinket) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0238 — Objet 3362 — Greater Vision Totem (Trinket)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3362-SCOPE** — Objet 3362 — Greater Vision Totem (Trinket) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3362-SERVER** — Objet 3362 — Greater Vision Totem (Trinket) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3362-SHOP** — Objet 3362 — Greater Vision Totem (Trinket) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3362-ACCEPT** — Objet 3362 — Greater Vision Totem (Trinket) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0239 — Objet 3363 — Farsight Orb (Trinket)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3363-SCOPE** — Objet 3363 — Farsight Orb (Trinket) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3363-SERVER** — Objet 3363 — Farsight Orb (Trinket) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3363-SHOP** — Objet 3363 — Farsight Orb (Trinket) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3363-ACCEPT** — Objet 3363 — Farsight Orb (Trinket) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0240 — Objet 3364 — Oracle's Lens (Trinket)

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3364-SCOPE** — Objet 3364 — Oracle's Lens (Trinket) : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3364-SERVER** — Objet 3364 — Oracle's Lens (Trinket) : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3364-SHOP** — Objet 3364 — Oracle's Lens (Trinket) : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3364-ACCEPT** — Objet 3364 — Oracle's Lens (Trinket) : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0241 — Objet 3401 — Face of the Mountain

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3401-SCOPE** — Objet 3401 — Face of the Mountain : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3401-SERVER** — Objet 3401 — Face of the Mountain : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3401-SHOP** — Objet 3401 — Face of the Mountain : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3401-ACCEPT** — Objet 3401 — Face of the Mountain : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0242 — Objet 3405 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3405-SCOPE** — Objet 3405 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3405-SERVER** — Objet 3405 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3405-SHOP** — Objet 3405 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3405-ACCEPT** — Objet 3405 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0243 — Objet 3406 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3406-SCOPE** — Objet 3406 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3406-SERVER** — Objet 3406 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3406-SHOP** — Objet 3406 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3406-ACCEPT** — Objet 3406 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0244 — Objet 3407 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3407-SCOPE** — Objet 3407 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3407-SERVER** — Objet 3407 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3407-SHOP** — Objet 3407 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3407-ACCEPT** — Objet 3407 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0245 — Objet 3408 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3408-SCOPE** — Objet 3408 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3408-SERVER** — Objet 3408 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3408-SHOP** — Objet 3408 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3408-ACCEPT** — Objet 3408 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0246 — Objet 3409 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3409-SCOPE** — Objet 3409 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3409-SERVER** — Objet 3409 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3409-SHOP** — Objet 3409 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3409-ACCEPT** — Objet 3409 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0247 — Objet 3410 — Head of Kha'Zix

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3410-SCOPE** — Objet 3410 — Head of Kha'Zix : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3410-SERVER** — Objet 3410 — Head of Kha'Zix : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3410-SHOP** — Objet 3410 — Head of Kha'Zix : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3410-ACCEPT** — Objet 3410 — Head of Kha'Zix : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0248 — Objet 3411 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3411-SCOPE** — Objet 3411 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3411-SERVER** — Objet 3411 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3411-SHOP** — Objet 3411 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3411-ACCEPT** — Objet 3411 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0249 — Objet 3412 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3412-SCOPE** — Objet 3412 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3412-SERVER** — Objet 3412 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3412-SHOP** — Objet 3412 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3412-ACCEPT** — Objet 3412 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0250 — Objet 3413 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3413-SCOPE** — Objet 3413 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3413-SERVER** — Objet 3413 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3413-SHOP** — Objet 3413 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3413-ACCEPT** — Objet 3413 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0251 — Objet 3414 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3414-SCOPE** — Objet 3414 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3414-SERVER** — Objet 3414 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3414-SHOP** — Objet 3414 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3414-ACCEPT** — Objet 3414 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0252 — Objet 3415 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3415-SCOPE** — Objet 3415 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3415-SERVER** — Objet 3415 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3415-SHOP** — Objet 3415 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3415-ACCEPT** — Objet 3415 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0253 — Objet 3416 — Head of Kha'Zix

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3416-SCOPE** — Objet 3416 — Head of Kha'Zix : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3416-SERVER** — Objet 3416 — Head of Kha'Zix : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3416-SHOP** — Objet 3416 — Head of Kha'Zix : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3416-ACCEPT** — Objet 3416 — Head of Kha'Zix : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0254 — Objet 3417 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3417-SCOPE** — Objet 3417 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3417-SERVER** — Objet 3417 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3417-SHOP** — Objet 3417 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3417-ACCEPT** — Objet 3417 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0255 — Objet 3418 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3418-SCOPE** — Objet 3418 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3418-SERVER** — Objet 3418 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3418-SHOP** — Objet 3418 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3418-ACCEPT** — Objet 3418 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0256 — Objet 3419 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3419-SCOPE** — Objet 3419 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3419-SERVER** — Objet 3419 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3419-SHOP** — Objet 3419 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3419-ACCEPT** — Objet 3419 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0257 — Objet 3420 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3420-SCOPE** — Objet 3420 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3420-SERVER** — Objet 3420 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3420-SHOP** — Objet 3420 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3420-ACCEPT** — Objet 3420 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0258 — Objet 3421 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3421-SCOPE** — Objet 3421 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3421-SERVER** — Objet 3421 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3421-SHOP** — Objet 3421 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3421-ACCEPT** — Objet 3421 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0259 — Objet 3422 — Head of Kha'Zix

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3422-SCOPE** — Objet 3422 — Head of Kha'Zix : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3422-SERVER** — Objet 3422 — Head of Kha'Zix : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3422-SHOP** — Objet 3422 — Head of Kha'Zix : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3422-ACCEPT** — Objet 3422 — Head of Kha'Zix : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0260 — Objet 3450 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3450-SCOPE** — Objet 3450 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3450-SERVER** — Objet 3450 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3450-SHOP** — Objet 3450 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3450-ACCEPT** — Objet 3450 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0261 — Objet 3451 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3451-SCOPE** — Objet 3451 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3451-SERVER** — Objet 3451 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3451-SHOP** — Objet 3451 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3451-ACCEPT** — Objet 3451 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0262 — Objet 3452 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3452-SCOPE** — Objet 3452 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3452-SERVER** — Objet 3452 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3452-SHOP** — Objet 3452 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3452-ACCEPT** — Objet 3452 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0263 — Objet 3453 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3453-SCOPE** — Objet 3453 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3453-SERVER** — Objet 3453 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3453-SHOP** — Objet 3453 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3453-ACCEPT** — Objet 3453 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0264 — Objet 3454 — Bonetooth Necklace

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3454-SCOPE** — Objet 3454 — Bonetooth Necklace : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3454-SERVER** — Objet 3454 — Bonetooth Necklace : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3454-SHOP** — Objet 3454 — Bonetooth Necklace : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3454-ACCEPT** — Objet 3454 — Bonetooth Necklace : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0265 — Objet 3455 — Head of Kha'Zix

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3455-SCOPE** — Objet 3455 — Head of Kha'Zix : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3455-SERVER** — Objet 3455 — Head of Kha'Zix : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3455-SHOP** — Objet 3455 — Head of Kha'Zix : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3455-ACCEPT** — Objet 3455 — Head of Kha'Zix : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0266 — Objet 3460 — Golden Transcendence

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3460-SCOPE** — Objet 3460 — Golden Transcendence : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3460-SERVER** — Objet 3460 — Golden Transcendence : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3460-SHOP** — Objet 3460 — Golden Transcendence : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3460-ACCEPT** — Objet 3460 — Golden Transcendence : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0267 — Objet 3504 — Ardent Censer

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3504-SCOPE** — Objet 3504 — Ardent Censer : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3504-SERVER** — Objet 3504 — Ardent Censer : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3504-SHOP** — Objet 3504 — Ardent Censer : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3504-ACCEPT** — Objet 3504 — Ardent Censer : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0268 — Objet 3508 — Essence Reaver

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3508-SCOPE** — Objet 3508 — Essence Reaver : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3508-SERVER** — Objet 3508 — Essence Reaver : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3508-SHOP** — Objet 3508 — Essence Reaver : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3508-ACCEPT** — Objet 3508 — Essence Reaver : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0269 — Objet 3599 — The Black Spear

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3599-SCOPE** — Objet 3599 — The Black Spear : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3599-SERVER** — Objet 3599 — The Black Spear : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3599-SHOP** — Objet 3599 — The Black Spear : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3599-ACCEPT** — Objet 3599 — The Black Spear : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0270 — Objet 3706 — Stalker's Blade

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3706-SCOPE** — Objet 3706 — Stalker's Blade : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3706-SERVER** — Objet 3706 — Stalker's Blade : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3706-SHOP** — Objet 3706 — Stalker's Blade : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3706-ACCEPT** — Objet 3706 — Stalker's Blade : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0271 — Objet 3707 — Enchantment: Warrior

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3707-SCOPE** — Objet 3707 — Enchantment: Warrior : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3707-SERVER** — Objet 3707 — Enchantment: Warrior : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3707-SHOP** — Objet 3707 — Enchantment: Warrior : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3707-ACCEPT** — Objet 3707 — Enchantment: Warrior : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0272 — Objet 3708 — Enchantment: Magus

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3708-SCOPE** — Objet 3708 — Enchantment: Magus : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3708-SERVER** — Objet 3708 — Enchantment: Magus : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3708-SHOP** — Objet 3708 — Enchantment: Magus : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3708-ACCEPT** — Objet 3708 — Enchantment: Magus : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0273 — Objet 3709 — Enchantment: Juggernaut

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3709-SCOPE** — Objet 3709 — Enchantment: Juggernaut : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3709-SERVER** — Objet 3709 — Enchantment: Juggernaut : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3709-SHOP** — Objet 3709 — Enchantment: Juggernaut : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3709-ACCEPT** — Objet 3709 — Enchantment: Juggernaut : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0274 — Objet 3710 — Enchantment: Devourer

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3710-SCOPE** — Objet 3710 — Enchantment: Devourer : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3710-SERVER** — Objet 3710 — Enchantment: Devourer : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3710-SHOP** — Objet 3710 — Enchantment: Devourer : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3710-ACCEPT** — Objet 3710 — Enchantment: Devourer : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0275 — Objet 3711 — Poacher's Knife

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3711-SCOPE** — Objet 3711 — Poacher's Knife : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3711-SERVER** — Objet 3711 — Poacher's Knife : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3711-SHOP** — Objet 3711 — Poacher's Knife : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3711-ACCEPT** — Objet 3711 — Poacher's Knife : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0276 — Objet 3713 — Ranger's Trailblazer

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3713-SCOPE** — Objet 3713 — Ranger's Trailblazer : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3713-SERVER** — Objet 3713 — Ranger's Trailblazer : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3713-SHOP** — Objet 3713 — Ranger's Trailblazer : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3713-ACCEPT** — Objet 3713 — Ranger's Trailblazer : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0277 — Objet 3714 — Enchantment: Warrior

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3714-SCOPE** — Objet 3714 — Enchantment: Warrior : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3714-SERVER** — Objet 3714 — Enchantment: Warrior : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3714-SHOP** — Objet 3714 — Enchantment: Warrior : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3714-ACCEPT** — Objet 3714 — Enchantment: Warrior : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0278 — Objet 3715 — Skirmisher's Sabre

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3715-SCOPE** — Objet 3715 — Skirmisher's Sabre : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3715-SERVER** — Objet 3715 — Skirmisher's Sabre : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3715-SHOP** — Objet 3715 — Skirmisher's Sabre : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3715-ACCEPT** — Objet 3715 — Skirmisher's Sabre : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0279 — Objet 3716 — Enchantment: Magus

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3716-SCOPE** — Objet 3716 — Enchantment: Magus : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3716-SERVER** — Objet 3716 — Enchantment: Magus : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3716-SHOP** — Objet 3716 — Enchantment: Magus : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3716-ACCEPT** — Objet 3716 — Enchantment: Magus : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0280 — Objet 3717 — Enchantment: Juggernaut

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3717-SCOPE** — Objet 3717 — Enchantment: Juggernaut : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3717-SERVER** — Objet 3717 — Enchantment: Juggernaut : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3717-SHOP** — Objet 3717 — Enchantment: Juggernaut : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3717-ACCEPT** — Objet 3717 — Enchantment: Juggernaut : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0281 — Objet 3718 — Enchantment: Devourer

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3718-SCOPE** — Objet 3718 — Enchantment: Devourer : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3718-SERVER** — Objet 3718 — Enchantment: Devourer : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3718-SHOP** — Objet 3718 — Enchantment: Devourer : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3718-ACCEPT** — Objet 3718 — Enchantment: Devourer : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0282 — Objet 3719 — Enchantment: Warrior

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3719-SCOPE** — Objet 3719 — Enchantment: Warrior : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3719-SERVER** — Objet 3719 — Enchantment: Warrior : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3719-SHOP** — Objet 3719 — Enchantment: Warrior : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3719-ACCEPT** — Objet 3719 — Enchantment: Warrior : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0283 — Objet 3720 — Enchantment: Magus

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3720-SCOPE** — Objet 3720 — Enchantment: Magus : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3720-SERVER** — Objet 3720 — Enchantment: Magus : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3720-SHOP** — Objet 3720 — Enchantment: Magus : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3720-ACCEPT** — Objet 3720 — Enchantment: Magus : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0284 — Objet 3721 — Enchantment: Juggernaut

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3721-SCOPE** — Objet 3721 — Enchantment: Juggernaut : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3721-SERVER** — Objet 3721 — Enchantment: Juggernaut : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3721-SHOP** — Objet 3721 — Enchantment: Juggernaut : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3721-ACCEPT** — Objet 3721 — Enchantment: Juggernaut : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0285 — Objet 3722 — Enchantment: Devourer

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3722-SCOPE** — Objet 3722 — Enchantment: Devourer : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3722-SERVER** — Objet 3722 — Enchantment: Devourer : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3722-SHOP** — Objet 3722 — Enchantment: Devourer : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3722-ACCEPT** — Objet 3722 — Enchantment: Devourer : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0286 — Objet 3723 — Enchantment: Warrior

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3723-SCOPE** — Objet 3723 — Enchantment: Warrior : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3723-SERVER** — Objet 3723 — Enchantment: Warrior : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3723-SHOP** — Objet 3723 — Enchantment: Warrior : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3723-ACCEPT** — Objet 3723 — Enchantment: Warrior : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0287 — Objet 3724 — Enchantment: Magus

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3724-SCOPE** — Objet 3724 — Enchantment: Magus : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3724-SERVER** — Objet 3724 — Enchantment: Magus : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3724-SHOP** — Objet 3724 — Enchantment: Magus : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3724-ACCEPT** — Objet 3724 — Enchantment: Magus : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0288 — Objet 3725 — Enchantment: Juggernaut

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3725-SCOPE** — Objet 3725 — Enchantment: Juggernaut : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3725-SERVER** — Objet 3725 — Enchantment: Juggernaut : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3725-SHOP** — Objet 3725 — Enchantment: Juggernaut : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3725-ACCEPT** — Objet 3725 — Enchantment: Juggernaut : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0289 — Objet 3726 — Enchantment: Devourer

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3726-SCOPE** — Objet 3726 — Enchantment: Devourer : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3726-SERVER** — Objet 3726 — Enchantment: Devourer : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3726-SHOP** — Objet 3726 — Enchantment: Devourer : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3726-ACCEPT** — Objet 3726 — Enchantment: Devourer : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0290 — Objet 3800 — Righteous Glory

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3800-SCOPE** — Objet 3800 — Righteous Glory : Qualifier version, cartes, restrictions, prix et recettes — disponibilité 4.20 à classifier
- [ ] **ITEM-3800-SERVER** — Objet 3800 — Righteous Glory : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — disponibilité 4.20 à classifier
- [ ] **ITEM-3800-SHOP** — Objet 3800 — Righteous Glory : Achever icône, texte, recette, achat/vente/annulation et inventaire — disponibilité 4.20 à classifier
- [ ] **ITEM-3800-ACCEPT** — Objet 3800 — Righteous Glory : Tester ressources, composants, cumul, usages, décès et échanges réseau — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0291 — Objet 3801 — Crystalline Bracer

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **ITEM-3801-SCOPE** — Objet 3801 — Crystalline Bracer : Qualifier version, cartes, restrictions, prix et recettes — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3801-SERVER** — Objet 3801 — Crystalline Bracer : Terminer stats, groupes uniques, passifs, actifs, charges et transformations nécessaires — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3801-SHOP** — Objet 3801 — Crystalline Bracer : Achever icône, texte, recette, achat/vente/annulation et inventaire — travail existant à terminer/qualifier — disponibilité 4.20 à classifier
- [ ] **ITEM-3801-ACCEPT** — Objet 3801 — Crystalline Bracer : Tester ressources, composants, cumul, usages, décès et échanges réseau — travail existant à terminer/qualifier — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0292 — rune 10001 — Razer Mark of Precision

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-10001-SCOPE** — rune 10001 — Razer Mark of Precision : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-10001-SERVER** — rune 10001 — Razer Mark of Precision : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0293 — rune 10002 — Razer Quintessence of Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-10002-SCOPE** — rune 10002 — Razer Quintessence of Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-10002-SERVER** — rune 10002 — Razer Quintessence of Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0294 — rune 5001 — Lesser Mark of Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5001-SCOPE** — rune 5001 — Lesser Mark of Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5001-SERVER** — rune 5001 — Lesser Mark of Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0295 — rune 5002 — Lesser Mark of Scaling Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5002-SCOPE** — rune 5002 — Lesser Mark of Scaling Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5002-SERVER** — rune 5002 — Lesser Mark of Scaling Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0296 — rune 5003 — Lesser Mark of Attack Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5003-SCOPE** — rune 5003 — Lesser Mark of Attack Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5003-SERVER** — rune 5003 — Lesser Mark of Attack Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0297 — rune 5005 — Lesser Mark of Critical Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5005-SCOPE** — rune 5005 — Lesser Mark of Critical Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5005-SERVER** — rune 5005 — Lesser Mark of Critical Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0298 — rune 5007 — Lesser Mark of Critical Chance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5007-SCOPE** — rune 5007 — Lesser Mark of Critical Chance : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5007-SERVER** — rune 5007 — Lesser Mark of Critical Chance : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0299 — rune 5009 — Lesser Mark of Armor Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5009-SCOPE** — rune 5009 — Lesser Mark of Armor Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5009-SERVER** — rune 5009 — Lesser Mark of Armor Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0300 — rune 5011 — Lesser Mark of Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5011-SCOPE** — rune 5011 — Lesser Mark of Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5011-SERVER** — rune 5011 — Lesser Mark of Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0301 — rune 5012 — Lesser Mark of Scaling Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5012-SCOPE** — rune 5012 — Lesser Mark of Scaling Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5012-SERVER** — rune 5012 — Lesser Mark of Scaling Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0302 — rune 5013 — Lesser Mark of Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5013-SCOPE** — rune 5013 — Lesser Mark of Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5013-SERVER** — rune 5013 — Lesser Mark of Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0303 — rune 5015 — Lesser Mark of Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5015-SCOPE** — rune 5015 — Lesser Mark of Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5015-SERVER** — rune 5015 — Lesser Mark of Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0304 — rune 5016 — Lesser Mark of Scaling Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5016-SCOPE** — rune 5016 — Lesser Mark of Scaling Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5016-SERVER** — rune 5016 — Lesser Mark of Scaling Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0305 — rune 5021 — Lesser Mark of Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5021-SCOPE** — rune 5021 — Lesser Mark of Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5021-SERVER** — rune 5021 — Lesser Mark of Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0306 — rune 5023 — Lesser Mark of Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5023-SCOPE** — rune 5023 — Lesser Mark of Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5023-SERVER** — rune 5023 — Lesser Mark of Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0307 — rune 5024 — Lesser Mark of Scaling Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5024-SCOPE** — rune 5024 — Lesser Mark of Scaling Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5024-SERVER** — rune 5024 — Lesser Mark of Scaling Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0308 — rune 5025 — Lesser Mark of Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5025-SCOPE** — rune 5025 — Lesser Mark of Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5025-SERVER** — rune 5025 — Lesser Mark of Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0309 — rune 5026 — Lesser Mark of Scaling Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5026-SCOPE** — rune 5026 — Lesser Mark of Scaling Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5026-SERVER** — rune 5026 — Lesser Mark of Scaling Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0310 — rune 5027 — Lesser Mark of Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5027-SCOPE** — rune 5027 — Lesser Mark of Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5027-SERVER** — rune 5027 — Lesser Mark of Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0311 — rune 5029 — Lesser Mark of Magic Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5029-SCOPE** — rune 5029 — Lesser Mark of Magic Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5029-SERVER** — rune 5029 — Lesser Mark of Magic Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0312 — rune 5031 — Lesser Glyph of Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5031-SCOPE** — rune 5031 — Lesser Glyph of Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5031-SERVER** — rune 5031 — Lesser Glyph of Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0313 — rune 5032 — Lesser Glyph of Scaling Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5032-SCOPE** — rune 5032 — Lesser Glyph of Scaling Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5032-SERVER** — rune 5032 — Lesser Glyph of Scaling Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0314 — rune 5033 — Lesser Glyph of Attack Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5033-SCOPE** — rune 5033 — Lesser Glyph of Attack Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5033-SERVER** — rune 5033 — Lesser Glyph of Attack Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0315 — rune 5035 — Lesser Glyph of Critical Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5035-SCOPE** — rune 5035 — Lesser Glyph of Critical Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5035-SERVER** — rune 5035 — Lesser Glyph of Critical Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0316 — rune 5037 — Lesser Glyph of Critical Chance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5037-SCOPE** — rune 5037 — Lesser Glyph of Critical Chance : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5037-SERVER** — rune 5037 — Lesser Glyph of Critical Chance : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0317 — rune 5041 — Lesser Glyph of Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5041-SCOPE** — rune 5041 — Lesser Glyph of Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5041-SERVER** — rune 5041 — Lesser Glyph of Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0318 — rune 5042 — Lesser Glyph of Scaling Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5042-SCOPE** — rune 5042 — Lesser Glyph of Scaling Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5042-SERVER** — rune 5042 — Lesser Glyph of Scaling Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0319 — rune 5043 — Lesser Glyph of Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5043-SCOPE** — rune 5043 — Lesser Glyph of Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5043-SERVER** — rune 5043 — Lesser Glyph of Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0320 — rune 5045 — Lesser Glyph of Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5045-SCOPE** — rune 5045 — Lesser Glyph of Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5045-SERVER** — rune 5045 — Lesser Glyph of Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0321 — rune 5046 — Lesser Glyph of Scaling Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5046-SCOPE** — rune 5046 — Lesser Glyph of Scaling Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5046-SERVER** — rune 5046 — Lesser Glyph of Scaling Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0322 — rune 5047 — Lesser Glyph of Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5047-SCOPE** — rune 5047 — Lesser Glyph of Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5047-SERVER** — rune 5047 — Lesser Glyph of Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0323 — rune 5051 — Lesser Glyph of Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5051-SCOPE** — rune 5051 — Lesser Glyph of Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5051-SERVER** — rune 5051 — Lesser Glyph of Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0324 — rune 5052 — Lesser Glyph of Scaling Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5052-SCOPE** — rune 5052 — Lesser Glyph of Scaling Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5052-SERVER** — rune 5052 — Lesser Glyph of Scaling Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0325 — rune 5053 — Lesser Glyph of Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5053-SCOPE** — rune 5053 — Lesser Glyph of Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5053-SERVER** — rune 5053 — Lesser Glyph of Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0326 — rune 5054 — Lesser Glyph of Scaling Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5054-SCOPE** — rune 5054 — Lesser Glyph of Scaling Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5054-SERVER** — rune 5054 — Lesser Glyph of Scaling Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0327 — rune 5055 — Lesser Glyph of Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5055-SCOPE** — rune 5055 — Lesser Glyph of Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5055-SERVER** — rune 5055 — Lesser Glyph of Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0328 — rune 5056 — Lesser Glyph of Scaling Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5056-SCOPE** — rune 5056 — Lesser Glyph of Scaling Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5056-SERVER** — rune 5056 — Lesser Glyph of Scaling Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0329 — rune 5057 — Lesser Glyph of Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5057-SCOPE** — rune 5057 — Lesser Glyph of Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5057-SERVER** — rune 5057 — Lesser Glyph of Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0330 — rune 5058 — Lesser Glyph of Scaling Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5058-SCOPE** — rune 5058 — Lesser Glyph of Scaling Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5058-SERVER** — rune 5058 — Lesser Glyph of Scaling Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0331 — rune 5059 — Lesser Glyph of Magic Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5059-SCOPE** — rune 5059 — Lesser Glyph of Magic Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5059-SERVER** — rune 5059 — Lesser Glyph of Magic Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0332 — rune 5061 — Lesser Seal of Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5061-SCOPE** — rune 5061 — Lesser Seal of Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5061-SERVER** — rune 5061 — Lesser Seal of Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0333 — rune 5062 — Lesser Seal of Scaling Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5062-SCOPE** — rune 5062 — Lesser Seal of Scaling Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5062-SERVER** — rune 5062 — Lesser Seal of Scaling Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0334 — rune 5063 — Lesser Seal of Attack Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5063-SCOPE** — rune 5063 — Lesser Seal of Attack Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5063-SERVER** — rune 5063 — Lesser Seal of Attack Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0335 — rune 5065 — Lesser Seal of Critical Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5065-SCOPE** — rune 5065 — Lesser Seal of Critical Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5065-SERVER** — rune 5065 — Lesser Seal of Critical Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0336 — rune 5067 — Lesser Seal of Critical Chance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5067-SCOPE** — rune 5067 — Lesser Seal of Critical Chance : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5067-SERVER** — rune 5067 — Lesser Seal of Critical Chance : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0337 — rune 5071 — Lesser Seal of Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5071-SCOPE** — rune 5071 — Lesser Seal of Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5071-SERVER** — rune 5071 — Lesser Seal of Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0338 — rune 5072 — Lesser Seal of Scaling Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5072-SCOPE** — rune 5072 — Lesser Seal of Scaling Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5072-SERVER** — rune 5072 — Lesser Seal of Scaling Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0339 — rune 5073 — Lesser Seal of Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5073-SCOPE** — rune 5073 — Lesser Seal of Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5073-SERVER** — rune 5073 — Lesser Seal of Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0340 — rune 5074 — Lesser Seal of Scaling Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5074-SCOPE** — rune 5074 — Lesser Seal of Scaling Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5074-SERVER** — rune 5074 — Lesser Seal of Scaling Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0341 — rune 5075 — Lesser Seal of Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5075-SCOPE** — rune 5075 — Lesser Seal of Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5075-SERVER** — rune 5075 — Lesser Seal of Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0342 — rune 5076 — Lesser Seal of Scaling Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5076-SCOPE** — rune 5076 — Lesser Seal of Scaling Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5076-SERVER** — rune 5076 — Lesser Seal of Scaling Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0343 — rune 5077 — Lesser Seal of Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5077-SCOPE** — rune 5077 — Lesser Seal of Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5077-SERVER** — rune 5077 — Lesser Seal of Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0344 — rune 5078 — Lesser Seal of Scaling Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5078-SCOPE** — rune 5078 — Lesser Seal of Scaling Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5078-SERVER** — rune 5078 — Lesser Seal of Scaling Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0345 — rune 5081 — Lesser Seal of Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5081-SCOPE** — rune 5081 — Lesser Seal of Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5081-SERVER** — rune 5081 — Lesser Seal of Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0346 — rune 5083 — Lesser Seal of Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5083-SCOPE** — rune 5083 — Lesser Seal of Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5083-SERVER** — rune 5083 — Lesser Seal of Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0347 — rune 5084 — Lesser Seal of Scaling Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5084-SCOPE** — rune 5084 — Lesser Seal of Scaling Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5084-SERVER** — rune 5084 — Lesser Seal of Scaling Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0348 — rune 5085 — Lesser Seal of Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5085-SCOPE** — rune 5085 — Lesser Seal of Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5085-SERVER** — rune 5085 — Lesser Seal of Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0349 — rune 5086 — Lesser Seal of Scaling Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5086-SCOPE** — rune 5086 — Lesser Seal of Scaling Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5086-SERVER** — rune 5086 — Lesser Seal of Scaling Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0350 — rune 5087 — Lesser Seal of Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5087-SCOPE** — rune 5087 — Lesser Seal of Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5087-SERVER** — rune 5087 — Lesser Seal of Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0351 — rune 5088 — Lesser Seal of Scaling Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5088-SCOPE** — rune 5088 — Lesser Seal of Scaling Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5088-SERVER** — rune 5088 — Lesser Seal of Scaling Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0352 — rune 5091 — Lesser Quintessence of Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5091-SCOPE** — rune 5091 — Lesser Quintessence of Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5091-SERVER** — rune 5091 — Lesser Quintessence of Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0353 — rune 5092 — Lesser Quintessence of Scaling Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5092-SCOPE** — rune 5092 — Lesser Quintessence of Scaling Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5092-SERVER** — rune 5092 — Lesser Quintessence of Scaling Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0354 — rune 5093 — Lesser Quintessence of Attack Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5093-SCOPE** — rune 5093 — Lesser Quintessence of Attack Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5093-SERVER** — rune 5093 — Lesser Quintessence of Attack Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0355 — rune 5095 — Lesser Quintessence of Critical Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5095-SCOPE** — rune 5095 — Lesser Quintessence of Critical Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5095-SERVER** — rune 5095 — Lesser Quintessence of Critical Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0356 — rune 5097 — Lesser Quintessence of Critical Chance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5097-SCOPE** — rune 5097 — Lesser Quintessence of Critical Chance : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5097-SERVER** — rune 5097 — Lesser Quintessence of Critical Chance : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0357 — rune 5099 — Lesser Quintessence of Armor Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5099-SCOPE** — rune 5099 — Lesser Quintessence of Armor Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5099-SERVER** — rune 5099 — Lesser Quintessence of Armor Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0358 — rune 5101 — Lesser Quintessence of Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5101-SCOPE** — rune 5101 — Lesser Quintessence of Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5101-SERVER** — rune 5101 — Lesser Quintessence of Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0359 — rune 5102 — Lesser Quintessence of Scaling Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5102-SCOPE** — rune 5102 — Lesser Quintessence of Scaling Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5102-SERVER** — rune 5102 — Lesser Quintessence of Scaling Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0360 — rune 5103 — Lesser Quintessence of Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5103-SCOPE** — rune 5103 — Lesser Quintessence of Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5103-SERVER** — rune 5103 — Lesser Quintessence of Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0361 — rune 5104 — Lesser Quintessence of Scaling Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5104-SCOPE** — rune 5104 — Lesser Quintessence of Scaling Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5104-SERVER** — rune 5104 — Lesser Quintessence of Scaling Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0362 — rune 5105 — Lesser Quintessence of Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5105-SCOPE** — rune 5105 — Lesser Quintessence of Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5105-SERVER** — rune 5105 — Lesser Quintessence of Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0363 — rune 5106 — Lesser Quintessence of Scaling Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5106-SCOPE** — rune 5106 — Lesser Quintessence of Scaling Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5106-SERVER** — rune 5106 — Lesser Quintessence of Scaling Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0364 — rune 5107 — Lesser Quintessence of Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5107-SCOPE** — rune 5107 — Lesser Quintessence of Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5107-SERVER** — rune 5107 — Lesser Quintessence of Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0365 — rune 5108 — Lesser Quintessence of Scaling Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5108-SCOPE** — rune 5108 — Lesser Quintessence of Scaling Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5108-SERVER** — rune 5108 — Lesser Quintessence of Scaling Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0366 — rune 5111 — Lesser Quintessence of Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5111-SCOPE** — rune 5111 — Lesser Quintessence of Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5111-SERVER** — rune 5111 — Lesser Quintessence of Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0367 — rune 5112 — Lesser Quintessence of Scaling Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5112-SCOPE** — rune 5112 — Lesser Quintessence of Scaling Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5112-SERVER** — rune 5112 — Lesser Quintessence of Scaling Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0368 — rune 5113 — Lesser Quintessence of Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5113-SCOPE** — rune 5113 — Lesser Quintessence of Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5113-SERVER** — rune 5113 — Lesser Quintessence of Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0369 — rune 5114 — Lesser Quintessence of Scaling Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5114-SCOPE** — rune 5114 — Lesser Quintessence of Scaling Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5114-SERVER** — rune 5114 — Lesser Quintessence of Scaling Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0370 — rune 5115 — Lesser Quintessence of Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5115-SCOPE** — rune 5115 — Lesser Quintessence of Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5115-SERVER** — rune 5115 — Lesser Quintessence of Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0371 — rune 5116 — Lesser Quintessence of Scaling Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5116-SCOPE** — rune 5116 — Lesser Quintessence of Scaling Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5116-SERVER** — rune 5116 — Lesser Quintessence of Scaling Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0372 — rune 5117 — Lesser Quintessence of Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5117-SCOPE** — rune 5117 — Lesser Quintessence of Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5117-SERVER** — rune 5117 — Lesser Quintessence of Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0373 — rune 5118 — Lesser Quintessence of Scaling Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5118-SCOPE** — rune 5118 — Lesser Quintessence of Scaling Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5118-SERVER** — rune 5118 — Lesser Quintessence of Scaling Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0374 — rune 5119 — Lesser Quintessence of Magic Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5119-SCOPE** — rune 5119 — Lesser Quintessence of Magic Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5119-SERVER** — rune 5119 — Lesser Quintessence of Magic Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0375 — rune 5121 — Lesser Quintessence of Movement Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5121-SCOPE** — rune 5121 — Lesser Quintessence of Movement Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5121-SERVER** — rune 5121 — Lesser Quintessence of Movement Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0376 — rune 5123 — Mark of Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5123-SCOPE** — rune 5123 — Mark of Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5123-SERVER** — rune 5123 — Mark of Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0377 — rune 5124 — Mark of Scaling Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5124-SCOPE** — rune 5124 — Mark of Scaling Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5124-SERVER** — rune 5124 — Mark of Scaling Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0378 — rune 5125 — Mark of Attack Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5125-SCOPE** — rune 5125 — Mark of Attack Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5125-SERVER** — rune 5125 — Mark of Attack Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0379 — rune 5127 — Mark of Critical Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5127-SCOPE** — rune 5127 — Mark of Critical Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5127-SERVER** — rune 5127 — Mark of Critical Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0380 — rune 5129 — Mark of Critical Chance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5129-SCOPE** — rune 5129 — Mark of Critical Chance : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5129-SERVER** — rune 5129 — Mark of Critical Chance : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0381 — rune 5131 — Mark of Armor Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5131-SCOPE** — rune 5131 — Mark of Armor Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5131-SERVER** — rune 5131 — Mark of Armor Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0382 — rune 5133 — Mark of Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5133-SCOPE** — rune 5133 — Mark of Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5133-SERVER** — rune 5133 — Mark of Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0383 — rune 5134 — Mark of Scaling Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5134-SCOPE** — rune 5134 — Mark of Scaling Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5134-SERVER** — rune 5134 — Mark of Scaling Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0384 — rune 5135 — Mark of Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5135-SCOPE** — rune 5135 — Mark of Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5135-SERVER** — rune 5135 — Mark of Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0385 — rune 5137 — Mark of Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5137-SCOPE** — rune 5137 — Mark of Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5137-SERVER** — rune 5137 — Mark of Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0386 — rune 5138 — Mark of Scaling Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5138-SCOPE** — rune 5138 — Mark of Scaling Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5138-SERVER** — rune 5138 — Mark of Scaling Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0387 — rune 5143 — Mark of Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5143-SCOPE** — rune 5143 — Mark of Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5143-SERVER** — rune 5143 — Mark of Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0388 — rune 5145 — Mark of Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5145-SCOPE** — rune 5145 — Mark of Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5145-SERVER** — rune 5145 — Mark of Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0389 — rune 5146 — Mark of Scaling Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5146-SCOPE** — rune 5146 — Mark of Scaling Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5146-SERVER** — rune 5146 — Mark of Scaling Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0390 — rune 5147 — Mark of Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5147-SCOPE** — rune 5147 — Mark of Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5147-SERVER** — rune 5147 — Mark of Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0391 — rune 5148 — Mark of Scaling Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5148-SCOPE** — rune 5148 — Mark of Scaling Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5148-SERVER** — rune 5148 — Mark of Scaling Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0392 — rune 5149 — Mark of Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5149-SCOPE** — rune 5149 — Mark of Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5149-SERVER** — rune 5149 — Mark of Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0393 — rune 5151 — Mark of Magic Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5151-SCOPE** — rune 5151 — Mark of Magic Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5151-SERVER** — rune 5151 — Mark of Magic Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0394 — rune 5153 — Glyph of Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5153-SCOPE** — rune 5153 — Glyph of Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5153-SERVER** — rune 5153 — Glyph of Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0395 — rune 5154 — Glyph of Scaling Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5154-SCOPE** — rune 5154 — Glyph of Scaling Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5154-SERVER** — rune 5154 — Glyph of Scaling Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0396 — rune 5155 — Glyph of Attack Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5155-SCOPE** — rune 5155 — Glyph of Attack Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5155-SERVER** — rune 5155 — Glyph of Attack Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0397 — rune 5157 — Glyph of Critical Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5157-SCOPE** — rune 5157 — Glyph of Critical Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5157-SERVER** — rune 5157 — Glyph of Critical Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0398 — rune 5159 — Glyph of Critical Chance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5159-SCOPE** — rune 5159 — Glyph of Critical Chance : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5159-SERVER** — rune 5159 — Glyph of Critical Chance : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0399 — rune 5163 — Glyph of Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5163-SCOPE** — rune 5163 — Glyph of Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5163-SERVER** — rune 5163 — Glyph of Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0400 — rune 5164 — Glyph of Scaling Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5164-SCOPE** — rune 5164 — Glyph of Scaling Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5164-SERVER** — rune 5164 — Glyph of Scaling Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0401 — rune 5165 — Glyph of Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5165-SCOPE** — rune 5165 — Glyph of Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5165-SERVER** — rune 5165 — Glyph of Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0402 — rune 5167 — Glyph of Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5167-SCOPE** — rune 5167 — Glyph of Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5167-SERVER** — rune 5167 — Glyph of Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0403 — rune 5168 — Glyph of Scaling Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5168-SCOPE** — rune 5168 — Glyph of Scaling Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5168-SERVER** — rune 5168 — Glyph of Scaling Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0404 — rune 5169 — Glyph of Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5169-SCOPE** — rune 5169 — Glyph of Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5169-SERVER** — rune 5169 — Glyph of Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0405 — rune 5173 — Glyph of Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5173-SCOPE** — rune 5173 — Glyph of Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5173-SERVER** — rune 5173 — Glyph of Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0406 — rune 5174 — Glyph of Scaling Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5174-SCOPE** — rune 5174 — Glyph of Scaling Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5174-SERVER** — rune 5174 — Glyph of Scaling Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0407 — rune 5175 — Glyph of Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5175-SCOPE** — rune 5175 — Glyph of Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5175-SERVER** — rune 5175 — Glyph of Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0408 — rune 5176 — Glyph of Scaling Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5176-SCOPE** — rune 5176 — Glyph of Scaling Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5176-SERVER** — rune 5176 — Glyph of Scaling Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0409 — rune 5177 — Glyph of Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5177-SCOPE** — rune 5177 — Glyph of Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5177-SERVER** — rune 5177 — Glyph of Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0410 — rune 5178 — Glyph of Scaling Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5178-SCOPE** — rune 5178 — Glyph of Scaling Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5178-SERVER** — rune 5178 — Glyph of Scaling Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0411 — rune 5179 — Glyph of Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5179-SCOPE** — rune 5179 — Glyph of Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5179-SERVER** — rune 5179 — Glyph of Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0412 — rune 5180 — Glyph of Scaling Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5180-SCOPE** — rune 5180 — Glyph of Scaling Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5180-SERVER** — rune 5180 — Glyph of Scaling Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0413 — rune 5181 — Glyph of Magic Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5181-SCOPE** — rune 5181 — Glyph of Magic Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5181-SERVER** — rune 5181 — Glyph of Magic Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0414 — rune 5183 — Seal of Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5183-SCOPE** — rune 5183 — Seal of Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5183-SERVER** — rune 5183 — Seal of Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0415 — rune 5184 — Seal of Scaling Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5184-SCOPE** — rune 5184 — Seal of Scaling Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5184-SERVER** — rune 5184 — Seal of Scaling Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0416 — rune 5185 — Seal of Attack Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5185-SCOPE** — rune 5185 — Seal of Attack Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5185-SERVER** — rune 5185 — Seal of Attack Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0417 — rune 5187 — Seal of Critical Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5187-SCOPE** — rune 5187 — Seal of Critical Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5187-SERVER** — rune 5187 — Seal of Critical Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0418 — rune 5189 — Seal of Critical Chance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5189-SCOPE** — rune 5189 — Seal of Critical Chance : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5189-SERVER** — rune 5189 — Seal of Critical Chance : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0419 — rune 5193 — Seal of Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5193-SCOPE** — rune 5193 — Seal of Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5193-SERVER** — rune 5193 — Seal of Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0420 — rune 5194 — Seal of Scaling Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5194-SCOPE** — rune 5194 — Seal of Scaling Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5194-SERVER** — rune 5194 — Seal of Scaling Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0421 — rune 5195 — Seal of Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5195-SCOPE** — rune 5195 — Seal of Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5195-SERVER** — rune 5195 — Seal of Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0422 — rune 5196 — Seal of Scaling Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5196-SCOPE** — rune 5196 — Seal of Scaling Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5196-SERVER** — rune 5196 — Seal of Scaling Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0423 — rune 5197 — Seal of Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5197-SCOPE** — rune 5197 — Seal of Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5197-SERVER** — rune 5197 — Seal of Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0424 — rune 5198 — Seal of Scaling Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5198-SCOPE** — rune 5198 — Seal of Scaling Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5198-SERVER** — rune 5198 — Seal of Scaling Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0425 — rune 5199 — Seal of Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5199-SCOPE** — rune 5199 — Seal of Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5199-SERVER** — rune 5199 — Seal of Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0426 — rune 5200 — Seal of Scaling Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5200-SCOPE** — rune 5200 — Seal of Scaling Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5200-SERVER** — rune 5200 — Seal of Scaling Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0427 — rune 5203 — Seal of Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5203-SCOPE** — rune 5203 — Seal of Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5203-SERVER** — rune 5203 — Seal of Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0428 — rune 5205 — Seal of Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5205-SCOPE** — rune 5205 — Seal of Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5205-SERVER** — rune 5205 — Seal of Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0429 — rune 5206 — Seal of Scaling Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5206-SCOPE** — rune 5206 — Seal of Scaling Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5206-SERVER** — rune 5206 — Seal of Scaling Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0430 — rune 5207 — Seal of Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5207-SCOPE** — rune 5207 — Seal of Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5207-SERVER** — rune 5207 — Seal of Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0431 — rune 5208 — Seal of Scaling Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5208-SCOPE** — rune 5208 — Seal of Scaling Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5208-SERVER** — rune 5208 — Seal of Scaling Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0432 — rune 5209 — Seal of Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5209-SCOPE** — rune 5209 — Seal of Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5209-SERVER** — rune 5209 — Seal of Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0433 — rune 5210 — Seal of Scaling Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5210-SCOPE** — rune 5210 — Seal of Scaling Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5210-SERVER** — rune 5210 — Seal of Scaling Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0434 — rune 5213 — Quintessence of Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5213-SCOPE** — rune 5213 — Quintessence of Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5213-SERVER** — rune 5213 — Quintessence of Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0435 — rune 5214 — Quintessence of Scaling Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5214-SCOPE** — rune 5214 — Quintessence of Scaling Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5214-SERVER** — rune 5214 — Quintessence of Scaling Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0436 — rune 5215 — Quintessence of Attack Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5215-SCOPE** — rune 5215 — Quintessence of Attack Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5215-SERVER** — rune 5215 — Quintessence of Attack Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0437 — rune 5217 — Quintessence of Critical Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5217-SCOPE** — rune 5217 — Quintessence of Critical Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5217-SERVER** — rune 5217 — Quintessence of Critical Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0438 — rune 5219 — Quintessence of Critical Chance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5219-SCOPE** — rune 5219 — Quintessence of Critical Chance : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5219-SERVER** — rune 5219 — Quintessence of Critical Chance : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0439 — rune 5221 — Quintessence of Armor Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5221-SCOPE** — rune 5221 — Quintessence of Armor Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5221-SERVER** — rune 5221 — Quintessence of Armor Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0440 — rune 5223 — Quintessence of Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5223-SCOPE** — rune 5223 — Quintessence of Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5223-SERVER** — rune 5223 — Quintessence of Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0441 — rune 5224 — Quintessence of Scaling Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5224-SCOPE** — rune 5224 — Quintessence of Scaling Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5224-SERVER** — rune 5224 — Quintessence of Scaling Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0442 — rune 5225 — Quintessence of Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5225-SCOPE** — rune 5225 — Quintessence of Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5225-SERVER** — rune 5225 — Quintessence of Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0443 — rune 5226 — Quintessence of Scaling Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5226-SCOPE** — rune 5226 — Quintessence of Scaling Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5226-SERVER** — rune 5226 — Quintessence of Scaling Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0444 — rune 5227 — Quintessence of Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5227-SCOPE** — rune 5227 — Quintessence of Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5227-SERVER** — rune 5227 — Quintessence of Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0445 — rune 5228 — Quintessence of Scaling Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5228-SCOPE** — rune 5228 — Quintessence of Scaling Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5228-SERVER** — rune 5228 — Quintessence of Scaling Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0446 — rune 5229 — Quintessence of Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5229-SCOPE** — rune 5229 — Quintessence of Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5229-SERVER** — rune 5229 — Quintessence of Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0447 — rune 5230 — Quintessence of Scaling Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5230-SCOPE** — rune 5230 — Quintessence of Scaling Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5230-SERVER** — rune 5230 — Quintessence of Scaling Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0448 — rune 5233 — Quintessence of Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5233-SCOPE** — rune 5233 — Quintessence of Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5233-SERVER** — rune 5233 — Quintessence of Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0449 — rune 5234 — Quintessence of Scaling Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5234-SCOPE** — rune 5234 — Quintessence of Scaling Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5234-SERVER** — rune 5234 — Quintessence of Scaling Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0450 — rune 5235 — Quintessence of Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5235-SCOPE** — rune 5235 — Quintessence of Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5235-SERVER** — rune 5235 — Quintessence of Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0451 — rune 5236 — Quintessence of Scaling Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5236-SCOPE** — rune 5236 — Quintessence of Scaling Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5236-SERVER** — rune 5236 — Quintessence of Scaling Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0452 — rune 5237 — Quintessence of Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5237-SCOPE** — rune 5237 — Quintessence of Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5237-SERVER** — rune 5237 — Quintessence of Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0453 — rune 5238 — Quintessence of Scaling Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5238-SCOPE** — rune 5238 — Quintessence of Scaling Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5238-SERVER** — rune 5238 — Quintessence of Scaling Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0454 — rune 5239 — Quintessence of Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5239-SCOPE** — rune 5239 — Quintessence of Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5239-SERVER** — rune 5239 — Quintessence of Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0455 — rune 5240 — Quintessence of Scaling Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5240-SCOPE** — rune 5240 — Quintessence of Scaling Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5240-SERVER** — rune 5240 — Quintessence of Scaling Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0456 — rune 5241 — Quintessence of Magic Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5241-SCOPE** — rune 5241 — Quintessence of Magic Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5241-SERVER** — rune 5241 — Quintessence of Magic Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0457 — rune 5243 — Quintessence of Movement Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5243-SCOPE** — rune 5243 — Quintessence of Movement Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5243-SERVER** — rune 5243 — Quintessence of Movement Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0458 — rune 5245 — Greater Mark of Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5245-SCOPE** — rune 5245 — Greater Mark of Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5245-SERVER** — rune 5245 — Greater Mark of Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0459 — rune 5246 — Greater Mark of Scaling Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5246-SCOPE** — rune 5246 — Greater Mark of Scaling Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5246-SERVER** — rune 5246 — Greater Mark of Scaling Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0460 — rune 5247 — Greater Mark of Attack Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5247-SCOPE** — rune 5247 — Greater Mark of Attack Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5247-SERVER** — rune 5247 — Greater Mark of Attack Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0461 — rune 5249 — Greater Mark of Critical Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5249-SCOPE** — rune 5249 — Greater Mark of Critical Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5249-SERVER** — rune 5249 — Greater Mark of Critical Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0462 — rune 5251 — Greater Mark of Critical Chance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5251-SCOPE** — rune 5251 — Greater Mark of Critical Chance : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5251-SERVER** — rune 5251 — Greater Mark of Critical Chance : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0463 — rune 5253 — Greater Mark of Armor Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5253-SCOPE** — rune 5253 — Greater Mark of Armor Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5253-SERVER** — rune 5253 — Greater Mark of Armor Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0464 — rune 5255 — Greater Mark of Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5255-SCOPE** — rune 5255 — Greater Mark of Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5255-SERVER** — rune 5255 — Greater Mark of Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0465 — rune 5256 — Greater Mark of Scaling Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5256-SCOPE** — rune 5256 — Greater Mark of Scaling Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5256-SERVER** — rune 5256 — Greater Mark of Scaling Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0466 — rune 5257 — Greater Mark of Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5257-SCOPE** — rune 5257 — Greater Mark of Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5257-SERVER** — rune 5257 — Greater Mark of Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0467 — rune 5259 — Greater Mark of Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5259-SCOPE** — rune 5259 — Greater Mark of Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5259-SERVER** — rune 5259 — Greater Mark of Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0468 — rune 5260 — Greater Mark of Scaling Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5260-SCOPE** — rune 5260 — Greater Mark of Scaling Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5260-SERVER** — rune 5260 — Greater Mark of Scaling Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0469 — rune 5265 — Greater Mark of Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5265-SCOPE** — rune 5265 — Greater Mark of Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5265-SERVER** — rune 5265 — Greater Mark of Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0470 — rune 5267 — Greater Mark of Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5267-SCOPE** — rune 5267 — Greater Mark of Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5267-SERVER** — rune 5267 — Greater Mark of Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0471 — rune 5268 — Greater Mark of Scaling Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5268-SCOPE** — rune 5268 — Greater Mark of Scaling Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5268-SERVER** — rune 5268 — Greater Mark of Scaling Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0472 — rune 5269 — Greater Mark of Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5269-SCOPE** — rune 5269 — Greater Mark of Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5269-SERVER** — rune 5269 — Greater Mark of Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0473 — rune 5270 — Greater Mark of Scaling Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5270-SCOPE** — rune 5270 — Greater Mark of Scaling Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5270-SERVER** — rune 5270 — Greater Mark of Scaling Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0474 — rune 5271 — Greater Mark of Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5271-SCOPE** — rune 5271 — Greater Mark of Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5271-SERVER** — rune 5271 — Greater Mark of Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0475 — rune 5273 — Greater Mark of Magic Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5273-SCOPE** — rune 5273 — Greater Mark of Magic Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5273-SERVER** — rune 5273 — Greater Mark of Magic Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0476 — rune 5275 — Greater Glyph of Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5275-SCOPE** — rune 5275 — Greater Glyph of Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5275-SERVER** — rune 5275 — Greater Glyph of Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0477 — rune 5276 — Greater Glyph of Scaling Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5276-SCOPE** — rune 5276 — Greater Glyph of Scaling Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5276-SERVER** — rune 5276 — Greater Glyph of Scaling Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0478 — rune 5277 — Greater Glyph of Attack Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5277-SCOPE** — rune 5277 — Greater Glyph of Attack Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5277-SERVER** — rune 5277 — Greater Glyph of Attack Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0479 — rune 5279 — Greater Glyph of Critical Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5279-SCOPE** — rune 5279 — Greater Glyph of Critical Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5279-SERVER** — rune 5279 — Greater Glyph of Critical Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0480 — rune 5281 — Greater Glyph of Critical Chance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5281-SCOPE** — rune 5281 — Greater Glyph of Critical Chance : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5281-SERVER** — rune 5281 — Greater Glyph of Critical Chance : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0481 — rune 5285 — Greater Glyph of Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5285-SCOPE** — rune 5285 — Greater Glyph of Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5285-SERVER** — rune 5285 — Greater Glyph of Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0482 — rune 5286 — Greater Glyph of Scaling Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5286-SCOPE** — rune 5286 — Greater Glyph of Scaling Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5286-SERVER** — rune 5286 — Greater Glyph of Scaling Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0483 — rune 5287 — Greater Glyph of Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5287-SCOPE** — rune 5287 — Greater Glyph of Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5287-SERVER** — rune 5287 — Greater Glyph of Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0484 — rune 5289 — Greater Glyph of Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5289-SCOPE** — rune 5289 — Greater Glyph of Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5289-SERVER** — rune 5289 — Greater Glyph of Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0485 — rune 5290 — Greater Glyph of Scaling Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5290-SCOPE** — rune 5290 — Greater Glyph of Scaling Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5290-SERVER** — rune 5290 — Greater Glyph of Scaling Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0486 — rune 5291 — Greater Glyph of Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5291-SCOPE** — rune 5291 — Greater Glyph of Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5291-SERVER** — rune 5291 — Greater Glyph of Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0487 — rune 5295 — Greater Glyph of Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5295-SCOPE** — rune 5295 — Greater Glyph of Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5295-SERVER** — rune 5295 — Greater Glyph of Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0488 — rune 5296 — Greater Glyph of Scaling Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5296-SCOPE** — rune 5296 — Greater Glyph of Scaling Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5296-SERVER** — rune 5296 — Greater Glyph of Scaling Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0489 — rune 5297 — Greater Glyph of Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5297-SCOPE** — rune 5297 — Greater Glyph of Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5297-SERVER** — rune 5297 — Greater Glyph of Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0490 — rune 5298 — Greater Glyph of Scaling Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5298-SCOPE** — rune 5298 — Greater Glyph of Scaling Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5298-SERVER** — rune 5298 — Greater Glyph of Scaling Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0491 — rune 5299 — Greater Glyph of Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5299-SCOPE** — rune 5299 — Greater Glyph of Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5299-SERVER** — rune 5299 — Greater Glyph of Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0492 — rune 5300 — Greater Glyph of Scaling Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5300-SCOPE** — rune 5300 — Greater Glyph of Scaling Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5300-SERVER** — rune 5300 — Greater Glyph of Scaling Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0493 — rune 5301 — Greater Glyph of Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5301-SCOPE** — rune 5301 — Greater Glyph of Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5301-SERVER** — rune 5301 — Greater Glyph of Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0494 — rune 5302 — Greater Glyph of Scaling Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5302-SCOPE** — rune 5302 — Greater Glyph of Scaling Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5302-SERVER** — rune 5302 — Greater Glyph of Scaling Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0495 — rune 5303 — Greater Glyph of Magic Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5303-SCOPE** — rune 5303 — Greater Glyph of Magic Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5303-SERVER** — rune 5303 — Greater Glyph of Magic Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0496 — rune 5305 — Greater Seal of Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5305-SCOPE** — rune 5305 — Greater Seal of Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5305-SERVER** — rune 5305 — Greater Seal of Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0497 — rune 5306 — Greater Seal of Scaling Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5306-SCOPE** — rune 5306 — Greater Seal of Scaling Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5306-SERVER** — rune 5306 — Greater Seal of Scaling Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0498 — rune 5307 — Greater Seal of Attack Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5307-SCOPE** — rune 5307 — Greater Seal of Attack Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5307-SERVER** — rune 5307 — Greater Seal of Attack Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0499 — rune 5309 — Greater Seal of Critical Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5309-SCOPE** — rune 5309 — Greater Seal of Critical Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5309-SERVER** — rune 5309 — Greater Seal of Critical Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0500 — rune 5311 — Greater Seal of Critical Chance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5311-SCOPE** — rune 5311 — Greater Seal of Critical Chance : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5311-SERVER** — rune 5311 — Greater Seal of Critical Chance : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0501 — rune 5315 — Greater Seal of Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5315-SCOPE** — rune 5315 — Greater Seal of Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5315-SERVER** — rune 5315 — Greater Seal of Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0502 — rune 5316 — Greater Seal of Scaling Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5316-SCOPE** — rune 5316 — Greater Seal of Scaling Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5316-SERVER** — rune 5316 — Greater Seal of Scaling Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0503 — rune 5317 — Greater Seal of Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5317-SCOPE** — rune 5317 — Greater Seal of Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5317-SERVER** — rune 5317 — Greater Seal of Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0504 — rune 5318 — Greater Seal of Scaling Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5318-SCOPE** — rune 5318 — Greater Seal of Scaling Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5318-SERVER** — rune 5318 — Greater Seal of Scaling Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0505 — rune 5319 — Greater Seal of Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5319-SCOPE** — rune 5319 — Greater Seal of Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5319-SERVER** — rune 5319 — Greater Seal of Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0506 — rune 5320 — Greater Seal of Scaling Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5320-SCOPE** — rune 5320 — Greater Seal of Scaling Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5320-SERVER** — rune 5320 — Greater Seal of Scaling Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0507 — rune 5321 — Greater Seal of Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5321-SCOPE** — rune 5321 — Greater Seal of Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5321-SERVER** — rune 5321 — Greater Seal of Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0508 — rune 5322 — Greater Seal of Scaling Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5322-SCOPE** — rune 5322 — Greater Seal of Scaling Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5322-SERVER** — rune 5322 — Greater Seal of Scaling Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0509 — rune 5325 — Greater Seal of Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5325-SCOPE** — rune 5325 — Greater Seal of Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5325-SERVER** — rune 5325 — Greater Seal of Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0510 — rune 5327 — Greater Seal of Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5327-SCOPE** — rune 5327 — Greater Seal of Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5327-SERVER** — rune 5327 — Greater Seal of Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0511 — rune 5328 — Greater Seal of Scaling Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5328-SCOPE** — rune 5328 — Greater Seal of Scaling Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5328-SERVER** — rune 5328 — Greater Seal of Scaling Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0512 — rune 5329 — Greater Seal of Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5329-SCOPE** — rune 5329 — Greater Seal of Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5329-SERVER** — rune 5329 — Greater Seal of Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0513 — rune 5330 — Greater Seal of Scaling Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5330-SCOPE** — rune 5330 — Greater Seal of Scaling Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5330-SERVER** — rune 5330 — Greater Seal of Scaling Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0514 — rune 5331 — Greater Seal of Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5331-SCOPE** — rune 5331 — Greater Seal of Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5331-SERVER** — rune 5331 — Greater Seal of Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0515 — rune 5332 — Greater Seal of Scaling Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5332-SCOPE** — rune 5332 — Greater Seal of Scaling Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5332-SERVER** — rune 5332 — Greater Seal of Scaling Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0516 — rune 5335 — Greater Quintessence of Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5335-SCOPE** — rune 5335 — Greater Quintessence of Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5335-SERVER** — rune 5335 — Greater Quintessence of Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0517 — rune 5336 — Greater Quintessence of Scaling Attack Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5336-SCOPE** — rune 5336 — Greater Quintessence of Scaling Attack Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5336-SERVER** — rune 5336 — Greater Quintessence of Scaling Attack Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0518 — rune 5337 — Greater Quintessence of Attack Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5337-SCOPE** — rune 5337 — Greater Quintessence of Attack Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5337-SERVER** — rune 5337 — Greater Quintessence of Attack Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0519 — rune 5339 — Greater Quintessence of Critical Damage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5339-SCOPE** — rune 5339 — Greater Quintessence of Critical Damage : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5339-SERVER** — rune 5339 — Greater Quintessence of Critical Damage : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0520 — rune 5341 — Greater Quintessence of Critical Chance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5341-SCOPE** — rune 5341 — Greater Quintessence of Critical Chance : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5341-SERVER** — rune 5341 — Greater Quintessence of Critical Chance : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0521 — rune 5343 — Greater Quintessence of Armor Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5343-SCOPE** — rune 5343 — Greater Quintessence of Armor Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5343-SERVER** — rune 5343 — Greater Quintessence of Armor Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0522 — rune 5345 — Greater Quintessence of Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5345-SCOPE** — rune 5345 — Greater Quintessence of Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5345-SERVER** — rune 5345 — Greater Quintessence of Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0523 — rune 5346 — Greater Quintessence of Scaling Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5346-SCOPE** — rune 5346 — Greater Quintessence of Scaling Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5346-SERVER** — rune 5346 — Greater Quintessence of Scaling Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0524 — rune 5347 — Greater Quintessence of Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5347-SCOPE** — rune 5347 — Greater Quintessence of Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5347-SERVER** — rune 5347 — Greater Quintessence of Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0525 — rune 5348 — Greater Quintessence of Scaling Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5348-SCOPE** — rune 5348 — Greater Quintessence of Scaling Armor : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5348-SERVER** — rune 5348 — Greater Quintessence of Scaling Armor : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0526 — rune 5349 — Greater Quintessence of Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5349-SCOPE** — rune 5349 — Greater Quintessence of Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5349-SERVER** — rune 5349 — Greater Quintessence of Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0527 — rune 5350 — Greater Quintessence of Scaling Magic Resist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5350-SCOPE** — rune 5350 — Greater Quintessence of Scaling Magic Resist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5350-SERVER** — rune 5350 — Greater Quintessence of Scaling Magic Resist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0528 — rune 5351 — Greater Quintessence of Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5351-SCOPE** — rune 5351 — Greater Quintessence of Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5351-SERVER** — rune 5351 — Greater Quintessence of Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0529 — rune 5352 — Greater Quintessence of Scaling Health Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5352-SCOPE** — rune 5352 — Greater Quintessence of Scaling Health Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5352-SERVER** — rune 5352 — Greater Quintessence of Scaling Health Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0530 — rune 5355 — Greater Quintessence of Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5355-SCOPE** — rune 5355 — Greater Quintessence of Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5355-SERVER** — rune 5355 — Greater Quintessence of Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0531 — rune 5356 — Greater Quintessence of Scaling Cooldown Reduction

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5356-SCOPE** — rune 5356 — Greater Quintessence of Scaling Cooldown Reduction : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5356-SERVER** — rune 5356 — Greater Quintessence of Scaling Cooldown Reduction : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0532 — rune 5357 — Greater Quintessence of Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5357-SCOPE** — rune 5357 — Greater Quintessence of Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5357-SERVER** — rune 5357 — Greater Quintessence of Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0533 — rune 5358 — Greater Quintessence of Scaling Ability Power

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5358-SCOPE** — rune 5358 — Greater Quintessence of Scaling Ability Power : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5358-SERVER** — rune 5358 — Greater Quintessence of Scaling Ability Power : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0534 — rune 5359 — Greater Quintessence of Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5359-SCOPE** — rune 5359 — Greater Quintessence of Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5359-SERVER** — rune 5359 — Greater Quintessence of Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0535 — rune 5360 — Greater Quintessence of Scaling Mana

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5360-SCOPE** — rune 5360 — Greater Quintessence of Scaling Mana : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5360-SERVER** — rune 5360 — Greater Quintessence of Scaling Mana : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0536 — rune 5361 — Greater Quintessence of Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5361-SCOPE** — rune 5361 — Greater Quintessence of Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5361-SERVER** — rune 5361 — Greater Quintessence of Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0537 — rune 5362 — Greater Quintessence of Scaling Mana Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5362-SCOPE** — rune 5362 — Greater Quintessence of Scaling Mana Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5362-SERVER** — rune 5362 — Greater Quintessence of Scaling Mana Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0538 — rune 5363 — Greater Quintessence of Magic Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5363-SCOPE** — rune 5363 — Greater Quintessence of Magic Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5363-SERVER** — rune 5363 — Greater Quintessence of Magic Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0539 — rune 5365 — Greater Quintessence of Movement Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5365-SCOPE** — rune 5365 — Greater Quintessence of Movement Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5365-SERVER** — rune 5365 — Greater Quintessence of Movement Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0540 — rune 5366 — Greater Quintessence of Revival

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5366-SCOPE** — rune 5366 — Greater Quintessence of Revival : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5366-SERVER** — rune 5366 — Greater Quintessence of Revival : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0541 — rune 5367 — Greater Quintessence of Gold

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5367-SCOPE** — rune 5367 — Greater Quintessence of Gold : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5367-SERVER** — rune 5367 — Greater Quintessence of Gold : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0542 — rune 5368 — Greater Quintessence of Experience

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5368-SCOPE** — rune 5368 — Greater Quintessence of Experience : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5368-SERVER** — rune 5368 — Greater Quintessence of Experience : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0543 — rune 5369 — Greater Seal of Energy Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5369-SCOPE** — rune 5369 — Greater Seal of Energy Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5369-SERVER** — rune 5369 — Greater Seal of Energy Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0544 — rune 5370 — Greater Seal of Scaling Energy Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5370-SCOPE** — rune 5370 — Greater Seal of Scaling Energy Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5370-SERVER** — rune 5370 — Greater Seal of Scaling Energy Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0545 — rune 5371 — Greater Glyph of Energy

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5371-SCOPE** — rune 5371 — Greater Glyph of Energy : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5371-SERVER** — rune 5371 — Greater Glyph of Energy : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0546 — rune 5372 — Greater Glyph of Scaling Energy

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5372-SCOPE** — rune 5372 — Greater Glyph of Scaling Energy : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5372-SERVER** — rune 5372 — Greater Glyph of Scaling Energy : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0547 — rune 5373 — Greater Quintessence of Energy Regeneration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5373-SCOPE** — rune 5373 — Greater Quintessence of Energy Regeneration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5373-SERVER** — rune 5373 — Greater Quintessence of Energy Regeneration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0548 — rune 5374 — Greater Quintessence of Energy

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5374-SCOPE** — rune 5374 — Greater Quintessence of Energy : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5374-SERVER** — rune 5374 — Greater Quintessence of Energy : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0549 — rune 5400 — Lesser Mark of Hybrid Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5400-SCOPE** — rune 5400 — Lesser Mark of Hybrid Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5400-SERVER** — rune 5400 — Lesser Mark of Hybrid Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0550 — rune 5401 — Mark of Hybrid Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5401-SCOPE** — rune 5401 — Mark of Hybrid Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5401-SERVER** — rune 5401 — Mark of Hybrid Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0551 — rune 5402 — Greater Mark of Hybrid Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5402-SCOPE** — rune 5402 — Greater Mark of Hybrid Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5402-SERVER** — rune 5402 — Greater Mark of Hybrid Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0552 — rune 5403 — Greater Seal of Gold

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5403-SCOPE** — rune 5403 — Greater Seal of Gold : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5403-SERVER** — rune 5403 — Greater Seal of Gold : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0553 — rune 5404 — Lesser Quintessence of Percent Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5404-SCOPE** — rune 5404 — Lesser Quintessence of Percent Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5404-SERVER** — rune 5404 — Lesser Quintessence of Percent Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0554 — rune 5405 — Quintessence of Percent Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5405-SCOPE** — rune 5405 — Quintessence of Percent Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5405-SERVER** — rune 5405 — Quintessence of Percent Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0555 — rune 5406 — Greater Quintessence of Percent Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5406-SCOPE** — rune 5406 — Greater Quintessence of Percent Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5406-SERVER** — rune 5406 — Greater Quintessence of Percent Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0556 — rune 5407 — Lesser Quintessence of Spell Vamp

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5407-SCOPE** — rune 5407 — Lesser Quintessence of Spell Vamp : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5407-SERVER** — rune 5407 — Lesser Quintessence of Spell Vamp : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0557 — rune 5408 — Quintessence of Spell Vamp

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5408-SCOPE** — rune 5408 — Quintessence of Spell Vamp : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5408-SERVER** — rune 5408 — Quintessence of Spell Vamp : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0558 — rune 5409 — Greater Quintessence of Spell Vamp

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5409-SCOPE** — rune 5409 — Greater Quintessence of Spell Vamp : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5409-SERVER** — rune 5409 — Greater Quintessence of Spell Vamp : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0559 — rune 5410 — Lesser Quintessence of Life Steal

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5410-SCOPE** — rune 5410 — Lesser Quintessence of Life Steal : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5410-SERVER** — rune 5410 — Lesser Quintessence of Life Steal : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0560 — rune 5411 — Quintessence of Life Steal

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5411-SCOPE** — rune 5411 — Quintessence of Life Steal : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5411-SERVER** — rune 5411 — Quintessence of Life Steal : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0561 — rune 5412 — Greater Quintessence of Life Steal

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5412-SCOPE** — rune 5412 — Greater Quintessence of Life Steal : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5412-SERVER** — rune 5412 — Greater Quintessence of Life Steal : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0562 — rune 5413 — Lesser Seal of Percent Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5413-SCOPE** — rune 5413 — Lesser Seal of Percent Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5413-SERVER** — rune 5413 — Lesser Seal of Percent Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0563 — rune 5414 — Seal of Percent Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5414-SCOPE** — rune 5414 — Seal of Percent Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5414-SERVER** — rune 5414 — Seal of Percent Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0564 — rune 5415 — Greater Seal of Percent Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5415-SCOPE** — rune 5415 — Greater Seal of Percent Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5415-SERVER** — rune 5415 — Greater Seal of Percent Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0565 — rune 5416 — Lesser Quintessence of Hybrid Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5416-SCOPE** — rune 5416 — Lesser Quintessence of Hybrid Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5416-SERVER** — rune 5416 — Lesser Quintessence of Hybrid Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0566 — rune 5417 — Quintessence of Hybrid Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5417-SCOPE** — rune 5417 — Quintessence of Hybrid Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5417-SERVER** — rune 5417 — Quintessence of Hybrid Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0567 — rune 5418 — Greater Quintessence of Hybrid Penetration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-5418-SCOPE** — rune 5418 — Greater Quintessence of Hybrid Penetration : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-5418-SERVER** — rune 5418 — Greater Quintessence of Hybrid Penetration : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0568 — rune 8001 — Mark of the Crippling Candy Cane

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8001-SCOPE** — rune 8001 — Mark of the Crippling Candy Cane : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8001-SERVER** — rune 8001 — Mark of the Crippling Candy Cane : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0569 — rune 8002 — Lesser Mark of the Yuletide Tannenbaum 

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8002-SCOPE** — rune 8002 — Lesser Mark of the Yuletide Tannenbaum  : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8002-SERVER** — rune 8002 — Lesser Mark of the Yuletide Tannenbaum  : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0570 — rune 8003 — Glyph of the Special Stocking

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8003-SCOPE** — rune 8003 — Glyph of the Special Stocking : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8003-SERVER** — rune 8003 — Glyph of the Special Stocking : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0571 — rune 8005 — Lesser Glyph of the Gracious Gift

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8005-SCOPE** — rune 8005 — Lesser Glyph of the Gracious Gift : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8005-SERVER** — rune 8005 — Lesser Glyph of the Gracious Gift : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0572 — rune 8006 — Lesser Seal of the Stout Snowman

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8006-SCOPE** — rune 8006 — Lesser Seal of the Stout Snowman : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8006-SERVER** — rune 8006 — Lesser Seal of the Stout Snowman : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0573 — rune 8007 — Lesser Mark of Alpine Attack Speed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8007-SCOPE** — rune 8007 — Lesser Mark of Alpine Attack Speed : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8007-SERVER** — rune 8007 — Lesser Mark of Alpine Attack Speed : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0574 — rune 8008 — Mark of the Combatant

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8008-SCOPE** — rune 8008 — Mark of the Combatant : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8008-SERVER** — rune 8008 — Mark of the Combatant : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0575 — rune 8009 — Lesser Seal of the Medalist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8009-SCOPE** — rune 8009 — Lesser Seal of the Medalist : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8009-SERVER** — rune 8009 — Lesser Seal of the Medalist : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0576 — rune 8011 — Lesser Glyph of the Challenger

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8011-SCOPE** — rune 8011 — Lesser Glyph of the Challenger : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8011-SERVER** — rune 8011 — Lesser Glyph of the Challenger : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0577 — rune 8012 — Glyph of the Soaring Slalom

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8012-SCOPE** — rune 8012 — Glyph of the Soaring Slalom : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8012-SERVER** — rune 8012 — Glyph of the Soaring Slalom : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0578 — rune 8013 — Quintessence of the Headless Horseman

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8013-SCOPE** — rune 8013 — Quintessence of the Headless Horseman : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8013-SERVER** — rune 8013 — Quintessence of the Headless Horseman : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0579 — rune 8014 — Quintessence of the Piercing Screech

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8014-SCOPE** — rune 8014 — Quintessence of the Piercing Screech : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8014-SERVER** — rune 8014 — Quintessence of the Piercing Screech : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0580 — rune 8015 — Quintessence of Bountiful Treats

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8015-SCOPE** — rune 8015 — Quintessence of Bountiful Treats : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8015-SERVER** — rune 8015 — Quintessence of Bountiful Treats : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0581 — rune 8016 — Quintessence of the Speedy Specter

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8016-SCOPE** — rune 8016 — Quintessence of the Speedy Specter : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8016-SERVER** — rune 8016 — Quintessence of the Speedy Specter : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0582 — rune 8017 — Quintessence of the Witches Brew

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8017-SCOPE** — rune 8017 — Quintessence of the Witches Brew : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8017-SERVER** — rune 8017 — Quintessence of the Witches Brew : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0583 — rune 8019 — Greater Quintessence of the Piercing Present

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8019-SCOPE** — rune 8019 — Greater Quintessence of the Piercing Present : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8019-SERVER** — rune 8019 — Greater Quintessence of the Piercing Present : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0584 — rune 8020 — Greater Quintessence of the Deadly Wreath

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8020-SCOPE** — rune 8020 — Greater Quintessence of the Deadly Wreath : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8020-SERVER** — rune 8020 — Greater Quintessence of the Deadly Wreath : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0585 — rune 8021 — Greater Quintessence of Frosty Health

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8021-SCOPE** — rune 8021 — Greater Quintessence of Frosty Health : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8021-SERVER** — rune 8021 — Greater Quintessence of Frosty Health : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0586 — rune 8022 — Greater Quintessence of Sugar Rush

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8022-SCOPE** — rune 8022 — Greater Quintessence of Sugar Rush : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8022-SERVER** — rune 8022 — Greater Quintessence of Sugar Rush : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0587 — rune 8035 — Greater Quintessence of Studio Rumble

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **RUNE-8035-SCOPE** — rune 8035 — Greater Quintessence of Studio Rumble : Qualifier palier, type, disponibilité, valeur et contraintes de page — disponibilité 4.20 à classifier
- [ ] **RUNE-8035-SERVER** — rune 8035 — Greater Quintessence of Studio Rumble : Appliquer réellement les effets sélectionnés et tester cumul, niveau et persistance — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.

## P07-L0588 — mastery 4111 — Double-Edged Sword

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4111-SCOPE** — mastery 4111 — Double-Edged Sword : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4111-SERVER** — mastery 4111 — Double-Edged Sword : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4111-PAGE** — mastery 4111 — Double-Edged Sword : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0589 — mastery 4112 — Fury

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4112-SCOPE** — mastery 4112 — Fury : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4112-SERVER** — mastery 4112 — Fury : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4112-PAGE** — mastery 4112 — Fury : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0590 — mastery 4113 — Sorcery

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4113-SCOPE** — mastery 4113 — Sorcery : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4113-SERVER** — mastery 4113 — Sorcery : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4113-PAGE** — mastery 4113 — Sorcery : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0591 — mastery 4114 — Butcher

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4114-SCOPE** — mastery 4114 — Butcher : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4114-SERVER** — mastery 4114 — Butcher : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4114-PAGE** — mastery 4114 — Butcher : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0592 — mastery 4121 — Expose Weakness

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4121-SCOPE** — mastery 4121 — Expose Weakness : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4121-SERVER** — mastery 4121 — Expose Weakness : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4121-PAGE** — mastery 4121 — Expose Weakness : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0593 — mastery 4122 — Brute Force

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4122-SCOPE** — mastery 4122 — Brute Force : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4122-SERVER** — mastery 4122 — Brute Force : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4122-PAGE** — mastery 4122 — Brute Force : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0594 — mastery 4123 — Mental Force

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4123-SCOPE** — mastery 4123 — Mental Force : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4123-SERVER** — mastery 4123 — Mental Force : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4123-PAGE** — mastery 4123 — Mental Force : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0595 — mastery 4124 — Feast

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4124-SCOPE** — mastery 4124 — Feast : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4124-SERVER** — mastery 4124 — Feast : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4124-PAGE** — mastery 4124 — Feast : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0596 — mastery 4131 — Spell Weaving

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4131-SCOPE** — mastery 4131 — Spell Weaving : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4131-SERVER** — mastery 4131 — Spell Weaving : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4131-PAGE** — mastery 4131 — Spell Weaving : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0597 — mastery 4132 — Martial Mastery

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4132-SCOPE** — mastery 4132 — Martial Mastery : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4132-SERVER** — mastery 4132 — Martial Mastery : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4132-PAGE** — mastery 4132 — Martial Mastery : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0598 — mastery 4133 — Arcane Mastery

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4133-SCOPE** — mastery 4133 — Arcane Mastery : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4133-SERVER** — mastery 4133 — Arcane Mastery : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4133-PAGE** — mastery 4133 — Arcane Mastery : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0599 — mastery 4134 — Executioner

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4134-SCOPE** — mastery 4134 — Executioner : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4134-SERVER** — mastery 4134 — Executioner : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4134-PAGE** — mastery 4134 — Executioner : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0600 — mastery 4141 — Blade Weaving

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4141-SCOPE** — mastery 4141 — Blade Weaving : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4141-SERVER** — mastery 4141 — Blade Weaving : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4141-PAGE** — mastery 4141 — Blade Weaving : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0601 — mastery 4142 — Warlord

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4142-SCOPE** — mastery 4142 — Warlord : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4142-SERVER** — mastery 4142 — Warlord : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4142-PAGE** — mastery 4142 — Warlord : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0602 — mastery 4143 — Archmage

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4143-SCOPE** — mastery 4143 — Archmage : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4143-SERVER** — mastery 4143 — Archmage : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4143-PAGE** — mastery 4143 — Archmage : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0603 — mastery 4144 — Dangerous Game

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4144-SCOPE** — mastery 4144 — Dangerous Game : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4144-SERVER** — mastery 4144 — Dangerous Game : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4144-PAGE** — mastery 4144 — Dangerous Game : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0604 — mastery 4151 — Frenzy

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4151-SCOPE** — mastery 4151 — Frenzy : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4151-SERVER** — mastery 4151 — Frenzy : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4151-PAGE** — mastery 4151 — Frenzy : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0605 — mastery 4152 — Devastating Strikes

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4152-SCOPE** — mastery 4152 — Devastating Strikes : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4152-SERVER** — mastery 4152 — Devastating Strikes : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4152-PAGE** — mastery 4152 — Devastating Strikes : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0606 — mastery 4154 — Arcane Blade

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4154-SCOPE** — mastery 4154 — Arcane Blade : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4154-SERVER** — mastery 4154 — Arcane Blade : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4154-PAGE** — mastery 4154 — Arcane Blade : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0607 — mastery 4162 — Havoc

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4162-SCOPE** — mastery 4162 — Havoc : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4162-SERVER** — mastery 4162 — Havoc : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4162-PAGE** — mastery 4162 — Havoc : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0608 — mastery 4211 — Block

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4211-SCOPE** — mastery 4211 — Block : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4211-SERVER** — mastery 4211 — Block : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4211-PAGE** — mastery 4211 — Block : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0609 — mastery 4212 — Recovery

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4212-SCOPE** — mastery 4212 — Recovery : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4212-SERVER** — mastery 4212 — Recovery : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4212-PAGE** — mastery 4212 — Recovery : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0610 — mastery 4213 — Enchanted Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4213-SCOPE** — mastery 4213 — Enchanted Armor : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4213-SERVER** — mastery 4213 — Enchanted Armor : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4213-PAGE** — mastery 4213 — Enchanted Armor : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0611 — mastery 4214 — Tough Skin

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4214-SCOPE** — mastery 4214 — Tough Skin : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4214-SERVER** — mastery 4214 — Tough Skin : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4214-PAGE** — mastery 4214 — Tough Skin : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0612 — mastery 4221 — Unyielding

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4221-SCOPE** — mastery 4221 — Unyielding : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4221-SERVER** — mastery 4221 — Unyielding : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4221-PAGE** — mastery 4221 — Unyielding : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0613 — mastery 4222 — Veteran's Scars

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4222-SCOPE** — mastery 4222 — Veteran's Scars : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4222-SERVER** — mastery 4222 — Veteran's Scars : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4222-PAGE** — mastery 4222 — Veteran's Scars : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0614 — mastery 4224 — Bladed Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4224-SCOPE** — mastery 4224 — Bladed Armor : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4224-SERVER** — mastery 4224 — Bladed Armor : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4224-PAGE** — mastery 4224 — Bladed Armor : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0615 — mastery 4231 — Oppression

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4231-SCOPE** — mastery 4231 — Oppression : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4231-SERVER** — mastery 4231 — Oppression : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4231-PAGE** — mastery 4231 — Oppression : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0616 — mastery 4232 — Juggernaut

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4232-SCOPE** — mastery 4232 — Juggernaut : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4232-SERVER** — mastery 4232 — Juggernaut : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4232-PAGE** — mastery 4232 — Juggernaut : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0617 — mastery 4233 — Hardiness

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4233-SCOPE** — mastery 4233 — Hardiness : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4233-SERVER** — mastery 4233 — Hardiness : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4233-PAGE** — mastery 4233 — Hardiness : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0618 — mastery 4234 — Resistance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4234-SCOPE** — mastery 4234 — Resistance : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4234-SERVER** — mastery 4234 — Resistance : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4234-PAGE** — mastery 4234 — Resistance : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0619 — mastery 4241 — Perseverance 

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4241-SCOPE** — mastery 4241 — Perseverance  : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4241-SERVER** — mastery 4241 — Perseverance  : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4241-PAGE** — mastery 4241 — Perseverance  : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0620 — mastery 4242 — Swiftness

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4242-SCOPE** — mastery 4242 — Swiftness : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4242-SERVER** — mastery 4242 — Swiftness : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4242-PAGE** — mastery 4242 — Swiftness : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0621 — mastery 4243 — Reinforced Armor

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4243-SCOPE** — mastery 4243 — Reinforced Armor : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4243-SERVER** — mastery 4243 — Reinforced Armor : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4243-PAGE** — mastery 4243 — Reinforced Armor : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0622 — mastery 4244 — Evasive

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4244-SCOPE** — mastery 4244 — Evasive : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4244-SERVER** — mastery 4244 — Evasive : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4244-PAGE** — mastery 4244 — Evasive : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0623 — mastery 4251 — Second Wind

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4251-SCOPE** — mastery 4251 — Second Wind : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4251-SERVER** — mastery 4251 — Second Wind : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4251-PAGE** — mastery 4251 — Second Wind : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0624 — mastery 4252 — Legendary Guardian

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4252-SCOPE** — mastery 4252 — Legendary Guardian : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4252-SERVER** — mastery 4252 — Legendary Guardian : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4252-PAGE** — mastery 4252 — Legendary Guardian : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0625 — mastery 4253 — Runic Blessing

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4253-SCOPE** — mastery 4253 — Runic Blessing : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4253-SERVER** — mastery 4253 — Runic Blessing : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4253-PAGE** — mastery 4253 — Runic Blessing : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0626 — mastery 4262 — Tenacious

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4262-SCOPE** — mastery 4262 — Tenacious : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4262-SERVER** — mastery 4262 — Tenacious : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4262-PAGE** — mastery 4262 — Tenacious : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0627 — mastery 4311 — Phasewalker

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4311-SCOPE** — mastery 4311 — Phasewalker : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4311-SERVER** — mastery 4311 — Phasewalker : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4311-PAGE** — mastery 4311 — Phasewalker : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0628 — mastery 4312 — Fleet of Foot

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4312-SCOPE** — mastery 4312 — Fleet of Foot : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4312-SERVER** — mastery 4312 — Fleet of Foot : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4312-PAGE** — mastery 4312 — Fleet of Foot : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0629 — mastery 4313 — Meditation

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4313-SCOPE** — mastery 4313 — Meditation : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4313-SERVER** — mastery 4313 — Meditation : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4313-PAGE** — mastery 4313 — Meditation : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0630 — mastery 4314 — Scout

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4314-SCOPE** — mastery 4314 — Scout : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4314-SERVER** — mastery 4314 — Scout : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4314-PAGE** — mastery 4314 — Scout : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0631 — mastery 4322 — Summoner's Insight

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4322-SCOPE** — mastery 4322 — Summoner's Insight : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4322-SERVER** — mastery 4322 — Summoner's Insight : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4322-PAGE** — mastery 4322 — Summoner's Insight : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0632 — mastery 4323 — Strength of Spirit

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4323-SCOPE** — mastery 4323 — Strength of Spirit : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4323-SERVER** — mastery 4323 — Strength of Spirit : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4323-PAGE** — mastery 4323 — Strength of Spirit : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0633 — mastery 4324 — Alchemist

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4324-SCOPE** — mastery 4324 — Alchemist : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4324-SERVER** — mastery 4324 — Alchemist : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4324-PAGE** — mastery 4324 — Alchemist : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0634 — mastery 4331 — Greed

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4331-SCOPE** — mastery 4331 — Greed : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4331-SERVER** — mastery 4331 — Greed : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4331-PAGE** — mastery 4331 — Greed : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0635 — mastery 4332 — Runic Affinity

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4332-SCOPE** — mastery 4332 — Runic Affinity : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4332-SERVER** — mastery 4332 — Runic Affinity : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4332-PAGE** — mastery 4332 — Runic Affinity : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0636 — mastery 4333 — Vampirism

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4333-SCOPE** — mastery 4333 — Vampirism : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4333-SERVER** — mastery 4333 — Vampirism : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4333-PAGE** — mastery 4333 — Vampirism : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0637 — mastery 4334 — Culinary Master

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4334-SCOPE** — mastery 4334 — Culinary Master : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4334-SERVER** — mastery 4334 — Culinary Master : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4334-PAGE** — mastery 4334 — Culinary Master : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0638 — mastery 4341 — Scavenger

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4341-SCOPE** — mastery 4341 — Scavenger : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4341-SERVER** — mastery 4341 — Scavenger : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4341-PAGE** — mastery 4341 — Scavenger : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0639 — mastery 4342 — Wealth

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4342-SCOPE** — mastery 4342 — Wealth : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4342-SERVER** — mastery 4342 — Wealth : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4342-PAGE** — mastery 4342 — Wealth : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0640 — mastery 4343 — Expanded Mind

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4343-SCOPE** — mastery 4343 — Expanded Mind : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4343-SERVER** — mastery 4343 — Expanded Mind : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4343-PAGE** — mastery 4343 — Expanded Mind : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0641 — mastery 4344 — Inspiration

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4344-SCOPE** — mastery 4344 — Inspiration : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4344-SERVER** — mastery 4344 — Inspiration : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4344-PAGE** — mastery 4344 — Inspiration : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0642 — mastery 4352 — Bandit

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4352-SCOPE** — mastery 4352 — Bandit : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4352-SERVER** — mastery 4352 — Bandit : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4352-PAGE** — mastery 4352 — Bandit : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0643 — mastery 4353 — Intelligence

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4353-SCOPE** — mastery 4353 — Intelligence : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4353-SERVER** — mastery 4353 — Intelligence : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4353-PAGE** — mastery 4353 — Intelligence : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0644 — mastery 4362 — Wanderer

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **MASTERY-4362-SCOPE** — mastery 4362 — Wanderer : Qualifier arbre, rangs, prérequis et valeurs — disponibilité 4.20 à classifier
- [ ] **MASTERY-4362-SERVER** — mastery 4362 — Wanderer : Appliquer les effets serveur et exceptions de cette maîtrise — disponibilité 4.20 à classifier
- [ ] **MASTERY-4362-PAGE** — mastery 4362 — Wanderer : Qualifier arbre UI, sauvegarde, sélection et effets en partie — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0645 — summoner SummonerBarrier — Barrier

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **SUMMONER-SummonerBarrier-SCOPE** — summoner SummonerBarrier — Barrier : Qualifier cartes, déblocage, cibles et paramètres 4.20 — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerBarrier-SERVER** — summoner SummonerBarrier — Barrier : Terminer mécanique, coûts, recharge et interactions serveur — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerBarrier-NET** — summoner SummonerBarrier — Barrier : Qualifier sélection, refus et réplication des événements — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerBarrier-PRESENT** — summoner SummonerBarrier — Barrier : Achever animation, VFX, audio, icône et HUD — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerBarrier-ACCEPT** — summoner SummonerBarrier — Barrier : Tester usages, interruptions, mort, visibilité et reconnexion — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0646 — summoner SummonerBoost — Cleanse

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **SUMMONER-SummonerBoost-SCOPE** — summoner SummonerBoost — Cleanse : Qualifier cartes, déblocage, cibles et paramètres 4.20 — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerBoost-SERVER** — summoner SummonerBoost — Cleanse : Terminer mécanique, coûts, recharge et interactions serveur — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerBoost-NET** — summoner SummonerBoost — Cleanse : Qualifier sélection, refus et réplication des événements — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerBoost-PRESENT** — summoner SummonerBoost — Cleanse : Achever animation, VFX, audio, icône et HUD — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerBoost-ACCEPT** — summoner SummonerBoost — Cleanse : Tester usages, interruptions, mort, visibilité et reconnexion — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0647 — summoner SummonerClairvoyance — Clairvoyance

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **SUMMONER-SummonerClairvoyance-SCOPE** — summoner SummonerClairvoyance — Clairvoyance : Qualifier cartes, déblocage, cibles et paramètres 4.20 — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerClairvoyance-SERVER** — summoner SummonerClairvoyance — Clairvoyance : Terminer mécanique, coûts, recharge et interactions serveur — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerClairvoyance-NET** — summoner SummonerClairvoyance — Clairvoyance : Qualifier sélection, refus et réplication des événements — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerClairvoyance-PRESENT** — summoner SummonerClairvoyance — Clairvoyance : Achever animation, VFX, audio, icône et HUD — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerClairvoyance-ACCEPT** — summoner SummonerClairvoyance — Clairvoyance : Tester usages, interruptions, mort, visibilité et reconnexion — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0648 — summoner SummonerDot — Ignite

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **SUMMONER-SummonerDot-SCOPE** — summoner SummonerDot — Ignite : Qualifier cartes, déblocage, cibles et paramètres 4.20 — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerDot-SERVER** — summoner SummonerDot — Ignite : Terminer mécanique, coûts, recharge et interactions serveur — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerDot-NET** — summoner SummonerDot — Ignite : Qualifier sélection, refus et réplication des événements — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerDot-PRESENT** — summoner SummonerDot — Ignite : Achever animation, VFX, audio, icône et HUD — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerDot-ACCEPT** — summoner SummonerDot — Ignite : Tester usages, interruptions, mort, visibilité et reconnexion — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0649 — summoner SummonerExhaust — Exhaust

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **SUMMONER-SummonerExhaust-SCOPE** — summoner SummonerExhaust — Exhaust : Qualifier cartes, déblocage, cibles et paramètres 4.20 — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerExhaust-SERVER** — summoner SummonerExhaust — Exhaust : Terminer mécanique, coûts, recharge et interactions serveur — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerExhaust-NET** — summoner SummonerExhaust — Exhaust : Qualifier sélection, refus et réplication des événements — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerExhaust-PRESENT** — summoner SummonerExhaust — Exhaust : Achever animation, VFX, audio, icône et HUD — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerExhaust-ACCEPT** — summoner SummonerExhaust — Exhaust : Tester usages, interruptions, mort, visibilité et reconnexion — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0650 — summoner SummonerFlash — Flash

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **SUMMONER-SummonerFlash-SCOPE** — summoner SummonerFlash — Flash : Qualifier cartes, déblocage, cibles et paramètres 4.20 — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerFlash-SERVER** — summoner SummonerFlash — Flash : Terminer mécanique, coûts, recharge et interactions serveur — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerFlash-NET** — summoner SummonerFlash — Flash : Qualifier sélection, refus et réplication des événements — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerFlash-PRESENT** — summoner SummonerFlash — Flash : Achever animation, VFX, audio, icône et HUD — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerFlash-ACCEPT** — summoner SummonerFlash — Flash : Tester usages, interruptions, mort, visibilité et reconnexion — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0651 — summoner SummonerHaste — Ghost

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **SUMMONER-SummonerHaste-SCOPE** — summoner SummonerHaste — Ghost : Qualifier cartes, déblocage, cibles et paramètres 4.20 — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerHaste-SERVER** — summoner SummonerHaste — Ghost : Terminer mécanique, coûts, recharge et interactions serveur — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerHaste-NET** — summoner SummonerHaste — Ghost : Qualifier sélection, refus et réplication des événements — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerHaste-PRESENT** — summoner SummonerHaste — Ghost : Achever animation, VFX, audio, icône et HUD — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerHaste-ACCEPT** — summoner SummonerHaste — Ghost : Tester usages, interruptions, mort, visibilité et reconnexion — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0652 — summoner SummonerHeal — Heal

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **SUMMONER-SummonerHeal-SCOPE** — summoner SummonerHeal — Heal : Qualifier cartes, déblocage, cibles et paramètres 4.20 — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerHeal-SERVER** — summoner SummonerHeal — Heal : Terminer mécanique, coûts, recharge et interactions serveur — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerHeal-NET** — summoner SummonerHeal — Heal : Qualifier sélection, refus et réplication des événements — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerHeal-PRESENT** — summoner SummonerHeal — Heal : Achever animation, VFX, audio, icône et HUD — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerHeal-ACCEPT** — summoner SummonerHeal — Heal : Tester usages, interruptions, mort, visibilité et reconnexion — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0653 — summoner SummonerMana — Clarity

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **SUMMONER-SummonerMana-SCOPE** — summoner SummonerMana — Clarity : Qualifier cartes, déblocage, cibles et paramètres 4.20 — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerMana-SERVER** — summoner SummonerMana — Clarity : Terminer mécanique, coûts, recharge et interactions serveur — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerMana-NET** — summoner SummonerMana — Clarity : Qualifier sélection, refus et réplication des événements — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerMana-PRESENT** — summoner SummonerMana — Clarity : Achever animation, VFX, audio, icône et HUD — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerMana-ACCEPT** — summoner SummonerMana — Clarity : Tester usages, interruptions, mort, visibilité et reconnexion — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0654 — summoner SummonerOdinGarrison — Garrison

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **SUMMONER-SummonerOdinGarrison-SCOPE** — summoner SummonerOdinGarrison — Garrison : Qualifier cartes, déblocage, cibles et paramètres 4.20 — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerOdinGarrison-SERVER** — summoner SummonerOdinGarrison — Garrison : Terminer mécanique, coûts, recharge et interactions serveur — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerOdinGarrison-NET** — summoner SummonerOdinGarrison — Garrison : Qualifier sélection, refus et réplication des événements — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerOdinGarrison-PRESENT** — summoner SummonerOdinGarrison — Garrison : Achever animation, VFX, audio, icône et HUD — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerOdinGarrison-ACCEPT** — summoner SummonerOdinGarrison — Garrison : Tester usages, interruptions, mort, visibilité et reconnexion — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0655 — summoner SummonerRevive — Revive

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **SUMMONER-SummonerRevive-SCOPE** — summoner SummonerRevive — Revive : Qualifier cartes, déblocage, cibles et paramètres 4.20 — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerRevive-SERVER** — summoner SummonerRevive — Revive : Terminer mécanique, coûts, recharge et interactions serveur — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerRevive-NET** — summoner SummonerRevive — Revive : Qualifier sélection, refus et réplication des événements — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerRevive-PRESENT** — summoner SummonerRevive — Revive : Achever animation, VFX, audio, icône et HUD — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerRevive-ACCEPT** — summoner SummonerRevive — Revive : Tester usages, interruptions, mort, visibilité et reconnexion — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0656 — summoner SummonerSmite — Smite

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **SUMMONER-SummonerSmite-SCOPE** — summoner SummonerSmite — Smite : Qualifier cartes, déblocage, cibles et paramètres 4.20 — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerSmite-SERVER** — summoner SummonerSmite — Smite : Terminer mécanique, coûts, recharge et interactions serveur — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerSmite-NET** — summoner SummonerSmite — Smite : Qualifier sélection, refus et réplication des événements — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerSmite-PRESENT** — summoner SummonerSmite — Smite : Achever animation, VFX, audio, icône et HUD — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerSmite-ACCEPT** — summoner SummonerSmite — Smite : Tester usages, interruptions, mort, visibilité et reconnexion — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

## P07-L0657 — summoner SummonerTeleport — Teleport

**Prérequis du lot :** Prérequis de phase et sources référencées.

- [ ] **SUMMONER-SummonerTeleport-SCOPE** — summoner SummonerTeleport — Teleport : Qualifier cartes, déblocage, cibles et paramètres 4.20 — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerTeleport-SERVER** — summoner SummonerTeleport — Teleport : Terminer mécanique, coûts, recharge et interactions serveur — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerTeleport-NET** — summoner SummonerTeleport — Teleport : Qualifier sélection, refus et réplication des événements — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerTeleport-PRESENT** — summoner SummonerTeleport — Teleport : Achever animation, VFX, audio, icône et HUD — disponibilité 4.20 à classifier
- [ ] **SUMMONER-SummonerTeleport-ACCEPT** — summoner SummonerTeleport — Teleport : Tester usages, interruptions, mort, visibilité et reconnexion — disponibilité 4.20 à classifier

**Fin du lot :** chaque tâche ci-dessus a son livrable et son contrôle acceptés ; les inconnues et anomalies obligatoires sont résolues.

- Résultat attendu (source) : Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve.
- Résultat attendu (simulation) : Comportement autoritaire relié au chemin ordinaire ; conditions de succès et refus explicites ; tests des limites et interactions pertinentes.
- Résultat attendu (network) : Événements et état répliqués aux seules audiences autorisées ; séquence, doublons, perte de vision, mort et reconnexion vérifiés.
- Résultat attendu (presentation) : Modèles/animation/VFX/audio/HUD reliés à l’événement accepté ; captures de la fenêtre réelle et sortie audio lorsque requise ; comparaison à la référence.
- Résultat attendu (acceptance) : Scénario ordinaire sur binaires et ressources identifiés, assertions attendues/observées, preuves et limites ; fidélité humaine requise pour clôture du contenu.

