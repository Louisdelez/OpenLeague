# SYS-01.2-02 — objet 1038 : source et refus d’achat sur Map10

Date : 2026-11-02

## Portée de cette unité

Ce sous-audit vérifie le lien entre le fichier natif de l’objet 1038, sa donnée de boutique locale et le refus d’achat du consumer Map10 actuel. Il ne décide pas de la disponibilité de l’objet dans la partie historique EUW de la version 4.20.0.315 et ne clôt ni ITEM-1038-SCOPE ni SYS-01.2-02.

## Source 4.20 et données locales

Les enregistrements existants sont réutilisés; aucun INIBIN n’a été redécodé ou rehaché :

- Référence : client PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB.
- Source native : DATA/Items/1038.inibin, OLS-31246393-cf24-581a-8913-c62ed5f818d5, 519 octets, SHA-256 42182e67c23fdec497f440cf5e9c4791a18d1d773cea43107625e0268eae17d4; identité vérifiée.
- Membership : DATA/Items/1038.inibin correspond au manifeste lol_game_client, projet 0.0.1.7, release membre 0.0.0.237; taille et MD5 concordent. La priorité effective au runtime n’est pas qualifiée.
- Données natives déjà décodées : Price=1550, FlatPhysicalDamageMod=50, InStore=true, CanBeSold=true.
- shop_foundation.json conserve le prix 1550, +50 dégâts d’attaque et le SHA-256 natif. map10_shop_admission.json porte allowed=false.
- Le catalogue comparatif officiel local Data Dragon 4.20.1 indique aussi maps["10"]=false pour l’objet 1038. Ce catalogue est une révision distincte; il ne prouve pas à lui seul la disponibilité historique du build client 4.20.0.315.
- InStore=true est une donnée du fichier d’objet, tandis que le refus Map10 est une admission de carte séparée; ces valeurs n’établissent pas à elles seules une contradiction.

## Consumer actuel et contrôle réutilisé

Dans crates/core/src/shop.rs, buy_item vérifie la politique si le monde Map10 est actif et retourne item unavailable on Map10 quand map10_available donne Some(false), avant le calcul du devis et le débit. Le consumer de statistiques conserve l’effet dégâts de l’objet pour un inventaire qui le contient; ce fait de code ne rend pas l’achat disponible sur Map10.

Le rapport V832 sur l’objet 1026 contient le reçu réutilisable du binaire précompilé : both_excluded_items_are_rejected_atomically_with_sufficient_gold_and_empty_or_full_inventory passe 1/1 pour les IDs 1038 et 1058. Les cas 1038 ont 10 000 or, inventaire vide ou plein, et attendent le refus exact, un état de champion inchangé et aucun changement de tick. Aucun test n’a été lancé dans le présent lot.

Le fichier source actuel crates/core/tests/map10_shop_admission.rs contient le contrat correspondant, mais annonce explicitement des tests préparés sans prétention d’exécution. Le reçu V832 est celui d’un ancien binaire, pas une exécution de cette révision source. Binaire documenté par V832 : map10_shop_admission-a6a46c157264e4a3.exe, 6 056 960 octets, 2026-10-21T10:16:13Z, SHA-256 7791975EFF9F583C94791B54664393DD05447AEEF7C504D705B623B74BD4A80A. La correspondance exacte entre ce binaire et les sources actuelles n’est pas établie.

## Résultat, limites et reprise

Lien d’audit source → donnée → règle de carte → consumer local fermé pour le refus d’achat Map10, avec la réserve explicite sur le reçu précompilé. La comparaison 4.20.1 et le comportement local ne démontrent pas la disponibilité historique du serveur 4.20.0.315. ITEM-1038-SCOPE reste partiel_a_terminer et acceptance_complete=false; aucun statut de registre n’a changé.

À établir pour reprendre les écarts : une preuve primaire propre au build 4.20.0.315 de l’admission 1038 par carte/file, la priorité de chargement effective et, si une vérification runtime est requise, un binaire lié aux empreintes courantes. La revente native et l’affichage/localisation ne sont pas établis par ce lot. Le nom local « BF Glaive » diffère de « B. F. Sword » dans le catalogue comparatif; ne pas le corriger sans preuve de locale et source de chaînes.

Aucun code, task registry, goal, Plan, application de suivi ou base de données modifié. Aucun test, build, installation ou migration exécuté dans ce lot.