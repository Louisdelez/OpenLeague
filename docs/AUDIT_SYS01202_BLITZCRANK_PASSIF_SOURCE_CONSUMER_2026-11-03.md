# SYS-01.2-02 — Blitzcrank PASSIF-SOURCE : source et consommateur borné, V1186

3 novembre2026. Unité **AUD-SYS-01.2-02-BLITZCRANK-PASSIF-SOURCE-CONSUMER-01**. Reprise de `docs/audit/AUDIT_CHARTER.md` : l’audit, l’implémentation, la vérification et l’acceptation humaine sont indépendants. Périmètre documentaire seulement ; aucun changement produit, Goal, Plan, UI, application, base ou registre.

**Une unité d’audit statique bornée est terminée avec preuves. Zéro tâche SOURCE, inconnue ou fonctionnalité close.** `CH-Blitzcrank-PASSIF-SOURCE` reste `a_qualifier`, sa trace `partial_with_open_questions` et son inconnue ouverte. Le texte client identifie20%PV/50%mana courant/10s/90s ; le chemin actuel de dégâts et de boucliers génériques ne fournit aucun producteur ManaBarrier qualifié dans les corps inspectés. Cette conclusion ne constate aucune absence globale.

## 1. Exigence précise et frontières

La cible est `CH-Blitzcrank-PASSIF-SOURCE`, **OLF-c17e2ed2-5f1d-5950-ad66-fc86964a8c29**. Son critère courant exige une fiche4.20datée avec source et SHA, les valeurs/exceptions connues séparées des inconnues, et la disponibilité historique décidée sur preuve. Les huit champs contractuels id/titre/type/required/required_if/dépendances/acceptance/preuves correspondent au contrat archivé V544. SOURCE est requise ; implémentation et acceptation sont false. `CH-Blitzcrank-IDENTITE` reste `a_qualifier`, non implémentée/non acceptée ; le lotD06-CH-Blitzcrank et ses six packages ne deviennent pas satisfaits par cet audit : D04-SYS-04-1, D04-SYS-04-6, D05-SYS-05-2, D05-SYS-05-4, D14-SYS-14-2, D20-SYS-20-1.

L’unité rapproche les sources et limites de V544, les identités datées V1182, le contrat courant réemployé et les consommateurs nommés actuels. Elle examine séparément l’état initial, les attaques ordinaires, dégâts/absorption/PV, API serveur générique, tick/régénération/capacité, mort/retour ordinaire. Elle ne qualifie pas le serveur Riot, le dispatch natif, toutes les politiques ManaBarrier, la disponibilité historique complète ou la présentation.

| Dimension | Conclusion bornée |
|---|---|
| Audit | Terminé avec preuves pour cette liaison documentaire SOURCE→consommateur |
| Implémentation | Voies génériques présentes ; producteur du passif non qualifié dans les corps lus |
| Vérification | Statique/documentaire effectuée ; aucun runtime actuel exécuté |
| Acceptation humaine | Non demandée/non donnée ; aucun gameplay accepté |

L’inconnue propriétaire **OLU-9d0518cb-b11f-5c9d-913f-309518d1521f** reste `open`. Les IDs liés de contrat/simulation restent chez leurs propriétaires. L’audit global SYS-01.2-02 reste ouvert.

## 2. Sources, provenance, identités et limites

Référence primaire cliente : **PUBLIC4.20.0.315 EUW/en_GB**, build littéral2014-11-17 17:46:45 ; fuseau et date de déploiement inconnus. Le catalogue officiel4.20.1 est distinct. Reçus conservés du25octobre2026 : `docs/FIDELITY_BLITZCRANK_PASSIVE_SHIELD_LINKS_V544.md` (11543B,SHA `b921919d53f2dd7ba3769b4778e1e3f50cfde996f3f3fc3f62f4f8a403a8713e`), `docs/fidelity_blitzcrank_passive_shield_links_v544.json` (2794B,SHA `81a43d4b6e7aa2d560b5e54746762b9ce73be864b6f5bb2d4b21c93931c88163`) et reçu détaillé `docs/reference_requirement_trace_sources/blitzcrank-passive-shield-links-v544.json` (441186B,SHA `184e94afc243a8b725ce7b67a4cfa1a97cc37f48e8ac59bb4c6aa0f6a27468cf`). Ces petites preuves gardent leurs pins V1182.

