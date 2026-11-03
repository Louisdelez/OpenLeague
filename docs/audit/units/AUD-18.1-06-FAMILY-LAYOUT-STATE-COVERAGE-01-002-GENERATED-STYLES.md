# SYS-18.1-06 — styles générés,livraison002

2026-11-02T04:13:19.467364+00:00

Livraison partielle du lot51familles/788composants. La cartographie source des68affectations est finie,sous réserve de sélection de la relecture indépendante. Aucun rendu,style actif ou famille entière déclaré terminé.

## Résultat
Les68affectations géométriques de _ClientWindow_StylesInit relèvent de41sélecteurs et15propriétés parmi543déclarations. Chaque ligne est reliée au lookup,àla registration,àla garde factory==null etau corps de factory exact. Ces affectations ne sont pas des dimensions de la fenêtre ClientWindow.
Le mécanisme source montre que CSSStyleDeclaration construit des objets de factory/prototype puislit overrides,factory etdefaultFactory ;le this de la factory n’est pas assimilé au NativeWindow. L’initialisation est gardée par _StylesInit_done,etune factory déjà présente n’est pas remplacée par ces blocs. Aucune valeur effective n’a été calculée.
Trois carriers de CSSStyleDeclaration/StyleManager/StyleManagerImpl sont conservés séparés :ClientWindow.dat,Flex3 etFlex4. Les traits public::setStyle etmx_internal::setStyle sont distincts ;l’ancien index conflatait ces noms. Le nouvel index préserve namespace etportée sans modifier les sources natives.

## Consommateurs etlimites
La recherche nouvelle est bornée aux9139fichiers AS recensés :620lectures littérales de propriétés,56liaisons styleName pour19alias etleurs types déclarés candidats. Les56liaisons ont une trace de type/receiver oudescripteur ;ce ne sont pas des instances ouproviders exécutés. Les sélecteurs de type Tree etTextInput etles liaisons calculées restent distingués des styleName littéraux.
buttonHeight a un consommateur réel malgré zéro getStyle("buttonHeight") littéral :ButtonBar stocke la clé dans buttonHeightProp etlit getStyle(buttonHeightProp). Les deux variantes conservent les gardes enfant absent,hauteur explicite etdimensions disponibles. Il n’y a donc pas de source manquante démontrée pour cette lecture.
Le sélecteur .browser est affecté àun Canvas du descripteur d’InternalBrowser,distinct de son enfant HTML. La lecture exacte de son borderWidth reste indéterminée. Les chaînes borderWidth d’objets de dessin CartesianDataCanvas/PolarDataCanvas sont exclues de cette liaison CSS. Aucune conclusion «inutilisé» ou«sans effet» àpartir de la seule absence littérale.
Les sources actuelles de configuration/CSS/HTML etleurs80règles sont réutilisées,avec leurs identités ;aucune équivalence sémantique auxstyles AIR ou mesure de rendu n’est inventée. Les sources natives peuvent dépendre de cascades,skins,thèmes,fonts,états etdomaines non observés.

## Contrôles
17sources de mécanismes,53fenêtres et14cas de contrats source ;parsing des543blocs etrattachement des68lignes ;identités des9139entrées etlignes des requêtes primaire/supplémentaire ;namespace,types déclarés etbornes. Relecture indépendante requise avant sélection. Aucune exécution/simulation AS,AIR,jeu,getStyle natif ouchaîne de styles.
Deux erreurs de préparation sont conservées :V2fusionnait deux namespaces setStyle ;un contrôle littéral attendait if(overrides) alors que Flex3 écrit if(Boolean(overrides)). Les fenêtres exactes sont conservées etles contrôles corrigés ;aucun code natif ouproduit modifié.

## Restes etreprise
Les effets actifs de borderWidth,de la cascade etdes skins/providers restent ouverts avec question etreprise précises. Les autres clauses de bootstrap etles51familles ne sont pas clôturées. Aucune tâche de registre oufonctionnalité du jeu terminée sur cette livraison.
Les corrections réutilisent SYS-18.1-06 / OLU-5383e436-013f-575c-bf97-03f832c95163. Ne pas répéter les recherches littérales inchangées sans nouvelle piste de receiver,transfert de propriété ou source.
Prochaine livraison003 :CHROME-FAMILY-LAYOUT-STATE-01,contrats propres àla famille chrome avec thèmes/états/ressources etconsommateurs réels. Les critères du lot complet restent inchangés.

## Écritures
Ajouts immuables uniquement dans F:\OpenLeague-work\audit-units\AUD-18.1-06-FAMILY-LAYOUT-STATE-COVERAGE-01 etce rapport,avec préparations E. Livraison001 etspécification racine conservées. Aucun goal,critère,registre,produit,Plan,base,case,historique,installation,migration,relance,HTTP,nouvelle décompilation,pixels oumédia modifié/exécuté.
