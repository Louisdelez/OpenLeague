# Sections repliables des raccourcis

## 1. Périmètre et dimensions

AUD-17.5-01-OPTIONS-KEYSECTIONS-01,goal SYS-01.2-02,parent SYS-17.5-01. Onze déclarations physiques d’une même famille ;identités,conditions,titres et descendants conservés séparément. Audit documentaire clôturable après relecture ;implémentation du widget appliqué non qualifiée,vérification documentaire seulement,acceptation humaine non demandée.157feuilles et les conteneurs bulk/capture déjà acquis sont conservés. Parent ouvert.

## 2. Sources et inventaire

LoL4.20,en_GB. FoundryOptionsKeybinds.xml SHA2706bdaa0d68114b5c586c8c111b8e3666ab449d55076f3ea2c07c29b794191e. Chaque début/fin/octet et titre est vérifié contre l’index source ;collapsebydefault=true,strategy=input,paddingtop=7 sur les11. Huit ancêtres game,trois replay ;une section ShopEvents,les dix autres GameEvents. Les deux Camera Control ont le même titre mais gardent leurs identités et contextes distincts. Dix clés de titres en_GB sont présentes832..842 ;aucun rendu de glyphes observé.

| Ligne | Identité | Ancêtre | Section INI | Feuilles déjà associées |
|---|---|---|---|---|
| 41 | OPT-SRC-da62cef244b4faba | game | GameEvents | 31 |
| 85 | OPT-SRC-3d9346cdaadd4251 | game | GameEvents | 21 |
| 114 | OPT-SRC-f5cd9979bbcd47fa | game | GameEvents | 7 |
| 124 | OPT-SRC-81c70103299251bb | game | GameEvents | 13 |
| 141 | OPT-SRC-b8cf18938fe00ddf | game | GameEvents | 5 |
| 150 | OPT-SRC-618e2ea86897cf08 | game | GameEvents | 13 |
| 166 | OPT-SRC-0e897805d4c693bd | game | GameEvents | 5 |
| 174 | OPT-SRC-ab2d26ca274f9b6e | game | ShopEvents | 3 |
| 188 | OPT-SRC-43f01c92628d4cc3 | replay | GameEvents | 16 |
| 207 | OPT-SRC-8755cadfdd9ce748 | replay | GameEvents | 22 |
| 232 | OPT-SRC-ecf2c844aa518723 | replay | GameEvents | 6 |

142feuilles descendantes déjà associées,14structures descendantes ;ces nombres décrivent seulement cette famille et ne s’ajoutent pas aux157feuilles. Les deux ajouts tardifs ChampionOnly/ChampSwap sont repris via leur overlay et leurs preuves,aucune ancienne lacune n’est perdue.

Export AS antérieur réutilisé sans export/désassemblage. Nouvelle lecture statique bornée : ViewCollapsibleKeySection,ViewCollapsibleGroup,sprite/bouton,création/layout/héritage nécessaires. ModelCollapsibleKeySection hérite ModelKeySection ;les fragments de conflit et capture déjà audités sont repris par pointeurs. Factory et source GFX sont identifiées dans la preuve ;admission/instanciation réelle non déduites de la seule présence de classes.

## 3. Contrat source et consommateurs

collapsedState commence false pour une instance. Après création des enfants,createAllChildren appelle toggleCollapse seulement lorsque l’attribut vaut la chaîne "true". Ce code bascule l’état,il ne lui assigne pas true :réinitialisations multiples et réouverture de la même instance ne sont pas qualifiées ici. False,absence et valeur autre ne prennent pas cette branche ;ce constat est statique,aucun original exécuté/émulé.

ButtonEvent.CLICK bascule le booléen. Replier retire les vues enfants de spriteInstance,déplier les ajoute ;le tableau d’enfants et les modèles déjà créés sont conservés. Aucun unbind ni écriture INI n’est appelé par cette méthode. Replier n’est donc pas une preuve de désactivation des actions ou d’exclusion du parcours de conflits. Seuls les enfants non nuls issus des factories sont conservés ;les142déclarations ne prouvent pas142vues disponibles.

La vue spécialisée place le footer à la hauteur du bouton si repliée,sinon à spriteInstance.height. La hauteur annoncée est Math.ceil(spriteInstance.height). Event.CHANGE déclenche le layout parent puis sa propagation ;ViewGroupBuilder choisit une stratégie et parcourt les vues. Aucune mesure de pixels,clipping,ordre physique des événements ou timeline du bouton n’est exécutée. Les defaults enabled/visible/toggle/selected/focusable du sprite restent des données authored. Aucun graphicsrc propre sur les11 ;le chemin décoratif facultatif de la classe ne prouve pas un asset manquant.

