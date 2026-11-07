# SYS-18.1-06 — contrat de fenêtre, échelle et coordonnées

2026-11-02T02:52:03.895917+00:00

Lot documentaire fini sous réserve de sélection de la relecture indépendante. Le parent SYS-18.1-06 reste ouvert pour layout/placement des composants et comparaison des écrans. Aucune fonctionnalité terminée revendiquée.

## Contrat établi
BaseShell construit WindowControlsProviderImpl avec lui-même et this.nativeWindow, initialise les dimensions avant les événements added-to-stage, puis installe initResizing à applicationComplete. Le contrôleur prend les visibleBounds du moniteur, publie maxWidth/maxHeight, choisit les points 1280×800, 1152×720 ou 1024×640 selon les gardes et centre la fenêtre.
initResizing capture le ratio largeur/hauteur actuel. La constante déclarée 1.6 ne remplace pas cette formule. resizing recalcule bottom depuis afterBounds.width/ratio, assigne bounds, émet RESIZE puis annule l’événement. refreshWindowSize vérifie présence, fenêtre ouverte et état NORMAL. Aucun événement ou calcul natif simulé.
Le contrôleur applicatif beginResize délègue directement à NativeWindow.startResize. Les gardes closed/resizable de la méthode protégée du framework sont distinctes et ne sont pas inventées dans ce délégué. Les huit abréviations du ChromeController et les cinq poignées créées sont reliées au chemin de resize.
Les deux variantes mx.core.WindowedApplication restent distinctes. Leurs méthodes lisent systemManager.stage.nativeWindow avec garde/null, distinguent fenêtre externe/stage via chromeWidth/chromeHeight et bornent les setters de taille. commitProperties diffère : les changements de bornes et leur publication ne sont pas fusionnés. 15 des 16 paires ont un texte identique après la seule normalisation indiquée, sans preuve d’équivalence runtime.

## Provenance et dépendances
Les 38 fragments dependencies.properties ont mêmes SHA-256, MD5 et tailles que les entrées du manifeste AIR 0.0.1.119 ; leurs 110 déclarations correspondent au graphe déjà conservé. mod.win.ClientWindow déclare directement lib.external.dat.flex3.airframework. Flex4 est aussi déclaré ailleurs ; ce lien statique ne prouve pas la résolution historique du domaine.
DependenciesManagerImpl demande les fragments sous lib profondeur 9 et mod profondeur 1, avec blacklist fale/rds ; LoaderContext utilise currentDomain et loadBytes attend payload/téléchargement/dépendances. Aucun filesystem AIR historique, ordre de chargement ou domaine exécuté.

## Espaces et consommateur actuel
Sept espaces explicités : auteur 1280×800 ; fenêtre native externe ; shell uniformément mis à l’échelle ; popup attaché au stage ; zone scale-free sœur du shell ; ancrages Blix conditionnels ; CSS du launcher actuel. Les en-têtes bitmap, la fenêtre externe et le viewport ne sont pas confondus.
La recherche ciblée dans 12 fichiers du launcher actuel ne trouve qu’un WindowEvent::CloseRequested ; aucun handler explicite de resize/DPI n’est établi dans cette portée. Le Tauri actuel déclare 1200×760 et le CSS un menu de préparation responsive. Les valeurs Tauri absentes ne sont pas déduites. Aucun runtime courant n’a été lancé.
Le chrome bitmap de 86 px et la règle CSS à 83 px restent les mêmes faits hérités : ils ne sont pas une panne de rendu démontrée. Les ancrages natifs dépendent de thème, état, modèle et tailles des enfants ; aucun positionnement de toutes les familles n’est revendiqué.

## Contrôles et limites
18 sources qualifiées, 97 fenêtres de méthodes/en-têtes, 31 cas de contrats statiques, trois contrôles locaux de sélection documentaire (unique, ambigu, absent). Les deux refus concernent l’outil d’audit, pas le comportement natif. Sources, fragments, consommateur actuel, anciennes preuves et fichiers protégés sont conservés.
Les erreurs préparatoires de assertions littérales et du petit outil d’inspection sont conservées dans les qualifications avec leurs véritables codes et tool chunks. Aucune publication F issue de ces échecs ; le lot final utilise les expressions natives exactes.
Aucun rendu, DPI, capture, audio/vidéo, exécution/simulation native, récupération HTTP, installation, migration, changement de produit, goal, critère, Plan ou base.

## Restes et reprise
- **AIR-GEO-WINDOW-PROVIDER-AND-SCALE** : Native root source chain is now qualified,including explicit ClientWindow→Flex3 AIR dependency and both framework variants. Effective historical domain/provider,descriptor/nativeWindow resizability,DPI and host events remain unobserved. Reprise : For runtime fidelity work,identify exact AIR executable,applicationDirectory,38qualified fragments and actual load/domain/NativeWindow stage chain plus viewport/DPI and events. Do not choose a provider from filename or direct dependency alone.
- **AIR-GEO-COMPONENT-LAYOUT-AND-ASSET-PLACEMENT** : 793indexed screen/component source files and geometry lines can be inventoried,but effective Blix/Flex layout,asset/timeline placement,scale9/clipping,theme/state/font/locale effects are not measured from source literals alone. Reprise : Use the family/component/source IDs and exact expressions. Identify actual layout/anchor consumer and admitted asset before measuring a state. A source with no matching lines is not zero-sized or absent.
- **AIR-GEO-CURRENT-COMPARISON-AND-CAPTURE** : Current Tauri config declares1200×760 and responsive CSS with a preparation menu. No native/current reference capture at matched viewport/DPI/state exists in this audit. Seven raster headers/native export candidates do not prove full-screen geometry. Reprise : Retain current CSS/HTML/config/image identities. In separately authorized visual work,identify native/actual executable,viewport/DPI,locale/theme/state and reference before comparing bounds. Do not change CSS to match bitmap height by assumption.

## Livraison et prochaine action
Ajouts immuables uniquement dans F:\OpenLeague-work\audit-units\AUD-18.1-06-WINDOW-SCALE-AND-ANCHOR-CONTRACT-01 et ce rapport ; préparations locales E identifiées. Les registres normatifs, cases et historiques restent inchangés.
La correction réutilise SYS-18.1-06 / OLU-5383e436-013f-575c-bf97-03f832c95163 avec comparaison host/DPI/événements explicite dans un travail autorisé distinct. Les clauses layout/ressources/comparaison restent ouvertes.
Prochain lot : AUD-18.1-06-LAYOUT-AND-ANCHOR-CONSUMER-01, contrats réels de layout/ancrage Blix/Flex et liens au recensement ; pas une nouvelle collecte de liens générale.
