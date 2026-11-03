# AUD-17.5-01-INVENTORY-USE-STATES-01

Date UTC : 2026-10-31T02:53:44.947862+00:00. Parent : SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46. Inconnue : OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd.

## R1 — Périmètre et résultat
Audit des six commandes USE-ITEM-0 à USE-ITEM-5 : états visibles, entrée clavier, utilisation acceptée/refusée. Frontière du slot de vision documentée sans le compter comme contrôle admis. Déplacement entre slots : seulement frontière avec utilisation ; recette complète du drag exclue. SYS-17.5-01 reste ouvert. Audit documentaire à relire ; implémentation partielle, vérification CPU héritée et statique, acceptation humaine non demandée.

## R2 — Sources historiques conservées
Client original4.20.0.315, catalogue4.20.1, EUW/en_GB ; build2014-11-17 17:46:45, fuseau et déploiement non établis. PE, deux HUD.zip, deux membres et58définitions repris de l’audit inventaire ; octets et propriétés revérifiés, captures natives héritées.48définitions pour six slots,10pour VisionSlot ; aucune conversion du nombre de sprites en nombre de contrôles. Source Enabled=0 ne définit pas l’éligibilité d’utilisation. Centre ActiveItems alternatif non sélectionné selon l’audit conservé ; aucune activation globale inférée.

Source principale : F:\OpenLeague-work\audit-units\AUD-17.1-05-INVENTORY-01\inventory-proof.json. Rapport conservé : F:\OpenLeague\docs\audit\units\AUD-17.1-05-INVENTORY-01.md.

Vision : evtUseVisionItem[4] existe ; 3340 / Warding Totem a maps10=false et reste absent du catalogue33objets. La présence du layout ne suffit pas ; un objet exclu ne prouve pas l’inapplicabilité globale. Reprise : objet de vision admissible Map10 nommé et sélection/commande d’origine, ou politique locale versionnée.

## R3 — Consommateurs réels
Touches1,2,3,5,6,7 → main.item_hotkey → commands → Action::UseItem{slot} → Simulation.command → consumables.use_item. Digit4 retourne None. native_hud_inventory sélectionne InventoryItem0..5 et InventoryItemCount0..5 ; valeurs limitées à item/count/stackable. icon_payloads ignore les slots vides et force le bit visible des slots occupés. Signature : session, joueur, slots, dimensions, DPI, scalaire ; aucun état santé/mana/stun/refus par objet.

Le garde commun inventory_capture.blocks_commands/shop.focused/connexion non prête/partie finie précède les touches. shop.open seul n’est pas déclaré un garde commun. Capture.step produit SwapItemsChecked ou None, jamais UseItem ; un clic sur le même slot n’active pas l’objet. GameplayRejected rejoint connection.report et pause_control.rejected ; aucun dernier refus par slot dans cette signature.

Deux consommables actuels :2003 soin et2004 mana. Les autres objets admis ne deviennent pas des actifs à implémenter du seul fait que UseItem les refuse. Les garde-fous d’utilisation précèdent la consommation : vie/fin/déplacement forcé, slot/objet, stun, ressource, file bornée.

## R4 — Attendu, observé et vérifications
Contrôles exécutés maintenant : lecture statique bornée, empreintes et cohérence des sources/propriétés, entrées du registre et identité des preuves. Quatorze tests CPU hérités : huit client, six core, retrouvés dans les journaux terminaux code0, onze fichiers source et six dépendances de données identiques au manifeste d’exécution conservé. Aucun test du jeu relancé. Binaires : identités enregistrées dans advanced_component_evidence.test_jobs ; pas de nouvelle qualification du binaire actuel. Les tests de handles/DDS et fixtures ECS ne prouvent pas un affichage GPU réel ni une session sécurisée complète.

| Cas | Attendu | Observé | Limite |
|---|---|---|---|
| I1 | one source binding and one current mapping per slot | Native1,2,3,5,6,7 match; retained key test passes for six slots and key4→None. | Inherited CPU input test, not OS keypress or remapping parity. |
| I2 | empty has no image; occupied known item uses its original icon | icon_payloads skips None and enables occupied source bit; retained holes/handle test passes. | Enabled source bit is display presence, not approval of UseItem. |
| I3 | use spends one count and queues duration; no immediate multiplied healing | Retained swap/sale/use case consumes two remaining potions in slot5 and queues900ticks; exact450update test covers health/mana totals. | Direct core function test; not six-slot real-client network acceptance. |
| I4 | refuse without spending quantity | Retained guards test rejects full health and activation of1036; source mutates only after guards. | 1036 has no current consumable; not a claim every non-consumable item needs an active spell. |
| I5 | non-mana champion/full mana refusal distinct | Garen mana-potion refusal exercised; mana already full is explicit source guard before mutation. | Full-mana branch source verified, not claimed as an executed dedicated test. |
| I6 | queue cap refusal does not consume remaining potion | Retained queued test reaches2250ticks and rejects extra potion; inventory_count remains1. | Queue timing is reconstructed local policy, not recovered native server schedule. |
| I7 | authoritative refusal before use | Retained guards test exercises dead, winner and slot6 refusal; command router repeats winner/dead guard. | Empty slot/unknown player are explicit source guards, not extra retained test cases. |
| I8 | preserve inventory on refusal | Retained stun test leaves count1; forced-motion test rejects Action::UseItem and direct use with full player-state equality. | Does not qualify all crowd-control families or original actor mask. |
| I9 | drag ownership suppresses hotkeys; click is not item use | Common blocks_commands gate precedes item mapping; retained ECS suppression test passes. Capture.step returns only checked swap or None; no same-slot use. | Selected drag tests establish this boundary only; full drag audit remains separate. |
| I10 | identify source responsible for each state without inventing a disabled overlay | Current icon/slot fields and signature use item/count/geometry/session, not health/mana/stun/last rejection. Icon can remain visible when server refuses use. | Conditional static comparison, not freshly observed rendered defect or mandate to grey every item. |
| I11 | identify path for authoritative refusal | GameplayRejected is routed to connection.report and pause_control.rejected, not a per-slot last-rejected state. | No per-item refusal animation or full diagnostic privacy qualification. |
| I12 | keep key4/layout presence separate from Map10 admission | Original evtUseVisionItem[4] and VisionSlot exist;3340 explicitly maps10=false and is absent from33item shop. | One excluded item does not establish global vision-slot inapplicability. |

