# SYS-18.1-03 — récupération des 91 descripteurs

2026-11-01T18:44:36.945411+00:00

Le lot des descripteurs est terminé sous réserve de relecture. Le parent d’audit AIR demeure ouvert : aucun nouveau SWF complet n’est assemblé ni accepté par MD5 natif, et aucune image n’est intégrée au launcher.

## Résultat concret
Les 31 plages prévues ont été réellement reçues par HTTP 206, avec extent, longueur et encodage contrôlés : 319 327 octets. Aucune tentative supplémentaire ni erreur. Les réponses, en-têtes, dates et octets restent conservés dans le nouveau répertoire source sur F.
Les 91 descripteurs sont décompressés par le ZSTD déjà présent, pour 193 072 octets. Les 12 067 records de 16 octets produisent exactement les tailles natives des 91 fichiers : 125 635 557 octets. Le masque low28 pour la taille et low4 pour le type de hash est réutilisé ; les bits opaques non nuls de 6 982 records restent conservés. Ils ne sont pas traités comme une corruption.
Les records utilisent le type de hash 3 ; les algorithmes d’identifiant de chunk ne sont pas réexécutés. Cette preuve de descripteurs et de sommes de tailles ne remplace pas les futurs MD5 des fichiers complets.

## Contenu et cache
Les 12 031 identifiants de blocs distincts sont adressés dans la table locale qualifiée. 36 candidats bruts sont déjà en cache, avec identités et tailles conservées ; 11 995 restent à récupérer. Le cache n’est pas modifié. La recherche de ces nouveaux identifiants ne rejoue pas celle des 91 descripteurs ni les index AIR.
La première cartographie conserve son groupement initial. Un plan opérationnel séparé choisit un groupement borné sous 128 Mio et 8 Mio par réponse ; il est calculé à partir des mêmes adresses, sans nouvel accès réseau. Les chiffres de ce plan ne sont pas des téléchargements déjà réussis. Plan retenu : {'maximum_gap': 63488, 'groups': 875, 'bounded_network_bytes': 134160473, 'maximum_group_bytes': 8387625}.

## Attendu / observé

### TRANSPORT
Attendu : Only selected bounded descriptor ranges,206extent/length andidentity encoding.
Observé : 31actual accepted responses,total319327bytes;91rawdescriptors193072bytes retained,zero errors.
Limite : No full archive/content retrieval or original game network.

### NATIVE-RECORDS
Attendu : Exact16byte records,low28size andlow4hash type;opaquehighbits retained.
Observé : 91nativefile size sums match;12067records,6982withnonzerohighbits preserved;all actualhashtype3.
Limite : Chunk-ID hash algorithms and completefileMD5 are not reexecuted here.

### CACHE-AND-NEXT
Attendu : Bound each missing content source and preserve existingcache.
Observé : 12031unique IDs found inTOC,36cached candidates,11995pending;separate bounded transportplan ready.
Limite : No payload SWF assembled or its pixels/render verified.

## Manques et reprise

### AIR-SWF91-SOURCE-AVAILABILITY
Les91descripteurs sont récupérés et qualifiés;12031blocs de contenu distincts sont identifiés,dont36candidats en cache.11995blocs restent à récupérer. Aucun des91SWF n’est encore assemblé/vérifié parMD5;125635557octets natifs attendus.
Reprise : Réutiliser descriptor-recovery.json,content_recovery_map et le plan de transport séparé. Récupérer uniquement les11995blocs manquants par plages206bornées,décoder selon la tailleTOC,puis assembler chaque fichier dans un nouveau répertoire source surF. Exiger la taille etleMD5 natifs avant admission;réutiliser les36candidatscache sans les modifier. Ensuite qualifier les tagsSWF des91nouveauxinputs. Ne pas relancer les index ni les31requêtes de descripteurs réussies.

