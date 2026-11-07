# SYS-01.2-02 — Master Yi : sources et consommateurs de Double Strike (V601)

Date UTC : 2026-10-26T08:50:45.291619+00:00. Projet : F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau et déploiement non établis. Catalogue officiel 4.20.1 distinct.

## Résultat

Les fiches CH-MasterYi-PASSIF-SOURCE, CH-MasterYi-PASSIF-SIMULATION-CONTRAT et CH-MasterYi-PASSIF-SIMULATION sont reliées à 54 sources natives (162 associations) et à 23 points de code (46 liens sur les fiches de simulation). Les points actuels restent qualifiés comme frontières ou contexte, sans consommateur complet du passif démontré.

Trois cas publics produisent huit attaques ordinaires chacun. Aucun second coup n’apparaît, y compris après la quatrième attaque. Les variantes épée longue et dague modifient correctement les dégâts et la cadence ordinaires. Les sorts Master Yi sont refusés. Ce lot améliore la traçabilité et démontre un écart ; il ne termine ni le passif, ni le champion, ni le jeu. Aucun gameplay ou asset modifié.

## Sources et divergences

- MasterYi.inibin lie MasterYiPassive, l’icône MasterYi_Passive1.dds et ExtraSpell1 MasterYiDoubleStrike. Le texte de personnage en_GB ligne 4232 reste vague (« chaque quelques coups »), tandis que le buff MasterYiPassive ligne 2278 décrit chaque quatrième attaque de base consécutive avec un second coup à 50 % des dégâts.
- DoubleStrikeStacks ligne 1841 précise la quatrième attaque ; DoubleStrikeReady ligne 1840 annonce le prochain coup double. Le BuffData de DoubleStrike.inibin demande game_buff_tooltip_DoubleStrike, absent du fontconfig sélectionné. Cette clé n’est pas remplacée silencieusement par Ready ou Stacks.
- Le champ ancien Passive1Desc parle de chance de second coup. Il est conservé comme divergence historique, sans transformer le passif en probabilité. PassLev1Desc2..4 décrit 40/60/80 % de régénération mana ; ces champs ne sont pas une progression de Double Strike. Les six Passive1Level sont absents (None), sans valeur par défaut inventée.
- MasterYiDoubleStrike.inibin a un tooltip SpellData présent mais vide, la description du personnage, portée 20, rayon 100, coût et délai nuls, coefficients 0/0. Ces valeurs ne démontrent pas des dégâts secondaires nuls. CanCrit et ApplyOnHitEffects sont absents ; leur absence n’est pas un booléen false et ne définit pas les règles de critique ou d’effets à l’impact.
- DoubleStrike.luaobj configure le buff Ready avec l’icône Passive1 ; Stacks utilise Passive2, avec persistance et non-dissipation. MasterYiPassive possède également persistance/non-dissipation. Ces métadonnées ne démontrent pas le compteur, sa durée ou son comportement à la mort.
- 23 Lua sont parcourus intégralement, sans fonctions enfants : 14 initialisations littérales et 9 limites NEWTABLE. Les limites concernent AlphaStrike, Bounce, Highlander, les trois attaques, MasterYiDoubleStrike, Meditate et Defense. CharScriptMasterYi est vide. Ce lecteur ne constitue pas une exécution du serveur historique ; ses limites ne prouvent pas une corruption.
- 11 preloads relient notamment Stacks, Ready, Passive, Wuju, gestionnaires de lame et particule masteryi_base_p_tar.troy. Les effets, animations et sons ne sont pas exécutés ici.
- MasterYi.ddf contient 16 lignes Q/W/E/R : AlphaStrike f1 = 0,6 AD et WujuStyle f2 = 0,1/0,125/0,15/0,175/0,20 AD, autres lignes vides. Ce DDF ne fournit pas une formule Double Strike ; les interactions avec Q/E restent à qualifier séparément.
- Dix clés BuffData : neuf résolues exactement une fois, une absente (DoubleStrike). Les 23 références communautaires restent secondaires ; CharScriptMasterYi.cs est vide.
- Six chemins candidats sont absents : CharScript sous Scripts (le vrai est à la racine), DoubleStrike.inibin et MasterYiDoubleStrike.luaobj sous DATA/Spells (les vrais sont dans Characters/MasterYi/Spells), DoubleStrike.preload, DoubleStrikeReady.luaobj et MasterYiPassive.preload. Aucune absence globale de texture, modèle, animation ou son n’en est déduite.

