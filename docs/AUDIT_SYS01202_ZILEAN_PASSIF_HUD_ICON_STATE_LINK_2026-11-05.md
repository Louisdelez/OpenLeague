# SYS-01.2-02 — V1306 Zilean : Heightened Learning, expérience, portée et HUD

## 1. Périmètre et prérequis

2026-11-05,F:/OpenLeague. Unité `AUD-SYS-01.2-02-ZILEAN-PASSIF-HUD-ICON-STATE-LINK-01`,tâche `CH-Zilean-PASSIF-PRESENTATION-HUD`,exigence `OLF-e97e5651-942a-516a-b7c4-d7c580cc1f0d`,inconnue `OLU-7c059515-84ea-5d0a-86a7-0b8cf4f8a81e`. Audit documentaire borné du lien HUD terminé ;six contrats/questions conservés,HUD a_faire,implémentation/acceptation false,NETWORK ouvert. D06/D06-CH-Zilean et prérequis dans phase_package_prerequisites.json,sans acceptation présumée. SYS-01.2-02 actif.

Référence PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ;catalogue4.20.1 distinct. Goal/Plan/UI/bases/registres/produit conservés.

## 2. Sources et provenance native

[V657](reference_requirement_trace_sources/zilean-passive-heightened_learning-links-v657.json),2754977octets/SHA `2b4c9ba4c1751a0ef5a64d3c0026ab570a7588fadd24aaff1444b9f68149625f`,UTC hérité `2026-10-27T04:05:31.240081+00:00`. SOURCE9relations/6IDs :2INIBIN,2Lua,preload,font. Memberships conservés concordants. Zilean.inibin2259octets/SHA `753a4b05fe678a1fdf44d82e829004ad3ef4f7fe271b25b2c989069aef9425a6` :Heightened Learning/Chronokeeper_Slow.dds ;Passive1/Desc/Level1..6 null,pas zéro.

Font miroir exact4496/4320/1990 :8%XP supplémentaires à Zilean et aux champions alliés proches,rayon non donné. Heightened Learning.inibin51octets ne fournit que BuffData.DynamicTooltip. CharScript56vide ;HeightenedLearning.luaobj159 déclare BuffName avec espace et texture,sans callback. Preload heightenedlearning sans espace/minuscule :graphies conservées,sans réécriture ni résolution native automatique.

11Lua entièrement consommés,sans fonctions enfants ;trois limites NEWTABLE concernent d’autres capacités. Aucun DDF dans le seul périmètre découvert. Métadonnées/texte ne prouvent pas une aura serveur ni une mécanique récente de Zilean.

resource_provenance :Chronokeeper_Slow.dds propreInfo et partagéSpells/Icons2D,4224octets chacun,64×64 DXT5/mipmap_count0,membres0.0.0.40/0.0.0.25,même SHA `9c043740b469be55ea81f343964ddd29b2b8a1c53e0c7bdbb92fe820ad0af3dc`. Sélection E avant lectures SOURCE ;taille/MD5/en-têtes concordent au manifeste0.0.1.7. Métadonnées natives non relues. Montage/priorité/pixels/GPU ouverts ;aucune corruption inférée du nom Slow.

## 3. Consommateurs actuels

28ancres sur10fichiers hérités ;30fichiers code/configuration,16communs et18identités V657 inchangés. award_experience valide montant/destinataire,ajoute l’XP et applique les seuils ;world::damage_unit distribue partages et récompenses globales ;reward_champion_death appelle base_experience puis award_experience. Politiques locales documentées,sans adoption comme algorithme historique complet.

Aucun hook Zilean/HeightenedLearning dans les seuls fichiers Rust examinés. Le mot Learning seul,lié à l’apprentissage de sorts,n’est pas utilisé comme preuve du passif. LevelStat lit player.level du snapshot ;HP/Mana existants conservés,ressource locale Mana. Aucun binding qualifié d’icône,d’aura ou d’infobulle8%. Les gains/bonus XP ne sont pas déduits du seul affichage de niveau.

## 4. Attendu, observé et vérifications

326/326 contrôles documentaires,228/228 cohérence séparée du même agent. Cinq archives9482170octets,RUN JSON intégral identique à OBS,BUILD/RUN0 hérités. Binaire6144000octets/SHA `f52dbb8a3cd6da142d671fa65e6648d19331f56c0c8eff20b50ff7f4c0054d16` hérité,non relu/rejoué ;1158entrées non requalifiées. Aucun nouveau build,jeu,REA,VM native,réseau/GPU.

