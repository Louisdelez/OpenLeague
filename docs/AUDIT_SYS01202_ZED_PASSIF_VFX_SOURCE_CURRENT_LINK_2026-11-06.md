# SYS-01.2-02 — Zed : Contempt for the Weak, sources et consommateurs VFX, V1430

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-ZED-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

Tâche `CH-Zed-PASSIF-PRESENTATION-VFX`, exigence `OLF-98486f8f-bad4-5e1f-8811-c2c013dcf99f` : relier seuil, bonus, récupération par cible et effets déclarés aux consommateurs réels. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues conservés dans initial_scope.json. Source V655 et HUD V1304 réutilisés. Ce résultat ne termine ni le passif, ni QWER, ni le goal.

## 2. Sources et provenance

Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau et déploiement inconnus. Catalogue 4.20.1 distinct. Source `reference_requirement_trace_sources/zed-passive-contempt-links-v655.json`, 3289727 octets, SHA `022a8305ff1b4c992b73e0cde26b15006c0aded462831fbb207d72fafd31be8f`, UTC documentaire hérité 2026-10-27T03:25:08.172512+00:00. Copies E retenues ; aucun nouvel accès D ou F/OpenLeague-work.

Seize sources primaires : cinq INIBIN, sept Lua, deux preloads, DDF et font. 93 identités liées restent contextuelles. Zed.inibin : 2028 octets/SHA `0fa7bf92de960df7d36cfb257b779c7527e25bf8be4ba73db213d27352ac0d5c`, alias ZedPassiveToolTip, icône shadowninja_P.dds. Passive1/Desc/Level1..6 absents, sans conversion en zéro.

49 vues Lua héritées, entièrement consommées antérieurement, sans prototype enfant : 37 littérales, 69 globals, douze limites NEWTABLE. CharScript56 vide ; ToolTip135 déclare nom/persistance, CD148 nom/texture. Passive225 déclare AkaliTwinDisciplines.dds et AutoBuffActivateEffect=Zed_Passive_Stage1.troy. NewPassive/NewPassive2,112 octets chacun, nomment ZiggsPassiveReady.dds. Trois vues AutoBuff/quatre champs distinguent ce passif, RShadowBuff/Clone_Idle avec bone déclaré et Slow/GLOBAL_SLOW. Ces contextes ne forment pas une recette universelle ; persistance, noms de bone et métadonnées ne prouvent ni callbacks ni pose.

Deux preloads relus depuis découverte : Char1023/SHA4af59bc5 et NewPassive91/SHA598ef116, 1114 octets/17 appels littéraux. Char nomme ToolTip, WPassiveBuff, Shadow, émotes et effets d’ultime ; NewPassive→NewPassive2. Leurs textes et empreintes complètes sont dans evidence_review.json. Préchargement et alternative d’icône ne prouvent ni sélection effective ni création de Stage1.

Font4494/4318/2988/2987 : cible sous50%PV, bonus magique6–10%PVmax, @f1@, une fois par cible toutes10secondes ; marqueur CD distinct. Strength of the Shadow2996 est le W. DDF72 lignes/17 liaisons peuplées conserve Akali et coefficients QWER, sans formule passive. f1, paliers et ordre natif restent inconnus. Font contrôlée par identité sans reparcours sémantique.

Trois DDS relus dans E,64×64/DXT1,7920 octets : ShadowNinja_P2872/mip7/SHA5c48281e, AkaliTwinDisciplines2872/mip7/SHA3664dcef, ZiggsPassiveReady2176/mip1/SHA22eef7e1. Identités complètes en preuves ; memberships134/25/71 et core7 hérités. Graphies shadowninja_P/ShadowNinja_P conservées ; alias étrangers restants, priorité provider, montage et pixels non qualifiés.

## 3. Consommateurs réels

Treize fichiers actuels, onze Rust/deux Python,26 ancres. Douze sources/frontières,33 contextes,14 entrées VFX communes et deux animations ordinaires concordent avec les empreintes héritées.

