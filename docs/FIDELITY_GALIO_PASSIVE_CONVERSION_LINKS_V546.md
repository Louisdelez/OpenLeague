# SYS-01.2-02 — Galio : Peau runique, V546

25 octobre2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 à17:46:45 ; fuseau et déploiement inconnus. Catalogue4.20.1 distinct. **Traçabilité partielle ; aucun passif, champion ou jeu accepté.**

## Résultat intégré

Les trois fiches CH-Galio-PASSIF-SOURCE, CH-Galio-PASSIF-SIMULATION-CONTRAT et CH-Galio-PASSIF-SIMULATION reçoivent18 arêtes vers six sources natives. Les deux fiches de simulation reçoivent20 liens vers dix frontières effectives, toutes `entry_boundary_only` et `provides_feature_consumer=false`. SYS-01.2-02 référence le lot. Les lecteurs de sources et le chargeur partagé sont conservés sans promotion en producteur de passif.

Phases, lots et prérequis effectifs figurent dans le reçu ; leurs sorties ne sont pas déclarées achevées. Trois questions propres et quatre dépendances restent exactes avec références aux questions de leurs propriétaires. Aucun inconnu ajouté ou fermé, aucune case ni statut changé.

## Sources natives et communautaires

| Fichier | Identifiant |
|---|---|
| Galio.inibin | OLS-c7854e66-def3-5360-9340-743830fcf5e1 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| GalioRunicSkin.inibin | OLS-f73c72bd-3226-5625-a867-aeda93134ebd |
| GalioRunicSkin.luaobj | OLS-5bdde298-7052-557d-a405-98e3462028d9 |
| CharScriptGalio.luaobj | OLS-60a08222-d102-5829-833f-669c3f850b7f |
| CharScriptGalio.preload | OLS-cc0c0fbc-de24-5515-a8c6-8f6ee758e615 |

Les six fichiers correspondent en taille/SHA au registre et en taille/MD5 aux projets sélectionnés du manifeste RADS. Le périmètre inspecte la définition, Spells/GalioRunicSkin et CharScriptGalio. Il ne démontre pas une absence mondiale de code serveur.

Passive1LuaName et BuffName valent GalioRunicSkin. L’INIBIN lie exactement game_buff_tooltip_GalioRunicSkin, ligne1930 du font anglais ; la description du champion, ligne4188, précise **50% de la résistance magique totale convertie en puissance**. Le fournisseur de la valeur dynamique f1 reste inconnu. SpellBlock vaut32.099998474121094 et SpellBlockPerLevel1.25 ; BaseSpellBlock est absent, il n’est pas remplacé par une valeur inventée.

Les deux Lua sont entièrement parsés et sans prototype de callback enfant. Le buff de214octets fournit littéralement nom, texture Galio_RunicSkin.dds et booléens de persistance/non-dissipation ; le CharScript de56octets ne contient qu’un RETURN. Le preload mentionne galiorunicskin et apbonusdamagetotowers. Aucune VM, activation, effectivité des booléens ou présentation n’est déduite de ces métadonnées.

Le vieux Passive1Desc décrit1AP pour3armure et3RM, alors que la description liée décrit50% de la RM totale. Il est conservé sans adoption. Passive1=9 et les niveaux3/7/11 restent des valeurs littérales dont la fonction et l’activation initiale ne sont pas qualifiées. Les quatre clés PassLev1Desc1..4 identiques ne prouvent pas de progression de rang. Les deux JSON communautaires et le CharScriptGalio.cs vide de cette copie sont pinés avec provenance et ne deviennent pas le serveur original.

## Consommateur courant et essai réel

Le chemin relie join, Buy/Sell, buy_item/sell_item, refresh_item_caps, shop::bonuses, stats, altar_damage_multiplier et advance. Le calcul courant d’AP utilise les objets et le multiplicateur éventuel d’autels ; celui de RM combine base, croissance, objets, défense temporaire, réduction Exhaust et ajustement TrundleR. Ces branches sont identifiées dans le code et pinées, mais les modificateurs temporaires et leur ordre natif ne sont pas exercés ici. Aucun calcul de conversion Galio n’est démontré par les statistiques génériques.

Deux parties Map10 utilisent le core non-test et la navigation réelle : Galio puis Ahri témoin. Commandes publiques uniquement : achat1033,30ticks,vente ; achat1052,vente ; achat1029,vente. Aucun champ de statistique, or, expérience ou passif n’est injecté. Les ventes financent les achats suivants ; le champion reste vivant au niveau1, sans victoire.

| Cas Galio | RM observée | AP observée | AP correspondant au texte50%RM |
|---|---:|---:|---:|
| Apparition |32.099998474121094|0.0|16.049999237060547|
| Cape1033 (+25RM) |57.099998474121094|0.0|28.549999237060547|

