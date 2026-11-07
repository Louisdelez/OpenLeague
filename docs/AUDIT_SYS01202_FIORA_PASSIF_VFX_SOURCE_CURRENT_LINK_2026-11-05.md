# Fiora — sources et consommateurs des VFX de Duelist

2026-11-05 · V1341 · AUD-SYS-01.2-02-FIORA-PASSIF-VFX-SOURCE-CURRENT-LINK-01

## 1. Exigence, périmètre et fin

SYS-01.2-02 ; CH-Fiora-PASSIF-PRESENTATION-VFX, OLF-5c3166fb-9770-57f8-98d4-eee97b530736. Relier déclarations et consommateurs courants ; distinguer déclencheurs, régénération, soin, cumuls/durée, variantes Hot, QWER, HUD et effets du passif. Contrat lancement/trajet/impact applicable, dépendance CH-Fiora-PASSIF-NETWORK et prérequis D06/lot conservés sans satisfaction implicite.

Fin : sources identifiées, déclarations qualifiées, chemins réels ou manque borné, contrôles et corrections précis. Après publication vérifiée, seul ce lien documentaire est clos. Inventaire, mécanique complète, tâche VFX et acceptation restent ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Reçu V662 retenu par V1322 :2846777 octets, SHA072515317cf632a1b1da6b27d9c19c336222edaeebe9a9ee80d56d2e6097b6e9. Source et ancien evidence_review_corrected V1309 restent externes E après vérification bytes/SHA ; cadrage107303 octets sans incorporation des documents complets, hook inchangé, accélération non mesurée.

Inspection V662 déjà capturée E :1337650 octets, SHAc08876726b6fae79081b037dd66b4cf8031fe14d44ba2ef7ce850692e980e95a. Métadonnées concordantes avec le reçu et V1309 ;21 identités natives conservées, dont quatre preloads. Leurs corps complets/références de particules ne sont pas inspectés ici ; aucun fichier déclaré absent, aucune recette inventée à partir de leurs noms.

Vingt-huit Lua entièrement lus structurellement, sans prototype enfant ni exécution serveur :22 initialisations littérales qualifiées/115 affectations, six vides ; six limites NEWTABLE conservées aux PC0/0/0/6/6/14. Ces limites ne prouvent pas une corruption ou l’absence d’effets.

CharScript56 vide ; Duelist210 déclare icône/nom/persistance/non-dissipation. Trois variantes Hot489 identiques, SHA4c9fb5f9f0865cdd8d9006b9b6e5dec535a8e5019d336101dcc66356783dd368 : cinq champs AutoBuff vides aux PC9/11/13/15/17 chacun. Huit contextes AutoBuff/36 champs au total ; Flurry AS/MS, QCD/Weapon et Riposte/Weapon/Sword_b/CENTER sont des contextes QWER, sans transfert au passif. Run90 déclare seulement PersistsThroughDeath ; aucune politique serveur ou pose exécutée déduite.

Définition FioraDuelist/Fiora_Duelist.dds ; Passive1/Desc et six niveaux nuls sans defaults. Quatre textes en_GB hérités :4362/4186/1899/1900. Le buff précise dégâts physiques, @f1@ sur6 secondes, quatre cumuls contre champions ; description du personnage moins précise. f1, cadence et renouvellement restent inconnus. DDF8 lignes/deux remplies :Q×0,6 et Dance×1,2 bonusAD, sans formule de soin. Aucun passif moderne de points vitaux importé. Recherche communautaire bornée sans définition Duelist, sans absence universelle.

Deux DDS Info/Spells hérités,5616 octets chacun, même SHA f519d5977c3b0dce8bc7b1378a0536e14737e73d7c55cd9300fe8da5479320f9 :64×64 DXT5/mip7, membre0.0.0.79 du projet0.0.1.7. Headers/membership hérités ; provider, priorité, sélection, pixels et rendu ouverts.

## 3. Consommateurs actuels

Neuf Rust relus : core attacks.rs, lifesteal.rs, damage.rs, regeneration.rs, healing.rs, lib.rs, world.rs, spells.rs ; client projected_live.rs. Vingt-deux ancres exactes. Trente identités antérieures concordantes incluent18 comparaisons V662 ;14 identités communes VFX et deux animations ordinaires concordent également, sans nouveau census.

