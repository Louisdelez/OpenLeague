# SYS-01.2-02 — Source audio, rééchantillonnage et contrats courants, V751

Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue 4.20.1 distinct. Ce lot relie des sources natives aux consommateurs actuels pour SYS-01.2-02 et SYS-02.2-07. Aucun code du jeu ni asset n’est modifié. Les qualifications précédentes restent conservées.

## Résultat et écart concret

Le chemin source original B0ED50 appelle B28AE0/B28520 puis B28870/B280F0. Les noyaux B34590, B339F0 et B342F0 traitent respectivement le pas unitaire, le pas fixe et la transition de pas. L’initialisation B28B60/B282D0/B28170 et la libération B17830/B28830/B28B90/B20CC0 sont exercées sur des objets fournis par le banc.

Le transport Rust audio_media::Playback::read conserve les échantillons et la fréquence source. audio_pitch::ratio calcule un ratio scalaire. Ces composants sont compilés inchangés et exécutés ; ils ne constituent pas une implémentation du rééchantillonneur natif ni de sa transition. Le banc retrouve 13 séquences de samples identiques au pas effectif unitaire et 102 différentes. L’égalité d’échantillons n’implique pas une égalité de fréquence ou de timing.

## REA et source originale

REA 6.4.0 avec Ghidra 12.1.4 analyse le PE complet original, sans conteneur synthétique. Huit fonctions : B28B60, B282D0, B20C50, B28BF0, B34590, B339F0, B342F0 et B28170. Les 681 instructions et 17 références sont recoupées avec les octets originaux ; les réponses et le pseudocode sont identifiés par SHA-256. Huit résolutions de procédure et fermeture de session vérifiées, zéro erreur.

Source : League of Legends.exe, 15 973 880 octets, SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862, sous D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy. Analyses et temporaires restent sur F. Init.bnk n’est pas chargé par ce lot. Les analyses antérieures de B0ED50 et B28AE0/B28870 sont conservées, pas présentées comme de nouvelles requêtes REA.

## Scénarios natifs et observations

112 contextes statiques combinent quatre fréquences source (24000, 44100, 48000, 96000 Hz), sept valeurs de pitch (-2400, -1200, -37, 0, 37, 1200, 2400 cents) et quatre longueurs (1, 3, 17, 33 frames). Deux scénarios de 2049 frames changent le pitch de 0 à -1200 ou +1200 après le premier bloc. Un scénario renvoie d’abord un bloc vide non terminal, puis 17 frames. Total : 115 scénarios, 962 blocs, 116 demandes source et 115 libérations source.

Les entrées sont des samples synthétiques finis, float32 stéréo planaire. Sortie 48000 Hz, demandes de huit frames. Les données source restent immuables. Tous les buffers de sortie alloués sont libérés : 962 paires vérifiées, aucune allocation restante. L’inventaire de 1435 adresses correspond aux octets du PE ; les adresses d’entrée des deux feuilles allocateur/libérateur interceptées y figurent sans que leur corps historique soit exécuté. Aucun accès bas mémoire observé.

Les contrôles stockent un pas fixe 16.16. Après changement de cible, le mode de transition est observé, sa progression commence à huit dans le premier bloc modifié et atteint 1024 avant le régime fixe. La copie unitaire reproduit les échantillons ; les chemins non unitaires ont leurs propres longueurs et interpolations.

Les callbacks de fournisseur source, de libération et les feuilles d’allocation B0E1D0/libération B0E9E0 sont fournis explicitement. Le getter de pitch utilise un adaptateur FLD/RET hors image. Les wrappers B20C50/B20CC0 restent originaux. Le stockage des objets est initialisé à zéro, les adresses de vtables originales sont fournies, et l’initialiseur natif est réellement appelé. Cela ne qualifie pas les constructeurs englobants, un décodeur de média ou le pool historique.

