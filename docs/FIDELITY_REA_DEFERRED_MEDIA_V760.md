# SYS-01.2-02 — Déchargement différé des banques audio, V760

Projet F:/OpenLeague. Association source/consommateur de SYS-01.2-02 et SYS-02.2-07. Référence PUBLIC 4.20.0.315. Aucun code produit ni asset modifié ; objectif global et jeu incomplets.

## Sources et acquis préservés

PE original, Init.bnk et cinq banques DIDX/DATA, identifiés par chemin, taille et SHA256 dans la preuve JSON. Announcer_Global_Female1_VO_audio (4 médias), NPC_Global_SFX_audio (249), NPC_Map10_SFX_audio (58), ENV_Map10_SFX_audio (44), ENV_Global_SFX_audio (62), soit 417 médias. Les voix présentes sont en_US ; en_GB n’est pas validé par ce lot.

Le PE fait 15973880 octets, SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Les originaux sur D restent inchangés, preuves nouvelles sur F. V759 a établi la priorité du dernier propriétaire chargé et des copies DATA ; les tests précédents de déchargement/worker sur banques limitées aux effets restent distincts et conservés.

## Exécution native

Init est chargé par le lecteur original. Pour chaque banque, deux chargements complets créent réellement les nœuds de 36 octets et leurs deux propriétaires. Les profils croisent emprunt conservé ou absent et callback activé ou nul, soit 20 scénarios. Les banques sont traitées successivement ; pas cinq banques différentes simultanées.

AFCDE0 détache le propriétaire récent ; AF9900 exécute le déchargement des effets, produit le drapeau8, enregistre callback/cookie, puis publie une commande de type24 et une frame. Le paquet de commande fait12octets, la frame8octets. Les recherches suivantes sélectionnent l’ancien propriétaire. Un nouvel unload du même couple ID/buffer retourne54 sans modifier l’état.

B06C60 consomme réellement la commande et la frame, avec scans de voix vides, puis AFBFD0 gère la référence :

| Cas | Résultat observé |
|---|---|
| Aucun emprunt, callback nul | Destruction du propriétaire, sans callback |
| Aucun emprunt, callback actif | Destruction et callback pendant la consommation |
| Emprunt conservé, callback nul | Propriétaire vivant jusqu’à la dernière libération |
| Emprunt conservé, callback actif | Callback retardé jusqu’à la dernière libération |

Les 6672 recherches vérifient les pointeurs, tailles, empreintes, références et sélection avant/après chaque étape. Dix callbacks sont observés, dont cinq après la dernière référence. Le callback reçoit ID, buffer, statut1, pool et cookie100 exacts. La dernière libération d’emprunt est déclenchée explicitement par le banc via AFC0D0/AFBFD0 quiet0 ; ce n’est pas une voix complète.

5413 allocations et5114libérations,37956paires de verrous,6682incréments et6722décréments atomiques. Chaque scénario retrouve exactement les299allocations Init/managers. Le teardown global reste ouvert.

## Contexte et limites du banc

Le contexte de file et ses deux pages de2048octets sont fournis ; la file, le marquage différé, le consumer et les notifications exécutent les corps originaux. Les tables de voix sont déclarées vides. Les adaptateurs couvrent allocation, mutex, événements, callback externe, atomiques, TLS, CloseHandle et DeleteCriticalSection. Ils ne prouvent pas la concurrence Windows ou le démarrage complet des gestionnaires.

Le premier banc a terminé le chemin de banque puis rencontré CloseHandle non adapté dans le nettoyage des notifications. Le script et FAILED.json restent conservés. Le banc corrigé identifie les imports CloseHandle/DeleteCriticalSection et fournit uniquement ces opérations physiques ; il ne remplace aucune commande ou destruction logique par un succès artificiel.

## Consommateurs Rust

38 modules complets inchangés compilés avec Cargo offline/locked ; compilation et exécution code0. Le banc importe les snapshots natifs et fournit les pages de file. Aucun chargeur courant complet, lancement du jeu ou producteur de descripteurs n’est revendiqué.

- 20 unload_request concordent : détachement, drapeau différé, champs callback/cookie, commande24 et frame. Les nœuds de36octets restent complets.
- 20 répétitions retournent54 et conservent l’état attendu.
- 10 consommations avec emprunt concordent avec l’état natif, sans consulter ni réduire les nœuds36.
- 10 consommations terminales refusent le stockage média après décrément du holder à zéro. Le holder et les médias restent présents ; le consumer n’avance pas son offset ni son compteur de traitement. Aucun callback courant n’est validé dans ces cas.
- Sur les10dernières libérations d’emprunt, MediaRegistry::release refuse les nœuds36. Une projection diagnostique séparée à32octets permet le décrément du nœud mais le destructeur de banque refuse encore. Aucune de ces projections n’est une intégration produit.

Les huit octets de padding sans signification de commande sont explicitement masqués pour comparer les pages : offsets[4,8) et[16,20). En-têtes, pointeur du holder et tous les autres octets restent comparés. Une falsification du pointeur ne peut pas être masquée comme padding.

Un rôle précis unload_request est ajouté. Six rôles existants sont réutilisés : consumer de banque, dispatch de file, enqueue avec attente, publication de frame, destruction de holder et libération média. Leurs anciennes qualifications restent conservées.

## REA et audit

REA6.4.0,SDK2.3.1,Ghidra12.1.4,JDK21.0.10.7 :12fonctions AFCDE0,AF9900,B05ED0,B06370,B08440,B06C60,AF4290,B0F7A0,AFCEC0,AFC410,B054D0,B05550. Session exportée et fermée. Les instructions/références exactes et1282blocs natifs exécutés sont recoupés avec le PE ; leurs nombres sont dans audit.statistics.

Six falsifications sont refusées : propriétaire différé sélectionné, opcode changé, callback prématuré, refus terminal promu, pointeur masqué comme padding et snapshot annoncé comme chargeur intégré. Scripts, modules, binaire Rust, commandes et journaux sont identifiés dans docs/fidelity_rea_deferred_media_v760.json.

## Livraison et suite

Trois registres, couverture/reprise et deux fiches dans les bases projet/bureau sont enrichis. Cases, notes, historiques, inconnues et autres tâches conservés. Deltas ciblés compressés ; aucune copie entière des bases. Les reçus VERIFIED, INDEPENDENT_READBACK et FINAL_VERIFIED dans revision760_delivery attestent la publication lorsqu’ils sont présents et réussis. La relecture de publication utilise le validateur natif partagé et contrôle séparément les identités, inversions des registres et tables des deux bases ; elle n’est pas un second moteur d’émulation.

Suite : fabrique/source/décodeurs alimentés par les descripteurs réellement produits, puis durée de vie avec voix non vides. Worker complet sous banques média, concurrence, démarrage copié via provider, streaming, boucles/seek, génération, mixage, autres médias/locales et sortie audible restent ouverts.
