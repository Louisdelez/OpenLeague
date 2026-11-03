# Parcours de partie — traçabilité V152

V152 match journeys:six requirements,six explicit boundary roles.1160 source pins,1186 checks,29 reader cases including28 refusals.Two terminal-result CPU tests pass with winner/damage injection. Historical visual receipt is diagnostic;simulated process tests and v67 session replacement do not prove same-match crash recovery. No ordinary full journey executed;all six scopes remain open.

## SYS-23.3-01

La capture terminale est immuable et les deux tests CPU passent, mais leur victoire est injectée directement ou obtenue par dégâts massifs.

Reste à faire : Jouer victoire et défaite ordinaires pour chaque mode requis, avec preuves des clients et résultats.

## SYS-23.3-02

Le launcher abandonne seulement une session détenue après fermeture du client ; les sessions rejointes sont refusées. Ce drain n’est pas une preuve de parcours de capitulation en partie.

Reste à faire : Qualifier le parcours exact d’abandon et le retour au launcher avec sauvegarde et refus pertinents.

## SYS-23.3-03

La reprise valide contexte, capacité, époque et silence ; les tests de registre contrôlent le temps et les endpoints, sans partie complète ordinaire.

Reste à faire : Exécuter timeout et reconnexion réels du participant en partie, sans double action ni perte d’identité.

## SYS-23.3-04

La reprise relance un client détenu avec un bootstrap privé ; les tests de superviseur Fake ne prouvent pas un crash réel suivi de reprise.

Reste à faire : Qualifier crash réel, redémarrage et rattachement à la même partie active, avec anciennes connexions invalidées.

## SYS-23.3-05

La sauvegarde refuse un résultat divergent sous le même identifiant et accepte des octets identiques. Elle ne prouve pas l’unicité des récompenses de compte dans tous les parcours.

Reste à faire : Qualifier résultats et récompenses idempotents sur succès, abandon, timeout, crash et reprise.

## SYS-23.3-06

Le chargeur sélectionne et lit Game.cfg ; la lecture et la migration ne démontrent pas la sauvegarde des réglages édités après retour au launcher.

Reste à faire : Exécuter modification, sortie, retour et relecture des configurations avec comparaison des valeurs.

Deux tests CPU de résultats exécutés. Les tests de reprise et de processus ont été inspectés, pas exécutés ici. Aucun nouveau rendu, crash réel ou partie ordinaire. Les reçus visuels antérieurs restent des preuves historiques limitées. Une première ancre de signature incorrecte a été refusée avant production du reçu, puis corrigée sur la source réelle.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-23.3-01 | La capture terminale est immuable et les deux tests CPU passent, mais leur victoire est injectée directement ou obtenue par dégâts massifs. | Jouer victoire et défaite ordinaires pour chaque mode requis, avec preuves des clients et résultats. |
| SYS-23.3-02 | Le launcher abandonne seulement une session détenue après fermeture du client ; les sessions rejointes sont refusées. Ce drain n’est pas une preuve de parcours de capitulation en partie. | Qualifier le parcours exact d’abandon et le retour au launcher avec sauvegarde et refus pertinents. |
| SYS-23.3-03 | La reprise valide contexte, capacité, époque et silence ; les tests de registre contrôlent le temps et les endpoints, sans partie complète ordinaire. | Exécuter timeout et reconnexion réels du participant en partie, sans double action ni perte d’identité. |
| SYS-23.3-04 | La reprise relance un client détenu avec un bootstrap privé ; les tests de superviseur Fake ne prouvent pas un crash réel suivi de reprise. | Qualifier crash réel, redémarrage et rattachement à la même partie active, avec anciennes connexions invalidées. |
| SYS-23.3-05 | La sauvegarde refuse un résultat divergent sous le même identifiant et accepte des octets identiques. Elle ne prouve pas l’unicité des récompenses de compte dans tous les parcours. | Qualifier résultats et récompenses idempotents sur succès, abandon, timeout, crash et reprise. |
| SYS-23.3-06 | Le chargeur sélectionne et lit Game.cfg ; la lecture et la migration ne démontrent pas la sauvegarde des réglages édités après retour au launcher. | Exécuter modification, sortie, retour et relecture des configurations avec comparaison des valeurs. |

Reçu : docs/reference_match_journeys_sources/match_journeys-links.json. Livraison : docs/fidelity_registry_match_journeys_links_revision_4_20.json. Les six tâches et le Goal restent ouverts.