Les deux filtres primaires passent en identité/bypass avec historique nul fourni. Pas d’effets, d’auxiliaires ni de mixage final : job+38 vaut 1. Le callback de limite renvoie -1 ; le décalage initial -8 compense les huit frames du mode à faible latence explicitement choisi. Ce choix de banc n’est pas un défaut historique établi.

## Frontières natives

Quatre pitches hors plage finis (-9600, -2400.01, 2400.01, 9600) sont bornés par le code original à ±2400. Une source terminale de zéro frame retourne le statut 17 et zéro frame valide. Un allocateur fourni retournant zéro entraîne le statut 2 avant les filtres. Dans ce dernier cas, le banc appelle explicitement B28BF0 pour libérer la source encore empruntée ; cette récupération ne démontre pas la politique du propriétaire historique.

## Consommateurs actuels et contrôles Rust

Deux modules réels inchangés sont compilés hors ligne : crates/core/src/audio_media.rs et audio_pitch.rs. Le lock, la compilation et l’exécution retournent 0 ; les dépendances de compilation citent ces fichiers exacts.

Pour chacun des 115 clips, Playback::read restitue les samples entrelacés, conserve la fréquence source, remplit les queues de zéro et termine correctement. 115 sorties non alignées sont refusées sans déplacer le curseur ni changer la sortie. Un clip vide est refusé. Ce clip vide n’est pas équivalent au bloc source vide natif.

Sept pitches non qualifiés sont refusés : quatre hors plage finis, NaN et deux infinis. Le bornage natif et le refus courant restent des contrats distincts.

962 ratios courants sont observés. Une projection diagnostique ajoutée seulement au banc calcule floor(ratio_f32 * rapport_source_sortie_f32 * 65536 + 0.5) : écart nul avec les cibles natives sur ces entrées. Cette formule n’a pas été ajoutée au produit ; elle ne prouve pas le rééchantillonnage, la phase, la rampe ou le raccordement en jeu.

crates/client/src/pcm_audio.rs est inspecté : le décodeur construit son SampleRate depuis self.pcm.sample_rate, appelle playback.read et retourne self.rate. Ce fichier Bevy n’est pas compilé dans ce lot ; aucune conclusion globale sur le rééchantillonnage aval rodio/périphérique n’est déduite. Les rôles existants Playback::read et process_voice sont conservés ; deux rôles précis sont ajoutés pour ratio et la déclaration de fréquence du décodeur.

## Intégration et vérifications

Preuves dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :
revision751_rea_source_pipeline, revision751_source_native, revision751_source_boundaries, revision751_rust_source, revision751_source_associations et revision751_delivery.

L’audit recoupe les instructions et réponses REA, les allocations/libérations, les champs de contrôle, les sorties Rust et leurs identités de compilation. Six preuves volontairement altérées sont refusées : libération source absente, buffer non libéré, progression de rampe modifiée, bornage natif modifié, sample courant altéré et projection de diagnostic promue en implémentation produit. Ces refus d’audit restent distincts des cas limites réellement exécutés.

Livraison ciblée : rapport et preuve JSON ; trois registres (completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json) ; coverage.json, completion_plan.json, resume_checkpoint.json, CURRENT.md et HANDOFF.md ; deux lignes de tâches dans chacune des bases projet et application. Les cases, notes, historiques, autres tâches, prérequis et inconnues restent conservés. Les reçus VERIFIED.json puis INDEPENDENT_READBACK.json et FINAL_VERIFIED.json distinguent publication, relecture indépendante et contrôle final. Leur présence et passed=true sont nécessaires avant de conclure la livraison.

## Travail restant

Fournisseur/décodeur réel, constructeurs et propriété des objets, autres formats et canaux, orchestration Rust normale, effets réels, métadonnées non vides, mixage B267F0, caller B0DFC0 et sortie physique. Conserver aussi les limites ENVS/auxiliaires/bus, commande20/état étendu, Meter, Init complet, médias/locale et toutes les autres exigences partielles. Aucun jeu, champion, système audio complet ou acceptation humaine n’est déclaré terminé.
