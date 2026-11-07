# SYS-01.2-02 — Xin Zhao : Challenge et consommateurs VFX, V1426

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-XINZHAO-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-XinZhao-PASSIF-PRESENTATION-VFX`, `OLF-5ac1d9ea-ccce-5184-abaf-ac17fe6178d6` :relier impact,armure,cible/durée et dépendances visuelles aux consommateurs réels. Contrat VFX,prérequis de phase/lot,consommateurs et inconnues préservés dans initial_scope.json. V652/HUD V1300 et corrections existantes conservés. Liaison close ne signifie ni passif,QWER,fonctionnalité ou goal terminés.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/xinzhao-passive-challenge-links-v652.json`,2794023octets,SHA `84fca0a5015a0defbb11b5095559726a3c57bdfa2da227fee26f30575acaeffe`,UTC documentaire2026-10-27T02:27:48.989165+00:00. Copies retenues dans E ;aucun accès renouvelé D ou F/OpenLeague-work.

Quatorze primaires :six INIBIN,trois Lua,trois preloads,DDF,font.35autres identités restent contextuelles ;neuf exclusions :cinq configurations bots,quatre recommandations d’objets. Définition2756octets,SHA `6a60a99dda517418b3dbdb36b1997e570cfcff938cb7df8b4d8d1c1282f5d58a` :XenZhaoPuncture/XinZhao_TirelessWarrior.dds. Passive1/Level1..6 absents,non zéro ;ancienne description MasterYi non adoptée.

17vues Lua héritées,lecture antérieure complète,zéro prototype enfant,quatre initialisations littérales,13limites NEWTABLE,10globals. Char56 vide ;Puncture195 porte XenZhaoPuncture/icône/persistance ;XenZhaoIntimidate.luaobj163 porte BuffName XinZhaoIntimidate et même icône. L’INIBIN est nommé XinZhaoIntimidate :graphies exactes conservées,sans renommage. Persistance distincte du lifecycle. Aucun AutoBuff reconnu dans ces vues,non-absence globale d’effet.

Font4489/4313/2946/2953 :Challenge15% d’armure pendant3secondes,cible unique,déclencheurs attaque ou Audacious Charge. BattleCryPassive2940 décrit le soin de troisième attaque du W,distinct. DDF16lignes,liens peuplés Q1,25AD/R1,0bonusAD seulement,non producteur Challenge. Ordre du premier impact et interactions d’armure non qualifiés. Identité font vérifiée sans reparcours sémantique complet.

Trois preloads relus depuis découverte :Char230/SHA `bd10b407a467de134b49a0653472d4e6b90a17bfe391612682e51d5f30dea1c2`,Puncture94/SHA `871306fd8d20389457bf435cc0832e21bf40e4dcb6858ea289d9c9bf5d778e68`,Intimidate104/SHA `9b4acbf4618919be8d6fb206c786e856c59276b4000c67eaae13fdb52a0f9e40`.428octets,cinq appels littéraux :Char déclare Puncture,BattleCryPassive et apbonusdamagetotowers ;Puncture déclare Intimidate ;Intimidate déclare **xen_ziou_intimidate.troy**. W/autres contextes non promus en passif. Aucune exécution/résolution typée complète ;préchargement distinct de création/attache/horloge.

Deux DDS relus uniquement dans E,2176octets chacun,64×64/DXT1/mips brut1,même SHA `c629b1cd3a0544f0e3a587c93c76f57e7faee596672942b0720f29f7640ff679`. Info membre0.0.0.40,Icons2D0.0.0.111,core0.0.1.7 hérité. Même contenu ne prouve ni priorité provider ni montage/pixels.

## 3. Consommateurs réels

Quatorze fichiers actuels,douze Rust/deux Python ;28ancres. Treize sources/frontières et36contextes concordants ;14entrées VFX communes et deux animations ordinaires inchangées.

command→advance_attacks→basic_attack_hit→apply_damage→penetrated_defenses/mitigate produit le physique. progression.stats/shop.bonuses fournissent armure/AD ;lib.rs739 régénération avant742 attaques. Chemins génériques conservés. Aucun producteur nommé dans les douze préfixes Rust examinés,conclusion bornée.

