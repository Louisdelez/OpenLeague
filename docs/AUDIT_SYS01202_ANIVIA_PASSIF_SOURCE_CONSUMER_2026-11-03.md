# SYS-01.2-02 — Anivia : liaison bornée des sources Rebirth aux consommateurs actuels

**V1183 — AUD-SYS-01.2-02-ANIVIA-PASSIF-SOURCE-CONSUMER-01.** L’audit documentaire/statique borné est terminé : sources et règles textuelles identifiées, lecteurs réels et chemin courant de mort/réapparition examinés, producteur Rebirth non qualifié dans ce périmètre, manques et reprises précisés. **CH-Anivia-PASSIF-SOURCE reste `a_qualifier`, sa trace `partial_with_open_questions`, son inconnue ouverte.** Aucun passif, champion ou jeu terminé ; aucune nouvelle exécution du jeu.

## 1. Objectif, contrat courant, prérequis et frontière de clôture

Tâche `CH-Anivia-PASSIF-SOURCE`, exigence **OLF-14ec441f-5efa-5b14-9c0c-103dc6ebf44a**, inconnue **OLU-171a3812-c5d0-5548-8b36-71d54f430648**. Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement non établis ; catalogue officiel4.20.1 conservé distinct.

Le contrat courant demande « Qualifier règles 4.20, valeurs de tous les rangs, coûts, délais, cibles et exceptions ». Critère exact : **« Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve. »** Le snapshot courant extrait dans `current_task_contract.json` conserve l’ID, le titre, le type SOURCE, required, required_if, les dépendances, l’acceptance et les preuves exigées : **huit champs inchangés par rapport à V558**. La fiche est requise, `required_if:null`, sans implémentation ni acceptation complètes.

Prérequis relevés, sans les déclarer satisfaits : `CH-Anivia-IDENTITE` reste `a_qualifier`, implementation/acceptancefalse. La phase D06 a `depends_on:[]` ; le lot D06-CH-Anivia est `a_faire`, `depends_on:[]`, et cite six `requires_packages` : **D04-SYS-04-1, D04-SYS-04-6, D05-SYS-05-2, D05-SYS-05-4, D14-SYS-14-2, D20-SYS-20-1**. Leurs états et consommateurs ne sont pas qualifiés par ce lot. Les sept tâches D01 SYS-01.1-01..07 extraites sont `a_valider`, implementationtrue/acceptancefalse. Ces prérequis d’intégration ouverts n’empêchent pas l’identification documentaire des sources et limites ; ils empêchent d’en déduire une intégration acceptée.

Critère de fin du **nouvel audit**, distinct de celui de la fiche SOURCE : relier les preuves V558/V1182 au contrat courant, lire les consommateurs nommés et leurs exceptions, distinguer texte/métadonnées/serveur, et fournir une décision bornée avec reprise. Le reçu d’intégration est **PASS_STATIC_SOURCE_CONSUMER_AUDIT, 14/14 cohérences**. Compte : **1 audit borné nouveau clos, 0 tâche SOURCE close, 0 inconnue close, 0 fonctionnalité close**. Aucun pourcentage du jeu n’est déduit.

## 2. Sources identifiées et acquis réutilisés

V558, du25/10/2026, est conservé :

- `F:\OpenLeague\docs\FIDELITY_ANIVIA_PASSIVE_REBIRTH_LETHAL_EGG_LINKS_V558.md` ;
- reçu `docs/reference_requirement_trace_sources/anivia-passive-rebirth-lethal-egg-links-v558.json`,607016octets, SHA-256 **1a503ec0ee8993e16913ebf752815607a83d19b1fab9de337912c42bafb888f8** ;
- preuve `docs/fidelity_anivia_passive_rebirth_lethal_egg_links_v558.json`,2713octets, `passed:true`, `native_Rebirth_qualified:false`, `passive_accepted:false`, `task_complete:false`.

