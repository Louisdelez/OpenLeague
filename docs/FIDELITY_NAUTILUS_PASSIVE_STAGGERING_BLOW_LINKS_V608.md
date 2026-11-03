# SYS-01.2-02 — Nautilus : sources et consommateurs de Staggering Blow (V608)

Date UTC : 2026-10-26T11:16:00.355247+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315, EUW/en_GB ; build littéral2014-11-17 à17:46:45, fuseau et date de déploiement non établis. Catalogue4.20.1 distinct.

## Résultat

Les trois fiches CH-Nautilus-PASSIF-SOURCE, CH-Nautilus-PASSIF-SIMULATION-CONTRAT et CH-Nautilus-PASSIF-SIMULATION sont reliées à79sources natives,237associations,31points du moteur et62liens sur les deux fiches de simulation. Les points sont qualifiés comme frontières/contextes, sans implémentation complète du passif. SYS-01.2-02 reçoit la synthèse. Aucun code de gameplay ni asset modifié, aucune tâche clôturée.

Les textes natifs décrivent dégâts physiques supplémentaires, immobilisation et immunité temporaire propre à la cible. Dans les deux simulations actuelles, premier coup et coups répétés infligent uniquement les dégâts ordinaires ; la cible bouge aux trois ticks suivant le premier impact. Ce résultat démontre l’écart du chemin exécuté, sans inventer les valeurs historiques f1/f2/f3 ni qualifier le délai par cible.

## Sources et limites

- Nautilus.inibin lie NautilusPassive, l’icône Nautilus_StaggeringBlow.dds et les clés du nom/description. Les textes en_GB lignes4239/4415 identifient Staggering Blow.
- NautilusPassive.inibin lie le tooltip ligne2340 : f1 dégâts physiques bonus, immobilisation f2secondes et délai f3secondes pour une même cible. PassiveCheck ligne2341 décrit l’immunité temporaire ; PassiveRoot ligne2342 décrit l’impossibilité de bouger. Onze clés BuffData se résolvent exactement dans le fichier lu.
- Passive1=9, Passive1Level1..4=3/7/11/15, les deux derniers absents. Ces valeurs n’ont pas été transformées en dégâts, niveaux ou durées acceptés. Les champs SpellData sélectionnés des trois INIBIN passifs sont absents ; absence ne vaut pas zéro.
- Les descriptions héritées mentionnent Jax et les objets AD, puis mana40/60/80%. Elles ne deviennent pas des règles Nautilus.
- Nautilus.ddf :8lignes, seules W/PiercingGaze f1=bonushealth×0,1 et Q/AnchorDrag f1=@special.nautilusq×0,5 sont non vides. Ces variables n’ont pas la portée de f1/f2/f3 du passif.
- CharScript natif : initialisation vide. CharScript communautaire : classe vide. Aucun callback de passif exécuté n’est identifié dans ces fichiers.
- Trente-trois Lua intégralement parcourus, aucun prototype enfant :23initialisations littérales,10limites NEWTABLE (AnchorDrag, AnchorDragMissile, GrandLineTarget, PiercingGaze, PiercingGazeShield, RavageStrikeAttack, SplashZone, SplashZoneHit, SplashZoneMarker, SplashZoneSplash). Limite du lecteur ne signifie pas corruption.
- Passive.luaobj expose l’icône3114_Malady.dds, BuffName et flags de persistance. PassiveRoot expose l’icône StaggeringBlow, le popup Snared et PersistsThroughDeath. PassiveCheck expose nom, icône, emplacements d’effets vides et persistance. Ce ne sont pas des producteurs de dégâts, de racine ou de délai par cible.
- Le contexte Backswing emploie LuxShield/LuxPrismaWrap. Les alias Malady/Lux ne prouvent pas des règles étrangères. Les indicateurs de persistance ne qualifient pas respawn, mort de cible ou dissipation.
- Dix-neuf preloads. PassiveRoot référence root, particules lv1/lv6/lv11/lv16 et autres effets. Leurs noms ne suffisent pas à déterminer les durées ou paliers, et ne qualifient pas le rendu. Le résolveur/exécution de la dépendance root n’est pas démontré par ce preload.
- Cinq chemins candidats absents : CharScript à la racine du personnage, Passive.inibin/.luaobj dans Characters/Nautilus/Spells, PassiveCheck.preload et Passive.ddf dans DATA/Spells. Les ressources sélectionnées existent dans Scripts et DATA/Spells. Aucun manque global de modèles/textures/animations/sons n’est déduit.
- Aucun NightmareBotNautilus dans les deux emplacements inspectés. Cette observation n’est pas un inventaire universel de variantes.
- Trente références communautaires gardent leur provenance distincte. Q applique Root0,5s dans le corps lu, sans déplacement de hook démontré ; le commentaire « pulls » n’est pas une implémentation. W délègue à NautilusShield6s : son effet complet n’est pas qualifié ici. R utilise un timer1s puis dommages/zone300, pas une qualification de trajet natif. E programme trois timers de0,4s et Slow2s ; aucune recette QWER complète n’est revendiquée.

