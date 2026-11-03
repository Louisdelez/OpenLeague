# Audit SYS-01.2-02 — Veigar : identité du rig et sélection cliente (2026-11-03)

## Périmètre

Unité AUD-SYS-01.2-02-VEIGAR-RIG-CONSUMER-01 ; parent SYS-01.2-02, exigences CH-Veigar-MODELE-RIG et SYS-14.2-02, inconnue existante OLU-29dbb803-7d62-54e9-a39e-acfedede9e66. Question : les sources du constat V527 sont-elles toujours les mêmes et quel modèle le code client courant sélectionne-t-il pour Veigar ? Les critères sont l'identité des trois fichiers, le chemin de sélection actuel, une lecture structurelle du skin GLB et une distinction explicite entre observation, preuve antérieure et limites. Ce lot ne modifie pas le modèle et ne valide ni rendu ni animation.

## Sources, acquis et identité

Le reçu `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision527_rig_discovery_identity/DISCOVERY.json`, SHA-256 5d50b847c46a9027f27301b4dada3e7a04d6b50354474153fefb19a41a88109f, contient une ligne Veigar ; V527 et V109 relient le squelette, le maillage, leurs identités et les influences positives. Ses conclusions sont historiques, sans exécution nouvelle du client ou des poses.

Les tailles et SHA-256 des trois entrées actuelles concordent avec le reçu : SKL natif `DATA/Characters/Veigar/Skins/Base/Veigar.skl`, 4 560 octets, a3a9789f67ffca59d3cad2df31bddeb86e837539c46e7ad32930221cbfe36b4c ; SKN natif `Veigar.skn`, 97 480 octets, 101fb05bba7a97cbc6fa5537c64395b9f71f42310bbab73986bed7645d1bf5e1 ; modèle `F:/OpenLeague/assets/champions/veigar.glb`, 3 190 312 octets, 2247ec3b9fe9117b26db46d7fd3f2ac4d7af71870b0b8fea0a0c4590e11b38ec. Les fichiers natifs proviennent de la référence fournie 4.20.0.315 ; V527 documente leur appartenance aux manifestes. Ce contrôle n'établit pas l'ordre historique effectif des providers et surcharges.

## Consommateur actuel et résultat

`crates/client/src/animation.rs::Catalog::default` assemble les manifestes champion et monde ; l'entrée champion `veigar` ne contient pas d'asset et le manifeste monde ne la remplace pas. `animation::request` choisit alors le chemin de repli `champions/veigar.glb` et le transmet à `assets.load`. Dans `crates/client/src/main.rs`, l'appel est effectué pour un champion présent dans le snapshot lorsqu'aucun visuel n'est encore enregistré. Il s'agit d'une lecture du code et des manifestes courants, non d'une observation d'un exécutable ou pack en cours d'utilisation.

Le lecteur borné de la partie JSON de ce GLB vérifie magic/version/longueur, hiérarchie sans cycle ou parents multiples et skin 0 : 49 joints, aucun chemin `root/pevis/R_thigh/R_calf/R_foot/toe` dans ce skin ; le chemin homologue gauche existe au slot 30. V527 rapportait 50 joints natifs, le joint droit 34 absent et 33 influences positives dirigées vers l'autre branche. Comme SKL, SKN et GLB ont les mêmes empreintes, ce constat reste applicable aux mêmes octets ; les 33 influences et le squelette natif ne sont pas redécodés dans ce lot. Le nom `pevis` est conservé tel que dans les données.

## Contrôle exécuté et preuves

`F:\OpenLeague\.ai-tools\.venv\Scripts\python.exe -B E:\mapslol3v3\audit_veigar_rig_runtime_20261103\probe.py`, sortie conservée dans `resultats.json` : code 0. Le script recontrôle les trois identités, vérifie la sélection statique et lit la structure du skin choisi ; il ne construit ni ne lance l'application. `probe.py` SHA-256 61cc5db779a0c91dfbc2da403517676e4e41f7968b05d5840d0472246ff83414 ; `resultats.json` SHA-256 a274e2c6edeb5919af57361501e59be7f365d9c08220df6a735db45a3dd44660. Le résultat épingle aussi les deux manifestes et les fichiers client lus.

Attendu : retrouver les trois octets V527, le chemin sélectionné et la branche droite dans le skin si elle avait été restaurée. Observé : mêmes entrées, chemin de repli attendu et branche droite absente du skin 0. Ce test n'inspecte pas de pose animée, de vertex ou d'image GPU ; l'impact visuel exact reste inconnu.

## Écart et reprise

La réparation et qualification restent rattachées à CH-Veigar-MODELE-RIG, SYS-14.2-02 et OLU-29dbb803-7d62-54e9-a39e-acfedede9e66. Pour reprendre lorsque la correction d'asset est autorisée : restaurer l'identité de la branche droite et les destinations des 33 influences à partir des sources qualifiées ; comparer à nouveau hiérarchie, bind et poids/destinations, puis vérifier des poses et le rendu du modèle effectivement chargé. Les skins, formes et providers restent à qualifier séparément. Ne pas recréer une texture ou réexporter tout le corpus sur la seule base de ce défaut. Si le fichier ou le chemin de sélection change, requalifier ses nouvelles empreintes avant de réutiliser V527.

Audit de cette liaison bornée terminé ; correction du modèle, vérification en jeu et acceptation humaine restent ouvertes. Aucun changement de goal, d'application de suivi, de base, de registre ou d'asset produit.
