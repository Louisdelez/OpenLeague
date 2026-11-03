# SYS-18.1-03 — admissibilité des images et atlas AIR

2026-11-01T18:24:27.814412+00:00

Le lot d’admissibilité est terminé sous réserve de relecture. L’audit de la tâche parente reste ouvert. Ni extraction complète ni intégration graphique ne sont terminées. Le goal,les critères,le produit,le suivi et les bases restent inchangés.

Extraire images et atlas des SWF du client AIR
Le résultat « Extraire images et atlas des SWF du client AIR » est intégré au consommateur réel et vérifié sur la référence 4.20 ; succès, refus et limites applicables sont documentés.

## Résultats établis
Le manifeste lol_air_client0.0.1.119 contient7886fichiers,dont418SWF et108DAT.435deces526sources sont présentes et conformes à la taille/auMD5 natifs;91sont absentes dans les3racines du recensement. L’ancien périmètre109fichiers de code ne couvrait pas tous lesSWF de ressources.
Lecture statique bornée des435conteneurs,aucune erreur de structure:1530tags bitmap dans51sources(type36:1230;35:170;6:34;20:63;21:33). Aucun AS/AIR ni timeline exécuté. Les offsets et SHA de payload sont conservés;les pixels des1530bitmaps n’ont pas été validés.
2963candidats d’images exportées sont conservés dans le seul arbre extrait contrôlé. Ils mêlent PNG/JPEG,SVG et rendus de formes/timelines:leur nombre ne se compare pas directement à1530.767ont unID bitmap unique dans un conteneur lié;cela ne qualifie pas leurs pixels.
Les13tables symbols.csv sont reliées aux SWF natifs:11parSymbolClass76,2parla réunion exacte SymbolClass76+ExportAssets56. L’exporteur primaire JPEXS écrit les deux types,ce qui explique les deux correspondances initialement incomplètes. Les22sheet_N.png sont des planches de revue candidates décrites par air_contact_sheet.py,lu mais non exécuté;elles ne prouvent pas22atlas natifs. La recherche de termes atlas/spritesheet sur9139exportsAS est sans hit,ce qui n’exclut pas une autre représentation.

## Images déjà utilisées par le launcher
Les9copies installées du reçu antérieur sont réutilisées etleurs identités vérifiées(7images,2polices). Les7images ont maintenant un conteneur,unID etun tag natifs identifiés. Le JPEG32 de mod/cs/mod_cs.dat égale exactement le fichier installé.
La carte197 du launcher pointe vers le tag DefineBitsLossless2 duSWF mod/man/mod_man.dat,en815×435. Les octetsARGB ont été décompressés:alpha minimum0,maximum255. La conversion des couleurs prémultipliées etla comparaison RGBA ne sont pas exécutées. Cela ne prouve aucune corruption ni différence avec l’image actuelle. Les5imageschrome ne disposent pas encore d’une comparaison de pixels natifs.
Une assertion préparatoire supposait2égalités alors qu’une seule est établie;elle a échoué avant écriture du résultat. Le script est conservé. La qualification corrigée code0 mesure les résultats individuels. La phrase héritée du champ image_pixel_decoding_scope est trop large:air_image_qualification_scope.json etles résultats individuels font foi.

## Contrôles attendus et observés

### NATIVE-DENOMINATOR
Attendu : Distinguer code AIR et ressources SWF du manifeste complet,admettre les identités exactes.
Observé : 526entrées(418SWF+108DAT),435présentes conformes,91absentes dans3racines,0candidate divergente.109fichiers de code de l’inventaire précédent sont inclus,mais ne définissent pas tout le périmètre.
Limite : Les91sources non examinées empêchent la clôture du parent.

### SOURCE-TAGS
Attendu : Lire les conteneurs statiquement,sans exécuter AS/AIR,et identifier les ressources par tags.
Observé : 435décompressions/streams bornés sans erreur;1530tagsbitmap dans51sources;ID,payloadSHA,offsets,types conservés.
Limite : 1530est un sous-ensemble connu,pas la population complète ni un nombre de sorties PNG.

### SYMBOL-TABLES
Attendu : Relier les exports conservés au bon conteneur,sans déduire la provenance du nom de dossier.
Observé : 11tables liées parSymbolClass76;2autres liées exactement en incluantExportAssets56,comme le faitl’exporteur primaire.13tables admissibles;767candidats ont unIDbitmapunique.
Limite : La correspondance de tables/ID ne prouve ni pixels ni exécution historique de l’exporteur.

### ACTUAL-CONSUMERS
Attendu : Conserver les copies installées établies et renforcer seulement les comparaisons effectivement faites.
Observé : 9copies/consommateurs historiques réutilisés,7images liées aux tagsnatifs;JPEG32 exactement identique. Map197 a les dimensions815x435etalpha0..255,comparaisonRGBA non exécutée.
Limite : Ancienne assertion supposant2égalités rejetée,échec conservé;aucune différence de pixels ou corruption affirmée.

## Manques et reprise

