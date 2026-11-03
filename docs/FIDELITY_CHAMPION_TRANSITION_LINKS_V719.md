# SYS-01.2-02 — Transitions d animation des champions, V719

Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, catalogue4.20.1 distinct.

Les1464fiches de transition ne pointaient que vers champion_catalog. Elles exposent maintenant les sources et les décisions du renderer actuel, avec leurs limites et les variantes non branchées.

## Résultats vérifiés

V719 : les1464fiches de transitions des122champions sont reliees aux configurations natives, graphes BLND et clips actuels.576roles sont lies a un declencheur actuel,34critiques conservent leur identite avec le clip attaque,732roles n ont ni liaison catalogue ni declencheur identifie dans le parcours inspecte.2364sources verifiees,122graphes lus selon le parseur borne,7ancres precises ajoutees. Cinq tests attaques couvrant122champions et un test de selection du modele Ezreal passent ; aucun rendu ou runtime original accepte.

| Rôle | Fiches | Rôle lié dans le catalogue | Champion avec candidat de nom dans le graphe natif |
|---|---:|---:|---:|
|IDLE|122|122|122|
|RUN|122|122|122|
|ATTACK|122|122|122|
|CRIT|122|88|117|
|RECALL|122|0|40|
|DEATH|122|122|122|
|RESPAWN|122|0|13|
|DANCE|122|0|122|
|JOKE|122|0|85|
|TAUNT|122|0|122|
|LAUGH|122|0|122|

Ces candidats de noms natifs ne prouvent ni la sélection du graphe ni la pose. Par exemple, Aatrox possède Recall/Joke/Laugh/Taunt et des branches Dance dans son graphe alors que ces rôles ne sont pas branchés dans le parcours actuel inspecté. Respawn n est pas remplacé artificiellement par un clip d idle dans le registre : la limite du déclencheur dédié est conservée.

## Contrôles

- 2364 identités de fichiers contrôlées ; les122modèles sélectionnés correspondent à leurs catalogues. L override actuel d Ezreal pointe vers ezreal_joint_identity_local.glb.
- 122graphes lus avec le parseur borné existant ; configurations de base, nœuds, références ANM et ambiguïtés conservés.
- Six falsifications refusées : signature/version BLND incorrectes, index booléen/hors limites, faux rôle Recall et fausse qualification du runtime natif.
- Client de tests compilé avec Cargo locked/offline sur F et CARGO_INCREMENTAL=0 ; code de sortie0.1275fichiers source/manifeste contrôlés inchangés.392artefacts de dépendance en cache et1artefact client reconstruit.
- Cinq tests existants portant sur les122champions passent : identité des attaques/critiques, âge et doublons, absence d attaque inventée, brouillard, annulation/mort. Le test précis du choix de modèle Ezreal passe également. Le filtre initial à zéro test est conservé mais exclu du total.
- Pas de nouvelle scène rendue et aucun binaire historique exécuté ; ces tests ne valent pas validation visuelle des transitions.

## Limites

- La lecture BLND est bornée aux tables, noms et références directes de type1. Les autres charges utiles restent opaques. Les noms de nœuds sont des candidats lexicaux, pas une preuve de sélection effective, priorité, transition ou événement dans le client original.
- 120 identités de skin de base sont résolues, une a des configurations équivalentes et une reste ambiguë. Les candidats Renekton et leurs références sont conservés ; aucune priorité n est inventée. Les skins et formes supplémentaires restent à qualifier.
- Les corrélations ANM utilisent les chemins du registre et de l inventaire historique d import, avec vérification des octets. Un même nom ou un fichier importé ne prouve ni fidélité des poses, ni absence de substitution historique, ni identité du modèle effectivement sélectionné par le client original.
- Recall, Respawn, Dance, Joke, Taunt et Laugh : aucun rôle catalogue et aucun producteur identifié dans animate, selection et Action inspectés ; recherche de leurs tokens exacts dans les sources client/core conservée. Ce constat ne prouve pas une absence de ressources natives. Les 732fiches ne reçoivent aucun consommateur marqué comme fournissant leur fonctionnalité.
- 34critiques utilisent le rôle attack en conservant leur identité et âge ; les fenêtres locales, les80ms de transition, les répétitions et la règle de déplacement ne sont pas validées comme règles originales.
- Les6tests frais exécutent les modules actuels compilés du client :5tests de journal d attaque et1test de sélection de ressource. Pas de fenêtre de jeu, de GPU, de lecture du client historique, de pose native comparée ou de validation des1342transitions.392artefacts dépendants restent du cache Cargo identifié ; un artefact client est reconstruit.
- Le premier filtre de test de modèle était erroné et a sélectionné zéro test ; il reste conservé et ne compte pas comme réussite. Le test précis observé dans le source a ensuite été exécuté et a passé.
- La première observation privée incluait un lecteur de catalogue marqué comme composant pour les rôles non branchés. La version vérifiée retire ce lien de ces732fiches et impose qu aucun consommateur de fonctionnalité n y soit propagé. Première observation conservée, jamais publiée au registre.
- Les titres des122parents incluent aussi casts, transformations,VFX,audio et HUD : les onze enfants nommés ne ferment pas ces autres dimensions. Aucun état manuel, prérequis, inconnu ou critère d acceptation n est promu.

## Livraison

Les1464fiches et SYS-01.2-02 sont enrichies dans les registres et les deux bases du plan. Sept consommateurs de code précis ajoutés, tous de portée partielle. Pour les732rôles sans déclencheur, seuls des points d entrée et de contrôle sont liés ; aucun fournisseur de la fonctionnalité n est revendiqué.

Le script de livraison vérifie Store.task/copy_text, la conservation des autres tâches et de toutes les cases/notes/historiques, le rechargement idempotent et PRAGMA quick_check. Résultats réels dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision719_delivery/VERIFIED.json après exécution.

Fichiers modifiés : ce rapport et [reçu détaillé](fidelity_champion_transition_links_v719.json), completion_tasks/fidelity_requirement_trace/fidelity_sources, coverage/completion_plan/resume_checkpoint, CURRENT/HANDOFF et les deux bases. Scripts, observations et deltas ciblés sur F:/OpenLeague-work. Aucun source de production ou asset modifié ; aucun snapshot intégral de base.

Goal, fiches et validation complète du jeu restent ouverts.
