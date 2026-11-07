# SYS-01.2-02 — Matrice de réemploi de douze fiches PASSIF-SOURCE

**V1182 — une consolidation documentaire bornée.** Douze exigences SOURCE sont reliées à leurs preuves existantes et à l’extrait courant ; six périmètres d’audit antérieurs explicitement clos sont réutilisables, six autres cas restent candidats à une relecture SOURCE précise. **Aucune des douze tâches SOURCE n’est clôturée par ce lot ; aucune ancienne clôture n’est comptée une seconde fois.**

## 1. Question, périmètre et critère de fin

Référence native PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct. Le périmètre contient exactement les douze premiers noms triés du catalogue local `F:\OpenLeague\data\4.20\champions.json` : Aatrox, Ahri, Akali, Alistar, Amumu, Anivia, Annie, Ashe, **Azir**, Blitzcrank, Brand, Braum. Le catalogue comporte 122 entrées ; le lot concerne uniquement leurs **PASSIF-SOURCE**, pas douze kits complets.

Critère de fin de cette consolidation : conserver un lien précis tâche/OLF/trace actuelle → ancien audit/son propre rôle → preuve réutilisable/limite → action de reprise. Ne pas transformer un audit d’ACCEPTANCE, de HUD ou du parent SYS en clôture SOURCE. La matrice machine `reuse_matrix.json` donne les IDs complets, inconnues, sources/consommateurs, cibles historiques exactes et empreintes ; le présent document en est la lecture opérationnelle. Les neuf contrôles de cohérence réussissent (**9/9**, code0).

Comptage : **1 nouvel audit de consolidation**, **6 anciens périmètres clos réutilisables**, **6 autres candidats**, **0 nouvel audit SOURCE clos**, **0 nouvelle clôture héritée**, **0 fonctionnalité close**. Ces comptes ne donnent aucun pourcentage de jeu terminé.

## 2. Sources et preuves conservées

L’extraction `extract_current_trace.py`, déjà exécutée, charge le graphe **une seule fois** et écrit `trace_excerpt.json` : douze relations SOURCE, 313 identités source sur 313 chemins distincts, tailles/SHA conformes, huit ancres de consommateurs avec sourceSHA conformes et entrées stables, durée totale3,766s. **313 n’est pas un compte d’assets natifs : les références, preuves documentaires et sources de code sont aussi incluses.** Une identité conforme ne qualifie pas le contenu sémantique ou la mécanique.

L’extrait est épinglé : `trace_excerpt.json` SHA-256 `9b861821e0d4a3924dfcac71512ff3a75df63f310eb427f72b1b945b94f98df6` ; extracteur `023f3a4c96c836c9840d70cc2e812fcf0c8dab5081c313f750362c0694652225`. La consolidation ne recharge pas le graphe, ne relit pas les 313 fichiers et ne relance aucun ancien validateur. Elle lit seulement cet extrait et les rapports/reçus documentaires nommés, dont elle conserve les empreintes.

Les preuves historiques `fidelity_*_passive_*_links_v*.json` consultées ont `passed:true`. Ce statut concerne leur contrôle de traçabilité d’origine ; il n’est pas transféré au gameplay ni au code actuel. Les listes exactes des fichiers lus et leurs SHA-256 sont dans `reuse_matrix.json.documentary_pins`.

## 3. Tâches SOURCE actuelles, rôles anciens et consommateurs réels

Chaque ligne représente `CH-<champion>-PASSIF-SOURCE`. Les **douze** traces courantes restent `partial_with_open_questions`, avec leurs inconnues inchangées. Les rapports mentionnés ci-dessous sont sous `F:\OpenLeague\docs` ; les cibles exactes des reçus, y compris les OLF des rôles SIMULATION-CONTRAT/SIMULATION, sont conservées dans `prior_audit_targets_exact` de la matrice.

