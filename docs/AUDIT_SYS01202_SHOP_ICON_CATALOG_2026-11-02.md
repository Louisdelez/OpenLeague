# Audit regroupé — icônes du catalogue boutique Map10 (33 objets)

Date : 2026-11-02  
Unité : `AUD-SYS-01.2-02-SHOP-ICON-CATALOG-01`  
Objectif parent : `SYS-01.2-02` — relier les exigences à leurs sources natives et consumers actuels.  
Référence : client 4.20.0.315 PUBLIC, EUW/en_GB ; catalogue Data Dragon 4.20.1 séparé.

## Lot et critères de clôture

Lot unique sur le chemin partagé des icônes boutique : chaque entrée active du catalogue et du manifeste HUD doit avoir un INIBIN natif, un DDS choisi par `Data/InventoryIcon`, une copie DDS installée et une PNG boutique au contenu identique après décodage. Le consumer courant doit être identifié, les refus d’admission Map10 distingués d’un manque d’image et les limites de rendu signalées.

**Résultat :** les 33 chaînes d’assets passent les contrôles d’identité et d’égalité des pixels. Le consumer boutique réel est identifié dans le code, mais son ancre n’est pas présente dans les 33 traces individuelles; la correction du registre reste interdite par la restriction active. Le lot clôt l’audit du chemin d’assets, pas les statuts individuels ou le goal parent.

## Sources et résultats mesurés

Le reçu déjà disponible `docs/reference_portrait_inventory_sources/portrait-inventory-v217.json` contient une association par objet (`kind=inventory_icon`), avec chemin INIBIN, nom DDS référencé, tailles, SHA-256, appartenance au manifeste du projet `lol_game_client`, copie locale et descripteur DDS. Les associations individuelles n’ont pas été redécodées. Les SHA-256 et tailles actuels des 33 INIBIN, des 33 DDS natifs et des 33 copies `assets/ui/native_items/{id}.dds` ont tous été comparés à leurs valeurs dans le reçu : **33/33 concordent dans chacune des trois catégories**. Les deux états d’appartenance du reçu indiquent `matches_selected_project_manifest` pour chacune des 33 ressources. La priorité effective de montage n’est pas qualifiée par ce reçu.

Pour chaque ID, FFmpeg a décodé le DDS natif et `assets/ui/items/{id}.png` en mémoire en RGBA. Les sorties ont chacune 16 384 octets (64×64 pixels), sont égales octet par octet et donnent le même SHA-256 RGBA par paire. Aucun fichier intermédiaire n’a été écrit. Résultats : **33/33 PNG présentes, 33/33 égalités RGBA, 33/33 copies DDS byte-identiques**.

