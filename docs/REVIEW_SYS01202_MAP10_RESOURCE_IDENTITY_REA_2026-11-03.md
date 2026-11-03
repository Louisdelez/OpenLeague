# Relecture indépendante V1151 — REA, identités géométrie et shaders Map10

## Verdict borné

La relecture indépendante accepte le lot REA uniquement pour les sept fonctions et les trois recherches de références demandées. Le validateur producteur repasse **34/34** et la matrice indépendante passe **11/11**.

Le verdict exact est `pass_for_targeted_static_function_and_xref_evidence_only`. Il ne promeut aucun runtime, aucune fonctionnalité produit, aucune compilation ou liaison shader historique, aucun draw, aucun `Present` et aucun pixel.

## Contrôles indépendants

Le PE original a été reparsé sans utiliser les résultats REA comme source d’octets :

- taille `15 973 880` octets ;
- SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ;
- PE32 x86, base image `0x400000`.

Les sept dossiers REA résolvent exactement les entrées demandées, avec corps disponibles et assemblage non vide :

- géométrie : `0x9596D0`, `0x9C2880` ;
- shaders : `0x98C070`, `0x98D960`, `0x9AEE30`, `0x9C22E0`, `0x9BEF40`.

Les sept réponses utilisent le même profil : Ghidra `12.1.4`, digest `b9d116ea480a02cc8773b19372074a3caf77785cbc080b1ac7133b5110e40b17`.

Seize instructions critiques ont été relues directement dans le PE puis redésassemblées avec Capstone. Elles concordent avec REA :

- sortie `context+0x04` et appel backend `+0x54` à `0x95974F/0x959790` ;
- frontière de création de déclaration à `0x9C2A68` ;
- appels compilateur, factories et publication `record+4` pixel/vertex à `0x98C2AA..0x98C2B9` et `0x98DB9A..0x98DBA9` ;
- création et stockage de paire à `0x9AEE85/0x9AEEA0/0x9AEEA3` ;
- résolution puis liaison à `0x9C233B/0x9C2372` ;
- slots D3D9 `+0x170/+0x1AC` à `0x9BEF56/0x9BEF6B`.

Les trois recherches de références contiennent les appelants exigés : `0x96097C`, `0x95A071` et `0x95A24E`.

Le reçu final contient 14 appels sans `isError`, le bundle conserve 10 preuves et le snapshot 7 entrées primitives/10 preuves. Le journal serveur REA retenu contient 12 statuts `ok`.

## Diagnostic Ghidra global

Trois erreurs d’auto-analyse globale avaient été observées avant fermeture aux adresses `0x79614D`, `0x72614D` et `0x746153`. Aucune n’appartient aux plages de corps des sept fonctions ciblées. Chaque fonction et chaque xref demandés a produit une réponse complète sans erreur ; ces diagnostics ne renversent donc pas le verdict borné.

Limite de preuve importante : le `ghidra.log` brut appartenait au projet éphémère et a été supprimé par `close_binary`. Il n’a pas été archivé dans le bundle. Les trois adresses ci-dessus restent donc une observation de tour de moindre autorité, pas un reçu brut rehashable. Une future session qui souhaite qualifier les diagnostics globaux devra copier ce journal avant la fermeture. Cette lacune n’affecte pas les octets des fonctions ciblées, recroisés indépendamment.

## Historique du validateur de revue

La première exécution de la revue a donné 10/11 : REA écrit certains petits déplacements en hexadécimal (`0x4`) et certains appels avec des zéros initiaux (`0x009C5B20`), tandis que Capstone rend `4` et `0x9C5B20`. La comparaison textuelle stricte a donc refusé des instructions pourtant identiques.

La revue a été corrigée pour normaliser uniquement la représentation numérique avant comparaison. Les octets, mnémoniques, opérandes et cibles n’ont pas changé. La seconde exécution passe 11/11. Le premier refus concernait l’outil de revue, pas la source.

## Limites conservées

- Le pseudocode et les signatures inférées par Ghidra ne sont pas utilisés comme autorité.
- La jonction historique d’un selector réellement produit avec une paire VB/IB dans un même batch Map10 reste ouverte.
- La compilation, publication et liaison historiques des objets shaders restent ouvertes.
- Aucun `DrawIndexedPrimitive`, `Present`, readback ou pixel n’est qualifié.
- SYS-01.2-02, le moteur et le jeu complet restent ouverts.

## Commandes réellement exécutées

```text
python E:\mapslol3v3\audit_map10_rea_resource_identity_20261103\validate_rea_resource_identity.py
python -m py_compile E:\mapslol3v3\audit_map10_v1151_rea_review_20261103\review_rea_resource_identity.py
python E:\mapslol3v3\audit_map10_v1151_rea_review_20261103\review_rea_resource_identity.py
```

Résultats finaux : producteur 34/34 ; revue indépendante 11/11.

## Livrables

- `review_rea_resource_identity.py` — SHA-256 `d561d946f24e8a32ed80160f35b0a45cab51d1cdf186b561d0851ade8127be84` ;
- `rea_independent_review_matrix.json` — SHA-256 `498990a38f5a044f87926f374667202bc6cf40ca5ce5f1277f9588132997d405` ;
- bundle REA relu — SHA-256 `ae9e6ad3f0723f9e4293db34c171d0f659dd4100efb448178004cfcd523e582a` ;
- snapshot REA relu — SHA-256 `081306333aa6ca284ebfa93da8918ae59106247c193ca8f15ce900f1300ca4d8`.

Seul le répertoire de preuve sous `E:\mapslol3v3` a été ajouté. Aucun fichier `F:` ou `D:`, produit, Goal, Plan, interface, base ou registre n’a été modifié ; aucune nouvelle session REA n’a été lancée par cette revue.