| Champion | OLF SOURCE actuel | Ancienne cible et portée réellement réutilisable | Reprise SOURCE précise |
|---|---|---|---|
| Aatrox | OLF-ea1d5d66-a12d-5a45-8b25-ced88a540531 | `AUDIT_CH-AATROX-PASSIF-SOURCE-CONSUMER-01_2026-11-02.md` cible **CH-Aatrox-PASSIF-ACCEPTANCE**, OLF-2060db7b-b9dc-5154-905b-9831d95d943c. Audit clos d’identité/liaison, absence Blood Well bornée au code inspecté. | Réutiliser identité et recherche bornée ; expliciter séparément les clauses SOURCE non couvertes. Le corps serveur/contrat primaire ou un handler nouveau conditionne la reprise mécanique. |
| Ahri | OLF-c0e02261-777d-5883-b292-9a6222c80e4c | `AUDIT_CH-AHRI-PASSIF-SOURCE-CONSUMER-01_2026-11-02.md` cible **CH-Ahri-PASSIF-ACCEPTANCE**, OLF-b32ca84b-e174-540a-a53f-c8aa1fa222ad. Liaison statique close ; pas de handler Essence Theft identifié dans le périmètre. | Réutiliser ce constat adjacent ; les règles charges/soins et le corps serveur restent à qualifier pour SOURCE. |
| Akali | OLF-7291a4c0-1d49-5cdb-a777-7f6f9277cf2c | `AUDIT_CH-AKALI-PASSIF-SOURCE-CONSUMER-01_2026-11-02.md` cible **CH-Akali-PASSIF-ACCEPTANCE**, OLF-770d90f4-f633-5f5b-abb7-e259aa8bfaba. Liaison statique close, pas de consommateur Twin Disciplines identifié. | Réemploi adjacent, sans transfert de statut à SOURCE ; f1/f2/formules/corps serveur ouverts. Lifesteal générique distinct. |
| Alistar | OLF-5999f5e7-a578-5cae-b6fb-b1704da1ef5b | `FIDELITY_ALISTAR_PASSIVE_CAST_TRAMPLE_LINKS_V552.md`, supplément02/11 : fraîcheur des sources/reçu/18ancres close. Les cibles V552 sont SOURCE (OLF ci-contre), SIMULATION-CONTRAT OLF-8af99190-251c-55ad-acb6-5ed203970f8e et SIMULATION OLF-cfd9eb8a-09dc-58f9-9421-ad8c1a6cd86a. **SOURCE explicitement ouverte.** | Réutiliser fraîcheur et diagnostic ancien ; sort accepté/déclencheur, f1/f2/f3, portée/cadence/cibles/phasing restent ouverts. |
| Amumu | OLF-3650d3fa-8aaf-51c4-8838-2b77011cf095 | `FIDELITY_AMUMU_PASSIVE_MR_LINKS_V550.md`, supplément02/11 : fraîcheur des sources/reçu/16ancres close. Cibles SOURCE (OLF ci-contre), SIMULATION-CONTRAT OLF-9f2efb22-23a3-56bd-9224-6eba70171c1a et SIMULATION OLF-df27d6be-e5e4-5aa8-86b6-64bb04d798d8. **SOURCE explicitement ouverte.** | Réutiliser MR inchangée et contrôle magique distinct ; fournisseur f1, montants/niveaux/cibles/ordre et producteur autoritaire ouverts. |
| Anivia | OLF-14ec441f-5efa-5b14-9c0c-103dc6ebf44a | `FIDELITY_ANIVIA_PASSIVE_REBIRTH_LETHAL_EGG_LINKS_V558.md` : SOURCE/CONTRAT/SIMULATION, preuve publiée de frontières ; aucune relecture de clôture SOURCE explicite retrouvée dans les rapports ciblés. | **Prochain candidat borné** : rapprocher V558 des clauses SOURCE et des consommateurs nommés. Producteur Rebirth courant non prouvé par l’extrait ; corps serveur/f1/déclenchement létal/œuf restent ouverts. |
| Annie | OLF-d565984c-872c-5e4b-97ce-c925c4db07e2 | `AUDIT_SYS01202_ANNIE_PASSIVE_LINK_2026-11-02.md`, unité AUD-SYS-01.2-02-ANNIE-PASSIVE-LINK-01, parent **SYS-01.2-02 / OLF-3a11ace9-485c-55ae-8dff-2533902a5839**. Lie SOURCE/SIMULATION/NETWORK/ACCEPTANCE sans clôturer ces rôles ; identité/liaison close. Le rapport ne fournit pas les quatre OLF individuels historiques : ne pas les inventer. | Réutiliser identité et producteur partiel actuel ; durée native et nouveaux callsites restent non qualifiés. Les quatre tâches ne reçoivent pas la clôture du parent audit. |
| Ashe | OLF-6de8fca6-0d5c-562c-9ff8-1bea0b8daca8 | `FIDELITY_ASHE_TRYNDAMERE_PASSIVE_BOUNDARY_LINKS_V537.md` cible **SIMULATION-CONTRAT** OLF-c34d31b6-7d27-5abe-bb41-49c0d98edec2 et **SIMULATION** OLF-cad4f2d7-93ae-559f-b955-73ce3916aea7 ; SOURCE reste distincte. | Relecture SOURCE explicite manque ; Focus/100charges/f1/producteur ouverts. Exclure les conclusions Tryndamere. HUD72/72 clos séparément, pas une clôture mécanique. |
| Azir | OLF-16408636-7d34-5837-b73f-7ae33e3038a5 | `FIDELITY_AZIR_PASSIVE_CDR_ATTACK_SPEED_SUNDISC_LINKS_V559.md` : SOURCE/CONTRAT/SIMULATION, frontières publiées ; clôture SOURCE explicite non retrouvée. | Relecture des seules clauses SOURCE et consommateurs nommés si prioritaire ; conversion CDR→AS/SunDisc/ruines restent ouverts. |
| Blitzcrank | OLF-c17e2ed2-5f1d-5950-ad66-fc86964a8c29 | `FIDELITY_BLITZCRANK_PASSIVE_SHIELD_LINKS_V544.md` : SOURCE/CONTRAT/SIMULATION, frontières publiées ; clôture SOURCE explicite non retrouvée. | Relecture SOURCE manque ; conserver le bouclier témoin distinct. Déclencheur, disponibilité/niveau, seuil/ordre/recharge restent ouverts. |
| Brand | OLF-31db12fd-f7b2-54b8-bbcd-df98e463ed56 | `FIDELITY_BRAND_PASSIVE_BLAZE_LINKS_V659.md` : SOURCE/CONTRAT/SIMULATION, frontières publiées ; clôture SOURCE explicite non retrouvée. | Relecture SOURCE manque ; producteur Ablaze/ticks/cumul/PVmax/plafond et tooltip non résolu ouverts. Témoins Annie/API séparés. |
| Braum | OLF-97580864-ed1d-58d7-bbf2-ab5b9e1e5ba7 | `FIDELITY_BRAUM_PASSIVE_CONCUSSIVE_BLOWS_LINKS_V660.md` : SOURCE/CONTRAT/SIMULATION, frontières publiées ; clôture SOURCE explicite non retrouvée. | Relecture SOURCE manque ; producteurs marques/f1/f2/f3/f5, ordre/alliés/immunité/interactions ouverts. |

