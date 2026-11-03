# Audit de liaison — item 3101, vitesse d’attaque

Date : 2026-11-02  
Unité : AUD-SYS01202-ITEM3101-ATTACK-SPEED-01  
Tâche : ITEM-3101-SERVER-STAT-PercentAttackSpeedMod  
Exigence : OLF-7a155a8b-c2db-5543-98d8-cb2150d8e62a  
Source native : OLS-446a1b39-0e8e-59a2-a11b-4ca0af960dab

## Portée et critères

Vérifier le lien statique entre le champ natif `Data.PercentAttackSpeedMod` de l’objet 3101, sa valeur dans le catalogue de jeu F, et les consommateurs réels de cette valeur. Exclure la qualification complète de disponibilité historique Map10, le passif de réduction des délais, le prix/recette, l’interface, le comportement runtime et l’acceptation humaine.

Résultat attendu : valeur native décodée égale à la valeur locale, reliée à l’accumulation des bonus d’inventaire puis au calcul du délai d’attaque. Un objet absent ou non admis doit rester refusé explicitement.

## Sources et identité

Le client fourni indique League of Legends 4.20.0.315, EUW/en_GB. La source est `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\3101.inibin` : 547 octets, SHA-256 `1c38a8625b5295556fdb4f699d6c21a8871c82f3e6345699f313a21b0f20cc39`, MD5 `d919d194aaf317ce1454b34471ab6653`.

Le reçu `docs/reference_native_skin_loader_sources/native-release-membership.json`, ligne 30996, relie exactement ces octets au membre `DATA/Items/3101.inibin` du projet `lol_game_client` release `0.0.1.7`, payload `0.0.0.242`; taille et MD5 correspondent. L’appartenance au manifeste est établie ; priorité historique effective des overlays non établie.

Le décodeur local `tools/references/lolpytools/lolpytools_inibin2.py` a lu `Data.PercentAttackSpeedMod = 0.4`. Le même décodage indique aussi `InStore=1`, mais ce bit ne suffit pas à qualifier la disponibilité historique sur Map10.

## Consommateur actuel et comparaison

Le registre de traçabilité relie la tâche à l’entrée locale `data/4.20/shop_foundation.json#/items/23`, source OLS-0423131f-6ac0-52ed-8973-d56afac44144. Pour l’objet 3101, `attack_speed=0.4`; son `source_sha256` est identique au SHA-256 de l’INIBIN. Le catalogue Map10 contient l’objet et `map10_shop_admission.json` donne `allowed=true`.

Le chemin courant est :
- `crates/core/src/shop.rs:69` résout un ID dans le catalogue ;
- `shop.rs:215-240` parcourt l’inventaire et additionne `v.attack_speed` ;
- `crates/core/src/progression.rs:119-125` lit `items.attack_speed` dans le dénominateur du délai d’attaque, puis applique l’arrondi entier et le plancher de 12 ticks.

Valeur attendue : +0.4, soit le modificateur de +40% encodé par la source. Valeur observée en statique : 0.4 dans le binaire décodé, 0.4 dans le catalogue et une addition directe de cette valeur dans le consommateur. Aucun scénario numérique par champion/niveau n’a été exécuté.

Le registre associe actuellement l’exigence à `OLC-b38bc16e-af3e-565e-8e4a-e8549549a702`, qui est seulement la recherche dans le catalogue. Les points d’application plus précis sont déjà recensés comme `OLC-f7685945-0b80-5bb7-a083-df3208bb5c5d` (`shop.rs:239`) et `OLC-7889a3f2-d6a8-55e9-ae7b-7af0b7921369` (`progression.rs:119`). Le premier reçu est borné à une observation de cadence Jax ; le second décrit le calcul courant de cadence, sans établir l’arrondi serveur natif. Le lien doit conserver ces limites.

## Cas nominal, refus et limites

- Nominal attendu/observé statiquement : 3101 est dans le catalogue, l’admission Map10 locale est vraie, et son bonus 0.4 atteint le terme `items.attack_speed`.
- Refus attendu par le code : ID sans entrée catalogue → `item behavior not implemented`; admission Map10 explicitement fausse → `item unavailable on Map10`; admission absente → `item map availability not qualified`. Ces branches n’ont pas été exécutées.
- `Price=350` dans l’INIBIN et prix total local 1250 relèvent du prix/recette, hors de cette unité. Le catalogue 4.20.1 est une référence distincte du binaire 4.20.0.315.
- La disponibilité locale Map10 ne prouve pas la disponibilité historique globale. La tâche parent `ITEM-3101-SCOPE` reste `partiel_a_terminer`; la tâche statistique demeure conditionnelle, `a_faire`, et non acceptée.

