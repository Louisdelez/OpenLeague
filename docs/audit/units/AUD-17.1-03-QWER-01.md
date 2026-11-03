# AUD-17.1-03-QWER-01 — Rangs et récupération Q/W/E/R

Date : 2026-10-30T19:57:42.918203+00:00. Projet : F:\OpenLeague. Lot du goal SYS-01.2-02.

Résultat : les sources et les consommateurs de SYS-17.1-03 sont reliés dans ce lot documentaire. La clôture de l’audit dépend de la relecture indépendante `delivery-readback.json`. La fonctionnalité, l’acceptation humaine et le goal restent incomplets. Aucun développement du jeu n’est livré dans ce lot.

## R1 — Exigence et frontière du lot

- Tâche : **SYS-17.1-03 — Afficher rangs et récupération des quatre compétences**.
- Exigence stable : **OLF-d5818a24-ef9e-5638-9792-fa70ad5e9605**.
- Inconnue conservée ouverte : **OLU-ad6bd316-ee70-51f7-80b1-0263c74a329d**.
- État normatif conservé : `a_faire`, `implementation_complete=false`, `acceptance_complete=false`. Aucun critère normatif ni statut n’a été modifié.
- Phase D17, lot D17-SYS-17-1, huit tâches. Prérequis déclaré D05-SYS-05-5 « Apprentissage dans les interfaces », toujours `a_faire`, lui-même lié à D05-SYS-05-1/2. L’audit des consommateurs existants ne vaut pas satisfaction de ces prérequis.
- Périmètre : rangs, éligibilité/apprentissage adjacent, icônes/états Q/W/E/R, texte et anneaux de récupération, producteurs des durées et transport jusqu’au snapshot consommé. Les deux invocateurs restent le lot AUD-17.1-04-SUMMONERS-01 déjà relu ; seuls leurs adaptateurs partagés sont réutilisés.
- Critères propres à ce lot : inventorier les huit membres sélectionnés, relier les consommateurs réels, identifier couverture/refus, réutiliser les contrats existants avec leurs limites, préciser les entrées de reprise et contrôler la conservation. Ils sont définis dans [audit-unit.json](F:/OpenLeague-work/audit-units/AUD-17.1-03-QWER-01/audit-unit.json), sans modification des critères normatifs du projet.

## R2 — Référence et sources originales

Référence conservée : League of Legends 4.20.0.315, PUBLIC/Releases/4.20, EUW/en_GB ; build 2014-11-17 17:46:45, fuseau et date de déploiement non établis ; catalogue 4.20.1.

Le PE original de la solution `lol_game_client_sln/releases/0.0.1.68/deploy` reste disponible : 15973880 octets, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Il a été identifié par lecture et hachage, **pas exécuté**. Les deux copies de HUD.zip (original D: et import F:) sont identiques : 122169 octets, SHA-256 `76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c`.

Les huit membres sont dans `ShadowIslesElementsListNormal.ini`. La différence de casse LevelUP/LevelUp est un alias de recherche insensible à la casse, pas un fichier manquant. Les 114 définitions ont une capture native antérieure acceptée, retrouvée par chemin, offset, nom et groupe ; aucune nouvelle exécution native n’est revendiquée.

| Membre sous HUD/Elements | Octets | Icon/Effect/Text | Sélectionné par les consommateurs étudiés |
|---|---:|---:|---:|
| CenterHUD_AbilitiesSpell0.ini | 3925 | 4/5/3 | 7 |
| CenterHUD_AbilitiesSpell1.ini | 3937 | 4/5/3 | 7 |
| CenterHUD_AbilitiesSpell2.ini | 3937 | 4/5/3 | 7 |
| CenterHUD_AbilitiesSpell3.ini | 3977 | 4/5/3 | 7 |
| CenterHUD_AbilitiesPipBars.ini | 5413 | 16/0/0 | 16 |
| CenterHUD_PositioningDummies.ini | 1790 | 4/0/2 | 2 |
| ShadowIslesEvolutionBar.ini | 6905 | 17/4/1 | 8 |
| ShadowIslesCenterHUD_LevelUpBar.ini | 6969 | 17/4/1 | 0 |

