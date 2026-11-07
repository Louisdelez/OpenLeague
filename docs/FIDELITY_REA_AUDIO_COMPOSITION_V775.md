# SYS-01.2-02 — Banques et médias après initialisation native, V775

Projet : F:/OpenLeague. Référence : LoL PUBLIC 4.20.0.315, EUW/en_GB. Fiches enrichies : SYS-01.2-02 et SYS-02.2-07 ; leurs objectifs complets restent ouverts. Compte rendu du 30 octobre 2026, heure locale Europe/Zurich ; reçus horodatés en UTC.

## Résultat attendu et observé

V774 vérifiait le parent d’initialisation sans rejouer les médias. V775 compose la publication de la mémoire et du gestionnaire de flux, les paramètres natifs, AEA510, l’enregistrement des plugins, les six banques et leurs doublons, puis les 31 préfixes audio.

La sortie est créée par AEA510 avant les banques. La mémoire prête et le gestionnaire de flux proviennent des instructions natives ADA380/ADA540 et B376D0. Les paramètres AEA3B0/B0FAB0 remplacent les scalaires nuls du banc antérieur. Le mode0 rencontre deux refus COM E_NOINTERFACE fournis explicitement et suit le repli natif3. Les pools portent les identifiants fournis23/19/17/21 ; leurs demandes/publications sont natives, leurs allocateurs restent des adaptateurs.

| Contrôle | Attendu et observé |
| --- | --- |
| Parent AEA510 | Retour1, dix composants publiés, drapeau initialisé |
| Banques originales | 6, présentées deux fois ; 12 admissions et traitements command0 |
| Mixage actif | 784 sorties ; toutes identiques bit à bit à V773 |
| Décodage | 713 buffers ; tous identiques par média, offset et taille |
| Comparaison aux WAV | 31 fichiers,730112 échantillons PCM16, écart maximal1 |
| Début du signal et durée des préfixes | Aucun écart avec V773 |
| Ordonnanceur | 846 suspensions coopératives,31 quotas nuls,815 frames traitées |
| Arrêt des workers | Corps natifs AF8C80 et B20D10 terminés ; handles remis à0 |
| Contrôles de limites du parcours | 6 cas : parent, objet, nœud, masque existant, position absente, allocation de position |
| Intégrité | 5233 blocs exécutés comparés aux octets du PE |
| Falsifications | 12 refusées |

Le retour interne69 lors d’une banque répétée reste normalisé à1 par son consommateur, comme dans les preuves antérieures. Le contrôle ne présente pas le doublon comme un nouveau chargement HIRC.

## Comparaisons et durée de vie

La comparaison des sorties est mesurée, sans assertion préalable imposant leur égalité. Les buffers décodés sont rapprochés par média, offset source et nombre de frames. Aucun buffer ajouté, disparu ou modifié dans ces préfixes. Les échantillons conservés sont vérifiés par SHA256 et comparés aux WAV locaux identifiés par le manifeste.

La chaîne réalise3855 allocations et2196 libérations :1659 allocations restent vivantes après la fermeture des workers. L’ancien parcours en laissait1657. Le stockage de démarrage mémoire et l’objet du gestionnaire de flux expliquent les deux allocations supplémentaires ; ce constat ne vaut pas fermeture globale. La mémoire des banques, des sorties et des gestionnaires reste présente. La comparaison agrégée par taille et pool montre aussi 21 allocations auparavant comptées sous UINT_MAX, réparties maintenant entre les pools17 et21. Ce regroupement ne constitue pas une identité objet par objet. Le reçu revision775_allocation_comparison.json conserve les deux histogrammes et leur différence.

AFC7F0 effectue stop, signal, attente et fermeture du worker de banques et de son événement. Le propriétaire natif ferme ensuite le worker de mixage. Les API sont des adaptateurs coopératifs ; aucun thread Windows ni périphérique réel n’est qualifié. L’événement du mixage et les autres objets globaux attendent leur destruction globale.

## REA et prochaines dépendances

REA6.4.0, SDK2.3.1, Ghidra12.1.4 et Java21 : 8 fonctions, 114 instructions et 10 références, recoupées avec le PE. La session est exportée et fermée sans erreur ; original inchangé.

