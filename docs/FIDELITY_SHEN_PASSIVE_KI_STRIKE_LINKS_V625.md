# Shen — sources et consommateurs de Ki Strike, V625

Date UTC : 2026-10-26T16:32:17.132614+00:00. SYS-01.2-02,F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB,catalogue4.20.1 distinct. Build littéral2014-11-17 17:46:45,fuseau et déploiement non établis.

## Résultat et portée

Les trois fiches CH-Shen-PASSIF-SOURCE,CH-Shen-PASSIF-SIMULATION-CONTRAT et CH-Shen-PASSIF-SIMULATION reçoivent57sources natives,171associations,26points de code et52liens pour les fiches de simulation. SYS-01.2-02 reçoit le reçu et la synthèse. Aucun gameplay modifié ;statuts,critères,inconnues,dépendances et preuves antérieures conservés.

Le texte détaillé décrit un bonus magique périodique,une restitution d’énergie et une réduction de délai par attaque. Les essais actuels montrent des attaques ordinaires sans bonus magique,même après une attente dépassant les deux durées natives concurrentes8s/9s. Les PVbonus du Rubis n’affectent pas les dégâts. La restitution d’énergie n’est pas qualifiée,puisque la jauge reste pleine et aucun sort Shen n’est accepté pour la dépenser.

## Sources natives et divergences

57 ressources :22 INIBIN,20 Lua,13 preloads,Shen.ddf et texte en_GB. Identités,SHA et appartenance RADS vérifiées. Aucun doublon de basename ou NightmareBot sélectionné. Douze bindings BuffData résolus.

Shen n’a pas de dossier Characters/Shen/Spells dans ce client. Le premier inventaire sur ce chemin a échoué ;la recherche a retrouvé les sorts dans DATA/Spells et CharScriptShen sous Characters/Shen/Scripts. Ce changement de rangement ne constitue pas une absence d’assets.

Shen.inibin définit PARType=Energy,BaseMP=200,BaseStaticMPRegen=10,MPPerLevel=0 et MPRegenPerLevel=0. PARStart/PARMax sont absents. Passive1LuaName=ShenWayOfTheNinjaMarker,icône Shen_KiStrike.dds,ExtraSpell1=ShenKiAttack. Passive1 vaut9 ;la signification du champ n’est pas transformée automatiquement en preuve de durée. Passive1Desc évoque Jax,les descriptions suivantes +40/+60/+80% de régénération mana et les niveaux3/7/11/15 :cet héritage n’est pas adopté comme progression Ki Strike.

La description liée au personnage est game_character_passiveDescription_Shen_WIP et annonce8s. La description générale Shen annonce également8s. Le BuffData Shen Passive Marker et celui de ShenWayOfTheNinjaMarker résolvent le même texte détaillé :toutes les9s,prochaine attaque restaurant f2 énergie et ajoutant f1+10% des PVbonus en dégâts magiques ;chaque attaque sur un sbire ou champion réduit le délai de1s. Le vieux texte de description ShenKiAttack évoque les PVmax,à distinguer du bonusHP détaillé. Les deux fichiers Marker gardent leur identité propre ;aucune priorité ou équivalence de chargement automatique.

Le producteur de f1 et f2,leur progression,la sélection8s/9s,l’état initial,le moment de consommation et l’ordre de réduction restent non résolus. Le texte Feint précise une réduction additionnelle du délai Ki par attaque tant que le bouclier tient ;il utilise Effect5. Les valeurs et transitions effectives restent à qualifier dans leur consommateur,notamment à expiration ou absorption complète du bouclier.

20Lua entièrement parcourus,sans sous-fonctions. Cinq limites NEWTABLE :ShenBasicAttack,ShenBasicAttack2,ShenCritAttack,ShenKiAttack et ShenVorpalStar. Les15 initialisations littérales restantes ne sont pas une exécution serveur. CharScriptShen est vide. Marker expose PersistsThroughDeath et NonDispellable ;Aura et HardCooldown exposent noms/icônes,HardCooldown et WayOfTheNinjaCooldown partagent le nom Shen Passive Cooldown. Ces métadonnées ne démontrent pas durée,priorité,cumul ou lifecycle.

