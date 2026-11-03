> Historique de la version 1.1. La version 1.2 remplace la méthode de durée et le survol. Voir [la recherche IA et la mise à jour](PLAN_AI_ESTIMATION_RESEARCH_2026-10-22.md).

# Audit de l’application OpenLeague Plan et qualification des tâches

Date : 22 octobre 2026. Périmètre : application de suivi Windows Rust/Tauri et
interface HTTP locale associée. Cet audit ne qualifie pas le jeu OpenLeague.

## Résultat livré

Trois badges compacts accompagnent chaque sous-tâche : durée indicative,
difficulté, puis modèle et effort recommandés dans un seul badge. Les couleurs
sont doublées par des textes explicites. Un seul arrêt clavier par groupe de
badges ouvre les hypothèses et la justification. Le clic ne modifie aucun état.
Le même ajout figure dans la liste et dans la fiche de consignes.

Le catalogue réel complet a été parcouru : 42 214 tâches, 2 770 fiches, 24 parties.
Il ne s’agit pas de 42 214 revues humaines indépendantes : la qualification est une
heuristique reproductible fondée sur le contenu et les métadonnées, avec
49 combinaisons de profils dans cet instantané. Les fourchettes ne sont pas des
mesures, des engagements de livraison ou un calcul de progression.

## Architecture et comportement examinés

- Deux interfaces HTML/CSS/JavaScript, avec un adaptateur IPC et des dialogues et
  un presse-papiers Windows pour Tauri ; adaptateur HTTP pour le site local.
- Backend autonome Rust : `tools/project-plan-desktop/src-tauri/src/{main,store}.rs`.
  Liste paginée par fiche, recherche normalisée, états, notes, exports/imports,
  annulation et sauvegarde SQLite. Les requêtes SQL utilisent des paramètres.
- Backend Python : `tools/project-plan/{server,store}.py`. Écoute loopback,
  contrôle Host/Origin et synchronisation du catalogue par identifiant.
- Catalogue `docs/completion_tasks_2026-10-20.json`, hiérarchie
  `docs/execution_plan_A_Z.json`, inconnues `docs/fidelity_unknowns_4_20.json`.
  Identité de tâche, appartenance aux fiches et dépendances sont conservées.
- La configuration Windows relie l’application à
  `E:/OpenLeague/runtime/project-plan/plan.sqlite3`. La graine embarquée sert à une
  première installation ; elle ne remplace pas une base explicitement configurée.
- Les modifications du suivi utilisent des transactions et des révisions
  optimistes. Une annulation refuse les écritures devenues obsolètes.
- Les cases restent des choix utilisateur, distincts de la qualification
  technique, des inconnues et de l’acceptation humaine.

## Méthode d’estimation

Le générateur lit tous les identifiants et contenus du catalogue. Il tient compte
du type de travail, du titre et du groupe, du contenu de la capacité originale
quand il est disponible, des formes secondaires, des transformations/clones,
des dépendances déclarées, du caractère transversal et des inconnues réellement
ouvertes pour la tâche. La présence d’un fichier ne résout pas une inconnue.

Les tâches de lecture d’une valeur ou d’un rang sont distinguées de la réparation
de ressources, des règles de simulation, de la réplication réseau, de la
présentation et de la recette. Les contrôles ciblés n’héritent pas automatiquement
de la difficulté de tout le champion. Les périmètres transversaux, les divergences
et les règles concurrentes ou de sécurité nécessitent une revue plus approfondie.

Lorsqu’une réalisation et sa vérification technique sont toutes deux déclarées
complètes, le temps concerne la revue finale restante. Cela n’accorde aucune
acceptation humaine et ne coche rien. Pour une tâche de synthèse, le temps couvre
l’intégration/revue de cette étape ; il n’inclut pas une seconde fois tous les
travaux de ses prérequis.

Les fourchettes vont de 15–45 minutes à 2–6 semaines. Il s’agit d’effort actif de
travail assisté par les outils, avec les prérequis disponibles, hors attente
humaine, téléchargements et apprentissage. Un jour = 8 heures, une semaine =
5 jours. Les profils avec source incertaine ont une confiance faible ; les autres
une confiance moyenne. Aucun profil ne prétend une précision élevée sans mesure.
L’inspection visuelle et l’écoute restent nécessaires pour les tâches concernées.

Il ne faut pas additionner ces valeurs pour annoncer une date de livraison du
jeu : dépendances, recettes de synthèse, réutilisation, parallélisme et recherches
non résolues empêchent un tel calcul.

## Modèles et effort

La difficulté n’est pas une durée de réflexion du modèle. La recommandation reste
consultative et ne change pas le modèle sélectionné dans Codex :

