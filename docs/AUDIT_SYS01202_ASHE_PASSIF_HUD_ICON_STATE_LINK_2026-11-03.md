# SYS-01.2-02 — Ashe, passif Focus : icônes et états vers le HUD courant

Date : 2026-11-03. Unité `AUD-SYS-01.2-02-ASHE-PASSIF-HUD-ICON-STATE-LINK-01`. **Liaison statique bornée close : 72/72 contrôles ciblés réussis.** Le HUD passif d'Ashe, le comportement historique de Focus, sa simulation complète et l'acceptation du jeu restent ouverts. Aucun client original, jeu Rust, rendu, réseau, REA, Cargo ou GPU n'a été exécuté dans ce lot.

## 1. Question et contrat

La tâche `CH-Ashe-PASSIF-PRESENTATION-HUD` (`OLF-7c3d1f1d-6bd5-5542-bbcf-5eb3e5c38413`) demande d'afficher l'icône, le texte, le rang et les états du passif. Elle reste `a_faire`, avec `implementation_complete=false`, `acceptance_complete=false`, et dépend de `CH-Ashe-PASSIF-NETWORK`. Ce sous-audit demande **quelles ressources et quels libellés le client 4.20 fourni associe à Focus, à ses charges et à l'état prêt, puis quel consommateur Ashe actuel affiche ces états dans le HUD**. La règle du serveur historique, l'attribution des buffs, leur priorité de montage, les transitions pendant une partie et la pertinence d'un « rang » passif ne sont pas conclus par leurs noms.

Le rapport `docs/FIDELITY_ASHE_TRYNDAMERE_PASSIVE_BOUNDARY_LINKS_V537.md` est réutilisé pour les tâches `PASSIF-SIMULATION-CONTRAT` et `PASSIF-SIMULATION` et ses anciennes observations. Il ne valide pas le HUD. Le préflight n'a pas trouvé de rapport ciblé déjà clos pour `CH-Ashe-PASSIF-PRESENTATION-HUD` ; l'unité présente reste limitée à ce composant.

## 2. Sources originales et provenance

La référence enregistrée est **PUBLIC 4.20.0.315, EUW/en_GB** (`docs/reference_client_4_20.json`, SHA-256 `efdf40252574a98f439829d43c6b29606d3c12d631c4a64c89ef15637e859d02`). Le catalogue officiel 4.20.1, cité par la tâche, est distinct du client original. La racine des octets originaux est `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy`. `DATA/Characters/Ashe/Ashe.inibin` fait **2 718 octets**, SHA-256 `de1706b681114ae95c164ce6f97f40cf84d5faa57682acc4327c372f2ac602f2`. Le lecteur local `tools/project-plan/reference_inibin.py` y décode `Data.Passive1Icon=Ashe_Passive.dds` et `Data.Passive1LuaName=Focus`.

Le manifeste RADS **agrégé** relu est `F:/OpenLeague/data/4.20/rads_manifests/lol_game_client/releases/0.0.1.7/releasemanifest`, 4 905 302 octets, SHA-256 `88b09959b24053c422e209343083d549cdfe6380828b583710d7f9343c1aba09`, 70 286 membres. `0.0.1.68` est le dossier de déploiement original ; `0.0.1.7` est le manifeste agrégé et les autres versions ci-dessous sont les releases **des fichiers**. Pour les neuf fichiers, taille, SHA-256 D et MD5 du membre correspondent. Le registre `docs/fidelity_sources_4_20.json` les possède déjà comme sources distinctes ; cela ne prouve pas leur priorité ni leur sélection runtime.