B0C830/B0C880 corroborent le pool inférieur : dernier argument16, repli16MiB pour taille inférieure ou égale à64 et alias conservé après destruction. Les profils dédiés de refus restent les preuves héritées V774, sans nouveau décompte de23 profils dans V775.

B37FC0 lit14A8364 et B38150 y écrit son argument. B37B70 transmet les paramètres à B37A40 avec le gestionnaire de flux comme receveur. ADB130 écrit le float1.0 ; ADB260 appelle ADB1D0 après une allocation et inscrit trois callbacks en cas de succès. Ces fonctions de flux et ADB sont analysées statiquement ici ; l’étape ADB complète n’est pas exécutée dans le parcours média. 7062A0 inscrit les plugins après le moteur, mais le caller704E60 entier et ses étapes intermédiaires restent à composer.

## Consommateurs actuels et limites

Quatre ancres existantes de audio_bank_command_worker.rs et audio_bank_command_queue.rs sont relues et réutilisées. Les42 liens sources antérieurs restent vérifiés : binaire et six banques,31 WAV, manifeste et trois fichiers Rust. Seuls les sept fichiers natifs forment les nouvelles relations native_inputs. Les entrées précédentes sont conservées.

Le premier audit supposait à tort que la liste entière de42 liens était native. Il a refusé l’intégration. La correction sélectionne les sept sources par leurs chemins exacts et conserve le reçu d’échec ; aucune mesure audio ni ressource originale modifiée. Une seconde tentative a détecté un sérialiseur hérité renvoyant du texte au lieu des octets UTF8 requis pour le hash canonique ; correction explicite et échec conservé avant publication.

Les positions nulles et identifiants d’objets sont des entrées de test déclarées. Le CPU, le TLS, les allocateurs, les verrous, les horloges, COM et les transports des workers restent fournis par le banc. L’avancement de21ms utilise la période du périphérique de repli ; l’attente native du worker vaut10ms. Ni une durée réelle ni une concurrence Windows n’en est déduite.

Les31 médias sont des préfixes résidents jusqu’au premier signal plus une frame, avec borne80. Les clips complets, autres médias/locales, streaming, seek, boucles, événements applicatifs et audio physique restent ouverts. Aucun nouveau test Rust, compilation Rust, client ordinaire, code produit ou asset modifié dans ce lot.

## Fichiers et preuves

Binaire : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe.
SHA256 : 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

Dossier des preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20.

- revision775_rea_stream_prerequisites/observations/d5ed4e98-c5dd-4d0d-a5c2-0055a511c13c/receipt.json.
- revision775_bootstrap_media/OBSERVATIONS.json et199 fichiers d’échantillons dédupliqués.
- revision775_media_validation/OBSERVATIONS.json : intégrité, durées de vie, WAV et comparaison V773.
- revision775_media_associations/FAILED.json : premier audit conservé.
- revision775_media_associations_final/OBSERVATIONS.json : liens, sources et falsifications.
- revision775_delivery/VERIFIED.json, INDEPENDENT_READBACK.json et FINAL_VERIFIED.json : intégration et relecture.

Le rapport et le reçu docs/fidelity_rea_audio_composition_v775.json sont reliés aux registres des sources, exigences et tâches, à la couverture/reprise et aux deux fiches des bases du projet et du bureau. Cases, notes, historique, autres tâches et inconnues restent conservés. Les deltas ciblés permettent de vérifier exactement les valeurs antérieures sans copier les bases entières.

## Suite

Continuer SYS-01.2-02 sur F avec REA. V775 compose les six banques et 31 préfixes après ADA380/ADA540, B376D0 et AEA510 ; les sorties V773 sont reproduites sous les nouveaux paramètres. Prochaine dépendance concrète : wrapper IO704590/704700, B37A40 derrière B37B70, puis ADB130/ADB260 et ADB1D0 entre AEA510 et les plugins7062A0. Qualifier ces étapes et le caller704E60 avec la configuration706A20 effective, puis le teardown global. Retrouver ou relier le consommateur Rust ordinaire ; les quatre ancres actuelles portent le worker/la file en aval. Garder ouverts les allocateurs physiques, TLS distinct, threads et périphérique réels, événements applicatifs, autres médias/locales, clips complets, streaming/seek/boucles et commandes1..11. Préserver preuves, cases, notes et historiques ; deltas ciblés sur F.
