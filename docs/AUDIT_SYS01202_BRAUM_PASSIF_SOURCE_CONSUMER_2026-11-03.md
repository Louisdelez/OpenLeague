# SYS-01.2-02 — Braum PASSIF-SOURCE : source et consommateur borné, V1188

3 novembre 2026. Unité **AUD-SYS-01.2-02-BRAUM-PASSIF-SOURCE-CONSUMER-01**, selon `F:/OpenLeague/docs/audit/AUDIT_CHARTER.md`. **Un audit statique borné terminé avec preuves ; zéro tâche SOURCE, inconnue ou fonctionnalité close.** Restriction documentaire respectée : aucun changement Goal, Plan, UI, base, produit, code, asset ou registre.

## 1. Exigence précise et frontières

Cible `CH-Braum-PASSIF-SOURCE`, **OLF-97580864-ed1d-58d7-bbf2-ab5b9e1e5ba7** ; inconnue propriétaire **OLU-8cb29ec4-39dd-5c76-bda8-21d2486314dc**, ouverte. Le critère courant exige une fiche 4.20 datée/source/SHA, valeurs et exceptions séparées des inconnues, disponibilité historique décidée sur preuve. Les huit champs contractuels comparés à V660 concordent. SOURCE reste requise, `a_qualifier`, trace `partial_with_open_questions`, implémentation et acceptation incomplètes. Le prérequis `CH-Braum-IDENTITE` reste `a_qualifier` et non accepté ; package `D06-CH-Braum` et ses six packages requis restent ouverts.

Le lot rapproche V660, l’extrait daté V1182, le contrat courant préparé et les corps consommateurs nommés. Il examine initialisation, dispatch, attaques propriétaire/alliés, dégâts, stun, tick, mort et snapshot. Il ne qualifie pas le serveur original, les règles complètes, l’admission historique ou la présentation.

| Dimension | Conclusion |
|---|---|
| Audit | Terminé pour cette liaison documentaire bornée |
| Implémentation | Voies génériques présentes ; aucun producteur Braum qualifié dans les corps lus |
| Vérification | Statique/documentaire effectuée ; aucun runtime courant |
| Acceptation humaine | Non demandée/non donnée ; aucun gameplay accepté |

SYS-01.2-02 reste ouvert ; terminer cette unité ne termine ni sa tâche SOURCE ni le jeu.

## 2. Sources, provenance, identités et limites

Client primaire **PUBLIC 4.20.0.315, EUW/en_GB**, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus. Catalogue 4.20.1 distinct. Preuves V660 du 27 octobre 2026 : `F:/OpenLeague/docs/FIDELITY_BRAUM_PASSIVE_CONCUSSIVE_BLOWS_LINKS_V660.md` (25198 octets, SHA `f6e3d19f57237adeef7e0791811010aedcf31234c4a3607af61e77769f6397a3`) ; reçu exact `F:/OpenLeague/docs/reference_requirement_trace_sources/braum-passive-concussive_blows-links-v660.json` (6042989 octets, SHA `de13a54bff2c5c88e74f9417df842ca41254a9f45c3f4772927d99c6e868f94f`) et vérification `fidelity_braum_passive_concussive_blows_links_v660.json` (2951 octets, SHA `5e794bbc07cd7658bd68d3e95a806aebed07f7927d263b1b9edb684c0bfbd7f5`). Leurs pins correspondent à la matrice V1182.

Les **26 payloads natifs sélectionnés** hors Deprecated sont identifiés par chemins complets, tailles/SHA et appartenance RADS héritée. **26/26** concordent avec les identités de l’extrait V1182 enregistré le 2026-11-03T17:09:54Z (313 vérifications partagées). Aucun natif D: ouvert, rehashé ou décodé ici. La présence au manifeste ne prouve ni priorité runtime ni disponibilité historique : cette dernière reste **indéterminée**, donc le critère SOURCE n’est pas satisfait en totalité.

V660 totalise **78 associations sur trois destinataires**, soit 26 par SOURCE/SIMULATION-CONTRAT/SIMULATION. SOURCE courant porte **32 relations natives vers ces mêmes 26 identités**, dont six relations antérieures conservées, et 60 références. Les 2316 entrées source_pins du reçu incluent le contexte de preuve ; elles ne sont pas 2316 natifs sélectionnés. Les 22 sites/44 liens de frontière appartiennent aux deux fiches simulation.

Définition : `Passive1LuaName=BraumMarkDamageTracker`, icône `Braum_Passive.dds`, nom/description natifs. `Passive1`, `Passive1Desc` et `Passive1Level1..6` absents ne valent pas zéro. Le texte décrit première marque par Braum ou Winter’s Bite/Q, contribution des attaques alliées après celle-ci, quatre marques, durée annoncée quatre secondes, puis stun/dégâts et période sans nouvelles marques avec bonus magique des attaques de Braum. **f1 dégâts, f2 stun, f3 immunité et f5 bonus n’ont pas de producteur qualifié.** Les nombres de Q ne deviennent pas les dégâts du passif.

