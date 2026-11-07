# SYS-01.2-02 — Nocturne : Umbra Blades et HUD, V1254

4 novembre 2026. Unité `AUD-SYS-01.2-02-NOCTURNE-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre ; implémentation, vérification du gameplay et acceptation humaine restent distinctes.

## 1. Exigence et périmètre

`CH-Nocturne-PASSIF-PRESENTATION-HUD`, `OLF-4a4c9bd8-a8b2-54d1-84a7-595633617097` : relier icône, texte, rang, états prêt/cooldown, dégâts et soin du passif aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-fa461077-2690-5432-a436-827d6d10e048` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et leurs inconnues conservés. Phase D06 et lot D06-CH-Nocturne consultés, sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/nocturne-passive-umbra-blades-links-v610.json`, 2313245 octets, SHA `01fec5b05f56657b7596864784c758048b3dfe8b755d49f202d4c48dd509e912`, UTC documentaire 2026-10-26T11:49:13.605019+00:00, sans attribution à une heure d’exécution.

HUD : une définition/un catalogue. SOURCE :61 relations/59 identités, quatre sites/deux fichiers. V610 :59 sources/177 associations,28 sites/56 liens/15 fichiers. Union :16 fichiers/32 ancres. Aucun ID SOURCE supplémentaire. Métadonnées natives réutilisées, sans réouverture D.

NocturneUmbraBladesTooltip/Nocturne_UmbraBlades.dds ; textes2391/2398/2399/4241 : toutes les10s,120% dégâts physiques aux ennemis environnants, soin f1 par cible, réduction1s à chaque attaque. f1/progression, géométrie, cibles et ordre temporel inconnus. Passive1=1 et niveaux1/6/11/16 non adoptés comme paliers du soin. Textes hérités Warwick et mana40/60/80% conservés sans adoption.

Le fichier `Nocturne Passive Cooldown.inibin` existe avec espaces ; le BuffName Lua concorde. Le candidat compact absent ne signifie pas une ressource de cooldown manquante. UmbraAttack CastRadius100/CastRange125/Cooldown1=0 ne déterminent ni zone réelle ni délai natif10s. Douze DDF :R bonusAD×1,2,Q bonusAD×0,75,dix vides ; aucun ne résout f1 de soin.

26 Lua :dix littéraux/16 limites NEWTABLE ;15 preloads et dix BuffData exactement résolus. CharScript natif non vide, limité à Wolfman_InnerHunger.dds ; communautaire vide. Métadonnée Wolfman ≠ gameplay Warwick. Umbra expose particules prêtes sur les paumes ; Tooltip PersistsThroughDeath ne prouve pas le cycle mort/respawn. Cinq absences de chemins bornées, sans manque global d’assets ni corruption déduite.

21 références communautaires non adoptées :Q totalAD×0,75 contre bonusAD natif ; W délégation1,5s ; E timers/peur sans contrôle de distance dans le corps lu ; R dégâts directs sans dash/vision qualifiés. Ni serveur original ni consommateurs Rust.

Trois DDS nécessaires,7920 octets/deux contenus, inventaire E avant lectures SOURCE :

| Icône et chemins | Identité |
|---|---|
| Nocturne_UmbraBlades.dds :Characters/Nocturne/Info et Spells/Icons2D | 2872 octets chacune,64×64 DXT1,mip7,membre0.0.0.25 ; SHA78364c5ec707d9c55097585d834c1f19052576b4ad33f8e8512230f8625d483e |
| Nocturne_UmbraBlades_Grey.dds :Spells/Icons2D | 2176 octets,64×64 DXT1,mip1,membre0.0.0.79 ; SHAa2af324c6b5ccb2dcbd91b3f0463ff0271a24c2be993b10a8d6a0eed4690beb7 |

Taille/MD5 concordent au manifeste lol_game_client0.0.1.7. Wolfman reste manifeste/métadonnée uniquement ; lookup/variante/pixels ouverts. Font miroir identique au témoin Ahri. Mana courant, PARType natif absent ; source_sha256 correspond au JSON communautaire9054 octets, distinct de l’INIBIN natif3723 octets/SHAf0b1f433221fc3fc98c81a99e8755a959e95187535b862ead0c036ca5c1f6403 (`resource_provenance.json`).

## 3. Consommateurs actuels

32 ancres exactes,16 entrées communes et30 fichiers code/configuration vérifiés. Recherche Nocturne/UmbraBlades sans hit dans ces Rust, sans prétendre à une absence globale. Catalogue, progression, commandes, attaques, dégâts, régénération, objets, soin, snapshots et déplacement inspectés.

`lifesteal.rs:4–29` applique des dégâts physiques ordinaires puis le vol de vie d’objet post-mitigation ; aucun producteur Umbra dans ce corps. `progression.rs:99` fournit un taux de vol de vie des objets, distinct du soin natif f1 par cible. `healing.rs:9–14` conserve les modificateurs génériques, non exercés ici. HUD Mana/MPStat/PV et module Ezreal ne prouvent ni icône prête/grisée sélectionnée ni cooldown/soin attribuable à Umbra.

## 4. Attendu et observé

Attendu : attaque prête à120%, sélection des ennemis autour, soin natif par cible, consommation/réduction du délai et états HUD cohérents. Hérité V610 :trois cas sans objet/Épée+10AD/Sceptre+10AD8%,AD59,208/69,208/69,208.18 mêlées sortantes, neuf physiques entrants, trois QAnnie,1806 ticks d’attente,81 refus et six trajets de préparation.

Deux séries de trois coups et deux attentes301ticks par cas. Les18 dégâts bruts sont AD ordinaire, sans coefficient120%, résidus<0,002 après mitigation. Les attaques ordinaires exercent le candidat du passif malgré QWER refusés. Une cible ennemie seulement : zone, soin multicible et réduction1s non qualifiés.

18 paires PVpropres avant/après, moins régénération médiane observée0,0550537109375PV/tick :soin0/base,0/Épée,4,64404296875/Sceptre. Attendu objet4,64405250549 ; témoin historique calculé avec régénération théorique4,64403009415. Écarts<0,002,PV non plafonnés,niveau/objets constants. Le Sceptre ne qualifie pas le soin f1 d’Umbra.

301ticks dépassent10s sans mesurer l’expiration d’un buff absent. Attentes PV/attendus recontrôlées ; dégâts cible/Q sans paire pré-impact adjacente, refus avec flags sans snapshots bruts avant/après. Aucune garde universelle NPC qualifiée.

Historique :15 fichiers/11720877 octets,13 anciens hashes concordants/deux identités nouvelles. Binaire6153216 octets,SHA `79b786696cc39936152b9554f119ec1859dd263266add7b0ed475e48a639839e`, inerte ; BUILD/RUN bruts0. Inspection qualifiée hachée, code numérique non requalifié ici. Ancien libellé540ticks corrigé en1806 avant publication V610 ; anciens artefacts conservés, aucune panne actuelle déduite.

Contrôles actuels65/65, cohérence séparée50/50 par le même agent. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni revue humaine/agent indépendante.

## 5. Écarts et inconnues

Producteur120%,zone,soin f1 et états prêt/cooldown non établis. Rayon/cibles,paliers,réduction1s,interruptions,critique,mitigation,boucliers,vol de vie,anti-soin,surdégâts,PVpleins,mort/respawn et transport ouverts. Lookup des icônes/provenance Mana à qualifier. Limites V564 et deux échecs Nami conservés.

## 6. Corrections et reprise

Réutiliser `CH-Nocturne-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-NOCTURNE-UMBRA-POLICY-01` :résoudre f1/paliers,rayon,cibles,ordre temporel. Fin :mappings/callsites4.20 démontrés sans valeurs modernes ni zéro supposé.

`COR-NOCTURNE-UMBRA-ONHIT-HUD-01` :intégrer producteur,zone,soin et états/HUD. Fin :premier impact/répétitions,multicible,avant/à/après10s,réduction1s,PVpleins/manquants,immunités/mort/respawn et attribution/transport vérifiés. Reprendre sur preuve nouvelle,dérive ou autorisation d’implémenter ; aucun correctif fonctionnel exécuté ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_nocturne_passive_hud_20261104` ; evidence_review/coherence_review,DDS/histoire,`resource_provenance.json`,`phase_package_prerequisites.json`,journaux. Identités préservées avant assertions ; témoin hook7/7 réutilisé. Captures explicites F/OpenLeague-work ; limites Python/bootstrap/contexte/inventaire final/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement,deux sauvegardes,sept protégés contrôlés avant/après. Une unité d’audit bornée close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif ; goal/Plan/UI/bases/registres/produit inchangés.
