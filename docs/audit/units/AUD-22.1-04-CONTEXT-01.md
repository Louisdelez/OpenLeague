# AUD-22.1-04-CONTEXT-01 — Contextes des quatre-vingt-dix Text restants

Contrôle du 30 octobre 2026 ; reçu à 12:54:44 UTC. Parent SYS-22.1-04. Résultat documentaire du goal SYS-01.2-02, sans modification du Goal, du jeu, de l'application de suivi ou de ses bases.

## 1. Périmètre, critères de fin et décision

Question : à quels panneaux et groupes source appartiennent les 90 Text restants de la capture HUD-01 ; quels sont leurs états initiaux ; jusqu'où les charge et les consomme le client actuel ?

Critères : classer exactement les 90 IDs encore sans contexte, vérifier leurs octets et leur appartenance à la liste chargée, distinguer définition/activation/donnée/rendu, identifier les consommateurs actuels ou l'absence bornée de producteur, préserver la réparation existante, rattacher chaque contexte à un travail de reprise précis.

**Audit de classification terminé pour ces 90 définitions.** Leurs activateurs historiques, leur pertinence dans chaque mode, leurs valeurs et leur rendu ne sont pas tous qualifiés. L'audit de ces inconnues constate leur frontière ; il ne déclare pas les fonctionnalités correspondantes réalisées.

| Dimension | État |
|---|---|
| Audit | Terminé sur provenance, contexte initial et raccordement actuel de ces 90 Text |
| Implémentation | Définitions chargées par le provider normal ; aucun producteur de valeur identifié pour ces champs dans les routes de texte inspectées |
| Vérification | Comparaisons de données/code exécutées ; anciennes captures natives de scènes et de boucle de fichier réutilisées ; aucune nouvelle exécution Rust/native/graphique |
| Acceptation humaine | Non demandée |

La capture de 154 Text est maintenant rapprochée intégralement par IDs, une seule fois : 25 sélectionnés dans les trois routes de glyphes, 39 définitions de buffs non sélectionnées déjà classées, 90 autres classées ici. Ce résultat ne couvre pas tous les textes historiques, toutes les routes locales ni toutes les clés de traduction. SYS-22.1-04 reste ouverte.

## 2. Sources, provenance et réparation préservée

Le corpus de HUD-01 et ses 498 sources Rust ont leurs empreintes inchangées. Les 90 enregistrements restent reliés individuellement à leur nom, chemin, offset et empreinte dans `data/4.20/native_hud_source_records_contract.json` ; les offsets de cette capture désignent les octets originaux, pas un éventuel fichier réparé.

Les deux HUD.zip sont relus : celui consommé sous `F:/OpenLeague/data/4.20/archives/menu/HUD.zip` et celui fourni sous `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/menu/HUD.zip`. Chacun fait 122169 octets, SHA256 `76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c`.

Dans chaque archive, 31 membres uniques sont comparés : 27 fichiers de ces Text, FastHUD.ini, les listes ShadowIsles Normal/Flipped et Scenes.ini. Tous les membres de layout correspondent aux entrées capturées ; les membres des deux copies sont identiques. La release/priorité historique de montage des ZIP demeure la limite héritée de V226, distincte de cette identité d'octets.

`HUD/Scenes.ini` fait 5056 octets, SHA256 `1281ca4388dd2aa7a427240abeaae43501c84ebbcad2a6314118d9df2c4d9dd4`. Ses 48 groupes correspondent au cas original du contrat `data/4.20/native_hud_scenes_contract.json` : noms, couches et bit Enabled comparés. Vingt-huit de ces groupes sont référencés par les 90 Text. Le contrat conserve 19 anciens cas ; le cas original consomme le fichier complet. Services de registre/arbre et contexte CRT avaient des adaptations ; l'activation, les paramètres, la durée de vie et le dessin complet restent hors de cette preuve. Aucune de ces exécutions n'est rejouée.