### AIR-SWF91-SOURCE-AVAILABILITY
91SWF du manifeste exact sont absents dans les3racines contrôlées,dont resources-en_GB Game/App et ColloqPack_fontconfig_en_GB. Leur population de bitmaps et rôle restent non examinés. La présence de435sources ne suffit pas à clore le parent.
Reprise : Chercher uniquement les91logical_path et leurs release/taille/MD5 dans les sources d’archives déjà connues. Admettre un payload par identité native puis qualifier ses tags;consigner les non-retrouvés. Ne pas substituer les218chemins supplémentaires du cache ni exclure Mac/autreslocales sans politique native établie.

### AIR-NATIVE-IMAGE-EXPORT-PROVENANCE
1530tags bitmap connus dans51sources présentes;2963candidats exportés mêlent bitmaps,vecteurs et rendu de timelines.767candidats ont unIDbitmap unique dans le conteneur lié;cela ne prouve pas leurs pixels ni leur installation.
Reprise : Réutiliser qualified_retained_export_matrix et les offsets/SHA des tags. Comparer par format natif(6/20/21/35/36),puis distinguer exports bitmap,SVG et timelines;ne pas compter unID de forme ou une planche de contact comme bitmap manquant.

### AIR-MAP197-AND-CHROME-PIXELS
Les7images installées ont conteneur/ID/tag natifs;seulJPEG32 égale déjà le payload natif. Bitmap197 comprend alpha0..255:conversion avec alpha prémultiplié non effectuée. Les5imageschrome restent sans comparaison pixel native.
Reprise : Partir des7current_seven_image_native_bindings;qualifier la conversion alpha exacte de DefineBitsLossless/2 avant comparaison. False signifie non vérifié,pascorrompu. Aucune réextraction ou réencodage du JPEG32 n’est nécessaire.

### AIR-ATLAS-AND-NATIVE-RENDER
22planchettes de revue ne prouvent pas des atlas historiques. Zérotermeatlas/spritesheet dans9139AS n’exclut pas une autre représentation. Aucun rendu AIR,timeline,état public/serveur ou acceptation humaine observé.
Reprise : Réutiliser les définitions de composants/écrans et qualifier les références natives de dimensions,cropping,scale9 et placements avant comparaison de rendu. Rechercher seulement une nouvelle référence précise,pas le même mot-clé sans piste.

## Sources et consommateurs
Manifeste binaire et contrat docs/reference_air_routes_4_20.json;copies F/docs/reference_air_sources/original,cache E/output/Launcher_420_Research/air_119 etdeploy natif D explicitement contrôlés. Aucun chemin supplémentaire du cache n’est admis comme source native sans preuve. Les91manques incluent3fichiers en_GB;ils ne sont pas automatiquement exemptés selon leur locale/plateforme.
Consommateurs:launcher/web/index.html etstyle.css déjà qualifiés,ancien reçu frontend-assets-consumers.json;tools/project-plan/air_reference.py décrit le référentiel,et audit_frontend_inventory_reference.py vérifie9copies sans décoder toutes les images. prepare_legacy_launcher.py copie les exports hérités etrenomme certains fichiers;il est lu,non exécuté.
Sources primaires: [DefineBitsLossless2](https://github.com/jindrapetrik/jpexs-decompiler/blob/dev/libsrc/ffdec_lib/src/com/jpexs/decompiler/flash/tags/DefineBitsLossless2Tag.java) et[SymbolClassExporter](https://github.com/jindrapetrik/jpexs-decompiler/blob/dev/libsrc/ffdec_lib/src/com/jpexs/decompiler/flash/exporters/SymbolClassExporter.java). Copies textuelles épinglées;commit upstream non établi. Aucun outil téléchargé/installé ou exporteur exécuté.

## Sept rubriques
- 1 : Contrat SYS-18.1-03 canonique et limites actuelles conservés.
- 2 : 526sources attendues,435qualifiées,91manquantes et3racines nommées.
- 3 : Outils d’export lus seulement;7images etconsommateurs actuels liés à leurs conteneurs/IDs natifs.
- 4 : Tags natifs lus;JPEG32 exact;autrespixels/rendu distingués etéchec préparatoire conservé.
- 5 : Manques etconditions de reprise précis;parent ouvert.
- 6 : Tâche SYS-18.1-03 existante réutilisée,matrice parsource/export;aucune nouvelle tâche générale.
- 7 : Nouveaux livrables etscripts,relecture distincte,empreintes etgel vérifiés.

## Livraison et suite
Ajouts seulement: F:\OpenLeague-work\audit-units\AUD-18.1-03-AIR-IMAGE-ATLAS-ADMISSIBILITY-01 etce rapport. Preuve principale air-image-admissibility-proof.json,inventaires/matrices,reçus réels etlecteur distinct. La première observation6Mo est conservée sur E par son identité;pas de copie redondante de sources graphiques.
Prochain lot : AUD-18.1-03-MISSING-SWF-AVAILABILITY-01 — disponibilité des91SWF exacts. Le parent reste ouvert sur ce manque réel.
