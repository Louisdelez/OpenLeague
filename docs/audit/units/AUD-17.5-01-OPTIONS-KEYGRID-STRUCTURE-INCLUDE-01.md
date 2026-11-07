# Structure des raccourcis et frontière d’inclusion

## 1. Portée et dimensions

AUD-17.5-01-OPTIONS-KEYGRID-STRUCTURE-INCLUDE-01,goal SYS-01.2-02,parent SYS-17.5-01.21nœuds structurels et1déclaration include ;aucun contenu inclus inventé. Audit des associations/frontière clôturable après relecture. Implémentation du renderer/provider non qualifiée ;vérification documentaire seulement ;acceptation humaine non demandée.157feuilles et13conteneurs acquis sont conservés. Parent et goal ouverts.

## 2. Sources et provenance

LoL4.20,en_GB. FoundryOptionsKeybinds.xml SHA2706bdaa0d68114b5c586c8c111b8e3666ab449d55076f3ea2c07c29b794191e. Matrice par ID/source/octet/ligne/attribut/condition :1data,1textfield,5group,10keysubsection,4keysubsectionsingle et1include. Les14sous-en-têtes sont autofermants,sœurs des bindings,avec6titres explicitement vides. Ils ne sont pas parents d’affectations. Source/factory des4familles enregistrées et sprites vérifiés ;data/include ne sont pas des tags enregistrés directs dans cette factory.

Export AS acquis réutilisé ;nouvelle lecture statique bornée des modèles/vues/labels/colonnes et du chemin auxiliaire d’inclusion. Layout,héritage,getAttrib,admission des factories et contexte déjà audités sont liés par pointeurs/empreintes. Aucun export/désassemblage/exécution.

## 3. Consommateurs et contrat

Groupes/textfield passent par ViewGroup/ViewLabel et applyStyleSheet → Utility.LocalizeText,avec styles/paddings. getAttrib renvoie ATTRIB_ERROR pour chaîne vide/manquante ;ViewKeySubSection efface alors le titre. Les modèles de sous-en-têtes sont de simples UnifBaseModel. Single hérite de la même vue :le sprite double possède txtPrimary/txtSecondary,le simple txtPrimary seul. Le code choisit Set1/Set2 avec les deux champs et Set2 lorsque seul txtPrimary existe. Les libellés en_GB sont Set 1 et Set 2,815/816. Ce choix source n’est pas corrigé par intuition ;le résultat visuel n’a pas été observé. nosublabels=="true" saute l’affectation de ces sous-libellés,il ne prouve pas un effacement complet de tous champs préexistants.

Point de provenance essentiel :XMLDeseralizer charge par URL relative base+filename,met les includes en file,puis remplace leurs enfants par ceux de la racine chargée. pruneIncludeNodes insère ces enfants à la place du nœud include,recopie les attributs non déjà présents sauf filename/children,et retire le nœud. Son callsite loadGameFiles vient de setupGfxPlayer ;il utilise TraceSerializer et DEBUG_ENVIRONMENT. La production passe séparément par InitializationData.xml objet,GameSerializer et environnement fourni. Ce chargeur auxiliaire ne qualifie donc pas le builder/provider natif.

Dans ce code auxiliaire,IO_ERROR évite readData,puis la suite de file/purge continue ;un garde de filename peut retourner avant COMPLETE et le parsing XML n’est pas protégé ici par un catch dédié. Ces branches n’ont pas été exécutées :aucun comportement natif d’optionalité,erreur,sûreté ou repli n’en est déduit. data reste une enveloppe de format dont le traitement natif doit être qualifié ;pas une ligne UI supplémentaire créée arbitrairement.

Include OPT-SRC-c95be605ecb448af,XML181,filename=FoundryOptionsInternalKeybinds.xml,ancêtre game. L’exact fichier voisin DATA/Menu_SC4/FoundryOptionsInternalKeybinds.xml est absent lors du contrôle frais,comme dans la preuve antérieure réutilisée. Ce fait ne lie pas l’URL auxiliaire data/ au chemin physique,n’exclut pas une archive/backend et ne prouve pas que le fichier était obligatoire dans le client public. Contenu,nombre d’actions incluses et expansion native restent inconnus.

