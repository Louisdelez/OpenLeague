# Karma — sources et consommateurs du passif, V583

Date UTC : 2026-10-26T03:49:43.704670+00:00. Projet `F:/OpenLeague`. Tâche : **SYS-01.2-02**, relier chaque exigence à une source native et à son consommateur actuel.

## Résultat

Trois fiches Karma reliées à **12 sources natives**, **36 associations** et **19 points de code**, soit **38 liens** pour les fiches contrat/simulation. Quatre sources de preuves ajoutées. Les statuts, critères, trois inconnues propres, quatre dépendances et propriétaires des questions restent conservés.

**Le moteur refuse Mantra et l’apprentissage des sorts de Karma.** Les attaques ordinaires fonctionnent, mais aucun délai de Mantra n’est armé dans les scénarios publics : ils ne peuvent donc pas qualifier le remboursement du passif. Le résultat est un raccordement vérifié de cette limite aux sources, pas une implémentation ou une acceptation de Karma.

## Sources natives et ambiguïtés

Référence : PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 à 17:46:45 ; fuseau et déploiement inconnus. Catalogue 4.20.1 distinct. Les sources du client original sur D: sont vérifiées par taille/SHA-256 et appartenance aux projets RADS sélectionnés ; cela ne prouve pas la priorité historique de montage.

| Fichier | Source enregistrée |
|---|---|
| Karma.inibin | OLS-1e932b8e-536e-54be-a9f4-cf5b32c81c1b |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptKarma.luaobj | OLS-4f965679-083b-5ecd-b034-a612b6c657a9 |
| CharScriptKarma.preload | OLS-54cd072e-ec9e-513c-846e-3fb604e6810b |
| KarmaMantra.inibin | OLS-443a42d3-df7b-5db1-b1e7-b14bfe86681b |
| KarmaMantra.luaobj | OLS-bb3b7508-d35e-56b7-9a4b-fab3add6c9ed |
| KarmaMantra.preload | OLS-52299bac-c8c3-5df1-aa05-4f555e1bd662 |
| KarmaPassive.inibin | OLS-c40d9256-21eb-51d0-86f0-bcf354bedf90 |
| KarmaPassive.luaobj | OLS-311c1c80-6a0d-580f-b20b-453534f91505 |
| Karma.ddf | OLS-c75bc548-0a68-5a74-b280-65038823de0b |
| KarmaChakraCounter.luaobj | OLS-1e7c2bf1-ee60-5bbc-82d0-e31356506758 |
| KarmaChakraCounter.preload | OLS-df29c924-8ac8-5a8c-89c0-0a03e9021b31 |

- `Karma.inibin` associe le passif à `KarmaPassive` et R à `KarmaMantra`. `PassLev1Desc1` lie la description en_GB ligne 4210 : dégâts d’une capacité à un champion ennemi, moitié de l’effet sur les attaques de base.
- Les buffs `KarmaPassive` et `KarmaMantra` ont des liaisons directes résolues, lignes 2145 et 2139. Le passif expose **@f1@ / @f2@**, pas des durées numériques résolues. Les textes de sort 9534/11629 décrivent le même mécanisme.
- Le texte Mantra ligne 9533 annonce sa disponibilité dès le niveau 1 sans point de compétence. Son tooltip 11628 décrit une fenêtre d’amélioration de huit secondes. Les champs natifs de délai sont **45/42/39/36 secondes**. Disponibilité, délai et fenêtre d’amélioration sont trois contrats distincts.
- Le DDF contient 28 lignes, dont quatre lignes `KarmaPassive` à liens et coefficients vides. Il ne fournit pas la résolution de f1/f2. La ligne `KarmaChakra` avec 30/25/20 et les valeurs d’amélioration classées avec Mantra restent du contexte qualifié séparément.
- Le `SpellData` du passif conserve `Cooldown1=8`, effets 18/36/54/72 et 30/60/90/120. Aucune liaison inspectée ne permet de les déclarer comme durées de remboursement f1/f2. Les valeurs sont conservées, sans interprétation automatique.
- Les anciennes descriptions d’aura de régénération de santé et de régénération de mana du personnage restent visibles ; elles ne remplacent pas la description passive liée. Les six champs de niveaux du passif sont absents, sans valeur inventée.
- L’icône du personnage `Karma_Passive.dds` diffère de `KarmaInnerFlame.dds` dans les métadonnées Lua du buff. Aucun alias ni remplacement automatique.
- Quatre Lua sont lus intégralement, zéro prototype enfant. Trois initialisations littérales sont qualifiées ; `KarmaMantra.luaobj` dépasse le lecteur littéral sur **NEWTABLE pc6**. Il s’agit d’une limite du lecteur, pas d’une corruption établie.
- Trois preloads décrivent le passif, les particules d’activation/refresh et un ancien compteur Chakra à une/deux charges. Les flags `IsDamagingSpell`, `DoesntTriggerSpellCasts`, persistance et non-dissipation du compteur sont des métadonnées ; ils ne prouvent pas la politique serveur de Gathering Fire.
- Huit références communautaires sont identifiées séparément. Le `CharScriptKarma.cs` est vide ; les Q/W/E/R et JSON communautaires ne sont pas assimilés au serveur historique.

