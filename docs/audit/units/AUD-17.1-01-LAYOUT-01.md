# AUD-17.1-01-LAYOUT-01 — Ancrages, proportions et bilan documentaire du HUD

Date : 2026-10-30T20:28:45.433023+00:00. Projet F:\OpenLeague. Lot du goal SYS-01.2-02.

Résultat : les sources et les consommateurs actuels de SYS-17.1-01 sont reliés ; les écarts ont des reprises précises. La relecture indépendante décide de la clôture documentaire de ce lot. Le HUD fonctionnel et le goal demeurent incomplets. Le bilan des huit exigences HUD est conditionné à cette relecture ; il ne modifie aucun statut du suivi.

## R1 — Exigence et frontières

Tâche **SYS-17.1-01 — Reproduire les proportions et ancrages du HUD 4.20**. Exigence **OLF-ba722b0b-ccd0-550e-b9e5-91d0d34fd685** ; inconnue **OLU-f29fa289-30fb-5f21-baea-551b695b9ee4**, laissée ouverte. État normatif conservé : `a_faire`, `implementation_complete=false`, `acceptance_complete=false`. Aucun critère normatif ni texte de goal modifié.

Le lot couvre la chaîne de lecture Rect/Anchor, les champs de géométrie, le viewport et le scalar propriétaire, les limites de groupes, les chemins réels icônes/textes/anneaux et leurs refus. L’audit des pixels complets, des réglages originaux et du cycle OS/GPU est distingué de la simple présence de ces fonctions. La réalisation fonctionnelle n’est pas autorisée implicitement par l’audit.

Phase D17 ; lot D17-SYS-17-1, huit tâches requises. Le prérequis D05-SYS-05-5 est encore `a_faire`, avec D05-SYS-05-1/2 en dépendances. Leur présence n’est pas une validation de leur réalisation. [audit-unit.json](F:/OpenLeague-work/audit-units/AUD-17.1-01-LAYOUT-01/audit-unit.json) fixe portée, résultats attendus et condition d’arrêt. Le tour précédent était un progrès : audit local HP/ressources/stats relu, sans achèvement fonctionnel.

## R2 — Sources et preuves héritées

Référence : LoL 4.20.0.315, PUBLIC/Releases/4.20, EUW/en_GB ; build2014-11-17 17:46:45, fuseau et déploiement non établis ; catalogue4.20.1. Le PE original est identifié, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, sans exécution.

Les deux HUD.zip, original D: et import F:, sont identiques : 122169 octets, SHA-256 `76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c`. FastHUD, liste normale, Scenes et les **32 fichiers** nommés ont leurs identités comparées ; chaque entrée originale est aussi confrontée à l’entrée brute du reçu de boucle natif hérité. L’alias de casse LevelUP/LevelUp est conservé, pas signalé comme fichier perdu.

Les nombres suivants décrivent des frontières différentes :

| Frontière | Résultat hérité confirmé par identité/lecture |
|---|---:|
| Définitions brutes dans les32fichiers | 703 |
| Captures individuelles avec origine/aspect fournis | 702 acceptées, 1 rejetée |
| Boucles de fichiers originaux complets | 677 éléments acceptés |
| Fichiers effectivement sélectionnés avec les2surcouches existantes | 703 états structurels |
| Groupes déclarés dans Scenes | 48 |
| États affectés à ces groupes dans le contrat de limites | 697 |
| Références au groupe non déclaré HUDCenterAbilitys | 6 |

Il est faux de présenter les703états sélectionnés comme703éléments acceptés par les fichiers originaux complets. Le rejet individuel est TargetBar_Buffs.ini, offset11005. LossOfControlUI peut réussir en lecture individuelle avec contexte fourni tout en ne donnant aucun élément dans sa boucle de fichier original : ces contrats ne sont pas interchangeables.

Deux surcouches dérivées **déjà existantes**, réutilisées sans nouvelle réparation :

