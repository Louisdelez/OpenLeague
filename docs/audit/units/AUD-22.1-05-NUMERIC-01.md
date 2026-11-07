# AUD-22.1-05-NUMERIC-01 — Formats des dix-huit textes HUD sélectionnés

Contrôle du 30 octobre 2026 ; reçu produit à 12:27:35 UTC. Parent SYS-22.1-05 « Qualifier pluriels et formats de nombres et durées » ; liens de layouts connexes à SYS-22.1-04. Résultat documentaire de SYS-01.2-02, sans modification du Goal, du jeu, du suivi ou de ses bases.

## 1. Périmètre, critères de fin et décision

Question : pour les dix-huit Text sélectionnés par native_hud_widgets, quelle est la source du widget, quelle règle produit sa valeur, quelles gardes sont appliquées et quelles équivalences de format restent non qualifiées ?

Critères de sortie : les dix-huit enregistrements individuellement reliés aux octets de leurs dix layouts ; aucune règle actuelle sans autorité classée comme contrat local, calcul natif hérité ou raccourci récupéré ; limites des preuves anciennes vérifiées ; corrections et conditions de reprise explicites. La portée comprend douze champs numériques/temporels et six libellés de raccourcis. Elle exclut les autres routes de texte, les pluriels, tooltips, ressources secondaires, et la fidélité de tous les producteurs serveur.

**Audit terminé pour ces dix-huit enregistrements et leurs règles actuelles.** SYS-22.1-05 et SYS-22.1-04 restent ouvertes pour leurs autres clauses. Les douze nombres et six raccourcis ne sont pas dix-huit traductions entièrement réalisées.

| Dimension | État distinct |
|---|---|
| Audit | Terminé pour le périmètre identifié, ses sources et ses frontières de formatage |
| Implémentation | Dix-huit widgets raccordés à leurs consommateurs actuels ; formats locaux et natifs partiels, sans équivalence complète selon la locale |
| Vérification | Comparaisons de sources et données exécutées ; tests ciblés hérités et identités vérifiées ; intégration actuelle, pixels et horloges non requalifiés |
| Acceptation humaine | Non demandée |

Condition d'arrêt du lot atteinte : les dix-huit définitions ont une attribution précise. Pas de réanalyse native des mêmes fragments ni de relance inchangée des tests ; une nouvelle trace de formatage ou une modification concrète justifiera la suite.

## 2. Sources, provenance et preuves réutilisées

L'inventaire `F:/OpenLeague-work/audit-units/AUD-22.1-04-HUD-01/hud-inventory.json` conserve leurs IDs HUD, chemins, offsets, noms et empreintes. Son identité et celles des 498 sources Rust du corpus ont été revérifiées : aucune évolution depuis HUD-01.

Deux archives HUD.zip, celle fournie dans le deploy 0.0.1.68 du client original sur D et celle consommée sous `F:/OpenLeague/data/4.20/archives/menu`, ont le même SHA256 `76e36f2718928be65be7dc792c2d27b43091cc7bb7d44b6d7fef629500eee61c`. Leurs dix membres uniques correspondant aux dix-huit Text sont identiques aux entrées de `data/4.20/native_hud_source_records_contract.json`. Chaque membre des deux archives est détaillé dans numeric-hud-proof.json. L'égalité des archives ne qualifie toujours pas leur release historique ni leur priorité de montage dans les manifestes RADS.

Sources natives de comportement héritées, toutes du 6 octobre 2026 :

