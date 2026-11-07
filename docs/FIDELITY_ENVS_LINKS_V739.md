# SYS-01.2-02 — Courbes ENVS et refus actuel, V739

Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB. Ce lot relie les sources et consommateurs ; il ne termine pas le moteur audio.

## Sources et résultat original

Les112octets ENVS d’Init.bnk contiennent quatre courbes, huit points et36champs exacts. Le branchement AF9C67/AF9CA3 du lecteur extérieur vers AFB1E0 est identifié statiquement. Le corps AFB1E0, l’installation B14900/AE4550 et la conversion B148B0 sont réellement exécutés après lecture du STMG original dans des gestionnaires déclarés. Deux courbes appliquent la constante native à leur seconde coordonnée et passent au scaling0. Le résultat est comparé bit à bit.

Six profils sont vérifiés : nominal1/112octets ; gestionnaire d’états absent2/0octet ; taille déclarée nulle2/0 ; allocation temporaire refusée52/4octets ; allocation de stockage de courbe refusée1/112octets avec une courbe absente ; dernier point tronqué56/111octets avec trois courbes conservées. Le statut1 ne prouve donc pas à lui seul l’installation complète. B14960 libère les allocations de courbes dans les six profils ; les allocations temporaires sont également libérées. Aucun accès mémoire bas n’est admis. Les1313adresses exécutées correspondent au PE original.

## Consommateurs Rust actuels

33modules actuels sont compilés hors ligne sans remplacer leurs déclarations. Sept profils sont exécutés. Le BKHD seul et une section inconnue explicitement ignorée réussissent. Trois variantes ENVS sont refusées, même avec SkipNativeDefaults ; une section inconnue sans cette politique est refusée. La banque Init complète est refusée sur STMG avant ENVS. Le cas ENVS sans corps montre le refus avant validation du corps ; il ne qualifie pas un décodage de données tronquées.

Les sept objets de banque sont libérés, aucun objet d’effet ni courbe ENVS n’est chargé dans ces profils. Le lecteur actuel refuse explicitement les sections reconnues encore non implémentées. Trois rôles précis sont enregistrés : lecture extérieure/refus, lecture du BKHD original et libération actuelle de l’objet de banque. Aucun code du jeu n’a été modifié pour cette qualification.

## Portée et conservation

Deux fiches sont enrichies : SYS-01.2-02 et SYS-02.2-07. Les fiches de voix/skins restent conservées ; aucune application d’ENVS à chaque action n’est déduite. Les trois registres, deux bases et documents de couverture/reprise reçoivent les liens et instructions copiables. Les cases, notes, historiques, prérequis et inconnues sont conservés, sans nouvelle copie complète des bases.

Trois problèmes du banc sont conservés : observation des arguments de libération après le retour simulé, message de compilation exigeant Debug sur un type qui ne l’implémente pas, puis variable de vérification masquant le JSON réussi du programme. L’observateur final lit les arguments avant le transport ; la sonde corrige son affichage sans modifier le produit ; la relecture du journal immuable confirme le résultat Rust code0. La correction du vérificateur ne prétend pas à une nouvelle exécution.

L’allocation de l’objet environnement52octets, les transports de mémoire/verrou/TLS et les gestionnaires sont déclarés. Le démarrage historique complet, l’évaluation des courbes sur des voix réelles, l’implémentation ENVS courante, les instances Meter sur bus, HIRC8/STMG, HIRC14 et la sortie audible restent ouverts.

[Reçu](fidelity_envs_links_v739.json). Corpus : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision739_*. Livraison : revision739_delivery/VERIFIED.json.


## Relecture finale et fichiers modifiés

La relecture indépendante confirme les deux fiches, les deux bases, les quatre courbes et les 1 313 adresses natives. Les six profils originaux et sept profils Rust gardent leurs résultats précis : aucune courbe ENVS n’est chargée par le lecteur actuel. Les trois registres retrouvent exactement leurs empreintes antérieures. Chaque base conserve les 42 605 autres tâches et tous les états manuels, notes, historiques, phases, lots et groupes ; PRAGMA quick_check retourne ok et les instructions copiables conservent les anciens contextes.

Fichiers de registre : docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Suivi : docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md, docs/ai/HANDOFF.md. Preuve : docs/fidelity_envs_links_v739.json et ce rapport. Bases : F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Corpus privé V739 sur F : sources, scripts, journaux, échecs et deltas ciblés.

Contrôles exécutés : lecture des sources et conversion de courbes, six profils natifs et leurs libérations, compilation de 33 modules actuels, sept profils Rust et nettoyages, quatre falsifications rejetées, publication et relecture indépendante. La première préparation du script de publication a été rejetée par le contrôle syntaxique avant toute modification du plan ; elle est conservée et corrigée séparément. La correction du vérificateur Rust relit le journal existant sans prétendre à une nouvelle exécution. Aucun code produit ou asset original modifié. Le goal reste ouvert. Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision739_delivery\INDEPENDENT_READBACK.json.
