# Interactions — traçabilité V151

V151 interactions:eight requirements,eight roles including five boundaries.1153 source pins,1190 checks,35 reader cases including34 refusals.Three CPU shield tests pass. Local shield ordering,death cleanup and pursuit visibility are partial;Cleanse dispatch,form transitions,complete mechanism matrix and champion/item exceptions remain open. No historical game execution or native event-priority acceptance.

## SYS-23.2-01

Les tests de sorts regroupent des cas locaux nommés sur une navigation synthétique et deux Garen ; ce dispositif ne constitue pas la matrice exhaustive des familles.

Reste à faire : Construire la matrice de familles avec dépendances, représentants et exceptions sourcées.

## SYS-23.2-02

Les boucliers expirés sont retirés puis consommés par échéance ; les trois tests locaux passent, sans preuve de priorité historique entre événements simultanés.

Reste à faire : Comparer les deux ordres dégâts/bouclier au même tick aux règles natives et qualifier les types et priorités.

## SYS-23.2-03

Le dispatch inspecté déclare Barrier, Heal, Exhaust, Ignite et Smite ; Purification ne figure pas dans cet enum.

Reste à faire : Identifier et qualifier le consommateur de Purification pendant contrôles et canalisations.

## SYS-23.2-04

La mort efface effets, boucliers, contrôles et mouvement ; ce nettoyage ne qualifie pas les projectiles indépendants ni tous les dashs/effets périodiques.

Reste à faire : Qualifier chaque famille persistante/interrompue à la mort avec sources et résultats attendus.

## SYS-23.2-05

Le dispatch ciblé refuse les kits non implémentés après ses branches connues ; il ne fournit pas un scénario de changement de forme.

Reste à faire : Identifier le dispatch des formes puis qualifier récupération, buffs et transferts d’état par champion.

## SYS-23.2-06

La poursuite exige une cible visible ; un test nommé perd la vision puis annule la poursuite. La résolution de chaque projectile/capacité reste distincte.

Reste à faire : Qualifier les phases de ciblage et résolution ainsi que leurs exceptions de vision.

## SYS-23.2-07

Un cas nommé vérifie la mort du lanceur de l’ultime Garen et son mouvement ; il ne recense pas les exceptions de tous les champions.

Reste à faire : Associer chaque exception découverte à sa source et son scénario nommé, avec couverture exhaustive.

## SYS-23.2-08

Un test nommé conserve composants et or après refus d’achat ; il ne recense pas les exceptions actives/passives de tous les objets.

Reste à faire : Associer chaque exception d’objet à un cas nommé sourcé et vérifier la couverture des interactions.

Les trois tests exécutés concernent uniquement les boucliers locaux. Les autres tests nommés ont été inspectés, pas réexécutés ici. Un ordre local ne prouve pas une priorité serveur historique. Les tâches et les anciennes preuves restent ouvertes et conservées.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-23.2-01 | Les tests de sorts regroupent des cas locaux nommés sur une navigation synthétique et deux Garen ; ce dispositif ne constitue pas la matrice exhaustive des familles. | Construire la matrice de familles avec dépendances, représentants et exceptions sourcées. |
| SYS-23.2-02 | Les boucliers expirés sont retirés puis consommés par échéance ; les trois tests locaux passent, sans preuve de priorité historique entre événements simultanés. | Comparer les deux ordres dégâts/bouclier au même tick aux règles natives et qualifier les types et priorités. |
| SYS-23.2-03 | Le dispatch inspecté déclare Barrier, Heal, Exhaust, Ignite et Smite ; Purification ne figure pas dans cet enum. | Identifier et qualifier le consommateur de Purification pendant contrôles et canalisations. |
| SYS-23.2-04 | La mort efface effets, boucliers, contrôles et mouvement ; ce nettoyage ne qualifie pas les projectiles indépendants ni tous les dashs/effets périodiques. | Qualifier chaque famille persistante/interrompue à la mort avec sources et résultats attendus. |
| SYS-23.2-05 | Le dispatch ciblé refuse les kits non implémentés après ses branches connues ; il ne fournit pas un scénario de changement de forme. | Identifier le dispatch des formes puis qualifier récupération, buffs et transferts d’état par champion. |
| SYS-23.2-06 | La poursuite exige une cible visible ; un test nommé perd la vision puis annule la poursuite. La résolution de chaque projectile/capacité reste distincte. | Qualifier les phases de ciblage et résolution ainsi que leurs exceptions de vision. |
| SYS-23.2-07 | Un cas nommé vérifie la mort du lanceur de l’ultime Garen et son mouvement ; il ne recense pas les exceptions de tous les champions. | Associer chaque exception découverte à sa source et son scénario nommé, avec couverture exhaustive. |
| SYS-23.2-08 | Un test nommé conserve composants et or après refus d’achat ; il ne recense pas les exceptions actives/passives de tous les objets. | Associer chaque exception d’objet à un cas nommé sourcé et vérifier la couverture des interactions. |

Reçu : docs/reference_interactions_sources/interactions-links.json. Livraison : docs/fidelity_registry_interactions_links_revision_4_20.json. Les huit tâches et le Goal restent ouverts.
