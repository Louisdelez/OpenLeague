# SYS-18.1-05 — trois couches musicales CAP

2026-11-01T22:24:48.000332+00:00

Audit documentaire des sources et consommateurs statiques terminé sous réserve de relecture indépendante. Implémentation, phase/mixage/boucle audibles, runtime AIR, parent et jeu restent ouverts.

## Sources
Trois chemins natifs révision 0.0.1.72, 5 917 049 octets chacun, MD5 et SHA256 distincts : 17 751 147 octets au total. Les 117 admissions antérieures ne fournissaient pas ces nouvelles identités.
1 669 blocs uniques, 18 plages de contenu totalisant 17 638 897 octets, sous un budget préalable de 32 Mio et 1 Mio maximum par réponse. Avec les descripteurs : 21 réponses 206 distinctes, 17 665 823 octets reçus. Aucun échec ou réponse déjà réussie rejouée ; décompression d’archive seulement.

- mod/cap/assets/audio/LoL_Teambuilder_ATSN_v4r08_BASE_LAYER_loop_441_16.mp3 — MD5 71b4de86891d3349d1e844d156ffc5c0.
- mod/cap/assets/audio/LoL_Teambuilder_ATSN_v4r08_SECOND_LAYER_loop_441_16.mp3 — MD5 45a879b9681f5832b80b0e563424242d.
- mod/cap/assets/audio/LoL_Teambuilder_ATSN_v4r08_TOP_LAYER_loop_441_16.mp3 — MD5 225670d28a7fdd84fe2f2cc33fcb663b.

## Propriétés, contrôleur et consommateurs
La première recherche des trois valeurs XML ne trouvait que leurs constantes. La source révèle une liaison dynamique : propriétés CAP_BGM_LAYER_1, _2, _3 vers valeurs CAP_BGM_LAYER1, 2, 3. Une nouvelle question ciblée retrouve 35 lignes dans 27 sources et 25 demandes de niveau : 18 LEVEL_1, quatre LEVEL_2, trois LEVEL_3. Trois fenêtres du lot SFX sont réutilisées, dont la préparation qui arrête la musique ; sa recherche n’est pas rejouée.
CapMusicController parcourt les indices LEVEL_1 à LEVEL_COUNT, résout CapAudioKeys[BGM_KEY_PREFIX + index], puis demande play(key,true,1) ou play(key,true,0) selon le niveau demandé. stopMusic parcourt allBgmKeys ; destroy appelle stopMusic. La signature est uint, sans validation de plage explicite dans cette méthode ; aucune conversion ni valeur hors plage n’est exécutée.
AudioProviderImpl applique le troisième paramètre au volume de couche avant AudioAsset.play, auquel le second paramètre transmet la boucle. AudioTypes réserve le prédicat de musique exclusive à music/login_music ; layered_music en est distinct. Les appels typés ISoundProvider ne qualifient pas l’injection/bootstrap concret du host.

## Déclarations et limites audio
Les trois événements ont type layered_music, preload=true, volumeModifier=1 et loopOverlapMS=1150. Fade-in : 1 seconde pour la première couche, 2 pour les deux autres ; fade-out : 2 secondes chacune. AudioAsset affecte le modifier directement sans canal, sinon le borne à [0,1] et demande un tween de 0,5 seconde.
Pour l’asset déjà chargé et joué, la branche non-SFX retourne sauf pendant le bouclage ; le setter de volume du provider précède cet appel. En attente de chargement, _playWhenLoaded et _loop sont stockés. Dans la branche de boucle, le timer utilise sound.length - overlap avec minimum de 500 ms ; Sound.play démarre à 87 ms. Ces branches sont statiques, sans exécution AS ou émulation.
La taille commune des fichiers ne prouve ni durée décodée commune, ni phase, départs synchronisés, continuité de boucle ou mixage fidèle. Aucun codec MP3, écoute, signal, timer, tween, GUI ou logique/réseau du jeu exécuté. Les sources provider/types/asset et la recherche frontend/Tauri antérieure sont réutilisées à identité et portée inchangées.

## Écarts et reprise
117 admissions précédentes conservées ; 120 chemins admis sur 2 750, 2 630 sans payload admis, pour 227 455 252 octets déclarés sommés par chemin. Les candidats non listés antérieurs, dont null.mp3 réellement demandé par CAP, restent ouverts hors de ce dénominateur. Aucun pourcentage du jeu n’est déduit.
Prochain lot : AUD-18.1-05-LOGIN-THEME-MUSIC-SOURCES-01 — trois événements login, quatre chemins musicaux natifs et huit candidats de thème/locale non listés. Présence de loginKalista/loginSummonersrift/parchment ne prouve pas le thème effectif ou son ordre de repli.
Les sept rubriques sont documentées. Corrections réutilisées : SYS-18.1-05 et tâches UI/audio existantes ; une précision rejoint l’écart XML/host existant. Aucun goal, critère, registre, produit, Plan ou base modifié ; aucune installation, migration, relance ou retrait.
Ajouts uniquement : nouveau dossier de références F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-CAP-LAYERED-MUSIC-SOURCES-01, dossier de preuves F:\OpenLeague-work\audit-units\AUD-18.1-05-CAP-LAYERED-MUSIC-SOURCES-01 et ce rapport. Reçus de production/relecture séparés ; accepted-delivery.json sélectionne la preuve si la relecture réussit.