## Conclusion et contrôles

Audit statique du lien source → donnée → consommateur terminé pour le seul champ d’attaque-speed. L’implémentation locale est présente ; ce constat ne valide ni le comportement historique du serveur, ni la cadence observée en partie, ni l’objet complet.

Contrôles exécutés : empreinte SHA-256 du binaire, relecture du membership enregistré, décodage INIBIN, comparaison des valeurs JSON, admission Map10, inspection des ancres Rust et des refus. Tests Cargo, exécution de simulation, lancement du jeu, capture runtime et validation humaine : non exécutés.

Aucun code, statut de tâche, goal, application de suivi ou base de données n’a été modifié. La tâche et la portée fonctionnelle restent ouvertes.

## Correction documentaire identifiée

Réutiliser la tâche existante `ITEM-3101-SERVER-STAT-PercentAttackSpeedMod`; aucune tâche fonctionnelle nouvelle n’est nécessaire pour ce champ. Pour compléter la traçabilité, enrichir l’entrée `OLF-7a155a8b-c2db-5543-98d8-cb2150d8e62a` de `fidelity_requirement_trace_4_20.json` avec le consommateur de calcul `OLC-7889a3f2-d6a8-55e9-ae7b-7af0b7921369`, en conservant `OLC-b38bc16e-af3e-565e-8e4a-e8549549a702` pour la recherche catalogue. Garder `game_behavior_accepted=false` et la limite d’arrondi serveur. L’ancre `OLC-f7685945-0b80-5bb7-a083-df3208bb5c5d` reste un point d’accumulation observé avec portée Jax bornée, pas une preuve générale d’acceptation.

Critère de fin de cette correction documentaire : relecture de l’entrée exacte confirme les deux consommateurs et la source native; le JSON demeure valide; aucun statut de tâche, décision de scope ni acceptation du jeu n’est changé. Cette correction n’a pas été appliquée dans le présent lot.

## Empreintes des fichiers F inspectés

- `data/4.20/shop_foundation.json` : SHA-256 `504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae ` (catalogue relu; l’entrée 3101 porte `source_sha256` natif exact).
- `data/4.20/map10_shop_admission.json` : SHA-256 `6393e7c2a39abed63b6f3db36c265e94d5ce2fc5435e29c17ccf012f288ad485`.
- `crates/core/src/shop.rs` : SHA-256 `3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0`.
- `crates/core/src/progression.rs` : SHA-256 `eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766`.

Le seul fichier créé par ce lot est le présent rapport.
## V828 — preuve d’exécution du consumer générique attack_speed

Le lien natif 3101 → catalogue 0,4 → shop::bonuses → progression::stats reste celui établi dans ce rapport; ses empreintes natives et de source ne sont pas recalculées. Pour vérifier le comportement du consumer commun sans compiler de nouveau, exécution du test existant shop::tests::boots_group_is_unique_and_dagger_changes_attack_cadence.

Attendu pour cette limite de portée : la Dague 1042 augmente la vitesse d’attaque via le même champ d’accumulation, réduit le délai en ticks, puis sa vente restaure la cadence initiale; un doublon de bottes est refusé sans débit. Observé : test direct réussi, 1 passé, 0 échoué (1 926 filtrés). La commande Cargo n’a pas été relancée. Binaire identifié : target/debug/deps/openleague_core-21eb81eb13817108.exe, 787 789 824 octets, daté du 2026-10-21 10:19:25Z, SHA-256 46D3732181601E8BFDC1923857D66192FD2A18FBA13FE7AA3BD2F80876F74E6D. Les empreintes courantes de shop.rs, progression.rs, shop_foundation.json et map10_shop_admission.json correspondent aux empreintes de la section précédente.

**Limite décisive :** ce test achète 1042, pas 3101. Il confirme le consumer générique de vitesse d’attaque et son retour à la base après vente; il ne vérifie ni la valeur +0,4 de 3101 dans une partie, ni l’arrondi historique du serveur 4.20, ni l’admission historique. Le résultat source → catalogue de 3101 demeure statique; aucun comportement spécifique de l’objet n’est déclaré vérifié.

Aucun code, asset, registre, goal, Plan, application ou base de suivi n’a été modifié. Cet addendum ferme seulement la vérification du consumer générique pour ce champ; les limites spécifiques à 3101 restent ouvertes.
