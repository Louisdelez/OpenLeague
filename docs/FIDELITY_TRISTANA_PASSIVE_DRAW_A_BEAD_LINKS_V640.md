# Tristana — Draw a Bead : sources et portées, V640

Date UTC : 2026-10-26T21:26:21.173969+00:00. Projet `F:/OpenLeague`. Tâche SYS-01.2-02 : relier chaque exigence aux sources et consommateurs actuels. Trois fiches Tristana enrichies : PASSIF-SOURCE, PASSIF-SIMULATION-CONTRAT, PASSIF-SIMULATION ; suivi SYS également enrichi. Aucun code de jeu ni asset modifié.

## Résultat et limite

**Le moteur conserve une portée de base de 550 aux niveaux 1 à 18.** Aux niveaux 1 et 18, Tristana attaque une cible située à 550 sans se déplacer ; elle poursuit une cible située à 650 avant de tirer. Aucun accroissement de portée n’est observé dans ces cas. E et R restent refusés : leurs portées effectives ne sont pas mesurées.

Les textes natifs décrivent pourtant une augmentation de la portée des attaques avec les niveaux et incluent E/R dans le tooltip du passif. Les valeurs exactes de cette progression et leurs producteurs restent non résolus. La livraison relie 30 sources, 90 associations et 18 points de code, avec 36 liens aux fiches de simulation. Les points demeurent qualifiés comme frontières ou mécanismes génériques, pas comme implémentation acceptée du passif.

## Référence et sources

PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et date de déploiement inconnus. Catalogue officiel 4.20.1 distinct. Deploy sous `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy`.

14 INIBIN, 11 Lua, 4 preloads et fontconfig_en_GB.txt. Les octets et l’appartenance aux manifestes sélectionnés sont contrôlés ; le chargement historique effectif n’est pas qualifié. Aucun DDF Tristana trouvé dans la recherche `*Tristana*.ddf` du deploy fourni. CharScriptTristana.luaobj est à la racine du personnage, retrouvé grâce aux liens antérieurs. Les noms avec espaces des buffs restent distincts des noms des sorts.

| Source | Identité du registre |
|---|---|
| Tristana.inibin | OLS-96f4d85b-ea05-53c6-8166-584638833778 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Buster Shot.inibin | OLS-f7a8620c-765b-5ad0-9fb3-03784875e259 |
| BusterShot.inibin | OLS-6d0601de-f479-5829-8f11-d22cfded87c2 |
| BusterShot.luaobj | OLS-1eb996ad-22d4-5c0d-9bef-3c30eaee4b31 |
| BusterShot.preload | OLS-82908d0e-055d-5a61-9cc0-fe9e42d25f64 |
| Detonating Shot.inibin | OLS-f52e8fef-4ae3-56f8-a08c-34c9236e7435 |
| DetonatingShot.inibin | OLS-f401a215-96da-5b78-b522-e705355ae3b2 |
| DetonatingShot.luaobj | OLS-f5a51553-316f-526c-b680-b91b25aa7e9a |
| DetonatingShot.preload | OLS-14049c88-0e81-5097-80cc-f554fa80eeb7 |
| Draw a Bead.inibin | OLS-d5599425-6d71-58ea-bac0-dd082f01caa5 |
| DrawABead.luaobj | OLS-0faadb63-e4cd-5e39-a6ee-19eccfbf9fcf |
| DrawABead.preload | OLS-bfb09274-d3f7-5f87-9e86-f69eed4697ff |
| Explosive Shot Debuff.inibin | OLS-a6a92ade-5b08-56eb-837b-028bb4b5b190 |
| ExplosiveShotDebuff.luaobj | OLS-4f1d71ec-49f4-594b-bb15-0efffa996e89 |
| Rapid Fire.inibin | OLS-5e072bf2-2798-5b31-8622-d4a3476fed86 |
| RapidFire.inibin | OLS-ff6bfce7-f2e9-53d3-a469-6c0ee7a6ba24 |
| RapidFire.luaobj | OLS-f59f6d03-c62d-58a5-918f-bc3121da3a88 |
| RocketJump.inibin | OLS-bd93f257-9d4c-5cdb-99e7-b034dc9306d4 |
| RocketJump.luaobj | OLS-7ec44a99-361a-58a7-b555-ab8c9085eacd |
| RocketJump.preload | OLS-5b801701-ff1b-54a3-b9ca-b035c70a33d5 |
| RocketJumpSlow.inibin | OLS-774e623b-7f91-5985-a855-80b7ce448f28 |
| RocketJumpSlow.luaobj | OLS-5b4f0003-a811-5b9c-840e-88d7ad9c4ea3 |
| TristanaBasicAttack.inibin | OLS-88dbdb65-5fbf-5dda-aee6-4fb7cc9c2a73 |
| TristanaBasicAttack.luaobj | OLS-b63d3501-59e1-5588-8330-8ba469773c25 |
| TristanaBasicAttack2.inibin | OLS-bf4a367a-c049-58e6-b5fa-6b5e67ecac0e |
| TristanaBasicAttack2.luaobj | OLS-733cbb13-4e52-5566-a1fa-ef3460085bd2 |
| TristanaCritAttack.inibin | OLS-ef81367e-6eee-5de2-8ed0-c83280ace19e |
| TristanaCritAttack.luaobj | OLS-1e668852-0447-5cb8-9468-715ad38434bc |
| CharScriptTristana.luaobj | OLS-2e1363a9-3284-5adf-a2c5-17c0ec92c7f0 |

