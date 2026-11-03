# SYS-18.1-05 — sources des six musiques globales

2026-11-01T20:25:05.538006+00:00

Le lot des six sources est terminé sous réserve de relecture indépendante. Les octets natifs, clés XML et consommateurs statiques sont identifiés. La fonction audio, le parent SYS-18.1-05 et le jeu ne sont pas déclarés terminés.

## Résultat concret
Les cinq sources manquantes sont récupérées dans un nouveau répertoire de références sur F : 30 790 033 octets, tous conformes à leur taille et MD5 du manifeste. La sixième source déjà admise, ChmpSlct_BlindPick.mp3, est contrôlée par identité et conservée sans nouveau téléchargement. Les six fichiers totalisent33 950 121octets.

- MUSIC_HOWLING_ABYSS_PATH → assets/sounds/ambient/howlingabyss_champselect.mp3 ; révision 0.0.1.7 ; 2563968 octets ; MD5 c0cefa9e1bd15dbbfb1791e15745347d ; origine new_native_reference_recovery.
- MUSIC_DOMINION_DRAFT_MODE_PATH → assets/sounds/ambient/ChmpSlct_Odin_DraftMode.mp3 ; révision 0.0.0.146 ; 11611222 octets ; MD5 6630fd99905d47191a026997416a4c66 ; origine new_native_reference_recovery.
- MUSIC_DRAFT_MODE_PATH → assets/sounds/ambient/ChmpSlct_DraftMode.mp3 ; révision 0.0.0.146 ; 11560231 octets ; MD5 01ea7e54833a9398777433761be4e785 ; origine new_native_reference_recovery.
- MUSIC_DOMINION_BLIND_PICK_PATH → assets/sounds/ambient/ChmpSlct_Odin_BlindPick.mp3 ; révision 0.0.0.146 ; 3426745 octets ; MD5 f49744b91639a881b9245ac3eab60f50 ; origine new_native_reference_recovery.
- MUSIC_BLIND_PICK_PATH → assets/sounds/ambient/ChmpSlct_BlindPick.mp3 ; révision 0.0.0.146 ; 3160088 octets ; MD5 84f32cfbaf789d488521560f819ba1c6 ; origine previous_source_reused_without_download.
- MUSIC_TUTORIAL → assets/sounds/ambient/ChmpSlct_Tutorial.mp3 ; révision 0.0.0.5 ; 1627867 octets ; MD5 c47365795d8c5b0940568ab0a4005f26 ; origine new_native_reference_recovery.

## Provenance et contrôles réels
Une nouvelle recherche bornée retrouve les cinq chemins exacts live/lol_air_client/révision/fichier dans l’index déjà qualifié. Les181 autres candidats de versions ou chemins différents sont conservés séparément, sans choisir automatiquement la version fusionnée la plus récente. Les dates de l’archive ne prouvent pas le build ou le déploiement historique.
Les descripteurs natifs donnent2 916 blocs uniques. Le transport de contenu est limité à31 plages,29 921 006octets de corps,avec un maximum de1Mio par réponse. Le checksum de table et les recherches précédentes ne sont pas rejoués. Zstandard déjà présent décompresse l’archive ; cela ne décode pas le MP3. Chaque fichier reconstitué passe ensuite le contrôle natif taille/MD5.
Le premier run s’arrête sur des erreursHTTP500 après deux descripteurs admis. Une reprise ne demande que les éléments manquants et réutilise ces deux réponses. Les deux runs et39tentatives restent conservés :36réponses206 admises et trois échecs500. Aucun corps en erreur n’est admis.

## Consommateurs et limites
PlayMusicCommand est typé ISoundProvider. Sa méthode playMusic contient huit appels pour six clés : tutoriel prioritaire ; draft et tournoi avec distinction Dominion/Crystal Scar ; puis Dominion,ARAM/HowlingAbyss et choix aveugle par défaut. Une absence de fournisseur a une garde statique. La source complète, les lignes et les attributs XML sont conservés ; aucun choix n’est simulé ou exécuté par cet audit.
Les paramètres de type, volume, fade et boucle proviennent des XML et du fournisseur déjà qualifiés. Les chemins littéraux à séparateurs doublés restent distincts des clés canoniques utilisées pour comparer au manifeste. Les sources ne prouvent pas la normalisation du host, le chargement effectif ou la fidélité d’une transition.
Le résultat de recherche précédent du launcher actuel est réutilisé par identité de ses fichiers et avec ses bornes frontend/Tauri. Il n’est pas rejoué et ne prouve pas une absence dans tout le moteur de jeu ou son HUD.

## Bilan restant ouvert
Le recensement intégral garde2 750 chemins médias :11 ont maintenant une source native admise,2 739 restent sans payload admis,soit255 918 914octets natifs déclarés. Le manque des trois XML, résolu dans le lot précédent, reste conservé comme tel. Les deux références XML non rapprochées, les autres langues, voix dynamiques et FLV ne sont pas exclus silencieusement.
Non exécutés : décodage MPEG, mesure de durée audible, écoute, lecture audio/vidéo, volume ou périphérique, horloge/boucles/fades natifs, bootstrap AIR/Flash, logique originale, jeu ou rendu GUI. Une source native exacte ne vaut pas acceptation humaine ni fonctionnalité intégrée.

## Clôture et reprise
Les sept rubriques documentaires sont remplies pour ce sous-ensemble : périmètre, sources, consommateurs, contrôles attendus/observés, limites, corrections existantes et preuves/relecture. Aucun nouveau critère ou registre n’est ajouté.
Prochain lot : AUD-18.1-05-GLOBAL-UI-SOUND-SOURCES-01. Il couvre exactement20événements /newSounds/ partageant sept fichiers : deux sources déjà admises, cinq à qualifier. Réutiliser les XML, admissions cumulées, indices et réponses acceptées ; ne rechercher que les nouveaux chemins/révisions nécessaires.
Ajouts uniquement : le dossier source F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-GLOBAL-MUSIC-SOURCES-01, le dossier d’audit F:\OpenLeague-work\audit-units\AUD-18.1-05-GLOBAL-MUSIC-SOURCES-01 et ce rapport. Goal, critères normatifs, registres, code produit, suivi et bases inchangés ; aucune installation ou migration.
