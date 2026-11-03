# SYS-01.2-02 — Jayce : Condensateur Hextech, V581

Date UTC : 2026-10-26T03:04:48.320360+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 2014-11-17 à 17:46:45 ; fuseau et déploiement non établis. Catalogue officiel 4.20.1 distinct.

## Résultat intégré

CH-Jayce-PASSIF-SOURCE, CH-Jayce-PASSIF-SIMULATION-CONTRAT et CH-Jayce-PASSIF-SIMULATION reçoivent 111 associations vers 37 ressources natives avec rôles distincts, et 44 liens vers 22 points du code courant. SYS-01.2-02 référence le lot. Trois inconnues propres et quatre dépendances conservées ; critères, statuts et prérequis de phase/lot respectés. Les compteurs sont calculés depuis les associations.

**Le moteur refuse actuellement Transform, y compris sans cible.** Le déclencheur du passif n’est donc pas exercé. Les vitesses et occupations testées restent des contrôles du comportement actuel, pas une validation native du passif. Consommateurs `entry_boundary_only`, `provides_feature_consumer=false`. Aucun gameplay ou asset modifié.

## Sources et limites

| Ressource | Identifiant |
|---|---|
| Jayce.inibin | OLS-ed7d22bf-b3af-5bb0-a2ab-b9c9345c16de |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptJayce.luaobj | OLS-a92deca1-32b5-5208-a2aa-a9eef503df86 |
| CharScriptJayce.preload | OLS-07b055d0-57ad-5aa1-8437-5d201b66554b |
| JaycePassiveDebuff.luaobj | OLS-6586fd3e-f0d6-54af-86d3-2d0c14817a77 |
| JaycePassiveHaste.luaobj | OLS-c793d974-42c6-5a22-a62b-887dd4f65e90 |
| JaycePassiveHaste.preload | OLS-3e09de8e-9a16-5890-a0c9-ef9977edf44b |
| JaycePassiveMeleeAttack.inibin | OLS-2abc1e09-4f20-5de9-8c29-6f4710b2c979 |
| JaycePassiveMeleeAttack.luaobj | OLS-5840d26d-b7f9-5419-801b-e62dd85109c5 |
| JaycePassiveMeleeAttack.preload | OLS-53a3d70e-15ec-5b28-85ac-94d4b91f2666 |
| JaycePassiveRangedAttack.inibin | OLS-b90d92ce-e04c-534e-9ad3-0a955b9f17e6 |
| JaycePassiveRangedAttack.luaobj | OLS-0be4216a-c4e5-5b6c-bdd2-6a622d67aeab |
| JaycePassiveRangedAttack.preload | OLS-dc0e7fee-ae6f-57b1-8387-95c312f98f7d |
| JaycePassiveShred.inibin | OLS-10611ad7-6d16-5df8-ac64-15dac57ed3d5 |
| JayceRunSpeed.luaobj | OLS-fb2521ed-525b-55d4-9353-df14a11caa86 |
| JayceStanceGtH.inibin | OLS-ac506e1d-4aeb-58fb-8a11-9d46f56c3fb5 |
| JayceStanceGtH.luaobj | OLS-a516ac4d-b0ba-59b4-8636-487e00cda522 |
| JayceStanceGtH.preload | OLS-c03a4986-eb5c-57be-95b4-445e9d6955ae |
| JayceStanceGun.inibin | OLS-33d49251-f7c7-5282-bd6b-5b62e34e3359 |
| JayceStanceGun.luaobj | OLS-9d501908-47ff-5d0b-8b24-3baa857cebd5 |
| JayceStanceGun.preload | OLS-1e430aa6-7740-5d8e-a329-463010addc3b |
| JayceStanceHammer.inibin | OLS-ba95c4d8-1b31-5e77-8f77-060d95a4816e |
| JayceStanceHammer.luaobj | OLS-0525709b-8731-5d13-998f-cda1323263f0 |
| JayceStanceHammer.preload | OLS-dca0b820-dcc2-51b0-879c-9bfcf40959fb |
| JayceStanceHammerCheck.luaobj | OLS-06042921-2024-55b2-9c51-73cd9bff926b |
| JayceStanceHtG.inibin | OLS-069ada27-3698-5f7c-9712-e3c32d760cd2 |
| JayceStanceHtG.luaobj | OLS-93f67004-c486-5ab7-8144-70af963fe4c5 |
| JayceStanceHtG.preload | OLS-bbc56d4b-071d-5200-a565-90eb84d40595 |
| JaycePassive.inibin | OLS-e4f41e9e-f800-5a0b-b73e-8de595b1b9ec |
| JaycePassive.luaobj | OLS-d067013f-bf86-51b6-af85-9e7d0300f041 |
| JaycePassiveBuild.luaobj | OLS-b214d2f9-4ce2-5875-945f-eaf873e76e02 |
| JaycePassiveManager.luaobj | OLS-86f6e085-4be0-5fa2-a16e-7497328d12c6 |
| JaycePassiveManager.preload | OLS-a9de97bb-9675-5be5-92da-06cd4c1de80a |
| JaycePassiveReady.luaobj | OLS-28ab8cb8-dd0e-5b31-b633-9aa87bc19e5f |
| JaycePassiveWaitTimer.luaobj | OLS-40e345b9-f5a5-5a20-af41-fd23bed88a0e |
| JaycePassiveWaitTimer.preload | OLS-d1fc7d44-a992-5e28-9acf-d77e7f33cc6b |
| Jayce.ddf | OLS-b03c4142-95e2-578c-945e-4e0c24ddacb5 |

