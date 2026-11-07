# Nidalee — Prowl / Hunt : sources, consommateurs et écarts

## 1. Exigence et portée

Date UTC2026-11-05, V1383 ; `AUD-SYS-01.2-02-NIDALEE-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Nidalee-PASSIF-PRESENTATION-VFX` ; `OLF-a2305b47-920c-577e-ab6c-54ee488af9de`. Audit de liaison borné terminé. Mouvement/vision génériques présents ; bonus Prowl et producteurs Hunt/Cougar non qualifiés. Vérification documentaire fraîche, simulations héritées, acceptation humaine non demandée. Fonctionnalité, tâche VFX complète et goal ouverts. Contrat et dépendance NETWORK conservés.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/nidalee-passive-prowl-links-v609.json`, 2829257octets, SHA `053eb62e2c4193a62375d6b2c71eb4fb46931c623c36ea875bcab542565e0936` ; copie E identique. LoL4.20.0.315/EUW/en_GB, catalogue4.20.1 distinct.72sources :33INIBIN/23Lua/14preloads/DDF/font. HUD V1253 :64/64documentaires,49/49cohérence historiques réutilisés.

23Lua :12initialisations/41globals/11limites NEWTABLE. Deux CharScripts56 vides. Hunt177 déclare Prowl/Nidalee_Passive/persistence ; Hunting193 persistence ; Hunted231 attacheC_BUFFBONE_GLB_HEAD_LOC seule. BrushPassive277 effet nidalee_base_p.troy et Prowl277 effet Nidalee_Base_P.troy sur BUFFBONE_GLB_GROUND_LOC : casse préservée. Scent285 global_Watched.troy/head distinct. Onze champs AutoBuff au total, dont contexte Takedown mainsR/L, non recette universelle du passif.

Textes :10%/2s en buisson,30% vers champion ennemi visible à5500 ; Hunt4s après JavelinToss/Bushwhack, vision et avantages Cougar. Buff2351 inclut Swipe renforcé, description4240 et SpellData citent seulement Takedown/Pounce. CastRange brut«5900.0000» distinct du texte5500. Conditions/direction/portée et divergence Swipe ouvertes. Onze tooltips : neuf résolus, BrushPassive et Bushwhack non résolus sans alias. Anciennes descriptions critique alliée/AttackRate10/15/20% et32DDF vides non règles adoptées.

Cougar partage nom/description/icône, LuaName absent non preuve de passif absent. Quatre noms d’attaques à deux chemins : chaque paire de contenu identique reste deux identités, priorité runtime non qualifiée.27métadonnées de sorts et33références communautaires secondaires : Qprojectile commenté/noHunted,W=Pounce non piège humain,Rbuff999999 non conversion complète. Cinq absences candidates bornées, aucun manque global d’assets établi.

Découverte1009244octets/SHA0b284e6b… disponible :14preloads/4313octets natifs/56références. Texte normaliséLF, reconstructionCRLF conforme aux14tailles/SHA hérités. Aucun accès natif frais ni recette Troy complète qualifiée. Deux DDS distincts2176octets/64×64/DXT1/mip0/membre237, non lookup/pixels/rendu.

Quinze captures,13pinnées historiquement/deux ultérieures ;14payloads nonEXE relus, binaire inerte. Ressource actuelle source_sha09fce980… du JSON communautaire6704octets, distinct de l’INIBIN natif2410/SHA20ccd43d… ; caveat conservé.

## 3. Consommateurs réels

13Rust complets,37ancres dans evidence_review.json sous `F:/OpenLeague/`. movement applique définition+objets, modificateurs génériques/slows/softcaps, sans état Prowl identifié. ally_occupancy utilise vitesse/TICK_RATE et collision/planification. vision lit drapeaux de buisson, ligne de vue, sources alliées et projection ; révélation Ignite existante non Hunt. Sorts/rangs Nidalee refusés, projected_live filtre Annie. Aucun nom Nidalee/Prowl/Hunted/Hunting/Cougar trouvé dans ces13corps, absence bornée.

14comparaisons sélectionnées recouvrent28fichiers F contextuels ; binaire séparé, inerte.14mécanismes communs/deux animations ordinaires concordants, non preuve de forme/clip/passif.

## 4. Attendu et observé

Attendu : liens précis, acquis/limites et reprise vérifiables. Observé :75/75contrôles documentaires,187/187cohérence séparée du même agent, non pair indépendant ; six opérations documentaires exit0.

V609 hérité : deux cas publics base/Bottes25, vitesse constante335/360. Huit trajets mesurés aboutis,280pas/272pleine vitesse,158échantillons buisson dont76vers ennemi visible et82en éloignement ;54refus,244ticks d’attente, deuxQAnnie, quatre déplacements de préparation distincts. Déclencheur buisson exercé, bonus Prowl non observé. Les refus des sorts ne suffisent pas à expliquer cet écart.

Mathématiques mouvement/direction V1253 héritées sans recalcul :280paires de positions, drapeaux avant/après et visibilité courante enregistrés ; direction de l’observateur non politique native d’angle/portée. Pas ordinaires vitesse/30, tolérance0.003 héritée, non ordre natif des caps. Navigation distingue HAS_GRASS et praticabilité ; l’octet exporté open n’est pas la condition de marche du consommateur décrit.

Hunt et transformation Cougar non exercés. QAnnie ne remplace pas un contact JavelinToss/Bushwhack. Sans bonus actif initial, attendre ne qualifie pas son expiration2s. Attentes sauvegardent vitesse/flagsregen sansPV bruts par tick ; préimpact adjacentQ et paires brutes de refus absents, NPC non universellement exclus.

BUILD/RUN0/0 bruts hérités ; OBSpassed non reçu terminal d’inspection. Binaire6060544octets/SHAb0bf5b69… inerte, ancien dossier yasuo simple libellé. Aucun nouveau build/jeu/natif/GPU/REA/probe ;1158dépendances non rejouées.

## 5. Écarts et inconnues

Prowl activation/rafraîchissement/cumul, direction/visibilité/portée, Hunt4s/audience et consommation des avantages Cougar restent ouverts.5500/5900 et Swipe conservés contradictoires, sans résolution inventée. Forme/lookup/priorité des paires, applicabilité/recette/attache, rendu/audio et acceptation ouverts. Huit trajets réussis ne ferment ni V564 ni les échecs V606. Inconnues et consommateurs enregistrés conservés.

## 6. Corrections et reprise

Cinq clauses de la tâche existante dans corrections_and_restart.json : buisson10%/2s ; direction/visibilité/portée30% ; Hunt/contact/vision4s ; Cougar/consommation/conflitSwipe ; présentation/provenance/nettoyage. Objectifs, prérequis, critères et reprise précis. Correction produit distincte à autoriser.

Prochain `CH-Nocturne-PASSIF-PRESENTATION-VFX` dans next_lot.json, après recherche d’audit équivalent. Réutiliser les preuves inchangées ; nouvelle investigation sur entrée ou question précise seulement. Aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_nidalee_passive_vfx_20261105/` : evidence_review.json, coherence_review.json, corrections_and_restart.json, journaux, result.json et reçus. Sept rubriques et publication vérifiées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`, 2370 entrées sales conservées. Seuls nouveau rapport et ajouts CURRENT/HANDOFF après archives exactes. Goal/Plan/UI/bases/registres/produit/assets inchangés ; tâche complète, fonctionnalité, parent et jeu ouverts.
