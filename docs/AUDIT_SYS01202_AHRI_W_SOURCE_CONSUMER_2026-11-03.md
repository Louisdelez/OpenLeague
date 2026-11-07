# SYS-01.2-02 — Ahri W : sources 4.20 et refus du consommateur actuel

Vérification du 2026-11-03. Unité `AUD-SYS-01.2-02-AHRI-W-SOURCE-CONSUMER-01`. Audit statique borné ; aucun code produit, registre, Plan, goal, application de suivi ou base modifié.

## 1. Exigences et périmètre

- `CH-Ahri-W-SOURCE` (`OLF-f47fda91-6697-51cc-ab88-1742ad4003d1`) : relier l'identité native de Fox-Fire, ses valeurs client et la réponse du consommateur courant. La tâche reste `a_qualifier` ; son prérequis `CH-Ahri-IDENTITE` n'est pas clos.
- `CH-Ahri-W-SIMULATION-CONTRAT` (`OLF-f01fbdb9-510e-5107-af96-ee066c09ac5d`) : relever ce que les sources disponibles disent des effets et nommer les branches encore indéterminées. La tâche reste `a_faire`. Cet audit ne prétend pas décrire chaque branche du comportement serveur.

Critère de fin **du seul sous-audit** : identité et provenance des sources, valeurs numériques de cinq rangs, entrée et refus du code courant, résultat attendu/observé statique, écarts et condition de reprise précis. L'implémentation, l'exécution et l'acceptation des deux tâches sont hors de cette clôture.

## 2. Sources historiques, version et limites

Le contrat de référence `docs/reference_client_4_20.json` retient le client **4.20.0.315**, EUW, en_GB. Dans le deploy original fourni sous `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy` :

- `DATA/Characters/Ahri/Ahri.inibin` : 2 671 octets, SHA-256 `341500db9fd6825eaef151326bad28f8878f495185020f5c99e5ab03491a60e2` ; `Data.Spell2=AhriFoxFire` décodé directement.
- `DATA/Characters/Ahri/Spells/AhriFoxFire.inibin` : 1 716 octets, SHA-256 `4aa1084f7ef3a1e1d355e655b4012219e625cca666f93ee9eba0bb9364e442f6` ; 180 paires lues avec `tools/project-plan/reference_inibin.py`. Les deux fichiers sont déjà liés au manifeste RADS sélectionné par le registre de sources.

| Champ `SpellData` | Rangs 1 à 5 décodés directement |
| --- | --- |
| `ManaCost` | 50 / 50 / 50 / 50 / 50 |
| `Cooldown` | 9 / 8 / 7 / 6 / 5 |
| `Effect1LevelNAmount` | 40 / 65 / 90 / 115 / 140 |
| `Effect2LevelNAmount` | 12 / 19,5 / 27 / 34,5 / 42 |
| `Effect3LevelNAmount` | 64 / 104 / 144 / 184 / 224 |

Autres champs observés : `Coefficient≈0,4`, `Coefficient2≈0,12` (float32 exact `0.11999999731779099`), `CastRange=750`, `CastRangeDisplayOverride=800`, `TargettingType=4`, `BounceRadius=450`, `CastRadius=1000`. Le nom d'un champ ou sa valeur ne prouve pas sa consommation par le serveur. L'export existant `data/4.20/native_spells_420.json` contient la ligne Ahri/slot 1 et concorde avec les 25 valeurs de rang ; son `sha256` de ligne `c641f741...` identifie le JSON exporté, **pas** l'INIBIN natif.

La référence Riot Data Dragon **4.20.1 en_US** `E:\mapslol3v3\Full_project_audit_2026-10-20\official_reference\championFull.json` (SHA-256 `72e26ad631c42f76cbd87ec6c5f656a79650ea5091d0fa2a604789d51c3b7404`) donne les mêmes coûts et délais, une portée affichée de 800, et décrit trois feux qui privilégient les champions. Son infobulle indique **30 %** de dégâts pour chaque feu supplémentaire sur la même cible. Cette version et cette locale ne sont pas une capture du comportement du client/serveur 4.20.0.315. L'écart 750/800 reste distingué entre `CastRange` et `CastRangeDisplayOverride`, sans décider la portée effective.

### LuaObj natifs W

Le manifeste RADS sélectionné `data/4.20/rads_manifests/lol_game_client/releases/0.0.1.7/releasemanifest` fait 4 905 302 octets, SHA-256 `88b09959b24053c422e209343083d549cdfe6380828b583710d7f9343c1aba09`, et contient 70 286 membres. Lecture ciblée avec le parseur existant `frontend_builds.release_manifest` : les **cinq** LuaObj du deploy correspondent individuellement à leur taille et MD5 de membre ; aucune priorité runtime n'est déduite.

