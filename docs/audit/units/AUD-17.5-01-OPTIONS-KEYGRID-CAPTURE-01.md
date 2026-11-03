# Keygrid — capture,conflits et sortie de saisie

## 1. Périmètre et dimensions

AUD-17.5-01-OPTIONS-KEYGRID-CAPTURE-01, goal SYS-01.2-02, parent SYS-17.5-01. Un conteneur : OPT-SRC-231c8a95f5f24c78,XML5..244. Audit documentaire clôturable après relecture ;fonctionnalité et parent ouverts. Les157associations de feuilles et le bulk normal/rapide acquis sont conservés. Les11sections repliables,21structures/libellés et1include restent distincts. Implémentation : aides d’entrée/dispatch présentes,éditeur/capture/conflits non qualifiés. Vérification documentaire ;acceptation humaine non demandée.

## 2. Sources historiques et provenance

Référence LoL4.20,en_GB. FoundryOptionsKeybinds.xml SHA2706bdaa0d68114b5c586c8c111b8e3666ab449d55076f3ea2c07c29b794191e,ouverture175,fermeture13873..13883. Attribut propre prependnolabelevents=flash_options_key_name_,sans condition propre/ancêtre déclarée ;cela ne prouve pas l’instanciation effective. Factory ModelKeyGrid/ViewKeyGrid,Sprite générique sans fichier sprite dédié. Export FoundryOptions-AS3 déjà acquis réutilisé,aucun réexport/désassemblage.

Nouvelle lecture statique explicitement bornée : raccords ModelKeyGrid/ViewKeyGrid/KeyBindStateHandler,FoundryOptionsModule/ViewApplication,les deux méthodes de conflit et l’héritage de ModelCollapsibleKeySection,plus constantes Esc/unbound. Les fragments déjà possédés de CAST1 et du journal sont réutilisés par pointeurs et empreintes. Lire un fragment de méthode de section ne clôture pas le widget repliable. Cinq textes en_GB vérifiés805,806,807,809,812 ;affichage/glyphes non exécutés.

## 3. Contrat et consommateurs réels

ViewKeyGrid reçoit le clic de la vue/source de binding. Le même objet de vue et le même slot primaire/secondaire rendent le clic répétitif sans nouvel effet dans cette méthode ;sinon l’ancienne vue termine son mode et la nouvelle sélection est envoyée au modèle. Le statut ModelKeyGridDialogSetText transporte KeybindEventType et KeyGridReference. Tout type différent de BindModeStart termine le mode de la vue ;le modèle ne remet pas pour autant activeBindingModel à null dans ces méthodes.

Le statut Start passe via panel → ViewApplication → KeyBindStateHandler,qui demande StartKeybindInputMode. Cette demande ne positionne pas le drapeau local. L’entrée SetKeybindInputMode {value} passe par le module/vue et son setter. KeybindData {keys,localizedKeys} est transmis au modèle seulement si keybindModeActive et registeredKeyGrid sont vrais. Le callback EndKeybindInputMode est émis seulement si le drapeau est vrai ;il ne le remet pas à zéro dans endKeybindMode. La désactivation du menu force false avant cancel. Ordre réel des callbacks,accusé et arrêt de capture OS restent inconnus.

ModelKeyGrid réinitialise les métadonnées récentes,puis refuse l’absence de binding actif. Une chaîne contenant [Esc] annule avant applyBind ;une réponse false produit Fail. Après applyBind réussi,le parcours de conflits s’exécute,puis Success. Les sections délèguent à leurs enfants directs convertibles en IModelKeyBind,sauf l’objet actif,sans filtre INISECTION explicite dans cette méthode. QuickBindLayout exclut aussi l’objet actif et exige en plus l’égalité INISECTION. Ne pas imposer un filtre uniforme ou une priorité inter-section inventée. L’arbre effectivement admis,les modèles miroirs et l’include restent à qualifier. Aucune atomicité/rollback n’est démontrée.

Unbind applique [<Unbound>] au slot actif et produit Unbound ou Fail. Cancel envoie un statut ;il n’appelle pas serializer.undo. Les contrats applyBind/unbind/journal/Update restent liés à leurs preuves séparées. Les états Interrupted et le helper d’affichage existent ;un producteur effectif de cette interruption n’est pas qualifié ici.

Le helper de fin connu retire le listener stage MOUSE_DOWN,masque les boutons et demande la fin ;succès/désaffectation/annulation ont les paramètres(0,0),échec(1.5,0.3). La branche de type inconnu affiche invalidType,programme hide à5000et demande end sans passer par ce helper :sa suppression du listener n’est pas prouvée par cette branche. Backdrop enlève seulement l’affichage ;ce n’est pas un accusé natif de cancellation. Ces durées et transitions sont des lectures source,aucun délai ni clic observé.

