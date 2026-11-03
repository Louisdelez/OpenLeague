# SYS-18.1-04 — identité des polices historiques

2026-11-01T19:35:38.335970+00:00

L’audit documentaire est terminé sous réserve de relecture. L’extraction complète, l’intégration et la fidélité visuelle ne sont pas terminées. Le statut normatif a_faire reste inchangé. Aucune police n’est installée ou convertie.

## Sources et identités établies
Le périmètre couvre les polices du patcher et du client AIR, dans leurs sources admises. Les polices du HUD de partie et les fontes du système actuel ne sont pas assimilées à ce corpus.
38 ressources externes sont identifiées : 16 fichiers OTF du manifeste AIR et 22 ressources dans les LOAD du patcher. Les 37 représentations SFNT, EOT ou WOFF forment 26 identités de tables normalisées ; une ressource SVG font reste distincte. Ces comptes ne représentent ni 26 familles, ni 38 fontes visuellement différentes.
56 conteneurs SWF portent 121 définitions DefineFont3 : 116 avec des glyphes et cinq sans glyphes. Elles possèdent 116 enregistrements DefineFontName et 121 tables d’alignement. Les noms, styles, codes, identifiants et sources sont conservés. Les NUL terminaux des noms SWF restent dans les octets de référence ; seule leur présentation lisible les retire explicitement.

## Consommateurs actuels et alias natifs
Les deux fichiers utilisés par le CSS courant correspondent exactement aux ressources AIR et patcher :
- Spiegel AIR est un alias CSS de SpiegelOT Regular, version 2.003.
- Beaufort AIR est un alias CSS de Beaufort for LOL Bold, version 1.000.

Les alias SWF ApplicationFont1, ApplicationFont2 et leurs variantes sont une autre couche. Dans css/fonts.swf, Font1 est associé à Arial Unicode MS et Font2 à ITC Friz Quadrata. Dans fonts_cs_CZ.swf, ces alias sont associés à DejaVu Sans. Un nom d’alias commun ne prouve donc pas une identité de fonte, de glyphes ou de rendu.
La recherche ciblée relève 643 références dans 154 sources ActionScript conservées, dont les lecteurs et registres réels. Ces fichiers n’ont pas d’erreur de décompilation recensée ; aucune nouvelle décompilation ni exécution de leur code n’est effectuée.

## Chargement : résultat conditionnel, pas démarrage observé
LoadFontsAction construit css/fonts_<ClientConfig.instance.locale>.swf. LoadFontsPathChecker vérifie File.applicationDirectory.resolvePath(...).exists. Sur false, le code déclare le repli /css/fonts.swf avant le chargement par RiotModuleInfo et l’enregistrement des fontes.
css/fonts_en_GB.swf est absent du manifeste sélectionné et des trois chemins de référence contrôlés ; css/fonts.swf est présent. Cela étaye un choix conditionnel pour la référence en_GB. Le système de fichiers effectif d’un ancien host AIR, sa locale, son cache et les priorités du registre ne sont pas observés par un démarrage natif.

## Limites et reprise précise
1. Extraction et intégration — Les 22 polices des LOAD et les 116 définitions SWF avec glyphes ne sont pas exportées ou converties par cet audit. Reprendre chaque source_id et fontID des inventaires, préserver noms, styles, métriques et caractères, puis comparer le résultat. Ne pas remplacer une définition SWF par un OTF homonyme sans preuve.
2. Alias et host — Réutiliser les deux sources LoadFontsAction/LoadFontsPathChecker et la matrice des alias par fichier. Qualifier ClientConfig, applicationDirectory et les priorités d’enregistrement avant d’affirmer quelle fonte était effectivement chargée.
3. Définitions vides et noms — Les cinq définitions sans glyphes n’ont pas de FontName88. Elles ne sont pas cinq fontes complètes extraites. Trois ressources icomoon contiennent des NUL dans certains noms décodés selon leur plateforme déclarée ; leurs entrées Unicode restent séparées. Qualifier le lecteur, le fallback et la priorité des noms avant de choisir une interprétation. Aucun contour ou octet n’est inventé ou réécrit.
4. Glyphes et rendu — Les métadonnées et identités de tables ne valident pas crénage, ligatures, substitution, retour à la ligne, fallback, métriques à l’écran ou capture historique. Reprendre un texte, un état et un écran précis avec les fontes et versions identifiées, puis vérifier le rendu. L’acceptation humaine reste distincte.
Ces travaux réutilisent SYS-18.1-04 et les tâches d’écrans existantes. Aucun nouveau critère ou registre normatif n’est ajouté.

