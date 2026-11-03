# AUD-22.1-07-OVF-01 — Débordements des textes de boutique

Date : 2026-10-30T10:57:06.628643+00:00. Parent : SYS-22.1-07. Audit documentaire du module shop_ui et de son constructeur de rectangles ; aucun changement de Goal, de code, d'application ou de base.

## 1. Périmètre et décision

**Audit terminé pour distinguer les contraintes de layout de la détection explicite des débordements dans cette boutique.** Des rectangles, une adaptation au viewport et un défilement sont présents. Aucun contrôle des dimensions réellement occupées par les textes ni diagnostic de dépassement n'est établi dans le chemin inspecté.

| Dimension | État limité à ce lot |
|---|---|
| Audit | Terminé pour construction et mise à jour des textes de shop_ui |
| Implémentation | Layout, échelle et défilement présents ; détection explicite de débordement absente dans le code inspecté |
| Vérification | Partielle : source inspectée ; aucune mesure de glyphes ni reproduction graphique |
| Acceptation humaine | Non demandée |

Le constat ne signifie pas qu'un texte précis déborde visuellement. Il signifie que le mécanisme attendu de détection n'est pas fourni par les contrôles inspectés. SYS-22.1-07 reste ouverte pour sa réalisation et les autres consommateurs.

## 2. Source du contrat et limites historiques

Contrat local explicitement identifié : shop_ui.rs, lignes 223-226, décrit clipping et défilement comme comportement du client reconstruit. Les règles natives exactes de redimensionnement et les payloads complets restent annoncés ouverts. Le présent lot ne transforme pas ces choix locaux en comportement historique 4.20 prouvé.

Les ressources de textes historiques et les preuves V795 sont disponibles et réutilisées dans AUD-22.1-04-RESP-01 et AUD-22.1-07-KEY-01. Elles ne prouvent aucun débordement mesuré. Aucune nouvelle analyse REA n'est justifiée pour constater les limites de ce code actuel. La politique native de texte trop long reste indéterminée.

## 3. Consommateurs et contrôles réellement présents

- `shop_ui.rs:159-163` crée Text, TextFont, TextColor et un rectangle par foundry::px_node. Il n'ajoute pas de contrôle explicite de taille du texte.
- `shop_native_foundry.rs:178-180` fixe position absolue, largeur et hauteur ; les autres champs restent à leur valeur par défaut. Aucune politique de wrapping ou de rognage par défaut du moteur n'est déduite ici.
- Le champ de recherche a un rectangle 457×30, ligne 216 ; le nom sélectionné 228×32, ligne 242 ; les recettes 455×190, ligne 240 ; la description 449×230, ligne 244 ; la notice 570×22, ligne 257. Ces unités sont les valeurs locales de layout, avant échelle.
- Le texte des lignes catalogue utilise 169×48, ligne 234. En mode grille, les enfants non icônes sont masqués par display=None, lignes 382-385 : absence de texte visible en grille ne vaut pas diagnostic de taille.
- Le conteneur catalogue configure Overflow::scroll_y(), lignes 225-226. La molette et la borne de défilement utilisent le nombre de lignes et leurs hauteurs fixes, lignes 360-365, sans mesure des glyphes.
- Les lignes 313-326 calculent une échelle à partir du viewport et du panneau 1170×920. Elles ne comparent pas la taille calculée de chaque texte à son rectangle.
- PresentationUi, lignes 284-295, interroge les rôles et Text, pas des dimensions de texte après layout. Les lignes 419-438 affectent les chaînes ; Notice provient de text_input.error ou connection.rejection, sans branche de détection de débordement dans cette boucle.

Les systèmes sont enregistrés dans main.rs:809,825, constat déjà établi dans KEY-01. Leur affichage n'a pas été exécuté pour cette unité.

## 4. Attendu / observé et vérifications

