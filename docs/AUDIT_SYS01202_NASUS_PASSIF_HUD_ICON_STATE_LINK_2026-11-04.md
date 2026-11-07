# SYS-01.2-02 — Nasus : Soul Eater et HUD, V1251

4 novembre 2026. Unité `AUD-SYS-01.2-02-NASUS-PASSIF-HUD-ICON-STATE-LINK-01` ;audit de liaison statique,fonctionnalité et acceptation distinctes.

## 1. Exigence et périmètre

`CH-Nasus-PASSIF-PRESENTATION-HUD`,`OLF-54a5e003-a9c0-58eb-b217-cd4f33ee2bd6` :icône,texte,rang applicable,vol de vie et soin attribuable au passif. Fiche requise a_faire,implémentation/acceptation false,dépendance NETWORK ;inconnue `OLU-aeb30e89-1238-5903-8488-784649f4499c` ouverte. Six contrats/inconnues HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE conservés ;phaseD06/lotD06-CH-Nasus/prérequis consultés sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ;catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/nasus-passive-soul-eater-links-v607.json`,2108031octets,SHA `67da44a3edb29011d14388b8bba0856b8f24b17151012ae03cdf20fcca5f8dda`,UTC documentaire2026-10-26T10:52:51.808057+00:00,pas un horaire d’exécution.

HUD :définition+CharScript client(non corps serveur),un catalogue/un consommateur. SOURCE44relations/32IDs/6sites/3fichiers ;V60732sources/96associations,28sites/56liens/15fichiers ;union17fichiers/34ancres. Métadonnées/INIBIN/Lua/font D réutilisés sans relecture.

NasusPassive/Nasus_Passive.dds ;Soul Eater4414,description4238,tooltip2691 `@f1@% bonus Life Steal`. f1,paliers,combinaison avec objets/runes/maîtrises inconnus :aucune valeur moderne ni déficit chiffré. Six niveaux et SpellData sélectionnés absents≠zéro. Passive1Desc parle de PV Singed selon mana,PassLev1Desc2 de réduction magique10% Singed ;octets conservés,sans adoption.

Six BuffData,cinq clés exactement résolues,`game_buff_tooltip_NasusQ` absent du miroir en_GB contrôlé,sans remplacement par NasusQStacks.24DDF :deux entrées Q/SiphoningStrikeNew f1=@stacks×3,22vides ;ce n’est pas f1 de Soul Eater.12Lua :sept littéraux/cinq limites NEWTABLE,aucun callback serveur démontré ;CharScript natif/communautaire vides. NasusPassive expose icône/nom/PersistsThroughDeath/NonDispellable,pas une politique de soin ou de respawn. Sept preloads dont particule de vol de vie,alias Chronokeeper/Slow sans mécanique étrangère. Cinq absences de chemins bornées ;aucun NightmareBot sélectionné dans les emplacements inspectés.

Seize références communautaires non natives :Q dégâts de sort immédiats et hausse AD globale sur mort,non qualification d’attaque renforcée/stacks Q ;E commentaire d’armure sans application dans le corps lu ;R non qualifié par ses seuls timers/bonus. Aucun consommateur Rust ou serveur original déduit.

Inventaire E avant payload :un chemin nécessaire/2176octets,lu une fois par SOURCE.

| Chemin | Octets | En-tête | Membre lol_game_client0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/Nasus/HUD/Icons2D/Nasus_Passive.dds | 2176 | DXT1 64×64, mip brut0 | 0.0.0.188 |

SHA `6e4d1bc5fcfb928a8499f462484709584c4fe01ef3396f7587b8d5f4ec4007aa`,membership/MD5/SHA identifiés,lookup/variante/pixels ouverts ;mip brut0 n’est pas une corruption démontrée. Scope champion/partagé appliqué. Font miroir identique au témoin Ahri. Type courant Mana,PARType natif absent ;source_sha256 correspond au JSON communautaire5481octets,distinct de l’INIBIN natif2059octets/SHA05d13f5dc9ca… (`resource_provenance.json`). Historique18fichiers/11296831octets,16hashes anciens concordants/2identités nouvelles. Cas V540 antérieurs non fusionnés avec V607.

## 3. Consommateurs actuels

34ancres exactes/16entrées communes inchangées vérifiées. `progression.rs:99` définit life_steal exclusivement avec items.life_steal.max(0.). `lifesteal.rs:19–23` traite une attaque acceptée,lanceur vivant,cible non structure,puis amount=outcome.post_mitigation×stats.life_steal et heal. Aucun ajout Nasus dans ce consommateur. `healing.rs:9–14` combine des modificateurs génériques Ignite/Trundle,non exercés ici.

Catalogue/initialisation/actions/dégâts/régénération/objets/cibles/snapshots inspectés. Recherche nommée bornée Nasus/SoulEater sans hit dans les Rust épinglés,pas une absence globale. HUD Mana/MPStat/PV (`native_hud_bars.rs:9–11`,`native_hud_widgets.rs:91`) peut porter des valeurs génériques,mais n’établit ni f1 ni attribution au passif ;module Ezreal non consommateur Nasus. Aucun HUD Soul Eater complet établi,sans capture GPU.

## 4. Attendu et observé

Attendu :bonus natif sourcé ajouté au vrai taux,attaque admissible produisant un soin attribuable,puis présentation fidèle. Hérité V607 :trois cas sans objet/Épée+10AD/Sceptre+10AD8%,AD59,18/69,18/69,18,taux0/0/8%. Neuf mêlées sortantes,neuf physiques entrantes,trois AnnieQ,540ticks d’attente,81refus,six trajets sans reprise.

Les attaques ordinaires exercent bien le candidat de passif. Le refus des sorts Nasus n’explique donc pas l’absence du bonus inhérent. Les neuf paires PVpropres avant/après,moins la régénération médiane observée(0,06008911PV/tick),donnent0/base,0/Épée et4,64218140/Sceptre,attendu objet4,64217377 ;écart<0,002. Hypothèse bornée :niveau/objets/régénération constants et PV non plafonnés. Le soin du Sceptre ne qualifie pas Soul Eater ;le déficit historique n’est pas quantifiable sans f1.

Attentes avec PV/attendu ;dégâts cible/Q sans paire pré-impact adjacente ;refus avec flags/erreurs sans paires brutes. Gardes joueurs/statuts/winner ne prouvent pas l’exclusion universelle des NPC. Binaire historique6117888octets,SHA `ea72220339e31457412145cd44d824d7a247a64a74fca2b02cf9deb088ac01b3`,inert ;BUILD/RUN bruts0. Première découverte mal nommée DynamicTooltip et inspection refusée sur NasusQ conservées comme contexte historique ;codes numériques d’inspection non établis par reçu ici.

Contrôles actuels49/49,relecture séparée47/47,même agent,pas de revue humaine/agent indépendante. Aucun nouveau build/jeu/VM/REA/réseau/rendu/audio/GPU.

## 5. Écarts et inconnues

Bonus Nasus absent du chemin de statistiques audité ;f1/progression/cumul natifs inconnus. Cibles/structures/monstres,Q renforcé/critiques,mitigation/boucliers/surdégâts,anti-soin/amplification,lifecycle/vente/réseau/HUD ouverts. Clé NasusQ manquante,provenance du registre et divergence communautaire à traiter sans substitution. Limites V564 et deux trajets Nami restent ouvertes,non reproduites ni attribuées à Nasus.

## 6. Corrections et reprise

Réutiliser `CH-Nasus-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION :résoudre f1/paliers/combinaisons puis intégrer le bonus au taux réellement consommé dans progression/lifesteal. Qualifier cibles,soin à PVpleins/manquants,dégâts nuls,Q/critiques,boucliers,anti-soin,vente/niveaux/mort/respawn,attribution/transport/HUD. Clarifier la provenance et la clé Q sans renommage inventé. Reprendre sur preuve4.20/callsite/mapping nouveau ou dérive ;le vol de vie d’objet reste un acquis distinct.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_nasus_passive_hud_20261104` :evidence_review/coherence_review,resource_provenance,phase_package_prerequisites,DDS/histoire/journaux. Identités conservées avant assertions(témoin hook7/7 réutilisé),captures explicites F/OpenLeague-work ;exclusions Python/contexte/bootstrap/inventaire final et limites TOCTOU déclarées. Relecture de cohérence séparée,aucune acceptation humaine.

Publication documentaire :rapport et ajouts CURRENT/HANDOFF,deux sauvegardes,sept protégés avant/après/readback. Une unité bornée close,zéro tâche/feature/inconnue/acceptation close. Fidélité humaine À VALIDER ;SYS-01.2-02 actif/partiel,goal/Plan/UI/bases/registres/produit inchangés.