Les sources retenues correspondent au registre et au manifeste RADS sélectionné, avec taille et SHA-256 vérifiés. Les identifiants ci-dessous renvoient aux chemins et détails dans les preuves.

| Fichier | Source |
|---|---|
| MasterYi.inibin | OLS-2f3137d5-a1c9-565f-95fe-cda1672c26e4 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| MasterYi.ddf | OLS-dc829ab4-810e-59a8-932e-a72658b3e3d7 |
| CharScriptMasterYi.luaobj | OLS-25d6a83d-3e31-5438-82ab-bcf8a3cec3eb |
| CharScriptMasterYi.preload | OLS-32f4a949-3b41-5e1f-ba13-79d44a67a601 |
| Alpha Strike.inibin | OLS-dd488e6e-78ce-5f34-9379-6a6fdcfdbf88 |
| Alpha Striking.inibin | OLS-31ad13f1-378a-57a7-9195-b8d68068e4a2 |
| AlphaStrike.inibin | OLS-3c3b92e3-eca7-55fa-9638-40d3db164565 |
| AlphaStrike.luaobj | OLS-aae189ec-ef9c-5a6b-85d1-ddd7ead001bc |
| AlphaStrike.preload | OLS-5763985d-a830-525e-96d5-531b9616cdce |
| AlphaStrikeBounce.inibin | OLS-34351e25-1cad-5788-a596-175a1440c052 |
| AlphaStrikeBounce.luaobj | OLS-5a49ee97-5c28-58cd-85ee-afa08f88a445 |
| AlphaStrikeBounce.preload | OLS-aaedaaf9-578c-5e63-802e-bd4d83e1202d |
| AlphaStrikeMarker.luaobj | OLS-903109d3-395a-501e-91e6-280ddc522f22 |
| AlphaStrikeMarker.preload | OLS-5e6f8f87-888e-5797-98a7-80d75bcdb02d |
| AlphaStrikeTarget.luaobj | OLS-6a89e04c-c462-5de2-b0bc-eaa8076ec61f |
| AlphaStrikeTarget.preload | OLS-89676a23-e746-575d-8979-5724b21d0466 |
| AlphaStrikeTeleport.inibin | OLS-ef704226-a9fa-5501-82cf-1fd907f31564 |
| AlphaStrikeTeleport.luaobj | OLS-e9f0c53b-9890-5c37-a49e-2abd4e28e7cc |
| DoubleStrike.inibin | OLS-fd6e6054-7f5f-553a-87b0-856487c588cc |
| DoubleStrike.luaobj | OLS-e2a2df7f-a058-5dfd-ad0b-d9eecdd61a0e |
| DoubleStrikeReady.inibin | OLS-f23f2c68-288f-532a-91a3-512af0c2ed8c |
| DoubleStrikeStacks.inibin | OLS-d4978545-ba1a-5034-9d52-e620ef3481ca |
| DoubleStrikeStacks.luaobj | OLS-06eb9318-af31-5058-b3b2-04c124ece8bc |
| Highlander.inibin | OLS-64dbc9e6-7002-5fff-9a32-f2f7c782dada |
| Highlander.luaobj | OLS-323d526f-c769-590d-b73d-4e0962c4cfa9 |
| Highlander.preload | OLS-56b71877-27bf-583e-99f8-8e384a32af79 |
| MasterYiBasicAttack.inibin | OLS-d9c5b06b-b135-5c18-9683-5d88c4adeb25 |
| MasterYiBasicAttack.luaobj | OLS-a8cab58e-acc8-5344-921b-2cfa23400108 |
| MasterYiBasicAttack2.inibin | OLS-b553ab52-30c5-5821-bc32-897e95e32ea1 |
| MasterYiBasicAttack2.luaobj | OLS-4c0f50c7-86d1-568f-abca-5d272f0e1831 |
| MasterYiBladeManager.luaobj | OLS-b3ce00d3-9594-517b-ac46-d1d2055e5575 |
| MasterYiBladeManager.preload | OLS-cd2f6738-cb7a-585c-bfe0-a5fe637bace5 |
| MasterYiCritAttack.inibin | OLS-4c58877b-e637-5695-8db8-ca18a20497a8 |
| MasterYiCritAttack.luaobj | OLS-5d714c16-cb5a-5674-bd54-e3186d739f06 |
| MasterYiDoubleStrike.inibin | OLS-de3268c3-7d1b-5f97-8bbd-a5c993a28a57 |
| MasterYiDoubleStrike.luaobj | OLS-9ddba09f-740e-566a-836d-47f2e76a3e47 |
| MasterYiDoubleStrike.preload | OLS-87a8ee9b-7761-5bc5-af76-0d1180144558 |
| MasterYiPassive.inibin | OLS-9265faff-c4c7-5453-9cb9-a20b896ed67d |
| MasterYiPassive.luaobj | OLS-7310016f-03cf-5b8e-8773-5d41db1f2bf7 |
| MasterYiTauntManager.luaobj | OLS-55b93a9b-1a85-57c5-983f-95d76490578f |
| MasterYiWujuDeactivated.luaobj | OLS-3f7c14b3-a39d-57be-8d43-5619968d5157 |
| Meditate.inibin | OLS-8b0726f3-385a-5ccf-9a98-e97fa6cfddb7 |
| Meditate.luaobj | OLS-ad06de9c-0de2-5cd1-924d-2f913887fa61 |
| Meditate.preload | OLS-2552ce9d-b7a6-57e7-bc9d-36c60fe65cd0 |
| MeditateDefense.luaobj | OLS-234ee715-0aab-57e4-9ab2-536b5fbda9cc |
| WujuStyle.inibin | OLS-1f83d30f-207a-5311-9757-7864322a5267 |
| WujuStyle.luaobj | OLS-718d6d15-e78e-5bb7-a1f9-1afc6b59dd35 |
| WujuStyle.preload | OLS-44ec1a50-c34e-5ecc-b82f-83f724c10dd6 |
| WujuStyleSuperCharged.inibin | OLS-29b1239b-1c68-5e73-a13d-a32b1c14895b |
| WujuStyleSuperCharged.luaobj | OLS-163a2039-cb7c-5500-bb83-25d9fe81e8d3 |
| WujuStyleSuperCharged.preload | OLS-80a3bbbe-ea81-5f35-9977-b7525aa591c2 |
| WujuStyleSuperChargedVisual.luaobj | OLS-44f804d5-62af-5aa3-8b43-2c77c221f43b |
| WujuStyleVisual.luaobj | OLS-e7074258-fe4b-55de-8162-ef27406d16a5 |