Quatre cas Zilean/Annie×allié proche/éloigné. Positions brutes redonnent200/6527,633789unités. Sixarrivées Move/Stop,sans reprise. Chaque destinataire commence niveau1/0XP,reçoit100 puis200 par API serveur :24paires XP brutes recalculées,48comparaisons d’autres joueurs inchangés,niveau2 à300XP. Ces API ne sont pas des commandes client ni une qualification des catégories natives du bonus.

À3052ticks,décès par API apply_damage True d’un sbire naturel,d’un TT_NWolf2,d’une tourelle et d’un champion :16événements,16paires PV fatales et48paires XP de destinataires recalculées. Le dommage létal ne prouve aucune attaque publique ni autorisation de portée.

Sbire64XP→32/32 proches ou64/0 éloignés ;monstre12au propriétaire ;tourelle70à chaque allié,proche ou éloigné ;champion niveau2→220au tueur. Données d’unités comparées à map10_world ;kill=(700−300)×0,55 en f32 selon le code courant. Les destinataires et montants des snapshots concordent,identiques avec Zilean et Annie,sans supplément8% observé. Le rayon1250 du partage de sbires ne qualifie pas la portée Heightened Learning.

Chaînes XP avant/après jusqu’aux endpoints finaux :propriétaire634/666,ennemi300,allié402/370,selon proximité. Aucun sort appris/lancé.60refus publics,52refus XP (zéro/négatif/NaN/infini/inconnu),16refus de cible déjà morte :flags d’invariance,sans toutes les paires brutes individuelles. 12208ticks=4×3052,sans toutes les frames.

## 5. Écarts et limites

Producteur8%,rayon/métrique,destinataires,cumul de plusieurs Zilean et application avant/après partage restent ouverts. Catégories d’XP,multiplicateurs/arrondis,XP excédentaire et limites de niveau non qualifiés. Manquent lifecycle vivant/mort/visibilité/connexion,entrée/sortie de portée,réseau et bindings HUD. Aucune fidélité native déduite des récompenses locales ou du contrôle Annie. Aucun échec nouveau dans les producteurs de ce lot.

## 6. Corrections et conditions de reprise

Réutiliser SOURCE/SIMULATION-CONTRAT/SIMULATION/NETWORK/PRESENTATION-HUD/ACCEPTANCE existants ;sous-objectifs proposés,aucune tâche ajoutée au registre :

- `COR-ZILEAN-NATIVE-AURA-POLICY-01` :qualifier rayon,catégories,cumul,ordre et exceptions sur source4.20 ;conserver chaque inconnue.
- `COR-ZILEAN-AURA-ELIGIBILITY-01` :lier présence/éligibilité à la politique qualifiée ;vérifier bornes de portée,alliés/ennemis,mort/reconnexion et plusieurs Zilean.
- `COR-ZILEAN-XP-MODIFIER-01` :appliquer8% au point qualifié ;vérifier séparément gains directs,sbires,monstres,structures,champions,partage et arrondis,avec témoin Annie.
- `COR-ZILEAN-ICON-PROVIDER-PATH-01` :qualifier alias avec/sans espace,montage Info/partagé et rôle du DDS ;vérifier chemin sélectionné sans substitution E/Slow arbitraire.
- `COR-ZILEAN-HUD-BINDINGS-01` :lier icône/tooltip/état d’aura à l’autorité serveur ;vérifier transitions et LevelStat,sans confondre XP totale et bonus.

Reprendre sur nouvelle source,consommateur modifié ou contrôle nécessaire autorisé. Prochain candidat :Zyra.

## 7. Livraison et garde-fous

Rapport et seuls appendices CURRENT/HANDOFF ;octets antérieurs archivés,sept documents protégés comparés avant/après. Preuves E:/mapslol3v3/audit_sys01202_zilean_passive_hud_20261105 :evidence_review,coherence_review,captures,journaux,result/publication/postpublication. Journal Python instrumenté seulement,contexte/dispatch/empaquetage exclus,sans garantie OS/TOCTOU. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2293entrées sales groupées conservées. Aucune tâche complète,feature,inconnue,acceptation ou goal clos ;même agent,sans acceptation indépendante/humaine.
