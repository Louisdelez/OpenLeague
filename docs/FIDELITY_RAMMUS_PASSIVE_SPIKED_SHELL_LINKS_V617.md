# Rammus — sources et consommateurs de Spiked Shell, V617

Date UTC : 2026-10-26T14:00:30.448253+00:00. SYS-01.2-02, F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct. Build littéral2014-11-17 à17:46:45,fuseau et déploiement non établis.

## Résultat et portée

CH-Rammus-PASSIF-SOURCE, CH-Rammus-PASSIF-SIMULATION-CONTRAT et CH-Rammus-PASSIF-SIMULATION reçoivent31 sources natives,93 associations,24 points de code et48 liens supplémentaires pour les deux fiches de simulation. La conversion d'armure en AD décrite par le passif n'est pas identifiée dans le chemin courant inspecté et n'apparaît pas dans les essais. Aucun gameplay modifié ; les trois fiches restent ouvertes.

Trois profils niveau1,commandes publiques :sans objet,Tissu1029+15armure,Épée1036+10AD. L'armure augmente avec le Tissu,mais les dégâts d'attaque restent identiques. L'Épée augmente les dégâts ordinaires. Achat,vente et rachat sont exercés pour les deux objets,sans injection de statistiques.

## Sources natives et limites

31 ressources :11 INIBIN,11 Lua,sept preloads,un DDF et un fichier de texte. Identités et appartenance au manifeste sélectionné vérifiées. Les11 Lua sont entièrement parcourus,sans sous-fonction. Cinq limites NEWTABLE :PowerBall,PowerBallSlow,PowerballStun,PowerBallStunSelf,Tremors2. Six initialisations littérales ne prouvent pas l'exécution du serveur original.

Rammus.inibin référence **Spiked Shell** avec espace et Armordillo_ScavengeArmor.dds. Le texte en_GB ligne4259 indique25% de l'armure convertie en dégâts d'attaque ; le nom Spiked Shell est lié ligne4435. Passive1,Passive1Desc et Passive1Level1..6 sont absents :aucune valeur de substitution adoptée.

Valeurs natives pertinentes :BaseDamage55,8800010681,Armor31,3840007782,BaseHP564,4799804688,SpellBlock32,0999984741,portée125,IsMelee=Yes,MS335. Les sorts liés sont PowerBall,DefensiveBallCurl,PuncturingTaunt,Tremors2.

Le CharScript natif se trouve dans **Scripts** et est vide. Le CharScript communautaire est également vide. SpikedShell.luaobj expose exactement BuffTextureName=Armordillo_ScavengeArmor.dds,BuffName=Spiked Shell,PersistsThroughDeath=true,NonDispellable=true. Aucun producteur de conversion,politique de mort/respawn ou ordre des statistiques n'en est déduit.

CharScriptRammus.preload référence spikedshell et la dépendance distincte apbonusdamagetotowers. Le nom compact du preload et le nom avec espace sont conservés ; la normalisation effective du provider reste non qualifiée. La dépendance pour les tours ne constitue pas une preuve du passif ou de son interaction avec les structures.

Six liens BuffData résolus exactement :DefensiveBallCurl,PowerBall,PowerballSlow,PowerballStun,PuncturingTaunt vers game_buff_tooltip_Puncturing_Taunt,Tremors2. Aucun doublon de basename ni variante NightmareBot sélectionnée.

Rammus.ddf contient12 lignes. Une seule non vide :**DefensiveBallCurl;f1 → armor,0.1**. Elle concerne le renvoi du W décrit dans son texte ; elle ne remplace pas le coefficient25% du passif. Les onze autres liaisons vides restent vides. Le DDF est un lien de données,pas le producteur natif de calcul.

Cinq chemins candidats absents :CharScript à la racine au lieu de Scripts,SpikedShell.inibin,SpikedShell.preload,SpikedShell.ddf et Rammus.en_gb.ddf. La présence du Lua et du texte est confirmée ; aucune absence globale d'assets ou corruption n'est déduite de cette recherche locale.

