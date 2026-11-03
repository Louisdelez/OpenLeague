# Sources et consommateurs des configurations de langue — V52

Les 19 tables de polices natives et leurs copies installées sont SHA-identiques. Les 31 paires de ressources importées sont contrôlées : 29 membres sélectionnés sont conformes ; DATA/cfg/defaults/locale.cfg est non listé et le fichier système de locale est hors périmètre des deux projets. Ces différences de périmètre ne sont pas masquées.

Les exigences LOCALE-*-SOURCE et LOCALE-*-FONT sont reliées aux lecteurs existants : import préservant les fichiers divergents, parseur du profil à quatre alias/une bibliothèque, chargement de la configuration, NormalFont, appel de démarrage et sélection de typeface. Le parseur Rust inchangé est exécuté pour 19 tables natives et 19 copies : 152 assertions d'alias, 38 NormalFont, 38 bibliothèques et 13 refus. Deux contrôles confirment que les lignes tr sont ignorées ; cela ne qualifie pas leur traduction.

22 contrôles de qualification passent, dont 20 refus de preuves altérées ou de portée exagérée. Aucun ancien test global ni importeur original rejoué. Le chargeur IO, Bevy, le GPU et le client historique ne sont pas exécutés par cette qualification. Les implémentations actuelles de polices/glyphes sont conservées sans être déclarées absentes ni qualifiées par ce seul composant.

Les 38 tâches et leurs questions restent ouvertes. SOURCE demande encore les consommateurs exacts des textes, voix/médias, disponibilité et sélection ; FONT demande glyphes, nombres, fallback et rendu. Aucun comportement de jeu, tâche complète ou acceptation humaine n'est déduit de la présence ou du parsing des fichiers.

Reçu : docs/reference_locale_font_sources/locale-font-links.json. Livraison : docs/fidelity_registry_locale_font_links_revision_4_20.json. Les six objectifs et toutes les preuves précédentes sont conservés ; Goal actif.

## Supplément — Liaison de Locale.cfg au démarrage OpenLeague (2026-11-02)

Réexamen ciblé de l’inconnue « producteur de defaults/Locale.cfg non listé », en réutilisant le rapport V52, son reçu et l’exécution native héritée. La source originale `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\CFG\defaults\Locale.cfg` et la copie OpenLeague `F:\OpenLeague\data\4.20\font_configuration\locale.cfg` font toutes deux 37 octets et SHA-256 `053f2ad45a7d6c808ba0b394f6a101e985099a953e5a2c7575ab44467804b42f`; le contenu observé est `[General] LanguageLocaleRegion=en_GB`. L’identité octet pour octet confirme le lien de ressource, mais ne détermine pas l’ordre de montage historique Riot.

Consommateur courant sur F, constaté dans le code source : `native_hud_font_configuration::load` lit cette copie, parse `[General].LanguageLocaleRegion`, sélectionne l’entrée correspondante de `native_font_configuration_manifest.json` et charge la table indiquée. Pour `en_GB`, la table est `data/4.20/font_configuration/menu/fontconfig_en_GB.txt`, SHA-256 `1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3`. `native_zip_provider::startup_hud` appelle ce chargeur et sélectionne les fontes; `main.rs` appelle `startup_hud`, insère `StartupHud` dans l’application, puis ajoute les plugins de fontes, métriques, GPU et widgets. Les chemins source consultés sont `crates/client/src/native_hud_font_configuration.rs` (SHA-256 `500ea12ef4fffd40ccf856169d59b2a9c17194620c22bacbe7c7422fc329bf14`), `native_zip_provider.rs` (`84f31115bf4413eb2617aa7eedf353d0fd36ee18d8afd2b5d4b35475eceacb6c`) et `main.rs` (`eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620`). Le sélecteur refuse statiquement un fichier invalide, une clé absente, une locale sans entrée et un chemin hors du préfixe permis. Aucun de ces refus n’a été rejoué dans cette relecture.

| Dimension | Résultat de ce lot |
|---|---|
| Audit | Liaison source native → copie locale → sélection de police dans le chemin de démarrage actuel établie statiquement pour `en_GB`. |
| Implémentation | Le choix local du profil et l’injection de `StartupHud` existent; la localisation complète, les remplacements de locale et la parité native ne sont pas établis par cette chaîne. |
| Vérification | Rehash de la source D, de la copie F, de la table et des trois fichiers consommateur; source lue. Aucun nouveau test, lancement du client ou rendu effectué. Les assertions V52 restent des preuves héritées, pas des exécutions de ce jour. |
| Acceptation humaine | Non donnée. |

