# SYS-01.2-02 — Varus : Living Vengeance et consommateurs VFX, V1416

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-VARUS-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Varus-PASSIF-PRESENTATION-VFX`, `OLF-3f386cfa-abac-539a-b9d6-57ec6ea3e21d` : relier marqueur, variantes Display/Minion, dépendances et consommateurs actuels. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues conservés dans initial_scope.json. Source V646 et HUD V1289 réutilisés ; QWER complet, politique historique, réseau et présentation complète restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Source `reference_requirement_trace_sources/varus-passive-living-vengeance-links-v645.json`, 3632759 octets, SHA `7b58b9f3cd911657a1a0ed8d08631a35ebe31535fe8965a423d43ba09c738e54`. Suffixe v645 erroné hérité conservé ; schéma/lot V646, distinct d’Urgot. UTC documentaire 2026-10-26T23:32:13.857244+00:00. Captures E réutilisées, aucun accès D/F/OpenLeague-work renouvelé.

Quinze ressources primaires : quatre INIBIN, cinq Lua, quatre preloads, DDF, font ; 94 autres identités non promues. Cinq chunks directs parmi 48 vues Lua, sans prototype enfant : 17 initialisations complètes littérales, 31 limites NEWTABLE, 83 globals. Trois préfixes PC0..17 qualifiés antérieurement ajoutent 27 globals séparés ; tables finales/skins non interprétées, aucun callback exécuté.

Varus.inibin3179 déclare VarusPassiveBuff/VarusPassive.dds ; Passive1Desc mentionne Ashe/critique, anomalie conservée. Passive1 et six champs de niveau non résolus. CharScript56 vide ; Tracker301 déclare VarusQ/slot1, contexte Q.

Les préfixes du marqueur430 et des Display478/DisplayMinion484 sont distincts. Marqueur : 12.dds, persistant/non dissipable. Les deux Display partagent BuffName=VarusPassiveBuffDisplay et VarusPassive.dds, mais déclarent respectivement VarusPassive.troy et VarusPassiveMinion.troy. Leurs flags PersistsThroughDeath ne qualifient pas la vie du bonus temporaire. Sept autres vues complètes portent treize champs AutoBuff contextuels, dont Slow et chaînes Q ; aucune recette globale déduite.

Font2853 : champion tué/assisté → @f2@ % AS pendant six secondes ; sbire/monstre tué → @f1@ % pendant trois secondes. **f1/f2 restent inconnus.** Display2854 contient SourceName ; clé Minion absente sans réécriture d’alias. Nom4475/description4299 conservés. DDF Q totalAD1/1.6 et E bonusAD.6, champs Disintegrate/Ziggs des SpellData et ancien texte Ashe ne définissent pas le bonus. Miroir font vérifié par identité, sans nouveau parcours sémantique.

Quatre identités preload, 1170 octets : Char274, marqueur306, Display327/SHA `bd9325d4d9d6d6bfb15ebd91bbd3f4565f13a3f5c9ac0a43e0c27826a66d8aab`, Minion263/SHA `29e3634f5f22f91ef8bed16fd7bca8fd9127d721b5e87a90e9013554af779962`. Rôles hérités : dépendances passif/Tracker/idle, arc lumineux et arc rouge ; texte brut et références typées non présents dans les copies sélectionnées, donc inconnus. Préchargement et effet déclaré ne prouvent pas création/attache/horloge.

Deux DDS partagés relus dans E,64×64 : 12.dds2176/DXT1/mip brut0/SHA `79c8851830454fcbe613ed846e2e16d6e83c4f9c0a706f1df86e67499ef915fb` ; VarusPassive5616/DXT5/sept mips/SHA `19ea4cec1cf03bc6a67047fad0ade5d2bed8cb7f6c4fbd688e2549acb93cf963`. Membership25/91 du projet0.0.1.7 hérité. Aucun payload Troy/Ziggs/Q relu ; provider,skin et pixels non qualifiés. Source StatsJSON communautaire distincte de l’INIBIN.

## 3. Consommateurs réels

Onze fichiers actuels, dix Rust et un lecteur Python ; 23 ancres concordantes. Dix sources/frontières,32 contextes,14 entrées VFX communes,deux liens d’animation ordinaire et font inchangés.

damage.rs:97/136 enregistre contribution et récompense de mort ; champion_kills.rs:26–50 calcule kill/assist ; world.rs:372–401 conserve le récepteur Trundle. progression.rs:119–127 compose croissance,objets,Trundle W,Ezreal et Exhaust. Aucun producteur Varus nommé dans dix préfixes Rust inspectés ; recherche client antérieure réutilisée après garde des identités, conclusion bornée.

Owner/projection/chargement,widget Ezreal et animations ordinaires ne prouvent pas le déclenchement des deux variantes.

## 4. Attendu, observé et contrôles

Attendu : conserver déclarations, établir producteur ou manque borné et reprise. Observé : deux variantes déclarées, activation/état/rendu spécifiques non établis.

34/34 contrôles documentaires qualifiés,54/54 de cohérence séparée du même agent. HUD225/225 et152/152 hérités. Huit paires PV avant/après relues et soustractions vérifiées : huit morts cohérentes avec Outcome, L1/L18 × champion kill/assist,monstre,sbire. API diagnostique à distance des positions de naissance ; aucune attaque ordinaire,portée ou acquisition qualifiée.

Cinquante-six échantillons postévénement : périodes calculées46 ticks L1/30 L18, sans bonus aux0/89/90/91/179/180/181 ; aucune cadence de tirs successifs mesurée. Ni f1/f2 ni expiration native déduits. Témoin Trundle W appris/lancé publiquement : stat45→38→45,bonus local20 %,samples0/239/240/241,distinct de Varus. 146 refus avec flags, sans toutes les paires individuelles ; quatre apports XP diagnostiques, aucune progression naturelle complète.

Ancien RUN1062750 et dépendances non relus ; binaire6073856/SHA `23c414eca110dc7f790b20d9a0121f7cf5159043e9ee0db1a1a59e3739103b72` inerte. Ancien bootstrap échoué/reprise Urgot vérifiés sans réexécution.

Collecteur actuel33/34 conservé : une attente attribuait25689 ticks aux seuls cas Varus. Qualification corrige uniquement ce prédicat :25448 pour les huit cas +241 témoin =25689 ; autres33 checks et fenêtres identiques. evidence_review_corrected.json fait autorité. Six productions réussies et cet échec conservés ; une erreur contextuelle de clé state/status consignée. Aucun nouveau build,jeu,REA,GPU,réseau/audio/rendu.

## 5. Écarts et inconnues

f1/f2,classification/assistance/pets,refresh/cumul/overlap,lifecycle,audiences,recette/owner/attache,skin/provider et pixels restent ouverts. **Le rendu des deux variantes reste non qualifié.** Flags persistants,préchargements et témoin Trundle ne remplacent pas un bonus Varus produit. Aucune revue indépendante/humaine ni inventaire secondaire complet qualifié.

## 6. Corrections et reprise

corrections_and_restart.json conserve quatre clauses : POLICY-01 qualifie événements/bonus/variantes ; KILL-STATE-01 relie état et son consommateur avec dépendance ATTACK-SPEED-01 ; NETWORK qualifie transitions/audiences ; VFX relie chaque variante au rendu. HUD-BINDINGS-01 existant préservé. Préconditions,fins et reprises précises, sans attendre tout QWER.

Reprendre sur source/capture/callsite nouveau ou dérive ; implémentation sous autorisation distincte. next_lot.json vise Vayne : chercher ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_varus_passive_vfx_20261106` : projections,fenêtres,paires létales,qualification,corrections et journaux. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF, sauvegardes exactes et sept registres protégés.

Une unité de liaison close ; zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés. SYS-01.2-02 reste actif.
