# SYS-01.2-02 — Ahri E (Charm) : source native et consommateur courant

Audit daté du 2026-11-03 ; unité `AUD-SYS-01.2-02-AHRI-E-SOURCE-CONSUMER-01`. **Verdict limité : audit statique source → consommateur/refus terminé, 37/37 contrôles ciblés réussis.** La règle serveur historique et la fonctionnalité Ahri E ne sont pas qualifiées. Ce lot réutilise les preuves communes du rapport Ahri W V1169 sans rejouer son analyse.

## 1. Exigence et frontières

`CH-Ahri-E-SOURCE` (`OLF-dc7d6c29-3298-51a0-a527-ad45b4a42628`) demande la source 4.20, les valeurs de tous les rangs, coûts, délais, cibles et exceptions. Son état recensé est `a_qualifier`, son prérequis `CH-Ahri-IDENTITE` demeure ouvert. `CH-Ahri-E-SIMULATION-CONTRAT` (`OLF-6a079862-a17b-53ff-9b39-0331e1566f97`) demande chaque effet et branche du comportement ; état `a_faire`, dépendance SOURCE. La trace actuelle `docs/fidelity_requirement_trace_4_20.json:204052` et `:204116` fournit des liens sources et consommateurs mais n'accepte pas le comportement du jeu ; `unknown_ids=[]` ne qualifie pas les règles serveur.

Le périmètre de cette unité est la provenance client, les valeurs lisibles, la comparaison officielle, les initialisations Lua côté client, le trajet d'entrée actuel et son refus. Ahri E n'est pas implémenté sur le chemin ordinaire ; ce rapport ne coche aucune tâche ni acceptation.

## 2. Sources historiques, versions et valeurs

`docs/reference_client_4_20.json` identifie le client fourni **PUBLIC 4.20.0.315, EUW/en_GB**. La racine native consultée est `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy`. `DATA\Characters\Ahri\Ahri.inibin` (2 671 octets, SHA-256 `341500db9fd6825eaef151326bad28f8878f495185020f5c99e5ab03491a60e2`) donne directement `Data.Spell3=AhriSeduce`. `DATA\Characters\Ahri\Spells\AhriSeduce.inibin` (1 432 octets, SHA-256 `a9e8ff17bfef8f53a0b08c79a67b9f9fbe79600b66cc5f4f214cd1760ac3dc36`) a été décodé directement avec `tools/project-plan/reference_inibin.py` (145 clés). La ligne Ahri/slot 2 de `data/4.20/native_spells_420.json` concorde sur ces champs ; son `sha256=52386baa...` est l'empreinte d'un export JSON, pas celle de l'INIBIN natif.

| Rang E | 1 | 2 | 3 | 4 | 5 |
|---|---:|---:|---:|---:|---:|
| ManaCost | 85 | 85 | 85 | 85 | 85 |
| Cooldown (s) | 12 | 12 | 12 | 12 | 12 |
| Effect1, dommage de base | 60 | 90 | 120 | 150 | 180 |
| Effect2, durée affichée (s) | 1 | 1,25 | 1,5 | 1,75 | 2 |

Autres valeurs natives : `Coefficient≈0,35`, `CastRange=10000`, `CastRangeDisplayOverride=975`, `TargettingType=6`, `LineWidth=60`, `MissileSpeed=1200`, `OverrideCastTime=0,25`. Ce sont des champs **client**. Le sens de `TargettingType=6` et le rapport entre portée interne 10000, portée affichée 975, vitesse, collision et portée effective ne sont pas établis par ce seul décodage. `TextFlags` inclut `AffectFriends` et `AffectNeutral`, sans démontrer que Charm affecte effectivement ces unités. Aucun `Effect3Level1Amount` n'est présent ; cela n'exclut pas un effet calculé hors INIBIN.

Comparatif officiel distinct : `E:\mapslol3v3\Full_project_audit_2026-10-20\official_reference\championFull.json` (Data Dragon **4.20.1 en_US**, SHA-256 `72e26ad631c42f76cbd87ec6c5f656a79650ea5091d0fa2a604789d51c3b7404`), entrée Ahri E `AhriSeduce`. Coûts, délais, dégâts de base, durées et portée affichée 975 concordent. Son texte dit : projectile touchant un ennemi, charme et marche vers Ahri, **20 % de dégâts magiques supplémentaires d'Ahri pendant 6 secondes**, y compris les dégâts bruts du retour Q. Ce catalogue n'est pas une observation du serveur 4.20.0.315.