Ces petites preuves correspondent aux pins documentaires V1182. Les **18 membres natifs V558** sont reliés à leurs18identités natives enregistrées et aux contrôles d’identité déjà exécutés dans `E:\mapslol3v3\audit_sys01202_passive_reuse_12_20261103\trace_excerpt.json` :18/18coïncident, **aucun natif rehashé ou redécodé dans V1183**. Les313contrôles d’identité datés de V1182 comprenaient natifs, références et code ; ce n’étaient pas313sources natives et ils ne sont pas rejoués.

Les18membres comprennent six INIBIN, sept LuaObj, quatre preloads et `fontconfig_en_GB.txt` : Anivia/AniviaEgg, CharScriptAnivia et les familles Rebirth Marker, Rebirth, RebirthMarker, RebirthReady, RebirthCooldown, RebirthAnimationPlay/Reset. Leurs chemins, source_id, taille, SHA/MD5 et release de membership sont dans `native_contract_review.json.native_memberships_reused`. La correspondance au manifeste lol_game_client0.0.1.7 ne prouve ni priorité VFS effective ni admission historique dans tous les modes.

Source propriétaire principale : **OLS-621265ef-9b55-5c59-a12f-80dcec45ce41**, `DATA/Characters/Anivia/Anivia.inibin`,2531octets, SHA-256 **7ed25b17573de7f30dd5621fc67a0173a0f046ee6b3fa9876c8eb9e60d6bd4cb**. AniviaEgg.inibin est distinct,1507octets, SHA-256 `c75a3b4b8a557ac999f2aea5cda1f93f4f0a285328243ffb8ff7e3918428bfb2`.

Le sous-contrôle documentaire est13/13 : il établit l’équivalence de ces preuves et leurs limites ; il ne réexécute aucun décodeur. Les notes initiales de cette partie indiquaient encore « code courant en attente » ; la présente intégration et `result.json` remplacent cette attente par la relecture courante décrite ci-dessous, sans réécrire la preuve intermédiaire.

## 3. Contrat natif documenté, inconnues et provenance clarifiée

| Clause SOURCE | Documenté | Restant inconnu |
|---|---|---|
| Identité/version et déclarations | Sources4.20 fournies, membership et SHA reliés ; `Passive1LuaName=Rebirth Marker`, icône `Cryophoenix_Rebirth.dds` | Priorité effective des variantes et disponibilité historique par mode |
| Bindings/textes client | Quatre clés `game_buff_tooltip_Rebirth_Marker`, `…Rebirth`, `…RebirthCooldown`, `…RebirthReady`, sans réécriture automatique d’alias ; description de champion liée | Ordre moteur d’alias/buffs, callbacks serveur |
| Déclencheur et valeurs | Infobulle2516 : dégâts fatals → œuf, pleinPV et `@f1@` armure/MR ; survie6secondes → renaissance ; recharge4minutes | Fournisseur/valeur f1, ordre exact, disponibilité initiale, durée/bornes/arrondi/recharge réellement exécutés, cibles et exceptions |
| Niveaux et autres champs | Champs absents conservés absents ; AniviaEgg déclare séparément1/4/7 | Aucun transfert de ces niveaux en rangs du passif Anivia ni valeur par défaut inventée |
| Lua client/préchargements | Sept chunks entièrement lus par V558, sans prototype de callback enfant ; littéraux conservés | Leur lecture ne constitue ni VM exécutée, ni serveur original, ni rendu/audio/skin qualifiés |

`Rebirth.luaobj` conserve **NEWTABLE pc16**, limite du lecteur de littéraux, pas une corruption du fichier. `RebirthReady` conserve **OnPreDamagePriority8** littérale, pas une exécution de callback. PersistsThroughDeath, NonDispellable, BuffName et noms de preloads ne qualifient pas la politique serveur. Les6s/4min sont des énoncés textuels client, pas des chronométrages natifs réalisés.

