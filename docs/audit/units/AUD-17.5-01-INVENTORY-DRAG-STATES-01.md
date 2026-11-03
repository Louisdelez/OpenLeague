# AUD-17.5-01-INVENTORY-DRAG-STATES-01

UTC : 2026-10-31T03:01:23.827021+00:00. Parent SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46. Inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Périmètre
Audit du geste INVENTORY-DRAG sur les six emplacements actuels : actif, indisponible, annulé, envoyé et refusé. Une commande logique, distincte des six commandes d’utilisation déjà auditées. Audit documentaire à relire ; implémentation locale existante, fidélité historique partielle ; vérification CPU héritée et statique ; acceptation humaine non demandée. SYS-17.5-01 et le goal global restent ouverts.

## R2 — Sources et limites natives
Référence4.20.0.315 EUW/en_GB, build2014-11-17 17:46:45, fuseau/déploiement non établis. PE et deux HUD.zip identifiés dans la preuve. Les six InventoryItem0..5 de ShadowIslesChampionLeft.ini conservent Draggable=1, AlwaysRespond=1 et Enabled=0 ainsi que leurs rectangles ; captures natives antérieures réutilisées, propriétés/octets relus. Enabled est un bit source et ne prouve pas une règle dynamique d’admission.

Les sources disponibles et l’audit antérieur établissent les métadonnées/layouts ; callback de drag, seuil, animation du pointeur et règle serveur native non qualifiés. Le module Rust déclare explicitement une politique locale sans callback/seuil natif récupéré. Aucun résultat de parité native n’est inventé ; pas de recherche REA/Web répétée sans piste nouvelle. Reprise native : callback identifié avec adresse/appelant ou capture native reproductible d’un geste nommé, ou contrat local explicitement assumé et versionné.

Preuve source conservée : F:\OpenLeague-work\audit-units\AUD-17.1-05-INVENTORY-01\inventory-proof.json.

## R3 — Consommateurs et états
native_hud_inventory programme drag::input après receive/shop/update_icons et avant commands. context exige inventaire valide et rendu disponible, shop fermé/non focalisé, connexion prête et identité session/joueur/epoch cohérente, snapshot sans vainqueur, joueur vivant à santé finie, fenêtre et six rectangles valides. Un départ nécessite gauche pressé/maintenu, pas de bouton droit maintenu et source occupée. slot_at refuse chevauchement/coordonnée non finie et emploie des bords droit/bas exclusifs. Destination vide autorisée.

ordered_frame consomme WindowEvent dans l’ordre, retient la position observée au press, vérifie le contexte même sans événements. Un changement de géométrie à tout endroit du lot invalide le contexte du lot ; pas de coordonnées finales devinées. Les événements de fenêtre sont filtrés ; KeyboardFocusLost est global sans ID de fenêtre. Sa remise à zéro conserve la capacité de reprendre un nouveau geste sans attendre un WindowFocused(true) absent.

| État | Entrée | Résultat local / visibilité |
|---|---|---|
| IDLE | No drag and no cancelled_until_release; context may be absent | No swap; a valid left press over occupied slot captures the full context ; No dedicated drag sprite in this module |
| CAPTURED | Focused left press, no held right button, unique rectangle, occupied source, valid context and icons | Own pointer until release/cancel; command suppression across whole frame ; Inventory renderer remains snapshot driven; original drag presentation unqualified |
| CANCELLED_UNTIL_RELEASE | Context drift/right press/escape/focus/geometry/input interruption under documented rules | Drop capture; held left cannot revive gesture; wait for real release or focus loss ; No per-slot cancelled-state renderer identified in bounded module |
| RETIRED | Valid release over different slot in unchanged context | Clear drag before one checked-swap send; no optimistic inventory mutation or gesture-layer retry ; Authoritative snapshot decides subsequent item/count images |
| AUTHORITATIVE_REJECTED | Server inventory/count mismatch, invalid bounds, unknown/dead actor or match ended at command boundary | Atomic refusal; common diagnostic path, no stored rejected drag state ; Not a named per-drag error animation; real render remains to compare |

Relâcher dans un autre slot inchangé retire le geste avant send_action(SwapItemsChecked). Pas de mutation optimiste ni de relance dans le module du geste ; cela ne promet pas une livraison exactement une fois sur tout transport. La barrière de transport possède ses propres séquences/reprises. Simulation.command applique vie/fin puis shop.swap_items_checked compare les six IDs ET six comptes bruts avant échange exclusif. Les méthodes directes swap_items_checked/swap_items ne reproduisent pas le garde mort de Simulation.command. Les commandes de déplacement forcé refusées ne comprennent pas SwapItemsChecked dans le sélecteur actuel : aucune interdiction générale des contrôles de foule n’est inférée.

