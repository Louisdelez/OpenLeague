# SYS-01.2-02 — Sion : Glory in Death et HUD, V1272

4 novembre 2026. Unité `AUD-SYS-01.2-02-SION-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Sion-PASSIF-PRESENTATION-HUD`, `OLF-db3e8ab3-f6ee-5fa9-b408-835b5230b732` : relier icône, texte et état réanimé aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false ; dépendance NETWORK et inconnue `OLU-1b892644-7886-56e7-ad17-10f351c4b7de` ouvertes. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/D06-CH-Sion consultés, sans satisfaction revendiquée. Parent PRESENTATION, QWER, cumul du W et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/sion-passive-glory_in_death-links-v629.json`, 4334760 octets, SHA `1b0ca07a579831d8a2242d1dd01916c1258b96c29d1227b09c802ab7f9452bfe`, UTC documentaire 2026-10-26T17:43:49.646218+00:00, sans attribution à l’heure d’exécution.

HUD enregistré : définition et CharScript, un catalogue. SOURCE : 156 relations, 150 identités, six sites/trois fichiers. V629 : 150 membres/450 associations, 26 sites/12 fichiers ; union 14 fichiers/32 ancres. Aucun ID SOURCE supplémentaire ; registres gelés conservés. Métadonnées réutilisées : 57 INIBIN, 66 Lua, 25 preloads, DDF et font ; aucune relecture native de ces métadonnées.

Base sélectionnée : PV 542.6400146, mana 275.6000061, AD 59.7200012, Passive1LuaName=SionPassive, icône Sion_Passive1.dds. PARType, Passive1 et six niveaux absents. CharScript racine vide ; DDF dans Localization. Quatre candidats absents ne prouvent aucun manque global.

`Characters/Sion/Spells/SionPassive.inibin` : 43 octets, SHA `c04b93841c6f06b58886a97b503675a88ff44462ea0233be1554ca2e3c998a7b`, distinct du fichier racine homonyme, 1254 octets, SHA `b865d50d7b2bb932609646e247520bc67367353e3a4776b2f2c66500dde5e65b`. Ce dernier, SionBerserk et SionMax portent 420 PV/50 AD ; sélection réelle inconnue, aucune statistique de zombie déduite.

Font 2644/4278 : réanimation, mouvement/attaque, perte rapide de PV, 100% vol de vie, bonus physique de 10% des PV maximum de la cible, plafond de 75 contre les monstres, remplacement des quatre sorts par Death Surge. Ne pas étendre ce plafond aux sbires. Zombie 2646 et Speed 2645 restent distincts. Les 37 occurrences BuffData donnent 19 résolutions exactes et 18 non résolues, sans alias.

Les 66 Lua n’exécutent aucun callback ; 21 limites NEWTABLE, notamment Passive/Delay/Zombie/Speed. Constantes et globals évalués restent distincts. DDF : 12 lignes/cinq liaisons Q/R/W, aucune formule de décroissance. Death Surge : Cooldown100, coût0, Effect1=100, Effect2=30, Effect3≈0.15, Effect4=0.1 ; rôles effectifs non qualifiés. Métadonnées étrangères Varus/Kassadin/Ziggs non adoptées.

63 références communautaires : délai2s, buff60s, formule de décroissance et accélération50%/1.5s ne constituent pas la politique native ; unités, décroissance et réentrance ouvertes. Mélange QWER antérieur/remanié et cumul du W conservés séparément.

Un DDS nécessaire : `DATA/Characters/Sion/HUD/Icons2D/Sion_Passive1.dds`, 2176 octets, 64×64 DXT1/mip brut0, SHA `9349106528ac10544fa4fc8b604c22896bccb176abea0c2df7c9d55c99357420`. Manifeste0.0.1.7, membre0.0.0.254, taille/MD5 concordants. Sélection E avant une lecture/stat SOURCE ; aucun autre DDS, aucune déduction depuis NEWTABLE. Lookup/provider/pixels ouverts ; font miroir inchangé, témoin Ahri réutilisé.

Ressource courante Mana : source_sha256 identifie le StatsJSON communautaire 4634 octets/SHA `dfe2043c02f7b9565641ed5b1592c73809a5ca79fbe6e112dbaf0f322b2c419d`, distinct de l’INIBIN 1415 octets/SHA `881fbc364101ca0e9d13745eefe56b08c62f857d88a6f5e6dbc021d009ef38d7` (`resource_provenance.json`). PARType absent n’est pas une déclaration native Mana.

## 3. Consommateurs actuels

32 ancres, 16 entrées communes et 27 fichiers code/configuration vérifiés. Aucun producteur nommé Sion/Glory in Death dans les Rust sélectionnés : recherche bornée. Lib.rs:603–604 refuse les commandes à PV≤0 ; damage.rs:115 programme la réapparition générique ; lifecycle.rs:33 restaure ensuite les pools à la fontaine. Les attaques appliquent dégâts physiques et soin génériques.

HUD : fractions santé/Mana, rangs, délais et permission PV>0 depuis snapshot ; icônes QWER du catalogue. Ces routes ne démontrent ni état réanimé, ni remplacement des quatre sorts, ni présentation du passif.

## 4. Attendu et observé

Attendu : transition réanimée, actions admissibles et HUD correspondants. V629 conservé : deux profils base/Rubis+150PV, 12 mêlées sortantes, 34 impacts physiques entrants, deux morts/réapparitions, six trajets, 144 refus dont 90 pendant la mort. Un achat Rubis, aucune vente/rachat.

PV maximum 542.6400146/692.6400146, mana275.6000061, AD59.7200012, cadence44, vol de vie0. Dégâts sortants50.0922546 ordinaires recalculés. Les 34 paires brutes PV avant/après entrants vérifient régénération, mitigation et clamp létal, tolérance0.002. Paires PVcible sortantes adjacentes absentes ; soin non qualifié, refus par flags, aucune garde NPC universelle.

Chaque fenêtre conserve 479 trames à zéro PV/position de mort, puis pools pleins/retour fontaine au tick480. Aucun intervalle réanimé. Trois séries de 15 commandes mortes refusées « champion dead » par profil, snapshots déclarés inchangés. Aucun sort Sion accepté.

Historique 15 fichiers/14539221 octets, 13 empreintes anciennes concordantes/deux identités nouvelles ; JSON brut RUN égal au relevé. Binaire 6149120 octets/SHA `2e29db3aaa74728ca85e3a5145e4194e6da41b2df30b304f0ff3533453ca6d27` inerte, BUILD/RUN0. Anciennes corrections du décompte18→19 et du libellé achat/vente conservées, sans rejeu.

Contrôles58/58, cohérence59/59 séparée du même agent. Tentative coherence01 sortie1 : variable d’historique masquée par la boucle DDS ; seul renommage de liaison dans v2, sortie0. Script/journaux initiaux conservés et différence exacte enregistrée. Aucun nouveau build/jeu/VM/REA/rendu/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Transition réanimée non observée ; délai, PV initiaux, cadence, décroissance, vitesse, ordre, sélection des variantes, fin/réentrance, vol de vie/bonus/cap, quatre emplacements, traductions, transport et pixels restent ouverts. V564/Nami et autres clauses conservés.

## 6. Corrections et reprise

Réutiliser les tâches SOURCE/SIMULATION/NETWORK/HUD. `COR-SION-GLORY-POLICY-01` : qualifier timing, statistiques, décroissance, sélection, ciblage, ordre et lifecycle. Fin : contrat historique traçable, sans promouvoir variantes ou règles communautaires.

`COR-SION-GLORY-LIFECYCLE-01` : implémenter vivant→mort→réanimé→mort et Death Surge. Fin : position, commandes, crédit de kill/minuterie, absence de boucle, attaques/soins/cap monstres et restauration QWER vérifiés, frontières comprises.

`COR-SION-GLORY-HUD-BINDINGS-01` : relier icône/texte, santé décroissante, états et quatre sorts temporaires. Fin : transitions, refus, transport et pixels observés. Reprendre sur artefact serveur/mapping/callsite nouveau, dérive ou autorisation fonctionnelle ; aucun correctif produit ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_sion_passive_hud_20261104` : evidence_review/coherence_review, DDS/histoire, resource_provenance.json, phase_package_prerequisites.json, résolution du diagnostic et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement, sauvegardes exactes/sept protégés contrôlés. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
