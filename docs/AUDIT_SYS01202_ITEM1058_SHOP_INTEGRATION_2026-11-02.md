# AUD-SYS-01.2-02 — Objet 1058, intégration boutique et acceptation

Lot d’audit : AUD-SYS-01.2-02-ITEM1058-SHOP-INTEGRATION-01

Date : 2026-11-02  
Tâche intégration : ITEM-1058-SHOP — OLF-02d4d978-d5d9-5276-b760-64526cd5b8d3  
Tâche acceptation : ITEM-1058-ACCEPT — OLF-0d120d1a-2507-539c-9301-232bd28e4854  
Scope : ITEM-1058-SCOPE, required=true, status=partiel_a_terminer.

## Résultat borné

Les sources de l’objet et plusieurs consommateurs réels sont liés. Les audits séparés établissent le bonus AP natif 80, l’icône locale pixel-identique au DDS, les chaînes texte en_GB et le prix d’achat/de vente. La ligne 1058 existe dans le catalogue local. L’HUD d’inventaire possède aussi son DDS.

Le parcours boutique Map10 ne permet toutefois pas l’achat : l’admission 1058 est explicitement false. La fenêtre ne crée donc pas de ligne 1058. L’icône exacte ne suffit pas à prouver un affichage runtime. Le bouton Undo est un no-op et aucun mécanisme de transaction en attente à annuler n’a été trouvé. Les données locales n’établissent pas non plus la recette sortante complète.

**L’audit de la liaison source → données → consumers et des blocages d’intégration est terminé pour ce lot. La fonctionnalité et les deux tâches du registre restent ouvertes.**

## État par besoin

| Besoin | Preuve actuelle | Écart ou limite |
|---|---|---|
| Stat AP | L’INIBIN décodé donne FlatMagicDamageMod=80; shop_foundation a ability_power=80.0; shop::bonuses et progression::stats transmettent le bonus. | Map10 interdit l’achat; résultat d’un objet détenu et facteur d’autel non testés. Rapport : AUDIT_SYS01202_ITEM1058_FLATMAGICDAMAGEMOD_2026-11-02.md. |
| Icône boutique | PNG 1058 pixel-identique au DDS natif décodé; shop_ui charge assets/ui/items/{id}.png. | La liste Map10 filtre l’objet par allowed=false; pas de ligne ni de capture réelle. Rapport : AUDIT_SYS01202_ITEM1058_ICON_2026-11-02.md. |
| Icône d’inventaire | native_inventory_icons.json a l’ID 1058 et le DDS local natif; l’ID est présent dans shop_foundation et résoluble par le consumer HUD. | Callsite établi, mais aucune capture/invocation runtime de la HUD dans ce lot. |
| Texte | fontconfig en_GB contient Needlessly Large Rod, +80 Ability Power et un tooltip de vente; le catalogue local utilise « Baguette trop grosse » et « +80 puissance ». | shop_ui lit les champs du catalogue local, pas fontconfig_en_GB ni game_item_tooltip complet. La locale produit attendue doit être décidée. Rapport : AUDIT_SYS01202_ITEM1058_TEXT_2026-11-02.md. |
| Prix | Natif Price=1600/CanBeSold; Data Dragon 4.20.1 confirme 1600/1120; la ligne locale porte price et sell_price explicites. | Map10 refuse l’achat mais sell_item ne consulte pas l’admission; aucun cas d’achat/vente exécuté. Le hash natif SellBackModifier n’a pas été résolu. Rapport : AUDIT_SYS01202_ITEM1058_PRIX_2026-11-02.md. |
| Recette | shop_foundation donne recipe=[] pour 1058. La référence de tâche liste les objets sortants 3089, 3157 et 3128. | Les upgrades ne figurent pas dans les 33 entrées shop_foundation; l’UI dérive la liste sortante uniquement depuis le catalogue Map10. La recette affichée ne peut pas être vérifiée sur le graphe complet. |
| Annulation | shop_ui envoie immédiatement Buy/Sell quand l’action est valide; Close ferme la fenêtre. | ShopControl::Undo a une branche vide. Aucun rollback d’action déjà envoyée. |
| Acceptation | ITEM-1058-ACCEPT demande un scénario ordinaire sur binaires/ressources identifiés et une validation humaine. | Elle dépend de ITEM-1058-SHOP; le parent est encore partiel et n’offre pas de parcours d’achat 1058 sur Map10. Aucun test ni reçu d’acceptation n’est présent dans la trace. |