## Contrat natif

Tristana.inibin sélectionne `Draw a Bead`, icône Tristana_DrawABead.dds, attaque de base 550. La description, ligne 4290, indique une augmentation avec les niveaux. `game_buff_tooltip_Draw_a_Bead`, ligne 1851, inclut la portée d’attaque et les portées de lancement d’Explosive Shot et Buster Shot avec le paramètre f1. Le tooltip DrawABead, ligne 11487, utilise Effect1Amount sans en produire ici la valeur. E et R ont chacun un CastRange natif `550.0000`.

Passive1, Passive1Desc, AttackRangePerLevel et les six marqueurs Passive1Level sont absents dans les champs recherchés. L’absence n’est pas convertie en zéro. Ces champs et les textes ne permettent pas, seuls, d’établir la série exacte des bonus ou la politique de mise à jour. Aucune formule supposée n’a été ajoutée au jeu.

Les 11 Lua sont lus intégralement et n’ont pas de fonctions enfants. Sept initialisations rencontrent NEWTABLE. CharScript est vide. DrawABead déclare notamment PersistsThroughDeath et NonDispellable ; il ne fournit pas de callback de changement de niveau exécuté. Son preload référence des particules de E ; cela ne qualifie ni portée ni rendu. Les quatre preloads et six BuffData sont conservés, avec six traductions exactes. DetonatingShot précharge ExplosiveShotDebuff, internal_50ms et grievouswound : dépendances identifiées, pas exécution de leurs effets.

## Écarts communautaires

Dix-neuf références, dont cinq C#, inspectées sans exécution du C#. CharScript est vide. Une recherche bornée du sous-arbre LeagueSandbox-Scripts retrouve un appel TristanaRapidFire dans Q et trois opérations TristanaExplosiveStacks dans E ; aucun producteur de Draw a Bead ni de ces buffs n’est retrouvé dans ce périmètre. Un fournisseur extérieur reste inconnu.

- Q appelle TristanaRapidFire pendant sept secondes ; le commentaire de vitesse d’attaque ne constitue pas une preuve du producteur.
- W applique dégâts et Slow autour d’une position, rayon 250, durée 0,5 + 0,5 × rang ; aucun saut ni reset sur kill/assist n’est démontré par ce fichier. Le texte natif décrit ces deux comportements.
- E utilise la classe TristanaExplosive et teste la présence d’un buff pour ajouter des dégâts. Le commentaire annonce quatre charges mais le code inspecté ne vérifie pas un compteur de quatre. Le natif 4.20 décrit une explosion sur les unités tuées par attaque, puis un actif infligeant des dégâts sur cinq secondes et réduisant soins/régénération de 50 %. Ce contrat reste distinct de la référence communautaire.
- R applique dégâts, Airborne 0,5 seconde, puis demi-dégâts et Airborne 0,3 seconde autour de la cible, rayon 200. Le recul et les règles de distance décrits par le natif ne sont pas démontrés par ce fichier.

Ces références restent des pistes partielles ; elles ne sont ni règles natives qualifiées ni consommateurs Rust du jeu courant.

## Contrôles du moteur courant

Le diagnostic privé lie le vrai cœur Rust hors tests et utilise ses commandes publiques. **L’expérience est explicitement fournie par l’API serveur**, sans progression naturelle en partie. Aucun champ de position, rang ou état champion n’est modifié directement.

Phase de rangs : 18 niveaux par champion, 18 appels XP valides par cas dont un au plafond, aucun tick de simulation. La portée de définition de Tristana reste 550 ; celle du témoin Annie reste 625. Annie gagne de l’armure et apprend 18 rangs ; Tristana conserve ses rangs à zéro. Les 144 prédictions de rang concordent avec les commandes.

