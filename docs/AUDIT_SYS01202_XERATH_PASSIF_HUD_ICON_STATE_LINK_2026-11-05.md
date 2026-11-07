# SYS-01.2-02 — V1299 Xerath : Mana Surge et HUD

## 1. Périmètre et prérequis

2026-11-05, F:/OpenLeague. Unité `AUD-SYS-01.2-02-XERATH-PASSIF-HUD-ICON-STATE-LINK-01`, tâche `CH-Xerath-PASSIF-PRESENTATION-HUD`, exigence `OLF-43341cdf-cfa4-54eb-8bc5-feff4520a711`, inconnue `OLU-6bf941af-a30c-5b3f-8b0a-0d463d0634cd`. Audit documentaire borné terminé ; six contrats/questions conservés, HUD a_faire, implémentation et acceptation false. Dépendance NETWORK ouverte. D06/D06-CH-Xerath et prérequis dans phase_package_prerequisites.json, sans acceptation présumée. Goal SYS-01.2-02 actif.

Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Plan/UI/bases/registres/goal/produit conservés.

## 2. Sources et provenance native

[V651](reference_requirement_trace_sources/xerath-passive-mana-surge-links-v651.json), 3087836octets/SHA `c2ac9df5dd8acfd45d209c43ab7a3e274ce019b153e6d29f17f3fdc34f93815d`, UTC hérité `2026-10-27T02:10:52.950997+00:00`. SOURCE : 18relations/12IDs, quatre INIBIN/quatre Lua/trois preload/font. Memberships concordants. Aucun DDF parmi les75 candidats vérifiés, sans absence universelle ; huit candidats exclus restent contextuels.

Xerath.inibin1798octets/SHA `87b047e4abf8bcfb2afbc453a19ac8f8baa913811867d97ae0ec5a9637db9e93` : alias XerathAscended2, icône Xerath_Passive1.dds ; Passive1/Desc/Level1..6 null, jamais zéro déduit. CharScript56octets vide ; Ascended219,OnHit220,BasicAttack119 sans callback enfant. Ascended/OnHit déclarent BuffName, texture, PersistsThroughDeath et Nondispellable ; aucune exécution serveur/lifecycle déduite. Les28 Lua sont entièrement consommés, avec13 limites NEWTABLE explicites.

Font miroir exact : nom4488,description4312,Ascended2948,OnHit2949. Le texte relie restauration aux attaques, période @f3@, montant @f1@ sur sbire/monstre et @f2@ sur champion. Aucun producteur de ces valeurs qualifié ; ni12secondes ni ratio2 adoptés.

resource_provenance : deux DDS sélectionnés sur E avant lectures SOURCE,6400octets. Xerath_Passive1 propre HUD2176octets,64×64 DXT1/mip0,membre0.0.0.196,SHA `7925c8d5c3d5d39f7d71fbf2634111c2589e91e5d41f73aefe62d02caabf27dc` ; AscendedForm partagé4224octets,DXT5/mip1,membre0.0.0.48,SHA `de7dfafe93ccd01fd436d5ec59827db6ec41d9957b5fa64ab3b6aab8b43a0e09`. Tailles/MD5/en-têtes concordent au manifeste0.0.1.7. Aucune métadonnée native relue ; priorité de montage et pixels/GPU ouverts.

## 3. Consommateurs actuels

29ancres sur13 fichiers hérités ;38fichiers code/configuration examinés,16communs et26identités V651 inchangés. Chemins réels : Attack→attacks.rs→lifesteal::basic_attack_hit, puis physique ; progression.rs pour statistiques, shop.rs::refresh_item_caps pour plafonds, consumables.rs pour potion, regeneration.rs pour régénération. lib.rs appelle consommables puis régénération puis attaques.

Barre Mana et MPStat existent dans native_hud_bars.rs/native_hud_widgets.rs. La provenance communautaire des ressources est distincte de l’INIBIN natif. Aucun hook Xerath/ManaSurge dans les seuls fichiers Rust examinés ; aucune absence universelle affirmée. Icône et état spécifique du passif restent sans binding qualifié. Profil d’attaque natif à distance, projectile2000, conservé.

## 4. Attendu, observé et vérifications

