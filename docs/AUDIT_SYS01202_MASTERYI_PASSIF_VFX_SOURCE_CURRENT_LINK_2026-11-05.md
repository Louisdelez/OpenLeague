# Master Yi — Double Coup : sources, consommateurs et écarts

## 1. Exigence et portée

2026-11-05, V1375 ; `AUD-SYS-01.2-02-MASTERYI-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-MasterYi-PASSIF-PRESENTATION-VFX` ; `OLF-21572f85-7b6f-554a-975d-626a9ce2705e`. Audit de liaison borné terminé. La tâche VFX, le double coup fonctionnel et le goal restent ouverts. Contrat, prérequis et dépendance NETWORK conservés dans initial_scope.json. Vérifications documentaires fraîches ; exécution historique réutilisée ; aucune acceptation humaine.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/masteryi-passive-double-strike-links-v601.json`,1431982octets, SHA `c4dea546a2e980b2728f61d0fad7d964fa4c7c86411a3b7ef1c6ece8bba38004` ; copie E identique. Référence LoL4.20.0.315/EUW/en_GB, catalogue4.20.1 distinct.54identités/rôles,23Lua,14initialisations/70affectations ; neuf limites NEWTABLE conservées. CharScriptMasterYi/AlphaStrikeMarker56octets vides ne prouvent aucune absence d’animation. Audit HUD source86/86 et consommateurs21/21 hérité.

MasterYiPassive217 : Passive1/MasterYiPassive, persistence et NonDispellable ; DoubleStrike157 : Passive1/DoubleStrikeReady,sans ces flags ajoutés ; DoubleStrikeStacks220 : Passive2/DoubleStrikeStacks,persistence et NonDispellable. Aucun AutoBuff qualifié pour ces trois états.32champs AutoBuff non vides appartiennent aux quatre contextes Wuju E, non recette du passif. Casse des quatre attaches et typo native SuperChraged conservées.

Tooltips : neuf résolus sur dix. MasterYiPassive2278 décrit chaque quatrième attaque consécutive et une seconde frappe à50% ; Ready1840 annonce la prochaine attaque double, Stacks1841 la quatrième. Clé BuffData DoubleStrike non résolue, non aliasée silencieusement. Description4232 « Every few strikes » moins précise, texte legacy probabiliste et bonus mana conservés sans en tirer une politique concurrente. DynamicTooltip MasterYiDoubleStrike présent vide11709 ; coefficients0 non dégâts secondaires nuls ; CanCrit/ApplyOnHitEffects null non false.17métadonnées de sorts et16lignes DDF liées conservées comme contexte, non formule du passif. Six candidats absents bornés, zéro contexte NightmareBot,23références communautaires secondaires ; seul CharScript communautaire inspecté vide.

11preloads3088octets/39noms ; MasterYiDoubleStrike104 déclare masteryi_base_p_tar.troy. Déclaration non callback, création ou recette complète. Deux DDS distinctes2176octets/64×64/DXT1,mipraw0,membre172 : Passive1/Passive2, sans pixels ou lookup qualifiés. Contextes modèles/particules non ouverts, aucune absence globale déduite. Champ caveat de provenance de ressource absent, aucune valeur inventée. Trois captures E818561/1040695/1169121octets et manifest initial54500octets/SHA4aef5e31… vérifiés ; capture d’origine et failure_provenance conservées. Chemins D inertes, aucune relance native.

## 3. Consommateurs réels

13Rust complets,34ancres dans evidence_review.json, racine `F:/OpenLeague/` : `crates/core/src/spells.rs:101,120`, `progression.rs:150,159,164`, `attacks.rs:157,218`, `lifesteal.rs:4,17,20`, `critical.rs:12,19`, `damage.rs:53,92`, `death_recap.rs:184,200,202`, `crates/client/src/projected_live.rs:168`.

Sorts/rangs Master Yi refusés. Attaque ordinaire, physique après mitigation, critique, vol de vie et récapitulatif attribué acquis ; ils ne constituent pas un producteur de seconde frappe. projected_live filtre Annie. Recherche bornée aux13Rust sans nom MasterYi/DoubleStrike, non absence globale de fichiers.

25comparaisons sélectionnées,145contextuelles fraîches et une identité EXE héritée inerte parmi146 ; ensembles recouvrants, pas171consommateurs.14mécanismes communs et deux fichiers d’animation ordinaire concordent. Chaîne d’animation explicite V1374→V1373→acquis conservé ; non animation propre au second coup. Extraits figés et témoins réutilisés, aucun gros registre redécodé ou REA répété.

## 4. Attendu et observé

Attendu : liens précis, preuves traçables, acquis/refus préservés, écarts clôturables. Observé :160/160contrôles documentaires,123/123de cohérence séparée du même agent, non pair indépendant. Six opérations journalisées exit0 ; erreur cp1252 du message final de préparation conservée, fichiers déjà écrits puis trois gardes réellement réussies. Aucun produit modifié.

V601 hérité : base/LongSword1036/Dagger1042, AD60.0400009/70.0400009/60.0400009,cadence44/44/38ticks ; huit impacts ordinaires/cas, soit24impacts/81refus/540ticks après Stop. Mana250.5599976 plafonnée. Les attaques candidates sont exercées, même si les sorts sont refusés ; dégâts ordinaires aux frappes4/8, pas de seconde frappe qualifiée. Dagger ne mesure pas le délai intra-double ; LongSword ne mesure pas son coefficient. Frappe8 non preuve du cycle suivant,540ticks après Stop non durée native de reset.

Tableaux HUD hérités exactement, sans recalcul :24paires PV cible avant/après,917frames sans tableaux PV,21lectures d’extrémité entre impacts et trois fins idle ; six snapshots complets/cas. Source_before absent ; paires brutes de refus, série PVidle et snapshots complets idle absents. NPC présents dans les snapshots sauvegardés ; gardes combat/idle distinctes du trajet, pas absence universelle. Binaire6043136octets/SHA892df60c… inerte, ancien dossier yasuo simple libellé. OBSpassed non reçu de sortie brut, rawexit null ; BUILD/RUN0 hérités. Aucun nouveau jeu,build,GPU,probe ou décodeur.

## 5. Écarts et inconnues

Compteur/éligibilité, consommation, auto-comptage du second coup, reset/persistence, temps/dégâts et interactions restent ouverts. Texte50% connu, formule et producteur non qualifiés. Icônes/preload et animations ordinaires ne prouvent ni seconde animation, ni recette/attache, rendu/audio ou cycle de vie. Inconnues et consommateurs enregistrés conservés, ressources non réputées manquantes globalement.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : eligible-basic-attack-counter-and-double-strike-state ; secondary-strike-damage-timing-and-interactions ; charge-ready-double-impact-presentation-and-cleanup. Chaque clause porte objectif, prérequis, critères et condition de reprise. Aucune autorisation produit implicite.

Prochain candidat : `CH-MissFortune-PASSIF-PRESENTATION-VFX` dans next_lot.json ; rechercher d’abord l’audit existant pour éviter un doublon. Reprendre sur source, événement, appel, dérive ou test précis nouveau. Aucun facteur d’accélération mesuré.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_masteryi_passive_vfx_20261105/` : evidence_review.json,coherence_review.json,corrections_and_restart.json,journaux,result.json,reçus. Sept rubriques et publication contrôlées séparément.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2362 entrées sales conservées. Publication : nouveau rapport et ajouts CURRENT/HANDOFF après archives exactes. Goal,Plan/UI/bases,registres,produit et assets inchangés ; fonctionnalité, tâche complète, parent, jeu et acceptation ouverts.
