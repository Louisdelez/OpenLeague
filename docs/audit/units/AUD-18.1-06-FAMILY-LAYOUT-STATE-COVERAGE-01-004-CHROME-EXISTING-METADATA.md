# SYS-18.1-06 — métadonnées existantes du cadre AIR (livraison004)

2026-11-02T04:44:32.990759+00:00

## Résultat
L’examen des inventaires existants est terminé. Les deux SWF natifs sont présents et admis : parchment et lolBrand. Les quatre symboles ChromeView262/265 et WindowControls19/16 déclarent chacun21images. Cela établit une longueur de timeline, pas les états, placements ou dimensions affichées.
Le pack chrome exporté est relié uniquement à lolBrand par égalité des dix entrées SymbolClass. Il contient1307fichiers recensés, dont42images candidates pour les deux racines et deux wrappers texte. Les vingt propriétés déclarées dans ces wrappers correspondent exactement aux noms liés dans createChildren des deux consommateurs déjà audités. Les wrappers sont des exports conservés ; aucune nouvelle décompilation.

## Limite résolue
Il ne manque pas les fichiers des thèmes. Les inventaires conservés n’exposent pas les valeurs de placement, noms d’instance, matrices, profondeur, labels par frame ou rectangles scale9. Leurs compteurs prouvent la présence de catégories de tags, pas leurs contenus. Les streams de définition ne forment pas le graphe des instances affichées.
Les42PNG restent des candidats de frame lolBrand : ni pixels comparés, ni équivalence parchment, ni association des numéros1–21 aux états thin/thick. Les huit profils média existants ne contiennent pas de profil chrome ; cette observation reste bornée à ces huit profils.

## Ce qui reste ouvert
- CHROME-RETAINED-INVENTORY-NO-PLACEMENT-FIELDS : The two admitted native SWFs exist and contain placement/label/scale-grid tag counts. Existing inventories retain offsets/symbols/frame counts but not per-frame instance names,matrices,depth,move/remove records,label text or scale9 rectangles. Reprise : Read only the already admitted CWS bytes and verify uncompressed SHA. Reuse exact stream spans for root262/265 andcontrols19/16; decode structural SWF tag26/70/28/43/78 and needed character definition headers/RECT only. No AS,ABC,vector drawing,image pixels or playback. Reconstruct source display-list state from tag records only,without claiming rendered geometry.
- CHROME-DERIVED-FRAMES-NOT-NATIVE-GEOMETRY : 42retained frame PNG candidates and two text wrappers bind to lolBrand only. Their filenames/properties do not prove pixels or native instance transforms; no admitted corresponding parchment export pack in this retained chrome group. Reprise : Use native structural records before any comparison. Do not infer parchment geometry from lolBrand frame images or map filenames1..21 to native state names. If visual work is separately authorised,establish matching native state/theme/locale/viewport/DPI and export provenance first.
Les limites de domaine actif, thème/locale/host et rendu actuel restent conservées. Toute la famille chrome, le lot51familles/788composants et la fonctionnalité demeurent ouverts. Le composant de navigation partagé ne clôt pas hidden-lore-watch.

## Vérification et reprise
Contrôles réels : identités des sources admises, champs JSON exacts, quatre streams et deux spans de définition, CSV, inventaire des fichiers,42candidats et20propriétés reliées aux consommateurs. Les preuves003 sont réutilisées sans rejouer les108fenêtres AS ni les requêtes de styles. Producteur et relecture séparés, reçus réels et sélection après succès.
Prochain lot : décodage statique ciblé des tags de placement/labels/scale9 dans les deux fichiers natifs existants, sans AS/ABC, rendu, pixel, réseau ou nouvelle décompilation. Les valeurs structurelles resteront séparées de la géométrie affichée.
SYS-18.1-06 / OLU-5383e436-013f-575c-bf97-03f832c95163 réutilisés. Ajouts documentaires uniquement ; goal, critères, registres, produit, Plan, interface et bases inchangés. Anciennes preuves et erreurs conservées. Aucune installation, migration ou relance.
