# SYS-01.2-02 — Anivia : Rebirth, V558

25 octobre2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ;build littéral2014-11-17 à17:46:45, fuseau et déploiement inconnus. Catalogue4.20.1 distinct. **Traçabilité partielle ;aucun passif,champion ou jeu accepté.**

## Résultat intégré

CH-Anivia-PASSIF-SOURCE, CH-Anivia-PASSIF-SIMULATION-CONTRAT et CH-Anivia-PASSIF-SIMULATION reçoivent54associations vers18fichiers natifs. Les deux fiches de simulation reçoivent40liens vers20points de code, tous entry_boundary_only et provides_feature_consumer=false pour Rebirth. SYS-01.2-02 référence le lot. Chargeurs et lecteurs antérieurs conservés sans promotion en mécanique terminée.

Prérequis de phase et de lot relevés dans le reçu. Trois questions propres et quatre dépendances conservées ;aucun statut,critère,identifiant,case,note ou historique manuel modifié. Aucun code du jeu ni asset modifié.

## Sources et limites natives

| Fichier | Identifiant |
|---|---|
| Anivia.inibin | OLS-621265ef-9b55-5c59-a12f-80dcec45ce41 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| AniviaEgg.inibin | OLS-516b0831-6cdf-5316-b3fb-1bacc8418a2b |
| CharScriptAnivia.luaobj | OLS-12c9e1da-3804-5172-b495-8bd7bedce1c9 |
| CharScriptAnivia.preload | OLS-e53573c0-12a0-5655-93ee-6fbad8fbca4a |
| Rebirth Marker.inibin | OLS-639aef5a-3398-565f-858d-7feeb1835364 |
| Rebirth.inibin | OLS-72d9b6be-848b-54b8-9e01-50d41ec4394f |
| Rebirth.luaobj | OLS-ac3823c3-f5a0-5bfb-aeb3-beb31d5c5cdb |
| Rebirth.preload | OLS-2fbe5c00-74f8-55b0-9bee-3382fa00cefb |
| RebirthAnimationPlay.luaobj | OLS-30d3ca1b-c56a-59ba-9b0c-5f59e69c7b24 |
| RebirthAnimationReset.luaobj | OLS-a467e621-530e-53f5-bf43-902753d24778 |
| RebirthCooldown.inibin | OLS-a342cf9a-5c96-5062-a8a6-1a51d8ef19f3 |
| RebirthCooldown.luaobj | OLS-d139732b-0466-5c56-ae6e-011f40da6749 |
| RebirthCooldown.preload | OLS-a09ba19e-1f59-5576-9a9d-7a09b970219a |
| RebirthMarker.luaobj | OLS-3c11d834-5015-538a-b089-c1e4835418bb |
| RebirthReady.inibin | OLS-228f195e-1b6f-5e78-9d04-4701e0f79d42 |
| RebirthReady.luaobj | OLS-f43c3099-ff05-549a-9e9f-4a6dcb212382 |
| RebirthReady.preload | OLS-bfbc529c-c16e-5f4e-9d8b-74a4a256fa29 |

Taille/SHA256 conformes au registre ;taille/MD5 conformes aux projets RADS sélectionnés lors de la découverte, identités revérifiées à l’inspection. Anivia.inibin, AniviaEgg.inibin, Rebirth Marker.inibin et RebirthMarker.luaobj gardent leurs identités distinctes.

La définition Anivia porte Passive1LuaName «Rebirth Marker», concordant avec le BuffName de RebirthMarker, et Cryophoenix_Rebirth.dds. Quatre bindings vers Rebirth, Rebirth_Marker, RebirthCooldown et RebirthReady. Texte2516 :dégâts létaux, transformation en œuf à pleine vie, f1armure/MR, survie pendant6secondes, recharge4minutes. Les fournisseurs et règles exactes restent inconnus.

