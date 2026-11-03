# Audit SYS-01.2-02 — conditions natives de la boutique Map10 (2026-11-03)

## Périmètre et critères

Unité AUD-SYS-01.2-02-MAP10-NATIVE-MODE-OBJECT-01, exigence parente SYS-01.2-02. Ce lot complète V1122, V1124 et V1126 : vérifier le résultat de la comparaison de mode et des deux indicateurs d'inclusion, puis vérifier sur deux identifiants la recherche dans l'arbre Map10 en utilisant un constructeur natif partiel au lieu des octets initialisés à la main. Les critères sont un binaire et des outils identifiés, des témoins attendus/observés, des limites explicites et une reprise déterminée. Il ne couvre pas le bootstrap réel, le serveur ou l'achat complet.

## Sources et consommateurs

Binaire original PUBLIC 4.20.0.315 : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe, SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Le chemin du binaire est vérifié et ses octets comparés au SHA du harnais. Le fichier Map10 Items.inibin fourni à la seconde expérience a pour SHA-256 2e0e874e036429fee1bda6c5d1942f8e217eda7468b6b5bea5eac0a4288456f7. V1124 a identifié dans Constants.var les indicateurs it_UseExplicitItemInclusion et it_UseExplicitItemInclusionTutorialOnly, tous deux à zéro dans ce fichier ; V1126 a testé séparément sa lecture et la construction de liste avec comparaison de mode fournie.

Le consommateur examiné est le client natif lui-même, dans Unicorn, non une exécution du jeu complet. Le setter 0x5B2590, le getter 0x5B26E0, le comparateur et la branche 0x5B663B–0x5B6689 sont exercés avec objet, chaînes et flags fournis. Le second contrôle réutilise le harnais V1122 pour construire l'arbre natif de 95 IDs à partir de l'INIBIN puis exécute le constructeur 0x5B9820 et la recherche 0x5B6EEC–0x5B6F21. Le mode, la racine, la locale, le provider, les sentinelles et une allocation de 24 octets sont fournis par les harnais ; allocation, accès fichiers, CRT, formatage, affectation de chaîne et diagnostic sont adaptés.

## Résultats attendus et observés

- Branche : 20/20 combinaisons passent : modes CLASSIC, TUTORIAL, tutorial, ODIN et NOT_A_MODE, croisés avec les quatre états 0/1 des deux flags. Le résultat observé vaut 1 si le flag d'inclusion est à 1 ou si le flag tutorial-only est à 1 et la chaîne de mode vaut TUTORIAL sans distinction de casse ; sinon 0. Les classes renvoyées pour les modes fournis sont respectivement 0, 2, 2, 1 et 0xffffffff. Ce constat est borné aux valeurs testées et aux objets construits pour l'essai.
- Recherche : après allocation fournie, le constructeur natif partiel initialise les octets +0C/+0D à 00/01 dans les deux cas et renvoie l'adresse de l'objet. Pour l'ID 1062 présent dans l'arbre, +0D devient 0 ; pour l'ID 1039 absent, il reste 1. Attendu et observé concordent. Les fonctions instrumentées du constructeur et de la recherche ont été visitées. La construction complète 0x5B6D80 n'est pas exécutée.

## Contrôles et preuves

- Depuis E:/mapslol3v3/map10_native_mode_branch_probe_2026_11_03 : `$env:PYTHONDONTWRITEBYTECODE='1'; python .\probe.py | Out-File -FilePath .\result.json -Encoding utf8` ; Python système 3.10.11, code 0, 20 cas réussis. Script SHA-256 4be26907db99f001113d564c138c3fe98bcbfde2a661975230e6fb973dad2e1c ; résultat SHA-256 c74ead4872dc32fedec27feb8f073bed4994e317b4d522eda8b334dc8675a133. Relecture indépendante : les six fichiers épinglés concordent avec leurs SHA et les 20 cas sont indiqués réussis.
- Depuis E:/mapslol3v3/map10_native_constructor_audit : `F:\OpenLeague\.ai-tools\.venv\Scripts\python.exe -B .\probe.py` avec sortie enregistrée dans resultats.json ; Python 3.12.14, code 0, deux cas réussis. Script SHA-256 bf926c0557aff704e8394adfa76256031f56bbbc035f8b02b7c479acc83a8f93 ; résultat SHA-256 764bcd2e03d97114de9dcbc8681db1a15adb076a804f76d731f6ab053b353230. Le script vérifie la présence unique de son point de coupure avant d'exécuter en mémoire la préparation V1122, sans rejouer ses 245 recherches ; les empreintes de cette préparation et des sources figurent dans le résultat.

## Écarts, limites et reprise

La comparaison native a été testée au lieu de supposer son résultat, et le comportement présent/absent a été relié à un objet construit par une fonction native partielle. Ces essais n'établissent pas le mode réellement transmis à Map10, le fournisseur de fichiers, la configuration finale après surcharge, le chemin de construction complet, une décision d'achat serveur ni une interface effective. Les entrées permettant de reprendre sont une trace ou des artefacts attribuables du bootstrap/mode et des paramètres finaux historiques, ou une nouvelle piste concrète vers le provider ; pour la décision d'achat, il faut aussi une preuve de l'autorité serveur. Ne pas répéter ces tables sans nouvelle entrée ou anomalie.

Réutiliser les travaux SYS-07.1/07.2 et ITEM-<ID>-SCOPE/SHOP pour qualifier ces points ; aucune tâche ni aucun registre n'est modifié. Le présent audit limité est terminé ; l'implémentation, la vérification d'une partie et l'acceptation humaine restent ouvertes. Le goal parent reste actif et partiel. Aucune modification de l'application, du goal ou de leurs bases.
