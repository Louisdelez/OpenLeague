# Anivia — Rebirth : sources VFX et consommateurs actuels

6 novembre 2026 · V1438 · AUD-SYS-01.2-02-ANIVIA-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence et périmètre

CH-Anivia-PASSIF-PRESENTATION-VFX, OLF-a27784cf-bd9a-5852-8e52-649b56ff64a2. Relier les effets applicables de lancement, trajet et impact aux sources, états et consommateurs réels, ou préciser le manque. D06 et prérequis hérités ; CH-Anivia-PASSIF-NETWORK reste requis. Statut a_faire, implémentation et acceptation conservés.

Audit documentaire de liaison terminé ; fonctionnalité non terminée ; vérification statique et résumés historiques hérités ; acceptation humaine non donnée. SOURCE V1183 et HUD V1198 ne sont pas clôturés à nouveau. Ce lot ne termine ni Rebirth, ni Anivia, ni SYS-01.2-02.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. V558 fait607016 octets, SHA1a503ec0ee8993e16913ebf752815607a83d19b1fab9de337912c42bafb888f8. L’identité F concorde avec la copie figée. Dix-huit memberships natifs hérités, aucun chemin D rouvert.

Sept vues Lua entièrement consommées par le lecteur antérieur, sans prototype enfant : six initialisations littérales et36globals reconnus ; Rebirth408 conserve NEWTABLEpc16 non interprété, sans être déclaré corrompu. Ses constantes SpellFXOverrideSkins/AniviaEggBlackIce ne fournissent pas le mapping de variantes. CharScript56 est vide. Marker218 déclare Rebirth Marker/Base ; Ready258 déclare Base et priorité8, sans callback exécuté. AnimationPlay/Reset/Cooldown394 ont le même contenu, Charging et BuffName RebirthCooldown ; leurs noms ne prouvent aucune animation jouée. Aucun AutoBuff reconnu dans ces vues, sans conclure à l’absence historique de VFX.

Passive1/description/niveaux Anivia absents restent absents ; AniviaEgg1/4/7 ne fournit pas ses rangs. Texte2516 : létal→œuf/pleinPV/f1 armure-MR, survie6s, recharge4min ; politiques effectives inconnues. Les six lignes2515–2518/4156/4332 sont conservées, malgré le nom historique selected_four_strings. Egg et ses textes restent distincts. La provenance086d du miroir communautaire, distincte du natif7ed, identifiée par V1183, n’est pas recherchée à nouveau.

Quatre preloads475/570/89/84, total1218 octets : identités seules, contenu/recette typée non disponibles dans les reçus sélectionnés. Six DDS4224octets/64×64 DXT5 : cinq copies Base même SHA7db581b4,mip0 ; une Charging SHA430c2239,mip1. Les cinq chemins Base incluent AniviaEgg/SwainBeam/SwainRaven ; aucun transfert de mécanique ou priorité déduit. Memberships hérités, sans nouvelle lecture des pixels ni sélection runtime.

## 3. Consommateurs réels

19 Rust courants inspectés,20 ancres V558 retrouvées. apply_damage met HP à zéro, réinitialise les effets et programme base_death_ticks. advance_respawns attend respawn_at, choisit une position depuis les spawns et l’occupation alliée, restaure les pools puis efface le délai. C’est le chemin ordinaire, pas un producteur Rebirth ou une transformation sur place qualifiés. Les gardes mort/apprentissage/cast sont conservées avec fenêtres exactes.

Les acquis partagés sont réutilisés : owner arrêtant huit handles existants, registre spatial alimenté par observations du caller, classes/résolveurs, animations ordinaires. Les descripteurs AniviaEgg et noms de clips du HUD existant ne créent pas une entité ou une bascule de forme. HUD QWER/Ezreal et RespawnTimer ordinaire restent distincts de l’œuf et de sa recharge.

46 comparaisons sur41 fichiers concordent :14 éléments partagés, deux animations,16 contextes HUD, treize contextes V558 et le texte en_GB. Identité en streaming seulement. Recherche Rebirth/AniviaEgg/Cryophoenix_Rebirth dans les préfixes de production des19 Rust : zéro hit. Conclusion bornée, sans exclure tout alias ou chargement dynamique ailleurs.

## 4. Attendu, observé et contrôles

Attendu : source → état prêt/létal/œuf/renaissance → ressource/forme → owner/attache/temps → rendu, ou lacune précise. Observé : déclarations et briques ordinaires identifiées, chaîne spécifique non établie. **31/31 contrôles documentaires,111/111 de cohérence séparée du même agent.** HUD hérité :35 source,20 consommateur,18 intégration,16 postpublication, non rejoués.

V558 hérité : Anivia meurt1321, point6s1501, retour fontaine1801 ; Ahri1356/1536/1836. Les23 attaques entrantes,960ticks observés et32refus restent des observations historiques, sans relecture des snapshots bruts ni nouveau calcul flottant. Le retour ordinaire480ticks/16s et479ticks morts avant retour ne prouvent ni œuf6s ni recharge4min. Aucun passif natif activé qualifié. Ancien EXE6078464/SHA05d5af32 et1158 dépendances inertes.

Cinq productions Python journalisées réussies, aucun échec de producteur ou de préparation dans ce lot. Les recherches optionnelles de common.pyc absent sont distinguées des lectures retenues de common.py ; aucun bytecode créé. Recherche complémentaire AUDIT_*.md hors AUDIT_SYS01202*.md : rg1, zéro candidat, résultat nominal borné. Aucun build, jeu, natif, REA, GPU, installation ou migration exécuté.

## 5. Écarts et inconnues

Disponibilité initiale, f1/défenses/ordre, horloges6s/4min, œuf détruit/survivant, identité/forme, recette/variantes/skins, owner/attache/arrêt, audiences/réseau et rendu restent ouverts. Persistance, priorité8, noms AnimationPlay et respawn fontaine ne les résolvent pas. Identifiants VFX/SOURCE intégralement conservés dans evidence_review. COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 reste ouverte ; inventaire secondaire et applicabilité exhaustive non qualifiés. Aucun asset déclaré corrompu ou absent.

## 6. Corrections et reprise

corrections_and_restart.json sépare quatre objectifs : politique prêt/œuf/variantes/recette, producteur létal→œuf→survie/destruction, réseau/identité/forme, intégration VFX. Réutiliser SOURCE, SIMULATION, NETWORK et PRESENTATION-VFX ; aucun ajout au registre. Chaque fiche précise prérequis, fin et reprise.

Reprendre sur source/capture/callsite nouveau ou dérive, avec autorisation distincte pour implémenter. Ne pas rejouer960ticks ordinaires, les décodeurs ou la recherche de provenance déjà résolue. next_lot.json sélectionne Brand, schéma exact lu dans son reçu figé ; aucun audit Brand réalisé ici.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_anivia_passive_vfx_20261106 : scope, inspection, evidence_review, coherence_review, identités, corrections, reprise et journaux. Sept rubriques relues ; même agent, sans revue indépendante ou acceptation humaine nouvelle. Seul l’audit de liaison borné est clôturable.

Publication limitée au rapport et ajouts CURRENT/HANDOFF avec sauvegardes exactes ; sept registres protégés. Main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,2424 entrées groupées conservées. Goal, Plan/UI, bases, code, assets et statuts inchangés.
