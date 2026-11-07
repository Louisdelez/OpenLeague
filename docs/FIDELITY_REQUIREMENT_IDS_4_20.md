# Identifiants de fidélité — SYS-01.2-01

Les 42 214 tâches actives, 151 exigences historiques et 392 tâches archivées ont une identité OLF unique (42 757 au total). Leur identifiant de travail reste inchangé.

UUIDv5, namespace immuable `ca018cd0-36bd-56d9-8515-f616cb194d4a`. Les titres, statuts, ordre et preuves ne participent pas à l’identité. Les chemins natifs des tâches EMPTY sont normalisés et l’action est conservée. Les 780 alias explicites des autres familles à index (matériaux, structures, camps, rôles, dépôts) conservent toutes les valeurs initialement attribuées lors d’une réindexation. Les nouvelles exigences obtiennent une nouvelle identité ; un renommage sémantique doit conserver sa clé ou faire l’objet d’un alias explicite, jamais d’une équivalence déduite du titre.

Le contrat JSON couvre les définitions et refuse doublons, réattributions, pertes d’archives et divergence de namespace/définitions. Les anciens agrégats restent distincts des tâches actives ; leur coche ne valide pas leurs enfants. Le plan affiche l’OLF dans la consigne copiée et permet sa recherche. Les cases, notes, révisions et historique utilisateur sont conservés.

15 tests du module installé et 16 tests du plan/suivi manuel sur base isolée réussissent. La preuve `fidelity_requirement_ids_4_20_verification.json` donne commandes, sources, reçus et vérifications du consommateur réel. L’échec initial d’ouverture de sockets sous bac à sable reste conservé, puis les16 contrôles réussissent avec l’accès requis.

Référence de périmètre : PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1. Il s’agit d’un contrat local de traçabilité, sans exécution historique ni qualification du comportement du jeu. Une identité ne prouve pas une fonctionnalité terminée. Tâche réalisée techniquement, acceptation humaine non donnée.