Réparation existante de LossOfControlUI préservée : `data/4.20/hud_restored/HUD/Elements/LossOfControlUI.ini`, 8024 octets, SHA256 `56479f80a3d33dafd77cb67b59e311dcd0d998b8d3b824ba933af16fb77b7968`. L'unique ligne ajoutée est `BaseOffset: 0,0`. Les huit blocs Text sont identiques à leurs blocs originaux. Les entrées original/restored du contrat `native_hud_file_loop_contract.json` correspondent aux octets actuels.

Limite explicite : l'ancienne boucle native comptait zéro affectation d'en-tête sur l'original, deux sur le réparé, et **deux avertissements sur le réparé**. Ceux-ci restent hérités, sans nouvelle exécution ni déclaration de réparation intégrale. Le provider actuel vérifie les deux identités avant d'utiliser le fichier réparé. L'autre réparation TargetBar_Buffs demeure qualifiée séparément dans BUFF-01.

## 3. Contextes et consommateurs actuels

Le chemin effectif inspecté est `native_zip_provider::startup_hud`, lignes 71-118 : FastHUD.ini → section ShadowIsles → ElementsListNormal → 32 layouts → réparation qualifiée éventuelle → structure/effets → groupes et textures → demandes de police. Charger un Text ou créer sa demande de police ne remplit pas sa valeur et ne prouve pas son dessin.

Les listes Normal et Flipped ont chacune 32 entrées ; quatre positions diffèrent (minimap, panneau du champion, statistiques et VisionSlot). Le provider observé lit explicitement ElementsListNormal. La présente qualification de cette racine ne s'étend pas aux autres listes, au spectateur ou à leur sélection au cours d'une partie.

| Contexte documentaire | Text et nombre | Rattachement existant |
|---|---|---|
| TOOLTIP_POSITION | SpellToolTip, StatusMessageToolTip : 2 | SYS-17.2-07, SYS-22.1-04 |
| POOL_REGEN | HPRegenStat, MPRegenStat : 2 | SYS-17.1-02 |
| ABILITY_EXTRA | PassiveCooldown ; SpellAmmo0..3 ; SummonerSpellAmmo0..1 ; RecallHotKey ; LevelUpBarPoints : 9 | SYS-17.1-03/04, SYS-17.4-01 |
| TARGET_STATS | TargetLevel, TargetHPStat, TargetMPStat et six statistiques : 9 | SYS-17.1-07 |
| TARGET_ITEMS | TargetItem0_Count..TargetItem5_Count : 6 | SYS-17.1-07/05 |
| OWNER_STATS_AND_KEYS | AvatarName ; AD/AP/AS/MS/Armor/MRStat ; InventoryItemHotKey0..5 : 13 | SYS-17.1-02/05, SYS-17.4-01 |
| MATCH_COUNTERS | Kills/Deaths/Assists/MinionKillsStat ; compteurs de kills/minions des équipes ; deux textes FirstBlood ; FPS : 11 | SYS-17.1-08 |
| DOMINION_SCORE | ScoreStat et ScoreStatOverlay, groupes TitanBarOdin : 2 | SYS-22.1-04 ; applicabilité à qualifier |
| TEAM_FRAMES | TeamLevel0..4 et TeamRespawnTimer0..4 : 10 | SYS-17.1-08 |
| EVOLUTION_TITLE | EvolutionBarTitle : 1 | SYS-22.1-04 |
| MODAL_MESSAGE | MB_Base_Text et MB_Title_Text : 2 | SYS-22.1-04 |
| LOSS_OF_CONTROL | Quatre paires SpellCooldown/Text et six paires AbilityCooldown/Text : 20 | SYS-17.5-01, SYS-22.1-04 |
| VISION_SLOT | InventoryItemCount6, InventoryItemHotKey6 et TargetItem6_Count : 3 | SYS-17.1-05/07, SYS-17.4-01 |

