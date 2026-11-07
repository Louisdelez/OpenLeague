# SYS-01.2-02 — Thresh : Damnation et HUD, V1282

5 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-THRESH-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Thresh-PASSIF-PRESENTATION-HUD`, `OLF-f437a17c-cb50-511b-a2a5-4d81c8b00535` : relier âmes, collecte, statistiques permanentes, compteur et icône aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-d55f851f-f426-508e-91bf-6e8ea5b93143` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/D06-CH-Thresh consultés sans satisfaction revendiquée. Parent PRESENTATION, QWER et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/thresh-passive-damnation-links-v639.json`, 5476417octets, SHA `22b9c87cbc7c247b99bf80bd2285abd13fa6f9ea2e61ef807ba552ba5efb5bbc`, UTC documentaire 2026-10-26T20:55:22.367227+00:00, sans attribution à l’heure d’exécution.

HUD enregistré : une définition/un catalogue. SOURCE :168relations/164identités/six sites/trois fichiers. V639 :164membres/492associations,14sites/sept fichiers ; union neuf fichiers/20ancres, plus deux consommateurs HUD complémentaires. Aucun ID SOURCE supplémentaire ; registres gelés conservés. Métadonnées réutilisées sans relecture native :49INIBIN,67Lua,46preloads,DDF/font.

Définition ThreshPassiveSouls/Thresh_Passive.dds. Armor chaîne"16.0", ArmorPerLevel chaîne"0" ; BaseMP numérique273.9200134/croissance44. PARType absent. Ancienne description Jax/dégâts d’objets, textes mana et marqueurs3/7/11/15 non adoptés comme politique d’âmes. CharScript/Scripts vide56octets ; trois candidats alternatifs absents sans absence globale déduite.

Font2770/4289 : ennemis morts à proximité, collecte en passant près des âmes, gains permanents armure/AP, aucune croissance d’armure par niveau. Champions/grands sbires toujours, petits sbires parfois ; catégories de monstres, taux numériques et algorithme restent inconnus. Font2771 lie compteur f1, bonus f2, valeur suivante f3 ; font2772 décrit la poursuite des gains sans établir seuil, stockage/plafond ou arrondi serveur.

17BuffData :16résolutions exactes, plusieurs ThreshQPassive/Flay distincts de Damnation ; ThreshWZoneBuff non résolu, aucun alias automatique. Ancien ThreshPassive MR/dégâts de base, tooltips Ahri/Maokai et DDF Khazix non adoptés. DDF72lignes : seul KhazixW bonusAD×0.6 non vide, pas une formule d’âme. 67Lua sans fonctions enfants,14limites NEWTABLE ; persistance/preloads non preuves de lifecycle ou callbacks serveur.

54références communautaires comparatives : Q +1AP à l’impact ne constitue pas une collecte d’âme ; producteur ThreshLantern non retrouvé dans le sous-arbre choisi, pas d’absence globale déduite. E/R simplifiés non promus en règles natives.

Un DDS nécessaire `DATA/Characters/Thresh/HUD/Icons2D/Thresh_Passive.dds` :2872octets,64×64 DXT1/septmips, SHA `1a743b72ea63b5bb6b25ac5d8917761becec4b83f43011d98b331b3ee96e865b`. Déclarations Souls/Gain évaluées avec même icône. Projet RADS0.0.1.7/membre0.0.0.141, taille/MD5 concordants ; sélection E avant unique stat/lecture SOURCE. Aucun DDS étranger/particule lu. Provider/pixels ouverts ; font miroir et témoin Ahri réutilisés.

Mana courant : source_sha256 identifie StatsJSON communautaire 8663octets/SHA `da2ca6e9ff02fc8893f6af4feb633651641d2d8a1367ce08d3e6630bf4442bf7`, distinct de l’INIBIN natif 3499octets/SHA `b3d8fb0af7516a440bcd3a072b5f3bd80686afae148bb3139e2c290298b501f0` ; resource_provenance.json.

## 3. Consommateurs actuels

20ancres exactes,27fichiers code/configuration vérifiés,16entrées communes inchangées. Motif Thresh/Damnation borné exclut explicitement threshold/Threshold ; aucun producteur nommé retrouvé dans ce périmètre Rust.

progression.rs:68 applique statistiques base/croissance/objets ; croissance d’armure Thresh courante0. learn/next_rank et casts refusent Thresh. native_hud_ranks.rs:7 exclut aussi Thresh de maxima ; native_hud_learning.rs:9 appelle maxima puis next_rank. HUD Mana/rangs générique, pas un compteur Damnation qualifié.

damage.rs:53, champion_kills.rs:32 et world.rs:355 **damage_unit** sont les frontières réelles de dégâts/décès/récompenses. La branche d’unité morte contient déjà un receiver Trundle ; ce n’est pas un producteur d’âmes Thresh. Ces chemins sont inspectés statiquement et ne sont pas exercés par le diagnostic à zéro tick.

## 4. Attendu, observé et contrôles

Deux diagnostics hérités Thresh/Annie, niveaux1–18 :36attributions XP par API serveur, pas une progression naturelle ni un transport réseau. Aucun rang injecté directement. Courbe Map10, deltas XP et attribution1000 au plafond vérifiés :19245→20245, niveau18 conservé.

36relevés armure/AP recalculés selon la courbe locale. Thresh :armure16/AP0 aux18niveaux, conforme à la croissance native nulle. Annie :19.2199993→87.2200012/AP0, témoin de croissance locale. Ce contrôle sans événement d’âme n’établit aucun gain par âme ni formule historique d’arrondi ; aucune correction de la croissance nulle acquise n’est proposée.

144prédictions d’apprentissage comparées aux commandes : Thresh72Learn et144Cast/CastAt refusés,0/0/0/0 ; Annie18Learn acceptés/54refusés,5/5/5/3. Result<u8> du prédicteur distingué de Result<()> de Learn. Total278refus de commandes et10refus XP :slots invalides/joueur inconnu,zéro/négatif/NaN/infini. Snapshots bruts Thresh de chaque niveau inchangés par les commandes ; autres refus par flags, aucune garde NPC universelle.

Zéro tick, combat, décès, création ou collecte d’âme ; bonus permanents, proximité/lanterne et interactions non exercés. Les sorts Thresh refusés ne sont pas un prérequis général de la collecte par proximité ; la lanterne dépend de sa tâche W distincte.

Historique15fichiers/14533218octets,13empreintes anciennes/deux nouvelles. RUN brut identique au relevé ; binaire 5489152octets/SHA `2aa6a68fef42a6ad8254a9af20edfbac218bbee75a36c7524e4aad3cf50d4e75` conservé inerte, BUILD/RUN0 hérités.

Contrôles239/239 ; cohérence130/130 après correction ciblée du même agent. Préparation initiale arrêtée avant production sur un reliquat de nom/motif, original et correction conservés. coherence01=1/129sur130 : mon vérificateur cherchait à tort mark_unit_dead ; ancre réelle damage_unit vérifiée, seul contrôle corrigé et fenêtre de décès ajoutée, autres129inchangés. Logs/script/JSON initiaux et death_consumer_qualification.json conservés, qualification01=0. Aucun nouveau jeu/build/VM/REA/rendu/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Production/collecte d’âmes et bonus non qualifiés dans les consommateurs inspectés. Éligibilité, RNG, rayons/durée/visibilité, valeurs successives/f1f2f3, arrondis/limites, unicité, lanterne, lifecycle et présentation ouverts. QWER, V564/V606/Nami et autres clauses conservés.

## 6. Corrections et reprise

Réutiliser SOURCE/SIMULATION-CONTRAT/SIMULATION/NETWORK/HUD. `COR-THRESH-DAMNATION-POLICY-01` : qualifier catégories/taux/RNG, rayons, durée, valeurs/progression et f1/f2/f3. Fin : contrat historique sourcé, monstres et limites explicités sans valeur communautaire supposée.

`COR-THRESH-DAMNATION-DROP-01` : relier décès admissible à une âme autoritaire. Fin : génération, sources multiples, simultanéité, refus et déterminisme vérifiés ; réutiliser les frontières réelles sans confondre receiver Trundle et Damnation.

`COR-THRESH-DAMNATION-PICKUP-01` : collecte unique et attribution. Fin : proximité/limites/expiration, propriétaires multiples et répétitions vérifiés ; collecte lanterne avec prérequis W, sans bloquer le parcours proximité sur tous les sorts.

`COR-THRESH-DAMNATION-STATS-01` : conserver bonus permanents armure/AP. Fin : séquences/arrondis/limites et mort/reconnexion vérifiés ; préserver armure16/croissance0 déjà acquises.

`COR-THRESH-DAMNATION-HUD-BINDINGS-01` : compteur/bonus/valeur suivante/variantes et provider. Fin : transitions, transport, pixels, VFX/sons pertinents observés. Reprendre sur source serveur/callsite nouveau, dérive ou autorisation fonctionnelle ; aucune réparation produit ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_thresh_passive_hud_20261105` : evidence_review, coherence_review_corrected, qualifications, DDS/histoire, resource_provenance.json, phase_package_prerequisites.json et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes/sept protégés vérifiés à la publication. Une unité documentaire close, zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