| Objet | Exigence | DDS natif sélectionné | Admission Map10 locale |
|---:|---|---|:---:|
| 1001 | `OLF-3f5c47d1-d1eb-5a39-91af-7a79d5af0c72` | `1001_Boots_of_Speed.dds` | oui |
| 1004 | `OLF-02d47731-1f22-55b7-9227-498d3596fef0` | `1004_Faerie_Charm.dds` | oui |
| 1006 | `OLF-e6a9233b-1595-5873-9956-5e12ed41c00e` | `1006_Rejuvenation_Bead.dds` | oui |
| 1011 | `OLF-4ccf46ca-e2a0-58e5-9779-9ba898491726` | `1011_Mighty_Waistband_of_the_Reaver.dds` | oui |
| 1027 | `OLF-a9f309d8-be1e-54d1-93be-8fa361afee22` | `1027_Sapphire_Sphere.dds` | oui |
| 1028 | `OLF-19d2cc98-e0f2-5079-91de-5e8f2359c51f` | `1028_RubyCrystal.dds` | oui |
| 1029 | `OLF-22e3e018-bc25-500b-b676-fa5423ee2d46` | `1029_Cloth_Armour.dds` | oui |
| 1031 | `OLF-268150ca-c266-5105-82f1-78f92198748d` | `1031_Chain_Vest.dds` | oui |
| 1033 | `OLF-00a37123-5231-5af9-a5e1-53d43db08755` | `1033_Elementium_Threaded_Cloak.dds` | oui |
| 1036 | `OLF-06bd4529-b0c1-57aa-9c49-e24e3b737605` | `1036_Long_Sword.dds` | oui |
| 1037 | `OLF-f7a1e398-e955-5a33-acb8-aefafaabe0b7` | `1037_Broadsword.dds` | oui |
| 1038 | `OLF-e9b1e148-4dc8-576b-883f-512cb0582fd7` | `1038_BF_Sword.dds` | non |
| 1042 | `OLF-8aea201c-42c7-511b-8737-f032c3418cf1` | `1042_Dagger.dds` | oui |
| 3801 | `OLF-d9f0fe38-1150-5302-acac-917abad5ce92` | `3801_Crystalline_Bracer.dds` | oui |
| 1051 | `OLF-2dc339b2-c919-53b5-96ca-abd5cdc6123c` | `1051_Brawlers_Gloves.dds` | oui |
| 1018 | `OLF-479abc28-8315-54de-a80f-8a57bf914611` | `1018_Cloak_of_Agility.dds` | oui |
| 1053 | `OLF-ab51fb8c-971f-5541-9b27-5c1dcaa670ef` | `1053_Vampiric_Scepter.dds` | oui |
| 1026 | `OLF-ece058ca-153d-55ce-bbdd-cd7e30a70f23` | `1026_Blasting_Band.dds` | oui |
| 1052 | `OLF-4046c3df-ee5a-52ab-9ab7-3ca09fcba2d2` | `1052_Amplifying_Scepter.dds` | oui |
| 1058 | `OLF-063261df-0b3c-529c-80ef-4761d204448b` | `1058_Needlessly_Large_Wand.dds` | non |
| 3108 | `OLF-2a0e8501-6e5c-574e-8745-88749ec6ef91` | `113_Tome_of_Minor_Necro_Compulsion.DDS` | oui |
| 3114 | `OLF-520eb956-857b-5cec-a231-227e3f1c2637` | `3114_Forbidden_Idol.dds` | oui |
| 3067 | `OLF-cf81cb14-d18b-5d86-8d91-654a2ea2a9fd` | `3067_Kindlegem.dds` | oui |
| 3101 | `OLF-f863d372-8845-569d-9eef-b11988fd5a1e` | `059_Sheen.DDS` | oui |
| 3024 | `OLF-052fd589-9aca-5011-875f-d7a1cc7849d2` | `3024_Glacial_Shroud.dds` | oui |
| 3134 | `OLF-9bbfa9fc-f5fd-572e-8f23-02cc48207b65` | `037_Big_Stick.dds` | oui |
| 3035 | `OLF-5cbe1893-6194-5424-ba96-4c4d3fedad93` | `3035_Last_Whisper.dds` | oui |
| 3135 | `OLF-da4e65ea-60e9-5471-b659-897360e80ac9` | `073_Zettas_Mana-Stick.DDS` | oui |
| 3136 | `OLF-33f9fc5f-b4b7-5114-ab7a-6c2cb0de4602` | `3136_Haunting_Guise.dds` | oui |
| 3020 | `OLF-82be664b-91c5-5dc0-bf47-a7b8f0bba076` | `3020_Flamewalkers.dds` | oui |
| 2003 | `OLF-13c7bbe2-e51a-5a08-a970-28e8dc091c16` | `2003_Health_Potion.dds` | oui |
| 2004 | `OLF-d0a6d7e8-b985-5069-997d-c5ac3c4f5388` | `2004_Mana_Potion.dds` | oui |
| 1055 | `OLF-47188f57-97e5-5b88-bdf5-dbd19447d4e1` | `PetAttack.DDS` | oui |

## Consumers, cas nominal et refus

Le code courant `crates/client/src/shop_ui.rs` (SHA-256 `cf7405045e6541866543c447b31aef33730ef6c11d2eb6b275387fbb27adcfc1`) filtre les lignes via `map10_purchase_catalog()` (autour de la ligne 57), puis charge `ui/items/{id}.png` pour chaque ligne (ligne 233) et pour le détail sélectionné (ligne 416). La donnée locale contient 33 objets; `native_inventory_icons.json` contient 33 entrées; l’admission contient 33 décisions : 31 `true`, deux `false` (1038 et 1058).