**Une ambiguïté de provenance est clarifiée sans changer de données.** `champion_resources.json#/anivia` porte `resource=DATA/Characters/Anivia/Anivia.inibin` et `source_sha256=086d1c1f813151f0123f3b3a8cc86c12c15022d5392f55375084736f4ceb8723`. Le second digest est exactement celui de **OLS-f3ac7341-02b5-52fe-9d1d-89735b3b3e1d**,7556octets, `D:\LeagueOfLegendsV2\4.20\GameServer\Content\LeagueSandbox-Default\Stats\Anivia\Anivia.json`, type `community_native_data_mirror`. Le registre repris dans V1182 le relie explicitement à OLS-621265ef-… et à `original_native_sha256=7ed25b17…`.

La référence communautaire est le snapshot modifié LeagueSandbox-Default, baseHEAD `a81a28558ea0aa4c543ae819f7ad3c4911a8bfe8`, contenu exact086d… ; l’identité du blob HEAD n’est pas supposée. La paire chemin logique natif/digest du miroir JSON existait déjà dans V558 et est inchangée. **Deux types d’octets distincts sont identifiés ; aucune corruption ou source manquante n’est démontrée.** La génération exacte du JSON local n’a pas été établie par les deux outils aux noms pertinents lus (`port_native_resource_snapshot.py`, `verify_resources.py`), jamais exécutés. Cela n’annule pas le référent désormais connu du digest ; ne pas répéter sa recherche.

Quatre lecteurs Rust directs de `champion_resources.json` ont été examinés : lifecycle.rs18/26/45 et native_hud_bars.rs10. Ils consomment **type**, pas `resource` ni `source_sha256`. Ces deux champs sont des métadonnées de provenance dans les sites inspectés ; aucune panne gameplay n’est établie par leur différence. Une éventuelle clarification future de libellé doit conserver séparément source physique du miroir et origine native, sans remplacer l’un des SHA par l’autre par supposition.

## 4. Consommateurs courants, portée et exceptions réellement lues

La relecture actuelle vérifie **21fichiers sélectionnés inchangés depuis V558** (14Rust,5JSON effectivement consommés,2lecteurs Python), **20ancres historiques** et **6ancres SOURCE** conformes. Les fichiers et leurs fenêtres exactes sont dans `current_consumer_review.json`. Le complément provenance identifie séparément le fichier HUD et les deux outils nommés ; leurs pins sont aussi conservés. Leurs scripts mutateurs ne sont pas exécutés.

Les six CID SOURCE sont le catalogue `champion_catalog` et cinq fonctions de hash/lecture/décodage INIBIN ou inspection/littéraux Lua. Leurs scopes distinguent l’audit de source d’une implémentation gameplay ; un marquage `provides_feature_consumer=true` de lecteur ne prouve pas Rebirth.

Le chemin nominal lu est :

1. `lib.rs136–153` charge les statistiques de base ; `join`533–597 crée le champion ordinaire et `respawn_at=None`, sans initialisation Rebirth qualifiée dans son corps.
2. Commande Attack → libération de frappe (`attacks.rs157–249`) → `basic_attack_hit` (`lifesteal.rs4–27`) → `apply_damage` (`damage.rs53–151`) : défenses/boucliers, puis vie diminuée jusqu’à zéro.
3. À zéroPV, ce corps efface l’état de combat transitoire et programme `respawn_at=tick+base_death_ticks(level)`. Les appels lus d’absorption de bouclier, présentation, crédit de kill et soin Trundle n’interceptent pas ce décès pour produire un œuf Anivia.
4. `advance` appelle `advance_respawns` avant les attaques du tick. `lifecycle.rs33–90` attend zéroPV et l’échéance, prend le spawn d’équipe, place le champion puis restaure vie/ressource à la fontaine. La règle locale niveau1 est16secondes/480ticks à30Hz. **Ce délai de retour ordinaire n’est pas la survie d’œuf de6secondes.**
5. Les commandes d’un mort sont refusées avant dispatch ; la régénération exclut les joueurs à zéroPV. Les trajets Learn/Cast/CastAt nommés conservent leur refus d’implémentation Anivia ; un refus de sort n’est pas une activation passive.