| Fichier | Entrée originale | Entrée dérivée sélectionnée | Contrôle du fournisseur |
|---|---|---|---|
| TargetBar_Buffs.ini | 39 acceptés / 1 rejet / 7 effets | 40 acceptés / 0 rejet / 8 effets, ajout33octets Color1 | Identité des bytes originaux puis des bytes dérivés confrontée aux deux cas natifs hérités. |
| LossOfControlUI.ini | 0 affectation d’en-tête / 0 élément | 2 affectations / 25 acceptés / 8 effets, préfixe17octets BaseOffset ; **2 avertissements conservés** | Même contrôle exact ; ne pas affirmer une corruption historique à partir de cette différence de contexte. |

Les archives originales restent intactes. Le fournisseur refuse un original ou une surcouche qui ne correspond pas aux entrées qualifiées ; le fixture sert de comparateur, pas de fournisseur caché des ressources.

Contrats hérités, incomplets et **non réexécutés** :

| Rôle | Point natif | Cas distincts selon le reçu | Date de la preuve |
|---|---|---:|---|
| rect | 0x9a2180 | 144 | 2026-10-06T00:12:21.386187+00:00 |
| anchor | 0x9a2000 | 96 | 2026-10-06T00:19:55.440033+00:00 |
| layout | 0x9a4b30 | 576 | 2026-10-06T01:07:41.163179+00:00 |
| bounds | Voir reçu | 1152 | 2026-10-06T02:42:15.624260+00:00 |
| groups | Voir reçu | 89 recherche / 960 liaison | 2026-10-06T02:26:21.568144+00:00 |
| owner | 0x9a3a00 | 2 | 2026-10-06T02:55:12.094356+00:00 |
| viewport | Voir reçu | 12 | 2026-10-06T02:58:05.105938+00:00 |
| file_loop | Voir reçu | 34 | 2026-10-06T02:03:35.301051+00:00 |
| text_batch | 0x9a81b0 | 1210 | 2026-10-06T07:19:56.390700+00:00 |
| text_pixels | 0x99fa40 | 270 | 2026-10-06T07:14:01.885685+00:00 |
| text_projection | 0x99f4bb | 30 | 2026-10-06T07:37:22.911163+00:00 |

Les576cas de transformation emploient quatre viewports : 1024×768,1280×800,1920×1080,2560×1440 ; huit valeurs de flags ; 192 cas sans mouvement et384avec mouvement fourni. Les FP contextes x87/MXCSR sont fournis. Ni cette matrice d’entrées, ni les144cas Rect, ni les96cas Anchor ne prouvent tous les producteurs/configurations/états possibles. Les96fixtures Anchor représentent des mots de stockage32bits issus du scanner ; ils ne qualifient pas un parseur d’entiers malgré un ancien libellé de limite.

## R3 — Chaîne actuelle et limites concrètes

