# SYS-01.2-02 — Ahri, passif : icône et état vers le HUD courant

Audit daté du 2026-11-03. Unité `AUD-SYS-01.2-02-AHRI-PASSIF-HUD-ICON-STATE-LINK-01`. **Audit statique borné terminé : 25/25 contrôles ciblés réussis.** L'affichage du passif, sa mécanique et son acceptation restent ouverts. Aucun jeu, rendu, audio, réseau, REA ou test Rust n'a été exécuté dans ce lot.

## 1. Exigence précise et frontière

`CH-Ahri-PASSIF-PRESENTATION-HUD` (`OLF-922d773d-6eeb-5653-925c-35afb7f1ce11`) demande « afficher icône, texte, rang et états de cette capacité ». Le registre lui donne `a_faire`, `implementation_complete=false`, `acceptance_complete=false`, et la dépendance `CH-Ahri-PASSIF-NETWORK`. Ce sous-audit répond seulement à la question suivante : **quelle icône et quels textes le client 4.20 fourni déclare-t-il, et le HUD F actuel a-t-il un trajet identifié pour l'icône ou l'état du passif d'Ahri ?** Il ne décide pas les déclencheurs, le nombre de charges effectivement produit, les états réseau, le rendu ni la présence d'un rang historique.

Recherche de doublon avant travail : parmi les rapports `AUDIT_*.md` de `F:\OpenLeague\docs`, la recherche de `CH-Ahri-PASSIF-PRESENTATION-HUD` et `Ahri_SoulEater` ne retrouve que `AUDIT_CH-AHRI-PASSIF-SOURCE-CONSUMER-01_2026-11-02.md`. Ce rapport antérieur établit une liaison générale du passif au catalogue de statistiques, **pas** le trajet de l'icône vers le HUD. Le rapport `FIDELITY_AHRI_PASSIVE_SPELL_HIT_CHARGES_HEAL_LINKS_V556.md` du 2026-10-25 et son reçu sont réutilisés comme preuves historiques ; leur ancien binaire et leurs anciens hashes de consommateurs ne sont pas présentés comme une exécution actuelle.

## 2. Sources historiques, identité et limites

La référence `docs/reference_client_4_20.json` est **PUBLIC 4.20.0.315, EUW/en_GB**. La racine fournie est `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy`. `DATA/Characters/Ahri/Ahri.inibin` : 2 671 octets, SHA-256 `341500db9fd6825eaef151326bad28f8878f495185020f5c99e5ab03491a60e2`, 125 valeurs décodées par le lecteur local `tools/project-plan/reference_inibin.py`. Le champ `Data.Passive1Icon` vaut **`Ahri_SoulEater.dds`** et `Data.Passive1LuaName` vaut `AhriPassive`. Ces déclarations ne prouvent ni la sélection runtime de l'icône ni l'exécution de la mécanique serveur.

Les deux fichiers natifs `DATA/Characters/Ahri/HUD/Icons2D/` sont distincts :

| Fichier | Taille | DDS | SHA-256 | Release du membre |
| --- | ---: | --- | --- | --- |
| `Ahri_SoulEater.dds` | 2 176 octets | 64×64, DXT1 | `a0d7d5e45f059bfde4439ebc5843df3b3ef7642b6ddf18807880fc46b8993926` | 0.0.0.120 |
| `Ahri_SoulEater2.dds` | 2 176 octets | 64×64, DXT1 | `6b1e2569ad98c2da55af474835635a8d012eaa97a63bac7e30d0d310af5591ee` | 0.0.0.120 |

Le validateur a comparé taille et MD5 de chaque octet D à son entrée du manifeste sélectionné `F:\OpenLeague\data\4.20\rads_manifests\lol_game_client\releases\0.0.1.7\releasemanifest` (4 905 302 octets, SHA-256 `88b09959b24053c422e209343083d549cdfe6380828b583710d7f9343c1aba09`, 70 286 membres). Le manifeste agrégé et les versions des membres sont distingués du dossier de deploy 0.0.1.68. La variante `SoulEater2` est présente, mais son nom est absent des 125 valeurs décodées de `Ahri.inibin` ; sa condition d'emploi demeure inconnue. Un en-tête DDS valide et l'appartenance au manifeste ne sont pas une vérification visuelle.

