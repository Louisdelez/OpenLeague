# SYS-01.2-02 — V1295 Vladimir : Crimson Pact, conversions et HUD

## 1. Périmètre et prérequis

2026-11-05, F:/OpenLeague. Unité `AUD-SYS-01.2-02-VLADIMIR-PASSIF-HUD-ICON-STATE-LINK-01` ; tâche `CH-Vladimir-PASSIF-PRESENTATION-HUD`, exigence `OLF-89645e84-31e5-5b74-b2d3-aa105761bf44`, inconnue `OLU-f772304d-c834-56c2-81ec-09f4a3f679dc`. Audit documentaire borné terminé ; tâche HUD, source/simulation/réseau, fonctionnalité, inconnues, acceptation et goal ouverts. Les six contrats sont conservés, HUD a_faire/implementation_complete=false/acceptance_complete=false, dépendance NETWORK ouverte. Phase D06, lot D06-CH-Vladimir et prérequis D01 détaillés dans phase_package_prerequisites.json, sans acceptation présumée.

Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Aucun goal, Plan/UI/base, registre, code produit ou asset modifié.

## 2. Provenance native et limites

[V545 conservé](reference_requirement_trace_sources/vladimir-passive-conversion-links-v545.json),458118octets/SHA `b08147763be77aa64bbce1b7c3d60b83344bdfbe82639696e3f92ebc0d950af4`, horodatage hérité `2026-10-25T18:09:45.799776+00:00`. SOURCE dix relations/sept IDs ; deux INIBIN, deux Lua, deux preload et font, membership antérieur concordant. Vladimir.inibin3474octets/SHA `d3e3d3bdc05cc93425fe41f0839e73fbb4a17f7da2894b4a32636d0e54cfefcd`.

Passive1LuaName/BuffName=VladimirBloodGorged, icône Vladimir_BloodGorged.dds. Lua224octets : nom, texture, PersistsThroughDeath/NonDispellable ; CharScript56octets vide, zéro callback enfant dans les deux. Preloads restent des dépendances déclarées, sans exécution serveur. Passive1 absent, BaseMP nombre0/MPPerLevel chaîne"0" conservés. Vieux texte Ryze, AP30/45/60 et niveaux1/6/16 non adoptés comme règle actuelle.

Font miroir exact, noms/description/buff aux4481/4305/2905 :40PV bonus→1AP et1AP→1,4PV bonus, sans cumul du passif avec lui-même ; placeholders f1/f2 présents, fournisseurs non établis. Texte et métadonnées ne démontrent ni ordre serveur, arrondis, multiplicateurs ni lifecycle.

resource_provenance : deux DDS exacts, propres Info et Spells/Icons2D, sélection E avant lecture SOURCE,5744octets. Même SHA `77b487be32f7a92ee47630c378348d1a9d4b395c116e39e6a223d8d9f5d94d7a`,64×64 DXT1/mip7, membres0.0.0.25 du manifeste choisi0.0.1.7. Tailles/MD5/SHA/en-têtes concordants. Aucune métadonnée INIBIN/Lua/font native relue, aucune énumération D par root ; identité commune ne prouve ni priorité d’alias ni rendu GPU.

## 3. Consommateurs réels

Seize ancres héritées sur six fichiers,27fichiers code/configuration ;16communs et15identités V545 inchangés. Le chemin actuel relie join→Buy/Sell→shop::bonuses→stats→refresh_item_caps ; advance_passive_gold finance le scénario. shop.rs additionne séparément PV et AP ; progression.rs:87 expose l’AP des objets multipliée par les autels. Aucun producteur Crimson Pact identifié dans les fichiers Rust examinés, sans prétendre à une absence universelle.

Le HUD générique existe : native_hud_bars.rs:10 consomme health/max_health ; native_hud_widgets.rs:90 affiche HPStat depuis les capacités autoritaires. Classification locale de ressource="None", donc pas de barre de mana. Ces consommateurs sont conservés ; aucune liaison f1/f2 ou présentation spécifique Vladimir n’est qualifiée. source_sha256 du catalogue de ressources diffère de l’INIBIN natif : provenances distinctes.

## 4. Attendu, observé, vérifications

