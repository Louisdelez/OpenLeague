# Janna — liaison bornée de Tailwind et des effets visuels

## 1. Exigence et portée

2026-11-05, V1351 ; `AUD-SYS-01.2-02-JANNA-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; parent SYS-01.2-02 ; `CH-Janna-PASSIF-PRESENTATION-VFX` ; `OLF-4e8e9491-3434-563b-859b-1c68162ee607`. Relier les déclarations applicables aux consommateurs nécessaires. Audit terminé pour cette liaison bornée ; inventaire complet, fonctionnalité, runtime et acceptation restent ouverts.

Implémentation : contribution Tailwind et événement visuel non établis dans les corps inspectés ; mécanismes génériques conservés. Vérification statique documentaire réussie, scénarios historiques non réexécutés. Acceptation humaine non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/janna-passive-tailwind-links-v578.json` ; copie E externe 847619octets, SHA256 `b80ba782d7f5585d0c3d85a0c2dd59cc1f4c210894871b82a49bd716e9009ecd`. Référence LoL4.20.0.315/EUW/en_GB héritée ; catalogue4.20.1 distinct. Treize identités/rôles natifs,39 associations historiques de trois tâches. Aucun accès D ; chemins natifs inertes.

Quatre Lua structurels sans enfants, trois initialisations/six affectations. CharScript56 vide ; Tailwind145 déclare identité/icône ; TailwindSelf211 ajoute PersistsThroughDeath/NonDispellable=true. Champs destinataire absents non false, sans transfert de politique de mort/dispel. SowTheWind522 reste limité par NEWTABLEpc18, sans corruption démontrée. Pas d’AutoBuff reconnu, sans absence générale d’effets déduite.

Deux preloads741octets/onze noms, comparés aux captures E420739/603577octets. Tailwind/Self,W,ForecastVO/taunts et particules SowTheWind restent des références, non une activation passive. DDF4 entrées W/coefs AP0.02/0.06 non règle Tailwind. Chaînes zéro de Passive1/rangs1..4 et rangs5/6 null ne définissent pas un bonus nul ; ancien5AstralSpirts non adopté. Dix références communautaires secondaires.

Trois bindings2745/2746/2997 et nom/description4379/4203 liés. Bonus5% documenté ; buff source «nearby allied champions», description «all allied champions», divergence conservée. Pas de f1 passif inventé. Zephyr décrit vitesse personnelle/passage W distincts. Deux DDS4224octets/64×64/DXT5/mip1 au même contenu, membres0.0.0.161 et0.0.0.25 sous core0.0.1.7 : aucun choix automatique du plus récent, lookup/alias/sélection/pixels ouverts. Aucun besoin de reconstruction graphique établi.

## 3. Consommateurs réels

Seize Rust complets,29 ancres : `lib.rs:685` ; `lib.rs:624` ; `lib.rs:668` ; `movement.rs:19` ; `movement.rs:38` ; `movement.rs:39` ; `movement.rs:44` ; `movement.rs:46` ; `movement.rs:53` ; `movement.rs:55` ; `movement.rs:56` ; `movement.rs:60` ; `progression.rs:118` ; `shop.rs:215` ; `summoner_heal.rs:21` ; `summoner_heal.rs:22` ; `summoners.rs:47` ; `interactions.rs:48` ; `trundle_w.rs:78` ; `trundle_w.rs:88` ; `trundle_e.rs:75` ; `slows.rs:9` ; `ally_occupancy.rs:96` ; `collision.rs:22` ; `spells.rs:5` ; `spells.rs:120` ; `annie_w.rs:49` ; `lifecycle.rs:83` ; `projected_live.rs:168`.

Racines : `F:/OpenLeague/crates/core/src/`, sauf projected_live dans client/src. La chaîne vitesse combine base/objets,GarenQ,Soin,relique,TrundleW,ralentissements/TrundleE,plafonds puis traversée propre à GarenE. TrundleW est limité à son propriétaire Trundle ; relique et Soin ont leurs échéances. Aucun producteur Tailwind identifié dans cette formule inspectée. Move/Stop,occupation/navigation et reset génériques ne qualifient pas l’aura ou le passage W.

