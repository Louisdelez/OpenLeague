# SYS-01.2-02 — Olaf : Berserker Rage et HUD, V1256

4 novembre 2026. Unité `AUD-SYS-01.2-02-OLAF-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre ; implémentation, vérification du gameplay et acceptation humaine restent distinctes.

## 1. Exigence et périmètre

`CH-Olaf-PASSIF-PRESENTATION-HUD`, `OLF-bbb1874d-d012-557d-96c5-88db67f76ea0` : relier icône, texte, rang applicable, bonus lié aux PV manquants et présentation aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-54356d8e-8649-56c9-8e29-c9ce4ef27d5a` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et leurs inconnues conservés. Phase D06/lot D06-CH-Olaf/prérequis consultés, sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/olaf-passive-berserker-rage-links-v612.json`,2200260 octets,SHA `c1c2c898946f8ad1fae1ce42f82bdbe25ef342f2ccd620abc6030f4808d2fa21`,UTC documentaire 2026-10-26T12:21:42.104731+00:00,sans attribution à une heure d’exécution.

HUD :définition+CharScript client,un catalogue. SOURCE :50 relations/44 identités,six sites/trois fichiers. V612 :44 sources/132 associations,24 sites/48 liens/13 fichiers. Union :15 fichiers/30 ancres. Aucun ID SOURCE supplémentaire. Métadonnées natives réutilisées sans réouverture D.

La ressource s’appelle exactement `OlafBerzerkerRage`,icône Olaf_Passive.dds. Berzerker ne devient pas automatiquement Berserker. BuffData2426/description4247 :1% de vitesse d’attaque par1% de PV manquants. Formule d’intégration,cumul,plafonds,arrondis et moment du recalcul inconnus. Passive1/Passive1Desc absents ; niveaux1/4/7 non adoptés comme progression.

20 Lua :neuf littéraux/11 limites NEWTABLE ; neuf preloads,trois BuffData et quatre tooltips QWER liés. CharScripts natif/communautaire vides. Drapeaux PersistsThroughDeath/NonDispellable ≠ politique mort/respawn. DDF8lignes :Q bonusAD×1,W health×0,01,six vides ; le coefficient W n’est pas une formule du passif.

Deux fichiers RagnarokPassiveBuff90octets ont les mêmes SHA à deux chemins,priorité runtime inconnue ; passif de R distinct du passif du champion. Cinq candidats absents,dont alias Berserker, sans manque global ni corruption déduits. Dix-huit références communautaires non adoptées :Q projectile commenté/1,1ADtotal contre1bonusAD natif ; E coût25%PVcourants contre30%dégâts/remboursement décrits ; R ajoute des défenses et30AD contre perte du passif défensif/40AD natifs. Ni serveur original ni consommateurs Rust.

Un DDS nécessaire :`DATA/Characters/Olaf/HUD/Icons2D/Olaf_Passive.dds`,2176octets,64×64 DXT1,mip brut0,membre0.0.0.174 du manifeste lol_game_client0.0.1.7 ; SHA `b8dfa22f817f1a656f899f305f95cd9454885ece4f0f781861f11f61efa556b4`. Taille/MD5 concordent ; inventaire E avant lecture SOURCE unique. Lookup/variante/pixels ouverts,mip0 non déclaré corrompu.

Font miroir identique au témoin Ahri. Mana courant,PARType natif absent ; source_sha256 correspond au JSON communautaire4675octets,distinct de l’INIBIN natif1753octets/SHAe12249c9162de8933082152d43a80e1549c336f60e62ca65bdd61caef46229a1 (`resource_provenance.json`).

## 3. Consommateurs actuels

30 ancres exactes,16 entrées communes et29 fichiers code/configuration vérifiés. Recherche Olaf/Berzerker/BerserkerRage sans hit dans ces Rust,sans absence globale revendiquée. Catalogue,stats,commandes,attaques,dégâts,régénération,objets,cibles et snapshots inspectés.

`progression.rs:119–128` calcule attack_cooldown_ticks depuis base,croissance,objets,Trundle/Ezreal,Exhaust,puis arrondi/minimum12 ; aucun terme Olaf/PV dans cette expression. Ce plancher générique n’est pas accepté comme règle historique d’Olaf.

`attacks.rs:284–326` transmet stats→cadence→windup/next_attack ; les intervalles observés correspondent. HUD Mana/MPStat/PV et module Ezreal ne démontrent ni bonus Berserker Rage affiché ni liaison dynamique complète de l’icône/tooltip.

## 4. Attendu et observé

Attendu :variation native de vitesse selon PVmanquants,réellement consommée par les attaques et présentée au HUD. Hérité V612 :deux cas base/Dague1042+15%AS,AD59,98/PVmax597,24.18 mêlées,six impacts physiques entrants,deux QAnnie,240ticks de récupération,54refus,quatre trajets aboutis sans reprise.

Trois séries par cas :pleine vie,blessure,récupération. Débuts/libérations d’attaque et ratios1−PV/PVmax recalculés. Douze intervalles :six43ticks sans objet,six37ticks avec Dague. Ratios0à pleine vie,26,1–29,1%manquants ensuite ; cadence constante dans les trois phases. Le bonus Dague est exercé ; celui du passif manque au chemin de statistiques et aux attaques observées. Le refus QWER ne masque pas l’exercice du déclencheur PVmanquants.

Ratios recomputés en précision Python et comparés aux témoins f32,tolérance10⁻⁶ ; dégâts/récupération attendus/observés,tolérance0,002. Aucun attendu de cadence native exact inventé sans ordre de cumul/arrondi qualifié. Dommages cible/Q sans paire pré-impact adjacente ; refus avec flags sans snapshots bruts avant/après ; aucune garde universelle NPC qualifiée.

Historique :15fichiers/10241475octets,13ancienshashes concordants/deux identités nouvelles. Binaire6125568octets,SHA `9e7434ea544e5041a38e59b0558be76ab3c978c9e7d47346127f0de1b3fc166d`,inerte ; BUILD/RUN bruts0. Inspection hachée héritée,code numérique non requalifié ici. Échecs Nunu antérieurs conservés,non rejoués.

Contrôles actuels65/65,cohérence qualifiée52/52 par le même agent. Première relecture51/52 conservée :son prédicat cherchait un accesseur inline,alors que le code utilise deux variables locales. Prédicat corrigé,fenêtre source étendue,sortie qualifiée séparée ; moteur/preuves source inchangés (`coherence_qualification_preparation.json`). Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Bonus PVmanquants et HUD non établis. Intégration,cumul/caps,arrondis,fréquence de recalcul,windup en cours,annulations,soins/W,boucliers sans perte de PV,changements PVmax,dégâts simultanés,mort/respawn et transport ouverts. Tests limités au niveau1,pleine vie/26–29%manquants,une cible et Dague ; extrêmes non exercés. Lookup/provenance Mana à qualifier. Limites V564 et deux échecs Nami conservés.

## 6. Corrections et reprise

Réutiliser `CH-Olaf-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-OLAF-BERZERKER-RAGE-POLICY-01` :qualifier intégration1%/1%,cumul,caps,arrondis et recalcul. Fin :contrats4.20 démontrés,sans formule W ni règle générique promue native.

`COR-OLAF-BERZERKER-RAGE-CADENCE-HUD-01` :intégrer au vrai calcul consommé et au HUD. Fin :pleine vie,faible perte,50%/quasi100%,plusieurs niveaux/objets,soins/PVmax/W,windup/annulation,mort/respawn et transport vérifiés. Conserver le contrôle Dague acquis. Reprendre sur preuve nouvelle,dérive ou autorisation d’implémenter ; aucun correctif fonctionnel réalisé ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_olaf_passive_hud_20261104` ; evidence_review/coherence_review_qualified,DDS/histoire,`resource_provenance.json`,`phase_package_prerequisites.json`,qualification/journaux. Identités conservées avant assertions ; hook7/7 réutilisé. Sélection d’historique unique avant lecture ; captures explicites F/OpenLeague-work,limites Python/bootstrap/contexte/inventaire final/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement,deux sauvegardes,sept protégés contrôlés avant/après. Une unité d’audit bornée close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif ; goal/Plan/UI/bases/registres/produit inchangés.
