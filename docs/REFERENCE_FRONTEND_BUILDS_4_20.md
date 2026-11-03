# SYS-01.1-02 — Builds du patcher et du client AIR

Date du relevé : 20 octobre 2026. Référence : client de partie PUBLIC 4.20.0.315, EUW / en_GB, définie dans [reference_client_4_20.json](reference_client_4_20.json).

## Résultat identifié

| Composant | Build interne | Release RADS | Preuve directe |
|---|---|---|---|
| Patcher `LoLPatcher.exe` | **0.4.0.122** (FileVersion et ProductVersion) | **0.0.0.11** | Ressource Windows VS_FIXEDFILEINFO du binaire fourni |
| Client AIR / PvP.net | **4.20.14_11_18_18_52** | **0.0.1.119** | Champ statique `Version.CURRENT_VERSION` de `lib/ClientLibCommon.dat` ; journaux natifs d’installation |
| Configuration AIR EUW | Sans numéro de build d’application déduit | **0.0.0.50** | Blocs `lol_air_client_config_euw` des mêmes journaux |

Le build du patcher n’est pas son numéro de release RADS. Le build AIR n’est ni le build du jeu 4.20.0.315 ni le catalogue Data Dragon 4.20.1.

## Provenance et association à la référence

Le patcher et son manifeste proviennent de `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20`. Le binaire a été lu par les API de ressource VERSIONINFO de Windows ; il n’a pas été exécuté.

Les journaux `Logs/Patcher Logs/2014-11-21T16-29-18_LoLPatcher.log` et `2014-11-22T18-38-24_LoLPatcher.log` identifient EUW, recensent le projet exact `lol_air_client`, son candidat 0.0.1.119 / 0x177, puis « Found OK-file, candidate is valid » et « Succeeded ». Ils chargent aussi `lol_game_client_sln/releases/0.0.1.68/configurationmanifest`, la solution du binaire 4.20.0.315 vérifié séparément. Le second journal corrobore le premier ; les dates de leurs noms ne sont pas transformées en dates de déploiement.

La copie native D: et l’archive locale 4.20 ne contiennent actuellement aucun projet AIR. La recherche dans l’archive `D:/LeagueOfLegendsV2/LoLversion/4.20/League_of_Legends_UNPACKED.7z` a listé 75 946 entrées sans chemin `lol_air_client`/`LolClient` ; aucun contenu n’a été extrait ou remplacé. Reçu : `E:/mapslol3v3/Build_identity_4_20_2026-10-20/archive-list.txt`.

La bibliothèque AIR avait déjà été récupérée dans `E:\mapslol3v3\output\Launcher_420_Research\air_119` depuis le Riot Archive Project. Son enregistrement exact est `live/projects/lol_air_client/releases/0.0.1.119/files/lib/ClientLibCommon.dat`, fileId **6EDA619E530BCBA3**. Cet enregistrement est recoupé entre l’index original (ligne 585796 de `air_index.jsonl`), la fusion des ressources et l’inventaire haché. SHA-256 de la bibliothèque : **f5915bfc68556608cb6aba924b9773862c09dd9e52414dc488aa01621efee638**.

Le lecteur décompresse ce SWF CWS v20, contrôle ses longueurs, trouve le tag DoABC nommé `com/riotgames/platform/gameclient/application/Version`, puis lit le trait statique `CURRENT_VERSION` et son index de chaîne UTF-8. La valeur est **4.20.14_11_18_18_52**. Ce champ est un `trait_slot` statique, pas une constante `trait_const` ; une première hypothèse de parseur a été corrigée avant l’intégration. Il ne s’agit pas d’une recherche de chaîne isolée dans un fichier quelconque.

## Versions héritées écartées

- `META-INF/AIR/application.xml` indique `versionNumber=1.0.0` dans le candidat provenant de 0.0.1.76 ; son namespace `/application/3.7` décrit ce candidat ancien. Son contenu diffère de celui attendu par le manifeste exact 0.0.1.119 : il n’est pas qualifié comme descripteur AIR 4.20. Aucun de ces nombres ne donne le build PvP.net ni la version vérifiée du runtime installé.
- `version.txt` contient `v[Mon 10/03/2011 18:36:35.70]`, provenant de 0.0.0.85 dans l’union d’archives ; ce chemin est absent du manifeste exact 0.0.1.119 et ne date pas AIR 4.20.
- Le dernier dossier, les mtimes, les dates 2023 de conversion d’archive et un nombre pris dans un autre projet ne constituent pas une identité de build.