## Attendu et observé
- Identité : les ressources admises doivent correspondre aux sources et à leurs noms internes. Les 38 ressources et 121 définitions sont lues sans erreur de métadonnées ; les versions, styles et ambiguïtés restent explicites.
- Consommateur actuel : chaque alias CSS doit pointer sur un fichier exact. Les deux comparaisons d’octets réussissent avec les ressources historiques ; elles ne prouvent pas la fidélité d’un écran AIR.
- Frontières : une définition vide, un nom ambigu ou un chemin régional absent ne doit pas produire une réussite inventée. Les cinq définitions vides, trois ambiguïtés de noms et le repli conditionnel sont conservés avec leurs sources et limites.

## Contrôles exécutés et non exécutés
Exécutés : vérification des identités natives, lecture bornée des tables SFNT et des conteneurs WOFF/EOT/SVG, lecture des métadonnées Font3/FontName et tables de codes, comparaison des fichiers CSS, inspection des sources de chargement et vérification des chemins exacts. Les inventaires précédents restent réutilisés par identité.
Non exécutés : installation de police ou de logiciel, export ou conversion de fonte, rasterisation de glyphes, host AIR, registre natif, rendu GUI, jeu, réseau du jeu ou modification de produit. FontTools n’est pas présent et n’est pas installé ; un lecteur local de métadonnées est utilisé.

## Contrats primaires
[OpenType sfnt](https://learn.microsoft.com/en-us/typography/opentype/spec/otff), [table de noms](https://learn.microsoft.com/en-us/typography/opentype/spec/name), [WOFF 1](https://www.w3.org/TR/WOFF/) et [EOT](https://www.w3.org/submissions/EOT/) fondent les champs et bornes de lecture. EOT est une soumission historique, pas une recommandation W3C.
[DefineFont3Tag](https://github.com/jindrapetrik/jpexs-decompiler/blob/dev/libsrc/ffdec_lib/src/com/jpexs/decompiler/flash/tags/DefineFont3Tag.java) et [DefineFontNameTag](https://github.com/jindrapetrik/jpexs-decompiler/blob/dev/libsrc/ffdec_lib/src/com/jpexs/decompiler/flash/tags/DefineFontNameTag.java) étayent les champs SWF. Copies textuelles épinglées, commit upstream non établi, code source non exécuté.

## Sept rubriques de clôture
1. Exigence et périmètre : tâche canonique conservée, polices launcher distinguées du HUD et du système.
2. Sources : fichiers, membres LOAD et définitions SWF identifiés avec leurs limites.
3. Consommateurs : CSS actuel, alias et lecteurs natifs inspectés ; host effectif non qualifié.
4. Contrôles : lectures et comparaisons réelles séparées des essais et rendus non exécutés.
5. Écarts : extraction, chargement, définitions vides, noms et rendu ont une reprise précise.
6. Corrections : tâches existantes réutilisées, aucun critère normatif réécrit.
7. Livraison : preuves datées, fichiers épinglés, lecteur distinct et état protégé vérifiés.

## Livraison et suite
Ajouts uniquement : F:\OpenLeague-work\audit-units\AUD-18.1-04-FONT-SOURCE-IDENTITY-01 et ce rapport. Le goal, ses critères, les registres, le code produit, le suivi et les bases restent inchangés.
Prochain lot : AUD-18.1-05-AIR-AUDIO-TRANSITION-IDENTITY-01 — sources des sons et transitions AIR, avec leurs consommateurs et limites avant extraction ou lecture.