Le rendu inventaire reste piloté par snapshot/session/objets/comptes/géométrie. Le module du geste n’instancie pas de sprite suivant le curseur ni d’état visuel de refus dédié. GameplayRejected suit le diagnostic commun ; le geste envoyé est déjà retiré. Ces frontières sont statiques, pas une observation graphique nouvelle.

## R4 — Attendu et observé
Exécuté maintenant : lectures statiques bornées et empreintes/cohérence des sources et reçus.27tests CPU réutilisés :21client drag +6core checked_swap, tous retrouvés dans les journaux terminaux code0. Deux étaient déjà utilisés au sous-lot précédent ;25cas supplémentaires examinés, zéro nouvelle exécution de ces tests. Douze sources et six dépendances de données sont identifiées face au manifeste conservé. Les noms, logs, binaires enregistrés et SHA figurent dans advanced_component_evidence ; aucun ancien binaire relancé ou requalifié comme binaire courant.

Les fixtures dites real_input exercent les systèmes ECS réels avec WindowEvent synthétiques, images CPU et Link::legacy sur UDP local ; elles ne sont pas une nouvelle session sécurisée ni une capture OS/GPU. Les noms de test ne remplacent pas cette limite.

| Cas | Attendu | Observé | Limite |
|---|---|---|---|
| G1 | Six current slots preserve exact native geometry and flags | Six InventoryItem0..5 have Draggable=1/AlwaysRespond=1/Enabled=0; retained rectangle test covers two resolutions, three DPI values and all six slots. | Geometry CPU comparison only; flags do not establish native threshold/callback. |
| G2 | One checked action; item IDs and raw counts move together | Retained release_once and checked_swap_moves tests preserve same tick and other player state; empty destination and occupied exchange covered. | Fixture start/drop pairs, not every ordered pair physically tested. |
| G3 | Empty source/same slot/outside/contradictory direct sample emits no use/swap | Retained clicks test and actual Capture.step return None; action type is checked swap only. | Current local gesture policy, not native click policy. |
| G4 | Outside motion keeps capture; right press cancels until release | Retained captured_pointer test verifies drag ownership and cancellation block. | No native pointer cursor/capture API execution. |
| G5 | Shop/death/winner/missing state/connection failure cancel; raw identity and inventory must remain exact | Retained actual_context, session_epoch and context_drift tests cover named variants; context source checks finite health, valid renderer and six rectangles. | Nonfinite health/readiness predicates partly static; no complete secure-session restart journey. |
| G6 | Use press-time source even when motion/release share frame | Retained ordered_same_update/press_then_motion preserve initial source; missing observed cursor refuses guessing from final Window position. | Synthetic WindowEvent stream, not a fresh OS/Winit event capture. |
| G7 | Focus/Escape/resize/scale/destroy/foreign window cannot resurrect old drag | Named ordered tests pass; geometry change anywhere in batch discards context, including resize after release. Global KeyboardFocusLost lacks window identity and is treated as global cancellation. | Do not describe global keyboard event as window-qualified. |
| G8 | Release then later motion cannot leak a world/learning/keyboard action; a new independent command works later | Retained release_then_more_motion and real_input_systems tests verify one swap and no deferred cast/learn; subsequent fresh learn/cast works. | ECS fixture and legacy UDP observer, not real game acceptance. |
| G9 | Compare all six item IDs AND raw counts, reject atomically without optimistic update/retry | Retained real_input_sends and unseen_change tests send captured arrays once, server refuses inventory changed and full player state remains equal; next update sends nothing. | No guarantee of exactly-once delivery across every transport/reconnection condition. |
| G10 | Unrelated slot, identical item IDs with changed count, sale/replacement must invalidate checked command | Three named checked_swap rejection tests preserve player JSON; raw zero is not normalized for comparison. | CAS equality is a local protocol rule, not recovered original server behavior. |
| G11 | Invalid indices/unknown player/dead/end refuse at command boundary | Retained checked_swap_keeps_bounds test covers6/255, unknown, dead, ended with player equality. Direct swap_items methods differ from Simulation.command dead guard. | Do not claim direct helper enforces death or that all control effects block swapping. |
| G12 | Existing SwapItems packet unchanged; malformed checked arrays/integers refused | Retained wire test roundtrips legacy packet, checked encoding under1024bytes and seven malformed variants refused. | Not fuzzing, full UDP capacity, authenticated replay or end-to-end security qualification. |
| G13 | Keep local gesture retirement separate from visible movement and authoritative rejection | input sends only actions; inventory signature is item/count/session/geometry driven; GameplayRejected uses common diagnostic, no drag ghost or per-slot rejected animation in inspected module. | Native drag appearance/threshold/callback and real framebuffer sequence unresolved. |