## Contrat et consommateur réel

[reference_frontend_builds_4_20.json](reference_frontend_builds_4_20.json) fixe les identités, les dix sources et leurs empreintes, les racines locales et les limites. `tools/project-plan/frontend_builds.py` reproduit les lectures et refuse les sources divergentes, l’absence de validation d’installation et les confusions de version.

Le contexte de **la seule tâche SYS-01.1-02** dans `completion_tasks_2026-10-20.json` consomme ces identités, leurs chemins et l’empreinte du contrat. Le générateur existant `make_instruction` affiche ce contexte dans la consigne complète, et le catalogue SQLite partagé par le site et l’application Tauri reçoit cette consigne. Le moteur et le launcher de jeu n’ont pas besoin d’une modification pour identifier leurs références historiques.

## Contrôles attendus et observés

| Contrôle | Attendu | Observé |
|---|---|---|
| VERSIONINFO du patcher | Deux versions cohérentes | FileVersion = ProductVersion = 0.4.0.122 |
| AIR dans le projet exact des deux journaux | Candidat 0x177 validé, EUW, même solution du jeu | Release 0.0.1.119, configuration EUW 0.0.0.50 |
| Valeur du champ statique dans l’ABC de Version | Build interne lisible et lié au champ | 4.20.14_11_18_18_52 |
| Provenance de la bibliothèque | Ressource exacte de la release 119 | Index et inventaire concordants, taille et SHA vérifiés |
| Source manquante, modifiée, autre build ou mauvais projet | Refus explicite | Tests ciblés ; résultats détaillés dans le reçu de vérification |
| Suivi manuel | Aucune coche, note ou révision modifiée | Comparaison de tous les états avant/après dans le reçu d’intégration |

Commandes depuis E:/OpenLeague :

```powershell
python -B tools/project-plan/frontend_builds.py --root E:/OpenLeague
python -B -m unittest discover -s tools/project-plan -p test_frontend_builds.py -v
```

Les résultats réellement exécutés, fichiers et empreintes finales sont dans `reference_frontend_builds_4_20_verification.json` et `E:/mapslol3v3/Build_identity_4_20_2026-10-20/`. Aucun test du jeu ni aucune exécution du patcher, d’AIR ou du client historique n’est revendiqué. Les tests de référence antérieurs restent distincts.

## Limites ouvertes

L’exécution d’un client AIR complet, la version de son chargeur PE/du runtime sur la copie native, son rendu et ses services ne sont pas qualifiés par cette identification. Aucun fuseau n’est attribué au suffixe du build AIR et aucune date de déploiement EUW n’en est déduite. Les URL officielles anciennes des manifestes et du descripteur n’étaient pas accessibles via l’outil web ; cela ne prouve pas leur inexistence et elles ne servent pas de preuve de contenu. L’archive de ressources conservées est corroborée par les journaux locaux et sa provenance est explicitement distincte de l’installation D:.

La tâche reste **à valider par l’utilisateur**, sa case est préservée. Identifier ces deux builds ne termine ni la fiche D01 ni le jeu.

## Revalidation de SYS-01.1-02 — manifeste exact du 20 octobre 2026

Les identités ci-dessus sont relues dans les mêmes octets originaux. Une vérification complémentaire remplace toute supposition d’appartenance fondée sur l’union `air_119_merged.json` par le manifeste exact de la release.

Le fichier [air_0.0.1.119.releasemanifest](reference_frontend_sources/air_0.0.1.119.releasemanifest), projet `lol_air_client`, release **0.0.1.119**, contient **7 886 membres**. Il provient de `live/projects/lol_air_client/releases/0.0.1.119/releasemanifest`, fileId `660E32FCFEB94BB0`, index original ligne 586184 ; ses 447 012 octets ont le SHA-256 `df8c52f34537e9c0d13a6ba1d88f089afa4067a4b5a6b87668e64edf08036463`. Le [reçu de récupération conservé](reference_frontend_sources/air_0.0.1.119.provenance.json) détaille cette provenance. Aucun nouveau téléchargement ni exécution historique n’est nécessaire à cette relecture.