Consommateurs actuels :preuves d’entrée/dispatch/menu existantes réutilisées après identité. Nouvelle recherche de5noms précis dans1168sources :aucune correspondance ;recherche de5concepts de tâches :aucune correspondance. Ce résultat borné ne prouve pas une absence globale de primitives/frameworks ou un menu complet. Aucun ancien scan/test/lecteur relancé.

## 4. Attendu,observé et vérifications

Attendu :séparer regroupement,présentation et actions. Observé :21structures,14en-têtes sans enfants,conditions et titres conservés. Attendu :identifier la route include sans transfert de provenance. Observé :parser URL auxiliaire/debug distinct du payload objet de production. Attendu :décrire exactement le manque. Observé :fichier voisin absent,backend/optionalité/contenu non qualifiés.

Contrôles documentaires :XML/factory/sprites/AS,matrice,liens de champs/relectures antérieures,locale,nouvelles recherches et leur reçu0,corpus/protégés/registres/Git avant-après,sorties réelles et relecture distincte. Aucun jeu,natif,AS,Rust,GUI,OS ou réseau exécuté/émulé. Aucun clic,chargement URL,erreur I/O,texte rendu ou sauvegarde déclaré observé. Les anciens cas CPU d’entrée/Game.cfg ne qualifient pas ces structures ou l’expansion de l’include.

## 5. Manques et conditions de reprise

STRUCTURE-NATIVE-TREE :producteur InitializationData.xml,arbre/admission et traitement data réels non qualifiés. Reprise sur builder/provider natif nommé ou schéma local versionné ;conserver la distinction TraceSerializer/debug et GameSerializer/production.

STRUCTURE-INCLUDE-CONTENT :voisin absent,source logique/backend,octets et caractère requis/optionnel inconnus. Reprise sur membre/manifest/backend ou caller/log qui explique ce nom et sa politique,avec provenance/hash si récupéré. Pas de scan global ou contrôle du même voisin répété sans piste nouvelle ;ne pas inventer de bindings internes.

STRUCTURE-RENDER-LOCALIZE :glyphes/styles/paddings/clipping/focus et colonnes réelles non exécutés. Reprise sur renderer/menu autorisé et les21mêmes identités ;vérifier le cas Single/Set2 explicitement.

## 6. Corrections et comptage

Conserver HUD-OPTIONS-ENTRY-01 pour entrée/lifecycle et préalable de source de production,BIND-EDIT-CONFLICTS-01 pour édition/capture,HUD-OPTIONS-KEYSECTIONS-01 pour repli des11sections. Proposition documentaire distincte HUD-OPTIONS-KEYGRID-STRUCTURE-01 :présentation des21primitives,avec sources,critères/refus/preuves/reprise. Aucun duplicata de binding et aucune tâche de récupération d’archive inconnue ajoutée ;le manque d’include est un préalable précisément documenté du menu. Aucun registre normatif modifié.

157feuilles,13conteneurs,21structures et1frontière couvrent les192déclarations physiques connues par leurs livrables documentaires,à confirmer par cette relecture. Ce dénominateur exclut le contenu inclus inconnu ;il ne qualifie ni le menu fonctionnel,ni son provider,ni la couverture des autres fichiers,ni un pourcentage de jeu terminé. L’audit de la frontière ne résout pas son contenu.

## 7. Livraison et suite

F:/OpenLeague-work/audit-units/AUD-17.5-01-OPTIONS-KEYGRID-STRUCTURE-INCLUDE-01/ :spec,collecteur/deux requêtes/reçu,programme/preuve,relecture distincte et reçu réel. Rapport :F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-KEYGRID-STRUCTURE-INCLUDE-01.md. Empreintes émises,codes réels et sept rubriques sont liés par les reçus ;clôture documentaire limitée aux21associations et à cette frontière.

Goal,critères normatifs,suivi,bases et logiciels gelés ;aucune installation,migration ou retrait. Prochain lot MENU-RECONCILIATION :129nœuds physiques du fichier Menu et livrables possédant réellement chaque source,en gardant distincts les192nœuds Keybinds et36Phreakspace. SYS-17.5-01 et SYS-01.2-02 restent ouverts.
