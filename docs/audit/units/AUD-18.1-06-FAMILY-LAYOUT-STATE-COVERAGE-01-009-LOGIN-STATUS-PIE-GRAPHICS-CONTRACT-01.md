# SYS-18.1-06 — géométrie Graphics du statut de file Login (009)

Date : 2026-11-02 (Europe/Zurich)  
Lot documentaire : `AUD-18.1-06-FAMILY-LAYOUT-STATE-COVERAGE-01-009-LOGIN-STATUS-PIE-GRAPHICS-CONTRACT-01`  
Décision : **contrat source local du pie qualifié; famille `login-status` et tâche parente restent ouvertes.**

## Correction du recensement existant

Le census 18.1-06 donne zéro `geometry_hits` pour `LoginQueueStatusPane`. Son motif de détection porte surtout sur `width/height`, coordonnées, `setSize`, `layout`, etc.; il ne couvre pas `Graphics.drawCircle`, `moveTo`, `lineTo` ni `curveTo`. Or la source exacte `LoginQueueStatusPane.as` (source 4.20 admise `mod/lgn/mod_lgn2.dat`, 13 718 octets, SHA-256 `6077771843d12198287e0914c2ef955ac4c47bf843bcabcc808b233a5aa8083d`, index 2356) définit `drawPieGraphics` aux lignes 205–254. Le zéro du census est donc un **faux négatif pour cette géométrie dessinée**; le census original est conservé et ce supplément le corrige pour ce composant.

## Forme et conditions observées dans le code

- Si le contexte `Graphics` est nul, la méthode retourne sans dessiner.
- Le dessin de fond est un cercle noir de centre local `(0,0)` et rayon `15`; le secteur blanc utilise un rayon `14` (retrait d’une unité).
- L’angle cible est `param2 × 2π − π/2`; l’arc est approché par segments `curveTo` avec un pas de `0,2` radian, puis refermé au centre. Ce sont des unités locales de l’API `Graphics`, pas une taille d’écran mesurée; le mapping stage, transformations, clipping et placement du symbole restent inconnus.
- `updateLoginQueueText` transmet son `param1` numérique à `drawPieGraphics`. Les variantes secondes/minutes/heures/indéfinie transmettent aussi ce nombre. L’interface `ILoginQueueView` ne documente aucune plage ou borne pour ce `Number`; aucune validation/clamp n’est présent dans les fenêtres examinées.
- Risque statique à reprendre : si `NaN` atteint l’angle cible, la comparaison `<=` de la boucle ne peut jamais le satisfaire et aucun compteur d’itérations n’est présent. C’est un risque conditionnel; l’origine/plage réelle du paramètre n’est pas établie et aucun cas n’a été exécuté.
- `showLoginQueueView` retarde l’affichage par un timer de 2 000 ms; les états `loginQueue`, `loginQueueInGame`, `loginBusy` et `hidden` déterminent quel écran existe. La géométrie native effective dépend donc aussi du flux et du symbole timeline `positionCheckInDisplay`.

## Vérification ciblée et limites

La fenêtre `drawPieGraphics`, son appel, l’interface et les empreintes de source sont contrôlés dans la preuve 009. Un contrôle motivé par ce faux négatif a aussi recherché les primitives Graphics dans les deux sources du lot Login 008 (`LoginView.as`, `LoginModule.as`) : aucune occurrence de `getGraphics/drawCircle/drawEllipse/drawRect/drawRoundRect/curveTo/moveTo/lineTo/beginFill/lineStyle/Graphics` dans ces deux fichiers. Le résultat 008 reste borné à ces sources et à ce vocabulaire; cela ne prouve pas les dimensions de la scène ou des symboles hérités.

Consommateur actuel inchangé : seule la surface du menu de préparation est identifiée; la fenêtre Tauri déclarée 1200×760 ne fournit pas la géométrie historique ni le rendu Login. Aucun AIR, launcher, jeu, pixel ou asset n’a été exécuté/décodé et aucun produit n’a été modifié.

## Critères de clôture et reprise

1. **Source :** `LoginQueueStatusPane.as`, `ILoginQueueView.as`, `LoginView.as` et `LoginModule.as` sont liés aux entrées exactes du catalogue; la formule de dessin et ses fenêtres sont rehashées.
2. **Cas :** chemin nominal, contexte Graphics nul, paramètre sans borne et risque NaN sont distingués; aucun risque conditionnel n’est présenté comme bug reproduit.
3. **Décision :** le faux négatif est ajouté comme correction documentaire; aucune image, dimension native ou acceptation fonctionnelle n’est inventée.

Reprise : établir la contrainte de `param1` dans sa source d’alimentation réelle; retrouver et comparer le symbole timeline et son emplacement/état; mesurer l’écran dans un hôte 4.20 avec thème, locale, stage, DPI et état connus. Tant que ces entrées manquent, le pie reste seulement un contrat géométrique local. La famille `login-status`, les autres familles et `SYS-18.1-06` restent ouverts.