1. **Lecture des champs.** `native_hud_record_population.rs:11` appelle le conducteur de propriétés. `native_hud_property_apply.rs:18-23` relie Anchor à son stockage courant/cache et Rect à sa normalisation4ou6affectations puis origine. La syntaxe du scanner, le stockage, la signification des champs et leur affichage restent des contrats distincts. Ces fragments sont identifiés dans la preuve ; pas une nouvelle exécution du parseur original.
2. **Transformation.** `native_hud_layout.rs:8-29` combine rectangle, ancrages, scale propriétaire, fractions, aspect et snaps. Flags2/0x20 suppriment certaines étapes ; 0x80 sélectionne l’échelle fixe ; 0x1000 supprime seulement le snap horizontal. Le snap vertical demeure. Dimensions0 ou supérieures à32768, entrées non finies et débordement fini final sont refusés côté Rust. Cela n’est pas présenté comme la politique native des entrées non qualifiées.
3. **Viewport.** `native_hud_viewport.rs` initialise scalar1.0 puis prend les dimensions physiques de la fenêtre Bevy. Un changement de dimensions marque les groupes non vides dirty, appelle `refresh_bounds` et enregistre les dimensions après réussite. Dimensions nulles ou inchangées → retour ; une erreur de rafraîchissement conserve l’état précédent. Aucun consommateur d’un réglage utilisateur nommé d’échelle HUD n’a été trouvé dans la recherche bornée. Le préfixe constructeur original ne prouve pas le défaut final de tous les réglages.
4. **Groupes.** `native_zip_provider.rs:91-110` lit Scenes et lie les éléments ; `native_hud_groups::refresh_bounds` → `native_hud_group_bounds` réunit les limites avec les choix d’égalité/signed-zero. Les groupes propres réutilisent leur cache ; les paramètres propriétaire sont fournis. Une union de limites n’est pas un offset de groupe, ni une hiérarchie de rendu animée. Les groupes et horloges originaux complets restent partiels.
5. **Panneaux et utilisateurs réels.** `native_hud_panels::payload` emploie la transformation, les UV, le quad, le shader et le transport UI absolu. Les cadres statiques appellent aussi localement ce payload ; les appels qualifiés le réutilisent pour vie/XP, icônes, rangs, apprentissage, inventaire/glissement, portrait, respawn, passif Ezreal, minimap et verrouillage caméra. Les appels de tests ne sont pas comptés comme chemins de production. Le chargement d’un état n’implique pas qu’il soit sélectionné par un renderer.
6. **Mouvement.** Les quatre chemins directs identifiés — panneaux, texte, anneaux et limites de groupes — passent **include_motion=false, group_offset=None**. La fonction mathématique sait traiter des offsets fournis ; ces chemins ne prouvent aucun producteur d’animation ou déplacement de parent. Il ne faut ni annoncer un mouvement intégré, ni déclarer défectueux un cadre statique à cause de ce choix.
7. **DPI, icônes et texte.** Le panneau exige DPI fini positif, refuse une géométrie non finie/incompatible avec le transport UI aligné sur les axes et divise dimensions physiques parDPI. Le texte traverse `native_hud_text_batch` → `native_hud_text_render` → `font-raster/native_hud_text_draw::pixel_rect` puis la projection. La taille de police/viewport incohérente est refusée. Une matrice de base identité, le facteur diagonal et l’offset UI0,5 sont des entrées actuelles explicites ; la matrice originale complète et le mapping de framebuffer/demi-texel ne sont pas qualifiés.
8. **Refus et caches visibles.** Les cadres statiques, en cas d’échec de payload, reviennent avant de remplacer leurs entités ; d’autres widgets ont des politiques de retrait différentes. Décrire ce comportement ne l’accepte pas comme fallback natif. Les clés de signature et les caches actuels sont visibles dans les fragments ; aucune réussite d’une transition invalide/récupérée n’est inventée.

Recherche de consommateurs bornée : corpus inchangé de **1168 fichiers Rust/launcher** ;43occurrences directes identifiées, dont22dans des contextes de test et21en production. Parmi les21, une est la déclaration de `refresh_bounds`, donc20occurrences d’appel recensées par ces motifs. Le rendu des trois cadres comporte en plus son appel local non qualifié à `payload`, inspecté directement. Ce recensement est une recherche de tokens et une lecture du code, **pas un graphe d’appels compilé exhaustif**. Le motif des contextes de test inclut cfg(all(test,windows)) ; il ne coupe pas la production au simple premier helper cfg(test).

Les six noms source qui référencent HUDCenterAbilitys sont : LossOfControlAbility0Overlay, LossOfControlAbility1Overlay, LossOfControlAbility2Overlay, LossOfControlAbility3Overlay, LossOfControlAbility4Overlay, LossOfControlAbility5Overlay. Ils viennent de LossOfControlUI_AbilityOverlay.ini. L’absence de déclaration dans ce Scenes ne prouve pas une absence de toute création dynamique native ultérieure. Aucune définition ni alias n’a été fabriqué.

## R4 — Vérifications et portée des observations

**328 contrôles documentaires réussis** avec `verify_layout_v3.py`. Ils comparent fichiers, bytes, métadonnées, clauses de code et garde de conservation. La relecture indépendante est séparée. Ces nombres ne sont pas des tests de jeu ou une mesure d’achèvement fonctionnel.

