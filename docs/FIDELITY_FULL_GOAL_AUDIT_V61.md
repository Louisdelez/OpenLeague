# Audit des six objectifs du Goal — V61

V61 intègre des sources natives de lancement,un contrat API Microsoft versionné et deux contextes copiables. Les frontières entre code natif,contrats modélisés et exécution réelle restent explicites. Aucune question,fonctionnalité ou acceptation n'est fermée.

| Objectif original | Preuve actuelle | Travail restant ou limite |
|---|---|---|
| 01 — Identifiants stables | 42757 identités vérifiées | Acceptation humaine non déduite |
| 02 — Sources et consommateurs | 92204 sources,265 ancres ;deux contextes de sources parents intégrés | 918 génériques et 1469 frontières seules : 2387 lacunes spécifiques visibles |
| 03 — Origine,version et SHA | Métadonnées renseignées ;40sources du lot relues ;API commit/blob/SHA | Périmètre V59 hérité,pas de nouveau recensement global ;contrat API actuel distinct de Riot2014 |
| 04 — Natif et Data Dragon | Comparaisons/décisions conservées | Deux divergences4312/4313 ouvertes ;Talent.maxRank effectif et rôle de Ranks non déduits |
| 05 — Scripts communautaires | Inventaire et évaluations nommées conservés | Dispatch,arguments,retours et rôles des sources restent à qualifier selon les cas |
| 06 — Registre des inconnues | 30 835questions structurées ;deux recherches/conditions affinées | 25 321ouvertes et5514résolues ;aucune clôture V61 |

Six nouveaux cas exécutent le préfixe original du lanceur admin dans Unicorn,avec MSVCP80/MSVCR80/WinAPI simulés. Sous ces contrats et sur les chemins ASCII fournis,il prépare module_directory+RADS pour le user kernel. Aucun DLL/API d'origine,processus Windows,IO réel ou changement de CWD n'est exécuté. Erreurs/troncatures de chemin,Unicode et branche non-admin de registre/config restent hors qualification.

Treize contrôles de source relient EDX à l'argument CWD du mini-lanceur. Deux appelants fournissent zéro ;le lancement projet fournit une chaîne produite avec le suffixe/deploy. Les helpers de composition,leurs entrées,le dispatch updateandrun et les changements au démarrage du patcher restent ouverts. La configuration exacte du mini-lanceur nomme lol_patcher/LoLPatcher.exe,sans preuve nouvelle de consommation en runtime. La première erreur d'adresse IAT du vérificateur est archivée ;la correction utilise l'import réel5B00A4.

Le contrat Microsoft actuel de CreateProcessA est conservé par commit583cf7bf91dc3743d56c52afef2c934081bbcad9,Gitblob9068828978a97f39410a64b5178d1beef56f52f0 et SHA-256. Il décrit l'héritage du répertoire parent pour un argument nul ;il ne prouve pas le répertoire du marqueur final. Source officielle :https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-createprocessa. Les deux GET publics sont enregistrés,sans credentials,aucun code amont exécuté.

Les cinq identités,cinq blocs API,trois pointeurs et cinq fenêtres partielles V60 sont hérités,pas rejoués. VERSIONINFO absente des deux racines et de jpatch ;kernel0.0.0.0,mini-lanceur2.22.0.237 et release projet0.0.0.227 restent distincts des builds patcher/AIR/jeu. Les preuves V59 d'ouverture w sous CRT simulé et V58 du popup restent conservées avec leurs limites.

27contrôles de source/portée et30contrôles de livraison passent. Les42 214consignes et11lectures HTTP fiche/copie concordent ;cinq enregistrements/consignes changent,trois métadonnées SYS et les deux contextes first_time. Les42 606cases,notes,révisions et l'historique restent identiques. Les265ancres et92 164anciens enregistrements de source restent inchangés. Aucun Rust/C,asset ou binaire natif modifié. Les deux tâches restent à qualifier,leurs inconnues ouvertes et leurs consommateurs actuels génériques.

Les six objectifs initiaux restent intacts :01/03/06àvalider,02/04/05partiels. Restent notamment les918liens génériques,1469frontières seules,42autres contrats de fichiers vides,l'adoption des12références et les divergences/contradictions nommées. L'ancienne recherche V60 est conservée avec une résolution d'intégration partielle séparée. Goal actif.

Livraison :docs/fidelity_registry_parent_launcher_revision_4_20.json. Sources/limites :docs/FIDELITY_PARENT_LAUNCHER_CWD_REFERENCE_4_20.md. Audits V59/V57,preuves SYS-01.1-02 et travaux antérieurs préservés.