### AIR-NATIVE-IMAGE-EXPORT-PROVENANCE
1530tags bitmap connus dans51sources présentes;2963candidats exportés mêlent bitmaps,vecteurs et rendu de timelines.767candidats ont unIDbitmap unique dans le conteneur lié;cela ne prouve pas leurs pixels ni leur installation.
Reprise : Réutiliser qualified_retained_export_matrix et les offsets/SHA des tags. Comparer par format natif(6/20/21/35/36),puis distinguer exports bitmap,SVG et timelines;ne pas compter unID de forme ou une planche de contact comme bitmap manquant.

### AIR-MAP197-AND-CHROME-PIXELS
Les7images installées ont conteneur/ID/tag natifs;seulJPEG32 égale déjà le payload natif. Bitmap197 comprend alpha0..255:conversion avec alpha prémultiplié non effectuée. Les5imageschrome restent sans comparaison pixel native.
Reprise : Partir des7current_seven_image_native_bindings;qualifier la conversion alpha exacte de DefineBitsLossless/2 avant comparaison. False signifie non vérifié,pascorrompu. Aucune réextraction ou réencodage du JPEG32 n’est nécessaire.

### AIR-ATLAS-AND-NATIVE-RENDER
22planchettes de revue ne prouvent pas des atlas historiques. Zérotermeatlas/spritesheet dans9139AS n’exclut pas une autre représentation. Aucun rendu AIR,timeline,état public/serveur ou acceptation humaine observé.
Reprise : Réutiliser les définitions de composants/écrans et qualifier les références natives de dimensions,cropping,scale9 et placements avant comparaison de rendu. Rechercher seulement une nouvelle référence précise,pas le même mot-clé sans piste.

## Sources, consommateurs et vérifications
Sources : index et adresses exacts du lot précédent, table/checksum déjà qualifiés, archive publique RADS.bundle sélectionnée dans le reçu de référence, source C++ du getter Packed et qualification antérieure de ses masques. L’ancienne assertion imposant des bits opaques nuls n’est pas rejouée. Décodeur zstandard0.25.0 et backend identifiés par empreinte ; aucune installation.
Exécutés : 31 requêtes de référence bornées, lecture/décompression de 91 descripteurs, sommes de tailles, recherche de 12 031 nouveaux IDs dans la table et contrôles de cache. Le lecteur distinct relit la livraison et ses liens. Non exécutés : ancien index/checksum, ancienne récupération réussie, hash des IDs de chunk, récupération des contenus, MD5 des SWF complets, original AIR/Flash/jeu, rendu/GUI/pixels, export d’images, REA, installation ou migration.

## Sept rubriques
- 1 : Contrat SYS-18.1-03 inchangé;91descripteurs,ni payload complet ni intégration.
- 2 : Plages publiques etsources locales identifiées;taille/MD5 des futursSWF restent les portesd’admission.
- 3 : Lecteur natif de records qualifié par masques;cache existant conservé;consommateurs graphiques inchangés.
- 4 : 31HTTP206réels,91décompressionsZSTD etsommes de tailles;pas de jeu/AIR/pixels.
- 5 : 11995blocs etpayloads encore manquants,conditions de reprise précises.
- 6 : SYS-18.1-03 réutilisée;pas de tâche générale ou critère nouveau.
- 7 : Ajouts inventoriés,échecs conservés si présents,lecteurdistinct etgel vérifiés.

## Livraison et suite
Sources ajoutées : F:\OpenLeague-work\audit-source-recovery\AUD-18.1-03-ARCHIVE-DESCRIPTOR-RECOVERY-01 ;154 fichiers de référence identifiés, sans source antérieure écrasée. Ajouts d’audit : F:\OpenLeague-work\audit-units\AUD-18.1-03-ARCHIVE-DESCRIPTOR-RECOVERY-01 et ce rapport. Le goal, ses critères normatifs, les registres, le produit, OpenLeague Plan et ses bases restent inchangés.
Prochain lot : AUD-18.1-03-NATIVE-SWF-PAYLOAD-RECOVERY-01 — reconstruction contrôlée des 91 SWF depuis les blocs manquants, puis taille/MD5 natifs et audit graphique séparé.
