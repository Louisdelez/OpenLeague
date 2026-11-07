# OpenLeague — Audit du plan complet

Audit du 20 octobre 2026. Périmètre : catalogue entier, découpage, références recensées, dépendances et consignes de copie. Les comportements du jeu gardent les états de qualification de l’audit source du 20 octobre.

## Corrections apportées

- Remplacement des 392 tâches globales par des actions précises et conservation de leur correspondance historique.
- Suppression du quota de six tâches et des regroupements artificiels de trois tâches.
- Une fiche complète pour chacun des 122 champions, avec les capacités principales et secondaires, chaque rang et chaque clip natif référencé.
- Fiches individuelles pour les objets, skins, runes, maîtrises, sorts invocateur, bâtiments placés, camps et unités natives candidates.
- Matériaux de la carte restaurée, décors animés et émetteurs suivis par nom ; contrôle explicite de l’export Blender et de l’orientation de Vilemaw.
- Objets natifs des autres cartes et locales candidates ajoutés depuis les fichiers effectivement présents.
- Suppression des règles de retour au camp et d’aggro des inhibiteurs, Nexus et fontaines.
- Classifications historiques rendues obligatoires ; les fichiers résiduels restent candidats jusqu’à décision sourcée.
- Prérequis de préparation des fiches ajoutés et graphe de dépendances vérifié.
- Imports de sauvegardes étendus au nouveau volume et aux anciennes tâches archivées, sans propager une coche globale vers ses enfants.

## Volume du plan

- 24 parties ; 2,770 fiches nommées ; 42,214 sous-tâches.
- 4,267 références de clips ont une tâche de qualification distincte.
- Une fiche contient le travail propre à son contenu ; son nombre de sous-tâches varie naturellement.
- Les coches de suivi manuel et les preuves d’acceptation sont conservées comme informations distinctes.

## Contrôles exécutés sur le catalogue entier

- [x] Identifiants de tâches uniques.
- [x] Titres précis non dupliqués.
- [x] Chaque tâche dans exactement une fiche.
- [x] Table de recherche tâche vers fiche complète.
- [x] 24 parties couvrent tous les domaines.
- [x] Aucun quota artificiel de tâches par fiche.
- [x] Comptes de parties exacts.
- [x] Dépendances de tâches existantes et sans cycle.
- [x] Prérequis des fiches existants et sans cycle.
- [x] Une fiche distincte par champion officiel.
- [x] La partie champions contient uniquement les 122 fiches individuelles.
- [x] Passif, QWER et entrées secondaires nommées pour chaque champion.
- [x] Une fiche par entrée de catalogue skin.
- [x] Une fiche par entrée de catalogue item.
- [x] Une fiche par entrée de catalogue rune.
- [x] Une fiche par entrée de catalogue mastery.
- [x] Une fiche par entrée de catalogue summoner.
- [x] Classifications de disponibilité obligatoires.
- [x] Une tâche par clip natif référencé.
- [x] 360 configurations natives de carte classifiées séparément.
- [x] Tous les dossiers Character supplémentaires ont une fiche.
- [x] 115 matériaux de la carte restaurée suivis séparément.
- [x] Langues natives candidates nommées.
- [x] 849 entrées Items réconciliées sans les confondre avec 849 objets de boutique.
- [x] 151 exigences historiques reliées au nouveau travail.
- [x] 392 anciennes tâches globales retirées des cases actives.
- [x] 9069 tâches nominatives conservent leurs identifiants.
- [x] Aucune preuve ou réussite ancienne fabriquée par le redécoupage.
- [x] Chaque ancienne tâche possède une correspondance.
- [x] Orientation de Vilemaw explicitement conservée.
- [x] Réexport restauré et prévention des anciennes textures prévus.
- [x] Règles de monstres retirées des bâtiments inapplicables.
- [x] Consignes complètes produites pour toutes les tâches.

## Points qui restent à qualifier pendant la construction

- Disponibilité datée de certaines cartes, variantes, modes, skins, objets, runes et médias ; chaque candidature a une tâche de décision.
- Mécanismes serveur et paramètres natifs encore non récupérés ; distinguer source confirmée et reconstruction locale.
- Branches de capacités et unités découvertes après l’inventaire initial : créer une tâche nommée avant de fermer le kit concerné.
- Le registre des autres cartes recense les configurations natives connues ; confirmer les objets effectivement instanciés par leurs scripts avant de les rendre obligatoires.
- Fidélité visuelle, audio et ergonomique : exécuter les comparaisons et l’acceptation humaine prévues.
- Exécution des parties complètes, LAN, performance, endurance et installation autonome : tâches de recette ouvertes.
- Le nombre de tâches est un découpage du travail, pas un pourcentage prouvé de fidélité du jeu.

## Traçabilité

Les 151 exigences historiques ont une correspondance vers des tâches actives. Les 9 069 identifiants déjà nominatifs sont conservés. Les 392 anciennes cases globales sont archivées avec leurs états ; leurs enfants ne sont jamais cochés automatiquement.

Registre machine : `completion_tasks_2026-10-20.json`. Hiérarchie : `execution_plan_A_Z.json`. Contrôles détaillés et empreintes : `E:/mapslol3v3/Plan_granulaire_2026-10-20/AUDIT.json`.

## Vérification de l’application et de la migration

- 14 tests fonctionnels passent sur le catalogue final : persistance, conflits, rollback, annulation, pagination exhaustive, copie, sauvegarde, imports anciens et nouveaux, HTTP local et fiche de champion.
- 9 461 états manuels préexistants, notes, révisions et dates conservés exactement après migration et vérification dans le navigateur.
- 392 anciennes tâches globales archivées ; aucune propagation automatique de leur coche vers les enfants.
- Page réellement ouverte : 24 parties, puis 122 fiches de champions ; fiche Garen à 166 sous-tâches et Elise à 219.
- Consigne complète ouverte et copie confirmée par l’interface ; le contenu de la réponse de copie est également vérifié. Le presse-papiers système n’a pas été relu indépendamment.
- Coche de test conservée après rechargement puis retirée ; section interne maintenue ouverte après une modification.
- Aucune erreur console ni débordement horizontal observé à la largeur de 842 pixels.
- Sauvegarde cohérente avant installation : `E:/mapslol3v3/Plan_granulaire_2026-10-20/preinstall/plan.sqlite3`.
- Plan Markdown intégral sur le Bureau : `OpenLeague_PLAN_COMPLET_DETAILLE_A_Z.md` ; index et 24 fichiers détaillés également conservés.

## Défauts trouvés pendant la validation et corrigés

- Références de prérequis de fiche incohérentes après normalisation de leur identifiant : corrigées, graphe relu sans cycle.
- Collision entre deux noms de clip de Zac lors de la simplification des caractères : identifiants désambiguïsés par empreinte stable.
- Fiche de simulation ne citant plus directement sa fiche source après découpage : dépendance explicite restaurée.
- Recherche d’une lettre de compétence à l’intérieur de mots sans rapport : recherche isolée pour les termes d’un caractère.
- Volume du catalogue pénalisant la pagination : index de lecture et table des groupes ajoutés pour éviter de relire les consignes et contextes volumineux dans la liste.

Les journaux des tentatives initiales restent conservés à côté du journal final. Aucun test du jeu ni nouvelle qualification de gameplay n’a été exécuté pour cette modification du plan.