Sept Lua entièrement parsés, sans prototype de fonction enfant ;six permettent l’extraction d’initialisations littérales. Rebirth.luaobj contient NEWTABLE au pc16, non pris en charge par ce lecteur littéral. C’est une limite de qualification, pas une corruption du fichier. RebirthReady déclare OnPreDamagePriority8 ;cela ne prouve pas l’exécution d’un callback. AnimationPlay/Reset et Cooldown déclarent BuffNameRebirthCooldown :le nom du script ne prouve pas une animation effectivement jouée.

Quatre preloads et sept références communautaires gardent leur provenance. Les niveaux de passif absents d’Anivia ne sont pas remplacés par1/4/7 présents dans AniviaEgg. Aucune normalisation d’alias ni politique d’héritage inventée. NightmareBotSpiritAnivia et ZacRebirth sont exclus de cette sélection.

## Chemins actuels et cas exécutés

Points inspectés :join/stats, commande/gardes de mort, Learn/next_rank, Cast/CastAt, attaques/basic_attack_hit, apply_damage, base_death_ticks, advance_respawns, placement, reward_champion_death, tick, régénération, classification/restauration des ressources et gardes achat/vente. Le code courant des dégâts létaux programme le délai de mort ordinaire ;le retour à la fontaine passe par advance_respawns. Ces consommateurs ne sont pas un producteur Rebirth qualifié.

Deux simulations Map10 publiques, Anivia puis Ahri en contrôle distinct. Déplacement vers une rencontre, attaques ordinaires non critiques de Garen jusqu’à la mort du champion, puis arrêt de Garen. Aucun PV,mana,or,XP,dégât,position ou effet directement injecté ;aucun objet acheté. Les deux champions restent niveau1 ;aucune fin de partie.

| Victime | Coups avant mort | Tick mort | Tick après6s | Tick retour fontaine | Refus |
|---|---:|---:|---:|---:|---:|
|anivia|11|1321|1501|1801|22|
|ahri|12|1356|1536|1836|10|

Attendu :observer le traitement réel de dégâts létaux et comparer la fenêtre native6secondes au délai de mort courant. Observé :Anivia meurt au tick1321 après11attaques ;elle est toujours à0PV au1501 et revient à pleine vie à la fontaine au1801. Ahri meurt au1356 après12attaques, reste à0PV au1536 et revient au1836. Les16secondes correspondent aux480ticks du délai niveau1 de death_times_map10.json. Ce retour à la fontaine **ne valide pas Rebirth**.

Chaque victime reste morte à sa position de mort pendant479ticks ;le480e donne le retour à la position initiale de sa fontaine, à plus de1000unités du lieu de mort. Identité du champion et compteur d’une mort conservés. Les960ticks postmortem sont enregistrés ;aucune unité dont le nom ou la définition contient AniviaEgg n’apparaît dans ces snapshots. Ce contrôle de noms ne démontre pas une absence visuelle globale et ne remplace pas une inspection du rendu.

Le coup létal produit le crédit ordinaire :une élimination pour Garen, une mort pour la victime,165XP et400or supplémentaires au premier sang. Les contrôles lisent ces valeurs observées sans injecter de récompense. L’état de mort persiste à6secondes ;aucun œuf actif ni renaissance sur place n’est qualifié.

32refus individuels avec snapshot complet inchangé :cinq gardes communes par cas (joueur inconnu,cible inconnue,cible soi,objet inconnu,vente hors slots), douze Learn/Cast/CastAt d’Anivia avant le combat, quatre commandes du mort par cas et une attaque sur la cible morte par cas. Après réapparition, Stop est de nouveau accepté.

## Manques restant ouverts

- Producteur Rebirth avant mort :transformation en œuf, vie et défenses, maintien de l’identité et règles de ciblage.
- Fournisseur f1, niveaux et ordre des modificateurs, six secondes de survie de l’œuf, PV au retour, destruction/interruption et recharge de quatre minutes.
- Animation, modèle de l’œuf, sons et présentation effective. La présence de fichiers natifs n’est pas une preuve de rendu.
- Exécution native des scripts et comportement historique du serveur. Aucun client original,VM Lua,GUI,GPU,audio ou réseau exécuté.

## Vérifications et conservation

