# SYS-18.1-03 — audit des images et atlas AIR terminé avec constats

2026-11-01T19:14:55.659176+00:00

L’audit documentaire de SYS-18.1-03 est terminé sous réserve de relecture. L’extraction complète, l’intégration produit, le rendu et l’acceptation humaine restent incomplets. Le statut normatif a_faire et les cases du suivi ne sont pas modifiés.

## Population établie
Les526sources SWF/DAT admises ont été examinées :435inventaires qualifiés réutilisés et91nouveauxconteneurs lus sans erreur de structure. Ils contiennent2938définitions bitmap dans72fichiers sources, dont1408dans les91nouveaux. Répartition :36DefineBits6,63DefineBitsLossless20,462JPEG2/21,258JPEG3/35 et2119Lossless2/36. Ce sont des occurrences natives par conteneur/ID, pas2938images uniques, visibles ou déjà extraites.
Les36imagesJPEG6 disposent de12tablesJPEGpartagées, identifiées parsource/offset/SHA. Les996ressourcesDefineBinaryData sont classées :3manifestesXML de composants,15programmes liés à des classes shader,959JSONd’objets/builds conseillés et19textesfontconfig/colloquialismes. Aucun shader ou code original n’est exécuté.
Quatretextes natifs avec BOM/headerfontconfig refusent un décodageUTF8complet(cs_CZ,el_GR,ko_KR,ru_RU). Les offsets/octets précis sont conservés ; aucun encodage de repli choisi et aucun fichier converti. Ce constat ne devient pas une image manquante ou une déclaration générale de corruption.

## Correction des exports et consommateurs
Le précédent nombre767surestimait les correspondances bitmap :391numéros de frames avaient été rapprochés d’IDs de bitmap. La preuve ancienne reste intacte. Le classement corrigé est376fichiersimages/bitmap,400SVGdeformes et2187frames de175sprites. Tousles2963exports sont liés au bon caractère natif ; les175séquences de noms1..N correspondent au nombre de frames déclaré, sans prouver une animation ou un rendu.
La matrice2938ressources contient source/ID/tag/SHA,noms exportés lorsqu’ils sont présents,liens verslesexports etconsommateur actuel.376définitions ont un fichierimages/ dans l’arbre de revue contrôlé ;2562n’en ont pas dans cet arbre. Cette absence est bornée, pas un scan duPC.
Les7images du launcher sont liées au bon bitmap natif. L’égalité JPEG32 déjà vérifiée est réutilisée ;les6autres comparaisons pixels restent ouvertes, dont map197 avec alpha0..255. Le termefalse signifie nonvérifié,pas différence de pixels. HTML/CSS etoutils actuels sont épinglés. Une requête bornée des littérauxSWF/BitmapData/TextureAtlas/SpriteSheet dans le frontend/Tauri ne trouve aucunhit(code1,sanserreur) ; elle ne prouve aucune absence globale dans le moteur Rust/HUD.

## Atlas : constat borné
Les22sheet_N.png sont des candidates aux planches de revue du générateur conservé, pas des preuves d’atlas natifs. Aucune structure d’atlas explicite n’est identifiée dans les déclarations de sources et données examinées : recherche AShéritée,manifestesXML/JSON ettypes de ressources. Cela ne prouve pas l’absence globale de packing,cropping ou atlas dynamique. L’audit de cette clause conclut avec cette limite etune reprise précise,sans inventer des atlas ou assimiler des planches de contact à des sources historiques.

