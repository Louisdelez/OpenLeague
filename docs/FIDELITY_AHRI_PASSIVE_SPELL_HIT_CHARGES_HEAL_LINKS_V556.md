# SYS-01.2-02 — Ahri : Essence Theft, V556

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement inconnus. Catalogue 4.20.1 distinct. **Traçabilité partielle ; aucun passif, champion ou jeu accepté.**

## Résultat intégré

Les trois fiches CH-Ahri-PASSIF-SOURCE, CH-Ahri-PASSIF-SIMULATION-CONTRAT et CH-Ahri-PASSIF-SIMULATION reçoivent 54 associations vers 18 fichiers natifs. Les deux fiches de simulation reçoivent 36 liens vers 18 points de code actuels, tous entry_boundary_only et provides_feature_consumer=false pour ce passif. SYS-01.2-02 référence le lot. Les lecteurs et chargeurs antérieurs restent conservés sans promotion en mécanique terminée.

Les prérequis de phase et de lot sont relevés dans le reçu. Trois questions propres et quatre dépendances conservées ; aucun statut, critère, identifiant, case, note ou événement historique manuel modifié. Aucun code du jeu ni asset modifié.

## Sources identifiées

| Fichier | Identifiant |
|---|---|
| Ahri.inibin | OLS-ebe56d83-7db2-5e90-9639-46ad85990f30 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| AhriPassive.inibin | OLS-e2246e74-eb8e-5c5e-a8d4-3389952d1a01 |
| AhriPassive.luaobj | OLS-ef175fc4-7426-5962-83d3-ea0d7e917836 |
| AhriPassiveParticle.luaobj | OLS-1ff30700-71c0-5118-891e-a1eb23eed337 |
| AhriPassiveParticle.preload | OLS-95dbc70d-70ac-5ff1-8ab2-bbd69211e5e9 |
| AhriSoulCrusher.inibin | OLS-c407f11f-6f68-54a9-b610-e91a4bf8e603 |
| AhriSoulCrusher.luaobj | OLS-cfac3302-98f2-5ff5-8df6-5e83796a8c0a |
| AhriSoulCrusher.preload | OLS-bcf31344-df67-5ae2-8bcf-dbe4ea314c95 |
| AhriSoulCrusher2.luaobj | OLS-29612671-fdb2-547d-bcd5-aa94630179fd |
| AhriSoulCrusher3.luaobj | OLS-6cb7123d-6376-583c-bf15-5a28897d8cc0 |
| AhriSoulCrusher3.preload | OLS-9f641352-eb79-5fcf-9315-c1b62ab00523 |
| AhriSoulCrusher4.luaobj | OLS-c06c8b25-a51a-5c2f-a35d-cd132c552c43 |
| AhriSoulCrusher5.luaobj | OLS-43e6a3a4-276d-564c-a1d7-164289cd2a58 |
| AhriSoulCrusherCounter.inibin | OLS-9fd841d3-f971-5770-91a0-3687dcb5c986 |
| AhriSoulCrusherCounter.luaobj | OLS-385e6709-9d2f-566c-9c8a-dfd2644c080e |
| AhriSoulCrusherCounter.preload | OLS-3edc46f3-9f7b-5560-9781-a51a91d3e505 |
| AhriSoulCrusherNumbers.inibin | OLS-bf63c4be-fb98-5a04-a60f-08a0a8d1e658 |

Taille/SHA256 conformes au registre ; taille/MD5 conformes aux projets RADS sélectionnés lors de la découverte, identités recontrôlées à l’inspection. Les ressources de sort sont dans Characters/Ahri/Spells. Le dossier Scripts et ses CharScript sont absents du seul emplacement sélectionné : aucune absence globale de serveur ou de passif déduite.

La définition Passive1LuaName et le Lua AhriPassive portent AhriPassive. L’icône déclarée est Ahri_SoulEater.dds. Quatre bindings explicites d’INIBIN : AhriPassive, AhriSoulCrusher, AhriSoulCrusherCounter et AhriSoulCrusherNumbers. Texte1660 et description4150 : une charge par impact de sort, au maximum trois par sort ; à neuf charges, le prochain sort soigne à chaque touche. Le texte Counter1664 dit « neuf sorts » ; sa formulation reste distincte et ne remplace pas la description plus précise.

