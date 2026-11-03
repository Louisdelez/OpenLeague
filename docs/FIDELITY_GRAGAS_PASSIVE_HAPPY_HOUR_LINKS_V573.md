# SYS-01.2-02 — Gragas : Happy Hour, V573

Date UTC 2026-10-26T00:55:57.781970+00:00. F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45; fuseau et déploiement non établis. Catalogue officiel4.20.1 distinct.

## Résultat intégré et portée

CH-Gragas-PASSIF-SOURCE, CH-Gragas-PASSIF-SIMULATION-CONTRAT et CH-Gragas-PASSIF-SIMULATION :48 associations vers16 ressources natives,40 liens vers20 points de code courants. SYS-01.2-02 référence le lot. Trois questions propres et quatre dépendances conservées; prérequis de phase/lot consultés, sans les déclarer satisfaits pour une acceptation du jeu. Les points de code restent `entry_boundary_only`, `provides_feature_consumer=false` pour Happy Hour.

**Les sources du passif existent. Le déclenchement par une capacité Gragas réussie n’est pas disponible dans les parcours actuels inspectés et testés.** Aucun gameplay ou asset modifié dans ce lot de traçabilité. Aucune absence de modèle, texture ou animation déduite des refus de gameplay.

## Sources vérifiées

| Ressource retenue | Identifiant |
|---|---|
| Gragas.inibin | OLS-93336735-982e-529d-9dfb-648617d6ec32 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptGragas.luaobj | OLS-b0ddfbb3-c281-54ea-9db7-d4cc2fd9ed32 |
| CharScriptGragas.preload | OLS-d6985cd6-bf69-5202-8482-82d2527ee6aa |
| GragasPassive.inibin | OLS-b9eb2c76-9e37-5b81-8bbb-3cadb80940b4 |
| GragasPassive.luaobj | OLS-f1637ae4-444b-5846-abdb-a6facb0f03c0 |
| GragasQ.inibin | OLS-157f5bc7-dafd-55a1-97fc-451f6cd271a4 |
| GragasQ.luaobj | OLS-7f531688-cca6-5363-8e05-95ee63025338 |
| GragasW.inibin | OLS-56bc20f0-1f0e-545b-9c35-e930d9e0497f |
| GragasW.luaobj | OLS-5d3b8675-2824-5503-96d1-109491feb411 |
| GragasE.inibin | OLS-d7bf8159-981e-581b-b345-5c5790b969a0 |
| GragasE.luaobj | OLS-09f07bf0-e953-5fab-ae19-65a5ef59a621 |
| GragasR.inibin | OLS-db3d768a-dd7a-535f-9c83-bfe838f1a94c |
| GragasR.luaobj | OLS-d2a4259a-d6d1-589d-bb5b-ebe03bea35ab |
| GragasQToggle.inibin | OLS-175d665f-3e32-50f3-a08c-23b7ca30bdd8 |
| GragasQToggle.luaobj | OLS-7dd63d80-ea0e-5b79-a7d7-7ae817274ab1 |

20 candidats lus,16 retenus. Taille/SHA256 vérifiés contre le registre et taille/MD5 contre les manifestes RADS sélectionnés. Cette appartenance ne prouve pas la priorité de montage effective du client historique.

Gragas.inibin lie Passive1LuaName=GragasPassive et Passive1Icon=GragasPassiveHeal.dds. GragasPassive.luaobj reprend BuffName et BuffTextureName, avec PersistsThroughDeath=true. Cette persistance déclarée ne qualifie pas la conservation ou la réinitialisation du délai de récupération à la mort.

Le binding `game_buff_tooltip_GragasPassive`, font en_GB ligne1960, annonce **4% de la santé maximale lors d’un lancement de sort, au plus une fois toutes les8secondes**. Le texte de description du personnage ligne4196 concorde. Le paramètre d’affichage f1 représente le montant; son producteur historique et les calculs exacts ne sont pas exécutés ici. Ne pas transformer cette lecture en test réussi du passif.