Total : **70 Icon, 28 Effect, 16 Text**. Les cinq consommateurs étudiés sélectionnent **54 définitions** : 26 pour les rangs, 8 pour l’apprentissage, 8 pour les icônes/overlays, 8 pour les textes et 4 pour les anneaux. Les **60 définitions adjacentes** non sélectionnées par ces chemins restent classées séparément ; il ne s’agit pas d’une preuve que 60 fonctionnalités manquent dans tout le jeu. Les deux références géométriques sont comptées comme sources, sans être confondues avec des sprites affichés.

Les 16 Text conservent leurs identifiants existants :

| Text | Identifiant conservé | Consommateur étudié |
|---|---|---|
| SpellCooldown0 | HUD-1eda9257a159be31 | native_hud_widgets |
| SpellAmmo0 | HUD-5ce143b9be7a3e97 | Adjacent, non sélectionné par les consommateurs étudiés |
| SpellHotKey0 | HUD-e3362f6b8009ba52 | native_hud_widgets |
| SpellCooldown1 | HUD-ed210d6ffca1177f | native_hud_widgets |
| SpellAmmo1 | HUD-7d00f89ec117fa34 | Adjacent, non sélectionné par les consommateurs étudiés |
| SpellHotKey1 | HUD-ee459b0a4efc8b6e | native_hud_widgets |
| SpellCooldown2 | HUD-e90982db87a0d51a | native_hud_widgets |
| SpellAmmo2 | HUD-97ec74c2b7e87b55 | Adjacent, non sélectionné par les consommateurs étudiés |
| SpellHotKey2 | HUD-2610bf26aadbe061 | native_hud_widgets |
| SpellCooldown3 | HUD-f2360bb84c6c0471 | native_hud_widgets |
| SpellAmmo3 | HUD-2a8affb60469514d | Adjacent, non sélectionné par les consommateurs étudiés |
| SpellHotKey3 | HUD-fd0945485824f4b2 | native_hud_widgets |
| SpellToolTip | HUD-58cbb44c426bb97d | Adjacent, non sélectionné par les consommateurs étudiés |
| StatusMessageToolTip | HUD-009dce28cf84cf84 | Adjacent, non sélectionné par les consommateurs étudiés |
| EvolutionBarTitle | HUD-3352fb4c2e36ef9f | Adjacent, non sélectionné par les consommateurs étudiés |
| LevelUpBarPoints | HUD-8442d09760d2f1ce | Adjacent, non sélectionné par les consommateurs étudiés |

Ressources d’icônes : 488 lignes de métadonnées pour 122 champions × quatre slots ; 486 icônes principales et 143 ressources variantes sont enregistrées. Les 486 fichiers DDS principaux présents sur F: ont été hachés et comparés aux SHA originaux enregistrés. Cela ne démontre ni leur décodage GPU actuel ni la sélection de leurs variantes. Pour Annie, Ezreal, Garen et Trundle, les 16 ponts config INIBIN originale → DDS original → DDS courant sont conservés et vérifiés. Le champ `sha256` de `native_spells_420.json` identifie un export JSON décodé : il ne faut pas le présenter comme le SHA du binaire INIBIN original.

Trois entrées non résolues, réutilisées sans refaire la même recherche :

| Entrée | État précis | Nouvelle entrée requise |
|---|---|---|
| Amumu W / AuraofDespair / InventoryIcon / SadMummy_AuraofDespair.dds | Deux DDS originaux différents sont présents, Characters/Amumu/Info et Spells/Icons2D. La config et les deux candidats sont toujours disponibles. | Priorité de résolution originale, manifeste ou trace du chargement natif. Aucun choix arbitraire. |
| Nunu R / AbsoluteZero / InventoryIcon / Yeti_Shatter.dds | Deux DDS originaux différents sont présents, Characters/Nunu/Info et Spells/Icons2D. La config et les deux candidats sont toujours disponibles. | Même besoin de priorité/trace originale ; ce n’est pas une absence de tous les fichiers. |
| Heimerdinger E / InventoryIcon2 / HeimerdingerE_E2.dds | La config existe. La variante n’avait pas été trouvée dans la recherche bornée des répertoires personnage/icônes globaux. Ce n’est pas une icône principale supplémentaire manquante. | Nouveau manifeste, alias, archive ou appelant. La recherche négative antérieure n’est pas réexécutée. |