Douze membres V544 correspondent à12identités contrôlées dans le cache daté V1182. Leurs tailles/SHA et membres RADS taille/MD5/releases individuelles sont conservés dans `native_contract_review.json`. **15relations natives SOURCE représentent12identités distinctes**, sans identité supplémentaire. Ces12sont les mêmes réemployées, pas12nouvelles sources à additionner. Aucun fichier natif n’est rehashé ou décodé pour V1186.

| Ressource native | Source ID |
|---|---|
| Blitzcrank.inibin | OLS-71d6b4e7-a4d7-5cca-8789-871a26034eea |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| BlitzcrankManaBarrierCD.inibin | OLS-d169b1b7-2dad-5a25-b2de-8875ec2c7840 |
| ManaBarrier.inibin | OLS-4d46a81a-6bf7-511c-a29f-70db5cb39f56 |
| ManaBarrier.luaobj | OLS-d2342baf-9886-5a7c-83b7-68815dc7d3d8 |
| ManaBarrier.preload | OLS-8db59512-c5e7-5767-af46-faf87a51ee43 |
| ManaBarrierCooldown.luaobj | OLS-14c6ac22-1902-5e5d-adca-2a6b4a6cfc9c |
| ManaBarrierIcon.inibin | OLS-7492b8f9-4479-5d09-8509-af0135fbb180 |
| ManaBarrierIcon.luaobj | OLS-189f00b3-e24c-5ec9-958d-3177c5f397ac |
| ManaBarrierIcon.preload | OLS-3232541e-833e-53b8-a8e5-805504595083 |
| CharScriptBlitzcrank.luaobj | OLS-67735fe6-81a9-577f-9383-108fcbe17bfc |
| CharScriptBlitzcrank.preload | OLS-9e1c1df6-966a-5cd2-9be0-8cb51226b044 |

La définition lie `Passive1LuaName=ManaBarrierIcon` et `Blitzcrank_ManaBarrier.dds`. Trois INIBIN lient exactement les textes du font : recharge **1731**, actif **2262**, Icon **2263**. Icon décrit passage **sous20%PV**, bouclier **50% du mana courant**, durée **jusqu’à10secondes**, activation **une fois toutes les90secondes**. Le4.20.1 dit « his mana » ; le texte natif explicite courant est conservé. Il ne démontre pas le moment d’échantillonnage, une dépense de mana, un ordre serveur, l’égalité20%, la disponibilité ou les niveaux.

Les littéraux Icon/Cooldown `PersistsThroughDeath=true`, `NonDispellable=true` et `OnPreDamagePriority=8` restent des déclarations. La priorité8 ne prouve ni un callback ni l’ordre de création/absorption. `BuffName=BlitzcrankManaBarrierCD` concorde avec l’INIBIN, sans politique d’alias exécutée. Le rapport V544 déclare quatre Lua entièrement parsés sans prototype enfant ; le reçu embarque le détail de ManaBarrier,365B,0prototypeenfant, entièrement consommé. Le lecteur de littéraux s’arrête sur **NEWTABLEpc8** : limite de lecture, pas corruption. Les noms `AutoCooldownByLevel` et `DoOnPreDamageInExpirationOrder` ne suffisent pas à attribuer des valeurs/règles. Les trois preloads et noms steamgolemshield/steamgolemshield_hit ne valident pas un rendu.

Ancien `Passive1Desc` concernant Alistar/tourelles, chaînes+400/+600PV et niveaux6/12/18 : littéraux conservés, non adoptés. Passive1 absent reste absent. Les quatre fichiers NightmareBotBlitzcrankManaBarrier sont exclus des règles du champion normal, même lorsque des octets correspondent. Les quatre miroirs JSON communautaires et le C# CharScript vide de cette copie restent des références avec provenance, pas le serveur original. La présence au manifeste ne décide ni priorité runtime ni admission historique complète.

