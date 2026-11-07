# Skarner — Crystallizing Sting : sources et consommateurs V631

UTC : 2026-10-26T18:30:16.482278+00:00. Projet F:/OpenLeague. Exigence SYS-01.2-02.

## Résultat et portée

Trois fiches Skarner et la synthèse SYS-01.2-02 sont enrichies : **68 fichiers natifs, 204 associations, 26 points actuels et 52 liens**. Les consommateurs ajoutés sont des frontières génériques ou des refus explicites ; ils ne sont pas présentés comme l’implémentation du passif. Aucun gameplay modifié, aucun statut promu et aucune case cochée.

Les sources natives décrivent Crystallizing Sting : les sorts infligeant des dégâts appliquent Crystal Venom pendant 5 secondes, jusqu’à 3 charges. L’attaque suivante contre une cible à 3 charges inflige f1 dégâts magiques et étourdit pendant f2 secondes. Skarner ne peut ensuite plus lui appliquer de charges pendant 6 secondes. Les producteurs de f1/f2 et leur progression restent non qualifiés.

Le moteur courant refuse les sorts de Skarner. Le diagnostic n’a donc appliqué aucune charge native : il vérifie les attaques ordinaires et cette frontière de refus. **Il ne constitue pas un test du déclenchement à trois charges, de l’expiration ou du verrou de six secondes.**

Référence : PUBLIC4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement non établis. Catalogue4.20.1 distinct. Aucun serveur historique exécuté.

## Sources natives

La sélection et les appartenances RADS sont vérifiées : 21 INIBIN, 28 Lua, 17 preloads, un DDF et le font. Elle reprend les anciennes associations natives et les fichiers découverts dans les répertoires réels.

- Skarner.inibin : PV601,280029296875, mana272,20001220703125, AD61,15599822998047, armure29,384000778198242, vitesse345, portée125. QWER sélectionnés : SkarnerVirulentSlash, SkarnerExoskeleton, SkarnerFracture, SkarnerImpale. PARType, Passive1Desc et les six Passive1Level sont absents ; aucun défaut natif inventé.
- CharScriptSkarner et Skarner.ddf sont à la racine du personnage. Quatre chemins alternatifs absents sont consignés ; cela ne signifie pas que les fichiers sont globalement manquants.
- SkarnerPassive.inibin et le texte du personnage décrivent le cycle 3 charges/5s/proc/verrou6s. PassiveBuff, PassiveCooldown et PassiveStun portent leurs textes et identités distincts.
- SkarnerPassive.luaobj fournit nom, icône et persistance après la mort. Il ne fournit pas de callback d’application ou de consommation des charges. Les noms de particules stack1/2/3 et d’étourdissement sont référencés par les preloads ; chargement référencé et présentation validée restent distincts.
- SkarnerPassiveAttack expose SpellData.Cooldown10. Ce champ ne définit pas automatiquement le verrou natif par cible de6s.
- Le Q décrit une réduction de son propre cooldown de0,5s par attaque, doublée contre les champions. Cette règle reste liée au Q ; elle n’est pas promue en ancien passif global.
- Le R décrit la consommation de toutes les charges et des dégâts supplémentaires par charge. Son ordre avec les charges et le déclenchement d’attaque est à qualifier séparément.

Les 28 Lua sont lus complètement, sans callback enfant. Le lecteur de littéraux s’arrête sur NEWTABLE pour 14 fichiers : les tables et constantes restent des limites explicites, pas des règles serveur exécutées. CharScript, BrushCheck, ImpaleFlashLock et Resurrection ont des globals vides ; cela ne prouve ni une résurrection spéciale ni Flash utilisable.

13 liens BuffData : 12 traductions exactes, une clé non résolue. ImpaleVO référence `game_buff_tooltip_SionWPassive` et son Lua déclare VarusQ. Ces métadonnées étrangères sont conservées sans importer les comportements de Sion ou Varus.

Fracture contient un ancien texte de buff « prochain coup/marque », tandis que le tooltip du sort décrit une projection d’énergie et un ralentissement. Les deux sont conservés, leur sélection effective reste ouverte. Le DDF contient quatre lignes, dont une liaison Q à bonusAD×0,8 ; aucune formule de dégâts f1 ou durée f2 du passif n’y est fournie.

