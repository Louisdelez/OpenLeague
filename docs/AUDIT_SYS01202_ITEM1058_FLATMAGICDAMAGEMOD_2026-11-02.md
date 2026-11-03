# AUD-SYS-01.2-02 — Objet 1058, FlatMagicDamageMod

Lot d’audit : AUD-SYS-01.2-02-ITEM1058-AP-LINK-01

Date : 2026-11-02  
Tâche : ITEM-1058-SERVER-STAT-FlatMagicDamageMod  
Requirement ID : OLF-9db7159e-45ca-5f9a-ac51-b53810293400  
Consommateur tracé : OLC-b38bc16e-af3e-565e-8e4a-e8549549a702  
Dépendance de scope : ITEM-1058-SCOPE, actuellement partiel_a_terminer.

## Résultat borné

Le champ brut de la ressource native 1058 est présent et décodé directement : FlatMagicDamageMod=80. La donnée locale shop_foundation reprend ability_power=80 et son source_sha256 correspond à l’INIBIN. Le code agrège le bonus d’ability power des objets résolus depuis l’inventaire, puis le transmet aux stats du champion.

L’entrée est toutefois explicitement refusée par map10_shop_admission (allowed=false); la boutique Map10 n’émet donc pas d’achat 1058 et Simulation::buy_item refuse cet objet sur cette carte. La vérification du bonus par un achat ordinaire sur ce mode n’est pas possible dans l’état actuel. L’effet d’un objet déjà présent dans un inventaire et sa valeur finale sous le multiplicateur d’autel n’ont pas été exécutés.

**L’audit de la liaison source native → donnée de catalogue → agrégateur AP → stat est terminé pour ce lot. La tâche fonctionnelle et sa validation restent ouvertes; le prérequis de scope n’est pas terminé.**

## Source et décodage

Le client de référence est docs/reference_client_4_20.json : LoL 4.20.0.315, EUW, en_GB. La source native est DATA/Items/1058.inibin, enregistrée comme OLS-7b897aea-cba0-53ed-9bfc-9327379d4f0c, 532 octets, SHA-256 43d805dcf226a130677771db11a8204ab0dda499990ca591fe97373a6cdcf394.

Le reçu OLS-8a207b4a-05d0-5b9d-b2f9-e716cdaa946d associe exactement ce fichier à lol_game_client, release 0.0.1.7, membre DATA/Items/1058.inibin, release 0.0.0.235, mêmes taille et MD5. La priorité effective des overlays reste non qualifiée.

Contrôle natif exécuté en lecture seule avec le lecteur local tools/project-plan/reference_inibin.py, méthode read et calcul hashkey("Data","FlatMagicDamageMod") :

- Clé calculée : 3524488927.
- Valeur lue dans le fichier natif : 80.
- Taille et SHA-256 lus pendant le contrôle : 532 octets; 43d805dcf226a130677771db11a8204ab0dda499990ca591fe97373a6cdcf394.

Ce décodeur local lit le binaire existant; aucun logiciel ou paquet n’a été installé et aucun fichier de données n’a été écrit. Le catalogue officiel Data Dragon 4.20.1 en_US, source OLS-b3343643-2fe6-513b-b286-7c03b86b8409, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1, donne également FlatMagicDamageMod=80 et l’affichage +80 Ability Power. Cette référence de catalogue est distincte du client en_GB 4.20.0.315.

## Chaîne de données et consommateurs

| Étape | Résultat courant |
|---|---|
| Source native | Le décodage direct confirme Data*FlatMagicDamageMod=80 dans le fichier membre 4.20. |
| Donnée OpenLeague | data/4.20/shop_foundation.json contient id=1058, ability_power=80.0, name « Baguette trop grosse », prix 1600, vente 1120 et source_sha256 identique au natif. Le lien de valeur est maintenant établi, non déduit seulement du hash. |
| Agrégateur d’objets | crates/core/src/shop.rs::bonuses résout les IDs par le catalogue et additionne Item.bonuses.ability_power. |
| Stat du champion | crates/core/src/progression.rs::stats récupère cet agrégat et transmet items.ability_power * altar_damage_multiplier(team) dans Stats. Le montant final varie donc avec l’état/multiplicateur d’autel; ce comportement combiné n’a pas été testé ici. |
| Admission/achat | data/4.20/map10_shop_admission.json contient id=1058, allowed=false. shop_ui filtre les lignes et selected_action refuse l’achat non admis; le cœur retourne « item unavailable on Map10 ». Cette règle locale ne prouve pas que l’objet était absent de toutes les cartes historiques. |

La trace existante associe la tâche à la source native, au catalogue officiel, à l’entrée locale items.id=1058 et à OLC-b38bc16e-af3e-565e-8e4a-e8549549a702. Source et membership sont prouvés; l’applicabilité par carte doit rester distincte.

## Attendu, observé et limites

- Attendu côté donnée : un objet présent dans l’inventaire fournit +80 de puissance, combiné aux autres bonus et aux modificateurs de jeu documentés.
- Observé statiquement : 80 dans l’INIBIN décodé, 80.0 dans le catalogue, agrégation générique et transfert dans Stats.
- Refus observé dans les sources : achat 1058 interdit par la politique Map10 (allowed=false); aucun achat ordinaire de test sur cette carte ne peut réussir.
- Contrôles exécutés : décodage non mutatif de l’INIBIN, recherche des lignes catalogue/admission, lecture des fonctions consommateurs et des liens de traçabilité.
- Non exécutés : tests, build, lancement du jeu, achat réel, capture, cas de cumul ou vérification des stats avant/après. Aucun résultat runtime ou acceptation humaine n’est revendiqué.

## Précondition, manques et reprise

ITEM-1058-SCOPE est required=true, status=partiel_a_terminer. Son critère demande une fiche 4.20 datée, les valeurs/exceptions séparées des inconnues et une décision d’applicabilité fondée sur preuve. Cette tâche de FlatMagicDamageMod dépend de ce scope. La source native prouve l’existence et la valeur 80 dans le client. L’entrée officielle 4.20.1 de /data/1058 indique maps["10"]=false, ce qui corrobore le refus Map10 courant pour cette révision de catalogue. La liaison de cette restriction à l’exécutable client exact 4.20.0.315 et la décision d’exclusion du périmètre restent à consigner; ne pas généraliser à toutes les cartes.

Pour reprendre : terminer ITEM-1058-SCOPE en consignant la preuve officielle 4.20.1 maps[10]=false et la limite du lien vers le client .315; ne tester l’achat AP que si un chemin est admis sur le mode retenu, sinon borner la feature au statut non achetable. Si un inventaire autorisé est disponible, relever le facteur d’autel et relier les reçus aux révisions exécutées.

La tâche stat reste a_faire, implementation_complete=false et acceptance_complete=false. Aucun statut n’a été modifié. Ce résultat clôt un audit de liaison, pas la fonctionnalité ni le jeu.

## Fichiers modifiés dans ce lot

Nouveau rapport : docs/AUDIT_SYS01202_ITEM1058_FLATMAGICDAMAGEMOD_2026-11-02.md.  
Notes de reprise : docs/ai/CURRENT.md, docs/ai/HANDOFF.md et docs/ai/DECISIONS.md.  
Aucun code, registre, goal, interface de suivi ou base n’a été modifié.