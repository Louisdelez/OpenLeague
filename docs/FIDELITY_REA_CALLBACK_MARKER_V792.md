# SYS-01.2-02 — Producteur natif des marqueurs audio et consommateurs Rust, V792

Projet : F:/OpenLeague. Fiche associée : SYS-02.2-07. Ce lot qualifie un lien supplémentaire source→producteur natif→consommateur actuel. Il ne clôture ni le goal ni l’audio du jeu.

## Référence et recherche des entrées

PE original League of Legends.exe :15973880 octets, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct.

Les31 médias du manifeste d’ambiance courant ne contiennent aucun chunk cue/LIST. Un inventaire en lecture seule du répertoire natif DATA/Sounds/Wwise a parcouru970 banques .bnk et15240 entrées DIDX ;117 médias dans31 banques contiennent cue/LIST, soit234 chunks relevés, sans erreur de lecture. Ce recensement ne couvre pas tous les .wpk ou médias externes et ne prouve pas leur lecture en jeu. Les identités complètes et la provenance sont qualifiées pour les deux médias retenus, pas pour les970 banques par cette seule liste.

Le graphe de l’événement949167658 provient de ENV_Map10_SFX_events.bnk. Ses actions835317034 et213001105 ciblent6926 et652131487 ; elles sélectionnent les sons247013267/213455685 et les médias1053015285/690032258 dans ENV_Map10_SFX_audio.bnk.35 champs du XML de référence sont recoupés aux offsets du binaire. DIDX, offset, taille et octets des deux WEM extraits sont vérifiés. Le nom historique de l’événement reste non établi : l’API numérique native AEA880 est appelée avec son vrai identifiant, sans nom inventé et sans prétendre exécuter7067B0 dans ce lot.

Chaque média possède deux marqueurs à l’échantillon0. Les libellés sont Tempo:120.0 et un Timestamp propre au média. Leurs octets et les labels transmis sont comparés tels quels ; aucune sémantique de gameplay n’est déduite de leur texte. Les WAV de comparaison sont produits par vgmstream épinglé et restent sous F:/OpenLeague-work, avec les WEM et reçus ; aucun asset de production ni banque originale n’est modifié.

## REA et octets originaux

REA6.4.0, Ghidra12.1.4 et Java21.0.10 analysent une copie exacte sur F. Outil demandé : https://github.com/morluto/rea. Session fermée proprement, aucune erreur d’outil ; réponses conservées et source identique avant/après.

| Fonction | Rôle | Instructions |
| --- | --- | ---: |
|AF4C80|Notification directe d’un marqueur ; statique dans ce lot|79|
|AF4D50|Notifications du lot de marqueurs émis par le décodeur|96|
|B37510|Filtre de positions [début,fin) vers AF4C80 ; statique|37|
|B0ED50|Parent de traitement des buffers ; appelAF4D50 àB0EEC7|343|
|B20C20|Libération du lot de marqueurs et remise à zéro|14|
|704A00|Consommateur temporaire des types4 et1|26|
|704A40|Consommateur lié des types4 et1|27|

622 instructions recoupées avec Capstone et19 références conservées ; cibles des CALL/JMP directs vérifiées. Les limites et éventuels avertissements de décompilation restent dans les réponses. AF4D50 est exécuté par le parent natif ; AF4C80/B37510 ne sont pas comptés comme exécutés.

## Trois exécutions natives

Le constructeur704B10 et le caller704E60 chargent Audio.ini et six banques. Le code original s’exécute dans Unicorn, avec allocations, services OS/TLS/verrous/COM/horloge et transport des workers fournis. Aucun processus de jeu original ni périphérique audio réel. Le callback lié est une interface observable fournie, dont le corps de gameplay n’est pas qualifié.

| Profil | Attendu | Observé |
| --- | --- | --- |
|Temporaire, flags5|Marqueurs transmis à704A00 puis fin|4 types4,4 appels slot8 ; type1 puis slots4 et0(1)|
|Lié, flags5|Marqueurs transmis à704A40 puis fin|Même séquence de notifications et méthodes|
|Temporaire, flags1|Lecture conservée sans marqueurs demandés|0 type4,2 voix actives ; type1 et nettoyage normaux|

La route temporaire exécute réellement706600/7055D0/707080 ; l’objet3 et son scratch proviennent de la fabrique native. La route liée utilise un wrapper fourni et une demande d’enregistrement native explicite pour l’objet2000001. Cette différence de portée reste visible.

Deux frames par profil, deux voix par profil. Les lots AF4D50 comportent deux entrées de20 octets chacun, avec pointeur de voix, identifiant, position et label. Les quatre marqueurs à0 passent du média à ces lots puis au callback sans données synthétiques. Les lots sont libérés par B20C20 dans la même frame ; les labels restent associés à leurs médias. Le second passage ne réémet pas les marqueurs initiaux dans la fenêtre observée.

Les callbacks4 ne marquent pas le scratch comme terminé : son octet retired est encore0 à l’entrée du callback1 d’arrêt. Le callback1 le marque ensuite et le nettoyage global libère objet, lien et scratch dans cet ordre. Aucun comportement de déduplication de notifications n’est inventé.