## Contrôles exécutés

Compilation Rust `--locked --offline`, core réel non compilé comme test ; identités/checksums des dépendances alignés sur Cargo.lock. Simulation Map10 avec Join/Buy/Move/Stop/Attack publics, sans injection directe d’état ni attaque secondaire artificielle. Les deux champions restent vivants, de niveau 1, sans victoire ou mort enregistrée ; mana Master Yi pleine, rangs et délais nuls. Aucun critique observé.

| Cas | AD | Intervalle entre impacts (ticks) | Impacts | Refus atomiques | Ticks après Stop |
|---|---:|---:|---:|---:|---:|
| base | 60.04000 | 44 | 8 | 27 | 180 |
| LongSword_AD_control | 70.04000 | 44 | 8 | 27 | 180 |
| Dagger_cadence_control | 60.04000 | 38 | 8 | 27 | 180 |

Attendu et observé pour les fonctions ordinaires : chaque perte de PV correspond au windup de Master Yi, à sa cible, au tick de relâchement et aux dégâts physiques mitigés par armure, corrigés de la régénération ; résidu inférieur à 0,002. Sept intervalles par cas sont constants : 44, 44 et 38 ticks. L’épée ajoute 10 AD ; la dague réduit la cadence. Les huit coups, dont les coups 4 et 8, produisent seulement ces dégâts ordinaires ; aucun impact supplémentaire entre les coups ou durant les 180 ticks après Stop de chaque cas.

