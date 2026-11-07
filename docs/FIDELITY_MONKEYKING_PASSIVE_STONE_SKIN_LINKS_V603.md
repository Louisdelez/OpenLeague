# SYS-01.2-02 — Wukong : sources et consommateurs de Stone Skin (V603)

Date UTC : 2026-10-26T09:40:10.332095+00:00. Projet : F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement non établis. Catalogue officiel 4.20.1 distinct.

## Résultat

Les fiches CH-MonkeyKing-PASSIF-SOURCE, CH-MonkeyKing-PASSIF-SIMULATION-CONTRAT et CH-MonkeyKing-PASSIF-SIMULATION sont reliées à64 sources natives,192 associations et28 points du moteur, soit56 liens sur les fiches de simulation. Ces points restent qualifiés comme frontières ou contexte, sans consommateur complet du passif démontré.

Deux simulations publiques à six joueurs font entrer puis sortir trois champions ennemis, avec deux alliés témoins. L’armure et la résistance magique de Wukong restent celles de sa base et de ses objets. Aucun bonus Stone Skin n’est observé dans ces cas. Le montant historique dynamique f1 et le rayon exact demeurent inconnus ; le rayon600 utilisé dans le diagnostic est une convention d’observation, pas une règle native acceptée.

Trois essais initiaux ont échoué pendant la mise en place des joueurs. Le scénario final aboutit avec deux reprises explicites Stop/Move par cas ; cela ne répare pas la navigation. Aucun gameplay ni asset modifié, aucun passif/champion/jeu déclaré terminé.

## Sources et limites de lecture

- MonkeyKing.inibin indique MonkeyKingPassive, l’icône MonkeyKingStoneSkin.dds et la description en_GB ligne4234 : augmentation de l’armure et de la résistance magique par champion ennemi proche. Le nom Stone Skin est résolu ligne4410.
- MonkeyKingPassive.inibin lie le tooltip ligne2303 contenant `@f1@`. Les champs SpellData inspectés (tooltip, description, icône, portée/rayon, coefficients, cooldown/coût et Effect1Level0..5) sont absents. Ils ne fournissent donc ni valeur par ennemi, ni progression, ni distance ; leur absence n’est pas une valeur zéro.
- Passive1Desc, PassLev1Desc2..4 et Passive1Level1..6 sont absents. Les défenses de base sont24,87999916 d’armure et32,09999847 de résistance magique ; ce ne sont pas les valeurs du passif.
- MonkeyKingPassive.luaobj utilise **Cassiopeia_PetrifyingGaze.dds**, contrairement à l’icône du personnage. BuffName reste MonkeyKingPassive ; PersistsThroughDeath et NonDispellable sont vrais. Cette divergence d’icône et ces indicateurs ne prouvent ni mécanique de Cassiopeia, ni persistance d’un compteur au respawn.
- Les clones Decoy/Nimbus portent les alias AkaliShadowDance ; les métadonnées des impacts Q utilisent Wolfman_SeverArmor.dds. Ces alias sont conservés sans en déduire les règles de Stone Skin ou l’éligibilité des clones.
- Six clés BuffData sont résolues exactement une fois : DecoyStealth, DoubleAttack, DoubleAttackDebuff, NimbusAS, Passive et SpinToWin.
- 27 Lua sont parcourus intégralement sans prototypes enfants :17 initialisations littérales et10 limites NEWTABLE (attaques de base1/2, critique, Decoy, DecoySwipe, DoubleAttack, Nimbus, NimbusKick, QAttack, SpinToWin). Les limites du lecteur ne démontrent pas une corruption et ne valent pas exécution du serveur historique. CharScriptMonkeyKing est vide.
- Les16 preloads relient notamment le passif, les particules de mort, les clones, les effets Q/E/R et le retour de l’ultime. DoubleAttackHit référence le passif à charger ; cela ne démontre pas un producteur de bonus de résistance. La présence d’une dépendance ne qualifie ni son chargement effectif ni son rendu.
- Les16 lignes DDF concernent Q/W/E/R : Cyclone f1=1,2AD, Crushing Blow f1=1,1AD, Nimbus f1=0,8bonusAD ;13 lignes sont vides. Ces coefficients ne résolvent pas le f1 de Stone Skin.
- Les24 références communautaires sont présentes. CharScriptMonkeyKing.cs est vide et la définition communautaire du passif contient seulement sa clé BuffData. Ces ressources ne remplacent pas une preuve du corps serveur historique.
- Les23 fichiers NightmareBotMonkeyKing trouvés sont identifiés et exclus des64 sources normales ; les règles spéciales Doom Wukong ne sont pas adoptées.
- Six chemins candidats sont absents : CharScript à la racine du personnage, Passive.inibin/.luaobj dans Characters/MonkeyKing/Spells, Passive.preload, PassiveStacks.inibin et Passive.ddf dans DATA/Spells. Le CharScript réel est sous Scripts et les ressources de sorts réelles dans DATA/Spells. Aucune absence globale de modèle, texture, animation ou son n’est déduite de ces chemins.

