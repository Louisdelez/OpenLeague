# SYS-18.1-03 — récupération des 91 SWF natifs

2026-11-01T18:57:38.360576+00:00

Le manque matériel des 91 sources est levé. Leur taille et leur MD5 correspondent au manifeste natif. Le lot de récupération est terminé sous réserve de relecture ; le parent d’audit graphique reste ouvert. Aucun asset n’est installé dans le produit.

## Résultat concret
91 SWF de référence reconstruits sur F : 125 635 557 octets, tous conformes à la taille et au MD5 exigés. Les révisions individuelles sont conservées ; matchHistory.swf est bien la version0.0.0.166,123736octets,MD544abc5b81b6fb623df2cadec6d9e6a2e. La version incorrecte de la vue fusionnée n’a pas été utilisée.
Le pool documentaire couvre désormais exactement les 526 entréesSWF/DAT du manifeste AIR0.0.1.119 :418SWF et108DAT. Les435sources antérieures sont conservées ;les91nouvelles sont dans le nouveau répertoire de référence, sans réécrire les anciens contrats ou chemins du produit.
875plages de contenu acceptées,134160473octets,avec statuts206,extent,longueur etencodage contrôlés.11995blocs manquants récupérés et36candidatscache réutilisés,12031blocs distincts au total. Les réponses et les erreurs transitoires éventuelles sont conservées ;aucune réponse déjà réussie n’a besoin d’être retéléchargée.
Résumé réel des tentatives et de la reprise : {'required_SWFs': 91, 'native_size_MD5_verified_payloads': 91, 'native_payload_bytes': 125635557, 'planned_HTTP_groups': 875, 'accepted_HTTP_groups': 875, 'accepted_HTTP_bytes': 134160473, 'reused_successful_HTTP_groups': 0, 'HTTP_attempt_records_used': 885, 'HTTP_failed_attempts_retained': 10, 'unique_content_chunks_decoded_or_reused': 12031, 'cache_chunks_reused': 36, 'native_image_pixels_decoded': 0, 'original_SWF_or_AIR_executed': False, 'errors': 0}.

## Frontières de la preuve
Les fichiers sont des sources historiques exactes par taille/MD5,pas des exports graphiques dérivés ou une installation dans le launcher. Aucun SWF/Flash/AIR ni jeu original n’a été exécuté. Aucun pixel,image,timeline,atlas ou écran n’est validé par cette seule récupération. Les435inventaires précédents sont hérités ;les91nouveauxcorps attendent leur audit de tags.
Les algorithmes d’ID de chunks ne sont pas réexécutés. Les blocs sont contrôlés par tailleTOC et les fichiers complets parMD5natif. La disponibilité régionale,les loaders/services historiques et l’acceptation humaine ne se déduisent pas de ces identités.

## Attendu / observé

### BOUNDED-SOURCE-RECOVERY
Attendu : Retrieve only missing ranges,retain successfulresponses/failedattempts,refuse wrongstatus/extent/encoding/length.
Observé : {'required_SWFs': 91, 'native_size_MD5_verified_payloads': 91, 'native_payload_bytes': 125635557, 'planned_HTTP_groups': 875, 'accepted_HTTP_groups': 875, 'accepted_HTTP_bytes': 134160473, 'reused_successful_HTTP_groups': 0, 'HTTP_attempt_records_used': 885, 'HTTP_failed_attempts_retained': 10, 'unique_content_chunks_decoded_or_reused': 12031, 'cache_chunks_reused': 36, 'native_image_pixels_decoded': 0, 'original_SWF_or_AIR_executed': False, 'errors': 0}
Limite : HTTP is reference-source retrieval,not gameplay networking or full258GBarchive download.

### NATIVE-SOURCE-IDENTITY
Attendu : Each91file matches exact native per-file release/size/MD5.
Observé : 91files125635557bytesaccepted;matchHistory0.0.0.166matchesnative123736bytes andMD544abc5b81b6fb623df2cadec6d9e6a2e.
Limite : Nativefile identity does not prove runtime loader policy,public availability or rendered images.

### COMPLETE-SOURCE-POOL
Attendu : Retain435admittedsources andadd91qualifiedinputs without substituting olderexports.
Observé : 526uniqueSWF/DATinputs exactly cover native manifest(418SWF+108DAT);old435inventories reused,new91bodies not parsed yet.
Limite : Graphicdenominator,pixels,atlas provenance andproductintegration remain open.

## Ce qui reste ouvert

### AIR-COMPLETE-IMAGE-ATLAS-COVERAGE
Les526sources nativesSWF/DAT sont présentes et admissibles. Les435anciennes sources ont un inventaire hérité de1530tagsbitmap;les91nouvelles sources ne sont pas encore analysées pour leurs tags/images/atlas. Le dénominateur graphique complet reste inconnu.
Reprise : Réutiliser qualified_air_source_pool.json et les inventaires des435sources inchangées;parser seulement les91sources nouvelles pour les types supportés,identifier précisément tout format non supporté puis consolider la population parsource/tag/ID/provenance. Distinguer bitmap,forme/timeline,police etplanche de revue;pasnouveau download,index ou test inchangé.

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
- 1 : SYS-18.1-03 canonique conservée;reconstruction de sources,ni exportgraphique dérivé ni intégration.
- 2 : 91payloads exactstaille/MD5 etpool526sources;versions/locales/plateformes non substituées.
- 3 : Assembleur de référence utilise descripteurs/chunks exacts;consommateurs graphiques inchangés.
- 4 : 875plages acceptées,11995chunks récupérés,36cache réutilisés;fichiers vérifiés,reprises/échecs conservés.
- 5 : Manque source matériel résolu;inventaire graphique des91inputs encore ouvert avecreprise.
- 6 : Tâche existante réutilisée;aucune correction générale ou critère normatif créé.
- 7 : Ajouts nouveaux surF etidentités,relecture distincte etgel contrôlés.

## Livraison et suite
Nouvelles sources : F:\OpenLeague-work\audit-source-recovery\AUD-18.1-03-NATIVE-SWF-PAYLOAD-RECOVERY-01. Le manifeste inputs.json identifie tous les fichiers et empreintes,sans remplacement de cache ou de fichiers antérieurs. Ajouts d’audit : F:\OpenLeague-work\audit-units\AUD-18.1-03-NATIVE-SWF-PAYLOAD-RECOVERY-01 etce rapport. Aucun goal,critère normatif,registre,code produit,application de suivi ou base modifié ;aucune installation,migration ou redémarrage.
Prochain lot : AUD-18.1-03-COMPLETE-BITMAP-ATLAS-COVERAGE-01 — analyser seulement les91corps nouvellement récupérés et consolider la population graphique avec les435inventaires réutilisés.
