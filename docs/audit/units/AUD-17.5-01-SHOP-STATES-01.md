# AUD-17.5-01-SHOP-STATES-01

UTC : 2026-10-31T03:36:13.708413+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 ; inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Périmètre et recensement
Boutique actuelle :13variantes ShopControl couvrent52boutons ; la molette du panneau ajoute1contrôle. Les53IDs précis ci-dessous sont regroupés en14familles :31sélections catalogue,6sélections inventaire,5catégories et11autres contrôles. P et Close sont deux routes de visibilité comptées une fois. Audit documentaire à relire ; implémentation locale partielle ;29tests CPU hérités et statique ; acceptation humaine non demandée. Le parent et le goal restent ouverts.

Le type déclaré ShopButton(Action) ne remplace pas les consommateurs actuels ShopControl/setup/update. Les31lignes et6slots sont explicitement paramétrés ; aucune réussite GUI individuelle n’est déduite d’un test partagé.

## R2 — Sources et règles
Référence4.20.0.315 EUW/en_GB ; build2014-11-17 17:46:45, fuseau/déploiement non établis ; catalogue officiel4.20.1. Deux jeux de liens source existants conservent questions_closed=0/full_task_scopes_closed=0 : leurs vérifications ne sont pas des audits fonctionnels clos. FoundryItemShop.gfx original, export statique et scripts épinglés ;8DDS sous F sont identiques aux originaux et aux données du runtime conservé. Les anciens cheminsE restent dans les preuves, la copie couranteF est identifiée séparément.

Les33définitions ont une table d’admission achat Map10 ;31autorisées,1038/1058refusées d’après basic.maps+overrides4.20.1. Ce filtre n’interdit pas de conserver/sélectionner un objet legacy en inventaire.33définitions ne sont ni280objets ni849fichiers natifs complets. Locale actuelle des noms/libellés française, référenceen_GB ; catégories5groupes de bonus et recherche64scalaires sont des politiques locales, pas le payload/arbre/alias/temporisation natifs.

La police extraite et les atlas ne qualifient pas glyphes,filtrage,layout dynamique,pixels ou actions originales. Recommandations et undo possèdent des sources/contrats mais leurs contrôles courants restent désactivés/no-op. Rayon1000/vie/règles de boutique du serveur sont locaux, permissions historiques non établies.

## R3 — Consommateurs et états
setup instancie uniquement le catalogue acheté autorisé, six slots et les contrôles communs ; update traite Changed<Interaction>/Pressed si ouvert. selected_action vérifie ready/open/joueur, admission/quote/or pour acheter et slot+item/prix pour vendre. Le moteur revalide vie/distance/boutique/groupe avant mutation. Les apparences utilisent Disabled avant Down puis Selected/Over/Up ; un label disabled absent garde artworkUp+tintlocal au lieu d’inventer un état natif.

| Famille | Variante réelle | Action/état constaté |
|---|---|---|
| SHOP-VISIBILITY | Close | P toggle or Close; Escape only removes text focus ; Panel open flag and same-update close; winner hides |
| SHOP-SEARCH | Search | focus and ordered local text/clipboard input ; Window/focus/activation gates;64Unicode scalars; no native IME parity |
| SHOP-CLEAR | Clear | query empty,category0,search focus cleared ; Local clear operation |
| SHOP-CATEGORY | Category | one of5 local categories ; Selected highlight, reset scroll; numeric bonus grouping not native external tree |
| SHOP-SELECT-ITEM | SelectItem | one of31Map10 catalogue IDs ; Selection allowed independently of affordability; dim row when selected_action buy unavailable |
| SHOP-SELECT-INVENTORY | SelectInventory | one of6 authoritative slots ; Empty cannot select; cached slot+item cleared if changed; legacy global items not purchase-gated |
| SHOP-BUY | BuySelected | buy current inspected item ; Disabled by shared selected_action; server adds life/shop/group guard and may refuse |
| SHOP-SELL | SellSelected | sell selected inventory slot ; Disabled for empty/stale/no sell price; server independently validates |
| SHOP-GRID | Grid | toggle local grid mode ; Selected appearance and scroll reset |
| SHOP-LIST | List | toggle local list mode ; Selected appearance and scroll reset |
| SHOP-ALL | AllItems | active constant AllItems tab ; Selected=true,handler no-op; not the Clear action |
| SHOP-RECOMMENDED | Recommended | visible disabled/no-op ; Native champion recommendation payload/resolver not admitted |
| SHOP-UNDO | Undo | visible disabled/no-op ; No undo Action/history transaction; selling is not undo |
| SHOP-SCROLL | None | catalogue wheel pane ; Own focused window,hovered pane,open and not search focused; clamp range |