Les79sources (25INIBIN,33Lua,19preloads,1DDF,1font) sont vérifiées par taille/SHA-256 et appartenance RADS sélectionnée. Les sources communautaires sont distinguées du serveur original et du code Rust actuel.

| Fichier | Source |
|---|---|
| Nautilus.inibin | OLS-d0e189ae-d425-50bf-8f79-d49cbde97d57 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Nautilus.ddf | OLS-bd3b5c24-968f-5828-9a99-0c3f3eebe9a8 |
| CharScriptNautilus.luaobj | OLS-e6a20659-1656-52f7-b44b-a98a6e969c95 |
| CharScriptNautilus.preload | OLS-8b34fb67-dec4-5614-9562-77023dfe3ac1 |
| NautilusAnchorDrag.inibin | OLS-b58db8db-358c-5c1b-b756-e9b35f6147c1 |
| NautilusAnchorDrag.luaobj | OLS-f6bd8d92-1c99-5f96-8dc5-6ccb24ebc5c0 |
| NautilusAnchorDragGlobalRoot.luaobj | OLS-910897ec-ad5f-5125-817a-4eaaca677dc5 |
| NautilusAnchorDragMissile.inibin | OLS-a9bb3a0e-0300-512d-93cd-6f61e259b229 |
| NautilusAnchorDragMissile.luaobj | OLS-0c2ab4c6-d1b8-5b9f-820d-d164bb6f742f |
| NautilusAnchorDragMissile.preload | OLS-e2b6ccdc-b310-5292-997d-bb006e34797d |
| NautilusAnchorDragRoot.inibin | OLS-e4c9b1b4-a325-5ea9-b7de-c008541a56ef |
| NautilusAnchorDragRoot.luaobj | OLS-731c1388-59db-50fc-9fa4-d3dc5ddfa667 |
| NautilusAnchorDragRoot.preload | OLS-a12e25fc-3c84-5f5a-ae63-fdde999ba4ff |
| NautilusBackswing.luaobj | OLS-218113b1-a23a-53f8-af5d-45acf06b85cf |
| NautilusBackswingAttack.inibin | OLS-52ffbf1d-73e6-589a-9893-e769052ea159 |
| NautilusBackswingAttack.luaobj | OLS-5dc04efc-61a2-5ca8-9f94-862c680a2d51 |
| NautilusBackswingAttack.preload | OLS-b4b55737-6b3e-5326-9729-8be5a28092d7 |
| NautilusBasicAttack.inibin | OLS-9d0b6ec2-8b37-5f89-9933-75a1b2e3de96 |
| NautilusBasicAttack2.inibin | OLS-ab52049d-b680-536e-a550-a01b64e39c3c |
| NautilusCritAttack.inibin | OLS-cf71484a-9e02-58a1-95d9-318701bf1294 |
| NautilusFacingFix.luaobj | OLS-dd1c926e-5af7-50b1-8e5a-0931fdf5475f |
| NautilusGrandLine.inibin | OLS-8fbc3e60-551e-517a-8127-17cfc2b30ad5 |
| NautilusGrandLine.luaobj | OLS-feba5cfa-d177-5cb1-8439-767f66341a50 |
| NautilusGrandLine.preload | OLS-7694be51-e2ab-5937-9b96-ed8dc3b8cf2c |
| NautilusGrandLineHit.luaobj | OLS-705a9579-7da0-5859-9f17-d2c91d9fa1ac |
| NautilusGrandLineStart.inibin | OLS-6e77cb69-3a6c-5e8e-9705-55a4b36bfff5 |
| NautilusGrandLineStart.luaobj | OLS-9b3f9b13-8026-51e7-a44d-d5d9f021b586 |
| NautilusGrandLineStart.preload | OLS-d996dee1-fd52-5917-9374-680e36073e24 |
| NautilusGrandLineTarget.inibin | OLS-40c3c2c0-ed5e-57f9-9671-85a5ca93ebe8 |
| NautilusGrandLineTarget.luaobj | OLS-a854011c-4262-5c99-b43a-407e3edc61f5 |
| NautilusGrandLineTarget.preload | OLS-20d6562f-3060-5fe9-8645-03cd4717284c |
| NautilusGrandLineTracker.luaobj | OLS-7c95398c-8d91-513a-bdcd-f7fc40000b94 |
| NautilusGrandLineTracker.preload | OLS-6da5376b-3363-5cfd-b651-d7684641079b |
| NautilusKnockAway.luaobj | OLS-9896b005-96fb-53f6-a651-f54657dbac47 |
| NautilusKnockAway.preload | OLS-ec3f6ddd-479d-5c6b-83f3-fb049af409cc |
| NautilusKnockUp.inibin | OLS-351cdda3-a30f-5b84-bcab-88a087d169ff |
| NautilusKnockUp.luaobj | OLS-bc16b8d6-372e-5391-8f28-323c87ea75d2 |
| NautilusMinorKnockAway.inibin | OLS-a70fa2ab-30a3-5fb1-8c07-404403aa3d02 |
| NautilusMinorKnockAway.luaobj | OLS-68f9f021-c65a-5299-8ab7-2cd2482b8298 |
| NautilusMinorKnockAway.preload | OLS-ead54e1e-2179-5e64-8da3-4c8f321c9470 |
| NautilusMinorKnockUp.inibin | OLS-659ab5f8-9fd7-53dc-afb4-a0fad278c1fd |
| NautilusMinorKnockUp.luaobj | OLS-027887ca-1c76-526d-a6e2-55e5dc024ae3 |
| NautilusPassive.inibin | OLS-7d2fc9c4-e89b-5bf2-ae2d-d9a8c03881cd |
| NautilusPassive.luaobj | OLS-8c165d65-9c93-5164-8b63-ffb384523a59 |
| NautilusPassive.preload | OLS-8e94e375-8f8c-516c-8d45-de1b6586a3f8 |
| NautilusPassiveCheck.inibin | OLS-fe17d9fb-4638-564f-a8fb-7b66c02de67c |
| NautilusPassiveCheck.luaobj | OLS-eebee96c-dbdb-5dbd-ba7e-32229a42b065 |
| NautilusPassiveRoot.inibin | OLS-952df1e9-7b75-5f6a-89da-cd14524fcbde |
| NautilusPassiveRoot.luaobj | OLS-88f69398-2eb6-5c3d-b966-9c38422dfc9a |
| NautilusPassiveRoot.preload | OLS-00983fb7-575e-5c14-a384-d3fd31337858 |
| NautilusPiercingGaze.inibin | OLS-a88ca15a-e526-53d3-bb32-7cd41b33ca70 |
| NautilusPiercingGaze.luaobj | OLS-be6c69c8-e75b-5d67-9389-be7e1b8f958f |
| NautilusPiercingGaze.preload | OLS-b8287613-53e8-52cc-bbcb-6c78d6322839 |
| NautilusPiercingGazeShield.inibin | OLS-9a094a1c-09b9-5d0d-b5af-3b2f632f6831 |
| NautilusPiercingGazeShield.luaobj | OLS-b6dcd17d-b16f-5620-9cf8-b78d4350cdc3 |
| NautilusPiercingGazeShield.preload | OLS-c5e4f841-8280-5a31-919c-4a6e10881ee5 |
| NautilusPiercingGazeShieldHit.luaobj | OLS-7fdf14b7-939a-5e85-9a41-95764b5bd700 |
| NautilusRavageStrikeAttack.inibin | OLS-6cfc6406-946e-5d38-a941-97b111efb2da |
| NautilusRavageStrikeAttack.luaobj | OLS-98f5e525-42b5-5fb1-910c-140d63c31e4f |
| NautilusRavageStrikeAttack.preload | OLS-7ca22a97-0d00-54f5-8915-df500051514b |
| NautilusRunOverride.luaobj | OLS-c5f578b5-fc49-5b6c-8895-8594df4b0a45 |
| NautilusRunOverride2.luaobj | OLS-4983bc6f-6155-599f-a9d0-ac3195a5e7ff |
| NautilusSplashZone.inibin | OLS-f6b11657-6bf1-5d0d-a802-8203324b1403 |
| NautilusSplashZone.luaobj | OLS-260d3f6a-bf74-587b-a3c0-0b32ca0acc28 |
| NautilusSplashZone.preload | OLS-d8d97d67-8b00-5826-84fa-37bf7b2ef37a |
| NautilusSplashZoneHit.luaobj | OLS-d608ba43-b3c4-50fc-a6fa-0aab7d1e55fe |
| NautilusSplashZoneMarker.luaobj | OLS-600ac1e3-8dfc-5da4-a50e-037f2405e44f |
| NautilusSplashZoneSlow.inibin | OLS-b988a2e8-be83-584a-8260-95737b2580b0 |
| NautilusSplashZoneSlow.luaobj | OLS-539b097a-158b-51d6-bd94-a2640a683d6a |
| NautilusSplashZoneSplash.inibin | OLS-805c9271-0b14-5fe5-8fd9-b145b76f3957 |
| NautilusSplashZoneSplash.luaobj | OLS-1f590516-3e62-5862-bdf1-5ca7ac88faa2 |
| NautilusSplashZoneSplash.preload | OLS-72c25719-67b6-5b96-b963-34ba81c53706 |
| NautilusWDoT.inibin | OLS-fac4c5ee-9259-53ad-ace1-5708fc5de444 |
| NautilusWDoT.luaobj | OLS-2cbec201-c9e6-5095-8440-285fbb810039 |
| NautilusWDoT.preload | OLS-13a5def5-852e-5ee9-ae41-3d5f5c057268 |
| NautilusWideswingAttack.inibin | OLS-3e9faa76-22be-5871-b70d-0cb577c79109 |
| NautilusWideswingAttack.luaobj | OLS-8619326c-f0ff-5377-96a2-c6efe9347cc1 |
| NautilusWideswingAttack.preload | OLS-5fbf4883-68be-5fe9-ab2c-aa9019523359 |

