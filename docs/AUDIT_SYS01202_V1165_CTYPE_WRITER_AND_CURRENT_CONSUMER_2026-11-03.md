# SYS-01.2-02 — V1165, writer CRT historique et consommateur actuel

Date : 2026-11-03  
Unité historique : `AUD-SYS-01.2-02-V1165-CTYPE-WRITER-REA-01`  
Unité courante : `AUD-SYS-01.2-02-CTYPE-CURRENT-CONSUMER-01`  
Exigence : `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`  
Inconnue : `OLU-3293c388-b623-5429-8fd7-c89f6f0aba7e`

## Décisions séparées

| Dimension | Résultat |
|---|---|
| Audit du consommateur OpenLeague actuel | `TERMINÉ_AVEC_PREUVES` |
| Implémentation actuelle | `PARTIELLE_NON_RELIÉE_DE_BOUT_EN_BOUT` |
| Vérification actuelle | `STATIQUE_RÉUSSIE_POUR_LE_PÉRIMÈTRE` |
| Tentative REA historique V1165 | `TOOL_FAILURE_PRESERVED` |
| Inconnue historique OLU-3293 | `OPEN` |
| Parent SYS-01.2-02 | `OPEN_PARTIAL_NOT_BLOCKED_AS_A_WHOLE` |
| Acceptation humaine | non applicable à cet audit technique |

Le prérequis `D01-SYS-01-1` reste `a_faire`. Rien dans ce lot ne l'accepte et aucun état de plan n'est modifié.

## 1. Exigence et frontière

La question historique est l'état CRT/locale effectif qui gouverne les branches de case-folding lorsque le global natif `0x14AE870` est non nul. Le sous-lot V1165 devait uniquement identifier la fonction contenant le store à `0xCA99C7`, ses callers directs et la provenance de `[ebp+0x0C]`.

Le côté courant devait établir si OpenLeague possède un consommateur réel de ce prédicat et s'il est relié au démarrage normal. Les tables NLS historiques, l'exécution du client Riot, les branches non ASCII effectives et une sélection complète de ressource sont exclus.

## 2. Sources historiques réutilisées

Source exacte : `League of Legends.exe` 4.20.0.315, 15 973 880 octets, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

La baseline V1039/V1040, non rejouée, établit :

- `0xCA99C7` est le début de `mov dword ptr [0x14AE870],1` ; `0xCA99C9` est l'opérande absolu ;
- le site `0xCA99BC` appelle `0xCB6B7E` ;
- le pointeur entrant `[ebp+0x0C]` est comparé à `L"C"` ;
- un résultat différent conduit au store de `1` ;
- les 26 références zéro-state et les cas ASCII acquis ne doivent pas être rejoués ;
- fonction englobante, callers, origine historique du paramètre, ordre d'initialisation et tables effectives restaient inconnus.

Le reçu `original-directory-execution.json` conserve `global=0x14ae870`, `value=0` et `historical_later_locale_override_qualified=false`.

## 3. Tentative REA historique

Une seule session REA 6.4.0 / Ghidra 12.1.4 a été exécutée sur une copie privée du PE :

- `open_binary` : PE x86 exact, SHA-256 conforme ;
- `list_segments` : `provider_timeout`, opération `list_segments`, délai déclaré `900000 ms`, durée journalisée `900542.59 ms` ;
- appels fonctionnels : `0` ;
- procédure résolue : aucune ;
- fonction, assemblage, analyse et xrefs de `0xCA99C7` : non produits ;
- export du bundle : échec distinct `execution_failure` (`details.operation=write`, `details.reason=io`) ; aucun lien causal avec le timeout du provider n'est établi ;
- `close_binary`, fermeture client et transport : acquittés ;
- processus Node/Java/Javaw résiduels : `0` ;
- retry : `0` ; repli Ghidra direct : `false`.

Conclusion historique : `[ebp+0x0C] = UNKNOWN_UNCHANGED`. Cette tentative ne prouve aucune provenance nouvelle et ne résout pas OLU-3293.

Règle d'arrêt : `STOP_AFTER_SINGLE_PROVIDER_TIMEOUT_NO_RETRY_NO_DIRECT_GHIDRA_FALLBACK`.

