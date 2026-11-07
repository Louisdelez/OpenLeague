# SYS-18.1-06 — extensions et composants enfants du cadre AIR (006)

2026-11-02T05:19:04.820386+00:00

## Résultat clôturable
Les 55 queues optionnelles sont entièrement consommées : 36 filtres Glow, 10 DropShadow, six ColorMatrix, deux listes vides et deux modes overlay. Aucune application sur des pixels. Les paramètres bruts, offsets, bit patterns float32 et flags sont conservés ; zéro anomalie de métadonnées parmi les clauses vérifiées.
Les clauses propres aux composants enfants sont reliées à 14 sources admises, 91 fenêtres exactes et 24 cas de contrat source. Les wrappers AudioButton/ScalingButtonX, les états ButtonX et deux producteurs du modèle sont inclus. Trois contrats core déjà audités sont réutilisés.

## Comportements établis dans les sources
- Nom d’invocateur : largeur disponible mémorisée, réduction uniforme si le texte déborde, recentrage vertical ; largeur de glyphes et dimensions réelles non calculées.
- Icône : taille explicite issue du hitAreaClip, ratio conservé et smoothing configuré. Le niveau 30 remplit la jauge XP ; sinon elle suit le pourcentage fourni.
- Ticker : hauteur bornée par le sizer et la mesure du DataGroup ; absence de mesure délègue à la base. Un setMessages vide conserve la visibilité dans cette méthode ; le reaper à 150ms peut ensuite masquer la liste vide. Aucune fusion de ces deux comportements.
- Messages : sélection masque ou montre corps/fond et choisit plus/minus ; hauteur développée calculée depuis le corps, hauteur repliée issue du titre. Traduction manquante → contenu fourni. Entrée non BroadcastMessage → retour avec data null, sans effacement du texte inventé.
- File : six états de timeline conservés, correspondant aux états source ; visibilité Home issue du modèle. Shutdown et états de flux peuvent désactiver Play. ButtonX désactivé arrête la propagation immédiate du clic dans son handler.
Les données natives confirment les labels des cinq enfants directs par thème. Un label non présent dans un skin ne prouve pas un défaut ni une disponibilité publique. Les données de services, domaines et fonts restent des entrées non observées.

## Vérification
Les six schémas d’extensions présents sont vérifiés et dix refus sont observés : troncatures, suffixe résiduel, type hors périmètre, flags non qualifiés et clip actions refusées. La relecture indépendante utilise un second parcours des champs. Tous les cas AS sont des vérifications de clauses, pas des scénarios exécutés.
Référence primaire pour les nouveaux champs : [Adobe SWF19](https://open-flash.github.io/mirrors/swf-spec-19.pdf), PlaceObject3/FILTERLIST et filtres réellement présents. Aucun asset, archive ou document complet téléchargé.

## Restes et reprise
- CHROME-LIST-TEXT-LAYOUT-DEPENDENCIES : Own child formulas and native states are qualified;DataScroller/DataGroup/Text and Blix vertical/virtualized layout algorithms behind measured dimensions remain unreviewed in this unit. Sources are present and named. Reprise : Use the five exact dependency source records and ticker/message/alert call windows. Review only relevant layout,measurement,truncation and active algorithm selection. Reuse TextFieldProxy/ScalingTransformBehavior/LayoutContainerView core evidence.
- CHROME-NATIVE-SKIN-AND-RUNTIME-STATE : ButtonX can select seven labels while a particular skin may define a subset. Native frame labels and own source states are linked,but effective fallback,active domain/provider/font/locale,external inventory/messages and rendered bounds remain unobserved. Reprise : Use exact state/skin rows,existing timeline-transition contracts and inherited runtime comparison conditions. Do not claim missing skin or working service from literal presence/absence;runtime fidelity work remains separate.
Prochain lot : les cinq dépendances exactes de liste/texte/layout, le renderer dynamique et le driver d’alertes, puis revue des critères complets de chrome. La famille, le parent et le jeu ne sont pas déclarés terminés. Les limites antérieures sont conservées avec la précision que les 55 queues ne sont désormais plus opaques.

## Consommateur et écritures
Le launcher courant reste le menu de préparation et son en-tête statique déjà recensés. Aucune nouvelle requête globale, aucun scénario ancien rejoué. SYS-18.1-06 et OLU-5383e436-013f-575c-bf97-03f832c95163 réutilisés, sans création ou modification de tâche normative.
Ajouts documentaires et scripts de lecture statique uniquement. Goal, critères, registres, produit, application de suivi, interface et bases inchangés ; aucune installation, migration, relance, nouvelle décompilation, exécution AS/AVM/jeu, application de filtres ou rendu.