| Fichier sous `DATA/Characters/Ashe/` | Taille | SHA-256 original | Release membre | Déclaration observable |
| --- | ---: | --- | --- | --- |
| `Ashe.inibin` | 2 718 | `de1706b681114ae95c164ce6f97f40cf84d5faa57682acc4327c372f2ac602f2` | `0.0.1.7` | `Passive1Icon=Ashe_Passive.dds`, `Passive1LuaName=Focus` |
| `Spells/Focus.luaobj` | 202 | `bc782c78f7914d988ab2501fc92333ed692aa571d18d414a5d90ea75330d14e5` | `0.0.0.196` | `BuffTextureName=Ashe_Passive.dds`, `BuffName=Focus` |
| `Spells/AsheCritChance.luaobj` | 154 | `14d456b12b5f59f6814b86cdfe7222738dbf2fd8feccf9c8e5596655d68e350e` | `0.0.0.196` | `BuffTextureName=Ashe_Passive_Grey.dds`, `BuffName=AsheCritChance` |
| `Spells/AsheCritChanceReady.luaobj` | 559 | `503aa56e5b395138e0bd8899440f5b239d357d7a07f2821c64d8c461e20fac92` | `0.0.0.196` | `BuffTextureName=Ashe_Passive.dds`, `BuffName=AsheCritChanceReady`, effet nommé `Ashe_Base_P_buf_geo.troy` |
| `Spells/Focus.inibin` | 37 | `2f811c60f6ccd32e1998f2a21484df54cab4c7a4901ceead6b66c08d55ce30de` | `0.0.0.196` | clé `game_buff_tooltip_Focus` |
| `Spells/AsheCritChance.inibin` | 53 | `c4aa6cd6af3af47748df584df4921990701305166a504d9a86087bdc9d79ad31` | `0.0.1.2` | clé `game_buff_tooltip_AsheCritChance` |
| `Spells/AsheCritChanceReady.inibin` | 58 | `47be718e599e8b1a5fbecd6871fb2d83ad01c20ffdf43bdc5bd017c7543a9124` | `0.0.1.2` | clé `game_buff_tooltip_AsheCritChanceReady` |
| `HUD/Icons2D/Ashe_Passive.dds` | 2 176 | `dc5b2945f8914cd4336991f7c91e239a03dccde75918eed8146c2341daff4918` | `0.0.0.196` | DDS 64×64 DXT1, différent du gris |
| `HUD/Icons2D/Ashe_Passive_Grey.dds` | 2 176 | `d335fd26d56b3027d171fe60d7c8c4aaa6ff94103e9a999f26b00b5399172cd7` | `0.0.0.196` | DDS 64×64 DXT1, cité par `AsheCritChance.luaobj` |

La variante grise a donc une **référence directe dans les métadonnées client** ; elle n'est pas un fichier orphelin. Ces LuaObj sont des déclarations de buff, pas le corps serveur Riot ni une preuve de leur apparition, du choix exclusif de l'un des deux DDS, des charges affichées ou de l'effet joué. `Data.Passive1Desc` dans `Ashe.inibin` emploie une ancienne formulation sur la chance critique qui augmente toutes les trois secondes. Elle diffère du texte localisé et du catalogue 4.20.1 ; les deux formulations restent distinctes, sans inférer une corruption.