Ce classement s'appuie sur les fichiers, noms et groupes ; il ne définit pas automatiquement les acteurs ou modes qui doivent les activer. Chaque record du JSON conserve ses propriétés complètes, groupe/scène, flags natifs hérités, empreinte originale/effective, tâches et absence de sélection actuelle.

Les trois sélecteurs de Text sont relus : dix-huit champs de native_hud_widgets, un BuffStack0 pour Ezreal, six InventoryItemCount0..5. Leur code et l'ensemble du corpus sont identiques à HUD-01. Une recherche reproductible des 90 noms comme tokens dans les 498 fichiers ne trouve aucune occurrence. Les sélecteurs dynamiques connus sont contrôlés séparément : les zéros de cette recherche ne sont pas, à eux seuls, une preuve d'absence globale de tout code généré ou alias Rust.

Autres acquis conservés : main::labels peut afficher des K/D/A et points dans le diagnostic F3 ; native_hud_learning présente des contrôles d'apprentissage, native_hud_ranks des pips pour les champions pris en charge. Ces consommateurs ne produisent pas automatiquement KillsStat, LevelUpBarPoints ou EvolutionBarTitle. Un marqueur de position peut aussi ne pas être destiné à afficher un texte propre : le rôle d'ancrage de SpellToolTip/StatusMessageToolTip reste à comparer à l'appelant natif.

## 4. Vérifications réellement exécutées

Commande, code 0 : `python -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-22.1-04-CONTEXT-01/audit_hud_contexts.py`.

| Contrôle | Attendu / observé |
|---|---|
| Entrées réutilisées | HUD-01 et COUNT-01 conformes à leurs empreintes ; 498 sources courantes inchangées |
| Archive/layout | 62 comparaisons de membres dans deux ZIP ; 27 layouts identiques aux captures ; chaque source appartient à la liste normale |
| Liste chargée | 32 noms normaux conformes à l'ensemble des sources capturées ; liste alternative conservée avec quatre différences, sans la qualifier comme sélectionnée |
| Classement | 90 IDs uniques, treize contextes, aucune ligne oubliée ni attribuée deux fois |
| Scènes | 48 groupes originaux recoupés avec l'ancien contrat ; les 28 groupes pertinents sont disponibles |
| Text | Propriété Enabled de chaque ligne conforme au bit initial capturé ; propriétés du fichier réparé préservées |
| Producteur | Noms exacts absents du corpus ; absence de sélection confirmée dans les trois routes de glyphes inspectées, avec limites de recherche conservées |
| Réconciliation | 25 sélectionnés + 39 buffs non sélectionnés + 90 classés ici = 154 IDs distincts de la capture |
| Conservation | Dix-neuf fichiers logiciels gelés conformes à WITHDRAWAL_INVENTORY.json ; aucune base ouverte |
| Relecture indépendante | Cardinalités, groupes, identités, réparation, tâches et absence de nouvelle exécution cohérents : PASS |

Les états initiaux ne se confondent pas avec un affichage effectif :

| Enabled du Text source | Enabled du groupe source | Nombre de records |
|---|---|---|
| 1 | 1 | 19 |
| 0 | 1 | 29 |
| 1 | 0 | 26 |
| 0 | 0 | 16 |

Ainsi 45 Text sont activés individuellement dans la source, mais 42 records appartiennent à un groupe initialement désactivé. Ce sont des comptages par Text, pas 42 groupes distincts. Même la combinaison 1/1 ne démontre ni valeur reçue ni appel de rendu.

Exemples de refus d'extrapolation : les deux scores Dominion sont présents mais leurs groupes sont désactivés ; les dix templates d'équipe ne fixent pas le nombre de participants actifs ; le septième slot source ne modifie pas les tableaux courants de six slots ; l'ajout d'en-tête de LossOfControlUI ne clôture pas les avertissements ni sa présentation.