## R5 — Ouvert et conditions de reprise
Restent non qualifiés : seuil/délai/callback natifs, apparence du déplacement et du refus, vraie reprise du transport sécurisé pendant le geste, rendu framebuffer et validation humaine. Les gardes statiques et variantes CPU nommées ne deviennent pas toutes les combinaisons d’entrée, de CC, de résolutions ou de paires de slots. Un compteur de tests ne mesure pas la complétude du jeu.

Pour une comparaison native : fournir un nouveau callback/adresse/appelant ou une trace versionnée pour un geste et un état précis ; comparer départ, annulation, relâche et retour de refus. Pour l’affichage local : observer session/binaire/assets/viewport identifiés, inventaire avant/après, refus sans mutation et reprise d’un geste neuf, sans capture ou animation périmée. Pour le transport : refaire seulement le parcours sécurisé nommé à partir d’une session réellement admise, avec perte/reprise et séquences, en conservant les preuves CPU existantes.

## R6 — Corrections et couverture
Deux corrections existantes réutilisées sans modification de statut ; aucune nouvelle fiche dupliquée, aucune correction produit appliquée. La partie CPU locale est désormais explicitement reliée aux tests ci-dessus ; les critères natifs/visuels ne sont pas déclarés satisfaits :

- **INV-DRAG-FIDELITY-01** — Qualifier le geste local existant face à un comportement natif précis Fin : Conserver CAS objets/quantités, contrôle de session/fenêtre/état et absence de mutation optimiste ; ajouter comparaison native et nominal/refus/capture pour le geste nommé. Reprise : Callback/seuil/trace native du drag ou contrat local assumé ; ancien test de DDS ne prouve pas le geste.

- **INV-FULL-RENDER-LIFECYCLE-01** — Qualifier l’affichage des six icônes sur changements d’inventaire et de session Fin : Un parcours achat/déplacement/usage/vente et pertes de source/session montre icônes et quantités cohérentes dans le vrai client, version/viewport identifiés. Reprise : Consommateurs et ressources déjà présents ; reprendre les tests/captures uniquement sur périmètre pertinent, ne pas récupérer à nouveau les33DDS.

Couverture documentaire du parent :16contrôles logiques antérieurs +1geste distinct =17sur les seuls sous-périmètres établis. Ni36paires théoriques ni six nouveaux usages ajoutés ; dénominateur HUD complet inconnu, aucun pourcentage. Reste : SYS-17.5-01 remains open: minimap/pings/camera/pause/surrender/return/other controls and exhaustive control census. Native drag callbacks/threshold/visual presentation and full secure-session/GPU acceptance are not qualified; resume INV-DRAG-FIDELITY-01 only with named new source or explicit local policy. Mode-specific vision admission, per-item refusal visuals and other HUD validation tasks retain their separate open conditions.

## R7 — Livraison et conservation
Nouveaux fichiers uniquement : audit-unit.json, verify_inventory_drag.py, inventory-drag-states-proof.json, verify_delivery.py, delivery-readback.json et ce rapport. Le lecteur séparé clôture uniquement ce sous-lot après les sept rubriques ; producteur audit_scope_closed=false, parent_documentary_scope_closed=false, fonctionnalité/jeu/goal non terminés.

Cinq registres normatifs,25fichiers protégés (19logiciels gelés +6documents),1168sources et état suivi Git conservés. Aucune base ouverte ; aucune installation/migration/restart, aucune modification du goal, des critères, de Plan ou de son interface. Aucun code produit modifié ; aucun écrasement/suppression de preuve.

Preuve : F:\OpenLeague-work\audit-units\AUD-17.5-01-INVENTORY-DRAG-STATES-01\inventory-drag-states-proof.json. Relecture : F:\OpenLeague-work\audit-units\AUD-17.5-01-INVENTORY-DRAG-STATES-01\delivery-readback.json.
