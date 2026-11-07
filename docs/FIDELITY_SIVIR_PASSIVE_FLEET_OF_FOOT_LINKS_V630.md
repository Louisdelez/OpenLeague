# Sivir — Fleet of Foot : sources et consommateurs V630

UTC : 2026-10-26T18:11:01.482301+00:00. Projet F:/OpenLeague. SYS-01.2-02 : relier chaque exigence à sa source native et à son consommateur actuel.

## Résultat

Les trois fiches du passif de Sivir et la synthèse SYS-01.2-02 reçoivent 156 associations à 52 fichiers natifs et 56 liens à 28 points précis du moteur. Ces points restent qualifiés comme frontières génériques, pas comme implémentation de Fleet of Foot. Les statuts ne sont pas promus, aucune case n’est cochée, aucun gameplay modifié.

**Écart vérifié :** après les attaques touchant un champion ennemi, la vitesse reste335 sans objet ou360 avec Bottes. Les textes natifs décrivent pourtant un bonus f1 pendant2secondes. La valeur f1, sa progression et ses règles précises restent ouvertes. Les sources ne sont pas globalement absentes ; il manque une implémentation qualifiée et certains producteurs numériques.

Référence : PUBLIC4.20.0.315, EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau et déploiement non établis. Catalogue4.20.1 distinct. Aucun serveur historique exécuté.

## Sources et limites de lecture

52 fichiers sélectionnés :20INIBIN,19Lua,11preloads,DDF et font. Leur identité et leur appartenance RADS sont contrôlées. La recherche reprend les anciennes associations natives et les noms exacts, dont `On The Hunt.inibin` et `Spell Shield.inibin` avec espaces.

- Sivir.inibin : vitesse335,AD52,040000915527344,PV515,760009765625,mana284,portée500. Passive1LuaName=SivirPassive ; icôneSivir_Passive.dds ; QWER=SivirQ/W/E/R. PARType absent : le choix Mana courant reste une entrée locale distincte.
- SivirPassive.inibin résout `game_buff_tooltip_SivirPassive` : toucher un champion ennemi par attaque de base ou capacité donne f1vitesse pendant2s. Le descriptif du personnage est moins précis. Aucun montant numérique n’est inventé.
- Passive1Desc conserve une ancienne esquive en mouvement ; PassLev1Desc2..4 portent15/20/25%,et Passive1Level1..4=1/6/11/16. Ces éléments sont consignés sans en faire une politique d’esquive4.20 ni des paliers prouvés de Fleet of Foot.
- CharScript et Sivir.ddf sont à la racine du personnage. Les quatre chemins alternatifs absents ne prouvent pas un manque global d’assets.
- CharScript natif : pas de callbacks enfants, globals vides. SivirPassive : nom,icône,persistance et NonDispellable ; pas de formule de vitesse. Son preload référence SivirPassiveSpeed, dont les littéraux donnent effetSivir_Base_passivehaste.troy et attache spine. Cela ne valide ni le déclencheur ni le rendu.
- SivirRPassive déclare également BuffName=SivirPassive,avec icôneSprint ; RPassiveBuff/Marker utilisent Deadeye. Cette homonymie ne suffit pas à fusionner Fleet of Foot et le passif de R.

Sept BuffData :six traductions exactes et une clé non résolue (`game_buff_tooltip_SivirRPassiveBuff`). Les19Lua sont lus entièrement,sans callback enfant ;le lecteur de littéraux s’arrête sur NEWTABLE pour trois fichiers:R,WAttack,WAttackBounce. Les constantes de tables ne sont pas des globals évalués et leurs valeurs ne prouvent pas un scénario serveur.

DDF :28lignes,quatre liaisons non vides :SpiralBlade bonusAD×1,0 ;SivirQ AD×Effect4 ;SivirW AD×Effect6 etEffect7. Les alias historiques SpiralBlade/OnTheHunt/Ricochet/SpellShield restent distincts des noms sélectionnés. Aucune formule f1 de Fleet of Foot dans ces liaisons.

