# SYS-01.2-02 — Azir : Shurima Legacy, V559

25 octobre2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ;build littéral2014-11-17 à17:46:45, fuseau et déploiement inconnus. Catalogue4.20.1 distinct. **Traçabilité partielle ;aucun passif,champion ou jeu accepté.**

## Résultat intégré

CH-Azir-PASSIF-SOURCE, CH-Azir-PASSIF-SIMULATION-CONTRAT et CH-Azir-PASSIF-SIMULATION reçoivent69associations vers23fichiers natifs. Deux fiches de simulation reçoivent48liens vers24points de code, tous entry_boundary_only et provides_feature_consumer=false pour ce passif. SYS-01.2-02 référence le lot. Lecteurs et chargeurs antérieurs conservés sans les assimiler à une mécanique terminée.

Prérequis de phase et de lot relevés dans le reçu. Trois questions propres et quatre dépendances conservées. Aucun statut,critère,identifiant,case,note ou historique manuel modifié. Aucun code du jeu ni asset modifié.

## Sources présentes et limites

| Fichier | Identifiant |
|---|---|
| Azir.inibin | OLS-455f1e7f-eab0-565c-849f-a8272b6420fd |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| AzirIsChannelingPassive.luaobj | OLS-fc0e9bbc-ac9d-579f-8ceb-18e67de764b0 |
| AzirPassive.inibin | OLS-e085dd2f-68cb-55cb-ae0b-13d15ce9f1d4 |
| AzirPassive.luaobj | OLS-f56529c5-1b5f-547a-a26f-466c3e43a2dd |
| AzirPassive.preload | OLS-d66af223-9b26-5588-b6a9-064e526536fe |
| AzirPassiveAvailable.inibin | OLS-7ff8e9d0-21b2-5895-aa39-0c6e27f6bbc9 |
| AzirPassiveAvailable.luaobj | OLS-7c132afc-a235-5d99-9762-ed2889e26911 |
| AzirPassiveTeleportBlocker.luaobj | OLS-0594f72d-1a29-5a6c-aba1-8ae854959476 |
| AzirPassiveUnavailable.luaobj | OLS-871acdce-6e64-544f-ac5b-582660ce1ae9 |
| AzirTowerBuff.luaobj | OLS-59995e09-063f-5985-ab54-1bc866b2bd41 |
| AzirTowerBuff.preload | OLS-d56335e0-6fb5-50d6-88b7-a401735c148a |
| AzirTowerBuffChaos.luaobj | OLS-546ed1b9-7bae-53cc-b707-972bdb2a5c3e |
| AzirTowerBuffChaos.preload | OLS-62bad2b4-24de-5271-98f3-60241204b3d6 |
| AzirSunDisc.inibin | OLS-c5c56452-afd3-5649-9c8a-7b9dd9af46f2 |
| AzirSunDiscBasicAttack.inibin | OLS-05595692-b850-5814-a973-e6066a6c8cc6 |
| CharScriptAzirSunDisc.luaobj | OLS-d1f6a211-db9f-5ad3-bebc-8b81bd0fd165 |
| CharScriptAzirSunDisc.preload | OLS-c05063fe-81a9-5a67-a69c-b0f35383fb3d |
| AzirTurretStatIncrease.luaobj | OLS-cfa9ccbd-f817-59f7-a173-6e5f38fd70d7 |
| AzirTowerClicker.inibin | OLS-961093b6-d8a4-50c1-8c9c-516a94dbbf1a |
| CharScriptAzirSoldiersTowerClicker.luaobj | OLS-6accc10d-ed10-5d73-a3ca-c0c326d5c02d |
| CharScriptAzirTowerClicker.luaobj | OLS-d414fc13-e7dd-5e3a-8983-c0eccc423e16 |
| CharScriptAzirTowerClicker.preload | OLS-991877ba-7c89-5692-8a55-fe0c28bdb2ec |

Taille/SHA256 conformes au registre ;taille/MD5 conformes aux projets RADS sélectionnés lors de la découverte. Les identités sont revérifiées à l’inspection. Azir,SunDisc,TowerClicker,SoldiersTowerClicker et leurs scripts gardent leurs identités et rôles distincts.

Deux bindings de tooltip. Texte1697 :1.25% de vitesse d’attaque par1% de réduction des délais ;Disque solaire depuis les ruines d’une tourelle, une activation toutes les3minutes, désintégration sur1minute, exclusion des ruines de tourelles Nexus/inhibiteur ennemies. Texte1698 :activation disponible depuis une tourelle détruite. Le champ f1 et les règles exactes du serveur ne sont pas exécutés.