Code courant : les9fenêtres de PERSISTENT-BINDINGS,sa requête bornée1168fichiers et ses5résultats classifiés sont conservés après identité. Les résultats sont des limites/documentations de rebinding,tests de defaults caméra et une mention FLS sans rapport ;ils ne prouvent pas un éditeur appliqué. Les dispatchs QWER/objets,lecteurs et libellés actuels restent partiels. Le loader Game.cfg potentiellement migrateur n’est jamais appelé. Aucune absence globale de comportement dans les dépendances externes n’est revendiquée.

## 4. Attendu,observé et contrôles

Attendu : relier les requêtes de capture à leur entrée d’état sans les confondre. Observé : callbacks Start/End distincts de SetKeybindInputMode et réception gardée des données ;la fermeture force false avant cancel. Attendu : distinguer refus,annulation et conflits. Observé : branches pas d’actif,Esc,apply=false,unbind et ordre apply→conflits ;méthodes de conflit différentes. Attendu : pas de succès gameplay/durabilité par simple statut. Observé : journal séparé et inconnues maintenues.

Contrôles : identités XML/AS/factory/locale,fragments et champs hérités,13anciens cas CPU et sources correspondantes,registres/protégés/corpus/Git avant-après,sorties datées et relecture distincte. Les13cas hérités couvrent9helpers/libellés,1raccourci objet et3Game.cfg,aucun test de capture/conflit/INI durable. Aucun ancien test/requête/lecteur relancé. Aucun jeu,natif,AS,Rust,GUI,OS ou réseau exécuté/émulé. La première lecture Git en sandbox a reçu un refus d’accès ;la lecture autorisée et les contrôles réels du producteur réussissent,sans en déduire un défaut produit.

## 5. Manques et reprise

KEYGRID-CAPTURE-PROVIDER : handlers natifs Start/End,producteur des payloads,conversion touches/modificateurs et propriétaire focus/session non qualifiés. Reprise : callbacks/producteur nommés ou contrat local versionné,puis scénarios autorisés ;ne pas supposer une bascule synchrone du drapeau.

KEYGRID-CONFLICT-ADMISSION : arbre actif,sections GameEvents/ShopEvents,modèles miroirs,include et effets d’une désaffectation d’alias non qualifiés. Reprise : contexte/factory/provider/include effectifs ou politique locale explicite,puis vérification ciblée ;aucun nouveau scan générique identique.

KEYGRID-LIFECYCLE-DURABILITY : éditeur courant,late data,End répété,payload nul/invalide,producteur Interrupted,échec partiel et cycle Apply/Cancel/Reset/relance non exécutés. Reprise : correction existante BIND-EDIT-CONFLICTS-01 et ses dépendances,avec consumer/owner et attendu/observé séparant capture,journal,effet gameplay et persistance.

## 6. Corrections et couverture

Réutiliser exactement BIND-EDIT-CONFLICTS-01 :son objectif possède déjà affectation unique,capture/focus,désaffectation,annulation/reset et politique de conflit/refus. Les nouveaux liens source enrichissent ses notes d’exécution ;ses critères normatifs ne sont pas réécrits. Garder BIND-LOAD-01,SAVE-01,RESTART-01,NATIVE-PROVIDER-01 et HUD-OPTIONS-ENTRY-01 dans leurs périmètres respectifs. Zéro nouvelle proposition :un second objectif « keygrid » ferait doublon.

Une association de conteneur ajoutée,aucune feuille recomptée. Instantané antérieur13conteneurs en attente,puis bulk acquis,puis ce lot ;restent11sections repliables.157feuilles déjà associées conservées,21structures/libellés et1include hors clôture. Ce décompte documentaire ne mesure pas un pourcentage de jeu terminé et ne qualifie pas le parent.

## 7. Livraison et prochaine unité

F:/OpenLeague-work/audit-units/AUD-17.5-01-OPTIONS-KEYGRID-CAPTURE-01/ contient spec,programme,preuve,lecture distincte et reçus réels. Rapport : F:/OpenLeague/docs/audit/units/AUD-17.5-01-OPTIONS-KEYGRID-CAPTURE-01.md. La relecture à sept rubriques,liée aux empreintes émises et aux codes réels,autorise seulement la clôture documentaire de ce conteneur.

Goal,critères normatifs,suivi,bases et logiciels gelés ;aucune installation,migration ou retrait. Prochain lot fini KEYSECTIONS :comportement partagé des11sections repliables,chaque identité/condition/descendant conservé ;les157feuilles et les2conteneurs acquis ne seront pas recomptés. La structure et l’include restent séparés. SYS-17.5-01 et SYS-01.2-02 restent ouverts.
