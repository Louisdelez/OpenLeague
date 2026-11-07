# SYS-01.2-02 — Fin naturelle et nettoyage audio différé, V791

Projet : F:/OpenLeague. Fiche associée : SYS-02.2-07. Ce lot ajoute des liens vérifiables entre le client4.20 et ses consommateurs Rust ; il ne clôture ni toute l’exigence audio ni le goal.

## Référence et outil

PE original League of Legends.exe,15973880 octets, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Référence PUBLIC4.20.0.315 EUW/en_GB, distincte du catalogue4.20.1. Huit sources natives existantes réutilisées : PE, Audio.ini et six banques. Les ressources originales restent inchangées.

REA6.4.0, Ghidra12.1.4, Java21.0.10 ; copie exacte et données d’analyse sur F. Outil demandé : https://github.com/morluto/rea. Session terminée avec close_binary et fermeture du transport confirmés, aucune erreur d’outil. Les réponses et avertissements de décompilation sont conservés, notamment la propagation de types de707610. Les conclusions dynamiques ne dépendent pas d’un prototype C supposé.

| Fonction | Rôle | Instructions recoupées |
| --- | --- | ---: |
|705150|Mise à jour du propriétaire, publication puis nettoyage|92|
|706720|Suppression des scratchs dont retired est non nul|58|
|707300|Mise à jour de l’objet ; associations vides dans le parcours|99|
|707610|État de hauteur ; branche initiale sans changement observée|54|
|707170|Destruction de l’objet et demande de désinscription|125|
|AEBC10|Commande de désinscription|23|

Total451 instructions vérifiées contre les octets du PE avec Capstone. Six références conservées ; cibles des CALL/JMP directs recoupées. Une référence de données n’est pas assimilée à une exécution.

## Exécution native

Le constructeur704B10 et le démarrage704E60 chargent Audio.ini et six banques. Le parent7067B0 crée réellement l’objet3 et son scratch via706600/7055D0/707080. L’événement `Play_sfx_Env_Map10_Emitter_brazierchain` (1392698701) sélectionne les médias931355143 et556739449. Après deux frames initiales, le banc alterne la mise à jour705150 et le worker natif jusqu’à la fin naturelle, sans demande d’arrêt injectée pour terminer l’événement.

Le code original s’exécute dans Unicorn, avec services OS, allocations, TLS, verrous, COM, horloges et transport des workers fournis. Aucun processus du jeu original ni périphérique audio réel n’est lancé. Le nouveau fournisseur en global2D791A8 est explicite : slot0x20 retourne vrai, slot8 retourne f64=0.04. Le producteur natif de cette valeur, son sens temporel historique et son ordonnancement réel ne sont pas qualifiés.

| Étape | Attendu | Observé |
| --- | --- | --- |
|Mise à jour pendant la lecture|Objet et scratch conservés|Deux voix ; retired0 ; aucune libération|
|Fin naturelle|Callback type1, retired avant méthode liée|Slot4 observé avec retired1 ; deux voix libérées|
|Après callback|Nettoyage de l’objet différé|Objet et scratch encore vivants ; registre conserve objet3|
|Mise à jour suivante|Publication puis nettoyage706720|705150→707300→707610→AEB000→706720→7056A0→707130/707170→AEBC10|
|Nettoyage|Objet, lien, puis scratch|Ordre dispose→slot0(1)→remove ; index propriétaire2→1|
|Second passage|Pas de destruction répétée|Aucune nouvelle libération ni méthode liée|
|Worker suivant|Désinscription différée|Objet3 absent ; objets0 et2 conservés|
|Arrêt complet|Libération des allocations suivies|1985 allocations,1985 libérations ; zéro restant|

43 frames audio sont conservées jusqu’au callback sur `natural_end_frame_40` (index global42). Les deux fichiers sont décodés jusqu’à leur fin :45032+44565=89597 échantillons PCM16, erreur maximale1 par rapport aux WAV épinglés. 43 appels705150 sont observés, y compris le nettoyage et sa répétition. Une étape worker supplémentaire traite la désinscription. Les empreintes des buffers de mixage sont vérifiées, sans prétendre valider une sortie matérielle.

Le registre porte0xc0000003 pendant les deux voix, puis0xc0000001 après leur fin ; la suppression du wrapper ne retire pas immédiatement cette entrée.705150 publie avant706720 : la commande produite par le destructeur est publiée au passage suivant, puis traitée par le worker. La capacité du vecteur de scratch reste allouée jusqu’au destructeur704C30. Les21 handles simulés sont fermés et les trois workers terminent. Les7517 blocs natifs capturés sont comparés au PE.

Le zéro final concerne les allocations suivies par le banc audio ; il ne qualifie pas les descripteurs physiques des pools, les mappings des banques ou toute la mémoire du banc.