Le fichier original `DATA/menu/fontconfig_en_GB.txt` fait **2 220 957 octets**, SHA-256 `1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3`, identique à la copie F. Les lignes **1692–1693** donnent des tooltips `AsheCritChance` (accumulation jusqu'à 100) et `AsheCritChanceReady` (prochaine attaque critique) ; la ligne **1917** décrit Focus, un délai de trois secondes, 100 charges et un taux `@f1@` **non résolu**. Les lignes **4159/4335** décrivent/nomment le passif. Ces chaînes ne déterminent ni l'état effectivement distribué au client ni le taux numérique.

## 3. Trace et consommateur actuel

La trace `docs/fidelity_requirement_trace_4_20.json:302883` reste `partial_with_open_questions`. Ses deux sources natives inscrites sont `Ashe.inibin` (`OLS-9dc52591...`) et **`CharScriptAshe.luaobj`** (`OLS-fa571342...`, 56 octets), et son unique consommateur inscrit `OLC-93924678...` est le catalogue de statistiques générique. `Focus.luaobj` porte un autre ID source déjà enregistré : **`OLS-b9ac154f-0616-56f8-b5d2-30aff0260df2`**, non relié à cette exigence HUD dans la trace. Les autres LuaObj, INIBIN de buff et DDS ont eux aussi des IDs de source existants, mais pas ce lien précis. L'inconnue `OLU-37f17d3b-6b1e-58ca-96d2-29f1c1ec001d` reste `open`. Aucun registre n'est modifié par ce lot sous la restriction actuelle.

Dans le projet courant, `data/4.20/native_spell_icons.json` fournit à Ashe quatre entrées `InventoryIcon` Q/W/E/R ; `assets/ui/native420/spells/ashe` contient leurs quatre DDS nommés. Le plugin `crates/client/src/native_hud_spells.rs`, chargé par `main.rs`, instancie les panneaux QWER et D/F et lit seulement ces `InventoryIcon` primaires. `crates/client/src/native_ezreal_passive_hud.rs` fournit un Buff0 **spécifique à Ezreal** : il ne rend pas Focus. `crates/core/src/spells.rs:5-45` ne possède aucun état nommé Focus/Ashe dans `Effects` ; `crates/core/src/attacks.rs:289-295` utilise la chance critique générique. Dans les 1 149 fichiers `.rs` des trois dossiers `crates/core/src`, `crates/client/src` et `crates/server/src`, la recherche exacte de `Ashe_Passive`, `focus_stacks` et `FocusBuff` ne trouve aucun chargement nommé. Une route indirecte, un autre alias ou un module non inspecté ne sont pas exclus. V537 avait observé Ashe à 90/900/5 400 ticks sans augmentation visible de critique, mais cela n'est pas un test HUD et n'est pas relancé ici.

## 4. Attendu, observé et refus

| Cas | Attendu de **l'audit statique** | Observé | Conclusion bornée |
| --- | --- | --- | --- |
| Source nominale | Ressources, textes et provenance précisément identifiés | Neuf fichiers natifs, un manifeste agrégé, tooltips en_GB et deux DDS distincts ; 72/72 contrôles | Source client relue ; aucun runtime qualifié |
| Variante grise et état prêt | Ne pas inférer leur rôle du seul nom | Deux LuaObj nomment respectivement les DDS gris et normal ; un troisième nomme le normal | Association métadonnées établie ; sélection et transitions inconnues |
| HUD actuel | Vérifier les consommateurs exacts | QWER seulement dans la branche inspectée, Buff0 Ezreal spécifique, aucune route Ashe nommée | Le HUD passif Ashe reste ouvert |
| Chiffres/rang/serveur | Refuser les valeurs non sourcées | `@f1@` reste littéral, pas d'état Focus dans `Effects`, aucun jeu exécuté | Pas de rang, taux, comportement ni acceptation revendiqués |

Commande réellement exécutée : `F:/OpenLeague/.ai-tools/.venv/Scripts/python.exe E:/mapslol3v3/audit_sys01202_ashe_passive_hud_20261103/validate_ashe_passive_hud.py` → **`PASS_STATIC_SCOPE 72/72`**. Le script lit D et F et écrit seulement `result.json` sur E ; il vérifie SHA-256, taille, MD5/manifest, source IDs, en-têtes DDS, chaînes Lua, textes en_GB, trace et consommateurs ciblés. Les reçus V537 sont antérieurs : aucun test Rust/Cargo, run historique, rendu, réseau ou acceptation humaine n'a été effectué ici.

## 5. Correction et reprise

Réutiliser la tâche existante `CH-Ashe-PASSIF-PRESENTATION-HUD`, sous sa dépendance `CH-Ashe-PASSIF-NETWORK`. Il reste à établir avec une observation originale attribuable ou un callsite qualifié **quels buffs/états sont réellement présents selon 0–100 charges, prêt, attaque consommée, mort et reconnexion**, quel DDS/tooltip est choisi, si un rang existe, et si les effets nommés se déclenchent. Un lot d'implémentation autorisé pourra ensuite relier l'état réseau autoritaire, les icônes et les textes au vrai HUD, puis vérifier les transitions, refus et rendu comparé. L'ancienne description INIBIN, les trois LuaObj et le catalogue 4.20.1 ne remplacent pas cette preuve historique. Une modification du consommateur F ou une nouvelle preuve primaire justifie une relecture ciblée ; ne pas rejouer les scans inchangés.

## 6. Clôture limitée

Les sept rubriques du contrat d'audit sont présentes : ID/frontière, sources, consommateurs, attendu/observé, contrôles, écarts/reprise, correction et décision. Verdict : **`TERMINÉ_BORNÉ` pour la liaison documentaire statique**. Implémentation : aucun widget Focus identifié dans les chemins HUD inspectés ; mécanique/statistiques génériques seulement. Vérification : 72/72 statiques, sans exécution produit. Acceptation humaine : non fournie. `CH-Ashe-PASSIF-PRESENTATION-HUD`, l'inconnue propriétaire, `SYS-01.2-02` et le jeu restent ouverts.

Livrables préparés dans `E:/mapslol3v3/audit_sys01202_ashe_passive_hud_20261103` : ce rapport, `validate_ashe_passive_hud.py`, `result.json`, puis un script de publication documentaire après revue. Aucun Goal, Plan, application de suivi, interface, base, registre protégé, code produit ou asset n'est modifié par cette préparation.
