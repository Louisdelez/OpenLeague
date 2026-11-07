# SYS-01.2-02 — Ashe : sources Focus et consommateurs critiques actuels

**V1184 — AUD-SYS-01.2-02-ASHE-PASSIF-SOURCE-CONSUMER-01.** Audit documentaire/statique borné terminé : déclarations et textes identifiés, rôles des preuves antérieures distingués, chaîne critique réelle relue et producteur Focus non qualifié dans les corps inspectés. **CH-Ashe-PASSIF-SOURCE reste `a_qualifier`, sa trace `partial_with_open_questions`, son inconnue ouverte.** Compte : un nouvel audit borné clos, zéro tâche, inconnue ou fonctionnalité close.

## 1. Question, contrat courant, prérequis et critère de fin

Cible : `CH-Ashe-PASSIF-SOURCE`, **OLF-6de8fca6-0d5c-562c-9ff8-1bea0b8daca8** ; inconnue **OLU-b31a9a69-0c7d-527e-9685-415f3d9cfc46**. Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement non établis. Le catalogue officiel 4.20.1 est une comparaison distincte.

Le contrat SOURCE courant demande de qualifier règles4.20, valeurs de tous les rangs, coûts, délais, cibles et exceptions. Critère exact : **« Fiche 4.20 datée avec source et SHA ; valeurs et exceptions connues séparées des inconnues ; disponibilité historique décidée sur preuve. »** La tâche requise reste sans implémentation ni acceptation complètes et dépend de `CH-Ashe-IDENTITE`, `a_qualifier`, non acceptée. Son contrat courant est extrait dans `current_task_contract.json` ; **aucune comparaison historique SOURCE avec V537 n’est affirmée**, car V537 ciblait d’autres rôles.

La phase D06 et le lot D06-CH-Ashe ont `depends_on:[]` ; le lot est `a_faire` et cite D04-SYS-04-1, D04-SYS-04-6, D05-SYS-05-2, D05-SYS-05-4, D14-SYS-14-2, D20-SYS-20-1 dans `requires_packages`. Aucune satisfaction ni consommateur de ces six packages n’est qualifié ici. Les tâches SYS-01.1-01..07 extraites restent `a_valider`, avec acceptationfalse. Ces prérequis ouverts sont conservés ; cette identification documentaire ne vaut pas sortie de phase/intégration acceptée.

Fin de **cet audit** : rattacher les sources et textes aux bons rôles, examiner les consommateurs nommés et leurs limites, puis fournir clauses démontrées/inconnues et correction précise sans modifier le registre. Ce résultat est vérifié par **14/14 cohérences d’intégration**, `PASS_STATIC_SOURCE_CONSUMER_AUDIT`, code0. La demande fonctionnelle complète de SOURCE n’est pas satisfaite par ces seuls constats ; aucun pourcentage de jeu terminé n’en découle.

## 2. Preuves et identités réutilisées sans nouveau corpus

| Preuve | Portée conservée |
|---|---|
| `docs/FIDELITY_ASHE_TRYNDAMERE_PASSIVE_BOUNDARY_LINKS_V537.md` et `docs/reference_requirement_trace_sources/ashe-tryndamere-passive-boundary-links-v537.json` | V537 du25/10/2026 ; reçu370589octets, SHA `134107704ce06d179a91ace60f29ad192ee2bf3479e1fe9a2a3ca45285004432`. Pour Ashe : **SIMULATION-CONTRAT / OLF-c34d31b6-7d27-5abe-bb41-49c0d98edec2** et **SIMULATION / OLF-cad4f2d7-93ae-559f-b955-73ce3916aea7**, pas SOURCE. |
| `docs/fidelity_ashe_tryndamere_passive_boundary_links_v537.json` | `passed:true`, mais Focus100, acceptation des passifs et clôture de tâchefalse. Les constats/valeurs/questions Tryndamere sont exclus de cette décision Ashe. |
| `revision537_passive_inspection/OBSERVATIONS.json`, chemin F-work exact dans le reçu V537 |352061octets, SHA `ca74852bdc46ab1b530bfa2c5e3cb044c4ea6adbe6a5e35c6e749b8576333476`. Preuve d’inspection datée, directement épinglée par V537 ; script non importé/exécuté. |
| `docs/AUDIT_SYS01202_ASHE_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md` et reçu E `audit_sys01202_ashe_passive_hud_20261103/result.json` | **V1174 HUD72/72**, liaison statique adjacente des icônes/textes/états ; ni SOURCE ni mécanique Focus complètes. Aucun validateur, décodage, rendu ou recherche HUD rejoué. |
| V1182 `trace_excerpt.json` et `reuse_matrix.json` | SOURCE/OLF/inconnue et identités déjà contrôlées ; matrice historique inchangée. L’extrait initial313identités inclut natifs, références et code ; aucun rehash de ces313fichiers ici. |