Le delta textuel serait12.5AP. L’absence de bonus persiste sur les30ticks échantillonnés. Le Tome1052 ajoute20AP et l’Armure1029 ajoute15armure sans modifier RM/AP. Les ventes rétablissent32.099998474121094RM et0AP. Ahri passe de30à55RM avec la Cape, reste à0AP, reçoit20AP du Tome et retrouve ses valeurs initiales. Les prédictions du passif ne sont pas attribuées au témoin.

Ces essais constatent un écart au texte **dans les scénarios de niveau1 testés**. Ils ne résolvent ni l’interprétation des anciennes valeurs de niveau, ni l’activation initiale du passif original, ni les comportements aux autres niveaux, réductions négatives, multiplicateurs, mort ou transitions. La stabilité de statistiques incomplètes ne vaut pas acceptation du passif.

Dix refus publics : joueur inconnu, objet inconnu, case hors limites, case vide et or insuffisant pour chaque partie. Chaque refus est entouré de sa propre comparaison de snapshot complet, identique avant/après. Les contrôles positifs des trois types d’objet et des ventes passent ; la réussite du diagnostic démontre les observations, pas une fidélité du passif.

Compilation et exécution retournent0. Core en cache Cargo, non-test ;1158 entrées source/ressource, anciens artefacts et identité/checksums des paquets du Cargo.lock racine inchangés. Binaire exécuté : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-galio-passive-conversion-probe.exe` ;5998592octets ; SHA-256 `36803f17bedd74d09c5212be070a35fc50b10eca3892407103f1071f4dd2f52a`. Source, outils, manifestes, verrous, logs et commandes pinés dans `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision546_Galio_passive_probe\OBSERVATIONS.json`. Aucun client historique, serveur natif, GPU, réseau, audio ou validation visuelle exécuté.

## Contrôles de livraison

Discovery, inspection, prepare, check, publish et audit réussis.60 associations invalides et quatre graphes invalides refusés : faux bonus, tiers armure/RM adopté, anciennes valeurs prises pour activation, sources ou binaire altérés, faux consommateur, question étrangère ou dépendance retirée. Quatre preuves ajoutées ; anciens descripteurs conservés.

Par base réelle : quatre destinataires actualisés,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques exacts. Store.task/copy_text/summary, questions/dépendances, integrity_check et sync_catalog idempotent vérifiés. Trois fragments changent,42212 restent exacts ;42211 autres objets tâche/trace préservés. IDs, hiérarchie et registre des inconnus identiques en octets.

Réexamen :42215 exigences,98860 sources,2865 consommateurs ;26189 questions ouvertes et5517 résolues.2865 ancres et527 fichiers actuels exacts, zéro divergence ;17 auxiliaires conservés. Ce n’est pas un nouveau census physique de toutes les sources.8346CH au seul chargeur partagé désigne une file de recherche, pas un taux de complétion.

## Livrables et suite

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json et fidelity_sources_4_20.json. Reçu docs/reference_requirement_trace_sources/galio-passive-conversion-links-v546.json ; preuve docs/fidelity_galio_passive_conversion_links_v546.json. Quatre lignes données/consignes changent par base. Couverture, plan documentaire, reprise, CURRENT et HANDOFF actualisés avec sauvegardes ; anciens champs conservés. Scripts sur F et archivés. Aucun code gameplay/asset changé ni stage/reset/commit.

Restent à qualifier les producteurs du passif et de f1, activation initiale, niveaux, réductions temporaires, ordre avec multiplicateurs, arrondis, mort, affichage et corps serveur original. Les acquis V545 et antérieurs restent conservés.

Continuer SYS-01.2-02 depuis revision547_trace_review/REVIEW.json. V546 Galio publié/audité : trois fiches,six sources natives,18arêtes,20liens vers10frontières ;3questions propres/4dépendances conservées. Au niveau1,MR32.1 puis57.1avec1033,AP0 dans les deux cas contre16.05/28.55textuels ; Tome1052 AP20,Armure1029 armor15 sansMR/AP,30ticks stables,ventes et Ahri témoins. Dix refus avec snapshots individuels exacts. Texte totalMR50% qualifié ; f1,activation initiale,niveaux,modificateurs temporaires,ordre,mort ouverts. Ancien texte tiers armure/RM,Passive1=9,niveaux3/7/11 conservés sans adoption. Aucun gameplay modifié/passif accepté. Ne pas republier ni relancer sans cause nouvelle. Examiner ensuite Rammus : Spiked Shell,conversion25%armure enAD ; identifier nom exact,INIBIN/Lua/preload et producteurs courants de stats/AD avant diagnostic. Le lookahead anglais4259 et tooltip2702 f1/f2 ne qualifie pas encore leurs producteurs.106autres contrats/parents de passifs restent à examiner ;8346CH au seul chargeur partagé reste une file de recherche,pas un taux de complétion. Goal actif.