Le texte original `DATA/menu/fontconfig_en_GB.txt` sur D fait 2 220 957 octets, SHA-256 `1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3`, identique octet pour octet à `F:\OpenLeague\data\4.20\font_configuration\menu\fontconfig_en_GB.txt`. Ses lignes **1660**, **4150** et **4326** portent respectivement le tooltip `AhriPassive`, la description et le nom « Essence Theft ». Le texte indique au plus trois charges par sort, neuf charges avant le prochain sort soignant à chaque impact ; le tooltip laisse les paramètres `@f1@` et `@f2@` non résolus. Ces chaînes sont une source de texte client, pas un corps serveur ni un contrat de rendu actuel. Le rapport V556 conserve aussi la formulation distincte du compteur et les branches non déterminées.

## 3. Trace et consommateurs F vérifiés

`docs/fidelity_requirement_trace_4_20.json:201138` rattache la tâche à `Ahri.inibin`, `CharScriptAhri.luaobj`, au catalogue 4.20.1 et au manifeste. Son unique consommateur enregistré est `OLC-93924678-ea15-5516-8f55-08616c5450cc`, le `champion_catalog` de `crates/core/src/lib.rs` : il charge les statistiques de base, sans trajet HUD du passif établi. La trace ne référence pas les deux DDS comme entrée de cette tâche et reste `partial_with_open_questions`. Son inconnue `OLU-f561f2fa-2c5f-536a-8a15-6aae0b63293d` est **ouverte** ; la présence des icônes ne la résout pas.

Le consommateur HUD actif `crates/client/src/native_hud_spells.rs` est enregistré dans `crates/client/src/main.rs`. Il sélectionne les widgets natifs Q/W/E/R et D/F, charge les entrées `InventoryIcon` de `data/4.20/native_spell_icons.json`, puis indexe les icônes par `(champion, slot)`. Les quatre entrées Ahri de ce catalogue sont les slots **0, 1, 2, 3** ; elles ne contiennent ni `Ahri_SoulEater.dds` ni une entrée PASSIF. Le dossier d'assets `assets/ui/native420/spells/ahri` contient les quatre fichiers `0-InventoryIcon.dds` à `3-InventoryIcon.dds`. Le tableau d'états du module porte quatre slots QWER et dépend du rang/coût/cooldown de ces compétences ; il ne constitue pas un état Essence Theft. `native_ezreal_passive_hud.rs`, également enregistré, demande explicitement `Ezreal_RisingSpellForce.dds` et l'état `ezreal_passive_hud` ; il ne fournit pas un trajet Ahri.

Une recherche de cinq littéraux (`AhriPassive`, `Ahri_SoulEater`, `AhriSoulCrusher`, `Ahri_SoulCrusher`, `Essence Theft`, sans sensibilité à la casse) dans **1 149 fichiers `.rs`** sous `crates/{core,client,server}/src` n'a trouvé aucune occurrence. `Champion` et `Effects` ont été inspectés comme points d'état candidats, mais l'absence de ces noms ne prouve pas l'absence de tout mécanisme générique ou d'un chargement dynamique indirect. Une recherche de chemins d'assets nommés Ahri/SoulEater sur F n'a trouvé aucun fichier à ce nom ; elle ne prouve pas l'absence d'octets équivalents sous un autre nom. La conclusion établie est limitée : **pas de trajet Ahri passif identifié dans le HUD QWER ou le HUD Ezreal, ni par la recherche Rust nommée**.

## 4. Attendu, observé et contrôles exécutés

| Cas | Attendu dans ce sous-audit | Observé | Limite |
| --- | --- | --- | --- |
| Déclaration native | L'icône déclarée est identifiable | `Passive1Icon=Ahri_SoulEater.dds` | Pas de sélection runtime prouvée |
| Payloads natifs | Présence, identité et membership des deux DDS | 2/2 tailles, SHA, en-têtes et MD5 manifeste concordants | Rôle de `SoulEater2` inconnu ; pixels non comparés |
| Texte en_GB | Source D identifiable et copie F concordante | SHA identiques ; trois lignes ciblées retrouvées | `@f1@`/`@f2@` et état visuel non qualifiés |
| HUD courant | Entrée Ahri passif ou frontière précise | QWER/D/F et Ezreal spécifique ; aucune entrée Ahri passif dans ces trajets | Un trajet indirect ailleurs n'est pas exclu |
| État passif | Producteur et consommation HUD identifiables | Aucun handler Ahri nommé dans la recherche bornée ; V556 ancien montre les refus de sorts, pas un état HUD courant | Aucun essai en partie ni réseau |

