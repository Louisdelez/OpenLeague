# Ahri — Essence Theft : sources VFX et consommateurs actuels

6 novembre 2026 · V1435 · AUD-SYS-01.2-02-AHRI-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence et périmètre

CH-Ahri-PASSIF-PRESENTATION-VFX, OLF-c94c246e-fa3d-598e-b8c7-b57a85d5d73d. Relier les effets de lancement, trajet et impact applicables à leurs sources, états et consommateurs, ou constater une lacune délimitée. D06 et prérequis hérités ; CH-Ahri-PASSIF-NETWORK reste requis. Le statut a_faire et les indicateurs d’implémentation/acceptation sont conservés.

Audit de liaison documentaire terminé ; fonctionnalité non terminée ; vérification statique et preuves historiques héritées ; acceptation humaine non donnée. Les audits généraux SOURCE/ACCEPTANCE et HUD existants ne sont pas clôturés à nouveau. Le goal complet SYS-01.2-02 reste ouvert.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus ; catalogue 4.20.1 distinct. Le reçu V556 conservé fait 583539 octets, SHA 0ff0997c993affb449699c63822b3678d941d85ddcd3a62c6e084e823b5b3bcb. Son identité F concorde avec la copie figée ; ses 18 memberships sont hérités, sans ouverture des chemins natifs D.

Huit vues Lua littérales, 38 globals, aucun prototype enfant : métadonnées client sans callback serveur démontré. AhriPassive157 déclare un marqueur persistant/non dissipable. PassiveParticle272 porte SoulCrusher et SoulEater, mais les chaînes effet et os sont vides. SoulCrusher186 porte le même nom/icône. Counter194 déclare SoulCrusherCounter et SoulEater2 : liaison déclarative établie, condition de sélection inconnue.

SoulCrusher2/3/4, chacun405 octets et même contenu, déclarent Egitai et trois effets de potions. SoulCrusher5 conserve cinq chaînes vides. Les 14 champs AutoBuff comprennent cinq vides et neuf références aux potions ; ni rangs, ni activation réelle, ni absence universelle d’effet déduits. PersistsThroughDeath ne suffit pas à établir la vie d’un effet de scène.

Quatre preloads identifiés, 97/159/93/92 octets, total441 : contenu et dépendances typées non présents dans les reçus sélectionnés. Leurs identités ne sont pas une recette. Deux DDS SoulEater distincts, 2176 octets, 64×64 DXT1 : en-têtes et membership hérités du HUD, sans nouvelle lecture des pixels. Textes1660/4150 : trois charges maximum par sort, neuf charges ; Counter1664 dit neuf sorts. Formulations distinctes, f1/f2 non résolus. Anciens textes critique allié/Attack Rate et champs absents non adoptés comme règles.

## 3. Consommateurs et acquis

19 fichiers courants lus, dont18 Rust ; 18 ancres V556 retrouvées. Le producteur générique de soin, la régénération, les attaques et Pyromania existent ; aucun n’est qualifié comme producteur d’Essence Theft. Les corps de next_rank, cast et cast_at conservent les refus Ahri. Les structures d’état et le HUD QWER/Ezreal examinés n’établissent aucun trajet spécifique à ce passif.

Recherche des noms AhriPassive/SoulEater/SoulCrusher/Essence Theft dans les préfixes de production de ces18 Rust : zéro hit, sans conclusion d’absence globale. Le HUD conserve ses six empreintes. Les acquis partagés Akali V1315 sont réutilisés : registre spatial alimenté par observations/bounds du caller, propriétaire arrêtant huit handles, classes de particules et autres résolveurs ne créent pas automatiquement un passif Ahri. Les deux chemins d’animation ordinaire ne prouvent pas ses VFX.

35 comparaisons d’identité sur32 fichiers concordent : 14 éléments partagés, deux animations, six SHA HUD, douze contextes V556 et le texte en_GB. Contrôle en streaming, distinct des lectures sémantiques et sans garantie OS/TOCTOU.

## 4. Attendu, observé et vérifications

Attendu : source → état/déclencheur → ressource → attache/temps → rendu, ou manque précis. Observé : déclarations attribuables et briques génériques présentes ; chaîne spécifique non établie dans les routes inspectées. **35/35 contrôles documentaires et102/102 de cohérence séparée du même agent.**

V556 hérité : deux cas Ahri/Annie, huit attaques entrantes,60 ticks observés,24 refus publics. Aucun sort Ahri accepté ; AnnieW/Pyromania et régénération ne prouvent ni charges ni soin Ahri. Ces résumés sont relus, sans rouvrir les observations brutes, recalculer l’arithmétique ou rejouer le runtime. L’ancien EXE6017024/SHA475e9e8d et ses1158 dépendances restent des identités inertes.

Cinq productions Python journalisées réussissent. Recherche complémentaire dans AUDIT_*.md hors AUDIT_SYS01202*.md : rg1, aucun candidat, cas nominal borné. Les erreurs root de découverte et du premier dispatch Git sont conservées dans root_context/inspection ; préparation reprise avec observation Git autorisée, sans remplacement d’un lot rempli. L’empaquetage initial distingue insuffisamment cinq tentatives de cache common.pyc absent : chacune est suivie de la lecture retenue de common.py. Le script initial, le rapport avant supplément et la qualification sont conservés ;108 lectures effectives et un dispatch rg restent distincts de ces tentatives. Aucun journal modifié, aucun échec de producteur. Aucun build, jeu, natif, REA, GPU, installation ou migration exécuté.

## 5. Écarts et inconnues

Conditions d’emploi des variantes et chaînes vides, contenu des preloads, applicabilité lancement/trajet/impact, recette, f1/f2, charges/consommation, owner/attache, temporalité, mort, skins, réseau et rendu restent ouverts. Aucune ressource déclarée manquante ou corrompue sur ces seules observations. Les inconnues VFX OLU-9de75f19 et SOURCE OLU-1e5aecf0 restent conservées. COR-PASSIF-VFX-SECONDARY-BUFF-COVERAGE-01 reste ouverte ; inventaire secondaire complet non qualifié.

## 6. Corrections et reprise

corrections_and_restart.json décrit quatre objectifs indépendants : politique/variantes/preloads, producteur réel de charges/soin, état réseau et intégration VFX. Réutilisation des tâches SOURCE, SIMULATION, NETWORK et PRESENTATION-VFX ; aucun ajout au registre. Chaque fiche précise prérequis, fin et reprise. Le premier cas demande un vrai sort qualifié, sans exiger tout le kit.

Reprendre seulement sur source/capture/callsite nouveau, dérive ou autorisation d’implémentation distincte. next_lot_resolved.json sélectionne Alistar, avec schéma lu dans son reçu figé ; next_lot.json conserve l’instruction initiale de consultation. Aucun audit Alistar réalisé ici.

## 7. Livrables et décision

Preuves E:/mapslol3v3/audit_sys01202_ahri_passive_vfx_20261106 : scope, inspection, evidence_review, coherence_review, identity_verification, corrections, reprise et journaux. Sept rubriques relues ; contrôle du même agent, sans revue indépendante ou acceptation humaine. Seul ce lien borné est clôturable, pas SOURCE complète, tâche VFX, passif, champion ou jeu.

Publication limitée au rapport et ajouts CURRENT/HANDOFF avec sauvegardes exactes ; sept registres protégés. Git main8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca,13556 entrées avec --untracked-files=all, non comparables aux anciens comptes de dossiers groupés. Travail existant conservé ; goal, Plan/UI, bases, code et assets inchangés.
