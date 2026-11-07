# SYS-01.2-02 — Swain : sources et consommateurs VFX du passif, V1405

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-SWAIN-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et frontières

`CH-Swain-PASSIF-PRESENTATION-VFX`, `OLF-90babc5c-a265-5ad7-babb-3b1ee453df1b` : relier Carrion Renewal aux sources et consommateurs réels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK et consommateurs enregistrés conservés. Inconnues VFX OLU-40370bca-d9a3-5ddc-b9fd-8e675d119cf0 et SOURCE OLU-afe8a42c-369d-5f45-9045-f0a322571053 ouvertes. Prérequis D06/lot consultés sans satisfaction revendiquée. HUDV1277 réutilisé, sans seconde clôture HUD. Parent, QWER et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral du 2014-11-17 à 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Source `reference_requirement_trace_sources/swain-passive-carrion_renewal-links-v634.json`, 2485039 octets, SHA `a7bc4894393ce1007694787689aa5f8f27ae664a96ce884c6c821b3c9867e195`. Métadonnées réutilisées sans nouveau décodage natif : 49 identités, 147 associations, 31 sites ; 16 INIBIN, 17 Lua, 15 preloads et font. Aucun DDF parmi les candidats inspectés ; aucune absence mondiale déduite.

Définition : SwainDampeningFieldMana, SwainCarrionRenewal.dds, BaseMP chaîne "324.0", MPPerLevel chaîne "50", BaseStaticMPRegen numérique 1.2000000000000002. PARType, Passive1/description/niveaux absents. Font2735 : élimination d’un ennemi ordinaire → 9 + 1 par niveau ; champion éliminé ou assistance → à la place 9% du mana maximal. Description4284 omet cette seconde branche. Six BuffData, cinq correspondances exactes ; SwainDecrepify non résolu. f1/f2, éligibilité, arrondis et ordre restent inconnus. Miroir font inchangé, sans nouvelle analyse des lignes.

17 Lua : 14 initialisations littérales, 49 globals, trois limites NEWTABLE, zéro prototype enfant selon reçus ; chemins complets conservés. Dampening432 déclare dix globals, dont SpellDamageRatio=1, persistance/non-dissipation ; ces valeurs ne fournissent pas une formule de mana. CharScript56 vide ne produit pas un événement. MetaHeal/MetaHealTorment/MetaNuke254 restent refusés à NEWTABLEpc8. Metamorphism390 déclare SpellToggleSlot=4.0, sans bascule réelle démontrée. Aucun AutoBuff reconnu ne prouve pas l’absence native d’effets.

15 preloads : 5395 octets reconstruits exactement en CRLF depuis Discovery conservé ; 65 références (45 particules, 16 sorts, quatre personnages). Char251 précharge swaindampeningfieldmana, apbonusdamagetotowers et disintegrationbeam_cas. Dampening173 précharge swain_grand_buf.troy et neutralmonster_buf.troy. Noms grand/neutralmonster ne qualifient pas une règle de skin ou de cible. MetaHeal95 précharge swain_heal ; Metamorphism717 référence swainraven et effets de forme, dont swain_grand_metamorh_human.troy, orthographe conservée. Ces contextes QWER/soin restent distincts de Carrion ; dépendances ne signifient pas choix, création ou recette.

Un DDS E relu : DATA/Spells/Icons2D/SwainCarrionRenewal.dds, 2872 octets, 64×64 DXT1, sept mips, membre0.0.0.25, SHA885bbf42…. Identité de l’icône établie, lookup/provider/pixels ouverts ; aucun payload Troy ouvert. Mana courant : source_sha256 communautaire c817239c… distinct du natif c29940bd… ; PARType absent ne déclare pas Mana. Limites communautaires cadence Q, W, Torment et forme R conservées ; producteurs non retrouvés dans les scripts sélectionnés, sans absence globale ni exécution C#.

## 3. Consommateurs actuels

