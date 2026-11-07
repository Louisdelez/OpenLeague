# AUD-17.1-02-LOCAL-POOLS-01 — Vie, ressources et statistiques locales

Date : 2026-10-30T20:11:39.327288+00:00. Projet F:\OpenLeague. Objectif d’audit SYS-01.2-02.

Résultat : la source et le consommateur actuel de chaque clause de SYS-17.1-02 sont identifiés, ou leur absence est constatée dans le corpus borné avec reprise précise. La clôture documentaire est prononcée uniquement par la relecture indépendante finale. **Fonctionnalité partielle ; aucune acceptation humaine ni complétude du goal.** Aucun code du jeu n’a été corrigé dans ce lot.

## R1 — Exigence et périmètre

- Tâche **SYS-17.1-02 — Afficher vie, ressource et statistiques du champion local** ; exigence **OLF-428eafef-fa5c-5795-a574-92ef8c9ace9c** ; inconnue **OLU-7b097a72-6f04-5369-b5ef-cb2eb624f8dd**, laissée ouverte.
- Statut normatif `a_faire`, réalisation et acceptation `false`, conservés. Aucun critère normatif ni objectif de goal n’est modifié.
- Phase D17, lot D17-SYS-17-1 ; prérequis déclaré D05-SYS-05-5, encore `a_faire`, qui requiert D05-SYS-05-1/2. Les exigences SYS-05.4 et SYS-05.5 associées restent distinctes.
- Portée : vie/mana/absence de ressource, six statistiques ordinaires du HUD local, textes de régénération, jauges spéciales et leurs données ; niveau/XP comme contexte adjacent explicitement examiné. Les inventaires, compteurs, cible et sorts ont leurs preuves précédentes, réutilisées sans rouvrir leurs contrôles inchangés.
- Fin de lot : cinq fichiers originaux, 114 définitions classées, 26 identifiants Text conservés ; provenance native/export de 122 personnages ; consommateurs réels et limites ; corrections atomiques ; sept rubriques relues. [audit-unit.json](F:/OpenLeague-work/audit-units/AUD-17.1-02-LOCAL-POOLS-01/audit-unit.json) définit cette portée, sans changer les critères du projet.
- Tour précédent : progrès vérifié, lot QWER relu et fermé documentairement, fonctionnalité demeurée partielle. Pas de processus actif à attendre ni à relancer.

## R2 — Sources, provenance et pièges évités

