# SYS-01.2-02 — Olaf : sources et consommateurs de Berserker Rage (V612)

Date UTC : 2026-10-26T12:29:43.837501+00:00. Projet F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral du 2014-11-17 à17:46:45 ; fuseau et déploiement non établis. Catalogue4.20.1 distinct.

## Résultat

CH-Olaf-PASSIF-SOURCE, CH-Olaf-PASSIF-SIMULATION-CONTRAT et CH-Olaf-PASSIF-SIMULATION sont reliées à44sources natives,132associations,24points actuels et48liens sur les deux fiches de simulation. Aucun gameplay ni asset modifié ; aucune fiche déclarée complète.

Deux essais publics montrent une cadence inchangée entre pleine vie, blessure et récupération :43ticks sans objet et37avec Dague. Les12intervalles mesurés entre débuts d’attaque ne reçoivent aucun bonus malgré environ26à29%de PV manquants. Le bonus de la Dague est effectif, celui du passif manque au chemin inspecté.

## Sources natives et limites

- Olaf.inibin lie **OlafBerzerkerRage** et Olaf_Passive.dds. BuffData et description en_GB donnent1%de vitesse d’attaque par1%de PV manquants. Textes aux lignes2426,4247 et4423 du font consulté.
- Berzerker est l’orthographe de cette ressource native ; l’alias avec Berserker n’est pas substitué automatiquement. Les sorts sélectionnés sont sous Characters/Olaf/Spells et le CharScript à la racine du personnage.
- Passive1 et Passive1Desc sont absents. Passive1Level1..3=1/4/7 n’est pas adopté comme progression démontrée du bonus. Absence de champ ne signifie pas zéro.
- Le Lua du passif expose nom/icône, PersistsThroughDeath et NonDispellable. Ce sont des métadonnées ; elles ne prouvent pas un callback de recalcul ni tous les comportements mort/respawn. CharScripts natif et communautaire vides.
- 13INIBIN,20Lua,9preloads,1DDF et1font composent les44sources. Tous les Lua sont parcourus intégralement sans prototype enfant :9initialisations littérales,11limites NEWTABLE. Une limite du lecteur n’est pas une corruption. Trois clés BuffData et quatre tooltips QWER sont liés exactement.
- DDF8lignes : Q/OlafAxeThrowCast f1=bonusattackdamage×1,0 ; W/OlafFrenziedStrikes f1=health×0,01 ; six lignes vides. Le lien W n’est pas une formule du passif Berserker Rage.
- Deux fichiers OlafRagnarokPassiveBuff.luaobj, sous le personnage et sous DATA/Spells, font90octets avec le même SHA-256. Les deux chemins et appartenances restent conservés ; égalité des octets ne prouve pas priorité runtime. Ce passif de R ne devient pas le passif du champion.
- Cinq candidats absents : CharScript sous Scripts, passif global, alias Berserker.inibin, preload et DDF individuels du passif. Les sources réellement trouvées restent liées. Aucun manque global d’assets n’est établi. Aucun NightmareBotOlaf dans les emplacements inspectés.
- La formule d’intégration, le cumul, les plafonds, arrondis, moments de recalcul et nettoyage restent à qualifier. Le texte1%/1% ne suffit pas à prouver tous les détails du serveur historique.

Dix-huit références communautaires sont séparées du serveur original. Q possède un lancement de projectile commenté et un calcul1,1ADtotal, contre le lien natif1,0bonusAD. E utilise25%des PVcourants et0,4bonusAD ; les sources natives décrivent30%des dégâts infligés comme coût, remboursé si la cible meurt, et CharTotalPhysical. Le remboursement n’est pas appliqué dans le corps communautaire lu. R ajoute des défenses pendant l’actif et30ADau rang1 ; le texte natif annonce la perte du passif défensif, avec40ADdans Effect3Level1Amount. W délègue un buff6s ; ses interactions de soin ne sont pas qualifiées ici. Aucun de ces scripts n’est exécuté comme consommateur Rust de ce lot.

