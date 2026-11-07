# SYS-01.2-02 — Ahri R : source 4.20 et consommateurs actuels

Vérification du 2026-11-03. Unité `AUD-SYS-01.2-02-AHRI-R-SOURCE-CONSUMER-01`. Audit statique borné. Aucun code produit, registre, Plan, goal, application de suivi, base ou asset modifié. Le validateur et son reçu sont préparés sous `E:\mapslol3v3\audit_sys01202_ahri_r_20261103` pour publication documentaire. Aucun audit Ahri R ciblé n'a été trouvé parmi les rapports nommés sous `F:\OpenLeague\docs` avant ce lot ; les audits Ahri passif/Q/W ont été conservés.

## 1. Exigence et frontière

- `CH-Ahri-R-SOURCE` (`OLF-0883b7fe-dee8-5d3c-9bc4-726f3421fc2d`, `a_qualifier`) : qualifier l'identité historique de Spirit Rush, les trois rangs, coûts, délais, cibles et exceptions. Son prérequis `CH-Ahri-IDENTITE` reste `a_qualifier`.
- `CH-Ahri-R-SIMULATION-CONTRAT` (`OLF-96fed46e-18b0-54bd-9d33-00a1298eca70`, `a_faire`) : décrire chaque effet et branche ; dépend de `CH-Ahri-R-SOURCE`.

Ce sous-audit ferme **seulement** la liaison source native → export/référence → entrée et refus du code courant. Il ne ferme ni le contrat serveur historique, ni l'implémentation R, ni les tâches du plan. `docs/fidelity_requirement_trace_4_20.json:205433` et `:205497` associe déjà les deux exigences aux sources INIBIN, au catalogue et aux consommateurs génériques, avec `unknown_ids=[]` ; ce champ n'atteste pas que les branches du R sont qualifiées. Le prérequis D01-SYS-01-1 demeure non accepté d'après `docs/ai/CURRENT.md`.

## 2. Sources, identité et limites

Le contrat `docs/reference_client_4_20.json` identifie le client fourni **PUBLIC 4.20.0.315, EUW, en_GB**. Les fichiers natifs ci-dessous proviennent du deploy `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy`. Le manifeste exact sélectionné `data/4.20/rads_manifests/lol_game_client/releases/0.0.1.7/releasemanifest` fait 4 905 302 octets, SHA-256 `88b09959b24053c422e209343083d549cdfe6380828b583710d7f9343c1aba09`, et possède 70 286 membres. Taille et MD5 des huit ressources ci-dessous correspondent chacun à son membre ; leur release individuelle est consignée dans `result.json`. Cette appartenance n'établit pas la priorité d'exécution.

| Ressource native relative à `deploy` | Octets | SHA-256 | Constat |
| --- | ---: | --- | --- |
| `DATA/Characters/Ahri/Ahri.inibin` | 2 671 | `341500db9fd6825eaef151326bad28f8878f495185020f5c99e5ab03491a60e2` | `Data.Spell4=AhriTumble` |
| `DATA/Characters/Ahri/Spells/AhriTumble.inibin` | 1 398 | `47a7f844f0860844c64b5479193fd302e84cace869baa8956f1bff2a9356ba89` | 154 clés hachées INIBIN décodées |
| `DATA/Characters/Ahri/Spells/AhriTumbleMissile.inibin` | 1 506 | `13059ac9518372436d62f4c90ef5f8635250296743569d3eda75f50d11215f1f` | Ressource liée par nom, sans attribution de règles serveur |
| `DATA/Characters/Ahri/Spells/AhriTumble.luaobj` | 651 | `8b7d204b4f9facb8e44500eb5ef3ac65ea5adde69e0081660eef1ca41e1faa93` | Métadonnées client R |
| `DATA/Characters/Ahri/Spells/AhriTumbleKick.luaobj` | 154 | `3277b373c4f54e30c19100dadf10abf8170b44730fef8b7e12e9860fd237d8c5` | Littéral `BuffName=AkaliShadowDance` |
| `DATA/Characters/Ahri/Spells/AhriTumbleKickParticle.luaobj` | 56 | `7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0` | Aucun global littéral |
| `DATA/Characters/Ahri/Spells/AhriTumbleMissile.luaobj` | 227 | `583bb2f07856cb953a3328d6e87c5c48c25dacd235401c3b43c94cf0d3309772` | Métadonnées missile |
| `DATA/Characters/Ahri/Spells/AhriSpiritRushReadyManager.luaobj` | 90 | `0b936e4b235f178501c4b0a41735e6e80944f715b24b4a523e28570f8020d45a` | Métadonnée `PersistsThroughDeath=true` |

Lecture directe de `AhriTumble.inibin` par `tools/project-plan/reference_inibin.py` :