La trace SOURCE comporte **six relations natives mais quatre source_id/chemins distincts** : Ashe.inibin (**OLS-9dc52591-407d-5b70-95a6-73ee4a537600**), CharScriptAshe.luaobj (**OLS-fa571342-97c8-5f7a-9cfd-853d06a3efab**), Focus.inibin (**OLS-ef8536c5-6873-5acc-8e90-a4505fa0b9ae**), Focus.luaobj (**OLS-b9ac154f-0616-56f8-b5d2-30aff0260df2**). Les quatre identités sont réutilisées depuis V1182 ; les relations doublées ne créent pas de fichiers supplémentaires.

Le HUD V1174 fournit neuf identités natives et le font anglais, dont trois fichiers recoupent les quatre SOURCE. Les neuf couvrent Ashe.inibin, Focus/AsheCritChance/AsheCritChanceReady LuaObj et INIBIN, et deux DDS normal/gris. Leurs tailles, SHA/MD5, IDs et releases membres sont conservés dans `native_contract_review.json` ; **aucun natif n’est rehashé ou redécodé dans V1184**. L’identité principale Ashe.inibin est2718octets, SHA `de1706b681114ae95c164ce6f97f40cf84d5faa57682acc4327c372f2ac602f2`. Le manifeste agrégé lol_game_client0.0.1.7 et les releases individuelles ne déterminent pas la priorité VFS ou la sélection runtime.

L’extraction des contrats courants est préparée une seule fois dans `audit_sys01202_passive_contracts_20261103/passive_task_contract_snapshot_122.json` :122fiches SOURCE et1350contrats sélectionnés,1657555octets, SHA `6567a15ae5ed0b7bad77c594afdd216d523a07e32f1999a684b625b7cfcc84c0`. Il s’agit d’un **cache de préparation**, pas de122audits ou fonctionnalités closes. Champs exclus, deux entrées brutes et script extracteur sont épinglés. En cas de dérive, refuser le réemploi et produire un nouveau snapshot versionné ; ne pas relancer l’extracteur dans ce dossier de preuve immuable.

## 3. Clauses SOURCE documentées et inconnues

| Clause | Documenté | Limite ouverte |
|---|---|---|
| Déclarations natives | `Passive1LuaName=Focus`, icône `Ashe_Passive.dds`. Focus Lua déclare BuffName, texture, PersistsThroughDeath, NonDispellable. | Littéraux client, pas corps serveur ou politique de priorité/alias exécutée. |
| Texte Focus lié1917 | Aucune attaque pendant3s, puis `@f1@` charges par seconde ; à100charges, prochaine attaque critique ; charges initiales égales à la chance critique. | Fournisseur/taux numérique f1, unité fraction/pourcentage→charges, événements et bornes précis non qualifiés. |
| Autres formulations | Description localisée/cataloque4.20.1 : charges hors combat et seuil100. Ancien `Data.Passive1Desc` : chance critique qui augmente toutes les3s et dure une attaque. | Aucune substitution silencieuse entre « hors combat », « aucune attaque » et l’ancien texte ; aucune corruption inférée. |
| Focus/CritChance/Ready | Focus→icône normale ; AsheCritChance→grise/tooltip1692 ; Ready→normale/tooltip1693 et nom `Ashe_Base_P_buf_geo.troy`. | Références statiques HUD ; ne prouvent ni transition du compteur, priorité de montage, rendu de l’effet ou critique forcé. |
| Valeurs/rangs/cibles/exceptions/disponibilité | Sources et chaînes versionnées conservées distinctes. | Règle historique complète, initialisation/consommation/reset, rang éventuel, modes et exceptions restent à qualifier. |

Le texte natif et l’ancienne description sont copiés intégralement dans le sous-reçu avec leurs clés/lignes ; les valeurs non résolues restent inconnues. Les deux chunks Ashe examinés par V537 (Focus et CharScript) étaient intégralement lus et sans prototype de callback enfant. Les chaînes CritChance/Ready citées sont les contrôles statiques de littéraux du HUD ; aucune nouvelle inspection complète de leur corps serveur n’est prétendue. Persistance, icône ou effet nommé n’équivalent pas à un comportement joué.

La provenance de `champion_resources.json#/ashe/source_sha256=b3f467950670e62f0962be7dc328e08cffb391f2272ffa9e5f5c68909303ec18` était déjà résolue par V537 : **JSON Stats décodé** exporté,6630octets, distinct de l’INIBIN natif `de1706b68…`. Le chemin exact exporté et l’origine native sont conservés dans les reçus. Aucun nouveau manque de hash, corruption, compteur Focus ou enquête de producteur n’est créé à partir de cette différence.

