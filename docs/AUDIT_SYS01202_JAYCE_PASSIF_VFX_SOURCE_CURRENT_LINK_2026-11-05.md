# Jayce — liaison bornée du Condensateur Hextech et des effets visuels

## 1. Exigence et portée

2026-11-05,V1354 ; `AUD-SYS-01.2-02-JAYCE-PASSIF-VFX-SOURCE-CURRENT-LINK-01` ; SYS-01.2-02 ; `CH-Jayce-PASSIF-PRESENTATION-VFX` ; `OLF-c43098e6-aad8-57a8-ad5c-f49042388b1d`. Relier les déclarations applicables aux consommateurs nécessaires. Audit terminé pour cette liaison bornée ; tâche complète,inventaire,fonctionnalité et acceptation ouverts.

Implémentation : Transform,bonus vitesse et traversée spécifiques non établis dans les corps inspectés. Vérification documentaire réussie ; essais historiques hérités sans nouvelle exécution du jeu. Acceptation humaine non demandée.

## 2. Sources et provenance

Reçu `F:/OpenLeague/docs/reference_requirement_trace_sources/jayce-passive-hextech_capacitor-links-v581.json`,copie E externe1170734octets,SHA256 `cdd05b959b236bd30f6821f3883ff934ef40c5114077f75d6a6b0f0b0fe94e54`. Référence LoL4.20.0.315/EUW/en_GB héritée,catalogue4.20.1 distinct. Trente-sept ressources/rôles,111 associations historiques sur trois tâches ;aucun accès D,chemins natifs inertes.

Seize Lua structurels sans enfants,14 initialisations/89 affectations. CharScript56 vide ;GtH/HtG620 limités par NEWTABLEpc14,sans corruption démontrée. Haste213 déclare Haste/Summoner_haste,non contrat Fantôme. RunSpeed et HammerCheck90 déclarent persistence ;formes persistence/non-dispel non lifecycle qualifié. GarenRecouperate,ApolloPassive/Active,JarvanIVDemacianStandard/14.dds et CastTime0.115 conservés sans réécriture ou durée vitesse déduite.

Dix preloads3265octets/43 références comparés aux captures E648567/811226octets. Root est un nom BBPreloadSpell,non une attache déduite. Model swaps,formes,capacités,skins et impacts chargés restent distincts. Quarante entrées DDF sans entrée vitesse passive ne prouvent pas une absence globale de formule. Quatorze références communautaires secondaires.

Dix-huit champs AutoBuff donnent neuf paires effet/os : ReadyMelee,ReadyRange et legacyReady,trois slots chacun,WEAPON_1/GAP_1/GAP_2. Déclarations présentes,activation,recette complète,pose/attache et rendu non qualifiés ;attaques chargées non automatiquement effet d’accélération.

Texte4206 : +40vitesse pendant1.25seconde et passage entre unités lors de Transform. Six bindings de buff,cinq liés2102–2106 ;JaycePassive manquant,sans alias. Rangs1/4/7 puisnull non calendrier du bonus. Personnage/Jayce_Passive,Haste/Summoner_haste et legacyJaycePassive/JayceManOfTomorrow gardent leurs rôles. Treize lignes en_GB héritées. JayceManOfTomorrow.dds non retrouvé dans les scopes antérieurs nommés,non absence globale/corruption.

Deux DDS distincts64×64 : Jayce_Passive5616/DXT5/mip7/membre174,SHA `7711a7f010a64b6bc4b9ef6c145bd41b92ac24a513464d66de38204bac122f14` ;Summoner_haste2176/DXT1/mipbrut0/membre195,SHA `78a4e9549b20333551c47c37cfe914a9dc9b301050df5bca08ebb847607ea798`. Projet0.0.1.7 ;lookup,variante,pixels ouverts,aucune reconstruction graphique présumée.

## 3. Consommateurs réels

Seize Rust complets,37 ancres : `lib.rs:533` ; `lib.rs:598` ; `progression.rs:68` ; `progression.rs:46` ; `progression.rs:150` ; `progression.rs:159` ; `spells.rs:101` ; `annie_w.rs:29` ; `lib.rs:685` ; `movement.rs:53` ; `movement.rs:38` ; `movement.rs:19` ; `shop.rs:215` ; `shop.rs:261` ; `summoner_heal.rs:33` ; `summoners.rs:47` ; `summoner_heal.rs:21` ; `ally_occupancy.rs:635` ; `collision.rs:22` ; `ally_occupancy.rs:96` ; `lib.rs:744` ; `lifecycle.rs:33` ; `lib.rs:624` ; `lib.rs:668` ; `movement.rs:39` ; `movement.rs:44` ; `movement.rs:46` ; `movement.rs:55` ; `movement.rs:56` ; `movement.rs:60` ; `interactions.rs:48` ; `trundle_w.rs:78` ; `trundle_w.rs:88` ; `trundle_e.rs:75` ; `slows.rs:9` ; `lifecycle.rs:83` ; `projected_live.rs:168`.