Onze Lua entièrement parsés, sans prototype enfant. Huit dépassent le lecteur d’initialisations littérales sur NEWTABLE :AzirIsChannelingPassive pc6,AzirPassive pc10,AzirPassiveAvailable pc12,AzirPassiveTeleportBlocker pc8,AzirPassiveUnavailable pc8,AzirTowerBuff pc6,AzirTowerBuffChaos pc6,AzirTurretStatIncrease pc6. Trois CharScript donnent des globals littéraux vides. **Limite du lecteur, pas corruption des fichiers.** Cinq preloads et six références communautaires présents ;aucun ne prouve à lui seul le comportement du serveur ou le rendu.

Passive1LuaName=AzirPassive et icône Azir_Passive.dds. Niveaux de passif absents d’Azir ;1/4/7 du TowerClicker conservés séparément. Le répertoire Scripts du seul Azir est absent dans l’emplacement sélectionné ;cela ne démontre pas une absence générale de sources.

## Contrôles réellement exécutés

Trois simulations Map10 publiques, Azir contre Garen :sans objet,avec Codex3108,avec Dague1042. Achats depuis les825or de départ :820 et450or. Déplacement,arrêt des deux champions puis six attaques ordinaires par cas. Aucun PV,mana,or,XP,dégât,position ou effet injecté ;niveau1 conservé ;aucune mort ni fin de partie.

| Objet | CDR courant | AP | Cadence observée en ticks | Refus |
|---|---:|---:|---:|---:|
|aucun|0.000|0.0|58|17|
|3108|0.100|30.0|58|17|
|1042|0.000|0.0|50|17|

Attendu du contrôle :observer la CDR réellement calculée et mesurer la cadence aux départs et aux impacts des projectiles, avec un objet de vitesse comme témoin. Observé :sans objet et avec Codex, impacts817/875/933/991/1049/1107, espacés de58ticks ;départs815/873/931/989/1047/1105. Codex fournit0.10000000149CDR et30AP mais aucune accélération observée. Dague+15%AS :impacts816/866/916/966/1016/1066,départs814/864/914/964/1014/1064,espacés de50ticks. Dix-huit projectiles réels non critiques identifiés avant impact puis retirés ;quinze intervalles de départ et quinze d’impact vérifiés.

Le texte natif prévoit un bonus AS lié à la CDR ;le chemin courant stats contient la CDR d’objet séparée et une somme AS sans conversion Azir. Le test confirme cet écart dans le contexte déclaré. Le taux de base et les arrondis historiques ne sont pas qualifiés par cette comparaison. La Dague est un contrôle d’AS d’objet, pas une preuve du passif.

51refus atomiques :par cas, joueur inconnu,cible inconnue,cible propre,objet inconnu,slot de vente invalide et12refus Learn/Cast/CastAt pour quatre slots. Snapshot complet identique avant/après chaque refus. Un sort refusé ne teste pas l’activation d’un passif.

## Disque solaire : revue statique séparée

Action ne comporte pas de commande SunDisc dédiée. Le clic courant dans client/main.rs passe par picking::enemy_target, qui filtre les unités alliées ou mortes ;une cible admise produit Attack, sinon un déplacement ou une commande de sort selon le contexte. Le serveur Attack refuse une cible alliée ou morte. Ces routes examinées ne constituent pas une route d’activation qualifiée depuis une ruine.

enable_map10 lit map10_world.json et ajoute la définition Tibbers ;le JSON ne contient pas de définition AzirSunDisc. spawn_unit exige une définition du monde. damage_unit conserve les structures mortes, programme240secondes pour les inhibiteurs et termine sur Nexus ;cette route ordinaire ne démontre pas le Disque solaire. Les sites de clic,création,protection,mort et mise à jour du monde ont été **lus**, sans exécution de GUI ni interaction avec une ruine dans ce lot. Les ressources natives SunDisc existent :aucune absence globale d’assets n’est déduite de la définition locale manquante.

## Travail restant et limites ouvertes

- Qualifier puis implémenter la conversion CDR→AS :unités,cap,arrondis,niveaux,ordre des modificateurs et fournisseur f1.
- Qualifier les ruines admissibles et la commande d’activation, propriété et exclusions, création, statistiques et ciblage du Disque solaire.
- Qualifier la désintégration1minute, recharge3minutes, interruptions,mort,destruction,répétition et synchronisation réseau.
- Relier modèle,textures,animations,sons et effets à une présentation réellement exécutée ;leur présence sur disque n’est pas une preuve visuelle.
- Dépasser explicitement les limites du lecteur Lua et retrouver le contrat serveur manquant. Aucun client original,VM Lua,GUI,GPU,audio ou réseau exécuté ici.