Restent ouverts : le montage/backend historique effectif et la priorité des overlays, la relation de cette valeur aux autres consommateurs de texte/traduction, et le rendu réel. Ce résultat clôt uniquement l’association statique de cette ressource à ce chemin de fonte; il ne clôt ni toutes les exigences LOCALE ni SYS-01.2-02. Aucun statut Goal, code, application de suivi, base, installation ou migration n’a été modifié.

Précision de reprise sur le fournisseur : le chargeur de police prend seulement `root` et lit `data/4.20/font_configuration/locale.cfg` avec `std::fs::read`; il ne reçoit pas `Provider` et ne consulte pas l’archive ZIP ni le chemin utilisateur `Game.cfg`. Le consommateur F vérifié sélectionne donc le profil de fontes à partir de cette copie directe `en_GB`; aucun overlay de locale ou ordre de montage n’est exercé par ce chemin. Pour reprendre cette limite, établir séparément la priorité native des backends/overlays pour `Locale.cfg`, puis relier ou qualifier le consommateur OpenLeague d’un override réel. Ce constat est statique; aucun remplacement d’asset ni lancement n’a été fait.

## Supplément — archive de defaults et SystemLocale (2026-11-02)

La recherche de provenance a trouvé les manifestes de déploiement `releases/0.0.1.68/deploy/files.json` et `oldFiles.json` (chacun 77 224 octets, SHA-256 `f9c2680729f3c58d24ed5cd129718d4ecefc4634e311d5fe6dfa855a72012281`). Tous deux déclarent `DATA/CFG/defaults.zip`, MD5 attendu `5b0713441b5e6ee27af56c23a8b625e4`. L’archive n’existe ni à ce chemin de déploiement ni ailleurs sous le RADS fourni (`rg --files -g defaults.zip`). Le `Locale.cfg` loose de 37 octets reste présent et identique au fichier F, mais sans l’archive on ne peut pas vérifier ses membres ni attribuer le staging de cette copie au ZIP. Reprise : récupérer `defaults.zip` de ce release avec le MD5 attendu, ou un manifeste de staging autoritatif établissant la provenance du fichier loose.

