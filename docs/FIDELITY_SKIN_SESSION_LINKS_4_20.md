# Apparences en session — traçabilité V110

Les étapes préparatoires restent datées ;la preuve finale fixe l’intégration effective. Les contrats AIR sont des consommateurs client, pas des algorithmes serveur récupérés.

# V110 — frontières du contrat de skin

Les commandes Tauri play/join_local acceptent champion et summoners. LaunchSpec transmet OPENLEAGUE_CHAMPION et OPENLEAGUE_SUMMONERS. Les champs consultés ne comprennent pas skin_num. JoinRequest authentifié impose deny_unknown_fields ;ClientPacket::Join ancien comprend champion/summoners sans cette restriction.

Deux nouveaux tests publics exécutés :requête authentifiée nominale acceptée puis ajout skin_num refusé comme champ inconnu ;ancien Join accepte le JSON avec skin_num mais le champ disparaît à la resérialisation. Ce second résultat documente une lacune actuelle,ne valide pas une prise en charge du skin. Le test ne traverse pas les sockets ou les commandes Tauri.

Nouveau fichier crates/core/tests/skin_contract_observation.rs ;aucun code de production modifié. Log,binaire,SHA et sources dans skin-contract-test-receipt.json.24 avertissements core déjà présents. Pas de lancement graphique,aucun secret réel utilisé.

Suite :examiner inventaire/droit d’usage,projection aux destinataires,mort/reprise et ressources absentes ;lier les frontières réelles aux six exigences SYS-14.3,sans inventer une implémentation complète. V109 dernière intégration,Goal actif,cases inchangées.


# V110 — Consommateurs de session et limites des apparences

- SYS-14.3-02 : Inventaire de six objets et achats en or ; ne constitue pas un inventaire de droits sur les apparences. Source : `crates/core/src/shop.rs:261`.

- SYS-14.3-03 : Projection snapshot_for_atomic par joueur puis paquets courants ; aucun skin transporté par Champion. Source : `crates/server/src/session_host.rs:158`.

- SYS-14.3-03 : Structure sérialisée sans champ skin ni forme explicite ; champion est un identifiant de champion. Source : `crates/core/src/lib.rs:155`.

- SYS-14.3-04 : Mutation du joueur existant à la réapparition ; ne prouve pas la conservation d’un skin absent du contrat. Source : `crates/core/src/lifecycle.rs:33`.

- SYS-14.3-05 : Authentification du bail et conservation du player ; pas de sélection de skin dans JoinRequest. Source : `crates/server/src/reconnect.rs:147`.

- SYS-14.3-05 : Réinstalle horloge et route du joueur existant ; aucun changement de forme qualifié. Source : `crates/server/src/session_host.rs:102`.

- SYS-14.3-06 : Résout asset par nom et replie sur champions/{name}.glb si entrée absente ; aucun numéro de skin. Source : `crates/client/src/animation.rs:410`.

- SYS-14.3-06 : Continue si modèle ou première scène absent ; ne publie pas une erreur de skin dans cette fonction. Source : `crates/client/src/animation.rs:430`.

- SYS-14.3-03 : Consommateur joueur demande le modèle par champion uniquement. Source : `crates/client/src/main.rs:1227`.

Dix contrôles statiques réussis : neuf ancres uniques et absence des deux champs skin_num/skin_id dans Champion. SHA-256 des fichiers dans le reçu voisin. Les deux tests JSON du checkpoint précédent sont hérités, pas réexécutés. Aucun test réseau, rendu ou natif exécuté.

Le contrôle LoadState::Failed repéré dans native_minion_mips.rs concerne les DDS de sbires ; il ne qualifie pas le refus du GLB de skin. L’absence de skin dans ces contrats ne démontre pas une absence universelle dans tous les outils. Droits d’usage, formes et erreurs explicites restent ouverts.

Prochaine action : compléter les sources natives/locales de droits et formes puis intégrer les six associations SYS-14.3 avec lecteur et contrôles de refus. V109 reste la dernière intégration ; aucune case changée.


# V110 — Sélection AIR et droits

Quatre sources AIR relues ; quatre empreintes concordent avec le registre et quatre ancres sont uniques. Aucun bytecode ni serveur historique exécuté.

- Disponibilité AIR : owned, location, index zéro ou récompense ; pas une autorité serveur. Source : `F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibDomain_dat\scripts\com\riotgames\platform\gameclient\domain\ChampionSkin.as:124`.

- Refus UI si indisponible, désactivé ou déjà sélectionné ; allSkinsRentalUnlock participe au calcul précédent. Source : `F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibChampionSelectionCore_dat\scripts\com\riotgames\platform\gameclient\controllers\game\controllers\ChampionSkinController.as:105`.

- Commande AIR attend le service ; lastSelected changé dans onResult. Source : `F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibChampionSelectionCore_dat\scripts\com\riotgames\platform\gameclient\controllers\game\commands\select\SkinSelectCommand.as:60`.

- Arguments historiques championId et skinId ; ne pas les remplacer implicitement par skinIndex. Source : `F:\OpenLeague\docs\reference_air_sources\review\mod__ser__mod_ser_dat\scripts\com\riotgames\platform\gameclient\module\services\lcds\GameServiceImpl.as:204`.

Le contrat local collections sépare disponibilité des assets et droits locaux persistants ; son état documentaire not_implemented n’est pas une nouvelle preuve exhaustive du code. Les consommateurs de session examinés dans skin-session-consumer-research.json ne portent pas de skin. Le serveur Riot, la source des locations et le lien skinId vers numéro natif restent à qualifier. Aucun lien implicite entre identifiant global et index local.

Suite : construire les associations SYS-14.3 puis qualifier le lecteur et publier au registre. Aucun état de tâche changé.


## Vérification du lecteur

25 fichiers,75 contrôles et29 cas dont28 refus. Toutes les associations sont des frontières existantes ;aucune implémentation skin qualifiée. La première recherche ChampionSkin.as avait deux homonymes ;elle a été corrigée par module explicite,avant enregistrement. Les deux tests Rust sont hérités du premier checkpoint V110,pas rejoués lors de la publication.
| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-14.3-01 | AIR selects championId/skinId;current launcher and authenticated Join have no skin selection. Two retained JSON tests distinguish strict refusal from legacy field loss. | Qualify identity mapping and implement explicit transmission;never equate global skinId with skinIndex. |
| SYS-14.3-02 | AIR availability and disabled checks exist;local collections policy is distinct from gameplay item inventory and session capability. | Persistent account ownership,grants,rental expiry and authoritative local enforcement remain unqualified. |
| SYS-14.3-03 | Current per-player snapshot and Champion schema identify champion but have no explicit skin/form selection. | Implement and qualify authorized skin/form replication;visibility tests alone do not establish appearance replication. |
| SYS-14.3-04 | Respawn mutates existing player and rendering requests by champion name. | Skin persistence is unproven because the current contract carries no selected skin;all death/revival variants remain open. |
| SYS-14.3-05 | Resume authenticates lease and reconnects existing player/clock recipient. | No skin/form field restoration or transformation dispatch qualified;do not count connection preservation as appearance proof. |
| SYS-14.3-06 | Model request falls back to champions/name.glb if catalogue path absent;load_models waits when model/first scene absent. | Explicit skin resource failure reporting and substitution policy remain unqualified;minion DDS diagnostics are separate. |

Reçu : docs/reference_skin_session_sources/skin_session-links.json. Livraison : docs/fidelity_registry_skin_session_links_revision_4_20.json. Les six tâches et le Goal restent ouverts.
