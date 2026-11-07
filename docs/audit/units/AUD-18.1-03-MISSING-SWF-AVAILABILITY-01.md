# SYS-18.1-03 — disponibilité des 91 SWF manquants

2026-11-01T18:34:11.438357+00:00

Le lot de localisation est terminé sous réserve de relecture. Le parent d’audit AIR reste ouvert : aucune source SWF supplémentaire n’est récupérée et aucun MD5 de payload n’est vérifié dans ce lot.

## Résultats établis
Les 91 chemins manquants ont chacun une entrée dans air_index.jsonl, au projet live/lol_air_client, avec la révision individuelle et la taille exigées par le manifeste natif 0.0.1.119. Une seule lecture bornée de cet index local (1 554 076 lignes, 330 250 250 octets) a été nécessaire. Les lignes, offsets, objets JSON et empreintes sont conservés.
Les 91 identifiants de descripteurs figurent dans la table d’archive locale déjà qualifiée ; les adresses de leurs données compressées sont établies, pour 193 930 octets sans les éventuels espaces entre plages. Les 91 noms exacts de cache ont été contrôlés : aucun descripteur brut n’y est présent. Les payloads natifs attendus totalisent 125 635 557 octets.
La vue air_119_merged.json fournit 90 candidats conformes en chemin/révision/taille. Son candidat assets/rankedTeams/matchHistory.swf est refusé : il pointe sur 0.0.0.170, 123 730 octets, alors que le manifeste exige 0.0.0.166, 123 736 octets, MD5 44abc5b81b6fb623df2cadec6d9e6a2e. La bonne entrée 0.0.0.166 a été trouvée dans l’index exact.

## Sens de la preuve et limites
Il s’agit de métadonnées locales et d’adresses d’archive, pas de fichiers historiques récupérés. Le timestamp time de l’index n’est pas une date de build ou de déploiement EUW. Langs=none ne prouve pas une disponibilité régionale ou une politique de chargement. Les révisions, plateformes et locales ne sont pas substituées.
Le checksum de la table et son véritable reçu d’exécution antérieur sont réutilisés par identité. Aucune nouvelle commande checksum, aucune requête HTTP, aucune décompression ni reconstruction de fichier et aucun test du jeu ne sont exécutés ici. L’accessibilité distante actuelle et l’authenticité des payloads restent à qualifier par la récupération bornée et les tailles/MD5 natifs.
Le consommateur de récupération source et la politique de lookup C++ déjà qualifiés sont réutilisés. Le défaut de sélection de la vue fusionnée est établi sur un cas précis ; le code existant reste conservé. La récupération future est alimentée par source_records et ses chemins exacts, pas par un choix automatique de dernière version.

## Attendu / observé

### EXACT-PER-FILE-REVISION
Attendu : Use native per-file release for every logical path.
Observé : 90merged candidates match;matchHistory .170 rejected and correct .166 entry found in retained AIR index.
Limite : Metadata and archive address only;no native MD5 or pixel qualification.

### CACHE-BOUNDARY
Attendu : Distinguish available archive metadata from an available reconstructed source.
Observé : Descriptor addresses looked up in qualifiedTOC;raw descriptor cache checked by exact91names;no payload assembled.
Limite : No HTTP probe or decompression performed;later retrieval must retain206/length/size and complete native MD5 checks.

## Manques et reprise

### AIR-SWF91-SOURCE-AVAILABILITY
Les91entrées exactes et leurs adresses de descripteurs sont identifiées. Aucun descripteur brut n’est en cache;aucun payload n’a été récupéré ou validé parMD5.125635557octets natifs sont attendus;population d’images de ces91SWF toujours non examinée.
Reprise : Réutiliser source_records et le plan de plages bornées de ce lot. Récupérer les91descripteurs par206exact/longueur contrôlée,décoder avec les masques natifs déjà qualifiés,contrôler les sommes de tailles et cartographier chunks/cache. Admettre ensuite chaque payload seulement par taille/MD5natifs. Utiliser matchHistory0.0.0.166,pas la vuefusionnée0.0.0.170. Aucune nouvelle recherche d’index à l’identique.

### AIR-NATIVE-IMAGE-EXPORT-PROVENANCE
1530tags bitmap connus dans51sources présentes;2963candidats exportés mêlent bitmaps,vecteurs et rendu de timelines.767candidats ont unIDbitmap unique dans le conteneur lié;cela ne prouve pas leurs pixels ni leur installation.
Reprise : Réutiliser qualified_retained_export_matrix et les offsets/SHA des tags. Comparer par format natif(6/20/21/35/36),puis distinguer exports bitmap,SVG et timelines;ne pas compter unID de forme ou une planche de contact comme bitmap manquant.

### AIR-MAP197-AND-CHROME-PIXELS
Les7images installées ont conteneur/ID/tag natifs;seulJPEG32 égale déjà le payload natif. Bitmap197 comprend alpha0..255:conversion avec alpha prémultiplié non effectuée. Les5imageschrome restent sans comparaison pixel native.
Reprise : Partir des7current_seven_image_native_bindings;qualifier la conversion alpha exacte de DefineBitsLossless/2 avant comparaison. False signifie non vérifié,pascorrompu. Aucune réextraction ou réencodage du JPEG32 n’est nécessaire.

### AIR-ATLAS-AND-NATIVE-RENDER
22planchettes de revue ne prouvent pas des atlas historiques. Zérotermeatlas/spritesheet dans9139AS n’exclut pas une autre représentation. Aucun rendu AIR,timeline,état public/serveur ou acceptation humaine observé.
Reprise : Réutiliser les définitions de composants/écrans et qualifier les références natives de dimensions,cropping,scale9 et placements avant comparaison de rendu. Rechercher seulement une nouvelle référence précise,pas le même mot-clé sans piste.

## Sept rubriques
- 1 : SYS-18.1-03 inchangée;lot limité aux91sources réellement manquantes.
- 2 : IndexAIRlocal etTOC épinglés;91chemins/releases/tailles,limiteprovider/payload conservée.
- 3 : Consommateur de sélection/récupération source inspecté;vuefusionnée incorrecte refusée pourmatchHistory.
- 4 : Rechercheexacte unique sur1554076lignes et lookupTOC pour91nouveauxIDs;aucunHTTP/décodage/jeu.
- 5 : Descripteurs etpayloads absents,conditions de reprise précises;parent ouvert.
- 6 : Tâche existante réutilisée;pas de correction générale nouvelle ni changement registre.
- 7 : Livrables bornés etidentifiés,lecteurdistinct etétat protégé vérifié.

## Livraison et suite
Ajouts uniquement : F:\OpenLeague-work\audit-units\AUD-18.1-03-MISSING-SWF-AVAILABILITY-01 et ce rapport. Inventaire des 91 entrées et adresses, scripts propres au lot, plan calculé de plages et reçus de producteur/lecteur. Aucun goal, critère, registre, code produit, Plan, interface ou base modifié. Aucune installation ni migration.
Prochain lot : AUD-18.1-03-ARCHIVE-DESCRIPTOR-RECOVERY-01. Plan borné : {'groups': 31, 'maximum_group_bytes': 121955, 'bounded_network_bytes': 319327, 'compressed_descriptor_bytes': 193930}. Ces nombres ne constituent pas des requêtes ou des récupérations déjà réussies.