## Diagnostic exécuté

Compilation privée avec `cargo build --locked --offline`, vrai `crates/core/src/lib.rs` non-test. Dépendances et checksums alignés sur le lock racine. **1 158 entrées de code/ressources** et les preuves antérieures sont contrôlées ; la chaîne Jinx V582, ses échecs de stockage et ses reçus de récupération sont conservés.

Exécutable `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-karma-passive-gathering-fire-probe.exe` — 6049792 octets — SHA-256 `f0f2927e2383981625873442b3a45169212159eaf776716083d7dc2df2a7266e`.

Deux parties Map10 neuves : Karma contre Annie, déplacements publics jusqu’à la zone centrale, six attaques atteignant la cible, Stop puis 90 ticks d’observation. Achat public du Codex 3108 dans le deuxième cas. Aucun changement direct de vie, mana, niveau, position, délai ou horloge.

| Cas | CDR | AP | Impacts témoins | Refus | Ticks après attaques |
|---|---:|---:|---:|---:|---:|
| base | 0.0% | 0 | 6 | 17 | 90 |
| codex | 10.0% | 30 | 6 | 17 | 90 |

Les douze impacts possèdent des projectiles source/cible témoins non critiques. Les dégâts physiques observés, corrigés de la régénération, correspondent au calcul AD/résistance avec résidu inférieur à 0,002. Les autres ticks ne présentent que la régénération prévue. Les deux champions restent vivants, sans événement d’élimination.

Dans les deux cas, Karma reste niveau 1, rangs `[0,0,0,0]`, délais `[0,0,0,0]`. Les **34 refus** couvrent joueur inconnu, attaque sur soi, slot invalide, Learn/Cast/CastAt pour QWER, et Mantra sans cible avant/après les attaques. Chaque refus conserve le snapshot. Le refus de Mantra sans cible évite de confondre absence de support et simple mauvais type de cible.

### Contrôle distinct du système générique de délai

Deux simulations supplémentaires avec Garen : achat éventuel du Codex, apprentissage public de Q, lancement accepté, tentative de relance refusée, puis 90 ticks d’observation. Le délai absolu reste constant pendant le décompte naturel.

| Cas | CDR | Délai créé | Refus | Observation |
|---|---:|---:|---:|---:|
| Garen Q sans Codex | 0 % | 240 ticks | 1 | 90 ticks |
| Garen Q avec Codex | 10 % | 216 ticks | 1 | 90 ticks |

Total du lot : **12 impacts, 36 refus publics sans mutation, 180 ticks après les attaques de Karma et 180 ticks de contrôle Garen**. La réduction générique à la création du délai fonctionne dans ces contrôles ; elle n’est pas un remboursement sur hit, ni Gathering Fire.

Les contrôles attendus et observés sont distincts de l’acceptation historique : le diagnostic confirme la limite actuelle, tandis que la disponibilité de Mantra décrite par la référence n’est pas réalisée. Les snapshots n’établissent ni transport réseau, ni affichage, ni audio.

## Consommateurs actuels reliés

| Source et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | initialization |
| crates/core/src/lib.rs:598 | public_actions |
| crates/core/src/progression.rs:68 | generic_CDR_reader_not_hit_refund |
| crates/core/src/progression.rs:46 | ordinary_level_growth |
| crates/core/src/progression.rs:150 | learn_boundary |
| crates/core/src/progression.rs:159 | unsupported_Karma_ranks |
| crates/core/src/spells.rs:101 | unsupported_Karma_cast |
| crates/core/src/annie_w.rs:29 | unsupported_Karma_ground_cast |
| crates/core/src/lib.rs:685 | tick_order |
| crates/core/src/shop.rs:215 | Codex_positive_control |
| crates/core/src/shop.rs:261 | public_purchase |
| crates/core/src/lib.rs:744 | diagnostic_not_network_acceptance |
| crates/core/src/lifecycle.rs:33 | static_only_no_Karma_passive_lifecycle |
| crates/core/src/attacks.rs:157 | actual_ranged_projectiles |
| crates/core/src/damage.rs:53 | actual_champion_death_dispatch |
| crates/core/src/cooldown.rs:11 | generic_cast_time_reduction_not_hit_refund |
| crates/core/src/cooldown.rs:10 | generic_CDR_cap_not_GatheringFire |
| crates/core/src/lifesteal.rs:4 | ordinary_damage_no_Karma_refund |
| crates/core/src/ezreal_q.rs:190 | static_only_other_champion_refund_not_Karma |