| Ressource `DATA/Characters/Ahri/Spells` | Octets | SHA-256 | Release du membre |
| --- | ---: | --- | --- |
| `AhriFoxFire.luaobj` | 375 | `c0e560720572da844163a29ddf3d5ef1d7cc45b2b6892a39d7edd3afaaf29e98` | 0.0.0.254 |
| `AhriFoxFireMissile.luaobj` | 285 | `48471009107039c6ee2408ae6768d19df8a20157bb68ceebcc293fc23994b917` | 0.0.0.254 |
| `AhriFoxFireMissileTwo.luaobj` | 195 | `0937d42b0fe40a02ef0ad50132b65d32d17d402510f9460738b8d73eff3adf49` | 0.0.0.254 |
| `AhriFoxFireMissileTag.luaobj` | 285 | `48471009107039c6ee2408ae6768d19df8a20157bb68ceebcc293fc23994b917` | 0.0.0.120 |
| `AhriFoxFireMissileTagTwo.luaobj` | 285 | `48471009107039c6ee2408ae6768d19df8a20157bb68ceebcc293fc23994b917` | 0.0.0.120 |

Les cinq portent l'en-tête de bytecode Lua 5.1, sont entièrement consommés par `tools/project-plan/lua51_reference.py` et n'ont aucun prototype enfant. Ce lecteur strict qualifie l'initialisation littérale des quatre Missile/Tag ; il s'arrête pour `AhriFoxFire.luaobj` à `NEWTABLE` pc14. Le lecteur existant `tools/native_lua.py`, capable de cette table simple, termine les cinq sans arrêt ni appel. Il récupère dans le LuaObj principal `IsDamagingSpell=true`, `DoesntBreakShields=true`, `BuffName=AhriFoxFire`, `BuffTextureName=Ahri_FoxFire.dds`, `SpellDamageRatio=1.0` et `SpellVOOverrideSkins[1]=AhriSkin04`. Les quatre autres ont `IsDamagingSpell=true` et `SpellDamageRatio=1.0`. Ces initialisations **client** ne démontrent ni l'acquisition de cible, ni trois projectiles effectifs, ni les dégâts serveur.

Limite de l'outil de membership : `RadsReferenceMembership(F:)` échoue avant inspection car les métadonnées du catalogue récupéré gardent un ancien chemin absolu `E:\OpenLeague`. L'inspection directe du manifeste **F** à l'empreinte épinglée et la comparaison taille/MD5 des cinq fichiers ont réussi. Le registre `native-release-membership.json` ne contient que le LuaObj principal parmi ces cinq ; ses quatre absences d'entrée ne sont pas des absences du manifeste.

## 3. Consommateurs OpenLeague actuels

La trace `docs/fidelity_requirement_trace_4_20.json:202671` et `:202735` enregistre les sources et trois consommateurs génériques. `crates/core/src/lib.rs:598` distribue `Action::Learn` et `Action::Cast`. `crates/core/src/progression.rs:164` refuse la progression d'Ahri avec `champion skill progression not implemented`. Dans `crates/core/src/spells.rs:101–120`, après les gardes communes, Ahri atteint `champion spell not implemented` **avant** la lecture du rang et des valeurs de dégâts. `crates/client/src/spell_input.rs:1` ne classe pas Ahri W comme sort visé au sol. `crates/client/src/native_hud_spells.rs:21–30` lit le coût dans l'export par champion/slot uniquement si un rang existe et si ses gardes le permettent ; l'apprentissage ordinaire d'Ahri est refusé.

Une recherche littérale bornée de `AhriFoxFire`, `ahri_fox` et `fox.fire` dans les fichiers Rust `crates/{core,client,server}/src` n'a trouvé aucun consommateur nommé W. Cela ne démontre pas l'absence de tout chemin indirect. Les empreintes des sources courantes inspectées figurent dans le reçu.

## 4. Attendu, observé et contrôles exécutés

| Cas | Attendu pour ce lot | Observé | Limite |
| --- | --- | --- | --- |
| Identité W | `Spell2` désigne le fichier W versionné | Lien et SHA natifs concordants | Pas de règle serveur |
| Cinq rangs | Valeurs INIBIN et export comparables | 25 valeurs de mana, délai et effets concordantes | Les trois champs `Effect` ne sont pas attribués à des branches serveur |
| LuaObj | Bytecode et membership vérifiables sans exécution | 5/5 membres taille/MD5 ; initialisations bornées extraites | Métadonnées client seulement |
| Apprendre et lancer W | Route courante ou refus explicite | Refus de progression et de sort dans les sources actuelles | Aucun `Action::Learn`/`Action::Cast` W exécuté |
| Contrat complet | Priorité, dégâts, répétitions et limites historiques décidés | **Non décidé** | Requiert source serveur ou observation native |