Identités contrôlées par taille/SHA-256 et appartenance RADS sélectionnée. Les chemins distincts sont conservés.

| Fichier | Source |
|---|---|
| Olaf.inibin | OLS-02620583-f235-5e31-9a00-b48a386e503e |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| Olaf.ddf | OLS-1b50d20a-69e0-5d8d-bbd4-1a87f1df86e1 |
| CharScriptOlaf.luaobj | OLS-43b42d24-fa55-5a88-a7e6-fc7355e7f951 |
| CharScriptOlaf.preload | OLS-319edef5-5a46-571b-bdf5-8062e92510bc |
| OlafAxeExpirationTimer.luaobj | OLS-557435dd-d365-5f4f-a962-86f645f26158 |
| OlafAxeExpirationTimer.preload | OLS-1d5ffbde-2643-5283-8d0c-dd1d68a37150 |
| OlafAxeExpirationTimer2.luaobj | OLS-fb7bd3f6-08c3-523b-8ab0-8ff8d0d45651 |
| OlafAxeThrow.inibin | OLS-fa7cf987-fc54-5179-b74e-3279583b0905 |
| OlafAxeThrow.luaobj | OLS-58c8326f-050b-5a38-9813-2ac12da9b9ac |
| OlafAxeThrow.preload | OLS-0952508f-cb28-5435-b4ce-6c8d605e4e83 |
| OlafAxeThrowCast.inibin | OLS-46b1e3b2-314f-566c-b461-067d1d600525 |
| OlafAxeThrowCast.luaobj | OLS-a3b596d3-c238-586e-8d63-13fef9155d76 |
| OlafAxeThrowCast.preload | OLS-a991885e-6f08-56b3-8ebb-a662a403a744 |
| OlafAxeThrowDamage.inibin | OLS-b8413a02-0007-5686-b476-4dfc50dc0320 |
| OlafAxeThrowDamage.luaobj | OLS-c4edbb57-6cb6-58a8-9ed5-4d85ace2f10b |
| OlafAxeThrowDamage.preload | OLS-c8320e61-7f48-574d-94c1-788c24f06929 |
| OlafAxeThrowHitMarker.luaobj | OLS-a1e12bb5-8ed3-52bb-a098-3686202230a0 |
| OlafBasicAttack.inibin | OLS-106f34cb-5846-5afc-adf0-dcd2b9b7c856 |
| OlafBasicAttack.luaobj | OLS-a2512340-1675-57a9-8561-38c3c644a8b1 |
| OlafBasicAttack2.inibin | OLS-c9cca2b3-4587-5020-baf9-ac08bc45ca5d |
| OlafBasicAttack2.luaobj | OLS-02297403-e2df-5ad7-b69b-36550bcf6897 |
| OlafBasicAttack3.inibin | OLS-c1bdaeaa-a531-5f39-b37c-c294ff104935 |
| OlafBasicAttack3.luaobj | OLS-a76ac212-fe70-578d-a9d0-44f68fdfe226 |
| OlafBerzerkerRage.inibin | OLS-478a7bea-f601-59cf-a479-6a320c9f736e |
| OlafBerzerkerRage.luaobj | OLS-617799da-ca67-5e65-94f7-f3c68617e150 |
| OlafCritAttack.inibin | OLS-d47da5e3-4d9a-5736-a195-135a1aca2312 |
| OlafCritAttack.luaobj | OLS-f3a57266-b924-5fb5-88fb-8cb5f227f212 |
| OlafCritAttack2.inibin | OLS-fabe754e-a2a4-542c-a93a-867ce8a3a67d |
| OlafCritAttack2.luaobj | OLS-776ceaef-08f9-56ac-a104-30a158650122 |
| OlafFrenziedStrikes.inibin | OLS-ef22111d-179a-5221-83f8-c172245c8927 |
| OlafFrenziedStrikes.luaobj | OLS-67237e01-4570-572f-a969-c9a7d6c1eafa |
| OlafFrenziedStrikes.preload | OLS-072b8855-440a-52e9-8913-b12339b4753f |
| olafIgnoreCollision.luaobj | OLS-8cbfa816-ded4-5808-8965-5dd2adcabd4b |
| OlafRagnarok.inibin | OLS-b21acc17-5a23-54d0-ba7e-3614a4818ffe |
| OlafRagnarok.luaobj | OLS-5936cc63-8861-54ec-bc9e-54bf28030b7c |
| OlafRagnarok.preload | OLS-b1318c92-edd2-5732-8f2c-133ce788b839 |
| OlafRagnarokPassiveBuff.luaobj | OLS-54734963-e394-5319-9090-ca90bf25b678 |
| OlafRecklessStrike.inibin | OLS-f5c33cb1-6bbc-5a55-8913-f9d531642fa7 |
| OlafRecklessStrike.luaobj | OLS-159001c4-0219-5334-b5db-37dfe8c27306 |
| OlafRecklessStrike.preload | OLS-3d4bb7cf-3e64-57b7-b7a3-8e1e1907a83f |
| olafSlow.luaobj | OLS-f0ad7972-c6c8-57ea-915b-f0bd0bb95a6d |
| olafSlow.preload | OLS-7fd57ede-b73f-5644-8655-366e20dedbba |
| OlafRagnarokPassiveBuff.luaobj | OLS-9ee5238b-872b-5c23-912d-d6737c7a4c43 |

