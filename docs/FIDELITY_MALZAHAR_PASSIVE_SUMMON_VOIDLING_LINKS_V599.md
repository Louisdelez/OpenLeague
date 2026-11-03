# SYS-01.2-02 — Malzahar : sources et consommateurs du passif (V599)

Date UTC : 2026-10-26T08:19:20.895197+00:00. Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315, EUW, en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement non établis. Catalogue officiel 4.20.1 distinct.

## Résultat et portée

Les fiches CH-Malzahar-PASSIF-SOURCE, CH-Malzahar-PASSIF-SIMULATION-CONTRAT et CH-Malzahar-PASSIF-SIMULATION sont reliées aux sources vérifiées et aux limites du moteur actuel. 57 sources natives produisent 171 associations ; 29 points de code produisent 58 liens sur les deux fiches de simulation. Tous ces points restent qualifiés comme frontières ou contexte, sans consommateur complet du passif démontré.

Les sorts Malzahar sont refusés dans les cas publics exécutés. Aucune créature n’est produite. Ce lot termine une amélioration de traçabilité ; il ne termine ni le passif, ni le champion, ni le jeu, ni SYS-01.2-02 globalement. Aucun code de gameplay ou asset modifié.

## Sources retrouvées et limites

- Le fichier Malzahar.inibin lie AlZaharSummonVoidling et AlZahar_SummonVoidling.dds à la description en_GB. Les niveaux Passive1Level1..6 sont absents (None), sans valeur de remplacement inventée.
- Description en_GB ligne 4229 : après quatre sorts, créature non contrôlable durant 21 secondes ; PV 200 + 50 × niveau et dégâts 20 + 5 × niveau ; croissance à 7 secondes (+50 % dégâts/armure) et frénésie à 14 secondes (+100 % vitesse d’attaque).
- Buffs lignes 1680–1685 : tooltip dynamique @f1@/@f2@/@f3@, compteur quatre sorts, état prêt au prochain sort, créature et phases. Les producteurs des variables et leur relation exacte au niveau et à l’AD du propriétaire restent ouverts.
- MalzaharVoidling.inibin expose les bases 200 PV, HPPerLevel 0, dégâts 20, armure 30, résistance magique 50, portée 125, vitesse 460 et rayons 20/10. Ces valeurs statiques ne prouvent pas le calcul final d’une créature invoquée. Les valeurs sont conservées avec leurs types natifs.
- 23 fichiers Lua ont été intégralement lus : initialisations littérales, aucune fonction enfant. Aucune limite NEWTABLE dans ce lot, mais aucune exécution du serveur historique. CharScriptMalzahar est vide ; la classe communautaire correspondante est également vide.
- 13 preloads relient les quatre sorts à SummonVoidling/Count et l’invocation à MalzaharVoidling, AlZaharVoidling et ifhasbuffcheck. Phase2/Phase3 préchargent des effets ; leur rendu n’a pas été vérifié ici.
- Les alias sont conservés : SummonVoidling.luaobj configure le buff Ready ; Count configure SummonVoidlingBuff ; Detonation configure SummonVoidling avec persistance. DanceOverride conserve NautilusPassive/3114_Malady.dds ; le missile Q conserve EzrealEssenceFluxDebuff/FallenAngel_DarkBinding.dds. Aucun comportement d’un autre champion n’est déduit de ces noms.
- Neuf clés BuffData sont résolues une fois chacune, dont Malefic Visions : attraction des créatures vers les unités affectées. Une phrase de tooltip ne spécifie pas toute l’IA et ses priorités.
- 25 références communautaires sont identifiées par taille/SHA-256 et conservées comme références secondaires. Treize fichiers NightmareBotMalzahar sont recensés et exclus du contrat standard.
- Six chemins candidats sont absents : CharScript au mauvais emplacement racine, passif sous Characters/Spells, Malzahar.ddf, CharScriptMalzaharVoidling sous Scripts, et Lua dédiés SummonVoidlingBuff/Ready. Les fichiers réels sous Scripts et DATA/Spells sont présents. Ces absences ne démontrent pas un manque global de modèles, textures, animations ou sons.

Chaque source native est comparée au registre et au manifeste RADS sélectionné. La liste ci-dessous donne ses identifiants stables ; chemins, tailles, hashes et résultats détaillés figurent dans la preuve de découverte.

