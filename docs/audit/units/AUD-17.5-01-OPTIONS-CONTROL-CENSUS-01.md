# AUD-17.5-01-OPTIONS-CONTROL-CENSUS-01 — inventaire source des Options

Unité documentaire de SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 / OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd, dans le goal SYS-01.2-02. Datée 2026-10-31T07:35:53.477936+00:00.

## R1 — Portée et sortie précise

Indexer toutes les déclarations des trois XML Options physiques connus et les relier aux enregistrements modèle/vue ainsi qu'aux occurrences de leurs liaisons directes dans le corpus actuel. Ce résultat couvre ces fichiers identifiés, pas tous les contrôles créés/visibles du HUD. Le producteur ne prononce pas sa propre clôture : voir la relecture indépendante `delivery-readback.json`.

Audit : inventaire produit, clôture documentaire soumise à la relecture. Implémentation : aucune modification, équivalence des réglages non établie par cet inventaire. Vérification : statique/documentaire seulement. Acceptation humaine : non demandée. SYS-17.5-01 et le goal global restent ouverts.

## R2 — Sources et provenance

Client original LoL 4.20, solution lol_game_client_sln release 0.0.1.68, DATA/Menu_SC4. Sources brutes conservées :

| Fichier | Déclarations physiques | SHA256 |
|---|---:|---|
| FoundryOptionsMenu.xml | 129 | 4859ef32283b8f22b69c202299ce5240e199cd7cde9f709fa67360d0270470de |
| FoundryOptionsKeybinds.xml | 192 | 2706bdaa0d68114b5c586c8c111b8e3666ab449d55076f3ea2c07c29b794191e |
| FoundryPhreakspace.xml | 36 | aeaa868a94dcc6cc224c92c15a0d7b736abdec6427ee1367277d1f4dd9d4a738 |

L'index conserve offsets octets, lignes, parent, chemin physique, attributs bruts, conditions directes et ancêtres physiques. Les identifiants OPT-SRC dépendent du nom, du hash de cette version et de l'offset ; ce ne sont pas de nouveaux IDs du plan. Aucun XML n'est réécrit. Les entités restent brutes.

Keybinds ligne7 : attributs adjacents `onlyshowif="game"paddingbottom="7"`. Le refus XML strict et la branche de grammaire native sont hérités de l'audit ATTRIBUTE-GRAMMAR-v3 ; aucune corruption n'est déduite du seul refus Python. Le lecteur documentaire conserve cette adjacency sans prétendre exécuter le parseur original.

306 scripts AS déjà exportés sont vérifiés par leurs identités, sans nouvel export. ModelFactory et ViewFactory, puis16 méthodes de consommateurs, fournissent les routes et les limites. Le contrat XMLDeseralizer/TraceSerializer est celui du chargement debug ; il ne remplace pas le décodeur ni la politique d'include native déjà audités.

## R3 — Consommateurs et classification

357 déclarations : 318 candidats de modèles enregistrés,32 descripteurs option consommés par ModelDropdown.addOption,3 wrappers data et4 directives include. Ce total n'est ni un nombre d'instances ni un nombre de contrôles actifs.

29 tags ont une route de factory vers28 classes modèles et28 vues : dropdown et dropdownNoLabel partagent ModelDropdown. Chaque route porte la source réelle modèle/vue et le symbole sprite par défaut. Sprite est une classe intégrée ; null pour QuickBindComponent est un littéral de registre, pas la preuve d'un asset absent. Les alias de sprites et le type stringify effectif ne sont pas simulés. buildOptionsMenu crée explicitement ModelApplication ; les trois wrappers data ne deviennent pas trois applications.

32 tags option sont les données de8 dropdowns, pas32 modèles manquants. Les conditions onlyshowif et les attributs inisection/strategy/prependnolabelevents des ancêtres restent physiques : aucun arbre effectif ni héritage calculé n'est inventé. La sélection native du contexte et du fournisseur reste ouverte.

222 déclarations ont un ini/event/datasource direct. Une recherche groupée exacte, sensible à la casse et aux limites d'identifiants ASCII, porte sur 278 termes (valeur brute et clé INI lexicale) et1168 fichiers Rust/JS/HTML vérifiés, avec contrôle d'appartenance du corpus. Résultat : 19 occurrences pour 10 termes dans 6 fichiers. Toutes restent `candidate_unqualified`, y compris commentaires/tests : un nom trouvé n'est pas une fonction implémentée ; un nom absent n'exclut pas un alias ou une autre implémentation. Chaque occurrence conserve fichier,hash,ligne,colonne et texte.

## R4 — Contrôles exécutés, attendu et observé

- Intégrité des trois XML,306 scripts réutilisés,1168 sources courantes,25 fichiers protégés et5 registres : vérifiée avant livraison ; état Git identique au point de reprise.
- Attendu129/192/36 nœuds,357 identifiants uniques,aucun type non classé,4 includes et222 déclarations avec liaison : observé à l'identique.
- Lecteur documentaire : quatre cas nominaux (chevron entre guillemets,commentaire contenant un faux tag,attributs adjacents,entité brute) et six refus explicites (fermeture incorrecte,guillemet non fermé,attribut dupliqué,DOCTYPE,texte hors contrat,deux racines). Ces exemples sont synthétiques et ne testent pas le moteur original.
- Relecture indépendante prévue : comparer le tokeniseur aux offsets et attributs bruts,comparer les deux sources strictes via ElementTree,contrôler le refus strict connu de Keybinds,les routes,les occurrences et toutes les identités.
- Non exécutés : Rust,jeu,AS,x86,GUI,entrées physiques,rendu,réseau,écriture de réglage ou chargeur de production. Aucun logiciel installé,aucune migration,aucun accès aux bases de suivi.

