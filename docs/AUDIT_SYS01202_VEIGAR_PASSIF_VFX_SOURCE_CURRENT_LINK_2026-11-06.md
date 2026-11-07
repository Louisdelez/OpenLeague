# SYS-01.2-02 — Veigar : Equilibrium et consommateurs VFX, V1418

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-VEIGAR-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Veigar-PASSIF-PRESENTATION-VFX`, `OLF-75232773-cd0d-5cd1-9787-4707e414c9eb` : relier marqueur, icônes, état de mana et consommateurs actuels. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues conservés dans initial_scope.json. SOURCE V554 et HUD V1291 réutilisés ; formule historique, réseau et présentation complète restent distincts. Aucun effet visuel obligatoire inventé depuis la barre de mana.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Source `reference_requirement_trace_sources/veigar-passive-missing-mana-regeneration-links-v554.json`,515593 octets,SHA `83eb85a79adb12b7e339c749395b12aeba41653db781a27ef1a266c3fcf176d0`. UTC documentaire 2026-10-25T20:10:40.575178+00:00. Métadonnées et captures E réutilisées ;aucun accès D/F/OpenLeague-work renouvelé.

Quatre sources directes :Veigar.inibin2349,font,VeigarEquilibrium.inibin49 et Lua349. Un chunk antérieurement lu entièrement,une initialisation littérale,huit globals,zéro callback enfant. BuffName et Passive1LuaName=VeigarEquilibrium,Passive1=1. PersistsThroughDeath/NonDispellable ne qualifient pas le lifecycle serveur. Aucun AutoBuff reconnu dans ce seul chunk,aucun preload sélectionné ;ni inventaire secondaire complet ni absence globale de VFX déduits.

Font2866/description4301 :régénération augmentée de1 % par1 % de mana manquant ;nom4477. Ancien texte Mundo/dégâts sous40 %PV,descriptions40/60/80 % et niveaux1/9/17 conservés sans adoption. Texte et multiplicateur illustratif1+fraction manquante ne sont pas une formule float32 native qualifiée.

CharScript :l’absence V554 concerne seulement Veigar/Scripts. La cinquième identité SOURCE enregistrée est à la racine Veigar/CharScriptVeigar.luaobj,56 octets,SHA `7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0`,membre254. CharScript_path_resolution.json et contexte enregistré réutilisés ;aucun nouveau stat/parse natif,quatre fichiers directs restent quatre.

Définition Veigar_Entropy.dds et buff VeigarEntropy.dds :deux noms conservés. Deux DDS propre/shared relus dans E,4224 octets chacun,64×64 DXT5,mip brut1,SHA identique `40d8b895c603a868fd08d47aac1b02e914c0d069c3fcc2e8d9030c1d1afd054b`. Membership237/25 du projet0.0.1.7 hérité. Identité de contenu nonpriorité d’alias/provider/skin,pixels ou recette de particule. StatsJSON communautaire distinct de l’INIBIN.

## 3. Consommateurs réels

Onze fichiers actuels,dont neuf Rust et deux lecteurs Python ;23 ancres concordantes. Dix sources/frontières,30 contextes,14 entrées VFX communes,deux liens d’animation ordinaire et font inchangés.

regeneration.rs:10–49 compose base,croissance,objets et restauration courante ;aucun terme Veigar/mana manquant dans ce chemin. shop.rs:314–321 préserve les pools absolus et écrête au plafond selon une reconstruction communautaire commentée. interactions.rs:84–108 traite la fontaine séparément. Aucun producteur nommé dans neuf préfixes Rust inspectés ;ancienne recherche client réutilisée après garde,conclusion bornée.

Owner/projection/chargement,widget Ezreal et animations ordinaires ne prouvent ni effet dédié ni présentation Equilibrium. Le besoin d’un statut réseau supplémentaire demeure à qualifier.

## 4. Attendu, observé et contrôles

Attendu :relier déclaration/état/présentation requise aux consommateurs,ou établir le manque et sa reprise. Observé :marqueur et icônes reliés ;régénération spécifique et présentation non établies.

30/30 contrôles documentaires,50/50 de cohérence séparée du même agent. HUD137/137 et112/112 hérités. Quatre cas publics L1 au spawn :Veigar plein,Sapphire1027,Sapphire+Charme1004,Annie+Sapphire. Achats400/180or,plafond+200mana et pools absolus conservés. Aucune injection de mana,or,XP,niveau,position ou effet ;aucun sort fonctionnel exécuté.

116 calculs float32 de paires mana avant fontaine,dont87 non écrêtées,réutilisés sans recalcul. Bornes préparées/tick29/pulsation30 des quatre cas relues séparément. Veigar+Sapphire :342.3999939/542.4000244 au départ,36.87316 % manquant,taux1.2/s,mana343.5602417 au29. Avec Charme :1.5/s,343.8496399. Résidus base/objet nuls ;aucun supplément dans ces deux déficits. Réserve pleine et témoin Annie nonvalidation du passif.

Quatre pulsations au30 expliquées par fontaine courante15 % du plafond,puis régénération :Veigar424.9602661 ou425.2596436. Constante et ajustement des pools restent communautaires,non natifs établis.32 refus flags,dont12Learn/Cast/CastAt Veigar ;toutes les paires individuelles non archivées.

Ancienne erreur analytique binary64/f32 conservée :542.3999938964844 contre542.4000244140625,deux comparaisons. Wrapper original et vérificateur arrondissant en float32 relus comme données ;commands_reexecuted=false. BUILD/RUN hérités0,ancien RUN382718 et1158 dépendances non relus. Binaire6025216/SHA `c98bd9d0ec2a06ba6757bb3bf6b0a59741af04fa9f5b85af46433814017de0b5`,identité inerte.

Six productions actuelles réussies,sans échec propre. Aucun nouveau build,jeu,décodage natif,REA,GPU,réseau/audio/rendu.

## 5. Écarts et inconnues

Formule/ordre/caps/pools natifs,autres niveaux,déficits extrêmes,coûts de sorts,mort/respawn,lifecycle,audiences,recette et rendu restent ouverts. **Le rendu propre au passif reste non qualifié.** Fontaine,Charme,icônes identiques et marqueur persistant ne prouvent pas Equilibrium. Aucune revue indépendante/humaine ni inventaire secondaire complet qualifié.

## 6. Corrections et reprise

corrections_and_restart.json conserve quatre clauses :POLICY-01 qualifie formule et besoin de présentation ;REGENERATION-01 consomme le déficit ;NETWORK qualifie le besoin de valeur/statut et ses audiences ;VFX relie la présentation requise,ou une absence historique explicitement sourcée. Réutiliser la réplication mana si suffisante,sans ajouter de statut ou de particule artificiels. HUD-BINDINGS et correction de chemin CharScript existants préservés. Préconditions,fins et reprises précises.

Reprendre sur source/capture/callsite nouveau ou dérive ;implémentation sous autorisation distincte. next_lot.json vise Velkoz :chercher ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_veigar_passive_vfx_20261106` :projections,fenêtres,bornes de mana,identités,corrections et journaux. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF,sauvegardes exactes et sept registres protégés.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés. SYS-01.2-02 reste actif.
