# Références fournies : provenance des documents vérifiée

La recherche V55 vérifie les 93 documents locaux des 12 dépôts cités dans les tâches REF-01-AUDIT à REF-12-AUDIT. Tous correspondent aux SHA-256 du catalogue conservé. Les réponses actuelles de l’API publique GitHub confirment les 12 commits exacts, sans substitution par une branche récente.

Les neuf arborescences récursives conservées et les trois arborescences racines récupérées sont rapprochées des arbres des commits. Les Git blobs des documents et leurs répertoires ancêtres sont recalculés : **93 chemins et 946 hashes de répertoires vérifiés**. Les neuf champs `sha` des anciennes réponses d’arbre contiennent l’identifiant demandé du commit ; ils ne servent pas de hash racine. Le hash racine est lu séparément dans la réponse du commit et vérifié par reconstruction. Ces champs ne démontrent pas des documents endommagés.

Treize contrôles passent, dont onze refus d’altération : mauvais commit ou arbre, arborescence tronquée, document ou dépôt manquant, hash erroné, entrée absente ou dupliquée, chemin sortant et mode incorrect. L’essai initial du vérificateur traitait à tort les trois réponses non récursives comme complètes ; sa source et son échec sont conservés. La correction vérifie uniquement leur racine et leurs six documents racines. Aucune requête déjà réussie n’a été rejouée.

Le premier accès réseau a échoué sur la résolution DNS du bac à sable. Les essais et réponses vides sont conservés. Le nouvel accès autorisé a obtenu les 12 réponses de commit et les trois arbres racines ; aucun identifiant, code distant, installation de skill ou programme amont exécuté. La qualification porte sur les contenus et les réponses HTTPS, pas sur les signatures des objets de commit Git.

Ces documents sont des références d’ingénierie locales de 2026. Ils ne sont pas des sources natives des règles de LoL 4.20. L’utilité des recommandations, leur adoption dans un livrable concret et leur compatibilité avec les dépendances réellement verrouillées restent à évaluer. Le Cargo.lock courant contient Bevy 0.19.0 et wgpu 29.0.4 ; le snapshot wgpu fourni déclare 30.0.0. Aucun remplacement de dépendance n’est effectué.

**Intégration au graphe encore à faire.** La livraison canonique reste V54 : 91 334 sources, 252 ancres et 2 399 associations génériques. Les 12 tâches AUDIT et leurs tâches ADOPT restent ouvertes. Aucun statut, aucune consigne, case, note ou révision de suivi n’est modifié par cette recherche.

Preuves détaillées : `E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision55/supplied-reference-tree-path-qualification.json`, `reference-commit-tree-linkage-qualified.json` et `supplied-reference-provenance-research.json`. Les réponses HTTP brutes sont conservées dans `upstream-metadata-qualified/`.

Contrat primaire consulté : [API Git Trees de GitHub](https://docs.github.com/en/rest/git/trees). La liste de chaque document conserve son URL exacte par commit et les hashes Git/SHA-256 dans les reçus.

Suite : relier les documents et les lecteurs existants de vérification/catalogue aux 12 exigences, avec leur contrat local explicite. Conserver la question d’adoption concrète et les critères de rejet. Poursuivre les six objectifs du Goal, dont les liens restants, les divergences 4312/4313 et les évaluations communautaires nommées.
