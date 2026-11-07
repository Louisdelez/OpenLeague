# SYS-01.2-02 — Olaf : sources et consommateurs VFX du passif, V1386

5 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-OLAF-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit de liaison documentaire terminé sur ce périmètre. Fonctionnalité, vérification du jeu et acceptation humaine restent ouvertes.

## 1. Exigence et frontières

`CH-Olaf-PASSIF-PRESENTATION-VFX`, `OLF-e0f2dcb3-3255-5917-8dc5-613917e30d77` : identifier les effets applicables au passif et leurs consommateurs réels. Contrat a_faire, implémentation et acceptation false ; dépendance NETWORK. Inconnue VFX `OLU-98382ac9-68c5-5baa-919a-ab11c5faff17` et SOURCE `OLU-a571fcb0-c6c9-55aa-bd9d-98ffa99559c9` conservées, ainsi que six consommateurs enregistrés. Phase/prérequis hérités examinés ; satisfaction non revendiquée. Le parent et SYS-01.2-02 restent ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau et déploiement inconnus. Catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/olaf-passive-berserker-rage-links-v612.json`, 2200260octets, SHA `c1c2c898946f8ad1fae1ce42f82bdbe25ef342f2ccd620abc6030f4808d2fa21`. Son UTC2026-10-26T12:21:42.104731+00:00 date le document, pas une exécution.

44 identités natives ; 20Lua, neuf initialisations littérales, douze globals, onze limites NEWTABLE. Chunks consommés et zéro prototype enfant selon les reçus ; cela ne qualifie pas un serveur original. `OlafBerzerkerRage.luaobj`214octets fournit exactement Olaf_Passive.dds/BuffName/PersistsThroughDeath/NonDispellable. CharScript56octets est vide. Deux RagnarokPassiveBuff90octets identiques à des chemins distincts concernent R ; priorité inconnue. Zéro champ AutoBuff reconnu ne démontre aucune absence globale d’effets.

Texte natif ligne2426 et description4247 :1%AS par1%PVmanquants. Ordre, cumul, caps et recalcul inconnus ; DDF W health×0,01 n’est pas la politique du passif. Les références communautaires Q/E/R déjà divergentes restent exclues comme preuve serveur.

Neuf preloads2938octets, 36 références typées :23particules,12sorts,un personnage. Texte retenu dans discovery749198octets/SHA155a91da8e74a5c6cb63f3c685ec5a79451ab429e85b958a14bb23913c8207be ; reconstruction CRLF exacte pour neuf identités. CharScript précharge quatre sorts, dont olafberzerkerrage et olafragnarokpassivebuff, sans déclaration de particule dans ces quatre entrées. Effets QWER/skins conservés comme contexte ; aucun alias Berserker ni recette du passif inventés.

DDS E relu :2176octets,64×64DXT1,mip brut0, SHA `b8dfa22f817f1a656f899f305f95cd9454885ece4f0f781861f11f61efa556b4`, membre0.0.0.174 du projet0.0.1.7 hérité. En-tête et identité ne prouvent ni lookup, variante ou pixels. Provenance Mana :source_sha98587894… correspond au JSON communautaire4675octets ; natif INIBIN1753octets/SHAe12249c9… distinct.

## 3. Consommateurs actuels

16 fichiers inspectés, dont14Rust et deux lecteurs Python ; 30 ancres SOURCE/frontières relues. Identités des15 fichiers antérieurs et29 fichiers de contexte inchangées. Recherche nominative sans hit dans ces14Rust, sans prétention d’absence globale.

`progression.rs:119` calcule la cadence depuis base/croissance/objets/Trundle/Ezreal/Exhaust, puis arrondi et minimum12. Aucun terme PV/Olaf dans cette expression. `attacks.rs:284` consomme cette statistique pour cadence, windup et next_attack. Le minimum générique12 n’est pas une règle native acceptée.

Quatorze mécanismes communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité. Ce lien ordinaire ne prouve aucune recette BerzerkerRage, registration, clip ou création d’effet. Le consommateur client projeté est générique ; aucun raccord Olaf n’est établi dans le périmètre inspecté.

## 4. Attendu et observé

Attendu :politique native de variation selon PV et présentation applicable réellement consommées. Hérité V612/HUDV1256 :deux cas niveau1, base/Dague1042+15%AS, AD59,98/PVmax597,24 ;18attaques, six impacts entrants, deux QAnnie,54refus,240ticks de récupération et quatre trajets aboutis.

Pleine vie, blessure et récupération :douze intervalles restent43ticks sans objet et37avec Dague, malgré26–29%PVmanquants. Le déclencheur est exercé ; le contrôle Dague fonctionne, le bonus du passif manque dans le calcul et les attaques observées. Aucun sort Olaf accepté, mais cela n’empêche pas l’exercice du déclencheur passif. Aucune cadence native exacte n’est inventée sans ordre de calcul qualifié.

Actuel :32/32 contrôles documentaires et52/52 de cohérence séparée par le même agent. Ratios/mesures antérieurs réutilisés, sans nouveau calcul runtime. Trois JSON historiques et deux reçus bruts BUILD/RUN0 relus. Binaire6125568octets/SHA9e7434ea544e5041a38e59b0558be76ab3c978c9e7d47346127f0de1b3fc166d conservé comme identité inerte, jamais ouvert.

Les contrôles HUD65/65 et cohérence qualifiée52/52 sont hérités ; ancien51/52 et correction du prédicat conservés. Une inspection de métadonnées actuelle a échoué sur KeyError0 (mapping pris pour liste), puis été corrigée sans modification de fichier. Retour transcrit, pas de faux journal brut. Six opérations journalisées actuelles exit0. Aucun build/jeu/natif/REA/GPU/réseau nouveau.

## 5. Écarts et limites

Recette applicable, producteur, attache, ressource/variante et pixels non qualifiés. Cumul/caps/arrondis/recalcul, extrêmes de PV, niveaux, W/soins/PVmax, windup, boucliers, dégâts simultanés, mort/respawn et transport ouverts. Mesures limitées au niveau1 et à une cible ; anciens manques de paires pré-impact, snapshots de refus et garde NPC conservés. V564 et échecs Nami hérités restent distincts. Aucun audit de rendu complet clos.

## 6. Corrections et reprise

`corrections_and_restart.json` définit quatre clauses sur IDs existants :SOURCE pour qualifier l’applicabilité/recette ; SIMULATION pour la cadence réellement consommée ; NETWORK pour état et transitions ; PRESENTATION-VFX pour raccord et rendu. Chaque clause porte objectif, prérequis, critères de fin et entrée de reprise. Préserver le contrôle Dague. Reprendre sur preuve native/capture précise, dérive ou autorisation distincte d’implémenter ; aucune correction fonctionnelle exécutée ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_olaf_passive_vfx_20261105`, evidence_review/coherence_review, journaux, gardes d’identité, corrections et `next_lot.json` (Orianna, ligne de couverture vérifiée). Sept rubriques relues ; une unité de liaison bornée close, zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept documents protégés contrôlés avant/après. Goal/Plan/UI/bases/registres/produit conservés. La relecture du même agent ne vaut pas revue indépendante.