Le contrat courant vient du cache immuable `E:/mapslol3v3/audit_sys01202_passive_contracts_20261103/passive_task_contract_snapshot_122.json`, SHA `6567a15ae5ed0b7bad77c594afdd216d523a07e32f1999a684b625b7cfcc84c0` :122SOURCE/1350contrats,0auditclos. Root a vérifié les deux identités d’entrée brutes sans nouveau parsing : execution_plan_A_Z.json SHA `a86d11b2c4520cfb980567163098d85e8f826d0724fca68e77f023a38a8ce9e0`, completion_tasks_2026-10-20.json SHA `5c30d6f9543cc7f39e7801ab721242204f5745b60e118f793fe618b13baef8da`. Sur dérive : refuser le réemploi et créer un nouveau snapshot versionné, sans écraser cette preuve.

## 3. Consommateurs réels courants

Le sous-reçu `current_consumer_review.json` relit **17fichiers** : neuf Rust, deux lecteurs, six JSON locaux. Tous gardent taille/SHA V544. Intersections avec les derniers reçus : Azir12/12, Anivia16/16, Ashe12/12 conformes ; aucun collecteur antérieur réexécuté. Cela ne prouve pas la provenance de compilation du binaire historique. Les six CID SOURCE sont conformes : chargeur `lib.rs:149` OLC-93924678..., INIBIN read46/decode12/hashkey8 OLC-38ea5f63.../5c0215b6.../a377335c..., Lua inspect86/literal_globals54 OLC-eb82d3cd.../1eee42c0.... Le JSON conserve les UUID complets. Le chargeur lit les champs de base de ChampionDefinition ; les lecteurs ne sont pas exécutés. Leur rôle de consommateur SOURCE n’est pas une production gameplay.

Les **dix sites V544** sont également conformes et restent `entry_boundary_only`, `provides_feature_consumer=false`. Les fenêtres numérotées et UUID complets sont conservés dans le sous-reçu :

| Trajet | Corps/ancres actuels | Conclusion statique |
|---|---|---|
| État/join | lib.rs136-207,445-519,533-597 ; spells.rs5-52 | Vie, mana courant, capacité et boucliers génériques ; niveau1, Effects par défaut, shields vides. Aucun état ManaBarrier de disponibilité/recharge identifié dans ces déclarations/initialisations. |
| Ordre/libération | lib.rs598-684/639 ; attacks.rs180-255/243 ; lifesteal.rs4-26 | Attack validé puis libération mêlée ordinaire→basic_attack_hit→apply_damage physique. Les branches spécifiques d’autres champions restent distinctes. |
| Dégâts | damage.rs53-150/104 ; shields.rs47-61 | Mitigation→absorption des boucliers positifs non expirés déjà présents, par expiration proche→PV. Aucun producteur qualifié associant seuil/mana courant/recharge dans ces corps. |
| Événement générique | shields.rs12-39 ; Action lib.rs280-301 | grant_shield reçoit tag/montant/durée explicites, remplace le même tag, expiration tick.saturating_add(duration). Pas de calcul50%mana, seuil20% ou rechargeManaBarrier dans ce corps ; aucune commande client grant_shield. |
| Temps/régénération | lib.rs685-743,776 ; shields.rs41-46 ; regeneration.rs9-49 | Tick incrémenté, boucliers avancés, puis régénération avant attaques ordinaires. Retain expires_at>tick. Ces mécanismes ne qualifient pas10s/90s natifs. |
| Capacité | progression.rs110-117 ; lifecycle.rs16-30 | Max mana = base+croissance+objets pour utilisateur de mana ; le snapshot expose la capacité. Elle reste distincte du mana courant. |
| Mort/retour | damage.rs104-116 ; lifecycle.rs33-89 | PV0, Effects réinitialisés, boucliers effacés, décès ordinaire ; retour restaurePV/capacité de mana au spawn. Ni interception létale ni politique de recharge/persistance du passif qualifiée. |

