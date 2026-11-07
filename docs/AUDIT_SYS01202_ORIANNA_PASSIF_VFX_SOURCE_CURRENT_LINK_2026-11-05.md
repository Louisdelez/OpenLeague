# SYS-01.2-02 — Orianna : sources et consommateurs VFX du passif, V1387

Lot du 5 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-ORIANNA-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit de liaison documentaire terminé sur ce périmètre. Fonctionnalité, jeu vérifié et acceptation humaine restent ouverts.

## 1. Exigence et frontières

`CH-Orianna-PASSIF-PRESENTATION-VFX`, `OLF-64366437-0b24-5f4c-a1c7-8e55555d1323` : relier les effets applicables au passif à leurs consommateurs réels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; six consommateurs enregistrés conservés. Inconnue VFX `OLU-ca5d9c99-cdb6-5d64-81fe-792238854603` et SOURCE `OLU-27729935-bb95-5cc0-ac63-a728b5c8d686` ouvertes. Prérequis et phase hérités examinés sans satisfaction revendiquée. Parent et SYS-01.2-02 ouverts.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Source `reference_requirement_trace_sources/orianna-passive-clockwork-windup-links-v613.json`, 2546156 octets, SHA `017a0515b08f881a83e8aa0dbceabef6201ac1d7ebaafff7ee52838c76bc6f65`. UTC documentaire 2026-10-26T12:40:53.037475+00:00, sans heure d’exécution déduite.

67 identités natives ; 26 Lua, 21 initialisations littérales, 98 globals, cinq limites NEWTABLE ; zéro prototype enfant selon les reçus. Deux CharScripts vides de 56 octets ont les mêmes octets. Orianna/NoBall déclarent exactement `OrianaSpellSword`, avec un seul n. SpellSword356 lie OriannaPowerDagger.dds et les flags IsDeathRecapSource/PersistsThroughDeath/NonDispellable, sans callback prouvé.

Dix chunks portent 26 champs AutoBuff. PowerDagger/Display326 ont chacun quatre champs vides. Quatre effets non vides relèvent des contextes Haste, RedactShield, Slow et Stun ; les deux noms d’os de bouclier/stun conservent leur casse. Aucun ne devient automatiquement un effet du passif. Blanc ou zéro champ reconnu ne signifie pas absence native globale.

19 preloads, 6362 octets, 85 références typées :35 particules, 46 sorts, quatre personnages. Texte retenu dans discovery940848octets/SHAb6b272a6a1fd7aa834f7f597057d1f2129f6193d5461328a24f155fb1905d1fc ; reconstruction CRLF exacte des 19 identités. SpellSword543 précharge quatre vacuumindicator, root, PowerDagger et Display. Main précharge orianaspellsword/orianaghostself ; NoBall précharge yomuspellsword/yomughostself/yomushockorb. Aucun alias silencieux ou recette exécutée déduits.

Tooltip SpellSword2440 :f2+f1%AP magique, puis +20% sur la même cible dans quatre secondes, deux cumuls ; f3 affiché. f1/f2/f3 et progression restent inconnus. SpellData50/20, coefficient0 et CastRange162,100006 ne leur sont pas substitués. Métadonnées NoBall et communautaires déjà divergentes restent distinctes des règles natives.

Trois DDS E relus, chacun2176octets,64×64 DXT1,mip brut0 :deux OriannaPassive à deux chemins/SHA `c27c19047f3192b4147e935ce94409b5c349a289e05bdcd910c278e7e423bccd`, PowerDagger/SHA `54215cddcb3c4b6fc657b3f1e95aea817cdc4c73c829a78285f59c5248373692`. Membres0.0.0.40/0.0.0.33 hérités du projet0.0.1.7. Pas de lookup/variante/pixels qualifiés. Mana source_sha cdd399aa… correspond au JSON communautaire7146octets ; INIBIN natif2388octets/SHA834ecd01… distinct.

## 3. Consommateurs actuels

