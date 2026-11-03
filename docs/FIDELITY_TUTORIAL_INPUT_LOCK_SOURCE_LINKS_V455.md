# SYS-01.2-02 — source partielle des commandes du tutoriel, V455

La fiche MODE-TUTORIAL-RULES et son union SYS-01.2-02 sont désormais reliées à sept demandes SetInputLockFlag encodées dans le script natif OnTutorialInit. Un reçu de source est ajouté. Aucun consommateur de jeu, statut ou case n’est ajouté ou validé. Le consommateur existant conserve sa portée Map10.

## Contrat précis

Référence : client fourni PUBLIC4.20.0.315, EUW/en_GB, build2014-11-17 à17:46:45 ; fuseau et déploiement non établis. Source : LEVELS/Map12/Scripts/TutorialScript.luaobj,49 243 octets,SHA25622f7319f8dd6cfabc413eefa684da340afff7f36b3e9f7c656cd6d0b72fedfc3. Le chemin Map12 ne prouve ni l’identité Battle Training, ni un montage de scénario effectif.

CALL pc170,174,178,182,186,190,194 : SetInputLockFlag reçoit successivement les symboles INPUT_LOCK_CAMERA_LOCKING,INPUT_LOCK_CAMERA_MOVEMENT,INPUT_LOCK_ABILITIES,INPUT_LOCK_SUMMONER_SPELLS,INPUT_LOCK_MOVEMENT,INPUT_LOCK_SHOP,INPUT_LOCK_MINIMAP_MOVEMENT, puis l’argument booléen true. Les symboles restent non résolus ; ce ne sont pas des valeurs d’enum ou des bits établis.

Les28 mots et les huit chaînes ont été comparés aux octets natifs lus comme données. Aucune instruction Lua, VM, fonction host ou jeu n’a été exécuté. Les effets, déverrouillages, règles complètes, provider et montage restent ouverts. La chaîne suppose que le prototype soit réellement invoqué, atteigne ces sites et que les appels antérieurs retournent normalement, sans intervention pertinente.

## Provenance et consommateur actuel

La qualification448 et sa revue indépendante449 sont conservées avec leurs auteurs et compteurs distincts ; leurs flags de readiness et d’acceptation restent false. Leur contenu est utilisé comme preuve source, sans annoncer leur réexécution ou une nouvelle revue indépendante.

Le lookup courant a inspecté28 consommateurs enregistrés et leurs fenêtres de code. La recherche bornée dans les fichiers Rust crates et launcher/src-tauri/src n’a trouvé aucun des symboles exacts ; cela ne démontre pas une absence globale d’implémentation.

Le CID déjà lié OLC-0ccede58-6326-58df-8834-bdf7c9f3c718 est world_loader : enable_map10 charge map10_world.json et prépare structures,camps et voies. Ses identités physiques E/F et sa fenêtre185–225 ont été contrôlées ; ce corps n’est pas promu en lecteur de verrouillage du tutoriel. Les listes de consommateurs restent strictement identiques.

Les consommateurs de cette livraison sont les lecteurs réels du plan : Store.task,Store.copy_text,requirement_trace.resolve et make_instruction. Le reçu fournit /associations/0 pour RULES et /associations pour SYS. La fiche garde map=null ; SYS garde entity=null.

Le lot et sa phase n’ont aucune dépendance envers la revue Team447. Cette intégration ROOT part des preuves448/449 et d’une capture courante ; les anciens brouillons450/451 restent intacts et ne sont pas présentés comme exécutés. La revue447 reste non acquise.

## Vérifications réellement exécutées

Préparation, enregistrement et audit séparé ont terminé code0 ; commandes et retours exacts : revision455/ROOT_COMMAND_OBSERVATIONS.json. Deux sélecteurs nominaux acceptés, cinq sélecteurs étrangers ou non canoniques refusés. Le contrôle selector tient compte de son caractère optionnel dans les anciennes références, correction conservée depuis V454.

Attendu : un reçu et deux fiches enrichies seulement. Observé : delta intégral identique à la reconstruction depuis sauvegardes ;42 212 autres exigences actives identiques ;anciens sources,consommateurs,statuts,flags et listes conservés ;registre des inconnues identique en octets.

Dans chacune des deux bases : deux fiches et copies relues par les lecteurs ordinaires ;42 606 états/notes et23 historiques inchangés ;42 604 autres lignes du catalogue identiques ;intégrité SQLite ok. Les bases sont celle du projet F et celle désignée par le connection.json desktop. Vérifications en mode=ro/query_only.

Sauvegardes avant trois remplacements JSON et deux transactions SQLite ; pas d’atomicité globale revendiquée. Le compteur structurel source_hashes_verified=0 est distinct des identités ciblées. Aucun test du jeu, build Rust, AIR, VM ou GPU lancé. La première recherche trop large avec un chemin launcher/src absent est conservée comme diagnostic et n’est pas utilisée pour conclure à une absence.

## Livrables et limites

Modifiés :fidelity_sources_4_20.json,fidelity_requirement_trace_4_20.json,completion_tasks_2026-10-20.json et deux lignes tasks par base. Ajoutés :le reçu sous docs/reference_tutorial_input_lock_sources/,la preuve JSON et ce rapport. Couverture,plan,reprise et notes courtes actualisés après sauvegarde brute. Aucun code ou donnée de jeu modifié.

Preuves privées :F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision455/DELIVERY_AUDIT.json,ROOT_EXECUTION_RECEIPT.json,EXISTING_WORLD_LOADER_INSPECTION.json. Les deux inconnues du tutoriel restent ouvertes :OLU-0e6c86e9-206e-5bea-bf02-b27643b3cb30 etOLU-42787794-76db-5954-841e-4e19c9cf5a9f. SYS-01.2-02 et le goal restent ouverts ; source liée ne signifie pas règle implémentée ou jeu accepté.