Une seule requête `Blitzcrank|ManaBarrier|mana_barrier|mana barrier`, sans récursion, sur ces neuf Rust : **0hit, code1attendu**, journal `manabarrier_named_body_search.txt`. Les textes de tests présents font partie de la recherche mais aucun test n’est exécuté. Les corps lus fondent la conclusion ; l’absence de nom seule ne prouve pas une absence globale de code ou d’assets. Aucun scan global1149fichiers ni scanHUD nouveau.

Les branches de refus sont lues, pas invoquées : commandes/Attack (match ended, unknown player, champion dead/stunned/in forced movement, skill blocked during cast, attacks disabled during cast, unknown target, target protected, invalid enemy target, target not visible) ; basic_attack_hit (unknown attack source/target, invalid enemy target) ; apply_damage (match ended, invalid damage, unknown damage source/target, damage target dead/protected, invalid defense stats). `grant_shield` refuse `match ended`, `invalid shield` (tagvide, montant non fini/non positif ou durée0), `unknown shield target`, `shield target dead`. Ce relevé ne constitue pas une preuve fraîche d’immutabilité après refus ni l’inventaire complet des callees.

Les `source_sha256` des ressources JSON typées gardent leur provenance distincte du natif INIBIN brut ; aucun faux défaut de hash ou nouvelle recherche du producteur n’est ouvert.

## 4. Comportement, contrôles exécutés et résultats

**V1186 réellement exécuté :** `review_native_contract.py` produit15/15cohérences documentaires ; le collecteur courant vérifie17pins,10+6ancres et une recherche9Rust ; `integrate_blitzcrank_review.py` joint les parties figées avec15/15cohérences, code0. Le dernier contrôle valide les objets de pins et refuse les trois chaînes du schéma préparatoire erroné. Ces nombres décrivent la cohérence de preuves bornées, pas des tests de gameplay. Aucun Cargo/build/testRust, runtime, vieux diagnostic, client/serveur original, VM Lua, GPU, réseau, décodeur ou REA exécuté.

**V544 daté, non rejoué :** deux parties Map10 avec commandes publiques Move/Attack/Stop, niveau1, sans injection de PV/mana/dégâts. Après11frappes au tick1321, PV144,427978515625→97,94989776611328 sur582,5999755859375, soit24,79024795%→16,81254752%. Aucun bouclier observé aux frappes initiales, au passage ou ensuite dans le cas sans témoin suivi jusqu’à1621. Mana267,20001220703125, moitié textuelle133,60000610351562PV. Le mana y est plein : ce cas ne distingue pas courant de maximum. La disponibilité initiale, le niveau et l’égalité20% n’y sont pas établis ; la non-activation n’est ni une fidélité complète ni une absence globale démontrée.

| Frappe suivante tick1369 | Sans témoin | Avec témoin artificiel |
|---|---:|---:|
| Absorption | 0PV | 46,534812927246094PV |
| PertePV au-delà régénération | 46,534812927246094 | 0 |
| PV au tick1621 | 68,43473815917969 | 114,96955108642578 |

Après le passage, le second cas fournit `grant_shield(id,"diagnostic-control",100,300)` via événement serveur. Son reliquat expire1621,300ticksaprèscréation. **100PV ne vaut pas133,6000061PV ; ce contrôle ne teste pas50%mana. 300ticks à30Hz coïncident avec10s, sans prouver10s natifs.** Ordre générique d’absorption/expiration et priorité8 littérale ne prouvent pas l’ordre natif de déclenchement. Le témoin n’est ni une activation du passif ni une commande client.