| Source | Contenu qualifié et limite conservée |
|---|---|
| data/4.20/native_hud_cooldown_text_contract.json | 84 cas, six modes (0,1,2,3,4,-1), quatorze entrées chacun, fonction 0x7d7940. Branches, ceil et arguments natifs examinés ; lookup de réglage adapté et sortie printf C9811C remplacée par du formatage Python. Les octets CRT/localisés exacts ne sont pas qualifiés |
| data/4.20/native_hud_pool_ratios_contract.json | 100 conversions et dix ratios. Tranches 0x7d6ec4..0x7d6f79, 0x7d7572..0x7d759b et 0x7d736d..0x7d7397 ; valeurs/champs d'acteur fournis. Accesseurs, drapeaux de mort, enum native, capacités nulles et ressources spéciales restent hors qualification |
| data/4.20/native_hud_hotkeys_contract.json | Onze cas de libellé court, tranches 0x83df6f..0x83e1d4 ; helpers de chaînes adaptés. Remappage historique, libellés longs et clavier/locale non qualifiés |
| data/4.20/native_summoner_hud.json | Liens exacts des deux layouts d'invocateur et bindings [d]/[f] ; le réglage de gameplay des cinq sorts locaux n'est pas établi par ces icônes/layouts |

Le binaire natif correspondant aux trois captures est identifié et rehashé : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe`, SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Il n'est pas exécuté dans ce lot.

Les deux fichiers Input.ini désignés par le contrat de touches sont rehashés. Les six bindings par défaut sont aussi relus directement dans leur section GameEvents : [q], [w], [e], [r], [d], [f]. L'égalité de ces valeurs ne qualifie pas le chargement/merge du client historique.

## 3. Consommateurs et règles actuels

`native_hud_widgets.rs:66-76` choisit exactement les dix-huit Text et conserve leur ordre global de police. Le plugin est enregistré dans main.rs. `snapshot_values_with_mode`, lignes 83-96, produit les valeurs à partir du snapshot du joueur identifié ; `update`, lignes 99-127, les copie dans les widgets et prépare les glyphes. Les positions/couleurs/polices source sont séparées de la provenance du contenu.

| Enregistrements individuels couverts | Source de layout sous HUD/Elements | Consommateur et règle actuelle |
|---|---|---|
| HPStat | CenterHUD_HealthBar.ini | native_hud_pool_numbers : ceil des PV courants et maximum, jointure ASCII « / » entourée d'espaces |
| MPStat | CenterHUD_PARBar.ini | Même helper en floor, uniquement pour le type natif Mana ; capacité autorisée obligatoire |
| GoldStat | ShadowIslesChampionLeft.ini | Valeur finie, positive ou nulle, dans u32 ; floor, puis chiffres décimaux sans groupement explicite |
| LevelStat | ShadowIslesChampionLeft.ini | player.level.to_string() ; pas de contrôle supplémentaire du domaine de niveau dans cette fonction d'affichage |
| GameTime | ShadowIslesTitanBar.ini | tick/TICK_RATE, puis minutes:secondes à deux chiffres ; TICK_RATE vaut 30 ; pas de bascule vers un format heures dans ce code |
| RespawnTimer | ShadowIslesChampionLeft.ini | native_hud_respawn::countdown : ceil entier des ticks restants ; politique locale, pas format natif récupéré |
| SpellCooldown0,1,2,3 | CenterHUD_AbilitiesSpell0,1,2,3.ini respectivement | Échéance de chaque slot moins tick avec saturation à zéro ; conversion f32 ; native_hud_cooldown_text::format |
| SummonerSpellCooldown0,1 | CenterHUD_AbilitiesSpellSummoner0,1.ini respectivement | Même formatteur, pour les slots équipés, avec summoners.ready_at |
| SpellHotKey0,1,2,3 | CenterHUD_AbilitiesSpell0,1,2,3.ini respectivement | spell_input::hud_labels ; libellés courts des bindings récupérés q,w,e,r ; mêmes touches physiques fixes utilisées par le consommateur local |
| SummonerSpellHotKey0,1 | CenterHUD_AbilitiesSpellSummoner0,1.ini respectivement | native_hud_summoners::labels puis spell_input::short_label ; bindings récupérés d,f |

Les dix-huit lignes détaillées du JSON conservent les propriétés source, flags initiaux, classe d'autorité et limite par widget. Les recharges et RespawnTimer commencent désactivés dans la source ; le code active seulement leurs copies lorsque leur valeur existe. La définition d'un Text n'est pas en elle-même un label traduit.

### Règles et refus observés dans le code

- PV : ceil ; mana : floor ; entrée non finie, négative ou hors entier signé32 refusée. Le calcul des barres refuse une capacité arrondie nulle et la capacité Mana absente. Une erreur remonte à snapshot_values puis efface le jeu de glyphes ; elle n'est pas transformée en zéro inventé. Les barres bornent les fractions excessives à 1, alors que le texte garde les valeurs arrondies : c'est une limite locale explicite pour snapshots au-dessus du maximum, pas une équivalence native universelle.
- Recharge : entrée finie, positive ou nulle dans l'intervalle signé32. Zéro et mode0 masquent. En dessous de 0,7f32 : une décimale. Sinon : ceil entier ; à partir de 60 secondes brutes, mode2 donne minutes:secondes et mode3 donne minutes avec suffixe m. Les autres modes non nuls, dont 4 et -1, suivent les secondes entières ; ils ne sont pas des modes rejetés par ce code.
- Réapparition : gagnant présent, joueur absent/vivant, PV non finis ou échéance absente masquent le compteur. Une échéance atteinte peut afficher 0 tant que le snapshot décrit encore le joueur mort. Le mode de recharge0 ne supprime pas ce compteur. update retire spécifiquement RespawnTimer si la connexion n'est pas prête ou la session ne correspond pas. Cela ne prouve pas une politique générale de fraîcheur pour tous les autres widgets.
- Rendu : plus de 255 octets, contenu non ASCII ou erreur de copie sont refusés. Cette garde n'est pas une mesure du débordement en pixels. Les fonctions de formatage n'utilisent pas la locale ; cela ne prouve pas que chacun de leurs résultats diffère de la référence en_GB, ni qu'il faut ajouter arbitrairement des séparateurs de milliers.

## 4. Contrôles réellement exécutés et résultats

Commande exécutée, code 0 : `python -X utf8 -E -B F:/OpenLeague-work/audit-units/AUD-22.1-05-NUMERIC-01/audit_numeric_hud.py`.

| Contrôle actuel | Attendu / observé |
|---|---|
| Corpus et inventaire réutilisés | 498 sources inchangées, dix-huit IDs et noms uniques : conforme |
| Provenance des layouts | Dix membres uniques dans chacun des deux ZIP, soit vingt comparaisons exactes aux captures : conforme |
| Attribution des valeurs | Douze nombres/durées et six libellés ; chaque record possède sa règle et sa limite : conforme |
| Bindings | Quatre sorts et deux invocateurs conformes à Input.ini et au catalogue utilisé : conforme |
| Réutilisation des essais | Deux triplets module/contrat/log identiques aux empreintes des reçus : conforme |
| Refus de requalification générale | native_hud_widgets.rs, main.rs et le client graphique courant ont changé depuis ces deux reçus : constat conservé, pas de validation actuelle de tout le HUD |
| Conservation | Dix-neuf fichiers logiciels gelés identiques à WITHDRAWAL_INVENTORY.json ; aucune base ouverte |
| Relecture indépendante | Dix-huit IDs attendus, vingt liens de membres, cardinalités, héritage et limites cohérents : PASS |

Résultats hérités réutilisés, avec leur date et leur portée :

- Le reçu `docs/native_hud_cooldown_text_progress.json`, daté du 6 octobre à 10:29:52 UTC, et `logs/native-hud-cooldown-client-tests.log` conservent le test nommé all84_original_formatter_branch_and_argument_cases_match passé. Le log indique 345 tests passés, zéro échec à cette date. Le module formatteur et son contrat sont toujours identiques ; ce total n'est pas un résultat actuel des 345 tests.
- Le reçu `docs/native_hud_pool_ratios_progress.json`, daté du 6 octobre à 09:09:23 UTC, et `logs/native-hud-pool-ratios-client-tests-utf8.log` conservent mana_integer_and_pool_fraction_match_executed_native_cases passé. Le log indique 338 tests passés, zéro échec à cette date. Le module et son contrat sont identiques. Son test Rust vérifie les 50 conversions de type correspondant et les dix ratios ; il ne prétend pas implémenter les 50 conversions de type différent présentes dans la capture native.

Exemples de frontières déjà présents dans les 84 cas, sans nouvelle exécution : 0,6999989748 en mode1 donne 0.7 ; la représentation f32 du seuil 0,7 donne 1. En mode2, 59,9990005493 donne 60 et 60,0 donne 1:00 ; en mode3, 60,0099983215 donne 1m. Les textes capturés proviennent du printf adapté : l'accord avec ces textes n'est pas une preuve des octets du CRT natif ou de la ponctuation par locale.

Aucun nouveau test Rust, jeu, réseau, GPU, REA ou code natif exécuté. Aucune capture ancienne présentée comme rendu actuel. Le Git courant contient 1943 entrées existantes, HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca ; aucun reset, checkout, staging ou changement de configuration Git. Une lecture Git limitée par le sandbox a été répétée hors sandbox en lecture seule et a réussi.

## 5. Manques et limites non convertis en réussites

L'origine des dix layouts est établie ; leurs formatteurs historiques complets ne le sont pas. Les contrats locaux de GoldStat, LevelStat, GameTime et RespawnTimer sont identifiés concrètement. Ils ne sont pas promus en implémentations du client historique.

La localisation des octets décimaux, les formats précis du CRT, les accesseurs de pools, le contexte d'horloge native et son lissage restent ouverts. Les capacités nulles et ressources spéciales demeurent refusées ou hors du chemin Mana ; aucun calcul arbitraire ne les comble. La validation du rendu doit aussi couvrir les changements de longueur et la géométrie, indépendamment de la limite de transport ASCII.

Les pluriels, les formats des tooltips de boutique et les autres routes HUD n'appartiennent pas à ce lot. L'inconnue existante de SYS-22.1-05, `OLU-fa0fd363-6776-595f-90b8-98d2d896dd0d`, reste ouverte. Le branchement actuel de cette tâche dans le registre concerne le tooltip regen_5s ; le présent résultat documente les dix-huit champs supplémentaires sans modifier cette association dans le suivi.

Il n'y a pas d'entrée manquante empêchant de clore cet audit borné : les consommateurs actuels, les sources de layout, les autorités locales et les limites sont établis. Les entrées requises pour revendiquer une fidélité supplémentaire sont précisées ci-dessous.

## 6. Reprise par résultats précis sous les tâches existantes

Ces clauses sont documentaires. Aucun ajout de case, migration ou modification de registre ; aucune correction fonctionnelle réalisée implicitement.

| Clause / rattachement | Résultat et critère de fin | Condition de reprise |
|---|---|---|
| NUM-GOLD-FORMAT-01 / SYS-22.1-05 | Qualifier le consommateur historique de GoldStat et son format, puis comparer les valeurs de frontière au chemin local unsigned32. Fin : attendu/observé pour valeurs fractionnaires, fortes et refus ; origine du format identifiée | Nouvel appelant natif relié au widget ou trace de valeurs/format, au-delà du seul layout. Ne pas ajouter de groupement supposé |
| NUM-LEVEL-FORMAT-01 / SYS-22.1-05 | Qualifier séparément le format et le domaine autorisé de LevelStat, sans confondre règle de niveau serveur et affichage. Fin : source/contrat, zéro et bornes documentés | Consommateur historique ou contrat local nommé/versionné ; source du niveau autorisé |
| NUM-GAMETIME-FORMAT-01 / SYS-22.1-05 | Qualifier GameTime : origine du temps, arrêt/pause, minute et éventuel changement d'heure. Fin : format attendu/observé pour 59/60 secondes et longue partie, avec autorité de l'horloge | Nouvelle trace native ou décision locale explicite ; les ticks actuels ne démontrent pas l'horloge historique |
| NUM-RESPAWN-FORMAT-01 / SYS-22.1-05 | Qualifier le compteur de réapparition seul, sa frontière zéro et son format historique. Fin : cas vivant/mort/échéance/fin/session et comparaison documentée ; préserver l'indépendance du réglage des recharges | Format/appelant natif supplémentaire, ou contrat local accepté comme tel ; ne pas rouvrir la règle serveur de mort sans nouvel écart |
| NUM-COOLDOWN-PRINTF-01 / SYS-22.1-05 | Qualifier les octets réellement produits par le CRT pour les quatre formats observés et les locales concernées. Fin : sorties/arguments/locale et limites identifiés, avec seuil0,7 et minute60 ; comparaison au Rust actuel | Exécution du vrai formatteur/CRT avec contexte localisé établi ou nouvelle capture équivalente. Rejouer le même printf Python ne résout pas ce manque |
| NUM-POOL-FORMAT-01 / SYS-22.1-05 | Relier HPStat et MPStat aux accesseurs et formats textuels natifs, en conservant ceil/floor déjà qualifiés. Fin : correspondance texte/valeur et décision explicite sur capacité nulle, sans inventer zéro | Appelant natif précis ou contrat local de branche refusée ; les 110 cas arithmétiques ne suffisent pas pour les octets du texte |
| NUM-KEY-LABEL-01 / SYS-22.1-04, complément SYS-22.1-06 | Vérifier l'affichage des six bindings réellement actifs selon le clavier/remappage pris en charge. Fin : touche physique, commande et libellé cohérents ; libellé non pris en charge refusé explicitement | Producteur de remappage/locale identifié ou prise en charge locale autorisée. Préserver les six bindings par défaut acquis |
| NUM-CURRENT-RENDER-01 / SYS-22.1-05, complément SYS-22.1-06 | Qualifier l'intégration actuelle des dix-huit valeurs, leur visibilité et rendu, sans confondre les anciens totaux de tests avec le client courant. Fin : sources/binaires identifiés, cas nominal/refus et longueurs aux résolutions retenues, attendu/observé | Une modification ou une demande de vérification d'intégration distincte. Reprendre les tests ciblés utiles après changement ; ne pas requalifier tout le jeu sur ces widgets |

Les prochaines recherches natives portent sur un appelant ou une trace manquante précise. Sans nouvelle piste, conserver la limite de fidélité et passer à une autre unité du goal, plutôt que répéter la capture des mêmes branches arithmétiques.

## 7. Livraison et relecture

Fichiers créés :

- `F:/OpenLeague/docs/audit/units/AUD-22.1-05-NUMERIC-01.md`, ce résultat.
- `F:/OpenLeague-work/audit-units/AUD-22.1-05-NUMERIC-01/audit_numeric_hud.py`, 13003 octets, SHA256 `0aa291eb0939def43cdca0dc14b3c9d279b83bc75bda07593f3e22e4a68da208`.
- `F:/OpenLeague-work/audit-units/AUD-22.1-05-NUMERIC-01/numeric-hud-proof.json`, 69687 octets, SHA256 `771708a0c8fb9578d7719e279998d42b3a20fa76224f55adfe375d2fda9548b8`.

Le JSON identifie les deux ZIP et leurs vingt membres comparés, les dix-huit enregistrements avec propriétés et autorités, les ancres du code, les deux triplets de preuves héritées, les identités d'intégration divergentes, les frontières de recharge et les dix-neuf fichiers gelés. Les anciens rapports, scripts, captures et ressources restent conservés.

Les sept rubriques de clôture sont satisfaites dans cette portée. Aucun pourcentage global de jeu terminé, aucune acceptation humaine ni exécution récente inventée. Les parents restent ouverts. Aucun changement du Goal, de l'application de suivi, des bases, des registres du plan ou du code du jeu ; aucun logiciel installé, aucune migration, aucune tâche cochée.