Une recherche négative bornée, exécutée une fois dans `crates/core/src`, `crates/client/src`, `crates/server/src`, recense1149fichiersRust et cherche Anivia/AniviaEgg/Rebirth/Cryophoenix. Un seul hit : test de refus d’un lobby plein dans `attack_presentation_server_tests.rs:569`. Ce test ne produit pas Rebirth. La conclusion repose aussi sur les corps et l’ordre d’appels ci-dessus, pas uniquement sur les symboles ou la liste CID. **Aucun producteur/intercepteur Rebirth n’est qualifié dans ces trajets inspectés** ; des alias ou du code hors de ces racines ne sont pas globalement exclus. Aucune absence visuelle globale ou d’asset n’est conclue.

## 5. Attendu, observé, vérifications exécutées et non exécutées

| Contrôle de ce lot | Attendu | Observé |
|---|---|---|
| Contrat courant/prérequis | Bonne tâche/OLF, critères comparés, dépendances non promues | Huit champs stables ; SOURCE et IDENTITE ouvertes ; six références de packages conservées sans satisfaction affirmée |
| Réemploi des sources | Identités natives datées reliées aux preuves existantes |18/18V558→V1182 conformes ; zéro nouveau hash/décodage natif |
| Consommateurs actuels | Lecteurs et corps de gameplay réellement inspectés |21/21pinsV558 inchangés,20/20+6/6ancres ; chemin ordinaire distinct de Rebirth |
| Cas nominal textuel | Décrire ce que la source annonce, sans inventer f1 | Œuf/pleinPV/f1/6s/4min identifiés dans les textes ; fournisseur et politiques serveur inconnus |
| Limites/refus | Distinguer ancien diagnostic, refus actuels lus et règle historique | Mort/respawn/refus ordinaires lus statiquement ; aucune activation passive ou nouvelle exécution présentée |
| Provenance086d | Identifier le référent exact ou garder le manque ouvert | Miroir JSON communautaire identifié, origine native7ed… distincte ; pas de corruption inférée |
| Intégration documentaire | Partie source, contrat courant et code cohérents |**14/14cohérences**, `PASS_STATIC_SOURCE_CONSUMER_AUDIT`, code0 |

Commandes exécutées dans cette préparation : `review_native_contract.py`, extraction bornée `extract_current_task_contract.py`, collecte initiale `review_current_consumers.py`, puis `integrate_anivia_review.py`, via le Python existant `F:\OpenLeague\.ai-tools\.venv\Scripts\python.exe -B`. Le complément provenance/HUD a été effectué par des lectures et recherches ciblées après la collecte initiale ; leurs observations et pins sont consignés séparément dans `current_consumer_review.json` et ses notes. Relancer seulement `review_current_consumers.py` ne reproduirait donc pas tout le reçu final enrichi ; aucune telle relance n’est nécessaire. Les détails et contrôles exacts sont dans leurs reçus E. L’intégration ne relit que les petites preuves ; aucun nouveau chargement des gros registres n’y est exécuté.

Le diagnostic V558 reste **daté** : Anivia meurt1321, reste morte1501 et revient fontaine1801 ; contrôle Ahri distinct. **960ticks et32refus anciens sont réutilisés, pas rejoués.** Le résultat ancien n’établissait déjà ni œuf ni Rebirth ; l’égalité actuelle des sources ne démontre pas la provenance de compilation de l’ancien binaire et ne le transforme pas en runtime actuel.

Non exécutés : jeu actuel/historique, serveur Riot, VM Lua, ancien probe/validateur, test/compilationRust, GUI/GPU/rendu/audio/réseau, REA, installation ou migration. Aucun nouveau cas de refus en partie n’a été exécuté. Les assertions de cohérence sont des contrôles documentaires, pas des tests du passif. Aucune acceptation humaine fournie.

## 6. Corrections proposées avec les IDs existants et reprise précise