Les frontières d’apprentissage et de cast refusent explicitement Karma. Les attaques ordinaires et dégâts ne fournissent pas un remboursement Karma identifié. Le pipeline générique CDR et le shop sont des consommateurs réels distincts. Le remboursement spécifique d’Ezreal Q est inspecté statiquement pour éviter sa confusion avec Gathering Fire ; il n’est pas exercé ni adopté comme contrat de Karma dans ce lot. La gestion de réapparition est également un contexte statique, sans acceptation du cycle de vie du passif.

Huit ressources locales de profils/règles sont conservées comme entrées du moteur, séparées des sources natives. Les sélecteurs incluent Karma, Annie et Garen lorsque pertinents.

## Travail restant et limites

1. Disponibilité et progression spécifiques de Mantra dès le niveau 1 ; lancement réel, coût, fenêtre d’amélioration et dépense du délai. La grille générique d’ultime 6/11/16 ne suffit pas.
2. Valeurs de remboursement f1/f2, progression par niveau et justification historique. Les données héritées non liées ne servent pas de valeurs par défaut.
3. Hits de capacités et attaques éligibles, dégâts persistants, multicibles, critiques, invocations, dégâts annulés ou absorbés, cibles alliées et non champions.
4. Plancher de réduction, ordre avec CDR, hits simultanés, disponibilité au même tick, répétition et éventuels rafraîchissements.
5. Mort/réapparition, déconnexion, changement de session et fin de partie.
6. HUD de Mantra et du passif, icônes, animations, VFX, audio et réseau, avec observations effectives.
7. Après intégration, tester un vrai Mantra lancé puis les hits publics ; les délais nuls actuellement observés ne prouvent ni le montant ni l’absence isolée d’un remboursement d’un délai actif.

Aucun serveur historique n’est exécuté. Les métadonnées et preloads ne prouvent pas de callbacks serveur. Aucun asset 3D manquant n’est déduit de cette limite. Les inconnues de BattleTraining, des autres champions et le défaut de déplacement V564 restent distincts et ouverts.

## Intégration et contrôles de conservation

BUILD, RUN, inspection, PREPARE, CHECK, PUBLISH et AUDIT : retours réels 0, journaux et identités conservés. Une commande de préparation d’une modification locale du script a échoué sur la syntaxe de citation avant toute modification ; la correction a été appliquée par patch avant exécution de l’inspection. Aucun ancien reçu n’est remplacé.

- 72 associations volontairement invalides et quatre graphes invalides refusés.
- Trois fragments de consignes modifiés, 42 212 inchangés. Les autres objets et descripteurs anciens restent exacts.
- Deux bases locales synchronisées : quatre destinataires, 42 603 autres lignes inchangées, **42 607 états manuels et 23 historiques conservés**. Synchronisation normale idempotente.
- Identités, hiérarchie et inconnues inchangées octet pour octet ; trois questions propres et quatre dépendances conservées avec leurs propriétaires.
- Graphe : 99 009 sources, 3 611 consommateurs, 42 215 exigences, 26 189 inconnues ouvertes et 5 517 résolues déjà recensées. Revue globale : **3 611 ancres exactes, zéro divergence courante**. Ce contrôle structurel ne prétend pas re-hacher toutes les sources ; les entrées sélectionnées sont vérifiées séparément.

Livraison : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`, `docs/reference_requirement_trace_sources/karma-passive-gathering_fire-links-v583.json`, `docs/fidelity_karma_passive_gathering_fire_links_v583.json`, ce rapport, `coverage.json`, `completion_plan.json`, `resume_checkpoint.json`, `docs/ai/CURRENT.md` et `HANDOFF.md`. Les données/consignes des deux bases sont actualisées sans accepter ni cocher automatiquement les tâches. Aucun code de gameplay ni asset modifié.

Dossiers de preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` : `revision583_Karma_discovery`, `revision583_Karma_passive_probe`, `revision583_Karma_inspection_verified`, `revision583_Karma`, puis revue `revision584_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision584_trace_review/REVIEW.json. Karma V583 publié/audité :12sources natives,36associations,19points/38liens. Deux cas Karma12impacts physiques avec témoins,34refus180ticks;Mantra non disponible,donc aucun remboursement de délai armé exercé. Deux contrôles GarenQ distincts240/216ticks,2refus180ticks;Codex10%CDR30AP. Texte dégâts aux champions/moitié sur attaques;f1/f2nonrésolus,Mantra niveau1 et fenêtre8s,cooldowns45/42/39/36. DDF28dont4passifs vides;anciennes descriptions HP/mana,effets18/36/54/72 et Chakra30/25/20 nonadoptés.4Lua3littéraux1NEWTABLEpc6,3preloads,2buffs,8communautaires;CharScript vide. Conserver l’historique JinxV582 et récupération disque,les inconnues et défaut déplacementV564. Poursuivre un autre passif après inspection réelle,par exemple Karthus. Goal actif;aucun statut/case/inconnu fermé.