## 4. Consommateurs actuels réellement inspectés

**10/10 ancres V537 et6/6 ancres SOURCE conformes ;14/14 fichiers nécessaires inchangés depuis V537**, avec pins stables durant la lecture. Onze sont aussi comparés aux pins V1183 et deux fichiers Rust aux pins du HUD ; ces intersections ne sont pas additionnées en nouveaux contrôles distincts. Les six CID SOURCE sont catalogue et lecteurs INIBIN/Lua ; leur `provides_feature_consumer=true` éventuel qualifie leur scope d’inspection SOURCE, pas Focus exécuté.

Chaîne lue avec fenêtres et empreintes dans `current_consumer_review.json` :

1. `lib.rs136–153` charge les statistiques typées ; `join533–597` crée un champion ordinaire, `attack_roll=None`, effets par défaut. Aucun compteur Focus n’y est initialisé.
2. `progression.rs92–98` calcule la chance critique depuis profil, croissance et objets, bornée0..1. Profil Ashe actuel : chance0, croissance0, multiplicateur2. La formule ne lit pas de charges Focus ni f1 ; son zéro générique ne suffit pas seul à conclure.
3. `critical.rs12–36` traite chance non finie/non positive→faux, chance≥1→vrai, intermédiaire→SplitMix64 reconstruit. **Une probabilité1 n’est pas100charges Focus**, et cet échantillonneur local ne prouve pas les séries critiques Riot.
4. `attacks.rs279–332` reprend `attack_roll` ou échantillonne la statistique critique, choisit un profil et stocke la décision dans Windup/cache. À la libération203–271, il efface le cache générique, lit `w.critical`, AD et multiplicateur. **Effacer attack_roll n’est pas un reset Focus qualifié.**
5. Ashe utilise le trajet à distance : profils normal/critique et missile2000. La libération crée un projectile ; son arrivée appelle `basic_attack_hit`, puis dégâts physiques. **Lancement et impact ne sont pas confondus** ; aucun gain/consommation Focus n’est identifié dans ces corps.
6. `Effects`/tick/mort ont les états, appels et effacements génériques présents, sans producteur temporel Focus qualifié. Les branches GarenQ/TrundleQ et états Ezreal demeurent propres à leurs champions ; aucun compteur Fury, scalaire mana ou travail Yasuo ne devient Focus.

Cas nominal statique borné : après une initialisation ordinaire, sans objet ni cache critique préalable, la première attaque utilise chance0 et profil normal. Aucun scénario n’a été exécuté pour cette déduction ; les autres inventaires, caches ou producteurs non inspectés ne sont pas remplacés par ce cas.

Une seule recherche exacte Focus/AsheCritChance/Ready est faite dans **huit fichiers nommés**, les corps déjà inspectés : code1, zéro hit, journal `focus_producer_named_body_search.txt`. Ce résultat attendu n’est pas une erreur ni un nouveau scan des1149fichiers HUD. La conclusion repose aussi sur les corps et l’ordre des appels : **aucun producteur f1/compteur/accumulation différée/garantie100/reset Focus n’est qualifié dans ce périmètre**. Alias, route indirecte et code hors périmètre restent possibles ; absence globale d’asset ou rendu non conclue.

## 5. Attendu, observé, contrôles et exécutions exclues

| Attendu de l’audit | Observé |
|---|---|
| Bon rôle SOURCE et état conservé | SOURCE/OLF/inconnue ouverts ; V537 SIM/CONTRAT et HUD V1174 adjacents distincts ; Tryndamere exclu |
| Sources/textes avec provenance et limites |15/15 contrôles documentaires ; six relations/quatre fichiers SOURCE, neuf HUD+font réemployés avec recoupement ; f1 non comblé |
| Consommateurs et mécanismes existants distingués |14pins,10+6ancres conformes ; chaîne chance→échantillonneur→cache→projectile→impact retrouvée ; garantie/reset Focus non qualifiés |
| Recherche ciblée proportionnée | Huit corps nommés, zéro hit, code1 attendu ; aucune recherche HUD ou corpus répétée |
| Intégration vérifiable |14/14 cohérences, `PASS_STATIC_SOURCE_CONSUMER_AUDIT`, code0 ; un audit borné, zéro tâche/inconnue/fonctionnalité close |

Exécutés : préparation partagée `extract_contracts.py` puis lecture de sa vue courante, `review_native_contract.py`, `review_current_consumers.py`, recherche nommée consignée et `integrate_ashe_review.py`, avec le Python existant `F:\OpenLeague\.ai-tools\.venv\Scripts\python.exe -B`. L’intégration lit seulement les petites preuves et le cache documentaire ; elle ne recharge pas les registres bruts ni les fichiers natifs. Les reçus E donnent les contrôles exacts et empreintes.

