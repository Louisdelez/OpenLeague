# SYS-18.1-05 — sources des sons et transitions AIR

2026-11-01T20:04:17.459604+00:00

Le lot d’identité et d’admissibilité est terminé sous réserve de relecture. Le parent SYS-18.1-05 reste ouvert sur de vraies entrées manquantes. Aucun son, vidéo ou code AIR n’est joué ou exécuté ; aucun média n’est installé dans le produit.

## Résultats établis
Le manifeste sélectionné contient 2 748 MP3 et deux FLV, pour 289 933 347 octets déclarés. Il couvre 18 groupes de langue, dont 146 chemins en_GB, et 102 médias sans segment de locale. Tous ces chemins restent recensés, sans exemption silencieuse de langue ou de plateforme.
Six MP3 présents sont conformes à leur taille et MD5 natifs. Les 2 744 autres chemins n’ont pas de payload admis dans les racines exactes contrôlées, qui incluent les emplacements de version sélectionnée et de fichier géré. Ce n’est pas une affirmation d’absence sur tout le PC. Le projet AIR natif sur D est lui-même absent de la racine indiquée ; les références admises restent celles des archives et sources déjà conservées.
Le cache contient aussi LoL_MUSIC_PVP_Login.mp3, conservé depuis un ancien travail. Ce chemin n’est pas membre du manifeste sélectionné : il n’est ni supprimé ni substitué à la musique du thème de connexion. Sept fichiers en cache ne signifient donc pas sept médias admis pour cette référence.

## Sons et timelines embarqués
Huit SWF admis contiennent 26 DefineSound au codec2, 37 StartSound dont tous les identifiants sont définis dans le même SWF, 115 en-têtes de flux, 49 définitions vidéo et 5 977 frames vidéo. Les offsets, IDs, empreintes et contextes de timeline sont conservés.
Les 115 en-têtes ont un codec et un nombre d’échantillons à zéro ; aucun SoundStreamBlock n’est présent dans les sources admises. Ils ne deviennent pas 115 clips ni une déclaration de corruption. Parmi les 49 flux vidéo, 33 couvrent directement toute la plage nominale des numéros de frames ; 16 ne l’épuisent pas. Le maintien ou la répétition d’une frame et les règles de lecture restent à qualifier avant de conclure à un manque.

## Consommateurs réels et transitions
AudioProviderImpl implémente ISoundProvider ; SoundProviderProxy relaie les appels et AudioAsset gère chemins de locale/thème, repli conditionnel en_US, chargement, volume, boucles et fondus. La première requête ne trouvait aucune implémentation littérale de l’ancienne interface ISoundManager : cela ne prouve pas l’absence d’un fournisseur audio. Le fournisseur concret est maintenant identifié.
Les sources de GenericTransitions.getFadeOut déclarent une durée par défaut de 0,4 seconde, une rasterisation conditionnelle, une modification alpha, une fonction de lissage et une action vide lorsque les conditions ne sont pas satisfaites. AudioAsset déclare aussi des transitions de volume. Ces lectures statiques ne sont pas des sons ou animations reproduits.
La recherche ciblée audio/transitions relève 144 fichiers de référence AS : 54 portent des motifs audio et 97 des motifs de transitions, avec recouvrement possible. Les définitions de framework, interfaces et appelants restent distincts. La recherche complémentaire du service concret relève 235 références dans 75 fichiers. Aucun de ces comptes ne mesure des parcours exécutés.
Le launcher actuel ne contient pas de lecteur audio ou transition historique identifié par la requête nommée sur son frontend et ses sources Tauri : code1, zéro hit, aucune erreur. Cette absence est bornée aux fichiers et motifs inspectés ; elle ne concerne pas tout le moteur de partie Rust ou son HUD.

## Entrées indispensables encore manquantes
AudioProviderImpl charge et fusionne trois fichiers XML natifs : assets/sounds/AudioEventDefinitions.xml, mod/lgn/audio/LoginAudioEventDefinitions.xml et mod/cap/assets/audio/CapAudioEventDefinitions.xml. Ils sont absents des chemins contrôlés. Les entrées exactes de manifeste, tailles, MD5 et chemins de recherche sont conservés.
Sans ces XML, les associations de clés, chemins, paramètres et thèmes n’ont pas été examinées. Ce manque et les 2 744 payloads non admis restent ouverts ; ils ne sont pas transformés en une réussite documentaire du parent.

## Contrôles et frontières
Exécutés : recensement des chemins de manifeste, vérification taille/MD5 des médias présents, lecture bornée des tags natifs, rapprochement des StartSound, contrôle des index de frames et inspection des consommateurs. Les deux anciennes références Tweener/ISoundManager restent conservées avec leur portée initiale.
Non exécutés : extraction de nouveaux médias, décodage de codecs, lecture audio/vidéo, changement de volume ou périphérique, exécution Flash/AIR/AS/jeu, installation, migration ou modification de l’application. Les sources de format primaires sont conservées par empreinte : [DefineSound](https://github.com/jindrapetrik/jpexs-decompiler/blob/dev/libsrc/ffdec_lib/src/com/jpexs/decompiler/flash/tags/DefineSoundTag.java), [SoundStreamHead2](https://github.com/jindrapetrik/jpexs-decompiler/blob/dev/libsrc/ffdec_lib/src/com/jpexs/decompiler/flash/tags/SoundStreamHead2Tag.java), [StartSound](https://github.com/jindrapetrik/jpexs-decompiler/blob/dev/libsrc/ffdec_lib/src/com/jpexs/decompiler/flash/tags/StartSoundTag.java), [DefineVideoStream](https://github.com/jindrapetrik/jpexs-decompiler/blob/dev/libsrc/ffdec_lib/src/com/jpexs/decompiler/flash/tags/DefineVideoStreamTag.java). Commit upstream non établi ; code de ces références non exécuté.

## Reprise précise
1. Récupérer d’abord les trois XML par leur chemin, révision, taille et MD5 exacts ; les parser comme données, puis confronter leurs clés et paramètres au fournisseur réel. Ne pas rejouer une recherche globale ou choisir automatiquement la dernière version fusionnée.
2. Réutiliser ensuite le recensement des médias et les rôles établis par les XML pour qualifier les payloads encore manquants. Conserver séparées versions, langues, sources physiques et candidates non déclarées.
3. Pour chaque son ou transition repris, utiliser source/ID/tag/SHA et contexte. Vérifier codec, horloge, boucles, enveloppes, fades et préférences dans un travail autorisé distinct ; ne pas inventer des blocs audio ou frames manquants.

## Sept rubriques et livraison
Exigence canonique, sources et limites, consommateurs réels, contrôles attendus/observés, manques, travaux existants réutilisés et relecture de cohérence sont documentés dans la preuve principale. La clôture porte sur ce lot ; le parent conserve ses deux entrées d’audit bloquantes.
Ajouts uniquement : F:\OpenLeague-work\audit-units\AUD-18.1-05-AIR-AUDIO-TRANSITION-IDENTITY-01 et ce rapport. Le goal, ses critères normatifs, les registres, le produit, le suivi et les bases restent inchangés.
Prochain lot : AUD-18.1-05-AUDIO-DEFINITIONS-SOURCE-RECOVERY-01 — trois XML de définition audio exacts.