| Fichier | Source |
|---|---|
| Malzahar.inibin | OLS-46e341da-a741-5550-848b-be5ebb08d6e0 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| MalzaharVoidling.inibin | OLS-e77f320a-243c-52d6-b56e-6c84308310ab |
| CharScriptMalzahar.luaobj | OLS-6347f85d-d328-5c93-9a3c-f40fd41a9b59 |
| CharScriptMalzahar.preload | OLS-43f72928-5041-5304-8ab9-4f2a0e2f0678 |
| AlZaharCalloftheVoid.inibin | OLS-f04d949e-6f94-50e0-bf6c-6131f6fe4ada |
| AlZaharCalloftheVoid.luaobj | OLS-8192d296-032b-5e01-9c20-a6140a3a8b5e |
| AlZaharCalloftheVoid.preload | OLS-7617771e-7932-5e22-92df-ad4d973a6a4b |
| AlZaharCalloftheVoidMissile.inibin | OLS-db632e96-da11-583a-af92-9529908c4ab7 |
| AlZaharCalloftheVoidMissile.luaobj | OLS-964ab085-cf23-57e9-847d-697e1471d928 |
| AlZaharCalloftheVoidMissile.preload | OLS-078775bf-3caa-51ab-ad1e-a69128c2ddba |
| AlZaharCallR.luaobj | OLS-90f6cf32-1c9f-5161-9296-2020045b3215 |
| AlZaharDeathParticle.luaobj | OLS-06471485-5ba9-5ee8-8db1-5aac55e1bf60 |
| AlZaharDeathParticle.preload | OLS-69623ded-cb13-5ee8-a123-d19048e5a757 |
| AlzaharInCombat.luaobj | OLS-388d9752-b8ec-51ff-abe9-881097de3d3a |
| AlZaharMaleficVisions.inibin | OLS-7eff7e53-f888-57e4-b46f-76d5025a1177 |
| AlZaharMaleficVisions.luaobj | OLS-12e288a4-3f60-577c-b251-78775bcfeaa4 |
| AlZaharMaleficVisions.preload | OLS-2770714a-239f-5979-8a72-8d9ce32851fe |
| AlZaharNetherGrasp.inibin | OLS-cbdd269d-ddb8-584c-b3af-2805f3696da7 |
| AlZaharNetherGrasp.luaobj | OLS-2958678d-ccee-5a32-a2ed-10f4ec9a39c4 |
| AlZaharNetherGrasp.preload | OLS-5665e141-b380-57eb-bcb9-3c832657992b |
| AlzaharNetherGraspOn.luaobj | OLS-b1d68f5c-9b83-55fa-81ec-9336a94ba29f |
| AlzaharNetherGraspSoftLock.luaobj | OLS-4b4b166c-dcd9-5201-9a69-15f7b299d553 |
| AlZaharNetherGraspSound.inibin | OLS-0aba2801-7e76-5fc9-a569-01e14dc776c7 |
| AlZaharNetherGraspSound.luaobj | OLS-a9e95212-dab6-5f8f-8263-b016cffee134 |
| AlZaharNullZone.inibin | OLS-5b652b6c-8404-5272-a3d1-458e8d60105e |
| AlZaharNullZone.luaobj | OLS-e9ffd44f-822a-5fe2-aba1-2ca1ec1e1142 |
| AlZaharNullZone.preload | OLS-c1941b0d-a899-5fad-8f52-9194ceb42f40 |
| AlZaharRecentVis.luaobj | OLS-3791aee1-9c8d-5914-adac-7939d8645f30 |
| AlZaharSummonVoidling.inibin | OLS-292d47d4-ceda-584b-8b4f-dff8d3a5f490 |
| AlZaharSummonVoidling.luaobj | OLS-5dfdc61c-4837-5f5d-9ed1-a427f8f8a717 |
| AlZaharSummonVoidling.preload | OLS-30ffebb3-3274-56d9-aeb5-2fdbad7b692f |
| AlZaharSummonVoidlingBuff.inibin | OLS-77a9a9d9-6c81-545d-b761-cd0e747de435 |
| AlZaharSummonVoidlingReady.inibin | OLS-40859d2b-0d03-5d3d-81ad-f2a301dab4f7 |
| AlZaharVoidling.inibin | OLS-49d186f4-ecb8-5433-9d85-862c848b5666 |
| AlZaharVoidling.luaobj | OLS-1b31d315-5421-5aa8-b96d-638634163422 |
| AlZaharVoidling.preload | OLS-ef51768e-2dc8-5d50-9ab9-478e60799766 |
| AlZaharVoidlingCount.luaobj | OLS-30b289a6-76a7-5be4-b9e3-7e6b4c8a7481 |
| AlZaharVoidlingCount.preload | OLS-7dc022cb-5d9c-56f2-b558-058f29551ded |
| AlZaharVoidlingDetonation.luaobj | OLS-cc0ab63f-ff79-5b6d-9ef6-b83c7b9682c0 |
| AlZaharVoidlingDetonation.preload | OLS-176e99f1-f2b7-5f4e-8257-1646c161dbe1 |
| AlZaharVoidlingPhase2.inibin | OLS-2e969b4b-e95b-5ff2-8d4d-f96b9395968f |
| AlZaharVoidlingPhase2.luaobj | OLS-b4d64509-74ad-5c4a-a752-fa531995b9ab |
| AlZaharVoidlingPhase2.preload | OLS-558b296b-4fc5-5be0-a9ba-2e64e5c54edd |
| AlZaharVoidlingPhase3.inibin | OLS-b100a32e-49b3-5c5b-a057-b79085ac815e |
| AlZaharVoidlingPhase3.luaobj | OLS-98723929-9b1c-542b-9a37-35d38dee06b9 |
| AlZaharVoidlingPhase3.preload | OLS-4c3695ff-6b1d-5ff3-828f-0bfbdfe81522 |
| MalzaharBasicAttack.inibin | OLS-edb59baa-65b5-5bc9-a646-aba4051c5be6 |
| MalzaharBasicAttack2.inibin | OLS-e91ea191-d77c-55d5-9f7c-9640823a7b2d |
| MalzaharCritAttack.inibin | OLS-ff947cbb-82f0-51ce-a6d6-4069a35de344 |
| MalzaharVoidlingBasicAttack.inibin | OLS-5315f2c4-c509-5f9e-80fd-fc992692dab5 |
| MalzaharVoidlingBasicAttack.luaobj | OLS-7d452ee8-b4b6-5271-b660-043625e88a95 |
| MalzaharVoidlingBasicAttack2.inibin | OLS-21739375-0fd6-528e-b467-0283a55b65c8 |
| MalzaharVoidlingBasicAttack2.luaobj | OLS-184622bb-5619-5022-80a4-5940d95d7cc4 |
| MalzaharVoidlingBasicAttack3.inibin | OLS-3dbc7203-a858-5ab7-9498-4429f4f01589 |
| MalzaharVoidlingBasicAttack3.luaobj | OLS-5545df23-12cf-57c6-9953-1ee448ece591 |
| MalzaharVoidlingDanceOverride.luaobj | OLS-5ae91909-c78a-5c5f-932e-9d7604ca0f84 |

