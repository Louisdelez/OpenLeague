# SYS-01.2-02 — Talon : sources et consommateurs VFX du passif, V1407

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-TALON-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé sur ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et frontières

`CH-Talon-PASSIF-PRESENTATION-VFX`, `OLF-9ea2dbbf-38fb-5ec7-bb0a-69a7f19949cd` : relier Mercy aux sources et consommateurs réels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK et consommateurs enregistrés conservés. Inconnues VFX OLU-885d3a72-0661-5268-9f7e-03e18d61807f et SOURCE OLU-7d165723-1bb6-51f9-8911-efd7bf118784 ouvertes. Prérequis D06/lot consultés sans satisfaction revendiquée. HUDV1279 réutilisé sans seconde clôture ; parent, QWER et goal distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral du 2014-11-17 à17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/talon-passive-mercy-links-v636.json`, 2565517 octets, SHA `6c2188b39df436ba036d6a092398623df0951815cfd304147726a02361f8ac2f`. Métadonnées réutilisées sans nouveau décodage natif : 63 identités, 189 associations, 27 sites ; 21 INIBIN, 25 Lua, 15 preloads, DDF/font.

Font4286 : attaques de base +10% contre cible ralentie, étourdie, immobilisée ou sous suppression. Quatre BuffData résolus exactement, sans alias : DamageAmp/Surprise, Disappear, Slow, NoxianDiplomacyBuff ; aucun automatiquement assimilé à Mercy. Définition Passive1LuaName vide, icône TalonMercy.dds, PARType absent. Soin Warwick, textes mana40/60/80% et marqueurs1/6/11/16 restent héritages distincts. Miroir font inchangé, sans nouvelle analyse des lignes.

25 Lua : 22 initialisations littérales, 80 globals, trois limites NEWTABLE, zéro prototype enfant selon reçus ; chemins complets conservés. CharScript/Scripts114 déclare Wolfman_InnerHunger.dds. TalonMercy401 déclare BladeRogue_CheatDeath/22.dds, persistance et cinq champs AutoBuff vides. Ces données ne résolvent pas le provider et ne prouvent pas l’absence d’effets natifs.

Sept vues AutoBuff/17 champs : DamageAmp213 référence talon_E_tar_dmg ; QBuff387 référence deux mains R_Hand/L_Hand et Q_on_hit_ready. RakeMissileOneMarker/MisBuff contiennent des champs vides ; Toggle déclare BrewPoison/Global_Poison/head ; Slow déclare GLOBAL_SLOW.TROY. Q/E/R, Warwick, Jax et Zilean restent distincts de Mercy. DDF12 : quatre termes bonusAD Q0.3/1.2,W0.6,R0.9, aucune formule passive. Limites communautaires Q immédiat/totalAD, W impact simple, E silence, R0.75 et producteurs non retrouvés conservés, sans absence globale ni exécution C#.

15 preloads : 3682 octets reconstruits exactement en CRLF depuis Discovery conservé ; 48 références (18 particules, 27 sorts, trois personnages). Char155 précharge talonmercy ; aucun TalonMercy.preload parmi ces15, sans absence globale déduite. E281 précharge DamageAmp ; Q231/Bleed297 concernent on-hit/saignement. RakeMarker160 conserve l’orthographe bladergoue_bladeaoe_temp. RMarker419 référence variantes dragon/base/team_red ; aucune règle de skin/équipe ni création déduite. Ces arêtes ne qualifient pas une recette Mercy.

Un DDS partagé E relu : DATA/Spells/Icons2D/TalonMercy.dds, 5616 octets, 64×64 DXT5/sept mips, membre0.0.0.43, SHA8c54436b…. Lookup/provider/pixels ouverts ; aucun DDS Wolfman/22 ou payload Troy ouvert. Mana courant : source_sha256 communautaire396275b0… distinct du natifa597f428… ; PARType absent ne déclare pas Mana.

## 3. Consommateurs actuels

17 fichiers relus, dont16 Rust/un lecteur Python ; 31 ancres exactes. Seize fichiers de frontières/SOURCE, 34 contextes, miroir font, 14 mécanismes VFX communs et deux fichiers d’animation ordinaire concordants. Recherche Talon/Mercy/BladeRogue par mots : aucun producteur nommé dans ces16 Rust ; ancien MetadataLonger est une sous-chaîne de donnée de test, sans absence globale revendiquée.

attacks.rs/lifesteal.rs appliquent l’attaque physique générique ; damage.rs mitige ; slows/stuns et summoner_exhaust produisent les contrôles. Exhaust retire10armure, distinct du bonus. Annie/Pyromania fournit le stun public. Ordre Annie→régénération→attaques ordinaires réutilisé après garde d’identité. HUD Mana/rangs/cooldowns génériques et mécanismes VFX communs ne prouvent pas présentation Mercy, création/owner, pose, horloge, arrêt ou pixels.

## 4. Attendu et observé

Trois essais publics niveau1 conservés : slow, stun, cumul ; neuf attaques Talon avant/pendant/après, dix Q Annie, deux Exhaust, deux apprentissages Q, neuf arrivées sans réordre et84 refus. Aucun contrôle injecté ; sort Talon accepté non requis pour ce déclencheur d’attaque.

Relecture actuelle : trois impacts conditionnels, attribution cible/non-critique, flags de contrôle et comparaison arithmétique de mitigation vérifiés à0.002 près. AD55.2080002 ; armure27.5359993 ou17.5359993 sous Exhaust. Stun seul : ordinaire43.2881699, observé43.2881775, comparaison textuelle Mercy47.6169891. Slow/cumul : ordinaire46.9711418, observé≈46.97113–46.97115, comparaison51.6682587. Écarts discriminants>4.32 ; aucun bonus observé. Comparaison réelle arithmétique, sans politique historique d’arrondi/ordre déduite.

Calcul des neuf paires PV avec régénération/plafond/Perseverance et dix impacts Annie hérité, sans rejeu intégral. Paires PV adjacentes aux impacts Q Annie non enregistrées ; tous leurs termes ne sont pas reconstruits indépendamment. Contrôles expirés observés, sans preuve d’expiration d’un buff Mercy produit. Root/suppression/critiques/on-hit/frontières non exercés. Refus par flags, aucune garde NPC universelle.

Ancien CharScript supposé56/vide : un contrôle106/107 corrigé en114/Wolfman, autres106 inchangés, revérifiés ; ressource non réparée, métadonnées inchangées. Ancien107/107 et108/108 réutilisés. Premier BUILD0/RUN101 sur l’ordre des opérations conservé ; variante order distincte BUILD/RUN0. Historique combiné25 fichiers, dont22 initiaux/trois suppléments ; deux identités binaires inertes. Variante order6063616 octets/SHAc012eaf9…, aucun payload EXE rouvert.

46/46 contrôles documentaires, 71/71 cohérence même agent, six productions journalisées réussies. Erreur racine de chemin daté consignée : rapport publié le5, preuves conservées sous20261104 ; reprise sur le chemin explicite. Aucun nouveau jeu exécuté.

## 5. Écarts et limites

Bonus conditionnel non observé ; classification exhaustive, types d’attaque/cible, ordre/arrondis, interactions et lifecycle ouverts. Présentation Mercy distincte présente ou absente non qualifiée ; provider, recettes/payloads, lookup, création/owner/pose/horloge/arrêt, transport et pixels ouverts. Aucun nouveau build/jeu/natif/REA/GPU/réseau ; V564/Nami et autres clauses conservés. Relecture même agent, aucune validation indépendante/humaine.

## 6. Corrections et reprise

corrections_and_restart.json réutilise quatre tâches SOURCE/SIMULATION/NETWORK/VFX : politique et existence d’une présentation dédiée ; bonus au bon impact ; événement conditionnel attribuable ; ressources/consommateurs seulement s’ils sont sourcés. Fins : slow/stun/root/suppression, cumul sans double bonus, expiration/frontières, cibles/critique/on-hit/refus, lifecycle, synchronisation et comparaison visuelle selon contrat qualifié. Documenter une absence dédiée si prouvée ; ne pas inventer un effet Mercy. Conserver Exhaust/régénération/Pyromania séparés. Reprise sur source, mapping/callsite, recette/payload/capture précis, dérive ou autorisation fonctionnelle distincte. Aucun correctif produit exécuté.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_talon_passive_vfx_20261106 : evidence_review/coherence_review, gardes, qualifications héritées, histoire combinée et journaux. next_lot.json cible Taric, ligne de couverture vérifiée ; chercher ses audits existants.

Une unité de liaison bornée close ; zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. Rapport et ajouts CURRENT/HANDOFF seulement, après sauvegardes exactes et contrôle des sept protégés. Goal/Plan/UI/bases/registres/produit conservés.
