# Jarvan IV — liaison bornée de Cadence martiale et des effets visuels

## 1. Exigence et portée

2026-11-05, V1352 ; `AUD-SYS-01.2-02-JARVANIV-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; SYS-01.2-02 ; `CH-JarvanIV-PASSIF-PRESENTATION-VFX` ; `OLF-1371f3a9-6e49-5fff-8cad-0ed79aa41da4`. Relier les déclarations applicables aux consommateurs nécessaires. Audit terminé pour cette liaison bornée ; tâche complète, inventaire, fonctionnalité et acceptation ouverts.

Implémentation : bonus, verrou par cible et événement visuel non établis dans les corps inspectés. Vérification documentaire réussie ; essais historiques hérités, sans nouvelle exécution du jeu. Acceptation humaine non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/jarvaniv-passive-martial_cadence-links-v579.json`, copie E externe860174octets, SHA256 `efc6cc643fd18964506f391875a7ef79d30550f2862b0293dc0214b33bb28745`. Référence LoL4.20.0.315/EUW/en_GB héritée, catalogue4.20.1 distinct. Treize ressources/rôles,39 associations historiques sur trois tâches ; aucun accès D, chemins natifs inertes.

Quatre Lua structurels sans enfants, trois initialisations et cinq affectations : CharScript56 vide ; source202 avec PersistsThroughDeath=true ; cibleCheck173 sans ce champ, absence non false. Attack116 limité par NEWTABLEpc0 : limite de lecteur, pas corruption. Pas d’AutoBuff reconnu, sans absence générale d’effets déduite. Source persistante non politique effective du destinataire.

Deux preloads346octets/quatre noms comparés aux captures E451100/613194octets : passif,apbonusdamagetotowers,jarvincritattack_tar.troy et buffCheck. Noms conservés littéralement, sans activation ou recette déduite. AnimationName=Passive ; FX identifié sans décodage/rendu. AnnieBasicAttack_mis,BloodSlash,globalhit_physical restent des références distinctes, pas des corrections automatiques.

Vingt entrées DDF dont quatre coefficients/liens passifs vides : f1 non résolu. Cooldown0 du sort supplémentaire non verrou par cible ; ApplyAttackDamage chaîne0 et autres flags non politique d’attaque qualifiée. Anciennes chaînes Yi/mana non adoptées, six rangs et Passive1 null non remplacés. Neuf références communautaires secondaires.

Textes liés2091/2092/4204 : premier coup, bonus physique10% des PV actuels,max400 ; délai par cible @f1@ ouvert. Deux DDS identiques2872octets/64×64/DXT1/mip7, membres25 sous projet0.0.1.7. Troisième homonyme Zyra contextuel non lu, non sélectionné. Lookup,alias,variante et pixels non qualifiés ; aucun besoin de reconstruction graphique établi.

## 3. Consommateurs réels

Seize Rust complets,37 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:46` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `attacks.rs:157` ; `attacks.rs:26` ; `attacks.rs:141` ; `lifesteal.rs:4` ; `damage.rs:53` ; `damage.rs:38` ; `regeneration.rs:10` ; `regeneration.rs:32` ; `shop.rs:215` ; `shop.rs:261` ; `lib.rs:744` ; `lifecycle.rs:33` ; `attacks.rs:103` ; `attacks.rs:14` ; `attacks.rs:59` ; `attacks.rs:219` ; `attacks.rs:218` ; `lifesteal.rs:17` ; `damage.rs:91` ; `damage.rs:101` ; `critical.rs:19` ; `healing.rs:16` ; `world.rs:226` ; `penetration.rs:4` ; `penetration.rs:9` ; `shields.rs:47` ; `lifecycle.rs:83` ; `projected_live.rs:168`.

Racines `F:/OpenLeague/crates/core/src/`, sauf projected_live dans client/src. L’attaque combine AD,critique et branches Garen/Trundle avant basic_attack_hit ; Physical passe par réduction,pénétration,mitigation,boucliers,PV puis vol de vie/riposte génériques. Aucun bonus de PV actuels ou verrou Cadence martiale établi dans cette chaîne inspectée. Présentation ordinaire et projection Annie distinctes ; windup/cadence ne fournissent pas f1.

Recherche JarvanIV/MartialCadence sur seize textes : zéro hit, sans absence globale déduite.19 comparaisons sélectionnées et89 contextuelles chevauchantes concordent ;14 mécanismes VFX et2 animations ordinaires réutilisés. Le pont attack/crit ne prouve pas la sélection du clip Passive.

## 4. Attendu, observé et contrôles

Attendu : préserver texte connu, bonus/verrou/presentation distincts et limites de preuve. Observé :89/89 contrôles documentaires,98/98 de cohérence séparée du même agent. V1224 source64/64,consommateurs63/63,intégration40/40 hérités, non rejoués. Pas de décodeur indépendant.

V579 hérité : deux cas publics Map10 base/Épée longue1036,huit impacts chacun sur deux Annie AABBABAB,16total,32refus,180ticks de suivi après Stop. AD55.7120018/65.7120056 ; dégâts physiques ordinaires avec régénération comptée,résidu<0.002. Première cible511.679993PV :51.167999 brut selon texte, calcul indicatif sans instantPV ou ordre natif qualifiés. +10AD objet non passif ; alternance non verrou ;90ticks ne prouvent pas une expiration sans état créé. Max400,autres cibles/niveaux,boucliers et critique non qualifiés.

Binaire6028288octets/SHA256 `18374d860f2adc88a15c6aa1af67432ad07bb06c3bf165817c06043d00e2af64`, BUILD/RUN0 historiques, jamais rouvert. Ancienne inspection hashstring/int puis variante qualifiée et préparations HUD/source archivées conservées. Deux erreurs de préparation actuelles conservées : affichage cp1252/U+2192, puis pointeur PREV Irelia au lieu de Janna ; variantes corrigées sans relâcher les identités. Six opérations documentaires journalisées réussies ; aucun nouveau build,jeu,natif,GPU,REA,probe ou réseau. V564 ouvert.

## 5. Écarts et inconnues

Délai f1,niveaux,cibles,min/max,instantPV,ordre des modificateurs,arrondis,cumuls et lifecycle source/cible ouverts. Applicabilité,activation,clip,recette,attache,pose,lookup et pixels restent à qualifier. Ni absence AutoBuff ni preloads ne démontrent l’effet manquant ou sa réalisation. Aucun inventaire complet,tâche VFX,inconnue ou acceptation fermé.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json : martial-cadence-visual-applicability-source,source-target-bonus-trigger-state,passive-clip-resource-render-lifecycle. Chacune possède objectif,prérequis,critères et condition de reprise. Préserver10%/max400 ;qualifier le reste avant correction du jeu. Ne pas répéter les essais ordinaires inchangés pour résoudre f1 ou le rendu.

Prochain lot CH-Jax-PASSIF-PRESENTATION-VFX ;sources conservées dans next_lot.json. Réutiliser consolidation V1346 et mécanismes communs sans nouveau recensement global.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_jarvaniv_passive_vfx_20261105/` : evidence_review,coherence_review,corrections_and_restart,operations/journals,reçus et variantes conservées. Relecture du même agent,sans acceptation indépendante ou humaine.

Seule liaison bornée close ; tâche complète,feature,inconnues et goal ouverts. Publication : ce rapport et ajouts CURRENT/HANDOFF avec archives exactes ;goal/Plan/UI/bases/registres/code/assets inchangés.
