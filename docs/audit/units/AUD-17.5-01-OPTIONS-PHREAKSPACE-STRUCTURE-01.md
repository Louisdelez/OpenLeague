# AUD-17.5-01-OPTIONS-PHREAKSPACE-STRUCTURE-01

Date UTC : 2026-11-01T07:37:00.932917+00:00. Goal SYS-01.2-02 ; parent SYS-17.5-01.

## 1. Portée et statuts

Cinq rôles de structure : data, panneau, deux groupes et une ligne de texte. Le fichier compte36déclarations ; les16checkboxes,1slider,1button et13spacers ne sont pas clôturés ici. Audit documentaire prêt pour relecture distincte ; implémentation partielle/non qualifiée, vérification documentaire, acceptation humaine non demandée. Parent et goal ouverts.

## 2. Sources et attributs

|Ligne|ID|Rôle|Attributs|
|---:|---|---|---|
|2|OPT-SRC-2f122b3cc7d6719c|data|{}|
|3|OPT-SRC-6ad931455bb24631|panel|{"label": "Phreak Only"}|
|4|OPT-SRC-cc231dda24e905b8|group|{"label": "Welcome to my top secret room.", "style": "header"}|
|5|OPT-SRC-29f03fd45b88516a|textfield|{"label": "Let's keep it a secret, ok?"}|
|14|OPT-SRC-db5cc9bf0a253640|group|{"layout": "fourPerLine"}|

Le XML4.20 FoundryPhreakspace.xml est identifié dans la preuve (1352octets,SHA256 aeaa868a94dcc6cc224c92c15a0d7b736abdec6427ee1367277d1f4dd9d4a738). Il se parse strictement en36éléments. Les PE/GFX et exports AS antérieurs sont conservés et identifiés ; trois fenêtres nouvelles bornées du builder relient le layout, sans export ou désassemblage.

La condition locale:en_us,summoner:Riot Phreak|summoner:Phreak appartient à l’include du Menu principal, pas à une déclaration propre de ce fichier. La route auxiliaire peut propager un attribut de l’include si l’enfant ne le possède pas ; son équivalence avec le provider de production reste inconnue. L’absence de gate dans ce fichier ne prouve donc pas une disponibilité inconditionnelle. EUW/en_GB ne prouve pas non plus l’état effectif de ce panneau.

## 3. Consommateurs et contrats

Les contrats ModelPanel/ViewPanel, boutons dérivés, ViewGroup/ViewLabel et fabriques sont réutilisés, avec sources exactes. Le titre Phreak Only est une chaîne fournie au protocole commun de panneau. Le groupe header et le texte conservent leurs chaînes littérales ; leur passage au localizer ne prouve pas le résultat affiché. Aucun effet évoqué par les autres intitulés (combat, voix, champion) n’est déduit de la présence des contrôles.

Le premier groupe possède8enfants physiques ; le groupe fourPerLine en possède24, comprenant11checkboxes et13spacers. La branche source fourPerLine délègue à layoutNPerLine avec N4. La cellule vaut Math.floor(maxWidth/N) ; le retour à la ligne utilise positionTracker.x + cellWidth > maxWidth, et non un cap currentRow.length à quatre. La vue est placée avec son padding puis reçoit relayout(cellWidth) ; x avance de la cellule. Une ligne avance selon le maximum height + padding.vertical de ses vues puis remet x à zéro.

Cela ne prouve ni quatre vues par ligne pour toute largeur, ni six rangées affichées à partir des24déclarations. Largeurs nulles/très petites/négatives, enfants admis, tailles après relayout, dimensions et clipping restent non observés. Aucun calcul original n’est exécuté ou émulé.

Les9fenêtres de consumers courants sont reprises et vérifiées. La requête nominale antérieure incluant FoundryPhreakspace.xml reste liée à son code et au corpus1168inchangé ; elle n’est pas relancée et son absence de résultats ne prouve pas l’absence d’un framework générique. Aucun raccord précis du panneau courant n’est annoncé comme terminé.

## 4. Attendu et observé

- Structure36,portée5 — attendu : Cinq rôles exacts sans clôturer les31autres éléments. Observé : XML strict36éléments ; octets/parents/attributs des5vérifiés ; partition5+13+18 exacte et sans doublon.
- Gate externe et labels — attendu : Conserver condition d’include, chaînes littérales et passage de localisation ; ne pas inventer activation ou effet de jeu. Observé : Condition source externe liée au panneau ; primitives communes réutilisées ; admission, texte affiché et actions des contrôles non exécutés.
- fourPerLine — attendu : Source N4 avec cellule floor et wrap par largeur ; aucune garantie universelle de quatre vues par ligne. Observé : Fenêtres statiques reset/hauteur/placement qualifiées ; pas de cap de longueur de ligne au site N, aucune mesure ou simulation originale.
- Consommateurs et reprise — attendu : Réutiliser les preuves inchangées et nommer les entrées manquantes. Observé : 1168sources inchangées,9fenêtres courantes revérifiées, requête historique du fichier conservée sans relance ; trois gaps et une correction de layout précis.

