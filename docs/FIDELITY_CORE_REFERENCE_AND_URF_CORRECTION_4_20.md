# Références core complètes et correction des deux comparaisons Urf

Le contrôle MD5 et SHA-256 a parcouru les 70 286 membres du manifeste sélectionné lol_game_client/0.0.1.7. Résultat : 70 275 fichiers conformes dans deploy ; huit chemins absents et trois fichiers divergents dans cette copie. Les onze fichiers exacts avaient déjà été récupérés et conservés. Leurs copies du projet, leurs fichiers de provenance, tailles, MD5, SHA et releases de payload sont revérifiés. Aucun nouveau téléchargement ni remplacement de la copie D: n’a eu lieu.

Le lecteur actuel core_reference_coverage.py expose une politique explicite pour l’analyse des références : fichier décompressé exact, sinon copie récupérée exacte. Chaque membre conserve son chemin logique, sa release de payload, l’origine de sa source et ses empreintes. Un membre sans récupération exacte ou une récupération de mauvais MD5 sont refusés. Cette sélection administrative de référence ne prouve pas les priorités du moteur ni un montage RADS réussi.

## Correction de la revue communautaire

La revue antérieure avait comparé Urf.json à la copie décompressée Urf.inibin de 515 octets, SHA 799e66595b4f9cbaffa5c4dc48a947def01dfd0ab9f100d63a81e07cff449b27. Ce fichier diffère du membre du manifeste sélectionné : 610 octets, MD5 63eb93a8d415b4a7eea65e7f40665f6f, SHA 10aba1ff86213cc533ab4e8f45d0c63646ff16d8ba1dcd16be28fcae4d296d3a. La copie exacte récupérée était déjà disponible ; elle constitue la référence de cette comparaison.

| Champ | Copie décompressée divergente | Membre exact sélectionné | Communauté | Décision courante |
|---|---|---|---|---|
| Info.IconCircle | Urf_Circle.dds | Dragon_Circle.dds | Dragon_Circle.dds | Conforme pour ce champ |
| Info.IconSquare | Urf_Square.dds | Dragon_Square.dds | Dragon_Square.dds | Conforme pour ce champ |

L’exclusion antérieure de « substitution Dragon » est donc remplacée pour ces deux champs seulement. Les deux payloads d’icônes sont eux-mêmes conformes au manifeste. La revue, ses deux anciens enregistrements et tous ses chiffres historiques restent conservés : il ne faut plus lire leur conclusion d’exclusion comme décision courante. Le nouvel outil audit_urf_selected_reference.py consomme le manifeste, la récupération exacte et les valeurs communautaires ; il refuse de rafraîchir silencieusement une source modifiée. Les autres règles, scripts, statistiques et présentations ne sont pas qualifiés par cette correction.

## Limites et suite

La provenance de l’archive conservée reste distincte d’une authentification indépendante par RiotCDN. Les anciens essais natifs et leurs limites sont conservés ; aucun nouveau programme historique, gameplay ou test Cargo n’est exécuté ici. Les flags bruts core4/6/22, le format des archives, le montage réussi, les I/O ordinaires et priorités effectives restent à qualifier. Les autres inconnues du Goal, dont les deux caps AIR4312/4313 et les sémantiques des 797 scripts, restent ouvertes. Les six tâches et les cases utilisateur ne sont pas acceptées automatiquement.

Preuves : [couverture et correction](reference_native_skin_loader_sources/core-reference-coverage-and-urf-correction.json), [intégration et audit](fidelity_registry_core_reference_revision_4_20.json).

## 2026-11-02 — audit borné URF/Cheats : identité et consommateur actuel

### Identité des deux variantes

Les reçus existants du registre `fidelity_sources_4_20.json` ont été réutilisés. Les deux fichiers loose du client fourni divergent chacun du membre exact préservé pour le projet `lol_game_client/0.0.1.7` ; les copies F sous `data/4.20/recovered_client_assets` correspondent aux membres récupérés. Les empreintes ci-dessous identifient les octets observés, sans prétendre établir à elles seules la politique historique de déploiement ni l’authenticité indépendante de l’archive communautaire.