Les 37 ressources sont vérifiées par taille/SHA256 contre le registre et taille/MD5 contre les manifestes RADS sélectionnés. L’ordre de montage historique effectif n’en découle pas.

La description personnage ligne 4206 annonce **40 de vitesse pendant 1,25 seconde et passage à travers les unités à chaque Transform**. Le personnage indique Spell4=JayceStanceHtG ; les deux preloads GtH/HtG référencent JaycePassiveHaste et leurs formes. Ces sources établissent des liens explicites à qualifier, pas une exécution du serveur original.

Le champ Passive1LuaName vaut **GarenRecouperate**, alors que CharScriptJayce.preload référence JaycePassiveManager, JayceStanceHammer et JayceRunSpeed. Aucune régénération de Garen n’est adoptée et aucune valeur originale n’est réécrite. Les champs Passive1Level=1/4/7, puis absents, ne sont pas transformés en progression de vitesse.

Les six bindings de buff comprennent cinq correspondances : attaques chargées mêlée/rangée, réduction de défenses, formes canon/marteau, lignes 2102–2106. La clé game_buff_tooltip_JaycePassive ne se résout pas dans la localisation inspectée. Elle reste manquante sans alias automatique.

Seize chunks Lua sont entièrement lus sans prototype enfant ; quatorze initialisations littérales reconnues. Les deux transformations dépassent le lecteur littéral sur NEWTABLE pc14 : limite de ce lecteur, pas corruption démontrée. CharScriptJayce est vide. Les déclarations de persistance/non-dissipation des formes ne prouvent pas leur cycle de vie effectif.

JaycePassiveHaste déclare BuffName=Haste, Summoner_haste.dds et DoesntTriggerSpellCasts=true. Ces noms ne permettent pas d’adopter le contrat du sort d’invocateur Fantôme. Les fichiers Build/Manager utilisent ApolloPassive, Ready utilise ApolloPassiveActive et WaitTimer déclare JarvanIVDemacianStandard avec l’icône 14.dds. Ces héritages sont conservés distinctement ; CastTime=0.115 ne devient pas la durée du bonus de déplacement.