## R3 — Producteurs et consommateurs actuels

Les sources Rust/launcher du corpus de 1168 fichiers ont les mêmes chemins, tailles et SHA que la preuve réutilisée AUD-17.2-09-NATIVE-BUFFER-01. Les fragments exacts, lignes et identités sont dans le reçu principal ; les liens transport sont vérifiés et conservés par le lecteur indépendant.

1. **État autoritaire** : `crates/core/src/lib.rs:180-184` porte `ranks`, les échéances `cooldowns` et `cooldown_totals: [Option<u64>;4]`, durée mémorisée à l’acceptation du sort. Les anciens snapshots sans cette propriété restent `None`, sans durée inventée. `snapshot()` clone ces champs. Les chemins effectifs sont `vision.rs:137/208` → `session_host.rs:158/200` et `server/main.rs:222`, puis `session_connection.rs:252` → `client/main.rs:1074/1331` → les plugins HUD. Le chemin legacy est distinct et reste présent. Cette lecture du transport ne prouve pas une session réseau exécutée maintenant.
2. **Écriture des délais** : 13 sites d’affectation en production couvrent les 16 sorts des quatre champions pris en charge : quatre Annie, quatre Ezreal, quatre Trundle et un chemin Garen commun aux quatre slots. Les fichiers/lignes exacts sont dans `production_duration_writers`. `cooldown.rs:11` utilise le plafond local CDR 0,4 et le minimum 0 ; la fidélité des scripts serveur originaux et des modificateurs n’est pas déduite de cette règle locale.
3. **Rangs affichés** : `native_hud_ranks.rs:7` reconnaît uniquement **Annie, Ezreal, Garen, Trundle**, schéma ordinaire 5/5/5/3. Les **118 autres champions** sont nommés individuellement dans `individual_rank_coverage` et `unsupported_rank_champions`, avec refus et entrée de reprise. Les 488 métadonnées de sorts ne constituent pas une table de rangs complète. Le producteur original de cette table n’est pas récupéré.
4. **Géométrie des rangs** : `native_hud_ranks.rs:22-47` sélectionne 26 sources : deux références, 16 séparateurs modèles, quatre remplissages et quatre fonds de raccourci. Le schéma 5/5/5/3 consomme 14 séparateurs ; deux modèles inutilisés ne sont pas un défaut. Rang 0 : aucun remplissage ; quatre fonds + 14 séparateurs donnent 18 entités. Quatre remplissages peuvent porter ce nombre à 22. Le consommateur vérifie rang ≤ maximum ; la fonction mathématique isolée n’effectue pas cette validation elle-même. Un rang hors limite ou une géométrie invalide est refusé.
5. **Apprentissage** : `progression.rs:150-185` vérifie slot, champion pris en charge, points, maximum et niveau. Les points sont dérivés de niveau − somme des rangs ; aucun DTO indépendant de points n’est démontré. R suit les seuils 6/11/16 ; les autres compétences suivent 2×rang−1. Le point d’entrée `Simulation::command` refuse une partie terminée et un champion mort avant `Action::Learn`; ne pas inférer une absence de ces garde-fous de la seule fonction `learn`.
6. **Boutons réels** : `native_hud_learning.rs:10-15` consomme huit `EvolutionArrow/Frame` de **ShadowIslesEvolutionBar.ini**, pas les sprites de `ShadowIslesCenterHUD_LevelUpBar.ini`. L’éligibilité utilise le même `next_rank`. Le clic produit `Action::Learn`, envoyé par `connection.send_action`; les limites de capture UI et la disponibilité de la connexion sont contrôlées. Les clics de qualification synthétiques ne prouvent pas l’équivalence de la souris OS. Les éléments adjacents LevelUp/Evolution, transitions, fade/glow, masques et callbacks natifs restent à qualifier.
7. **États et icônes** : `native_hud_spells.rs:21-31` lit rangs/échéances/santé/mana/étourdissements et les coûts de mana de base. Les schémas spéciaux sont refusés. Ce chemin ne qualifie pas toutes les ressources sans mana, les modificateurs de coût, les formes, les recasts ou leurs masques. Le chargement filtre `InventoryIcon` : disposer de 143 textures variantes ne prouve pas un sélecteur de variantes. Les rangs/apprentissages limités à quatre champions et la disponibilité de 486 icônes sont deux couvertures différentes.
8. **Récupération** : les quatre textes `SpellCooldown` et raccourcis `SpellHotKey` passent par `native_hud_widgets`. `native_hud_recharge::player_params` calcule `remaining = deadline.saturating_sub(tick)`. Si zéro, aucun anneau ; sinon il exige la durée autoritaire mémorisée. Un total absent, nul ou non fini est refusé ; le total n’est pas remplacé par le profil local des invocateurs. Un remboursement peut modifier l’échéance en conservant la durée mémorisée ; les tests source Annie Q et Ezreal Q existants sont des indices identifiés, pas des tests exécutés dans ce lot.
9. **Frontière d’erreur partagée** : l’adaptateur QWER/D/F peut invalider les six anneaux lorsque QWER renvoie une erreur ; les icônes partagent aussi une frontière de groupe. Le correctif existant `HUD-SUM-ERROR-BOUNDARY-01` est réutilisé. Aucun nouveau doublon ni correctif logiciel n’est appliqué. L’absence de session dans la signature locale des rangs est documentée dans le fragment, sans inventer un bug de cache sans cas réel.