## Contrôles réellement exécutés
Lecture bornée des91nouveauxSWF ;435inventaires réutilisés. Lecture complémentaire des types de caractères et tablesJPEG dans les seuls anciensconteneurs nécessaires à une question nouvelle. Association type/ID/source des2963exports etnoms/ranges des175sprites. Classification JSON/XML/texte desdonnées embarquées ;4refusUTF8réels. Vérification des identités,duconsommateur actuel etdugel.
Non exécutés : nouveau téléchargement d’archive,index/lookup rejoué,ancien lecteur complet relancé,nouveau décodage de pixels ou rendu,Flash/AIR/AS/jeu/GUI,export graphique,installation,migration ou modification produit. Les familles de formats et la source des tablesJPEG sont étayées par [DefineBitsTag primaire](https://github.com/jindrapetrik/jpexs-decompiler/blob/dev/libsrc/ffdec_lib/src/com/jpexs/decompiler/flash/tags/DefineBitsTag.java),copie textuelle épinglée,commit upstream non établi.

## Manques précis et conditions de reprise

### AIR-GRAPHIC-MATERIALIZATION-INTEGRATION
2938définitions bitmap natives sont indexées;376ont un fichierimages/ dans l’arbre de revue,2562n’en ont pas dans cet arbre.7images sont référencées par le launcher;aucune installation de nouvelles images par cet audit.
Reprise : Utiliser les resource_id et champssource de bitmap_source_consumer_matrix,puis exporter par format natif avec tablesJPEG6/alpha/palettes corrects et valider chaque résultat. L’absence est bornée à l’arbre de revue identifié,pas auPC entier. Installer seulement les ressources du consommateur réellement choisi dans une intervention produit distinctement autorisée.

### AIR-DERIVED-VECTOR-TIMELINE-RENDER
400SVG/formes et2187frames de175sprites sont liés au bon caractère natif. Noms de frames1..N complets ne prouvent ni pixels,couleurs,masks,animation,dynamiqueAS ou affichage public.22planches de revue ne sont pas des atlas natifs.
Reprise : Reprendre retained_export_source_matrix et sprite_frame_group_qualifications pour le sprite/forme précis;qualifier composition,transformations,états et rendu historique. Pour un atlas autonome,apporter une nouvelle déclaration/ressource/consommateur précis;ne pas répéter à l’identique les mêmes recherches de mots-clés.

### AIR-PIXELS-ALPHA-ATLAS-SEMANTICS
Un seulJPEG installé est égal au payload natif;les6autrescomparaisons pixels restent non exécutées. Atlas natif explicite non identifié dans les déclarations et données examinées;présence/absence globale ou packing dynamique non prouvé.15ressources shader sont typées sans comportement exécuté.
Reprise : Utiliser current_seven_native_consumer_bindings et native_tag/sourceSHA. Pour map197,conserver alpha0..255 et qualifier la conversion prémultipliée avant comparaison. Unfalse signifie nonvérifié,pascorrompu. Lier tout nouveau contrat d’atlas à son producteur natif et distinguer métadonnée,raster et rendu.

### AIR-FOUR-COLLOQ-TEXT-ENCODINGS
Quatrepayloads natifsfontconfig cs_CZ,el_GR,ko_KR,ru_RU portent unBOM/headertextuel mais refusentUTF8complet aux offsets exacts conservés. Ils sont identifiés comme données de texte,pas images;encodageetlecteur natif effectif restent indéterminés.
Reprise : Réutiliser four_configuration_encoding_boundaries,octets/SHA/offsets etclassesColloqPack précises. Examiner le lecteur natif avant de choisir un encodage de repli. Aucun octet n’a été converti ni réparé automatiquement;la sémantique régionale n’est pas déduite du headerEnglish.

## Sept rubriques
- 1 : Task canoniqueSYS-18.1-03 conservée;scopebitmap/vectoriel/timeline/atlas explicité.
- 2 : 526sources qualifiées,2938tags bitmap et996données embarquées classés;limites datées.
- 3 : 2938matrice source/consommateur,2963exports typés et7assets du launcher;absence actuelle bornée au code inspecté.
- 4 : 91nouveauxconteneurs lus,435inventaires réutilisés,4refusUTF8 et175ranges de frames contrôlés;sans rendu.
- 5 : Manques précis d’export/intégration/pixels/atlas/encodages,sans source inconnue masquée enréussite.
- 6 : SYS-18.1-03 et tâches graphiques/localisation existantes réutilisées;pas de nouveau critère normatif.
- 7 : Livrables/identités/relecturedistincte et gel vérifiés;états normatifs inchangés.

## Livraison et suite
Ajouts seulement : F:\OpenLeague-work\audit-units\AUD-18.1-03-COMPLETE-BITMAP-ATLAS-COVERAGE-01 etce rapport. Lesinventaires,qualifications,frontières etmatrice source-consommateur sont séparés,identifiés et relus. Aucune preuve ancienne écrasée. Goal,critères normatifs,registres,codeproduit,application de suivi etbases inchangés.
Clôture documentaire motivée : toutes les entrées et classes de ressources admises ont été examinées ; les manques restants sont identifiés comme implémentation/vérification/acceptation. Aucun manque réel de source non examinée n’est converti automatiquement en réussite.
Prochain lot : AUD-18.1-04-FONT-SOURCE-IDENTITY-01 — Qualifier les sources de polices historiques,leurs identités/noms internes et consommateurs actuels,sans installation ou modification de rendu.