## Vérification et conservation

Build/run,inspection,préparation,contrôle du candidat,publication,audit :code0. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-azir-passive-cdr-attack-speed-sundisc-probe.exe` ;6009856octets ;SHA256 `777af6cb004d4c46905d51a1b40bb6c0044735fb695c8d7f133ae54d3235225f`. Runtime `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision559_Azir_passive_probe\OBSERVATIONS.json` ;logs BUILD/RUN conservés.1158entrées de code/ressources et anciens artefacts exacts ;verrou privé aligné au Cargo.lock racine. Core non-test en cache ;la suite historique complète n’a pas été réexécutée.

72associations invalides et4graphes invalides rejetés :passif accepté à tort,SunDisc inventé,revue statique assimilée à GUI,limite NEWTABLE assimilée à corruption,source absente,question étrangère,dépendance retirée.

Deux bases SQLite :4destinataires chacune ;42603autres lignes de catalogue,42607états manuels,23événements historiques exacts. Store.task/copy_text/summary,dépendances,références,intégrité et synchronisation idempotente vérifiés. Trois fragments changés,42212inchangés. IDs,hiérarchie et inconnues identiques en octets.

Graphe42215exigences,98912sources,3091consommateurs ;3091ancres et527fichiers courants exacts,zéro divergence.26189questions ouvertes/5517résolues. Pas de nouveau recensement physique de toutes les sources.8320fiches CH à chargeur partagé seulement restent une file de recherche, pas un pourcentage de réalisation.

## Fichiers et suite

completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json ;reçu docs/reference_requirement_trace_sources/azir-passive-cdr-attack-speed-sundisc-links-v559.json ;preuve docs/fidelity_azir_passive_cdr_attack_speed_sundisc_links_v559.json ;couverture,plan,reprise,CURRENT et HANDOFF sauvegardés puis complétés. Scripts archivés. Aucun stage/reset/commit.

Continuer SYS-01.2-02 depuis revision560_trace_review/REVIEW.json. Azir V559 publié/audité :23sources natives,69arêtes,24points/48liens false. Trois cas publics sans objet/Codex3108/Dague1042,18impacts,51refus,aucune injection. Cadence58/58/50ticks ;Codex10%CDR sans conversion AS observée ;Dague15%AS contrôle positif. Branche SunDisc distincte :clic actuel filtre les cibles mortes et alliées,Action sans commande dédiée,Map10 sans définition AzirSunDisc. Revue statique seulement,pas de clic de ruine ni création de SunDisc exécutés.2bindings,11Lua sans callbacks,5preloads,6références communautaires ;8limites littérales NEWTABLE,non corruption. Texte1697 :1.25%AS par1%CDR,recharge3min,désintégration1min,ruines Nexus/inhibiteur ennemies exclues. Niveaux Azir absents,TowerClicker1/4/7 non adoptés. Aucun gameplay modifié,statut/case/inconnue fermé. Ne pas republier V559 sans nouvelle cause. Examiner ensuite Caitlyn/Headshot :compteur attaques,effet buisson,attaque renforcée,critique et types de cible ;séparer ses sources des variantes bots. Goal actif. Découverte Caitlyn déjà faite :revision560_Caitlyn_discovery/OBSERVATIONS.json,15sources natives,3bindings,5Lua sans callbacks,4preloads,6références communautaires. CharScript à la racine du champion. Headshot Marker.inibin dans DATA/Spells ;BuffName du fichier CaitlynHeadshotpassive concordant,PersistsThroughDeath/NonDispellable déclarés sans exécution serveur. Headshot NEWTABLEpc4 et Missile NEWTABLEpc0 restent limites du lecteur. Texte1979 f1attaques,buisson compte2,150%champion/250%sbire ;texte9345 dit8attaques,ne pas adopter automatiquement. Niveaux absents. Aucun runtime Caitlyn encore exécuté. Pistes courantes :flags(point)&1 pour buisson ;attaque ordinaire rawAD ou crit×2 sans branche Caitlyn dans le chemin inspecté ;champion50.04AD,période48ticks,projectile2500,crit0. Ne pas refaire découverte sans cause nouvelle.
