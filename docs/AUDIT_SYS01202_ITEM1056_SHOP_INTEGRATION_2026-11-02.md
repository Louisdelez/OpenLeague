# AUD-SYS-01.2-02 — Objet 1056, intégration complète de la boutique

Lot d’audit : AUD-SYS-01.2-02-ITEM1056-SHOP-INTEGRATION-01

Date : 2026-11-02  
Tâche : ITEM-1056-SHOP  
Requirement ID : OLF-cc1d5c57-fbe6-5f8e-a2a4-b21c32361326  
Consommateur tracé : OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b  
Statut registre relu : a_implementer_ou_integrer; implementation_complete=false; acceptance_complete=false; required=false; scope_decision_required=true.

## Conclusion de l’audit borné

Les ressources de présentation et plusieurs consommateurs génériques existent. La PNG 1056 de boutique est localement pixel-identique au DDS natif, les textes en_GB existent, le consommateur shop_ui sait présenter les lignes, prix, recettes et icônes d’objets admis, et le cœur a des chemins génériques d’achat et de vente.

L’intégration 1056 n’existe cependant pas de bout en bout :

- 1056 manque de shop_foundation.json et de l’admission Map10; la boutique ne crée donc aucune ligne et refuse l’achat.
- La HUD d’inventaire refuse un ID absent du catalogue puis efface les icônes et compteurs.
- Le bouton Undo est sans effet. Acheter ou vendre envoie immédiatement une action; Close ferme seulement le panneau. Aucun état de transaction en attente à annuler n’a été trouvé.
- Les tests source recensés couvrent 1055 et des refus de catalogue, mais pas un parcours 1056.
- Le critère d’acceptation de la tâche parle de modèles/animation/VFX/audio/HUD, alors que son titre réclame icône, texte, recette, achat/vente/annulation et inventaire. Cette discordance empêche de déduire une définition fiable de la clôture.

**L’audit source → consommateurs → écarts de l’intégration boutique est clos pour ce périmètre. La fonctionnalité 1056 et l’acceptation restent ouvertes.** Aucun registre ou statut n’a été modifié.

## Sources et preuves réutilisées

La définition native et son membership client 4.20 sont établis dans les rapports précédents. La référence Data Dragon 4.20.1 est une autre version/locale; elle confirme le prix 400/160, mais ne remplace pas la référence en_GB 4.20.0.315 ni une qualification serveur.

Les constats réutilisés, sans nouvel import ni nouvelle comparaison d’assets :

- Stats de l’objet : AUDIT_SYS01202_ITEM1056_FLATHPPOOLMOD_2026-11-02.md, AUDIT_SYS01202_ITEM1056_FLATMPREGENMOD_2026-11-02.md, AUDIT_SYS01202_ITEM1056_FLATMAGICDAMAGEMOD_2026-11-02.md.
- Passif : AUDIT_SYS01202_ITEM1056_PASSIF_2026-11-02.md.
- Icône boutique et chemin runtime : AUDIT_SYS01202_ITEM1056_ICON_2026-11-02.md.
- Nom/description en_GB et chemin texte : AUDIT_SYS01202_ITEM1056_TEXT_2026-11-02.md.
- Prix achat/revente : AUDIT_SYS01202_ITEM1056_PRIX_2026-11-02.md.

Le registre de traçabilité lie la tâche à DATA/Items/1056.inibin, à /data/1056 du catalogue officiel, au lookup absent items.id=1056 et au consommateur OLC ci-dessus. L’identité native réutilisée est source OLS-04ec5370-8428-5c53-925a-41f5fb787829, SHA-256 861cf0f8d1d7fb17098cfd76ea28991eb82467ab3361b4322c0124a43174b12c, membership au manifeste lol_game_client release 0.0.1.68 via OLS-8a207b4a-05d0-5b9d-b2f9-e716cdaa946d. La priorité effective des overlays demeure inconnue.

## Chemin consommateur observé dans le code

