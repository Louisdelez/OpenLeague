# SYS-01.2-02 — REA et producteur audio original, V742

Projet F:/OpenLeague ; référence PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct. REA est maintenant utilisé dans le travail du goal, avec un lanceur local réutilisable : tools/rea-openleague.ps1 et sa configuration voisine.

## Utilisation réelle de REA

Installation existante conservée : REA6.4.0 et Ghidra12.1.4 sur E, Java21.0.10 déjà installé, Node24.22.1. Nouveaux résultats et répertoire temporaire d’analyse sur F. Aucun téléchargement ni changement de configuration globale des agents. Une session MCP locale privée est utilisée sans redémarrer Codex.

Le diagnostic ciblé Ghidra retourne0 et healthy=true. Le diagnostic global retourne1 pour Hopper/IDA et les intégrations d’agents non configurées ; il ne signifie pas que Ghidra manque. Les deux diagnostics restent conservés. Le lanceur vérifie les dépendances et la version6.4.0, transmet les arguments et restaure les variables d’environnement de son processus.

REA inspect-pe-resources retourne0 : dix ressources du PE original, comprenant six icônes, une ressource brute, un groupe d’icônes, une ressource de version et un manifeste. Chaque identité type/nom/langue, offset, longueur et SHA est recoupée avec pefile et les octets originaux. Le texte de version, le décodage visuel des icônes et leur utilisation par la fenêtre ne sont pas qualifiés ici.

Une copie du PE, SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862, est ouverte par REA/Ghidra. L’import pour resolve_containing_procedure(0xAF63B0) atteint600000ms et retourne provider_timeout. Aucun pseudocode, instruction ou appelant Ghidra n’est retenu comme résultat. Le bundle, l’erreur et les reçus sont conservés ; close_binary, fermeture du client MCP et du transport sont confirmés. L’original conserve son empreinte. Les avertissements de l’analyse sont des diagnostics, pas des contrats du jeu.

## Producteur audio vérifié séparément

La fonction originale AF63B0..AF63F7 est exécutée en mémoire Unicorn32 isolée, sans lancer le jeu. Elle refuse un indice d’auditeur non signé supérieur ou égal à8 : retour2 et aucune écriture dans l’objet fourni. Sinon elle multiplie les deux flottants par255.0, les convertit par troncature entière et écrit les octets bas dans owner+38+index et owner+40+index, puis retourne1.

102cas :64nominaux pour les huit auditeurs,24refus d’indice et14diagnostics de valeurs hors plage ou non finies. Les19adresses d’instruction et la constante1139104 correspondent aux octets du PE. Le contrôle indépendant recalcule les résultats, vérifie la conservation des autres octets et rejette trois falsifications. Ces diagnostics ne prouvent pas que les appelants historiques autorisent les valeurs hors plage.

V740/V741 ont précédemment établi la consommation de ces champs pour les gains et filtres ENVS. Cette preuve est héritée : aucune nouvelle exécution de ces chaînes ni des composants Rust n’est revendiquée ici. La recherche bornée de noms/adresse dans373fichiers audio*.rs ne trouve aucun correspondant nommé ; ce résultat ne démontre pas l’absence du comportement partout dans le produit. Aucun nouveau consommateur Rust n’est inventé ou promu.

## Intégration, conservation et suite

Les deux fiches SYS-01.2-02 et SYS-02.2-07 reçoivent cette preuve. Le lien du producteur original est ajouté ; les consommateurs actuels et inconnues restent conservés. Aucun statut manuel, case, note, historique, prérequis ou acceptation n’est promu. Une source de preuve est ajoutée au registre, aucun rôle Rust nouveau.

Fichiers : tools/rea-openleague.ps1, tools/rea-openleague.config.json, docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json, docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md, docs/ai/HANDOFF.md, ce rapport et docs/fidelity_rea_owner_links_v742.json. Deux bases du plan sont synchronisées par deltas ciblés, sans copie intégrale. Les contrôles terminaux de publication figurent dans revision742_delivery/VERIFIED.json ; la relecture indépendante doit être confirmée séparément.

La prochaine analyse REA doit disposer d’un budget d’import plus long explicitement enregistré. Restent à qualifier les appelants AF63B0, la politique amont, parent B17486, transport240/244, raccordement ENVS Rust, Meter, chargement complet Init, médias, montage historique, locale et sortie audible. Ce lot ne termine ni le moteur audio ni le goal.


## Relecture finale

Le contrôle indépendant réussit : dix ressources et102cas natifs recoupés, erreur REA600s et fermeture conservées. Les deux bases passent quick_check ;42605autres tâches,42607états manuels,23historiques,24phases,2770lots et42215groupes demeurent identiques. L’inversion ciblée retrouve les octets antérieurs des trois registres. Aucun rôle Rust ou inconnu promu. Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision742_delivery\INDEPENDENT_READBACK.json.
