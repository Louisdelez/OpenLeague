# SYS-01.2-02 — Akali : Twin Disciplines, V557

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 à17:46:45, fuseau et déploiement inconnus. Catalogue4.20.1 distinct. **Traçabilité partielle ; aucun passif, champion ou jeu accepté.**

## Résultat intégré

CH-Akali-PASSIF-SOURCE, CH-Akali-PASSIF-SIMULATION-CONTRAT et CH-Akali-PASSIF-SIMULATION reçoivent39associations vers13fichiers natifs. Les deux fiches de simulation reçoivent34liens vers17points de code, tous entry_boundary_only et provides_feature_consumer=false pour ce passif. SYS-01.2-02 référence le lot. Chargeurs et lecteurs antérieurs conservés sans promotion en mécanique terminée.

Prérequis de phase et de lot relevés dans le reçu. Trois questions propres et quatre dépendances conservées ; aucun statut, critère, identifiant, case, note ou historique manuel modifié. Aucun code du jeu ni asset modifié.

## Sources

| Fichier | Identifiant |
|---|---|
| Akali.inibin | OLS-b0f76dda-13f2-5173-bdd8-19f0ecd02a13 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptAkali.luaobj | OLS-e03d9685-a338-5a67-8a86-883331aee349 |
| CharScriptAkali.preload | OLS-63ecc64b-ad14-5e25-ba83-80536339e5c5 |
| AkaliTwinAP.inibin | OLS-a5aeb0e4-2473-5679-9fc1-b7f061928d07 |
| AkaliTwinAP.lua.inibin | OLS-1e049e2b-8f29-54b3-8e88-415fc701275d |
| AkaliTwinAP.luaobj | OLS-4627c1fd-93f9-5dda-a89f-bc52962a991c |
| AkaliTwinAP.preload | OLS-1b1ca63e-4a91-591c-9158-05aeaa56d2ad |
| AkaliTwinDisciplines.inibin | OLS-6fbd5919-4e3a-5f32-bbcd-9acdd500b023 |
| AkaliTwinDisciplines.luaobj | OLS-feeb9e77-8d5b-5ec7-95d4-799b554d306a |
| AkaliTwinDisciplines.preload | OLS-72f7559a-fb37-53b5-bfcc-392377d3cf65 |
| AkaliTwinDmg.inibin | OLS-12a72376-760d-57fe-8958-85ad6c8d7f2f |
| AkaliTwinDmg.luaobj | OLS-451bc9e9-8bb1-5043-a391-ed1afb30cd71 |

Taille/SHA256 conformes au registre ; taille/MD5 conformes aux projets RADS sélectionnés lors de la découverte. Identités revérifiées à l’inspection. AkaliTwinAP.lua.inibin est un fichier distinct conservé, sans renommage ni substitution.

Trois bindings INIBIN vers AkaliTwinAP, AkaliTwinDisciplines et AkaliTwinDmg. Texte1673 et description4151 : dégâts magiques supplémentaires de6%, augmentés de1% par6AP ; SpellVamp6%, augmenté de1% par6bonusAD. Les fournisseurs f1/f2, la base de calcul, les unités, l’arrondi et les interactions doivent encore être qualifiés. Les textes distincts de dégâts et de soin restent reliés à leurs fichiers respectifs.

Quatre Lua entièrement parsés, sans prototype de fonction enfant. CharScriptAkali n’a pas de globals littéraux. TwinAP et TwinDmg déclarent une icône AkaliTwinDisciplines.dds et les effets sur R_hand/L_hand. TwinDisciplines déclare BuffTextureName33.dds, différent de Passive1Icon. Nondispellable et NonDispellable sont conservés tels quels ; aucune équivalence de casse présumée. Trois preloads ne prouvent pas le rendu des effets.

Passive1, Passive1Desc et les trois niveaux sont absents de la définition sélectionnée : aucun défaut inventé. Cinq références communautaires sont conservées séparément. Le C# OnActivate contient littéralement `6 + bonusAd % 6` dans SpellVamp.PercentBonus : cette expression n’est pas adoptée comme formule historique ni comme preuve d’unités correctes. Aucun serveur ou VM native exécuté.

## Consommateurs et contrôles

Points inspectés : join/stats, Learn/next_rank, commande, Cast/CastAt, achat/vente/bonus d’objets, attaques de mêlée, basic_attack_hit, apply_damage, heal, régénération/taux et tick. Le chemin ordinaire applique des dégâts physiques puis le vol de vie de l’objet. Le simple accès aux statistiques ou au soin générique ne fournit pas le passif Akali.

Quatre parties Map10 publiques, niveau1, Akali face à Garen. Achat normal, déplacement à portée, quatre attaques reçues puis arrêt de Garen. Akali effectue ensuite trois attaques normales. Les personnages restent vivants, sans fin de partie. Aucune injection directe de PV, mana, or, XP, dégâts, position ou effets.

| Objet | AD actuel | AP actuel | Dégâts physiques prédits | Soin supplémentaire observé/attaque | Refus |
|---|---:|---:|---:|---:|---:|
|None|58.375999|0.0|45.772175|0.000000|17|
|1052|58.375999|20.0|45.772175|0.000000|5|
|1036|68.375999|0.0|53.613098|0.000000|5|
|1053|68.375999|0.0|53.613098|4.289062|5|

Les impacts sortants surviennent aux ticks947,990,1033 dans chaque cas. Les dégâts observés, après prise en compte de la régénération de la cible avant l’impact, correspondent à la prédiction physique. Résidu maximal environ0.0000191PV, inférieur à0.002PV. Le Tome1052 donne20AP mais aucun supplément magique observé. L’Épée1036 ajoute10AD et augmente les dégâts physiques de45.77217 à53.61310PV. Le Sceptre1053 donne le même AD et environ8% de vol de vie :4.2890625PV restaurés par attaque. Ce soin est celui de l’objet, pas une validation de Discipline of Might.

