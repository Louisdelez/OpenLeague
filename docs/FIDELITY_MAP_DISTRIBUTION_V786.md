# SYS-01.2-02 — GLB restauré, vrai pack et chargeur, V786

Projet : F:/OpenLeague. SYS-10.1-02 et SYS-10.1-03 restent non terminées. Les règles de distribution du GLB sont des contrats OpenLeague ; aucune politique native Riot n’est inventée.

## Résultat réel

Le ZIP openleague-assets-04.zip existant en cache est conforme au manifeste :600576905octets, SHA2567369904f9e1bcb5bf9eac8d78ac4cc7f43d9ae2776fbf67a29981da8a2c5d900. Ses3007membres correspondent à la liste et aux tailles du manifeste. La lecture décompressée du GLB a été comparée octet par octet au fichier installé.

GLB sélectionné : assets/maps/twisted_treeline.glb ;222680548octets ; SHA256909513a80e01ae67ee6b15783177a2891363efc640ca47d727f189bcaa429c1a.

Le véritable tools/download_assets.py, inchangé, a ensuite restauré tout le pack dans un dossier neuf isolé sur F. Les3007fichiers extraits, totalisant1251360299octets, ont été vérifiés individuellement par taille et SHA256.

| Cas exécuté | Résultat attendu et observé |
| --- | --- |
| Vrai pack, dossier vide | Les3007membres sont restaurés ; le GLB correspond au manifeste. |
| Deuxième restauration, fichiers identiques | Aucun fichier réécrit ; dates de modification conservées. |
| Ancien GLB réel au même chemin dans le dossier de test | Refus Local file differs sans force ; ancien fichier conservé. |
| Empreinte du GLB volontairement altérée dans une copie du manifeste | Refus Extracted file checksum mismatch ; ancien fichier conservé et temporaire supprimé. |
| Force explicite dans le dossier de test avec le vrai manifeste | GLB actuel restauré ; les3007fichiers sont à nouveau conformes. |

L’ancien fichier utilisé provient de assets/maps/twisted_treeline.before_native_uv.glb. Son identité est enregistrée ; le test ne juge pas visuellement la qualité de ses textures. Le manifeste de production et tous les assets sources sont restés identiques.

## Consommateur client et limite importante

Les liens conservés vers le lecteur du plan et les contrôles SHA du restaurateur sont complétés par trois ancres déjà présentes dans le registre : racine de compilation main.rs:518, dossier AssetPlugin main.rs:653 et chargement Scene(0) main.rs:912. La requête MapHandle main.rs:909 reste liée.

Le restaurateur est un outil optionnel. Son refus d’un ancien GLB ne prouve pas le refus du client au démarrage. Aucun client ni renderer n’a été lancé, aucun binaire reconstruit et aucune nouvelle analyse native REA effectuée. La question du garde-fou de démarrage reste explicitement ouverte.

Le binaire client existant est identifié :168444928octets, SHA256d10c068b691dedf827863c72b752b135a67c5b1da36d85a20d9acc976951a306. Les chaînes de racine F, de chemin GLB et de SHA sont présentes dans ses octets. Cette observation ne démontre ni leurs références d’instructions, ni le chemin effectivement ouvert, ni un contrôle d’intégrité. Le SHA présent pourrait appartenir à des données embarquées ; il ne suffit pas à établir un garde-fou.

Les copies installées sur E et F ont le même SHA. Ce constat ne prouve pas quels octets un client en cours de jeu a chargés. La provenance antérieure GLB→Blender demeure distincte d’un export Blender→jeu, non exécuté ici.

## Registre et conservation

Deux bases contractuelles locales sont ajoutées, les liens existants sont conservés et trois ancres sont réutilisées sans doublon. Les deux questions ouvertes sont précisées : le contrôle du ZIP local et de son extraction ne sont plus présentés comme inconnus ; installation propre, disponibilité distante, garde-fou de démarrage et rendu restent non qualifiés selon la tâche. Les questions précédentes et toutes les recherches sont conservées dans l’historique. Aucun statut d’inconnue ou de tâche n’est clôturé.

Les fichiers temporaires du test ont été supprimés après validation du chemin absolu, des3007noms attendus, de la taille totale et de l’absence de liens de fichiers. Le pack source et les reçus restent présents.1251360299octets logiques temporaires supprimés ; aucun asset du projet supprimé.