Les64 sources sélectionnées correspondent au registre et au manifeste RADS retenu ; taille et SHA-256 sont vérifiés. Les23 exclusions sont également identifiées par empreinte sans ajout aux associations natives de Stone Skin.

| Fichier | Source |
|---|---|
| MonkeyKing.inibin | OLS-d390076f-0a66-50ca-bfbb-128e26b7eaf9 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| MonkeyKing.ddf | OLS-31b78d1e-1fa9-596a-8cc5-41eeb9de5455 |
| CharScriptMonkeyKing.luaobj | OLS-e2943329-ff85-5f5a-abb7-4445fc395b78 |
| CharScriptMonkeyKing.preload | OLS-f2086c69-9166-5fd5-bb06-2931e3b7ba03 |
| MonkeyKingBasicAttack.inibin | OLS-995b3f1d-5a98-53f1-995e-a9d9c88d2c0d |
| MonkeyKingBasicAttack.luaobj | OLS-767447ad-3eee-56de-925d-c552de5226ac |
| MonkeyKingBasicAttack2.inibin | OLS-e8bb0657-e13c-5408-b032-cca5ba62bc3e |
| MonkeyKingBasicAttack2.luaobj | OLS-a2bf2251-e2fd-5f75-9321-fdf3ffcd1e7c |
| MonkeyKingCritAttack.inibin | OLS-a3606813-643b-56d9-bb82-3b0e1e216fc2 |
| MonkeyKingCritAttack.luaobj | OLS-48d972c2-aaa1-5d25-af2d-707f3b2e28b8 |
| MonkeyKingDAHitC.inibin | OLS-26133544-5789-5c34-a893-64532962c0fa |
| MonkeyKingDAHitC.luaobj | OLS-dea537ea-f7c4-58fe-a665-21244dd4c273 |
| MonkeyKingDAHitC.preload | OLS-7ac67a61-e20a-591f-b4df-b00b1bc68f18 |
| MonkeyKingDeathParticle.luaobj | OLS-953492d5-9428-5fae-89e6-071a353d1897 |
| MonkeyKingDeathParticle.preload | OLS-aeac79df-25a4-5888-8605-f23f91f6c161 |
| MonkeyKingDecoy.inibin | OLS-74b4d658-5bfa-59f9-a0cd-f697cece6b7f |
| MonkeyKingDecoy.luaobj | OLS-24806d04-e8d7-5a0f-b24c-00f92db7b481 |
| MonkeyKingDecoy.preload | OLS-c86bdaa0-e3cf-5ca4-a13f-167ae542fce6 |
| MonkeyKingDecoyClone.luaobj | OLS-55d10257-f1c9-52ee-b95f-b772be39f860 |
| MonkeyKingDecoyClone.preload | OLS-18d39504-1435-5a3a-a164-71f2445b6793 |
| MonkeyKingDecoyStealth.inibin | OLS-562b7792-dd87-5f46-aad3-5c960ddc0f90 |
| MonkeyKingDecoyStealth.luaobj | OLS-bb5450b4-d43a-54a7-a7cc-8808e759187c |
| MonkeyKingDecoyStealth.preload | OLS-a8f1f836-4114-5748-b5b7-8041122b0321 |
| MonkeyKingDecoySwipe.inibin | OLS-385c5223-23d6-5ee5-9d48-98eda405adf8 |
| MonkeyKingDecoySwipe.luaobj | OLS-aed28948-09e5-53ae-8df1-3eb7d28ed531 |
| MonkeyKingDoubleAttack.inibin | OLS-6ecbe8a8-0fcf-5f59-a8ba-5ea77fa6f975 |
| MonkeyKingDoubleAttack.luaobj | OLS-bf977167-98d2-5c1f-bbc3-04c304f5ff2c |
| MonkeyKingDoubleAttack.preload | OLS-f60c43f0-e514-5a86-b895-3975522f7705 |
| MonkeyKingDoubleAttackDebuff.inibin | OLS-f5efd44d-5ba5-5924-8d85-3e5ccde03777 |
| MonkeyKingDoubleAttackDebuff.luaobj | OLS-6c2faae3-1306-55dd-894f-2d7b9a7f3a12 |
| MonkeyKingDoubleAttackDebuff.preload | OLS-7544efbf-07c8-51dd-b891-afbcc7260cfc |
| MonkeyKingDoubleAttackHit.inibin | OLS-b8e54826-d775-5969-925f-848ff453bc51 |
| MonkeyKingDoubleAttackHit.luaobj | OLS-e073443b-00e6-54a5-b32b-61b6c3cf92fc |
| MonkeyKingDoubleAttackHit.preload | OLS-914d38d5-bc95-5fbe-a900-a5638a50c726 |
| MonkeyKingKillClone.luaobj | OLS-07e00105-e70f-5727-8278-d2dd92de40bf |
| MonkeyKingKillCloneE.luaobj | OLS-ef5c17c1-c86b-5e46-afc2-030acb7b3bf5 |
| MonkeyKingKillCloneW.luaobj | OLS-4c7556f1-98dd-534d-8d17-21d2bfce786a |
| MonkeyKingKillCloneW.preload | OLS-ef2842e5-a1ae-51ec-8245-4f5291cf7421 |
| MonkeyKingNimbus.inibin | OLS-bc7a7eb3-dbab-51ce-9b9e-2b6af69068e3 |
| MonkeyKingNimbus.luaobj | OLS-ceb332a1-ac6e-5ef1-8f21-b7a866c34809 |
| MonkeyKingNimbus.preload | OLS-d5a26840-8d45-541d-98ce-56565709ec87 |
| MonkeyKingNimbusAS.inibin | OLS-c60f0daf-b2ef-5cb8-bc04-6be33923a4ab |
| MonkeyKingNimbusAS.luaobj | OLS-aabc5190-ea8d-5ddf-9f77-d7744fa47512 |
| MonkeyKingNimbusKick.inibin | OLS-9cb25b40-dd4e-5f02-9c1d-68fa885d27f7 |
| MonkeyKingNimbusKick.luaobj | OLS-f98b3b7d-493e-58d2-a849-06df498b7758 |
| MonkeyKingNimbusKick.preload | OLS-21d6040f-1c1d-5cfc-a578-68698724a498 |
| MonkeyKingNimbusKickClone.inibin | OLS-62d9726d-799a-5c5b-a287-2cc5fc791ddc |
| MonkeyKingNimbusKickClone.luaobj | OLS-dad4a112-d3bb-5981-8cf6-5cce361ceaf2 |
| MonkeyKingNimbusKickClone.preload | OLS-7a37f054-0435-57df-b4c2-a4b3c09902fb |
| MonkeyKingNimbusKickFX.luaobj | OLS-f3374fcf-c52b-54ba-aa1d-1aa8c1b550b4 |
| MonkeyKingNimbusKickFX.preload | OLS-d6097023-9bbd-5c80-b0ea-448b0b02fef2 |
| MonkeyKingPassive.inibin | OLS-86376f13-079b-50e9-bfc9-5ecad9d2246d |
| MonkeyKingPassive.luaobj | OLS-3949ede3-5865-51da-9d83-bb8207b26a28 |
| MonkeyKingQAttack.inibin | OLS-82bc3fc2-4caf-5e53-81e6-c1bb146d848d |
| MonkeyKingQAttack.luaobj | OLS-a6f14ef3-4d28-5732-adf0-39fac6245154 |
| MonkeyKingSpinKnockup.luaobj | OLS-ed68038c-2722-50fa-aabd-96729e064b4d |
| MonkeyKingSpinMarker.luaobj | OLS-544be4ca-bc5e-5536-9d8c-b5b252055799 |
| MonkeyKingSpinToWin.inibin | OLS-326b076b-f844-5d70-af43-340375fa3c6e |
| MonkeyKingSpinToWin.luaobj | OLS-fae0444a-c9b8-56e0-bf7e-8ebca6038f17 |
| MonkeyKingSpinToWin.preload | OLS-3f9b12ab-60c8-57b1-92a0-9ff4d6af2eaa |
| MonkeyKingSpinToWinLeave.inibin | OLS-3d301c45-f1a2-5341-b010-625c24b53ef3 |
| MonkeyKingSpinToWinLeave.luaobj | OLS-794f7e0e-63c0-590f-a4e8-cc1b2c28d5a9 |
| MonkeyKingSpinToWinLeave.preload | OLS-15894fa4-5d8f-5688-bf53-aa26e9c11e2d |