V544 conserve **six refus Attack + cinq refus grant_shield**, snapshots inchangés :11refushistoriques,0nouveautest. Le binaire6041088B,SHA `ad9fad9534b1a2d38c58e30d99d564d4d3e04cf8760e99188f73044127d6a862`, ses commandes/lock/logs restent attribués au reçu daté. L’identité actuelle du code ne démontre pas sa provenance de compilation. Recharge90s, second déclenchement, mort et présentation n’étaient pas qualifiés.

## 5. Écarts, limites et indéterminations

La fiche SOURCE n’est pas satisfaite dans son entier : corps/callback/dispatch serveur original, admission historique, disponibilité initiale et niveaux, seuil exact20%, PV de référence, ordre dégâts/absorption/létalité, capture et éventuel coût du mana courant, démarrage90s/10s, réarmement, persistance/mort, dégâts/interactions et présentation restent ouverts. Les déclarations clients n’effacent pas ces inconnues. Aucune nécessité de correction d’asset ou de corruption n’est démontrée.

Le moteur actuel fournit les consommateurs génériques relus, sans producteur ManaBarrier qualifié dans les corps bornés. Sa capacité mana/regen, son grant_shield et ses politiques de mort ne sont pas une reconstitution automatique du passif. Le résultat de recherche nommée et les observations historiques sont limités à leurs scopes. Aucun accès original ou nouveau runtime ne permet de trancher les autres branches.

## 6. Corrections réutilisées et critères de fin

Les trois IDs existants sont réutilisés uniquement dans ce rapport ; aucune fiche n’est créée/enregistrée, aucun statut changé, aucun nouveau dénominateur. Le travail fonctionnel nécessite une autorisation distincte du cadrage documentaire actuel.

| ID existant | Objectif unique et critères de fin |
|---|---|
| CH-Blitzcrank-PASSIF-SOURCE | Fiche versionnée reliant les12IDs, le texte client et les inconnues. Qualifier l’admission historique sur preuve primaire ; distinguer déclarations/serveur/miroirs. Garder les sources natives, priorités/alias, variantes exclues et disponibilité séparées. Fin de SOURCE seulement lorsque son critère courant est satisfait, notamment la disponibilité historique décidée sur preuve ; une indétermination bornée permet de terminer cet audit, pas de qualifier automatiquement la tâche SOURCE. Aucun témoin artificiel adopté. |
| CH-Blitzcrank-PASSIF-SIMULATION-CONTRAT | Obtenir une autorité primaire attribuable : seuil strict/égalité et basePV ; ordre d’absorption/dégâts/létalité/déclenchement ; mana courant≠maximum, instant de capture/coût ; disponibilité initiale/règle de niveau ; unités, arrondis et départs/durées10s/90s ; second déclenchement ; mort/persistance/réinitialisation ; types de dégâts/exclusions/refus. Ne pas attribuer une valeur à une constante non résolue ou promouvoir la priorité8 en callback. |
| CH-Blitzcrank-PASSIF-SIMULATION | Après contrat qualifié, implémenter/vérifier le vrai trajet dégâts→seuil→bouclier autoritaire. Attendus/observés séparés pour juste au-dessus/égalité/juste au-dessous20%, hit franchissant, bouclier existant et létalité ; mana réellement entamé distinct de sa capacité maximale pour discriminer courant/max ; initialisation/disponibilité/niveaux ; montant/expiration puis recharge90s et second déclenchement ; mort et exclusions. Vérifier erreurs exactes, prérequis et absence de mutation après refus. Le grant_shield100/300 reste un contrôle distinct. Pas de fin sur une seule non-activation ou un seul montant injecté. |

L’identité et les prérequis du package restent ouverts. Les rôles NETWORK/PRESENTATION/ACCEPTANCE restent séparés ; aucune nouvelle correction générale de source, hash, outil ou asset n’est justifiée par ce lot.

## 7. Livrable, preuves et relecture de cohérence