| Contrôle | Résultat observé | Portée |
|---|---|---|
| Relecture de native_text et px_node | Rectangles fixes, aucun comparateur de taille du texte dans ces fonctions | Inspection statique |
| Relecture des deux modes catalogue | Texte masqué en grille ; rectangle fixe en liste | Inspection statique, pas une mesure d'affichage |
| Relecture du défilement et de l'échelle | Calculs basés sur nombre de lignes et dimensions de fenêtre/panneau | Pas de détection de glyphes coupés ou hors cadre établie |
| Recherche rg dans crates/client/src | Aucun résultat pour ComputedTextBlock, TextLayoutInfo, TextMeasure, TextBounds, TextLayout, LineBreak ou les motifs overflow.*text / text.*overflow | Code retour 1 attendu pour absence de correspondance ; recherche par ces noms uniquement |
| Texte nominal / long / retour à la ligne | Non exécutés graphiquement | Aucun succès ou refus visible inventé |
| Comparaison à la politique native | Non exécutée | Politique historique non qualifiée |

Recherches et lectures limitées au code local, sans build, modification de donnée ou lancement. Aucun test par comptage de caractères ne remplace une mesure de texte rendu. Les contraintes moteur implicites et un éventuel diagnostic sous d'autres noms ne sont pas exclus globalement par une simple recherche de noms.

## 5. Manques établis et inconnues

Il manque dans le chemin inspecté la comparaison explicite entre texte mis en page et zone autorisée, ainsi qu'un diagnostic associé. Il ne s'agit pas d'un asset manquant démontré. La lisibilité réelle des descriptions et des recettes à chaque résolution reste à vérifier. Les autres HUD, le launcher et l'application de suivi sortent de ce lot.

L'inconnue existante OLU-15e65258-ea11-5f9c-97f3-d3f96d67db5f est conservée ; aucun statut ou lien de base n'est modifié. Les constats TR-01 et KEY-01 couvrent d'autres frontières de la même exigence et ne remplacent pas cette vérification.

## 6. Actions précises et reprise

Actions documentaires sous SYS-22.1-07, sans création de tâche dans le suivi :

| Action | Résultat unique / critère de fin | Condition de reprise |
|---|---|---|
| OVF-MEASURE-01 | Identifier le vrai point de mesure après layout et comparer taille occupée/zone autorisée pour recherche, nom, recette, description et notice ; produire un diagnostic avec rôle, locale et dimensions. | Réalisation fonctionnelle autorisée ; contrat local de diagnostic explicitement défini, politique native distinguée si elle reste inconnue |
| OVF-VERIFY-01 | Vérifier nominal, texte long et retours à la ligne en liste ; vérifier le masquage attendu en grille ; vérifier 1280×800 et 1920×1080. Fin : attendu/observé, ressources et binaire identifiés, mesures et captures réelles, aucun dépassement ignoré dans les cas couverts. | Après OVF-MEASURE-01 ; rendu réel accessible. Pour en_GB/fr_FR dynamiques, raccordement des textes à la locale nécessaire, constat RESP-01 |
| OVF-NATIVE-01 | Qualifier la politique native d'un widget précis avant d'en revendiquer la fidélité. Fin : source ou observation native identifiée et comparaison limitée au widget/cas. | Nouvelle piste native sur le widget choisi ; aucune répétition de l'analyse du chargeur de polices |

Aucune correction réalisée : la demande actuelle autorise cet audit documentaire. Les comportements existants de défilement et de grille doivent être conservés lors d'une éventuelle correction.

## 7. Livraison et relecture

Fichier source supplémentaire vérifié : `crates/client/src/shop_native_foundry.rs`, 16741 octets, SHA256 fcc74ead14aa40b3f6ead4042232f89b396ce3611a07e9ce4e17ecee26a4d199. Identité shop_ui.rs inchangée : 36049 octets, SHA256 cf7405045e6541866543c447b31aef33730ef6c11d2eb6b275387fbb27adcfc1. Sources et preuves complémentaires : les deux comptes rendus KEY-01 et RESP-01 de cette session, sans copie volumineuse.

Seul ce compte rendu est créé pour cette unité. Aucun binaire exécuté, aucune base ouverte, aucune installation/migration. Les sept rubriques sont couvertes pour la frontière annoncée. Audit clos ; fonctionnalité de détection non déclarée terminée ; comportement visuel non certifié ; parents conservés ouverts.
