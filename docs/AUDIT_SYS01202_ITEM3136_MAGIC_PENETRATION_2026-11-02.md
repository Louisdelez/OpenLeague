# SYS-01.2-02 — item 3136 : pénétration magique unique et consumer actuel

Date de contrôle : 2026-11-02 UTC. Unité : `AUD-SYS01202-ITEM3136-MAGIC-PENETRATION-01`. Exigence parente : `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`.

## Lot, frontière et décision

Question : le montant de pénétration magique du Déguisement hanté est-il relié à la source native, à la donnée Map10 et au consumer des dégâts magiques ?

Résultat attendu de l’audit : établir une source primaire qui donne le sens du champ d’effet `Effect1Amount=15`, confirmer la valeur locale/admission et identifier le chemin courant. Attendus du modèle local : 100 résistance magique devient 85 avant mitigation; 10 devient 0 après plancher; résistance nulle ou négative demeure inchangée.

**Décision :** la cartographie documentaire du champ 15 est terminée pour ce périmètre. Le fichier natif INIBIN porte la valeur numérique; le tooltip natif en_GB nomme cette valeur comme pénétration magique; le catalogue et le consumer courant portent la même valeur. Les tests sources restent non exécutés. Cette clôture ne valide ni le calcul historique du serveur, ni le jeu complet, ni l’acceptation humaine.

## Sources primaires et identité

La ressource native `DATA/Items/3136.inibin` est enregistrée sous `OLS-e28ed3b4-c7d2-51aa-8b4e-be9a65c6dc40` : 527 octets, SHA-256 `719b06c4442d2a105ee4304b9ffebdf9b59afc6ffc96f1b56ef1a55f21933858`, version attribuée `PUBLIC 4.20.0.315 EUW/en_GB`, release extraite `0.0.1.68`. Le hachage relu concorde. Le membership existant associe le contenu au manifeste sélectionné (project release `0.0.1.7`, release `0.0.0.239`); la precedence effective au runtime n’est pas établie.

Le lecteur local en lecture seule `tools/project-plan/reference_inibin.py` décode `Data*Effect1Amount=15`; le reçu de comparaison communautaire donne 70 champs égaux, 0 différents, 0 clé native absente. Le miroir communautaire reste un recoupement, pas une autorité serveur; son commit exact n’est pas établi.

La piste sémantique auparavant manquante est résolue par la source primaire d’interface `DATA/menu/fontconfig_en_GB.txt`, clé `game_item_description_3136`, ligne 6779. Identité dans `docs/fidelity_sources_4_20.json` : `OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d`, 2 220 957 octets, SHA-256 `1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3`; hash relu concordant, membership du fichier au projet client confirmée. La phrase localisée associe explicitement +15 à Magic Penetration et précise que les passifs uniques de même nom ne se cumulent pas. Cette preuve qualifie le texte livré au client, pas la logique serveur.

L’ancien reçu `docs/penetration_item_sources.json` garde `native_magic_penetration=null` pour les statistiques nommées; ce champ vide de l’extraction ne signifie pas que le tooltip natif est absent. Le tooltip et le champ générique `Effect1Amount` établissent ici le lien documentaire demandé.

## Donnée et consumers courants

`data/4.20/shop_foundation.json`, item 3136, déclare `magic_penetration=15`, `unique_penetration=true`, 25 AP, 200 PV, recette 1028+1052, coût total local 1485 et le SHA natif correspondant. `data/4.20/map10_shop_admission.json` admet l’objet.

Le chemin magique commun est réutilisé depuis V840–V843, sans rescanner les mêmes callsites :

- `crates/core/src/shop.rs` agrège le bonus et ne cumule pas une seconde occurrence de même ID lorsque le passif est marqué unique.
- `crates/core/src/progression.rs` reporte `magic_penetration` dans `Stats`.
- `crates/core/src/penetration.rs` réduit la résistance magique positive par la pénétration plate puis planche à zéro; MR non positive inchangée.
- `crates/core/src/damage.rs` applique ce calcul avant mitigation magique pour champions et unités.

Tests source déjà repérés, non exécutés :

- `boot_upgrade_unique_group_and_separate_magic_pen_sources` achète deux 3136 après 3020 et attend 30 de pénétration magique au total, soit une seule occurrence de la passive 3136, tandis que l’AP directe s’additionne.
- `source_owned_items_change_damage_without_mutating_target_stats` mélange 3136 et 3135 puis compare les dégâts magiques à l’attendu du modèle.
- `ultimate_retains_caster_penetration_and_kill_attribution` applique la pénétration du 3136 à la résistance de la cible dans un scénario de sort.

Ces tests décrivent le comportement prévu du simulateur local; aucun n’a été lancé dans ce lot.

## Attendu, observé et contrôles

- Attendu nominal local : 100 RM − 15 = 85 avant mitigation.
- Limites attendues : 10 RM − 15 est planché à 0; RM=0 ou négative est préservée.
- Observé statiquement : INIBIN 15; tooltip natif en_GB le nomme pénétration magique; donnée locale 15 avec même SHA; admission Map10 vraie; chemin `shop → Stats → pénétration → damage` présent. Les valeurs 85/0 sont des conséquences du code inspecté, pas des mesures de gameplay.
- Contrôles effectués : décodage en lecture seule du seul INIBIN; rehash des deux ressources natives; lecture du comparatif, des memberships et de la clé de localisation en_GB; lecture des entrées catalogue/admission, des tests qui mentionnent 3136 et réutilisation de l’empreinte du consumer commun.
- Contrôles non exécutés : tests Rust, compilation, binaire, achat, dégâts observés, réseau, client graphique ou serveur historique.

## Écarts et condition de reprise

Reste à prouver : priorité effective de la ressource dans le runtime historique; logique serveur 4.20.0.315 derrière le tooltip; achat et dégâts sur un build lié aux empreintes courantes; comportement réseau; empilement entre objets portant des passifs distincts; acceptation humaine. L’admission Map10 locale n’établit pas l’offre dans chaque région ni la politique serveur.

Proposition documentaire non inscrite au registre : `OPEN-ITEM-3136-CURRENT-MAGIC-PENETRATION-VERIFY`. Reprise sur vérification autorisée liée aux empreintes actuelles : achat isolé de 3136 et `Stats.magic_penetration=15`; résistance 100→85 et 10→0; non-cumul du doublon 3136; résultat séparé sur champion et unité, puis preuve réseau si nécessaire. Toute conclusion serveur doit avoir une source versionnée.

## Relecture des sept critères

1. Exigence et frontière limitées à la valeur de pénétration magique du 3136.
2. INIBIN numérique, tooltip primaire localisé et memberships identifiés; limites de precedence et serveur explicitées.
3. Donnée locale/admission et consumer courant reliés.
4. Attendus, constat statique, contrôles exécutés et non exécutés séparés.
5. Limites et reprise nommées précisément.
6. Vérification fonctionnelle future dotée d’un ID proposé, sans changer le registre.
7. Rapport daté et références vérifiables; aucun code modifié.

**Clôture limitée :** correspondance documentaire entre le tooltip natif du 3136, le champ d’effet 15, le catalogue et le consumer local terminée. Vérification d’exécution, fidélité serveur et acceptation restent ouvertes. Aucun code, registre, goal, Plan, application ou base de suivi modifié; aucun logiciel installé, aucune migration et aucun test/build/runtime lancé.