39936 échantillons décodés sont comparés aux WAV, erreur PCM16 maximale1. Ce sont des préfixes de lecture suivis de l’arrêt natif, pas le décodage intégral des deux fichiers ni une preuve de rebouclage. Les5515 allocations suivies sont libérées ; zéro restant après704C30. Chaque profil ferme21 handles simulés. Les limites des réservations physiques, mappings de banques et mémoire du banc restent distinctes.

## Consommateurs actuels et contrôles

Nouveau test `crates/core/tests/audio_marker_callback_observation.rs`. Le code de production reste inchangé. Le test appelle les vraies fonctions audio_object_callbacks::deliver et Pool::{allocate,deliver_callback,cleanup,clear}. Les types de notifications et identités de stockage sont des entrées issues des captures. Le test ne prétend pas produire les marqueurs depuis un décodeur Rust ou implémenter AF4D50 et son ordonnancement.

Commande exécutée : `cargo test --locked --offline -p openleague-core --test audio_marker_callback_observation -- --nocapture`.

Code0,2 tests réussis,0 échec ; trois comparaisons nominal/lié/drapeau désactivé. Trois limites locales distinctes : cookie absent, lien absent, type exact5 non pris en charge. Les24 avertissements existants sont conservés. Commande, compilateur, exécutable et sources avant/après sont épinglés. Aucune compilation complète du jeu ni validation utilisateur n’est déduite de ces tests.

Six preuves altérées sont refusées : label inventé, trace AF4D50 effacée, drapeau désactivé remplacé, cookie substitué, ordre de nettoyage inversé, empreinte PCM changée. Ces refus portent sur les preuves et ne sont pas comptés comme six nouvelles exécutions du jeu.

Cinq ancres existantes sont réutilisées sans duplication ; leur texte historique est conservé, avec une observation d’exécution V792 explicite. Le diagnostic client AmbientRequests indique toujours backend_available=false ; ce constat reste statique.

## Publication et fichiers

Deux fiches enrichies : SYS-01.2-02 et SYS-02.2-07. Les trois registres et les deux bases du plan reçoivent des deltas ciblés avec inverse exact ; les états manuels, notes, historiques, autres fiches, prérequis et inconnues restent conservés. Aucun statut d’implémentation ou d’acceptation n’est promu, aucune copie intégrale des bases n’est créée.

Ajouts : `crates/core/tests/audio_marker_callback_observation.rs`, `docs/FIDELITY_REA_CALLBACK_MARKER_V792.md`, `docs/fidelity_rea_callback_marker_v792.json`.

Enrichissements : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`, `docs/coverage.json`, `docs/completion_plan.json`, `docs/resume_checkpoint.json`, `docs/ai/CURRENT.md`, `docs/ai/HANDOFF.md`, `docs/ai/DECISIONS.md`, `docs/REA_WORKFLOW.md`.

Bases : `F:/OpenLeague/runtime/project-plan/plan.sqlite3` et `C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3`. Conservation vérifiée de42605 autres tâches,42607 états manuels,23 entrées d’historique,24 phases,2770 lots et42215 groupes dans chaque base.

Preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` :
- `revision792_marker_resource_scan/OBSERVATIONS.json` : inventaire en lecture seule.
- `revision792_marker_inputs/` : graphe, provenance, WEM/WAV et décodage de comparaison.
- `revision792_marker_event_unbound/`, `revision792_marker_event_bound/`, `revision792_marker_disabled_unbound/` : observations natives et captures.
- `revision792_rea_callback_marker/observations/94e36b06-bbe3-4576-8f15-854bbaafdd0d/receipt.json` : REA.
- `revision792_native_validation.json`, `revision792_current_marker/RECEIPT.json`, `revision792_associations/OBSERVATIONS.json` : validations et liens.
- `revision792_delivery/` : deltas, publication, relecture indépendante et vérification finale.

## Limites et prochaine action

Le producteur direct, les positions non nulles, le rebouclage, le nom historique, les autres événements, l’OOM, la concurrence, le streaming/IO, le pool19 physique, les émetteurs ordinaires et la production de ces notifications par le jeu Rust restent non qualifiés. Les preuves antérieures gardent leur portée propre.

Continuer SYS-01.2-02 sur F avec REA. V792 qualifie le producteur AF4D50 sur les marqueurs initiaux de deux médias natifs, deux routes de callback et un drapeau désactivé. Poursuivre les associations partielles du recensement V784 et les limites précises encore ouvertes : producteur direct AF4C80/B37510, marqueurs non nuls et rebouclage, nom historique de événement949167658, OOM pertinents. Conserver séparés le producteur de notifications Rust, son backend physique, les émetteurs de jeu, le pool19, le streaming/IO et la concurrence. Les autres branches707610, associations707300 et fournisseur de temps2D791A8 restent ouverts. Les cinq exigences Battle Training restent ouvertes sans nouvelle entrée historique ; ne pas répéter leurs recherches inchangées. Préserver preuves, cases, notes, historiques et inconnues.