Les six périmètres antérieurs explicitement clos réutilisables sont **Aatrox, Ahri, Akali, Alistar, Amumu, Annie**. Leur portée est celle de la troisième colonne, pas la clôture des six SOURCE. Les six candidats sont **Anivia, Ashe, Azir, Blitzcrank, Brand, Braum** ; « relecture non retrouvée » est borné aux rapports ciblés par leurs noms, pas une absence globale de preuve ou d’implémentation.

Le HUD d’Ashe est adjacent : `AUDIT_SYS01202_ASHE_PASSIF_HUD_ICON_STATE_LINK_2026-11-03.md`, unité AUD-SYS-01.2-02-ASHE-PASSIF-HUD-ICON-STATE-LINK-01, cible `CH-Ashe-PASSIF-PRESENTATION-HUD` / OLF-7c3d1f1d-6bd5-5542-bbcf-5eb3e5c38413, liaison statique72/72 close ; il ne qualifie pas le producteur Focus ni SOURCE.

**Consommateurs courants contrôlés dans l’extraction :** six points communs sont le catalogue `champion_catalog`, quatre fonctions de lecture/hash/décodage INIBIN ou inspection Lua et `literal_globals`. Les cinq fonctions de lecteurs sont qualifiées pour l’audit SOURCE ; leurs `provides_feature_consumer=true` sont limités par leur scope explicite et ne prouvent aucun passif exécuté. Les deux autres points sont `annie_passive.rs:9` (`pyromania_spell`) et `:23` (`grant_stun`) : producteur réel **partiel** pour Annie, pas un serveur historique qualifié. Les huit CID et leurs scopes complets sont dans l’extrait. Les anciennes ancres V550/V552 et les anciennes recherches négatives restent des preuves datées : l’extraction ne requalifie pas toutes leurs frontières gameplay actuelles.

