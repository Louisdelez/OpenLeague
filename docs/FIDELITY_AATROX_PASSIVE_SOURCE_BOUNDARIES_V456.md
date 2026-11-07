# SYS-01.2-02 — Aatrox : sources du passif et fonctions actuelles, V456

La fiche CH-Aatrox-PASSIF-SIMULATION-CONTRAT et son union SYS-01.2-02 sont reliées aux métadonnées natives du passif et aux deux fonctions existantes de dégâts et de réapparition normale. Quatre liens sont ajoutés, un reçu est enregistré et aucun consommateur n'est créé. Ces fonctions ne constituent pas une implémentation complète du Puits de sang. Statuts, questions, cases, notes et historiques sont conservés.

## Source et contrat

Référence : client fourni PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 17 novembre 2014 à 17:46:45 ; fuseau et déploiement non établis. Les dix fichiers natifs sont sous DATA/Characters/Aatrox dans la solution RADS 0.0.1.68. Les identités, origines et appartenances RADS déjà enregistrées restent conservées ; aucune priorité de chargement n'est déduite.

Aatrox.inibin : 1 997 octets, SHA-256 4d1949dc1ddbd27fd37c2b5dc6d2aa635a738f7bf4547314ae4ddc445eac2483. Les champs Data.Passive1LuaName=AatroxPassive, Passive1Icon=Aatrox_Passive.dds et PARType=BloodWell sont relevés avec leurs clés. La clé de description est conservée sans inventer un nom de propriété absent.

CharScriptAatrox.luaobj : 56 octets, SHA-256 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0, un RETURN sans corps de callback. Les quatre autres chunks AatroxPassive, Activate, Death et Ready contiennent des affectations littérales de métadonnées : textures, noms, PersistsThroughDeath, NonDispellable et OnPreDamagePriority=4 pour le premier. Cette constante ne prouve pas un effet serveur.

Les cinq chunks totalisent 39 mots, 17 paires d'affectation littérale encodées, zéro CALL et zéro prototype enfant. Lecture de données par Reader.parse, sans exécution Lua, interprétation de registres, VM ou callback. Le lecteur INIBIN lit les champs, sans lancer le jeu.

Death et Ready ont des chunks Lua identiques et désignent tous deux AatroxPassiveReady. Le fichier AatroxPassiveDeath.inibin contient des libellés Disintegrate : ils sont conservés comme faits de source, sans les attribuer à la logique du passif, ni déclarer arbitrairement le fichier corrompu. Le source_sha256 du catalogue de ressources actuel n'est pas attribué au fichier INIBIN natif ; sa sémantique de production reste non établie dans ce lot. La description Data Dragon 4.20.1 en_US est une comparaison distincte de la référence en_GB.

## Code actuel effectivement inspecté

- Le chargeur champion_catalog existant lit les définitions de base ; son lien est conservé, sans qualification de logique passive.
- OLC-68c82898-e3d0-50b7-aa35-c58c982e7ddc : apply_damage, damage.rs, fenêtre 53–156. Dégâts communs, protections et boucliers, santé, nettoyage à la mort et programmation du retour normal. Le corps ne fournit pas ici de consommateur qualifié de la résurrection d'Aatrox.
- OLC-81087896-b97f-51ae-bdc3-de1f3db15992 : advance_respawns, lifecycle.rs, fenêtre 1–90. Réapparition normale à échéance, placement, santé et ressources ; sa portée existante exclut une preuve de résurrection spéciale.

Les identités physiques E et F de ces corps sont comparées. Les anciens identifiants, origines et portées sont conservés ; aucun doublon n'est créé. Les recherches lexicales bornées ne sont pas utilisées comme preuve d'absence globale d'une implémentation.

## Attendu et observé

Préparation, publication et audit séparé terminés avec code 0. Les retours exacts sont consignés dans ROOT_COMMAND_OBSERVATIONS.json. Vingt et une identités physiques ciblées sont contrôlées ; le compteur structurel source_hashes_verified=0 reste distinct de ces contrôles.

Deux sélecteurs nominaux sont acceptés. Cinq sélecteurs étrangers ou non canoniques sont refusés. Trois entrées Lua malformées (vide, en-tête erroné, tronquée) sont refusées. Ces contrôles valident les liens et le lecteur de données, pas le gameplay.

Le delta des trois registres est reconstruit depuis les sauvegardes : un reçu, quatre liens et deux fiches enrichies ; 42 212 autres exigences actives identiques. Les anciens enregistrements source/consommateur, flags et statuts restent identiques ; les listes précédentes restent préfixes des listes enrichies. Le registre des inconnues reste identique en octets.

Dans chaque base du projet et de l'application desktop : deux fiches relues par Store.task, Store.copy_text, requirement_trace.resolve et make_instruction ; 42 606 états/notes, 23 historiques et 42 604 autres lignes de catalogue inchangés ; intégrité SQLite ok. Les lectures de contrôle utilisent mode=ro/query_only. Trois remplacements JSON et deux transactions SQLite successives, avec sauvegardes ; aucune atomicité globale revendiquée.

## Livraison et limites

Modifiés : docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json, docs/completion_tasks_2026-10-20.json et deux lignes tasks dans chacune des deux bases. Ajoutés : reçu sous docs/reference_aatrox_passive_sources/, preuve JSON et ce rapport. Couverture, plan, reprise et notes courtes actualisés avec sauvegarde des versions précédentes. Aucun code ou asset de jeu modifié.

L'inconnue OLU-c2eb96df-fdfd-597a-be19-853e1cebc930 reste ouverte, ainsi que la qualification du comportement, de ses valeurs, du déclenchement, de la recharge et de la résurrection. La tâche source préalable reste a_qualifier : sa présence n'est pas transformée en acceptation. SYS-01.2-02 et le goal restent ouverts. Aucun build Rust, jeu, AIR, GPU ou VM exécuté.

Preuves détaillées : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision456/PREPARATION.json, SOURCE_LINK_RECEIPT.json, DELIVERY_AUDIT.json et ROOT_EXECUTION_RECEIPT.json. Le reçu public et la preuve JSON se trouvent à côté de ce rapport dans docs.
