# OpenLeague Plan 1.2 — survol et estimations d’agent IA

Recherche et réalisation du 22 octobre 2026. Ce rapport remplace la méthode de
durée de la version 1.1, dont le rapport daté reste conservé comme historique.

## Résultat

Les 42 214 tâches ont un profil IA. Trois petits badges restent visibles :
temps agent, difficulté pour l’IA, modèle et effort recommandés. La longue
infobulle système est supprimée. Une carte de survol personnalisée sépare les
trois informations sur des lignes distinctes, avec couleurs et explications.
Elle se positionne dans la fenêtre, reste lisible quand la souris y entre et
s’ouvre aussi au clavier. Échap la ferme sans déplacer le focus. Le clic conserve
l’accès à la fiche complète. Un survol dans une boîte de consignes s’affiche
au-dessus de cette boîte, via la couche supérieure des popovers HTML.

## Ce qui a été recherché

La [sélection des modèles OpenAI](https://developers.openai.com/api/docs/guides/model-selection)
distingue les tâches ciblées et répétitives, le code complexe courant et les
problèmes ambigus exigeant une analyse approfondie. Ces rôles guident la
recommandation, sans prétendre qu’un nom de modèle prouve une réussite sur LoL.

Les fiches actuelles de [GPT-6 Luna](https://developers.openai.com/api/docs/models/gpt-6-luna),
[GPT-6.1 Sol](https://developers.openai.com/api/docs/models/gpt-6.1-sol) et
[GPT-6 Astra](https://developers.openai.com/api/docs/models/gpt-6-astra)
permettent de vérifier leurs usages et réglages. Le périmètre recommandé dans
l’application reste celui des modèles de la famille disponible dans Codex.
Aucune connexion à un fournisseur supplémentaire ni installation d’un modèle
local n’est supposée présente ou plus rapide sans mesure.

Le [guide du raisonnement](https://developers.openai.com/api/docs/guides/reasoning)
décrit le compromis entre effort, latence et consommation. Monter au maximum
n’est pas une preuve de gain utile sur chaque tâche. Les niveaux automatiques
retenus sont Faible, Moyen, Élevé et, pour deux recherches ciblées, Très élevé.
Max et Ultra ne sont pas attribués systématiquement. Ultra dans Codex, les modes
de service Fast/Ultrafast de l’API et l’effort de raisonnement sont des réglages
distincts ; aucun multiplicateur de vitesse n’est déduit d’un libellé.

Le [guide de latence](https://developers.openai.com/api/docs/guides/latency-optimization)
explique le rôle des générations, requêtes et opérations séquentielles. Les
scripts déterministes et les opérations indépendantes groupées sont donc pris
en compte dans le mode de travail. On ne fait pas écrire par un modèle chaque
ligne d’un catalogue lorsqu’un script vérifiable peut la traiter.

La [boucle d’agent Codex](https://developers.openai.com/blog/run-long-horizon-tasks-with-codex)
alterne lecture, changements, outils, observation et réparation. Le temps
estimé inclut ces étapes de travail. Une réponse textuelle rapide ne signifie
pas que la compilation, les contrôles et l’intégration sont terminés.

Une [comparaison publiée par OpenAI](https://developers.openai.com/blog/maintaining-software-with-the-gpt-6-family)
montre des compromis entre configurations sur un audit logiciel réel. Elle
appuie la nécessité de comparer qualité et coût. Ses chiffres ne sont pas
utilisés comme chronométrage d’OpenLeague ou comme preuve de supériorité sur ses
formats historiques particuliers.

Enfin, la [méthodologie METR](https://metr.org/time-horizons/) précise que ses
horizons sont exprimés en durée humaine de référence, pas en temps mural de
l’agent. Cette page n’est plus mise à jour depuis le 8 septembre 2026 ; elle sert
ici à vérifier cette distinction méthodologique, sans classer les modèles
actuels. Aucun ratio universel « humain divisé par dix » n’est appliqué.

## Durée : base et limites précises

La version 1.2 utilise des **scénarios de cycles d’agent IA**, jamais une
conversion de journées humaines. Un cycle représente un bloc de lecture,
raisonnement, modification, appel d’outil et observation. Le nombre de cycles
varie avec la tâche : valeur isolée, script, simulation, réseau, ressource,
présentation, recette, synthèse et recherche de source. Les transformations,
exceptions, interactions, reprises et inconnues augmentent ce nombre.

La cadence retenue pour ce premier scénario est une hypothèse explicite de
35 à 120 secondes par cycle, plus une réserve de 1 à 5 minutes d’outils. Ce ne
sont **ni des secondes d’inférence mesurées ni une cadence publiée par OpenAI**.
Il n’existe pas de télémétrie permettant ici d’annoncer un temps précis propre
à chaque modèle et niveau. Les estimations ne sont pas présentées comme des
percentiles de fiabilité, et aucun coefficient fictif Astra/Sol/Luna n’est utilisé.

Les repères locaux réellement disponibles sont :

- Le précédent ajout de badges, du checkpoint de préparation à la validation
  installée, a duré environ **24,6 minutes**. Ce repère couvre une modification
  réelle avec outils, tests, compilation et contrôle. Le début exact de la
  demande précède le checkpoint ; il ne s’agit pas d’un échantillon statistique
  de toutes les tâches ni d’un comparatif de modèles.
- Le journal du 20 octobre mesure une compilation incrémentale Tauri à
  **22,40 secondes**, une préparation/compilation des tests à **7,23 secondes** et
  l’exécution des dix tests de stockage à **0,42 seconde**. Ces temps concernent
  des outils sur un cache déjà alimenté, pas une tâche IA complète.
- Les durées et empreintes des sources de calibration sont conservées dans
  `tools/project-plan/task_estimate_research.json`. Les données brutes de
  conversations ne sont pas publiées. Des journaux de contrôle automatique ont
  été écartés : ils ne mesurent pas un travail de développement par le modèle.

Les valeurs affichées sont donc une estimation IA argumentée et reproductible,
avec une validation numérique encore limitée. Elles ne constituent pas un
benchmark comparatif. Pour les améliorer empiriquement, il faudra enregistrer
plusieurs tâches terminées de chaque catégorie, avec modèle, effort, outils,
nombre de reprises et durée murale, puis confronter les prédictions aux durées
constatées. Les badges n’annoncent aucune précision statistique inexistante.

Le scénario suppose un agent unique, un accès interactif courant, les prérequis
disponibles et des outils déjà installés. Il n’intègre pas une attente humaine,
une file fournisseur inconnue, un gros téléchargement ou une compilation
complète à cache froid non mesurée. Il ne suppose pas de sous-agents, de service
Ultrafast payé ou de génération de textures déjà acceptées. Les tâches visuelles
et audio gardent leur contrôle perceptif après le travail automatique.

## Recherches non bornées

Huit tâches transversales ou recherches de contradictions portent le libellé
**Lot**. Leur durée correspond à une première passe d’investigation ; la carte
dit explicitement que la durée totale reste ouverte. Faire apparaître un nombre
de minutes pour ce lot ne ferme aucune inconnue et ne promet pas une source
historique absente. C’est notamment le cas de la liaison globale des exigences
et de l’examen de contradictions communautaires.

Les tâches dont la technique est déclarée complète estiment la préparation de
leur revue par l’IA, hors décision utilisateur. Les synthèses excluent le temps
des prérequis eux-mêmes. Les durées ne sont pas additionnées pour annoncer une
date de fin du jeu. Elles ne changent aucune case, note ou acceptation.

## Choix du modèle et difficulté IA

| Travail à réaliser | Point de départ recommandé |
| --- | --- |
| Valeur isolée, extraction bornée, contrôle scriptable | Luna · Faible |
| Contrôle ciblé répétitif avec résultat déterministe | Luna · Moyen |
| Intégration courante, plusieurs fichiers et outils | Sol 6.1 · Moyen |
| Simulation, réseau, tests et sources à croiser | Sol 6.1 · Élevé |
| Contradiction historique ciblée | Sol 6.1 · Très élevé, à comparer à Élevé |
| Recherche ambiguë ou mécanisme complexe | Astra · Élevé |

La difficulté affichée devient Simple, Standard, Avancée ou Recherche. Elle
décrit le périmètre et les obstacles pour un agent avec outils, pas un niveau
d’expérience humaine. Cette échelle et le nombre de cycles restent un jugement
de planification explicite, pas un score issu d’un benchmark de LoL.

La recommandation est consultative. Elle ne modifie pas le modèle sélectionné
dans Codex. Les capacités, outils, prix et limites de compte peuvent évoluer ;
les sources sont datées et devront être revérifiées lors d’une prochaine mise
à jour de la méthode.

## Vérifications

- 10 tests Python nouveaux sur les 42 214 profils, la portée des lots, les
  différences entre tâches, les inconnues, la synthèse et la régénération bornée.
- 13 parcours navigateur : vrai survol, disparition de l’attribut `title`,
  conservation au passage de la souris dans la carte, clavier et Échap, dialogue
  de consignes, bords de fenêtre, largeurs 420/550/850/1100, défilement,
  redimensionnement, recherche et modification/annulation sur une copie SQLite.
- Vérification de contraste des textes et des badges. Les labels restent
  explicites sans dépendre de la couleur.
- Build release 1.2.0 verrouillé et hors ligne. Les sources du stockage Rust et
  du serveur Python restent inchangées ; les dix tests Rust de la version
  précédente ne sont pas annoncés comme réexécutés.
- Comparaison complète des états manuels et historiques de la base réelle,
  et vérification séparée de la fenêtre Windows installée.

L’échec initial d’un survol après défilement automatique a conduit à corriger
le traitement d’un affichage encore en attente. Une seconde attente de test
était due à une fenêtre sans défilement possible ; le parcours utilise ensuite
une fenêtre réellement défilable. Les tests finaux passent.

Preuves : `E:/mapslol3v3/Plan_AI_estimates_2026-10-22/`.
Cette livraison qualifie le suivi et sa présentation ; elle ne valide pas le jeu.
