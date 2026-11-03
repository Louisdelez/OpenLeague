# SYS-01.2-02 — inconnue config.prop résolue

Les deux inconnues empty_resource_consumer des tâches EMPTY035 sont résolues sur leur condition exacte : identifier le rôle natif et classifier le fichier obligatoire/facultatif avant toute réparation. Le patcher déclare data/config.prop facultatif et ignore la taille nulle avant lecture/parsing (preuve V159). Le manifeste original déclare le membre distribué vide, correspondant au fichier fourni (V176). Le lecteur actuel de membres vérifie cette correspondance, avec quatre refus documentés.

Décision limitée : configuration facultative distribuée vide ; conserver les octets, aucune réparation justifiée par le seul vide. Cette conclusion n’affirme pas le chemin absolu effectivement ouvert lors d’un lancement historique, le comportement complet du parser/defaults ni la complétude des tâches. Aucun indicateur manuel, implementation_complete ou acceptance_complete modifié.

Les anciennes questions, conditions et recherches sont conservées ; des preuves et historiques de résolution sont ajoutés. Les autres inconnues restent identiques. Le registre compte25319 inconnues ouvertes et5516 résolues. Trois fiches/copies/traces par base, trois pointeurs et deux refus sont contrôlés ;42606 états manuels et historique conservés.

Preuve : docs/fidelity_config_classification_v179.json. Décision : docs/reference_event_lookup_sources/config-classification-v179.json. Sauvegardes complètes dont inconnues : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision179/before-config-classification.

Suite : confronter les autres conditions de résolution à leurs preuves exactes ; ne pas maintenir artificiellement ouvertes les questions déjà résolues, ni extrapoler une classification locale à la complétude du jeu.