| Champ `SpellData` | Rang 1 | Rang 2 | Rang 3 |
| --- | ---: | ---: | ---: |
| `ManaCost` | 100 | 100 | 100 |
| `Cooldown` | 110 | 95 | 80 |
| `Effect1LevelNAmount` | 70 | 110 | 150 |
| `Effect2LevelNAmount` | 10 | 20 | 30 |
| `Effect3LevelNAmount` | 28 | 23 | 18 |
| `Effect4LevelNAmount` | 2 | 2 | 2 |
| `Effect5LevelNAmount` | 1 | 1 | 1 |

Autres champs observés : `Coefficient≈0,3`, `CastRange=25000`, `CastRangeDisplayOverride=450`, `TargettingType=6`, `CastRadius=300`, `BounceRadius=600`, `CastType=0`, `AnimationName=Spell4`, `CastFrame=15`. Les noms et valeurs des champs ne démontrent pas leurs usages effectifs : **25000 ne devient pas une portée de dash**, et 450 est un override d'affichage, pas une mesure du déplacement réalisé. Les effets 2 à 5 ne sont attribués à aucune branche serveur par cet audit. L'export `data/4.20/native_spells_420.json` Ahri/slot 3 concorde avec les 21 valeurs de rang ; son champ `sha256=ea567956...` désigne le JSON exporté, pas l'INIBIN natif, et `mechanics_validated=false`.

Le catalogue officiel comparatif Riot Data Dragon **4.20.1 en_US**, `E:\mapslol3v3\Full_project_audit_2026-10-20\official_reference\championFull.json` (SHA-256 `72e26ad631c42f76cbd87ec6c5f656a79650ea5091d0fa2a604789d51c3b7404`), donne trois rangs, 100 mana, 110/95/80 s, 70/110/150 dégâts de base, coefficient AP 0,3 et portée affichée 450. Sa description mentionne un dash, trois projectiles vers des ennemis proches avec priorité aux champions, et jusqu'à trois activations en dix secondes. Cette version/locale ne constitue pas une observation du serveur 4.20.0.315 EUW.

Les cinq LuaObj portent du bytecode Lua 5.1 ; `tools/project-plan/lua51_reference.py` les consomme entièrement et n'y trouve aucun prototype enfant. Le lecteur strict s'arrête pour `AhriTumble.luaobj` à `NEWTABLE` pc16 ; `tools/native_lua.py` récupère sa table simple sans arrêt. On y lit notamment `BuffName=AhriTumble`, `IsDamagingSpell=true`, `BuffTextureName=Ahri_SpiritRush.dds` et `ChainMissileParameters.MaximumHits=10` pour ses cinq index. `AhriTumbleKick.luaobj` porte littéralement `BuffName=AkaliShadowDance`; son rôle effectif n'est pas qualifié. Le LuaObj missile porte `SpellDamageRatio=1.0`. Ces initialisations **client** ne prouvent ni dix impacts, ni acquisition/priorité des cibles, ni dash, ni recharge ou dégâts serveur.

## 3. Consommateurs actuels

`crates/core/src/lib.rs:621–623` distribue `Action::Learn`, `Action::Cast` et `Action::CastAt`. `crates/core/src/progression.rs:163–165` refuse l'apprentissage d'Ahri avec `champion skill progression not implemented`. Dans `crates/core/src/spells.rs:101–121`, après les gardes communes, Ahri atteint `champion spell not implemented` **avant** la lecture du rang et des valeurs. Dans `crates/core/src/annie_w.rs:29–51`, `cast_at` atteint `champion ground spell not implemented` après ses gardes et avant le rang. Aucun succès R n'est ainsi établi par la présence de données.

`crates/client/src/spell_input.rs:1` ne classe pas Ahri R parmi les slots au sol. `crates/client/src/main.rs:1389–1394` traite cependant **tout slot 3** comme `targeted_skill` ; au clic de monde, la branche non `ground_skill` produit `Action::Cast { slot: 3, target }` (`:1489–1491`), puis le cœur refuse Ahri. Ce routage actuel par clic n'est pas assimilé au dash historique. Le coût du HUD dans `crates/client/src/native_hud_spells.rs:21–30` est pris dans l'export seulement après ses gardes de rang/disponibilité ; l'apprentissage ordinaire d'Ahri est refusé. La recherche bornée des littéraux `AhriTumble`, `AhriSpiritRush`, `Spirit Rush`, `ahri_r` dans les `.rs` de `crates/{core,client,server}/src` ne trouve aucun implémenteur nommé R, sans exclure tous les chemins indirects. Les SHA des fichiers Rust inspectés sont dans le reçu.

## 4. Attendu, observé, contrôle

| Cas | Attendu pour ce sous-audit | Observé | Limite |
| --- | --- | --- | --- |
| Identité native R | `Spell4` rejoint l'INIBIN du R sélectionné | Nom, SHA, taille et membership concordent | Pas de comportement serveur |
| Trois rangs | Coûts/délais/effets comparés sans conversion inventée | 21 valeurs INIBIN = export ; coûts, délais et effet1 concordent avec Data Dragon | Signification des effets 2–5 ouverte |
| LuaObj | Lecture bornée et appartenance au manifeste | 5/5 LuaObj taille/MD5 conformes ; métadonnées extraites | Priorité et emploi runtime inconnus |
| Entrée R actuelle | Route et refus documentés | Learn, Cast, CastAt refusent Ahri après gardes applicables ; client R route vers Cast au clic | Aucune commande R exécutée |
| Contrat historique complet | Dash, activations, cibles, dégâts, exceptions attribués | **Non décidé** | Requiert serveur natif attribuable ou observation reproductible du client/serveur exact |

