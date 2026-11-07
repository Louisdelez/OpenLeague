# QuickBind — boutons globaux normal et rapide

## 1. Périmètre et dimensions

AUD-17.5-01-OPTIONS-QUICKBIND-BULK-ACTIONS-01, goal SYS-01.2-02, parent SYS-17.5-01. Une portée : quickbindlayout OPT-SRC-ed87622f4605b7f6, XML8..31 et ses deux boutons. Audit documentaire clôturable après relecture distincte ; fonctionnalité et parent ouverts. Implémentation actuelle partielle : dispatch et helpers présents, raccord de modes/boutons non qualifié. Vérification documentaire ; aucun cas produit exécuté. Acceptation humaine non demandée.

## 2. Sources historiques et identité

FoundryOptionsKeybinds.xml SHA2706bdaa0d68114b5c586c8c111b8e3666ab449d55076f3ea2c07c29b794191e : conteneur octets292..1538, stratégie input/GameEvents, ancêtre game,13enfants déclarés lignes18..30 : quatre capacités,deux invocateurs,six objets,vision. L’identité source+ID+octets est conservée pour chacun. Huit textes en_GB vérifiés lignes843,855,860,865,867,868,894,895. Les tooltips décrivent l’intention de ciblage ; ils ne prouvent pas le gameplay.

Export AS déjà acquis réutilisé sans export ni désassemblage. Nouvelle lecture statique bornée et annoncée : ModelQuickBindLayout,ViewQuickBindsLayout,mcQBLayout,les deux délégations nécessaires et constantes Data. Les fenêtres et SHA figurent dans quickbind-bulk-proof.json. Les contrats partagés des feuilles et du journal sont liés par pointeurs et empreintes aux preuves existantes.

## 3. Contrat et consommateurs réels

ViewQuickBindsLayout:44..69 attache ButtonEvent.PRESS ; 71..98 ajoute seulement les vues créées non nulles. Les13déclarations et les13sprites ne garantissent donc pas13vues actives. Lignes126..148 : normal appelle setChildrenSmartCast(false),rapide true,puis son. Pour chaque vue créée : retrait du listener parent CHANGE,setSmartCast(choix),setSelfCast(false),réattachement. Le handler agrégé155..157 est vide ; aucune règle d’état mixte des boutons n’est établie par ce handler. Les defaults enabled/visible du sprite ne sont pas une observation runtime.

ViewQuickBindsComponentBase:74..82 délègue au modèle. ModelQuickBindComponent:148..156 passe par changeSmartSelfCast:168..179 : comparaison avant écriture de chaque flag mais émission CHANGE à chaque appel, même sans changement. Ce n’est pas un appel direct à defaultCastOnly. Les listeners des autres observateurs ne sont pas globalement supprimés. Aucune transaction ni récupération d’exception n’est démontrée par cette boucle.

Après les deux appels réussis,les modes source terminaux sont normal=(smart=false,self=false),rapide=(true,false). Les setters ne réaffectent pas les touches GameEvents et ne changent pas HUD/SmartCastOnKeyRelease. Lecture INI : Quickbinds,clé événement+smart/self. Sérialisation frontend : stratégie quickbinds,section=événement,clé smart/self ; le mapping natif vers l’INI reste à qualifier. Journal/undo/serialize et Update existent sur source ; aucune réponse native ni durabilité n’en est déduite.

Consommateurs Rust : les6fenêtres du lot CAST-MODE-PERSISTENCE sont reprises après identité,avec la requête bornée1168fichiers déjà sans correspondance nommée. Aucune requête identique relancée. QWER et dispatch d’objets/invocateurs existants ne qualifient pas le mode global. Le parseur générique peut conserver une clé sans l’appliquer ; son loader potentiellement migrateur n’est jamais appelé.

## 4. Contrôles et attendu/observé

Les contrôles documentaires lient sources,fenêtres,13enfants,textes,configurations,consommateurs,preuves précédentes et sorties réelles. Attendu : deux choix source bornés aux vues créées ; observé : ordre smart puis self=false,comparaisons et notifications ci-dessus. Attendu : préserver source native et fichiers antérieurs ; observé : identités protégées,registres,codex de reprise,corpus et Git contrôlés avant/après.

Configurations fournies : aucun des26flags smart/self dans les defaults natifs ;13flags smart=1 dans chaque configuration deploy/utilisateur,aucun self. Ces valeurs ne prouvent ni l’état effectif ni le défaut général du patch. Les14anciens cas CPU conservent leur périmètre :10helpers d’entrée,1touche objet,3Game.cfg ; aucun n’est un test des boutons globaux ou d’une persistance de mode. Ils ne sont pas réexécutés. Aucun jeu,AS,Rust,GUI,OS,résultat de clic ou échec d’écriture n’est exécuté/émulé.

## 5. Manques et reprise

QB-BULK-ADMISSION : contexte/factory/provider effectifs et disponibilité des13actions,notamment vision,non qualifiés. Reprise sur handler/contexte nommé ou observation autorisée de ce menu précis.

QB-BULK-PROVIDER-SAVE : traduction quickbinds → Input.ini,effet natif et cycle Apply/Cancel/Reset/relance ouverts. Reprise sur consumer Update/GetInput identifié ou contrat local explicite,avec les corrections modèle/édition/provider existantes.

QB-BULK-RUNTIME-FAILURE : raccord courant non qualifié ; échec d’un enfant,type incompatible ou interruption ne possède pas de politique démontrée. Reprise sur implémentation autorisée du seul adaptateur,avec attendu/observé et résultat partiel/refus explicite. Une suppression de listener n’est pas une preuve d’atomicité. Pas de nouvelle recherche générique sans cette entrée.

## 6. Corrections et comptage

Conserver sans modification CAST-MODE-MODEL-01,ABILITY-01,SUMMONER-01,ITEM-01,EDIT-01,RELEASE-01 et HUD-OPTIONS-ENTRY-01. La correction EDIT porte sur une préférence ; elle ne clôture pas ces deux actions globales. Une seule proposition documentaire nouvelle HUD-OPTIONS-QUICKBIND-BULK-01 couvre leur raccord aux enfants admis,préserve touches/release et dépend du modèle/édition/menu existants. Ses critères,refus et conditions de reprise sont dans la preuve ; rien n’est ajouté au registre normatif.

157associations de feuilles déjà acquises conservées,aucune nouvelle feuille comptée. Ce lot couvre un seul conteneur parmi les13encore en attente dans l’instantané précédent ;12autres portées,21structures/libellés et1include restent hors clôture de ce lot. Ce n’est pas un pourcentage de jeu terminé. La couverture passée est conservée dans l’overlay immuable et chaque enfant référence son association antérieure.

## 7. Livraison et suite

Preuve/programme/specification/relecture et reçus : F:/OpenLeague-work/audit-units/AUD-17.5-01-OPTIONS-QUICKBIND-BULK-ACTIONS-01/. Rapport : F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-QUICKBIND-BULK-ACTIONS-01.md. Les reçus lient les empreintes des fichiers réellement émis,les contrôles et codes de sortie du producteur puis du lecteur distinct ; la clôture de cette seule unité relève de cette relecture réussie.

Goal,critères normatifs,application de suivi,bases et logiciel gelés ; aucune installation,migration ou retrait. Prochain lot fini : KEYGRID-CAPTURE,source OPT-SRC-231c8a95f5f24c78,un contrat de capture/conflits de conteneur en réutilisant les sources déjà acquises. Ni ce rapport ni cette lecture ne clôturent SYS-17.5-01 ou SYS-01.2-02.