| Cas | Attendu selon les sources lues | Observé et limite |
|---|---|---|
| Nominal rectangle/ancrages | Normalisation/champs/transformation reliés aux renderers réels | Chemins et identités présents ; primitives héritées réutilisées, pas rejouées. |
| Différences de taille/aspect/flags | Quatre tailles natives identifiées, autres classes ouvertes | Matrice576cas conservée ; pas d’extrapolation à toutes les tailles acceptées par l’API. |
| Mouvement activé dans le helper | Paramètres natifs fournis comparés séparément de l’intégration | 384cas natifs hérités ; les quatre chemins courants désactivent mouvement et parent. |
| Dimensions/DPI invalides, overflow | Refus explicites courants | Branches source trouvées ; pas de changement réel OS/fenêtre exécuté. |
| Groupe dirty/propre | Union ou réutilisation du cache selon flags | API et contrat1152cas reliés ; pas de preuve du cycle original GPU/polices/textures. |
| Ressource originale/surcouche divergente | Refus avant adoption silencieuse | Deux comparaisons exactes du fournisseur retrouvées ; surcouches existantes inchangées. |
| Groupe non déclaré | Garder la source et l’inconnue | Six références nommées, aucune création inventée. |
| Réutilisation des anciens audits | Rapports/reçus principaux cohérents et conservés | Sept audits voisins relus par identité et leurs sept rubriques ; aucun ancien test de jeu relancé. |
| Conservation | Même Git suivi, sources gelées et registres | 25 fichiers protégés et cinq registres comparés avant/après ; bases jamais ouvertes. |

Les rapports graphiques du6octobre sont conservés avec leurs dates, binaires et correspondances/dérives de sources. Les anciennes phrases « widgets absent », « pas de runtime bounds refresh » ou « bounds non ported » ne constituent pas l’état actuel : d’autres preuves ultérieures et le code montrent ces acquis. Inversement, un module mathématique inchangé ne qualifie pas le build graphique actuel lorsque main, le fournisseur ou les utilisateurs ont changé.

**Non exécutés** : Cargo/tests Rust, REA, client original, jeu, session réseau, GPU, captures OS/fenêtre ou comparaison original/courant. Les anciennes captures DPI1 et essais CPU àDPI2 restent historiques, pas une transition réelle de moniteur/DPI nouvellement observée. Aucun binaire n’a été créé ou lancé.

Deux échecs du collecteur sont conservés : v1 a comparé une liste vide de rejets à un nombre0 ; v2 a supposé `main_proof` alors que les lecteurs BUFF/TARGET exposent `main_receipt`. Les scripts et reçus d’échec restent inchangés ; v3 normalise seulement ces deux structures et vérifie toujours l’identité complète des preuves. Ces erreurs d’audit ne sont pas des défauts du jeu. Les explorations ont également rencontré des différences de schéma ; les collections ont été inspectées avant l’agrégation finale.

## R5 — Corrections et conditions de reprise

Dix fiches atomiques proposées, **proposed_not_applied**, sans ajout au registre ni cases cochées. Chaque fiche machine ajoute prérequis, sources/limites et preuves nominales/refus à son objectif unique.

