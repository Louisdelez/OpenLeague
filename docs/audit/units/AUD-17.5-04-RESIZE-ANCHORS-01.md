# AUD-17.5-04-RESIZE-ANCHORS-01

## Résultat et portée

Tâche SYS-17.5-04 : **audit borné des chemins de redimensionnement prêt pour relecture**. Les 15 cas ci-dessous sont des confrontations de sources, pas 15 transitions exécutées. La qualification complète du cycle natif et du rendu reste ouverte. Aucun code produit, goal, critère normatif, Plan, UI ou base modifié.

Audit ≠ implémentation ≠ vérification graphique ≠ acceptation humaine. Le reçu de relecture séparé décide uniquement de la clôture de ce sous-audit.

## Contrat réutilisé

La tâche et son instantané sont identiques ; les quatre prérequis du lot D17-SYS-17-5 restent a_faire. Données natives enregistrées : layout 576 cas, bounds 1152, viewport 12. Les dimensions natives sont des champs propriétaire fournis ; le producteur Game et leur relation DPI/physique restent à établir. Les callbacks de polices/textures sont fournis aux frontières, sans preuve de cycle GPU complet.

Le test CPU source décrit 1280×800 → 1920×1080 puis réutilisation des limites. Il n’est pas relancé. Les audits layout, minimap et inventaire sont réutilisés avec leurs identités et observations ; leurs anciens reçus d’exécution autonomes ne sont pas fournis, aucun code 0 historique n’est inventé. Les quatre anciennes captures 1280×800 ne deviennent pas une recette de redimensionnement.

## Consommateurs et ordres

Fenêtre physique → Viewport → StartupHud → Registry → calcul du groupe. Le plugin est enregistré dans main. Panneaux : signature dimensions/facteur fenêtre/scalar/atlas. Polices : SizingSet → MetricsSet → valeurs numériques ; la garde de Metrics teste la hauteur avant de lire Dpi. Valeurs numériques : dimensions/faces.dpi/scalar, avec garde de concordance de hauteur.

La minimap met à jour sa géométrie avant son InputSet ; celui-ci suit l’InputSet inventaire et précède commands. L’inventaire ordonne update_icons avant son input. Ces liens explicites ne prouvent pas une synchronisation globale de tous les widgets.

## Matrice des transitions — lecture statique

### FIRST-VALID

Condition : Dimensions précédentes absentes, fenêtre unique et dimensions non nulles.

Attendu dans le code : Appeler refresh_bounds puis mémoriser les dimensions seulement sur succès.

Observé dans les sources : La première visite ne force pas le bit dirty ; les gardes propres à chaque groupe restent applicables.

Limite/reprise : La population initiale et la validité des groupes ne sont pas déduites de ce seul appel.

### VALID-CHANGE

Condition : Dimensions précédentes présentes, dimensions physiques différentes et non nulles, calculs réussis.

Attendu dans le code : Marquer les groupes non vides puis rafraîchir ; avancer le marqueur après succès.

Observé dans les sources : Ce chemin est visible et le test CPU existant décrit 1280×800 → 1920×1080 ; ce test n’a pas été relancé.

Limite/reprise : Aucune transition OS, capture fraîche ou qualification de tous les widgets.

### UNCHANGED

Condition : Même paire de dimensions physiques.

Attendu dans le code : Retour du viewport avant refresh_bounds.

Observé dans les sources : La garde ne compare ni DPI ni scalar. Les autres consommateurs ont leurs propres signatures.

Limite/reprise : Ne prouve ni absence de travail dans les autres systèmes ni validité globale des caches.

### ZERO

Condition : Une dimension vaut zéro.

Attendu dans le code : Retour du viewport sans enregistrer zéro ni salir les groupes par ce chemin.

Observé dans les sources : Le marqueur précédent est conservé ; le retrait ViewTarget est une demande conditionnelle distincte.

Limite/reprise : Les autres consommateurs et la libération GPU effective ne sont pas qualifiés par ce retour.

### RESTORE-SAME

Condition : Après un épisode zéro ignoré, retour à la dernière paire mémorisée.

Attendu dans le code : La garde inchangée du viewport retourne.

Observé dans les sources : Ce chemin ne force pas à lui seul une reconstruction des limites ; les ressources rendues ont des cycles distincts.

Limite/reprise : Observer une minimisation/restauration réelle avec la politique native ou locale explicitement admise.

### RESTORE-DIFFERENT

Condition : Après zéro ignoré, paire non nulle différente de la dernière paire mémorisée.