Huit Lua entièrement parsés, sans prototype de fonction enfant, avec initialisations littérales. Ils donnent des noms de buffs, textures et effets ; ils n’exécutent pas une logique serveur. Les variantes SoulCrusher2/3/4 mentionnent 3017_Egitai_Twinsoul.dds et des effets de potions. SoulCrusher5 contient des chaînes vides. Ces variantes ne sont pas automatiquement des niveaux ni des effets réellement actifs. Quatre preloads et six références communautaires gardent leur provenance distincte.

Les anciens champs de critique des alliés et de bonus Attack Rate sont conservés sans adoption. Passive1 et Passive1Level1/2/3 sont absents, sans défaut inventé. Les fournisseurs f1/f2, leur progression, les catégories de dégâts et cibles, l’ordre de consommation et les arrondis du soin restent non résolus.

## Consommateurs et observations

Points inspectés : join/stats, Learn/next_rank, commande, Cast/CastAt, gardes d’achat/vente, attaques, basic_attack_hit, apply_damage, heal, régénération/taux, tick, advance_annie_w et pyromania_spell. Le chemin commun de soin ne fournit pas de producteur Ahri. Le compteur Pyromania appartient explicitement à Annie ; son incrément n’est pas une charge d’Essence Theft.

Deux simulations Map10 publiques, Ahri puis Annie en contrôle distinct. Déplacements ordinaires jusqu’à portée de combat et quatre attaques reçues de Garen par cas ; l’adversaire est ensuite arrêté. Plus de100PV manquants permettent d’observer un soin sans écrêtage. Aucune injection directe de PV, mana, or, XP, dégâts, position ou effets ; aucun achat d’objet.

| Cas | Attaques reçues aux ticks | Sort accepté | Refus |
|---|---|---|---:|
| Ahri | 828, 876, 924, 972 | Aucun | 17 |
| Annie | 816, 864, 912, 960 | W, impact968 | 7 |

Attendu : rendre explicites les refus Ahri avec un état valide, distinguer dégâts de sorts, compteur d’Annie et soin générique. Observé : les quatre Learn retournent champion skill progression not implemented ; les quatre Cast champion spell not implemented ; les quatre CastAt champion ground spell not implemented. Aucun de ces refus ne produit un impact ou une activation de passif.

Annie apprend et lance W : coût70mana, impact8ticks après lancement, dégâts nets52.9379272PV sur la cible après sa régénération, Pyromania0vers1. Aucun soin supplémentaire de la source. Les 30ticks par cas, soit60, suivent la régénération ordinaire avec résidu de soin0. Tolérance du contrôle float32 :0.002PV. Les personnages restent vivants, niveau1, sans fin de partie.

24refus individuels avec snapshot complet inchangé : cinq gardes communes par cas (joueur inconnu, cible inconnue, cible soi, objet inconnu, vente hors slots), douze tentatives Ahri et deux gardes de W Annie (non appris, lancement en cours). Les attaques entrantes sont celles de Garen ; aucune attaque à distance d’Ahri n’est exécutée par ce test. Les frontières génériques d’attaque ne sont pas qualifiées comme génération de charges.

## Limites ouvertes

- Les sorts Ahri ne sont pas implémentés dans les routes testées. Il manque un producteur de charges et de soin qualifié pour Ahri.
- Les plafonds trois/neuf, la consommation et le soin à chaque touche ne sont donc pas exercés par ce runtime. Un refus ou un contrôle Annie ne constitue pas un succès de cette mécanique.
- f1/f2, niveaux, cibles multiples, zones, effets persistants, interactions, mort/réapparition, effets visuels et sonores restent à qualifier.
- Pas d’exécution du client historique, serveur original, VM Lua, GUI, GPU, audio ou réseau.

## Vérifications et fichiers