Les anciens messages de trace « Annie/Garen », certaines anciennes limites et `next_action` ne sont pas une description exhaustive de l’état actuel : les sources actuelles reconnaissent bien quatre champions et les consommateurs textes/anneaux/boutons existent déjà. Ils sont conservés, sans les transformer en absence actuelle.

## R4 — Vérifications, attendu et observé

**438 contrôles documentaires réussis** dans `verify_qwer_v2.py`. Ce sont des comparaisons de fichiers, d’identités, de définitions, de métadonnées et de contrats lus ; aucun cas de jeu n’a été exécuté. La relecture indépendante contrôle de nouveau les éléments livrés et émet son résultat séparé.

| Cas examiné | Attendu selon le contrat lu | Observé et portée |
|---|---|---|
| Nominal ordinaire, quatre champions | Table 5/5/5/3, sources de pips et durées des quatre slots présentes | Quatre branches, 26 sources et 13 sites d’affectation retrouvés. Présence source, pas scénario de match rejoué. |
| Rang 0 / rang supérieur au maximum | Remplissage absent / refus explicite | Conditions exactes retrouvées dans fraction/panels ; aucune prétention d’exécution Rust. |
| Champion hors table | Refus rang/progression, aucun schéma générique inventé | 118 noms individuels, messages d’erreur actuels et conditions de reprise conservés. |
| Apprentissage sans points, mauvais slot/niveau/maximum, partie finie | Refus aux garde-fous nommés | Branches exactes retrouvées ; bouton et commande serveur reliés. |
| Échéance atteinte, total inconnu ou nul | Zéro : anneau absent ; intervalle actif invalide : erreur | Saturation et validations retrouvées ; la frontière partagée peut masquer les six anneaux. |
| Texture disponible | Bytes courants identiques au DDS original enregistré | 486 SHA comparés, 16 ponts complets config/DDS courant/original vérifiés. Pas de test GPU de ces 486 assets. |
| Sources ambiguës | Conserver les deux candidats | Config et candidats Amumu/Nunu relus ; aucune priorité inventée. |
| Réemploi des preuves d’octobre | Conserver leur identité et leur date, comparer les sources | Contrat de rangs inchangé ; `native_hud_ranks.rs` et `main.rs` ont changé. Anciennes captures non étendues à la version actuelle. |
| Conservation | Aucune mutation des acquis protégés ni registres | 25 fichiers protégés, cinq registres et Git suivis comparés avant/après ; bases jamais ouvertes. |

Contrats natifs hérités, **non réexécutés** : rangs getter 40/fractions 364/séparateurs 66, apprentissage 32, angle 256, états 384/couleurs 192. Les entrées de table, getters, masques, producteurs de ressources/durée ou paramètres fournis dans ces contrats ne prouvent pas l’ensemble du moteur original. Les contrats numériques/raccourcis sont ceux déjà réutilisés par le lot invocateurs ; aucune recherche REA répétée sans piste nouvelle.