| Ressource logique | Copie loose 4.20.0.315 | Membre exact sélectionné dans le projet RADS | Copie exacte préservée sur F |
|---|---|---|---|
| `DATA/Characters/Urf/Urf.inibin` | `RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/.../Urf.inibin` ; source `OLS-48e20f68-1348-5708-9e3c-644f1246d9cb` ; 515 octets ; MD5 `db15c1934bf303d71ffe3f02e4782ff5` ; SHA-256 `799e66595b4f9cbaffa5c4dc48a947def01dfd0ab9f100d63a81e07cff449b27` | `live/projects/lol_game_client/releases/0.0.1.7/files/.../Urf.inibin` ; 610 octets ; MD5 `63eb93a8d415b4a7eea65e7f40665f6f` ; SHA-256 `10aba1ff86213cc533ab4e8f45d0c63646ff16d8ba1dcd16be28fcae4d296d3a` ; archive file ID `F611EAF58B893139` | `data/4.20/recovered_client_assets/DATA/Characters/Urf/Urf.inibin` ; 610 octets ; SHA-256 identique au membre exact ; source `OLS-efb773ac-b9d8-581e-bae6-260483235f4e` |
| `DATA/CFG/defaults/Cheats.cfg` | `RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/.../Cheats.cfg` ; source `OLS-46c76b0f-941e-5437-9ce3-832f7e74d520` ; 150 octets ; MD5 `0c22edb003b4452850141660324bcfb6` ; SHA-256 `7ea33682baa99c6f620d2cc54f3fcbd7f7d519d75adf5d96ce39a1744838bbbc` | `live/projects/lol_game_client/releases/0.0.0.64/files/DATA/CFG/defaults/Cheats.cfg` dans le projet `lol_game_client/0.0.1.7` ; 148 octets ; MD5 `a5f4d81fcd498a88ba4782d60bfebdd9` ; SHA-256 `ab54ae2f8b0dba1aea64c95577018c834db8fa9dfa2ff4a6a6f64d83d56aa34c` ; archive file ID `AFF0C0C07893E543` | `data/4.20/recovered_client_assets/DATA/CFG/defaults/Cheats.cfg` ; 148 octets ; SHA-256 identique au membre exact ; source `OLS-0322e7b9-cda0-52dc-b99e-bfe4da944fe8` |

La sélection exacte de ces deux membres dans le manifeste est établie par les reçus conservés ; elle ne signifie pas que le client historique les choisissait à l’exécution. Pour Urf, la correction d’icônes documentée plus haut reste limitée aux deux champs `Info.IconCircle` et `Info.IconSquare`.

### Consommateur OpenLeague observé

Inspection statique de `crates/client/src/main.rs` : la racine du client est `CARGO_MANIFEST_DIR/../..` (ligne 518). Le démarrage monte `native_zip_provider::Provider::from_catalog` (ligne 599), charge le HUD (ligne 600), puis appelle `native_user_settings::load_using` (ligne 607). `data/4.20/native_zip_catalog.json` liste cinq archives de menu/HUD et de sorts ; `Provider::read_optional` consulte l’index d’archives puis, si le nom n’y est pas, tente `root.join(path)` via le fournisseur fichier. Le chemin de configuration courant est `Game.cfg` ; ce n’est pas un appel à `Cheats.cfg`.

La recherche bornée des identifiants `Urf`, `Cheats.cfg`, `DATA/Characters/...` et `DATA/CFG/defaults/...` dans les sources Rust de `crates` ne trouve aucun appel direct pour ces deux ressources ni de chargeur générique de champion INIBIN. L’unique parseur INIBIN observé dans ce périmètre est celui de la carte Map10. Les chemins de repli littéraux `F:\OpenLeague\DATA\Characters\Urf\Urf.inibin` et `F:\OpenLeague\DATA\CFG\defaults\Cheats.cfg` sont absents ; les copies récupérées sont plus bas sous `data/4.20/recovered_client_assets` et ne sont pas automatiquement visées par ce repli.

### Décision de clôture du sous-lot

**Audit de provenance : terminé pour ces deux ressources** — chaque variante observée, son membre exact, son empreinte et la copie F correspondante sont reliés. **Audit du consommateur direct : terminé dans le périmètre Rust inspecté** — aucun appel direct actuel n’est établi ; le fournisseur générique existe mais ne prouve ni demande de ces ressources ni comportement de jeu. **Raccordement fonctionnel et sélection historique effective : ouverts.** Aucun client, test, build ou rendu n’a été lancé pour cette vérification.

Reprise de ces deux ressources seulement si un callsite consommateur concret ou un manifeste de démarrage historique nouveau est fourni/identifié. Il faudra alors relier le chemin logique au consommateur, établir l’ordre archive/fichier/overlay effectif, puis vérifier les octets utilisés face aux deux variantes conservées. Ces constats ne clôturent ni `SYS-01.2-02` ni l’acceptation du jeu.