| Ressource | Identité du registre |
|---|---|
| Rammus.inibin | OLS-818ca10f-c794-50f6-a6ef-2a74596b9272 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Rammus.ddf | OLS-9de19e34-2f28-5f29-a87c-37171fb8c9b0 |
| CharScriptRammus.luaobj | OLS-978af507-f1c9-5ba8-91c8-6f1b7742dd06 |
| CharScriptRammus.preload | OLS-967ac418-6b6d-5fed-a366-811f1f91eec0 |
| DefensiveBallCurl.inibin | OLS-ed88d503-848b-5a2a-a199-737dc689bd31 |
| DefensiveBallCurl.luaobj | OLS-06b7d3c1-3cb4-5989-93a5-ea16365870b5 |
| DefensiveBallCurl.preload | OLS-02ac5a7b-4efb-5247-8be9-351ca1bc3c89 |
| DefensiveBallCurlCancel.inibin | OLS-7b355a5e-c109-5c53-bf2b-8893584c9c1e |
| DefensiveBallCurlCancel.luaobj | OLS-29b63ecb-9d6e-540e-bbcf-799527afbbca |
| DefensiveBallCurlCancel.preload | OLS-437a44ee-1301-5892-a67c-f6772c02ebb5 |
| PowerBall.inibin | OLS-8c3e8e5a-a319-527a-a4ee-770af5d785bf |
| PowerBall.luaobj | OLS-7ac66a20-e773-5edd-be27-47d481472835 |
| PowerBall.preload | OLS-b902ff34-c995-5f3d-bb8a-d35346d9042c |
| PowerballSlow.inibin | OLS-204addba-4c02-5811-b791-37adbc3c0f97 |
| PowerBallSlow.luaobj | OLS-5fe20a70-84e3-51fa-af91-7ee6093c1461 |
| PowerballStun.inibin | OLS-98a8a327-6760-5f00-bdea-88af210237ee |
| PowerballStun.luaobj | OLS-03d090bc-52d0-5eb3-a025-5e2af854febb |
| PowerBallStunSelf.luaobj | OLS-65d12fca-7677-56f2-a59a-8a858c26dc22 |
| PuncturingTaunt.inibin | OLS-560321ff-1702-5118-8960-551debce7268 |
| PuncturingTaunt.luaobj | OLS-6ce386cf-7954-5898-ac66-0b52a4b7b71e |
| PuncturingTaunt.preload | OLS-3ded8dae-bf48-566a-8eeb-e54c75bd8fa2 |
| PuncturingTauntArmorDebuff.luaobj | OLS-cef4380b-a643-5a52-9583-3aa5a2530a8a |
| PuncturingTauntArmorDebuff.preload | OLS-fe405c21-c989-5c30-a449-162345f73a92 |
| RammusBasicAttack.inibin | OLS-eb2174f9-307f-5b81-a15e-f41078059fff |
| RammusBasicAttack2.inibin | OLS-6962d40b-b9c8-5a2b-83bf-d83d77132682 |
| RammusCritAttack.inibin | OLS-45187e23-81c0-57b2-9428-79a0577efd44 |
| SpikedShell.luaobj | OLS-22313b73-94f8-570b-b5ed-f5b6cf2161a1 |
| Tremors2.inibin | OLS-8105b29a-76c5-557a-bb6d-9bc67b2ba518 |
| Tremors2.luaobj | OLS-9378a7d6-cf56-56ec-84a7-7943ccd26c6b |
| Tremors2.preload | OLS-ca33ff1a-0d54-553e-b60c-a6e042e76c5e |

## Références communautaires et écarts

16 références présentes,séparées de l'autorité historique et du code Rust courant. Ces scripts n'ont pas été exécutés comme serveur d'origine.