## Communauté : 26 références statiques

Le CharScript communautaire est vide. Les scripts QWER et le buffW sont présents,mais ne sont ni le serveur historique ni des consommateurs Rust exécutés dans cette vérification.

| Élément | Observation et limite |
|---|---|
| Q | Deux passes par cônes1000unités,dot0,95 ;retour différé0,8s ;dégâts décroissants de10% par cible,min30%. Pas une preuve du missile aller/retour,du temps de vol,de l’ordre des cibles ou des collisions natives. |
| W | Buff6s,trois charges,annulation d’attaque,remplacement du missile,chaîne ;dégâts secondaires50–70%AD. TODO cooldown dans le buff. Les callbacks,la consommation des charges,l’absence de double impact et les règles on-hit restent à qualifier. |
| E | Ajout d’un buff1,5s et d’une particule. Le blocage de capacité et le remboursement de mana ne sont pas démontrés par ce fichier. |
| R | Ajout d’un buff10s à soi et alliés dans1000unités. La courbe de vitesse native et le passif de vitesse d’attaque pendant Ricochet ne sont pas démontrés ici. |

Les descriptions natives QWER sont conservées :Q boomerang avec réduction par cible,W rebonds et on-hit réservé à la première cible,E blocage puis restitution de mana,R vitesse de groupe avec décroissance et bonus AS pendant W. Ces contextes ne qualifient pas automatiquement leur implémentation ni le déclenchement du passif.

## Diagnostic réel : attendu et observé

Compilation `cargo build --locked --offline --message-format=json` du diagnostic contre le crate courant non-test. Exécution par commandes publiques,sans injection d’état. Les1158 entrées courantes,les identités de dépendances/Cargo.lock et les preuves antérieures sont revérifiées. Achat de Bottes testé ;vente/rachat non exercés.

| Cas | Vitesse observée | Attaques touchant Annie | Distance sur30ticks | Trames après impact | Refus atomiques |
|---|---:|---:|---:|---:|---:|
| base | 335.0 | 6 | 334.995117 | 122 | 27 |
| Boots25Speed | 360.0 | 6 | 360.000000 | 122 | 27 |

Total :12projectiles/impacts ordinaires,54refus,244trames après impact dont60ticks de marche,six trajets arrivés etdeux ordres de marche mesurée,zéro réordre. Les dégâts43,650390625 correspondent à l’attaque ordinaire et à la mitigation de la cible. Les six attaques de chaque cas sont réparties en deux groupes de trois ;les fenêtres de61ticks dépassent les2secondes décrites.

La vitesse de déplacement effective et celle des statistiques restent à 335/360 pendant 416 trames d’attaque et les 244 trames après impact. Le champ technique `attack_speed_observation_frames` compte ces observations de déplacement pendant les attaques ; il ne mesure pas une vitesse d’attaque. Les deux marches comptent 30 pas effectifs ; distance cumulée de 334,9951171875 sans objet et 360 avec les Bottes. La faible différence du premier cas est enregistrée avec les coordonnées flottantes ; aucun trajet n’est présenté comme exact au-delà de sa tolérance. Aucun bonus Fleet of Foot supplémentaire n’est observé dans ces deux cas au niveau 1.

Les54refus couvrent joueur inconnu,attaque sur soi,emplacement invalide,apprentissage/lancer/lancer à position des quatre sorts avant/après les séquences. Snapshot inchangé à chaque refus. Aucun sort Sivir accepté :la branche «capacité touche un champion» et les rafraîchissements du vrai bonus ne sont pas exercés.