Le personnage utilise Jayce_Passive.dds, le buff JaycePassive utilise JayceManOfTomorrow.dds ; les formes et attaques chargées ont d’autres icônes. Les rôles visuels restent à qualifier. Les attaques chargées ajoutent des dégâts magiques ou réduisent armure/résistance magique ; elles restent distinctes de l’accélération temporaire.

Dix preloads conservent leurs effets et dépendances. Le DDF contient 40 entrées de contexte de sorts/formes, aucune entrée de vitesse du passif. Les déclarations ne prouvent pas chargement, rendu ou callbacks. Quatorze références communautaires sont séparées des sources natives ; CharScriptJayce.cs est vide. Aucun serveur historique exécuté.

## Mesures et refus publics

Quatre simulations Map10 utilisent Jayce et Annie. Achat éventuel de bottes 1001, déplacement public au centre puis cinq pas mesurés et Stop ; 60 ticks observés par cas. Le Soin est un contrôle séparé. Aucune injection de position, santé, niveau, rang, XP ou effet ; aucun PNJ supprimé.

| Cas | Vitesse de base | Vitesse initiale | Vitesse finale | Refus |
|---|---:|---:|---:|---:|
| bootsfalse_healfalse | 335.000000 | 335.000000 | 335.000000 | 17 |
| bootstrue_healfalse | 360.000000 | 360.000000 | 360.000000 | 17 |
| bootsfalse_healtrue | 335.000000 | 431.399963 | 335.000000 | 18 |
| bootstrue_healtrue | 360.000000 | 457.399963 | 360.000000 | 18 |

335 sans bottes, 360 avec bottes. Le Soin donne environ 431,4 ou 457,4 puis expire au tick 30. Les cinq pas de chaque cas correspondent à vitesse/30, résidu inférieur à 0,005 unité ; après Stop le déplacement est nul. Total : 240 ticks et 20 pas mesurés. Les plafonds et le Soin conservent leurs propres limites locales/historiques et ne sont pas le contrat du passif de Jayce.

Cast slot 3 sans cible est refusé avant et après 60 ticks : `champion spell not implemented`, snapshot inchangé. Les autres refus couvrent joueur inconnu, attaque de soi, slot invalide et Learn/Cast/CastAt des quatre capacités, ainsi que les deux relances de Soin en cooldown. Total de ces quatre cas : 70 refus. Attendre au-delà de 1,25 seconde après un refus ne démontre pas l’expiration du passif.

Quatre autres cas comparent l’occupation pour Jayce/Garen, allié/ennemi. Devant Annie alliée, les deux champions restent à 65 unités et n’atteignent pas son centre. Devant Annie ennemie, les deux traversent son occupation ; distance minimale environ 4,336914 pour Jayce et 3,004350 pour Garen, destination atteinte à environ 250 unités au-delà du centre. Les 65 unités représentent la somme des rayons de navigation actuels, pas une portée native du passif. Deux refus supplémentaires de Transform sont consignés pour Jayce : **72 refus publics au total**.

Le franchissement d’ennemis existe aussi chez Garen ; il ne prouve donc pas le passage temporaire de Jayce à travers les unités. Ces contrôles n’acceptent ni politique native d’occupation ni correction du défaut de déplacement V564.

## Consommateurs et vérifications