## Prérequis et cas exécutés

Les phases, lots, six dépendances de lot, quatre dépendances de tâches et trois questions propres sont enregistrés dans le reçu. Leurs états ouverts sont conservés. Le diagnostic de frontières peut être exécuté avec le core actuel ; il ne constitue pas une levée des prérequis de fidélité.

Compilation Rust `--locked --offline` du core réel hors configuration de test, avec identités/checksums des dépendances alignés sur Cargo.lock. Les1158 entrées core/ressources et la chaîne des preuves antérieures restent inchangées. Aucune injection d’état, aucun dégât artificiel, aucun octroi d’XP ; Join/Buy/Move/Stop/Attack/Learn/Cast publics seulement.

Participants : Wukong, Annie, Ahri, Ashe, Ryze, Ezreal. Wukong, Ahri et Ryze sont alliés ; Annie, Ashe et Ezreal sont ennemis. Tous restent vivants, au niveau1, sans victoire ou événement de mort. Wukong garde ses ressources pleines, rangs et délais nuls, sans bouclier, ralentissement ou étourdissement. Aucun sort Wukong accepté.

| Cas | Armure | Résistance magique | Impacts physiques | Q reçus | Refus atomiques | Ticks d’attente | Reprises Move |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| base | 24.88000 | 32.10000 | 3 | 1 | 27 | 270 | 2 |
| Cloth15_NullMagic25_control | 39.88000 | 57.10000 | 3 | 1 | 27 | 270 | 2 |