## Références communautaires

26 fichiers sont lus statiquement, avec identité enregistrée. CharScriptSkarner est vide. Le moteur C# n’est pas exécuté.

| Sort | Code observé | Limite |
|---|---|---|
| Q | Zone350, dégâts physiques18–58+0,2AP+0,5bonusAD, Slow1s | Le DDF natif porte0,8bonusAD ; bonus magique conditionnel et charges de Crystal Energy ne sont pas démontrés par ce code. |
| W | Ajout de SkarnerShield pendant6s et particule | Montant du bouclier, progression de vitesse et dépendance au maintien du bouclier non qualifiés ici. |
| E | Dégâts magiques40–120+0,4AP puis Slow2,5s | Le taux du ralentissement et l’application du passif restent non qualifiés par ce fichier. |
| R | Deux impacts100/150/200+0,5AP, espacés1,75s, buffSuppression | Aucun déplacement forcé ou consommateur de charges démontré ici ; présence du buff n’est pas une validation de suppression/traînée. |

## Diagnostic exécuté

Compilation `cargo build --locked --offline --message-format=json` contre le crate courant en profil non-test. Les 1158 entrées de code et ressources, Cargo.lock, dépendances et preuves antérieures sont vérifiés avant/après. Pas d’injection directe d’état. Déplacements, achat/vente/rachat du Tome et attaques utilisent les commandes publiques.

| Cas | AP | Attaques ordinaires | Dégâts par impact | Ticks au repos | Refus |
|---|---:|---:|---:|---:|---:|
| base | 0.0 | 6 | 51.296753 | 181 | 27 |
| Tome20AP | 20.0 | 6 | 51.296753 | 181 | 27 |

Total : 12 attaques ordinaires, 54 refus atomiques, 362 ticks au repos, quatre trajets arrivés et zéro réordre. Achat/vente/rachat réellement exécutés dans le cas Tome20AP. Les dégâts51,2967529296875 restent cohérents avec AD61,15599822998047 et la mitigation ordinaire dans les deux cas. Aucun étourdissement observé, aucun sort de Skarner accepté, aucun scénario natif de charges amorcé.

Les refus couvrent joueur inconnu, attaque sur soi, emplacement invalide et apprendre/lancer/lancer à position les quatre sorts avant/après l’attente. Chaque refus conserve le snapshot. Le mana reste au plafond ; aucune restitution spécifique de mana n’est qualifiée.

