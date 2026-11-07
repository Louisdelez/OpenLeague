# SYS-01.2-02 — Shen : Ki Strike, V549

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue 4.20.1 distinct. **Traçabilité partielle ; aucun passif, champion ou jeu accepté.**

## Résultat intégré

Les trois fiches CH-Shen-PASSIF-SOURCE, CH-Shen-PASSIF-SIMULATION-CONTRAT et CH-Shen-PASSIF-SIMULATION sont reliées à 18 sources natives, soit 54 arêtes. Les deux fiches de simulation reçoivent 32 liens vers 16 points du code courant, qualifiés `entry_boundary_only` et `provides_feature_consumer=false`. Le chargeur et les lecteurs historiques restent conservés sans devenir une implémentation du passif. SYS-01.2-02 référence ce lot.

Les phases, lots, prérequis, dépendances et propriétaires des questions sont relevés dans le reçu. Trois questions propres et quatre dépendances sont conservées. Aucune question n’est ajoutée ou résolue ; aucune case cochée, aucun statut ou critère modifié.

## Sources natives et divergences

| Fichier | Identifiant |
|---|---|
| Shen.inibin | OLS-694cb940-aca7-5b40-ba31-1f0bcf2b6244 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Shen Passive Aura.inibin | OLS-d9bd9a27-a902-51df-a758-a0887032bafe |
| Shen Passive Cooldown.inibin | OLS-ee5cea5b-e9d1-58ed-8fb7-dac5ec876551 |
| Shen Passive Marker.inibin | OLS-4983641a-fb2c-5350-bac7-7b1f32b60a3a |
| ShenKiAttack.inibin | OLS-9606da11-a764-50a4-9f92-edeb93bf7041 |
| ShenKiAttack.luaobj | OLS-b6043b07-9f5e-594d-8782-04e75a0b545a |
| ShenKiAttack.preload | OLS-509333e9-381d-5413-a210-d3b13db8b7ec |
| ShenPassiveHardCooldown.luaobj | OLS-733ca9d5-ea3a-5c6f-a0ab-44bf7b49d96b |
| ShenPassiveHardCooldown.preload | OLS-1412602a-9283-59ed-a792-308a1f444e48 |
| ShenWayOfTheNinjaAura.luaobj | OLS-e319cee7-e8aa-5006-ac93-27af1d362c31 |
| ShenWayOfTheNinjaAura.preload | OLS-591bbfb0-45dd-5eb4-bd7f-2037fc91cf7f |
| ShenWayOfTheNinjaCooldown.luaobj | OLS-36b09ca9-dfc7-5bb9-adc8-0d81ef46b825 |
| ShenWayOfTheNinjaMarker.inibin | OLS-5c7e4354-dd62-5a4b-9e1b-1beeafa153ac |
| ShenWayOfTheNinjaMarker.luaobj | OLS-a9de56a5-52fd-56e6-a61e-93cde4454f36 |
| ShenWayOfTheNinjaMarker.preload | OLS-d29402a0-38e0-5476-83a0-fe74554c199c |
| CharScriptShen.luaobj | OLS-140f5f19-ed0e-5b09-8a9d-7baff70427f3 |
| CharScriptShen.preload | OLS-fdd74203-e34a-50f0-9b8d-58b66bf440fc |

Les 18 fichiers correspondent en taille/SHA au registre et en taille/MD5 aux projets sélectionnés du manifeste RADS. La découverte V549, effectuée au tour précédent, est revalidée et réutilisée. Cette sélection ne constitue ni un recensement mondial des sources ni une preuve du serveur original.

La définition lie `Passive1LuaName=ShenWayOfTheNinjaMarker`, le nom et la description `Shen_WIP`. Cette description indique **8 secondes**. `ShenWayOfTheNinjaMarker.inibin` lie directement l’infobulle `Shen_Passive_Marker`, qui indique **9 secondes**, une récupération d’énergie f2, des dégâts magiques f1 + f3 **[10% de vie bonus]**, et une réduction de recharge de **1 seconde par attaque sur champion ou sbire**. Les trois INIBIN espacés Aura/Cooldown/Marker lient également leurs textes. Quatre bindings de buff sont donc établis, sans décision de priorité historique.

