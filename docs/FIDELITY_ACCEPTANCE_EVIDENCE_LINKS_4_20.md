# Preuves de recette — traçabilité V150

V150 acceptance evidence:five requirements,five explicit boundary roles.13 source pins,33 checks,26 reader cases including25 refusals.22 source-version Python tests pass. Criteria copying,source hashes,manual states,version history and unknown listing do not prove complete scenario coverage,execution or automatic invalidation. No game execution;all five feature scopes remain open.

## SYS-23.1-01

Le copieur expose le critère de fin et les preuves demandées pour chaque tâche ; il ne crée pas un scénario nommé avec résultats exécutés.

Reste à faire : Établir une correspondance exhaustive entre tâches obligatoires et scénarios reproductibles avec attendus, entrées et résultats.

## SYS-23.1-02

Le validateur compare taille et SHA des sources quand verify_files est activé. Cela ne relie pas automatiquement chaque résultat à tous les exécutables et ressources employés.

Reste à faire : Relier chaque résultat exécuté aux identités exactes des binaires et ressources ; conserver les versions historiques.

## SYS-23.1-03

done est un état manuel séparé du catalogue. Une case cochée ne constitue pas un résultat de scénario exécuté.

Reste à faire : Recenser explicitement les scénarios non exécutés et leur état non vérifié, indépendamment des cases utilisateur.

## SYS-23.1-04

La validation de versions conserve les archives et refuse une dérive non enregistrée ; elle ne réouvre pas les scénarios dépendants.

Reste à faire : Calculer les scénarios affectés par chaque changement et invalider leur qualification avec conservation des résultats antérieurs.

## SYS-23.1-05

resolve expose les inconnues par exigence. Les inconnues techniques ne sont pas à elles seules un inventaire exhaustif des anomalies de recette finale.

Reste à faire : Consolider les anomalies par scénario, gravité, reproduction et condition de fermeture ; prouver la couverture de la recette finale.

Les 22 tests utilisent des versions de source temporaires. Ils ne jouent aucun scénario du jeu. Le premier parseur du journal a refusé les fins de lignes Windows ; le parseur corrigé relève les 22 succès, puis une nouvelle exécution réussit. Le test historique test_requirement_trace.py conserve une racine E: ; il ne sert pas ici de qualification F:. Aucun état manuel ni résultat historique remplacé.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-23.1-01 | Le copieur expose le critère de fin et les preuves demandées pour chaque tâche ; il ne crée pas un scénario nommé avec résultats exécutés. | Établir une correspondance exhaustive entre tâches obligatoires et scénarios reproductibles avec attendus, entrées et résultats. |
| SYS-23.1-02 | Le validateur compare taille et SHA des sources quand verify_files est activé. Cela ne relie pas automatiquement chaque résultat à tous les exécutables et ressources employés. | Relier chaque résultat exécuté aux identités exactes des binaires et ressources ; conserver les versions historiques. |
| SYS-23.1-03 | done est un état manuel séparé du catalogue. Une case cochée ne constitue pas un résultat de scénario exécuté. | Recenser explicitement les scénarios non exécutés et leur état non vérifié, indépendamment des cases utilisateur. |
| SYS-23.1-04 | La validation de versions conserve les archives et refuse une dérive non enregistrée ; elle ne réouvre pas les scénarios dépendants. | Calculer les scénarios affectés par chaque changement et invalider leur qualification avec conservation des résultats antérieurs. |
| SYS-23.1-05 | resolve expose les inconnues par exigence. Les inconnues techniques ne sont pas à elles seules un inventaire exhaustif des anomalies de recette finale. | Consolider les anomalies par scénario, gravité, reproduction et condition de fermeture ; prouver la couverture de la recette finale. |

Reçu : docs/reference_acceptance_evidence_sources/acceptance_evidence-links.json. Livraison : docs/fidelity_registry_acceptance_evidence_links_revision_4_20.json. Les cinq tâches et le Goal restent ouverts.
