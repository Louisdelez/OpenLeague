# SYS-18.1-06 — structure native du cadre AIR (livraison005)

2026-11-02T04:59:34.147865+00:00

## Résultat
Les données structurelles des deux ChromeAssets admis sont extraites : 187streams,527définitions de caractères,732placements/retraits,209labels et31grilles scale9. Les40placements nommés des quatre racines correspondent aux noms attendus par les consommateurs sources déjà audités. Aucun fichier de thème manquant.
Les deux ChromeView déclarent thin à l’image1 et thick à l’image11, sur21images. WindowControls conserve21images sans label de frame. Les coordonnées locales du bouton Play diffèrent : translation11400/320twips en parchment et11200/260twips en lolBrand. Ces valeurs ne sont ni des coordonnées écran ni des mesures getBounds.
Les en-têtes des ressources déclarent un RECT0..25600/0..16000twips et une cadence fixe6144/256. Ce sont des métadonnées d’auteur, pas la taille ou la cadence observée du client.

## Vérification
Les SHA décompressées et compteurs de tags concordent avec les inventaires antérieurs. Chaque événement, matrice, label, rectangle et définition garde son offset et son empreinte. 174placements n’ont pas de MATRIX ; ils restent absents dans les événements. 53matrices portent une translation négative.
Huit corruptions bornées d’entrées réelles sont refusées explicitement : matrice tronquée, préfixe de placement incomplet, chaîne sans zéro terminal, longueur SWF déclarée incorrecte. Aucun fichier natif modifié. Une relecture binaire indépendante est requise avant sélection.
Format consulté pour cette nouvelle question : [spécification Adobe SWF19](https://open-flash.github.io/mirrors/swf-spec-19.pdf), sections RECT/MATRIX, PlaceObject2/3, FrameLabel et DefineScalingGrid. Publication primaire hébergée sur un miroir ; aucun document complet ou asset téléchargé.

## Limites et reprise
- CHROME-OPTIONAL-EXTENSION-TAILS : 55PlaceObject3 extension tails are retained with raw bytes and hashes; filters/blend/cache and further optional fields are not decoded or applied. Clip/mask/filters can change appearance; no renderer result inferred. Reprise : Use exact55offset/prefix/tail records and primary format sections for the actually present extension flags1/2. Decode only those optional records without applying pixel filters or running clip actions; reconcile bounded sizes and leave AVM/render effects open.
- CHROME-CHILD-OVERRIDES-AND-RENDERED-BOUNDS : Root source contracts and native placement/label records are linked. Child-specific AS layout/ticker/queue/summoner/button overrides,actual theme/domain/provider and rendered bounds remain separately unqualified. Native authoring RECT,local MATRIX,scale9 and declared child bounds do not prove getBounds/display geometry. Reprise : Reuse the40root binding rows and potential dependency graph;choose exact child methods affecting sizes/visibility and only their unreviewed clauses. Reuse root/core contracts and deferred native/current matched-state comparison;do not reparse the same native prefix or repeat style/source-wide queries without a new issue.
Le graphe décrit des références possibles sur toutes les frames ; il ne prouve ni la visibilité, ni un chargement de domaine, ni l’exécution de transitions. Les55queues d’extension sont conservées octet pour octet, sans application de filtres ou décodage de clip actions. Les42exports PNG demeurent des candidats, sans comparaison de pixels.
La famille chrome, le lot complet51familles/788composants et la fonctionnalité restent ouverts. Le manque de champs dans les anciens inventaires est résolu pour les préfixes, noms, matrices, labels et grilles ; les limites originales restent conservées avec cette précision.

## Consommateur et écritures
Le consommateur actuel reste le launcher de préparation et son en-tête statique déjà recensés. Les preuves courantes sont réutilisées ; aucune recherche de styles ou nouvelle requête globale du code. Aucun changement fonctionnel déduit de cet audit.
SYS-18.1-06 / OLU-5383e436-013f-575c-bf97-03f832c95163 réutilisés. Ajouts documentaires et scripts de lecture statique uniquement ; goal, critères, registres, produit, application de suivi, interface et bases inchangés. Aucune installation, migration ou relance. Aucun AS/ABC, dessin vectoriel, rendu, pixel, audio, vidéo ou jeu exécuté/décodé.
Prochain lot :55extensions présentes et contrats propres aux enfants non encore audités, à partir des liaisons exactes. Ne pas refaire les préfixes, méthodes racines, labels ou recherches de styles sans nouvelle anomalie.
