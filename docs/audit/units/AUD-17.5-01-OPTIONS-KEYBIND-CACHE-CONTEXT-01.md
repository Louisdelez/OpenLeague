# AUD-17.5-01-OPTIONS-KEYBIND-CACHE-CONTEXT-01 — cache de configuration et bindings

Date : 2026-10-31T09:28:43.713251+00:00. Parent SYS-17.5-01, OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46, OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd. Goal SYS-01.2-02 inchangé.

## R1 — Portée et fin

Relier le caller du cache à ses preuves existantes et aux consommateurs actuels. Le lot clôt la **réconciliation documentaire de cette frontière**, pas la sélection historique des bindings ni leur implémentation. Aucune nouvelle exploration récursive ou exécution native n'est nécessaire. Le producteur ne clôt pas sa propre portée : une relecture séparée examine les sept rubriques.

Audit : sources, réutilisation, limites et conditions de reprise établies. Implémentation : primitives partielles, raccord Input non établi. Vérification : sources et reçus contrôlés ; essais anciens non rejoués. Acceptation humaine : non demandée. Parent et goal ouverts.

## R2 — Sources et périmètres hérités

PE original 4.20 SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Le corps `8B0750` et son appel `8B0812→8ACEF0` sont réutilisés depuis DESCRIPTOR. Filename, SSO, borne de copie et statut AL restent ceux des lots clos, sans correction des anciennes preuves.

Huit contrats communs de 2026-10-05 sont identifiés : politique du cache (1080 cas), rechargement (3456), rechargement avec splitter natif (3456), orchestration du constructeur (256), texte par fichiers (60), merge texte (60), séparation de chemin (144), dispatch de ressources (7695). **Les deux ensembles de 3456 cas sont identiques** : le second ajoute une qualification du splitter, pas 3456 scénarios nouveaux. Les autres familles se recouvrent aussi ; aucun total cumulé n'est calculé. Leurs limites datées ne réouvrent pas automatiquement les points qualifiés plus tard.

Le reçu du 2026-10-21 `original-config-cache-execution.json` couvre 668 sélections de skins dans 1336 contextes déclarés, avec hits sans réouverture et rechargements forcés. Ses 390 identités de sources sont vérifiées. Les providers, racines, locale et certaines feuilles sont fournis par le banc ; le montage historique n'est pas qualifié. Ses 1336 profils n'ont **aucun overlay sélectionné** ; ils ne prouvent pas la priorité d'un overlay Input présent. Les scripts historiques portent encore des chemins E : leurs copies F ont les mêmes octets et sont seulement inspectées, sans réécriture ni exécution.

Le reçu texte/locale est réutilisé à sa portée : caller de locale, parser texte et wrapper `8B0630` sous backend déclaré. Ce n'est pas le callback des bindings. Aucun cas nommant Input.ini n'est trouvé dans les huit ensembles, les 668 requêtes de skins ou le cas de référence de locale. Cette recherche bornée n'est pas une absence globale de preuve dans tout le projet.

## R3 — Contrat et consommateurs réels

Le caller pousse le flag **0** à `8B0808`, puis le filename à `8B080A`, avec le manager `ECX=2D84098`, et appelle `8ACEF0`. Le flag zéro ne force pas le rechargement ; une absence ou un objet sale peut tout de même le provoquer. Le nom vient des lectures de défaut/utilisateur déjà qualifiées.

La paire renvoyée fournit objet+4 en premier. Si cet objet manque, ou si `8B01C0` retourne AL=0, objet+0 est consulté. La présence d'une entrée vide peut arrêter ce repli ; AL ne signifie ni sauvegarde ni succès d'I/O. L'ancien banc nomme ces deux pointeurs override/primary, et les snapshots de skins ont des flags `01 00 00` à 148h/149h/14Ah. **Ces flags ne sont pas attribués aux fichiers Input sans observation de leur paire.**

Les contrats communs montrent la composition littérale du chemin de défaut. Exemple ancien observé : `DATA/CFG/defaults/Game.cfg` donne aussi l'argument `data/cfg/defaults/defaults/game.cfg`. Par inférence de la même composition, la requête de défaut Input peut produire `data/cfg/defaults/defaults/input.ini` comme argument secondaire. Ce n'est ni un fichier déclaré manquant ni une lecture réellement observée. La preuve distingue trois exemples Input nominaux, tous étiquetés comme inférences.

`native_config_cache.rs::decide` et `native_config_cache_reload.rs::plan/plan_with_resources` existent. Dans les 1168 fichiers du corpus, leurs noms de modules n'ont que les déclarations de `main.rs` comme références externes littérales. Les fonctions ont leurs tests locaux ; ce constat borné ne prouve pas un raccord au lecteur de bindings. Il ne prétend pas établir un graphe dynamique global.