| Tâche existante conservée | Critère précis à reprendre, sans inscription/modification par ce lot |
|---|---|
| **CH-Anivia-PASSIF-SOURCE** | Garder connus/inconnus séparés avec SHA et versions ; identifier les textes6s/4min comme déclarations client et f1 comme placeholder non résolu ; conserver source physique miroir086d et origine native7ed distinctes ; décider l’admission historique sur preuve. Une lecture bornée du code sans producteur qualifié ne satisfait pas les valeurs/exceptions complètes de cette fiche. |
| **CH-Anivia-PASSIF-SIMULATION-CONTRAT** | Obtenir un contrat primaire attribuable pour déclencheur létal, état œuf, pleinPV, fournisseur f1/niveaux, ordre et bornes6s, recharge4min/disponibilité initiale, cibles/structures/effets létaux/mort/respawn, arrondis et interruption/destruction de l’œuf. Identifier ce qui serait reconstruction locale. Ne pas utiliser16s/480ticks locaux comme substitut. |
| **CH-Anivia-PASSIF-SIMULATION** | Après contrat qualifié et prérequis appropriés, relier le producteur réel au bon consommateur. Vérifier nominal létal→œuf→survie→renaissance sur place ; limites œuf détruit, passif indisponible, frontière du timer/recharge, ordre dégâts/boucliers/mort et entrée invalide. Rapporter attendu/observé, binaires/ressources et refus sans mutation ; aucun témoin injecté ou retour fontaine ne vaut activation native. |

Ces critères précisent les rôles existants ; **aucun nouvel ID, champ de registre ou dépendance n’est créé**. Inconnue OLU-171a… ouverte. Entrées pour la reprise mécanique : source serveur originale, trace native reproductible/attribuable ou nouvelle implémentation/source primaire qualifiant f1 et la politique temporelle. Reprise de l’identité physique seulement sur dérive concrète ; reprise de l’historique du producteur `champion_resources.json` seulement si sa génération devient nécessaire, avec producteur versionné/reçu. Le référent086d est désormais identifié : ne pas le rechercher de nouveau.

L’absence de ces entrées ne justifie pas une enquête identique en boucle. Le prochain préflight documentaire peut examiner **Ashe SOURCE**, candidat V1182, en réutilisant V537 et en gardant le HUD clos adjacent distinct ; ce lot ne déclenche pas cette enquête. Les autres candidats et le goal global restent ouverts.

## 7. Livraison, clôture de l’audit et conservation

Le reçu `result.json` rassemble les trois parties : contrat natif documentaire13/13, contrat courant/hierarchie et revue code. Il épingle leurs fichiers, les petites preuves réutilisées, les entrées de registre et les scripts. La clôture porte seulement sur **AUD-SYS-01.2-02-ANIVIA-PASSIF-SOURCE-CONSUMER-01** et ses sept rubriques : périmètre/fin, sources, consommateurs, attendu/observé, contrôles exécutés/non exécutés, écarts/reprise/correction, preuves et décision. Relecture indépendante/publication à tracer séparément ; aucune acceptation de fonctionnalité n’en découle.

Livrables préparés exclusivement dans `E:\mapslol3v3\audit_sys01202_anivia_passive_source_20261103` : notes et reçus natifs, contrat courant extrait, revue code/log de recherche, `integrate_anivia_review.py`, `result.json`, ce rapport et publisher documentaire gardé. Le publisher est **non exécuté à la préparation** ; cible prévue `F:\OpenLeague\docs\AUDIT_SYS01202_ANIVIA_PASSIF_SOURCE_CONSUMER_2026-11-03.md` et append V1183 dans CURRENT/HANDOFF seulement.

Les cinq JSON protégés, **completion_tasks_2026-10-20.json** et **execution_plan_A_Z.json** sont épinglés et contrôlés avant/après publication, ainsi que les petites preuves d’entrée et les pins du complément provenance. Aucun des18natifs n’est rehashé par le publisher. Aucun code/asset produit, Goal, Plan, UI, application ou base modifié. La matrice V1182 reste une preuve historique inchangée ; seule la note de reprise constate que sa candidature Anivia a désormais cette relecture bornée. **La fiche SOURCE, sa trace, son inconnue, SYS-01.2-02 et le jeu restent ouverts.**