## Contrôles exécutés

Compilation Rust `--locked --offline`, core réel non compilé comme test, identités et checksums des dépendances alignés sur Cargo.lock du projet. Exécution locale de Simulation sur Map10 par les commandes publiques Join/Buy/Move/Stop/Attack ; aucune injection directe d’état et aucun appel artificiel de création de pet.

| Cas | AD champion | Mana maximum | Impacts physiques | Refus atomiques | Ticks après Stop |
|---|---:|---:|---:|---:|---:|
| base | 54.70000 | 325.60001 | 3 | 123 | 631 |
| LongSword_AD_control | 64.70000 | 325.60001 | 3 | 123 | 631 |

Attendu et observé : six impacts physiques ordinaires correspondent aux projectiles du propriétaire et à la mitigation par armure, résidu inférieur à 0,002 ; six identités de projectile. L’épée longue augmente l’AD de 10, sans vérifier un héritage de dégâts par une créature absente. Mana pleine, rangs et délais nuls, champions vivants de niveau 1, aucun étourdissement/ralentissement, aucune victoire ou mort dans les gardes.

Les 246 commandes refusées conservent exactement le snapshot : joueur inconnu, auto-ciblage, slot invalide, apprentissage et lancement Q/W/E/R ciblé ou au sol. Aucune consommation de mana, aucun sort Malzahar accepté, aucun pet et aucune unité dont la définition contient voidling.