Attendu dans le code : Reprendre le chemin de changement de dimensions.

Observé dans les sources : Dirtying et mémorisation sur succès sont conditionnels aux gardes et au résultat de refresh_bounds.

Limite/reprise : Ce résultat est déduit du code ; aucune restauration OS rejouée.

### BOUNDS-FAILURE

Condition : Un changement ultérieur échoue sur la résolution ou le calcul d’un groupe.

Attendu dans le code : Le marqueur des dimensions reste ancien ; le groupe fautif ne valide pas son cache local.

Observé dans les sources : Des bits dirty ont déjà été posés et les groupes antérieurs peuvent avoir été validés avant le ? de la boucle. Aucun rollback global n’est établi.

Limite/reprise : Conditionnel : aucun défaut de ressource ni échec réel de cette transition n’est affirmé. Nommer la politique de conservation et un scénario fautif.

### WIDTH-ONLY

Condition : Largeur physique différente, hauteur physique inchangée.

Attendu dans le code : Le viewport et les signatures dimensions peuvent changer ; pas de rechargement des polices par leur seule garde de hauteur.

Observé dans les sources : Sizing et metrics utilisent la hauteur ; les panneaux et valeurs numériques incluent les dimensions.

Limite/reprise : Ne prouve pas que les rectangles visibles ou zones cliquables suivent correctement.

### HEIGHT-CHANGE

Condition : Nouvelle hauteur physique.

Attendu dans le code : Sizing précède Metrics, qui précède les valeurs numériques.

Observé dans les sources : Les sets et after établissent cet ordre explicite ; les métadonnées et faces ne sont remplacées qu’après réussite de leurs préparations.

Limite/reprise : Aucun ordre global simultané de tous les consommateurs du HUD n’est déduit.

### DPI-ONLY

Condition : Changement de facteur de fenêtre ou de DPI effectif, hauteur physique inchangée, faces.height déjà égal à sizes.height.

Attendu dans le code : Distinguer invalidation des panneaux et cache des polices.

Observé dans les sources : La signature des panneaux contient window.scale_factor ; Metrics retourne avant de consulter Dpi. Le texte numérique signe faces.dpi, pas directement le facteur de fenêtre.

Limite/reprise : Limite conditionnelle du chemin inspecté, pas panne OS démontrée : établir la relation DPI système/facteur fenêtre et une transition admise.

### SCALAR-ONLY

Condition : Scalar changé alors que les dimensions mémorisées ne changent pas.

Attendu dans le code : Distinguer garde viewport et signatures graphiques.

Observé dans les sources : Le viewport retourne sur dimensions identiques ; panneaux et valeurs numériques signent scalar. Le producteur de réglage scalar reste non qualifié.

Limite/reprise : Ne pas inventer une commande utilisateur ou un défaut effectif ; réutiliser HUD-LAYOUT-SCALAR-01.

### PANEL-FAILURE

Condition : La collecte des payloads de panneaux échoue après entrée dans update.

Attendu dans le code : Retour avant remplacement des entités et avant mise à jour de la signature.

Observé dans les sources : Les anciennes entités/signature ne sont pas retirées par cette branche.

Limite/reprise : Ce comportement de trois cadres statiques n’est pas la politique native de tous les contrôles.

### TEXT-FAILURE

Condition : Valeurs/session valides jusqu’à la garde de hauteur ; comparer garde et erreurs de payload/reconcile.

Attendu dans le code : Distinguer retour anticipé conservant les glyphes et appel ultérieur à clear.

Observé dans les sources : Hauteur/faces non concordantes : retour sans clear par cette garde. Erreur payload/reconcile : clear retire les glyphes et remet la signature à None. Des gardes plus précoces peuvent déjà appeler clear.

Limite/reprise : Retrait demandé et réconciliation source ne prouvent pas à eux seuls une libération GPU ou un rendu cohérent.

### INPUT-GEOMETRY

Condition : Événement de taille ou facteur sur la fenêtre surveillée.

Attendu dans le code : Annuler les gestes/pointeurs concernés et respecter la géométrie avant les entrées.

Observé dans les sources : Minimap invalide le lot ; inventaire marque focus_lost et efface le point. Des ordres explicites géométrie/entrée/commande existent.

Limite/reprise : Les deux audits d’entrée sont réutilisés ; pas de preuve native globale ni de nouveau geste OS exécuté.

### SURFACE-CLEANUP

Condition : RenderApp présent, ViewTarget sans ExtractedCamera.

Attendu dans le code : Programmer le retrait de ViewTarget avant create_surfaces.

