# SYS-01.2-02 — recherches Battle Training reliées aux fiches

Les cinq fiches Battle Training conservaient une recherche historique « None » et aucun lien vers les investigations ultérieures. Leurs recherches et leurs limites sont désormais consultables depuis chaque fiche et son texte copiable, ainsi que depuis SYS-01.2-02.

**Aucune source de scénario n’est déclarée retrouvée.** Le reçu ajouté est un historique de recherche incomplète. Les cinq native_inputs restent vides ; les dix questions associées restent ouvertes. Leurs statuts, required et conditions de disponibilité sont conservés.

## Ce que les sources permettent de dire

Les travaux conservés V389/V393 identifient BattleTraining.Enabled et sa lecture par CreateTutorialGameController. Les paramètres littéraux false/true de configuration ne sont pas les valeurs effectives reçues. La garde du setter public vérifie un changement de valeur avant d’appeler le setter privé ; choisir false quand la valeur est déjà false ne réévalue donc pas automatiquement Enabled. Cette limite V393 est conservée.

Le layout statique inspecté contient BASIC seulement. Les branches Advanced, noms de skin et fond battle_training ne prouvent pas l’identité, l’activation régionale, les règles ou le montage du scénario demandé. Les anciennes réserves registration_ready=false restent intactes : ces travaux ne sont pas promus en qualification du scénario.

V452 a identifié deux membres de langue du manifeste AIR119, mais pas leur contenu. V453 a échoué en DNS avant HTTP sur ses six candidats ; aucun fichier n’avait été reçu. Ces anciennes tentatives ne sont pas réexécutées.

Dans cette reprise, trois fichiers ActionScript courants sont relus et hachés. Les dix emplacements locaux précis des deux ressources de langue sont revérifiés : aucun fichier présent. Six recherches web visant des sources primaires et une tentative d’ouverture d’une ancienne page officielle archivée n’ont fourni aucune preuve primaire 4.20 utilisable. Les résultats Wiki restent des pistes, sans valeur native attribuée. L’archive officielle était inaccessible via l’outil.

Les ressources recherchées sont :

| Membre AIR 0.0.1.119 | Taille | MD5 attendu |
|---|---:|---|
| assets/locale/App/resources-en_US.swf | 104358 | cd2b8d96c60edceddb8febbb61daca07 |
| assets/locale/App/resources-fr_FR.swf | 109704 | b2f312b0bd7b2972816040e0ecb2dbba |

Ces fichiers seuls ne suffiraient pas à prouver le mode complet : il faut aussi une association versionnée entre le scénario demandé, sa sélection, ses règles, son chargement et ses résultats. Aucun constat d’absence globale de toutes les archives n’est fait.

## Manque précis par fiche

- SCOPE : source primaire, payload ou chargeur établissant l’identité datée et la disponibilité effective du scénario.
- SELECT : identité confirmée et sources de ses règles de champions, sorts et runes.
- STEPS : identité confirmée, script ou graphe de quêtes exact et liaison au chargeur.
- RULES : identité confirmée et producteurs de restrictions, avec leurs valeurs effectives.
- RESULT : identité confirmée et parcours réels de victoire, défaite et retour au client.

Le consommateur actuellement associé est **world::enable_map10**, dans crates/core/src/world.rs, et non un consommateur Battle Training. Sa portée Map10 est préservée. Cela précise la formulation du rapport V460 qui parlait d’un lecteur de fiche : l’ancien rapport reste conservé, cette correction s’appuie sur le CID OLC-0ccede58-6326-58df-8834-bdf7c9f3c718 et son corps courant.

## Intégration et vérifications

Un reçu de recherche, aucun nouveau consommateur, aucun input natif de scénario ajouté. Le consommateur Map10 existant est également relié à SYS comme frontière connue, sans changement de portée. Les cinq tâches et SYS sont les seules fiches enrichies.

Préparation, publication, audit : code0. Six sélecteurs nominaux et sept refus. Les lecteurs réels Store.task, Store.copy_text, requirement_trace.resolve et make_instruction sont vérifiés dans les deux bases. Six fiches actualisées ; 42 600 autres lignes, 42 606 états/notes et 23 entrées d’historique restent exacts dans chaque base. 42 208 autres exigences actives inchangées ; registre des inconnues identique en octets. Intégrité SQLite : ok.

Le graphe contient 98 597 sources enregistrées et 2 412 consommateurs. Le nouveau reçu documentaire ne réduit pas le nombre de scénarios dont la source historique manque. Les 25 321 questions ouvertes et 5 517 résolues restent inchangées.

Aucun jeu, AIR, VM, Rust, build ou GPU exécuté. Les anciens collecteurs et tests ne sont pas rejoués. Deux erreurs d’orientation sont conservées dans les observations : chemins revision452/revision453 abrégés inexistants, puis nom de reçu FINAL_TOOL_RECEIPT inexistant pour V393 ; les vrais dossiers et FINAL_SEAL_TOOL_OBSERVATION ont ensuite été lus.

## Livrables et état de fin

- Reçu : docs/reference_battle_training_research/battle-training-unresolved-research-v462.json.
- Vérification : docs/fidelity_battle_training_research_v462.json.
- Script, sauvegardes et matrice de fin : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision462_battle_training_research.py et revision462/COMPLETION_AUDIT.json.
- Les trois registres de sources/liens/tâches, les deux bases et les documents de couverture/reprise sont actualisés ; données manuelles et anciennes preuves conservées.

SYS-01.2-02 reste ouvert. La finalisation nécessite les entrées historiques identifiées ci-dessus ou une preuve primaire équivalente. La complétude des consommateurs enregistrés V460/V461 ne comble pas ces manques. Aucun nouveau contrôle identique ni reçu supplémentaire ne peut, à lui seul, les résoudre.
