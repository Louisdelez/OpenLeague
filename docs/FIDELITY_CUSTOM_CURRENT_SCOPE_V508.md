# Parties personnalisées : sources, préparation locale et portée — V508

25 octobre 2026 — F:\OpenLeague — SYS-01.2-02. Référence conservée : PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau et déploiement non établis. Catalogue 4.20.1 et composant AIR 0.0.1.119 distincts.

## Résultat intégré

Les quatre fiches MODE-CUSTOM SCOPE/SELECT/RULES/RESULT distinguent les contrats historiques de leurs sources AIR et les fondations locales effectivement présentes. Le lien World reste dans les quatre listes brutes et conserve son rôle global Map10 ; il est signalé hors portée de ces contrats historiques. Les preuves du launcher et de la simulation locale sont accessibles en références, sans être promues en implémentation complète du client Custom 4.20.

Les huit questions restent ouvertes avec leurs identifiants, propriétaires, aspects et statuts exacts. Les anciennes formulations « aucun fichier exact trouvé » et « admission de None » sont précisées selon les sources partielles désormais liées et le contrat réel. Anciens textes/conditions en question_history et recherches antérieures en préfixe. Aucune question créée ou résolue, aucune case acceptée. Critères, dépendances, required/required_if et entity.map=null conservés.

Aucun code de production, asset ou binaire du jeu n’a été modifié. Quatorze fiches CoOp/Tutorial/Battle Training et leurs questions/historiques restent exacts. Les lots D01-SYS-01-2 et D11-MODE-CUSTOM et leurs phases sont conservés dans les prérequis du reçu, sans achèvement présumé.

## Sources historiques et manques

Les contrats V384 et V427 restent attribués à leurs qualifications/relectures d’origine, avec leurs stades et limites. V508 réidentifie leurs octets et sélections ; aucune nouvelle décompilation, exécution AIR ou revue indépendante de ces anciens travaux n’est revendiquée.

| Fiche | Sources partielles déjà liées | Ce qui reste à établir |
|---|---|---|
| SCOPE | Quatre autorités AIR119 ; flux Custom/PRACTICE, requêtes et filtres | Provider, liste/création/admission de salons effectives, cartes/modes et disponibilité EUW datée |
| SELECT | Neuf autorités ; minima, sélection, pools/flags/ownership, équipes/bots/spectateurs/skins et ack conditionnels | Composition et protocole réellement produits/validés par le serveur, données actives et parcours ordinaire |
| RULES | Quatre autorités ; configuration, carte, capacité, spectateurs, mutateurs et création | Paramètres effectifs, règles et validations serveur, parcours UI et lifecycle réellement atteints |
| RESULT | Quatre autorités ; DTO/providers, prédicats, retour et rejeu conditionnels | Résultat serveur, bridge natif/AIR, récompenses, retour/rejeu ordinaires et fidélité |

Les 21 occurrences native_inputs restent exactes, 4/9/4/4. Les littéraux PRACTICE_GAME, CUSTOM_GAME et la clé provider custom restent distincts. Les minima et callback différé ne sont pas des gardes atomiques de begin. chooseMap(null) ne vaut pas la remise à zéro d’un autre chemin ; cap*2, override, listes vides, notifications et handlers conservent leurs prémisses. CAP, booléen Join/Create et garde de rejeu Custom ne sont pas la garde Coop. Les trois prédicats WIN, slot[0], OR littéraux et désactivation/cleanup restent séparés. Aucun ID de carte, valeur de configuration ou politique serveur n’est inventé.

Relecture ciblée : 55 occurrences d’ancres de V384 et 306 de V427, soit 361 ; 203 fenêtres de source. Les sources, lignes, aiguilles et SHA de fenêtres correspondent aux reçus. Les 2060 identités vérifiées incluent les entrées de cette collecte, celles des preuves locales réutilisées et du nouveau contrôleur ; ce nombre n’est pas une vérification physique de tout le registre.

