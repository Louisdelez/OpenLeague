# SYS-01.2-02 — Twisted Fate : Loaded Dice et consommateurs VFX, V1412

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-TWISTEDFATE-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-TwistedFate-PASSIF-PRESENTATION-VFX`, `OLF-4d3dc090-30a6-5e50-b88f-bda656a52855` : relier Second Sight/Loaded Dice, bonus/cumul et présentation aux sources et consommateurs réels. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues conservés dans initial_scope.json. HUD V1312 et ses corrections restent acquis. QWER, rendu complet et goal demeurent distincts.

Tryndamere V1330 est réutilisé après 42 gardes d’identité courantes, sans nouvelle clôture ni rapport doublon. Ses contrôles56/40 et anciennes préparations échouées restent hérités, sans rejeu.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. V643 : `reference_requirement_trace_sources/twistedfate-passive-loaded-dice-links-v643.json`, 2613515 octets, SHA `d62e957905bd415875adbeccbefde687cc6a0e84e69d1ac8dc9c8deebabfaee0`. Capture exacte de l’inspection et source de diagnostic conservées dans E ; aucun accès natif/F/OpenLeague-work renouvelé.

Sept ressources primaires : deux INIBIN, deux Lua, un preload, DDF et font. Douze vues Lua incluant les contextes voisins sont conservées : lecture complète, zéro prototype enfant, cinq initialisations littérales, sept limites NEWTABLE, 14 globals. SecondSight188 déclare texture Cardmaster_SealFate.dds, nom Second Sight et persistance ; CharScript56 vide. Ces métadonnées ne fournissent pas de callback de récompense.

CardmasterSlow déclare GLOBAL_SLOW.TROY ; CardmasterStack et ses icônes concernent E. Sept constantes UnderworldTwistedFate restent dans des initialisations non qualifiées. Aucune recette, attache ou sélection de skin de Loaded Dice n’en est déduite.

Alias INIBIN Second Sight, fichier SecondSight.luaobj et clé Second_Sight gardent leurs formes exactes. Passive1/six niveaux absents. Ancien Passive1Desc parlant de critique et textes localisés parlant d’or restent contradictoires. Le candidat SOURCE S5Test_DragonBuff demeure un lien de métadonnées non promu en alias/runtime ; son payload n’est pas relu.

Font2598/4293/4469 : bonus entre1 et6 après une unité tuée, cumul f1 et nom. Distribution uniforme, pondérations, RNG/seed et catégories/attribution non résolus. DDF20 lignes : seul PickACard;f1 lié à @special.twistedfatew/0.65, distinct du passif. Garde du miroir font sans reparcours sémantique.

CharScriptTwistedFate.preload :218 octets, SHA `533866aea329d62228dd4e83add5c512a8db12eb663679889f59fcb9758efda5`. Le rôle historique mentionne secondsight ; **les copies sélectionnées donnent identité/rôle, sans texte brut ni compteur de références typées reconstitué**. Nouvelle lecture conditionnée à une copie attribuable de cette identité.

Deux DDS HUD own/shared : chacun4224 octets,64×64 DXT5,compteur brut de mips0, même SHA `89fe52b4066189209d36f33cbc5b6dc3f235994482214827d6e62b2403995ee1`. Identités/headers relus dans E, membership conservé ; égalité sans priorité provider, texture d’effet ou pixels qualifiés. Provenance du porteur de ressource antérieure conservée.

## 3. Consommateurs réels

Douze fichiers actuels, dont dix Rust et deux lecteurs Python ;18 ancres vérifiées. Onze sources/frontières et31 contextes inchangés ;14 entrées communes VFX et deux liens d’animation ordinaire concordants.

world.rs:420–461 calcule gold+altar_bonus, résout combat_owner, crédite le portefeuille puis global_gold. champion_kills produit des récompenses/événements génériques killer_gold. passive_gold distribue le revenu ambiant ; altars fournit le bonus d’autel. Ces chemins restent distincts du tirage et du cumul Loaded Dice.

La recherche fraîche sur dix préfixes Rust de production n’a pas de liaison nommée ; résultat borné. Les anciennes recherches HUD sont réutilisées après garde des31 contextes. GoldStat=floor(player.gold) reste le portefeuille, pas f1. Projection/owner/ressources et animations ordinaires sont des acquis génériques, sans événement ni consommateur spécifique établi.

## 4. Attendu, observé et contrôles

Attendu : sources/contextes et chemin de récompense liés, manque visuel borné. Observé : ressources et crédit générique identifiés ; producteur du bonus/cumul et présentation spécialisée non établis.

30/30 contrôles documentaires,46/46 de cohérence séparée du même agent. HUD68/68 et64/64 hérités. V643 : deux diagnostics TwistedFate/Garen, six monstres chacun,3000 ticks chacun ; récompenses33/18/18/48/38/28, supplément zéro dans les douze éliminations. Vingt-deux refus API et leurs limites sont hérités. Résumés identiques aux reçus ; observations brutes et arithmétique non rejouées.

Ces diagnostics utilisent l’API serveur de dégâts. Attaques/sorts ordinaires, élimination de champion et admissibilité historique exacte des victimes ne sont pas qualifiés. Ancien probe216886/RUN complet et1158 entrées restent hors nouvelle lecture. Binaire5703168 octets, SHA `01335653fd65a24669d9748b9cfbfe5304a7ac2d4b024e5c4aecd729f96e8b1b`, identité inerte.

Une hypothèse de clé d’ancre erronée lors du repérage est consignée dans root_context_note.json ; schéma descriptor.path ensuite utilisé. Aucun producteur actuel échoué. Aucun nouveau build, test Rust, jeu, décodage natif, REA, réseau, audio ou rendu.

## 5. Écarts et inconnues

Restent ouverts : RNG/distribution, f1, attribution/catégories/ordre, contradiction critique/or, alias candidat, lifecycle, transport, recette/ressources/variantes et pixels. **Présentation propre au passif et présence éventuelle d’un effet dédié inconnues.** Les icônes et le portefeuille ne suffisent pas ; aucun effet de W/E ou texte flottant fictif n’est substitué.

Vérification statique et preuves historiques limitées ; aucune revue indépendante/humaine ni qualification complète de l’inventaire secondaire.

## 6. Corrections et reprise

corrections_and_restart.json définit quatre clauses : POLICY-01 qualifie politique/applicabilité visuelle ; REWARD-STATE-01 produit bonus et cumul distincts ; NETWORK relie les données attribuables ; VFX relie la présentation réellement attendue au consommateur. Prérequis, fins et conditions de reprise explicites. TARGET-CREDIT, ALIAS/TEXT, ICON-PROVIDER et HUD-BINDINGS existants sont référencés sans duplication.

Reprendre sur source/capture/callsite nouveau ou dérive. Implémentation soumise à autorisation distincte. next_lot.json vise Twitch : chercher ses audits existants avant nouvelle acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_twistedfate_passive_vfx_20261106` : projections, fenêtres, identités, corrections et journaux. Réutilisation Tryndamere rattachée au paquet. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF, avec sauvegardes exactes et sept registres protégés.

Une unité de liaison close ; zéro tâche VFX, fonctionnalité, inconnue, acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés. SYS-01.2-02 reste actif.
