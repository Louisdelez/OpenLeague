# Wukong — Peau de pierre : sources, consommateurs et écarts

## 1. Exigence et portée

2026-11-05,V1377 ; `AUD-SYS-01.2-02-MONKEYKING-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-MonkeyKing-PASSIF-PRESENTATION-VFX` ; `OLF-3faafd00-faa1-596b-bf14-6ebc86ffb867`. Audit de liaison borné terminé. Défenses et dégâts génériques partiels acquis,producteur Peau de pierre non établi dans les corps inspectés. Vérification documentaire fraîche,simulation locale historique réutilisée,acceptation humaine non demandée. Fonctionnalité,tâche VFX complète et goal ouverts. Contrat/prérequis/NETWORK conservés dans initial_scope.json.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/monkeyking-passive-stone-skin-links-v603.json`,1638923octets,SHA `6f664a92eef3bc0b451a932b915788fcfe56fa73f613d700fad9f723e562c98c`,copie E identique. LoL4.20.0.315/EUW/en_GB,catalogue4.20.1 distinct.64identités,27Lua,17initialisations/46affectations,dix limites NEWTABLE non corruption. Cinq Lua56 vides ne prouvent aucune absence d’animation. Source native et métadonnées du HUD corrigé identiques.

MonkeyKingPassive227 déclare Cassiopeia_PetrifyingGaze.dds/MonkeyKingPassive/persistence/NonDispellable ; définition personnage MonkeyKingStoneSkin.dds distincte. DeathParticle118 porte deux flags,non politique d’aura. Deux clones citent AkaliShadowDance,les impacts Q Wolfman_SeverArmor : noms littéraux,non adoption de mécanique étrangère. Cinq champs AutoBuff vides appartiennent à SpinToWinLeave R ; aucun AutoBuff qualifié du passif,non absence globale.

Six tooltips résolus ;2303 décrit armure/MR augmentées de@f1@ par champion ennemi proche,description4234 concordante. Montant,niveaux,rayon et éligibilité inconnus. Rang et valeurs sélectionnées du Passive INIBIN null,non zéro.18métadonnées de sorts,16DDF QWER dont R attackdamage1.2,non formule du passif.24références communautaires secondaires,CharScript inspecté vide,23fichiers NightmareBot exclus,six absences de candidats bornées.

16preloads3548octets/42noms : CharScript lie apbonusdamagetotowers/passive/deathparticle ; Qhit lie passive ; DeathParticle lie death/remove-rocks. Clones,E,Q/R,audio et noms xenziou restent contextes distincts. Dépendance non création,attache ou recette Peau de pierre. Deux DDS2176octets/64×64/DXT1/mip1,membre40,contenu identique : propre Info et partagé Spells. Réutilisation Vi exacte conservée ; candidat Cassiopeia repéré sous HUD étranger dans l’ancien manifeste,sans ouverture. Lookup/provider/alias,pixels et GPU ouverts,non ressource globalement manquante.

Trois captures E914978/1183257/4492481 vérifiées.20payloads historiques nonEXE conservés,anciens chemins F-work et D inertes. HUD V1298 corrigé134/134 et cohérence127/127 historiques. Projection279686octets liée au reçu original10349396octets,conserve tous les champs hors liste checks ; originale et correction intactes. Aucun nouveau décodeur,lecture native,font ou analyse des1158dépendances.

## 3. Consommateurs réels

17Rust complets,37ancres dans evidence_review.json,racine `F:/OpenLeague/`. Points : `crates/core/src/progression.rs:68,101,106,164`, `damage.rs:53,91`, `penetration.rs:9`, `vision.rs`, `attacks.rs:157,539`, `annie.rs:45,73,87`, `ally_occupancy.rs:526`, `crates/client/src/projected_live.rs:168`.

stats compose base/croissance/objets/bonus génériques ; dégâts passent par défenses,pénétration et mitigation. Source d’un compteur d’ennemis ou bonus Wukong non établie. Vision/filtrage de snapshot ne définit pas le rayon d’aura. Sorts/rangs MonkeyKing refusés ; projected_live filtre Annie. Unique hit de nom dans les17Rust : attacks539 teste que l’alias wukong est refusé par supports_champion_presentation ; clé canonique MonkeyKing,non implémentation du passif.

31comparaisons sélectionnées recouvrent43fichiers F de contexte. Identité binaire historique séparée,hors ces43.14mécanismes communs et deux animations ordinaires concordent,non recette/rôle d’aura. Extraits et preuves réutilisés,sans recherche globale répétée.

## 4. Attendu et observé

Attendu : liens précis,provenance/acquis/refus préservés,écarts et reprise vérifiables. Observé :62/62contrôles documentaires,107/107cohérence séparée du même agent,non pair indépendant. Sept opérations documentaires : six exit0,collect01 exit1 initial conservé avec script/preuve/logs,puis corrigé pour classer le hit d’alias connu. Aucun code produit modifié.

V603 hérité,deux simulations Map10 à six joueurs : base/Cloth15+NullMagic25,armure24.88/39.88,MR32.10/57.10 constantes. Ennemis0/0/1/2/3/3/2/1/0,alliés0/2/2/2/2/2/2/2/2,rayon600 choisi par l’observateur. Six impacts physiques,deuxQAnnie,540ticks d’attente,54refus,28trajets/quatre reprises Stop/Move ; candidats de proximité effectivement exercés malgré les sorts refusés,aucun bonus Peau de pierre observé. Items témoins non montant natif d’aura.

Lectures V1298 héritées exactement,sans nouveau calcul :540statframes défenses/tick/flags,36snapshots de bornes ; positions/comptes non vérifiés à chaque tick. Six impacts sans paire PVpréimpact,54flags de refus sans paires brutes complètes. DeuxQ reconstruits depuis endpoints et12ticks de régénération/impact,non mesure PVadjacente archivée. Trois anciens BUILD0/RUN101 de setup et16diagnostics conservés ; succès final et Stop/Move ne réparent pas la navigation. BUILD/RUN final0/0 hérités des commandes sérialisées du probe ; OBSpassed non reçu de sortie brut d’inspection. Binaire6129664octets/SHAf9089daa… inerte,ancien dossier yasuo simple libellé. Aucun nouveau build,jeu,natifD,GPU,REA,probe ou réseau réel.

## 5. Écarts et inconnues

@f1@,niveaux,rayon,classes/visibilité/clones,compteur et composition des défenses ouverts. Persistence non politique mort/réapparition. Applicabilité VFX,provider/icône,recette,attache,rendu/audio et cycle de vie non qualifiés. Inconnues et consommateurs enregistrés conservés ; les données natives présentes ne sont pas une acceptation serveur ou graphique.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : nearby-enemy-selection-radius-and-aura-lifecycle ; native-f1-level-policy-and-authoritative-defense-composition ; StoneSkin-presentation-applicability-resource-binding-and-cleanup. Objectif,prérequis,critères et reprise précis,correction produit à autoriser séparément.

Prochain candidat `CH-Mordekaiser-PASSIF-PRESENTATION-VFX` dans next_lot.json,avec recherche d’audit existant. Ancienne formulation de succession évoquant un bouclier corrigée dans le périmètre de ce lot vers armure/MR,ancien fichier préservé. Reprendre sur preuve,événement,appel,dérive ou test précis nouveau,aucun gain chiffré revendiqué.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_monkeyking_passive_vfx_20261105/` : evidence_review.json,coherence_review.json,corrections_and_restart.json,journaux,result.json,reçus. Sept rubriques et publication vérifiées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2364 entrées sales conservées. Seuls nouveau rapport et ajouts CURRENT/HANDOFF après archives exactes. Goal,Plan/UI/bases,registres,produit et assets inchangés ; tâche complète,fonctionnalité,parent,jeu et acceptation ouverts.