Le tableau catalogue peut rester sélectionnable et montrer un bouton achetable alors que le serveur refuse mort/hors boutique/groupe. Comparaison statique conditionnelle, pas nouveau bug GUI observé ni règle native à inventer. Notice affiche erreur générique du collage ou connection.rejection. AllItems reste constamment sélectionné/no-op ; Clear vide query et remet category0, ce ne sont pas la même action.

Texte et molette ont des gates focus/fenêtre propres ; le dispatcher de boutons n’a pas de garde commun fenêtre focalisée/epoch avant le match. Les actions réseau gardent ready via selected_action. La sélection inventaire mémorise slot+item et se retire s’ils changent ou si session/id change ; inspected peut persister. Les politiques d’epoch et de search reset natifs ne sont pas induites.

### Instances précises

| ID | Paramètre/nom | Preuve applicable |
|---|---|---|
| SHOP-VISIBILITY | SHOP-VISIBILITY | Panel open flag and same-update close; winner hides ; analyse du code partagé, pas test GUI individuel |
| SHOP-SEARCH | SHOP-SEARCH | Window/focus/activation gates;64Unicode scalars; no native IME parity ; analyse du code partagé, pas test GUI individuel |
| SHOP-CLEAR | SHOP-CLEAR | Local clear operation ; analyse du code partagé, pas test GUI individuel |
| SHOP-CATEGORY-0 | 0 | Selected highlight, reset scroll; numeric bonus grouping not native external tree ; analyse du code partagé, pas test GUI individuel |
| SHOP-CATEGORY-1 | 1 | Selected highlight, reset scroll; numeric bonus grouping not native external tree ; analyse du code partagé, pas test GUI individuel |
| SHOP-CATEGORY-2 | 2 | Selected highlight, reset scroll; numeric bonus grouping not native external tree ; analyse du code partagé, pas test GUI individuel |
| SHOP-CATEGORY-4 | 4 | Selected highlight, reset scroll; numeric bonus grouping not native external tree ; analyse du code partagé, pas test GUI individuel |
| SHOP-CATEGORY-3 | 3 | Selected highlight, reset scroll; numeric bonus grouping not native external tree ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1001 | Bottes de vitesse | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1004 | Charme féérique | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1006 | Collier rafraîchissant | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1011 | Ceinture du géant | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1027 | Cristal de saphir | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1028 | Cristal de rubis | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1029 | Armure d'étoffe | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1031 | Cotte de mailles | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1033 | Cape de néant | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1036 | Épée longue | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1037 | Pioche | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1042 | Dague | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-3801 | Bracelet cristallin | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1051 | Gants de combat | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1018 | Cape d'agilité | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1053 | Sceptre vampirique | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1026 | Baguette explosive | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1052 | Tome d'amplification | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-3108 | Codex méphitique | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-3114 | Idole interdite | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-3067 | Gemme exaltante | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-3101 | Dardeur | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-3024 | Linceul de glace | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-3134 | Brutaliseur | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-3035 | Dernier souffle | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-3135 | Bâton du vide | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-3136 | Déguisement hanté | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-3020 | Chaussures de sorcier | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-2003 | Potion de soin | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-2004 | Potion de mana | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-ITEM-1055 | Lame de Doran | Selection allowed independently of affordability; dim row when selected_action buy unavailable ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-INVENTORY-0 | 0 | Empty cannot select; cached slot+item cleared if changed; legacy global items not purchase-gated ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-INVENTORY-1 | 1 | Empty cannot select; cached slot+item cleared if changed; legacy global items not purchase-gated ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-INVENTORY-2 | 2 | Empty cannot select; cached slot+item cleared if changed; legacy global items not purchase-gated ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-INVENTORY-3 | 3 | Empty cannot select; cached slot+item cleared if changed; legacy global items not purchase-gated ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-INVENTORY-4 | 4 | Empty cannot select; cached slot+item cleared if changed; legacy global items not purchase-gated ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELECT-INVENTORY-5 | 5 | Empty cannot select; cached slot+item cleared if changed; legacy global items not purchase-gated ; analyse du code partagé, pas test GUI individuel |
| SHOP-BUY | SHOP-BUY | Disabled by shared selected_action; server adds life/shop/group guard and may refuse ; analyse du code partagé, pas test GUI individuel |
| SHOP-SELL | SHOP-SELL | Disabled for empty/stale/no sell price; server independently validates ; analyse du code partagé, pas test GUI individuel |
| SHOP-GRID | SHOP-GRID | Selected appearance and scroll reset ; analyse du code partagé, pas test GUI individuel |
| SHOP-LIST | SHOP-LIST | Selected appearance and scroll reset ; analyse du code partagé, pas test GUI individuel |
| SHOP-ALL | SHOP-ALL | Selected=true,handler no-op; not the Clear action ; analyse du code partagé, pas test GUI individuel |
| SHOP-RECOMMENDED | SHOP-RECOMMENDED | Native champion recommendation payload/resolver not admitted ; analyse du code partagé, pas test GUI individuel |
| SHOP-UNDO | SHOP-UNDO | No undo Action/history transaction; selling is not undo ; analyse du code partagé, pas test GUI individuel |
| SHOP-SCROLL | SHOP-SCROLL | Own focused window,hovered pane,open and not search focused; clamp range ; analyse du code partagé, pas test GUI individuel |