Exécution : `python -B E:\mapslol3v3\audit_sys01202_ahri_w_20261103\validate_ahri_w.py` ; résultat `PASS_STATIC_SCOPE`, **37/37** contrôles dans `E:\mapslol3v3\audit_sys01202_ahri_w_20261103\result.json`. Le script lit les fichiers 4.20, la référence officielle, l'export, le manifeste, les LuaObj et le code courant ; il écrit uniquement son reçu E. Aucun Cargo, binaire Rust W, jeu original, serveur, HUD, client graphique, VFX, audio ou réseau n'a été exécuté. Le probe Ahri Q existant reste une preuve Q, pas une vérification W.

## 5. Écarts, conflit et conditions de reprise

1. `D:\LeagueOfLegendsV2\4.20\GameServer\Content\LeagueSandbox-Scripts\Characters\Ahri\W.cs` (SHA-256 `72303338f580512c1ec34f953615a2b785782fd721e9892a19be4f48d3c549c9`) est un **script communautaire**. Sa ligne 55 applique `damage * 0.5f` aux feux restants dirigés vers une première cible ; le texte Riot 4.20.1 indique 30 % par feu supplémentaire. Le rapprochement par nom dans `docs/fidelity_community_semantics_4_20.json` est `single_name_candidate_not_dispatch_proof`. Ne pas utiliser ce script pour trancher l'historique ; le conflit 50 % / 30 % reste ouvert.
2. Le sens de `TargettingType=4`, la portée effective 750/800, la sélection/priorité/visibilité des cibles, le nombre et le timing des feux, les répétitions sur une cible, les immunités/boucliers, le calcul d'AP/dégâts et les interactions de mort ne sont pas établis par les seules initialisations client. Reprendre avec un artefact serveur attribuable à 4.20.0.315 ou une capture reproductible de son exécution, puis vérifier les cas et limites.
3. Les refus Rust sont statiquement reliés ; le comportement W courant, la non-mutation des refus, les états HUD et la partie réseau n'ont pas de test direct dans ce lot. Reprendre sur un probe W isolé du code actuel ou un test de partie après implémentation autorisée, avec binaires et ressources identifiés. Ne pas citer l'exécutable Q comme preuve W.
4. `unknown_ids=[]` dans la trace n'est pas une preuve que la sémantique W est connue. Les anciens chemins `E:\OpenLeague` des métadonnées de manifeste doivent être rapprochés de F avant un usage du wrapper ; aucune migration n'est exécutée ici.

## 6. Corrections existantes, sans doublon

Réutiliser `CH-Ahri-W-SOURCE` pour la qualification historique des règles, `CH-Ahri-W-SIMULATION-CONTRAT` pour chaque branche et ses inconnues, puis `CH-Ahri-W-SIMULATION` pour le comportement autoritaire et ses refus. `CH-Ahri-W-NETWORK`, `CH-Ahri-W-PRESENTATION-ANIMATION`, `-VFX`, `-AUDIO`, `-HUD`, `CH-Ahri-W-PRESENTATION` et `CH-Ahri-W-ACCEPTANCE-RANG1..5` couvrent les suites ; elles restent non terminées. Pour clore les tâches, exiger une source/observation 4.20 attribuable, les valeurs/cibles/cas limites sur cinq rangs, des tests courants des succès et refus, puis les vérifications visuelle, audio et réseau pertinentes. Aucune implémentation n'est effectuée dans cet audit.

## 7. Relecture des critères et décision

Les sept rubriques de `docs/audit/AUDIT_CHARTER.md` sont satisfaites **pour l'unité source → consommateur/refus statique seulement** : périmètre, provenance, consumer, attendu/observé, manques, corrections existantes et preuve datée. La relecture indépendante a confirmé le reçu `PASS_STATIC_SCOPE`, 37 contrôles présents et réussis, zéro échec, sans exécution runtime ni fichier produit modifié. Verdict : `AUDIT_BORNÉ_TERMINÉ` pour cette unité, implémentation W `ABSENTE_DU_CHEMIN_ORDINAIRE`, vérification `STATIQUE_37/37`, acceptation humaine `NON_DEMANDÉE_POUR_CET_AUDIT`. `CH-Ahri-W-SOURCE`, `CH-Ahri-W-SIMULATION-CONTRAT`, leurs dépendances, `SYS-01.2-02` et le jeu restent ouverts.

Preuves conservées : `E:\mapslol3v3\audit_sys01202_ahri_w_20261103\validate_ahri_w.py` et `result.json`, sources natives et manifeste identifiés ci-dessus, `docs/fidelity_requirement_trace_4_20.json:202671` et `:202735`, export local, Data Dragon 4.20.1 et source communautaire explicitement secondaire. Aucune donnée du plan ou de suivi n'est modifiée.