Le refus observé est un refus d’affichage/achat sur Map10 pour 1038 et 1058; ces deux objets ont néanmoins une source DDS, une copie HUD et une PNG boutique pixel-identiques. Un filtre qui les masque ne signifie donc pas que leur icône manque. Ce refus est celui des données OpenLeague actuelles et ne tranche pas leur disponibilité sur toutes les cartes ou dans toutes les versions du client.

Les 33 traces individuelles ont chacune la même liste de sept consumers : `OLC-b38bc16e-af3e-565e-8e4a-e8549549a702` (lookup), cinq ancres du HUD (`OLC-75bd4d46-b96a-5d54-8f66-e99a88635b0e`, `OLC-2656f81f-a6a9-5ad5-84ed-8f6a809b671d`, `OLC-93c64d4a-5cbc-58de-8b3b-48fdf61b4925`, `OLC-54b3a030-bcfe-5420-8c28-aac49bc524af`, `OLC-864f1e69-ab50-5bfe-a718-2cc95167fbc0`) et le décodeur DDS partagé (`OLC-1613f21b-149d-5048-9d26-e119d0536f5a`). Leurs chemins ont été résolus dans `fidelity_sources_4_20.json` et réutilisés depuis `docs/AUDIT_SYS01202_ITEM3101_ICON_2026-11-02.md` : lookup `shop.rs`, consommateurs `native_hud_inventory.rs` et `native_hud_atlases.rs`. Aucun ne pointe vers l’appel PNG boutique `shop_ui.rs:233` ni vers l’icône détaillée `shop_ui.rs:416`. Le consumer réel est maintenant explicitement relié aux 33 exigences dans ce rapport, mais aucune ancre n’est ajoutée au registre sous la restriction courante.

## Vérification réutilisée et limites

Le reçu `portrait-inventory-v217.json` conserve le test `native_hud_inventory::tests::original_six_slots_counts_and_all_playable_dds_are_used_without_replacement` : réussi, code 0, sur un binaire de tests identifié; il itère les 33 IDs du catalogue et décode les DDS HUD. Les SHA-256 actuels de `native_hud_inventory.rs`, `native_hud_inventory_tests.rs` et `native_inventory_icons.json` concordent avec ceux du reçu. Le test couvre le consumer CPU du HUD, pas les PNG boutique, l’interface réellement rendue ou un GPU. Le test de filtre boutique consigné dans `AUDIT_SYS01202_ITEM3101_TEXT_2026-11-02.md` est réutilisé comme preuve historique de 33 objets globaux, 31 achetables et exclusion 1038/1058; il n’a pas été relancé.

Ce lot n’a exécuté ni test Rust, ni build, ni lancement, ni capture. La comparaison FFmpeg RGBA est une vérification d’asset, pas une preuve visuelle de la fenêtre. Aucun essai d’image manquante ou d’échec de montage n’a été effectué. Les 33 tâches sont marquées `required=false` dans la trace; aucun statut, portée, registre, goal, suivi ou base n’a été changé.

## Conditions de reprise et décision

1. Lorsque la restriction est levée, ajouter les deux vrais consumers boutique (`shop_ui.rs:233` et `:416`) aux exigences concernées, sans remplacer les consumers HUD déjà établis.
2. Qualifier séparément le précédent de montage et la sélection native effective avant d’affirmer la fidélité de runtime.
3. Vérifier le rendu UI sur une exécution courante; pour 1038 et 1058, conserver le refus Map10 local distinct d’une disponibilité historique globale.
4. Clarifier pourquoi ces 33 tâches portent `required=false` avant toute prétention de couverture requise.

**Décision bornée :** la liaison source native → copies → PNG boutique est vérifiée pour les 33 entrées, avec 33/33 égalités de pixels et deux refus d’admission Map10. Le consumer boutique réel existe, mais les ancres du registre ne le couvrent pas; rendu, priorité de montage, portée et acceptation restent ouverts. SYS-01.2-02 demeure actif et partiel.