## R4 — Attendu et observé
Exécuté maintenant : lectures/empreintes/recensement et cohérence des sources.29tests existants réutilisés :23client (2sélection,9filtres,12saisie) et6core achat/vente/transactions/refus. Journaux terminaux code0 ;8fichiers source et14données liés au manifeste conservé, dont8DDS et la police. Aucun test relancé, aucun accès au presse-papiers réel, aucune extraction FFDec. Les tests de sélection sont des fonctions pures, les tests de saisie des queues Bevy/closures de collage ; aucun parcours ECS complet shop_ui.update ou GUI du magasin n’est qualifié par eux. Binaires historiques identifiés dans test_jobs, pas qualifiés comme installation courante.

| Cas | Attendu | Observé | Limite |
|---|---|---|---|
| H1 | Cover every currently constructed selector and handler | 13ShopControl variants + wheel;52button instances +1wheel=53logical scopes in14families.31catalogue,6inventory,5category entries named individually. | P and Close share visibility; no final all-HUD denominator. |
| H2 | Only31of33current definitions purchasable on Map10 | Explicit official basic.maps+overrides match33table entries;1038/1058excluded from purchase, inventory actions preserved. | Catalogue metadata not native server rule;33not280or849fully implemented. |
| H3 | Ready/open/player/selected quote or exact slot+item needed | Two retained selection tests cover accepted buy/sell, closed/unready/missing player, insufficient gold and stale item. | Direct helper tests, not actual whole-shop pointer/system execution. |
| H4 | Displayed affordable item does not imply authoritative acceptance | selected_action lacks life/shop distance/group ownership; core guards precede mutation. Six retained core tests cover named nominal/atomic/refusal cases. | Conditional static difference; do not impose a guessed native dead-purchase or radius rule. |
| H5 | Disabled/Down/Selected/Over/Up are distinct | Skins use disabled priority then pressed then selected then hover/up. Missing authored disabled layers fall back to up+local tint; no invented native label. | State tables/static slices not original GPU or native activation parity. |
| H6 | Preserve names,word conjunction,category and admission | Nine retained filter tests cover accents/case/words,combat/magic/utility and excluded items. Five categories hardcode bonuses. | Current French names/search differ referenceen_GB and native aliases/category payload. |
| H7 | Fresh focused owned input, bounded text, no held paste retry | Twelve retained text tests coverCtrlV ordering,AltGr,window/session/focus,UTF16 errors and64scalar limit. | Injected paste closures/Bevy queue; no actual clipboard read in this audit or native IME equivalence. |
| H8 | Text/wheel gates must not be generalized to every button | Text and wheel check own focused window; changed-Interaction dispatch checks pressed/open and buy/sell ready only, no common window focus/epoch predicate. | Source-only gap; Bevy physical event behavior unexecuted; choose policy before correction. |
| H9 | Recommended/Undo remain explicit non-actions | Both handlers no-op and skins always disabled;AllItems always selected/no-op is separate fromClear. | No recommended-page/undo transaction completion claimed. |
| H10 | Slot+item choice clears on identity mismatch/replacement | presentation resets inventory choice for session/id;stale slot mismatch clears. Inspected catalogue ID may remain. | No full count-change/epoch/reconnect selection policy proven; existing SYS07.5-08 retained. |
| H11 | Display server error without pretending precheck is authoritative | send_action error→connection.report;Notice uses clipboard generic error or connection.rejection. Close hides in same frame;winner closes panel. | No per-control reason/privacy or physical close/resize proof. |
| H12 | Reuse exact native resources without calling all native shop behavior complete | OriginalGFX+export scripts and8DDSoriginal/current hashes verified;8code+14data inputs match retained runtime manifest. | Font glyph rasterization/sampler/pixels,root346layout,input provider/remap/tree/recommendations remain unqualified. |

## R5 — Manques et reprise
Restent : permissions natives achats/vente,35restrictions champion et catalogue complet,undo/recommandations,catégories/alias/locale/IME natifs,préchecks UI vs refus serveur,barrière commune de pointeur,selection/epoch,réels glyphes/états/viewport/rendu et parcours réseau du magasin. Les contrôles désactivés restent tels quels ; aucune tentative d’activation par seule présence de texture.

