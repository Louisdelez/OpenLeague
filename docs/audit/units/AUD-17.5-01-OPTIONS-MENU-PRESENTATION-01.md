# AUD-17.5-01-OPTIONS-MENU-PRESENTATION-01

Date UTC : 2026-11-01T07:28:33.647756+00:00. Goal SYS-01.2-02 ; parent SYS-17.5-01.

## 1. Périmètre et statut

Trois rôles physiques du Menu : un conteneur emblems et ses deux enfants graphic. Audit documentaire prêt pour relecture distincte ; implémentation partielle/non qualifiée, vérification documentaire, acceptation humaine non demandée. Aucun contrôle éditable ajouté ou recompté. Le rendu réel, le parent et le goal restent ouverts.

## 2. Sources et ressources

|Ligne|ID|Rôle|Attributs|
|---:|---|---|---|
|187|OPT-SRC-14965ae79ba2458e|emblems|{"layout": "center"}|
|188|OPT-SRC-f6cc52290838250e|graphic|{"graphicsrc": "korratings12", "onlyshowif": "locale:ko_kr"}|
|189|OPT-SRC-24c9f86482c59197|graphic|{"graphicsrc": "korratingsviolence", "onlyshowif": "locale:ko_kr"}|

Sources identifiées : XML Menu4.20, index physique357nœuds, PE/GFX inchangés et export AS existant. Onze fenêtres nouvelles et bornées qualifient les wrappers, le placement et la clé graphicsrc ; fabriques, groupe et contexte sont réutilisés avec leurs anciennes limites. Aucun nouvel export ou désassemblage.

Les clés swcemblems/korratings12/korratingsviolence correspondent aux classes mcEmblems/mcKorRatings12/mcKorRatingsViolence. Leurs annotations pointent symbol94/symbol185/symbol378 ; SwcPositioningPen porte symbol179 et le champ _emblems. Ces noms sont des sélecteurs d’export, pas des IDs natifs prouvés. Le compagnon /_assets/assets.swf est absent des deux candidats précis de l’export contrôlés ; aucune absence des ressources du jeu natif n’est déduite. Pixels et dimensions restent non qualifiés.

## 3. Consommateurs réels et branches

ModelEmblems et ModelGraphic dérivent d’UnifBaseModel. ViewEmblems dérive de ViewGroup et teste le nombre d’enfants du modèle à l’initialisation ; ce booléen n’observe pas les sprites rendus. Sans enfant, il saute la création du sprite et super.init. Sinon il crée swcemblems et initialise le groupe avec la largeur du sprite et hauteur initiale0. Le layout center sélectionne layoutDefault/startRowCenter dans le code partagé ; aucun centrage en pixels n’a été mesuré.

ViewApplication route ViewEmblems, puis ne le place que si hasChildren ; il reprend x/y du repère _positioningPen._emblems et le rattache à _background. ViewGraphic résout graphicsrc, appelle addChild puis super.init, sans garde explicite contre un sprite nul dans cette classe. La fabrique signale une clé inconnue puis renvoie null ; cela ne prouve ni exception réelle ni refus gracieux observé.

Les deux graphiques déclarent locale:ko_kr. Le prédicat historique sur les tokens est conservé ; aucune admission effective n’est déduite de la région/locale de référence. Les9fenêtres de consumers courants sont revérifiées. Une requête nouvelle de six alias dans les1168sources inchangées renvoie zéro occurrence ; elle n’établit pas l’absence d’un provider graphique générique.

## 4. Attendu et observé

- Trois rôles physiques — attendu : Un conteneur et deux enfants graphiques conditionnels, aucun réglage éditable supplémentaire. Observé : Attributs, parentés et trois identités exacts ; conditions ko_kr et layout center conservés, admission réelle non observée.
- Raccord de ressources — attendu : Noms/classes/annotations identifiés sans convertir les sélecteurs en IDs natifs ou affirmer une absence globale. Observé : Quatre sélecteurs d’export et leurs wrappers liés ; deux chemins de compagnon absents ; GFX original inchangé, pixels et ressources effectives non qualifiés.
- Branches source et limites — attendu : Distinguer enfants du modèle/rendu, branche vide, position et sprite manquant. Observé : Les sources gardent hasChildren et sautent l’initialisation vide ; addChild graphique sans garde nulle explicite, aucun effet ou refus exécuté.
- Consommateur actuel — attendu : Une seule requête nominale nouvelle et réutilisation des consumers réels ; aucune absence générique déduite. Observé : 1168sources inchangées, zéro alias ciblé ; neuf fenêtres courantes vérifiées, parcours graphique actuel non qualifié.

