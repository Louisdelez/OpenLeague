# SYS-01.2-02 — Découverte qualifiée des contrats de passifs, V534

25 octobre 2026 — F:/OpenLeague. Suite du lot V533 des sources, publié et audité. Référence 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct.

Les 122 contrats PASSIF-SIMULATION-CONTRAT sont recensés : tous restent a_faire, avec **122 questions propres**, distinctes des **122 questions de leurs dépendances SOURCE**. Les parents SIMULATION, leurs dépendances, critères, sources et consommateurs sont conservés. **Aucun lien de simulation, statut, critère ou état manuel n'est modifié par cette découverte.**

Quatre politiques actuelles sont identifiées et lues : Annie, Ezreal, Garen et Trundle. La découverte qualifiée recense **28 occurrences d'appels dans les sources**, dans leur contexte lexical. Une même ligne peut appeler plusieurs méthodes. Les autres 118 contrats restent à inspecter ; ce relevé ne démontre pas une absence globale d'implémentation.

## Portée corrigée de la recherche

La première découverte tronquait chaque fichier à la première annotation cfg(test). Dans lib.rs, cette annotation porte aussi sur des déclarations de modules de tests placées avant du code de production. Cette coupure omettait des appels réels situés plus loin.

Le script qualifié limite cette coupure au début d'un corps de module inline nommé tests. Les déclarations externes de modules de tests n'excluent plus le code qui les suit. **Les 18 anciennes occurrences sont toutes conservées ; le relevé en contient désormais 28.** Les appels clear_ezreal_passive à lib.rs:691 et716 et prune_ezreal_passive à733 sont explicitement vérifiés. Les appels de départ et de réapparition, projection privée et bonus de vitesse d'attaque sont aussi recensés.

Le premier script, sa sortie et sa commande réussie restent conservés avec leur portée plus étroite. La version qualifiée les supplée pour la suite. Ce contrôle améliore la recherche de sources ; il ne prétend pas analyser toute la syntaxe Rust, résoudre cfg/call activation ou exécuter les chemins au runtime.

## Chemins actuels à qualifier

- **Annie** : charge sur E, impact Q, libération W/R, puis appels au producteur de stun ; durées et exceptions à confronter aux sources et au contrat local explicite.
- **Ezreal** : contacts acceptés Q/W/E/R, expiration avant nouveau contact, remise à zéro/session/fin de partie, départ/réapparition, getter de charges, projection privée et contribution à la vitesse d'attaque. Les politiques locales d'ordre et d'ancienne vie doivent rester explicites.
- **Garen** : événements de dégâts et toucher de sort ennemi, getter de régénération et ajout au chemin de soin ; table et exceptions historiques à distinguer des choix locaux.
- **Trundle** : notifications de morts de champion/unité par dégâts vers le récepteur local, avec garde d'état ; formule native, expirations naturelles, illusions et ordre ne sont pas prouvés par ces appels.

spells.rs contient un garde d'échec pour le **targeted Cast** non pris en charge. Sa portée reste cette fonction : il ne prouve pas l'absence de tous les chemins à point au sol ou de toutes les mécaniques passives.

## Preuves et état

- Découverte qualifiée : revision534_passive_contract_discovery_qualified/DISCOVERY.json ; commande revision534_passive_contract_COMMAND_DISCOVERY_QUALIFIED.json/.log, code0.
- Première découverte : revision534_passive_contract_discovery/DISCOVERY.json ;18occurrences et périmètre de coupure ancien conservés.
- Registres d'entrée et identités de fichiers relus sans modification. Sources/critères/dépendances/questions et descripteurs existants exacts.
- V533 déjà publié/audité : docs/FIDELITY_CHAMPION_PASSIVE_SOURCE_PARTIAL_LINKS_V533.md ; aucun nouveau lien de simulation publié ici. Pas de jeu, natif, VM, GPU, build ou Blender exécuté.

Poursuivre SYS-01.2-02 depuis revision534_trace_review/REVIEW.json (8378CH au chargeur partagé seul). Prochain lot122PASSIF-SIMULATION-CONTRAT :utiliser revision534_passive_contract_discovery_qualified/DISCOVERY.json,qui conserve les18anciens appels et en recense28 avec les remises à zéro/expiration/départ/projection/bonus Ezreal. La première découverte coupait du code de production après un cfg(test) de module externe ;elle reste conservée mais est suppléée pour ce périmètre. Quatre politiques spécialisées identifiées (Annie/Ezreal/Garen/Trundle),122questions propres et122questions SOURCE distinctes ;118autres contrats à inspecter sans inférence d’absence. Examiner chaque effet/branche réelle,propriété/activation/paramètres/choix locaux,succès/refus et limites avant nouveaux liens ;un appel lexical ou refus targeted Cast ne suffit pas au runtime. V533SOURCE publié/audité :362arêtes natives/600liens partiels/1contexte Garen/9CID,aucun statut ou question modifié ;ne pas republier. Préserver12déclarations non résolues/5groupes multivalués/Talon vide/descriptions Ezreal-Talon non autorité mécanique,122questions MODELE import-rendu/145questions enfants et854dépendances,V531copies1347exactes et17auxiliaires. Goal actif.