L’attente de181ticks par cas dépasse6s mais ne prouve pas le verrou du passif : aucune charge ni consommation n’a démarré ce délai. De même, l’absence de dégâts magiques supplémentaires sur des attaques non amorcées ne démontre pas l’échec d’un proc à3charges. La recherche précise Skarner/Crystallizing/CrystalVenom dans core ne relève aucune branche dédiée ; elle complète les refus observés. Les points génériques de stun et d’expiration sont inspectés et liés, mais le diagnostic ne leur injecte pas de stun natif.

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-skarner-passive-crystallizing_sting-probe.exe` ; 6077952 octets ; SHA256 `4c220f87ad520d59136dab5509707565cf1f7e69ea2194440ce8a7afd88c42ee`.

BUILD0, RUN0, collecteur0, découverte0, inspection0. Aucun relancement nécessaire.

## Intégration vérifiée

PREPARE, CHECK, PUBLISH, AUDIT :0. Les 72 mutations d’association et quatre mutations de graphe invalides sont refusées. Trois aperçus enrichis et quatre copies de tâches sont vérifiés avec leurs instructions détaillées et limites.

Deux bases réelles : quatre lignes enrichies, 42603 autres lignes, 42607 états manuels et23 historiques conservés. Intégrité et synchronisation idempotente vérifiées. Trois questions propres et quatre dépendances préservées. Identités, hiérarchie et registre d’inconnues inchangés à l’octet.

Revue globale : 99201 sources, 4809 consommateurs, 4809 ancres exactes sans divergence. La revue globale est structurelle ; les empreintes de la sélection et du diagnostic sont vérifiées séparément. Aucun contrôle exhaustif des octets des99201sources ou du jeu complet n’est revendiqué.

Fichiers concernés :

- docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json.
- docs/reference_requirement_trace_sources/skarner-passive-crystallizing_sting-links-v631.json, docs/fidelity_skarner_passive_crystallizing_sting_links_v631.json et ce rapport.
- docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md, docs/ai/HANDOFF.md et checkpoint privé.
- F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3 ; sauvegardes avant modification.
- Scripts et preuves privés dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision631_Skarner*.

## Travail restant

1. Qualifier f1/f2, progression, catégories de cibles, producteur de charges, rafraîchissement et expiration5s.
2. Implémenter les sorts nécessaires à l’application réelle des charges puis les états0/1/2/3 et l’attaque de consommation.
3. Tester dégâts magiques, étourdissement, tenacité, verrou6s par cible/propriétaire, plusieurs Skarner, impacts simultanés, boucliers, invulnérabilité et interruptions selon les sources qualifiées.
4. Qualifier l’ordre de consommation par R et la réduction du cooldown de Q ; ne pas fusionner leurs règles avec le proc d’attaque.
5. Tester mort, réapparition, reconnexion, visibilité et synchronisation. Qualifier séparément HUD, VFX, sons, animations et réseau.
6. Conserver les limites de lecture Lua, la clé étrangère non résolue et les anciennes descriptions sans alias silencieux.

Les limites V564/V606 et les cinq lacunes Battle Training restent ouvertes localement. Aucun serveur historique, rendu, transport réseau ou multijoueur testé ici. Goal actif et objectif global incomplet.

## Consommateurs actuels

| Fichier et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/lib.rs:598 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/progression.rs:68 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/progression.rs:150 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/progression.rs:159 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/spells.rs:101 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/annie_w.rs:29 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/lib.rs:685 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/lib.rs:744 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/damage.rs:53 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:157 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/lifesteal.rs:4 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/regeneration.rs:32 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/regeneration.rs:10 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/shop.rs:261 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/shop.rs:215 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/world.rs:226 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/damage.rs:38 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/attacks.rs:26 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/lifecycle.rs:16 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/lifecycle.rs:24 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:635 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:526 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/spells.rs:5 | current Skarner unprimed attacks,items,resources or spell-refusal boundary |
| crates/core/src/stuns.rs:15 | generic stun entry;no Skarner stack producer and not called by this diagnostic |
| crates/core/src/stuns.rs:37 | generic expiry boundary;not native passive lockout acceptance |

## Sélection native

| Fichier | Source |
|---|---|
| Skarner.inibin | OLS-a6bbfbf1-b508-597e-ae30-e3541f5a8daf |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Skarner.ddf | OLS-9ed1d817-a44d-5522-9d33-e1535c633aef |
| CharScriptSkarner.luaobj | OLS-b30b0c49-f1de-5d51-a365-e56b25987108 |
| CharScriptSkarner.preload | OLS-3d59fb2b-1b1c-5358-a021-08c1a00507ca |
| SkarnerBasicAttack.inibin | OLS-6d995f08-bbbc-50b6-857f-673a7c32180f |
| SkarnerBasicAttack.luaobj | OLS-a435dcfd-ea58-59bd-849a-0f2d7236aedd |
| SkarnerBasicAttack.preload | OLS-6370ae72-b3d8-56f8-bf9a-fec82a0922d5 |
| SkarnerBasicAttack2.inibin | OLS-7dc69f65-7f9f-5d60-82e0-10f847c7203a |
| SkarnerBasicAttack2.luaobj | OLS-fa41c611-2d1b-5016-9b77-83a4ef407c41 |
| SkarnerBasicAttack2.preload | OLS-4e12b121-e3c5-5c7b-99f4-30e11fab0606 |
| SkarnerBasicAttack3.inibin | OLS-e2ecebf8-6b3b-53ae-8a27-33b7793f9c99 |
| SkarnerBasicAttack3.luaobj | OLS-9f4a92cc-96e4-5163-b610-3839e8fdd32d |
| SkarnerBasicAttack3.preload | OLS-f4180741-8fa4-5c9a-9553-7d50717fc678 |
| SkarnerBrushCheck.luaobj | OLS-7f46a8d5-a7de-514d-afa5-ae57c0ab6673 |
| SkarnerBrushCheck.preload | OLS-1cc60fe0-62d9-59f4-9aa2-940875c83ab7 |
| SkarnerBrushSound.luaobj | OLS-a0c39a91-93d0-5bb6-8755-502ec7f4b602 |
| SkarnerCritAttack.inibin | OLS-500ed197-d1c6-523e-8b75-38163c7b0d15 |
| SkarnerCritAttack.luaobj | OLS-3362266c-a617-537c-8b7c-d1e09acde32e |
| SkarnerCritAttack.preload | OLS-1f59aa56-f625-593a-821f-62c8e10da861 |
| SkarnerExoskeleton.inibin | OLS-cbe2ad1b-1687-530e-8cb3-7a6fa5f396c0 |
| SkarnerExoskeleton.luaobj | OLS-5a659d0e-26b8-50c5-90ce-9565bf4463b0 |
| SkarnerExoskeleton.preload | OLS-7c268c3f-1ff8-5639-bdab-ccaedbe1871a |
| SkarnerFracture.inibin | OLS-b9fd777c-fd7c-5bbb-8fb8-a7fd6e0b64c3 |
| SkarnerFracture.luaobj | OLS-a382cd0a-e5e0-5a9f-a534-2e35b941b0e4 |
| SkarnerFracture.preload | OLS-7ad4fe00-ff4b-5494-b86e-fc9c318ce1c7 |
| SkarnerFractureMissile.inibin | OLS-4334242f-db95-5413-a4ea-1dadf62756ce |
| SkarnerFractureMissile.luaobj | OLS-8d260ad2-b4db-5258-a376-2509adfab886 |
| SkarnerFractureMissile.preload | OLS-93bf1097-1d51-557d-b945-74a289a8900d |
| SkarnerFractureSlow.inibin | OLS-60cb8f3c-25f2-57fe-ab74-987ada980a36 |
| SkarnerFractureSlow.luaobj | OLS-2da99548-9c8a-572e-a8af-5842fa91ecd8 |
| SkarnerFractureSlow.preload | OLS-fa7008ef-cb88-574c-ab6f-8a93cd26d5af |
| SkarnerImpale.inibin | OLS-57b857c8-9312-552c-a0d5-9b86b6b2ac62 |
| SkarnerImpale.luaobj | OLS-6fa2ab51-391c-56ac-842c-79056aff0bd4 |
| SkarnerImpale.preload | OLS-ba265433-d8bd-59fe-8f4a-feea564d7502 |
| SkarnerImpaleFlashLock.luaobj | OLS-f224cb2b-304d-5d8d-9550-73d2f016a406 |
| SkarnerImpaleRangeCheck.luaobj | OLS-45f03d1a-5c84-5cce-8d58-e8617b542526 |
| SkarnerImpaleVO.inibin | OLS-693bd374-54b3-5064-b809-17e76cffcb7b |
| SkarnerImpaleVO.luaobj | OLS-d939c44f-4d6b-5c59-b45a-388d63bca8b4 |
| SkarnerPassive.inibin | OLS-08249903-5036-5e30-86be-5e6755307c14 |
| SkarnerPassive.luaobj | OLS-b980a522-5411-5669-8568-c815f08bf058 |
| SkarnerPassiveAttack.inibin | OLS-a063d0da-714d-5ed6-b87d-6e56a95cfec3 |
| SkarnerPassiveAttack.luaobj | OLS-45d490f8-49a7-58b0-88ea-77d09240c817 |
| SkarnerPassiveAttack.preload | OLS-3355e6b9-418e-51f6-b91c-44f6f3148430 |
| SkarnerPassiveBuff.inibin | OLS-f80d08f4-a632-5da4-b18b-6bff013c182e |
| SkarnerPassiveBuff.luaobj | OLS-4770c354-f391-55e6-bc54-aa381be0933c |
| SkarnerPassiveBuff.preload | OLS-f5904e2a-9ca3-5623-9df2-f9d5930da75a |
| SkarnerPassiveCooldown.inibin | OLS-2e8003ca-bdfc-587e-be1a-4b4e16abccc1 |
| SkarnerPassiveCooldown.luaobj | OLS-903d471f-2934-5455-b4a0-cbf099156515 |
| SkarnerPassiveStun.inibin | OLS-77758ed2-893d-58c8-a211-79eea5312645 |
| SkarnerPassiveStun.luaobj | OLS-1f09177d-62f8-509d-a486-9e80dcf09663 |
| SkarnerPassiveStun.preload | OLS-8d6187be-70cb-5c2b-bb7c-8582df9f4ed8 |
| SkarnerResurrection.luaobj | OLS-aa19cb47-33c0-5ddc-b61b-3ee6b3bc55c7 |
| SkarnerTurretAttack.inibin | OLS-fe85140f-231e-5966-9739-aa815b942a33 |
| SkarnerTurretAttack.luaobj | OLS-672d22f4-47b6-578e-bcb2-25e502b003fb |
| SkarnerTurretAttack2.inibin | OLS-3adb1fa3-9f78-5c93-b055-6fee10c9900e |
| SkarnerTurretAttack2.luaobj | OLS-95da9964-a962-5f6d-9730-33fb52d56bae |
| SkarnerVirulentSlash.inibin | OLS-b051b65f-088f-5cc4-b394-ce8fd3f11c7c |
| SkarnerVirulentSlash.luaobj | OLS-670c07f1-901f-5537-9c19-b2be56f69590 |
| SkarnerVirulentSlash.preload | OLS-3aa6bc7e-72d4-5608-9086-4aa6f9d0dc6e |
| SkarnerVirulentSlashEnergy1.luaobj | OLS-12aa318f-38fd-51a3-ba29-a373f602c3c6 |
| SkarnerVirulentSlashEnergy1.preload | OLS-54829eb5-7b8f-58b4-8fbc-63e56825535b |
| SkarnerVirulentSlashSlow.inibin | OLS-10157087-d3ce-5e78-9fb2-53558d5e2a6a |
| SkarnerVirulentSlashSlow.luaobj | OLS-accb7402-a9f7-5ba3-bf9d-c23b0554fc98 |
| SkarnerVirulentSlashSlow.preload | OLS-1488f18d-8828-58e0-9d3e-70aee942f518 |
| SkarnerImpaleBuff.inibin | OLS-1dfcc0a4-30d8-53a8-aefc-56363921deda |
| SkarnerImpaleBuff.luaobj | OLS-028d5563-f8bc-5432-9e1a-7d3d6516b976 |
| SkarnerMarker.luaobj | OLS-b96d0e3b-9989-5aa0-bc04-64f54923e121 |

## Reprise

Continuer SYS-01.2-02 depuis revision632_trace_review/REVIEW.json. V631 Skarner / Crystallizing Sting : 68 fichiers natifs, 204 associations, 26 points et 52 liens. Sorts infligeant des dégâts : charges5s, maximum3 ; attaque à trois charges : dégâts magiquesf1 et étourdissementf2, puis interdiction de nouvelles charges sur cette cible6s. f1/f2, progression et producteurs restent ouverts. 28Lua dont14 limites NEWTABLE,17preloads,13BuffData dont12résolus/1inconnu ; DDF4lignes avec bonusAD0,8 du Q. PassiveAttack Cooldown10 distinct du verrou6s ; anciens textes Fracture et métadonnées Varus/Sion conservés. 26références communautaires : CharScript vide,Q bonusAD0,5 et AP physique divergents,W/E effets délégués,R deux impacts sans traînée ni consommation des charges démontrées. Deux cas publics base/Tome20AP :12attaques ordinaires non amorcées,54 refus,362ticks au repos,quatre trajets et achat/vente/rachat. Dégâts51,29675 dans les deux cas ; aucun sort Skarner accepté,aucune charge native appliquée :proc,expiration et verrou6s non exercés. BUILD/RUN/inspection0 ; états,cases,inconnues et preuves antérieures conservés,aucun gameplay modifié. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Sona. Goal actif.