La preuve graphique datée du 6 octobre mentionne 348 tests client et 12 captures, ancien binaire SHA `760398c765e12fd356d344c9b2c29813de7f3f78d334ea8d33f698db0b61822e`. Ces nombres sont **historiques**. Les captures n’ont pas été réinspectées ici ; la comparaison ne qualifie pas les sources changées. La compilation courante, les tests Rust, les exécutions REA/natives, le jeu, les sessions réseau, le GPU, les entrées OS et l’acceptation humaine sont **non exécutés**.

Incident du contrôle conservé : la première version attendait 16 sites d’écriture au lieu de 13, en confondant slots et affectations. Échec réel exit 1, attendu 16/observé 13. `verify_qwer.py` et `attempt-1-failure.json` restent conservés ; `verify_qwer_v2.py` corrige uniquement ce comptage et réutilise le périmètre initial. Aucun défaut du jeu n’est déduit de cet échec. Deux chemins initialement présumés (`commands.rs`, `session_state.rs`) étaient absents ; les consommateurs réels ont été retrouvés dans `lib.rs` et `session_host.rs`, sans conclure à une fonctionnalité manquante.

## R5 — Manques et conditions de reprise

Les inconnues ne sont pas refermées par la présence d’un fichier, un `passed=true` hérité ou le succès de cet audit. Chaque correction ci-dessous a un résultat de fin et une entrée de reprise, enregistrés dans le reçu. Une nouvelle entrée requise signifie table/appelant, priorité de ressource, nouvelle archive ou scénario/build courant identifié ; refaire la même recherche sans changement est exclu.

| Correction proposée | Manque précis | Critère de fin du futur correctif | Conditions de reprise |
|---|---|---|---|
| `HUD-QWER-RANK-SOURCE-01` | Current maxima and learning admit four ordinary schemes only; native getter receives a supplied table whose population is not recovered. | Identify table population/caller and validate per-champion maxima including exceptional schemes; admit each champion only on its own identified source and bounded rank0/max/overflow cases. | Original table/caller trace or decoded per-champion maximum-rank definition, then champion-specific current producer and consumer checks. |
| `HUD-QWER-STATE-RESOURCE-01` | Current base mana/health/stun state is partial; special ranks, nonmana resources, cost modifiers, toggles/recasts/forms and mask producers remain unqualified. | Qualify one named champion/resource-state path at a time with original caller/config and current ready/blocked/resource/cooldown cases; preserve explicit refusals. | A named champion and primary resource/mask/cost/variant producer contract; 488 metadata rows or an icon are not sufficient. |
| `HUD-QWER-ICON-amumu-01` | The primary DDS is ambiguous, not absent; two different original candidates are retained. | Determine original resource precedence and select bytes proven for the named spell; keep both historical candidates and a comparison receipt. | Original lookup/manifest precedence or native runtime resource trace for amumu; same-filesystem search is not a new lead. |
| `HUD-QWER-ICON-nunu-01` | The primary DDS is ambiguous, not absent; two different original candidates are retained. | Determine original resource precedence and select bytes proven for the named spell; keep both historical candidates and a comparison receipt. | Original lookup/manifest precedence or native runtime resource trace for nunu; same-filesystem search is not a new lead. |
| `HUD-QWER-VARIANT-heimerdinger-01` | HeimerdingerE InventoryIcon2 is missing from the bounded original character/global icon search; primary/other variants are separate. | Recover the exact named variant or prove original alias/fallback with source and trigger; independently qualify dynamic variant selection. | New archive/manifest/alias/caller or variant evidence for HeimerdingerE_E2.dds; no repeated unchanged scan. |
| `HUD-QWER-LEARNING-PANEL-01` | Eight Evolution arrows/frames are consumed; other LevelUpBar elements and native animation/callback/mask producers remain unqualified. | Recover original active-panel/state selection and qualify a single named ordinary learning interaction including no-points, gates, overflow and blocked commands; retain D05 prerequisite links. | Original panel/callback/state producer and identified source/binary plus a named current input scenario; synthetic clicks alone are not OS input parity. |
| `HUD-QWER-RENDER-LIFECYCLE-01` | October captures/tests refer to changed rank/main sources; current GPU/input/resize/session and denominator behavior is not newly executed. | Qualify a pinned current build for the four admitted champions with rank0/max/overflow, unknown/zero/expired/refunded duration, reconnect/session, DPI/resize and failure isolation; record expected/observed and actual resources. | Current pinned build and real graphical/server execution authorization within an implementation task; this audit permits no restart or product changes. |