Barre Mana et MPStat acquis après garde d’identité ;provenance de ressource distincte de l’INIBIN natif. Aucun binding Challenge source/cible/texte/durée qualifié. Profil mêlée acquis,MissileSpeed20 reste métadonnée,sans projectile démontré. Owner/projection/animations génériques ne créent pas l’effet natif.

## 4. Attendu, observé et contrôles

Attendu :source exacte,consommateur ou manque borné,refus et reprise. Observé :chaîne déclarative et consommateurs reliés,producteur/rendu spécifiques non établis. **32/32 contrôles documentaires,56/56 de cohérence séparée du même agent.** HUD138/138 et122/122 hérités.

Quatre cas XinZhao1/18,Annie18,avec/sans1029 ;six attributions XP diagnostiques,huit mouvements/arrivées hérités. Achat public300,solde825→525,armure87,22000122070312→102,22000122070312 ;témoins sans achat825/87,22000122070312. PV conservés à l’achat,inventaires concordants,sans injection.

366calculs f32 PV/armure antérieurs réutilisés,sans recalcul. Douze impacts liés à leurs frames PV/armure relus,trois windups non critiques par cas,release concordante. Armure inchangée avant/après toutes les frames. AD57,5439987/113,6439972 et physique sans/avec objet30,7360325/28,4561348 au niveau1,60,7007790/56,1981964 au18 hérités. Physique,ordre d’arrondi et plafond de régénération expliquent les PV ;formule du collecteur parfois différente d’un ULP,tolérance0,004 héritée. Comparateur armure×0,85 explicitement diagnostique,non formule native acceptée.

Vingt relevés après combat relus,offsets0/89/90/91/95,armure inchangée.380ticks intermédiaires reconstruits antérieurement,non toutes frames brutes. Deuxième impact45/31ticks après premier,<90,preuve héritée. Sans activation,la fenêtre95ticks ne qualifie pas l’expiration native3s.108refus avec flags,non108paires brutes individuelles ;8334ticks non8334frames. E,transfert,autres catégories,lifecycle/réseau/rendu non exercés.

Ancien RUN564357octets et1158entrées non rouverts. Binaire6059520octets/SHA `ff455a74a110ebb1eb79e0ad7c453207359e1e5e5dde6ea3c4add002a6045a4e` inerte. Ancien refus d’inspection pub fn au lieu de pub(crate) fn :script anchorchecked capturé13626octets relu comme donnée,ancre réelle présente. Script/erreur bruts avant correction non récupérés ;aucune réparation moteur ni exécution déduite.

Six productions actuelles réussies,sans échec propre. Aucun nouveau build,jeu,décodage natif,REA,GPU,réseau ni acceptation humaine.

## 5. Écarts et inconnues

Premier impact,armure base/bonus/réductions/pénétrations/valeurs négatives,renouvellement/transfert,plusieurs lanceurs,mort,audiences et recette/owner/attache/provider/variante restent ouverts. **Le rendu Challenge reste non qualifié.** W,objet1029,persistance ou particule préchargée ne remplacent pas le passif. Aucune revue indépendante/humaine ou inventaire secondaire complet qualifié.

## 6. Corrections et reprise

corrections_and_restart.json :quatre clauses POLICY/ARMOR/NETWORK/VFX avec préconditions,fins et reprises. TARGET-STATE,E-TRIGGER,ICON-PROVIDER-PATH et HUD-BINDINGS existants préservés. Piste précise Puncture94/Intimidate104/xen_ziou_intimidate.troy,capture/callsite attribué,non recensement global répété. Implémentation sous autorisation distincte. next_lot.json vise Yasuo,consulter ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_xinzhao_passive_vfx_20261106` :sources,découverte/préchargements,fenêtres,impacts/endpoints,cohérence,corrections et journaux. Rapport et ajouts CURRENT/HANDOFF seuls publiables,sauvegardes exactes,sept registres protégés.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés ;SYS-01.2-02 actif.