Stage : `E:/mapslol3v3/audit_sys01202_blitzcrank_passive_source_20261103`. `result.json` (30411B,SHA `a6fa476081e16a6e33e8d1f7bdf019a0cf795878ef84f3516b8cd3dff8b23327`) contient15/15cohérences, pins des parties, sources, cache, extracteur et17fichiers courants ; sous-reçu natif59233B,SHA `cff8b592c33086372d1ed5587db199ba146bd86f64325123e19e5af94c9962fe` ; sous-reçu code107980B,SHA `852459f9cac8e148cc8ba24275dbb19c5cb371439e44f0df2d0b3484f9aadb83`. Scripts et notes identifiés accompagnent ces reçus. L’extrait V1182 SHA `9b861821e0d4a3924dfcac71512ff3a75df63f310eb427f72b1b945b94f98df6` et matrice SHA `bd350cea162a0363ab8aba3f308f8a1d6e23241d2b175a3a5cd741ce661c0d23` restent historiques, inchangés.

Correction avant publication, détectée par lecture indépendante : l’intégration initiale dépliait trois clés `azir`, `anivia`, `ashe` au lieu des objets de pins correspondants ; le publisher aurait levé TypeError avant publication. Aucun publisher n’a été exécuté, même en dry-run. Le result préparatoire initial28141B/SHA `8386e943e39f803dd41b3caa86010ceca0c6500ba7df12b930cc04f6d0cabd8d` avait été remplacé par la correction `.values()` avant réception de la consigne d’archivage : ses octets n’ont pas de sauvegarde préalable disponible. L’état corrigé avant garde structurel est conservé (28794B/SHA `245fa4160d1ba1e0df524bc8617ddae716be82d1a7d1076acc103c50fa0d52cb`). Seul le rapport initial a été reconstruit avec concordance du SHA connu99178f... et étiquette `RECONSTRUCTED_NOT_BACKUP`. `prepublication_correction.md` consigne cette limite de préservation, qui concerne uniquement la preuve préparatoire de cette intervention ; acquis V544/V1182 et produits intacts. Le dernier intégrateur valide chaque pin objet/chemin absolu/taille/SHA avant PASS et refuse l’ancien schéma ; seule l’intégration E de petits reçus est rejouée. `publisher_schema_guard_review.json` exécute uniquement la fonction verify_pin extraite par AST : les trois chaînes sont refusées avant I/O ; aucun code top-level du publisher, contrôle protégé ou accès F n’est exécuté par cette vérification. Aucune publication F n’a été tentée.

Le publisher gardé n’écrit que ce rapport dans docs et des appendCURRENT/HANDOFF. Il refuse doublon, dérive des petites preuves/pins courants/cache/extracteur ou des sept fichiers protégés (cinq registres de continuité + completion_tasks + execution_plan). Aucune vérification physique du corpus natif, aucun grand JSON parsé. **Le gate des sept protégés est prévu pour la publication root ; il n’est pas exécuté pendant la préparation E.** Son reçu séparé fera foi de la publication et des identités avant/après. La relecture indépendante précède toute publication root ; ses observations sont conservées séparément sans créer une seconde unité close.

Mesure : **1nouvelauditbornéclos/1unitéexplicitementexaminée**,0SOURCE/0inconnue/0fonctionnalitéclose. Sous-partie native15/15 et intégration15/15, sixlecteurs, dixfrontières,17pins et cache122ne sont pas des audits supplémentaires. Aucun taux de jeu terminé ou comparaison hebdomadaire inféré ; comparaison indisponible. Delta V1182 : candidature Blitzcrank désormais relue bornément ; aucune réécriture de la matrice historique, aucune qualification SOURCE complète.

Reprise root readonly : `E:/mapslol3v3/resume_sys01202_20261103_v1185.txt`, main, HEAD `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, modifications locales antérieures conservées ; aucun acte Git dans ce lot. Reprendre cette mécanique seulement sur source/callsite primaire attribuable, observation nouvelle, dérive nommée ou autorisation runtime ciblée. Pas de replay identique sans cause nouvelle. **Prochain candidat documentaire possible : Brand PASSIF-SOURCE depuis V659/V1182**, selon preuves disponibles ; aucun nouveau lot ou enquête automatique autorisé par cette note.