Les helpers voisins ont de vrais autres callers : `native_filesystem_provider.rs` utilise le dispatch de ressources pour la lecture CRT, et `relic_namespace.rs::register_tga` utilise le splitter. Ces raccords ne constituent pas un cache Input. Le chargeur courant Game.cfg est inspecté ; il lit et fusionne ses textes en dehors de ces modules de cache et peut créer/renommer des fichiers. Il n'est pas exécuté.

Le plan Rust de rechargement refuse un calcul de suffixe négatif par `checked_sub` et ne reproduit pas la copie native partagée de 512 octets. C'est une limite de domaine explicite, pas une équivalence générale démontrée par les tests communs.

## R4 — Attendu et observé

Onze points du caller sont reliés aux instructions existantes ; la relecture redécode ce corps pour contrôler l'association. Les huit reçus sont identifiés, leurs cas comptés sans addition et leur recherche Input reproductible. Les 1336 hits et rechargements sont contrôlés dans la preuve ancienne, pas réexécutés. L'égalité des deux ensembles de 3456 cas est vérifiée par hash canonique.

Quatre recherches de références sont bornées par le corpus, le motif exact et les lignes trouvées. Fragments actuels, harness, sources natives et état protégé sont vérifiés. Aucun nouveau test Rust, x86, AS, rendu, input physique, jeu, réseau ou loader productif. Aucun scan d'archives ni rejeu des profils. Tous les attendus/observés et leurs natures sont dans la preuve.

## R5 — Manques et reprise

- `CACHE-INPUT-MATERIALIZATION` : une requête Input observée, sa paire, ses streams et flags, puis hash/valeur pour `GameEvents/evtCastSpell1`, `GameEvents/evtNormalCastSpell1` et `Quickbinds/evtCastSpell1smart`. Reprise avec un contexte Input versionné et explicite ; réutiliser les contrats clos. Un éventuel banc natif nécessiterait une autorisation distincte, des racines/providers/locale déclarés et l'interdiction du chemin de migration.
- `CACHE-BOOTSTRAP-INPUTS` : racine, mode, droits, providers, mounts et locale historiques. Reprendre seulement sur un nouveau manifeste/contexte primaire ou une observation précise ; réutiliser les recherches RADS et classifieur déjà acquises.
- `CACHE-FAILURE-LIFETIME` : cas Input de dirty/change/force, erreurs d'allocation, exceptions et concurrence. Exiger un producteur ou un cas précis ; conserver les contrats communs et la limite 512 sans rejeu inchangé.
- `CACHE-CURRENT-INTEGRATION` : raccord des helpers au lecteur Input, édition, conflits, save/cancel/restart et dispatch des modes. Reprendre les corrections existantes sous autorisation produit distincte.

Les manques de source ou de contexte restent ouverts, avec impacts et entrées de reprise. Ils ne transforment pas un mécanisme commun qualifié en fonctionnalité complète et ne justifient pas une exploration native sans borne.

## R6 — Corrections et suite finie

Les dix corrections bindings/modes et `HUD-OPTIONS-ENTRY-01` sont réutilisées avec leurs définitions et leur statut proposé, non appliqué. Aucun doublon ni modification normative. Les nouveaux constats précisent leurs entrées et empêchent de confondre helpers, tests et parcours raccordé.

La frontière cache est désormais bornée ; on ne poursuit pas ses callees faute de nouvelle entrée Input. Prochain lot : `AUD-17.5-01-OPTIONS-KEYBIND-CAPTURE-01`, entrée/sortie du mode de capture. `Data.as` donne les callbacks exacts `StartKeybindInputMode` et `EndKeybindInputMode`. Réutiliser les AS exportés et les gates courants ; deux callbacks et leurs frontières directes seulement, sans refaire les recherches filename/cache.

## R7 — Livraison et relecture

Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CACHE-CONTEXT-01\keybind-cache-context-proof.json` ; SHA256 `f11783d154dea66bcd49409f681b08ef92ff9c5ff0828e82d181b811e87f6e45`. Producteur : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CACHE-CONTEXT-01\verify_keybind_cache_context.py` ; fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CACHE-CONTEXT-01\audit-unit.json`. Relecture : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CACHE-CONTEXT-01\verify_delivery.py`, reçu `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-KEYBIND-CACHE-CONTEXT-01\delivery-readback.json` et `INDEPENDENT-REVIEW.md`.

Seuls ces nouveaux artefacts documentaires isolés sont écrits. Les 25 fichiers protégés, cinq registres, 1168 sources et l'état Git restent identiques. Goal, critères, produit, assets, application de suivi, interface, bases et preuves antérieures inchangés. Aucune clôture fonctionnelle, du parent ou du goal ; aucun pourcentage de jeu ou décompte de contrôles HUD ajouté.
