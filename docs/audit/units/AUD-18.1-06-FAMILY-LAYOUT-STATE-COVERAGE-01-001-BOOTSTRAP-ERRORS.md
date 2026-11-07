# SYS-18.1-06 — erreurs de démarrage,livraison001

2026-11-02T03:31:50.992858+00:00

Livraison partielle du lot complet des51familles et788composants. Seuls les contrats source des deux fenêtres d’erreur sont clôturés avec bornes,sous réserve de relecture indépendante. Zéro famille entière déclarée auditée à100% ;les51familles restent ouvertes et les critères du lot complet restent strictement conservés.

## Résultat concret
ShellErrorWindow et FatalErrorWindow déclarent chacun une fenêtre native600×400,chrome standard,non redimensionnable,non maximisable et non minimisable,avec stage TOP_LEFT/NO_SCALE. Ce600×400 est une taille de fenêtre déclarée,distincte des bounds de contenu/stage non observés ;ce n’est pas le1280×800 du shell principal.
Les deux sources ajoutent,dans cet ordre,un fond solide600×400,le loader d’image,puis le texte. Le texte est à(30,30),320×360,sélectionnable,multiligne,avec retour automatique,blanc etformat20 à nom de police null. La sélection de police etles métriques réelles restent inconnues.
Le fond est assets/images/champions/Amumu_Splash_0.jpg,avec scaleX/scaleY0.6667,décalage(-10,-60),ColorTransform etBlurFilter(2,2,HIGH). Aucun handler de fin/échec de chargement n’est déclaré dans ces deux méthodes ;aucun résultat de chargement,filtre ou clipping n’est revendiqué.
L’image existe déjà dans les sources conservées E. Ses304092octets etMD5d07136cf231630d6f61785e6b94c3d9f correspondent au membre du manifeste AIR0.0.1.119 ;la release du membre est0.0.0.151 etne devient pas le build global. SHA-2563ad759e4efee4d811d5d2e77f8bf9a2262629889ead01932417e6b3aa31bba9f ;en-tête JPEG1215×717,lu sans pixels. Aucun téléchargement,copie ou remplacement d’asset.

## Routes et consommateur actuel
LolClient distingue l’erreur de dépendances0001 etl’erreur du contenu0002,puis crée ShellErrorWindow etlie CLOSE àla sortie de l’application. BaseShell crée FatalErrorWindow etlie aussi la fermeture àla sortie. ClientWindow.onLoginModuleError appelle le fatal hérité.
Deux limites évitent une fausse généralisation : uncaughtErrorHandler nefait qu’un relay conditionné par hasDefinition ;dataLoadErredHandler journalise seulement dans son corps exact. Ces méthodes ne sont pas promues en ouverture automatique d’un écran fatal.
Le JS actuel écrit les erreurs de catalogue/session/commandes dans status.textContent etdésactive les actions ;HTML fournit un paragraphe aria-live. La recherche explicite des noms des fenêtres etdu fond dans12fichiers du launcher n’a pas dematch. Cette absence est bornée àces fichiers etn’est pas une preuve d’absence sémantique dans tout le moteur. Aucun rendu courant exécuté.

## Contrôles réellement exécutés
Cinq sources exactes,20fenêtres de méthodes,19contrats source avec termes/ordre/absences limitées aux méthodes ;provenance MD5/taille/SHA-256 eten-tête SOF de l’image existante ;lignes JS/HTML,requête actuelle etfichiers protégés. La relecture séparée ne doit pas transformer ces contrôles statiques en tests de comportement natif.

## Ce qui reste ouvert
Les autres clauses bootstrap etles autres familles/composants/états ne sont pas clôturés. Les68références géométriques de ClientWindow appartiennent toutes à_ClientWindow_StylesInit ;leurs sélecteurs/factories etconsommateurs doivent être qualifiés avant toute interprétation en dimensions de fenêtre.
Comparaison réelle :identifier exécutable,fenêtre externe/stage,DPI/viewport,font,glyphes,image chargée,filtre,état etévénements. Réutiliser l’image admise ;aucune reconstruction ou nouvelle recherche distante nécessaire pour cette entrée.
La correction réutilise SYS-18.1-06 etOLU-5383e436-013f-575c-bf97-03f832c95163,avec critères de fin/reprise dans les qualifications. Les trois bornes géométriques antérieures restent intactes.

## Livraison et reprise
Ajouts immuables uniquement dans F:\OpenLeague-work\audit-units\AUD-18.1-06-FAMILY-LAYOUT-STATE-COVERAGE-01 etce rapport,avec préparations E. Aucun goal,critère,registre,produit,Plan,base,case ou historique modifié ;aucune installation,migration,relance,nouvelle décompilation,HTTP,simulation native,pixel décodé ou média joué.
Prochaine livraison002 dans le même lot complet :BOOTSTRAP-GENERATED-STYLE-GEOMETRY-01,qualification des68affectations par sélecteur/factory exact. Les critères de fin du lot51familles restent inchangés ;le prochain enregistrement est une nouvelle preuve/index numéroté,aucun fichier001 àécraser.
