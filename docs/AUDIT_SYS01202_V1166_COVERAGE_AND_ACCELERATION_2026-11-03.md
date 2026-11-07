# SYS-01.2-02 — réconciliation finale V1166 et accélérations retenues

## Verdict

**PASS pour la consolidation bornée. Le parent reste ouvert.**

La recherche a permis d’accélérer le travail là où le gain est vérifiable :
réemploi par empreinte, consolidation par delta, règles d’arrêt, validation
indépendante en parallèle et lecture hors ligne des preuves REA. Elle n’a pas
créé de nouvelle preuve historique capable de fermer `OLU-3293...`.

Cette réconciliation ne termine ni la fonctionnalité CTYPE, ni Map10, ni
`SYS-01.2-02`, ni le jeu.

## Comptes non confondus

- **19 audits source-consommateur clos** : 17 hérités de V1162, ColorPalette
  V1163 et consommateur CTYPE courant V1165 ;
- **2 investigations d’outillage closes** : tentative REA V1165 conservée en
  `TOOL_FAILURE_PRESERVED`, puis qualification V1166 du réemploi snapshot ;
- **0 nouvelle unité historique ou fonctionnelle close** après le probe
  snapshot ;
- **2 unités Map10 à une preuve** et **2 unités Map10 bloquées**, inchangées ;
- V1164 reste `STOP_NO_NEW_EVIDENCE`, sans audit supplémentaire.

Les 19 audits et les deux investigations ne forment pas un dénominateur global.
Aucun pourcentage du parent, de la map ou du jeu n’est calculé.

## Ce qui accélère réellement la reprise

1. **Delta de couverture** : V1162 sert de base ; seuls V1163 à V1166 sont
   rapprochés. Cela évite un nouveau scan global des registres massifs.
2. **Réemploi par hash** : rapports, inventaires, manifests et reçus sont
   épinglés et réutilisés ; les validateurs seuls sont rejoués.
3. **Gates de non-répétition** : une recherche épuisée devient une condition de
   reprise précise, pas une nouvelle boucle de scan.
4. **Parallélisme limité** : consolidation, crosscheck, sélection et revue
   snapshot sont indépendants ; aucune opération partageant GPU ou état mutable
   n’est parallélisée.
5. **REA hors ligne** : le bundle existant expose 10 preuves retenues — sept
   dossiers de fonctions et trois jeux de xrefs — sans démarrer Ghidra. Le filtre
   exact `0xCA99C7` retourne zéro immédiatement.

## Limite qualifiée du snapshot REA

L’instantané est lié au PE exact SHA-256
`402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`,
à Ghidra 12.1.4 et au profil attendu. Il relit les preuves déjà conservées,
mais il n’est pas un projet Ghidra complet garantissant l’accès à une nouvelle
adresse.

Avec une copie privée, `analyze_function(0xCA99C7)` puis l’unique requête plus
petite `read_function_instructions(0xCA99C7)` expirent chacune à `180000 ms`.
La revue indépendante passe 33/33 et confirme : investigation close, inconnu
historique ouvert. Aucun troisième essai identique n’est admis.

`OLU-3293...` manque encore de la fonction, des callers, de la provenance de
`[ebp+0x0C]`, de l’ordre CRT/thread, des tables de locale effectives et de la
valeur runtime historique. Reprendre uniquement avec un projet persistant déjà
analysé contenant cette adresse, une correction diagnostiquée du provider ou
une nouvelle preuve primaire indépendante.

## Outils différés, avec condition d’emploi

- **Tree-sitter** : seulement si une recherche de consommateur source devient
  structurellement ambiguë ou génère des faux positifs textuels.
- **Cache Cargo et tests ciblés** : dans un lot Rust autorisé, même profil et
  mêmes features, avec mesure avant/après. Ce lot ne compile rien.
- **cargo-nextest** : aucune installation maintenant ; à évaluer uniquement si
  le temps d’exécution des tests, et non la compilation, devient le bottleneck.
- **Tests paramétrés/parallèles** : adaptés aux cas indépendants ; interdits en
  concurrence sur GPU, fichiers mutables ou état runtime partagé.
- **apitrace** : candidat D3D9 uniquement si le client exact atteint une scène
  stable capturable. Il ne débloque pas le démarrage historique.
- **RenderDoc** : pertinent pour le renderer Vulkan courant, pas pour LoL 4.20
  D3D9 ; à réserver à un lot visuel courant distinct.
- **Nouveaux modèles/outils** : aucune installation justifiée par les entrées
  actuelles.

## Prochaine décision

La sélection reste
`NO_NEW_FUNCTIONAL_OR_HISTORICAL_UNIT_CLOSABLE_WITH_CURRENT_INPUTS`.
Le lot documentaire de couverture/stop gate est clos. Les cinq candidats
historiques évalués par le sélecteur restent ouverts ; quatre appartiennent au
delta V1164/V1165 et `OLU-29959...` est le candidat supplémentaire évalué.

Le parent reste `OPEN_PARTIAL_NOT_BLOCKED_AS_A_WHOLE` et le prérequis
`D01-SYS-01-1` reste `a_faire`.

## Frontières respectées

Aucune écriture sur `F:\OpenLeague`, aucun Goal, Plan, UI, application, base,
registre protégé, code produit ou asset modifié. Aucune installation, migration,
exécution du jeu, du renderer, de REA/Ghidra ou build n’a été effectuée par
cette réconciliation.


## Publication documentaire

Cette copie publie la réconciliation V1166 dans `F:\OpenLeague\docs`. La
publication modifie uniquement ce rapport, sa revue, `docs/ai/CURRENT.md` et
`docs/ai/HANDOFF.md`. La phrase « aucune écriture sur F » dans la section des
frontières décrit le lot d'analyse E-only antérieur à cette publication.
