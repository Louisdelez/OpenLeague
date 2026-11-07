# SYS-18.1-06 — sources géométriques Login sans déclaration mesurable (008)

Date : 2026-11-02 (Europe/Zurich)  
Lot documentaire : `AUD-18.1-06-FAMILY-LAYOUT-STATE-COVERAGE-01-008-LOGIN-ZERO-GEOMETRY-SOURCE-AUDIT-01`  
Décision : **audit borné de présence/absence source terminé**. Aucune dimension d’écran n’est mesurée ou inventée.

## Périmètre et provenance

Le recensement accepté de géométrie liste pour la famille `login` deux sources admises :

| Classe | Source AIR 4.20 | Index source | Composant indexé | Géométrie déclarée/reliée |
|---|---|---:|---:|---:|
| `LoginView` | `review/mod__lgn__mod_lgn2_dat/scripts/com/riotgames/pvpnet/login/LoginView.as` — 38 640 octets, SHA-256 `ddeb9f40f4c4f92efe1ec96f8c64890a8c60329c36e4f71bec3c3e9dcaec9958` | 2357 | 350 | 0 lignes de géométrie |
| `LoginModule` | `review/mod__lgn__mod_lgn2_dat/scripts/com/riotgames/pvpnet/login/LoginModule.as` — 7 143 octets, SHA-256 `889552c6350401309e59b2caab948562a25251a70e73b7517fa6f7c634ae9794` | 2355 | 348 | 0 lignes de géométrie |

Les deux sources sont dans `mod/lgn/mod_lgn2.dat` (11 947 octets; SHA-256 `a7aa5ce03b648bf4de107d1b0f05172f1feacb3ae5792892876c9e7249cbdf60`; entrée de manifeste locale release `0.0.1.119`, MD5 `f9bc48ee230e721a36110ce91fc8d363`). Le recensement n’indique pas d’erreur de décompilation pour ces classes. Leurs bases sont `StatefulView` et `RiotModuleView`; elles ne fournissent pas les dimensions effectives de leurs bases.

## Résultat et cas de contrôle

- **Attendu — source disponible :** les deux définitions et leur carrier 4.20 doivent être identifiés. **Observé :** les chemins, tailles, empreintes, indices et carrier concordent avec le recensement et le catalogue source.
- **Attendu — géométrie qualifiée :** chaque source doit fournir une valeur/algorithme de taille ou position, ou une absence bornée. **Observé :** les deux listes `geometry_hits` sont vides et les deux composants ont `geometry_line_count = 0`; aucun bounds natif n’est mesuré.
- **Refus — inférer une taille nulle ou une absence d’écran :** refusé. Le résultat zéro concerne uniquement les lignes de géométrie propres aux deux classes indexées; il ne prouve pas que l’écran n’existe pas, ni que la classe de base ou les symboles enfants n’ont pas de dimensions.
- **Consommateur courant :** la preuve géométrique existante identifie seulement la surface du menu de préparation dans l’HTML courant. Elle conserve `launcher/web/style.css`, `launcher/web/index.html` et `tauri.conf.json`; la taille déclarée de la fenêtre est 1200×760. Les styles calculés, limites DOM, fenêtre/DPI et rendu natif ne sont pas mesurés. Ces valeurs décrivent le consommateur présent, pas la référence historique Login.

Le contrôle réutilise le census existant et ses conditions de recherche; il ne relance pas le recensement global. Aucun AIR, launcher, jeu ou scénario d’interface n’est exécuté. Aucun pixel n’est décodé.

## Critères de clôture du lot

1. **Source :** les deux sources Login, leur carrier, leurs entrées de méthode et la conclusion bornée « zéro ligne géométrique » sont reliés et rehashés.
2. **Consommateur :** la surface courante et les limites de sa preuve sont reprises; la présence d’une déclaration de fenêtre n’est pas confondue avec la fidélité historique.
3. **Cas, limites et reprise :** la conclusion d’absence bornée, le refus d’inférer zéro écran et les conditions manquantes sont relus indépendamment. Le readback ferme seulement ce lot.

## Restes et reprise

La famille `login` demeure ouverte pour l’apparence, les ressources réellement choisies et les dimensions effectives. Il manque une observation admissible de l’écran dans l’état 4.20 pertinent, avec taille de scène/fenêtre, DPI, locale, thème, domaine, état et chemins de ressources connus. Reprendre alors sur les `LoginView`/`LoginModule` épinglés, leurs symboles enfants et l’état exact de l’hôte; ne pas transformer l’absence de géométrie source en mesure.

`SYS-18.1-06` reste `a_faire`; seule une unité source est close. Le parent géométrie, les 51 familles/788 composants et les autres familles restent ouverts. Aucune mise à jour du goal, du plan, d’un registre normatif, de l’application de suivi ou d’une base de données n’a été faite; aucun produit n’a été modifié.

Preuve structurée et relecture indépendante : `family-coverage-proof-008.json` et `delivery-readback-008.json` dans `F:\OpenLeague-work\audit-units\AUD-18.1-06-FAMILY-LAYOUT-STATE-COVERAGE-01`.