Référence : LoL 4.20.0.315, PUBLIC/Releases/4.20, EUW/en_GB, build 2014-11-17 17:46:45 ; fuseau et date de déploiement non établis ; catalogue 4.20.1. Le PE original identifié par SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` n’est pas exécuté.

Les deux HUD.zip, original D: et import F:, sont identiques : 122169 octets, SHA-256 `76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c`. Les cinq membres étudiés sont sélectionnés par la liste normale. Leurs captures natives antérieures sont acceptées et retrouvées par fichier, SHA, offset, nom et groupe ; aucune nouvelle exécution native n’est revendiquée.

| Membre HUD/Elements | Octets | Icon/Effect/Text | Sélections locales de ce lot |
|---|---:|---:|---:|
| CenterHUD_HealthBar.ini | 4133 | 10/1/2 | 5 |
| CenterHUD_PARBar.ini | 4019 | 11/0/2 | 6 |
| ShadowIslesCenterHUD_BG.ini | 653 | 2/0/0 | 2 |
| ShadowIslesChampionLeft.ini | 20826 | 37/15/16 | 5 |
| ChampionLeft_Stats.ini | 4873 | 12/0/6 | 0 |

Total **114 définitions : 72 Icon, 16 Effect, 26 Text**. Les chemins locaux étudiés sélectionnent **18 sources** : onze barres/fonds, trois Text HP/MP/niveau et quatre sprites XP. Les **96 autres définitions** sont conservées comme adjacentes ou champs précisément non alimentés. Une absence de sélection dans ce lot n’est pas une preuve globale d’une fonctionnalité manquante : Gold, inventaire, portrait, cadres et respawn disposent notamment d’autres consommateurs. Les neuf membres contenant « Stats » comprennent deux fichiers normaux, local et cible ; les sept autres sont des variantes/positions/locales non sélectionnées par cette liste, pas sept ressources perdues.

La preuve existante [V78 ressources et HUD](F:/OpenLeague/docs/FIDELITY_RESOURCE_HUD_LINKS_4_20.md), datée du 22 octobre, est réutilisée. Ses **122 exports JSON décodés et 122 INIBIN originaux** ont été relus et hachés maintenant. Les correspondances natives aux manifestes sont héritées, pas une nouvelle qualification du montage historique. Les valeurs du catalogue et les types correspondent aux associations déjà établies.

Deux identités différentes : `champion_resources.json.source_sha256` identifie le **Stats JSON décodé**, pas l’INIBIN. Les deux provenances sont reliées dans `resource_provenance_bridges`. Les 122 différences qu’une comparaison brute de ces empreintes produirait ne prouvent donc aucune corruption. Aucun fichier de données n’a été « réparé » sur cette fausse base.

Les **102 Mana sont des défauts locaux**, avec `PARType` absent dans les champs originaux examinés. Le producteur du défaut Mana natif reste non qualifié. Les **20 autres types sont explicites** : six None, cinq Energy et neuf types spéciaux individuels. Les effectifs sont ceux du catalogue courant, sans convertir un défaut local en champ natif récupéré.

La précision existante est préservée : Janna, Nami, Sona et Soraka présentent une différence d’un ULP pour BaseStaticMPRegen face au lecteur analytique. L’octet compressé18 et le parseur original hérité donnent les bits actuels ; ils ne doivent pas être normalisés aveuglément. La preuve déplacée E:\OpenLeague → F:\OpenLeague conserve son SHA ; aucune exécution du parseur natif n’a été répétée.

Identifiants Text antérieurs conservés :

| Nom | ID stable | Route de ce lot ou contexte |
|---|---|---|
| HPStat | HUD-955a99641a30104e | native_hud_widgets |
| HPRegenStat | HUD-ec34ea9ead561483 | Non sélectionné par les chemins étudiés |
| MPStat | HUD-495804d53d5798e4 | native_hud_widgets |
| MPRegenStat | HUD-20bd91a0ff2e5b19 | Non sélectionné par les chemins étudiés |
| AvatarName | HUD-7ee04347822d5f2e | Non sélectionné par les chemins étudiés |
| GoldStat | HUD-8a03e123a0fbd692 | Adjacent ; route antérieure native_numeric |
| InventoryItemCount0 | HUD-0beb3b9c91219326 | Adjacent ; route antérieure inventory_counts |
| InventoryItemCount1 | HUD-17405556e9e2f00f | Adjacent ; route antérieure inventory_counts |
| InventoryItemCount2 | HUD-6443198d215a09e9 | Adjacent ; route antérieure inventory_counts |
| InventoryItemCount3 | HUD-02800e58ae94dedf | Adjacent ; route antérieure inventory_counts |
| InventoryItemCount4 | HUD-bbe4d1848f3d616c | Adjacent ; route antérieure inventory_counts |
| InventoryItemCount5 | HUD-09cb9d00cf6e3acf | Adjacent ; route antérieure inventory_counts |
| LevelStat | HUD-b194ef5344755925 | native_hud_widgets |
| RespawnTimer | HUD-64cd6a559b724b96 | Adjacent ; route antérieure native_numeric |
| InventoryItemHotKey0 | HUD-ee65e713d4fe21bf | Non sélectionné par les chemins étudiés |
| InventoryItemHotKey1 | HUD-515c49247bfff404 | Non sélectionné par les chemins étudiés |
| InventoryItemHotKey2 | HUD-b2d0d8e9dbf77e90 | Non sélectionné par les chemins étudiés |
| InventoryItemHotKey3 | HUD-428f35f2cd803be0 | Non sélectionné par les chemins étudiés |
| InventoryItemHotKey4 | HUD-9b2c2cd7445c9734 | Non sélectionné par les chemins étudiés |
| InventoryItemHotKey5 | HUD-93009f00239715d6 | Non sélectionné par les chemins étudiés |
| ADStat | HUD-6373aafbebd748eb | Non sélectionné par les chemins étudiés |
| APStat | HUD-dd2d6fc546922646 | Non sélectionné par les chemins étudiés |
| ASStat | HUD-228b9d026608ed34 | Non sélectionné par les chemins étudiés |
| MSStat | HUD-b6c00dd61c33a696 | Non sélectionné par les chemins étudiés |
| ArmorStat | HUD-0b75a032333a3f74 | Non sélectionné par les chemins étudiés |
| MRStat | HUD-16cb272ee73c4bbc | Non sélectionné par les chemins étudiés |

## R3 — Consommateurs réels et limites

**Vie et ressource.** `native_hud_bars.rs:9-11` prend le joueur propriétaire du snapshot. Vie/capacité viennent de `Champion.health/max_health`. Mana utilise `mana` et `max_mana: Option<f32>` ; absence de capacité → refus explicite. `lib.rs:776` ajoute la capacité calculée par `Simulation::stats`. Les snapshots anciens restent inconnus, sans capacité reconstruite côté affichage. `native_resource_snapshot.rs` contient des tests de croissance/objets/transport/compatibilité, cités comme source et non exécutés maintenant.

`native_hud_pool_numbers.rs:3-15` applique ceil à la vie et floor à la mana, puis division des compteurs arrondis. Négatif, non fini ou débordement signé32 sont refusés ; capacité arrondie≤0 est explicitement non intégrée. Le clamp0..1 en surcapacité est une politique locale, pas le comportement prétendu du fragment natif qui ne clampait pas les ratios testés. Les nombres affichés utilisent les mêmes arrondis ; le format original exact reste un correctif distinct.

**Sélection des barres.** Onze sources sont chargées, pas onze composants toujours visibles. Mana sélectionne théoriquement dix composants ; None sept avec EmptyPARBar ; un type spécial six, sans jauge MP ni EmptyPARBar. Ce sont des décomptes issus des branches source, pas des mesures d’exécution. Les 14 jauges spéciales sont masquées ; elles ne deviennent pas des jauges mana. None est une absence explicite de ressource primaire, pas la preuve que tous ses sorts sont gratuits ou qu’aucune mécanique secondaire n’existe.

**Six statistiques.** `ChampionLeft_Stats.ini` contient six Text et douze icônes/zones. Le sélecteur courant des 18 textes (`native_hud_widgets.rs:66-76`) ne les prend pas. Le sélecteur générique de panneaux ne prend que des cadres nommés. Une recherche exacte des huit noms de valeurs/regen, six icônes et du fichier de stats ne trouve aucun consommateur dans les **1168 fichiers** du corpus inchangé Rust + launcher. Cette recherche bornée et les sélecteurs inspectés établissent l’absence de liaison native étudiée ; ils ne prouvent pas une absence de toute statistique du moteur ou d’un futur mécanisme générique.

`progression.rs:17/68` possède bien Stats et son calcul actuel, avec objets, niveau et effets. Cela ne suffit pas à alimenter le HUD : la structure Stats n’est pas un DTO HUD déjà sérialisé et ses six Text n’ont pas de liaison trouvée. Le nombre AS natif ne doit pas être déduit comme fidèle à partir des seuls ticks quantifiés d’attaque.

| Text natif | ID conservé | Candidat core actuel, pas contrat d’affichage | Correction proposée |
|---|---|---|---|
| ADStat | HUD-6373aafbebd748eb | damage | `HUD-LOCAL-STAT-ADStat-01` |
| APStat | HUD-dd2d6fc546922646 | ability_power | `HUD-LOCAL-STAT-APStat-01` |
| ASStat | HUD-228b9d026608ed34 | attack_cooldown_ticks; not qualified as exact attack-speed display | `HUD-LOCAL-STAT-ASStat-01` |
| MSStat | HUD-b6c00dd61c33a696 | move_speed | `HUD-LOCAL-STAT-MSStat-01` |
| ArmorStat | HUD-0b75a032333a3f74 | armor | `HUD-LOCAL-STAT-ArmorStat-01` |
| MRStat | HUD-16cb272ee73c4bbc | magic_resist | `HUD-LOCAL-STAT-MRStat-01` |

**Régénération.** `regeneration.rs:10` fournit des taux serveur ; leur application ajoute aussi passif et multiplicateur de soins à la vie. `HPRegenStat` et `MPRegenStat` restent non liés. Un taux appliqué en simulation n’établit ni l’unité affichée (seconde ou cinq secondes), ni les modificateurs inclus, ni le format natif. Ne pas multiplier arbitrairement par5. Les quatre cas de précision existants restent conservés.

**Niveau/XP.** LevelStat a une liaison réelle. `native_hud_experience.rs` sélectionne XPBar, overlay et deux embouts, lit expérience/niveau autoritaires, valide niveau1..18 et valeurs finies, calcule les seuils depuis l’export Map10 et rend la barre pleine au niveau18. L’INIBIN Map10 original est identifié : 200 octets ; l’export désigne son chemin. Les niveaux19/20 présents dans les données de courbe ne prouvent pas un plafond natif20. Le plafond courant18, les accessors originaux, le highlight/tooltip et la comparaison exhaustive des seuils au parseur original restent des frontières distinctes. XPBarHighlight non sélectionné n’est pas automatiquement un effet obligatoire pour tous les états.

**Transport et erreurs.** Les sources du transport session/legacy, du contrôle de session et du commit snapshot sont réutilisées depuis la relecture QWER. Leur corpus n’a pas changé. Une capacité inconnue ou un autre champ invalide peut effacer les barres ; la fonction commune des valeurs peut également effacer les 18 Text, y compris des labels sans rapport. La frontière souhaitée du refus/fallback natif est à qualifier ; aucune isolation nouvelle n’est inventée. La restauration après reconnexion reste SYS-05.5-05.

## R4 — Attendu, observé et vérifications réellement exécutées

**1248 contrôles documentaires réussis** par `verify_local.py` : identités, métadonnées, captures antérieures, classifications, correspondances export/INIBIN, assertions de code et conservation. Ce compte n’est pas une mesure de jeu terminé. La relecture indépendante finale contrôle de nouveau ces liens et émet un reçu séparé.

| Cas | Attendu d’après la source lue | Observé et limite |
|---|---|---|
| Nominal HP/MP et propriétaire | Vie arrondie vers le haut, mana vers le bas ; capacité autoritaire requise | Fonctions/DTO/sélecteurs reliés ; 11 sources de barres présentes. Pas de match rejoué. |
| Mana102, None6, spéciaux14 | Déclinaisons distinctes et aucune substitution mana | Catalogues et 122 ponts vérifiés ; 102 défauts locaux restent non qualifiés nativement. |
| Propriétaire absent | Aucune valeur ; retrait des entités | Branches trouvées dans le code ; pas de simulation de reconnexion exécutée. |
| Valeur négative/non finie/débordement | Erreur explicite | Conditions présentes ; les fragments natifs hérités ne qualifient pas ces entrées. |
| Capacité absente ou arrondie0 | Refus explicite | Option inconnue et branche zéro identifiées ; comportement natif complet encore ouvert. |
| Surcapacité | Fill borné actuellement | Clamp local lu ; pas revendiqué comme une règle native. |
| Six stats + deux regen | Une source ne devient pas une valeur affichée sans binding | 8 Text disponibles ; recherche bornée et sélecteurs constatent l’absence de liaison. |
| GainXP/18/19-20 | XP courant contrôlé1..18 ; données de courbe séparées de la politique de plafond | Quatre sprites et source de progression existent ; transitions graphiques non rejouées. |
| Identités JSON et INIBIN | Conserver deux SHA de deux formats | 244 fichiers relus ; aucune fausse corruption déclarée. |
| Conservation | Acquis et registres inchangés | 25 fichiers protégés, cinq registres et Git comparés avant/après ; aucune base ouverte. |

Preuves héritées, **non réexécutées** : conversion/ratios110 cas, santé13 cas, XP64 cas. Leurs paramètres/accessors fournis, la population du type de ressource et l’ensemble du contrôleur natif restent limités. L’ancien document health_rounding mentionne encore un affichage santé floor : ce commentaire est périmé face à l’intégration ceil actuelle, déjà présente dans la preuve de ratios ultérieure.

Les sources actuelles des barres, du helper de nombres et de l’XP correspondent aux identités de certaines preuves du 6 octobre. Les sources widgets/main ont changé : ces sous-ensembles inchangés sont réutilisables ; ils ne qualifient pas l’intégration graphique courante. Les anciennes captures de départ Garen/Ahri et les comptes de tests d’octobre restent datés, avec leurs binaires et limites enregistrés. Captures non réinspectées maintenant.

**Non exécutés** : Cargo/tests Rust, jeu, client original, REA, réseaux réels, GPU, entrées OS, rendu comparatif original/courant et acceptation humaine. Aucun changement fonctionnel à tester n’a été autorisé. Les recherches de consommateurs ont d’abord rencontré des chemins présumés absents ; l’inventaire a permis de retrouver les fichiers réels progression.rs et regeneration.rs. Aucune absence fonctionnelle n’a été déduite de ces chemins inexistants.

## R5 — Petites corrections et conditions de reprise

Les **28 corrections proposées** restent `proposed_not_applied`. Chaque fiche machine a objectif unique, manque, prérequis, résultat de fin, preuve attendue et entrée précise de reprise. Elles n’ajoutent aucune case ni statut au suivi.

Pour chacune des 14 jauges nommées ci-dessous : identifier le producteur autoritaire propre au champion et son contrat natif ; qualifier le payload courant/capacité, la présentation et les cas vide/partiel/plein/reset/inconnu, sans fallback mana. Reprise seulement avec ce producteur/contrôleur et le prérequis mécanique existant ; capacité de base ou remise à zéro seule ne suffit pas. Les fiches concernent la liaison HUD, sans reconstruire implicitement tout le champion.

| Champion | Type explicite | Sous-correction HUD précise | Prérequis existant à réutiliser |
|---|---|---|---|
| aatrox | BloodWell | `HUD-LOCAL-RESOURCE-aatrox-01` | SYS-05.4-08 |
| akali | Energy | `HUD-LOCAL-RESOURCE-akali-01` | SYS-05.4-02 |
| gnar | Gnarfury | `HUD-LOCAL-RESOURCE-gnar-01` | SYS-05.4-03 |
| kennen | Energy | `HUD-LOCAL-RESOURCE-kennen-01` | SYS-05.4-02 |
| leesin | Energy | `HUD-LOCAL-RESOURCE-leesin-01` | SYS-05.4-02 |
| mordekaiser | Shield | `HUD-LOCAL-RESOURCE-mordekaiser-01` | SYS-05.4-08 |
| renekton | Rage | `HUD-LOCAL-RESOURCE-renekton-01` | SYS-05.4-03 |
| rengar | Ferocity | `HUD-LOCAL-RESOURCE-rengar-01` | SYS-05.4-04 |
| rumble | Heat | `HUD-LOCAL-RESOURCE-rumble-01` | SYS-05.4-05 |
| shen | Energy | `HUD-LOCAL-RESOURCE-shen-01` | SYS-05.4-02 |
| shyvana | Dragonfury | `HUD-LOCAL-RESOURCE-shyvana-01` | SYS-05.4-04 |
| tryndamere | Battlefury | `HUD-LOCAL-RESOURCE-tryndamere-01` | SYS-05.4-04 |
| yasuo | Wind | `HUD-LOCAL-RESOURCE-yasuo-01` | SYS-05.4-08 |
| zed | Energy | `HUD-LOCAL-RESOURCE-zed-01` | SYS-05.4-02 |

Pour chacun des six champs du tableau R3 : retrouver unités, arrondi et composition base/bonus du contrôleur natif, puis une valeur autoritaire typée et sa liaison à l’ID Text conservé. Fin : cas nominal, inconnu, invalide et variation vérifiés pour ce champ seul. Le candidat core est un point de recherche, pas une valeur fidèle acceptée. Ces six sous-corrections ne remplacent pas la tâche parente.

Autres travaux indépendants :

| Correction | Objectif | Fin du futur correctif | Nouvelle entrée de reprise |
|---|---|---|---|
| `HUD-LOCAL-REGEN-HPRegenStat-01` | Display only HPRegenStat from its identified rate. | Qualify native per-second/per5seconds units, included modifiers/passives, authoritative rate and formatting; verify zero/positive/invalid/item/level changes without normalizing the four inherited byte18 cases. | Named original HPRegenStat producer/format and current owner rate payload; current totals and healing application alone are insufficient. |
| `HUD-LOCAL-REGEN-MPRegenStat-01` | Display only MPRegenStat from its identified rate. | Qualify native per-second/per5seconds units, included modifiers/passives, authoritative rate and formatting; verify zero/positive/invalid/item/level changes without normalizing the four inherited byte18 cases. | Named original MPRegenStat producer/format and current owner rate payload; current totals and healing application alone are insufficient. |
| `HUD-LOCAL-TRAIL-HP-01` | Qualify only HP lost/tip/highlight presentation. | Recover original trigger/timing/interpolation and compare named damage/heal or spend/restore sequences against the current state without invented delay constants. | Original HP visual controller and timestamped current state changes, including cap/reset behavior. |
| `HUD-LOCAL-TRAIL-MP-01` | Qualify only MP lost/tip/highlight presentation. | Recover original trigger/timing/interpolation and compare named damage/heal or spend/restore sequences against the current state without invented delay constants. | Original MP visual controller and timestamped current state changes, including cap/reset behavior. |
| `HUD-LOCAL-ZERO-CAPACITY-01` | Define the native zero-rounded-capacity display branch. | Recover native branch and qualify HP/MP zero-rounded maximum separately, preserving nonfinite/negative/signed32 refusals. | Original caller for zero capacity and named current representation; positive finite ratio slices do not supply it. |
| `HUD-LOCAL-XP-TRANSITIONS-01` | Qualify current level/XP transitions and highlight state. | Pin a current build and source XP policy, then verify gain/threshold reset/level18 and invalid states; treat authoredLevel19/20 as curve data, not evidence of a level20 rule. | Named original XP actor/cap/highlight producer and current gain/level transition scenario. |
| `HUD-LOCAL-NUMERIC-ERROR-01` | Document and qualify failure boundaries between local pools and unrelated HUD texts. | Identify intended native refusal/fallback scope and verify a named bad-field case while preserving unknown data and unrelated valid labels as the qualified contract requires. | Original error/fallback contract or explicit accepted local policy plus a current bounded failure scenario. |
| `HUD-LOCAL-RENDER-01` | Qualify the current local health/resource/stat presentation. | Use pinned build/assets to check one named admitted champion at a time through damage/heal/cast/regen/death/respawn/item/level and DPI/resize; record actual expected/observed screenshots and retain refusals. | Current build and authorized real graphical/server scenario; no new execution is authorized by this audit alone. |

Les conditions de reprise excluent de refaire les recherches de fichiers inchangées ou d’exécuter de nouveau les mêmes fragments natifs pour gonfler les preuves. Une nouvelle source, un producteur/format précis, un code changé ou un scénario actuel identifié doit changer la décision possible.

## R6 — Réemploi et résultats séparés

Corrections/tâches existantes réutilisées : **NUM-POOL-FORMAT-01**, **NUM-CURRENT-RENDER-01**, **SYS-05.4-01**, **SYS-05.4-02**, **SYS-05.4-07**, **SYS-05.4-08**, **SYS-05.5-05**. Les autres tâches de familles de ressources sont reliées par les sous-fiches nominatives. Le défaut Mana natif n’est pas une nouvelle anomalie inventée ; son inconnue et ses conditions sont reprises de V78. Les 26 IDs Text ne sont pas recréés.

Résolu dans cet audit : provenance exacte des données, sélection et masquage actuels, relation entre capacités serveur et valeurs locales, distinction core/binding/transport/rendu, limites du cas XP, recherche bornée des champs non alimentés et entrées de correction précises. Aucun calcul de mana, arrondi santé, texture, courbe ou code déjà intégré n’est réécrit.

Restent ouverts : défaut natif Mana, 14 jauges spéciales, six statistiques et deux textes de régénération, branche zéro, effets de perte/tips et producteurs originaux, politique de refus partagé, formats natifs et preuve intégrée actuelle. Les résultats **audit**, **implémentation**, **vérification en exécution** et **acceptation humaine** demeurent indépendants. Ce lot peut être clos documentairement avec ces manques ; SYS-17.1-02 et le goal ne deviennent pas des fonctionnalités terminées.

## R7 — Livraison et conservation

[Nouvelle preuve principale](F:/OpenLeague-work/audit-units/AUD-17.1-02-LOCAL-POOLS-01/local-pool-stats-proof.json), 907731 octets, SHA-256 `161c9e94a96096fb6b04da340bfa69d5aada14fc186ca2243c368ac5e3892aad`. Elle conserve `audit_scope_closed=false` jusqu’à la [relecture indépendante](F:/OpenLeague-work/audit-units/AUD-17.1-02-LOCAL-POOLS-01/delivery-readback.json). Le résultat de cette relecture fait autorité uniquement pour la clôture documentaire de ce lot.

Nouveaux fichiers uniquement : ce rapport, audit-unit.json, verify_local.py, local-pool-stats-proof.json, verify_delivery.py et delivery-readback.json dans le dossier isolé du lot. Les producteurs créent les fichiers exclusivement ; ne pas relancer un producteur dans le même dossier en remplaçant ses preuves.

Relecture sans écriture :

```powershell
& 'C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -X utf8 -E -B 'F:\OpenLeague-work\audit-units\AUD-17.1-02-LOCAL-POOLS-01\verify_delivery.py' --check-only
```

HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, branche main, 76 fichiers suivis déjà modifiés conservés. Les 19 fichiers logiciels gelés, six documents de contexte et cinq registres ont les mêmes empreintes avant/après. Aucun goal, critère, code produit, suivi, registre ou base n’est modifié. Aucune base ouverte, aucun programme relancé, aucune installation/migration, suppression ou opération Git de mutation. Les documents de contexte gelés restent inchangés même lorsque leurs prochaines actions sont anciennes ; ce rapport est le nouveau point de reprise de ce lot.