Le preload du personnage cite Aura,Marker,HardCooldown,isninja et apbonusdamagetotowers. Aura référence l’indicateur de disponibilité et les cooldowns,Marker/HardCooldown se référencent avec Aura. Les dépendances ne prouvent pas déclenchement ni rendu ;la constante TPAShen dans KiAttack ne qualifie pas le comportement du passif pour ce skin.

Shen.ddf comporte8lignes,dont trois non vides pour Q :texte6/10/14/18/22,health×0.015 et health×0.005. Ces bindings décrivent des soins de VorpalStar ;ils ne remplissent pas les f1/f2 du passif. Q natif décrit une marque soignant les attaquants et un soin instantané si le sort tue ;E natif décrit dash,taunt,réduction des attaques des cibles et énergie par champion ;R décrit un bouclier5s et téléportation après canalisation. Les anciens textes Destabilize/Feint-dodge restent contextes distincts,non règles adoptées.

Quatre candidats absents consignés :CharScript à la racine du personnage,KiAttack dans le sous-dossier Spells inexistant,Shen.en_gb.ddf et ShenPassive.inibin sous ce même sous-dossier. Les alternatives réelles sont présentes ;aucune absence globale ou corruption déduite.

| Ressource | Identité du registre |
|---|---|
| Shen.inibin | OLS-694cb940-aca7-5b40-ba31-1f0bcf2b6244 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Shen.ddf | OLS-25c379ae-26c6-577e-a37d-3a0a844ed1ec |
| CharScriptShen.luaobj | OLS-140f5f19-ed0e-5b09-8a9d-7baff70427f3 |
| CharScriptShen.preload | OLS-fdd74203-e34a-50f0-9b8d-58b66bf440fc |
| Shen Destabilize.inibin | OLS-9e828c23-9e7d-59a6-890e-002d1b7cd819 |
| Shen Feint Buff.inibin | OLS-f3692730-bc3b-5fe0-bbfb-7e83167208c2 |
| Shen Passive Aura.inibin | OLS-d9bd9a27-a902-51df-a758-a0887032bafe |
| Shen Passive Cooldown.inibin | OLS-ee5cea5b-e9d1-58ed-8fb7-dac5ec876551 |
| Shen Passive Marker.inibin | OLS-4983641a-fb2c-5350-bac7-7b1f32b60a3a |
| Shen Shadow Dash.inibin | OLS-46413581-174d-5f10-8f73-3ceaca87ba9b |
| Shen Stand United Channel.inibin | OLS-d764ae98-9b1f-5047-aff7-8163e2183e39 |
| Shen Stand United Shield.inibin | OLS-11aa0694-d0ec-5bf9-b03f-4fc849139514 |
| Shen Stand United Target.inibin | OLS-f76fd952-732e-5cbd-aa01-f9e6d263128d |
| Shen Vorpal Star Heal.inibin | OLS-114a0051-feb1-58a5-ba98-c65a8138c594 |
| Shen Vorpal Star.inibin | OLS-e54e7b44-6db0-597c-a491-3488516bb8af |
| ShenBasicAttack.inibin | OLS-53169865-8fd0-5a3d-840d-3e90dc0c2538 |
| ShenBasicAttack.luaobj | OLS-dae64a7f-4b9c-5047-9e69-d7fd46ffa4be |
| ShenBasicAttack2.inibin | OLS-cd2b310d-88ce-5544-8bc0-b2bfb0caa156 |
| ShenBasicAttack2.luaobj | OLS-6ddc3753-de41-5cac-977d-e706084459f6 |
| ShenCritAttack.inibin | OLS-76dc80c8-fbb5-54c8-b786-b88f37d4f4d7 |
| ShenCritAttack.luaobj | OLS-b7598f03-6d4b-5312-8af9-75f4bcd65644 |
| ShenDestabilize.inibin | OLS-e3c02205-c137-5c33-bdf1-2f3b8bc23c8d |
| ShenDestabilize.luaobj | OLS-9ad3a5f1-5352-55d8-836b-b7b36e026acc |
| ShenDestabilize.preload | OLS-026ff5ff-034e-5ad4-b622-d75f77fbad78 |
| ShenFeint.inibin | OLS-d3844f46-cda7-5798-ac21-530fd8d44c9a |
| ShenFeint.luaobj | OLS-0441142d-9bde-5a78-a270-76cdd731df36 |
| ShenFeint.preload | OLS-5ddcb738-f89c-5d11-bb3f-97ea18863de0 |
| ShenKiAttack.inibin | OLS-9606da11-a764-50a4-9f92-edeb93bf7041 |
| ShenKiAttack.luaobj | OLS-b6043b07-9f5e-594d-8782-04e75a0b545a |
| ShenKiAttack.preload | OLS-509333e9-381d-5413-a210-d3b13db8b7ec |
| ShenPassiveHardCooldown.luaobj | OLS-733ca9d5-ea3a-5c6f-a0ab-44bf7b49d96b |
| ShenPassiveHardCooldown.preload | OLS-1412602a-9283-59ed-a792-308a1f444e48 |
| ShenShadowDash.inibin | OLS-81599c97-003b-5ee3-bf40-a41a9993537a |
| ShenShadowDash.luaobj | OLS-91ae277f-a91c-5df2-9c80-5e6df7220eb8 |
| ShenShadowDash.preload | OLS-ea6f9c6e-344f-5e21-9fac-e7a1ee8631df |
| ShenShadowDashCooldown.luaobj | OLS-3cb2390e-4662-5f41-b8a1-bb920a2eeb16 |
| ShenShadowDashPassive.luaobj | OLS-9b560f7a-492b-5d0b-8b76-605c44a2ac4d |
| ShenStandUnited.inibin | OLS-772df09e-7944-5f95-9bfa-8c2f69184ad9 |
| ShenStandUnited.luaobj | OLS-dff429a4-587f-5d47-99be-c5164e19f1a5 |
| ShenStandUnited.preload | OLS-b66be70f-578e-5787-95ad-088f8fd57cee |
| ShenStandUnitedLock.luaobj | OLS-e0d742f4-3738-57a7-9926-cdcb6973fe9a |
| ShenStandUnitedShield.luaobj | OLS-4f5d90c7-c82e-5ce7-9b15-8dd8c436081e |
| ShenStandUnitedShield.preload | OLS-0917a037-b377-5823-bf68-a7ca070890b3 |
| ShenStandUnitedTarget.luaobj | OLS-e717d9a6-2772-5948-8b0f-1d9af8f4b056 |
| ShenStandUnitedTarget.preload | OLS-32419b8c-7660-5374-b72a-c0c317ccbb97 |
| ShenVorpalStar.inibin | OLS-1795a7ce-ef84-5938-bc7a-e3c914041f21 |
| ShenVorpalStar.luaobj | OLS-978cce43-1cce-506b-bfdd-36fecbaa12ef |
| ShenVorpalStar.preload | OLS-7a324609-334f-53ba-9290-d827ce82f677 |
| ShenVorpalStarHeal.luaobj | OLS-c31b6a7e-4215-5125-9c73-20c3dec05247 |
| ShenVorpalStarHeal.preload | OLS-60579ecd-44a4-5872-8300-fb52d6aa027c |
| ShenWayOfTheNinjaAura.luaobj | OLS-e319cee7-e8aa-5006-ac93-27af1d362c31 |
| ShenWayOfTheNinjaAura.preload | OLS-591bbfb0-45dd-5eb4-bd7f-2037fc91cf7f |
| ShenWayOfTheNinjaCooldown.luaobj | OLS-36b09ca9-dfc7-5bb9-adc8-0d81ef46b825 |
| ShenWayOfTheNinjaMarker.inibin | OLS-5c7e4354-dd62-5a4b-9e1b-1beeafa153ac |
| ShenWayOfTheNinjaMarker.luaobj | OLS-a9de56a5-52fd-56e6-a61e-93cde4454f36 |
| ShenWayOfTheNinjaMarker.preload | OLS-d29402a0-38e0-5476-83a0-fe74554c199c |

