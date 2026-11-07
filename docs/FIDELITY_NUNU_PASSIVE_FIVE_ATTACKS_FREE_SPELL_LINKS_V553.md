# SYS-01.2-02 — Nunu : Visionary, V553

25 octobre2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 à17:46:45, fuseau/déploiement inconnus. Catalogue4.20.1 distinct. **Traçabilité partielle, aucune acceptation du passif, du champion ou du jeu.**

## Intégration et périmètre

Les trois fiches CH-Nunu-PASSIF-SOURCE, CH-Nunu-PASSIF-SIMULATION-CONTRAT et CH-Nunu-PASSIF-SIMULATION reçoivent33arêtes natives. Les deux fiches de simulation reçoivent36liens vers18points actuels, tous qualifiés entry_boundary_only et provides_feature_consumer=false. SYS-01.2-02 référence le lot. Les anciens liens restent conservés ; aucun chargeur partagé ou lecteur de source n’est promu en implémentation de Visionary.

Phases, lots, prérequis et propriétaires des questions sont relevés dans le reçu. Trois questions propres et quatre dépendances conservées ;aucun inconnu ajouté ou fermé ;aucun statut, critère, case, note ou historique manuel modifié.

## Sources natives

| Fichier | Identifiant |
|---|---|
| Nunu.inibin | OLS-09134c7b-dbd7-5075-bcb3-f61621e363d9 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptNunu.luaobj | OLS-6f98d4d7-488c-590c-9610-a7823ce62de0 |
| CharScriptNunu.preload | OLS-8a465d13-a535-5a9a-96a1-e79d4f42b823 |
| Visionary Counter.inibin | OLS-8366b75d-69e2-5c10-bd5c-9af6578fe922 |
| Visionary.inibin | OLS-2ac789f8-54a7-5033-8dbb-da268da9c45e |
| Visionary.luaobj | OLS-2c57c0a1-05ed-55aa-b44a-ceb1a4b969ba |
| Visionary_Counter.luaobj | OLS-61cc496f-d67e-5b1c-80f3-9515190e21bf |
| Visionary_Counter.preload | OLS-7ebdb048-b1fb-5851-8563-17eb3220ee03 |
| Visionary_marker.luaobj | OLS-b96df443-378d-5901-ba62-2bf4c3b01360 |
| Visions.inibin | OLS-e136d9db-8573-5b20-b592-299c29858433 |

Les11fichiers correspondent en taille/SHA au registre et en taille/MD5 aux projets RADS sélectionnés. La découverte précédente a été revalidée ;elle ne prouve pas une absence mondiale de corps serveur original.

La définition Passive1LuaName=Visionary concorde avec BuffName du marqueur Visionary_marker.luaobj, icône Yeti_FrostNova.dds. Visionary_Counter.luaobj déclare Visionary Counter et Yeti_FrostNova_Charging.dds. Les trois INIBIN lient directement les textes2898 Visionary,2899 Visionary_Counter et2900 Visions. Le premier décrit cinq attaques de base puis le prochain sort sans mana ;le compteur décrit sa préparation et Visions l’état de gratuité. La description du champion4242 confirme cinq attaques. Les noms restent distincts ;aucun ordre d’alias n’est inventé.

Quatre Lua entièrement parsés, sans prototype de callback enfant. Trois ont des initialisations littérales qualifiées. **Visionary.luaobj contient NEWTABLE pc8, non pris en charge par le lecteur de littéraux : ce n’est pas une corruption.** Ses constantes comprennent BuffName/Visions, Visionary_buf.troy et NunuBot ;elles ne deviennent pas automatiquement des affectations exécutées ni une qualification de skin. CharScriptNunu ne contient qu’un RETURN. Ses preloads nomment visionary_counter, visionary_marker et apbonusdamagetotowers ;celui du compteur nomme visionary. Ils ne prouvent pas la séquence serveur, un bonus aux tourelles ou un rendu.