17 fichiers relus, dont 15 Rust et deux lecteurs Python ; 37 ancres exactes. Seize fichiers de frontières/SOURCE, 29 contextes, miroir font, 14 mécanismes VFX communs et deux fichiers d’animation ordinaire concordants. Le motif enregistré cible Swain/Carrion/DampeningField ; aucun producteur nommé dans ces 15 Rust, sans absence globale revendiquée.

champion_kills.rs:26/32 enregistre contributions, éliminations/assistances et événement, sans mutation mana. regeneration.rs fournit la régénération plafonnée ; shop.rs augmente la capacité via Saphir sans remplir le pool. spells.rs:120 refuse les capacités non implémentées. Fenêtre HUD Mana héritée après garde d’identité : fraction générique, sans présentation Carrion qualifiée. Les mécanismes communs ne démontrent ni recette, création/owner, pose, horloge, arrêt ou pixels.

## 4. Attendu et observé

Quatre essais conservés : base/Saphir × kill/assist. Capacités 324/524, deux achats1027 sans remplissage du mana courant. Événements réels et crédit kill/assist relus ; tous les acteurs niveau1. Attendu textuel champion : 29.16/47.16. Deux témoins plafonnés324 non discriminants.

Relecture ciblée actuelle : quatre paires mana au décès, calcul f32 de la régénération seule, crédits et capacité concordants à0.002 près. Saphir kill tick2437 : mana381.8123474121094, déficit142.18765258789062 ; assist tick2301 : mana376.3711853027344, déficit147.62881469726562. Espace supérieur à47.16, aucun bonus supplémentaire observé. Expression f32 illustrative47.160003662109375 conservée, sans politique native d’arrondi déduite. Sort Swain accepté non requis pour ce déclencheur.

2084 trames de combat et124 après décès réutilisées sans rejouer leur arithmétique complète. Ancien contrôle : 48 impacts, 28 projectiles Swain, 20 mêlées Garen, quatre morts, deux kills/deux assistances, 112 refus, 16 arrivées ; régénération1.2/s et plafond. Branche ordinaire et niveaux2–18 non exercés. PVcible/soins non entièrement reconstitués ; flags de refus sans garde NPC universelle.

40/40 contrôles documentaires, 72/72 cohérence même agent ; anciens91/91 et81/81 hérités. Six productions réussies, un premier collecteur échoué puis repris : HUD dans les29 contextes, hors17 entrées ciblées ; fenêtre qualifiée réutilisée après garde, originaux/journaux conservés. Une erreur racine d’encodage également conservée. BUILD/RUN historiques0 ; binaire6191104/SHAe4ef2c64… inerte. Aucun nouveau jeu exécuté.

## 5. Écarts et limites

Restitution manquante dans les deux cas discriminants. Branches, niveaux, attribution/assistances, ordre/arrondis, plafonnement, lifecycle, transport, recettes/payloads, lookup, création/owners/attaches/horloges/arrêts et pixels restent ouverts. Aucun nouveau build/jeu/natif/REA/GPU/réseau ; V564/Nami et autres clauses conservés. Cohérence même agent, aucune validation indépendante/humaine.

## 6. Corrections et reprise

corrections_and_restart.json réutilise quatre tâches SOURCE/SIMULATION/NETWORK/VFX : qualifier politique/recettes ; relier événement et restitution ; transporter montant/owner/horloge ; qualifier particules et consommateur réel. Fins : kill/assist/unités ordinaires, niveaux1–18, plafonds, refus/événements multiples, variantes, lifecycle, reconnexion et pixels selon contrat qualifié. Conserver régénération, Saphir et témoins plafonnés. Reprise sur source, mapping/callsite, recette/payload/capture précis, dérive ou autorisation fonctionnelle distincte. Aucun correctif produit exécuté.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_swain_passive_vfx_20261106 : evidence_review/coherence_review, gardes, journaux et collector_failure_resolution.json. next_lot.json cible Syndra, ligne de couverture vérifiée ; chercher ses audits existants.

Une unité de liaison bornée close ; zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. Rapport et ajouts CURRENT/HANDOFF seulement, après sauvegardes exactes et contrôle des sept protégés. Goal/Plan/UI/bases/registres/produit conservés.
