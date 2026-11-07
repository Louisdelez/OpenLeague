# Miss Fortune — Fanfaronne : sources, consommateurs et écarts

## 1. Exigence et portée

2026-11-05,V1376 ; `AUD-SYS-01.2-02-MISSFORTUNE-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-MissFortune-PASSIF-PRESENTATION-VFX` ; `OLF-f532c5a0-d422-5acd-af5c-cb1012ad9802`. Audit de liaison borné terminé. Fonctionnalité partielle : déplacement et dégâts génériques acquis, producteur Strut non établi dans les corps examinés. Vérification documentaire fraîche, simulation historique héritée, acceptation humaine non demandée. Tâche VFX complète et goal ouverts. Contrat/prérequis/NETWORK conservés dans initial_scope.json.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/missfortune-passive-strut-links-v602.json`,1405571octets,SHA `5b2dd4979d4a5411cf20b0651fc715c4ce691abb71046f8cefe5e047d6c6d4cb`,copie E identique. LoL4.20.0.315/EUW/en_GB,catalogue4.20.1 distinct.62identités natives,27Lua,18initialisations/45affectations ; neuf limites NEWTABLE non corruption. Sept Lua56 vides,non absence d’animations. Audit HUD source42/42,consommateurs16/16 hérité.

Strut190 utilise normale/nom MissFortuneStrut/persistence ; Debuff200 utilise grise/nom « Miss Fortune Strut Cooldown »/NonDispellable ; Stacks162 utilise normale/nom MissFortuneStrutStacks,sans flags ajoutés. MissFortunePassive230/PassiveStack169 sont W ImpureShots,non Strut ; leur recap/icône ne définit pas une source de dégâts du passif de vitesse. IsPirateHunter207 conserve Nondispellable avec sa casse. Unique AutoBuff qualifié : GLOBAL_SLOW.TROY de E,non recette Strut. Draw a Bead est un alias littéral,non politique Tristana ; rangs et description legacy null restent indéterminés.

Description4233 :5s sans être attaquée,puis+25vitesse,+8chaque seconde,cap70. Tooltips2291 « hit in combat » et2287 « taken damage » conservés séparément ; neuf requêtes résolues pour huit clés uniques,dont Strut répétée. Sept chaînes HUD héritées.19métadonnées de sorts ; champs sélectionnés de Strut INIBIN null,non paramètres zéro.12lignes DDF QWER,dont R bonusAD0.35,non formule Strut.25références communautaires secondaires,CharScript inspecté vide,six candidats absents bornés,zéro contexte bot exclu ; aucune absence globale d’assets.

13preloads3406octets/42noms projetés depuis la découverte E conservée. Strut lie Debuff/Stacks,missfortune_base_p_buff.troy/root ; Debuff lie lui-même/Strut. W/Q/E/R et personnages testcube/spellbook1 restent contextes distincts. Dépendance non recette/callback/création. Trois DDS2176octets/64×64/DXT1/mip1 : normale personnage et normale sort identiques,membres239/25 ; grise différente,membre79. Aucun lookup,pixel ou GPU qualifié.

Trois captures E868931/1082209/2127945 vérifiées. Ancien reçu18entrées :13pins historiques et cinq identités capturées ultérieurement sans pin historique ; ne pas les requalifier comme identités historiques. Les17payloads nonEXE relus,EXE inerte. Schéma source HUD initial utilise historical_capture.records ; champs de préloads helper,manifest initial,dates et caveat absents,non inventés. Données et sources de provenance exactes conservées,aucun accès D ou ancien stockage F-work.

## 3. Consommateurs réels

13Rust complets,35ancres dans evidence_review.json,racine `F:/OpenLeague/`. Points : `crates/core/src/movement.rs:19,38,46,53,55`, `ally_occupancy.rs:526,635,677`, `spells.rs:101,120`, `progression.rs:150,164`, `annie.rs:45,73,87`, `damage.rs:53`, `crates/client/src/projected_live.rs:168`.

movement_speed combine définition/Bottes puis modificateurs génériques et caps reconstruits ; ally_occupancy utilise ce résultat pour le budget par tick. Le fit_step courant est identifié,ancien écart V564 conservé ouvert. Annie Q prépare/lance puis applique de vrais dégâts magiques. Sorts/rangs Miss Fortune refusés ; aucun producteur Strut établi. projected_live filtre Annie. Recherche sans hit MissFortune/Strut bornée à13Rust,non absence globale.

27comparaisons sélectionnées,104contextuelles fraîches+une identité EXE inerte parmi105 ; ensembles recouvrants,non131consommateurs.14mécanismes communs et deux animations ordinaires concordent,non effet/rôle Strut. Extraits et mécanismes réutilisés,aucun gros registre redécodé ou REA répété.

## 4. Attendu et observé

Attendu : liens vérifiables,provenance/acquis/refus préservés,écarts et reprise précis. Observé :73/73contrôles documentaires,122/122cohérence séparée du même agent,non pair indépendant. Sept opérations documentaires : six exit0 et documentation01 exit1 initial,car le successeur supposé était erroné. Ordre figé corrigé vers MonkeyKing avant tout livrable ; script et logs conservés dans documentation_failure_preserved.json. Trois incidents root de lecture/affichage transcrits et conservés : cp1252,champ de préloads absent,list traitée initialement comme mapping ; schémas corrigés sans toucher aux sources.

V602 hérité : base/Bottes325/350vitesse,mana275.8399963cap,1324ticks d’attente,deuxQAnnie acceptés raw80/coût60,huit trajets/216pas/208pleinevitesse,54refus. Mouvement et dégâts reçus exercent les candidats malgré les sorts propres refusés. Aucun bonus Strut observé ; sans bonus initial,reset non qualifié.

Tableaux HUD hérités exactement,sans nouveau calcul : quatre fenêtres331frames,84lectures de bornes,34snapshots complets/20ticks uniques. Positions de marche et vitesses sauvegardées ; PV par tick d’attente/marche absents,paire PV immédiatement avant impact absente. Endpoint PV+régénération conditionnel aux assertions du script,non mesure adjacente indépendante. Paires brutes de refus et mana immédiatement après cast absentes. Gardes trajet distinctes des attentes ; NPC non exclus universellement. Binaire6057472octets/SHA262a20e7… inerte,ancien dossier yasuo simple libellé. Inspection rawexit null ; BUILD/RUN0 hérités de commandes conservées. Aucun nouveau build,jeu,natifD,GPU,REA,probe ou décodeur.

## 5. Écarts et inconnues

Éligibilité attaque/impact/dégâts,état initial,timer,reset,paliers/arrondi,cumul/caps et cycle de vie ouverts. Textes5s/25/8/70 connus,non producteur exécuté. Icônes/preloads/animations ordinaires ne prouvent pas attache,recette,rendu/audio ou transitions Strut. Inconnues et consommateurs enregistrés conservés,acceptation ouverte.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : eligible-interruption-timer-and-Strut-state ; authoritative-speed-ramp-and-movement-composition ; Strut-icons-particle-state-presentation-and-cleanup. Objectif,prérequis,critères et reprise précisés ; correction produit à autoriser séparément.

Prochain candidat `CH-MonkeyKing-PASSIF-PRESENTATION-VFX` dans next_lot.json,avec recherche d’audit existant préalable. Reprendre sur preuve,événement,appel,dérive ou test précis nouveau ; aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_missfortune_passive_vfx_20261105/` : evidence_review.json,coherence_review.json,corrections_and_restart.json,journaux,result.json,reçus. Sept rubriques et publication contrôlées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2363 entrées sales conservées. Seuls nouveau rapport et ajouts CURRENT/HANDOFF après archives exactes. Goal,Plan/UI/bases,registres,produit et assets inchangés. Fonctionnalité,tâche complète,parent,jeu et acceptation ouverts.