## Exécution : attendu, observé et limites

Prérequis de phases/lots consultés. Trois questions propres et quatre dépendances conservées. Compilation Rust --locked --offline du core réel hors configuration de test, dépendances alignées sur Cargo.lock. Les1158entrées core/ressources et la chaîne de preuves antérieures restent inchangées.

Deux parties publiques Olaf/Annie, sans objet puis Dague1042(+15%vitesse d’attaque). AD59,98, PVmax597,24 dans les deux cas ; aucun état, dégât, soin, niveau ou déplacement injecté. Les personnages restent vivants niveau1, sans victoire, contrôle de foule ni bouclier ; rangs/délais Olaf nuls et mana plein. Quatre trajets de préparation réussis sans reprise.

Chaque cas : trois attaques Olaf à pleine vie ; trois attaques physiques Annie et un QAnnie ; trois attaques Olaf blessé ;120ticks de régénération ; trois attaques Olaf en récupération. Total18attaques mêlée,6impacts physiques entrants,2Q,240ticks d’attente et54refus atomiques.

| Cas | AD | Cadence en ticks | Fraction de PV manquants, blessé | Fraction de PV manquants, récupération | Refus |
|---|---:|---:|---|---|---:|
| base | 59.98000 | 43 | [0.2820621132850647, 0.291276216506958] | [0.26135414838790894, 0.27056825160980225] | 27 |
| Dagger15percentAS | 59.98000 | 37 | [0.28339195251464844, 0.291276216506958] | [0.2640138864517212, 0.271898090839386] | 27 |

Les trois séries de chaque cas donnent chacune deux intervalles entre débuts d’attaque : six intervalles43ticks sans objet et six37ticks avec Dague. Les témoins windup.started/release identifient la cadence et chaque impact. Les échantillons à pleine vie ont0PVmanquant ; les phases blessées/récupération ont26à29%de PVmanquants. Les statistiques de cadence restent constantes malgré cette variation.

Attendu pour le code générique courant : cadence modifiée par l’objet, aucune dépendance aux PV d’Olaf, dégâts ordinaires après armure et régénération. Observé conforme à ce chemin, avec résidus de dégâts inférieurs à0,002. Ce succès confirme l’écart avec le bonus décrit par le texte natif ; il ne valide pas Berserker Rage.

Les deux QAnnie sont acceptés, brut80/coût60, avec correction de résistance et régénération. Les240ticks de récupération ne montrent que la régénération ordinaire. Les54refus atomiques couvrent joueur inconnu, auto-attaque, slot invalide et Learn/Cast/CastAt QWER avant/après ; snapshots inchangés. Aucun sort Olaf accepté.