Périmètre V660 : 290 ressources natives, dont 181 Deprecated ; 125 Lua entièrement consommés, zéro fonction enfant, 45 limites NEWTABLE. Ces limites du lecteur ne prouvent pas des globals originaux vides. Les six basenames E/Q/W doubles restent séparés par chemins complets. CharScript vide et DDF 48 lignes/dont neuf renseignées n’établissent pas de callback serveur ; le lien ancien BraumSlowShot;f1→MarkDamage n’établit pas le tracker courant. Conserver Kennen_MarkOfStorm/KennenMarkOfStorm/KennenMoSDiminish, LeonaShieldOfDaybreak/LeonaSkin04, GemKnight_Shatter et MaokaiTrunkSmash sans importer leurs règles. Le tooltip MarkDiminish absent et les preloads restent des limites, pas des preuves de stun/rendu.

Contrat courant réemployé depuis le cache immuable `E:/mapslol3v3/audit_sys01202_passive_contracts_20261103/passive_task_contract_snapshot_122.json`, SHA `6567a15ae5ed0b7bad77c594afdd216d523a07e32f1999a684b625b7cfcc84c0` : 122 SOURCE/1350 contrats, zéro audit clos. Ses deux entrées ont été vérifiées avant préparation ; aucun grand registre reparsé ici. Une dérive impose un nouveau snapshot versionné, sans écraser le cache ni l’extracteur.

## 3. Consommateurs réels courants

Le sous-reçu code épingle **28 fichiers nommés**, tous conformes aux pins V660. Intersections conformes : Brand 26/26, Blitzcrank 17/17, Azir 14/14, Ashe 12/12, sans rejouer leurs collecteurs. Les 22 CID de frontière et six CID SOURCE correspondent à **27 emplacements distincts**, le catalogue `lib.rs:149` ayant deux CID. Les frontières restent `entry_boundary_only`, `provides_feature_consumer=false`. Les cinq helpers SOURCE lisent/hashent des données brutes ; leur drapeau de lecteur ne prouve aucun producteur gameplay.

| Trajet courant lu | Conclusion statique |
|---|---|
| lib.rs catalogue/join/Effects ; spells.rs initialisation | Données de base et états génériques ; aucune marque Braum propriétaire/cible attribuable |
| command, progression next_rank, cast, cast_at | Learn/Cast/CastAt Braum refusés dans les branches lues ; Q initiateur non exercé |
| attacks.rs ; lifesteal basic_attack_hit | Impacts mêlée/projectile→Physical, vol de vie/réplique distincts ; aucune admission alliée après marque, compteur ou proc Braum qualifié |
| damage/penetration/shields/world | Dégâts et protection génériques ; aucun calcul f1/f5 ou ciblage Braum natif établi |
| stuns.rs ; control_duration | tag/source/expires_at, durée fournie par appelant ; aucun callsite du quatrième coup ou immunité f3 qualifié |
| advance/régénération/mort/XP/snapshot | Tick 30Hz, systèmes nommés, cleanup/crédit et clone d’état génériques ; aucun timer quatre secondes, cycle d’immunité ou réplication Braum qualifié |

Les ancres et **33 fenêtres numérotées** sont dans `current_consumer_review.json`. Une recherche unique `Braum|Concussive|BraumMark` sur **16 fichiers Rust explicitement nommés**, sans récursion, ne trouve aucun hit (code 1 attendu). Elle corrobore les corps lus, sans prouver une absence globale dans projet/assets/archives. Catalogue et cinq helpers INIBIN/Lua restent séparés du gameplay ; aucun décodeur/VM exécuté. Le `source_sha256` du JSON ressources suit la politique connue de données décodées, pas le SHA brut INIBIN ; aucune nouvelle enquête de hash n’est inférée.

## 4. Comportement, contrôles et résultats

**Exécuté V1188 :** collecteur natif 13/13 cohérences ; collecte courante 28 pins, 28 CID, 33 fenêtres et recherche bornée ; intégration **15/15**, premier passage réussi. Incidents exploratoires de lecture (sortie tronquée, clé de wrapper et nom de modèle incorrects) sans écriture produit ni écrasement de reçu. Aucun Cargo/build/runtime, ancien probe, décodeur, REA, client/serveur original, rendu, audio ou réseau exécuté.

**Hérité V660, non rejoué :** quatre cas Map10 Braum/Garen niveaux 1/18 avec Annie18 alliée et ennemie ; 13 coups chacun, soit **52 impacts/huit quartets au total** : 26 impacts/quatre quartets dans les deux cas Braum et autant dans les deux contrôles Garen. Les 16 coups alliés négatifs se partagent huit/huit. Chaque quartet propriétaire+trois alliés dure 110 ticks, moins que 120 ticks à 30Hz ; cette opportunité diagnostique locale ne garantit pas la durée native quatre secondes. Seuls dégâts physiques après armure/régénération observés, sans stun ni bonus magique passif. Dix apports XP serveur et douze trajets publics sans réémission sont diagnostiques, sans injection directe d’état.

