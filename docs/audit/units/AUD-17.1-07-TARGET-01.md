# AUD-17.1-07-TARGET-01 — Cible sélectionnée et informations publiques

Date des contrôles : 2026-10-30T18:40:05.780873+00:00. Goal courant : SYS-01.2-02, conservé actif et inchangé.

## R1 — Exigence, périmètre et frontière de clôture

**SYS-17.1-07** — « Afficher la cible sélectionnée et ses informations publiques ». Identifiant stable : **OLF-fae17085-a8e6-5088-b3b5-8f83998772e7**. Inconnue réutilisée : **OLU-e6a1be9b-8c17-5ce3-be3e-a171aec1b9ac**, toujours `open` dans le registre normatif.

Ce lot clôt l’audit documentaire de l’état actuel lorsque les sept rubriques et la relecture indépendante de `delivery-readback.json` passent. Il ne clôt ni la fonctionnalité, ni son acceptation, ni le goal global. Le reçu brut garde `audit_scope_closed: false` pour ne pas s’auto-valider ; le reçu de livraison séparé porte la conclusion documentaire.

Le registre conserve `status: a_faire`, `implementation_complete: false`, `acceptance_complete: false`. Le critère fonctionnel original exige un résultat intégré au consommateur réel et vérifié sur la référence 4.20 ; ce résultat n’est pas démontré ici.

Référence : LoL 4.20.0.315, PUBLIC Releases/4.20, EUW/en_GB, catalogue 4.20.1 ; la date de compilation n’est pas transformée en date de déploiement. Périmètre frais : panneau de cible du HUD normal ShadowIsles chargé actuellement, ses ressources, ses sélecteurs et la frontière des données publiques. Contexte flipped/replay conservé, comportement dynamique historique encore ouvert.

Prérequis vérifiés : phase D17 ; lot D17-SYS-17-1 « HUD de partie », huit tâches, dépendances directes vides, `requires_packages: [D05-SYS-05-5]`. Ce dernier lot est encore `a_faire` et requiert D05-SYS-05-1/02. Aucun prérequis fonctionnel n’est déclaré acquis à partir du présent audit.

## R2 — Sources originales, preuves réutilisées et provenance

Les deux archives HUD ont été relues et comparées par SHA-256, sans extraction ni modification :