advance_attacks et basic_attack_hit conservent l’attaque ordinaire ; dégâts physiques puis vol de vie fondé sur post_mitigation et taux de stats, via heal. apply_damage conserve ses gardes et sa voie générique. regeneration_rates compose base/croissance/objets ; advance_regeneration ajoute le passif Garen, applique received_multiplier et plafonne les PV. Ce chemin réel ne constitue pas Duelist.

heal vérifie source/cible vivante, montant fini et plafond ; received_multiplier appelle Ignite/Trundle W, sans qualifier leur interaction native avec Duelist. Effects/advance/cast gardent les mécanismes existants ; cast refuse explicitement le chemin champion non implémenté. projected_live sélectionne Annie.

Recherche Fiora/Duelist nulle dans ces neuf textes complets, sans absence globale. Animation ordinaire V1336 réutilisée via V1340 et deux gardes, sans relecture sémantique, sélection de clip passif ou pixels. Six entrées QWER V1309 et HP/Mana conservés, sans binding Duelist substitué.

## 4. Attendu, observé et contrôles

Attendu : déclarations/frontières qualifiées et manque spécifique borné en conservant l’acquis. Observé :71/71 contrôles documentaires,85/85 cohérences séparées du même agent,22 ancres et gardes30/14/2 concordantes. V1309 corrigé55/55 et sa cohérence56/56 hérités, non rejoués.

V662 hérité :Fiora/Annie niveaux1/18,24 attaques et24 fenêtres181ticks sans supplément de soin, déficit PV conservé ;12 contrôles API physiques/magiques/vrais, quatre heal25 distincts de f1,20 préparations de blessure, six XP diagnostiques, huit trajets,12768 ticks ;60 refus publics/40API. Cinquième attaque sans activation ne valide pas cap4. Aucune nouvelle recalculation des fenêtres ou observation brute.

Binaire historique6116352 octets/SHA267c7eecac4910c920a86c86a002c66ef0af46578a87ef330530505dbc78d16c inerte, non relu/rejoué. Premier contrôle HUD54/55 corrigé sur six variantes QWER, conservé avec sa qualification ; pas défaut produit déduit.

Deux recherches de contexte ont échoué sur des noms de dossier/scripts supposés ; root_context_failure.json et root_context_scripts_failure.json les conservent. Dossier V1309 réel et inputs épinglés retrouvés. Six opérations documentaires journalisées réussies ; aucun nouveau build, jeu, natif D/stat/résolution, décodeur/VM, GPU, REA, réseau ou rendu.

## 5. Écarts et inconnues

Corps des preloads/recette et applicabilité, producteur f1, dégâts/cibles/crédit, cadence/arrondis, gain/renouvellement/cap/durée des cumuls, mort/dissipation/réapparition/reconnexion, owner/skin/audiences, pose/attache et rendu ouverts. Soin générique, vol de vie, régénération et QWER ne clôturent pas ces clauses ; mouvement et autres médias séparés.

Inconnues VFX/SOURCE, consommateurs inscrits et V1322 conservés exactement. Zéro tâche complète, feature, inconnue, acceptation ou goal clos ; aucun pourcentage du jeu ni garantie globale TOCTOU.

## 6. Corrections et reprise

Réutiliser CH-Fiora-PASSIF-PRESENTATION-VFX :duelist-visual-applicability-source, trigger-stack-heal-world-link, resource-attachment-render-lifecycle. Objectifs/prérequis/fins/reprises dans corrections_and_restart.json ; six tâches historiques et leurs critères restent distincts.

Reprendre sur copie attribuable de corps preload si nécessaire, nouvelle source/lecteur/appel/producteur/pose/capture ou dérive pertinente ; pas de recherche globale/replay inchangé. Prochain lot CH-Fizz-PASSIF-PRESENTATION-VFX via next_lot.json retenu.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_fiora_passive_vfx_20261105 :cadrage, inspections, gardes, evidence_review, coherence_review, erreurs de contexte et journaux. Sept rubriques examinées, relecture du même agent, sans acceptation indépendante/humaine.

Publication limitée au rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes ; sept registres protégés identiques. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2328 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