## 4. Attendu, observé et vérifications réellement exécutées

| Attendu | Observé |
|---|---|
| Roster réel, douze IDs SOURCE/OLF sans transfert de rôle | 122champions,12noms exacts avecAzir ; douze SOURCE mappées, OLF historiques distincts conservés |
| Réutiliser les preuves plutôt que refaire les mêmes recherches | Une extraction du graphe déjà produite ; aucun rechargement par la consolidation, aucun ancien script relancé |
| Vérifier la fraîcheur bornée des entrées de l’extrait | Extraction :313/313identités et8/8ancres conformes, trois registres stables pendant la lecture ; rien n’en déduit des règles complètes |
| Conserver les états et séparer les clôtures | Douze `partial_with_open_questions` conservés ; six périmètres anciens et six candidats séparés ; zéro SOURCE promue |
| Matrice exploitable avec limites/reprise | `consolidate_reuse.py` :9/9cohérences, code0, `PASS_DOCUMENTARY_CONSOLIDATION` |

La commande de consolidation réellement exécutée est `F:\OpenLeague\.ai-tools\.venv\Scripts\python.exe -B E:\mapslol3v3\audit_sys01202_passive_reuse_12_20261103\consolidate_reuse.py`. Elle écrit seulement `reuse_matrix.json` sur E. `sys.dont_write_bytecode=True` est fixé ; aucun import de module du projet n’est nécessaire dans cette consolidation.

Non exécutés : client/serveur historique, jeu actuel, compile/test Rust, Lua VM, GPU/rendu/audio, REA, ancien diagnostic/validateur, recherche générale ou nouveau corpus natif. Le lot ne produit aucun nouveau refus en partie et ne présente pas les refus/tests anciens comme une exécution actuelle. Les checks de cohérence refusent un autre roster, une identité/ancres rapportées non conformes, une partition différente ou une promotion SOURCE ; ils ne sont pas des tests de gameplay.

## 5. Écarts précis et conditions de reprise

**Écart documentaire résolu :** le rôle des six anciennes clôtures est désormais explicite face aux douze SOURCE courantes ; les OLF ACCEPTANCE et parent SYS ne sont plus interchangeables avec les OLF SOURCE. Les sources physiques et ancres courantes de l’extrait restent reliées sans nouveau dénominateur de progression.

**Ouvert :** les clauses SOURCE complètes, corps serveur, fournisseurs/formules et comportements indiqués dans chaque ligne. Les douze inconnues de l’extrait restent ouvertes chez leurs propriétaires. Six candidats n’ont pas de relecture de clôture SOURCE explicite retrouvée ; cela manque à leur décision d’audit courante, pas à leur présence d’assets. Pour les six périmètres réemployés, les clauses SOURCE non couvertes restent également ouvertes ; l’héritage documentaire ne les dispense pas d’une décision sur le bon rôle.

