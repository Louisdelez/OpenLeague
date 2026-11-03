# SYS-18.1-05 — sept sources des sons UI, vingt événements

2026-11-01T20:36:31.885280+00:00

Le lot de sources est terminé sous réserve de relecture indépendante. Il qualifie les sept fichiers partagés par vingt événements /newSounds/, avec leurs clés et références statiques. Il ne termine ni la fonction audio, ni SYS-18.1-05, ni le jeu.

## Résultat concret
Les cinq sources manquantes sont conservées uniquement comme références sur F : 114 985 octets, tous conformes aux tailles et MD5 natifs. Les deux sources déjà admises, air_button_press_1.mp3 et air_button_rollover_1.mp3, sont vérifiées et conservées sans nouveau téléchargement. Les sept fichiers totalisent 127 903 octets.

- assets/sounds/newSounds/playbutton.mp3 — révision 0.0.0.1, 41536 octets ; MD5 25ae372b4cd985fd3ffa1a0627eb1569 ; new_native_reference_recovery.
- assets/sounds/newSounds/login.mp3 — révision 0.0.0.1, 23296 octets ; MD5 4442db2dde2353e4ed0fb51b09a092fb ; new_native_reference_recovery.
- assets/sounds/newSounds/air_button_press_1.mp3 — révision 0.0.0.1, 6852 octets ; MD5 1591ff0951b3f177b28fc448973a6df9 ; previous_source_reused_without_download.
- assets/sounds/newSounds/air_button_rollover_1.mp3 — révision 0.0.0.1, 6066 octets ; MD5 f0dda884e48794aa62ac74f6b8ebad35 ; previous_source_reused_without_download.
- assets/sounds/newSounds/air_button_press_7.mp3 — révision 0.0.0.1, 7142 octets ; MD5 c00ba5d19baa5bbc05fdfef953f8370a ; new_native_reference_recovery.
- assets/sounds/newSounds/air_box_chalkcheck_1.mp3 — révision 0.0.0.1, 8526 octets ; MD5 52acc840628e17696b47db8ae3906e6d ; new_native_reference_recovery.
- assets/sounds/newSounds/air_button_press_12.mp3 — révision 0.0.0.1, 34485 octets ; MD5 2f7d61bc387d5f8d81618fffd08897a0 ; new_native_reference_recovery.

## Provenance et contrôles exécutés
Une recherche nouvelle et bornée identifie cinq chemins d’archive exacts pour leur révision native ; 284 autres candidats restent séparés. Les treize blocs de contenu sont transportés en quatre plages, 93 361 octets de corps ; avec les descripteurs, neuf réponses206 acceptées totalisent 93 614 octets. Aucun paquet global ou média déjà admis n’est téléchargé. Le décompresseur Zstandard existant sert à l’archive, pas au codec MP3.
Le contrôle Git initial en lecture dans le bac à sable a échoué avant toute création de sortie ; la commande de lecture qualifiée, avec accès autorisé, confirme ensuite l’état inchangé. Les préparations en échec et leurs sources sont conservées. Le goal, le code produit, les registres et bases restent gelés.

## Consommateurs statiques et précision de recherche
La recherche brute des vingt clés relève 62 lignes dans 22 fichiers. Deux lignes ne concernent que SOUND_MOUSE_OVER_DISABLED, hors du lot : elles restent conservées séparément. Le filtrage exact des lignes déjà acquises donne 60 lignes, 62 couples clé/ligne ; aucun nouveau scan global n’est exécuté.
Les références couvrent notamment boutons audio, barre de boutons, combo box, bouton Play, navigation, liste de champions, connexion, préférences, runes et commandes de sélection/ban. Les définitions de constantes, appels directs et liaisons de constructeur/propriété/fabrique restent distincts ; six sources complètes de composants et provider sont liées aux preuves. Aucun de ces chemins natifs n’est exécuté.
Quatre clés n’ont que leur déclaration constante dans cette recherche AS : SOUND_OPTIONS_MENU_OPEN, SOUND_HOME_BUTTON_CLICK, SOUND_DROP_DOWN_OPEN et SOUND_DROP_DOWN_SELECT. Cela ne démontre pas leur inutilité globale ; les clés dynamiques, ressources UI sérialisées et bootstrap restent à qualifier avec une piste précise avant une nouvelle recherche.

## Partage de fichier et volumes
Les vingt événements partagent sept fichiers, mais gardent leurs attributs propres. SOUND_MOUSE_OVER déclare volumeModifier=0 ; d’autres événements utilisant le même fichier de rollover déclarent .45. Le média seul ne détermine donc pas le volume d’un événement. Aucun silence audible ou fonctionnement de préférence n’est démontré.
Les chemins littéraux à séparateurs doublés restent distincts des clés canoniques de comparaison au manifeste. Le résultat précédent du launcher courant est réutilisé par identité et portée frontend/Tauri ; il ne vaut pas absence dans tout le moteur de jeu ou son HUD.

## Ce qui reste ouvert
Le catalogue intégral conserve 2 750 chemins : 16 sources natives sont admises, 2 734 chemins restent sans payload admis, soit 255 803 929 octets natifs déclarés. Les acquis des trois XML et six musiques restent conservés. Autres langues, voix dynamiques, FLV, deux références XML non rapprochées et routes UI restent dans le périmètre restant.
Non exécutés : codec MPEG, écoute/lecture, volume ou périphérique, durée audible, timing, boucle/fade, host AIR/Flash, logique originale, jeu, rendu GUI ou acceptation humaine. Aucun logiciel installé, migration ou application relancée.

## Clôture et reprise
Les sept rubriques sont examinées pour ce lot : exigence, sources, consommateurs, attendu/observé, limites, travaux existants réutilisés et preuves/relecture. Les données du suivi et les critères normatifs ne sont pas modifiés.
Prochain lot : AUD-18.1-05-CHAMPSELECT-SOUND-SOURCES-01 — huit événements /champSelect/ et huit fichiers ; conserver celui déjà admis et qualifier les sept autres par chemin/révision/taille/MD5 ou recherche bornée non concluante.
Ajouts uniquement : le nouveau dossier de références F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-GLOBAL-UI-SOUND-SOURCES-01, le dossier d’audit F:\OpenLeague-work\audit-units\AUD-18.1-05-GLOBAL-UI-SOUND-SOURCES-01 et ce rapport.