Build/run, inspection, préparation, contrôle du candidat, publication et audit :code0. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-anivia-passive-rebirth-lethal-egg-probe.exe` ;6078464octets ;SHA256 `05d5af32d8275cba390a06286787b10ab32b14934b39116efd7a946a2a1fda21`. Reçu runtime `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision558_Anivia_passive_probe\OBSERVATIONS.json` ;logs BUILD/RUN conservés.1158entrées de code/ressources et anciens artefacts exacts ;verrou privé aligné sur Cargo.lock racine. Core non-test issu du cache ;aucun nouveau passage de toute la suite historique revendiqué.

72associations invalides et4graphes invalides rejetés :respawn assimilé à Rebirth, mort assimilée à œuf, absence de nom assimilée à absence visuelle, limite NEWTABLE assimilée à corruption, priorité native assimilée à callback exécuté, niveaux inventés, question étrangère ou dépendance retirée.

Deux bases SQLite réelles :4destinataires chacune ;42603autres lignes de catalogue,42607états manuels et23événements historiques inchangés. Store.task/copy_text/summary, dépendances, résolution des références, intégrité et synchronisation idempotente vérifiés. Trois fragments de trace changés,42212inchangés. IDs,hiérarchie et registre des inconnues identiques en octets.

Graphe42215exigences,98908sources,3067consommateurs ;3067ancres et527fichiers courants exacts, zéro divergence.26189questions ouvertes/5517résolues. Pas de nouveau recensement physique de toutes les sources.8322fiches CH avec seul chargeur partagé constituent une file de recherche,pas un taux d’achèvement.

## Fichiers et suite

completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json ;reçu docs/reference_requirement_trace_sources/anivia-passive-rebirth-lethal-egg-links-v558.json ;preuve docs/fidelity_anivia_passive_rebirth_lethal_egg_links_v558.json ;couverture,plan,reprise,CURRENT et HANDOFF avec sauvegardes. Scripts archivés,anciennes preuves conservées. Aucun stage/reset/commit.

Continuer SYS-01.2-02 depuis revision559_trace_review/REVIEW.json. Anivia V558 publié/audité :18sources natives,54arêtes,20points actuels/40liens false. Deux cas publics Anivia/Ahri morts après11/12attaques,encore morts après6secondes,respawn fontaine après16secondes.960ticks,32refus,aucune injection. Anivia mort1321,observation1501,respawn1801 ;Ahri1356/1536/1836. Aucun Rebirth qualifié ;mort/respawn ordinaires distincts.4bindings,7Lua sans callbacks,4preloads,7références communautaires ;Rebirth NEWTABLEpc16 limite du lecteur,non corruption. f1armure/MR,œuf6s,recharge4min et présentation ouverts. Anivia niveaux absents/AniviaEgg1-4-7 non adoptés ;OnPreDamagePriority8 ne prouve pas callback. Aucun gameplay changé,statut/case/inconnue fermé. Examiner ensuite Azir/Shurima Legacy :conversion CDR vers vitesse attaque et SunDisc depuis ruines,avec sources natives et consommateurs actuels distincts. Ne pas republier V558 sans cause nouvelle. Goal actif. Découverte Azir déjà faite :revision559_Azir_discovery/OBSERVATIONS.json,23sources natives dont SunDisc,TowerClicker,SoldiersTowerClicker et attaque SunDisc,2bindings,11Lua sans callbacks,5preloads,6références communautaires. Huit Lua dépassent le lecteur littéral NEWTABLEpc6/8/10/12 ;trois CharScript sans globals,aucune corruption déduite. Texte1697 :1.25%AS par1%CDR,SunDisc recharge3min,désintégration1min,ruines tourelles Nexus/inhibiteur ennemies exclues. Azir niveaux absents ;TowerClicker1/4/7 distincts. Scripts du seul Azir absent localement. Pistes de contrôles publics dans shop_foundation :Codex3108 coûte820,+10%CDR/+30AP ;Dague1042 coûte450,+15%AS. Aucune exécution Azir encore faite. Qualifier les deux branches séparément,ne pas prétendre avoir créé SunDisc à partir du seul contrôle de cadence. Ne pas refaire découverte sans cause nouvelle.
