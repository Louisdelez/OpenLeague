# SYS-01.2-02 — Taric : sources et consommateurs VFX du passif, V1408

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-TARIC-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé sur ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et frontières

`CH-Taric-PASSIF-PRESENTATION-VFX`, `OLF-ef4fb9c4-b6a7-5bf4-941b-20c3bf9b1c91` : relier Gemcraft aux sources et consommateurs réels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK et consommateurs enregistrés conservés. Inconnues VFX OLU-4b3b6858-61ed-5dfe-90a4-f5170c32a637 et SOURCE OLU-c62dd155-0a62-58b2-ac09-18bc5c47b0c9 ouvertes. Prérequis D06/lot consultés sans satisfaction revendiquée. HUDV1280 réutilisé sans seconde clôture ; parent, QWER et goal distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral du 2014-11-17 à17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/taric-passive-gemcraft-links-v637.json`, 3880179 octets, SHA `9667a4d8f2f524c62e927f00662f0dae8a76442195ffc24e3ceb40043c5e5113`. Métadonnées réutilisées sans nouveau décodage natif : 42 identités, 126 associations, 26 sites ; 16 INIBIN, 14 Lua, 10 preloads, DDF/font.

Définition : Passive1LuaName=Gemcraft, GemKnight_Gemcraft.dds, ancienne description Singed/PV selon mana distincte. PARType/Passive1/six niveaux absents, sans conversion en zéro. Mana349.0799866, croissance56. BuffData Gemcraft1943 : après un sort, prochaine attaque avec dégâts magiques f1, f2% d’armure et réduction des délais de2s. Description4287 et Gemcraft.Description9443 mentionnent armure/après-sort/délais.

Gemcraft.DynamicTooltip11543 parle du mana maximal ; priorité de dispatch inconnue, aucun choix par majorité des textes. TaricGemcraftBuff.DynamicTooltip11935 décrit Radiance/R, distinct de son BuffData2753. Trois bindings réutilisés exactement après garde d’identité du miroir font, sans nouvelle analyse des lignes. Neuf BuffData/huit résolutions, ShatterAura répété ; HammerSmash non résolu, sans alias automatique. f1/f2, assiette, progression, sélection et consommation non qualifiés.

14 Lua : neuf initialisations littérales, 58 globals, cinq limites NEWTABLE, zéro prototype enfant selon reçus ; chemins complets conservés. Gemcraft409 déclare dix globals dont icône/persistance/non-dissipation ; CharScript56 vide ne produit pas un scénario. TaricGemcraftBuff616 reste non évalué à NEWTABLEpc22 : bluehands_buf et noms L_Buffbone_Glb_Hand_Loc/R_Buffbone_Glb_Hand_Loc sont des constantes, pas des mappings qualifiés. HammerInternal469, weapon/Taric_HammerInternal, reste non évalué àpc18.

Deux vues AutoBuff/sept champs reconnus : Radiance750 déclare HammerFlare sur deux BUFFBONE_CSTM_WEAPON et ShoulderFlare/spine ; RadianceAura contient un effet vide. Ce contexte R ne devient pas Gemcraft. Champs Tantrum/Amumu, ZyraQ, Judicator et OpalHarmony restent distincts. DDF12 : Shatter armure×0.12/0.2/0.05, Imbue bonusPV×0.07, aucune formule Gemcraft. Scripts communautaires Gemcraft/CharScriptTaric non retrouvés dans le sous-arbre inspecté ; absence globale non déduite. QWER communautaires non exécutés.

10 preloads : 1808 octets reconstruits exactement en CRLF depuis Discovery conservé ; 23 références (12 particules, 11 sorts). Char466 précharge sept sorts dont Gemcraft, TaricGemcraftBuff et HammerInternal. Gemcraft103 référence taric_gemstorm_tar ; HammerSmash313 référence aussi cette particule et Radiance. HammerInternal105 utilise le nom lowercase taric_hammerinternal. Aucun preload TaricGemcraftBuff parmi ces10, sans absence globale déduite. Dépendances partagées ne prouvent pas alias, recette, création ou attache.

Un DDS partagé E relu : DATA/Spells/Icons2D/GemKnight_Gemcraft.dds, 4224 octets, 64×64 DXT5/un mip, membre0.0.0.25, SHA8c099eae…. Lookup/provider/pixels ouverts ; aucun payload Troy ouvert. Mana courant : source_sha256 communautaire3a683fc6… distinct du natif4af9c866… ; PARType absent ne déclare pas Mana.

## 3. Consommateurs actuels

16 fichiers relus, dont14 Rust/deux lecteurs Python ; 32 ancres exactes. Quinze fichiers de frontières/SOURCE, 30 contextes, miroir font, 14 mécanismes VFX communs et deux fichiers d’animation ordinaire concordants. Aucun producteur nommé Taric/Gemcraft dans ces14 Rust ; recherche bornée, sans absence globale revendiquée.

attacks/lifesteal appliquent l’attaque physique générique ; shop ajoute l’armure d’objet ; progression expose les statistiques. Les chemins learn/cast/cast_at refusent Taric. cooldown.rs:10/11 transforme une réduction en pourcentage en durée : cette fonction ne démontre pas une soustraction déclenchée de2s. HUD Mana/rangs/cooldowns et mécanismes VFX communs ne qualifient ni prêt/consommation, recette, lookup, création/owner, pose, horloge, arrêt ou pixels.

## 4. Attendu et observé

Attendu : état après sort, impact magique, consommation et réduction déclenchée. Deux profils conservés base/Tissu1029 : armure25.8759995→40.8759995, AD57.8800011 inchangé, AP0 final. Aucun sort Taric accepté, aucun déclencheur Gemcraft appliqué : proc et réduction de2s non exercés. Délais enregistrés à zéro, non discriminants pour une réduction ; augmentation d’armure seule ne teste pas un scaling de proc.

Relecture actuelle : un impact ordinaire par profil, dégâts attendus/observés≈48.54889 concordants à0.002 près, Mana plein et rangs/délais source nuls. Cinq relevés boutique vérifient inventaire vide→Tissu→vide→Tissu, armure +15 puis retour à la base, AD stable. AP n’apparaît pas dans ces lignes boutique : valeur finale seulement. 362 relevés au repos gardent Mana plein/AD stable ; attente181ticks sans état produit ne qualifie pas son expiration.

Douze impacts non amorcés, cadence48ticks et360 paires PV adjacentes au repos restent hérités sans rejeu arithmétique complet. Paires PV adjacentes aux impacts non enregistrées ; chaque terme PV non reconstruit, soin non qualifié. Quatre trajets sans réordre, 54 refus par flags, aucune garde NPC universelle.

44/44 documentaires, 67/67 cohérence même agent, six productions journalisées réussies. Ancien69/69 et72/72 réutilisés. BUILD/RUN historiques0 ; binaire6077952/SHA7d1d70fb… inerte, sans lecture/empreinte actuelle du payload. Aucun nouveau jeu exécuté.

## 5. Écarts et limites

Dispatch armure/mana et bindings f1/f2 non établis ; activation/consommation, dégâts renforcés, soustraction2s et sorts admissibles ouverts. Bases/cibles, ordre/arrondis, cumul, lifecycle, provider, recettes/payloads, création/owner/attache/horloge/arrêt, transport et pixels non qualifiés. Aucun nouveau build/jeu/natif/REA/GPU/réseau ; V564/Nami et autres clauses conservés. Relecture même agent, aucune validation indépendante/humaine.

## 6. Corrections et reprise

corrections_and_restart.json contient cinq clauses dans les tâches existantes : politique/dispatch ; état prêt/proc magique ; réduction déclenchée des délais ; événements réseau ; consommateurs VFX. Les corrections COR-TARIC-GEMCRAFT-ARM-PROC-01 et COOLDOWN-01 restent distinctes. Pour les délais : valeur positive avant impact, réduction2s, plancher/horloge/ordre/CDR et cas exclus ; zéro initial insuffisant. Pour le proc : sort admis selon QWER, prochain impact/consommation, contrôles armure/mana, cibles/refus/arrondis. Pour VFX : transitions, variantes, owners/poses/lifecycle, erreurs et pixels selon recette qualifiée. Reprise sur source, mapping/callsite, recette/payload/capture précis, dérive ou autorisation fonctionnelle distincte. Aucun correctif produit exécuté.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_taric_passive_vfx_20261106 : evidence_review/coherence_review, bindings contradictoires, gardes et journaux. next_lot.json cible Teemo, ligne de couverture vérifiée ; chercher ses audits existants.

Une unité de liaison bornée close ; zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. Rapport et ajouts CURRENT/HANDOFF seulement, après sauvegardes exactes et contrôle des sept protégés. Goal/Plan/UI/bases/registres/produit conservés.