## Références communautaires

27 fichiers identifiés séparément de l’autorité native et du Rust. CharScriptShen.cs est vide. Aucun marqueur ShenWayOfTheNinja dans les quatre fichiers Q/W/E/R inspectés ;cela ne prouve pas une absence globale ailleurs. Aucun script exécuté ici comme serveur historique.

- Q ajoute ShenKiMark4s et multiplie les dégâts par1,3 sur une cible marquée. Il ne démontre pas les soins natifs aux attaquants ou au kill.
- W délègue ShenFeintShield2,5s et une particule. Le commentaire de remboursement d’énergie ne prouve ni ce remboursement ni la réduction supplémentaire de délai Ki.
- E applique dégâts et Taunt1,5s à des unités d’un cône de600. La particule ne démontre pas le déplacement,la sélection native des champions,le remboursement d’énergie ou la réduction de leurs attaques.
- R délègue un buff3s à un allié,avec repli sur le porteur si cible absente. Aucune canalisation/téléportation effective ou durée5s du bouclier n’est démontrée dans ce fichier ;le commentaire ne remplace pas le code.

## Diagnostic : attendu et observé

BUILD=0,RUN=0,collecte=0,inspection=0. Cœur Rust hors configuration test,offline/locked,dépendances alignées avec Cargo.lock. 1158entrées source et preuves antérieures contrôlées. Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-shen-passive-ki-strike-probe.exe`,6078976 octets,SHA256 `c6d30a0ba5cf44ef793371c2135b53437c1eaa64c94a44e4d298a716c40d74c9`.

Trois profils publics niveau1 contre Annie :base,Rubis1028+150PV,Saphir1027+200mana. Achats/ventes/rachats réels ;six trajets Move/Stop sans réémission. Aucune position,vie,énergie,stat,rang ou délai injecté.

Chaque profil :trois attaques,271ticks d’attente (>8s et9s),puis trois attaques. Total18impacts,813ticks et81refus atomiques :acteur inconnu,autoattaque de soi,slot invalide,apprentissage et lancements QWER avant/après. Les snapshots sont inchangés après refus.

| Profil | PVmax | Énergie / plafond | Attente en ticks | Dégâts physiques observés | Refus |
|---|---:|---:|---:|---:|---:|
| base | 570.79999 | 200/200 | 271 | 50.46973 | 27 |
| Ruby150HP | 720.79999 | 200/200 | 271 | 50.46973 | 27 |
| Sapphire200Mana | 570.79999 | 200/200 | 271 | 50.46973 | 27 |

Attendu textuel :Ki Strike ajoute des dégâts magiques périodiques et dépend des PVbonus. Observé :AD60.1699981689 et dégâts physiques ordinaires50.46971..50.46973 dans tous les profils et les deux séries,aucun bonus magique observé. La régénération et mitigation ordinaires sont contrôlées. L’ajout150PV est effectif mais ne modifie pas les dégâts. Le supplément théorique lié aux seuls PVbonus serait15brut si la règle native décrite s’applique ;ni la base f1,ni son ordre,ni le déclenchement effectif ne sont inventés.

L’énergie et son plafond restent200,même avec l’objet mana. Ce contrôle préserve la distinction Energy/Mana. Il ne démontre pas l’absence de restitution par Ki :une jauge pleine masque un éventuel gain et aucun sort Shen n’est accepté pour la dépenser. Régénération sous le plafond,restauration,caps et arrondis restent à exercer. Tous rangs/délais QWER0 ;Feint et sa réduction conditionnelle ne sont pas exécutés. Mort/réapparition non exercées.

La recherche exacte Shen/WayOfTheNinja/KiStrike dans crates/core/src ne trouve aucun chemin dédié. Les points génériques d’attaque,ressource et bouclier sont associés sans être promus en implémentation de Ki Strike. Sept ressources locales sont liées :champions,croissance,ressources,attaques,critiques,collisions,boutique.

| Point de code | Rôle vérifié |
|---|---|
| crates/core/src/lib.rs:533 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/lib.rs:598 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/progression.rs:68 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/progression.rs:150 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/progression.rs:159 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/spells.rs:101 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/annie_w.rs:29 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/lib.rs:685 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/lib.rs:744 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/damage.rs:53 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/attacks.rs:157 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/lifesteal.rs:4 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/regeneration.rs:32 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/regeneration.rs:10 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/shop.rs:261 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/shop.rs:215 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/world.rs:226 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/damage.rs:38 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/attacks.rs:26 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/lifecycle.rs:16 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/lifecycle.rs:24 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:635 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/ally_occupancy.rs:526 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/spells.rs:5 | current Shen ordinary damage,Energy,health or spell-refusal boundary |
| crates/core/src/shields.rs:12 | generic shield boundary,Feint not executed or accepted |
| crates/core/src/shields.rs:41 | generic expiry,not KiStrike extra reduction |

## Intégration et conservation

PREPARE/CHECK/PUBLISH/AUDIT :code0. Les tests négatifs refusent72associations et4graphes invalides,notamment fausse acceptation,source manquante,binaire modifié,question étrangère et dépendance retirée. Graphe99177sources/4678consommateurs ;revue globale de4678ancres exactes sans divergence. Le contrôle structurel global ne re-hache pas toutes les sources ;les entrées sélectionnées sont vérifiées séparément par identité.

Deux bases SQLite :quatre destinataires actualisés,42603 autres lignes conservées,42607 états manuels et23 historiques identiques,synchronisation Store idempotente. Trois fragments de traçabilité changés,42212 inchangés. Trois questions propres et quatre dépendances conservées. Registres des identités,hiérarchie et inconnues inchangés octet pour octet.

Fichiers livrés :completion_tasks_2026-10-20.json,fidelity_requirement_trace_4_20.json,fidelity_sources_4_20.json,reçu reference_requirement_trace_sources/shen-passive-ki-strike-links-v625.json,preuve fidelity_shen_passive_ki_strike_links_v625.json et ce rapport. Couverture,plan de complétion,reprise,CURRENT et HANDOFF mis à jour avec sauvegardes. Scripts,journaux,diagnostic Rust et observations conservés dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 sous revision625_shen et revision625_Shen. Les erreurs historiques V624 sont préservées ;les compteurs de la nouvelle revue sont précontrôlés explicitement.

## Travail restant et limites

Résoudre f1/f2 et progression,8s/9s,état initial,consommation/réduction du délai et priorité des variantes. Implémenter bonus magique,restitution d’énergie et interaction Feint puis qualifier impacts prêts/non prêts,attaques interrompues,PVbonus,critiques,résistances,boucliers,caps et cibles. Vérifier énergie sous le plafond,Feint intact/absorbé/expiré,mort/réapparition,reconnexion,HUD,VFX,sons,animations et réseau séparément. Aucun serveur historique ou rendu exécuté. Les divergences communautaires et V564/V606 restent ouvertes. Ni Shen,ni le jeu,ni SYS-01.2-02 ne sont déclarés terminés.

Suite : Continuer SYS-01.2-02 depuis revision626_trace_review/REVIEW.json. V625 Shen / Ki Strike :57sources natives,171associations,26points et52liens. Marker :9s,bonus magique f1+10%bonusHP,restauration énergie f2 et réduction1s par attaque sbire/champion ;description WIP8s,Passive1 numérique9 et ancien texte maxHP distincts. Valeurs f1/f2,progression et ordre non résolus ;Feint ajoute une réduction pendant le bouclier. Energy200,regen10 ;héritage Jax,mana40/60/80%,niveaux3/7/11/15 non adoptés. Sources dans Scripts et Spells globaux,20Lua dont5limites NEWTABLE,13preloads,12BuffData résolus. CharScripts vides ;DDF8lignes,trois liaisons Qsoin,non Ki Strike. 27références communautaires :Q×1,3 contre marque sans soin natif,W délégation sans réduction Ki qualifiée,E cône sans dash/énergie qualifiés,R buff3s sans canalisation/téléportation démontrées. Trois cas publics base/Rubis150HP/Saphir200mana :18attaques physiques50,46972,81 refus,813ticks dont271 par attente,six trajets. Aucun bonus magique après plus de9s ;Rubis augmente PV570,8→720,8 sans effet sur les dégâts,Saphir ne change pas énergie200. Énergie au plafond :restauration du passif non testée ;aucun sort Shen accepté ni Feint exécuté. BUILD/RUN/inspection0 ;acquis génériques,V564/V606 et états du plan conservés,aucun gameplay modifié. PREPARE/CHECK/PUBLISH/AUDIT :0 ;72+4 refus de publication. Prochain passif à inspecter réellement :Shyvana. Goal actif.