## R5 — Écarts et reprise
L’icône peut rester affichée lorsque l’utilisation est refusée : potion à santé pleine, file pleine, mort, stun ou déplacement forcé. Comparaison conditionnelle de sources, pas défaut GPU nouvellement observé ni obligation de griser tous les objets. Le contrat visuel natif par objet et le retour de refus dédié ne sont pas qualifiés. Pleine mana/slot vide/joueur inconnu : branches lues ; ne pas les présenter comme tests dédiés exécutés.

Conditions de reprise : nommer objet/slot/règle et état d’autorité ; identifier source native ou politique locale explicite ; conserver quantité sur refus ; comparer affichage/action sur nominal et refus avec versions, session et viewport. Pour vision, établir d’abord l’admission Map10. Pour drag, réutiliser ses tests sans requalifier le geste entier ici. Pas de recherche externe ou REA répétée : aucune piste nouvelle requise pour cette conclusion.

## R6 — Corrections réutilisées
Cinq fiches existantes réutilisées, aucune nouvelle fiche dupliquée et aucune correction appliquée :

- **INV-HOTKEY-LABELS-01** — Raccorder les six Text InventoryItemHotKey au binding effectif, un slot par cas Fin : Source/label/action cohérents pour les six touches et leurs refus ; préserver le mapping déjà conforme, ne pas fabriquer un libellé depuis un autre slot. Reprise : Producteur de labels et remappage natif ou politique locale versionnée ; vrais glyphes et capture requises pour le rendu.

- **INV-ACTIVE-FEEDBACK-01** — Raccorder état actif/récupération pour un seul objet nommé Fin : Objet et autorité de récupération identifiés ; un slot affiche les bons icône/overlay/temps, masque inconnu et se réconcilie après déplacement. Reprise : Contrat de l’objet et choix de ses éléments Inventory*/ActiveItem*, aucune activation globale des soixante définitions.

- **INV-VISION-SCOPE-01** — Qualifier séparément le slot de vision et son applicabilité au mode Fin : Source de sélection de VisionSlot et objet admissible identifiés ; définir les limites du modèle six slots sans activer 3340 sur Map10 contre sa restriction explicite. Reprise : Règle de mode native ou politique locale nommée ; présence du layout et touche4 insuffisantes.

- **INV-DRAG-FIDELITY-01** — Qualifier le geste local existant face à un comportement natif précis Fin : Conserver CAS objets/quantités, contrôle de session/fenêtre/état et absence de mutation optimiste ; ajouter comparaison native et nominal/refus/capture pour le geste nommé. Reprise : Callback/seuil/trace native du drag ou contrat local assumé ; ancien test de DDS ne prouve pas le geste.

- **INV-FULL-RENDER-LIFECYCLE-01** — Qualifier l’affichage des six icônes sur changements d’inventaire et de session Fin : Un parcours achat/déplacement/usage/vente et pertes de source/session montre icônes et quantités cohérentes dans le vrai client, version/viewport identifiés. Reprise : Consommateurs et ressources déjà présents ; reprendre les tests/captures uniquement sur périmètre pertinent, ne pas récupérer à nouveau les33DDS.

Couverture du parent :10contrôles antérieurs QWER/apprentissage/D/F +6commandes d’utilisation distinctes =16contrôles audités sur ces sous-périmètres. Dénominateur HUD complet inconnu ; aucun pourcentage. Vision et drag non ajoutés au numérateur. Reste : Full drag state comparison as its own logical gesture, not six new activation controls. Minimap/pings/camera/pause/surrender/return and other controls; explicit exhaustive logical control inventory. Original or named local per-item visual/refusal contract, mode-admitted vision selection, real-client render/lifecycle and acceptance. Full SYS-17.5-01, other SYS-17.5 tasks and global SYS-01.2-02 remain open.

## R7 — Livraison et conservation
Nouveaux fichiers uniquement : audit-unit.json, verify_inventory_use.py, inventory-use-states-proof.json, verify_delivery.py, delivery-readback.json et ce rapport. Les deux derniers fichiers de relecture sont produits séparément ; la clôture du sous-lot dépend de leurs sept rubriques réussies. Le producteur garde audit_scope_closed=false ; le lecteur peut clore seulement le sous-lot. parent_documentary_scope_closed=false ; aucune conclusion de jeu ou goal terminé.

Conservation : cinq registres normatifs,19fichiers logiciels gelés +6documents,1168sources, HEAD et état suivi Git identiques avant/après. Aucune base ouverte ; aucune migration, installation, exécution du jeu, suppression ou écrasement. Aucune modification du goal, des critères normatifs, de Plan, de son interface ou de ses bases. Les preuves antérieures restent intactes.

Preuve machine : F:\OpenLeague-work\audit-units\AUD-17.5-01-INVENTORY-USE-STATES-01\inventory-use-states-proof.json. Relecture : F:\OpenLeague-work\audit-units\AUD-17.5-01-INVENTORY-USE-STATES-01\delivery-readback.json.