Build/run, inspection, préparation, contrôle du candidat, publication et audit : code0. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-ahri-passive-spell-hit-charges-heal-probe.exe` ; 6017024octets ; SHA256 `475e9e8d34462f954bbc177e056d851236d25f15d76c5d2b99fa80199a88ae99`. Reçu runtime `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision556_Ahri_passive_probe\OBSERVATIONS.json` et logs BUILD/RUN conservés. 1158entrées core/ressources et artefacts antérieurs exacts, verrou privé aligné sur Cargo.lock racine. Le core non-test provient du cache ; aucun nouveau passage de toute la suite historique revendiqué.

72associations invalides et4graphes invalides rejetés, dont compteur Annie présenté comme Ahri, paramètre f1/f2 inventé, fichiers numérotés interprétés en niveaux, neuf sorts assimilés sans réserve à neuf charges, question étrangère et dépendance retirée.

Deux bases SQLite réelles :4destinataires chacune ;42603autres lignes de catalogue,42607états manuels et23événements historiques inchangés. Store.task/copy_text/summary, dépendances, résolution des références, intégrité SQLite et synchronisation idempotente vérifiés. Trois fragments de trace changés,42212 inchangés. IDs, hiérarchie et registre des inconnues identiques en octets.

Graphe :42215exigences,98900sources,3030consommateurs ;3030ancres et527fichiers courants exacts, zéro divergence.26189questions ouvertes/5517résolues. Pas de nouveau recensement physique de toutes les sources.8326fiches CH avec seul chargeur partagé constituent une file de recherche, pas un taux d’achèvement.

Fichiers : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json ; reçu docs/reference_requirement_trace_sources/ahri-passive-spell-hit-charges-heal-links-v556.json ; preuve docs/fidelity_ahri_passive_spell_hit_charges_heal_links_v556.json ; couverture, plan, reprise, CURRENT et HANDOFF avec sauvegardes. Scripts archivés et anciennes preuves conservées. Aucun stage/reset/commit.

Continuer SYS-01.2-02 depuis revision557_trace_review/REVIEW.json. Ahri V556 publié/audité :18sources natives,54arêtes,18points actuels/36liens false. Deux cas publics Ahri/Annie,8coups entrants,60ticks observés,24refus ;aucune injection. Ahri Learn/Cast/CastAt refusés à portée valide ;AnnieW70mana,tick968 et Pyromania0vers1 sont un contrôle distinct. Quatre bindings,8Lua sans callbacks,4preloads,6références communautaires. Textes jusqu à3charges par sort,9charges avant prochain sort soignant ;Counter parle de9sorts,conservé distinct. f1/f2,niveaux,cibles,consommation,soin par impact et présentation restent ouverts. Anciens textes critique allié/Attack Rate non adoptés ;champs absents conservés ;SoulCrusher2/3/4 et chaînes vides du5 ne prouvent aucun rang. Scripts absent du seul dossier sélectionné. Aucun gameplay changé,statut/case/inconnue fermé. Examiner ensuite Akali/Twin Disciplines :retrouver les bindings exacts et confronter conversion AP/dégâts/soin aux consommateurs actuels,sans assimiler lifesteal ordinaire au passif. Ne pas republier V556 sans cause nouvelle. Goal actif. Découverte Akali déjà faite :revision557_Akali_discovery/OBSERVATIONS.json,13sources natives dont AkaliTwinAP.lua.inibin conservé distinct,3bindings,4Lua littéraux sans callbacks,3preloads,5références communautaires. CharScript sans globals ;TwinDisciplines BuffTextureName33.dds diffère de Passive1Icon AkaliTwinDisciplines.dds ;Nondispellable et NonDispellable conservés distincts. Texte1673/4151 :6%bonus magique plus1%par6AP,6%SpellVamp plus1%par6bonusAD ;producteurs f1/f2 et interprétation arithmétique à qualifier. C# communautaire OnActivate utilise6+bonusAd%6 :ne pas adopter comme source native ni supposer unités équivalentes. Passive1/description ancienne/niveaux absents. Effets L_hand/R_hand déclarés ne prouvent pas rendu. Runtime,inspection et publication restent à faire ;ne pas refaire découverte sans cause nouvelle.
