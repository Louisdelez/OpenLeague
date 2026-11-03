# SYS-01.2-02 — Veigar : Equilibrium, V554

25 octobre2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ;build littéral2014-11-17 à17:46:45,fuseau/déploiement inconnus. Catalogue4.20.1 distinct. **Traçabilité partielle ;aucun passif,champion ou jeu accepté.**

## Résultat intégré

CH-Veigar-PASSIF-SOURCE, CH-Veigar-PASSIF-SIMULATION-CONTRAT et CH-Veigar-PASSIF-SIMULATION reçoivent12arêtes vers4sources natives. Les deux fiches de simulation reçoivent34liens vers17points actuels,qualifiés entry_boundary_only et provides_feature_consumer=false. SYS-01.2-02 référence le lot. Les lecteurs et chargeurs partagés restent conservés sans promotion en implémentation du passif.

Phases,lots et prérequis sont relevés dans le reçu. Trois questions propres et quatre dépendances conservées ;aucun inconnu ajouté/fermé ;aucun statut,critère,case,note ou historique manuel modifié.

## Sources natives et provenance

| Fichier | Identifiant |
|---|---|
| Veigar.inibin | OLS-dfe083ce-3762-550a-a87f-2ca2d8c52a30 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| VeigarEquilibrium.inibin | OLS-5cfdc1f9-1c59-5d2e-b127-e5d071b6fb12 |
| VeigarEquilibrium.luaobj | OLS-1d30c672-6ea6-5f35-8b3f-202d36481fcc |

Les4fichiers correspondent en taille/SHA au registre et en taille/MD5 aux projets RADS sélectionnés. Découverte précédente revalidée. Le INIBIN et Lua VeigarEquilibrium sont dans Characters/Veigar/Spells. CharScriptVeigar.luaobj/.preload sont absents du seul répertoire Scripts sélectionné ;cette absence locale ne signifie pas que le passif ou le serveur manque partout. IreliaEquilibriumStrike ne fait pas partie de cette association.

La définition Passive1LuaName et BuffName concordent sur VeigarEquilibrium. L’INIBIN lie game_buff_tooltip_VeigarEquilibrium,ligne2866 :régénération de mana augmentée de1% par1% de mana manquant. La description du champion4301 concorde. Un Lua entièrement parsé,sans callback enfant,avec initialisations littérales (dont DoesntTriggerSpellCasts=true,IsDamagingSpell=false,PersistsThroughDeath et NonDispellable). Cela ne prouve pas une exécution du serveur original.