Aucun test Rust, compilation, REA, jeu, réseau, GPU ou code natif relancé. Aucun résultat ancien qualifié de résultat frais. L'observation read-only du dépôt a été effectuée : HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca ; 1943 entrées de changements existants. Aucun reset, checkout, staging ou lancement du suivi.

## 5. Manques, inconnues et frontières

La provenance et le contexte des 154 définitions de cette capture sont maintenant classés. Cela ferme l'inventaire contextuel de cet ensemble ; cela ne ferme pas les clés de texte de toutes les interfaces. Les autres routes de HUD-01, le service de traduction, les formats, les tooltips, les titres bitmap et les contextes non capturés restent distincts.

Pour les 90 records ici, la source de valeur, le déclencheur historique d'activation et l'applicabilité précise par mode restent non qualifiés, sauf leurs propriétés initiales et la frontière de consommation actuelle établies. Une absence de sélection ne donne pas automatiquement une correction fonctionnelle : certains éléments peuvent être conditionnels, des ancrages, des variantes ou hors du mode courant.

Les éléments TargetBar exigent une projection publique par spectateur ; un champ présent ne permet pas de reprendre l'état privé du propriétaire ou d'une cible cachée. Les capacités/ammo, passifs, points, régénérations et charges nécessitent une autorité de données propre, pas des valeurs inventées pour remplir le layout. Les cinq templates d'équipe et le septième slot doivent être qualifiés avant de changer les modèles de roster/inventaire.

Les inconnues existantes des dix tâches associées sont conservées dans le JSON. Notamment : SYS-22.1-04, OLU-f7d57a9f-32d2-5d02-8b33-c903cdac74e8 ; cible publique SYS-17.1-07, OLU-e6a1be9b-8c17-5ce3-be3e-a171aec1b9ac ; compteurs SYS-17.1-08, OLU-a3333160-a89a-5d4c-944b-a583182fd948. Aucun état, note, case ou inconnue du registre n'est changé.

Aucune entrée indispensable ne manque pour la conclusion bornée « source/contexte initial/frontière actuelle ». Les activateurs et règles non prouvés sont des entrées de reprise de leur clause de fidélité, pas des réussites implicites.

## 6. Reprise par contexte et critère de résultat

Clauses documentaires réutilisant les tâches du tableau précédent. Une réalisation se découpe par widget, acteur et mécanisme nommés ; un seul cas réussi ne termine pas son contexte entier. Les IDs HUD individuels du JSON servent d'ancres stables. Aucun ajout au plan ou à ses bases.