Reprise ciblée : choisir un objet/slot/contrat de mode et une règle locale explicite si l’autorité historique manque. Réutiliser les29tests et8DDS ; préparer seulement le scénario ECS/pointeur/serveur/rendu nommé avec binaire/assets/session/viewport identifiés. Pour recommandations/arbre/undo rechercher le provider/payload/callback discriminant prévu par les tâches existantes ; pas de nouvelle extraction globale sans nouvelle anomalie. Presse-papiers système et données du suivi restent hors action.

## R6 — Travaux restants précis
Douze tâches existantes réellement retrouvées dans le registre et reliées à leurs associations source, sans mutation de statut : SYS-07.1-02, SYS-07.2-01, SYS-07.2-02, SYS-07.2-06, SYS-07.5-01, SYS-07.5-02, SYS-07.5-03, SYS-07.5-04, SYS-07.5-05, SYS-07.5-06, SYS-07.5-07, SYS-07.5-08. Leurs finding/remaining,critères et offsets sont dans related_existing_tasks. Trois sous-tâches documentaires de qualification sont proposées, aucune correction produit appliquée :

- **HUD-SHOP-BUY-FEEDBACK-01** — Qualifier un état Acheter face à un refus de l’autorité. Fin : Choisir règle native qualifiée ou politique locale vie/distance/groupe ; comparer état de bouton/quote et résultat sur un objet nommé. Refus préserve or/IDs/comptes et fournit motif choisi sans fausse réussite ; achat accepté met à jour l’état reçu. Reprise : Reuse pinned source/scripts/DDS and retained29tests; qualify the named missing actual ECS/pointer/authority scenario with current binary/assets/session/viewport. Do not recover the8DDS or export Foundry again without a new discrepancy.

- **HUD-SHOP-SELL-FEEDBACK-01** — Qualifier un état Vendre face à un refus de l’autorité. Fin : Un slot+item courant peut demander vente selon contrat choisi ; vide/remplacé/session incorrecte ou refus d’autorité ne vend pas un autre objet et ne crédite pas à tort. Motif et état du bouton réconciliés avec snapshot ; prix absent reste refusé. Reprise : Reuse pinned source/scripts/DDS and retained29tests; qualify the named missing actual ECS/pointer/authority scenario with current binary/assets/session/viewport. Do not recover the8DDS or export Foundry again without a new discrepancy.

- **HUD-SHOP-POINTER-CONTEXT-01** — Qualifier la barrière commune des pressions dans la boutique. Fin : Définir focus/fenêtre/epoch voulus pour le dispatcher, puis cas Bevy réel Acheter et filtre/recherche avec perte/reprise de contexte ; aucune pression périmée ne devient commande nouvelle. Préserver les gates de texte/molette et l’édition volontaire de query. Reprise : Reuse pinned source/scripts/DDS and retained29tests; qualify the named missing actual ECS/pointer/authority scenario with current binary/assets/session/viewport. Do not recover the8DDS or export Foundry again without a new discrepancy.

Couverture du parent :23IDs antérieurs +53instances boutique distinctes =76sur les sous-périmètres établis.14est le nombre de familles boutique, pas14réussites ou le dénominateur HUD. Dénominateur complet inconnu, aucun pourcentage ; absence d’acceptation par instance conservée. Reste : SYS-17.5-01 remains open: complete HUD census and remaining chat/score/options/inspection/recall/other controls; no denominator/percentage. Native full shop/controller/category/recommendation/undo/search/pixel contracts and per-item semantics remain in existing domain07 tasks. Pointer and buy/sell actual ECS/refusal/render paths remain unqualified; do not count53static control mappings as53completed game functions.

## R7 — Livraison et conservation
Nouveaux fichiers uniquement : audit-unit.json, verify_shop_states.py, shop-states-proof.json, verify_delivery.py, delivery-readback.json et ce rapport. Le lecteur séparé doit relire les sept rubriques et clore seulement ce sous-lot ; producteur audit_scope_closed=false, parent_documentary_scope_closed=false. Audit clos ne termine pas la fonctionnalité, le parent ou le goal.

Cinq registres normatifs,25fichiers protégés (19logiciels gelés +6documents),1168sources et état suivi Git conservés. Aucune modification du goal/des critères, du code produit, de Plan/UI/bases ; aucune base ouverte, installation/migration/restart, exécution native/Rust/jeu/réseau/GUI. Aucun écrasement des anciennes preuves ni retrait implicite.

Preuve : F:\OpenLeague-work\audit-units\AUD-17.5-01-SHOP-STATES-01\shop-states-proof.json. Relecture : F:\OpenLeague-work\audit-units\AUD-17.5-01-SHOP-STATES-01\delivery-readback.json.