16 fichiers inspectés, dont14 Rust/deux lecteurs Python ; 30 ancres SOURCE/frontières vérifiées. 15 fichiers antérieurs et29 de contexte inchangés. Recherche nominative sans hit dans ces14 Rust, sans absence globale revendiquée.

`attacks.rs:157` conduit le projectile libéré à `basic_attack_hit`. `lifesteal.rs:4` applique les dégâts physiques génériques et le vol de vie d’objet. La branche magique de retaliation inverse source/cible ; elle n’est pas un producteur Clockwork identifié. Aucun bonus magique ni compteur Orianna retrouvé dans ces routes. Death recap conserve sa politique locale, sans qualification du flag natif.

Quatorze mécanismes communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité. Leur existence et le client projeté générique ne prouvent pas une recette passive, une registration, une sélection de clip ou des pixels.

## 4. Attendu et observé

Attendu :bonus magique/charges à l’impact et présentation applicable attribuable. Hérité V613/HUDV1257 :deux cas niveau1, base/Tome1052+20AP, AD40,368 ;14 impacts et14 projectiles identifiés dans leur partie,54 refus,242 ticks d’attente, quatre trajets aboutis. Aucun sort Orianna accepté, aucune mécanique de Balle exercée.

Chaque cas :quatre impacts1971/2017/2063/2109, puis trois2246/2292/2338. Dix intervalles internes de46ticks, deux écarts137ticks entre séries. Comparaison documentaire fraîche des ticks conservés, sans rejouer le moteur. Les14 dommages observés33,8600769043 restent proches du physique attendu33,8600921631, avec0/20AP et attaques répétées. Aucun bonus magique/cumul observé ; déclencheur d’attaque répété exercé malgré QWER refusés. Aucune perte native exacte chiffrée sans f1/f2/f3. L’écart137 ne prouve pas l’expiration d’un cumul absent.

Actuel :33/33 documentaires,56/56 cohérence par le même agent ; sept opérations journalisées, six succès et une première relecture échouée. Celle-ci supposait Function/Name sur une ligne ; OriannaEAllyRangeRingRender les sépare. Lecteur de contrôle corrigé, source inchangée ; script, logs et terminal initiaux conservés. Contrôles HUD51/51 et48/48 hérités.

Trois JSON et deux reçus bruts anciens BUILD/RUN0 relus. Binaire6064128octets/SHA518a65c4f3e56a5c1f776bd52a71e0cce264b76ea31bed1aa1a1a2b49e53fdfb inerte, jamais ouvert. Aucun nouveau build, jeu, natif, REA, GPU ou réseau.

## 5. Écarts et inconnues

Politique des dégâts, charges/expiration, recette, attache, owner/cible, clock et rendu non qualifiés. Balle/NoBall/Yomu, retour/distance, ordre/rafraîchissement, AP/niveaux, résistances/boucliers/immunités, on-hit, annulations et mort/respawn ouverts. Tests hérités limités au niveau1, une cible,0/20AP ; anciennes limites de pré-impact/refus/NPC, V564 et échecs Nami conservés. Pas de nouvelle acceptation du gameplay.

## 6. Corrections et reprise

`corrections_and_restart.json` définit cinq clauses sur les tâches existantes :formule native ; bonus/charges au vrai impact ; applicabilité Balle/NoBall ; état réseau et lifecycle ; raccord de présentation et ressources. Chacune possède objectif, prérequis, critères de fin et entrée de reprise. Conserver les contrôles physiques acquis. Reprendre sur une preuve native/capture précise, dérive ou autorisation distincte d’implémenter ; aucun correctif fonctionnel exécuté ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_orianna_passive_vfx_20261105`, evidence_review/coherence_review, journaux, gardes et échec préservé. `next_lot.json` cible Pantheon selon la couverture vérifiée. Sept rubriques relues ; une unité de liaison bornée close, zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept documents protégés contrôlés avant/après. Goal/Plan/UI/bases/registres/produit conservés. Relecture du même agent, sans revue indépendante.