Les clics enfants sont relayés vers le keygrid/capture déjà audité. Le repli ne remplace pas son protocole Start/End/SetKeybindInputMode. Les conditions game/replay et l’héritage INISECTION/STRATEGY/préfixe sont liés au contrat factory existant ;collapsebydefault ne fait pas partie de cet héritage. Pas de route de sauvegarde de collapsedState dans les méthodes inspectées ;la durée de vie du propriétaire reste ouverte.

Recherche courante nouvelle et bornée :1168sources,trois fragments de noms de famille,6résultats dans4fichiers. Lecture des candidats :1test de conservation des octets Heal,4commentaires sur RenderCommandState pickup et1commentaire du cache audio. Aucun de ces candidats n’est un widget d’options appliqué. Les preuves de vrais consommateurs d’entrée/dispatch et de menu/capture sont réutilisées ;aucune absence globale de comportement dans les frameworks ou dépendances n’est revendiquée.

## 4. Attendu,observé et contrôles

Attendu :11identités sans fusionner les titres ;observé :8game/3replay,ShopEvents distinct,142feuilles existantes,14structures. Attendu :distinguer affichage et configuration ;observé :création avant toggle,add/remove des vues,footer/CHANGE et état d’instance,sans réaffectation. Attendu :qualifier les candidats réels ;observé :les6hits sont hors widget et le raccord appliqué reste non qualifié.

Contrôles documentaires :sources/AS/locale/factory,matrice complète,ownership antérieur,requêtes nouvelles avec reçu réel0,registres/protégés/corpus/Git avant-après,preuves antérieures et relecture distincte. Aucun ancien test/requête/lecteur relancé. Les anciens cas CPU d’entrée/Game.cfg ne prouvent pas le repli/rendu et ne sont pas recomptés. Aucun jeu,natif,AS,Rust,GUI,OS ou réseau exécuté/émulé. Aucun clic,pixel,focus ou sauvegarde durable déclaré observé.

## 5. Manques et reprise

KEYSECTIONS-EFFECTIVE-TREE :arbre/factory/contexte/provider effectifs,disponibilité replay et descendants conditionnels non qualifiés. Reprise sur ces identités et leur contexte nommé ou un contrat local versionné ;pas de nouvelle recherche générique identique.

KEYSECTIONS-LAYOUT-INPUT :géométrie/clipping/glyphes,timeline et focus,ressource absente et repli pendant capture non exécutés. Reprise sur un menu/widget réel autorisé et ses assets/owner,avec avant/après et refus ;conserver le contrat d’édition/capture existant.

KEYSECTIONS-INSTANCE-LIFETIME :pas de route de sauvegarde identifiée dans ces méthodes ;réutilisation d’instance,nouvelle construction et restauration non qualifiées. Reprise sur le propriétaire et sa durée de vie ou une politique locale explicite ;ne pas inventer une préférence Game.cfg/Input.ini.

## 6. Corrections et couverture

HUD-OPTIONS-ENTRY-01 conserve le cycle du menu ;BIND-EDIT-CONFLICTS-01 conserve édition/capture/conflits. La recherche bornée de concepts dans le registre de tâches ne trouve aucune correspondance exacte ;les anciens rapports de conteneurs ne possèdent pas ce résultat de présentation. Une proposition documentaire HUD-OPTIONS-KEYSECTIONS-01 porte sur le widget partagé,avec les11sources explicites et critères nominaux/refus/rendu/durée de vie. Ni11tâches dupliquées,ni nouvelles implémentations de touches/modes/replay. Les critères normatifs et bases ne sont pas modifiés.

Onze associations de conteneur ajoutées aux deux déjà relues :les13portées source de conteneurs de ce fichier ont désormais un livrable documentaire,à confirmer par cette relecture. Les157feuilles restent inchangées. Restent21structures/libellés et1include ;aucun pourcentage de jeu terminé,aucune clôture du parent ou validation fonctionnelle générale n’en découle.

## 7. Livraison et suite

F:/OpenLeague-work/audit-units/AUD-17.5-01-OPTIONS-KEYSECTIONS-01/ :spec,collecteur et ses deux requêtes,reçu réel,programme/preuve,relecture distincte et reçu. Rapport :F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-KEYSECTIONS-01.md. Les fichiers émis,leurs empreintes,sept rubriques et codes réels sont liés par les reçus ;seule la relecture réussie clôt ces11associations documentaires.

Goal,critères normatifs,suivi,bases et logiciels gelés ;aucune installation,migration ou retrait. Prochain lot fini KEYGRID-STRUCTURE-INCLUDE :21nœuds structure/libellés et1frontière include,leurs consommateurs et limites de provider en réutilisant les acquis. SYS-17.5-01 et SYS-01.2-02 restent ouverts.
