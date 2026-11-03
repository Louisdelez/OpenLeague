# SYS-01.2-02 — Worker des banques et paramètres de démarrage, V773

Projet : F:/OpenLeague. Référence : LoL PUBLIC 4.20.0.315, EUW/en_GB. Fiches enrichies : SYS-01.2-02 et SYS-02.2-07. Leurs objectifs complets restent ouverts.

## Résultat attendu et observé

Le chargement appelait directement AF9D40 dans le banc précédent. Il passe maintenant par l’admission AFBAE0, la file AF8AE0 et le corps réel AF8C80. Le worker copie neuf mots, retire le nœud sous verrou puis appelle AF9D40 hors verrou. Les instructions originales s’exécutent en mémoire x86 isolée ; les appels Windows physiques sont des adaptateurs coopératifs.

Six banques originales, dont Init, sont chargées puis présentées une seconde fois : douze admissions et douze appels du gestionnaire réussis. La seconde présentation conserve le refus interne69 déjà documenté et le retour normalisé1, sans nouvelle lecture des objets HIRC. Les nœuds de la file sont réutilisés. Le worker publie son identifiant fourni0x772 et attend son événement0x4402 sans délai maximal.

Le premier essai exécutait le corps puis fournissait son drapeau d’arrêt. Il est conservé. Le parcours final exécute AFC7F0 : écriture du drapeau, signal, attente du worker, fermeture du handle0x4472 et de l’événement0x4402, remise à zéro des deux références. AF8C80 retourne0. Le worker de mixage est ensuite fermé par son propriétaire natif, comme auparavant. Aucun thread Windows physique n’est lancé par ces adaptateurs.

| Contrôle | Attendu et observé |
| --- | --- |
| Médias résidents | 31 préfixes, chacun produit un signal |
| Sorties actives | 784, identiques bit à bit à V772 |
| Décodage | 713 buffers identiques à V772 ; 730112 échantillons PCM16 |
| Comparaison aux WAV | 31 fichiers ; écart maximal de1 unité PCM16 |
| Ordonnancement du mixage | 846 suspensions coopératives, 31 quotas nuls et 815 frames traitées |
| Corps natifs du parcours | 5068 blocs comparés aux octets du PE |
| Mémoire restante | 1657 allocations ; aucune fermeture globale annoncée |

Ces préfixes ne représentent pas l’intégralité des clips ni du contenu audio du jeu. Les six banques sont identifiées par chemin, taille et SHA256 dans le reçu structuré.

## Quinze profils de file et d’arrêt

Les profils passent62 admissions :60 réussissent et2 refusent. Le refus de capacité et le refus d’allocation supplémentaire conservent les dix requêtes déjà admises. Trois nœuds supplémentaires sont alloués puis libérés dans les profils de dépassement des dix nœuds de réserve. Une liste libre disponible est utilisée même lorsque la capacité déclarée est0.

Les valeurs de retour d’attente0,128,258 et UINT_MAX sont fournies explicitement. Le corps natif poursuit selon le drapeau d’arrêt et ne teste pas ces valeurs. Les résultats faux de SetEvent et CloseHandle ne sont pas propagés. Une remise à zéro native après CloseHandle faux ne démontre donc pas qu’un objet Windows réel a été fermé.

Les sélecteurs synthétiques12 et UINT_MAX suivent la branche native sans traitement. Ce contrôle ne qualifie pas les autres commandes1..11. L’arrêt avec une commande encore en file termine le worker en conservant cette commande ; il ne constitue pas une vidange. Un second arrêt n’appelle aucune API. Les charges command0 sont, elles, les vraies banques du parcours principal.

## Vingt-six profils de paramètres et prérequis

AEA3B0 produit les56 octets de configuration avec ses valeurs natives. Les trois octets de padding29..31 restent inchangés, contrôlés avec plusieurs remplissages. B0FAB0 produit64 octets de paramètres de plateforme avec un handle de fenêtre explicitement fourni. B0C7E0 copie ces64 octets et normalise le mot à l’offset0x30 :0/1 deviennent4, les valeurs2/3/4/65535 restent telles quelles. Aucun nom de champ métier supplémentaire n’est déduit de cet offset.

AEA200 crée le pool seulement lorsque son identifiant vaut UINT_MAX. Pour une taille demandée inférieure ou égale à64, il utilise16MiB ;65 est conservé. Les résultats de création17 et UINT_MAX produisent respectivement1 et52. Un pool existant0 ou17 est conservé. AEA270 remet le global principal à UINT_MAX après la destruction fournie ; l’alias1210238 conserve sa valeur antérieure.