Passive1 est absent. Les anciens textes évoquent une chance aléatoire, Yuralia10%, des sorts non ultimes et non objets, avec niveaux1/6/11. **Ils sont conservés sans adoption comme règles de Visionary4.20.** Les cinq références communautaires (CharScript C# vide, statistiques et trois fiches de sorts) ont leur provenance distincte.

## Consommateurs actuels et diagnostics réels

Chemins inspectés : join/stats, apprentissage et règles de rang, commande, Cast ciblé, CastAt, coût et exécution du W d’Annie, dégâts communs, régénération, tick, ordre/tick d’attaque, impact de mêlée et projectile, impact physique commun et classification mana. Ces frontières existent ;elles ne démontrent pas un compteur ou une consommation gratuite propre à Nunu.

Deux parties Map10 publiques. Déplacements, arrêts, attaques, apprentissage et tentatives de sorts passent par les commandes normales. Aucun PV, mana, or, XP, dégât, position ou effet injecté. Acteurs vivants au niveau1, sans fin de partie. Garen reste arrêté ;chaque baisse de PV comptée possède un témoin d’impact de mêlée libéré ou de projectile en vol.

| Cas | Attaques ordinaires observées | Sort après la cinquième attaque |
|---|---|---|
| Nunu/Garen |792,840,888,936,984 |4Learn,4Cast et4CastAt refusés |
| Annie/Garen, témoin distinct |820,872,924,976,1028 |W appris et accepté1028 ;coût70mana,recharge240ticks,impact1036 |

Nunu renvoie respectivement champion skill progression not implemented, champion spell not implemented et champion ground spell not implemented. Les91ticks984→1075 après refus montrent la régénération de base de Garen, avec mana/recharges Nunu inchangés et rangs0. **Les cinq attaques ne qualifient pas l’activation du compteur ;aucun sort gratuit n’a été consommé ou vérifié.** L’absence de baisse de mana lors d’une commande refusée ne prouve pas la gratuité.

Le témoin Annie dépense70mana après ses cinq attaques. Son W inflige un impact au1036 :429.8858032→376.9479065PV, baisse nette52.9378967. La valeur calculée avant régénération du même tick est52.9901581 ;le diagnostic emploie une tolérance0.2PV entre valeur de dommage et baisse nette. Ce contrôle montre un chemin courant de sort payant pour un autre champion, **pas une implémentation de Visionary**. Les91ticks1028→1119 ne produisent qu’un impact de sort.

24refus publics :17Nunu et7Annie, chacun avec comparaison individuelle du snapshot complet. Cinq gardes communes (joueur inconnu, slots Cast/CastAt/Learn invalides, point non fini),12refus des quatre slots Nunu, W Annie non appris et nouvelle tentative pendant son cast. Total10attaques ordinaires et182ticks d’observation après les tentatives.

## Vérifications, échec conservé et limites

Le premier build privé a réussi, puis le run a échoué :l’attendu réutilisé imposait des PV cibles constants après les cinq attaques, alors que Garen régénère normalement. La copie qualifiée calcule chaque tick la régénération de base. Ancien source, manifeste, verrou, logs et exécutable restent conservés et pinés ;le nouvel exécutable possède un autre nom. Aucun code du jeu modifié.

Le vérificateur Python qualifié a émis SyntaxWarning sur la juxtaposition 0.002for ;ce warning est conservé dans la preuve et n’a pas interrompu l’exécution. Build/run qualifiés code0 ;core non-test réutilisé du cache.1158entrées source/ressource et anciens artefacts exacts. Identités/checksums du verrou privé alignés sur Cargo.lock racine.

Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-nunu-passive-five-attacks-free-spell-qualified-probe.exe` ;6028288octets ;SHA256 `7f41c543e029d390d839ab7f81cf2ba498fd2659fa9788159af12cd9ee8b2cef`. Commandes, outils, logs, verrous et sources : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision553_Nunu_passive_probe_qualified\OBSERVATIONS.json`. Aucun client historique, corps serveur original, VM Lua, GUI, GPU, réseau ou audio exécuté.

Inspection,prepare,check,publish,audit réussis.72associations invalides et4graphes invalides refusés, dont cinq attaques présentées comme passif accepté, commande refusée présentée comme gratuité, NEWTABLE présenté comme corruption, Annie assimilée à Visionary, question étrangère ou dépendance retirée. Ces contrôles qualifient la traçabilité et sa conservation, pas le gameplay.

Deux bases réelles :4destinataires mis à jour par base ;42603autres lignes de catalogue,42607états manuels et23événements historiques exacts. Store.task/copy_text/summary, dépendances/questions, intégrité et synchronisation idempotente vérifiés.3fragments modifiés,42212exacts ;42211autres objets tâche/trace conservés. IDs, hiérarchie et inconnus identiques en octets.

Graphe42215exigences,98888sources,2978consommateurs ;26189questions ouvertes/5517résolues.2978ancres et527fichiers courants exacts, zéro divergence. Aucun nouveau recensement physique des98k sources.8332CH au seul chargeur partagé est une file de recherche, pas un taux d’achèvement.

## Fichiers et travail restant

Registres modifiés :completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json. Reçu docs/reference_requirement_trace_sources/nunu-passive-five-attacks-free-spell-links-v553.json ;preuve docs/fidelity_nunu_passive_five_attacks_free_spell_links_v553.json. Couverture, plan, reprise, CURRENT et HANDOFF mis à jour avec sauvegardes. Scripts archivés ;V552 et preuves antérieures conservés. Aucun gameplay/asset modifié, aucun stage/reset/commit.

Restent ouverts :corps serveur,événement exact de comptage (attaque,libération ou impact),cibles,maintien/reset du compteur,admission du prochain sort,cost provider,consommation et exclusions,échecs de cast,mort/réapparition et présentation.

Continuer SYS-01.2-02 depuis revision554_trace_review/REVIEW.json. V553 Nunu publié/audité :3fiches,11sources natives,33arêtes,36liens vers18frontières false.5attaques ordinaires Nunu792/840/888/936/984,puis4Learn/4Cast/4CastAt refusés ;gratuité et compteur non qualifiés. Témoin Annie5attaques820/872/924/976/1028,W appris/lancé1028,coût70mana,impact1036 ;pas Visionary.24refus individuels,91ticks par cas ;régénération normale observée. Premier diagnostic en échec attendait PV constants ;copie corrigée,ancien binaire/logs conservés. SyntaxWarning Python conservé,build/run corrigés0,moteur inchangé.3bindings,4Lua sans callbacks,2preloads,5références communautaires. Visionary.luaobj NEWTABLE pc8 non interprété,pas corruption ;constantes distinctes des affectations. Anciens textes chance/Yuralia10%/exclusionultime et niveaux1/6/11 non adoptés. Corps serveur,événement de comptage,cibles,reset/consommation et présentation ouverts.99autres contrats/parents de passifs à examiner ;8332CH chargeur seul est une file de recherche. Examiner ensuite Veigar/Equilibrium :définition Passive1LuaName VeigarEquilibrium,textefont regenmana+1% par1% manquant ;identifier les payloads effectivement disponibles,les consommateurs de mana/régénération et une éventuelle situation ordinaire de mana manquant. Ne pas inventer une absence mondiale de serveur ou une réussite depuis une réserve pleine ou un coût refusé. Goal actif ;ne pas republier V553 sans cause nouvelle. Découverte Veigar déjà effectuée :revision554_Veigar_discovery/OBSERVATIONS.json,4sources natives,1binding,1Lua sans callbacks,0preload,3références communautaires. Le INIBIN et Lua VeigarEquilibrium sont dans Characters/Veigar/Spells ;CharScriptVeigar absent du seul répertoire Scripts inspecté. LuaBuffName concorde ;BuffTextureName VeigarEntropy.dds diffère du Passive1Icon Veigar_Entropy.dds,ne pas réécrire automatiquement. Texte2866/4301:+1% regen par1%mana manquant. Ancien texte Mundo/dégâts et niveaux1/9/17 non adoptés. Piste de diagnostic non exécutée :achat public Sapphire1027 augmente le plafond sans remplir le mana selon shop.refresh_item_caps ;observer les premiers ticks avant la première pulsation de fontaine attendue au30,à vérifier dans interactions/config. Une réserve pleine ou une pulsation de fontaine ne prouve pas Equilibrium. Runtime,inspection qualifiée et publication restent à faire ;ne pas relancer la découverte sans cause nouvelle.