Binaire `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-olaf-passive-berserker-rage-probe.exe`, 6125568octets, SHA-256 `9e7434ea544e5041a38e59b0558be76ab3c978c9e7d47346127f0de1b3fc166d`. BUILD/RUN/inspection :0. Les échecs antérieurs, notamment le premier diagnostic Nunu supposant à tort un mana plein après achat, restent dans la chaîne de preuves ; ils ne sont pas rejoués ni effacés.

Portée : deux profils niveau1, pleine vie et environ26à29%de PVmanquants, une cible ennemie, pas de W, plafonds extrêmes, changement de PVmax, mort/respawn ou réseau. Aucun serveur historique, rendu ou audio exécuté. Les trajets réussis ne ferment ni V564 ni les deux échecs d’arrivée V606.

## Consommateurs réels

Recherche Olaf/BerserkerRage/BerzerkerRage dans crates/core/src sans occurrence, complétée par lecture et exécution des routes. La recherche lexicale seule ne constitue pas une preuve d’absence globale.

progression::stats calcule attack_cooldown_ticks depuis cadence de base, croissance, objets, bonus Trundle/Ezreal et pénalité Exhaust, puis arrondi et minimum12ticks. Aucun terme Olaf/PV n’y figure. advance_attacks consomme cette cadence pour programmer les attaques et windup_ticks calcule leur préparation. Les essais montrent ces mêmes43/37ticks dans les trois états de santé. Les règles génériques d’arrondi/plancher sont des règles actuelles, sans acceptation historique globale.

Huit ressources locales liées séparément : catalogue, croissance, ressources, attaques, critiques, collision, boutique et QAnnie. Leur présence ne constitue pas une implémentation du passif.

| Ancre exacte | Portée |
|---|---|
| crates/core/src/lib.rs:533 | ordinary Olaf spawn |
| crates/core/src/lib.rs:598 | public actions and atomic refusals |
| crates/core/src/progression.rs:68 | attack cadence uses generic modifiers without Olaf missingHP term |
| crates/core/src/progression.rs:150 | unsupported Olaf learning |
| crates/core/src/progression.rs:159 | unsupported Olaf ranks |
| crates/core/src/spells.rs:101 | unsupported Olaf targeted spell |
| crates/core/src/annie_w.rs:29 | unsupported Olaf ground spell |
| crates/core/src/lib.rs:685 | tick order with240idle ticks and18melee hits |
| crates/core/src/lib.rs:744 | state witnesses,not network acceptance |
| crates/core/src/damage.rs:53 | ordinary physical and magical incoming damage |
| crates/core/src/attacks.rs:157 | 18Olaf melee and6Annie ranged impacts,12measured cadence intervals |
| crates/core/src/lifesteal.rs:4 | ordinary melee damage,not passive speed producer |
| crates/core/src/regeneration.rs:32 | ordinary HP recovery separated from attack speed |
| crates/core/src/regeneration.rs:10 | per-tick health prediction |
| crates/core/src/shop.rs:261 | Dagger1042+15percent attack speed |
| crates/core/src/shop.rs:215 | ordinary item attack speed modifier |
| crates/core/src/world.rs:226 | ordinary target state |
| crates/core/src/damage.rs:38 | ordinary physical mitigation |
| crates/core/src/attacks.rs:26 | release/start witnesses and fixed43or37tick cadence |
| crates/core/src/critical.rs:12 | ordinary attack profile context |
| crates/core/src/annie.rs:45 | two accepted Q80raw60mana |
| crates/core/src/annie.rs:73 | two Q impacts create missingHP |
| crates/core/src/ally_occupancy.rs:635 | four public preparation travels,no reorders |
| crates/core/src/ally_occupancy.rs:526 | navigation boundary,V564 remains open |

## Publication et conservation