| Frontière | Code/donnée courante | Résultat statique |
|---|---|---|
| Catalogue cœur | crates/core/src/shop.rs charge data/4.20/shop_foundation.json; item(id) ne cherche que dans cette liste. | Aucun 1056 : la résolution renvoie None. quote, achat et vente ne peuvent pas lire ses données et renvoient item behavior not implemented. |
| Admission de carte et lignes boutique | crates/core/src/shop.rs::map10_available; crates/client/src/shop_ui.rs::map10_purchase_catalog. La liste UI est filtrée par map10_available(id)==Some(true). | map10_shop_admission.json n’a pas d’entrée 1056. Même l’ajout isolé d’une ligne au catalogue n’afficherait pas l’objet; l’admission resterait inconnue. |
| Présentation boutique | shop_ui.rs charge assets/ui/items/{id}.png, nom, description, prix, recette et prix de vente à partir de l’Item. | La PNG exacte existe, mais aucune ligne ne la demande. Aucun texte, prix ou recette 1056 n’est rendu. |
| Achat et vente UI | selected_action exige une boutique ouverte et prête, contrôle le catalogue/admission, puis envoie immédiatement Buy ou Sell par connection.send_action. | Les actions valides ne sont pas des opérations provisoires. BuySelected/SellSelected sont les seuls boutons d’action vérifiés ici. |
| Annulation | ShopControl::Undo a une branche vide; ShopControl::Close met open=false. | Aucun mécanisme d’annulation ou de rollback n’est implémenté. Fermer ne rappelle pas une action déjà envoyée. |
| Inventaire HUD | crates/client/src/native_hud_inventory.rs::values résout chaque ID d’inventaire via le catalogue; sur ID inconnu, retourne inventory icon unavailable for unsupported item {id}. update_icons efface les icônes et compteurs à l’erreur. | Si un snapshot contient 1056 sans entrée catalogue, les six emplacements de la HUD d’inventaire ne sont pas présentés. Le reçu existant indique aussi que son manifeste DDS d’icônes ne contient que 33 entrées, sans ID 1056. |
| Enregistrement des consommateurs | crates/client/src/main.rs enregistre shop_ui et native_hud_inventory. | Ce sont des consommateurs applicatifs actifs dans le code, mais aucune capture ou exécution réelle n’a été faite dans ce lot. |

Identités des sources de code reprises des rapports récents : shop.rs SHA-256 3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0; shop_ui.rs cf7405045e6541866543c447b31aef33730ef6c11d2eb6b275387fbb27adcfc1; native_hud_inventory.rs 00c506b31d15f93f844a9bc45c8327839d2a0ffde80a527d23d0abb62501c6db; main.rs eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620. Hashes réutilisés, non recalculés pour cette synthèse.

## Résultat attendu / observé

- **Attendu avant clôture fonctionnelle :** ligne 1056 sélectionnable avec icône/texte/recette et valeurs de prix correctes; achat et revente appliqués au snapshot/inventaire; retour explicite si achat impossible; annulation définie et sans mutation; icône d’inventaire rendue; comparaison aux sources 4.20.
- **Observé statiquement :** ligne absente et filtre admission non satisfait; achats/reventes non résolus; la HUD d’inventaire échoue sur l’ID absent; Undo ne fait rien; aucune capture de fenêtre ou test 1056 n’est enregistré.
- **Tests présents dans le code :** le test de sélection et achat/vente dans shop_ui.rs porte sur 1055; les tests de garde vérifient 1055, 1038, 1058 et un ID inconnu, pas 1056. Ils n’ont pas été exécutés dans ce lot.
- **Contrôles exécutés ici :** lecture ciblée du contrat et de la trace, recherche des branches UI et des callsites inventaire, réutilisation des rapports source/asset/prix. Aucun test, build, lancement du jeu, capture ou comparaison nouvelle d’images n’a été réalisé.

## Tâche d’acceptation dépendante

ITEM-1056-ACCEPT (requirement OLF-b3d61527-c13e-5601-8a7b-2bef8052f722) dépend explicitement de ITEM-1056-SHOP, reste a_implementer_ou_integrer, avec evidence=[] et scope_decision_required=true. Elle demande des vérifications d’assets/composants/cumul/usages/décès/réseau puis fidélité humaine. Comme l’intégration boutique requise n’existe pas, le parcours n’a pas de candidat exécutable et aucun test d’acceptation n’a été lancé. Cette analyse statique ne satisfait pas la tâche enfant.
## Critères précis pour reprendre et clôturer

1. Résoudre le périmètre attendu et la décision d’admission de l’objet sur le mode/carte visé. Le statut required=false et scope_decision_required=true ne sont pas une exclusion.
2. Aligner le texte d’acceptation du registre avec le besoin boutique déclaré, dans une intervention autorisée qui modifie le goal/registre; aucune correction n’est faite ici.
3. Intégrer et relier les données source vérifiées (y compris prix d’achat 400/revente 160 si le périmètre les confirme), chaîne en_GB, icône, admission et recette. Les rapports enfants restent la preuve de ce qui existe et de ce qui manque.
4. Définir ce que signifie annuler et vérifier que l’annulation ne soumet ni n’applique d’action. Le bouton Undo actuel est une coquille vide.
5. Après intégration autorisée, vérifier le parcours d’achat, refus fonds insuffisants sans mutation, vente, inventaire/UI et annulation; produire reçus reliés aux hashes courants et une capture réelle de la fenêtre.
6. Garder la qualification du passif, des stats, de l’ordre d’overlay et du comportement serveur distincte de l’audit de présentation.

Tâche inchangée : a_implementer_ou_integrer, implementation_complete=false, acceptance_complete=false. Cet audit ne déclare pas la boutique ou le jeu terminés.

## Fichiers modifiés dans ce lot

Nouveau : docs/AUDIT_SYS01202_ITEM1056_SHOP_INTEGRATION_2026-11-02.md.  
Notes de reprise : docs/ai/CURRENT.md, docs/ai/HANDOFF.md, docs/ai/DECISIONS.md.  
Aucun code, registre, plan/goal, interface de suivi, base de données, installation ou migration n’a été modifié.