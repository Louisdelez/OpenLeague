# SYS-01.2-02 — objet 1055 : AD et vol de vie, test courant (V821)

Unité : AUD-SYS01202-ITEM1055-AD-LIFESTEAL-CURRENT-TEST-01  
Exigences : ITEM-1055-SERVER-STAT-FlatPhysicalDamageMod (OLF-b9425d28-121d-5f01-bf17-3abeaf5ed98e) et ITEM-1055-SERVER-STAT-PercentLifeStealMod (OLF-f2a8750d-57dd-51ac-ac00-d7166384b469).

## Décision et périmètre

**Audit du lien source → données → consommateurs locaux : clos pour ces deux champs et les cas testés ci-dessous.** La donnée et les consumers existaient déjà; cette unité actualise la preuve d’exécution qui était obsolète après les changements de shop.rs et progression.rs. Elle ne clôt pas les tâches fonctionnelles, la fidélité historique complète ou l’acceptation humaine.

- Implémentation observée : présente dans la simulation Rust pour achat, agrégation AD/vol de vie et impacts couverts.
- Vérification : réussie pour le test d’intégration courant doran_blade et ses quatre tests.
- Acceptation humaine : non fournie.
- Statut des deux tâches dans completion_tasks_2026-10-20.json : toujours a_faire; implementation_complete=false, acceptance_complete=false. Le registre n’a pas été modifié.

## Source et relation réutilisées

Référence conservée des audits précédents : client PUBLIC LoL 4.20.0.315, EUW/en_GB; DATA/Items/1055.inibin, source OLS-7009b21b-648f-5338-9d1d-5beddef7c7c5, 520 octets, SHA-256 1645d84bd97510e3adc9965a0e6c31a95ddb721b991af0a81af65c9655647f38; membership du manifeste sélectionné établie par OLS-8a207b4a-05d0-5b9d-b2f9-e716cdaa946d. Le reçu est réutilisé sans relire ni re-hacher le binaire natif.

Les valeurs enregistrées sont FlatPhysicalDamageMod=7 et PercentLifeStealMod=0.029999999329447746. La ligne 1055 de data/4.20/shop_foundation.json les porte comme damage=7.0 et life_steal=0.029999999329447746, avec source_sha256 natif concordant. Son SHA-256 courant est 504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae. La provenance et la sémantique des champs sont documentées dans AUDIT_SYS01202_ITEM1055_DAMAGE_LIFESTEAL_2026-11-02.md; les preuves de prix et de santé restent dans leurs rapports dédiés.

Chaîne observée dans la révision testée : shop.rs charge et agrège les bonus d’inventaire; progression.rs expose le bonus de dégâts et le taux de vol de vie dans les stats; lifesteal.rs applique le taux au résultat d’une attaque de base. Le test est le consommateur vérifié ici, pas le serveur LoL historique.

Empreintes SHA-256 des fichiers locaux au contrôle :

- crates/core/src/shop.rs : 3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0.
- crates/core/src/progression.rs : eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766.
- crates/core/src/lifesteal.rs : 7a762577aa0d5255f643325fc16c3eb8847c67eaef936cbc64cbb6cf633accae.
- crates/core/tests/doran_blade.rs : bc5074f09e172a3ebf7361c758f891557f05876fa5408f02a7ad8ea4e05d3cf5.

## Attendu, observé et contrôles

Commande exécutée dans F:\OpenLeague :

    cargo test --offline -p openleague-core --test doran_blade -- --nocapture

Résultat : code 0, 4 passés, 0 échoué. Cargo a compilé la cible de test et mis à jour les artefacts ordinaires dans target; aucun fichier source n’a été édité. La compilation affiche 24 avertissements Rust (imports/éléments inutilisés et noms non snake case), sans échec.

| Cas | Attendu | Observé |
|---|---|---|
| Achat 1055 par Garen, 825 or | Déduire 440; ajouter +7 dégâts et environ +0,03 vol de vie | 385 or, objet en inventaire; stats +7 et taux 0.0299999993 |
| Vente | Créditer 176 et retirer les deux bonus | 561 or; inventaire vide; dégâts et vol de vie reviennent à la base |
| Refus d’achat | Or insuffisant (439), hors boutique alliée ou inventaire plein : refus atomique | Les trois cas refusent et préservent l’état sérialisé du joueur et les stats observées |
| Impacts | Le vol de vie s’applique une fois à l’attaque ordinaire et à l’impact Q renforcé; pas aux pulsations du sort Jugement | Les deux assertions passent; l’exclusion Jugement passe |

La suite inclut aussi une assertion de +70 PV et la conservation des PV courants selon la politique locale actuelle; ces assertions ne qualifient pas la sémantique historique du pool de santé.

## Limites, reprise et fichiers

Le résultat porte sur une simulation contrôlée avec Garen. Il ne prouve pas les règles d’un serveur Riot 4.20, la priorité des overlays, les autres champions, toutes les familles d’attaques/cibles, le réseau, le client graphique ou l’acceptation du jeu. Les champs historiques réutilisés et l’interprétation numérique ne constituent pas une comparaison avec un serveur original. Reprendre ces questions uniquement sur une source serveur 4.20 ou une observation de référence nouvelle; ne pas refaire l’extraction native, le membership ou la recherche des consumers sans nouvelle piste. Reprendre la fonctionnalité séparément, selon la tâche existante et son périmètre accepté.

Aucun défaut de raccord n’a été observé dans les cas exécutés; aucune correction de code ou nouvelle tâche n’est proposée. Ce rapport complète les audits statiques antérieurs et clôt uniquement cette unité d’audit. Les tâches 1055 restent ouvertes, tout comme D01-SYS-01-1 et le goal SYS-01.2-02.

Fichiers documentaires de cette intervention : le présent rapport, docs/ai/CURRENT.md, docs/ai/HANDOFF.md et le checkpoint de reprise docs/resume_checkpoint.json. Aucun goal, plan de tâches, application de suivi, base de données, source produit, asset, installation ou migration n’a été modifié.