| Ressource | Attendu dans le manifeste | Observé / décision |
|---|---|---|
| `LoLPatcher.exe` | Projet lol_patcher, release et membre 0.0.0.11, 4 247 544 octets, MD5 ace2737187b05155ed3aa317d5c307f1 | Octets conformes ; VERSIONINFO = 0.4.0.122 |
| `lib/ClientLibCommon.dat` | Projet lol_air_client, release et membre 0.0.1.119, 78 498 octets, MD5 18e2488befd98ec98ab3a2fa459e2178 | Octets conformes ; champ statique CURRENT_VERSION = 4.20.14_11_18_18_52 |
| `META-INF/AIR/application.xml` récupéré dans l’union | Manifeste 119 : membre hérité de 0.0.1.67, 927 octets, MD5 332b2a5cb3619cab02c8682a847e0ee9 | Candidat local de 0.0.1.76 : MD5 a28037fc7d3fdc4a090d8dc981179d18 ; divergent et exclu comme descripteur 4.20 |
| `version.txt` récupéré dans l’union | Chemin absent du manifeste 119 | Candidat de 2011 conservé comme preuve négative ; exclu de la release 119 |

Le membre exact du descripteur 0.0.1.67 n’a pas été récupéré ici. Son `versionNumber`, son namespace et le runtime installé restent non établis pour AIR 4.20. Cela ne bloque pas l’identification du build, directement lié à la bibliothèque conforme au manifeste. L’affirmation antérieure d’un « descripteur hérité » ne doit donc pas être lue comme une appartenance validée de ce candidat à la release 119.

Contrôles supplémentaires : projet et release du manifeste incorrects, membre absent, autre release de membre, bibliothèque altérée, manifeste tronqué, promotion erronée d’un candidat d’archive et faux nom du champ de build sont refusés explicitement. Les tests utilisent les sources réelles et des mutations contrôlées en temporaire ; aucun programme historique n’est lancé. Les **17 contrôles antérieurs sont conservés et 14 contrôles de manifeste/liaison sont ajoutés**.

Commandes maintenues :

```powershell
python -B tools/project-plan/frontend_builds.py --root E:/OpenLeague
python -B -m unittest discover -s tools/project-plan -p 'test_frontend*.py' -v
```

Preuve de cette reprise : [reference_frontend_builds_4_20_revalidation.json](reference_frontend_builds_4_20_revalidation.json) et `E:/mapslol3v3/Build_identity_revalidation_4_20_2026-10-20/`. Le reçu précédent reste conservé dans `reference_frontend_builds_4_20_verification.json` ; les anciennes recherches et preuves ne sont pas remplacées. Seule SYS-01.1-02 reçoit ce complément dans le catalogue ; les cases, notes, révisions et acceptations utilisateur sont préservées.


## Reprise ciblée — preuves courantes du 20 octobre 2026

**SYS-01.1-02 est réalisée techniquement et reste à valider par l’utilisateur.** Le contrôle maintenu et les **31 tests ciblés** ont été réexécutés avec succès. Les dix sources de builds et les cinq sources de la référence du jeu sont conformes. Les entrées nécessaires existent ; la tâche, la fiche D01-SYS-01-1 et la phase D01 n’ont aucune dépendance déclarée.

| Objectif | Résultat attendu et observé |
|---|---|
| Patcher | FileVersion et ProductVersion **0.4.0.122** ; membre `LoLPatcher.exe` conforme au manifeste `lol_patcher` **0.0.0.11** |
| AIR/PvP.net | Champ statique `com.riotgames.platform.gameclient.application.Version.CURRENT_VERSION` = **4.20.14_11_18_18_52** ; bibliothèque conforme au manifeste `lol_air_client` **0.0.1.119** |
| Région | Deux journaux locaux : configuration `lol_air_client_config_euw` **0.0.0.50**, EUW, même solution du jeu0.0.1.68 ; localeen_GB vérifiée séparément dans la référence du client |
| Refus pertinents | Source absente ou altérée, autre build/projet/release, champ ABC incorrect, candidat non validé ou ambigu, manifeste tronqué, mauvais membre, chemins hors racine : refus explicites dans les31 tests |

**Actualisation d’une ancienne inconnue :** le membre exact `META-INF/AIR/application.xml`, hérité de **0.0.1.67** par le manifeste119, a depuis été récupéré pour SYS-01.1-05. Sa copie conservée dans `docs/reference_air_sources/original/` est relue ici et conforme :927octets, MD5`332b2a5cb3619cab02c8682a847e0ee9`, SHA-256`9eae11aee5feb06196abe74178f87cbed5915ea2b5425792645368babe1e9ab6`, `versionNumber=1.0.0`, namespaceAIR3.7. Le candidat différent provenant de0.0.1.76 reste exclu. Les passages précédents relatifs au descripteur non récupéré décrivent donc l’état de cette ancienne preuve ; ils ne représentent plus une inconnue actuelle. Le contrat de builds et tous les reçus antérieurs restent inchangés.

