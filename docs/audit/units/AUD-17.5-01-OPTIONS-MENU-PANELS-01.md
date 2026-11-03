# Menu — cinq panneaux et navigation

## 1. Portée et dimensions

AUD-17.5-01-OPTIONS-MENU-PANELS-01,goal SYS-01.2-02,parent SYS-17.5-01. Cinq déclarations panel,leurs onglets dérivés et raccords source. Audit documentaire clôturable après relecture ;implémentation appliquée de navigation non qualifiée,vérification documentaire,acceptation humaine non demandée. Les65préférences et32descripteurs descendants conservent leurs preuves ;aucun enfant recompté. Parent/goal ouverts.

## 2. Sources et provenance

Menu XML SHA4859ef32283b8f22b69c202299ce5240e199cd7cde9f709fa67360d0270470de :panels XML6,10,73,91,159,labels Hotkeys,Video,Sound,Interface,Game. Les cinq IDs/octets/ordre/labels et références en_GB sont vérifiés ;aucune condition propre/ancêtre déclarée pour ces5nodes ne prouve leur admission réelle. L’inclusion Keybinds est un enfant physique de Hotkeys ;son expansion n’est pas comptée comme source Menu supplémentaire.

Factory ModelPanel/ViewPanel/mcViewPanel et route dérivée ModelPanelButton/ViewPanelButton/mcPanelButton identifiées. Le wrapper enregistré par model.stringify et l’alias sprite panelbutton/FoundryPanelButton ont des rôles distincts ;ne pas les confondre. Export AS existant réutilisé,sans réexport/désassemblage. Nouvelle lecture textuelle bornée des méthodes nécessaires et raccords directs ;cycle et capture hérités reliés par pointeurs.

## 3. Contrat et consumers

ModelPanel hérite UnifBaseModel. ModelApplication tente de créer le bouton à partir de la même définition avant super.createChild du panneau :deux résultats de factory distincts,pas une création atomique garantie. ViewApplication conserve les views produites,positionne les panels et attache les relais application/keygrid/datasource ;les hooks sont retirés au destroy.

Les boutons sont construits dans l’ordre du vecteur dérivé,avec ButtonGroup,allowDeselect=false et caption localisée en majuscules. Les getters de matching retournent le label fourni ;la sélection compare ces valeurs exactement. Le header reçoit getName directement à ce site,sans appel explicite de localisation ;cela ne prouve pas une erreur de rendu natif ou la forme déjà traduite du payload de production.

L’initialisation garde children.length>0 puis prend children[0] as ViewPanel et panelButtonList[0]. Aucun garde complet de paire/type/null n’est démontré ici. Le clic retourne si le label courant correspond,sinon parcourt les children typés ViewPanel jusqu’au premier label correspondant ;absence/ambiguïté/types incompatibles non exécutés.

activatePanel ajoute le nouveau à targetPanelIdx,puis retire l’ancien display s’il existe,met le header,appelle activate sur le nouveau et réactive Defaults. targetPanelIdx vient de getChildIndex(_hoverFrame),c’est un z-order,pas un numéro d’onglet/préférence. Aucun appel explicite à old.deactivate,save,undo ou cancelCapture dans cette méthode. L’arbre de modèles/vues reste conservé ;activate peut déclencher des datasources enfants,donc aucune absence globale de mutation n’est déduite du simple changement d’affichage.

La désactivation racine et la capture/Save/Cancel/Defaults sont reliées aux audits existants. Defaults agit sur activePanel ;la navigation n’est pas validation/annulation du journal. Le bouton CLIK émet CLICK avec bubbling dans le chemin de release déjà audité ;ordre physique des MouseDown/Click,ButtonGroup,capture et callbacks reste non observé.

ViewPanel crée background,mask et scrollbar,place les enfants et recalcule sur CHANGE. Scroll visible si columnHeight>=viewHeight ;sinon position0. Le handler SCROLL garde target===scrollbar puis applique -position*(columnHeight-viewHeight)/columnHeight. La molette utilise le signe de delta seulement ;0 prend la branche non positive.600est la constante de page/position et0.3une durée source,ni pixels ni délai mesuré. Aucun clamp complet,dimensions/glyphes/clipping ou traitement des hauteurs nulles n’est qualifié par ces fragments.