Commande exécutée : `python -B E:\mapslol3v3\audit_sys01202_ahri_r_20261103\validate_ahri_r.py`. Résultat `PASS_STATIC_SCOPE`, **50/50** contrôles réussis dans `E:\mapslol3v3\audit_sys01202_ahri_r_20261103\result.json`. Ce succès concerne le périmètre statique nommé. Aucun Cargo, binaire Rust R, client graphique, jeu original, serveur, réseau, VFX ou audio exécuté ; le code Lua/C# est lu, pas lancé. Les vérifications Q et W antérieures ne sont pas présentées comme tests R.

## 5. Écarts et conditions de reprise

1. Le script communautaire `D:\LeagueOfLegendsV2\4.20\GameServer\Content\LeagueSandbox-Scripts\Characters\Ahri\R.cs` (SHA-256 `8f2b145e2dcd153a9ac939a0a3d99449d9089bfead3c10393680a8d6632b4034`) se qualifie lui-même de simplifié : son `OnSpellPostCast` choisit les trois unités les plus proches et applique `30 + level*40 + AP*0,3`. Le rapprochement dans `docs/fidelity_community_review_4_20.json` porte le statut `single_name_candidate_not_dispatch_proof`, `dispatch_proven=false`, `script_fully_qualified=false`. Ce C# ne devient pas la règle Riot ; il ne tranche pas le dash, les trois activations, la priorité champion ou le ciblage exact.
2. La portée effective du dash et la signification des champs 25000/450, la fenêtre des trois activations et son coût/cooldown, le timing des projectiles, la sélection/priorité/visibilité des cibles, les cas sans cible, collision, mort, immunité, dégâts, boucliers et interactions du buff restent ouverts. Reprise : artefact serveur attribuable à 4.20.0.315 ou capture reproductible du jeu/serveur exact, avec cas nominaux et limites par rang. Ne pas relancer la même extraction INIBIN/LuaObj sans piste nouvelle.
3. Le refus actuel est prouvé statiquement, pas par un test de non-mutation. Reprise : probe R isolé sur code courant, ou vérification de partie après implémentation autorisée, avec binaires, ressources, état avant/après et erreurs identifiés. Le routage R ciblé du client doit être confronté à l'interface historique et au contrat de dash avant correction.

## 6. Corrections existantes, sans nouveau statut

- `CH-Ahri-R-SOURCE` : qualifier l'usage réel des champs et les règles historiques par rang sur preuve attribuable ; fin lorsque coûts, délais, portée, cibles et exceptions ont source, résultat attendu/observé et inconnues résolues ou explicitement non résolues.
- `CH-Ahri-R-SIMULATION-CONTRAT` : détailler séparément dash, activations, projectiles, cibles, dégâts et refus ; fin lorsque chaque branche possède une source ou un contrat local déclaré, plus cas limites vérifiables.
- `CH-Ahri-R-SIMULATION` : implémenter ensuite la logique autoritaire et tester succès/refus/non-mutation ; `CH-Ahri-R-NETWORK` et `CH-Ahri-R-PRESENTATION-ANIMATION`, `-VFX`, `-AUDIO`, `-HUD` couvrent leurs chemins propres ; `CH-Ahri-R-ACCEPTANCE-RANG1..3` vérifient les rangs. Ces tâches restent ouvertes. Aucun code produit ni état du plan n'est modifié au titre de ce lot.

## 7. Décision et preuves

Les sept rubriques de `docs/audit/AUDIT_CHARTER.md` sont couvertes **pour la seule unité source → consommateur/refus statique** : exigence/frontière, provenance, code courant, attendu/observé, inconnues, corrections avec IDs et preuves datées. Verdict : `AUDIT_BORNÉ_TERMINÉ`, implémentation R `ABSENTE_DU_CHEMIN_ORDINAIRE`, vérification `STATIQUE_50/50`, acceptation humaine `NON_DEMANDÉE_POUR_CET_AUDIT`. `CH-Ahri-R-SOURCE`, `CH-Ahri-R-SIMULATION-CONTRAT`, leurs dépendances, `SYS-01.2-02` et le jeu restent ouverts. Preuves : validateur et reçu E ci-dessus, sources natives et manifeste identifiés, `docs/fidelity_requirement_trace_4_20.json:205433` / `:205497`, export local, Data Dragon 4.20.1 et C# communautaire explicitement secondaire.

Relecture indépendante : **PASS, 50/50 contrôles statiques**. Le fichier natif comporte 154 clés hachées INIBIN décodées ; l'export nomme 149 champs `SpellData`. Le comptage natif ne désigne donc pas 154 champs `SpellData` nommés.
