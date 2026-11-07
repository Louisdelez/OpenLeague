# SYS-01.2-02 — Nautilus : Staggering Blow et HUD, V1252

4 novembre 2026. Unité `AUD-SYS-01.2-02-NAUTILUS-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire ; implémentation, vérification technique et acceptation humaine restent distinctes.

## 1. Exigence et périmètre

`CH-Nautilus-PASSIF-PRESENTATION-HUD`, `OLF-6510c9e6-7c95-564f-b445-fa29bc7336b0` : relier icône, texte, rang, dégâts supplémentaires, immobilisation et immunité par cible aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-faf750a2-ff75-5ffd-8aa8-dd37b03b7c25` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et leurs inconnues conservés. Phase D06 et lot D06-CH-Nautilus consultés sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts.

## 2. Sources et provenance

Référence PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/nautilus-passive-staggering-blow-links-v608.json` : 2580470 octets, SHA `c94e7360215086821b06ee04ed20dd1c8bfecd0b11f5170a7319a53fd2a7c48a`, UTC documentaire 2026-10-26T11:07:56.164179+00:00, sans attribution à une heure d’exécution.

HUD : une définition native/un catalogue. SOURCE : 88 relations/82 identités, six sites/trois fichiers. V608 : 79 payloads/237 associations, 31 sites/62 liens/16 fichiers. Union : 18 fichiers/37 ancres. Les trois identités SOURCE supplémentaires sont des candidats littéraux BuffName (LuluFaerieOverrideTemp, MalzaharVoidlingDanceOverride, MordekaiserCOTGDanceOverride) ; ni alias runtime démontrés ni mécaniques étrangères. Métadonnées natives réutilisées, sans réouverture D.

Tooltip2340 : bonus physique f1, immobilisation f2 secondes, délai par cible f3 secondes. Valeurs et progression inconnues. Passive1=9 et niveaux3/7/11/15 restent des valeurs non interprétées ; niveaux5/6 absents. Ancien texte Jax/objets AD et mana40/60/80% conservé sans adoption. Onze BuffData résolus exactement, sans réécriture ; PassiveCheck annonce l’immunité, PassiveRoot l’impossibilité de bouger et le popup Snared. Drapeaux de persistance ≠ politique mort/respawn.

33 Lua, dont dix limites NEWTABLE ; CharScripts natif/communautaire vides. Dix-neuf preloads et cinq absences de chemins bornées, sans conclusion d’absence globale. Huit DDF : seuls coefficients Q/W non vides, non ceux du passif. Trente références communautaires non adoptées : Q root0,5s sans traction démontrée, W délégation, R timer1s ; ni serveur original ni consommateurs Rust. Malady/Lux restent des métadonnées.

Quatre chemins DDS nécessaires, 11488 octets, deux contenus : Nautilus_StaggeringBlow (Characters/Nautilus/info et Spells/Icons2D), membre0.0.0.77, SHA `777b7cd1c507418750870260ecb3dd755408f9d59b0b3e10a02ac49241718557` ; 3114_Malady (Items/Icons2D et Spells/Icons2D), membre0.0.0.25, SHA `4abf5d6e9ddfa2f7dff8f87298960fb2bdbf0bdc49a97078ce621cabecaecd53`. Chaque fichier : 2872 octets, 64×64 DXT1, sept mipmaps ; MD5/taille concordent au manifeste lol_game_client0.0.1.7. Inventaire E avant quatre lectures SOURCE ; lookup, priorité de variante et pixels non qualifiés.

Font miroir identique au témoin Ahri. Mana courant, PARType natif absent. Le source_sha256 de champion_resources correspond au JSON communautaire (7382 octets), distinct de l’INIBIN natif (2654 octets, SHA e61269d0f235f46fa82feeb221306b14c4dd7c06788ce39567de03a4ef353da7) : voir `resource_provenance.json`.

## 3. Consommateurs actuels

37 ancres exactes et 16 entrées communes vérifiées ; 32 fichiers de code/configuration épinglés. Catalogue, initialisation, commandes, stats, attaques, dégâts, régénération, objets, cibles, snapshots et déplacement inspectés. Recherche Nautilus/StaggeringBlow sans hit dans ces Rust, sans prétendre à une absence globale.

`lifesteal.rs:4–29` applique les dégâts physiques ordinaires et le vol de vie générique ; aucun producteur Nautilus dans ce corps. `stuns.rs:6/15/37` porte un événement d’étourdissement générique, pas le root ni le délai par cible de Nautilus. Ne pas substituer cet étourdissement. HUD Mana/MPStat/PV (`native_hud_bars.rs:9–11`, `native_hud_widgets.rs:91`) et module Ezreal ne démontrent pas un HUD Staggering Blow complet.

## 4. Attendu et observé

Attendu : attaque admissible ajoutant le bonus natif, empêchant le mouvement selon f2 et posant une immunité source/cible selon f3, avec présentation attribuable.

Historique V608 : deux cas sans objet/Épée+10AD, AD57,544/67,544 ; six mêlées sortantes, six physiques entrantes, deux AnnieQ, 360 ticks d’attente, 54 refus et quatre trajets de préparation sans reprise déclarée. Les premières attaques et répétitions infligent uniquement les dégâts ordinaires, résidus<0,002. Les attaques ordinaires exercent le candidat du passif ; les sorts Nautilus refusés n’expliquent pas son absence.

Six paires brutes de positions, trois ticks suivant chaque premier impact, recalculées : déplacement11,16650390625 par tick, compatible335/30. Aucune immobilisation observée sur ces échantillons. Cela ne quantifie ni durée native ni déficit historique sans f1/f2/f3. Attendre90 ticks ne qualifie pas l’expiration d’un marqueur jamais activé.

Attentes PV/attendus contrôlées ; dégâts cible/Q sans paire pré-impact adjacente ; refus avec erreurs/flags sans snapshots bruts avant/après. Aucune garde universelle NPC démontrée. Historique 15 fichiers/10641416 octets : 13 anciens hashes concordants et 2 identités nouvelles. BUILD/RUN bruts0 ; binaire6131200 octets, SHA `e1a737e4baf424f18162e48f6955ecaff21a646ce5a5b7ee54afff93eeed5903`, conservé inerte. Aucun nouveau build/jeu/VM/REA/rendu/réseau/GPU.

Contrôles actuels51/51, cohérence séparée52/52 par le même agent ; aucune revue humaine ou par agent indépendant.

## 5. Écarts et inconnues

Bonus physique, root, marqueur par source/cible et HUD non établis. f1/f2/f3, progression, cibles, immunités, ténacité, interruptions, attaques/sorts pendant root, déplacements forcés, mort/respawn et transport ouverts. Lookup d’icônes et provenance Mana restent à qualifier. Limites V564 et échecs Nami antérieurs conservés, sans attribution à Nautilus.

## 6. Corrections et reprise

Réutiliser `CH-Nautilus-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. Correction `COR-NAUTILUS-STAGGERING-BLOW-POLICY-01` : sourcer f1/f2/f3 et progression4.20. Fin : mappings/callsites démontrés, aucune constante moderne supposée.

Correction `COR-NAUTILUS-STAGGERING-BLOW-ONHIT-01` : intégrer ensuite bonus, immobilisation distincte du stun, marqueur par source/cible et attribution/HUD. Fin : premier impact, répétition interdite, autre cible/source, expiration exacte, cibles invalides, mort/respawn et transport vérifiés, attendu/observé identifié. Conserver les contrôles ordinaires acquis. Reprendre sur nouvelle preuve4.20, dérive du code ou autorisation d’implémenter ; aucun correctif fonctionnel réalisé ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_nautilus_passive_hud_20261104` ; evidence_review/coherence_review, DDS/histoire, `resource_provenance.json`, `phase_package_prerequisites.json` et journaux. Identités conservées avant assertions ; témoin du hook7/7 réutilisé. Captures explicites F/OpenLeague-work ; limites Python/bootstrap/contexte/inventaire final/TOCTOU déclarées.

Livraison limitée au présent rapport et aux ajouts CURRENT/HANDOFF, avec sauvegardes et sept fichiers protégés contrôlés avant/après. Une unité d’audit bornée close ; zéro tâche, fonctionnalité, inconnue ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 reste actif ; goal, Plan/UI/bases/registres/produit inchangés.
