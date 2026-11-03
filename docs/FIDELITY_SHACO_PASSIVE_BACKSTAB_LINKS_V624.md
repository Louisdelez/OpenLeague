# Shaco — sources et consommateurs de Backstab, V624

Date UTC : 2026-10-26T16:16:29.249622+00:00. SYS-01.2-02,F:/OpenLeague. PUBLIC4.20.0.315 EUW/en_GB,catalogue4.20.1 distinct. Build littéral2014-11-17 17:46:45,fuseau et déploiement non établis.

## Résultat et portée

Les trois fiches CH-Shaco-PASSIF-SOURCE,CH-Shaco-PASSIF-SIMULATION-CONTRAT et CH-Shaco-PASSIF-SIMULATION reçoivent62sources natives,186associations,28points de code et56liens pour les fiches de simulation. SYS-01.2-02 reçoit le reçu et la synthèse. Aucun gameplay modifié ;statuts,critères,dépendances,inconnues et acquis conservés.

Le texte natif indique20% de dégâts supplémentaires depuis le dos. Les quatre diagnostics publics montrent des dégâts identiques face/dos,avec et sans Épée longue,contre un Garen dont l’orientation résulte d’un déplacement réel. Le seuil angulaire natif,le moment du test,les catégories de dégâts et l’ordre des modificateurs restent à qualifier. L’orientation physique actuelle ne suffit pas à démontrer Backstab.

## Sources natives

62 ressources :19 INIBIN,28 Lua,13 preloads,Shaco.ddf et texte en_GB. Taille,SHA et appartenance au manifeste RADS vérifiées. Aucun doublon de basename ou NightmareBot sélectionné. Six bindings BuffData résolus.

Shaco.inibin définit Passive1LuaName=Backstab,icône Jester_CarefulStrikes.dds,AD57.5800018311,portée125,vitesse350,BaseMP297.2000122070. PARType,Passive1 et les six niveaux Passive1Level sont absents. La classification Mana actuelle reste distincte. Les textes hérités +40/+60/+80% de régénération du mana ne sont pas adoptés comme progression du passif.

BuffData Backstab et description du personnage concordent sur20% de dégâts supplémentaires depuis le dos. Les formulations « attacking » et « striking a unit » ne fournissent pas à elles seules la liste exhaustive des sorts,attaques de clone,types de cible ou ordre avec critiques/réductions.

Les28 Lua sont entièrement parcourus,sans sous-fonction et sans limite NEWTABLE. Cela ne les transforme pas en code serveur complet. CharScriptShaco,FromBehind et CastFromBehind exposent des initialisations vides. Backstab expose nom,icône,PersistsThroughDeath et NonDispellable :métadonnées,non prédicat géométrique ou callback de dégâts.

Backstab.preload référence castfrombehind,frombehind,twoshivpoison et absolutezero_tar.troy. Le preload du personnage cite backstab,apbonusdamagetotowers,traplimiter_shaco et shacoclonedanceoverride. Ces dépendances ne prouvent ni chargement effectif,ni rendu,ni politique de gameplay.

Shaco.ddf comporte8lignes,dont une liaison non vide :TwoShivPoison;f1→bonusattackdamage×1.0. Elle concerne E et ne démontre pas une formule Backstab. Les variantes espacées Jack In The Box/JackInTheBox et Two Shiv Poison/TwoShivPoison sont conservées séparément ;aucun alias silencieux.

Le champ exact Spell4 sélectionne **HallucinateFull**,ExtraSpell1 indique **Hallucinate**. Le texte Full mentionne en plus une réduction de dégâts au porteur pendant la vie du clone. La phrase libre de découverte qui évoquait Hallucinate comme sélectionné était incorrecte ;l’inspection qualifiée,les consignes et ce rapport la corrigent à partir du champ exact,sans effacer la preuve initiale. Les variantes ne sont pas considérées équivalentes.

Q décrit téléportation,invisibilité3,5s,prochain critique sous6s et délai après invisibilité. W décrit invisibilité après2s,peur puis attaques et durées cachée/active distinctes. E distingue passif disponible et actif,ralentissement et réduction des chances de toucher des sbires/monstres. R décrit un clone contrôlable jusqu’à18s,75% de dégâts,dégâts reçus augmentés et explosion à sa mort. Ces contextes restent séparés de Backstab.