| Champion | Niveaux | Learn acceptés | Learn refusés | Cast refusés | Refus aux limites | XP invalides | Rangs finaux |
|---|---|---|---|---|---|---|---|
| tristana | 18 | 0 | 72 | 144 | 4 | 5 | [0, 0, 0, 0] |
| annie | 18 | 18 | 54 | 0 | 4 | 5 | [5, 5, 5, 3] |

Total : 278 refus de commandes et 10 refus XP invalides (zéro, négatif, NaN, infini, propriétaire inconnu), avec snapshots inchangés. Les refus d’E/R ne prouvent ni une portée native ni l’absence d’un effet sur un sort accepté : aucun E/R de Tristana n’est accepté ici.

Phase de portée : quatre simulations fraîches sur Map10, huit déplacements publics jusqu’à arrivée, aucun réordre, quatre projectiles observés. L’XP est fournie deux fois pour les cas niveau 18, soit 38 appels XP valides dans l’ensemble du diagnostic. Les quatre cas simulent au total 7 640 ticks, déplacements compris ; la mention « zéro tick » concerne uniquement la phase de rangs.

| Niveau | Distance initiale réelle | Déplacement avant windup | Résultat |
|---|---|---|---|
| 1 | 550 | 0 | Attaque sans poursuite, projectile émis |
| 1 | 650 | 43,33203125 | Poursuite puis projectile |
| 18 | 550 | 0 | Attaque sans poursuite, projectile émis |
| 18 | 650 | 43,33203125 | Poursuite puis projectile |

Les positions demandées sont ajustées par la navigation ; le tableau rapporte les distances mesurées, pas les distances demandées. Position de départ : x=7534,98193359375, z=6934,240234375. Le code local compare la distance entre centres à la portée 550 plus le rayon de la cible. **Le rayon natif de Garen est absent ; 65 est le repli explicite de collision::body_radius.** Le seuil local de 615 ne prouve pas une règle historique de collision. Les positions de premier windup respectent ce seuil aux deux niveaux ; cette mesure n’est pas un contrôle exhaustif des frontières ou de toutes les cibles.

La recherche ciblée de Tristana/Draw a Bead dans les sources Rust ne retrouve pas de producteur spécifique ; les chemins génériques de définition, poursuite et attaque sont inspectés séparément. Aucun patch de gameplay n’est réalisé dans cette tâche d’association.