Les offsets 209/210/211, 419/420/421 et 629/630/631 sont observés après Stop. Ils encadrent les durées textuelles de 7/14/21 secondes à 30 ticks/s mais **ne valident ni croissance, ni frénésie, ni expiration** : aucun déclenchement de passif ou horloge de créature n’existe dans ces cas. Attendre ne remplace pas quatre lancers acceptés.

Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-malzahar-passive-summon-voidling-probe.exe` ; 6057472 octets ; SHA-256 `9de2b41239abe6ede81fa6941f71ff40386a8488c88548a5054f8c125e6b41f9`. Les 1158 entrées du core et ressources, le verrou et la chaîne des preuves antérieures sont revérifiés et conservés.

## Consommateurs inspectés

Le chargeur Map10 insère explicitement annietibbers. Le catalogue local ne déclare pas de voidling. Les fonctions Annie R produisent Tibbers et ses statistiques, ordres, aura et expiration ; le type Unit.pet est actuellement Annie Pet. Ces acquis sont conservés. Aucun de ces constats ne prouve un compteur, une création, une IA ou une attribution Malzahar fonctionnelle.

| Ancre exacte | Rôle qualifié |
|---|---|
| crates/core/src/lib.rs:533 | public owner/enemy initialization |
| crates/core/src/lib.rs:598 | public action boundary |
| crates/core/src/progression.rs:68 | ordinary AD and target resistance |
| crates/core/src/progression.rs:150 | unsupported Malzahar learning |
| crates/core/src/progression.rs:159 | unsupported Malzahar rank policy |
| crates/core/src/spells.rs:101 | unsupported Malzahar cast |
| crates/core/src/annie_w.rs:29 | unsupported Malzahar ground cast |
| crates/core/src/lib.rs:685 | ordinary tick order |
| crates/core/src/lib.rs:744 | observed public state not network acceptance |
| crates/core/src/damage.rs:53 | ordinary physical impact boundary |
| crates/core/src/attacks.rs:157 | ordinary ranged launch and impact |
| crates/core/src/lifesteal.rs:4 | ordinary basic hit entry |
| crates/core/src/regeneration.rs:32 | ordinary health regeneration during waiting |
| crates/core/src/regeneration.rs:10 | ordinary target health regeneration correction |
| crates/core/src/shop.rs:261 | public LongSword10AD control |
| crates/core/src/shop.rs:215 | ordinary item bonuses |
| crates/core/src/world.rs:226 | current enemy identity |
| crates/core/src/damage.rs:38 | ordinary physical mitigation |
| crates/core/src/attacks.rs:26 | ordinary windup profile,not voidling attack cadence |
| crates/core/src/critical.rs:12 | ordinary critical profile;SummonVoidling critical policy not exercised |
| crates/core/src/death_recap.rs:184 | current ordinary capture context,not voidling-specific recap source |
| crates/core/src/death_recap.rs:200 | ordinary damage recap context,not accepted SummonVoidling attribution |
| crates/core/src/world.rs:185 | current world definition loader inserts Annie Tibbers,not MalzaharVoidling |
| crates/core/src/world.rs:265 | generic entity constructor;not invoked as voidling spawn |
| crates/core/src/annie_r.rs:20 | current pet attribution context;not exercised with voidling |
| crates/core/src/annie_r.rs:23 | current Annie pet lookup;not voidling consumer |
| crates/core/src/annie_r.rs:26 | Annie R cast context;not invoked in Malzahar diagnostic |
| crates/core/src/annie_r.rs:62 | Annie-specific spawn and statistics;no accepted summon here |
| crates/core/src/annie_r.rs:82 | current pet AI and expiry context;zero pets in both cases |

## Intégration et conservation

- Registre des tâches, registre des sources et graphe de traçabilité mis à jour ; reçu `docs/reference_requirement_trace_sources/malzahar-passive-summon-voidling-links-v599.json` et preuve `docs/fidelity_malzahar_passive_summon_voidling_links_v599.json`.
- Instructions copiables enrichies dans les deux bases SQLite, projet et application installée. Quatre destinataires seulement : les trois fiches et SYS-01.2-02. 42603 autres lignes, 42607 états manuels et 23 historiques conservés ; synchronisation normale idempotente.
- Les registres d’identifiants, phases/lots et inconnues sont identiques octet par octet. Trois questions propres et quatre dépendances sont conservées. Aucun statut, critère, propriétaire, note ou case coché automatiquement.
- PREPARE, CHECK, PUBLISH et AUDIT réussis avec code 0. 72 associations volontairement altérées et quatre graphes invalides sont refusés. Trois fragments de traçabilité changent, 42212 restent identiques.
- Revue globale : 99073 sources, 3991 consommateurs, 3991 ancres exactes, aucune divergence d’ancre. La validation structurelle globale ne relit pas chaque payload (source_hashes_verified=0) ; les hashes des entrées sélectionnées sont contrôlés séparément.
- `coverage.json`, `completion_plan.json`, `resume_checkpoint.json`, `docs/ai/CURRENT.md` et `HANDOFF.md` mis à jour ; champs et preuves antérieurs conservés. Aucun stage, reset, commit ou nettoyage.

Preuves détaillées privées : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision599_Malzahar_discovery/OBSERVATIONS.json ; revision599_Malzahar_passive_probe/OBSERVATIONS.json ; revision599_Malzahar_inspection_qualified/OBSERVATIONS.json ; revision599_Malzahar/DELIVERY_AUDIT.json ; revision600_trace_review/REVIEW.json. Les reçus de commande donnent les commandes et codes effectivement exécutés.

## Travail restant explicite

1. Qualifier puis implémenter le compteur et ses lancers éligibles, l’état initial, les refus, interruptions, doublons et événements simultanés.
2. Résoudre les producteurs @f1@/@f2@/@f3@, le niveau retenu, l’AD bonus et le moment de capture/recalcul des statistiques.
3. Relier une véritable création de créature au quatrième sort, avec identité, propriétaire, équipe, position, coexistence et nettoyage.
4. Tester croissance à 7 secondes, frénésie à 14 et expiration à 21 sur des créatures réellement créées, aux frontières temporelles et lors des événements simultanés.
5. Qualifier l’IA non contrôlable, déplacement/collisions, priorité Malefic Visions, portée/cadence, changement de cible et interactions Q/W/E/R.
6. Qualifier dégâts, effets à l’impact, attribution, récompenses, cibles, contrôles, protections et immunités, sans recopier aveuglément les règles de Tibbers.
7. Vérifier mort du propriétaire/créature, respawn, déconnexion, fin de partie, plusieurs propriétaires et plusieurs créatures.
8. Vérifier séparément HUD, icônes charge/prêt, modèles, textures, animations, particules, sons et réplication réseau. Aucun manque d’asset global n’est établi par ce lot.

Les lacunes Battle Training déjà documentées et le défaut de déplacement V564 restent ouverts ; ce lot ne les modifie pas. Aucun serveur historique, rendu graphique ou transport réseau exécuté dans ce diagnostic.

Suite : Continuer SYS-01.2-02 depuis revision600_trace_review/REVIEW.json. Malzahar V599 intégré : 57 sources, 171 associations, 29 points et 58 liens. 57 sources natives et 25 références communautaires liées : 23 Lua en initialisation littérale, 13 preloads, 9 buffs résolus. Quatre sorts, croissance à 7 secondes, frénésie à 14 secondes, expiration à 21 secondes dans les textes. Les producteurs @f1@/@f2@/@f3@, le compteur et l’IA restent à qualifier. CharScript vides, six chemins candidats absents, 13 fichiers NightmareBot exclus ; alias Nautilus/Malady et Ezreal/FallenAngel conservés. Deux cas publics base/épée longue +10 AD : 6 impacts physiques, 246 refus atomiques, 1262 ticks observés ; aucun sort Malzahar accepté et aucune créature. Les observations autour de 7/14/21 secondes sont après Stop : elles ne testent pas une horloge de créature. Code monde/Tibbers relié comme contexte, sans le présenter comme passif Malzahar. BUILD/RUN/inspection/prepare/check/publish/audit 0 ; 72+4 refus. Conserver preuves et défaut V564. Prochain passif à inspecter réellement : Maokai. Goal actif, aucun statut/case/inconnue fermé.