Observé dans les sources : Commands.remove est explicite sous PrepareViews ; la présence du plugin est vérifiée dans main.

Limite/reprise : Retrait différé demandé seulement ; pas une preuve de destruction du swapchain, de restauration réussie ou de cycles natifs complets.

## Précision ajoutée aux preuves antérieures

HUD-RESIZE-PARTIAL-STATE-01 : le rapport layout, ligne 66, disait « une erreur de rafraîchissement conserve l’état précédent ». Le marqueur de dimensions est conservé, mais aucun rollback global n’est établi : dirtying avant l’appel, puis validation groupe par groupe ; une erreur ultérieure peut laisser les groupes antérieurs mis à jour. Le groupe fautif ne valide son propre cache qu’après succès. Aucune erreur réelle n’a été déclenchée. Ancien rapport et critères conservés.

La précision HUD-VIEWPORT-UNIT-PROVENANCE-01 du lot précédent est conservée : dimensions natives fournies ≠ provenance physique OS qualifiée.

## Manques et conditions de reprise

- **RESIZE-NATIVE-LIFECYCLE** — Le transfert natif réutilisé prend les dimensions Game fournies et les appels de redimensionnement police/texture à leurs frontières ; le producteur amont, les corps de cycles ressources et la politique erreur/invalidation complète restent non qualifiés. Reprise : Une source/capture existante nommée reliant Game20328/2032C, unités/DPI et callbacks/cache à la transition retenue, ou un contrat local versionné explicitement admis. Réutiliser HUD-LAYOUT-RESIZE-LIFECYCLE-01 et FAILURE-STATE-01.

- **RESIZE-CACHE-POLICY** — DPI seul à hauteur inchangée, scalar seul et états partiels après erreur ne sont pas qualifiés face à une politique native ou locale admise. Les gardes et ordres réels sont identifiés, pas leurs résultats OS/rendus. Reprise : Un contrat de reprise/invalidation nommé pour une transition à la fois, producteur du réglage identifié, puis travail produit autorisé et preuve nominale/refus correspondante. Réutiliser DPI-01, SCALAR-01 et FAILURE-STATE-01 ; ne pas rechercher à nouveau sans piste.

- **RESIZE-RENDERED-ACCEPTANCE** — Aucune preuve comparée de redimensionnement OS/GPU complet n’est ajoutée. Les anciennes captures partielles 1280×800 et le test CPU ne qualifient pas cadres, glyphes, régions d’entrée et ressources sur zéro/restauration/DPI. Reprise : Un scénario précis avec versions binaires/assets/sources, contexte natif comparable, DPI et taille avant/après, widgets/rectangles d’entrée nommés et renderer ; fournir ou produire sous autorisation distincte la paire et les refus. Ne pas transférer la qualification des anciens builds dont les sources ont dérivé.

## Corrections et décision

Réutiliser sans changement : HUD-LAYOUT-SCALAR-01, HUD-LAYOUT-RESIZE-LIFECYCLE-01, HUD-LAYOUT-DPI-01, HUD-LAYOUT-FAILURE-STATE-01. Aucune nouvelle correction produit ni modification de registre. Les notes d’exécution sont documentaires et non appliquées.

Sous-audit : clôturable après le lecteur séparé. SYS-17.5-04 complet : ouvert. Fonctionnalité : non qualifiée complète. Acceptation humaine : non revendiquée. Goal global : ouvert. Prochain lot indépendant : AUD-17.5-05-REJECTION-PRIVACY-01 — Afficher les motifs des commandes rejetées sans révéler d’état privé.

## Fichiers et contrôles réellement exécutés

Nouveaux fichiers dans F:/OpenLeague-work/audit-units/AUD-17.5-04-RESIZE-ANCHORS-01/ : spécification, entrées, producteur, preuve, lecteur et reçus. Rapport : F:/OpenLeague/docs/audit/units/AUD-17.5-04-RESIZE-ANCHORS-01.md. Identités, assertions source, données enregistrées, pointeurs et gardes de conservation sont contrôlés par le producteur puis relus séparément. Le nombre final et les codes retour sont dans producer-execution.json et reader-execution.json.

Aucune exécution Rust/native/AS/jeu/GUI/réseau, aucune émulation, capture, installation, migration, accès aux bases ou modification du goal. Aucune ancienne query, lecteur ou test relancé. Les empreintes des cinq registres, 25 fichiers protégés et 1168 sources sont comparées avant/après ; les modifications Git antérieures sont conservées.