Les liens couvrent initialisation, commandes, statistiques/progression, refus de capacités, ordre des ticks, vitesse/modificateurs/plafonds, bonus/achats d’objets, Soin, occupation alliée, rayons de navigation, mouvement, snapshots et frontière statique de réapparition. Aucun état de transformation ou bonus temporaire Hextech n’est établi dans les chemins testés.

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-jayce-passive-hextech-capacitor-probe.exe`. Taille : 6056960 octets. SHA256 : `a039135e06e854df559892923f35fd8de2c1ebe95d4cff11af929e4d7d3ea297`.

BUILD/RUN code 0 ; core courant non-test, verrou privé aligné sur les identités/checksums du verrou racine. 1 158 entrées core/ressources et chaîne précédente inchangées, y compris la preuve initiale Jax V580, son compteur corrigé à quatre inconnues et le premier finisher échoué. Ces preuves antérieures sont conservées, pas réexécutées ici.

Discovery, inspection, prepare, check, publish, audit et revue globale réussis. 72 associations invalides et quatre graphes invalides refusés, séparément des 72 refus de commandes de jeu. Trois fragments de trace enrichis, 42 212 autres inchangés. Compteurs d’inconnues/dépendances dérivés des tableaux réels, afin de ne pas reproduire le compteur hérité erroné du lot précédent.

Store.task/copy_text/summary, dépendances et résolution de trace sont vérifiés dans les deux bases SQLite. Chacune conserve 42 603 autres lignes, 42 607 états manuels et 23 historiques ; quatre destinataires enrichis, intégrité et synchronisation idempotente vérifiées. Identifiants, hiérarchie et inconnues identiques en octets. Aucune tâche ni case acceptée automatiquement.

Revue globale : 42 215 exigences, 99 001 sources, 3 568 consommateurs ; 3 568 ancres exactes, aucune divergence courante. 26 189 inconnues ouvertes et 5 517 résolues conservées. La revue structurelle ne re-hashe pas tout le corpus et n’est pas une mesure du jeu terminé.

## Travail restant

- Qualifier puis implémenter les deux transformations : états, dispatch des capacités, profils/portée d’attaque et présentation de forme.
- Déterminer le déclencheur, les 40 de vitesse, la durée exacte, l’arrondi aux ticks, les cumuls/rafraîchissements et les corps traversables.
- Intégrer accélération et occupation temporaire, puis vérifier les deux sens, contrôles, annulation, niveaux, objets, ralentissements et fin d’effet.
- Traiter séparément les attaques chargées mêlée/rangée et la réduction de défenses.
- Qualifier mort/réapparition, départ, déconnexion et fin de partie.
- Résoudre ou conserver explicitement les noms hérités, le tooltip manquant et les rôles d’icônes.
- Vérifier séparément HUD, animation, changement du modèle, VFX, audio et réseau.
- Conserver les anomalies antérieures, dont V564 ; ce lot ne les corrige pas.

## Fichiers et reprise

Registres modifiés : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`. Reçu : `docs/reference_requirement_trace_sources/jayce-passive-hextech_capacitor-links-v581.json`. Preuve : `docs/fidelity_jayce_passive_hextech_capacitor_links_v581.json`. Couverture, plan, checkpoint, CURRENT, HANDOFF et deux bases actualisés avec sauvegardes. Scripts et journaux sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20, préfixe revision581.

Continuer SYS-01.2-02 depuis revision582_trace_review/REVIEW.json. JayceV581 publié/audité :3fiches,37natives et contextes formes/attaques chargées distincts,111associations,22points/44liens. Quatre cas vitesse70refus240ticks20pas;335/360,bottes/Soin431.4/457.4expire30. Transform sans cible refusé avant/après60ticks. Quatre cas occupation Jayce/Garen,alliés bloquent65,ennemis traversés tousdeux;2refusTransformsupplémentaires. Aucun trigger passif natif exercé. Description40vitesse1.25s et ghosting;GarenRecouperate/Apollo/Jarvan aliasesnonadoptés,Haste≠contratGhost,6bindings5résolus1manquant,16Lua14littéraux2NEWTABLEpc14,10preloads,DDF40,14communautaires. Préserver chaîneV580 incluant preuve originaleJax,compteur corrigé4et échecfinisher initial. Compteurs inconnues/dépendances désormais dérivés des associations. Aucun statut/case/inconnu fermé. Poursuivre autre passif après inspection réelle,par exemple Jinx. Défaut déplacementV564 ouvert;goal actif.