Les PV manquants restent suffisants pour éviter l’écrêtage du soin au plafond. Trente ticks après arrêt des attaques par cas, soit120, suivent uniquement la régénération ordinaire. Aucun sort n’est exécuté : les quatre Learn, quatre Cast et quatre CastAt du cas sans objet sont refusés comme non implémentés. Ces refus sont vérifiés à portée de combat.

32refus individuels avec snapshot complet inchangé : cinq gardes communes par cas (joueur inconnu, cible inconnue, cible soi, objet inconnu, vente hors slots), plus les douze commandes de sorts d’Akali. Les attaques sont de mêlée, non critiques, sans pénétration d’armure ni bouclier de la cible dans les impacts observés.

## Manques et limites

- Aucun producteur de dégâts magiques du passif n’est qualifié ; les12attaques testées montrent seulement le chemin physique ordinaire, y compris avec20AP.
- Les sorts d’Akali sont refusés dans les routes testées. Le déclenchement et les règles du SpellVamp restent non qualifiés.
- f1/f2, base arithmétique des pourcentages, progression, niveaux, cibles, dégâts de zone ou persistants, ordre des modificateurs, mort/réapparition et présentation restent ouverts.
- Les valeurs de sources, métadonnées Lua et références communautaires ne prouvent pas l’exécution du jeu original. Aucun client historique, serveur original, GUI, GPU, audio ou réseau exécuté.

## Vérifications et conservation

Build/run, inspection, préparation, contrôle de candidat, publication et audit :code0. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-akali-passive-twin-disciplines-probe.exe` ;6040576octets ;SHA256 `2fe58febcfc321babe6bf7d13295edd0d6a2913a5df0fde6d473829e1124becf`. Reçu runtime `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision557_Akali_passive_probe\OBSERVATIONS.json`, logs BUILD/RUN conservés.1158entrées de code/ressources et anciens artefacts exacts ;verrou privé aligné sur Cargo.lock racine. Le core non-test est issu du cache ;aucun nouveau passage de toute la suite historique revendiqué.

72associations invalides et4graphes invalides rejetés, dont vol de vie présenté comme passif, AP présenté comme dégât magique exécuté, modulo communautaire présenté comme règle native, icônes/casse normalisées sans preuve, f1/f2 inventés, question étrangère et dépendance supprimée.

Deux bases SQLite réelles :4destinataires chacune ;42603autres lignes de catalogue,42607états manuels et23événements historiques inchangés. Store.task/copy_text/summary, dépendances, résolution des références, intégrité et synchronisation idempotente vérifiés. Trois fragments de trace changés,42212 inchangés. IDs, hiérarchie et inconnus identiques en octets.

Graphe42215exigences,98904sources,3047consommateurs ;3047ancres et527fichiers courants exacts, zéro divergence.26189questions ouvertes/5517résolues. Pas de nouveau recensement physique de toutes les sources ;8324fiches CH au seul chargeur partagé constituent une file de recherche, pas un taux d’achèvement.

## Fichiers et suite

completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json ; reçu docs/reference_requirement_trace_sources/akali-passive-twin-disciplines-links-v557.json ; preuve docs/fidelity_akali_passive_twin_disciplines_links_v557.json ; couverture, plan, reprise, CURRENT et HANDOFF avec sauvegardes. Scripts archivés, anciennes preuves conservées. Aucun stage/reset/commit.

Continuer SYS-01.2-02 depuis revision558_trace_review/REVIEW.json. Akali V557 publié/audité :13sources natives,39arêtes,17points actuels/34liens false. Quatre cas publics sans objet/Tome1052/Sword1036/Vamp1053 :16coups entrants,12attaques,120ticks,32refus. AP20 laisse les dégâts physiques45.77217 inchangés ;AD+10 donne53.61310 ;pas de supplément magique observé. Vamp soigne4.28906 via lifesteal ordinaire. Akali Learn/Cast/CastAt refusés ;SpellVamp non qualifié.3bindings,4Lua sans callbacks,3preloads,5références communautaires. C#6+bonusAd%6 non adopté ;icône33.dds et Nondispellable/NonDispellable non normalisés. f1/f2,formules,cibles,niveaux et présentation restent ouverts. Aucun gameplay changé,statut/case/inconnue fermé. Examiner ensuite Anivia/Rebirth,Rebirth Marker et AniviaEgg :relier les sources et frontières de dégâts létaux,mort,respawn et transformation,avec un contrôle public sans injection. Ne pas republier V557 sans cause nouvelle. Goal actif. Découverte Anivia déjà faite :revision558_Anivia_discovery/OBSERVATIONS.json,18sources natives dont AniviaEgg.inibin,4bindings,7Lua sans callbacks,4preloads,7références communautaires. Rebirth.luaobj est parsé mais lecture littérale limitée par NEWTABLEpc16 ;pas une corruption. RebirthReady déclare OnPreDamagePriority8 ;RebirthMarker porte BuffName Rebirth Marker. Texte2516 :dégâts létaux,œuf pleine vie,f1armure/MR,6secondes,4minutes de recharge ;producteur f1 et politique native non résolus. Anivia niveaux absents,AniviaEgg1/4/7 distincts sans adoption. Scripts AnimationPlay/Reset portent BuffNameRebirthCooldown :ne pas confondre nom et animation exécutée. Le code courant damage.rs programme base_death_ticks puis lifecycle.advance_respawns ;contrôle public létal à réaliser,aucune transformation ou renaissance qualifiée. NightmareBotSpiritAnivia et ZacRebirth exclus. Ne pas refaire découverte sans cause nouvelle.
