# Kha’Zix — sources et consommateurs du passif, V589

Date UTC : 2026-10-26T05:24:56.481828+00:00. Projet `F:/OpenLeague`. **SYS-01.2-02** : relier les exigences à leurs sources natives et consommateurs actuels.

## Résultat

Trois fiches Kha’Zix reliées à **29 sources natives, 87 associations, 29 points du moteur et 58 liens** contrat/simulation. Quatre sources de preuves ajoutées. Trois inconnues propres, quatre dépendances, leurs propriétaires, statuts et critères conservés.

**Le moteur courant ne produit ni dégâts magiques supplémentaires ni ralentissement dans les cycles de visibilité et d’attaque exécutés.** Il masque et révèle correctement Kha’Zix selon ses propres règles de vision, mais cela ne qualifie pas la vision historique ni la furtivité de R. Les formules dynamiques du passif restent ouvertes. Ce lot documente l’écart sans modifier le gameplay.

## Sources natives

Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus. Catalogue officiel 4.20.1 distinct. Taille, SHA-256 et appartenance RADS sélectionnée vérifiées ; appartenance ne signifie pas priorité historique de montage établie.

| Fichier | Source enregistrée |
|---|---|
| Khazix.inibin | OLS-da6683a7-fea8-5a80-819f-ab57050001ee |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Khazix.ddf | OLS-ee74d087-2cc3-59fc-b130-97907470341e |
| CharScriptKhazix.luaobj | OLS-dae9851e-b0de-512c-9b42-9660c37d5270 |
| CharScriptKhazix.preload | OLS-8097bf44-3ecc-5e13-a786-8dde2fa90195 |
| KhazixPassive.inibin | OLS-dc3866db-d74c-560b-b874-a5712e2f13ef |
| KhazixPassive.luaobj | OLS-819d6f45-1b28-5d0c-b004-e001e5391132 |
| KhazixPassive.preload | OLS-f7fced35-7aa2-5be0-a808-1aef8fcc5987 |
| KhazixPDamage.inibin | OLS-99e3f376-de0f-5e7a-8d2b-10ad4d37088b |
| KhazixPDamage.luaobj | OLS-1a17f0c7-24d8-5d67-856c-8df3126d91c9 |
| KhazixPDamage.preload | OLS-6e823d60-11f8-5e02-9a0c-78985a8a86d9 |
| KhazixPAttack.inibin | OLS-34da4ae6-b2b2-539b-8e23-069c366b804e |
| KhazixPSlow.luaobj | OLS-0edc9662-9987-5641-819b-63a1d67e2f85 |
| KhazixR.inibin | OLS-505ab042-58dc-5060-853c-4d7549b394a5 |
| KhazixR.luaobj | OLS-2cea4949-651e-5e09-b1dc-f8f2ca17b83f |
| KhazixR.preload | OLS-d031c078-9251-5206-b257-a2808606130d |
| KhazixRStealth.inibin | OLS-71543ab6-3e72-515e-9e39-28736ba05545 |
| KhazixRStealth.luaobj | OLS-e705d004-6522-57fb-a81e-06f9cd998f08 |
| KhazixRStealth.preload | OLS-239651eb-4e19-554a-8986-2ca98f279cdc |
| KhazixREvo.inibin | OLS-d478360b-9b3f-5ef3-a7d4-2f9ed8e1b654 |
| KhazixREvo.luaobj | OLS-45fc3292-0ccd-573b-a62d-56bbf85dbcc0 |
| KhazixREvo.preload | OLS-a6959bb5-7827-5b5f-ab66-04b0a19746e1 |
| KhazixRInternalCD.luaobj | OLS-70c6bde4-270d-5534-ba63-5643bcc8997f |
| KhazixBasicAttack.inibin | OLS-f8127f93-0bb5-51aa-a2bb-7fb73430d79d |
| KhazixBasicAttack.luaobj | OLS-3e91014c-81f9-5cc1-9aec-d2d7c1503265 |
| KhazixBasicAttack2.inibin | OLS-f16c5b74-1dab-5939-a525-84382eca92fe |
| KhazixBasicAttack2.luaobj | OLS-e5066f90-b31b-56b9-9530-2ffd9ed8fff6 |
| KhazixCritAttack.inibin | OLS-a42b5f1d-4f43-56eb-884b-e161db04016c |
| KhazixCritAttack.luaobj | OLS-404c4c01-fb37-558e-940e-6ef54419a28a |

