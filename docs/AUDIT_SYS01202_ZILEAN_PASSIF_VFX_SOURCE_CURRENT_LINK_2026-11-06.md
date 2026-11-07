# SYS-01.2-02 — Zilean : Heightened Learning, sources et consommateurs VFX, V1432

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-ZILEAN-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

Tâche `CH-Zilean-PASSIF-PRESENTATION-VFX`, exigence `OLF-f14b77d1-e48f-5114-96c2-3d535d446521` : relier aura/éligibilité, bonus d’XP et présentation applicable aux consommateurs réels. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues dans initial_scope.json. Source V657/HUD V1306 et corrections conservées. Cette liaison ne termine ni le passif, ni QWER, ni le goal.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus, catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/zilean-passive-heightened_learning-links-v657.json`,2754977octets,SHA `2b4c9ba4c1751a0ef5a64d3c0026ab570a7588fadd24aaff1444b9f68149625f`, UTC hérité2026-10-27T04:05:31.240081+00:00. Copies E retenues ; aucun nouvel accès D ou F/OpenLeague-work.

Six primaires :deux INIBIN,deux Lua,un preload,font ;27 identités liées restent contextuelles. Zilean.inibin2259/SHA `753a4b05fe678a1fdf44d82e829004ad3ef4f7fe271b25b2c989069aef9425a6` :Heightened Learning/Chronokeeper_Slow.dds. Passive1/Desc/Level1..6 absents, sans conversion en zéro. Heightened Learning.inibin51 ne fournit que BuffData.DynamicTooltip.

Onze vues Lua consommées entièrement antérieurement,zéro prototype enfant ;huit littérales,28globals,trois limites NEWTABLE dans d’autres capacités. CharScript56 vide ;HeightenedLearning159 déclare seulement BuffName=Heightened Learning et BuffTextureName=Chronokeeper_Slow.dds. Aucun AutoBuff direct reconnu ne prouve l’absence d’une présentation historique. Métadonnées distinctes de producteur d’aura ou callback serveur.

Un preload163/SHA `1f1b2e418bb05988e5eb233265b0be7dd2eae36c31cfc9533f486f8f0110c4d4`,deux appels littéraux relus depuis découverte :heightenedlearning et apbonusdamagetotowers. Nom avec espace dans caractère/INIBIN/BuffName, sans espace dans Lua/préchargement, graphies conservées. Aucune résolution native automatique, création d’effet ou sélection d’icône déduite.

Font4496/4320/1990 :8%XP supplémentaires pour Zilean et champions alliés proches ;rayon absent du texte. Aucun DDF dans le seul périmètre découvert, sans absence globale affirmée. Font contrôlée par identité, sans reparcours sémantique. Ne pas importer une mécanique récente de Zilean.

Deux DDS Chronokeeper_Slow4224 chacun,64×64/DXT5/mips brut0,même SHA `9c043740b469be55ea81f343964ddd29b2b8a1c53e0c7bdbb92fe820ad0af3dc`. Propre Info et partagé Spells/Icons2D relus dans E ;memberships40/25,core7 hérités. Nom Slow distinct d’une corruption prouvée ;provider/montage/priorité/pixels restent ouverts.

## 3. Consommateurs réels

Onze fichiers actuels,neuf Rust/deux Python,28ancres. Dix sources/frontières,30contextes,14entrées VFX communes,deux animations ordinaires concordants. award_experience valide montant/destinataire, ajoute l’XP et applique les seuils ;world::damage_unit partage ou attribue les récompenses ;reward_champion_death appelle base_experience et award_experience. Le partage générique lit config.experience_radius ;1250 dans les cas archivés ne qualifie pas le rayon natif du passif.

Aucun hook Zilean/HeightenedLearning dans les neuf préfixes Rust examinés, conclusion bornée. LevelStat lit player.level ;HP/Mana acquis après garde,ressource Mana de provenance distincte. Skill Learning concerne l’apprentissage des sorts. Affichage de niveau,icône et primitives owner/projection/animation ne démontrent pas un bonus d’XP ou un rendu dédié.

## 4. Attendu, observé et contrôles

Attendu :source exacte,consommateur ou manque borné,refus/reprise. Observé :métadonnées,XP et consommateurs reliés ;aura/rendu spécifiques non établis. **29/29 contrôles documentaires,57/57 de cohérence séparée du même agent.** HUD326/326 et228/228 hérités.

Quatre cas Zilean/Annie×allié proche/éloigné. Distances200/6527,633789 héritées, non portée native ;six arrivées Move/Stop héritées. 24 paires XP brutes de destinataires relues et48 comparaisons d’autres joueurs inchangés. Chaque destinataire reçoit100 puis200 par API explicite,niveau2 à300XP. Ces API ne sont pas des commandes client ni une qualification des catégories natives du bonus.

Seize décès par API serveur True,quatre catégories par cas :sbire naturel,TT_NWolf2,tourelle,champion. Seize paires PV fatales et48paires XP de destinataires relues. Des dégâts API ne prouvent ni attaque publique ni autorisation de portée.

Récompenses locales conservées :sbire64→32/32 proches ou64/0 éloignés ;monstre12 au propriétaire ;tourelle70 à chaque allié ;champion niveau2→220 au tueur. Gains Zilean/Annie identiques,sans supplément8% qualifié. Calculs f32/règles antérieurs réutilisés,sans recalcul ni qualification de l’algorithme serveur original. Formule locale du kill(700−300)×0,55 héritée. Endpoints propriétaire634/666,ennemi300,allié402/370 selon proximité,concordants aux snapshots.

60refus publics,52refus XP,16refus de cible déjà morte :128flags d’invariance, non128paires individuelles. Les 24attributions XP sont diagnostiques. Aucun sort Zilean appris/lancé.12208ticks=4×3052,non toutes frames.

Six productions actuelles réussies,sans échec propre. RUN2292385octets/1158entrées non rouverts ;binaire6144000/SHA `f52dbb8a3cd6da142d671fa65e6648d19331f56c0c8eff20b50ff7f4c0054d16` inerte. Aucun nouveau build,jeu,natif,REA,réseau ou GPU.

## 5. Écarts et inconnues

Producteur8%,rayon/métrique,destinataires,catégories,cumul/multiZilean,ordre avant/aprèspartage,arrondis,excédents/limites de niveau et lifecycle restent ouverts. **Le rendu Heightened Learning reste non qualifié.** Nécessité et forme d’une présentation spécifique restent à établir ;aucune absence universelle ou nonapplicabilité présumée. Owner/attaches/provider/variantes,réseau et son applicables non qualifiés. Pas d’inventaire secondaire complet ni acceptation indépendante/humaine.

## 6. Corrections et reprise

corrections_and_restart.json :quatre clauses POLICY/XP/NETWORK/VFX avec préconditions,fins/reprises ;AURA-ELIGIBILITY,ICON-PROVIDER-PATH,H​​UD-BINDINGS existants conservés. Qualifier une présentation applicable ou prouver sa nonapplicabilité, sans inventer un effet. Reprendre sur script/Troy/capture/callsite attribué ou consommateur modifié ;autorisation distincte pour implémenter. next_lot.json vise Zyra,consulter ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_zilean_passive_vfx_20261106` :sources,préchargement,fenêtres,24pairesXP/48comparaisons/16pairesfatales/48récompenses,cohérence,corrections et journaux. Rapport et ajouts CURRENT/HANDOFF seuls publiables,sauvegardes exactes,sept registres protégés. Journal Python des producteurs seulement ;contexte/dispatch/gardes/empaquetage exclus,sans garantie OS/TOCTOU.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés ;SYS-01.2-02 actif.