Racines `F:/OpenLeague/crates/core/src/`,sauf projected_live dans client/src. Vitesse réelle : base+objets,puis bonus GarenQ/Soin/relique/Trundle,ralentissements/plafonds et multiplicateur GarenE. Gardes propres conservées ;pas de producteur Hextech Capacitor établi. Dispatchs sorts/rangs refusent Jayce. Corps vivants,filtrage allié et mouvement réel sont des mécanismes locaux,non une fenêtre de traversée après Transform.

Recherche Jayce/HextechCapacitor sur seize textes : zéro hit,sans absence globale déduite. Recherche Transform distincte :un Transform::IDENTITY Bevy géométrique ;ancien périmètre plus large12 occurrences caméra/géométrie non substitué.28 comparaisons sélectionnées et92 contextuelles chevauchantes concordent ;14 mécanismes VFX et2 animations ordinaires réutilisés,sans rendu spécifique qualifié.

## 4. Attendu, observé et contrôles

Attendu : distinguer Haste,formes,attaques chargées,activation et rendu. Observé :120/120 contrôles documentaires,120/120 de cohérence séparée du même agent. V1226 source74/74,consommateurs58/58,intégration40/40 hérités,non rejoués. Pas de décodeur indépendant.

V581 hérité :quatre cas vitesse,70refus,240ticks,20pas ;base335/bottes360,Soin431.399963/457.399963 puis retour tick30. Cinq pas/cas suivent vitesse/30,résidu<0.005,puis Stop immobile. Transform refusé avant/après60ticks,snapshots inchangés ;aucun état passif activé. Attente non expiration1.25s.

Quatre cas occupation Jayce/Garen :alliés bloquent à65unités,ennemis traversés chez les deux ;deux refus Transform supplémentaires,72total publics. Rayons locaux et traversée générique ne qualifient pas le passage natif. Troisième capture E829626octets confirme résumés vitesse/occupation ;aucun replay.

Binaire6056960octets/SHA `a039135e06e854df559892923f35fd8de2c1ebe95d4cff11af929e4d7d3ea297`,BUILD/RUN0 historiques,jamais rouvert. Anciennes erreurs source dépendances3distinctes/4liens et assertion Transform trop large conservées. Préparation actuelle :assertion chemin de reprise puis deux scripts absents ;originaux,journaux,identités nulles et variantes corrigées conservés. Huit opérations documentaires :six réussies,deux échecs initiaux ;aucun nouveau build,jeu,natif,GPU,REA,probe ou réseau. V564 ouvert.

## 5. Écarts et inconnues

Transform dans les deux sens,temporalité/arrondis,ordre/cumuls/refresh,corps traversables,niveaux et lifecycle ouverts. Applicabilité,alias,ressource non localisée,activation,recette,pose,attache,pixels et audiences restent à qualifier. États persistants ou neuf paires effet/os ne démontrent pas leur emploi. Aucun inventaire complet,tâche VFX,inconnue ou acceptation fermé.

## 6. Corrections et reprise

Trois clauses de la tâche existante dans corrections_and_restart.json :transform-haste-visual-applicability-source,form-transition-speed-occupancy-event,charged-effect-resource-bone-render-lifecycle. Chacune possède objectif,prérequis,critères et reprise. Préserver40/1.25 ;qualifier les autres politiques avant correction du jeu. Ni Haste/Fantôme ni Garen/Apollo/Jarvan ne fournissent une substitution implicite.

Prochain lot CH-Jinx-PASSIF-PRESENTATION-VFX ;sources conservées dans next_lot.json. Réutiliser consolidation V1346 et mécanismes communs,sans nouveau recensement global ni replay inchangé.

## 7. Livrable et clôture

Preuves `E:/mapslol3v3/audit_sys01202_jayce_passive_vfx_20261105/` :evidence_review,coherence_review,corrections_and_restart,operations/journals,reçus et échecs conservés. Relecture du même agent,sans acceptation indépendante ou humaine.

Seule liaison bornée close ;tâche complète,feature,inconnues et goal ouverts. Publication :rapport et ajouts CURRENT/HANDOFF avec archives exactes ;goal/Plan/UI/bases/registres/code/assets inchangés.