Preuve et readback indépendants : `family-coverage-proof-009.json` et `delivery-readback-009.json` dans `F:\OpenLeague-work\audit-units\AUD-18.1-06-FAMILY-LAYOUT-STATE-COVERAGE-01`. Aucun fichier du goal, plan, registre normatif, app ou base de données n’a été modifié.

## Supplément — attribution de la source au build exact

Contrôle documentaire du 2026-11-02, limité à la provenance de l’export utilisé ci-dessus. `docs/reference_air_sources/manifest-index.json` identifie le projet `lol_air_client`, release `0.0.1.119`. Les membres présents dans `docs/reference_air_sources/original` concordent en taille et MD5 avec ce manifeste : `lib/ClientLibLogin.dat` (13 450 octets, `79aa34e2b1fafe559d5dac6d430a13c2`), `lib/ClientLibServices.dat` (48 811 octets, `2e8639c651d2a00c5799247ea51221ff`) et `mod/lgn/mod_lgn2.dat` (11 947 octets, `f9bc48ee230e721a36110ce91fc8d363`). Cette concordance établit l’identité interne de la copie d’archives et de son index, pas son rattachement à `PUBLIC 4.20.0.315`, à EUW ni à `en_GB`.

Dans le dossier client original fourni sur D:, `RADS` existe. Son inventaire immédiat contient `solutions/lol_game_client_sln` et les projets `lol_launcher` et `lol_patcher`, sans projet/solution `lol_air_client`. Le déploiement du client de jeu `solutions/lol_game_client_sln/releases/0.0.1.68/deploy` existe, mais les trois membres AIR testés (`lib/ClientLibLogin.dat`, `lib/ClientLibServices.dat`, `mod/lgn/mod_lgn2.dat`) n’y sont pas. Les chemins AIR `solutions/lol_air_client_sln/releases/0.0.1.119/deploy` et `projects/lol_air_client/releases/0.0.1.119/deploy` sont absents. Les projets launcher `0.0.0.227` et patcher `0.0.0.11` ont des déploiements distincts; les trois chemins standard de membres AIR testés y sont également absents. Une recherche récursive bornée à `RADS` sur ces trois noms exacts n’a trouvé aucune occurrence. La même recherche des trois noms dans le reste du dossier client fourni (hors `RADS`) n’a trouvé aucun fichier libre correspondant. Les recherches de noms ne fouillent pas l’intérieur de conteneurs d’archives; aucun autre dossier ou disque n’a été exploré. Ce contrôle borné n’établit pas une absence globale; il confirme que l’export de ce rapport n’est pas relié, par les preuves vérifiées ici, au build exact de référence.

**Portée corrigée :** les observations de code du lot 009 restent des constats sur l’export local AIR `0.0.1.119`; leur attribution au client LoL 4.20.0.315 n’est pas vérifiée. Le lot et le parent restent ouverts pour cette attribution. Reprise seulement avec le membre AIR original et un manifeste ou reçu faisant le lien vérifiable entre sa release, le build `4.20.0.315`, la région et la locale. Aucun comportement AIR, rendu ou code produit n’a été exécuté ou modifié par ce supplément.

## Consommateur actuel OpenLeague — contrôle source borné

Relecture du 2026-11-02 : `launcher/src-tauri/tauri.conf.json` désigne `../web` comme frontend; `launcher/web/index.html` charge `app.js`. Cette page courante est la préparation locale : sélection champion/sorts, ouverture ou jonction de session, état, reprise et abandon. `app.js` appelle `roster`, `play`, `join_local`, `session_status`, `resume_session` et `abandon_session`; `launcher/src-tauri/src/main.rs` enregistre ces commandes. Le scan ciblé des sources `crates/client/src`, `launcher/web` et `launcher/src-tauri/src` ne trouve aucun identifiant ou appel de file de connexion `LoginQueue`/`loginQueue`, `QueueStatus`, `positionCheckInDisplay` ou `loginBusy`. Aucun consommateur actuel équivalent au panneau AIR n’est donc présent dans ces points d’entrée inspectés. Ce constat est une absence bornée dans le code, pas une mesure du comportement d’une application en exécution.

Empreintes des entrées relues : `index.html` SHA-256 `b530673509af41a6708988e0524cd7a69541d228eb80f14ee5e636eb1635dcc1`; `app.js` `f4f58340d72d2bedbf94b88a847a537c2ea7d76594f053d6a5dc4eba1cf64ad6`; `tauri.conf.json` `4d6acf54145f1a3cedcdc3f02e1b8d288a1094dbe8a36c2ac7100a9bad86e358`; `main.rs` `d132e610f9810e1b2bd9d35edd15ccb12d41f6fa8f66a8c59b232f5e6a5e1074`. Aucun frontend ou backend n’a été modifié et aucun test ou lancement graphique n’a été effectué. Ce lien côté consommateur ne remplace pas la preuve de provenance historique manquante et ne clôt ni l’audit global ni la fonctionnalité.