## Contrôles réellement exécutés

Prérequis de phases/lots, trois questions propres et quatre dépendances conservés. Compilation Rust `--locked --offline` avec core réel hors configuration de test et dépendances alignées sur Cargo.lock. Les1158entrées core/ressources et la chaîne de preuves antérieures sont conservées.

Deux parties publiques Nautilus/Annie : sans objet puis Épée longue1036(+10AD). Aucun soin, dégât, niveau, contrôle ou position injecté directement. Join/Buy/Move/Stop/Attack/Learn/Cast utilisent les vraies routes. Tous restent vivants, niveau1, sans victoire, bouclier, ralentissement ou étourdissement. Nautilus conserve ses rangs/délais nuls et son mana plein. PVmax576,47998 ; manamax284.

| Cas | AD | AP | Vol de vie | Soin hors régénération | Refus | Ticks d’attente |
|---|---:|---:|---:|---:|---:|---:|
| base | 57.54400 | 0.0 | 0.00000 | -0.00001 | 27 | 180 |
| LongSword10AD | 67.54400 | 0.0 | 0.00000 | -0.00001 | 27 | 180 |

Chaque cas reçoit trois attaques physiques Annie puis un Q brut80/coût60, attend90ticks, produit trois attaques Nautilus puis attend90ticks. Totaux :6impacts mêlée,6impacts physiques entrants,2Q et360ticks d’attente. Quatre trajets de préparation aboutissent sans reprise. Ils ne résolvent ni V564 ni les deux échecs d’arrivée V606.