Commande réellement exécutée : `F:\OpenLeague\.ai-tools\.venv\Scripts\python.exe -B E:\mapslol3v3\audit_sys01202_ahri_passive_hud_20261103\validate_ahri_passive_hud.py`. Interpréteur Python **3.12.14**, SHA-256 de son exécutable `82264b3fe4248d1ff3564a0296cbb4a266ef968799bd85902ab5eaaf3e17eb62`. Exécution finale : code **0**, `PASS_STATIC_SCOPE`, **25/25** dans `result.json`. Deux essais préparatoires ont échoué avant l'écriture du reçu, car des `set` puis des `bytes` n'étaient pas sérialisables en JSON ; le validateur a été corrigé puis relancé. Ces essais n'ont validé aucun résultat et n'ont pas modifié F. Aucun binaire de jeu, client historique, rendu GPU ou serveur n'a été lancé.

## 5. Écarts, inconnues et conditions de reprise

L'icône déclarée et le texte original sont disponibles, mais aucun routage Ahri du passif vers le HUD F n'a été établi. Il manque l'origine autoritaire des charges/soins et leur état répliqué, la règle de sélection éventuelle de `SoulEater2`, le mapping entre texte `@f1@`/`@f2@` et paramètres, ainsi que le comportement des états zéro/neuf/armé, multi-impact, mort, reconnexion et perte de vision. Le mot « rang » dans la tâche ne suffit pas à déduire que le passif 4.20 possédait des rangs ; qualifier cette clause avant de la rendre.

Reprendre avec une preuve native ou une capture reproductible permettant d'établir la sélection des icônes et les états affichés, puis avec un producteur de charges/soin Ahri et son état réseau identifié dans le code courant. Après intégration autorisée, exercer les transitions et refus puis comparer un rendu réel au client de référence. Une modification du trajet HUD F ou un nouvel artefact primaire justifie une nouvelle inspection ciblée ; ne pas rejouer V556 à l'identique.

## 6. Correction réutilisée et critères futurs

La tâche existante `CH-Ahri-PASSIF-PRESENTATION-HUD` porte déjà l'intégration de l'icône, du texte et des états. Respecter sa dépendance `CH-Ahri-PASSIF-NETWORK`, elle-même dépendante de la simulation du passif ; les travaux SOURCE/CONTRAT et l'inconnue serveur restent séparés. Pour achever la fonctionnalité plus tard : choisir l'asset sur preuve, établir les valeurs et la clause de rang, recevoir un état autoritaire par les audiences permises, afficher les états et textes à partir de cet état, tester cas normaux/refus/transitions et vérifier visuellement avec ressources et binaires identifiés. Les VFX, sons et acceptations de champion relèvent de leurs tâches propres. Aucune nouvelle tâche ni correction du jeu n'est créée ici.

## 7. Livrable, relecture et décision

Ce dossier E contient `validate_ahri_passive_hud.py`, `result.json` et le présent rapport. SHA-256 du validateur `0319340bae84e9efcc84c099b364b403d88a1fb080e5704f4203bcf13a6a6b7e` ; SHA-256 du reçu final `3fddc28613ed032c5f3564c74c7d44df0eb6ca5cb457085db20b2d25223bfd9c`. Le reçu identifie les empreintes des consommateurs F contrôlés et le périmètre de la recherche. Les preuves V556 et l'audit général du 02/11 sont conservés séparément et ne sont pas réexécutés.

Les sept rubriques de `docs/audit/AUDIT_CHARTER.md` sont satisfaites **pour cette seule liaison statique icône/texte/état → consommateur actuel**. Relecture indépendante : **PASS** pour ces sept rubriques et le reçu 25/25, après correction des formulations de portée et des empreintes citées ; aucun autre écart bloquant. Verdict : audit `TERMINÉ_BORNÉ`, implémentation HUD Ahri `NON_IDENTIFIÉE_DANS_LES_TRAJETS_INSPECTÉS`, vérification `STATIQUE_25/25`, acceptation humaine `NON_DEMANDÉE_POUR_CET_AUDIT`. `CH-Ahri-PASSIF-PRESENTATION-HUD`, son prérequis réseau, l'inconnue `OLU-f561f2fa-2c5f-536a-8a15-6aae0b63293d`, le goal SYS-01.2-02 et le jeu restent ouverts. La phase de validation E n'a modifié aucun fichier F, registre, Plan, base, goal, code produit ou asset.
