# SYS-01.2-02 — Choix de plateforme graphique, V714

Date : 28 octobre 2026. Projet : F:/OpenLeague. Référence : PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct.

V714 : [General].x3d_platform=0 retrouvé dans le Game.cfg natif et sa copie actuelle. Code original9808C7→9B7590 exécuté :0/1/2 conservés, autres valeurs testées normalisées à1 ;la fabrique directe refuse3/-1. Dix cas réussissent, dont trois refus allocation. Chaînes natives0=Direct3D9,1=OpenGL identifiées ;2 possède une troisième fabrique, comportement rendu encore inconnu. C58 est le choix de fabrique et une entrée de copie ;B04 reste2 tant que le device n est pas construit. Aucun mapping wgpu ni bootstrap complet accepté.

## Sources et chaîne constatée

- Exécutable natif : SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- `DATA/CFG/defaults/Game.cfg`, ligne23 : `[General].x3d_platform = 0`. La copie `data/4.20/configuration/defaults/Game.cfg` est identique, SHA-256 `02c41cb9a5068f8bc993435557fd7b159bddbcda1f022605d284d9ea51d72b0e`. Cette valeur livrée ne prouve pas la configuration effective après overlays.
- Le caller980830 prépare les chaînes General/x3d_platform, appelle8B1C20 puis normalise son résultat à9808C7. Le banc commence à cette normalisation avec un entier déclaré ; il ne simule pas une lecture réelle du fichier.
- La fabrique9B7590 écrit1225C58 et construit le fournisseur retenu. Le caller publie celui-ci dans le renderer+10 à9808F8.
- Valeur0 :9C4BB0→9C4D70→import d3d9.dll!Direct3DCreate9 ;9C3D00 stocke l'interface dans le fournisseur, vtable10E2E2C. Sa méthode+10 est9C3E30, qui appelle le constructeur9C1430 ; son chemin écrit1225B04=0.
- Valeur1 : fournisseur vtable10E2E58, méthode+10=9B62A0. Cette méthode référence wglCreateContext/wglMakeCurrent et appelle9B3D00 ; ce constructeur utilise les imports OPENGL32 et écrit1225B04=1.
- Valeur2 : fournisseur réel de64octets, vtable10E28B8, méthode+10=9B2B70. Sa sémantique graphique reste ouverte. Cette valeur n'est pas un refus automatique.

Les chaînes de device au-delà de la fabrique sont inspectées statiquement, pas exécutées ici. Les instructions de branchement et les sites d'appel retenus sont décodés depuis des débuts alignés. Les recherches brutes d'adresses ont servi seulement à trouver des candidats.

## Contrôles exécutés

| Entrée et chemin | Attendu d'après le code | Observé |
|---|---|---|
| Caller0 | Fabrique0, fournisseur Direct3D9 | Conforme,16octets |
| Caller1 | Fabrique1, fournisseur OpenGL | Conforme,72octets |
| Caller2 | Fabrique2, troisième fournisseur | Conforme,64octets |
| Caller3 et caller-1 | Normalisation vers1 | Conforme,2cas |
| Fabrique directe3 et-1 | Sortie nulle | Conforme,2cas |
| Allocations refusées0/1/2 | Sortie nulle, aucun bloc conservé | Conforme,3cas ;référence COM libérée pour0 |

Dix cas réussissent. Dans chacun,1225C58 est écrit par le code original ;1225B04 reste à2. Aucun de ces deux globals n'est écrit par le banc. Le banc conserve des adaptations explicites de mémoire, cookie, résultat Direct3DCreate9, contexte Cg nul et compteurs COM. **Aucune API graphique réelle, aucun device ou GPU n'est exécuté.**

Le premier essai avait une attente de pile erronée pour les huit cas passant par le caller :9808F3 a déjà poussé la chaîne du prochain appel avant la publication9808F8. Cet échec est conservé. La correction vérifie exactement cet argument et le décalage-4 ; les deux cas directs conservaient déjà le bon résultat.

## Consommateur actuel et écart

Le `WgpuSettings::default` courant construit `Some(Backends::from_env().unwrap_or(default_backends))` ; `RenderCreation::default` choisit Automatic. Ces ancres sont relues et identiques aux sources deV712. L'exécution Vulkan deV712 reste une preuve datée distincte, non répétée ici. Les numéros natifs0/1/2 ne sont pas traduits en bits wgpu.

La présente preuve corrige aussi la portée attribuée à1225C58 : la variable intervient dès le choix du fournisseur graphique, puis dans les chemins de copie déjà étudiés. Elle est distincte de1225B04, publié plus tard par les constructeurs de device. Les anciens reçus restent conservés avec leurs résultats bornés.

## Limites et livraison

- Caller span starts after native integer getter8B1C20 with a declared return value. Source Game.cfg contains0, but effective native config/cache/overlay startup is not executed.
- 9808C7 normalization and9B7590 factory execute, including D3D object constructor9C3D00; allocator,cookie,Direct3DCreate9 return,cgCreateContext null andCOM reference leaves are declared adapters. No actual API or GPU invoked.
- C58 is written by API-factory selection and also used in texture-copy routing;B04 changes later inside device constructors, which are only inspected here. No alias or equality invariant inferred.
- Selector2 has a real third-factory branch. Do not label it unknown input, refusal or absent backend merely because unconfigured texture registration yields FFFFFFFF. Third renderer semantics remain open.
- The first harness wrongly expected no stack delta at9808FB; original9808F3 has pushed a diagnostic string for the next call. Its failures are preserved; corrected probe asserts that exact argument and delta-4.
- Current modern Vulkan renderer evidenceV712 remains separate from historical API selection. No numeric conversion to wgpu flags is inferred.
- Raw E8 and immediate matches were discovery candidates; final call links are checked in aligned decoded function spans. No global absence or complete indirect-call graph is claimed.
- Les imports Direct3DCreate9 et cgCreateContext et les méthodes COM sont des adaptateurs déclarés : handle D3D fictif, contexte Cg nul. La création effective du device historique n est pas testée.
- La recherche x3d_platform dans crates et vendor/bevy_render ne trouve aucun texte littéral ;cela ne prouve pas l absence globale de consommateurs indirects ou calculés. Le consommateur moderne Default/Automatic vérifié lit ses propres options/environnement.
- Le dossier deploy/Config recherché est absent. La recherche sous DATA/CFG et la copie actuelle trouvent Game.cfg:23 ;elle ne prouve pas que ce fichier l emporte sur tous les overlays.
- Les consommateurs globaux, prérequis et inconnues restent conservés ;la nouvelle qualification est limitée aux deux fiches. Le troisième moteur ne reçoit pas un nom inventé.

Cinq mutations sont refusées : mauvais repli, troisième fabrique déclarée absente, faux GPU, faux lecteur de configuration et confusion des deux globals. [Reçu détaillé](fidelity_graphics_platform_selection_v714.json).

Le registre et les deux bases du plan reçoivent des ajouts ciblés à SYS-01.2-02 et SYS-17.3-01. Cases, notes, historiques et autres tâches restent conservés. Aucune exigence n'est marquée terminée et aucun code du jeu n'est changé. Preuve de livraison : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision714_delivery/VERIFIED.json.

Suite : qualifier le lecteur de configuration effectif et la création du device Direct3D9 choisi par le défaut livré, puis inscription978820 avec son wrapper et écran Standard complet. La troisième fabrique reste une entrée distincte à identifier.