Quatre chemins candidats absents sont consignés :CharScript sous Scripts,Backstab dans les Spells globaux,Shaco.en_gb.ddf et ShacoPassive.inibin. Les alternatives sélectionnées sont présentes. Aucune absence globale d’assets ou corruption du client n’est déduite.

| Ressource | Identité du registre |
|---|---|
| Shaco.inibin | OLS-33a91964-a972-5978-a83c-12a190932118 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Shaco.ddf | OLS-c7730b80-66d9-5985-abf1-7d9c152209b5 |
| CharScriptShaco.luaobj | OLS-527ea77f-9e10-59b1-911c-b76f0b821d11 |
| CharScriptShaco.preload | OLS-2e6300d8-f801-59e6-bd43-6005b2055ed0 |
| Backstab.inibin | OLS-6f282de3-b695-57bf-97aa-b9cbba86295c |
| Backstab.luaobj | OLS-b6af3ba1-cf95-54a6-9b21-41ce74c3d418 |
| Backstab.preload | OLS-3ceecd1d-e55f-580e-8a97-dffea595c5f2 |
| CastFromBehind.luaobj | OLS-27056ab8-d3ad-5286-99f5-e91f883b3e34 |
| Deceive.inibin | OLS-c97cb92e-b75d-5701-a2ef-59c616c9c4c3 |
| Deceive.luaobj | OLS-a4c1bed2-a059-5096-8ecc-f5403a06fa31 |
| Deceive.preload | OLS-794cbe13-5d62-501b-932b-d7221c79ee31 |
| DeceiveCritBonus.inibin | OLS-cf8291b3-9298-537b-a83a-0396f3b0c0ea |
| DeceiveCritBonus.luaobj | OLS-f5b615a4-aefb-5d7c-84b6-d31b1d359b3c |
| DeceiveCritBonus.preload | OLS-8b058301-9618-5dd8-b533-3562e4219f4b |
| DeceiveCritChance.luaobj | OLS-62812859-09a9-5065-8aaf-66f2f3bcc35e |
| DeceiveFade.luaobj | OLS-34ec3cdc-31aa-5c94-ba6f-0835d3ee8149 |
| DeceiveFade.preload | OLS-589a9036-8301-5f83-9fcb-9b8a69751931 |
| EndKill.luaobj | OLS-e2e25078-6b81-5db9-a8b5-b40610ddf30f |
| FromBehind.luaobj | OLS-22e818b4-1a9e-5918-a006-e08efda735ee |
| Hallucinate.inibin | OLS-b3a64dbc-4b65-59c2-889b-66fdfefe3ea1 |
| Hallucinate.luaobj | OLS-85dd7308-9ba6-5ea0-97eb-5628e9f0e33e |
| Hallucinate.preload | OLS-f01ea241-85eb-529c-b4ea-e61b0efdd3c5 |
| HallucinateApplicator.luaobj | OLS-4c0287e5-6c65-5645-8ff6-174bcf9ba473 |
| HallucinateApplicator.preload | OLS-b0b5e7db-f5bf-554d-a60f-995c528bef52 |
| HallucinateFull.inibin | OLS-eedd5654-fc1e-5b9a-a877-8c957d91fdfd |
| HallucinateFull.luaobj | OLS-bdf53c73-4ca6-59e8-b69f-678463ecab98 |
| HallucinateFull.preload | OLS-1fd330ca-bf5c-58bd-95b5-f9c604822739 |
| HallucinateGuide.inibin | OLS-63b0fd47-7b3a-532c-aa2e-efbcc40c63eb |
| HallucinateGuide.luaobj | OLS-3bc7c831-3ef1-5657-9136-680a9af7811d |
| HallucinateGuide.preload | OLS-dc0084ee-d264-56d9-9f05-4c26aca16d97 |
| Jack In The Box.inibin | OLS-662651b2-768c-51dc-b539-a58977fae7ea |
| JackInTheBox.inibin | OLS-6bfafd9c-0f97-546c-9153-21b8f0a27fd1 |
| JackInTheBox.luaobj | OLS-c91358ee-1db4-53cc-9637-81a1d35ad2cb |
| JackInTheBox.preload | OLS-ad4629eb-2e60-53dc-8ec8-6abde0f7795f |
| JackInTheBoxDamageSensor.luaobj | OLS-4cbf0194-585c-5eec-9f88-113192630379 |
| JackInTheBoxDamageSensor.preload | OLS-25254af5-3643-5044-a845-79b16ea8224c |
| JackInTheBoxHardLock.luaobj | OLS-72bd36b1-8a28-5d27-8bb2-7f8de71918c9 |
| JackInTheBoxInternal.luaobj | OLS-23a6f129-557d-5e3a-95bc-463adeb7fb48 |
| JackInTheBoxInternal.preload | OLS-d361aa1f-faa1-5d3f-8ffe-ecd4847681d6 |
| JackInTheBoxSoftLock.luaobj | OLS-a86af5a2-af54-5afd-ac96-10783e59fe35 |
| ShacoBasicAttack.inibin | OLS-962593ff-08a3-537c-9cf3-79d44fb47089 |
| ShacoBasicAttack2.inibin | OLS-16af212f-74c1-55d5-a79e-fc467c3f9655 |
| ShacoCloneDanceOverride.luaobj | OLS-a6cbf3f8-fd93-563c-a8a9-7c1ed88788db |
| ShacoCritAttack.inibin | OLS-a87c1531-7d4c-5b52-9d1f-0c514453c7b0 |
| ShacoDummyCommandParticle.luaobj | OLS-8437f1de-d58b-5bc4-bba4-bd96569050e2 |
| TrapLimiter_Shaco.inibin | OLS-ae94940b-10fd-5c1c-95e8-f88096b462a2 |
| TrapLimiter_Shaco.luaobj | OLS-18df5366-1733-5146-9821-cdb5c5a9262a |
| Two Shiv Poison.inibin | OLS-16dd4a69-2cf8-5133-8b33-14500d0a21e7 |
| TwoShivPoison.inibin | OLS-01fa179a-dcd2-5ff0-b26f-7e128d0790f9 |
| TwoShivPoison.luaobj | OLS-56b1c3ca-5ce8-594e-91d8-3ecd7e90cb03 |
| TwoShivPoison.preload | OLS-00730807-6483-5fe6-8f80-b98b0f3f8184 |
| ShacoBoxBasicAttack.inibin | OLS-eeba5817-5871-5be2-8006-b25b5519627e |
| ShacoBoxBasicAttack.luaobj | OLS-111a5204-8a74-5efa-96d9-ffb4f1718217 |
| ShacoBoxSlow.luaobj | OLS-d2d16cde-9519-53cb-a417-af9b31dcc91a |
| ShacoBoxSnare.luaobj | OLS-9bdc81e4-37b9-52c2-a83c-0fb352301127 |
| ShacoBoxSpell.inibin | OLS-c07c42d1-f30c-5e98-9b0a-d3d4bac3f8df |
| ShacoBoxSpell.luaobj | OLS-79bd4aed-10d7-5898-9c15-9f44f5c2e098 |
| ShacoBoxSpell2.inibin | OLS-5221542e-fedb-5d42-bb01-391bf83262e4 |
| ShacoBoxSpell2.luaobj | OLS-48aae93f-d5ab-529b-8b9a-3ccd7180babf |
| Two Shiv Poison Passive.inibin | OLS-b996632d-c59e-56e4-a8b0-066b9008a34c |
| TwoShivPoisonPassive.luaobj | OLS-c0bb702d-343a-5f53-9140-69b82109caca |