## Consommateurs actuels et vérifications

Nouveau test `crates/core/tests/audio_retired_update_observation.rs`. Le code de production reste inchangé. Le test compose réellement Pool::{allocate,deliver_callback,cleanup}, ObjectIndex::dispose, Registry::{register,acquire,unregister}, release_reference et unregister_command. Les identités de stockage, les méthodes liées et une file Vec différée sont des adaptateurs de test. Cette file n’implémente pas le transport natif et ne qualifie pas le caller705150 complet dans le jeu Rust.

Commande exécutée : `cargo test --locked --offline -p openleague-core --test audio_retired_update_observation -- --nocapture`.

Résultat : code0,2 tests réussis,0 échec,1 comparaison composée. Le premier retrouve les états et l’ordre de nettoyage du parcours natif. Le second vérifie trois limites locales : cookie inconnu, destruction d’objet nul, désinscriptionID0. Les cas locaux ne sont pas présentés comme trois nouvelles exécutions natives. Les24 avertissements existants du crate sont conservés dans stderr. Sources avant/après identiques ; compilateur et exécutable de test identifiés par taille et SHA256.

Six altérations de preuve sont refusées : récepteur705150 substitué, appel706720 effacé, cookie callback substitué, retired naturel effacé, ordre des libérations inversé, empreinte PCM modifiée. Ces contrôles qualifient le vérificateur des captures, pas six comportements supplémentaires du jeu.

Quatre ancres précises ajoutées : Pool::cleanup, ObjectIndex::dispose, unregister_command et release_reference. Les ancres de création, callback, registre et références déjà recensées restent conservées. Le diagnostic client AmbientRequests contient toujours backend_available=false ; inspection statique uniquement.

## Publication

Deux fiches enrichies : SYS-01.2-02 et SYS-02.2-07. Trois registres et les deux bases SQLite du plan sont mis à jour par deltas ciblés avec inverse exact. Les42605 autres lignes de tâches, les42607 états manuels,23 entrées d’historique,24 phases,2770 lots et42215 groupes de chaque base restent conservés. Aucun statut d’implémentation ou d’acceptation n’est promu. Le registre des inconnues reste inchangé. Aucune nouvelle copie intégrale des bases.

Fichiers du projet ajoutés :
- `crates/core/tests/audio_retired_update_observation.rs`.
- `docs/FIDELITY_REA_RETIRED_UPDATE_V791.md` et `docs/fidelity_rea_retired_update_v791.json`.

Fichiers du projet enrichis : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`, `docs/coverage.json`, `docs/completion_plan.json`, `docs/resume_checkpoint.json`, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md`, `docs/ai/DECISIONS.md`, `docs/REA_WORKFLOW.md`.

Bases concernées : `F:/OpenLeague/runtime/project-plan/plan.sqlite3` et `C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3`. Seules les données/instructions des deux fiches et les métadonnées de catalogue changent ; cases et notes restent intactes.

Preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` :
- `revision791_retired_update/OBSERVATIONS.json` et captures PCM : exécution native.
- `revision791_rea_retired_update/observations/77a22136-f115-42fe-9bd9-0b93be5b2bb6/receipt.json` : REA.
- `revision791_native_validation.json` : validation des octets, captures, ressources et états.
- `revision791_current_retired/RECEIPT.json`, stdout.txt, stderr.txt : Rust.
- `revision791_associations/OBSERVATIONS.json` : liens précis, refus et limites.
- `revision791_delivery/` : publication, deltas, relecture indépendante et vérification finale.

## Inconnues et suite

Le parcours utilise field18=1/field14=0 et des vecteurs associés vides. Il ne qualifie pas les autres branches707610, les objets associés707300, le fournisseur natif de temps, callback4, les nouveaux OOM, le streaming/IO, le pool19 physique, la concurrence, les émetteurs ordinaires ni le backend audio Rust complet. Les anciennes preuves restent présentes avec leur portée historique.

Continuer SYS-01.2-02 sur F avec REA. V791 relie une fin naturelle au nettoyage différé706720 via705150 et à la désinscription ultérieure ; poursuivre les producteurs du callback4 et les limites OOM pertinentes, ainsi que les associations partielles du recensement V784. Les autres branches707610, les associations707300 et le fournisseur natif2D791A8 restent ouverts ; ne pas traiter le f64 fourni0.04 comme une preuve du producteur historique. Garder séparés services physiques, pool19, streaming/IO, concurrence, backend Rust et émetteurs du jeu. Cinq exigences Battle Training restent ouvertes sans nouvelle entrée historique ; ne pas répéter leurs recherches inchangées. Préserver preuves, cases, notes, historiques et inconnues.