Sept chunks Lua sélectionnés sont intégralement lus, sans prototype enfant. Six initialisations littérales sont reconnues; GragasW.luaobj s’arrête dans le lecteur littéral sur NEWTABLE pc16. Le parser a consommé les octets :c’est une limite du lecteur, pas une corruption prouvée. Les callbacks du serveur historique ne sont pas récupérés ou exécutés par cette lecture.

Q.luaobj déclare DoesntTriggerSpellCasts=false, QToggle.luaobj=true. Ces métadonnées distinguent le lancement et sa variante; elles ne prouvent pas à elles seules l’éligibilité au passif. QToggle conserve les noms Flash Frost/Cryophoenix_FrigidOrb.dds. Gragas.inibin contient aussi un Passive1Desc parlant d’Alistar, des descriptions400/600PV et des champs de niveau10. Ces valeurs héritées restent enregistrées sans réécriture ni adoption comme règles de Happy Hour.

Quatre clés de tooltip ont été relevées dans les16sources; GragasPassive et GragasQ résolvent un texte, GragasW et GragasE n’en résolvent pas dans le font sélectionné. **Deux bindings sans texte, pas deux fichiers de sorts absents.** WAttackBuff et WSelf, examinés avec leurs Lua puis exclus de l’autorité du passif, décrivent respectivement l’attaque renforcée et la réduction de dégâts du W. Leurs textes ne remplacent pas automatiquement les clés manquantes.

CharScriptGragas.preload référence gragaspassive, apbonusdamagetotowers et rengar_base_w_heal.troy. Une référence de preload n’est ni une exécution de soin ni une validation visuelle. Quatorze références communautaires sont pinées séparément; CharScriptGragas.cs est vide. Les scripts Q/W/E/R communautaires existent, mais leur présence ne les qualifie pas comme serveur4.20 original.

## Vérifications réellement exécutées

Deux simulations Map10 ordinaires :Gragas bleu, Annie rouge, connexion avec Soin dans le premier emplacement. Le second cas achète publiquement un Cristal de rubis1028 avant de se déplacer. Les deux champions atteignent les positions centrales via Move puis Stop. Annie inflige cinq attaques; le déficit dépasse90PV. Aucun changement direct de position, santé, XP, rang, effet ou ressource; aucun événement artificiel de dégâts.

| Cas | PV maximum | Impacts reçus | Soin d’invocateur observé | Refus | Ticks de suivi |
|---|---:|---:|---:|---:|---:|
| base_health | 583.520020 | 5 | 90.0 | 20 | 300 |
| ruby_crystal | 733.520020 | 5 | 90.0 | 20 | 300 |

Attendu/observé :chaque impact a un projectile source/cible présent dans le snapshot précédent; perte de santé corrigée de la régénération égale aux dégâts physiques bruts×100/(100+armure),résidu inférieur à0.002. Le Cristal de rubis ajoute150PV maximum. Niveau1 confirmé.

Les40refus atomiques couvrent joueur inconnu,attaque de soi,slot invalide,Learn/Cast/CastAt sur les quatre capacités,emplacement d’invocateur invalide ou vide,cible ennemie ou soi explicite pour Soin,et relance de Soin pendant son délai. Chaque snapshot reste inchangé. **Les casts refusés ne testent pas la guérison après un cast réussi.**

Contrôle positif séparé :Action::Summoner déclenche Soin et restaure exactement90PV dans les deux cas,avec un délai courant7200ticks. Ces valeurs proviennent du contrat local heal_rules.json (niveau1=90,cooldown240s); ce contrat conserve son conflit natif300s et son interprétation communautaire par niveau. Il ne sert pas de source aux4%/8s de Happy Hour. Le suivi300ticks par cas montre uniquement la régénération ordinaire attendue, sans autre soin discret; ce n’est pas un test d’expiration du passif, jamais déclenché ici.

Le code inspecté relie les commandes, apprentissage,dispatch des sorts,PV maximum,attaques,dégâts,régénération et soin partagé. Les chemins de cast refusent explicitement Gragas. Simulation::heal fournit un mécanisme de soin générique,distinct du déclencheur manquant. Les modificateurs de soin et le cycle de mort/réapparition sont lus statiquement mais non exercés dans ce lot.