| Travail | Modèle recommandé | Effort |
| --- | --- | --- |
| Contrôle simple, borné, sans obstacle connu | GPT-6 Luna | Moyen |
| Travail ciblé ou intégration courante | GPT-6.1 Sol | Moyen |
| Simulation, réseau, sources incertaines, rendu complexe | GPT-6.1 Sol | Élevé |
| Contradictions, rétro-ingénierie, mécanismes complexes, synthèse critique | GPT-6 Astra | Très élevé |

Ce choix est un jugement de travail, pas le résultat d’un benchmark comparatif
des modèles sur les 42 214 tâches. Les réglages extrêmes ne sont pas attribués
systématiquement. La disponibilité exacte dépend du compte et du produit.
Sources officielles consultées le 22 octobre 2026 :
[sélection des modèles](https://developers.openai.com/api/docs/guides/model-selection)
et [effort de raisonnement](https://developers.openai.com/api/docs/guides/reasoning).

## Interface, accessibilité et performance

La page garde son organisation, ses filtres et sa progression. Aucun nouveau
panneau permanent, compteur global, légende permanente ou réglage de modèle n’est
ajouté. Les trois badges tiennent à droite à grande largeur et sous le titre à
petite largeur. La zone de copie et les cases restent distinctes.

Les badges ont une description accessible et s’ouvrent avec Entrée. Échap ferme
le dialogue et rend le focus à son déclencheur. La justification est également
disponible au survol. Les couleurs de texte/fond sont contrôlées à au moins 4,5:1 ;
les textes transmettent l’information sans dépendre de la couleur. Une règle
spécifique conserve les contours en mode couleurs forcées.

Les données compactées dédupliquent les profils. Elles sont intégrées dans chaque
interface pour rester disponibles hors ligne sans nouvelle route HTTP ni
dépendance de service. Chaque HTML passe d’environ 30 ko à 2,13 Mo. Ce coût de
chargement est explicite ; aucun chargement des consignes ou notes complètes
n’est ajouté à la liste. Aucun contenu n’est envoyé à un modèle ou à Internet
pour calculer les badges.

## Obsolescence et maintien

L’estimation est datée et traçable aux SHA-256 exacts de ses trois entrées. Une
empreinte compare identifiant, titre, type et statut de source avec la ligne
réellement reçue par l’interface. Une tâche ajoutée ou dont ces champs changent
affiche « À estimer / À qualifier / À recommander » au lieu d’une fausse précision.
Une modification sémantique des seules preuves ou inconnues impose une nouvelle
génération même si le titre n’a pas changé. L’application autonome ne se met pas
à jour toute seule quand le catalogue source évolue.

Commande de régénération depuis la racine :

```powershell
python -B tools/project-plan/task_estimates.py --root E:/OpenLeague --output runtime/project-plan-estimates/task-estimates.json --refresh-ui
python -B tools/project-plan/test_task_estimates.py
```

Le générateur remplace seulement trois blocs dérivés dans chaque HTML : données,
style des badges et lecture des profils. Pour l’application native, recompiler
ensuite le workspace autonome puis remplacer l’exécutable après fermeture de la
fenêtre. La base utilisateur, les coches, notes, révisions et l’historique ne sont
pas des sorties du générateur.

## Vérifications exécutées et limites

- 9 tests Python : couverture exhaustive des identifiants et champs, différence
  entre une valeur simple et une simulation, traitement des inconnues, synthèse
  sans double comptage, revue finale, Unicode et régénération bornée.
- 10 tests Rust existants : persistance, recherche, pagination, conflits,
  rollback, annulation, import/export, sauvegarde et refus des commandes.
- 10 parcours navigateur : couverture des badges, clavier/focus, consignes,
  absence de mutation lors de la consultation, données obsolètes, recherche
  champion, largeurs 420/550/850/1100 et coche/annulation sur une copie isolée.
- Compilation Windows release de la version 1.1.0, verrouillée et hors ligne.
- Contrôle complet des 42 606 états manuels et des 22 historiques de la base
  originale, comparaison des empreintes avant/après et lecture SQLite.
- Captures de l’interface web, puis contrôle distinct de la fenêtre Windows.

L’échec initial du navigateur de test dans le sandbox et l’inaccessibilité de son
serveur depuis le navigateur hors sandbox ont été conservés comme échecs
d’environnement. Le serveur et le navigateur de test ont ensuite été placés dans
le même environnement, toujours sur loopback et sur une copie des données.
Une fenêtre initialement minimisée a été restaurée pour la vérification native.

Ce travail ne constitue pas une certification de sécurité, une recette métier du
jeu, une validation humaine de chaque estimation, ni une qualification sur un
autre PC. Aucun historique de temps réel exploitable n’est disponible ; les
fourchettes devront être recalibrées à partir de durées observées. Les dépendances
non cochées peuvent ajouter un délai qui n’apparaît pas dans la durée de l’étape.

Preuves détaillées de cette livraison :
`E:/mapslol3v3/Plan_badges_2026-10-22/` et
`docs/plan_task_estimates_audit_2026-10-22.json`.