114/114 contrôles documentaires corrigés,76/76 cohérence séparée du même agent. Sept archives1375927octets ; RUN brut identique à OBS, anciens BUILD/RUN0. Binaire historique6005760octets/SHA `6257760d18d26dfbf10447f89b692f5ff34864220a3f6465b88248714d51f388` seulement identifié, non relu/rejoué ;1158dépendances non requalifiées. Aucun build, jeu, VM native, REA, GPU ou réseau nouveau.

Deux ordres1052→1028 et1028→1052 pour Vladimir, deux cas Ahri témoins. Pour chaque cas,36relevés bruts : initial, premier achat, financement, deux objets,30ticks stables, deux ventes. Les144relevés sont recalculés depuis les inventaires et le catalogue. Au niveau1, Vladimir observe692,7999877929688PV/20AP, contre prédiction textuelle non récursive720,7999877929688PV/23,75AP ; les28PV et3,75AP supplémentaires sont absents. Ahri observe664,4000244140625PV/20AP ; les prédictions du collecteur générique ne deviennent pas une règle Ahri.

Or initial825, prix435+400 ; deuxième achat refusé, puis financement public8or aux2250/2400, sans injection. Solde après achats6, après ventes591 ; capacités initiales restaurées. Trente relevés stables consécutifs2401–2430 par cas,120au total. Les9720ticks simulés ne sont pas tous archivés en frames brutes ; cadence d’or locale non équivalence historique. Vingt refus : quatre commandes comparées en groupe avant/après, puis refus d’or insuffisant comparé séparément ; pas de snapshots bruts de chaque état intermédiaire.

Une conversion absente et stable ne valide pas la politique non récursive. Autres niveaux, sources de bonus, ordre avec autels, arrondis, mort et transitions restent ouverts.

## 5. Anomalies conservées

Ancienne inspection échouée sur le descripteur F passive_gold_rules, seul E recensé ; inspection qualifiée_v2 et identité F conservant l’origine E réutilisées, sans nouvelle migration ni correction de jeu.

Reprise actuelle initiale refusée : Git renvoyait des champs nuls sous restriction d’accès. Nouvelle observation explicitement en lecture seule et bootstrap_v2 réussis, main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2282entrées sales groupées conservées. Vérificateur initial110/114 : quatre attentes avaient cinq cases au premier achat. Qualification distincte construit six cases depuis l’ordre d’achat ; seules ces attentes sont corrigées,110autres contrôles et tous les autres champs exacts. Originaux/scripts/journaux/échecs gardés, aucun test de jeu rejoué.

## 6. Corrections et conditions de reprise

- `COR-VLADIMIR-CRIMSON-PACT-POLICY-01` : qualifier base d’entrée, non-récursivité, arrondis, ordre avec multiplicateurs et fournisseurs f1/f2 ; finir avec source ou contrat local versionné, limites explicites.
- `COR-VLADIMIR-STAT-CONVERSION-01` : ajouter les deux conversions sans réinjecter leurs propres résultats ; vérifier les deux ordres d’achat et les totaux attendus, Ahri témoin sans bonus.
- `COR-VLADIMIR-STATE-REVERSAL-01` : recalculer après vente et changements qualifiés ; vérifier restauration et absence d’accumulation, puis niveaux/mort selon source établie.
- `COR-VLADIMIR-HUD-BINDINGS-01` : relier icône, capacités réelles et f1/f2 à l’état du passif ; vérifier affichage et transitions, conserver HPStat/barres existants.

Reprendre sur une nouvelle source primaire, un consommateur modifié ou un test nécessaire autorisé. Les archives actuelles ne sont pas à rejouer sans cause nouvelle. Prochain candidat : Volibear.

## 7. Livraison et garde-fous

Rapport et appendices CURRENT/HANDOFF seuls publiables ; anciens octets sauvegardés et sept documents protégés comparés avant/après. Preuves E:/mapslol3v3/audit_sys01202_vladimir_passive_hud_20261105 : evidence_review original/corrected, correction d’attentes, coherence_review, captures DDS/histoire, journaux, result/publication/postpublication. Journaux limités aux producteurs Python instrumentés ; contexte exploratoire, dispatch et empaquetage final exclus ; sans garantie OS/TOCTOU. Relecture du même agent, sans acceptation indépendante/humaine. Zéro tâche complète, inconnue, feature ou acceptation close.