Recherche Janna/Tailwind sur seize textes : zéro hit, sans absence globale déduite.28 comparaisons sélectionnées et96 contextuelles chevauchantes concordent ;14 mécanismes VFX et2 animations ordinaires réutilisés sans présentation Tailwind qualifiée. Projection Annie distincte.

## 4. Attendu, observé et contrôles

Attendu : conserver source/destinataire,5%,divergence de portée et voies génériques. Observé :78/78 contrôles documentaires et86/86 de cohérence séparée du même agent ; pas de second décodeur indépendant. V1223 source63/63,consommateurs60/60,intégration40/40 hérités, non rejoués.

V578 : quatre cas publics Map10,70refus,240ticks,40pas mesurés. Ahri330 ou355 avec1001 à250 puis1249.999512unités ; Janna/Annie335. Soin donne426.200012/452.200012 puis retour330/355 au tick30. Phases30ticks avec cinq pas Move puis Stop ; distance=vitesse/30,résidu<0.005,puis mouvement nul ; résidu vitesse<0.001, hérités. Ces distances ne qualifient ni rayon natif ni aura nulle.

Soin30%/30ticks,plafonds locaux et conflit cooldown240/300s restent distincts de Tailwind.70refus=60Janna,8cibles Soin invalides,2cooldowns,snapshots conservés. Aucun W/passage exercé. Binaire6031872octets/SHA71373f316991eec8cc40245a8bd8bdccda96b5a8ce549b87f8523ef62cac7d3b, BUILD/RUN0 hérités, jamais rouverts. Anciennes précisions de préflight,nom MD hérité/fenêtre slows et chaîne Irelia/Heimer conservées, pas de nouvelle correction de navigation.

Six opérations documentaires journalisées ; aucun nouveau build,jeu,natif,GPU,REA ou probe ; V564 ouvert.

## 5. Écarts et inconnues

Politique globale/proche,portée/cibles/auto-application,base du pourcentage,sources multiples/cumuls,ordre ralentissements/plafonds,arrondis/niveaux et mort/dispel/perte de source restent ouverts. Source persistante/non dissipable ne définit pas le cycle destinataire. Applicabilité,recette,attache,pose,ressource sélectionnée et pixels restent à qualifier. Aucun effet passif présumé manquant. Contrat et IDs d’inconnues conservés ; aucune tâche VFX complète ou inconnue fermée.

## 6. Corrections et reprise

Réutiliser la tâche existante avec tailwind-visual-applicability-source,allied-speed-source-recipient-world-link et applicable-resource-attachment-render-lifecycle. Objectifs,prérequis,critères nominaux/refus et reprises dans corrections_and_restart.json. Conserver5%,résoudre les autres politiques sans importer W ou Soin. Exiger l’applicabilité avant un éventuel effet graphique ; aucun code produit corrigé implicitement. Reprise sur source/callsite/événement ou dérive précise,sans essai inchangé.

Prochain lot : CH-JarvanIV-PASSIF-PRESENTATION-VFX,sources conservées dans next_lot.json. Réutiliser consolidation V1346 et mécanismes communs sans nouveau recensement global ou acquisition présumée.

## 7. Livrable et clôture

Preuves : `E:/mapslol3v3/audit_sys01202_janna_passive_vfx_20261105/`, evidence_review.json,coherence_review.json,corrections_and_restart.json,operations/journals et reçus. Relecture du même agent,sans acceptation indépendante ou humaine.

Seule liaison bornée clôturable ; tâche complète,inventaire,feature,inconnues et goal ouverts. Publication documentaire : rapport et ajouts CURRENT/HANDOFF avec archives exactes ; goal/Plan/UI/bases/registres/code/assets inchangés.