V537 reste daté : Ashe aux ticks0/90/900/5400 avec chance0, sans qualification f1 ou seuil100. **Ces observations ne sont pas relancées et ne prouvent ni absence de Focus ni test d’attaque garantie/reset.** Aucun résultat Tryndamere ne devient une observation Ashe. L’identité actuelle de fichiers ne prouve pas la provenance de compilation des vieux exécutables.

Non exécutés : jeu, client/serveur historique, ancien probe/validateur, décodage natif/VM Lua, test/compilationRust, GUI/GPU/rendu/audio/réseau, REA, installation ou migration. Aucun nouveau refus en partie ou test de mécanique n’est présenté ; les contrôles d’intégration sont des cohérences documentaires. Aucune acceptation humaine fournie.

## 6. Corrections avec les IDs existants et conditions de reprise

| Rôle conservé | Critère concret de reprise |
|---|---|
| **CH-Ashe-PASSIF-SOURCE** | Relier IDs/versions/SHA et textes distincts ; garder ancien rawDesc, en_GB et catalogue4.20.1 séparés ; expliciter f1/unités/priorités inconnus et décider la disponibilité historique sur preuve. Les six CID de lecteurs ne satisfont pas toutes valeurs/exceptions. |
| **CH-Ashe-PASSIF-SIMULATION-CONTRAT** | Obtenir une règle primaire attribuable pour3s, taux/fournisseur f1, unité initiale égale à chance critique, accumulation100, attaque éligible, consommation/reset, lancement/impact/annulation, cibles/dégâts/sorts/mort/reconnexion et priorité des états. Préciser les éventuelles reconstructions locales ; ne pas appeler le sampler≥1 ou le cache un contrat Focus. |
| **CH-Ashe-PASSIF-SIMULATION** | Après contrat qualifié, relier la vraie production autoritaire au consommateur ; vérifier accumulation→100→prochaine attaque critique→reset. Couvrir sous-seuil, frontière3s, cache préalable, annulation/échec/cible morte et refus sans mutation, avec attendu/observé et binaires/ressources. Une attente à chance0 ou un critique générique seul n’est pas la réussite de ce scénario. |

Aucun nouvel ID, registre, dépendance ou état modifié. Le HUD et son prérequis réseau restent dans leurs rôles propres. Entrées manquantes : source/callsite Focus attribuable ou observation primaire reproductible qualifiant f1 et transitions, admission historique, puis lot d’implémentation/vérification distinct. À défaut de piste nouvelle, ne pas répéter les hashes, scans ou attentes inchangés. Reprendre l’identité seulement sur dérive concrète.

Le prochain préflight proposé peut examiner **Azir SOURCE** depuis V1182/V559, en réutilisant ses preuves disponibles ; cela ne déclenche pas une nouvelle enquête dans V1184 ni une recherche f1 sans piste.

## 7. Livraison, clôture bornée et conservation

Livrables E `audit_sys01202_ashe_passive_source_20261103` : contrat courant, sous-reçus/notes natifs et code, recherche consignée, `integrate_ashe_review.py`, `result.json`, ce rapport et publisher documentaire gardé. Les sept rubriques sont satisfaites **pour l’audit borné** : question/fin, sources, consommateurs, attendu/observé, contrôles exécutés/non exécutés, écarts/reprise/correction et preuves/décision. Relecture indépendante/publication à tracer séparément ; SOURCE et inconnue restent ouvertes.

Cible prévue : `F:\OpenLeague\docs\AUDIT_SYS01202_ASHE_PASSIF_SOURCE_CONSUMER_2026-11-03.md` et append V1184 dans CURRENT/HANDOFF seulement. Le publisher est **non exécuté à la préparation** ; il épingle rapport/résultat/parties,14pins de code, petites preuves, snapshot partagé et extracteur. Cinq JSON protégés plus completion_tasks et execution_plan sont contrôlés avant/après ; natifs non rehashés. Les preuves et changements antérieurs restent conservés. La matrice V1182 demeure historique ; les notes indiquent seulement que sa candidature Ashe a désormais cette relecture bornée.

Reprise Git relevée par root dans `E:\mapslol3v3\resume_sys01202_20261103_v1183.txt` : branche main, HEAD8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, modifications locales antérieures conservées ; aucun changement Git réalisé par ce lot. Aucun code/asset produit, Goal, Plan, UI, application ou base modifié. **Un audit SOURCE→consommateur clos, zéro tâche/unknown/feature close ; SYS-01.2-02 et le jeu restent ouverts.**
