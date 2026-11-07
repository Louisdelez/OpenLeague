# SYS-18.1-05 — trois XML audio natifs récupérés et qualifiés

2026-11-01T20:13:11.479971+00:00

Le lot des trois XML est terminé sous réserve de relecture indépendante. Le manque d’entrée AIR-AUDIO-THREE-DEFINITION-XML-INPUTS est résolu. SYS-18.1-05 reste ouvert sur les médias non admis ; cette livraison ne termine ni la fonction audio ni le jeu.

## Résultat concret
Les trois fichiers originaux sont conservés uniquement comme références dans un nouveau répertoire F. Ils totalisent 15 091 octets, tous conformes à la taille et au MD5 du manifeste sélectionné. Aucun fichier produit ou source antérieure n’est écrasé.

- assets/sounds/AudioEventDefinitions.xml — révision 0.0.1.89, 10045 octets ; MD5 374382a976d15cfde357f69929e10975 ; source F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-AUDIO-DEFINITIONS-SOURCE-RECOVERY-01\payloads\assets\sounds\AudioEventDefinitions.xml
- mod/lgn/audio/LoginAudioEventDefinitions.xml — révision 0.0.1.48, 573 octets ; MD5 3a31aa1c5e2b87debd5e485424a192e3 ; source F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-AUDIO-DEFINITIONS-SOURCE-RECOVERY-01\payloads\mod\lgn\audio\LoginAudioEventDefinitions.xml
- mod/cap/assets/audio/CapAudioEventDefinitions.xml — révision 0.0.1.76, 4473 octets ; MD5 5a837c0a77af526cdb02093074743f6a ; source F:\OpenLeague-work\audit-source-recovery\AUD-18.1-05-AUDIO-DEFINITIONS-SOURCE-RECOVERY-01\payloads\mod\cap\assets\audio\CapAudioEventDefinitions.xml

## Recherche bornée et provenance
L’index AIR conservé a été consulté une seule fois pour trois chemins d’archive complets : plateforme live, projet lol_air_client, révision de chaque fichier et chemin logique. Les trois correspondances exactes sont conservées avec ligne et offset ; 381 autres révisions ou chemins de noms similaires restent séparés. La vue fusionnée la plus récente n’est pas utilisée comme autorité. L’horodatage d’archive n’est pas une date de build ou de déploiement du client.
Trois descripteurs et quatre blocs de contenu ont nécessité sept réponses HTTP partielles strictement bornées, toutes206 acceptées. Étendue, taille, identité d’archive et corps sont conservés. Les sources sont reconstituées avec le décompresseur Zstandard déjà présent et vérifiées contre les MD5 natifs ; aucune installation ni lecture de média. Le checksum de table déjà qualifié n’est pas rejoué.

## Associations maintenant examinées
Les XML déclarent 120 clés uniques :91 dans les définitions globales,3 pour la connexion et26 pour le Team Builder. Les attributs de fichier/type/volume/fade/locale/préchargement/boucle sont conservés événement par événement. Trois événements portent preload=true, sept volumeModifier=0 et24 defaultToUS=false ; ce sont des déclarations, pas des actions observées.
AudioProviderImpl, AudioAttributes, AudioTypes, AudioKeys, AudioAsset, ThemeConfig, LoginModule et ClientModuleCap sont liés aux sources et aux lignes réelles. Le constructeur charge le XML global ; LoginModule.initialize enregistre le XML login ; CAP l’enregistre dans onAssetsLoaded lorsque !published. Le fournisseur applique un chemin de base et le volume du groupe, fusionne les définitions, cherche une clé en majuscules et contient un refus statique des clés inconnues. Aucune de ces méthodes AIR n’est exécutée.
Les noms de thèmes présents dans le manifeste sont loginKalista, loginSummonersrift et parchment. Le thème par défaut du constructeur est parchment ; cela ne prouve pas l’ordre effectif configuré. Les chemins sont comparés pour en_GB et les branches conditionnelles en_US, sans déclarer ces replis ou le bootstrap exécutés.

## Limites et anomalies conservées
Deux références ne trouvent pas de candidat dans ce rapprochement au manifeste : SOUND_LOGIN_SCREEN_LORE, chemin de narration HowlingAbyss par thème/locale à volume XML zéro, et CAP_MATCHMAKING_STARTED, qui désigne /null.mp3. Ce résultat ne prouve ni un silence volontaire ni un fichier corrompu. Aucun remplacement n’est créé.
Le fournisseur concatène littéralement base + "/" + file. Plusieurs chemins contiennent donc des séparateurs doublés. Le chemin littéral et une clé canonique de comparaison sont tous deux conservés ; la normalisation du host AIR n’est pas démontrée. Les règles de préférences, cache, ordre de fusion, horloge, boucles, fades et rendu restent distinctes.
Les XML conduisent à122 candidats uniques du manifeste pour en_GB et le repli conditionnel en_US : quatre étaient déjà admis,118 restent sans payload admis. Il s’agit d’un sous-ensemble des2 750 médias externes recensés auparavant. Les2 744 payloads non admis du recensement intégral restent ouverts ; ni les autres langues, ni les voix de champion construites dynamiquement, ni les FLV et transitions ne sont exclus.

## Contrôles réellement exécutés
Correspondances exactes dans l’index, contrôle des réponses206, décompression des seuls blocs nécessaires, reconstruction des trois XML, tailles/MD5 natifs, parsing XML sans DTD/entité, inventaire des120 événements et inspection statique de huit consommateurs. Le gel des fichiers protégés et du corpus courant est contrôlé avant et après.
Une première qualification a échoué sur un préfixe review/ omis dans la clé d’index des métadonnées. Le script et le retour code1 sont conservés ; aucun résultat de qualification ni source native n’avait été écrit. Une version distincte corrige cette clé et a réellement terminé avec code0.
Non exécutés : codecs audio/vidéo, lecture ou écoute, changement de volume/périphérique, host AIR/Flash, logique d’origine, jeu, rendu GUI, installation, migration ou accès aux bases du suivi.

## Clôture et reprise
Les sept rubriques documentaires sont remplies pour ce lot : périmètre, sources/provenance, consommateurs, attendu/observé, écarts, corrections existantes réutilisées et preuves/relecture. Le manque des trois XML est résolu ; les inconnues ne deviennent pas des fonctionnalités terminées.
Prochain lot : AUD-18.1-05-GLOBAL-MUSIC-SOURCES-01. Il couvre exactement les six musiques du groupe MUSIC global : conserver celle déjà admise et traiter les cinq restantes, par révision/taille/MD5 ou constat borné de recherche non concluante. Aucun nouveau téléchargement des octets déjà admis.
Ajouts uniquement : F:\OpenLeague-work\audit-units\AUD-18.1-05-AUDIO-DEFINITIONS-SOURCE-RECOVERY-01, le dossier source de récupération et ce rapport. Goal, critères, registres, application, code produit et bases inchangés.
