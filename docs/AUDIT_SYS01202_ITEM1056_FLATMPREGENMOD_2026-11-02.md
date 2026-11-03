# AUD-SYS-01.2-02 — Objet 1056, FlatMPRegenMod

Lot d’audit : AUD-SYS-01.2-02-ITEM1056-MANAREGEN-LINK-01

Date de contrôle : 2026-11-02  
Tâche : ITEM-1056-SERVER-STAT-FlatMPRegenMod  
Requirement ID : OLF-1cb6b8fd-f5e0-5288-9c07-b6eb6b059f41  
Consommateur associé dans la trace : OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b

## Résultat borné

L’audit du lien vers le code est clos avec un écart de source précis : le catalogue officiel 4.20.1 donne FlatMPRegenMod=0.6 pour Doran’s Ring, mais l’export natif 1056 déjà enregistré dans native_item_audit.json ne fournit pas cette clé. Cet export ne prouve pas que la clé est absente du binaire brut; l’existence et le décodage natifs de cette valeur restent donc inconnus.

Le consommateur courant ne représente pas de régénération de mana plate : Bonuses possède mana_regen_percent seulement, et le calcul de tooltip applique un multiplicateur au taux de base. De plus, l’objet 1056 est absent du catalogue et son achat est refusé comme objet non implémenté. La fonctionnalité n’est pas terminée; la tâche conserve son statut a_faire.

## Contrat et applicabilité

Le registre demande d’appliquer FlatMPRegenMod à l’objet 1056 et précise que la fonctionnalité est requise si l’objet est historiquement disponible dans le périmètre 4.20 retenu. Le membership du fichier DATA/Items/1056.inibin dans le manifeste lol_game_client retenu est déjà vérifié et documenté dans le lot AUD-SYS-01.2-02-ITEM1056-HEALTH-LINK-01. La condition d’applicabilité est satisfaite, mais la valeur native de ce champ n’est pas encore qualifiée.

Le registre garde required=false avec required_if conditionnel, status=a_faire, implementation_complete=false et acceptance_complete=false. La trace de fidélité associe la même source native, l’entrée officielle /data/1056, l’absence de items.id=1056 dans le catalogue courant et le consommateur OLC ci-dessus. Aucune de ces valeurs de suivi n’a été changée.

## Sources et consommateur courant

| Élément | Résultat |
|---|---|
| Référence client | docs/reference_client_4_20.json : 4.20.0.315, EUW, en_GB. |
| Source native réutilisée | DATA/Items/1056.inibin, OLS-04ec5370-8428-5c53-925a-41f5fb787829. Le lot santé précédent a rehaché le fichier D, SHA-256 861cf0f8d1d7fb17098cfd76ea28991eb82467ab3361b4322c0124a43174b12c, et confirmé le membership du manifeste lol_game_client release 0.0.1.68. Aucun nouveau rehash n’a été fait. |
| Export natif existant | data/4.20/native_item_audit.json, SHA-256 8490946392b459466ddc396ff681107ca4043406fd2780f41d63bd97c5d25e03. L’objet 1056 y énumère notamment FlatHPPoolMod=60 et FlatMPPoolMod=0, mais pas FlatMPRegenMod. L’étendue et les limites du décodeur ne sont pas documentées par cet artefact. |
| Catalogue officiel | OLS-b3343643-2fe6-513b-b286-7c03b86b8409, Data Dragon 4.20.1 en_US, SHA-256 676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1. La ligne /data/1056 donne Doran’s Ring avec FlatMPRegenMod=0.6. Ce catalogue ne démontre pas à lui seul la valeur effective du binaire serveur/client EUW 4.20.0.315. |
| Catalogue jouable courant | shop_foundation.json ne contient pas id=1056 (33 entrées; SHA-256 504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae), comme établi et rehashé au lot santé précédent. |
| Consommateur Rust | shop.rs, SHA-256 courant 3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0, ne résout que les objets du catalogue et renvoie « item behavior not implemented » quand l’ID manque. Bonuses expose mana_regen_percent, pas de mana_regen flat. regeneration_tooltip calcule le taux de base multiplié par mana_regen_percent. |

## Attendu, observé et limites

**Attendu catalogue :** la ligne officielle indique +0.6 de régénération de mana plate. Cela n’est pas confirmé par le décodage natif actuellement enregistré.

**Observé dans le code :** aucun champ plat ne permet de transmettre cette statistique; aucune ligne 1056 ne permet de l’acheter; le chemin d’achat aboutit statiquement au refus d’objet inconnu. Aucun de ces résultats n’a été exécuté en test pendant ce lot.

**Inconnue de source :** l’absence de FlatMPRegenMod dans l’export JSON ne prouve pas que la clé est absente de l’INIBIN brut, puisque la couverture du décodeur n’est pas documentée ici. Ne pas convertir le 0.6 du catalogue 4.20.1 en fait natif 4.20 EUW sans preuve supplémentaire.

## Reprise précise