| ID | Travail unique | Critère de fin du futur correctif | Entrée nécessaire pour reprendre |
|---|---|---|---|
| `HUD-LAYOUT-PROFILE-01` | Sélection profil/orientation | Retrouver une branche originale de sélection et comparer une transition nommée avec ses entrées et sa liste exacte. | Appelant/réglage/profil original nouveau ; pas un nouvel inventaire des mêmes listes. |
| `HUD-LAYOUT-SCALAR-01` | Réglage de l’échelle HUD | Qualifier plage/défaut/transition du réglage, propagation au propriétaire et invalidation des limites mises en cache. | Producteur original du réglage et contrat courant explicite ; scalar1 fourni ne suffit pas. |
| `HUD-LAYOUT-ELEMENT-MOTION-01` | Mouvement d’un élément nommé | Comparer offset, horloge, activation, interruption et remise à zéro pour cet élément seul. | Contrôleur/horloge original et transition autoritaire nommée, sans durée inventée. |
| `HUD-LAYOUT-GROUP-OFFSET-01` | Offset d’un groupe parent nommé | Qualifier influence active/inactive, parent/enfant et remise à zéro ; ne pas confondre offset et union des limites. | Appelant de mouvement et représentation courante du groupe. |
| `HUD-LAYOUT-RESIZE-LIFECYCLE-01` | Cycle de redimensionnement | Comparer zéro/minimisation/restauration, redimensionnement et dimensions inchangées ou scalar changé, selon une politique d’invalidation qualifiée. | Appelant natif caches/polices/textures ou politique locale acceptée et scénario courant. |
| `HUD-LAYOUT-DPI-01` | DPI réel physique/logique | Capturer un changement DPI nommé avec icônes, texte, positions et zones de clic, face au mapping natif qualifié. | Producteur de dimensions/DPI original et contexte OS/fenêtre/build identifié ; réutiliser NUM-CURRENT-RENDER-01. |
| `HUD-LAYOUT-ASPECT-RANGE-01` | Une classe de résolution/aspect manquante | Comparer ancrages/bords et refus pour cette taille/classe de flags, sans extrapoler aux32768valeurs de la garde API. | Producteur original d’aspect/viewport et nouvelle classe d’entrées explicitement choisie. |
| `HUD-LAYOUT-PROJECTION-01` | Projection géométrique finale | Relier matrice originale, viewport et demi-texel à un oracle numérique de bords/icônes/ancrages glyphes original/courant. | Producteur de matrice/projection et états natifs/courants identifiés ; réutiliser NUM-CURRENT-RENDER-01. |
| `HUD-LAYOUT-UNDECLARED-GROUP-01` | Six références HUDCenterAbilitys | Prouver déclaration, alias, création dynamique ou suppression voulue des six overlays, puis vérifier liaison/refus. | Nouvelle source factory/appelant/liste/trace originale ; réutiliser BUFF-LOSS-CONTROL-01, sans fabriquer un groupe. |
| `HUD-LAYOUT-FAILURE-STATE-01` | Conservation/retrait sur refus de layout | Comparer valide→invalide→récupéré pour cadres et viewport selon le contrat de fallback qualifié ; ne pas appeler valides des coordonnées anciennes. | Appelant de refus original ou politique locale explicitement acceptée et cas courant borné. |

Ne pas répéter une primitive ou une recherche de fichiers inchangés sans piste nouvelle. La reprise doit apporter le producteur, profil, réglage, appelant, source modifiée ou scénario graphique identifié qui permet de décider. Les données absentes demeurent inconnues ; une politique locale future doit être explicitement nommée et acceptée, pas rebaptisée fidélité native.

## R6 — Réemploi et quatre dimensions

Corrections existantes réutilisées pour les parcours de leurs composants : NUM-CURRENT-RENDER-01, HUD-LOCAL-RENDER-01, HUD-QWER-RENDER-LIFECYCLE-01, HUD-SUM-RENDER-LIFECYCLE-01, INV-FULL-RENDER-LIFECYCLE-01, BUFF-LOSS-CONTROL-01, BUFF-LIFECYCLE-RENDER-01 et TARGET-03-FRAME. Les nouvelles fiches isolent les producteurs sous-jacents du layout ; elles ne recréent pas les tâches d’implémentation de chaque composant.

Résolu dans l’audit : séparation des entrées originales/individuelles/dérivées ; rôle des32fichiers,48groupes et6références ; consommateurs actuels ; paramètres mathématiques réellement utilisés ; frontières de réglage, mouvement, DPI et projection ; refus/caches et reprises.

Ouvert fonctionnellement : sélection historique du profil, réglage scalar, mouvements élément/parent, cycle complet de resize, classes de taille/aspect non couvertes, mapping DPI/projection, six références à un groupe non déclaré et fallback actuel. Leur documentation permet la clôture de l’audit ; elle ne ferme aucune de ces inconnues par substitution.

Les dimensions demeurent indépendantes : **audit documentaire**, **réalisation**, **vérification en exécution**, **acceptation humaine**. Ici réalisation non complète, exécution nouvelle non effectuée, acceptation humaine non donnée. La clôture globale SYS-01.2-02 ne se déduit pas de ce lot ou de la somme des cas hérités.

## R7 — Livraison et bilan du lot D17-SYS-17-1