## R5 — Manques et conditions de reprise

- **OPTIONS-INTERNAL-PANEL-SOURCE** : FoundryOptionsInternalPanel.xml. Impact : Available three-file inventory cannot cover its unknown declarations or effective children. Reprise : New archive/provider with exact source;do not repeat unchanged whole-client/ZIP searches.
- **OPTIONS-INTERNAL-KEYBINDS-SOURCE** : FoundryOptionsInternalKeybinds.xml. Impact : Nested include contributes unknown declarations;four includes are authored edges,not four loaded sources. Reprise : New original archive/provider mapping or source carrying this exact include;then index its declarations and qualify include inheritance/environment separately.
- **OPTIONS-EFFECTIVE-TREE** : Selected movie/provider,environment values and effective include/model tree. Impact : No complete visible-controls denominator or runtime equivalence. Reprise : Identify actual version/context/provider or explicitly authorized local reconstruction contract;reuse include/visibility proofs.
- **OPTIONS-WIDGET-BINDING-QUALIFICATION** : Per-widget semantics and actual current consumers beyond exact-name candidates. Impact : No imported Options implementation or current binding equivalence claimed. Reprise : Use the indexed node IDs and concrete source fragments;qualify one binding/family with current read/write/effect and limits;do not call a name hit implemented.

Le quatrième include est FoundryOptionsInternalKeybinds.xml, Keybinds ligne181, sous un groupe conditionné game. Sa présence physique et le résultat de la recherche exacte dans le client et cinq ZIP sont enregistrés dans `new_include_search`. Cette recherche ne couvre pas tous les fournisseurs virtuels. InternalPanel reste issu de la recherche antérieure ; aucune nouvelle recherche large de ce nom.

## R6 — Corrections et prochains petits lots

HUD-OPTIONS-ENTRY-01 et HUD-QUIT-DIALOG-LIFECYCLE-01 sont réutilisées avec leurs définitions inchangées, toujours proposées/non appliquées. Aucun doublon de correction ni nouveau critère normatif. Les déclarations fournissent désormais des entrées ciblées pour les sous-audits suivants :

- **AUD-17.5-01-OPTIONS-ENVIRONMENT-QUALITY-01** : Qualifier [Performance]EnvironmentQuality et son consommateur réel courant. Fin : Historique dropdown/options/GraphicsLookup,lecture courante et usages réels reliés;écriture UI,effets,persistance et valeurs non prises en charge distingués;sept rubriques relues. Arrêt : Un seul réglage;ne pas qualifier toute la vidéo ni exécuter le produit.
- **AUD-17.5-01-OPTIONS-KEYBIND-CAST1-01** : Qualifier evtCastSpell1 et variantes normales/rapides reliées à la première capacité. Fin : Sources quickbind/keygrid et entrée courante inspectées;rebind,normal/rapide,focus et refus séparés;preuves précédentes réutilisées. Arrêt : Première capacité seulement;pas tous les raccourcis/champions.
- **OPTIONS-SOURCE-RESUME** : Reprendre les includes internes manquants uniquement avec une nouvelle entrée. Fin : Provenance/version et octets du nouvel include identifiés,effet sur inventaire et inconnues décrit. Arrêt : Pas de nouvelle recherche large sans archive,mapping ou piste nouvelle.

Ces sous-lots sont des propositions documentaires dans ce livrable, sans modification du Goal,du plan,de ses cases ou de ses bases. Le prochain résultat privilégié est EnvironmentQuality,un réglage précis avec une piste de consommateur courant ;aucune relance globale des exports,des liens ou des recherches identiques.

## R7 — Livraison et contrôle de cohérence

Preuve : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CONTROL-CENSUS-01\options-control-census-proof.json` (SHA256 ba1f3a03a89f0ba696c7a60c67de87e5504905cc642282c0feba1a4a18a1c95c).

Index exploitable : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CONTROL-CENSUS-01\options-authored-index.json` (SHA256 6df1bc5edf8905492ffceb6f753e5e8fc90390b7fb0db30ed52459e374da3e66).

Scripts neufs : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CONTROL-CENSUS-01\verify_options_control_census.py` et `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CONTROL-CENSUS-01\options_lexical_index.py`. Spécification : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CONTROL-CENSUS-01\audit-unit.json`. Relecture séparée : `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CONTROL-CENSUS-01\verify_delivery.py` → `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-CONTROL-CENSUS-01\delivery-readback.json`.

Rapport neuf : `F:\OpenLeague\docs\audit\units\AUD-17.5-01-OPTIONS-CONTROL-CENSUS-01.md`. Seuls ces nouveaux artefacts documentaires sont écrits. Les preuves antérieures,76 modifications Git suivies et les25 fichiers protégés sont conservés. Goal,critères,registres,produit,interface et bases inchangés. Les78 contrôles logiques courants recensés précédemment ne sont pas augmentés par les déclarations XML. Aucun pourcentage de jeu achevé n'est calculé.