Le code courant de mouvement compose vitesse de base,objet,buffs/slows et courbe reconstruite. Le dispatch des projectiles et on-hit est générique. La recherche précise Sivir/Fleet of Foot dans core ne relève pas de branche dédiée ;ce résultat accompagne les tests,il ne les remplace pas. Softcaps et règles génériques restent distincts du contrat historique du passif.

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-sivir-passive-fleet_of_foot-probe.exe` ; 6118400octets ; SHA256 `e09998b4275bdaa0fa4ea0c2b818062c68b7576cc38a397429a0b77816b8dcd3`.

BUILD0,RUN0,collecteur0,inspection0. La première découverte a échoué1 sur `progressivir.rs` :une substitution de nom trop large dans le générateur avait modifié progression/collision/vision et revision. Le script corrigé utilise les chemins réels et la découverte passe0. L’original et son dossier partiel sont conservés ;aucune source de jeu n’avait été modifiée. Le point projectiles du script d’inspection a été corrigé avant exécution vers la ligne réelle `let flights = std::mem::take(&mut self.projectiles);` dans advance_attacks.

## Intégration et contrôles

PREPARE,CHECK,PUBLISH,AUDIT0. Contrôle négatif :72 mutations d’association et4mutations du graphe refusées. Trois aperçus de trace enrichis et quatre copies de tâches vérifiés avec instructions complètes et limites.

Deux bases réelles :quatre lignes enrichies,42603autres lignes inchangées,42607états manuels et23historiques conservés. Synchronisation idempotente et intégrité vérifiées. Trois questions propres etquatre dépendances conservées. Identités,hiérarchie et registre d’inconnues inchangés à l’octet.

Revue globale :99197sources,4783consommateurs,4783ancres exactes sans divergence. La revue du graphe est structurelle ;les octets de la sélection sont vérifiés par les reçus dédiés. Aucun audit complet des99197sources ni jeu complet n’est revendiqué.

Fichiers concernés :

- docs/completion_tasks_2026-10-20.json,docs/fidelity_requirement_trace_4_20.json,docs/fidelity_sources_4_20.json.
- docs/reference_requirement_trace_sources/sivir-passive-fleet_of_foot-links-v630.json,docs/fidelity_sivir_passive_fleet_of_foot_links_v630.json etce rapport.
- docs/coverage.json,docs/completion_plan.json,docs/resume_checkpoint.json,docs/ai/CURRENT.md,docs/ai/HANDOFF.md etcheckpointprivé.
- F:/OpenLeague/runtime/project-plan/plan.sqlite3 etC:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3 ;sauvegardes avant modifications.
- Scripts etpreuves privés sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision630_Sivir*.

Aucun changement du code de jeu,asset,état manuel,critère,propriétaire ou dépendance ;pas de stage/reset/commit.

## Travail restant

1. Retrouver et qualifier f1,progression,nature additive/multiplicative,rafraîchissement,cumul etexpiration2s ;ne pas réutiliser automatiquement les anciens paliers d’esquive.
2. Implémenter le déclenchement à l’impact d’attaque et de capacité sur champion ennemi,avec consommation/expiration réelles.
3. Tester les cibles alliées,sbires,monstres,champions,dommages nuls,boucliers,missiles en vol,rebondsW,retourQ etimpacts simultanés selon le contrat récupéré.
4. Vérifier déplacement effectif,changements de niveau,objets,buffs,slows,softcaps,mort/réapparition,reconnexion etvisibilité.
5. Qualifier séparément HUD,VFX,sons,animations etréseau ;aucun rendu,transport réseau,partie multijoueur ou serveur historique testé ici.
6. Garder ouverte la traduction RPassiveBuff,les limites NEWTABLE etla sélection des alias ;ne pas résoudre une question par une association documentaire.

Les limites V564/V606 etles cinq lacunes Battle Training restent ouvertes localement. Elles ne bloquent pas cette avancée indépendante. Goal actif,objectif global incomplet.

## Points actuels

| Fichier et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/lib.rs:598 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/progression.rs:68 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/progression.rs:150 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/progression.rs:159 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/spells.rs:101 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/annie_w.rs:29 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/lib.rs:685 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/lib.rs:744 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/damage.rs:53 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/attacks.rs:157 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/lifesteal.rs:4 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/regeneration.rs:32 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/regeneration.rs:10 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/shop.rs:261 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/shop.rs:215 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/world.rs:226 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/damage.rs:38 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/attacks.rs:26 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/lifecycle.rs:16 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/lifecycle.rs:24 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:635 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:526 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/spells.rs:5 | current Sivir ordinary attacks,items,movement or explicit spell-refusal boundary |
| crates/core/src/movement.rs:53 | effective current speed without Sivir-specific bonus |
| crates/core/src/movement.rs:38 | generic speed buffs/slows without Fleet of Foot |
| crates/core/src/movement.rs:19 | current reconstructed movement curve;not native passive formula |
| crates/core/src/attacks.rs:159 | generic ranged hit dispatch |

## Sélection native

| Fichier | Source |
|---|---|
| Sivir.inibin | OLS-444c38c2-f873-5599-8b73-9fe3a6bca2bc |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Sivir.ddf | OLS-dc6a60d0-7792-58ae-a20e-242b26951e77 |
| CharScriptSivir.luaobj | OLS-aa893408-df9e-5210-ac1f-535214aff999 |
| CharScriptSivir.preload | OLS-d38d8ea6-cf0e-5f73-8c83-cf1a1a2df2b9 |
| On The Hunt.inibin | OLS-f7f8adb7-99bb-5b68-87e7-87ca6bae4e70 |
| SivirBasicAttack.inibin | OLS-478c0605-5bf6-598a-8d3a-e02b6d3ecab4 |
| SivirBasicAttack2.inibin | OLS-84cdbf65-1c64-5aa3-941c-1aae7e873de3 |
| SivirCritAttack.inibin | OLS-df3af7ec-d285-525b-a95d-959c1507a269 |
| SivirE.inibin | OLS-71b999f1-753f-5d12-8793-7385c88528ab |
| SivirE.luaobj | OLS-c1562954-e786-5e30-acc4-84a4538ad241 |
| SivirE.preload | OLS-cbb4e224-6284-5119-84ca-62abb8787c84 |
| SivirPassive.inibin | OLS-7d61bab0-9cc4-51ad-9720-a3a030100907 |
| SivirPassive.luaobj | OLS-262e9ec6-d02b-57cb-b127-beab411262fb |
| SivirPassive.preload | OLS-71ad5110-a0be-5fe1-be83-782aaa6f9139 |
| SivirPassiveSpeed.inibin | OLS-d1bc314c-b38d-56e0-93cd-d150fc048af8 |
| SivirPassiveSpeed.luaobj | OLS-2269df7c-35f3-570f-8b49-0389ec0dbc8c |
| SivirQ.inibin | OLS-c2a10c5c-806a-5c14-b281-296e52905319 |
| SivirQ.luaobj | OLS-5d837b52-536d-5dce-a80c-1a84cc1e58f5 |
| SivirQMissile.inibin | OLS-05a5f4fa-5bc4-5bb4-8ae7-0f85b55ee847 |
| SivirQMissile.luaobj | OLS-95ec4bf8-37c4-5ec9-bdc8-c8d334fdc6de |
| SivirQMissile.preload | OLS-21f83008-5020-5c52-979c-c14a5b22c933 |
| SivirQMissileReturn.inibin | OLS-7e5f9748-fb52-5857-ae2c-95bffe4d3e0c |
| SivirQMissileReturn.luaobj | OLS-22519eba-9103-5e9d-b1a1-ce9860808d57 |
| SivirQMissileReturn.preload | OLS-94932121-92f7-58c1-9e6b-7e1568b3298a |
| SivirQMissileReturnDead.inibin | OLS-513ffd1b-ba4f-50f4-8b8c-5dee3ee6681c |
| SivirQMissileReturnDead.luaobj | OLS-be7b28c8-3f21-5481-bea2-a17be333ff3c |
| SivirQMissileReturnDead.preload | OLS-b44cb39d-bc68-55de-adb0-1d29c89cff9a |
| SivirR.inibin | OLS-cbcb8144-09c0-5b6f-897b-eaac9ff5d2ab |
| SivirR.luaobj | OLS-fce321eb-06e6-5033-a8fa-e60d30dacaaa |
| SivirR.preload | OLS-c50ad3ca-3c89-55ab-b0d9-77e2580c8035 |
| SivirRAuraBuff.luaobj | OLS-c3fa4d33-2f65-5787-92f3-5366acca538c |
| SivirRAuraBuff.preload | OLS-b986e2a1-4af4-54d7-bb4d-9444f73e455d |
| SivirRMissile.inibin | OLS-e9d26780-a90e-53cd-9b64-71a5b02c3013 |
| SivirRMissile.luaobj | OLS-844d1680-36f9-571e-8794-3c1e9e2fadfa |
| SivirRPassive.luaobj | OLS-0204e32c-fc8b-5a04-8949-392026421246 |
| SivirRPassiveBuff.inibin | OLS-cf2c9381-8874-5320-89c5-6c8805b492d5 |
| SivirRPassiveBuff.luaobj | OLS-db52d85a-291d-504f-9eec-d41b3c5ac612 |
| SivirRPassiveMarker.luaobj | OLS-822bf550-d81a-56e4-b174-e9b9b263d1dc |
| SivirRunCycleManager.luaobj | OLS-8eb889d5-37d8-5369-b6c2-59cbd92e18fa |
| SivirW.inibin | OLS-8a468903-3872-53d1-96f0-836056b0dc06 |
| SivirW.luaobj | OLS-1b24b345-7ad0-54ac-b4b2-c4b4fd407616 |
| SivirW.preload | OLS-eac17372-3537-53ec-a920-fda7833d74d6 |
| SivirWAttack.inibin | OLS-62341ec5-0ab5-5737-91af-164e1c580471 |
| SivirWAttack.luaobj | OLS-07c98a0d-0e88-5605-be28-26d449ceb70a |
| SivirWAttack.preload | OLS-5e82bb86-f7c3-58cf-acc1-e31a424cc713 |
| SivirWAttackBounce.inibin | OLS-1bb889d5-8b8c-5fb1-96e2-9281b4f63675 |
| SivirWAttackBounce.luaobj | OLS-a9c143dd-1aa8-50c9-a7bc-ab44c6dfc808 |
| SivirWAttackBounce.preload | OLS-e57dfdeb-ee72-5725-bb6a-b0a8d1e6824a |
| SivirWMarker.inibin | OLS-4a6ff359-3371-5a3e-8dfd-e5b2c0f405b8 |
| SivirWMarker.luaobj | OLS-f3179006-8ef2-5385-9543-3537cc6e8e90 |
| Spell Shield.inibin | OLS-baaecdd9-fd93-524e-995d-645097cd12ad |

## Reprise

Continuer SYS-01.2-02 depuis revision631_trace_review/REVIEW.json. V630 Sivir / Fleet of Foot :52 fichiers natifs,156 associations,28 points actuels et56 liens. Le texte natif décrit f1vitesse pendant2s après une attaque ou capacité touchant un champion ennemi ;valeur et progression non qualifiées. Ancien texte esquive15/20/25% et marqueurs1/6/11/16 conservés sans les adopter. 19Lua dont3 limites NEWTABLE,11preloads,7BuffData dont6résolus/1inconnu ;DDF28lignes4liaisonsQW,aucun f1 du passif. On The Hunt et Spell Shield avec espaces distincts ;RPassive a le même BuffName sans preuve d’identité de comportement. 26références communautaires :CharScript vide,Q deux cônes simplifiés,W chaîne et cooldown partiels,E/R délèguent des buffs non qualifiés. Deux cas publics base/Bottes :12attaques à distance,54 refus,244ticks après impact dont60ticks de marche,six trajets plus deux ordres mesurés. Vitesse335/360 inchangée après les impacts et dans416trames d’attaque ;distances sur30ticks334,995/360. Aucun bonus passif observé,aucun sort Sivir accepté. BUILD/RUN/inspection0 ;découverte initiale1 pour noms de chemins du générateur,puis correction0 conservée. Aucun gameplay modifié ;états,cases,inconnues et preuves antérieures conservés. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Skarner. Goal actif.