Ces corrections sont **proposed_not_applied** ; elles n’altèrent pas le goal, ses critères, le registre des tâches ni l’interface de suivi. Les 122 lignes nominatives de couverture évitent de transformer 118 refus en succès implicites. Elles ne déclarent aucun champion complet.

## R6 — Réutilisation et résultats séparés

- Réemploi direct : HUD.zip identique, captures natives antérieures, corpus source inchangé, inventaire Text et identifiants, preuve numérique, sources et shaders du lot invocateurs. Les ressources ambiguës et la variante absente conservent leur recherche bornée antérieure.
- Corrections existantes réutilisées : `NUM-COOLDOWN-PRINTF-01` (formatage/CRT exact), `NUM-KEY-LABEL-01` (producteur/remappage natif), `NUM-CURRENT-RENDER-01` (preuve de rendu courante), `HUD-SUM-ERROR-BOUNDARY-01` (frontière partagée). Aucune duplication d’implémentation.
- Résolu dans l’audit : sélection exacte des fichiers et composants ; relation des champs autoritaires aux consommateurs ; séparation 4 schémas / 122 métadonnées / 486 icônes ; distinction absence/ambiguïté ; identité et limites des preuves antérieures ; reprises précises.
- Ouvert : population native des rangs, 118 schémas non admis, ressources/masques/spécificités de sorts, variantes et priorités de chargement, transitions/callbacks d’apprentissage, preuve GPU/réseau/OS courante, fidélité serveur originale et acceptation humaine.
- Clôture documentaire, réalisation, vérification technique en exécution et acceptation restent indépendantes. Le lecteur peut clore ce lot documentaire tout en laissant la fonctionnalité et le goal incomplets.

## R7 — Livraison, conservation et reproduction

Preuve principale : [qwer-hud-proof.json](F:/OpenLeague-work/audit-units/AUD-17.1-03-QWER-01/qwer-hud-proof.json), 643196 octets, SHA-256 `cb3c05474ef9ada4e7b8c994431ec93748e0602b02be3aea271c2d173032e7a9`. Elle conserve `audit_scope_closed=false` jusqu’au résultat du lecteur indépendant. La référence finale de clôture documentaire est [delivery-readback.json](F:/OpenLeague-work/audit-units/AUD-17.1-03-QWER-01/delivery-readback.json), produit après ce document ; aucun statut normatif n’est modifié.

**Nouveaux fichiers uniquement** : ce rapport et le répertoire isolé `F:\OpenLeague-work\audit-units\AUD-17.1-03-QWER-01` : audit-unit.json, verify_qwer.py, attempt-1-failure.json, verify_qwer_v2.py, qwer-hud-proof.json, verify_delivery.py, delivery-readback.json. Les scripts producteurs utilisent une création exclusive, pour ne remplacer aucune preuve. Ne pas relancer le producteur dans le même dossier : le reçu existant est intentionnellement conservé.

Relecture sans écriture :

```powershell
& 'C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -X utf8 -E -B 'F:\OpenLeague-work\audit-units\AUD-17.1-03-QWER-01\verify_delivery.py' --check-only
```

Avant/après : HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, branche main, 76 fichiers suivis déjà modifiés conservés. Les 19 fichiers de l’intervention logicielle gelée, les six documents de contexte et les cinq registres ont des SHA inchangés. Ce contrôle ne prétend pas hacher des bases de données : aucune base ni application de suivi n’a été ouverte. Aucun goal, critère, application, code produit ou registre n’a été modifié ; aucune installation, migration, relance, suppression ou opération Git de mutation.

Le lot s’arrête sur ses critères documentaires vérifiables. Une suite fonctionnelle nécessite l’une des entrées précises de R5 et une tâche d’implémentation autorisée ; elle ne sera pas inventée pour annoncer un jeu terminé.