Registres modifiés : docs/completion_tasks_2026-10-20.json, docs/fidelity_sources_4_20.json et docs/fidelity_requirement_trace_4_20.json. Reçu docs/reference_requirement_trace_sources/olaf-passive-berserker-rage-links-v612.json ; preuve docs/fidelity_olaf_passive_berserker_rage_links_v612.json. Instructions copiables enrichies dans les trois fiches et la synthèse SYS-01.2-02.

PREPARE/CHECK/PUBLISH/AUDIT :0. 72associations altérées et4graphes invalides refusés. Trois fragments de traçabilité modifiés,42212identiques. Deux bases locales : quatre destinataires,42603autres lignes,42607états manuels et23historiques conservés ; synchronisation normale idempotente. Identifiants, hiérarchie et inconnues inchangés octet par octet. Aucun statut, critère, propriétaire, case ou note clôturé automatiquement.

Revue globale :99125sources,4342consommateurs,4342ancres exactes sans divergence. Vérification structurelle globale (source_hashes_verified=0) ; sources sélectionnées et code hachés séparément. Aucun recontrôle exhaustif de toutes les sources revendiqué.

coverage.json, completion_plan.json, resume_checkpoint.json, docs/ai/CURRENT.md et HANDOFF.md actualisés en conservant les preuves antérieures. Aucun stage/reset/commit/nettoyage.

Preuves privées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 : revision612_Olaf_discovery/OBSERVATIONS.json ; revision612_Olaf_passive_probe/OBSERVATIONS.json ; revision612_Olaf_inspection/OBSERVATIONS.json ; revision612_Olaf/DELIVERY_AUDIT.json ; revision613_trace_review/REVIEW.json. Scripts, binaires et reçus identifiés dans ces preuves.

## Travail restant

1. Qualifier formule, ordre de cumul, caps, arrondis et moment du recalcul du bonus1%/1%.
2. Implémenter le bonus dans le calcul effectivement consommé par les attaques et le HUD.
3. Tester pleine vie, faible perte,50%et quasi100%de PVmanquants, plusieurs niveaux et objets.
4. Vérifier soins, régénération, boucliers sans perte de PV, variations de PVmax, dégâts simultanés et W.
5. Vérifier changements de cadence pendant un windup, annulations, contrôles de foule, mort/respawn et nettoyage.
6. Qualifier séparément QWER, présentation, HUD, particules, animations, audio et réseau.

Les trois fiches Olaf restent ouvertes. Les limites Battle Training et navigation sont conservées. Goal actif.

Suite : Continuer SYS-01.2-02 depuis revision613_trace_review/REVIEW.json. V612 Olaf / Berserker Rage :44sources natives,132associations,24points et48liens. Texte natif :1%vitesse d’attaque par1%PV manquants. Deux cas publics base/Dague1042+15%AS :18attaques mêlée,6impacts physiques entrants,2Q Annie,240ticks de régénération et54refus atomiques. Trois phases pleine vie/blessé/récupération ;12intervalles mesurés restent43ticks sans objet et37avec Dague malgré26à29%PV manquants. Bonus du passif absent du chemin de statistiques et des attaques observées. Aucun sort Olaf accepté. 20Lua dont11limites NEWTABLE,9preloads,8DDF,3clés BuffData résolues ;18références communautaires. CharScripts natif et communautaire vides. Deux chemins RagnarokPassiveBuff ont les mêmes octets, priorité inconnue. Berzerker est l’orthographe de la ressource ;5candidats absents ne prouvent pas un manque global d’assets. Q communautaire projectile commenté et1,1ADtotal contre1,0bonusAD natif ; E coûte25%PVcourants contre30%dégâts décrits ; R ajoute des défenses pendant que le texte natif prévoit leur perte. Aucun script communautaire adopté comme serveur original. Quatre trajets réussis ; V564 et deux échecs V606 ouverts. Aucun gameplay modifié. BUILD/RUN/inspection/PREPARE/CHECK/PUBLISH/AUDIT0 ;72+4refus de publication. Prochain passif à inspecter réellement : Orianna. Goal actif.