Attendu pour les attaques ordinaires actuelles : AD après mitigation d’armure, sans bonus Nautilus. Observé sans objet :48,267059PV par coup, attendu48,267067 ; avec Épée :56,654907 à56,654938, attendu56,654922. Résidus inférieurs à0,002, y compris pour les dégâts entrants corrigés de régénération. Chaque coup Nautilus possède un témoin windup avec cible et tick de libération ; ceux d’Annie un projectile non critique. Aucun supplément de dégâts observé au premier coup ou aux répétitions.

Immédiatement après le premier impact (tick2205), le test arrête Nautilus puis ordonne Move à Annie vers un point éloigné de100unités. Aux ticks2206/2207/2208, elle parcourt11,166504unités à chaque fois, pour335unités/s, dans les deux cas. Six échantillons attestent l’absence d’immobilisation à ces instants. La cible est ensuite arrêtée et Nautilus reprend ses attaques. Ce test ne mesure pas une durée de racine native puisque aucune racine n’est produite.

Le vol de vie est nul dans les deux cas. La variation de santé du lanceur correspond à la régénération seule, écart d’arrondi d’environ−0,000010PV sur impact. Ce contrôle évite de confondre régénération et effets supplémentaires ; il ne qualifie pas les règles de soin du jeu entier.