## Références communautaires

24 références identifiées séparément. CharScriptShaco.cs est vide. Aucun script communautaire exécuté ici comme serveur historique ou consommateur Rust.

- Q délègue ShacoStealth et ShacoBackstab pendant3,5s et une particule. Le fichier ne démontre pas de téléportation ni le critique natif sous6s ;les corps délégués ne sont pas qualifiés par leur seul nom.
- W crée ShacoBox,mais conserve des TODO pour peur,invisibilité,durée cachée/active et application des dégâts sur attaque. Les dégâts sont programmés par timers et la durée vaut5s ;une particule et un pet créé ne démontrent pas le comportement complet.
- E calcule ses dégâts sans le terme bonusAD présent dans le DDF et ajoute×1,33 si la cible possède Slow. Ce multiplicateur n’est pas une règle Backstab native démontrée.
- R ajoute un buff au porteur pendant8s puis déclenche une explosion autour de sa position. Cela ne démontre ni clone contrôlable18s,ni attaque propre au clone,ni explosion à sa mort.

## Orientation du moteur et diagnostic actuel

entity_facing::capture_facing n’actualise l’orientation que pour Garen et Trundle. Le yaw utilise l’arithmétique native,mais les producteurs de direction par mouvement/attaque sont des politiques reconstruites explicitement bornées. Shaco garde facing=None ;ne pas le remplacer par un angle0. La cible choisie pour le test est donc Garen.