- Le CharScript est à la **racine de `DATA/Characters/Khazix`** et les sorts dans son sous-dossier **`Spells`**. Les premiers chemins candidats `Scripts` et sorts globaux étaient absents ; les ressources sont présentes à ces emplacements réels. Aucune reconstruction d’un fichier déjà présent.
- `Khazix.inibin` : `Passive1LuaName=KhazixPassive`, icône `Khazix_P.dds`, `ExtraSpell4=KhazixPAttack`. Les champs Passive1Level et l’ancien Passive1Desc absents restent absents.
- Description liée en_GB ligne 4216 : quand Kha’Zix n’est pas visible par l’équipe ennemie, sa prochaine attaque de base contre un champion reçoit des dégâts magiques supplémentaires et un ralentissement.
- Cinq buffs directement liés : Passive, PDamage, R, RStealth, REvo. Le tooltip Passive ligne 2174 précise **deux secondes** de ralentissement et conserve les valeurs dynamiques **@f1@, @f2@, @f3@**. Le tooltip PDamage ligne 2175 décrit l’attaque préparée.
- Le DDF contient **40 lignes**, dont **quatre lignes PDamage avec link et coeff vides**. Elles ne définissent pas une formule nulle. Les paramètres SpellData Effect1..4 du passif contiennent **3 / 35 / 4 / 3**, sans mapping démontré vers f1/f2/f3 ; ils ne sont pas adoptés comme dégâts, coefficient ou ralentissement.
- Trois clés SpellData absentes du fontconfig sélectionné : `game_spell_tooltip_KhazixPassive`, `game_spell_description_KhazixPassive`, `game_spell_description_GreenTerrorBasicAttack`. Les liaisons BuffData présentes restent distinctes ; aucune substitution automatique d’alias.
- Onze Lua intégralement lus, aucun prototype enfant. Deux initialisations littérales vides : CharScript et RInternalCD. Neuf limites **NEWTABLE** : Passive/PDamage pc16, PSlow pc14, R/REvo pc18, RStealth pc6, BasicAttack/BasicAttack2/CritAttack pc0. Ces limites du lecteur littéral ne démontrent pas une corruption. Aucun callback serveur exécuté.
- Six preloads : CharScript, Passive, PDamage, R, RStealth et REvo. Passive cite PDamage et des dépendances de chasse ; PDamage cite PSlow, RInternalCD et des effets. Les noms et dépendances ne prouvent ni un temps de réarmement ni une présentation acceptée. Isolation de Q, chasse de Rengar et furtivité restent des contextes distincts du passif.
- Six chemins candidats absents sont enregistrés : les deux CharScript sous `Scripts`, les deux Passive globaux, `KhazixPSlow.inibin` et `KhazixPAttack.luaobj`. Le Lua PSlow et l’inibin PAttack sont présents. Aucune absence générale d’assets n’en est déduite.
- Quinze références communautaires séparées : CharScript, QWER, statistiques et neuf JSON associés. Le CharScript communautaire est vide ; provenance/version du snapshot conservées, sans assimilation au serveur original.

## Diagnostic exécuté