AEA510 retourne76 si la capacité CPU requise manque,74 si la mémoire n’est pas prête et75 si le gestionnaire de flux manque. Ces états d’entrée sont fournis explicitement. Dans la branche déjà initialisée, il copie les paramètres puis retourne2 sans construire les composants. Cela ne prouve pas un démarrage complet ni la validité de l’état déjà initialisé. Le producteur CPU réel, la mémoire, le gestionnaire de flux et le pool physique restent à composer au parent complet.

## Consommateurs actuels

Quatre ancres exactes sont reliées dans les sources existantes :

- audio_bank_command_worker::Worker::run : entrée command0 et lecteur concret des banques.
- audio_bank_command_worker::Worker::run_dispatch : attente, drapeau d’arrêt, retrait sous verrou et traitement hors verrou.
- audio_bank_command_queue::Queue::admit : inscription, admission et signal.
- audio_bank_command_queue::Queue::pop : copie des neuf mots, retour des nœuds de réserve ou libération des nœuds dynamiques.

Le code existant est conservé. La recherche bornée dans crates et la lecture de audio_bank_memory_reader.rs trouvent des usages dans le module de tests commençant à la ligne200 ; aucune absence globale de consommateur n’est déduite de cette recherche. Aucun nouveau test Rust, compilation Rust ou client ordinaire n’a été exécuté dans ce lot. Les preuves antérieures restent distinctes.

## REA et intégrité

REA6.4.0, SDK2.3.1, Ghidra12.1.4 et Java21 :12 fonctions,831 instructions et25 références, recoupées avec le PE. Session exportée et fermée sans erreur ; original inchangé.

Binaire : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe.
SHA256 : 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

Seize falsifications sont refusées : requête copiée altérée, admission ou retour falsifié, traitement hors worker, handle restant, corps non exécuté, sortie modifiée, compte de file, refus masqué, commande prétendue vidée, fermeture supplémentaire, octets natifs, padding, garde et alias du pool. Aucun octet du PE n’est patché.

## Fichiers et preuves

Dossier de preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.

- revision773_rea_audio_startup/observations/aa60bf25-9dff-4a88-883c-a2ef16bad7d1/receipt.json : session REA.
- revision773_bank_worker_media/OBSERVATIONS.json : premier parcours avec drapeau d’arrêt fourni.
- revision773_bank_worker_closed/OBSERVATIONS.json : parcours final avec propriétaire natif d’arrêt.
- revision773_bank_worker_boundaries/OBSERVATIONS.json :15 profils de file et fermeture.
- revision773_startup_parameters/OBSERVATIONS.json :26 profils de paramètres et gardes.
- revision773_bank_validation/OBSERVATIONS.json et revision773_bank_associations/OBSERVATIONS.json : contrôles, comparaisons, liens Rust et falsifications.
- revision773_delivery/VERIFIED.json, INDEPENDENT_READBACK.json et FINAL_VERIFIED.json : intégration et relecture.

Le reçu docs/fidelity_rea_bank_worker_v773.json référence ces sources. Les trois registres sources/exigences/tâches, la couverture et la reprise sont enrichis, ainsi que les deux fiches dans les bases du projet et de l’application de bureau. Cases, notes, historiques, autres tâches, prérequis et inconnues sont conservés. Aucun asset ni code produit modifié.

## Suite

Continuer SYS-01.2-02 sur F avec REA. V773 qualifie le worker des banques et sa fermeture sur six banques originales, leurs doublons et 31 préfixes audio ; handles du worker et événement à zéro, mais 1657 allocations globales restent vivantes. Qualifier maintenant le parent AEA510 complet avec ses paramètres natifs AEA3B0/B0C7E0, puis les producteurs de mémoire prête, du stream manager et du pool. Ses gardes76/74/75 et sa branche déjà initialisée2 sont contrôlées, pas le démarrage complet. Conserver padding, alias du pool après destruction et commande en attente lors du stop ; résultats wait/signal/close ignorés ne prouvent pas le succès physique. Relier le worker Rust existant au démarrage ordinaire ; les appels observés sont dans les tests, sans preuve d’absence globale. Séparer commandes1..11, callbacks, TLS distinct, concurrence/temps Windows, audio physique, autres médias/locales, streaming/seek/boucles et teardown global. Préserver les acquis et les états manuels ; preuves et deltas ciblés sur F.