**Prochain lot proposé : Anivia uniquement.** Entrées prêtes : ligne `CH-Anivia-PASSIF-SOURCE`/OLF-14ec441f-5efa-5b14-9c0c-103dc6ebf44a et inconnue OLU-171a3812-c5d0-5548-8b36-71d54f430648 dans l’extrait, rapportV558, reçu/proof ci-dessous. Question : quelles clauses SOURCE sont déjà démontrées, et quel consommateur Rebirth est établi ou non dans les chemins nommés ? Fin attendue : décision bornée source→consommateur avec champs non démontrés et déclencheur de reprise précis. Pas de corpus/redécodage/test ancien répété sans dérive ; pas de supposition d’absence globale sur la seule liste CID SOURCE. Cette proposition ne déclenche aucune nouvelle enquête dans V1182.

## 6. Corrections, preuves référencées et conservation

Aucun nouvel ID fonctionnel proposé ou enregistré ; aucune modification de tâches, états, inconnues, Goal, Plan, UI, application ou bases. La correction est cette matrice de rôles et d’actions, avec source/consommateur courant identifié. Les reçus de liens cités sont sous `F:\OpenLeague\docs\reference_requirement_trace_sources` :

| Champion | Reçu de preuve historique réutilisable |
|---|---|
| Aatrox | Le rapport d’audit adjacent et `docs/fidelity_aatrox_passive_source_boundaries_v456.json` sont épinglés ; l’audit NETWORKV664 est conservé hors de cette preuve de clôture SOURCE. |
| Ahri | `ahri-passive-spell-hit-charges-heal-links-v556.json` |
| Akali | `akali-passive-twin-disciplines-links-v557.json` |
| Alistar | `alistar-passive-cast-trample-links-v552.json` |
| Amumu | `amumu-passive-mr-links-v550.json` |
| Anivia | `anivia-passive-rebirth-lethal-egg-links-v558.json` ; preuve `docs/fidelity_anivia_passive_rebirth_lethal_egg_links_v558.json` |
| Annie | Le rapport d’audit parent est la preuve de clôture réemployée ; VFXV668 et HUD restent des composants adjacents distincts. |
| Ashe | `ashe-tryndamere-passive-boundary-links-v537.json` ; les paires Tryndamere sont conservées dans le reçu, exclues des cibles Ashe de la matrice. |
| Azir | `azir-passive-cdr-attack-speed-sundisc-links-v559.json` |
| Blitzcrank | `blitzcrank-passive-shield-links-v544.json` |
| Brand | `brand-passive-blaze-links-v659.json` |
| Braum | `braum-passive-concussive_blows-links-v660.json` — underscore exact conservé |

Les différences entre nombres historiques de ressources associées et relations courantes cumulées ne sont pas présentées comme une corruption : la matrice garde leurs périmètres/versions respectifs. Les preuves anciennes, y compris les six audits d’objetsV1175–1180 et V1181, ne sont pas republiées ou requalifiées.

## 7. Livraison, contrôle de clôture et limites

Livrables de ce lot sur `E:\mapslol3v3\audit_sys01202_passive_reuse_12_20261103` : extraction/reçu préparés, `consolidate_reuse.py`, `reuse_matrix.json`, ce rapport, et publisher documentaire gardé **non exécuté** lors de la préparation. L’unité de consolidation satisfait les sept rubriques dans sa frontière documentaire : question/fin, sources, consommateurs, attendu/observé, écarts/reprise, correction, preuves/limites. La relecture indépendante et la publication documentaire doivent être tracées séparément ; elles ne clôturent aucune tâche SOURCE.

Le publisher n’autorise que le nouveau rapport et l’append de notes V1182 dans `docs/ai/CURRENT.md` et `HANDOFF.md`. Il épingle l’extraction, la matrice, les scripts, les petites preuves documentaires et les six entrées de l’extraction ; parmi elles les **trois registres** trace/sources/inconnues. Il contrôle aussi les **cinq JSON protégés** avant/après (plan, checkpoint, trace, sources, inconnues), et refuse tout doublon ou dérive. Aucune installation/migration, aucun changement du produit, des bases ou du goal n’appartient à cette livraison. SYS-01.2-02 et le jeu restent ouverts.
