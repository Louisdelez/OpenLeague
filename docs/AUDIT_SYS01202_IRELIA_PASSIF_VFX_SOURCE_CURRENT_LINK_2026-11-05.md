# Irelia — liaison bornée de Ionian Fervor et des effets visuels

## 1. Exigence et portée

2026-11-05, V1350 ; `AUD-SYS-01.2-02-IRELIA-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Irelia-PASSIF-PRESENTATION-VFX` ; `OLF-70456e3e-b42f-5815-b8a5-5bd4e9963b16`. Relier les déclarations applicables aux consommateurs nécessaires. Audit terminé pour cette liaison bornée ; inventaire complet, fonctionnalité, runtime et acceptation restent ouverts.

Implémentation : comptage/réduction Ionian Fervor et événement visuel non établis dans les corps inspectés ; contrôles génériques conservés. Vérification : statique documentaire réussie, scénarios historiques non réexécutés. Acceptation humaine : non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/irelia-passive-ionian_fervor-links-v577.json` ; copie E externe828124octets, SHA256 `4a759468cc9cecc0878a88676704be299ce6c4d98ab2ed67ac8d456080f24373`. Référence LoL4.20.0.315/EUW/en_GB héritée ; catalogue4.20.1 distinct. Huit identités/rôles natifs,24 associations historiques de trois tâches. Aucun accès D ; chemins natifs inertes.

Définition Passive1LuaName=Voracity, preload/buff IreliaIonianDuelist : divergence conservée sans réécriture automatique ou substitution Katarina. Deux Lua littéraux/deux affectations, sans enfant ni callback exécuté ; CharScript56 vide,buff161 identité/icône. Persistance absente non false ; aucun AutoBuff reconnu, sans absence générale d’effets déduite. Rangs null non convertis en zéro ; Passive1Desc null distinct de PassLev1Desc1 lié.

Deux preloads616octets/huit noms comparés aux captures E397385/568048octets. Trois particules irelia_new_passive_01/02/03.troy déclarées, sans mapping d’ennemis,invo­cation,attache ou rendu qualifié. HitenStyle/idle distincts. DDF4 entrées R sans passif seulement dans ce fichier ; coefficient0.6AD bonus non f1. Sept références communautaires secondaires.

Un binding2022 f1%/SourceName ; description4202 liée documente10/25/40% pour1/2/3ennemis, nom4378 lié. Rayon,comptage/producteur,0/4+,visibilité/morts/clones,exceptions et calcul restent ouverts. Deux DDS2872octets chacun/64×64/DXT1/mip7, même contenu, membre0.0.0.25 sous core0.0.1.7 ; lookup/priorité/alias/pixels non qualifiés. Aucun besoin de reconstruction graphique établi.

## 3. Consommateurs réels

Douze Rust et un JSON local complets,30 ancres : `lib.rs:685` ; `spells.rs:5` ; `spells.rs:93` ; `spells.rs:94` ; `spells.rs:95` ; `spells.rs:119` ; `spells.rs:167` ; `spells.rs:187` ; `spells.rs:196` ; `spells.rs:197` ; `stuns.rs:8` ; `stuns.rs:11` ; `stuns.rs:15` ; `stuns.rs:28` ; `stuns.rs:37` ; `slows.rs:9` ; `slows.rs:20` ; `slows.rs:33` ; `slows.rs:41` ; `slows.rs:50` ; `slows.rs:74` ; `slows.rs:78` ; `attacks.rs:249` ; `annie.rs:45` ; `progression.rs:164` ; `lifecycle.rs:83` ; `movement.rs:38` ; `damage.rs:53` ; `annie_w.rs:49` ; `projected_live.rs:168`.

Racines : `F:/OpenLeague/crates/core/src/`, sauf projected_live dans client/src et `F:/OpenLeague/data/4.20/disabled_cast_rules.json`. control_duration utilise courage_until puis ceil(durée×0.7), sinon durée brute. Getter sans garde champion, producteur public inspecté dispatché Garen ; aucun comptage Irelia dans ce corps. Silence,stun et slow possèdent des applications/échéances ; APIs serveur distinctes des sorts publics. Admission NPC locale non immunité native.

allows_disabled consomme12 booléens du JSON335octets/SHAf5e3f647a7c68b7cbb4b7bb7786d645cb8c82439203dbf30af1ba5aaf0e57256 ; OLS-40ae19ee-0962-56b3-a7a7-6d6a5d6f34ae explicitement politique Rust locale, pas immunité Irelia native. SOURCE conserve ses quatre sites/deux fichiers INIBIN, sans site Lua enregistré dans cette clause. Recherche nommée sur treize entrées : zéro hit, sans absence globale déduite.20 comparaisons sélectionnées et78 contextuelles chevauchantes concordent ;14 mécanismes VFX et2 animations ordinaires réutilisés. Projection Annie distincte.

## 4. Attendu, observé et contrôles

Attendu : relier alias,pourcentages,contrôles et ressources sans promouvoir une politique locale ou un diagnostic. Observé :82/82 contrôles documentaires et92/92 de cohérence séparée du même agent ; pas de second décodeur indépendant. V1222 source59/59,consommateurs60/60,intégration40/40 hérités, non rejoués.

V577 : quatre cas Irelia0/1/2/3ennemis et deux Garen. Groupe400unités diagnostique ; distances150/250/350 ou13261.615 non rayon natif. Trois silences publics GarenQ45ticks,135ticks de suivi déclarés séparément.14 paires serveur/28 événements grant_stun/grant_slow ; Irelia conserve1/30/90ticks ; Garen90,ou63 sous Courage.637ticks de suivi serveur,74refus publics54serveur hérités.90→63 ne qualifie pas arrondi ou règle Irelia ; diagnostics non sorts joueurs.

Ancienne inspection refusée sur entrée de registre disabled_cast_rules absente,PREPARE sur comparaison élément/tranche,source regex communautaire57/58 puis59/59 conservées. Chaînes qualifiées distinctes ; aucun échec promu. Binaire6078976octets/SHA6a9ecfb00b4aa08c80f555455825186194abd839a9711ba5c7bd878dfb08bd11 et artefacts échoués conservés comme identités inertes, aucun F-work/binaire rouvert. Six opérations documentaires journalisées ; aucun nouveau build,jeu,natif,GPU,REA ou probe ; V564 ouvert.

## 5. Écarts et inconnues

Usage effectif Voracity,f1 dynamique,rayon/comptage,catégories et exceptions,cumuls/objets,arrondis/minima,niveaux et cycle de vie restent ouverts. Trois noms numérotés ne définissent pas seuls les états. Applicabilité,recette,attache,pose,ressource sélectionnée et pixels restent à qualifier. Contrat et IDs d’inconnues conservés ; aucune tâche VFX complète ou inconnue fermée.

## 6. Corrections et reprise

Réutiliser la tâche existante avec ionian-fervor-visual-applicability-source,enemy-count-control-duration-world-link et resource-attachment-render-lifecycle. Objectifs,prérequis,critères nominaux/refus et reprises dans corrections_and_restart.json. Préserver les pourcentages documentés,qualifier les autres règles,ne pas importer Courage. Aucun code produit corrigé implicitement. Reprise sur source/callsite/événement ou dérive précise,sans essai inchangé.

Prochain lot : CH-Janna-PASSIF-PRESENTATION-VFX,sources conservées dans next_lot.json. Réutiliser consolidation V1346 et mécanismes communs sans nouveau recensement global ou acquisition présumée.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_irelia_passive_vfx_20261105/`, evidence_review.json,coherence_review.json,corrections_and_restart.json,operations/journals et reçus. Relecture du même agent,sans acceptation indépendante ou humaine.

Seule liaison bornée clôturable ; tâche complète,inventaire,feature,inconnues et goal ouverts. Publication documentaire : rapport et ajouts CURRENT/HANDOFF avec archives exactes ; goal/Plan/UI/bases/registres/code/assets inchangés.