[Preuve principale](F:/OpenLeague-work/audit-units/AUD-17.1-01-LAYOUT-01/layout-proof.json), 288744 octets, SHA-256 `369120bb01a5dce05f6e57890781ae17551c96b1e89bb346bad7d839999f7bc1`. Elle garde `audit_scope_closed=false`. Le [reçu indépendant final](F:/OpenLeague-work/audit-units/AUD-17.1-01-LAYOUT-01/delivery-readback.json) décide du résultat des sept rubriques et du bilan ci-dessous.

| Exigence unique | Preuve de référence | Résultat séparé |
|---|---|---|
| SYS-17.1-01 | Présent rapport et relecture indépendante | À clore par le lecteur ; fonctionnalité non complète |
| SYS-17.1-02 | [AUD-17.1-02-LOCAL-POOLS-01](F:/OpenLeague/docs/audit/units/AUD-17.1-02-LOCAL-POOLS-01.md) | Audit documentaire clos ; fonctionnalité non complète |
| SYS-17.1-03 | [AUD-17.1-03-QWER-01](F:/OpenLeague/docs/audit/units/AUD-17.1-03-QWER-01.md) | Audit documentaire clos ; fonctionnalité non complète |
| SYS-17.1-04 | [AUD-17.1-04-SUMMONERS-01](F:/OpenLeague/docs/audit/units/AUD-17.1-04-SUMMONERS-01.md) | Audit documentaire clos ; fonctionnalité non complète |
| SYS-17.1-05 | [AUD-17.1-05-INVENTORY-01](F:/OpenLeague/docs/audit/units/AUD-17.1-05-INVENTORY-01.md) | Audit documentaire clos ; fonctionnalité non complète |
| SYS-17.1-06 | [AUD-17.1-06-BUFF-DURATION-01](F:/OpenLeague/docs/audit/units/AUD-17.1-06-BUFF-DURATION-01.md) | Audit documentaire clos ; fonctionnalité non complète |
| SYS-17.1-07 | [AUD-17.1-07-TARGET-01](F:/OpenLeague/docs/audit/units/AUD-17.1-07-TARGET-01.md) | Audit documentaire clos ; fonctionnalité non complète |
| SYS-17.1-08 | [AUD-17.1-08-COUNTERS-01](F:/OpenLeague/docs/audit/units/AUD-17.1-08-COUNTERS-01.md) | Audit documentaire clos ; fonctionnalité non complète |

Règle de mesure : dénominateur **8 tâches atomiques requises** du lot, sans parent/phase, sans compter une seconde fois le fragment COUNT de l’inventaire, sans compter les versions de reçus ou les cas natifs comme des tâches. Numérateur avant la présente relecture : **7 audits documentaires clos**. Il devient **8/8 uniquement si cette relecture réussit** et vérifie les sept autres reçus et leurs rapports. Le reçu final conserve la matrice nominative des huit tâches.

Ce bilan concerne le lot HUD, **pas l’ensemble de D17 ni le jeu**. Aucun pourcentage du jeu terminé, aucune conversion en acceptation humaine et aucun changement de statut normatif. Le critère de sortie fonctionnel du lot exige toujours les réalisations et acceptations requises ; il reste non satisfait. Les autres lots/domaines et le goal global restent à traiter selon leurs preuves propres.

Nouveaux fichiers uniquement : ce rapport, audit-unit.json, verify_layout.py, attempt-1-failure.json, verify_layout_v2.py, attempt-2-failure.json, verify_layout_v3.py, layout-proof.json, verify_delivery.py et delivery-readback.json dans le répertoire isolé du lot. Les producteurs utilisent la création exclusive et ne remplacent aucune ancienne preuve.

Relecture sans écriture :

```powershell
& 'C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe' -X utf8 -E -B 'F:\OpenLeague-work\audit-units\AUD-17.1-01-LAYOUT-01\verify_delivery.py' --check-only
```

HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, main, 76 fichiers suivis déjà modifiés conservés. Les19fichiers logiciels gelés, les six documents de contexte et les cinq registres gardent leurs empreintes. Aucun goal, critère, registre/statut, code produit, application ou base n’est modifié ; aucune base ouverte. Aucune installation, migration, relance, suppression ou opération Git de mutation. Les prochaines actions anciennes des documents gelés restent historiques ; les reprises de ce rapport constituent l’index nouveau de ce lot.