- Q délègue RammusPowerball7s. Son commentaire cite +0.6AP et un stun,mais ne constitue pas le producteur de collision/accélération. Le texte natif décrit impact,repoussement et ralentissement ;Coefficient1,Effect1=100/150/200/250/300,ralentissement20/25/30/35/40% pendant3s,fenêtre7s. Le binding effectif et la mécanique complète restent à qualifier.
- W communautaire ajoute50/65/80/95/110armure et10/25/40/55/70RM. Le texte natif lie **les deux défenses au même Effect1=40/60/80/100/120**. Durée6s,renvoi15/25/35/45/55 avec10% d'armure. Le timer communautaire retire les bonus après6s ;annulation par Q,recouvrement et mort ne sont pas qualifiés par ce fichier.
- E communautaire utilise0.75+0.5×rang,soit1.25/1.75/2.25/2.75/3.25s. Le natif donne1.25/1.5/1.75/2/2.25s et réduction d'armure5/10/15/20/25. Le fichier E lu applique Taunt mais ne modifie pas Stats.Armor. La réduction décrite dans son commentaire n'est pas une preuve de producteur.
- R communautaire planifie huit impulsions,65/130/195+0.3AP,avec rayon300 et filtre ObjAIBase. Le natif décrit aussi des dégâts aux structures,durée8s. Le champ CastRange375 ne suffit pas à fixer le rayon effectif ;le filtre communautaire ne qualifie pas les structures,ni la cadence initiale/fin ou l'annulation.

Le renvoi du W,les dégâts de R et la conversion du passif restent des fonctionnalités distinctes.

## Exécution et contrôles