## Identités et conservation

Exécutable `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-gragas-passive-happy-hour-probe.exe`,6018048octets,SHA256 `d12672adae3aa86b35a7ea5a0929453219a6300262e4ce6564605802f25565d5`. BUILD/RUN code0,openleague_core non-test,verrou privé aligné sur les identités/checksums du verrou racine.1158entrées core/ressources inchangées. La chaîne précédente conserve V572centre,les diagnostics de voie échoués et leurs ancêtres. Pas de serveur ou client historique exécuté, pas de transport réseau ni de rendu GPU qualifié.

Discovery/inspection/prepare/check/publish/audit code0.72associations invalides et4graphes invalides refusés. Deux bases SQLite vérifiées via Store.task/copy_text/summary/dépendances et résolution de trace :4destinataires,42603autres lignes de catalogue,42607états manuels et23événements historiques conservés. Intégrité et sync normale idempotente contrôlées. Identifiants,hiérarchie,inconnues inchangés en octets.3fragments de trace enrichis,42212conservés.

Revue globale fraîche :42215exigences,98968sources,3380consommateurs;3380ancres exactes,0divergence.26189inconnues ouvertes et5517résolues inchangées. Ce contrôle ne re-hashe pas toutes les sources et ne mesure pas le pourcentage du jeu terminé.

Le générateur de livraison a d’abord refusé un remplacement textuel trop large avant de produire le script; aucune publication n’avait eu lieu. Le sélecteur a été corrigé et le script généré a passé les contrôles ci-dessus. Ce défaut de préparation ne doit pas être rapporté comme un échec de compilation du moteur.

## Travail restant et limites ouvertes

- Qualifier quels événements Q/W/E/R et recasts déclenchent Happy Hour,leur ordre et leur politique d’annulation/refus.
- Retrouver ou qualifier le producteur f1,les arrondis,la date de mesure des PVmaximum,le plafond de santé et les modificateurs de soin.
- Intégrer le déclencheur et le délai8secondes dans le moteur; vérifier un cast réussi,des casts avant/à/après échéance et l’absence de double déclenchement.
- Vérifier santé pleine/blessée,PVmaximum variables,mort/réapparition,modificateurs et transitions de partie.
- Qualifier séparément réplication réseau,HUD,animation,VFX et audio; distinguer ressource référencée,ressource disponible et rendu effectif.
- Conserver le défaut de déplacementV564 ouvert; les parcours centraux réussis ne le corrigent pas.

## Fichiers et reprise

Registres modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json,docs/fidelity_sources_4_20.json. Reçu docs/reference_requirement_trace_sources/gragas-passive-happy-hour-links-v573.json;preuve docs/fidelity_gragas_passive_happy_hour_links_v573.json. Couverture,plan,checkpoint,CURRENT,HANDOFF et deux bases mis à jour avec sauvegardes. Scripts et journaux :revision573_Gragas* sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Statuts,cases,notes et inconnues conservés.

Continuer SYS-01.2-02 depuis revision574_trace_review/REVIEW.json. GragasV573 publiée/auditée :3fiches,16sources parmi20candidats,48associations,20points/40liens limités. Deux cas publics base/RubyCrystal :10impacts,40refus,600ticks;sortsGragas refusés. Soin séparé restaure90PV dans chaque cas,ne prouve pas HappyHour. Texte natif4%maxHP/8s;casts/recasts,ordre,arrondis,modificateurs,mort/réapparition restent ouverts. QToggle DoesntTriggerSpellCasts=true avec aliasFlashFrost hérité;W limité NEWTABLE pc16;bindingsW/E sans texte. Préserver la chaîne INPUTS_BEFORE.previous_artifacts issue deV572centre et les diagnostics échoués. Aucun statut/case/inconnu fermé. Reprendre un autre passif de la file après inspection réelle,par exemple Graves. Le défaut déplacementV564 reste ouvert;goal actif.