La fenêtre de huit attaques couvre le premier déclenchement décrit par le tooltip. Elle ne fixe pas la cadence historique des cycles suivants : il reste notamment à déterminer si le coup secondaire alimente lui-même le compteur. Les 540 ticks après Stop ne valident pas un délai de remise à zéro des charges.

Les 81 refus conservent exactement le snapshot : joueur inconnu, auto-ciblage, slot invalide, apprentissage et lancement ciblé/au sol Q/W/E/R avant et après les attaques. Les fonctions actuelles signalent explicitement les sorts non implémentés. Aucun sort Master Yi accepté, aucun compteur ni frappe secondaire qualifié.

Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-masteryi-passive-double-strike-probe.exe` ; 6043136 octets ; SHA-256 `892df60cc21a59a4e5ed26d9fdb14cef1a0130d06c3f1e3abf79f4550873bbde`. BUILD et RUN renvoient 0. Les 1158 entrées du core/ressources et la chaîne des preuves antérieures sont revérifiées et conservées. Le succès du diagnostic ne qualifie pas Double Strike.

## Consommateurs actuels

Les frontières join/command, progression des compétences, attaques, stats, objets, critique, dommages et régénération sont reliées. basic_attack_hit applique les effets ordinaires et la fonction roll_critical traite ici une chance nulle ; cela ne démontre pas les règles du second coup. Aucun consommateur spécifique Master Yi n’a été identifié dans le core inspecté.

| Ancre exacte | Rôle qualifié |
|---|---|
| crates/core/src/lib.rs:533 | public owner/enemy initialization |
| crates/core/src/lib.rs:598 | public action boundary |
| crates/core/src/progression.rs:68 | ordinary AD/cadence and target resistance |
| crates/core/src/progression.rs:150 | unsupported MasterYi learning |
| crates/core/src/progression.rs:159 | unsupported MasterYi rank policy |
| crates/core/src/spells.rs:101 | unsupported MasterYi cast |
| crates/core/src/annie_w.rs:29 | unsupported MasterYi ground cast |
| crates/core/src/lib.rs:685 | ordinary tick order |
| crates/core/src/lib.rs:744 | observed public state not network acceptance |
| crates/core/src/damage.rs:53 | ordinary physical impact boundary |
| crates/core/src/attacks.rs:157 | ordinary MasterYi melee impacts |
| crates/core/src/lifesteal.rs:4 | ordinary basic hit entry |
| crates/core/src/regeneration.rs:32 | ordinary health regeneration during waiting |
| crates/core/src/regeneration.rs:10 | ordinary target health regeneration correction |
| crates/core/src/shop.rs:261 | public LongSword10AD andDagger controls |
| crates/core/src/shop.rs:215 | ordinary item bonuses |
| crates/core/src/world.rs:226 | current enemy identity |
| crates/core/src/damage.rs:38 | ordinary physical mitigation |
| crates/core/src/attacks.rs:26 | ordinary windup profile,not secondhit timing |
| crates/core/src/critical.rs:12 | ordinary critical profile;DoubleStrike critical policy not exercised |
| crates/core/src/death_recap.rs:184 | current ordinary capture context,not secondhit attribution |
| crates/core/src/death_recap.rs:200 | ordinary damage recap context,not accepted DoubleStrike attribution |
| crates/core/src/critical.rs:19 | ordinary zero-chance control;not secondstrike critical policy |

## Livraison et conservation

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_sources_4_20.json et fidelity_requirement_trace_4_20.json. Reçu : docs/reference_requirement_trace_sources/masteryi-passive-double-strike-links-v601.json. Preuve : docs/fidelity_masteryi_passive_double_strike_links_v601.json. Les instructions copiables décrivent les règles sourcées, divergences, contrôles et tâches restantes ; SYS-01.2-02 reçoit la synthèse.

Deux bases SQLite mises à jour, projet et application installée : quatre destinataires, 42603 autres lignes intactes, 42607 états manuels et 23 historiques conservés. Synchronisation normale idempotente. Identifiants, phases/lots et inconnues identiques octet par octet ; trois questions propres et quatre dépendances conservées. Aucun statut, critère, propriétaire, note ou case modifié automatiquement.

PREPARE/CHECK/PUBLISH/AUDIT réussissent avec code 0. Les contrôles refusent 72 associations volontairement altérées et quatre graphes invalides. Trois fragments de traçabilité changent, 42212 restent identiques. Revue globale : 99081 sources, 4043 consommateurs, 4043 ancres exactes, aucune divergence. source_hashes_verified=0 désigne la validation structurelle globale ; les payloads sélectionnés et fichiers de consommateurs sont contrôlés séparément, sans prétendre revalider tous les assets.

coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md sont mis à jour en conservant les champs et preuves antérieurs. Aucun stage/reset/commit/nettoyage.

Preuves privées : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision601_MasterYi_discovery/OBSERVATIONS.json ; revision601_MasterYi_passive_probe/OBSERVATIONS.json ; revision601_MasterYi_inspection_qualified/OBSERVATIONS.json ; revision601_MasterYi/DELIVERY_AUDIT.json ; revision602_trace_review/REVIEW.json. Les reçus de commande fixent les commandes et codes réellement exécutés.

## Travail restant

1. Qualifier et implémenter le compteur : événement incrémentant, état initial, plafond, effet du coup secondaire sur le cycle suivant, délai/reset et interruption de la succession.
2. Produire le véritable second coup : identité, cible, timing, coefficient 50 %, capture/recalcul de l’AD et mitigation.
3. Qualifier critiques, effets à l’impact, pénétration, vol de vie, boucliers, immunités, mort de cible au premier coup, sur-dégâts et attribution.
4. Tester annulations, déplacement/Stop, changement de cible, perte de vision, contrôles et simultanéité.
5. Qualifier séparément les interactions avec Q/W/E/R, objets, niveaux et cadence ; ne pas utiliser les DDF Q/E comme formule du passif.
6. Couvrir champions, sbires, monstres et structures, plusieurs propriétaires, mort/respawn, déconnexion et fin de partie.
7. Vérifier HUD des charges, icônes, animation de double frappe, particules, sons, rendu et réplication réseau.

Les lacunes Battle Training précédentes et le défaut V564 restent ouverts. Aucun serveur historique, rendu graphique ou transport réseau exécuté dans ce diagnostic.

Suite : Continuer SYS-01.2-02 depuis revision602_trace_review/REVIEW.json. MasterYi V601 intégré :54sources162associations23points46liens. 54 sources natives et 23 références communautaires : 23 Lua dont 9 limites NEWTABLE, 11 preloads, 10 buffs dont 9 résolus et DoubleStrike absent, 16 lignes DDF QWER. Le tooltip décrit chaque quatrième attaque consécutive et un second coup à 50%. Ancien texte de chance, mana40/60/80%, coefficients0 et champs critiques/onhit absents conservés sans adoption. CharScript vides ; six chemins candidats absents. Trois cas publics base/épée10AD/dague :24 impacts ordinaires,81 refus,540 ticks de fin. Huit coups par cas dont4/8 sans second impact ; cadences44/44/38, AD60,04/70,04/60,04. Le compteur, la frappe secondaire, son critique/onhit et son reset restent non qualifiés. BUILD/RUN/inspection/prepare/check/publish/audit0 ;72+4refus. Conserver preuves et défaut V564. Prochain passif à inspecter réellement : MissFortune. Goal actif, aucun statut/case/inconnue fermé.
