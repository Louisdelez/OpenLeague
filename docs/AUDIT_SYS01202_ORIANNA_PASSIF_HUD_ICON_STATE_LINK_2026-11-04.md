# SYS-01.2-02 — Orianna : Clockwork Windup et HUD, V1257

4 novembre 2026. Unité `AUD-SYS-01.2-02-ORIANNA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre ; implémentation, vérification du gameplay et acceptation humaine restent distinctes.

## 1. Exigence et périmètre

`CH-Orianna-PASSIF-PRESENTATION-HUD`, `OLF-a0ef572a-d82b-53fb-af14-655473a86a3a` : relier icône, texte, rang applicable, dégâts magiques et charges à leurs consommateurs actuels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-e43c2341-6bf5-5aff-88f0-fd84d34bba08` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et leurs inconnues conservés. Phase D06/lot D06-CH-Orianna/prérequis consultés, sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/orianna-passive-clockwork-windup-links-v613.json`,2546156 octets,SHA `017a0515b08f881a83e8aa0dbceabef6201ac1d7ebaafff7ee52838c76bc6f65`,UTC documentaire 2026-10-26T12:40:53.037475+00:00,sans attribution à une heure d’exécution.

HUD :une définition/un catalogue. SOURCE :70 relations/67 identités,six sites/trois fichiers. V613 :67 sources/201 associations,24 sites/48 liens/13 fichiers. Union :15 fichiers/30 ancres. Aucun ID SOURCE supplémentaire. Métadonnées natives réutilisées sans réouverture D.

Orianna et OriannaNoBall lient exactement `OrianaSpellSword` (un seul n) et OriannaPassive.dds. Passive1/description/six niveaux absents, sans zéro inventé. SpellSword2440 décrit f2+f1%AP en bonus magique,puis20% supplémentaires sur la même cible dans4s,jusqu’à deux cumuls ; f3 affiche le bonus. f1/f2/f3/progression restent inconnus. SpellData50/20,coefficient0 et CastRange162,100006 ne sont pas substitués à ces variables ou à la portée d’attaque.

Le BuffTextureName de SpellSword/PowerDagger est OriannaPowerDagger.dds, distinct de l’icône de définition. BuffName,IsDeathRecapSource,PersistsThroughDeath et NonDispellable sont des métadonnées, pas des callbacks ou une acceptation du rendu/recap/respawn.

26 Lua :21 littéraux/cinq limites NEWTABLE ;19 preloads,sept BuffData exactement résolus. Deux CharScripts natifs vides56octets/SHA égaux ; communautaire vide. Preload principal :orianaspellsword/orianaghostself ; NoBall :yomuspellsword/yomughostself/yomushockorb. Aucune réécriture ni recherche mondiale Yomu dans ce lot. Régénérations statiques1,2/1,568 et croissance0,16/0,1 conservées ; priorité/transition NoBall et Balle non qualifiées. Six candidats absents,dont DDF sélectionné,sans manque global ni corruption déduits.

25 références communautaires non adoptées :Q cône depuis propriétaire65+0,4AP contre60+0,5AP natif,QCommand825 ; W/R targetPos ne qualifient pas une Balle ; E bouclier sans trajet qualifié ; R Airborne0,75s ne prouve pas une attraction. Ni serveur original ni consommateurs Rust. Les métadonnées croisées d’autres champions ne deviennent pas leurs mécaniques.

Trois DDS nécessaires,6528octets/deux contenus,2176octets chacun,64×64 DXT1,mip brut0 :

| Icône et chemins | Identité |
|---|---|
| OriannaPassive.dds :Characters/Orianna/Info et Spells/Icons2D | membres0.0.0.40/0.0.0.33 ; SHAc27c19047f3192b4147e935ce94409b5c349a289e05bdcd910c278e7e423bccd |
| OriannaPowerDagger.dds :Spells/Icons2D | membre0.0.0.33 ; SHA54215cddcb3c4b6fc657b3f1e95aea817cdc4c73c829a78285f59c5248373692 |

Taille/MD5 concordent au manifeste lol_game_client0.0.1.7 ; inventaire E avant trois lectures SOURCE. Lookup/variante/pixels ouverts,mip0 non déclaré corrompu. Font miroir identique au témoin Ahri. Mana courant,PARType natif absent ; source_sha256 correspond au JSON communautaire7146octets,distinct de l’INIBIN natif2388octets/SHA834ecd01cad4d6fc56bbf4430aec139f7f6d6bb8b7fbeb51d67b5897711d4ac0 (`resource_provenance.json`).

## 3. Consommateurs actuels

30 ancres exactes,16 entrées communes et29 fichiers code/configuration vérifiés. Recherche Orianna/Oriana/Clockwork sans hit dans ces Rust,sans absence globale revendiquée. Catalogue,stats/objetsAP,commandes,projectiles,dégâts,régénération,cibles et snapshots inspectés.

`attacks.rs:157–173` transmet le projectile libéré à basic_attack_hit ; `lifesteal.rs:4–29` applique les dégâts physiques génériques. Aucun producteur Clockwork/magique/charges identifié dans ces routes. Death recap reste un contexte générique, sans acceptation du flag natif. HUD Mana/MPStat/PV et module Ezreal ne démontrent pas l’icône sélectionnée,les états0/1/2 ou f3 affiché.

## 4. Attendu et observé

Attendu :bonus magique natif,progression des charges sur même cible,consommation/rafraîchissement/expiration et HUD attribuable. Hérité V613 :deux cas base/Tome1052+20AP,AD40,368 dans les deux. Quatorze impacts,sept projectiles distincts par partie,54refus,242ticks d’attente,quatre trajets aboutis sans reprise. Aucun dégât entrant ni sort Orianna accepté ; Balle non exercée.

Chaque cas :quatre impacts1971/2017/2063/2109,121ticks d’attente,puis trois2246/2292/2338. Dix intervalles internes recalculés46ticks,deux écarts entre séries137ticks. Un seul couple source/cible par partie ; identifiants de projectile uniques dans chaque partie, sans unicité mondiale revendiquée.

Attendu physique générique33,8600921631 ; observé33,8600769043 pour les14coups,écart<0,002 après correction de régénération du témoin historique. Même résultat avec0/20AP et attaques répétées :aucun ajout magique/cumul observé. Les attaques exercent le candidat du passif malgré QWER refusés. f1/f2/f3 inconnus empêchent un déficit historique chiffré.

121ticks/écart137 ne qualifient pas l’expiration d’un cumul absent. Attentes PV/attendus recontrôlées ; dégâts cible sans paire pré-impact adjacente,refus avec flags sans snapshots bruts avant/après. Aucune garde universelle NPC qualifiée.

Historique :15fichiers/10005727octets,13ancienshashes concordants/deux identités nouvelles. Binaire6064128octets,SHA `518a65c4f3e56a5c1f776bd52a71e0cce264b76ea31bed1aa1a1a2b49e53fdfb`,inerte ; BUILD/RUN bruts0. Inspection hachée héritée,code numérique non requalifié ici. Contrôles actuels51/51,cohérence séparée48/48 par le même agent. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Bonus magique,charges/expiration et HUD non établis. f1/f2/f3/progression,ordre des impacts,cibles/propriétaires,rafraîchissement/changement de cible,résistances/boucliers/immunités,on-hit,annulations/mort/respawn ouverts. NoBall/Yomu,Balle/retour/distance,QWER,lookup/provenance Mana et réseau non qualifiés. Tests limités au niveau1,0/20AP,une cible. Limites V564 et deux échecs Nami conservés.

## 6. Corrections et reprise

Réutiliser `CH-Orianna-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-ORIANNA-CLOCKWORK-POLICY-01` :résoudre f1/f2/f3/progression,ordre et identité source/cible. Fin :mappings/callsites4.20 démontrés,sans reprise arbitraire de50/20/coefficient0.

`COR-ORIANNA-CLOCKWORK-ONHIT-HUD-01` :intégrer bonus/charges au vrai impact et au HUD. Fin :états0/1/2,plafond,rafraîchissement,avant/à/après4s,alternance cible/multiowner,AP/niveaux,mitigation/interruptions/mort/respawn/recap et transport vérifiés. Balle/NoBall restent des clauses distinctes à qualifier. Reprendre sur preuve nouvelle,dérive ou autorisation d’implémenter ; aucun correctif fonctionnel réalisé ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_orianna_passive_hud_20261104` ; evidence_review/coherence_review,DDS/histoire,`resource_provenance.json`,`phase_package_prerequisites.json`,journaux. Identités conservées avant assertions ; hook7/7 réutilisé. Sélection unique avant lecture,captures explicites F/OpenLeague-work ; limites Python/bootstrap/contexte/inventaire final/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement,deux sauvegardes,sept protégés contrôlés avant/après. Une unité d’audit bornée close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif ; goal/Plan/UI/bases/registres/produit inchangés.