Les objets témoins sont l’armure d’étoffe1029 (+15armure,300or) et la cape1033 (+25RM,500or). Les achats publics réussissent dans le budget initial825. Les valeurs ordinaires observées sont24,88/32,1 sans objet et39,88/57,1 avec objets, à l’arrondi d’affichage près.

Neuf phases de30 ticks par cas : aucun champion proche ; deux alliés proches sans ennemi ; un, deux puis trois ennemis ; les mêmes trois après dégâts ; deux, un puis zéro après leur départ. Les alliés sont à150/300 unités. Les ennemis proches sont à150/300/450 ; éloignés à1800/1950/2100. Les positions et visibilités sont enregistrées. Les ennemis proches sont visibles dans ces observations ; elles ne qualifient pas l’invisibilité ou les unités cachées. **600 n’est pas un rayon original résolu.**

Attendu/observé : les défenses courantes restent constantes pendant les phases et déplacements contrôlés. Les trois attaques ordinaires d’Annie par cas ont un témoin de projectile, cible, dégâts bruts et indicateur non critique ; les pertes de PV correspondent à la mitigation physique et à la régénération, résidu inférieur à0,002. Chaque Q Annie accepté coûte60mana, porte80dégâts magiques bruts et donne une perte de PV conforme à la RM observée, même tolérance. Aucun supplément de défense selon le nombre d’ennemis n’apparaît. Le test valide ces constats du moteur, pas le montant ou rayon historique du passif.