| Point de code | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/lib.rs:598 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/progression.rs:68 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/progression.rs:150 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/progression.rs:159 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/spells.rs:101 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/annie_w.rs:29 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/lib.rs:744 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/progression.rs:131 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/progression.rs:50 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/progression.rs:46 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/lib.rs:149 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/combat.rs:4 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/attacks.rs:141 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/attacks.rs:157 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/world.rs:226 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/collision.rs:29 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |
| crates/core/src/lib.rs:685 | current XP/rank/refusal or base-range pursuit/attack path;not Tristana range-growth implementation |

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-tristana-passive-draw-a-bead-radius-probe.exe` ; 6087680 octets ; SHA-256 `2630b5ac6b1f37a26c371dc66c177c267f1f6b32a90ddc4075019c2f26224048`. Compilation `cargo build --locked --offline --message-format=json` et exécution corrigées : codes 0. Les 1 158 entrées cœur/ressources et les preuves antérieures sont conservées ; identités et sommes de contrôle Cargo alignées avec le projet réel.

## Échecs conservés et corrections du diagnostic

1. La première découverte supposait Tristana.ddf à la racine et s’est arrêtée avec FileNotFoundError. Le script initial est conservé ; la version `discovery_paths` recense les chemins présents et garde la recherche négative explicite.
2. Un garde de génération cherchait la sous-chaîne « thresh » et rejetait à tort « threshold ». Il a été corrigé avant tout lancement Rust. La tentative de copie des fichiers non générés a échoué ; aucune preuve de compilation n’en a été déduite.
3. Le premier programme Rust compile, puis termine avec RUN 101 en déballant le rayon optionnel de Garen, absent. La version `probe_radius` distingue le champ absent et le repli local 65 réellement utilisé par le cœur. L’ancien binaire, les sources, manifestes et journaux sont conservés et identifiés. Il s’agit d’une hypothèse erronée du diagnostic, pas d’un correctif du moteur.

## Intégration, contrôles et fichiers

PREPARE/CHECK/PUBLISH/AUDIT : codes 0. Les 72 mutations invalides d’association et 4 mutations invalides du graphe sont refusées. Deux bases SQLite : quatre destinataires vérifiés, 42 603 autres lignes inchangées, 42 607 états manuels et 23 historiques conservés ; synchronisation normale idempotente. Trois questions propres et quatre dépendances conservées. Aucune inconnue fermée, aucune acceptation ou case modifiée.

Graphe : 99 237 sources, 5 023 consommateurs, 26 189 inconnues ouvertes et 5 517 résolues conservées. Les 5 023 ancres actuelles sont exactes sans divergence. La validation globale est structurelle (`source_hashes_verified=0`) ; les contrôles d’octets ciblés sont distincts et documentés. Aucun lancement du serveur Riot historique, rendu, audio ou transport réseau.

Modifiés : docs/completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json et fidelity_sources_4_20.json ; deux bases du plan ; ajouts dans coverage.json, completion_plan.json, resume_checkpoint.json ; notes docs/ai/CURRENT.md et HANDOFF.md. Identités, phases/lots et inconnues restent identiques octet par octet. Nouveaux rapport, reçu et preuve ci-dessous. Aucun stage, reset, commit ou changement de code de jeu.

| Preuve | Emplacement |
|---|---|
| Association | docs/reference_requirement_trace_sources/tristana-passive-draw-a-bead-links-v640.json |
| Vérification | docs/fidelity_tristana_passive_draw_a_bead_links_v640.json |
| Découverte corrigée | revision640_Tristana_discovery_paths/OBSERVATIONS.json |
| Diagnostic corrigé | revision640_Tristana_passive_probe_radius/OBSERVATIONS.json |
| Inspection | revision640_Tristana_inspection/OBSERVATIONS.json |
| Relecture globale | revision641_trace_review/REVIEW.json |

Les chemins privés sont relatifs à `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` ; ils sont une dépendance locale. Découverte SHA-256 `3b83f28388de4068622cc88c14057651b8975f72ef5871f9e019fa5b35847a13` ; diagnostic `03acbe58c4464307c21d106ad43c57d388f46c0e90ffe5a598b10a1613ba7464` ; inspection `1d7824d3872ce78c87b52305e8a2fcd741c07abf9fb13aff7616177832724a50`. Les reçus contiennent commandes, logs, identités et résultats attendus/observés.

## Travail restant

1. Retrouver les valeurs exactes de progression, les producteurs de f1/Effect1Amount et la politique de mise à jour du passif.
2. Relier cette règle à la portée d’attaque, à la poursuite, à la validation du windup et aux portées E/R, en conservant les trois portées distinctes.
3. Qualifier chaque niveau et les frontières exactes, cibles mobiles, changement de niveau pendant action, mort/réapparition, reconnexion et reprise déterministe.
4. Conserver les limites de collision et de sources ; compléter E/R dans leurs tâches propres sans copier les divergences communautaires.
5. Qualifier séparément HUD, portées affichées, sons, VFX, animations, rendu et réseau ; conserver les limites antérieures V564/V606.

Cette livraison n’accorde aucune complétude à Tristana ou au jeu. Le goal global demeure actif.

## Reprise

Continuer SYS-01.2-02 depuis revision641_trace_review/REVIEW.json. V640 Tristana / Draw a Bead : 30 fichiers natifs, 90 associations, 18 points de code et 36 liens. Textes natifs : augmentation de portée des attaques et de E/R, progression exacte non résolue ; portée initiale 550, CastRange E/R 550. Champs absents conservés, aucun DDF Tristana retrouvé dans le deploy. Onze Lua sans fonctions enfants, sept limites NEWTABLE, quatre preloads, six BuffData résolus ; CharScript natif vide à la racine. Dix-neuf références communautaires : CharScript vide, Q producteur non retrouvé, W sans saut démontré, E à charges divergent du DoT et de la réduction des soins natifs, R sans recul démontré. Diagnostic XP explicite : portée 550 aux niveaux1-18 ; 278 refus de commandes et10 refus XP ; Annie témoin18 apprentissages. Quatre cas publics niveaux1/18 : à550 attaque sans mouvement ; à650 poursuite43,332031 avant tir, même seuil local615. Rayon Garen natif absent, repli local65 conservé. Quatre projectiles, huit déplacements, aucun réordre ; 7640 ticks dans les cas de portée, zéro tick dans les cas de rangs. Aucun E/R accepté. BUILD/RUN corrigés0, premier RUN101 dû au diagnostic conservé ; découverte corrigée après hypothèse DDF erronée. Gameplay, statuts, cases, inconnues et preuves conservés. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Suite : relire les acquis Trundle V534/V535 et crates/core/src/trundle_passive.rs avant de choisir le prochain écart. Table communautaire, récepteur de mort et appels damage/world déjà reliés ; ne pas les déclarer absents ni répéter une association équivalente. Qualifier seulement les sources ou chemins encore manquants avec preuves nouvelles. Goal actif.
