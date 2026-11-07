# SYS-01.2-02 — Nidalee : Prowl/Hunt et HUD, V1253

4 novembre 2026. Unité `AUD-SYS-01.2-02-NIDALEE-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre ; implémentation et acceptation du passif restent ouvertes.

## 1. Exigence et périmètre

`CH-Nidalee-PASSIF-PRESENTATION-HUD`, `OLF-febceab0-fb14-5900-8b57-65f8986f89ce` : relier icône, texte, rang et états Prowl/Hunt/formes aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-92029e7d-319e-516b-8ffb-6bd8b993d415` ouverte. Six contrats et ensembles d’inconnues HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE conservés. Phase D06, lot D06-CH-Nidalee et prérequis consultés, sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/nidalee-passive-prowl-links-v609.json`, 2829257 octets, SHA `053eb62e2c4193a62375d6b2c71eb4fb46931c623c36ea875bcab542565e0936`, UTC documentaire 2026-10-26T11:24:52.019532+00:00, sans attribution à une heure d’exécution.

HUD : définition+CharScript client, un catalogue. SOURCE : 78 relations/72 identités, six sites/trois fichiers. V609 : 72 sources/216 associations, 28 sites/56 liens/12 fichiers. Union : 14 fichiers/34 ancres. Aucun ID supplémentaire SOURCE. Réutilisation des métadonnées/INIBIN/Lua/font natives sans réouverture D.

NidaleePassiveHunt et Nidalee_Passive.dds sont liés côté humain. Cougar conserve nom/description/icône, mais Passive1LuaName est absent : cela ne prouve pas une absence voulue du passif. Six champs de niveau absents ; texte ancien critique alliée et AttackRate10/15/20% conservé sans adoption.32 DDF vides ≠ valeurs nulles de gameplay.

Textes natifs :10% en buisson pendant2s,30% vers champion ennemi visible à5500 ; Hunt4s après JavelinToss/Bushwhack, avec vision. CastRange est la chaîne5900.0000 : divergence conservée, sans marge inventée. BuffData ajoute Swipe aux Takedown/Pounce renforcés ; description générale et tooltip SpellData ne citent pas Swipe. Aucun arbitrage sans preuve.

Onze BuffData, neuf résolus exactement ; BrushPassive et Bushwhack restent sans clé correspondante, sans renommage automatique.23 Lua :12 littéraux/11 limites NEWTABLE, aucun callback serveur démontré. Deux CharScripts natifs et le communautaire vides.14 preloads, cinq absences de chemins bornées ; aucun manque global ni corruption déduit. Quatre noms d’attaques Cougar ont chacun deux chemins et des SHA égaux ; priorité runtime inconnue.

33 références communautaires non adoptées : Q projectile commenté/sans application Hunted, W définit Pounce sans déplacement démontré, R alterne un buff sans conversion complète des capacités/stats. Ni serveur original ni consommateurs Rust.

Deux DDS nécessaires sous DATA/Characters/Nidalee/HUD/Icons2D, membre0.0.0.237 du manifeste lol_game_client0.0.1.7 :

| Icône | SHA-256 |
|---|---|
| Nidalee_Passive.dds | d5619142d1b28065ed34f0bc51c5eb5731516fb59979d893e7046a15c524f947 |
| Nidalee_R2.dds, déclaration CougarScent | f706d65492515b7706bc3dad3deef5aa42d2d14aeae9afacaad068495923ae74 |

Chacune2176 octets,64×64 DXT1,mip brut0 ; taille/MD5 concordent. Inventaire E avant deux lectures SOURCE ; lookup/variante/pixels non qualifiés. Mip0 ne démontre pas une corruption. Font miroir identique au témoin Ahri.

Mana courant, PARType natif absent. source_sha256 correspond au JSON communautaire6704 octets, distinct de l’INIBIN natif2410 octets/SHA20ccd43dd2e2cd4a63bee4ccbb0a086d837ee5f69302277d724ea74f863c9201 : `resource_provenance.json`.

## 3. Consommateurs actuels

34 ancres exactes,16 entrées communes et28 fichiers code/configuration vérifiés. Recherche Nidalee/Prowl/Hunted sans hit dans ces Rust, sans absence globale revendiquée. `movement.rs:53–56` combine vitesse de définition+objets ; `:37–47` gère des bonus génériques, sans Prowl. Les caps/ordres historiques restent non qualifiés.

`vision.rs:45/48` lit flags/HAS_GRASS ; `:79/95/137` fournit visibilité et snapshots filtrés, sans révélation Hunt démontrée ni acceptation réseau. Navigation consomme hauteur/NOT_PASSABLE ; le champ exporté open ne qualifie pas seul la praticabilité. Catalogue, commandes/refus, progression, régénération, QAnnie et déplacement inspectés. HUD Mana/MPStat/PV et module Ezreal ne démontrent pas les états Prowl/Hunt/Cougar.

## 4. Attendu et observé

Attendu : vitesse Prowl selon buisson/direction/visibilité, maintien2s, déclencheurs Hunt4s et états attribuables au HUD. Hérité V609 : deux cas sans objet/Bottes1001 ; vitesses335/360, huit trajets mesurés aboutis.

280 paires de positions recalculées :272 pas à pleine vitesse,158 échantillons buisson, dont76 vers ennemi visible à moins de5500 et82 en éloignement. Distances, direction et distance ennemie recalculées ; pas compatibles avec vitesse ordinaire/30, tolérance0,003. Aucun bonus Prowl observé. Le buisson a été exercé ; les sorts refusés n’expliquent pas cette absence.

244 ticks d’attente, deux QAnnie et54 refus. Hunt et transformation Cougar non exercés ; QAnnie n’est pas JavelinToss. Offsets59/60/61 ≠ âge d’un buff actif. Attentes conservent vitesse/flags de régénération, sans PV bruts par tick ; Q sans paire pré-impact adjacente, refus avec flags sans snapshots bruts avant/après. Quatre trajets de préparation, sans reprises dans le code de collecte ; aucune garde universelle NPC qualifiée.

Historique :15 fichiers/11098811 octets,13 anciens hashes concordants/deux identités nouvelles. Binaire6060544 octets, SHA `b0bf5b692d6ed620bc817b7a86cbb3e0d44b9e9feec15d1957ba8d67a21d5800`, inerte ; BUILD/RUN bruts0. Inspection hachée héritée, code numérique non requalifié ici.

Contrôles actuels64/64, cohérence séparée49/49 par le même agent. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Prowl absent du chemin de vitesse audité ; Hunt/formes non exercés. Direction exacte, visibilité/partage, frontière5500/5900, multiplicateurs, rafraîchissement, Swipe, consommation des bonus, priorité Cougar, clés manquantes et provenance Mana ouverts. Mort/respawn, plusieurs Nidalee/cibles, invisibilité, attribution/HUD/transport non qualifiés. V564 et deux échecs Nami antérieurs conservés.

## 6. Corrections et reprise

Réutiliser `CH-Nidalee-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-NIDALEE-PROWL-BRUSH-01` : qualifier direction/portée/cumul, intégrer Prowl au vrai consommateur. Fin : entrée/sortie buisson, maintien2s, seuils et visibilité testés avec attendu sourcé.

`COR-NIDALEE-HUNT-FORM-01` : résoudre Swipe/portée puis déclencheurs, vision alliée, formes et consommation renforcée. Fin : JavelinToss/Bushwhack réels, Hunt4s, plusieurs sources/cibles, expiration, mort/respawn et HUD/transport vérifiés. Reprendre sur preuve4.20 nouvelle, dérive ou autorisation d’implémenter ; aucun correctif fonctionnel exécuté ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_nidalee_passive_hud_20261104` ; evidence_review/coherence_review, DDS/histoire, `resource_provenance.json`, `phase_package_prerequisites.json`, journaux. Identités préservées avant assertions ; hook7/7 réutilisé. Captures explicites F/OpenLeague-work ; limites Python/bootstrap/contexte/inventaire final/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement, deux sauvegardes, sept protégés contrôlés avant/après. Une unité d’audit bornée close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif ; goal/Plan/UI/bases/registres/produit inchangés.