Contrôles réellement exécutés : octets/parentés/attributs, classes/annotations/fabriques et fenêtres héritées, compagnons précis, nouvelle requête, corpus/Git/25fichiers protégés/5registres avant/après. Producteur puis lecteur documentaire distincts ont des reçus et codes réels. Aucun jeu/AS/Rust/GUI/réseau ni émulation, aucune observation visuelle ou nouveau test produit.

## 5. Manques et reprise

- PRESENTATION-CARRIER — Les annotations AS pointent un SWF compagnon absent des deux chemins d’export contrôlés. Résolution des symboles dans le movie natif, pixels et dimensions non qualifiés ; aucune absence native globale établie. Reprise : Carrier/ressource exact et table de symboles nommés, octets/hash ou preuve de rendu autorisée ; garder le GFX original et ses identités, ne pas déduire les IDs natifs des noms symbolNNN.
- PRESENTATION-ADMISSION-LAYOUT — Les modèles admis, le repère, le rendu centré, les dimensions, le clipping et la gestion réelle d’un sprite nul ne sont pas observés. Les deux conditions ko_kr sont des déclarations, pas un état exécuté. Reprise : Provider/environnement/viewport/menu réels nommés et correction autorisée ; zéro/un/deux enfants, clé/asset/repère absent et contexte refusé/inconnu avec attendu/observé.
- PRESENTATION-CURRENT-CONSUMER — Aucune occurrence des six alias ciblés dans le corpus courant inchangé ; l’existence ou l’équivalence d’un provider graphique générique reste non qualifiée. Reprise : Consommateur précis ou exécution distincte de HUD-OPTIONS-EMBLEMS-01 ; conserver les neuf fenêtres existantes et ne pas relancer cette requête sans nouvelle piste.

Les quatre écarts des includes sont conservés par référence, notamment le rejet XML strict Keybinds ligne7/28 et le panneau interne absent au voisin contrôlé. Ce lot ne les résout pas et ne réécrit aucune source historique.

## 6. Correction

HUD-OPTIONS-EMBLEMS-01 est proposée, non appliquée : Afficher le conteneur et ses deux graphiques selon ressources, contexte et disposition qualifiés. Elle réutilise ENTRY/PANELS et les primitives partagées ; aucun nouveau réglage ou critère normatif modifié.

- Les3identités sont reliées à des assets/contextes/consumers nommés ; les cas zéro/un/deux enfants effectivement admis ont attendu/observé et aucune validation de rendu déduite du seul nombre de modèles.
- Le rendu réel qualifie images, dimensions, centre, position/clipping, superpositions et changements de contexte ; aucune activation arbitraire à partir de la locale de référence.
- Clé ou ressource absente, type incompatible et repère absent produisent une erreur/indisponibilité explicite avec preuve ; aucune préférence ou binding modifié par cette présentation.
- Provenance et comparaison des ressources originales ou reconstruites sont identifiées ; l’absence du seul compagnon d’export ne déclenche pas une reconstruction non justifiée.

Reprise : Correction produit autorisée séparément, provider/arbre/assets/viewport nommés ; réutiliser les sélecteurs et classes conservés, sans réexporter ou rechercher globalement à l’identique.

## 7. Livraison et suite

Dossier : F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-MENU-PRESENTATION-01. Preuve menu-presentation-proof.json, scripts audit_menu_presentation.py/verify_delivery.py, reçus producer-execution.json/reader-execution.json, relecture delivery-readback.json. Le lecteur distinct examine les sept rubriques et clôture uniquement les trois rôles documentaires ; le producteur ne s’auto-clôture pas.

Les129déclarations physiques du Menu ont désormais une association de rôle selon la partition67+32+5+19+3+3. Les IDs sont vérifiés sans recouvrement sur l’ensemble exact du Menu ; chaque famille est reliée à son propriétaire documentaire relu, pas seulement à un total arithmétique. Ce n’est ni la réussite du parcours du Menu, ni une qualification des branches ou des assets exécutés, ni un taux de jeu terminé. Les36déclarations Phreakspace restent distinctes. Prochain lot : AUD-17.5-01-OPTIONS-PHREAKSPACE-STRUCTURE-01 avec 5rôles de structure ; les autres contrôles/choix seront traités selon leurs scopes propres.

Goal, critères normatifs, Plan, UI, bases, registres et modifications antérieures conservés ; aucune installation, migration, relance, restauration ou suppression.