Appartenance directe : manifeste sélectionné `F:\OpenLeague\data\4.20\rads_manifests\lol_game_client\releases\0.0.1.7\releasemanifest` (4 905 302 octets, SHA-256 `88b09959b24053c422e209343083d549cdfe6380828b583710d7f9343c1aba09`, 70 286 membres). Pour chacun des six fichiers ci-dessous, taille et MD5 de l'octet natif concordent directement avec l'entrée du manifeste, via `frontend_builds.release_manifest` ; la version membre est affichée séparément de la release agrégée 0.0.1.7.

| Sous `DATA/Characters/Ahri/Spells/` | Octets | Version membre | SHA-256 natif |
|---|---:|---|---|
| `AhriSeduce.inibin` | 1432 | 0.0.0.188 | `a9e8ff17bfef8f53a0b08c79a67b9f9fbe79600b66cc5f4f214cd1760ac3dc36` |
| `AhriSeduce.luaobj` | 359 | 0.0.0.254 | `f85de5fe0e2144fd80b5c46e2e08573ba14fde4b9815ff6e4c833d1aac009a95` |
| `AhriSeduceMissile.inibin` | 1531 | 0.0.0.188 | `de44bf4c70c7901a8887b596b2884613e8da47b3b122b2f44c46668275cf69e0` |
| `AhriSeduceMissile.luaobj` | 90 | 0.0.0.254 | `b1361a97eb2baffe50ac89b73e24602fb3ca90d6ac83cb9f3f6a76caf3e6ae4c` |
| `AhriSeduceDoom.inibin` | 46 | 0.0.0.183 | `33b189ba265a15c0ecfc0fa009fcfb717ab600aa02e4e21578148850a2acdeb3` |
| `AhriSeduceDoom.luaobj` | 147 | 0.0.0.254 | `eda2c094da4f275582f245a79a4653978d2f7abad539ebaa3043888745226a17` |

Les trois LuaObjs sont des chunks Lua 5.1 que `lua51_reference` consomme jusqu'au dernier octet, sans prototype enfant. Ce lecteur strict ne qualifie pas l'initialisation littérale entière du LuaObj racine ; `native_lua.initialization` traite les trois sans arrêt et relève les littéraux de la racine : `NotSingleTargetSpell=true`, `IsDamagingSpell=true`, `DoesntTriggerSpellCasts=false`, `BuffTextureName=Ahri_Charm.dds`, `BuffName=AhriSeduce`, `PopupMessage1=game_floatingtext_Charmed`. Missile porte `NotSingleTargetSpell=true` ; Doom porte `BuffName=AhriSeduceDoom`. Ce sont des initialisations statiques côté client, pas une preuve de collision, effet de contrôle, priorité de cible ni dispatch serveur.

## 3. Consommateur réel et absence bornée

Le client courant `crates/client/src/spell_input.rs:1` ne route aucun slot Ahri vers une commande de point. Dans `crates/client/src/main.rs:1389-1453`, pour Ahri E (slot 2) sur le chemin d'une touche en partie prête, `ground_skill=false`, `targeted_q=false`, `slot!=3` : le client construit `Action::Cast {slot:2,target:None}`. `crates/core/src/lib.rs:621-622` dispatch `Action::Learn` et `Action::Cast`. `crates/core/src/progression.rs:164` refuse l'apprentissage d'Ahri avec `champion skill progression not implemented`. `crates/core/src/spells.rs:119-120` refuse son cast avec `champion spell not implemented`, après certains contrôles généraux (slot, joueur, mort, contrôle, cast en cours) et avant lecture du rang, coût, délai ou effets. Le HUD `crates/client/src/native_hud_spells.rs:28` sait rechercher `ManaCost{rank}` dans l'export pour une compétence déjà classée ; il ne rend pas Ahri E jouable. Recherche lexicale bornée `ahriseduce|ahri_seduce` dans `crates/{core,client,server}/src/*.rs` : aucune implémentation nommée trouvée ; un appel dynamique indirect n'est pas exclu par cette seule recherche.