Contrôles réellement exécutés : XML statique, octets/parentés/attributs, partition exacte36IDs, fenêtres nouvelles et champs hérités, corpus/Git/25fichiers protégés/5registres avant/après. Producteur et lecteur documentaire distincts ont scripts, sorties et codes réels. Aucun jeu/AS/Rust/GUI/réseau, émulation, rendu ou test produit nouveau.

## 5. Écarts et reprise

- PHREAK-STRUCTURE-ADMISSION — L’include externe conditionne une structure physique sans propre gate, mais le payload, le provider et l’environnement réellement admis restent non qualifiés. La référence EUW/en_GB ne prouve ni activation ni refus de ce panneau. Reprise : Producteur InitializationData.xml, environnement et arbre effectifs nommés, ou contrat local versionné ; réutiliser les frontières include et les tâches ENTRY/PANELS sans forcer l’activation.
- PHREAK-STRUCTURE-LAYOUT — Les labels, styles et le raccord N4 existent sur source ; traduction, mesures, rangées effectives, clipping et comportement aux largeurs extrêmes ne sont pas observés. Reprise : Menu/renderer/viewport et vues admises identifiés ; reprendre HUD-OPTIONS-FOUR-PER-LINE-01 et auditer les13espaces avant une observation de composition complète.
- PHREAK-STRUCTURE-CONSUMER — Les consumers communs et la recherche nominale du fichier sont repris ; aucun raccord courant spécifique du panneau ou des fonctions évoquées par ses18contrôles n’est qualifié dans ce lot. Reprise : Consumer/arbre précis ou correction produit autorisée ; traiter séparément contrôles et espaces avec leurs attributs/protocoles, sans convertir leurs libellés en mécaniques inventées.

Les quatre inconnues include restent conservées, dont le rejet XML strict du fichier Keybinds ligne7/28 et le panneau interne absent au chemin contrôlé. Elles ne sont pas résolues par cette structure.

## 6. Corrections

ENTRY, PANELS et MENU-STRUCTURE sont conservées sans changer leurs critères ; elles portent les primitives communes, avec ces associations de source comme notes documentaires. Une seule proposition indépendante est ajoutée : HUD-OPTIONS-FOUR-PER-LINE-01, pour le groupe db5cc9bf0a253640.

- Le consumer de groupe réel est nommé et les calculs/retours à la ligne sont comparés à des entrées identifiées ; l’observation visuelle reste distincte de la simple présence de la branche source.
- Les cas 0/1/4/5enfants admis et plusieurs largeurs documentées ont attendu/observé ; aucune promesse de six lignes à partir des24nœuds physiques.
- Espaces, contrôle refusé ou absent, taille inattendue et padding/clipping ont une politique observable ; aucun binding/préférence modifié par la présentation.
- L’admission externe du panneau et les effets évoqués par les labels conservent leurs scopes ; pas d’activation arbitraire ni de mécanique déduite d’un intitulé.

Proposition non appliquée. Reprise : Correction produit autorisée séparément, consumer/arbre/contextes/viewport et espaces qualifiés ; réutiliser les fenêtres conservées sans relancer une recherche identique ni émuler le code original implicitement.

## 7. Preuves, clôture limitée et suite

Dossier : F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-PHREAKSPACE-STRUCTURE-01. Preuve phreak-structure-proof.json, scripts audit_phreak_structure.py/verify_delivery.py, reçus producer-execution.json/reader-execution.json, relecture delivery-readback.json. Le producteur ne s’auto-déclare pas clos ; le lecteur distinct examine les sept rubriques et clôture seulement les cinq rôles documentaires.

Partition36sans doublon : 5structures +13spacers +18contrôles. Aucune conversion en taux de jeu terminé. Les129associations de rôle du Menu restent acquises avec leurs propres limites. Prochain lot : AUD-17.5-01-OPTIONS-PHREAKSPACE-SPACERS-01 pour les13spacers ; contrôles et effets restent séparés.

Goal, critères normatifs, Plan, UI, bases, registres et modifications antérieures inchangés. Aucun logiciel installé, migration, relance, restauration ou suppression.
