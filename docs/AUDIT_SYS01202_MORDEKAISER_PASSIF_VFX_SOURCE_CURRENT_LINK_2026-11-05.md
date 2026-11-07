# Mordekaiser — Dur comme fer : sources, consommateurs et écarts

## 1. Exigence et portée

2026-11-05, V1378 ; `AUD-SYS-01.2-02-MORDEKAISER-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Mordekaiser-PASSIF-PRESENTATION-VFX` ; `OLF-e27d2023-4ec8-5601-bed1-b374187625da`. Audit de liaison borné terminé. Mécanismes génériques de bouclier présents ; génération et décroissance IronMan non établies dans les corps examinés. Vérification documentaire fraîche, simulation historique héritée, acceptation humaine non demandée. Fonctionnalité, tâche VFX complète et goal ouverts. Contrat, prérequis et dépendance NETWORK conservés dans initial_scope.json.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/mordekaiser-passive-iron-man-links-v604.json`, 1415184octets, SHA `d3ca325409ff2003c210c8bccb95b4fd277321306138d52daabf965691eeae7c` ; copie E identique. Référence LoL4.20.0.315/EUW/en_GB, catalogue4.20.1 distinct.57identités natives,24Lua,24initialisations/42affectations,zéro limite littérale. Douze Lua56 vides ne prouvent aucune absence d’animation. HUD V1248 source31/31 et cohérence42/42 historiques réutilisés.

IronMan194 déclare Mordekaiser_IronMan.dds/nom MordekaiserIronMan/persistence, sans NonDispellable ajouté. Aucun AutoBuff du passif qualifié. CreepingDeath W déclare un effet vide ; MaceOfSpades Q déclare mordakaiser_maceOfSpades_activate.troy sur BUFFBONE_CSTM_WEAPON_1, typo native préservée. COTG priorité10,ratio Guide0.5 et alias Malady/Nautilus,Viktor/InfernalGuardian,DarkChampion/FallenAngel restent contextes étrangers, non politique du passif.

Six tooltips résolus.2311 décrit conversion@f2@%, plafond@f1@PV, décroissance3%/seconde et conversion moitié contre sbires ; description4235 concordante. Montant,base,cadence et plancher ouverts. Champs sélectionnés IronMan INIBIN null,non zéro. PARTypeShield/BaseMP«120.0»/croissance0/régénération0 distinguent porteur de ressource et absorption. Ancien binding Jester non résolu et textes mana40/60/80% conservés,non progression de bouclier.17métadonnées de sorts,quatreDDF Q bonusAD1.65/1.0,23références communautaires secondaires,CharScript inspecté vide,six absences candidates bornées,zéro bot exclu.

Deux DDS identiques2176octets,64×64/DXT1/mipbrut0,membre25 : propre Info et Spells. Identité non priorité de lookup,rendu ou pixels. Treize preloads sont identifiés dans l’inspection qualifiée,3376octets ; contenu non qualifié ici. Le JSON de découverte attendu830679octets,SHA `e4c889f52a13778e05b22e6a5ae5796f8deaa90012d046f9ee37dccc9bd6d012`, manque aux13captures sélectionnées. Chemin historique E exact et blobs nommés par ce SHA dans le précédent dossier HUD : aucun candidat. Ancien F-work et D non consultés,aucune absence globale affirmée. Entrée de reprise exacte dans current_inspection.json et corrections_and_restart.json.

Captures qualifiée1076897/probe1252410 vérifiées ;13entrées historiques,11pinnées à l’origine/deux capturées ultérieurement,12payloads nonEXE relus. Binaire conservé comme identité inerte. Provenance de ressource inchangée : source_sha25640ff002b… désigne le JSON communautaire,non l’INIBIN natif69844e00… ; nature native du chemin textuel non présumée. Aucune réouverture native,font ou dépendances du build.

## 3. Consommateurs réels

17Rust complets,43ancres dans evidence_review.json, racine `F:/OpenLeague/` : `crates/core/src/shields.rs:12,33,41,44,47,52`, `damage.rs:53,101`, `lifecycle.rs:16,24`, `progression.rs:68,164`, `spells.rs:101,120`, `annie.rs:45,73,87`, `crates/client/src/projected_live.rs:168`.

grant_shield est une API d’événement autoritatif : remplace le tag,refuse les entrées invalides. advance_shields expire/nettoie ; absorb_shields consomme après mitigation,par expiration la plus proche,priorité native non qualifiée. lifecycle distingue Mana/Energy de Shield ; ce classement ne produit pas IronMan. Sorts/rangs Mordekaiser refusés,projected_live filtre Annie. Aucun hit Mordekaiser/IronMan dans les17Rust,absence bornée.18comparaisons sélectionnées recouvrent31fichiers F ; binaire historique séparé,hors31.14mécanismes communs/deux animations ordinaires concordent,non recette du bouclier.

## 4. Attendu et observé

Attendu : liens précis,provenance/acquis/refus préservés,écarts et reprise vérifiables. Observé :57/57contrôles documentaires,117/117cohérence séparée du même agent,non pair indépendant. Six opérations documentaires exit0. Lecture root initiale source_roles supposée liste corrigée vers mapping ; transcription conservée,aucune source modifiée.

V604 hérité : base et Ruby150/Sapphire200,PVmax555.4/705.4 ; porteur120/max120/régénération0 constants. Six attaques sortantes,six impacts physiques entrants,deuxQAnnie,244ticks d’attente,54refus,quatretrajets. Aucun sort Mordekaiser accepté : déclencheur de dégâts de compétence non exercé,aucun bouclier IronMan généré. Attaques ordinaires non substitut de ce déclencheur.

Contrôle séparé : grant diagnostique absorbant50 sur QAnnie ; autre bouclier80 avec expiration fixe30ticks observée31ticks,sept événements invalides refusés. Preuve d’API générique,non génération/plafond/décroissance IronMan. Lectures HUD héritées sans nouveau calcul :244frames d’attente sans PV/positions,24propriétaires aux bornes ; impacts sans paire PV immédiatement avant,refus fondés sur assertions sans paires brutes complètes. Attendre sans bouclier ne qualifie pas les3%. BUILD/RUN0 hérités,commandes JSON brutes sauvegardées relues ; OBSpassed non reçu terminal d’inspection. Binaire6107648octets/SHAf270d2f8… inerte,ancien dossier yasuo simple libellé. Aucun nouveau build,jeu,natifD,GPU,REA,probe ou réseau réel.

## 5. Écarts et inconnues

@f1@/@f2@,dégâts éligibles,base de conversion,plafond,croissance et décroissance,priorité et cycle de vie ouverts. Moitié sbires non règle universelle contre tous les non-champions. Ressource120 non montant absorbant. Contenu des préchargements,applicabilité VFX,lookup/attache/recette,rendu/audio et acceptation ouverts. Inconnues et consommateurs enregistrés conservés.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : eligible-ability-damage-and-native-shield-conversion ; native-capacity-three-percent-decay-and-shield-lifecycle ; IronMan-resource-binding-presentation-applicability-and-cleanup. Objectif,prérequis,critères et reprise explicites. Correction produit distincte à autoriser ; aucune formule ni réussite inventée pour l’entrée manquante.

Prochain candidat `CH-Morgana-PASSIF-PRESENTATION-VFX` dans next_lot.json,avec recherche préalable d’audit existant. Reprendre sur entrée nommée,source,événement,appel,dérive ou test précis nouveau ; aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_mordekaiser_passive_vfx_20261105/` : evidence_review.json,coherence_review.json,corrections_and_restart.json,journaux,result.json,reçus. Sept rubriques et publication vérifiées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2365 entrées sales conservées. Seuls nouveau rapport et ajouts CURRENT/HANDOFF après archives exactes. Goal,Plan/UI/bases,registres,produit et assets inchangés ; fonctionnalité,tâche complète,parent,jeu et acceptation ouverts.
