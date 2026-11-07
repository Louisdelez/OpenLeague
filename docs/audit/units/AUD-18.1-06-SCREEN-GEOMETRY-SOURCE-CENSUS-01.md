# SYS-18.1-06 — recensement des sources de dimensions/ancrages

2026-11-02T02:32:42.975282+00:00

Recensement source fini,sous réserve de sélection du lecteur indépendant. Le parent SYS-18.1-06 reste ouvert : contrat de fenêtre/scaling/ancrages et comparaison effective non terminés.

## Résultat
51familles de référence et788composants indexés sont conservés,soit793sources communes/propres et cinq dépendances supplémentaires :798fichiers qualifiés,6310références géométriques,aucune erreur de catalogue de méthodes. Les51familles ne sont pas51écrans réellement observés :15source_defined,28service_dependent,cinq feature_gated,un region_or_partner_gated et deux internal_or_hidden.
Les propriétés/littéraux,expressions,getters et métadonnées sont reliés à leurs fichiers/méthodes ; un nombre déclaré ne devient pas une mesure de composant. Une classe sans ligne correspondant au motif n’est pas déclarée absente ou de taille zéro. Les sources de skins/timelines peuvent porter d’autres géométries.
LolClient déclare1280×800,TOP_LEFT/NO_SCALE. BaseShell déclare1280×800 etminimum1024×640 ; WindowConstants déclare les points1280×800,1152×720,1024×640 et un ratio1.6. updateDisplayList affecte scaleX/scaleY depuis largeur de nativeWindow/largeur de référence. Ces expressions ne sont pas exécutées.
Deux carriers natifs de mx.core.WindowedApplication restent séparés. Le descripteur du bootstrap ne donne pas de largeur/hauteur ; son resizable=false ne résout pas à lui seul le contrat de la fenêtre shell avec ses cinq poignées. Le choix de provider/domain et les coordonnées effectives restent à qualifier.

## Consommateur actuel
Le launcher courant déclare1200×760 dans Tauri et utilise un menu de préparation en grille responsive. CSS,HTML,config et80règles CSS feuilles sont identifiés ; aucune valeur par défaut Tauri absente de la config n’est supposée. Aucun DOM/computed style,DPI ou viewport n’a été mesuré.
Sept images courantes correspondent par octets aux exports retenus ; leurs en-têtes sont lus sans pixels décodés. Six dimensions nominales de bitmap lossless natif correspondent aux en-têtes ; le JPEG restant reste limité à son en-tête/export. Cette liaison ne valide ni pixels natifs rendus,ni placement ou comparaison plein écran.
Le fond chrome128.png a une dimension nominale1280×86 tandis que le CSS l’utilise à83px de haut. C’est une différence de déclarations/ressource à comparer aux règles natives de placement/clipping ; aucune correction automatique vers86px ni panne visuelle n’est déduite.

## Manques et reprise
- AIR-GEO-WINDOW-PROVIDER-AND-SCALE : Bootstrap authoring size,BaseShell declarations and stage/window scale callbacks are known. Effective WindowedApplication provider (two same-FQCN carriers),nativeWindow association,resize/aspect constraints and device scale are not yet qualified as a complete contract. Reprise : Audit WindowGlue,WindowControlsProviderImpl,WindowConstants,BaseShell and both admitted mx.core.WindowedApplication variants with module/dependency context. Preserve source/display units; no provider selection by basename.
- AIR-GEO-COMPONENT-LAYOUT-AND-ASSET-PLACEMENT : 793indexed screen/component source files and geometry lines can be inventoried,but effective Blix/Flex layout,asset/timeline placement,scale9/clipping,theme/state/font/locale effects are not measured from source literals alone. Reprise : Use the family/component/source IDs and exact expressions. Identify actual layout/anchor consumer and admitted asset before measuring a state. A source with no matching lines is not zero-sized or absent.
- AIR-GEO-CURRENT-COMPARISON-AND-CAPTURE : Current Tauri config declares1200×760 and responsive CSS with a preparation menu. No native/current reference capture at matched viewport/DPI/state exists in this audit. Seven raster headers/native export candidates do not prove full-screen geometry. Reprise : Retain current CSS/HTML/config/image identities. In separately authorized visual work,identify native/actual executable,viewport/DPI,locale/theme/state and reference before comparing bounds. Do not change CSS to match bitmap height by assumption.

## Contrôles et écritures
Recensement intégral des indices de familles/composants et sources exactes ; comparaison des hashes/catalogues/ligne-méthode ;14fenêtres racines,dix cas de contrat statique,sept en-têtes et deux refus locaux de métadonnées tronquées. Aucun scénario de jeu ou de rendu exécuté.
Preuves : F:\OpenLeague-work\audit-units\AUD-18.1-06-SCREEN-GEOMETRY-SOURCE-CENSUS-01\air_screen_geometry_data.json,preuve producteur,reçus indépendants et accepted-delivery.json pour la sélection. La précédente clôture documentaire de SYS-18.1-05 reste acquise,avec sa fonctionnalité ouverte ; aucun écart audio n’est arbitrairement transféré au parent géométrie.
Ajouts uniquement : F:\OpenLeague-work\audit-units\AUD-18.1-06-SCREEN-GEOMETRY-SOURCE-CENSUS-01 et ce rapport,plus préparations E. Aucun goal,critère,registre,produit,Plan ou base modifié ; aucune installation,migration,relance,capture,décompilation,nouvelle récupération ou export/pixel décodé.
Prochain lot : contrat fenêtre/scaling/ancrages et ses consommateurs natifs exacts,avec les deux variantes framework et les limites de comparaison actuelles.