Compilation privée du vrai core non-test, `cargo build --locked --offline` : BUILD et RUN **0**. Dépendances/checksums alignés sur le lock racine. **1 158 entrées** de code et ressources, ainsi que la chaîne antérieure, sont vérifiées. Les anciens échecs restent conservés.

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-khazix-passive-unseen-threat-probe.exe` — 6120960 octets — SHA-256 `13e1b546ed5a5b4defae0fef81f979a9a6a6fe09d612a86bcddf879e938e7f64`.

Deux parties Map10 neuves : Kha’Zix face à Ahri, sans puis avec achat public du Tome d’amplification 1052 (+20 puissance). Déplacements, achats, attaques et arrêts passent par les commandes publiques. Aucun état de visibilité, effet, dégât, position, santé ou temps n’est injecté.

| Cas | Puissance | Impacts mêlée | Refus | Ticks cachés immobiles | Ticks finaux visibles |
|---|---:|---:|---:|---:|---:|
| base | 0 | 4 | 16 | 120 | 180 |
| Amplifying_Tome | 20 | 4 | 16 | 120 | 180 |

Par scénario : 30 ticks initiaux hors vision ennemie ; déplacement vers une zone de ligne de vue dégagée ; deux attaques ; retrait à distance hors vision ; 90 ticks caché ; retour visible ; deux nouvelles attaques ; 180 ticks finaux visibles.

La visibilité de l’équipe ennemie est comparée à la présence dans `snapshot_for` à chaque tick de trajet et d’attente. Kha’Zix reste présent dans sa propre projection. La perte puis le retour de visibilité sont observés ; l’attaque de l’adversaire contre Kha’Zix caché est refusée sans mutation. La route choisie possède une ligne de vue dégagée : ce contrôle utilise la perte de vision par distance, pas une furtivité de R.

Les **huit impacts de mêlée** ont un windup source/cible, non critique, avec `release` égal au tick d’impact. Les dégâts totaux observés correspondent aux dégâts physiques ordinaires, tolérance 0,002, en tenant compte de la régénération. Aucune contribution magique supplémentaire n’est observée. La cible n’a aucune entrée de ralentissement et sa vitesse reste inchangée. Les quatre champions des deux parties restent vivants et niveau 1.

**32 refus publics inchangés** : joueur inconnu, attaque sur soi, slot invalide, apprentissage/lancement QWER ciblés et au sol, attaque de l’adversaire contre Kha’Zix hors vision. R et ses évolutions ne sont pas exécutés. Les **240 ticks cachés immobiles** et **360 ticks finaux visibles** sont distincts des ticks de déplacement et d’attaque.

Attendu du diagnostic actuel : masque de visibilité et projections cohérents, refus inchangés, dégâts ordinaires attribuables ; observé conforme. Attendu du texte passif après une perte de vision qualifiée : attaque renforcée et ralentissement ; **non observé avec la vision courante**. La valeur exacte des dégâts, du coefficient, du ralentissement et la fidélité de cette vision à 4.20 ne sont pas établies par ces tests.

## Consommateurs actuels

| Fichier et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | initialization |
| crates/core/src/lib.rs:598 | public_dispatch_and_refusals |
| crates/core/src/progression.rs:68 | current_AP_and_ordinary_target_defenses |
| crates/core/src/progression.rs:150 | Khazix_learning_refusal |
| crates/core/src/progression.rs:159 | unsupported_Khazix_rank |
| crates/core/src/spells.rs:101 | Khazix_cast_refusal |
| crates/core/src/annie_w.rs:29 | Khazix_ground_cast_refusal |
| crates/core/src/lib.rs:685 | tick_order_and_regeneration |
| crates/core/src/lib.rs:744 | diagnostic_not_network_acceptance |
| crates/core/src/damage.rs:53 | ordinary_physical_without_bonus_magic |
| crates/core/src/attacks.rs:157 | melee_windup_release_and_vision_guard |
| crates/core/src/lifesteal.rs:4 | ordinary_melee_hits |
| crates/core/src/regeneration.rs:32 | regeneration_during_public_wait |
| crates/core/src/shop.rs:261 | AmplifyingTome_public_purchase |
| crates/core/src/shop.rs:215 | 20AP_control |
| crates/core/src/lifecycle.rs:33 | static_context_not_respawn_acceptance |
| crates/core/src/attacks.rs:103 | static_context_not_departure_acceptance |
| crates/core/src/damage.rs:38 | ordinary_resistance_formula |
| crates/core/src/penetration.rs:4 | penetration_distinct_from_reduction |
| crates/core/src/penetration.rs:9 | current_item_penetration |
| crates/core/src/vision.rs:48 | ordinary_navigation_vision |
| crates/core/src/vision.rs:79 | actual_team_visibility_cycle |
| crates/core/src/vision.rs:95 | shared_team_vision_sources |
| crates/core/src/vision.rs:137 | filtered_projection_not_network_acceptance |
| crates/core/src/slows.rs:12 | no_slow_after_hits |
| crates/core/src/slows.rs:78 | slow_cleanup_context |
| crates/core/src/slows.rs:74 | static_boundary_no_slow_event_injected |
| crates/core/src/movement.rs:53 | target_speed_unchanged |
| crates/core/src/vision.rs:30 | current_selected_radius_not_full_native_vision |

Les fonctions de visibilité partagée, projection filtrée, attaques, dégâts, ralentissements et vitesse sont présentes et liées selon leur rôle. Le point `grant_slow` est une frontière statique : aucun ralentissement n’a été injecté par cet API dans le diagnostic. Réapparition et départ ne sont pas des validations du cycle de vie du passif. Les lecteurs de sources ne sont pas promus en implémentation de simulation.

Dix ressources locales sont associées séparément : champions, croissance, ressources, attaques, critiques, collision, boutique, règles de vision, rayons natifs sélectionnés et règles de vitesse. Profils Kha’Zix/Ahri sélectionnés lorsque pertinent. Contrats locaux et règles historiques restent distincts.

## Travail restant et limites

1. Identifier les producteurs de f1/f2/f3 : dégâts, progression par niveau, coefficient et pourcentage de ralentissement ; résoudre les clés SpellData absentes sans adopter arbitrairement les autres chiffres.
2. Qualifier vision partagée, rayons, ligne de vue, buissons, révélations, tours, sbires/pets, équipes et spectateurs ; distinguer perte de vision, isolation de Q et furtivité.
3. Intégrer l’armement, le maintien en vue, la consommation sur champion et le réarmement ; tester attaques annulées, cibles nonchampions, changement de cible et événements simultanés.
4. Qualifier l’ordre des dégâts physiques/magiques et du ralentissement, immunités/boucliers, durée de deux secondes et effets concurrents.
5. Implémenter/qualifier R et ses évolutions, charges et délai interne avant de tester le réarmement par furtivité.
6. Mort/réapparition, déconnexion et fin de partie ; puis HUD de disponibilité, attaque renforcée, icônes, animations, VFX, audio et réseau.

Aucun serveur historique, rendu GPU ou transport réseau exécuté. La réussite de projection est un contrôle interne, pas une réception réseau. Les ressources présentes ne sont pas déclarées manquantes. BattleTraining, les autres champions et le défaut de déplacement V564 restent distincts et ouverts.

## Livraison vérifiée

Inspection, PREPARE, CHECK, PUBLISH et AUDIT : retours réels **0**. 72 associations invalides et quatre graphes invalides refusés. Trois fragments de consignes actualisés ; 42 212 inchangés.

Deux bases : quatre destinataires actualisés, 42 603 autres lignes inchangées, **42 607 états manuels et 23 historiques conservés**, synchronisation normale idempotente. Identités, hiérarchie et inconnues inchangées octet pour octet ; trois questions propres et quatre dépendances conservées avec leurs propriétaires.

Graphe : **99 033 sources, 3 757 consommateurs**, 42 215 exigences. Revue globale : **3 757 ancres exactes, zéro divergence courante**. 26 189 inconnues ouvertes et 5 517 précédemment résolues restent inchangées. Hachages des sources sélectionnées et validation structurelle restent distincts.

Fichiers modifiés : registres `completion_tasks_2026-10-20.json`, `fidelity_requirement_trace_4_20.json`, `fidelity_sources_4_20.json` ; reçu `reference_requirement_trace_sources/khazix-passive-unseen_threat-links-v589.json` ; preuve `fidelity_khazix_passive_unseen_threat_links_v589.json` ; ce rapport, couverture/plan/reprise, CURRENT/HANDOFF, reçu privé et données/consignes des deux bases. Aucun gameplay, asset, statut de fin ou case manuelle modifié.

Preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` : `revision589_Khazix_discovery`, `revision589_Khazix_passive_probe`, `revision589_Khazix_inspection_verified`, `revision589_Khazix` et revue `revision590_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision590_trace_review/REVIEW.json. Khazix V589 publié/audité :29sources natives,87associations,29points/58liens. Deuxcas publics base/20AP,8impacts mêlée32refus240ticks cachés360ticks finaux. Cycles horsvision→visible et projections filtrées vérifiés;aucun dégât supplémentaire ni ralentissement. Vision historique/furtivitéR/formule f1f2f3 non qualifiées;sorts refusés. OnzeLua lus,2littéraux9limites NEWTABLE,5buffs6preloads,DDF40dont4PDamagevides,15communautaires dontCharScriptvide. Fichiers aux vrais chemins personnage;6candidats absents,3clésSpellData absentes dontGreenTerror. Effect1..4=3/35/4/3 nonadoptés commeformule. BUILD/RUN/inspection/prepare/check/publish/audit0. Préserver ancienséchecs et déplacementV564. Poursuivre un autre passif après inspection réelle,par exemple KogMaw. Goal actif;aucun statut/case/inconnu fermé.
