# SYS-01.2-02 — Ryze : Arcane Mastery et HUD, V1266

4 novembre 2026. Unité `AUD-SYS-01.2-02-RYZE-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; implémentation, vérification du jeu et acceptation humaine restent distinctes.

## 1. Exigence et périmètre

`CH-Ryze-PASSIF-PRESENTATION-HUD`, `OLF-ec308e74-63a7-5919-aba9-f92f3a81c32e` : relier icône, texte et état du passif aux consommateurs de délais et au HUD. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-7e89ee24-fdc6-52e8-bb8e-e7da6477b3f5` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/lot D06-CH-Ryze consultés, sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts. Audit de liaison, sans implementation implicite de QWER.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/ryze-passive-arcane-mastery-links-v622.json`, 2253112 octets, SHA `359ed899dd52d112a7c772154b0bdc91c4b74cfe3ee0545c0f32eb6c699e63d6`, UTC documentaire 2026-10-26T15:34:48.236720+00:00, sans attribution à une heure d’exécution.

HUD : deux sources/un catalogue. SOURCE : 35 relations/30 identités, six sites/trois fichiers. V622 : 30 sources/90 associations, 28 sites/56 liens/14 fichiers. Union : 16 fichiers/34 ancres. Aucun ID SOURCE supplémentaire. Métadonnées réutilisées sans lecture D : 14 INIBIN, huit Lua, six preloads, DDF et font.

Définition et buff : `Arcane Mastery`, `Ryze_SpellStrike.dds`. Buff1687 et description4269 disent : lancer un sort retire une seconde aux autres sorts. PARType et Passive1 absents, BaseMP=342.3999938964844. Les champs hérités AP à faible vie, 30/45/60 et niveaux1/6/16 ne sont pas une progression établie du passif.

Quatre BuffData exactement résolus. Trois paires INIBIN avec/sans espaces ont des SHA différents : arcane mastery/arcanemastery, Rune Prison/runeprison, Spell Flux/spellflux. Aucune priorité ou équivalence de provider déduite. Huit Lua : cinq littéraux/trois limites NEWTABLE ; CharScript natif56octets et communautaire vides. DoesntTriggerSpellCasts/PersistsThroughDeath/NonDispellable ne démontrent ni callback, ni exclusion des invocateurs, ni lifecycle serveur.

Q CDR2/4/6/8/10% est distinct de la réduction fixe d’une seconde. DDF12lignes, trois liens mana Q0.065/W0.045/E0.01 ; QCooldown3.5, W absent, E14, R70/coût0. Aucune règle manquante remplacée par zéro. Quatre candidats absents ne prouvent aucune absence globale. Dix-neuf références communautaires comparatives : divergences mana Q/W/E et R AP75 conservées, aucune autorité serveur déduite.

DDS nécessaire : `DATA/Characters/Ryze/HUD/Icons2D/Ryze_SpellStrike.dds`, 4224 octets, 64×64 DXT5/mip brut0, membre0.0.0.254, SHA `802c9069ebb4da70a88719b32424edb9857e4270fe1c03a7cbef438f349c11e2`. Manifeste lol_game_client0.0.1.7, taille/MD5 concordants ; sélection E avant une lecture SOURCE, aucun alias étranger ouvert. Lookup, provider et pixels restent ouverts. Font miroir inchangé, témoin Ahri réutilisé.

Mana courant est distinct du PARType natif absent. Son source_sha256 correspond au StatsJSON communautaire 5164 octets/SHA `f4d5e56b99f715657f34eccb28f8cdb77c5ab55d22237a88eea393db75a16ad3`, distinct de l’INIBIN natif 1842 octets/SHA `8d77d2a50ac936ddba314f1408a7b524399a5aa5c1e885826c79be3a626e263f` (`resource_provenance.json`).

## 3. Consommateurs actuels

34 ancres exactes, 16 entrées communes, 31 fichiers code/configuration vérifiés. Aucun producteur nommé Ryze/ArcaneMastery dans les fichiers Rust sélectionnés ; recherche bornée. Progression et cast retournent des erreurs explicites pour Ryze. Cooldown.rs:11 convertit un délai initial avec CDR d’objet plafonné ; il ne retire pas une seconde aux autres délais. Barrier utilise son propre cooldown sans CDR d’objet.

Mana générique, régénération et capacité d’objet présents. Native_hud_bars.rs:11 et widgets.rs:91 produisent la ressource Mana ; widgets.rs:92/94 sépare SpellCooldown et SummonerSpellCooldown, calculés depuis les échéances et snapshot.tick. Le formatter masque zéro et applique les modes numériques. Ces chemins sont acquis ; ils ne prouvent ni le producteur du passif, ni son icône/texte rendus, ni les pixels historiques.

## 4. Attendu et observé

Attendu : après un lancement Ryze accepté, diminution d’un autre délai propre actif et affichage attribuable. V622 : trois profils base/Codex3108+30AP+10%CDR/Saphir1027+200mana ; 18 projectiles physiques non critiques, trois Barrier, 726 ticks d’attente, 84 refus, six trajets aboutis sans reprise, trois achats publics.

AD55.04 et dégâts46.166748 identiques ; calcul physique ordinaire recalculé à tolérance0.002. Six IDs distincts par partie, sans unicité entre parties revendiquée. Aucun sort Ryze accepté, rangs/délais propres tous zéro dans les observations. Le cas nominal du passif reste non exercé.

Contrôle générique dix secondes : 300/270/300 ticks, recalcul f32 cohérent. Barrier : bouclier115 jusqu’au tick60, absent au tick61 ; échéance initiale+6300 inchangée après attaques et attentes. Les 183 frames de bouclier et 543 frames suivantes montrent le compte à rebours ordinaire, pas une réduction du passif ni son éligibilité native. Saphir augmente capacité342.4→542.4 sans remplissage immédiat ; Mana final plein ne qualifie pas sa consommation par un sort Ryze.

Sortants sans paires PVcible adjacentes brutes ; healing_checked=false, refus flags sans snapshots bruts, pas de garde NPC universelle. Historique15fichiers/10455005octets, 13 anciens hashes concordants/deux identités nouvelles. Binaire 6081536 octets/SHA `4da60cda94df94c05fb0278b13c934670a738862ee16095e267de0d917c01737` inerte, BUILD/RUN bruts0. Contrôles71/71, cohérence séparée65/65 par le même agent ; aucune opération matérielle actuelle échouée. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni validation humaine.

## 5. Écarts et inconnues

Événement précis, instant du cast, slots affectés/exclusion du sort déclencheur, invocateurs, recasts/annulations, clamp/arrondis, ordre avec CDR, lifecycle, providers et rendu/transport restent ouverts. QWER distincts ; V564/Nami conservés.

## 6. Corrections et reprise

Réutiliser `CH-Ryze-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-RYZE-ARCANE-MASTERY-POLICY-01` : qualifier événement, éligibilité, ordre/horloge, clamp, recasts et lifecycle. Fin : contrat4.20 sourcé distinguant CDR de Q, CDR d’objet et réduction fixe.

`COR-RYZE-ARCANE-MASTERY-COOLDOWNS-01` : produire la réduction après un vrai lancement Ryze. Fin : autre délai actif avant/après, cas inférieur/égal/supérieur à1s, CDR0/10/40%, slots exclus, refus sans mutation et règles d’invocateurs vérifiés selon politique qualifiée. Prérequis : capacité Ryze acceptée ; les contrôles Barrier ne la remplacent pas.

`COR-RYZE-ARCANE-MASTERY-HUD-BINDINGS-01` : relier icône/texte et variation des délais au bon événement. Fin : bindings exacts, délais propres/invocateurs séparés, transitions et réplication observées, rendu vérifié. Reprendre sur nouveau mapping/source/callsite, dérive ou autorisation d’implémenter ; aucun correctif fonctionnel ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_ryze_passive_hud_20261104` ; evidence_review/coherence_review, DDS/histoire, resource_provenance.json, phase_package_prerequisites.json et journaux. Hook7/7 réutilisé ; limites Python/contexte/inventaire final/TOCTOU déclarées. Rapport et ajouts CURRENT/HANDOFF uniquement, sauvegardes exactes et sept protégés contrôlés avant/après publication. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif ; goal/Plan/UI/bases/registres/produit inchangés.