Le résultat est intégré au **consommateur existant** : contexte de cette seule tâche dans le registre, consigne générée par `tools/project-plan/instructions.py`, catalogueSQLite partagé par le site local et l’applicationTauri. Aucun code du moteur ou du launcher n’a besoin d’être changé pour cette identification. Les deux builds sont déterminés sans lancer un programme historique ; la lecture de VERSIONINFO n’exécute pas le patcher.

Restent ouverts : version réellement installée du runtime/chargeurAIR, exécution et rendu d’un clientAIR complet, fuseaux et date de déploiementEUW. La date littérale du build du jeu reste2014-11-17/17:46:45, sans fuseau établi. Le catalogue4.20.1 reste distinct des builds. Aucune ressource n’est reconstruite et aucune disponibilité des services Riot n’est déduite.

Preuve courante, commandes exactes, identités des outils, résultats attendus/observés et contrôles du consommateur : [reference_frontend_builds_4_20_review.json](reference_frontend_builds_4_20_review.json). Journaux et sauvegarde : `E:/mapslol3v3/Build_identity_review_4_20_2026-10-20/`. La compilation et les tests du jeu ne sont pas concernés par ce changement documentaire. Les14 tests du plan de la reprise précédente ne sont pas revendiqués comme réexécutés ici. Aucune case, note, révision ni acceptation utilisateur n’est modifiée.


## Confirmation ciblée de SYS-01.1-02 — 20 octobre 2026

Les builds sont de nouveau vérifiés dans les sources : patcher **0.4.0.122**, release RADS **0.0.0.11** ; AIR/PvP.net **4.20.14_11_18_18_52**, release **0.0.1.119**, configuration EUW **0.0.0.50**. Les **31 tests ciblés** et la CLI maintenue passent ; dix sources de builds et cinq sources du client sont relues. Les numéros de build restent distincts des releases, du descripteur et du runtime. Le membre exact du descripteur67 conservé par SYS05 est revérifié sur le manifeste119 ; le candidat76 divergent et version.txt de2011 restent exclus.

La consigne enregistrée était antérieure au générateur courant. Seule la ligne SYS-01.1-02 est actualisée avec le générateur installé et la nouvelle preuve, sans réimporter les autres tâches. Les états manuels, notes, révisions, historique et anciennes preuves sont conservés. Cette tâche reste a_valider ; aucune acceptation humaine n’est déduite de sa case existante. Les mises à jour du registre des exigences en cours ailleurs dans le dépôt sont préservées et ne sont pas qualifiées par cette confirmation.

Preuve : [reference_frontend_builds_4_20_confirmation.json](reference_frontend_builds_4_20_confirmation.json). Runtime/chargeur AIR effectivement installé, rendu/exécution historiques, fuseaux et date de déploiement EUW restent ouverts. Aucun logiciel historique, build/test du jeu ni reconstruction de ressource n’est exécuté.


## Vérification de la demande SYS-01.1-02 — 20 octobre 2026

Résultat revérifié : **patcher 0.4.0.122**, release RADS **0.0.0.11** ; **AIR/PvP.net 4.20.14_11_18_18_52**, release RADS **0.0.1.119**, configuration EUW **0.0.0.50**. La VERSIONINFO du PE et le champ statique `Version.CURRENT_VERSION` de la bibliothèque originale sont liés aux manifestes exacts par chemin, release, taille et MD5, avec SHA-256 des sources. Les **31 tests nominaux et de refus** et la CLI maintenue passent lors de cette vérification ; 10 sources de builds et 5 sources de la référence du client sont relues.

Le descripteur exact source67 conservé par SYS05 correspond au manifeste119 ; son versionNumber1.0.0 et son schéma AIR3.7 restent distincts du build et du runtime installé. Le candidat76 divergent et version.txt2011 absent du manifeste restent exclus. Runtime/chargeur installé, fuseaux et date de déploiement EUW restent inconnus. Les recherches et conditions de clôture sont dans le reçu.

Le registre, la consigne enregistrée et ses API de lecture/copie sont vérifiés pour cette seule tâche ; la configuration Tauri utilise la même base. Toutes les cases, notes, révisions et leur historique sont conservés. Statut `a_valider`, acceptation humaine non donnée. Aucun programme historique, code/build/test du jeu ni autre tâche ou Goal n’est exécuté ou clôturé par cette demande.

Preuve : [reference_frontend_builds_4_20_requested_verification.json](reference_frontend_builds_4_20_requested_verification.json). Les preuves antérieures restent inchangées.