- Copie de travail : `F:\OpenLeague\data\4.20\archives\menu\HUD.zip`.
- Original : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\menu\HUD.zip`.
- Les deux : 122169 octets, SHA-256 `76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c`.
- Binaire associé aux captures natives héritées : `League of Legends.exe` du même déploiement, 15973880 octets, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Le binaire n’a pas été exécuté dans ce lot.

`HUD/defaults/FastHUD.ini` référence les listes normales et inversées ShadowIsles. La liste normale contient les six fichiers TargetBar et VisionSlot.ini. Ces sept fichiers contiennent **89 définitions de cible : 57 Icon, 24 Text, 8 Effect**. Leur texte, chemin, offset brut, propriétés avec doublons et espaces conservés, hash et correspondance native sont enregistrés dans le reçu.

| Fichier sous HUD/Elements | Text de cible | SHA-256 source |
|---|---:|---|
| TargetBar_Frame_Portrait.ini | 1 | `7e3ace2ac522e2d630dcac2338f6b9ca521c2e442564359438d9689aa12a815b` |
| TargetBar_HealthBar.ini | 1 | `2d7f8caf0771f94a0d963a1b743c6ef772646a4ceebdd61bbe5c3d03cce3367f` |
| TargetBar_PARBar.ini | 1 | `36d35328625c9c59f33d615739df5bac413971876a6a797ceac667e7e187bd0a` |
| TargetBar_Stats.ini | 6 | `65f0b2cd50ce82fdf8eec6ac24afeba0ae5350253be350ec3aa8b8df80cb89c0` |
| TargetBar_Items.ini | 6 | `2956b53c4963f42475421cb28848db4082729f1d2cc6d341b7adde73902019a0` |
| TargetBar_Buffs.ini | 8 | `ab26e62d3e67be6e21b5ffdaac138a1b7cdd93d6d8dc05bafd0ad6dcc9b567f5` |
| VisionSlot.ini | 1 | `548b18a1c5a21b7408a43eaa1b5f6094c0a6975c0348ddd87e00e80b73b8dfd6` |

La barre de vie et la barre de ressource appartiennent à `TargetBarRealtime` ; les 22 autres Text ont le groupe normalisé `TargetBar`. Les espaces terminaux de `TargetItem4_Count` et de l’icône `TargetItem6_` sont conservés dans la preuve lexicale et ne sont pas déclarés corrompus. Les noms de groupes capturés par le parseur sont vérifiés séparément.

**Septième emplacement :** `VisionSlot.ini` fournit `TargetItem6_` et `TargetItem6_Count`, initialement désactivés. Le fichier est réellement dans la liste normale de cette carte. Cela ne prouve pas la règle dynamique d’autorisation du slot 6 en 3v3. La liste inversée référence `VisionSlot_Right.ini`, dont le texte s’appelle `TargetItem6_Stack` ; aucune équivalence de noms ou fidélité flipped n’est inventée.

`Scenes.ini` définit `TargetBar` et `TargetBarRealtime` avec `Enabled: 0`. Un enfant déclaré actif ne suffit donc pas à démontrer l’activation du panneau. `TargetImage`, `TargetItem*_Icon` et `TargetBuffIcon*` sont des noms de liaison dynamique ; leur présence n’est pas la preuve de fichiers image manquants.

**Réparation antérieure conservée :** l’original `TargetBar_Buffs.ini` finit par un effet incomplet. Le rejet hérité porte précisément sur `TargetBuffCooldown7` à l’offset 11005. Le fichier déjà réparé se trouve dans `data/4.20/hud_restored/HUD/Elements/TargetBar_Buffs.ini`, SHA-256 `504e33f7fe6b5cadbb9d7e6e5fcaa547710b0837f5da475bbd44f217e1efe709`. Il conserve exactement l’original puis ajoute les 33 octets `\r\nEffectColor1: 64, 64, 64, 100\r\n`. Aucune nouvelle reconstruction effectuée.

La capture native de boucle de fichier conservée rapporte original : 39 éléments généraux / 7 effets ; réparé : 40 / 8, deux affectations d’en-tête, zéro avertissement, fermeture du flux une fois. Ce sont des résultats hérités dont les entrées ont été revérifiées octet par octet, pas une nouvelle exécution native.

Preuves réutilisées : inventaire `AUD-22.1-04-HUD-01/hud-inventory.json` (les 24 identifiants HUD existants sont repris), `native_hud_source_records_contract.json` (captures par élément), `native_hud_file_loop_contract.json` (boucle originale/réparée), association `docs/reference_hud_display_sources/hud_display-links.json` et corpus courant de `AUD-17.2-09-NATIVE-BUFFER-01`. La qualification primitive ne prouve ni l’interaction, ni la projection des champs publics, ni le rendu complet.

## R3 — Consommateurs réels et absence bornée

| Consommateur actuel | Observation et limite |
|---|---|
| native_zip_provider.rs:75–118 | Lit la liste ShadowIsles normale, charge chaque fichier, applique les réparations qualifiées, parse la structure, groupes, textures et requêtes de fontes. Chargement structurel réel, distinct du dessin. |
| native_zip_provider.rs:123–138 | Vérifie l’original exact et le fichier réparé exact contre les entrées du contrat natif ; absence ou différence produit un refus explicite. Branches relues, pas exécutées à nouveau ici. |
| main.rs:687–716 | Les plugins widgets, inventaire, panneaux, portraits et barres sont réellement enregistrés. Aucun effacement de ces acquis. |
| native_hud_widgets.rs:66–96 | Sélectionne dix-huit Text du joueur local et du temps ; valeurs par connection.id. N’inclut aucun des 24 Text de cible. |
| native_hud_bars.rs:9–18 | HP/ressource du joueur local et fichiers CenterHUD ; aucune sélection des barres TargetBar. |
| native_hud_panels.rs:8–18 | Trois cadres statiques HUDLeftFrame/HUDLeftPillar/TitanBarFrame ; aucune sélection de TargetBarFrame. |
| native_hud_portraits.rs:9–16 | Portrait propre ShadowIslesChampionLeft.ini, liaison AvatarImage ; ce n’est pas TargetPortrait/TargetImage. |
| native_hud_inventory.rs:17–57 | Six slots et compteurs du joueur local dans ShadowIslesChampionLeft.ini ; ce ne sont pas les sept slots TargetItem. |
| native_ezreal_passive_hud.rs:14–66 | BuffStack0 propre dans CenterHUD_Buffs.ini ; ce n’est pas l’ensemble des TargetBuffStack0…7. |
| picking.rs:16–85 → main.rs:1453–1502 | Retourne une identité ennemie vivante du snapshot selon collision/rayon ; alimente Attack/Cast. L’absence du joueur propre retourne None, les quatre types de structures sans rayon gardent un fallback explicitement reconstruit à 160. Ce chemin ne démontre pas un état d’inspection persistante ni un panneau d’information. |
| core/world.rs:226–243 | target_info est interne pub(crate), pour les règles de jeu (position, vie, équipe, rayon). Ne pas l’exposer comme projection publique de HUD. |
| core/vision.rs:137–167,208–219 → server/session_host.rs:158–167 → client/main.rs:1317–1335 | Projection par spectateur effectif via snapshot_for, puis snapshot_for_atomic, routage à route.context.player et réception courante du snapshot. Les entités sont filtrées par visible_to. Cela ne qualifie pas à lui seul chaque champ transporté comme historiquement public. |

Une seule nouvelle recherche lexicale ciblée est conservée : `selected_target|target_panel|target_hud|TargetBar|TargetItem6|TargetBuffStack|TargetHPStat|TargetLevel`, sur 1168 fichiers Rust courants et JS/HTML de launcher délimités dans le reçu. Tous leurs chemins et hashes ont été comparés au corpus antérieur : aucun écart. Deux occurrences seulement, toutes deux dans le fournisseur : réparation et test existant. L’examen direct des sélecteurs et du chemin de commande complète cette recherche ; aucune prétention à un graphe d’appels sémantique exhaustif.

**Conclusion actuelle :** les ressources et leurs primitives de chargement existent ; un consommateur d’affichage de la cible sélectionnée n’a pas été identifié dans les chemins inspectés. L’audit ne transforme pas cette absence bornée en panne observée à l’écran ni en fuite de données prouvée.

## R4 — Attendu, observé, contrôles et refus

| Contrôle | Attendu | Observé |
|---|---|---|
| Nominal documentaire | Sources originales égales à la copie et identités HUD traçables | 2 archives identiques ; 7 membres pertinents ; 89 définitions et 24 Text reliés à leurs captures et identifiants existants. |
| Groupes de Text | Comparer au Group réel de chaque source | 22 TargetBar normalisés, 2 TargetBarRealtime ; les espaces bruts sont conservés. |
| Limite originale | Ne pas masquer un élément incomplet | Rejet hérité TargetBuffCooldown7, réparation distincte déjà existante et 7→8 effets dans les preuves de boucle. |
| Réparation choisie | Original et overlay strictement qualifiés | Entrées conservées égales aux octets actuels ; les branches Rust de refus original différent / overlay absent / overlay différent sont citées. Aucun de ces refus Rust n’est revendiqué comme exécuté ici. |
| Informations publiques | Source explicite par champ et par cible | Non établi pour un nouveau panneau ; le filtrage des entités et le gameplay target_info ne suffisent pas. |
| Consommateur fonctionnel | Sélection d’inspection, données autorisées, dessin et effacement vérifiés | Non démontré ; sélecteurs existants consacrés au joueur propre ; picking consacré aux commandes. |
| Conservation | Goal, suivi, normes et code préexistant inchangés | 25 fichiers protégés et 5 registres recontrôlés ; Git identique avant/après, 76 fichiers déjà modifiés conservés, HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca. |

**Contrôles réellement exécutés :** Python 3, lecture ZIP/JSON/mmap, SHA-256, index lexical des définitions, comparaison de captures héritées et de sélecteurs source, recherche ciblée du corpus, lecture Git. Le producteur corrigé termine code 0 avec **291 contrôles réussis**. Le détail attendu/observé est dans `checks` du reçu.

**Non exécutés :** Cargo, tests Rust, jeu natif ou courant, émulateur, capture graphique, serveur de suivi, SQLite/base de suivi, migration, installation, REA et changement du goal. Aucune acceptation humaine réclamée.

**Erreur d’audit conservée :** le premier producteur attendait à tort TargetBar pour tous les Text et a échoué sur TargetHPStat, qui est réellement TargetBarRealtime. Il n’avait pas écrit de reçu principal. La v2 compare chaque groupe à sa définition source. Le delta de réparation est maintenant comparé aux 33 octets exacts, avec CRLF initial. Première version et `attempt-1-failure.json` gardés ; aucune erreur du produit n’en est déduite.

Une exploration avec les noms ZIP stricts a aussi échoué sur `ShadowIslesCenterHUD_LevelUPBar.ini` : le membre porte `LevelUpBar`. La résolution par noms ASCII insensibles à la casse, cohérente avec le fournisseur actuel, retrouve le membre ; les noms ZIP sont non ambigus dans cet index. Ce n’est pas une ressource manquante.

## R5 — Manques et conditions précises de reprise

- Il ne manque aucun des 24 Text de la liste normale examinée. Ne pas lancer de recherche communautaire de textures avant d’avoir identifié un véritable producteur dynamique ou fichier absent.
- Sélection : obtenir les callbacks/états natifs d’inspection et leurs règles de désélection ou déclarer explicitement une politique locale reconstruite. Le picker ennemi actuel ne prouve pas la sélection historique d’alliés, morts ou unités inspectables.
- Champs publics : produire une matrice champ × type de cible × audience/visibilité, avec sources de réplication/affichage natives ou limites locales assumées ; ajouter des tests de projection et d’indisponibilité. Aucun champ n’est autorisé simplement parce que l’entité est dans un snapshot.
- Activation et rendu : qualifier le pilote de TargetBar/TargetBarRealtime, TargetImage, TargetItem*_Icon et TargetBuffIcon*, puis les entrées de rendu réelles, formats numériques, états d’icônes et effets. La présence des sources n’établit pas le dessin.
- Slot 6 : obtenir sa condition dynamique de mode/entité et la correspondance normale/flipped avant de l’activer. Buffs : permissions, ordre, piles et temps d’expiration à qualifier en coordination avec SYS-17.1-06.
- Cycle de vie : définir puis exercer changement A→B, suppression, cible cachée, données indisponibles, reconnexion et changement de session ; aucune valeur privée nouvelle ou périmée ne doit être fabriquée pour compléter le panneau.
- Preuve fonctionnelle : après un consommateur réel, obtenir une exécution client et des captures à viewport déclaré, avec nominal et refus pertinents. Les contextes flipped/replay restent à qualifier si revendiqués. Aucun de ces travaux n’est compté comme accompli par ce lot.

Les recherches générales déjà consignées ne sont pas relancées sans indice neuf. Conditions de reprise ci-dessus : nouveau callback/pilote natif localisé, contrat public par champ, changement du consommateur ou preuve runtime nouvelle. Un chemin, un build ou un lien supplémentaire seul ne résout pas cette exigence.

## R6 — Corrections indépendantes proposées, non appliquées

Ces identifiants appartiennent à ce rapport d’audit. Ce sont des lots futurs proposés, sans modification du plan, du goal ou de leurs critères normatifs. Chaque correction conserve SYS-17.1-07, son OLF et son OLU. La liste détaillée, les entrées de reprise et les correspondances HUD sont dans `proposed_corrections` du reçu.

| Correction | Résultat attendu pour une future clôture propre |
|---|---|
| `TARGET-01-SELECTION` | Selection inspection identity separate from attack/cast intent — Exact 4.20 selection/clear inputs and local policy documented; stable session+entity inspection state exercised without issuing an attack; ally/enemy/player/unit eligibility explicitly qualified. |
| `TARGET-02-PUBLIC` | Public-data projection matrix — Each displayed field has viewer/target visibility permission and unavailable behavior; hidden/removed/stale/session-mismatched targets reveal no new private values. |
| `TARGET-03-FRAME` | Target scene activation, frame and portrait — Bind TargetBar/TargetBarRealtime enable state and TargetImage producer; verify select/clear with original UV/layout and source/current comparison. |
| `TARGET-04-LEVEL` | TargetLevel — TargetLevel is fed by an authorized selected-target level and clears on invalid selection; original format policy qualified. |
| `TARGET-05-HEALTH` | TargetHPStat and target HP bar — Authorized target current/max HP, bar state and formatting verified independently of own HPStat. |
| `TARGET-06-RESOURCE` | TargetMPStat and target resource bar — Mana/non-mana/absent resource rules qualified for the selected target; unsupported data explicitly unavailable. |
| `TARGET-07-STAT-AD` | TargetADStat — Selected-target public AD value and native or explicit local formatter verified at nominal and unsupported/missing data boundaries. |
| `TARGET-07-STAT-AP` | TargetAPStat — Selected-target public AP value and native or explicit local formatter verified at nominal and unsupported/missing data boundaries. |
| `TARGET-07-STAT-AS` | TargetASStat — Selected-target public AS value and native or explicit local formatter verified at nominal and unsupported/missing data boundaries. |
| `TARGET-07-STAT-Armor` | TargetArmorStat — Selected-target public Armor value and native or explicit local formatter verified at nominal and unsupported/missing data boundaries. |
| `TARGET-07-STAT-MR` | TargetMRStat — Selected-target public MR value and native or explicit local formatter verified at nominal and unsupported/missing data boundaries. |
| `TARGET-07-STAT-MS` | TargetMSStat — Selected-target public MS value and native or explicit local formatter verified at nominal and unsupported/missing data boundaries. |
| `TARGET-08-ITEM-0` | Target item slot 0 — Bind authorized item identity/icon and counter for this slot only; empty/nonstack/unknown values clear; slot applicability proven rather than inferred from source presence. |
| `TARGET-08-ITEM-1` | Target item slot 1 — Bind authorized item identity/icon and counter for this slot only; empty/nonstack/unknown values clear; slot applicability proven rather than inferred from source presence. |
| `TARGET-08-ITEM-2` | Target item slot 2 — Bind authorized item identity/icon and counter for this slot only; empty/nonstack/unknown values clear; slot applicability proven rather than inferred from source presence. |
| `TARGET-08-ITEM-3` | Target item slot 3 — Bind authorized item identity/icon and counter for this slot only; empty/nonstack/unknown values clear; slot applicability proven rather than inferred from source presence. |
| `TARGET-08-ITEM-4` | Target item slot 4 — Bind authorized item identity/icon and counter for this slot only; empty/nonstack/unknown values clear; slot applicability proven rather than inferred from source presence. |
| `TARGET-08-ITEM-5` | Target item slot 5 — Bind authorized item identity/icon and counter for this slot only; empty/nonstack/unknown values clear; slot applicability proven rather than inferred from source presence. |
| `TARGET-08-ITEM-6` | Target item slot 6 — Bind authorized item identity/icon and counter for this slot only; empty/nonstack/unknown values clear; slot applicability proven rather than inferred from source presence. |
| `TARGET-09-BUFF-0` | Target buff slot 0 — Bind authorized icon, stack and cooldown effect for this slot; clear unavailable/expired/hidden target state; inherited source repair retained. |
| `TARGET-09-BUFF-1` | Target buff slot 1 — Bind authorized icon, stack and cooldown effect for this slot; clear unavailable/expired/hidden target state; inherited source repair retained. |
| `TARGET-09-BUFF-2` | Target buff slot 2 — Bind authorized icon, stack and cooldown effect for this slot; clear unavailable/expired/hidden target state; inherited source repair retained. |
| `TARGET-09-BUFF-3` | Target buff slot 3 — Bind authorized icon, stack and cooldown effect for this slot; clear unavailable/expired/hidden target state; inherited source repair retained. |
| `TARGET-09-BUFF-4` | Target buff slot 4 — Bind authorized icon, stack and cooldown effect for this slot; clear unavailable/expired/hidden target state; inherited source repair retained. |
| `TARGET-09-BUFF-5` | Target buff slot 5 — Bind authorized icon, stack and cooldown effect for this slot; clear unavailable/expired/hidden target state; inherited source repair retained. |
| `TARGET-09-BUFF-6` | Target buff slot 6 — Bind authorized icon, stack and cooldown effect for this slot; clear unavailable/expired/hidden target state; inherited source repair retained. |
| `TARGET-09-BUFF-7` | Target buff slot 7 — Bind authorized icon, stack and cooldown effect for this slot; clear unavailable/expired/hidden target state; inherited source repair retained. |
| `TARGET-10-LIFECYCLE` | Cross-field clear and native/current presentation comparison — Tests cover select A→B, deselect, death, fog/removal, reconnect/session change and unsupported entity; actual client capture plus source comparison at declared viewport. Audit alone never closes this correction. |

Les 24 Text sont affectés exactement une fois à leurs corrections de champ. Les sept slots d’objet et huit slots de buff sont séparés. Aucun de ces 28 lots n’est déclaré implémenté.

| Identifiant HUD antérieur | Définition | Groupe brut (espaces terminaux représentés par ␠) |
|---|---|---|
| `HUD-294b6e59def4ef2d` | TargetLevel | TargetBar |
| `HUD-80c0ef483323abd9` | TargetHPStat | TargetBarRealtime |
| `HUD-3821368fb77d3068` | TargetMPStat | TargetBarRealtime |
| `HUD-e7826f2f803a153f` | TargetADStat | TargetBar |
| `HUD-a4fee9ec12adb318` | TargetAPStat | TargetBar |
| `HUD-f95bf4522a54c813` | TargetASStat | TargetBar |
| `HUD-b6250bbf0ef2789f` | TargetArmorStat | TargetBar |
| `HUD-72d886a701652e60` | TargetMRStat | TargetBar |
| `HUD-01a267e290902bf7` | TargetMSStat | TargetBar |
| `HUD-1d94b0c1c76f530c` | TargetItem0_Count | TargetBar |
| `HUD-6ce940d9e39e7069` | TargetItem1_Count | TargetBar |
| `HUD-5dc337004c9748df` | TargetItem2_Count | TargetBar |
| `HUD-47b40e0dd93ccb2d` | TargetItem3_Count | TargetBar |
| `HUD-d72ac2dbed57cbc9` | TargetItem4_Count | TargetBar␠ |
| `HUD-26ecdbe927aeb0a0` | TargetItem5_Count | TargetBar |
| `HUD-5df4ee3e85465b14` | TargetBuffStack0 | TargetBar |
| `HUD-39156381cecd1809` | TargetBuffStack1 | TargetBar |
| `HUD-2429fbf438e562d6` | TargetBuffStack2 | TargetBar |
| `HUD-aaa3dac8668dca07` | TargetBuffStack3 | TargetBar |
| `HUD-cc4cf15ac3c4887d` | TargetBuffStack4 | TargetBar |
| `HUD-29e7827082a432b1` | TargetBuffStack5 | TargetBar |
| `HUD-10261dcdee165c9a` | TargetBuffStack6 | TargetBar |
| `HUD-4ac6b878d700c509` | TargetBuffStack7 | TargetBar |
| `HUD-32ab87c3249c862a` | TargetItem6_Count | TargetBar |

## R7 — Livraison, reprise vérifiable et conservation

Nouveaux fichiers uniquement :

- Rapport : `F:\OpenLeague\docs\audit\units\AUD-17.1-07-TARGET-01.md`.
- Dans `F:\OpenLeague-work\audit-units\AUD-17.1-07-TARGET-01\` : `verify_target_information.py` (première tentative conservée), `attempt-1-failure.json`, `verify_target_information_v2.py`, `target-information-proof.json`, `verify_delivery.py` et `delivery-readback.json`.

Reçu principal : SHA-256 `048cd6765508cf55c6f27c4bb145a12e6cdfa665bd717967460074742e4cd987`. Producteur v2 : `1afbcb28fdeb7ef119c19982389f192f699a56b084eb67d458594232277e269e`. Les identités de tous les autres intrants et les fragments de consommateurs avec lignes sont dans le reçu.

Pour recontrôler sans écrire : lancer le Python existant avec `-X utf8 -E -B F:\OpenLeague-work\audit-units\AUD-17.1-07-TARGET-01\verify_delivery.py --check-only`. Sans cette option, le lecteur écrit son reçu exclusivement et refuse de l’écraser. Même conservation pour le producteur : une nouvelle preuve doit porter un nouveau nom, aucune preuve existante n’est remplacée.

Le lecteur indépendant vérifie les identités actuelles, refait les liens des 24 Text depuis les offsets de l’inventaire, compare aux captures et aux sources originales, recoupe les comptes/réparation et les sept rubriques, puis conserve Git et les fichiers protégés. Sa conclusion documentaire n’altère aucun état normatif.

Résolu : identité/provenance des ressources du panneau, récupération des 24 liens HUD y compris slot6, distinction des deux groupes, réparation antérieure reconnue, consommateurs propres/commandes/projection distingués, limites et reprise délimitées. Ouvert : fonctionnalité d’inspection/rendu, autorisation publique par champ, pilotes dynamiques, variante inversée/replay, comparaisons graphiques et acceptation. Le jeu complet et le goal restent incomplets.