Les **92 refus publics +28 API**, 14809 ticks et BUILD/RUN 0 sont historiques. L’égalité des 28 fichiers courants ne prouve pas fraîchement la compilation de l’ancien exécutable. Les quatre API **40 dégâts magiques bruts** suivent 40×100/(100+RM) ; les quatre stuns diagnostiques **60 ticks** bloquent les actions à 0/59, expirent à 60. Chaque famille comprend deux cas Braum et deux Garen ; ces contrôles distincts ne valent ni f1/f2/f5 ni proc Braum. Attendre 121 ticks sans marque/proc établi ne valide ni expiration ni immunité. Les refus Braum n’exercent pas Q. Les cinq branches de refus courantes sont lues, jamais invoquées ici : leur description ne prouve pas une nouvelle absence de mutation.

## 5. Écarts, limites et indéterminations

Restent ouverts : producteurs/valeurs/rangs f1/f2/f3/f5 ; marques par cible/propriétaire, ordre, rafraîchissement/cumul, alliés/multi-Braum, catégories de cibles, Q, bonus et disponibilité après immunité ; mitigation/boucliers, dissipation/ténacité, kill/mort/disparition/changement d’équipe ; serveur original et disponibilité historique. Les références anciennes et tooltip absent ne sont pas normalisés. Réplication, sauvegarde, HUD, animations, VFX et audio restent distincts. Les voies génériques présentes et l’absence bornée de producteur qualifié ne prouvent ni absence globale ni corruption d’assets.

## 6. Corrections réutilisées et critères de fin

Trois IDs existants, propositions documentaires ; aucune création, modification d’état ou action fonctionnelle.

| ID | Objectif et fin |
|---|---|
| CH-Braum-PASSIF-SOURCE | Fiche versionnée des 26 identités/textes/aliases, champs absents et exceptions. Décider la disponibilité historique sur preuve attribuable. Une indétermination documentée clôt cet audit borné sans satisfaire automatiquement SOURCE. |
| CH-Braum-PASSIF-SIMULATION-CONTRAT | Qualifier autorité primaire, f1/f2/f3/f5 et toutes branches marque/propriétaire/alliés/Q/cible/ordre/timing/cumul/immunité/bonus/cycle de vie ; préciser limites et refus. Aucun défaut tiré du DDF ancien ou des règles Kennen/Leona. |
| CH-Braum-PASSIF-SIMULATION | Après contrat qualifié, relier le chemin ordinaire autoritaire Braum/Q→marques→quatrième coup→dégâts/stun→immunité/bonus. Vérifier nominaux et bornes avant/à/après, alliés sans marque, multi-propriétaires, cibles/protections/mort/refus sans mutation ; API40/stun60/Garen/XP restent témoins distincts. |

IDENTITE et packages restent ouverts ; NETWORK/PRESENTATION/ACCEPTANCE gardent leur rôle. Aucune correction générale de hash, outil, données ou asset justifiée par ce lot.

## 7. Livrable et relecture de cohérence

Stage `E:/mapslol3v3/audit_sys01202_braum_passive_source_20261103`. `result.json` 31657 octets, SHA `d0055a3588779fa6ccc511a99d3b3360bc18414b539420ca88be1941645ae68a`, 15/15 ; `native_contract_review.json` 92614 octets, SHA `65c593c6ffe9730fd370b9abcdd4018db4e77bf4f98fd16bdf8698acb58c554e`, 13/13 ; `current_consumer_review.json` 227003 octets, SHA `83f1cbc5275997c655e2a5545fba95dd02207279d588a7f0820503343f09364e`. Collecteurs, journaux, notes et pins stricts accompagnent ces reçus. Préparation courante et preuves initiales conservées.

Publisher préparé en E, **jamais importé/exécuté par le worker**, réservé à root après relecture. Il garde rapport/CURRENT/HANDOFF seulement, refuse dérive/doublon/pin D:, vérifie les sept protégés et pins documentaires/code/cache/extracteur. `typed_pin` et `verify_pin` sont identiques à Brand V1187 ; son reçu de garde est réemployé par pin/digests, sans rejouer les cinq contrôles ni créer un nouvel audit. Un reçu de publication séparé établira les identités avant/après.

Mesure : **1 audit borné clos /1 unité examinée, 0 SOURCE/0 inconnue/0 fonctionnalité close**. Sous-contrôles/pins/cache ne sont pas des audits supplémentaires ; comparaison hebdomadaire indisponible. Delta V1182 : les **six candidats initiaux sont désormais relus bornément**, matrice historique inchangée, zéro SOURCE complète close. Prochaine étape : consolidation de couverture à partir des deltas réutilisés, avec préflight explicite avant choix d’un grand lot ; aucun septième candidat arbitraire.

Reprise root `E:/mapslol3v3/resume_sys01202_20261103_v1187.txt`, main/`8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, modifications préexistantes conservées. Reprise mécanique seulement sur source/callsite primaire attribuable, nouvelle observation qualifiée, dérive nommée ou autorisation runtime ciblée ; aucun replay identique automatique.
