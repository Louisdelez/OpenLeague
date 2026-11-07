# SYS-01.2-02 — Banques de médias natives et consommateurs, V758

Projet F:/OpenLeague. Association source/consommateur de SYS-01.2-02 et SYS-02.2-07, référence PUBLIC4.20.0.315. Aucun code produit ni asset modifié. Le jeu et l’objectif global restent incomplets.

## Sources retrouvées

Les onze noms STID observés en V757 ont chacun un fichier dans DATA/Sounds du client original. Six sont les banques d’événements déjà étudiées ; cinq contiennent DIDX/DATA. Un nom résolu ne prouve pas toutes les dépendances d’exécution ou le montage historique.

| Banque audio | Entrées DIDX |
|---|---:|
| Announcer_Global_Female1_VO_audio | 4 |
| NPC_Global_SFX_audio | 249 |
| NPC_Map10_SFX_audio | 58 |
| ENV_Map10_SFX_audio | 44 |
| ENV_Global_SFX_audio | 62 |
| Total | 417 |

Les voix trouvées sont sous VO/en_US/Shared. Cela ne qualifie pas une couverture en_GB. NAME_RESOLUTION.json conserve les chemins, tailles, SHA256, offsets et empreintes des médias ; originaux sous D, nouvelles preuves sur F.

## Exécution native

Le banc charge Init puis les cinq fichiers audio entiers par AF9D40/AF9960, commande0, mémoire1, callback0. Les sections BKHD→DIDX→DATA sont lues dans leur ordre réel. AF9F50 conserve la table DIDX dans le buffer d’entrée ; AF9E10 produit les nœuds et listes de propriétaires. Les buffers originaux restent vivants pendant leur utilisation ; aucune copie DATA ou entrée disque n’est simulée.

Les 417 nœuds sont réellement alloués avec 36 octets, dont une copie de l’identifiant à +32. Les listes contiennent le holder, le pointeur vers le membre DATA et sa taille. AF94A0/AF93E0 retrouvent chaque média : pointeur, taille et SHA256 sont comparés aux octets du fichier. Les références de nœud et de holder passent1→2 puis reviennent2→1 par AFC0D0 et AFBFD0. Les descripteurs proviennent du lecteur original, contrairement aux contextes précédemment fournis au banc.

Les six relectures (Init compris) retournent69 dans le lecteur puis1 dans le caller, sans recharger de corps. Les cinq banques sont détachées, nettoyées et détruites ; chaque fois les allocations reviennent exactement au niveau Init et la table média est vide. Dix cas vérifient une clé absente et un propriétaire marqué différé : sortie vide, propriétaire de sortie préservé, aucun emprunt conservé.

1216 allocations,917 libérations,417 incréments et429 décréments atomiques,3290 paires de verrous ;299 allocations Init/managers restent vivantes. Le teardown global n’est pas qualifié. Allocateurs,pools,verrous,TLS et opérations atomiques sont des transports déclarés ;les corps de chargement,recherche et destruction exécutent les octets originaux.

## Limites et refus natifs

| Copie contrôlée | Statut observé | Médias enregistrés |
|---|---:|---:|
| Version87 | 64 | 0 |
| DIDX tronqué | 1 | 0 |
| DATA tronqué d’un octet | 1 | 4 |
| Taille DIDX non multiple de12 | 7 | 0 |
| Allocation du holder refusée | 52 | 0 |
| Allocation du premier nœud refusée | 52 | 0 |
| Allocation du premier propriétaire refusée | 52 | 0 |
| Allocation du second nœud refusée | 1 | 1 sur4 |

Les statuts1 des cas tronqués ou partiels ne prouvent pas l’intégrité. Ces contrôles inspectent les métadonnées et leur nettoyage, sans déréférencer les pointeurs de médias malformés. Les sources originales ne sont pas tronquées. Le premier essai conservait seulement32octets par nœud dans ses captures ;le banc final capture les36octets et leur allocation réelle.

## Consommateurs Rust actuels

Une sonde privée compile34modules complets inchangés : Cargo generate-lockfile --offline, build --locked --offline, exécution code0. Aucun build du jeu complet ni lancement ordinaire n’est revendiqué.

- Les cinq banques sous deux contextes7C et deux politiques de section donnent20refus :10avant le contexte et10au lecteur DIDX absent.
- MediaRegistry::lookup et release exigent un nœud de32octets. Chacun refuse les417nœuds natifs complets avec InvalidAllocation. Ce résultat établit une limite actuelle, pas une corruption des banques.
- Une projection privée qui retire les4octets dupliqués à+32 permet417comparaisons exactes des champs observés,recherche,emprunt/libération ;dix contrôles absents/différés concordent aussi. Cette projection n’est ni un producteur courant ni une intégration du chargeur.
- destroy_empty_holder refuse les cinq holders possédant des médias. Son compteur passe1→0 avant le refus et le stockage reste présent ;ce chemin ne peut pas être annoncé nettoyé.
- Seize comparaisons de contrôles gardent l’arrêt Rust précoce distinct du résultat natif tardif. Les refus de chargement Rust nettoient leurs seules allocations produites.

Deux rôles précis ajoutés pour lookup/release ;les rôles du caller et du destructeur V757 sont réutilisés sans modifier leur qualification précédente. Les snapshots importés et leur projection sont explicitement distingués de tout producteur du jeu.

## REA et vérifications

REA6.4.0,SDK2.3.1,Ghidra12.1.4,JDK21.0.10.7 :dix fonctions,1219instructions,27références recoupées. AF9F50,AF9E10,AFAAE0,AFB110,AF93E0,AF94A0,AFC0D0,AFCF00,AFBFD0,AF9960. AFAAE0 et AFB110 sont analysées statiquement,non exécutées dans ce profil sans copie. Session exportée et fermée normalement,aucune erreur.

Les1180blocs réellement exécutés correspondent au PE original :15973880octets,SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Les sources natives et34modules courants sont vérifiés par empreinte. Six falsifications sont refusées :descripteur tronqué,hash média modifié,statut partiel réécrit,refus36promu,projection cachée et producteur courant indûment qualifié.

## Livraison et suite

Preuve docs/fidelity_rea_bank_media_v758.json ;dossier F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision758_delivery. Trois registres,documents de couverture/reprise et deux fiches dans deux bases sont enrichis. Deltas ciblés compressés,aucune copie complète de base. Cases,notes,historiques,autres tâches et inconnues conservés. VERIFIED,INDEPENDENT_READBACK et FINAL_VERIFIED attestent les contrôles de livraison lorsqu’ils sont présents et réussis.

Suite :propriétaires multiples et durée de vie différée,modes de copie DATA et allocateurs,puis branchement du descripteur réellement produit à la fabrique/source et au décodage. Garder ouverts provider disque,scope non nul,async,streaming,voix,boucles/seek,génération,mixage,locales et sortie physique. La disponibilité exacte de417médias ne démontre pas leur lecture audible ni le jeu complet.