## Préparation locale actuelle : six cas réellement exécutés

Le fichier courant launcher/web/app.js est exécuté directement dans un contexte Node VM avec DOM, invoke Tauri et intervalle fournis par des adaptateurs en mémoire. Le roster provient du vrai data/4.20/champions.json. Aucun navigateur, application Tauri, processus de jeu ou service historique n’est lancé ; le binaire installé du launcher n’est pas qualifié par ce contrôle de son fichier source.

| Cas | Attendu du contrôleur actuel | Observé |
|---|---|---|
| Boot et statuts | Actions initialement bloquées ; 122 options après roster ; seuls des booléens true activent les actions | Conforme, défaut garen ; valeurs string/nombre/null non acceptées comme autorisation |
| Play/join et attente | Payload champion/summoners exact ; pas de seconde demande pendant play en attente | Conforme ; play garen + Heal/null, join_local ezreal + null/Smite ; aucune demande de carte/salon/règles dans ces payloads |
| Refus de lancement | Erreur conservée et statut rafraîchi ; actions suivant les flags reçus | Conforme, refus simulé visible avec message de statut |
| Erreur de statut | Actions désactivées, clics bloqués sans demande de lancement | Conforme |
| Erreur de roster | Actions désactivées, aucune poursuite vers statut ou lancement | Conforme |
| Statut ancien arrivé tard | Ne pas réactiver les actions pendant la demande en cours ; statut frais après fin | Conforme pour l’ordre de réponses contrôlé, une seule demande de lancement |

Ces six scénarios couvrent des comportements précis du contrôleur ; ils ne qualifient pas tous les ordres d’interleaving, l’UI réelle, l’autorisation serveur ou les commandes resume/abandon en exécution. Le texte HTML actuel indique « Ouvrir/Rejoindre la partie locale ». Les deux demandes play/join transportent champion et sorts ; elles ne démontrent pas le protocole des salons Custom historiques.

Une nouvelle exécution de contrôleur JS est comptée, avec six cas. Zéro nouvelle exécution du moteur de jeu. Le DOM et les réponses Tauri sont simulés explicitement ; aucun succès de création de processus ou de partie réelle n’est déduit de leur réponse contrôlée.

## Fondations CPU locales héritées

Le reçu V505 est réidentifié, avec ses sources/entrées, toolchain, bibliothèque, sonde, observations et résultats enregistrés. Ses trois cas contrôlés d’admission/remplacement, de résultats des deux équipes et de stockage immuable ne sont pas rejoués. Ils impliquaient six Garen, dégâts serveur injectés et tick 0 ; ils ne sont pas une partie ordinaire ou un protocole Custom historique.

Les fonctions locales Move/Attack, join, capture/stockage de résultat et retour UI ont des portées propres. Les corps courants de launcher, sessions, serveur, world, résultats, stockage et retour client sont lus et conservés dans l’observation. Aucune de ces fondations n’est masquée, mais le seul corps enable_map10 ne démontre pas les contrats Custom SCOPE/SELECT/RULES/RESULT. Son rôle global et les autres associations restent exacts.

La recherche fraîche de littéraux de protocole Custom/PRACTICE parcourt 1203 fichiers Rust/JS/HTML/TS avec target/node_modules exclus : aucun fichier correspondant aux termes ciblés. Les fonctions locales play/join ne sont pas absentes : elles sont examinées séparément et leur contrôleur est exécuté sur les six cas. Le résultat lexical n’est pas une preuve d’absence globale d’implémentation.

## Contrôles du plan et conservation