command→advance_attacks→basic_attack_hit→apply_damage, penetrated_defenses/mitigate et stats existent ; régénération avant attaques. healing::heal sert aux préparations diagnostiques. Aucun hook Zed/Contempt dans les onze préfixes Rust examinés : conclusion bornée, sans absence universelle affirmée.

HPBar/HPStat acquis ; ressource Energy, sans alimentation des éléments Mana actuels. Aucun binding qualifié pour bonus f1, disponibilité, source/cible ou CD. Owner/projection/animation génériques ne créent pas le passif. Profil mêlée acquis ; MissileSpeed467 reste métadonnée, sans projectile passif démontré.

## 4. Attendu, observé et vérifications

Attendu : source exacte, consommateur ou manque borné, refus et reprise. Observé : liens déclaratifs et frontières actuelles établis, producteur/rendu spécifiques non établis. **31/31 contrôles documentaires et57/57 de cohérence séparée du même agent.** HUD142/142 et175/175 hérités.

Six cas Zed1/18 contre Annie18, ratios60/50/40%. Dix-huit relevés d’impact relus : PV début de tick, après régénération et après physique ; releases non critiques concordantes, résidu<0,004. Calculs f32 antérieurs conservés sans recalcul : AD54,7120018/112,5120087, physique29,2233753/60,0961494, armure87,2200012. Aucun bonus magique qualifié dans ces cas.

Deux cas ont exactement901,8399658203125PV après régénération, avant physique ; au début du tick les PV sont inférieurs à la moitié. Cela ne démontre pas l’ordre du prédicat natif. Huit préparations PV par API, explicites, ne sont pas des attaques ennemies naturelles ; aucune injection de champ direct.

Dix-huit relevés de fenêtre299/300/301ticks relus. Reconstruction f32 des intervalles intermédiaires héritée, non toutes frames brutes. Sans proc initial qualifié, ces relevés ne prouvent pas l’expiration du cooldown. Impacts suivants relatifs46/312 au1,30/309 au18 hérités.

Six paires PV d’API magique20 relues, distinctes du passif. Post-mitigation15,3846158981 et variation PV15,3846435547 héritées ; comparateurs6–10% diagnostiques, non formule native. 162 refus publics et18 API ont des flags d’invariance, sans180paires brutes individuelles. Neuf XP diagnostiques, douze Move/Stop hérités ;13362ticks=3×2230+3×2224, non toutes frames.

Six productions actuelles réussies, aucun échec propre. RUN589910 octets et1158entrées non rouverts ; binaire6072320/SHA `e580595bc1b87ab5f6010e531f0c7f44d8fe269e5dee1c1624f854f9b0ef1d83` inerte. Aucun nouveau build, jeu, natif, REA, réseau ou GPU.

## 5. Écarts et inconnues

f1, paliers, ordre seuil/régénération/physique/magique, égalité, catégories, plusieurs lanceurs, cible/CD, mort/reconnexion et sélection/recette/owner/attache/provider/variantes restent ouverts. **Le rendu Contempt reste non qualifié.** W, contrôle API, Stage1 déclaré et variantes d’icônes ne remplacent pas le passif. Aucun inventaire secondaire complet ni acceptation indépendante/humaine qualifiés.

## 6. Corrections et reprise

corrections_and_restart.json : quatre clauses POLICY/ONHIT/NETWORK/VFX avec préconditions, fins et reprises. PER-TARGET-CD, TARGET-CD-HUD, ICON-PROVIDER-PATH et HUD-BINDINGS existants conservés. Reprendre sur source/callsite/capture attribuée ou consommateur modifié ; autorisation distincte pour implémenter. next_lot.json vise Ziggs, consulter ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_zed_passive_vfx_20261106` : sources, textes de préchargement, fenêtres, impacts/API/préparations/relevés, cohérence et journaux. Rapport et ajouts CURRENT/HANDOFF seuls publiables, sauvegardes exactes, sept registres protégés. Journal Python des producteurs seulement ; contexte/dispatch/gardes/empaquetage exclus, sans garantie OS/TOCTOU.

Une unité de liaison close ; zéro tâche VFX, fonctionnalité, inconnue, acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
