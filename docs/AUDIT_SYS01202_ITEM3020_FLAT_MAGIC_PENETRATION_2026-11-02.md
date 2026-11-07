# SYS-01.2-02 — item 3020 : pénétration magique plate et consumer actuel

Date de contrôle : 2026-11-02 UTC. Unité : `AUD-SYS01202-ITEM3020-FLAT-MAGIC-PENETRATION-01`. Exigence parente : `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`.

## Lot, frontière et décision

Question : la pénétration magique plate du client LoL 4.20 pour les Chaussures de sorcier est-elle reliée à la donnée Map10 et au chemin de dégâts magiques courant ?

Résultat attendu de cette unité : confirmer l’ID, la valeur native de `Effect1Amount`, sa traduction en `magic_penetration`, l’admission Map10 et le consumer avant mitigation magique. Cas nominal dans le modèle local : 100 résistance magique avec 15 pénétration plate donne 85 avant mitigation. Limites retenues : 10 résistance devient zéro après plancher; une résistance nulle ou négative reste inchangée.

**Décision :** l’audit statique de cette relation est terminé. Source, donnée locale et consumer sont reliés; un contrôle ciblé confirme que la propriété native `Effect1Amount` est présente et vaut 15. Le fonctionnement en exécution et la sémantique historique du serveur ne sont pas validés. Cette unité ne clôt pas l’objet complet, le parent SYS-01.2-02 ou le jeu.

## Source et identité

Source native : `DATA/Items/3020.inibin`, build de référence `PUBLIC 4.20.0.315 EUW/en_GB`, release extraite `0.0.1.68`. `docs/fidelity_sources_4_20.json` l’identifie par `OLS-c77f6e97-aa8a-5d4f-96e7-9659b9f8ca19`, taille 532 octets, SHA-256 `aaaa96411913f9dd6e9f0df15f501530597155b51107a53c7667a7b88407a260`; le hachage a été relu et concorde.

Le reçu de membership associe le chemin, la taille et le MD5 au manifeste sélectionné : projet `lol_game_client`, project release `0.0.1.7`, release `0.0.0.242`. Il précise toutefois que la precedence effective dans le runtime historique n’est pas qualifiée.

Le reçu communautaire compare ce fichier à `LeagueSandbox-Default/Items/3020/3020.json` : 72 champs égaux, 0 différents et 1 clé native manquante selon le résumé. Le miroir porte le SHA-256 `a60e28a37654b1fc2f5ba43006d8ea80f931736bce96b965c8ee24633bcc592a`; son `ContentFormatVersion=4` est un schéma d’export, et son commit exact est inconnu. Le résumé ne nomme pas la clé manquante. Un contrôle direct, limité aux 52 noms de `Values.Data` du miroir, a calculé leurs hashes `Data*Nom` contre l’INIBIN : les 52 sont présents, dont `Effect1Amount`. L’écart agrégé non identifié reste ouvert hors du champ de cette valeur.

Le lecteur existant en lecture seule `tools/project-plan/reference_inibin.py` a décodé `Data*Effect1Amount=15`, `Data*FlatMovementSpeedMod=45`, `Data*Price=775` et `Data*RecipeItem1=1001`. Le champ de pénétration est corroboré sans attribuer au miroir une autorité serveur.

## Donnée et consumers courants

`data/4.20/shop_foundation.json`, item 3020, associe le même SHA natif à `magic_penetration=15`, `move_speed=45`, `group=BootsNormal`, `unique_penetration=false`, recette 1001 et coût total local 1100. `data/4.20/map10_shop_admission.json` admet l’item.

Le consumer physique/magique commun a été inspecté en V840–V841; ses empreintes sont réutilisées depuis ces reçus, car aucun code n’a été modifié entre ces lots :

- `crates/core/src/shop.rs` ajoute le bonus plat à `Bonuses.magic_penetration`.
- `crates/core/src/progression.rs` transmet ce bonus à `Stats`.
- `crates/core/src/penetration.rs` choisit la résistance magique pour les dégâts magiques; sur une résistance positive, applique `max(RM × (1 − pénétration % ) − pénétration plate, 0)`. Les valeurs non finies et paramètres invalides sont refusés; la résistance nulle ou négative est préservée.
- `crates/core/src/damage.rs` appelle ce consumer avant mitigation pour les champions et unités.

Le test source `penetration.rs::boot_upgrade_unique_group_and_separate_magic_pen_sources` achète les bottes 1001 puis 3020, attend que 3020 remplace l’item de groupe et porte `Stats.magic_penetration=15`, puis vérifie des refus de doublon et l’ajout d’une seconde source magique. Il n’a pas été exécuté. Il couvre le comportement prévu par le simulateur courant, pas le serveur historique.

## Attendu, observé et contrôles

- Attendu nominal local : 100 RM − 15 = 85 RM avant mitigation magique.
- Attendu limite local : 10 RM − 15 est planché à 0; RM nulle ou négative reste inchangée.
- Observé statiquement : le champ natif vaut 15; le catalogue conserve le même SHA et porte `magic_penetration=15`; l’admission Map10 est vraie; le consumer courant transmet le bonus aux dégâts magiques.
- Contrôles exécutés : décodage en lecture seule du fichier natif; SHA-256; lecture ciblée du comparatif et du membership; comparaison des 52 noms de champ `Values.Data`; inspection du seul item, de son admission et du test source existant.
- Contrôles non exécutés : tests Rust, build, binaire, achat, dégâts observés, réseau, client graphique ou runtime serveur.

Le calcul 100→85 est une conséquence de l’expression source inspectée, pas une mesure de gameplay.

## Écarts et condition de reprise

Restent ouverts : identité de l’unique champ non expliqué dans le résumé comparatif global; priorité runtime de la ressource; règle de pénétration du serveur 4.20.0.315; comportement du build courant avec achat, défense positive/faible/négative et dégâts réseau; acceptation humaine. Le présent périmètre établit précisément la propriété `Effect1Amount=15`; il ne résout pas les autres propriétés de l’objet.

Proposition documentaire non inscrite au registre : `OPEN-ITEM-3020-CURRENT-MAGIC-PENETRATION-VERIFY`. Reprise lorsque la vérification est autorisée et liée aux empreintes courantes : achat 3020, `Stats.magic_penetration=15`, cas 100 RM→85, cas 10 RM→0, RM non positive inchangée, puis hit magique séparé sur champion et unité. Identifier la clé manquante du comparatif uniquement si une source ou décision nouvelle en dépend; ne pas refaire la comparaison globale. Séparer l’acceptation humaine.

## Relecture des sept critères

1. Exigence et frontière limitées à la pénétration magique plate du 3020.
2. Source native, hash, membership, champ décodé, comparaison miroir et limites consignés.
3. Donnée Map10 et consumer courant reliés par inspection réutilisée.
4. Cas nominal et limites explicités comme attendus statiques; aucun test/runtime prétendu.
5. Incertitudes et condition de reprise précises, y compris la clé agrégée inconnue.
6. Correction/runtime task définie par ID proposé et critères, sans modifier le registre.
7. Preuves, contrôles et date répertoriés; aucun code modifié.

**Clôture limitée :** cartographie statique de la valeur 15 du 3020 terminée. Implémentation locale présente; vérification en exécution et fidélité serveur non établies. Aucun code, registre, goal, Plan, application ou base de suivi modifié. Aucun logiciel installé, aucune migration, aucun test/build/runtime lancé.