- 42214 textes de traçabilité comparés : quatre changent, 42210 restent exacts. Cette comparaison n’exécute pas les tâches.
- 40 refus via le validateur public : fausse feature, preuve détachée, non-membre, doublon ; mauvais propriétaire/statut/condition des questions.
- Huit refus de garde lorsque l’historique d’une question est retiré. Le lecteur générique n’impose pas ce nouvel historique ; son acceptation de métadonnées est distincte du refus de la garde de livraison.
- Métadonnées des cinq cibles, SYS inclus, comparées au sélecteur avant publication. Préparation : cinq nominaux et six refus de sélecteur.
- Huit questions précisées, anciens textes/conditions/recherches récupérables, compteurs et tous les autres enregistrements exacts ; zéro création/résolution. Tous les records de consommateurs inchangés, aucun CID ni lien natif/consommateur ajouté.
- Vrais Store.task/copy_text, requirement_trace.resolve et instructions des cinq fiches relus dans les deux bases après publication et par audit séparé. Cases, notes, historiques et autres lignes contrôlés, sans initialisation Store ni acceptation automatique.

Les quatre registres changent uniquement selon le delta attendu, avec sauvegardes. Le reçu ajoute les sources de preuve de collecte, d’exécution JS contrôlée et de livraison ; ces sources ne sont pas des ressources originales du jeu nouvellement récupérées.

## Identités, commandes et livraison

Node exécuté : C:\Program Files\nodejs\node.exe, 89953280 octets, SHA256 `d14ba95cdce1ef7dc9ad3ac74949ca5db38b27378ee30f30a23cf26f9e875a11`. UI_OBSERVATIONS.json : 1818 octets, SHA256 `d438513bd029f040b2145f6af4324567a362d4de7d4ffc791cbb9fb88051cde6`. CURRENT_UI_CONTROLLER.json : 3002 octets, SHA256 `adb19248865c9dc69e8c21ff71bddaf5fb928351c1afa634c33005815ac10141`.

CUSTOM_SCOPE_OBSERVATIONS.json : 1694908 octets, SHA256 `2ac78668e9174e15b96a28b539730ead3391604c17ec0e6c2e1c7ee71b9f8b44`. Les entrées sont vérifiées avant/après ; commande Node, source réelle, adaptations, sorties et code terminal sont conservés. Python -X utf8 -E -u -B exécute le wrapper UI, le collecteur, delivery prepare, le candidat, delivery publish et audit. Les identités de l’interpréteur, des scripts et dépendances réellement utilisés sont dans les reçus.

Rapport docs/FIDELITY_CUSTOM_CURRENT_SCOPE_V508.md ; reçu docs/reference_custom_mode_roles_sources/custom-current-scope-v508.json ; preuve docs/fidelity_custom_current_scope_v508.json. Quatre registres et deux bases actualisés ; couverture, plan et reprise mis à jour. Détail sous F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision508*, dont revision508_ui_checks et revision508_inspection.

Restent les salons et leurs opérations natives, leurs paramètres/cartes/modes effectifs, équipes/spectateurs/bots et sélection, réponses/providers/validation serveur, résultat/retour/rejeu ordinaires et fidélité humaine. Aucun jeu original, AIR, VM Lua, processus serveur/client, compilation Rust, GPU ou audio n’est exécuté. Les preuves locales permettent de préciser le travail disponible et les manques ; le mode historique, SYS-01.2-02 et le jeu restent ouverts.

Bilan vérifié : trois sources de preuve ajoutées ; aucun CID ou lien natif/consommateur nouveau ; 21 occurrences natives et tous les records de consommateurs exacts. Quatre références hors portée sur quatre fiches ; huit questions affinées, anciens textes/conditions/recherches conservés, zéro création/résolution. Graphe : 98709 sources / 2608 consommateurs / 25827 ouvertes / 5517 résolues avec historique. Deux bases : cinq fiches relues chacune, 42601 autres lignes de catalogue exactes ; 42606 états/notes et 23 historiques exacts, intégrité OK. Wrapper Node/collecte/préparation/candidat/publication/audit terminaux 0. Une exécution JS contrôlée avec six cas ; zéro exécution actuelle du moteur de jeu, trois cas CPU historiques non rejoués. Sous-inventaire :11à reprendre/477partielles/52lignes horsportée encore ouvertes dont27audio ;deux liens World de tâches TTpartielles comptés séparément.
