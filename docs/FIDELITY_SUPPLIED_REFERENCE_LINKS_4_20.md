# Références fournies : sources et consommateurs reliés — V55

Les 12 exigences REF-01-AUDIT à REF-12-AUDIT sont reliées aux 93 documents récupérés, à leurs reçus et aux lecteurs existants du catalogue, des hashes et du générateur de tâches. Leur origine, leur commit exact, leur chemin et leurs SHA sont explicites. Ces références d’ingénierie ne sont pas des sources natives des règles de LoL 4.20 ; leur absence de correspondant natif est un contrat local identifié.

La qualification de provenance déjà obtenue est conservée : 12 réponses de commits exacts, neuf arborescences récursives et trois racines bornées, 93 chemins et 946 hashes de répertoires vérifiés. Treize contrôles, dont onze refus, qualifient ces chaînes. Aucun GET réussi ni contrôle complet précédent n’est rejoué. Les signatures des objets de commit ne sont pas qualifiées.

Deux projections du code existant sont exercées : la boucle réelle du vérificateur lit les 93 documents et sept cas précisent ses gardes ; la lecture et la boucle du générateur produisent 24 appels AUDIT/ADOPT concordant avec les tâches actuelles. Les écritures, l’exécution du générateur complet et les effets de add sont exclus explicitement. Le corpus, le vérificateur, l’ancien reçu et les sources du générateur ne sont pas modifiés.

Deux limites de l’ancien lecteur restent visibles : il vérifie seulement la présence du commit et n’ajoute pas un document indisponible aux erreurs. Le contrôle strict des commits et de tous les documents provient de la preuve Git séparée. Une sortie sans erreur de cet ancien lecteur ne vaut pas, seule, qualification complète.

Le projet verrouille Bevy 0.19.0 et wgpu 29.0.4 ; les snapshots fournis décrivent Bevy 0.20.0-dev et wgpu 30.0.0. Aucune substitution de dépendance, installation de skill ni exécution de code amont n’a lieu. L’utilité des recommandations et leur adoption ou rejet motivé restent ouverts pour chaque dépôt.

Les 27 contrôles d’association, dont 25 refus d’altération, passent. Les 12 tâches et leurs questions d’adoption restent ouvertes. Les tâches ADOPT, les règles du jeu, les états manuels et les six objectifs initiaux ne sont pas acceptés par ces liens de provenance.

Reçu : docs/reference_supplied_reference_sources/supplied-reference-links.json. Livraison : docs/fidelity_registry_supplied_reference_links_revision_4_20.json. La recherche initiale conservée dans FIDELITY_SUPPLIED_REFERENCE_RESEARCH_4_20.md décrit l’étape antérieure à cette intégration.