La seconde ressource est distincte : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\system\locale.cfg` et `F:\OpenLeague\data\4.20\font_configuration\system_locale.cfg` ont toutes deux 12 octets, SHA-256 `82ecb50f4bf707a35a13a6b6987df89fa6044bedac6fc8aca179890a7890d6ae`, contenu `locale=en_gb`. Le manifeste de fontes enregistre sa provenance sous `files[]`, mais le chargeur courant n’accède qu’à `configurations[]` et lit séparément `font_configuration/locale.cfg`. La recherche du nom de ressource dans les sources Rust du client/serveur/launcher n’a trouvé aucun consommateur runtime direct. L’identité et la copie sont établies ; le consommateur de jeu actuel ne l’est pas. Reprise : identifier un appelant natif 4.20 de `RADS/system/locale.cfg` et un consommateur correspondant dans F avant de relier cette ressource au runtime. Ne pas confondre ce fichier avec le `DATA/CFG/defaults/Locale.cfg` réellement lu par le sélecteur de fontes.

Ces résultats sont des contrôles statiques de fichiers, manifeste et références source ; aucun membre ZIP, refus d’exécution, démarrage client ou rendu n’a été observé. Ils précisent les entrées manquantes sans fermer les inconnues de montage historique, de traduction ni l’objectif SYS-01.2-02.

### Contrôle ciblé — consommateur direct de RADS/system/locale.cfg (2026-11-02)

Critère du lot : établir l’identité de la ressource native et de sa copie active, rechercher son chemin/nom dans le code de production Rust et du launcher, et conclure soit sur un consommateur soit sur son absence, avec une condition de reprise. Le lot clôt uniquement cette vérification statique.

La source D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\system\locale.cfg et la copie F data/4.20/font_configuration/system_locale.cfg ont chacune 12 octets, le texte locale=en_gb et SHA-256 82ecb50f4bf707a35a13a6b6987df89fa6044bedac6fc8aca179890a7890d6ae. Le manifeste courant F:\OpenLeague\data\4.20\native_font_configuration_manifest.json (28 264 octets, SHA-256 1303cee7a84d19c3608bf3f61962e5364e99588457be9e2a3680d57b5d4bc211) a source_system_locale=en_gb et une entrée files[] reliant ces chemins, cette taille et cette empreinte.

La recherche bornée du 2026-11-02 dans les sources *.rs, *.ts, *.js, *.html et *.json de crates/ et launcher/ ne trouve aucune référence à system_locale.cfg ou RADS/system/locale.cfg. Le seul accès Rust à locale.cfg dans ce périmètre est crates/client/src/native_hud_font_configuration.rs:38, qui lit le fichier distinct data/4.20/font_configuration/locale.cfg; les lignes 47–57 lisent configurations[], pas l’entrée du fichier système dans files[]. Résultat attendu pour ce contrôle : un appelant direct identifié ou une absence précisément bornée. Résultat observé : absence de consommateur direct actuel dans le code recherché. Aucun test d’exécution nominal/refus n’est applicable à ce fichier tant qu’aucun consommateur n’est relié.

Divergence de documentation : docs/reference_locale_font_sources/locale-font-links.json enregistre pour cette même copie le chemin absolu historique E:\OpenLeague\data\4.20\font_configuration\system_locale.cfg; le manifeste actif sur F utilise le chemin relatif ci-dessus. Les octets/hachages concordent, mais le chemin du reçu de référence ne décrit pas la racine active F. Le reçu de référence est conservé sans modification.

Clôture : audit statique source/copie et absence de consommateur direct terminés; aucune fonctionnalité, intégration ou équivalence historique n’est déclarée terminée. Restent inconnus l’appelant natif 4.20, la sémantique de locale=en_gb, son rôle éventuel pour les autres consommateurs, et les overlays/montage. Reprise seulement avec un appelant natif 4.20 qui lit ce fichier ou un callsite courant correspondant; pour la divergence de chemin, produire un nouveau reçu de provenance explicitement ancré sur F plutôt que modifier l’ancien reçu. Aucun code, test, build, lancement, goal, suivi, base, installation ou migration n’a été modifié/exécuté.

### Lot AUD-LOCALE-DEFAULTS-ARCHIVE-01 — recherche de defaults.zip

Parent : SYS-01.2-02 / OLU-0ae207ed-8eed-5b18-8086-c348282caeb5. Question limitée : l’archive exacte citée par le manifeste de déploiement existe-t-elle ailleurs dans le corpus client 4.20 fourni que le répertoire RADS déjà vérifié? Résultat attendu : retrouver defaults.zip et contrôler son MD5 déclaré 5b0713441b5e6ee27af56c23a8b625e4, ou constater son absence dans le périmètre cherché.

Preuves réutilisées : les manifestes deploy/files.json et oldFiles.json déclarent DATA/CFG/defaults.zip avec ce MD5 attendu; le fichier loose DATA/CFG/defaults/Locale.cfg est identifié séparément dans le supplément de ce rapport. Leur présence ne prouve pas que l’un provient de l’autre.

Contrôle nouveau du 2026-11-02 : recherche récursive du nom exact defaults.zip sous D:\LeagueOfLegendsV2\4.20, avec rg --files --hidden --no-ignore -g defaults.zip. Le répertoire racine existait; résultat observé : aucune correspondance, code de sortie 1. Cette recherche comprend les fichiers cachés et ignorés sous l’arbre parcouru. rg ne suit pas les cibles de liens symboliques; celles-ci ne sont pas qualifiées.

Critère de clôture du lot : recherche reproductible dans le corpus client fourni, résultat enregistré et condition de reprise. Le lot est clos pour ce périmètre seulement : aucune archive candidate n’a été trouvée, donc aucun hash ni contenu ZIP n’a pu être vérifié. Cela ne prouve pas l’absence de l’archive hors de cet arbre ni la provenance du fichier loose.

Reprise seulement sur une nouvelle entrée : archive reçue ou trouvée hors du corpus courant dont le MD5 correspond exactement, ou manifeste de staging autoritatif liant Locale.cfg loose à son producteur. Ne pas refaire la recherche identique dans D:\LeagueOfLegendsV2\4.20 sans nouvelle piste. La provenance et la priorité historique de Locale.cfg restent ouvertes; aucun comportement runtime n’est validé et aucun code ou registre de tâches n’est modifié.

### Supplement -- membership RADS de `defaults.zip` (2026-11-02)

Perimetre borne: verifier si l'archive `DATA/CFG/defaults.zip` declaree par les manifestes de deploiement est un membre des releases RADS selectionnees; ne pas refaire la recherche de nom dans le corpus D ni extraire une archive sans payload disponible.

Preuve reutilisee: `AUD-LOCALE-DEFAULTS-ARCHIVE-01` conserve la declaration `files.json`/`oldFiles.json` et le MD5 attendu `5b0713441b5e6ee27af56c23a8b625e4`; sa recherche recursive sous `D:\LeagueOfLegendsV2\4.20` n'avait trouve aucun fichier nomme `defaults.zip`. Les identites des deux manifests RLSM sous F ont ete verifiees dans le lot V797 contre les hashes du recu existant, puis les manifests ont ete relus avec le parseur local RLSM.

Attendu: au moins une entree de chemin `defaults.zip` dans le core ou le projet en_GB si l'archive appartient a l'une des releases selectionnees. Observe: zero entree, y compris une recherche insensible a la casse, dans `lol_game_client/0.0.1.7` (70 286 membres) et `lol_game_client_en_gb/0.0.0.235` (563 membres). Le `default Locale.cfg` loose reste lui aussi absent de ces deux manifests, comme deja enregistre.

Conclusion de ce sous-audit: la declaration de l'archive dans les manifestes de deploiement ne la rend pas membre des deux releases de projet selectionnees. Cela n'exclut pas un payload de staging/patcher ou un overlay exterieur au RLSM. Aucun contenu ZIP n'a ete lu; aucun lien runtime ni ordre de provider n'est etabli. `OLU-0ae207ed-8eed-5b18-8086-c348282caeb5` reste ouvert; reprendre seulement sur un payload archive dont le MD5 correspond ou un manifeste/trace de staging autoritatif. Cette cloture porte sur l'appartenance RLSM uniquement, pas sur la provenance ni le consumer historique de `Locale.cfg`.


### V823 — `RADS/system/system.cfg` : portee et consommateur courant

Lot clos pour la relation presente dans le code, pas pour son effet historique. Le registre source conserve `OLS-daf85bfb-e3ba-57d2-a854-e4a20e822e76` : 72 octets, SHA-256 `a99ea26414fbd7deebace37c9e2c109f818a8c394f92607cfa082bd49f35c16a`, fichier fourni `RADS/system/system.cfg`. Le contenu recense indique `Region=EUW`; cette configuration n'identifie pas a elle seule une release active ni le serveur effectivement choisi.

Attendu pour le lien courant : un consommateur Rust/launcher lisant ce fichier, ou une absence bornee. Observe : la recherche de `system.cfg`, `DownloadURL` et `DownloadPath` dans les sources `*.rs`, `*.ts`, `*.tsx`, `*.js`, `*.html` de `crates/` et `launcher/` ne retourne aucune reference. `main.rs:518` construit la racine normale depuis `CARGO_MANIFEST_DIR/../..`; `main.rs:599-600` passe cette racine au catalogue ZIP et au chargement du HUD. Le chemin fourni sous `D:\LeagueOfLegendsV2\...` n'est donc pas selectionne par ce chemin normal de demarrage.

Le lien du registre n'est pas requis par SYS-01.2-02 : il figure comme source de contrat historique uniquement dans SYS-01.1-01 et SYS-01.1-03. L'audit present ferme le recensement du consommateur courant dans le perimetre de code recherche; il ne ferme ni l'audit global SYS-01.2-02, ni une fonctionnalite de configuration/boot.

Reste ouvert : quel bootstrap Riot de la reference 4.20 lit `system.cfg`, comment il choisit le projet/release effectif et quel overlay/config prime au lancement EUW du 17-11-2014. Reprendre ce point seulement avec une trace native de selection de chemin/configuration associee a cette release, ou une preuve de demarrage controlee qui identifie les fichiers effectivement lus. Aucun test, build, lancement, code produit, registre, goal, Plan, application ou base de suivi n'a ete modifie ou execute dans ce lot.