`ShenKiAttack.inibin` lie une description parlant de **vie maximale**. Sa DynamicTooltip indique un texte qui ne devrait pas être affiché ; sa description ne remplace pas arbitrairement le marker. Les fournisseurs f1/f2/f3, le délai effectif et la base de calcul restent ouverts. Les champs CooldownTime sondés sont absents ; cela ne démontre ni recharge nulle ni absence de tout autre champ de recharge. Les valeurs brutes restent dans la découverte.

Six Lua sont entièrement parsés, sans prototype de callback enfant ; cinq preloads sont conservés. Le marker déclare son nom, son icône et des booléens ; Aura et les deux variantes Cooldown gardent leurs noms et chaînes vides exacts. Le CharScript ne fournit pas le corps serveur du passif. Les preloads citent notamment aura, marker, hard cooldown, particle de disponibilité, globalhit_red, isninja et apbonusdamagetotowers ; une déclaration de ressource ne prouve ni activation ni rendu.

L’initialisation littérale de `ShenKiAttack.luaobj` s’arrête sur **NEWTABLE à pc10**, bien que le fichier soit entièrement parsé. Les constantes de flags et `TPAShen` ne sont pas promues en affectations ou comportements exécutés. C’est une limite du lecteur, pas une corruption démontrée.

Les anciens textes Jax, mana +40/+60/+80%, Passive1=9 et niveaux3/7/11 sont conservés sans adoption. Six références communautaires, dont le CharScript C# vide, restent d’origine communautaire. Les champs natifs BaseMP="200.0" et BaseStaticMPRegen="10.0" restent distincts des nombres convertis courants.

## Consommateur réel et diagnostic

Le chemin inspecté couvre join, stats, somme des objets, achats/ventes, rafraîchissement des plafonds, commande Attack, tick d’attaque, libération mêlée, basic_attack_hit, apply_damage, régénération, tick général, Cast ciblé, classification de ressource et calcul de son débit. Le code actuel de l’impact applique les dégâts physiques ordinaires et les mécanismes génériques présents ; les points relevés ne sont pas déclarés producteurs de Ki Strike.

Trois parties Map10 réelles, Shen contre Ahri, au niveau1 : sans objet, Rubis1028 et Épée longue1036. Achats, ventes, rachats, déplacements, arrêt et attaques passent par l’API publique. Aucune injection de vie, dégâts, XP, or, ressource ou position. Ahri reste arrêtée ; les acteurs restent vivants, au niveau1, sans victoire.

Avant chacune des trois attaques de chaque partie, les acteurs restent arrêtés pendant **271 ticks**, soit plus que les deux délais textuels à 30Hz. Fenêtres816..1087,1096..1367,1376..1647 ; impacts1096,1376,1656. Ces fenêtres ne qualifient ni disponibilité initiale, ni recharge native, ni réduction par attaque. Les trois coups sont séparés ; le mécanisme de réduction sur des attaques rapprochées n’est pas testé.

| Cas | PV maximum | Dégâts d’attaque | Perte par coup après régénération |
|---|---:|---:|---:|
| Sans objet |570.7999878|60.1699982|49.7766418|
| Rubis1028 |720.7999878|60.1699982|49.7766418|
| Épée1036 |570.7999878|70.1699982|58.0493164|

Les neuf pertes correspondent à la prédiction physique courante, après armure et régénération d’Ahri, avec tolérance0.002PV. Résidu maximal1.1444091796875e-05PV, conservé comme arrondi. Aucun supplément de passif n’est observé dans ces cas. Les achats/ventes/rachats valident les variations et leur réversibilité ; le Rubis ne prouve pas une guérison instantanée.

L’énergie reste à son plafond200 ; le débit générique exposé vaut10/s. **Une restauration de Ki Strike n’est pas observable à ce plafond.** Les quatre emplacements de Cast ciblé refusent avec `champion spell not implemented` ; aucun coût n’est injecté pour simuler un sort fonctionnel. Le test ne couvre pas toutes les autres routes possibles de dépense. Les cibles sbires, structures et autres classes ne sont pas testées.

27 refus publics, chacun avec snapshot complet inchangé : joueur inconnu, cible inconnue, cible soi-même, objet inconnu, emplacement de vente invalide et quatre Cast ciblés, dans chacun des trois cas. Ces refus vérifient les limites courantes, pas la fidélité des sorts originaux.

## Exécution, intégration et conservation