## 4. Attendu, observé et contrôles réellement exécutés

Attendu dans cette unité : les octets client identifiés et la comparaison versionnée concordent sur les cinq rangs ; les six ressources liées appartiennent au manifeste exact ; le chemin actuel Ahri E aboutit à un refus explicite avant application du sort. Observé : **37/37** assertions réussies par `python -B E:\mapslol3v3\audit_sys01202_ahri_e_20261103\validate_ahri_e.py`, sortie `PASS_STATIC_SCOPE`, code de retour 0 ; reçu détaillé `result.json`. Les valeurs attendues sont figées dans le validateur, les valeurs observées et les empreintes courantes dans le reçu. Le contrôle est statique ; ni Cargo, ni jeu d'origine, ni binaire de jeu, ni test visuel/audio/réseau, ni REA n'a été exécuté. Aucun effet réussi en partie n'est revendiqué.

## 5. Écarts, inconnues et reprise

Le script communautaire `D:\LeagueOfLegendsV2\4.20\GameServer\Content\LeagueSandbox-Scripts\Characters\Ahri\E.cs` (2 324 octets, SHA-256 `f0b22ecc2de4851e610676105df9f6730b4f98911da665d8f9f040c0fb02a3cb`) calcule 60–180 + 0,35 AP, une durée de `0,95 + 0,25 × rang` (soit 1,2/1,45/1,7/1,95/2,2 s), sélectionne le premier ennemi de sa liste et applique un buff `Charm`. Ses cinq durées dépassent de 0,2 s celles de l'INIBIN et de Data Dragon. Le bonus officiel de 20 % pendant 6 secondes n'est pas implémenté dans ce seul `E.cs`. `docs/fidelity_community_semantics_4_20.json:1469` le classe `single_name_candidate_not_dispatch_proof` ; aucun conflit n'est tranché au profit de ce script.

Restent ouverts : formule/durée serveur exactes du build 4.20.0.315, effet de bonus et interaction Q, trajectoire/collision/largeur, unités admissibles et immunités, contrôle de déplacement et ténacité, boucliers, portée effective, ordre des cibles, conditions d'échec et effets visuels/audio/réseau. Reprendre sur un artefact serveur authentifié au build, un callsite original pertinent ou une capture reproductible du client/serveur de référence ; comparer les cinq rangs et les cas cibles/refus. Après implémentation autorisée, vérifier par un probe E isolé le routage, le refus sans mutation, le hit/miss, les durées et le bonus. Les fichiers LuaObj clients et le script communautaire ne remplacent pas cette preuve.

## 6. Corrections et critères de fin

Réutiliser les tâches existantes `CH-Ahri-E-SOURCE` (qualifier données et inconnues), `CH-Ahri-E-SIMULATION-CONTRAT` (chaque branche), `CH-Ahri-E-SIMULATION` (autorité de jeu), `CH-Ahri-E-NETWORK` et les tâches `CH-Ahri-E-PRESENTATION-*` et `CH-Ahri-E-ACCEPTANCE-RANG1..5`. Critères futurs : contrat 4.20 attribuable et arbitré, consommateur ordinaire intégré, succès et refus testés, rendus/sons/réseau vérifiés dans leur périmètre, acceptation distincte. Aucun doublon ni correction de code n'est créé par ce sous-audit.

## 7. Livrables et décision de relecture

Le dossier `E:\mapslol3v3\audit_sys01202_ahri_e_20261103` contient ce rapport, `validate_ahri_e.py` et `result.json`. Les sept rubriques de `docs/audit/AUDIT_CHARTER.md` sont renseignées **pour l'unité source → consommateur/refus seulement** : audit `TERMINÉ_BORNÉ`, implémentation E `ABSENTE_DU_CHEMIN_ORDINAIRE`, vérification `STATIQUE_37/37`, acceptation humaine `NON_DEMANDÉE_POUR_CET_AUDIT`. La relecture indépendante conclut `PASS` pour ce périmètre et confirme le reçu 37/37. Les tâches SOURCE/CONTRAT, leur prérequis, `SYS-01.2-02` et le jeu restent ouverts. La phase de validation sous E n'a modifié aucun fichier F, registre protégé, Plan, interface, base, goal, code produit ou asset. La publication documentaire sous F est une étape distincte.