Les54refus atomiques couvrent joueur inconnu, auto-ciblage, slot invalide et apprentissage/lancement ciblé/au sol des quatre sorts avant/après. Tous conservent le snapshot. Aucun sort Nautilus accepté.

Compilation et exécution renvoient0. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-nautilus-passive-staggering-blow-probe.exe` ; 6131200octets ; SHA-256 `e1a737e4baf424f18162e48f6955ecaff21a646ce5a5b7ee54afff93eeed5903`. Inspection renvoie0. Aucun serveur historique, rendu, audio ou transport réseau exécuté. Les limites et échecs antérieurs restent conservés dans la chaîne.

## Consommateurs réels et distinction des contrôles

La recherche enregistrée dans les fichiers Rust de crates/core/src ne trouve pas Nautilus/Staggering Blow et variantes choisies. Ce constat lexical est complété par lecture de stats/attaques/dégâts/actions/mouvement et par l’exécution, sans conclure à une absence universelle dans tout le projet.

Le moteur possède des événements génériques d’étourdissement et des restrictions d’actions correspondantes. **Un étourdissement générique n’est pas une implémentation de la racine native de Nautilus.** Ses API sont liées comme contexte et n’ont pas été injectées pour simuler une réussite. Les autorisations d’attaque/sort, déplacements forcés, ténacité et nettoyage spécifiques au passif restent à établir. Aucun marqueur de délai par couple source-cible n’est qualifié. Attendre90ticks ne démontre pas son expiration.

Huit ressources locales (catalogue, croissance, ressources, attaques, critiques, collisions, boutique et QAnnie) sont reliées séparément des sources natives. Snapshot, récapitulatif et soin générique restent des contextes ; ils ne prouvent pas la présentation ou le réseau.

| Ancre exacte | Rôle qualifié |
|---|---|
| crates/core/src/lib.rs:533 | ordinary Nautilus spawn |
| crates/core/src/lib.rs:598 | public action andatomic refusal |
| crates/core/src/progression.rs:68 | ordinary AD inputs without passive bonus |
| crates/core/src/progression.rs:150 | unsupported Nautilus learning |
| crates/core/src/progression.rs:159 | unsupported Nautilus ranks |
| crates/core/src/spells.rs:101 | unsupported Nautilus spell action |
| crates/core/src/annie_w.rs:29 | unsupported Nautilus ground cast |
| crates/core/src/lib.rs:685 | tick order and360idle ticks |
| crates/core/src/lib.rs:744 | state witnesses,notnetwork acceptance |
| crates/core/src/damage.rs:53 | ordinary physical/magic damage and lifesteal basis |
| crates/core/src/attacks.rs:157 | Nautilus melee and Annie ranged attacks |
| crates/core/src/lifesteal.rs:4 | ordinary physical hit and item lifesteal context |
| crates/core/src/regeneration.rs:32 | ordinary HP regen separated fromhealing |
| crates/core/src/regeneration.rs:10 | per-tick health correction |
| crates/core/src/shop.rs:261 | LongSword10AD |
| crates/core/src/shop.rs:215 | ordinary item inputs |
| crates/core/src/world.rs:226 | ordinary target state |
| crates/core/src/damage.rs:38 | postmitigation damage andlifesteal basis |
| crates/core/src/attacks.rs:26 | ordinary attack timing |
| crates/core/src/critical.rs:12 | ordinary critical attack profile context |
| crates/core/src/death_recap.rs:184 | context,notrendered recap |
| crates/core/src/death_recap.rs:200 | damage recap context |
| crates/core/src/healing.rs:16 | ordinary item healing;notpassive producer |
| crates/core/src/healing.rs:9 | generic received healing context;Ignite/Trundle modifiers unexercised |
| crates/core/src/annie.rs:45 | two accepted Q80raw60mana |
| crates/core/src/annie.rs:73 | two incoming Q hits |
| crates/core/src/ally_occupancy.rs:635 | four actual public travels,no reorders |
| crates/core/src/ally_occupancy.rs:526 | movement boundary,V564 remains open |
| crates/core/src/stuns.rs:6 | generic stun context, not root |
| crates/core/src/stuns.rs:15 | authoritative stun event not invoked as passive producer |
| crates/core/src/stuns.rs:37 | generic expiry cleanup not per-target passive immunity |

## Publication et conservation

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json, docs/fidelity_requirement_trace_4_20.json. Reçu docs/reference_requirement_trace_sources/nautilus-passive-staggering-blow-links-v608.json ; preuve docs/fidelity_nautilus_passive_staggering_blow_links_v608.json. Instructions copiables précisant sources, écarts, cas non couverts et travail restant intégrées au plan et aux deux bases locales.

PREPARE/CHECK/PUBLISH/AUDIT :0. Les72associations altérées et4graphes invalides sont refusés. Trois fragments de traçabilité changent,42212restent identiques. Quatre destinataires par base,42603autres lignes,42607états manuels et23historiques conservés. Synchronisation normale idempotente. Identifiants, phases/lots et inconnues inchangés octet par octet. Aucun statut, critère, propriétaire, case ou note clôturé automatiquement.

Revue globale :99109sources,4236consommateurs et4236ancres exactes sans divergence. Vérification globale structurelle (`source_hashes_verified=0`) ; sources sélectionnées/code hachés séparément. Aucun recontrôle exhaustif de toutes les sources revendiqué.

coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md actualisés avec conservation des preuves. Aucun stage/reset/commit/nettoyage.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision608_Nautilus_discovery/OBSERVATIONS.json ; revision608_Nautilus_passive_probe/OBSERVATIONS.json ; revision608_Nautilus_inspection/OBSERVATIONS.json ; revision608_Nautilus/DELIVERY_AUDIT.json ; revision609_trace_review/REVIEW.json.

## Travail restant

1. Résoudre f1 dégâts, f2 immobilisation, f3 délai par cible et leurs paliers sur preuves4.20.
2. Implémenter le vrai producteur attaque→bonus/racine/marqueur sans substituer un étourdissement.
3. Vérifier premier coup, répétitions avant/à/après délai, alternance de cibles et plusieurs Nautilus.
4. Qualifier catégories de cibles, immunités, critiques, W renforcée, dégâts zéro/bouclier/surdégâts.
5. Définir attaques/sorts sous racine, déplacements forcés, ténacité et interactions avec autres contrôles.
6. Tester mort, respawn, dissipation, annulation d’attaque, sortie de portée, déconnexion et fin de partie.
7. Comparer les QWER communautaires et résoudre leurs consommateurs avant toute adoption.
8. Qualifier séparément particules, animations, audio, HUD, rendu et réseau.

Les trois fiches Nautilus conservent leurs états ouverts. Les limites Battle Training et navigation restent ouvertes. Goal actif.

Suite : Continuer SYS-01.2-02 depuis revision609_trace_review/REVIEW.json. V608 Nautilus / Staggering Blow :79 sources natives,237 associations,31 points et62 liens. Tooltip : dégâts physiques bonus f1, immobilisation f2 secondes, immunité sur la même cible f3 secondes ; valeurs, niveaux et politique détaillée inconnus. Passive1=9, niveaux3/7/11/15 et anciens textes Jax/mana conservés sans adoption. Deux cas publics base/Épée10AD :6attaques mêlée,6physiques entrants,2Q Annie,360ticks et54 refus atomiques. AD57,544/67,544 ; dégâts ordinaires seuls, aucun bonus. Après le premier impact, cible mobile aux3ticks suivants à335unités/s :6échantillons de11,16650unités, aucune immobilisation observée. Aucun sort Nautilus accepté, immunité par cible non qualifiée. 33Lua dont10limites NEWTABLE,19preloads,11buffs résolus,8DDF dont coefficients Q/W non passifs,30références communautaires. CharScripts vides ; métadonnées Malady/Lux non adoptées comme règles étrangères. Q communautaire pose Root0,5s sans déplacement dans le corps lu ; W délègue à un buff ; R utilise un timer1s. Ces scripts ne sont pas le serveur original ni des consommateurs Rust. Cinq chemins candidats absents sans absence globale d’assets. Quatre trajets de préparation réussis sans reprise ; V564 et échecs V606 ouverts. Aucun gameplay modifié. BUILD/RUN/inspection/PREPARE/CHECK/PUBLISH/AUDIT0 ;72+4refus de publication. Prochain passif à inspecter réellement : Nidalee. Goal actif.
