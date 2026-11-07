# SYS-18.1-05 — musiques de connexion et thèmes

2026-11-01T22:44:27.613265+00:00

Audit documentaire du lot terminé avec constats non listés, sous réserve de relecture indépendante. Thème actif, cycle de signaux, audio réel, implémentation, parent et jeu restent ouverts.

## Sources et alias
Quatre chemins natifs, trois identités SHA256, 12 651 794 octets sommés par chemin et 8 639 760 octets uniques. Intro/boucle Summoner’s Rift sont identiques et partagent le même descripteur ; leurs rôles et attributs restent distincts. Kalista intro/boucle ont la même taille mais des MD5 différents. Les 120 admissions précédentes et l’ancien MP3 login conservé ont été comparés avant transport : aucune substitution conforme.
621 blocs uniques, sept plages de contenu de 6 118 767 octets, sous un budget préalable de 16 Mio et 1 Mio maximum par réponse. Dix réponses HTTP 206 distinctes, 6 132 365 octets réellement reçus. Le reçu de récupération compte onze utilisations car un descripteur commun est réutilisé sans nouvelle requête. Aucun échec ou ancien succès rejoué. Décompression d’archive seulement.

- mod/lgn/themes/loginKalista/music/LoginScreenIntro.mp3 — 0.0.1.119, 2313863 octets ; MD5 d9981aadb1cadf22ce1711d9ec4ca4e6.
- mod/lgn/themes/loginSummonersrift/music/LoginScreenIntro.mp3 — 0.0.1.116, 4012034 octets ; MD5 66f860c7942d039cb16c0504d35d9f73.
- mod/lgn/themes/loginKalista/music/LoginScreenLoop.mp3 — 0.0.1.119, 2313863 octets ; MD5 1c47504f90756dee0c4ea9131e5cbf13.
- mod/lgn/themes/loginSummonersrift/music/LoginScreenLoop.mp3 — 0.0.1.116, 4012034 octets ; MD5 66f860c7942d039cb16c0504d35d9f73.

## Consommateurs et signaux
La recherche des trois clés donne 18 lignes dans AudioKeys/AudioProviderImpl. Une nouvelle question sur play/stop/mute et assignations explicites de thème donne 23 lignes dans cinq sources : proxy, interface héritée, implémentation, LoginView et ApplicationController. Treize fenêtres nouvelles, trois sélections supplémentaires et six sources XML/provider/thème réutilisées documentent les liaisons. ISoundProvider hérite d’ISoundManager ; une déclaration d’interface seule n’est pas une implémentation.
Le provider garde loginMusicPlaying, demande INTRO et LORE, puis ajoute loginIntroComplete sur soundEndingSignal. Le callback demande LOOP en boucle si le drapeau est encore vrai. stopLoginMusic arrête les trois assets présents, retire ce callback de soundCompleteSignal, puis remet le drapeau à false. Les signaux sont distincts ; l’asymétrie est conservée sans déclaration de fuite ou de duplication avérée. Aucun cycle de Signal n’est exécuté.
LoginView démarre sur chargement du fond sans partnerCredentials et demande stop à sa destruction. Il traite un indicateur optionnel de musique embarquée SWF, avec défaut true, et transmet des préférences d’animation/mute. setSwfAudioMute règle un MovieClip présent et un éventuel defaultVolumeSetter. Aucun indicateur SWF, volume, préférence, appareil, GUI ou son exécuté.

## Thèmes et candidats non listés
ThemeConfig déclare parchment à la construction ; son setter sépare une chaîne CSV et son résolveur parcourt le vecteur ordonné jusqu’au premier fichier existant. La requête AS bornée ne retrouve aucune assignation conventionnelle .themeConfig dans sa forme recherchée ; elle ne prouve pas l’absence d’une configuration dynamique/bootstrap ou le thème effectif. La présence de loginKalista/loginSummonersrift/parchment au manifeste ne définit pas leur ordre.
Huit candidats restent sans entrée native : six variantes de lore (trois thèmes, en_GB/en_US) et les intro/boucle parchment. Le volume XML de LORE vaut 0.0 mais le provider le demande ; ne pas inventer de silence volontaire, de fichier ou de corruption. Les chemins littéraux et la normalisation de comparaison au manifeste sont distincts d’un test de résolution AIR.
Reprise : fournir la configuration de thème historique effective et un fichier loose/généré, paquet ou producteur de bootstrap identifié pour le chemin précis. Sans piste nouvelle, ne pas relancer les mêmes recherches de manifeste. L’impact des signaux exige leur implémentation effective et une observation autorisée du cycle stop/reprise ; il reste ouvert.

## Couverture et reprise
Les 120 admissions précédentes sont conservées ; 124 chemins admis sur 2 750, 2 626 sans payload admis, soit 214 803 458 octets déclarés sommés par chemin. Aucun pourcentage du jeu n’est calculé.
Les trois XML déclarent 120 événements et 122 chemins natifs candidats, désormais tous fournis par des octets qualifiés ; neuf chemins non listés restent documentés hors catalogue. Deux admissions (button_click/hover) sont hors de cette matrice XML et restent conservées. La couverture des consommateurs des 120événements n’est pas encore réconciliée.
Prochain lot : AUD-18.1-05-XML-AUDIO-COVERAGE-REVIEW-01 — relier chacun des 120événements aux cohortes et consommateurs déjà audités, vérifier les chevauchements/homonymes et les122sources/neuf constats, sans rejouer les anciens scripts ou transports. Toute lacune doit rester précise ; la disponibilité des octets ne suffit pas à clore cette revue.
Les sept rubriques sont documentées. SYS-18.1-05 et tâches UI/audio existantes réutilisées ; une précision rejoint l’écart XML/host. Aucun goal, critère, registre, produit, Plan ou base modifié ; aucune installation, migration, relance ou retrait.
Ajouts uniquement : nouveau dossier de références F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-LOGIN-THEME-MUSIC-SOURCES-01, dossier de preuves F:\OpenLeague-work\audit-units\AUD-18.1-05-LOGIN-THEME-MUSIC-SOURCES-01 et ce rapport. Reçus de production/relecture séparés ; accepted-delivery.json sélectionne la preuve si la relecture réussit.