Recherche nouvelle1168sources sur7noms de raccord :0hit ;6concepts de tâche :0hit. Cela ne prouve pas une absence globale de framework. Les vrais consumers actuels d’entrée/dispatch/config et les cycles existants sont conservés ;loader migrateur jamais appelé,aucun code produit modifié.

## 4. Attendu,observé et contrôles

Attendu :5sources distinctes avec leurs enfants conservés. Observé :5labels/ordre exacts,65préférences et32choix existants sous les5panels. Attendu :séparer sélection/affichage et lifecycle. Observé :matching exact,new add→old remove→new activate,absence d’appel explicite old.deactivate/journal au switch,et capture/cycle séparés. Attendu :qualifier scroll/gardes sans inventer le rendu. Observé :>=,target et delta-sign source,contraintes de pairing non démontrées.

Contrôles documentaires :XML/locale/factories/AS,matrix,pointeurs et cycles hérités,nouvelles requêtes avec reçu0,corpus/protégés/registres/Git avant-après,sorties réelles et relecture distincte. Aucun ancien lecteur/test/requête relancé,aucun jeu,natif,AS,Rust,GUI,OS ou réseau exécuté/émulé.0cas produit,aucun clic/scroll/délai/capture/sauvegarde réelle déclaré observé.

## 5. Manques et reprise

PANELS-PAIRING-ADMISSION :arbre/owner/factories/assets effectifs et correspondance5boutons/panneaux non qualifiés. Reprise sur arbre/contextes nommés ou contrat local versionné,puis cas vide/panneau/bouton/type/label absent ou ambigu ;pas de nouvelle recherche générique.

PANELS-LIFECYCLE-INPUT :activation,callbacks retardifs,focus/capture/ordre des événements et réouverture réelle non qualifiés. Reprise sur menu/capture/cycles existants et scénarios A→B→A,reclic et callback tardif ;ne pas traiter retrait display comme deactivate/cancel/ack.

PANELS-LAYOUT-SCROLL :géométrie/glyphes/clipping,hauteurs nulles,clamp et molette physique non observés. Reprise sur assets/viewport réels,panneau court/long/hauteur égale,target/delta et ressources manquantes,avec observations séparées des constantes source.

## 6. Corrections et couverture

Conserver HUD-OPTIONS-ENTRY-01,capture,Save/Cancel/Defaults et réglages enfants avec leurs critères/gaps. Une proposition documentaire HUD-OPTIONS-PANELS-01 couvre seulement la navigation commune des5sources,leur pairing et scroll/relai,avec dépendances,refus et reprise. Les gardes manquants ou une politique locale améliorée ne sont pas revendiqués comme comportement historique exécuté ;toute divergence doit être versionnée. Aucun registre normatif modifié.

67associations Menu contrôles,32descripteurs conservés,5associations de panneau ajoutées ;0enfant/contrôle nouveau compté. Restent25rôles physiques :19structures/libellés,3includes,3présentations. Ces décomptes documentaires ne sont ni fonctions complètes,ni pourcentages du jeu ;provider/rendu/parcours et parent restent ouverts.

## 7. Livraison et suite

F:/OpenLeague-work/audit-units/AUD-17.5-01-OPTIONS-MENU-PANELS-01/ :spec,collecteur/requêtes/reçu,programme/matrice/preuve,lecteur distinct et reçus réels. Rapport :F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-MENU-PANELS-01.md. Les sept rubriques/empreintes/codes réellement obtenus sont liés ;la relecture clôt seulement les5associations de panneau.

Goal,critères normatifs,suivi,bases et logiciel inchangés ;aucune installation,migration ou retrait. Prochain lot MENU-STRUCTURE :19rôles data/group/textfield du Menu principal,avec clauses de style/stratégie/cycle existantes. Les3includes,3présentations et36Phreakspace gardent leur propre portée. SYS-17.5-01 et SYS-01.2-02 restent ouverts.