| Contexte | Prochain résultat précis et critère de fin | Entrée nécessaire |
|---|---|---|
| TOOLTIP_POSITION | Pour une infobulle nommée, déterminer si le Text sert d'ancrage ou de contenu, puis qualifier placement, texte/locale éventuel et disparition | Appelant/contrat de tooltip correspondant ; ne pas imposer une chaîne à un simple marqueur |
| POOL_REGEN | HPRegenStat puis MPRegenStat séparément : autorité de valeur, unité et format, avec absence/non-mana et actualisation vérifiées | Producteur de régénération affichée ; une augmentation des PV ne prouve pas son format |
| ABILITY_EXTRA | Une capacité nommée par sous-tâche : compteur ammo ou recharge passive, projection autorisée et masquage. RecallHotKey et LevelUpBarPoints sont deux résultats distincts | Source de la mécanique, binding actif ou points non dépensés ; ne pas activer les neuf champs avec des constantes |
| TARGET_STATS | Pour chaque champ choisi, identité cible et donnée publique raccordées ; changement de cible, perte de vision et donnée absente traités | Projection par spectateur et contrôle de sélection ; préserver la confidentialité |
| TARGET_ITEMS | Une quantité d'un slot cible nommée, avec slot vide, changement de cible et politique publique vérifiés | Contrat de visibilité de l'inventaire cible ; ne pas recopier celui du propriétaire |
| OWNER_STATS_AND_KEYS | Identité, chaque statistique et chaque raccourci sont qualifiés séparément : valeur ou binding réellement actif, format et mise à jour documentés | Source d'identité destinée au joueur, calcul de statistique ou producteur de remappage selon le champ |
| MATCH_COUNTERS | Pour un compteur nommé, autorité joueur/équipe/événement et format établis ; vérifier les frontières de première élimination ou l'activation FPS selon le cas | Producteur exact ; distinguer diagnostic F3, résultat final et HUD de partie |
| DOMINION_SCORE | Attribuer l'activation des deux groupes et le producteur de score au mode concerné avant toute demande de rendu Map10 | Nouvelle trace native de mode/scene ou contrat local explicite ; le nom de fichier seul ne suffit pas |
| TEAM_FRAMES | Définir l'affectation roster→slot et la projection autorisée du niveau/délai d'un coéquipier, pour le mode retenu | Règle de roster et inclusion/exclusion du joueur local ; cinq templates ne prouvent pas cinq participants |
| EVOLUTION_TITLE | Identifier une mécanique/acteur nommé, sa clé de titre et le déclencheur ; qualifier apparition, locale et fermeture | Appelant natif ou contrat propre à cette mécanique ; ne pas généraliser les flèches d'apprentissage existantes |
| MODAL_MESSAGE | Pour un événement modal nommé, établir titre/contenu, permissions et fermeture ; vérifier le message et sa disparition | Producteur d'événement et clés/contrat ; pause ou statut de connexion locaux ne prouvent pas cette boîte |
| LOSS_OF_CONTROL | Une paire slot/raison nommée : état autorisé, texte/temps, activation/disparition et locale qualifiés | Producteur du contrôle et overlay ; conserver la réparation et reprendre les deux avertissements seulement sur une nouvelle piste |
| VISION_SLOT | Déterminer le rôle spécial du slot6 et son applicabilité ; définir séparément quantité/binding propriétaire et données publiques cible | Source de mode et contrat de modèle/projection avant d'étendre les six slots ordinaires |

Sans nouvel appelant, trace ou source, ne pas répéter les mêmes comparaisons de ZIP ni REA sur les mêmes parseurs. Les définitions sont disponibles et identifiées. Le prochain lot peut porter sur un consommateur de valeur précis ou une autre exigence encore sans audit, sans attendre une reconstruction globale du HUD.

## 7. Livraison et relecture

Fichiers créés uniquement :

- `F:/OpenLeague/docs/audit/units/AUD-22.1-04-CONTEXT-01.md`, ce résultat.
- `F:/OpenLeague-work/audit-units/AUD-22.1-04-CONTEXT-01/audit_hud_contexts.py`, 19583 octets, SHA256 `4b74daa64e24cf13ffd8fc9ea74938eedf8a15bcbae0eb5940d6e801f75e7423`.
- `F:/OpenLeague-work/audit-units/AUD-22.1-04-CONTEXT-01/hud-contexts-proof.json`, 213885 octets, SHA256 `30a2bd0c54e36786c98733176983eb808e13290303d3659d9f1baf7e03288266`.

Le reçu conserve les 90 IDs et propriétés, treize contextes et leurs conditions de reprise, les 62 comparaisons de membres, les groupes natifs hérités, la liste normale et son alternative, la réparation, les ancres de code, la recherche bornée, dix tâches/inconnues et la réconciliation de la capture. Les preuves HUD-01, BUFF-01, NUMERIC-01 et COUNT-01 restent conservées.

Les sept rubriques sont satisfaites dans cette portée. Audit classé ne signifie pas fonctionnalité terminée, traduction réalisée, mode accepté ou jeu complet. Aucune modification du Goal, du jeu, de l'application de suivi, de ses registres ou bases ; aucun logiciel installé, aucune migration, aucun état de complétion changé.
