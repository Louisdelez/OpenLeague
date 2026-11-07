# SYS-01.2-02 — Propriétaires et copies des médias, V759

Projet F:/OpenLeague. Association source/consommateur pour SYS-01.2-02 et SYS-02.2-07, référence PUBLIC 4.20.0.315. Aucun code produit ni asset modifié. L’objectif global et le jeu restent incomplets.

## Sources

Le PE original, Init.bnk et cinq banques DIDX/DATA sont identifiés par chemin, taille et SHA256 dans la preuve JSON. Les banques contiennent 417 médias : Announcer_Global_Female1_VO_audio (4), NPC_Global_SFX_audio (249), NPC_Map10_SFX_audio (58), ENV_Map10_SFX_audio (44) et ENV_Global_SFX_audio (62). Les voix sont en_US ; cette observation ne valide pas en_GB.

Le PE fait 15973880 octets, SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Originaux sur D, nouvelles preuves sur F.

## Propriétaires natifs

Init est chargé par le lecteur original. Chaque banque est ensuite chargée deux fois, aux adresses 0x70000000 et 0x71000000. Les cinq banques sont traitées successivement. Les nœuds de 36 octets et les deux propriétaires sont produits par le code natif. AF9810 insère le dernier chargé à l’index 0. Le premier essai attendait à tort le plus ancien ; revision759_ownership_explore/FAILED.json conserve cet échec.

| Profil | Résultat observé |
|---|---|
| Deux propriétaires actifs | Le plus récent est choisi |
| Plus récent marqué différé | L’ancien est choisi |
| Les deux marqués différés | Sortie vide, sentinelle conservée |
| Plus récent détruit | L’ancien est choisi |

Les 20 profils couvrent 1668 recherches : pointeur, taille et empreinte comparés au fichier. Les drapeaux différés sont des mutations déclarées du banc ; leur producteur asynchrone reste à qualifier.

Dix emprunts conservés et 30 opérations vérifient la durée de vie. Un holder détaché reste vivant tant qu’un média l’emprunte ; sans drapeau différé, il reste sélectionnable. La dernière libération le détruit et retire ses entrées média. Le déchargement de l’ancien rétablit le niveau Init et une table média vide. 1620 allocations, 1321 libérations, 8733 paires de verrous, 1261 incréments et 1271 décréments atomiques. Les 299 allocations Init/managers restantes ne sont pas un teardown global.

## Copies de DATA

AF8A20 construit un contexte explicitement copié : compteur +64 nul, compteur +68 égal à 1. Le lecteur original lit BKHD, DIDX et l’en-tête DATA, puis AFAAE0 copie 417 médias par ADA610, pool 0 et alignement 16. Le script exécuté compare chaque buffer aux octets d’origine ; le reçu contient les empreintes des membres mais pas un dump séparé des copies. DIDX reste emprunté au fichier d’entrée.

Chaque nœud pointe directement vers sa copie, sans liste de propriétaires. AF94A0 incrémente le nœud sans retenir un holder et conserve la sentinelle de propriétaire. AFC0D0 rend la référence ; AFC170/AFCC00 libèrent buffers, nœuds et holder. Le niveau Init est retrouvé. 1217 allocations, 918 libérations, 3215 paires de verrous et 10 décréments atomiques ; 299 allocations de contexte restent vivantes.

| Contrôle | Statut natif |
|---|---:|
| DATA tronqué | 2 |
| Première allocation de copie refusée | 52 |
| Deuxième allocation de copie refusée | 52 |
| Longueur DATA nulle | 1, aucune copie |
| Premier offset hors DATA | 2 |

Chaque contrôle retrouve le niveau Init après nettoyage. Longueur nulle avec statut 1 ne signifie pas banque complète. Ce profil qualifie les corps natifs sous contexte déclaré, pas le démarrage complet AF9960 en mode copié avec son provider. Allocateur borné, pools, verrous, TLS et atomiques sont des transports fournis. Pas de worker concurrent ou périphérique audio exécuté.

## Rust actuel

Une sonde privée compile 34 modules inchangés avec Cargo offline/locked ; compilation et exécution terminent avec code 0. Aucun build ou lancement du jeu entier.

- 1668 recherches multi-propriétaires et 417 recherches directes refusent les nœuds natifs de 36 octets avec InvalidAllocation.
- Une projection diagnostique privée retire l’ID dupliqué à +32. Les 2085 recherches concordent alors avec les champs observés, et leurs références sont rétablies.
- Vingt opérations de durée de vie concordent. Dix destructions de banque restent refusées après décrément du holder à zéro ; le stockage est conservé.
- 417 libérations terminales de médias projetés produisent 834 libérations de nœuds/buffers dans l’ordre natif, avec taille de nœud normalisée 36→32. Le holder demeure conservé : ce n’est pas une destruction complète de banque.

Un rôle précis de unlink_holder est ajouté ; lookup, release et destroy_empty_holder sont réutilisés sans promotion. Producteur de descripteurs, chargeur de copies et parcours asynchrone actuels ne sont pas déclarés terminés.

## REA et contrôles

REA 6.4.0, SDK 2.3.1, Ghidra 12.1.4, JDK 21.0.10.7 : 12 fonctions, 943 instructions, 30 références. AFC6F0, AF9810, AFC600, AF91C0, AF93E0, AFCF00, AFBFD0, AFAAE0, AFCC00, AFC170, AFCDE0, AF9900. Les deux dernières restent statiques. Session exportée et fermée normalement.

1157 blocs de propriété et 1171 blocs de copie correspondent aux octets du PE. Six falsifications sont refusées : ordre inversé, destruction prématurée, taille de copie modifiée, succès inventé sur troncature, refus36 promu et chargeur actuel indûment déclaré intégré. Scripts, modules, entrées, binaire Rust et journaux sont identifiés dans docs/fidelity_rea_media_ownership_v759.json.

## Livraison et suite

Trois registres, couverture/reprise et deux fiches dans les bases projet/bureau sont enrichis. Cases, notes, historiques, autres tâches et inconnues conservés. Deltas ciblés compressés, sans copie entière des bases. VERIFIED, INDEPENDENT_READBACK et FINAL_VERIFIED dans revision759_delivery attestent les contrôles lorsqu’ils sont présents et réussis.

Suite : caller asynchrone, commande 24 et drapeau différé, puis fabrique/source/décodeur alimentés par les vrais descripteurs. Démarrage complet du mode copié, provider disque, voix, streaming, boucles/seek, génération, mixage, autres médias/locales et sortie audible restent à qualifier.