Les54 refus sont atomiques : joueur inconnu, auto-ciblage, slot invalide, apprentissage et lancements ciblés/au sol Q/W/E/R avant les dégâts puis après le départ des ennemis. Les snapshots avant/après sont identiques. Les18 phases représentent540 ticks d’attente, sans compter les déplacements et impacts.

Binaire final : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-monkeyking-passive-stone-skin-probe-reordered.exe` ; 6129664 octets ; SHA-256 `f9089daa656c4671ef681d34e66f78784eb91d4aa90cc72486e1eb54d2aec27d`. BUILD/RUN finaux et inspection renvoient0. Les résultats concernent ce binaire et les sources pinées, sans serveur original, rendu graphique, audio ou transport réseau exécuté.

## Échecs et reprises de déplacement

Trois essais distincts conservés, chacun BUILD0 puis RUN101 ; les scripts de supervision renvoient1 :

1. `revision603_MonkeyKing_passive_probe` : installation successive des six joueurs ; le trajet d’Annie n’atteint pas sa destination en2400 ticks.
2. `_diagnostic` : reproduction avec observations. Wukong porte l’identifiant21 et Annie22. Annie22 s’arrête vers(10563,6313), but(7685,6934), destination effacée au tick5254. Le journal complet conserve les valeurs exactes ; le serveur n’a pas atteint le scénario de comptage prévu.
3. `_qualified` : installation simultanée sans reprises. Quatre joueurs sur six satisfont la tolérance d’arrivée inférieure à1 ; Annie reste à environ1376 unités du but et Ezreal à2,3623 unités. Le nom du répertoire n’est pas une déclaration de qualification.

Le code actuel de déplacement prévoit qu’un chemin interrompu nécessite un nouvel ordre ordinaire. Dans `_reordered`, le diagnostic conserve la tolérance d’arrivée inférieure à1 et émet explicitement Stop puis Move lorsque la destination a disparu avant l’arrivée, avec limites strictes de reprises et journal de chacune. Aucune téléportation ou mutation du moteur.

Les deux cas finaux ont chacun deux reprises pendant l’installation : Annie22 au tick575 vers(10562,6312), puis Ashe24 au tick590 vers(10564,6314). La mise en place atteint tous les buts en899 ticks ; les phases suivantes aboutissent sans reprise. Au total28 trajets demandés et quatre nouveaux ordres Move après Stop, soit32 ordres Move. Les échecs précédents, binaires et logs sont pinés dans la chaîne du scénario final.

Cette reprise permet les observations de Stone Skin mais ne résout pas la cause exacte des interruptions. La navigation n’est pas déclarée acceptée ; le défaut V564 reste ouvert, sans affirmer que ces arrêts en ont nécessairement la même cause.

## Consommateurs actuels

stats calcule les défenses avec base, croissance, objets et modificateurs courants Garen/Annie/Exhaust/Trundle ; aucun producteur Stone Skin n’est identifié dans le core inspecté. apply_damage et penetrated_defenses utilisent ces défenses pour les dommages reçus. La fonction visible_to fournit les observations de visibilité, sans fixer l’éligibilité native du passif.

Onze ressources locales sont sélectionnées : catalogue, croissance, ressources, contrats d’attaque/critique, collisions, boutique, Q Annie, mouvement, rayons de vision et règles de vision. Leurs données ne sont pas présentées comme corps serveur historique de Stone Skin. Les points de récapitulatif restent du contexte, sans acceptation de rendu.

| Ancre exacte | Rôle qualifié |
|---|---|
| crates/core/src/lib.rs:533 | public six-player initialization |
| crates/core/src/lib.rs:598 | public actions including4explicit Stop/Move recoveries |
| crates/core/src/progression.rs:68 | observed base anditem defenses with0..3nearby enemies |
| crates/core/src/progression.rs:150 | unsupported MonkeyKing learning |
| crates/core/src/progression.rs:159 | unsupported MonkeyKing rank policy |
| crates/core/src/spells.rs:101 | unsupported MonkeyKing cast |
| crates/core/src/annie_w.rs:29 | unsupported MonkeyKing ground cast |
| crates/core/src/lib.rs:685 | actual tick order,540idle ticks |
| crates/core/src/lib.rs:744 | public state,not network acceptance |
| crates/core/src/damage.rs:53 | actual6physical2magic incoming impacts |
| crates/core/src/attacks.rs:157 | actual incoming Annie ranged attacks |
| crates/core/src/lifesteal.rs:4 | ordinary incoming basic impact effects |
| crates/core/src/regeneration.rs:32 | ordinary health regeneration during waiting |
| crates/core/src/regeneration.rs:10 | health correction forimpact attribution |
| crates/core/src/shop.rs:261 | Cloth1029 armor15 andNullMagic1033 MR25 public controls |
| crates/core/src/shop.rs:215 | ordinary defense item bonuses |
| crates/core/src/world.rs:226 | current six-player targetidentity |
| crates/core/src/damage.rs:38 | ordinary physical andmagic resistance mitigation |
| crates/core/src/attacks.rs:26 | ordinary Annie attack timing,not passive event policy |
| crates/core/src/critical.rs:12 | ordinary noncritical control |
| crates/core/src/death_recap.rs:184 | current damage capture context,not rendered recap |
| crates/core/src/death_recap.rs:200 | ordinary damage recap context |
| crates/core/src/penetration.rs:9 | zero penetration controls,not stacking ofStoneSkin |
| crates/core/src/vision.rs:79 | recorded visibility,not native passive eligibility |
| crates/core/src/ally_occupancy.rs:635 | 28publictravels,4reorders;navigation not fully qualified |
| crates/core/src/ally_occupancy.rs:526 | movement boundary,V564 andstopped trajectories stay open |
| crates/core/src/annie.rs:45 | accepted incoming Q raw80cost60 |
| crates/core/src/annie.rs:73 | two actual magic impacts |

## Livraison et conservation

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json et docs/fidelity_requirement_trace_4_20.json. Reçu : docs/reference_requirement_trace_sources/monkeyking-passive-stone-skin-links-v603.json. Preuve : docs/fidelity_monkeyking_passive_stone_skin_links_v603.json. Les instructions copiables exposent les règles sourcées, inconnues, écarts, essais échoués et travail restant ; SYS-01.2-02 reçoit la synthèse.

PREPARE/CHECK/PUBLISH/AUDIT renvoient0. Soixante-douze associations volontairement altérées et quatre graphes invalides sont refusés. Trois fragments de traçabilité changent,42212 restent identiques. Les deux bases SQLite, projet et application installée, reçoivent quatre lignes ciblées :42603 autres lignes,42607 états manuels et23 historiques conservés. Synchronisation ordinaire idempotente. Identifiants, phases/lots et inconnues restent identiques octet par octet ; trois questions propres et quatre dépendances conservées. Aucun statut, critère, propriétaire, note ou case fermé automatiquement.

Revue globale :99089 sources,4096 consommateurs,4096 ancres exactes, aucune divergence. source_hashes_verified=0 désigne le contrôle structurel global ; les payloads et consommateurs sélectionnés sont hachés séparément. Aucun contrôle exhaustif des99089 sources n’est revendiqué.

coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md sont mis à jour avec conservation des preuves antérieures. Aucun stage/reset/commit/nettoyage.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision603_MonkeyKing_discovery/OBSERVATIONS.json ; revision603_MonkeyKing_passive_probe_reordered/OBSERVATIONS.json ; revision603_MonkeyKing_inspection_qualified/OBSERVATIONS.json ; revision603_MonkeyKing/DELIVERY_AUDIT.json ; revision604_trace_review/REVIEW.json. Les trois répertoires d’essais échoués et leurs commandes restent disponibles.

## Travail restant

1. Résoudre f1, niveaux et progression avec une source explicitement identifiée.
2. Résoudre rayon, métrique, bord inclus/exclu, cadence et ordre de recalcul.
3. Implémenter le producteur de bonus et ses consommateurs d’armure/RM, sans cumuls fantômes.
4. Qualifier les entités comptées : ennemis vivants/morts, clones, illusions, invocations, invisibles et unités cachées ; exclure correctement alliés et autres catégories selon preuve.
5. Tester entrées/sorties, simultanéité, mort/respawn, changements d’équipe, déconnexion et fin de partie.
6. Vérifier dégâts physiques/magiques/purs, pénétration, réductions de résistance, boucliers, objets et changements de niveau.
7. Qualifier séparément les icônes divergentes, HUD, effets, animation, sons, rendu et réseau.
8. Diagnostiquer les interruptions de déplacement observées et conserver leur portée distincte du passif ; aucune réparation de navigation n’est livrée ici.

Les lacunes Battle Training demeurent ouvertes. Les trois tâches Wukong gardent leur état antérieur, et le goal complet reste actif.

Suite : Continuer SYS-01.2-02 depuis revision604_trace_review/REVIEW.json. MonkeyKing V603 intégré :64sources192associations28points56liens. 64 sources natives,24 références communautaires,27 Lua dont10 limites NEWTABLE,16 preloads,6 buffs résolus et16 DDF QWER ;23 fichiers NightmareBot exclus. Stone Skin décrit armure/RM par ennemi proche, mais f1, niveaux et rayon restent non résolus. Icônes Cassiopeia/StoneSkin divergentes et alias Akali/Wolfman conservés sans mécanique étrangère. CharScript vides ;six chemins candidats absents. Deux cas publics à six joueurs sans objet/armure15 RM25 :séquence0/0/1/2/3/3/2/1/0 ennemis dans un rayon600 d’observation, deux alliés témoins,6impacts physiques2Q Annie,540ticks d’attente,54refus. Défenses24,88/32,1 ou39,88/57,1 constantes,aucun bonus Stone Skin. 28trajets et4reprises publiques Stop/Move ;installation simultanée899ticks par cas. Trois essais préalables BUILD0/RUN101 sont conservés : deux installations successives arrêtées sur Annie loin du but, puis une installation simultanée où4/6joueurs atteignent la tolérance1. Le scénario final avec reprises publiques BUILD0/RUN0 aboutit sans modification du moteur. La cause précise des arrêts n’est pas qualifiée ;V564 reste ouvert. Inspection/PREPARE/CHECK/PUBLISH/AUDIT0 ;72+4refus. Conserver toutes les preuves,statuts etinconnues. Prochain passif à inspecter réellement : Mordekaiser. Goal actif.