## 4. Consommateurs OpenLeague actuels

Le démarrage normal attache la banque Windows courante via `crates/client/src/main.rs` et `audio_replay_runtime_image`. Le package `data/4.20/runtime/replay_runtime_image.bin` fait 21 110 octets, contient 73 régions et porte le SHA-256 `d2d0a8517da861a959bbb4f6914573a7897c6f78c1f1d8d7e6e90b50e50a5099`. L'adresse `0x14AE870` y existe avec la valeur initiale `0`. Cela décrit l'entrée OpenLeague, pas l'état historique post-initialisation.

Deux consommateurs composants sont présents :

1. `audio_replay_loading_owner` lit `C_LOCALE_FLAG = 0x14ae870`, applique le pli ASCII `A-Z → a-z` en état C et refuse explicitement la comparaison non-C non connectée. Aucun appel de production qualifié à son constructeur n'a été trouvé.
2. `audio_loading_resource_cache` lit le même prédicat par octet, applique le pli ASCII et refuse explicitement la locale non-C à la frontière `C985D6`. La route packet95 existe, mais le manager requis n'est pas publié et `initialize_loading_resources` n'apparaît qu'à sa définition dans les sources de production.

Le module `native_config_cache_reload` ne lit pas `0x14AE870` et n'a aucun callsite de production qualifié ; il n'est pas compté comme consommateur runtime de bout en bout.

Résultat : l'équivalent courant existe et les refus sont explicites, mais le démarrage normal ne publie ni le loading owner ni le resource manager. La fonctionnalité n'est donc pas complète.

## 5. Attendu, observé et contrôles

| Cas | Attendu | Observé |
|---|---|---|
| Identité historique | PE exact | conforme |
| Writer/callers historiques | procédure, instructions et arêtes directes | non produits, timeout provider |
| Paramètre historique | provenance de `[ebp+0x0C]` | inconnue inchangée |
| Banque OpenLeague | adresse et prédicat disponibles | valeur initiale 0 |
| Branche C/ASCII | pli borné | présente dans deux composants |
| Branche non-C | implémentation reliée ou refus | refus explicite dans deux composants |
| Parcours courant complet | owner/manager construits et publiés | absent |

Contrôles réellement exécutés : baseline 39/39, session REA 59/59 sur la conservation correcte de l'échec, consommateur courant 32/32, revue indépendante 49/49. Aucun Cargo, jeu, D3D9 ou rendu n'a été exécuté.

## 6. Écarts et actions restantes

Historique : reprendre uniquement avec un projet/session analysé réutilisable et vérifié pour ce PE exact, ou après diagnostic matériel du timeout du provider. Une relance identique est interdite. Il faut ensuite obtenir la borne de fonction, les xrefs d'appel, la provenance du paramètre, l'ordre d'initialisation CRT/thread et les tables effectives.

Courant : correction documentaire proposée `COR-SYS-01.2-02-CTYPE-CURRENT-END-TO-END-01` — construire et publier le loading owner et le resource manager depuis le démarrage normal, relier une branche non-C vérifiée aux tables effectives, puis prouver un nominal ASCII, un nominal non-C ou son refus contractuel, les erreurs provider et le nettoyage. Cette correction n'est pas exécutée sous la restriction actuelle.

## 7. Preuves et intégrité

- Baseline V1165 : manifeste SHA-256 `c85422cf3daf80c7d44d438eb59262de79f13349578bd4025d7e6fa53dbbf467`.
- Session REA V1165 : manifeste SHA-256 `803cca4c707111d3a84a4b6b8d96d9ac1fcb71d17e220dfff37bc831609e0a2a`.
- Consommateur courant : manifeste SHA-256 `61faa323c91a7f175ae6802b9cdaa573b883333bf7f31a96d1de8e470f3f1a15`.
- Revue indépendante : manifeste SHA-256 `591f332f308015f3e2ccf4f86a97b31b848f84a8710f06cec0b7fd4789869474`.

Les cinq fichiers protégés conservent leurs empreintes autorisées avant/après. Aucun code, asset, Goal, Plan, UI, application, base ou registre protégé n'est modifié par ce lot.

