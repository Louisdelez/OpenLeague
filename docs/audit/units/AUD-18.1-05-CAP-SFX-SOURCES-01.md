# SYS-18.1-05 — effets sonores CAP

2026-11-01T22:11:47.351507+00:00

Audit documentaire des 23 événements SFX terminé avec un constat de source non listée, sous réserve de relecture indépendante. Implémentation, runtime audio/matchmaking, parent et jeu restent ouverts.

## Sources et contrôles
16 chemins natifs récupérés, conformes à leurs tailles et MD5 : 633 288 octets sommés par chemin. 15 identités SHA256, 606 956 octets uniques. La paire groupfinder-player_fadein/groupfinder-solo_proposed a des octets identiques mais conserve ses deux chemins et IDs ; les clés ont des modifiers .5 et .8. Aucun événement n’est fusionné.
70 blocs uniques, trois plages de contenu totalisant 567 412 octets. Avec les descripteurs, 19 réponses HTTP 206 distinctes, 568 724 octets. Aucun échec ou ancien succès rejoué. Décompression Zstandard d’archive seulement.

- mod/cap/assets/audio/global-button_large.mp3 — 0.0.1.72, 32256 octets ; MD5 59a61fce420119ce2e6cc30d6269671a.
- mod/cap/assets/audio/groupfinder-solo_groupfound.mp3 — 0.0.1.72, 43280 octets ; MD5 fc9958369348c014dbcaa1d8cbec8d59.
- mod/cap/assets/audio/global-button_small.mp3 — 0.0.1.72, 13440 octets ; MD5 68fb8237e06a67908b34d56a8ed259bf.
- mod/cap/assets/audio/groupfinder-player_declined.mp3 — 0.0.1.72, 24960 octets ; MD5 a845f459c9f16b5111c5ecb47d54e275.
- mod/cap/assets/audio/global-dropdown_open_01.mp3 — 0.0.1.72, 65518 octets ; MD5 d3707e36c3dbac981808dce46e7f97d2.
- mod/cap/assets/audio/global-dropdown_select.mp3 — 0.0.1.72, 25344 octets ; MD5 b084821ab0f8ce5846fd461d9096d21f.
- mod/cap/assets/audio/global-menu_open_01.mp3 — 0.0.1.72, 17884 octets ; MD5 cc4207be8c0b42fa129c277118bc1a4b.
- mod/cap/assets/audio/groupfinder-player_join.mp3 — 0.0.1.72, 29184 octets ; MD5 7b984111f0f67680f946ea9ee27c2650.
- mod/cap/assets/audio/groupfinder-player_leaves.mp3 — 0.0.1.72, 24412 octets ; MD5 1612a2b44025fba13825819490e9fbd0.
- mod/cap/assets/audio/groupfinder-player_ready.mp3 — 0.0.1.72, 65280 octets ; MD5 1da8085c30843d619ffa3b33f0207649.
- mod/cap/assets/audio/groupfinder-captain_allready.mp3 — 0.0.1.72, 57908 octets ; MD5 40482e9377555d8002f8aca7585e12dc.
- mod/cap/assets/audio/groupfinder-player_fadein.mp3 — 0.0.1.72, 26332 octets ; MD5 1d714c4d8bdf589244d19ebcf970a68c.
- mod/cap/assets/audio/groupfinder-player_changeposition.mp3 — 0.0.1.72, 29020 octets ; MD5 0c701f91d1ef12b858dcfa2648214355.
- mod/cap/assets/audio/groupfinder-solo_proposed.mp3 — 0.0.1.72, 26332 octets ; MD5 1d714c4d8bdf589244d19ebcf970a68c.
- mod/cap/assets/audio/global-menu_close_01.mp3 — 0.0.1.72, 29258 octets ; MD5 2e2629c1e9c3355c398dd0b452c75d4f.
- mod/cap/assets/audio/LoL_Teambuilder_ATSN_v4r08_HIT_441_16.mp3 — 0.0.1.72, 122880 octets ; MD5 5ad0b63f3ba80194eb7fc1a73c694cab.

## Consommateurs et source non listée
Nouvelle recherche exacte dans 9 139 fichiers AS : 54 lignes dans 15 fichiers, soit 23 constantes CapAudioKeys et 31 appels play. Toutes les 23 clés ont une référence non constante. 22 événements pointent vers les 16 fichiers qualifiés ; CAP_MATCHMAKING_STARTED pointe vers /null.mp3.
Ce dernier est réellement demandé par setupAudioPlaybacks, sur inMatchmakingQueueChanged lorsque inMatchmakingQueue est vrai. Le manifeste natif sélectionné ne liste pas mod/cap/assets/audio/null.mp3, constat repris de l’audit XML. Aucun payload n’est admis ou fabriqué. Cela ne prouve ni corruption ni silence volontaire. Le constructeur AudioAsset retourne si son résolveur renvoie null ; cette branche n’a pas été exécutée sur un host AIR.
Reprise du cas null : fournir un fichier loose/généré historiquement identifié ou une preuve de paquet/bootstrap pour ce chemin précis. Sans piste nouvelle, conserver le constat de manifeste inchangé ; ne pas répéter sa recherche. Une observation runtime exigerait un environnement AIR identifié et une autorisation distincte.

## Gardes et limites
Les fenêtres conservent les méthodes appelantes et leur contexte : ready ignore les joueurs distants ; changement de position retourne pendant fade-out ; fade-in teste playSound ; préparation retourne si _inProgress et demande le hit seulement si une vue CAP est présente. Le timeout déclaré vaut 5 200 ms ; il n’est pas exécuté. hideView demande PLAYER_LEAVES avant son action : le nom de cette clé ne démontre pas un événement réseau de départ.
Le XML et les fenêtres AudioProviderImpl, AudioAsset et ClientModuleCap sont réutilisés avec leurs empreintes. Les modifiers distincts d’une même source restent séparés. Aucune écoute, codec MP3, injection/bootstrap effectif, signal, timer, tween, GUI, matchmaking ou logique/réseau du jeu exécuté. Le contrôle du frontend/Tauri courant est réutilisé à portée et fichiers inchangés.

## Écarts et reprise
101 admissions précédentes conservées ; 117 chemins admis sur les 2 750 du catalogue, 2 633 sans payload admis, soit 245 206 399 octets déclarés sommés par chemin. Le candidat null.mp3 ne fait pas partie de ce dénominateur et reste explicitement ouvert. Ce décompte ne représente pas le pourcentage du jeu.
Prochain lot : AUD-18.1-05-CAP-LAYERED-MUSIC-SOURCES-01 — trois événements MUSIC layered_music et leurs trois sources, avec consommateurs et limites de niveaux/mixage/boucle distincts. Login, transitions, autres locales et runtime restent ouverts.
Les sept rubriques sont documentées. Corrections réutilisées : SYS-18.1-05 et tâches UI/CAP existantes. Le cas null complète l’écart XML/host existant. Aucun changement du goal, critères, registres, produit, Plan ou bases ; aucune installation, migration, relance ou retrait.
Ajouts uniquement : nouveau dossier de références F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-CAP-SFX-SOURCES-01, dossier de preuves F:\OpenLeague-work\audit-units\AUD-18.1-05-CAP-SFX-SOURCES-01 et ce rapport. Les reçus de production/relecture restent séparés ; accepted-delivery.json sélectionne la preuve technique si la relecture réussit.