Reprendre la qualification de source uniquement avec un dump des paires clé/valeur de DATA/Items/1056.inibin produit par un décodeur identifié et lié à des hashes, ou avec une autre source primaire membre du build qui démontre FlatMPRegenMod. Si cette valeur est confirmée dans le périmètre retenu, ajouter une représentation de mana_regen plate au consommateur/donnée de l’objet, puis tester l’achat, l’effet attendu et les refus sur les hashes courants. Si la clé est prouvée absente, résoudre le conflit avec le catalogue officiel et justifier la règle appliquée avant d’exclure l’exigence. Réutiliser le hash et membership 1056 du lot précédent sans les recalculer si le fichier n’a pas changé.

L’audit est clos comme constat borné de lien manquant et de conflit non résolu. L’implémentation fonctionnelle de ITEM-1056-SERVER-STAT-FlatMPRegenMod, l’acceptation et SYS-01.2-02 restent ouverts.

## Contrôles réellement exécutés

- lecture ciblée du contrat de tâche, de la trace et des identifiants associés;
- réutilisation de la preuve source et membership 1056 vérifiée au lot précédent;
- inspection de l’objet 1056 dans native_item_audit.json et parsing de la ligne 4.20.1 déjà enregistrée;
- inspection ciblée de Bonuses, de regeneration_tooltip et de la résolution/erreur d’achat dans shop.rs;
- aucun test, build, lancement du jeu, installation ou migration.

Aucun code, registre de suivi, goal, application de suivi ou base de données n’a été modifié.## Addendum V1010 — valeur INIBIN brute de FlatMPRegenMod

Cet addendum remplace uniquement l’ancienne incertitude sur la présence/valeur de la clé dans le binaire. Le constat que l’export dérivé `native_item_audit.json` ne l’énumérait pas reste exact; cet export avait une couverture incomplète pour ce champ.

Le lecteur `tools/project-plan/reference_inibin.py` calcule le hash de `Data*FlatMPRegenMod` comme `1108872257`. Le lecteur de référence local `tools/references/lolpytools/lolpytools_inibin2.py` retrouve la même clé. Les deux fichiers sont ceux du répertoire client 4.20.0.315 `RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Items`; leurs empreintes attendues ont été comparées aux octets effectivement décodés.

| Contrôle | Résultat attendu | Observé par reference_inibin | Observé par lolpytools |
|---|---:|---:|---:|
| Contrôle positif — `1005.inibin`, SHA-256 `30454747f4626b051904930d70a99b8081240cb959a8f60b5e720cd3fae2871b`, 527 octets | `FlatMPRegenMod=1.4`, valeur déjà reliée au natif dans V1006 | `1.4000000000000001` | `1.4000000000000001` |
| Cible — `1056.inibin`, SHA-256 `861cf0f8d1d7fb17098cfd76ea28991eb82467ab3361b4322c0124a43174b12c`, 485 octets | La présence et la valeur native sont à établir; la référence 4.20.1 donne `0.6` | `0.6000000000000001` | `0.6000000000000001` |

Chaque lecteur a décodé 64 clés dans chacun des deux fichiers; le contrôle positif confirme le nom/section de la propriété et le chemin de lecture. La valeur binaire 1056 correspond à `0.6` à la précision flottante du format et concorde avec la valeur enregistrée dans Data Dragon 4.20.1. La source est donc désormais qualifiée pour cette propriété. Cette comparaison ne prouve pas la politique du serveur historique, la fréquence d’application ni le comportement en partie.

### État source → consommateur après résolution

L’export dérivé omet toujours `FlatMPRegenMod`; il ne doit plus servir à conclure que la clé manque au natif. Le catalogue `shop_foundation.json` (SHA-256 `504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae`) ne contient toujours pas l’ID 1056. Le code `shop.rs` (SHA-256 `3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0`) ne porte que `mana_regen_percent`; `regeneration_tooltip` multiplie le taux de base par cette valeur. La recherche d’un objet absent renvoie statiquement `item behavior not implemented`. `progression.rs` (SHA-256 `eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766`) et le catalogue ont conservé les empreintes déjà vérifiées.

**Décision du lot.** Le sous-audit source → donnée native → consumer courant est clôturé avec une valeur native résolue : `FlatMPRegenMod=0.6`. L’écart constaté est l’omission dans l’export et l’absence d’intégration dans le consumer; il ne constitue pas une fonctionnalité terminée. Aucun achat, effet de régénération, refus runtime ni cas de limite n’a été exécuté. Le statut de tâche, les données de jeu, le code, le goal, l’application et ses bases restent inchangés.

**Contrôles réellement exécutés.** Deux décodeurs locaux ont lu les fichiers natifs en mémoire via `python -B`; les deux empreintes SHA enregistrées ont été comparées aux octets lus; la clé `Data*FlatMPRegenMod` a été recherchée dans les deux sorties; les empreintes du catalogue, des consommateurs et de l’export dérivé ont été comparées aux preuves précédentes; les points d’entrée Rust ont été inspectés. Aucun test, build, lancement, installation ou migration.

**Limites et reprise.** Restent ouverts : intégration de la stat plate et du recalcul des ressources, achat/refus observés en exécution, éventuel effet sur la mana courante, règles de cumul, sélection effective pour le mode/map et acceptation humaine. Reprendre la fonctionnalité dans son lot dédié avec un consumer révisé et des vérifications nominales/refus; ne pas redécoder ni rehasher les deux sources tant que leurs empreintes ne changent pas. Pour SYS-01.2-02, cette preuve ferme seulement la relation source-consumer statique de ce champ.