107/107 contrôles documentaires,93/93 en seconde passe séparée du même agent. Dix archives4186525octets ; RUN brut : deux diagnostics puis JSON intégral identique à OBS. BUILD/RUN0 hérités. Binaire6074880octets/SHA `be65856d09a098c84c8ca88142ba83eebdfaa18a1b31161576e83bb184f00ce6` hérité, non relu/rejoué ;1158dépendances non requalifiées. Aucun build,jeu,VM native,REA,réseau/GPU nouveau.

Deux cas Xerath niveaux1/18, Annie18 ; trois attributions XP diagnostiques, huit Move avec arrivée <1 et sans reprise. Achat public1027/2004 : solde825→390, maximum +200 nominal, mana courant conservé. Soustraction réelle au niveau1 :199,99996948242188, conséquence f32 ; au niveau18 :200. Placement hors rayon1000+100 de la fontaine actuelle ; ce rayon et la conservation du pool ne sont pas acceptés comme règles natives.

1111paires mana brutes recalculées :209 pendant les attaques,902 pendant les potions. Régénération0,04000000283122063/0,13066667318344116 par tick ; potion0,2222222238779068 pendant450 mises à jour puis une mise à jour après expiration par cas. Ordre et arrondis f32 expliquent exactement chaque paire ; déficit >50 pendant les attaques.

Six impacts fournissent six paires PV cible et six paires mana source liées aux frames. Régénération cible avant dégâts, armure Annie18 et physique recalculés ; projectiles2000. Soixante refus avec flags snapshot_unchanged, sans tous les snapshots bruts individuels. Total4599ticks, sans archivage de toutes les frames. Ces témoins ne qualifient ni disponibilité native ni montant de Mana Surge.

## 5. Écarts et anomalies conservés

**Correction de portée V651 : aucun relevé de potion n’atteint le plafond.** Fins439,6078796386719/516,9599609375 et1287,120849609375/1315,9599609375. La formule min existe ; sa branche de saturation n’est pas exercée. Ancien MD conservé, affirmation « avec saturation au maximum » non retenue ; aucun soin de mana effectif exactement100 déduit.

Ancien BUILD0/RustRUN101 : garde fontaine refusée avant achat/combat. Une seule ligne du collecteur change position800/8200→900/8550 et ajoute un diagnostic. Aucune réparation du moteur/navigation. Launcher1 décrit auparavant non fraîchement observé. f1/f2/f3,disponibilité,cooldown,lifecycle,sbires/monstres/bâtiments restent ouverts.

## 6. Corrections et conditions de reprise

- `COR-XERATH-MANA-SURGE-POLICY-01` : établir f1/f2/f3, disponibilité et cooldown sur source versionnée ; finir avec règles explicites et inconnues conservées.
- `COR-XERATH-ON-HIT-MANA-01` : relier impact et restauration qualifiée ; vérifier niveaux et catégories admissibles avec témoins régénération/potion.
- `COR-XERATH-READY-LIFECYCLE-01` : produire état prêt, consommation, recharge et transitions mort/réapparition selon politique établie ; vérifier synchronisation.
- `COR-XERATH-HUD-BINDINGS-01` : qualifier montage des deux DDS et lier icône/texte/état autoritaire ; vérifier rendu/transitions sans remplacer MPStat.
- `COR-XERATH-MANA-CAP-WITNESS-01` : ajouter un cas qui atteint réellement max_mana et dépasse sa marge ; vérifier plafond et expiration séparément, avec paires brutes attendues/observées.

Reprendre sur nouvelle source, consommateur modifié ou vérification nécessaire autorisée ; pas de recherche/recompilation inchangée. Prochain candidat : XinZhao.

## 7. Livraison et garde-fous

Rapport et seuls appendices CURRENT/HANDOFF publiables ; octets antérieurs archivés, sept documents protégés contrôlés avant/après. Preuves : E:/mapslol3v3/audit_sys01202_xerath_passive_hud_20261105, evidence_review/coherence_review, captures, journaux, result/publication/postpublication. Journaux Python instrumentés seulement, contexte/dispatch/empaquetage exclus, sans garantie OS/TOCTOU. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2286entrées sales groupées conservées. Aucune tâche complète,feature,inconnue ou acceptation close. Relecture du même agent, sans acceptation indépendante/humaine.