Véritable cœur Rust compilé hors configuration test,offline/locked,dépendances alignées sur Cargo.lock. BUILD0,RUN0. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-rammus-passive-spiked-shell-probe.exe` ; 6127104 octets ;SHA256 `83c31c91abe6dff8153e3770001756a25012833b4955ae46d17f12f7e9499bf3`.

Trois parties Rammus/Annie,total neuf attaques mêlée sortantes,neuf impacts physiques entrants,trois Q Annie(raw80,coût60),81 refus atomiques. Six trajets publics réussis,sans réémission. Aucun sort Rammus accepté,aucune injection directe de position,PV,rang ou dégâts. Champions vivants niveau1,sans contrôle/bouclier/vainqueur,rangs/délais Rammus à zéro,mana plein. Une cible ennemie par partie.

| Cas | Armure | AD courant | Impact sortant attendu générique | Impact sortant observé | Premier impact entrant observé | Refus |
|---|---:|---:|---:|---:|---:|---:|
| base | 31.38400 | 55.88000 | 46.87133026 | 46.87133789 | 38.36846924 | 27 |
| Cloth15Armor | 46.38400 | 55.88000 | 46.87133026 | 46.87133789 | 34.43682861 | 27 |
| Sword10AD | 31.38400 | 65.88000 | 55.25918961 | 55.25918579 | 38.36846924 | 27 |

Le Tissu réduit les dégâts physiques entrants d'environ38,36845 à34,43682 par la mitigation générique,mais ne change ni AD ni dégâts sortants. L'Épée augmente AD et dégâts sortants. Les trois Q suivent la mitigation magique ordinaire ;ils ne qualifient pas une interaction spéciale du passif. Les résidus,après correction de régénération,reste inférieurs à0,002.

Deux cycles achat→vente→rachat sont exercés avant les trajets. Tissu :armure31,3840007782→46,3840026855→31,3840007782→46,3840026855 ;AD55,8800010681 constant. Épée :AD55,8800010681→65,8800048828→55,8800010681→65,8800048828 ;armure inchangée. Ces observations montrent l'absence du terme armure→AD dans le chemin courant.

Une addition illustrative du texte,AD courant+0.25armure,donne63,72600/67,47600/73,72601. Ces valeurs ne sont pas observées. Elles ne qualifient pas tous les ordres historiques :plancher d'armure négative,composantes base/bonus,réductions de défenses,multiplicateurs AD,arrondis et moment du recalcul restent ouverts.

**Échec conservé :** le premier collecteur Python retourne1 après BUILD/RUN0. Il comparait exactement une somme Python en double précision à des valeurs Rust `f32` :31,3840007782+15 n'est pas exactement46,3840026855 en double. Même différence pour AD+10. La relecture qualifiée arrondit explicitement les sommes en `f32`,vérifie les mêmes journaux/binaires/sources et retourne0. Aucun changement du moteur ou du diagnostic Rust,aucune nouvelle compilation ou exécution pour masquer l'échec. Le script,journaux initiaux et INITIAL_COLLECTOR_FAILURE_REVIEW.json sont conservés et liés.

Les refus contrôlent acteur inconnu,attaque de soi,slot invalide et apprentissage/lancement QWER non supportés,avec snapshots inchangés.

## Consommateurs réels

Recherche Rammus/SpikedShell/Spiked Shell sans occurrence dans crates/core/src,complétée par lecture des routes stats,ad_components,shop et attaques. Le calcul AD courant utilise base,croissance,objets,multiplicateur d'autel et ajustement Trundle Q ;aucun terme Rammus dépendant de l'armure n'est identifié. Cette conclusion porte sur le chemin inspecté,pas sur tous les projets ou le serveur historique.

Sept ressources locales liées :catalogue,croissance,ressources,attaques,critiques,collision,boutique. Les1158 entrées du diagnostic sont identifiées et hachées. Les lecteurs des sources restent distincts des consommateurs de simulation.

| Ancre exacte | Portée |
|---|---|
| crates/core/src/lib.rs:533 | ordinary Rammus spawn |
| crates/core/src/lib.rs:598 | public actions and atomic refusals |
| crates/core/src/progression.rs:68 | ordinary armor/AD;no conversion observed |
| crates/core/src/progression.rs:150 | unsupported Rammus learning |
| crates/core/src/progression.rs:159 | unsupported Rammus ranks |
| crates/core/src/spells.rs:101 | unsupported targeted spell |
| crates/core/src/annie_w.rs:29 | unsupported ground spell |
| crates/core/src/lib.rs:685 | nine outgoing,nine incoming physical,three Q |
| crates/core/src/lib.rs:744 | state witnesses,not network acceptance |
| crates/core/src/damage.rs:53 | generic damage,not passive stat conversion |
| crates/core/src/attacks.rs:157 | nine melee attacks |
| crates/core/src/lifesteal.rs:4 | physical hit uses ordinary damage |
| crates/core/src/regeneration.rs:32 | regeneration separated from damage |
| crates/core/src/regeneration.rs:10 | per-tick damage correction |
| crates/core/src/shop.rs:261 | Cloth1029/Sword1036 public purchases |
| crates/core/src/shop.rs:215 | ordinary armor/AD modifiers |
| crates/core/src/world.rs:226 | one enemy champion;other target types unexercised |
| crates/core/src/damage.rs:38 | Cloth incoming physical control |
| crates/core/src/attacks.rs:26 | melee hit witness |
| crates/core/src/critical.rs:12 | ordinary noncritical context |
| crates/core/src/progression.rs:40 | base/growth/item/altar/Trundle AD calculation,no Rammus armor term |
| crates/core/src/shop.rs:294 | two public buy-sell-rebuy cycles,immediate stat witnesses |
| crates/core/src/ally_occupancy.rs:635 | six preparation travels,no reorders |
| crates/core/src/ally_occupancy.rs:526 | navigation boundary,V564 remains open |

## Publication et conservation

Registres modifiés :docs/completion_tasks_2026-10-20.json,docs/fidelity_sources_4_20.json,docs/fidelity_requirement_trace_4_20.json. Reçu :docs/reference_requirement_trace_sources/rammus-passive-spiked-shell-links-v617.json. Preuve :docs/fidelity_rammus_passive_spiked_shell_links_v617.json. Instructions copiables des trois fiches et de SYS-01.2-02 mises à jour.

PREPARE/CHECK/PUBLISH/AUDIT0. 72 associations altérées et quatre graphes invalides refusés. Trois fragments de traçabilité changés,42212 identiques. Deux bases :quatre destinataires,42603 autres lignes,42607 états manuels et23 historiques conservés ;synchronisation idempotente. Identifiants,hiérarchie,inconnues inchangés octet par octet. Trois questions propres et quatre dépendances conservées ;aucune case ni statut clôturé.

Revue globale99145sources/4462consommateurs,4462ancres exactes,sans divergence. Contrôle structurel global (source_hashes_verified=0),distinct des hashes sélectionnés ;aucun recontrôle exhaustif de toutes les sources revendiqué.

coverage.json,completion_plan.json,resume_checkpoint.json,CURRENT.md et HANDOFF.md actualisés avec conservation des preuves antérieures. Aucun stage/reset/commit/nettoyage. Battle Training,V564 et deux arrivées V606 restent ouverts.

Preuves privées :F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision617_Rammus_discovery/OBSERVATIONS.json ;revision617_Rammus_passive_probe/BUILD_COMMAND.json et RUN_COMMAND.json ;revision617_Rammus_passive_probe_f32_review/OBSERVATIONS.json ;revision617_Rammus_inspection/OBSERVATIONS.json ;revision617_Rammus/DELIVERY_AUDIT.json ;revision618_trace_review/REVIEW.json.

## Travail restant

1. Qualifier les composantes d'armure prises en compte et l'ordre avec réductions,buffs,multiplicateurs AD.
2. Qualifier armure nulle/négative,plancher éventuel,arrondis et recalcul.
3. Implémenter une conversion unique sans accumulation ni récursion,dans le calcul réellement consommé.
4. Vérifier achats,ventes,annulations,changement de niveau et variations temporaires de défenses.
5. Qualifier activation/fin W,interruption Q,Exhaust,Trundle et interactions de statistiques.
6. Tester mort/respawn,plusieurs Rammus,attaques critiques et consommateurs bonusAD/totalAD.
7. Tester cibles champions,sbires,monstres et structures,avec interactions on-hit distinctes.
8. Qualifier affichage des statistiques,icône,animations,audio et réseau séparément.

Pas de serveur historique,rendu,audio ou transport réseau qualifié ici. Goal actif.

Suite : Continuer SYS-01.2-02 depuis revision618_trace_review/REVIEW.json. V617 Rammus / Spiked Shell :31 sources natives,93 associations,24 points et48 liens. Texte natif :25% de l’armure convertie en dégâts d’attaque. Trois cas publics sans objet/Tissu1029+15armure/Épée1036+10AD :neuf attaques mêlée,neuf impacts physiques entrants,trois Q Annie et81 refus. Achat-vente-rachat dans les deux cas équipés :les statistiques suivent les objets,mais le Tissu ne donne aucun AD. AD observé55,88000/55,88000/65,88000 ; armure31,38400/46,38400/31,38400. Aucun sort Rammus accepté. BUILD/RUN0 ; collecteur initial1 pour comparaison Python double/Rust f32,corrigée dans une relecture distincte sans relance ni modification du jeu ; journaux et échec conservés. Onze Lua dont cinq limites NEWTABLE,sept preloads,six liens BuffData résolus,douze lignes DDF dont seule DefensiveBallCurl f1=armor0.1 non vide. Ce renvoi10% du W est distinct du passif25%. CharScripts natif et communautaire vides ;nom Spiked Shell et preload spikedshell conservés sans qualification du provider. Seize références communautaires :W donne armure/RM50/10 au rang1 contre40/40 natifs ;E durée1,25–3,25s contre1,25–2,25s et aucune réduction d’armure dans le fichier ;Q délègue un buff ;R filtre ObjAIBase sans qualification des structures. Cinq candidats absents ne prouvent pas un manque global d’assets. Six trajets réussis ; V564/V606 ouverts. Ordre,armure négative,croissance,W,lifecycle et présentation restent à qualifier. Aucun gameplay modifié. Relecture f32/inspection/PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Renekton. Goal actif.
