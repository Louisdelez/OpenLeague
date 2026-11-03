# SYS-01.2-02 — Transport des contrôles audio, V748

Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315 EUW/en_GB, catalogue 4.20.1 distinct. La précédente livraison V747 a modifié le registre et les deux bases puis passé la relecture indépendante. Ce lot poursuit la liaison source → exigence → consommateur, sans déclarer le jeu complet.

## Résultat

Les deux chemins précédemment envisagés sont distincts. B17A60 copie les contrôles 240/244 du premier élément de sa liste de sorties vers deux états de filtre du parent. B15030 lit un contrôle auxiliaire depuis voice+18C, puis +0C. Aucun lien direct 240/244 → B15030 n’est établi ; la prochaine action V747 est précisée, ses preuves restent conservées.

## Analyse REA du PE complet

REA 6.4.0 et Ghidra 12.1.4 ont analysé B17A60, B0ED50 et B15030 : trois fonctions, 699 instructions et trois références directes recoupées avec les octets du PE. Session fermée normalement ; aucune exécution du jeu par REA.

B0E066 appelle B17A60 ; B0E088 appelle B0ED50 ; B0EF10 appelle B15030. B0ED50 appelle B28810 sur les wrappers parent+1F0 puis parent+2E0. La correspondance avec les états cibles est une piste statique pour la prochaine qualification ; B28810 et le caller commun n’ont pas été exécutés ici.

Client : 15 973 880 octets, SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Init.bnk : 6 890 octets, SHA256 41d3befb0b934fc609c7b9d5305a8d361cbc77c35e713d37b66e1ac87de3f004. Les champs ENVS sont recoupés avec la banque originale.

## Exécution du parent original

B17A60 entier appelle B171F0 puis B18530 après chargement original STMG/ENVS, en mémoire Unicorn isolée. Sept profils, quatre dispositions d’auditeurs et six couples de contrôles produisent 168 cas. Chaque cas est répété avec cibles identiques et dirty nettoyé : 336 appels du parent et 672 écritures de cible vérifiées, 2 838 adresses natives identifiées.

- parent+2C4 reçoit clamp(head+240, 0, 100).
- parent+3B4 reçoit clamp(max(head+244, voice+A0), 0, 100).
- Le premier élément est utilisé, y compris avec plusieurs auditeurs ; ce n’est pas un maximum sur la liste entière.
- Les octets dirty sont mis à jour si la cible change ; une répétition identique ne les réactive pas. Les états immediate restent conservés.

Le contexte déclare voice+A0=30, un état de voix en cache, aucun bus racine ni auxiliaire, un pointeur de ressource non nul, parent flags=5, 128 frames et un compteur de frames restant à -1. gain+0C pointe sur la même voix que le caller. Le callback virtuel voice vtable+30 est une adaptation explicite retournant -1 ; sa sémantique historique n’est pas qualifiée. Allocateurs, verrous, TLS et transport mémoire restent les adaptations déclarées du banc.

Le booléen poussé sur la pile est porté par AL. Le DWORD observé vaut FFFFFF00 avec ce callback ; ses octets supérieurs ne doivent pas être interprétés comme un booléen 32 bits. Les deux premiers bancs, dont l’attente était erronée, restent conservés. La version finale vérifie les arguments réellement observés.

## Chemin auxiliaire séparé

B15030 entier passe 112 cas couvrant seuil 0,1 et valeur immédiatement supérieure, valeurs -10/0/30/100/120, buffer absent ou présent, filtre préalloué ou allocation refusée, cibles antérieures et dirty différents.

Seize cas atteignent l’entrée PCM B2B4F0 et seize l’allocateur B1ADE0. Ces deux corps sont adaptés : le premier enregistre l’entrée sans traiter de samples ; le second retourne un échec explicite. Le reste de B15030 est original. Seuil, clamp, préservation de dirty/immediate et des états primaires sont vérifiés. Cela ne qualifie ni l’allocateur réel, ni le PCM auxiliaire, ni une voix historique complète.

## Consommateurs Rust actuels

Le rôle existant de Controller::update_target est conservé et enrichi par 672 comparaisons avec les écritures primaires. Quatre fichiers core actuels sont compilés sans modification. Le banc fournit l’agrégation observée ; le produit ne gagne pas pour autant une orchestration B17A60.

La structure FilterControl et son impl sont extraites octet pour octet de pcm_audio.rs, avec plage et hash vérifiés, puis compilées avec std. Le module Bevy complet n’est pas compilé dans ce lot. Cinq profils contrôlent mise à jour, reset, clone partagé et voix séparée. Deux threads effectuent 1 000 set et 1 000 reset : cible finale 999 et epoch 1 000, sans perte de mise à jour observée. Dix-neuf refus sont vérifiés : valeurs non finies et épuisement du compteur. Ce sont des contrats locaux, pas une preuve de fidélité de la concurrence native.

L’analyse syn du fichier actuel situe snapshot dans le constructeur du décodeur et Decoder::next. Les appels set du contrôle trouvés dans ce fichier sont sous cfg(test) ; le reset ordinaire trouvé appartient au Controller DSP. La recherche ne remplace pas la résolution globale des noms/macros et ne prouve pas une absence générale de route dynamique.

Trois rôles sont ajoutés pour set, reset et snapshot ; le rôle existant du setter est réutilisé. Compilation hors ligne et exécution retournent 0. Une première préparation supposait des fins de ligne LF, et une première compilation omettait le type du visiteur syntaxique : leurs sources et diagnostics sont conservés, les versions finales passent.

## Publication, contrôles et limites

Six falsifications sont rejetées : cible primaire altérée, dirty réactivé sur cible identique, suppression du seuil auxiliaire, confusion des états primaires/auxiliaires, perte d’epoch et mauvaise plage d’extraction.

Deux fiches sont enrichies : SYS-01.2-02 et SYS-02.2-07. Trois registres, les documents coverage/completion_plan/resume_checkpoint et les notes de reprise sont actualisés. Les deux bases du plan reçoivent des deltas ciblés ; cases, notes, historiques, autres tâches, prérequis et inconnues restent conservés. Aucun code produit ni asset modifié.

Preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision748_rea_control_transport ; revision748_parent_transport_bytearg ; revision748_auxiliary_target_native ; revision748_rust_controls_final ; revision748_control_associations ; revision748_delivery. Les reçus VERIFIED.json et INDEPENDENT_READBACK.json distinguent publication et relecture.

Restent ouverts : B28810 et son caller commun, production du contrôle auxiliaire, orchestration Rust en jeu, autres branches bus/auxiliaires, commande 20 et état étendu, Meter, Init complet, médias, locale et sortie audible. Le goal reste actif.