Passive1 vaut1. Le Passive1Icon Veigar_Entropy.dds diffère du BuffTextureName VeigarEntropy.dds ;aucune réécriture automatique. Ancienne description de dégâts de Dr.Mundo sous40%PV,descriptions+40/60/80%regen et niveaux1/9/17 conservés sans adoption. Trois références communautaires (C# CharScript,stats,sort) restent distinctes. Aucun preload de passif dans la sélection ;aucun rendu d’icône ou comportement serveur déduit.

## Consommateurs actuels et cas exécutés

Chemins inspectés :join/stats,Learn/next_rank,commande,Cast/CastAt,achat/vente/plafonds/catalogue,régénération et taux,tick,interactions de fontaine et classification mana/ressource. La formule courante de régénération utilise base,niveau et objets,sans terme de mana manquant. L’achat augmente les plafonds en conservant les pools absolus selon une reconstruction communautaire commentée dans refresh_item_caps ;cette politique n’est pas qualifiée comme native.

Quatre parties Map10 publiques,niveau1,acteurs vivants et immobiles au spawn. Achat ordinaire1027 (400or,+200mana),puis1004 dans un cas (180or,+25%regen de base),depuis825or initiaux. Aucun PV,mana,or,XP,position,dégât ou effet injecté. Les achats conservent le mana courant. Les29premiers ticks sont observés avant la première pulsation de fontaine au30,d’après la configuration courante1seconde et30ticks/s.

| Cas et objets | Mana maximum | Mana initial | Taux actuel/s | Mana après29ticks | Mana après30ticks |
|---|---:|---:|---:|---:|---:|
|veigar []|342.3999939|342.3999939|1.2000000|342.3999939|342.3999939|
|veigar [1027]|542.4000244|342.3999939|1.2000000|343.5602417|424.9602661|
|veigar [1027, 1004]|542.4000244|342.3999939|1.5000000|343.8496399|425.2596436|
|annie [1027]|534.0000000|334.0000000|1.2000000|335.1602478|415.3002625|

Avec Sapphire,Veigar commence à342.3999939/542.4000244mana,soit36.87316% manquant. Durant29ticks,son taux reste1.2000000477mana/s ;avec le Charme il vaut1.5. Le déficit reste supérieur à100mana :aucun écrêtage au plafond. Dans les deux cas,les valeurs observées sont exactement celles de la base et de l’objet,pas d’un supplément lié au mana manquant. Le cas plein vérifie le plafond ;il ne pourrait pas prouver Equilibrium. Annie avec Sapphire fournit un contrôle distinct de la régénération commune.

Au tick30,la fontaine ajoute15% du plafond courant,soit81.3600082mana dans les deux cas Veigar avec Sapphire,puis la régénération ordinaire s’applique. Cette pulsation explique le saut de mana et **ne prouve pas Equilibrium**. Le diagnostic conserve séparément la borne de mana plein,les87ticks non écrêtés des trois cas Sapphire,les116ticks pré-fontaine totaux et les4ticks30.

Le multiplicateur illustratif1+fraction manquante est enregistré pour lire le texte ;il n’est pas adopté comme algorithme natif float32 ni comme ordre qualifié des modificateurs d’objets. Autres niveaux,autres déficits,sorts consommant effectivement du mana,mort/réapparition et présentation restent ouverts.

32refus publics,chaque fois snapshot complet inchangé :5gardes communes par cas (joueur inconnu,objet inconnu,vente hors slots,slots Cast/Learn invalides),plus4Learn/4Cast/4CastAt pour Veigar avec Sapphire. Ces12tentatives retournent skill progression/spell/ground spell not implemented. Aucun sort fonctionnel n’est déduit de ces refus.

## Exécutions et correction analytique

Build et run initiaux code0,avec toutes les assertions Rust réussies. Le vérificateur Python a ensuite échoué sur l’égalité exacte entre base+200 en binary64 (542.3999938964844) et plafond Rust float32 (542.4000244140625),écart0.000030517578125. Le contrôle corrigé arrondit l’addition au float32,comme le code courant. Il reproduit les deux comparaisons anciennes incorrectes,puis relit les mêmes logs et le même binaire :**aucune recompilation ni réexécution**. Le premier script et ses données restent conservés ;aucun code du moteur modifié.

Core non-test issu du cache ;1158entrées source/ressource et anciens artefacts exacts. Identités/checksums du verrou privé alignés sur Cargo.lock racine. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-veigar-passive-missing-mana-regeneration-probe.exe` ;6025216octets ;SHA256 `c98bd9d0ec2a06ba6757bb3bf6b0a59741af04fa9f5b85af46433814017de0b5`. Reçu qualifié `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision554_Veigar_passive_probe_qualified\OBSERVATIONS.json` ;logs originaux dans revision554_Veigar_passive_probe. Aucun client historique,serveur original,VM Lua,GUI,GPU,audio ou réseau exécuté.

Inspection,prepare,check,publish,audit réussis.72associations invalides et4graphes invalides refusés,dont fontaine/Charme assimilés à Equilibrium,réserve pleine présentée comme validation,icônes réécrites comme identiques,absence locale présentée comme globale,fausse règle native d’achat,question étrangère ou dépendance retirée.

Deux bases réelles :4destinataires actualisés par base ;42603autres lignes de catalogue,42607états manuels et23événements historiques exacts. Store.task/copy_text/summary,dépendances/questions,intégrité et synchronisation idempotente vérifiés.3fragments modifiés,42212exacts ;42211autres objets tâche/trace conservés. IDs,hiérarchie et inconnus identiques en octets.

Graphe42215exigences,98892sources,2995consommateurs ;26189questions ouvertes/5517résolues.2995ancres et527fichiers courants exacts,zéro divergence. Aucun nouveau recensement physique des98k sources.8330CH au seul chargeur partagé est une file de recherche,pas un taux d’achèvement.

## Fichiers et suite

Registres :completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json. Reçu docs/reference_requirement_trace_sources/veigar-passive-missing-mana-regeneration-links-v554.json ;preuve docs/fidelity_veigar_passive_missing_mana_regeneration_links_v554.json. Couverture,plan,reprise,CURRENT et HANDOFF actualisés avec sauvegardes. Scripts archivés ;V553 et preuves antérieures conservés. Aucun gameplay/asset modifié ;aucun stage/reset/commit.

Continuer SYS-01.2-02 depuis revision555_trace_review/REVIEW.json. V554 Veigar publié/audité :3fiches,4sources natives,12arêtes,34liens vers17frontières false. Quatre cas publics :Veigar plein,Veigar Sapphire1027,Veigar Sapphire+Charme1004,Annie Sapphire.29ticks avant fontaine :mana manquant36.87%,tauxVeigar1.2/s ou1.5avecCharme,pas de supplément Equilibrium observé. Au30 pulsations de fontaine distinctes.32refus dont12Learn/Cast/CastAt Veigar. Achats/pools selon reconstruction communautaire,aucune injection. Build/run0 ;seule analyse Python initiale échouait sur binary64 vs plafondfloat32,arrondi corrigé en relisant les logs et le binaire exact,sans réexécution. Icônes VeigarEntropy.dds/Veigar_Entropy.dds distinctes ;anciens textes Mundo/40-60-80%/niveaux1-9-17 non adoptés. INIBIN/Lua dans Characters/Veigar/Spells,CharScript absent du seul répertoireScripts sélectionné.1binding,1Lua sans callbacks,0preload,3références communautaires. Ordre/formule natifs,niveaux,mort et présentation ouverts.98autres contrats/parents de passifs restent à examiner ;8330CH chargeur seul est une file de recherche. Examiner ensuite Morgana/Soul Siphon :définition Passive1LuaName Empathize,description liée de vol de vie sur sorts,ancien texte de régénération alliée ;retrouver les bindings exacts,qualifier dégâts de sorts/soin/vol de vie ordinaire et refus actuels sans assimiler lifesteal à spellvamp. Goal actif ;ne pas republier V554 sans cause nouvelle. Découverte Morgana déjà effectuée :revision555_Morgana_discovery/OBSERVATIONS.json,7sources natives,1binding,2Lua littéraux sans callbacks,2preloads,3références communautaires. EmpathizeAura BuffName Empathize et icône FallenAngel_Empathize.dds concordent avec la définition. CharScriptMorgana déclare PersistsThroughDeath/NonDispellable. Texte1866:f1%SpellVamp,description4236:soin sur dégâts de sorts. f1/échelons/cibles non résolus ;ancien texte regenalliée non adopté,Passive1/niveaux absents conservés. Preloads de skins/idle et apbonusdamagetotowers/crestbigmarker ne prouvent pas gameplay/rendu. Runtime,inspection qualifiée et publication restent à faire. Ne pas relancer la découverte sans cause nouvelle. Préserver aussi le wrapper original de Veigar et sa vérification analytique séparée ;les commandes BUILD/RUN y sont réutilisées,sans seconde exécution.