## Preuves et modifications

- docs/fidelity_map_distribution_v786.json : associations, contrats, limites et questions précisées.
- revision786_map_pack_runtime/OBSERVATIONS.json : exécution, SHA et observations des5cas.
- revision786_map_pack_runtime/CLEANUP.json : suppression bornée du dossier temporaire.
- revision786_associations/OBSERVATIONS.json : sources, ancres du client et état des questions.
- revision786_delivery/ : deltas réversibles, publication et relecture des deux bases.

Les répertoires revision786_* sont sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. La publication porte sur quatre registres, trois fiches dans les deux bases, les rapports et les documents de couverture/reprise. Code du jeu et assets inchangés ; cases, notes, historiques et prérequis conservés. Les comparaisons visuelles, l’exécution de Blender et les preuves anciennes ne sont pas présentées comme nouvelles.

## Suite

Continuer SYS-01.2-02 sur F. V786 qualifie le pack local et la restauration du GLB, pas le refus au démarrage ni le rendu complet. Garder ouverts ce garde-fou client, l’installation propre, la disponibilité distante et la direction Blender→jeu non prouvée. Prochain lot de sources : vérifier les24références communautaires REF-01..12-AUDIT/ADOPT et leur usage actuel, puis l’identifiant stable SYS-01.2-01. Il reste32exigences sans native_inputs ni base locale explicite :24références,identifiant stable,deuxcombats,cinqBattleTraining. Poursuivre aussi les associations natives/consommateurs partiels du recensement V784, avec REA lorsque nécessaire. Préserver sources, preuves, cases, notes, historiques et inconnues.

## Supplément — garde de démarrage contre l’ancien GLB

Contrôle source actuel du 2026-11-02 pour `SYS-10.1-03` (« Empêcher le chargement silencieux de l’ancien export aux textures corrompues »). Le contrat est local OpenLeague : aucune règle native Riot de vérification de ce GLB n’est revendiquée. Le GLB courant est toujours celui du manifeste (`assets/maps/twisted_treeline.glb`, 222 680 548 octets, SHA-256 `909513a80e01ae67ee6b15783177a2891363efc640ca47d727f189bcaa429c1a`). L’ancien export conservé (`twisted_treeline.before_native_uv.glb`) fait 169 328 064 octets, SHA-256 `a310bcfe34335063043bc36faf1252e92cae1bd67a8e2b8147336d4261c60471`. Le manifeste actuel reste identique à V786 (1 807 879 octets, SHA-256 `b08a8f9ac6709a78878b3fdf99044b9e8ef8fd81e0f7d9928aa706bb736097a2`).

Consommateur relu : `crates/client/src/main.rs`, inchangé depuis V786 (SHA-256 `eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620`). `run_client` résout la racine au parent du crate; `AssetPlugin` pointe directement sur `root/assets`; puis les lignes 909 et 912 demandent `maps/twisted_treeline.glb` et `Scene(0)`. Aucun hash de carte, lecture de `assets-manifest.json` ou branche de refus ne précède cette demande dans le chemin de démarrage inspecté. Les références à `assets-manifest.json` trouvées dans les crates sont dans des tests; le contrôle de hash de `tools/download_assets.py` appartient à l’outil de restauration séparé et n’est pas appelé par le client.

| Dimension | Résultat pour le chemin inspecté |
|---|---|
| Audit | Terminé pour l’état source du consommateur courant : garde de démarrage absente dans le chemin d’initialisation inspecté. |
| Implémentation | Absente : le client charge par chemin sans comparer le GLB au manifeste local. |
| Vérification | Partielle : manifeste, deux GLB et code rehashés; aucune substitution de l’ancien GLB au chemin actif, aucun lancement du client ni test graphique. Un chargement silencieux est donc un risque source établi, pas un échec d’exécution reproduit. |
| Acceptation humaine | Non demandée. |

La fermeture de cet audit de source ne termine pas `SYS-10.1-03` comme fonctionnalité : l’action distincte est un refus explicite avant `Scene(0)` si l’empreinte du GLB actif diffère du manifeste, avec contrôle nominal, GLB ancien, empreinte incorrecte et fichier manquant. Cette action n’est pas implémentée ici; aucune tâche, base, application, installation ou migration n’a été modifiée.