BUILD=0 et RUN=0. Le premier collecteur Python a échoué avec KeyError sur facing :serde omet ce champ lorsqu’il est absent. Les assertions Rust avaient déjà vérifié None et réussi. Le collecteur qualifié utilise l’absence du champ,relit le même RUN et le même binaire,sans recompilation ni nouvelle exécution du jeu. Relecture=0,inspection=0. Script initial,journaux BUILD/RUN et preuve de relecture conservés.

Cœur Rust hors configuration test,offline/locked,dépendances alignées sur Cargo.lock,1158 entrées source et preuves antérieures contrôlées. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-shaco-passive-backstab-probe.exe`,6138880 octets,SHA256 `f9338438c46e0ab31561bbc62455fb3f52aecc5006e66be4efbd9b884574f2bb`.

Quatre cas publics niveau1 :base face,base dos,Épée1036+10AD face,Épée dos. Achats/ventes/rachats réels. Douze trajets Move/Stop sans réémission. Garen effectue un dernier déplacement qui produit son yaw ;le vecteur du dernier déplacement est conservé et vérifié contre facing. Shaco approche d’un côté ou de l’autre. Aucun angle,position,vie,ressource,stat,sort ou délai injecté.

Chaque cas produit trois attaques,puis181ticks d’attente,puis trois attaques. Total24impacts,724ticks et108refus atomiques :acteur inconnu,autoattaque de soi,slot invalide,apprentissage et lancements QWER avant/après attente. Les snapshots restent inchangés après refus.

| Profil | AD | Yaw Garen | Cosinus relatif à l’impact | Dégâts physiques observés | Refus |
|---|---:|---:|---:|---:|---:|
| base_front | 57.58000 | -89.99999 | 1.0 | 45.14807 | 27 |
| base_rear | 57.58000 | -89.99999 | -1.0 | 45.14807 | 27 |
| Sword10AD_front | 67.58000 | -89.99999 | 1.0 | 52.98895 | 27 |
| Sword10AD_rear | 67.58000 | -89.99999 | -1.0 | 52.98895 | 27 |

Les cosinus valent+1 ou−1 à chacun des impacts et l’orientation de Garen reste stable. Ce sont des cas géométriques extrêmes de diagnostic,pas une récupération du seuil angulaire natif. Les dégâts restent45.14804..45.14807 en base et52.98895 avec Épée,identiques face/dos pour chaque série. La variation minime entre impacts provient des calculs float32 de vie/régénération ;elle n’est pas un bonus. L’augmentation AD de l’objet est bien observée.

Attendu textuel :20% supplémentaires si la condition arrière native est satisfaite. Observé :aucun bonus pour l’approche opposée au déplacement/orientation de la cible. Le calcul illustratif×1,2 est stocké sans être présenté comme preuve du seuil,de l’ordre ou de la formule complète historique. Mitigation et régénération ordinaires sont vérifiées ;aucun critique Q ou sort Shaco accepté,tous rangs/délais QWER0. La recherche exacte Shaco/Backstab dans crates/core/src ne trouve aucun chemin dédié.

Huit ressources locales liées :champions,croissance,ressources,attaques,critiques,collisions,boutique et contrat yaw. Les lecteurs de sources restent distincts de la simulation.

| Point de code | Rôle vérifié |
|---|---|
| crates/core/src/lib.rs:533 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/lib.rs:598 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/progression.rs:68 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/progression.rs:150 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/progression.rs:159 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/spells.rs:101 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/annie_w.rs:29 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/lib.rs:685 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/lib.rs:744 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/damage.rs:53 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/attacks.rs:157 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/lifesteal.rs:4 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/regeneration.rs:32 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/regeneration.rs:10 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/shop.rs:261 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/shop.rs:215 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/world.rs:226 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/damage.rs:38 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/attacks.rs:26 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/lifecycle.rs:16 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/lifecycle.rs:24 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/ally_occupancy.rs:635 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/ally_occupancy.rs:526 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/spells.rs:5 | current Shaco damage,ordinary attack,orientation or refusal boundary |
| crates/core/src/entity_facing.rs:18 | derive physical facing,not Backstab |
| crates/core/src/entity_facing.rs:34 | Garen/Trundle only;Shaco unknown |
| crates/core/src/entity_facing.rs:44 | physical orientation validity |
| crates/core/src/entity_yaw.rs:2 | native yaw arithmetic distinct from damage predicate |

## Publication et préservation

PREPARE/CHECK/PUBLISH/AUDIT :code0. Les contrôles négatifs refusent72 associations et4graphes invalides,notamment fausse acceptation,source absente,binaire changé,question étrangère,dépendance retirée. Graphe99173sources/4652consommateurs ;revue de4652ancres exactes sans divergence. La validation structurelle globale ne re-hache pas toutes les sources ;les entrées sélectionnées sont vérifiées séparément par identité.

Deux bases SQLite mises à jour :quatre destinataires,42603 autres lignes conservées,42607 états manuels et23 historiques identiques,synchronisation Store idempotente. Trois fragments de traçabilité changés,42212 inchangés. Trois questions propres et quatre dépendances conservées. Registres des identités,hiérarchie et inconnues inchangés octet pour octet.

Fichiers livrés :completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json,reçu reference_requirement_trace_sources/shaco-passive-backstab-links-v624.json,preuve fidelity_shaco_passive_backstab_links_v624.json et ce rapport. Couverture,plan de complétion,reprise,CURRENT et HANDOFF mis à jour avec sauvegardes. Scripts,diagnostic Rust,journaux et observations sont conservés dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 sous revision624_shaco et revision624_Shaco.

La première revue globale a échoué avec code1 avant écriture du rapport et des documents de reprise :son générateur avait remplacé le compteur attendu par4625 au lieu de4652. L’audit d’intégration avait déjà validé4652. Le script qualifié revision625_trace_review_shaco_counts recontrôle les données effectivement publiées avec le compteur correct ;la revue initiale,son journal et son reçu restent conservés. Aucun registre ou état utilisateur modifié pour contourner ce contrôle.

## Manques et limites

Qualifier le prédicat arrière natif,seuil,moment du test,types de dégâts,cibles et ordre avec critiques/mitigation ;implémenter le bonus dans le consommateur réel. Qualifier les producteurs d’orientation pour les entités concernées et les cas inconnus,nuls ou invalides ;tester rotation entre lancement/impact,cibles mobiles,attaques interrompues,pet/clone et autres types d’unités. Préserver les variantes Hallucinate et qualifier E/Q séparément. Mort/réapparition,reconnexion,HUD,VFX,sons,animations et réseau restent à vérifier. Aucun serveur historique ou rendu exécuté. V564/V606 restent ouverts. Ni Shaco,ni le jeu,ni SYS-01.2-02 ne sont déclarés terminés.

Suite : Continuer SYS-01.2-02 depuis revision625_trace_review_shaco_counts/REVIEW.json. V624 Shaco / Backstab :62sources natives,186associations,28points et56liens. Texte4.20 :20% de dégâts supplémentaires depuis le dos ;angle,seuil,moment,types de dégâts et ordre avec critiques non résolus. PARType absent,Mana actuel distinct ;textes hérités régénération mana40/60/80% non adoptés. 28Lua entièrement lus,aucune limite NEWTABLE,six BuffData résolus,13preloads. CharScript,FromBehind et CastFromBehind vides ;métadonnées de persistance non assimilées au callback. Spell4=HallucinateFull,ExtraSpell1=Hallucinate,variantes distinctes ;DDF8lignes,une liaison EbonusAD1.0. 24références communautaires :Q délègue buffs sans blink démontré,W TODO peur/invisibilité et timers de dégâts,E omet bonusAD et ajoute1,33 contre Slow,R buff8s/explosion au porteur au lieu du clone18s. Quatre cas publics base/Épée face/dos :24attaques,108 refus,724ticks,12trajets sans réémission. Garen orienté par déplacement réel,yaw-89,99999,cosinus+1/-1 ;dégâts identiques face/dos45,14804 ou52,98895 avec Épée. Orientation Shaco absente,producteur actuel limité à Garen/Trundle ;aucun sort Shaco accepté. BUILD/RUN0 ;collecteur initial KeyError facing omis par serde,corrigé par relecture de la même exécution sans recompilation. Inspection0,acquis génériques et V564/V606 conservés,aucun gameplay modifié. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Shen. Goal actif.