Build et exécution terminés avec code0 ; core non-test réutilisé du cache Cargo. 1158 entrées source/ressource et les anciens artefacts restent identiques. Identités et checksums des dépendances du verrou privé alignés sur le Cargo.lock racine.

Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-shen-passive-onhit-probe.exe` ; 6031872 octets ; SHA-256 `8ff34bf5e6886981be02d3db9e3499be80d0a88a3a8c95e47ba8b3c5bfc46f29`. Commandes, sources Rust, compilateur, Python, manifestes, verrous et logs sont identifiés dans `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision549_Shen_passive_probe\OBSERVATIONS.json`. Aucun processus historique, VM originale, GPU, réseau, audio ou contrôle visuel exécuté.

Inspection, prepare, check, publish et audit réussis. **72 associations invalides et quatre graphes invalides refusés** : énergie pleine assimilée à une restauration, délai/base de vie résolus sans preuve, NEWTABLE assimilé à une corruption, anciens champs ou skin adoptés, source/binaire modifié, question étrangère ou dépendance retirée. Les garde-fous sont spécifiques aux preuves et à la conservation du plan ; ils ne valident pas le gameplay.

Deux bases réelles : quatre destinataires actualisés par base,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques exacts. Store.task/copy_text/summary, questions/dépendances, intégrité et synchronisation idempotente vérifiés. Trois fragments changent,42212 restent exacts ;42211 autres objets tâche/trace conservés. IDs, hiérarchie et registre des inconnus identiques en octets.

Graphe :42215 exigences,98872 sources,2909 consommateurs,26189 questions ouvertes et5517 résolues. Le réexamen confirme2909 ancres et527 fichiers actuels exacts, sans divergence ;17 auxiliaires conservés. Aucun nouveau recensement physique des98k sources. Les8340 tâches champion au seul chargeur partagé sont une file de recherche, pas un taux de complétion.

## Fichiers et limites restantes

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json et fidelity_sources_4_20.json. Reçu : docs/reference_requirement_trace_sources/shen-passive-onhit-links-v549.json. Preuve : docs/fidelity_shen_passive_onhit_links_v549.json. Couverture, plan documentaire, reprise, CURRENT et HANDOFF actualisés avec conservation des anciens champs et sauvegardes. Scripts exécutés archivés. Aucun code de jeu ou asset modifié, aucun stage/reset/commit.

Restent ouverts : corps serveur du passif, f1/f2/f3, conflit8s/9s, vie bonus/vie maximale, disponibilité initiale, réduction/recharge, récupération d’énergie, niveaux/cibles, mort, ordre et flags, skinTPAShen et présentation. Les métadonnées et le diagnostic ne résolvent pas ces questions. V548 et tous les artefacts antérieurs restent conservés.

Continuer SYS-01.2-02 depuis revision550_trace_review/REVIEW.json. V549 Shen publié/audité : 3 fiches,18 sources natives,54 arêtes,32 liens vers16 frontières ;3 questions propres/4 dépendances conservées. Neuf attaques contre Ahri,après271ticks arrêtés chacune :49.77664PV sans objet/Rubis,+150PV max sans supplément ;58.04932PV avec Épée+10AD. Résidus physiques max1.14441e-05PV. Énergie200 pleine,restauration du passif non observable. Quatre Cast ciblés non implémentés par cas ;27 refus individuels. La définition lie Marker et WIP8s,le marker9s ;vie bonus contre vie maximale dans le texte du sort,f1/f2/f3 et politique native ouverts. Six Lua sans callbacks ;KiAttack NEWTABLEpc10 non qualifié,pas corruption. Aucun gameplay modifié/passif accepté. Ne pas republier ni relancer sans cause nouvelle. Examiner ensuite le passif Amumu : identifier la définition,les variantes Cursed Touch,les bindings/valeurs/durée et les consommateurs actuels de résistance magique avant tout diagnostic.103 autres contrats/parents de passifs restent à examiner ;8340 CH au seul chargeur partagé est une file de recherche,pas un taux de complétion. Goal actif. Découverte Amumu déjà effectuée et revalidée dans revision550_Amumu_discovery/OBSERVATIONS.json :8 sources natives,2 bindings de buff,3 Lua sans callbacks enfants,1 preload et4 références communautaires. Définition/marker CursedTouchMarker ; texte3s avec f1 non résolu. Ancienne description20/30/40/50 et niveaux1/9/17 conservés sans adoption ; textes underscore/Self restent distincts. Aucun NightmareBot promu. Runtime,inspection qualifiée et publication Amumu restent à faire ; ne pas relancer la découverte sans cause nouvelle.