Le registre de tâche ITEM-1058-SHOP porte status=partiel_a_terminer, implementation_complete=false, acceptance_complete=false, required=false, scope_decision_required=true et une evidence vide. Son critère d’acceptation parle de modèles, animation, VFX, audio et HUD, tandis que le titre exige icône, texte, recette, achat/vente/annulation et inventaire. Cette incohérence est consignée, sans modification du registre.

ITEM-1058-ACCEPT est aussi partiel, dépend de ITEM-1058-SHOP et exige un scénario ordinaire puis la fidélité humaine. Son périmètre de tests contient usage/décès/réseau, mais la donnée native décodée indique UseEffect=0 et UseWhenAcquired=0. Les contrôles applicables doivent être distingués des scénarios sans effet actif; aucune décision n’a été prise ici.

## Contrôles exécutés et non exécutés

Exécutés : relecture des statuts, dépendances et traces; réutilisation des preuves natives 1058 de membership et de décodage; recherche ciblée des entrées catalogue/admission/recettes; inspection du chemin buy/sell/Undo, du shop UI et de l’HUD.

Non exécutés : aucun build, test, lancement du jeu, capture de fenêtre, scénario d’achat/vente/inventaire ou acceptation humaine. Les rapports enfants ferment des audits de source/consumer, pas les tâches de fonctionnalité.

## Correction de scope — catalogue officiel 4.20.1

La relecture du contexte de référence 1058 montre que la fiche officielle déjà enregistrée indique maps["10"]=false. Elle corrobore donc le refus de la politique Map10 dans le catalogue 4.20.1; les notes antérieures qui laissaient ouverte l’hypothèse d’une restriction uniquement locale étaient trop larges pour cette révision. La source est distincte du client 4.20.0.315 en_GB, et le task de scope demeure partiel tant que cette différence de révision et la décision de périmètre ne sont pas consignées. Aucun statut n’est changé.
## Conditions précises de reprise

1. Terminer ITEM-1058-SCOPE en enregistrant que le catalogue officiel 4.20.1 /data/1058/maps["10"]=false corrobore l’admission locale; garder ouverte la liaison de cette restriction au client exact 4.20.0.315.
2. Dans une intervention autorisée sur le goal/registre, aligner le critère de ITEM-1058-SHOP avec les fonctions boutique annoncées; il n’est pas corrigé dans le présent audit.
3. Fixer la locale du produit, la source/forme des recettes et la règle de vente d’un item indisponible à l’achat.
4. Définir une vraie opération d’annulation ou confirmer que le besoin d’Undo est exclu; l’implémentation actuelle ne l’effectue pas.
5. Quand le parcours est implémenté et autorisé, tester achat/refus, vente, prix, inventaire/HUD, recette et annulation; enregistrer hashes des binaires/données et capture réelle.
6. Exécuter ITEM-1058-ACCEPT seulement après que son parent ait un scénario testable, puis conserver la validation humaine comme état séparé.

Aucun statut n’a été modifié. Cet audit ne déclare ni l’objet 1058 terminé, ni la boutique, ni le jeu terminé.

## Fichiers modifiés dans ce lot

Nouveau rapport : docs/AUDIT_SYS01202_ITEM1058_SHOP_INTEGRATION_2026-11-02.md.  
Notes de reprise : docs/ai/CURRENT.md, docs/ai/HANDOFF.md, docs/ai/DECISIONS.md.  
Aucun code, asset, donnée produit, registre, goal, interface de suivi ou base n’a été modifié.