# SYS-01.2-02 — Udyr : Monkey's Agility et consommateurs VFX, V1414

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-UDYR-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Udyr-PASSIF-PRESENTATION-VFX`, `OLF-f4acbe9c-c5f7-5fdf-be44-605503f574d0` : relier marqueur persistant, bonus temporaire, postures et dépendances visuelles aux consommateurs actuels. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues conservés dans initial_scope.json. V644/HUD V1287, admission/rangs des postures et leurs corrections restent acquis. QWER complet, présentation complète et goal demeurent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Source `reference_requirement_trace_sources/udyr-passive-monkeys-agility-links-v644.json`,3049492 octets,SHA `5dd530bb041507d5c4fdb0cd3edf49231947b79bdfa48796f89d79088247ae72`. Inspection et diagnostic retenus dans E ; aucun accès natif/F/OpenLeague-work renouvelé.

Quinze ressources primaires :sept INIBIN,trois Lua,trois preloads,DDF,font. Trois chunks directs identifiés parmi36 vues Lua héritées ;78 autres identités restent du contexte non promu. Lecture antérieure complète sans enfant,14 initialisations littérales,22 limites NEWTABLE,52 globals. CharScript56 vide.

Définition UdyrPassiveBuff/Udyr_MonkeysAgility.dds ; Passive1/Desc/niveaux absents. UdyrMonkeyAgility387 déclare UdyrPassiveBuff,BlindMonk_FistsOfFury.dds,persistance/non-dissipation. UdyrMonkeyAgilityBuff329 déclare son propre nom et Udyr_MonkeysAgility.dds,sans flag de persistance dans ce chunk. Marqueur et bonus temporaire restent distincts. Aucun AutoBuff reconnu dans les36 vues ;aucune absence globale d’effet conclue.

Font2826 décrit entrée en posture,+10 % AS,+5 déplacement pendant5 secondes,max3 cumuls ;2825 décrit le bonus avec SourceName ;nom4472/description4296 conservés. Rafraîchissement,horloges communes/indépendantes,mort et choix d’image non qualifiés. Miroir font vérifié par identité,sans reparcours sémantique.

MaxLevels=[5,5,5,5],y compris Phoenix ;coûts47/44/41/38/35,Cooldown1..5=6 secondes,champs de rang6 absents. Ni délai partagé ni portes d’apprentissage déduits. DDF4 lignes :deux liens Tiger attackdamage×.15 et1.2/1.3/1.4/1.5/1.6,sans producteur AS/MS du passif. Marqueurs communautaires de postures non promus en logique native.

Trois préchargements,1794 octets d’identités/rôles hérités :CharScript1522 → chaîne Monkey/visuel/audio ;MonkeyAgility179 → bonus et particule audio SpiritGuard ;Buff93 → dépendance udyrbuff. Texte brut et références typées non reconstitués dans les copies sélectionnées ;rôle audio SpiritGuard distinct d’une règle universelle de variante. Reprise précise :Buff93/SHA `9b50b3a8dd739c825d2c8b077830473c1c1ea98adea991a9fe278ff6a33145df` ou Monkey179/SHA `8bab2ef50c77abd6a0302e2cf4704fcfeddc0a9861d27696e566b45e73398ca4` attribué.

Trois DDS HUD relus dans E,4224 octets chacun,64×64 DXT5 :Udyr propre/shared,mips bruts1,SHA `4e59ff73417895a2a43b1e4eda4660f1b6a66cad8c479ebdf03672128e1c56be` ;BlindMonk partagé,mips brut0,SHA `3aae5582034f193c0ab9220c473ecd68c2301e99b3d299f3c286ea9e204516b6`. Membership hérité ;deux contenus ne qualifient ni priorité provider ni texture de particule/pixels. Provenance StatsJSON distincte de l’INIBIN conservée.

## 3. Consommateurs réels

Huit fichiers actuels,dont six Rust et deux lecteurs Python ;19 ancres. Sept sources/frontières et27 contextes inchangés ;14 entrées communes VFX et deux liens d’animation ordinaire concordants.

next_rank/learn refusent Udyr ;cast/cast_at renvoient les erreurs de logique non implémentée. Fenêtres réelles et messages archivés concordent. Aucun producteur nommé dans six préfixes Rust de production ;conclusion bornée.

L’unique ancien hit nommé est dans un test native_hud_ranks,non exécuté ici. Le prédicat HUD déjà qualifié slot3/rang>3 est réutilisé après garde du fichier :écart statique pour Phoenix4/5,aucun échec de rendu reproduit avec posture admise. Mana/PV,widget Ezreal,projection/owner/ressources et animations génériques ne constituent pas le passif Udyr.

## 4. Attendu, observé et contrôles

Attendu : conserver sources/refus,établir producteur ou manque borné et conditions de présentation. Observé : marqueur/bonus et dépendances reliés ;activation,état et rendu spécifiques non établis.

34/34 contrôles documentaires,46/46 de cohérence séparée du même agent. HUD114/114 et76/76 hérités. Deux paires complètes initial/final relues :égales,au tick0,niveaux1/18. Dix-sept refus par cas :Learn/Cast/CastAt et frontières invalides. Les34 flags individuels sont conservés,sans prétendre à34 paires brutes. Aucun champ directement injecté ;un apport XP diagnostique100000,aucune progression naturelle qualifiée.

Rangs0000,move_speed345 et attack_cooldown_ticks46/32 sont des statistiques calculées,pas des déplacements/cadences mesurés. Aucune posture acceptée,aucun cumul amorcé ni aucune expiration Udyr testée.

Témoin Garen Q hérité :statistique345→455.600006→345,retour à45 sur46 ticks,deux refus. Flags dérivés de tick<45,sans preuve de retrait d’objet buff. Il ne qualifie ni AS Udyr ni ses5 secondes. Sommaires préservés,sans rejeu de simulation,ancien RUN79665 ou1158 entrées. Binaire6010880 octets,SHA `16d599de2aae5df4d28cf3eb2e320ddb55e932acf653a3247b43c5c9e350f559`, identité inerte.

Aucune production actuelle échouée. Aucun nouveau build,test Rust,jeu,décodage natif,REA,GPU,réseau/audio/rendu ni restauration des snapshots privés V644.

## 5. Écarts et inconnues

Admission,schéma de rangs,cumuls,réactivation,refresh/GCD,ordre AS/MS,lifecycle,audiences,owner/attache,recette/variante et pixels restent ouverts. **Le rendu du bonus temporaire reste non qualifié.** Un marqueur persistant ou un témoin Garen ne remplace pas un bonus Udyr produit.

Aucune revue indépendante/humaine ni qualification de l’inventaire secondaire complet. Durée native textuelle connue,politique complète et expiration effective inconnues.

## 6. Corrections et reprise

corrections_and_restart.json contient quatre clauses :POLICY-01 qualifie règles/présentation ;STATE-01 produit le bonus depuis une entrée réelle ;NETWORK relie transitions/audiences ;VFX relie la présentation qualifiée au consommateur. Préconditions,fins et reprises précises. STANCE-ADMISSION,STANCE-RANK-SCHEME et HUD-BINDINGS existants sont référencés,sans exiger tout le kit avant un premier cas du passif.

Reprendre sur source/capture/callsite nouveau ou dérive ;implémentation soumise à autorisation distincte. next_lot.json vise Urgot :consulter ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_udyr_passive_vfx_20261106` :projections,fenêtres,comparaisons de snapshots,identités,corrections et journaux. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF,avec sauvegardes exactes et sept registres protégés.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés. SYS-01.2-02 reste actif.
