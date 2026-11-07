# SYS-01.2-02 — Sona : Power Chord et HUD, V1275

4 novembre 2026. Unité `AUD-SYS-01.2-02-SONA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Sona-PASSIF-PRESENTATION-HUD`, `OLF-71afb1e8-4934-54f6-847c-e8e470b0f32b` : relier compteur, état prêt, variantes et icônes aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false ; dépendance NETWORK et inconnue `OLU-aa54f99f-3d0d-524d-b157-b96020640afc` ouvertes. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/D06-CH-Sona consultés, sans satisfaction revendiquée. Parent PRESENTATION, QWER/auras et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/sona-passive-power_chord-links-v632.json`, 3303249 octets, SHA `22f4e7b9cf6473db1351cf638edd814b6bc5b6ccd285a68d2f096c05bc579e69`, UTC documentaire 2026-10-26T18:36:23.650065+00:00, sans attribution à l’heure d’exécution.

HUD enregistré : définition/CharScript et un catalogue. SOURCE : 98 relations, 92 identités, six sites/trois fichiers. V632 : 92 membres/276 associations, 28 sites/14 fichiers ; union 16 fichiers/34 ancres. Aucun ID SOURCE supplémentaire ; registres gelés conservés. Métadonnées réutilisées : 30 INIBIN, 37 Lua, 23 preloads, DDF et font, sans nouvelle lecture native.

Définition : Passive1LuaName=SonaPassive, icône Sona_Passive_Charged.dds, PV482.3599854, mana340.6000061, AD50.0400009. PARType, Passive1Desc et Passive1 absents. Niveaux8/15 conservés sans conversion en formule de dégâts. CharScript/DDF à la racine ; quatre candidats alternatifs absents sans manque global déduit.

Font2673/2674 : après trois sorts hors ultime, prochaine attaque avec bonus magique f1(+f2), effet selon dernier chant activé. Description4281 omet « hors ultime » ; cette différence reste visible. Count, Ready2676 et Debuff/Diminuendo2675 sont distincts. Onze liens BuffData exactement résolus, sans alias automatique. Dégâts de base, AP/progression, compteur initial, sélection et consommation restent non qualifiés.

Trois bindings supplémentaires vérifiés sur le font miroir :

- Q11874 : Staccato, Effect6=50 sur les cinq rangs, soit +50% de dégâts Power Chord selon le texte ; base et ordre inconnus.
- W11877 : Diminuendo, Effect4=20% de base, supplément f1%, Effect10=3s. Producteur f1, catégories de dégâts et composition inconnus.
- E11871 : Tempo, Effect4=40% de base, supplément CharAbilityPower2%, Effect8=2s. Calcul AP effectif, application et empilement inconnus.

Count déclare Sona_Passive.dds ; Passive/Ready/Debuff déclarent Charged. Persistance/preloads ne prouvent pas lifecycle ou rendu. QWEAttack/Upgrade avec globals non évalués ne deviennent pas des formules par déduction. 37 Lua sans callback exécuté, 26 limites NEWTABLE ; DDF16 lignes vides et anciens noms QWER, sans formule passive.

35 références communautaires : CharScript vide ; Q sans priorité champions/aura prouvées ; W35–115 contre soin natif30–110, amplification PV manquants/bouclier non démontrés ; E appelle SonaSpeedBoost sans producteur retrouvé dans les scripts sélectionnés ; R cône plutôt que ligne, améliorations d’auras non prouvées. Aucune absence globale ni exécution C# déduite.

Deux DDS nécessaires :

- `DATA/Characters/Sona/HUD/Icons2D/Sona_Passive.dds` : 2176 octets, SHA `e065ea233d2161fa9ebc6dd10863d54ecb4363c0365cc8a9622c6d8476932b9e`.
- `DATA/Characters/Sona/HUD/Icons2D/Sona_Passive_Charged.dds` : 2176 octets, SHA `2e5f9c89e4dbfa1c3a65c991582863ce7d4a00f399e26d8dcf926aa677f41f7a`.

4352 octets, deux contenus, 64×64 DXT1/mip brut0, manifeste0.0.1.7/membres0.0.0.243, tailles/MD5 concordants. Sélection E avant deux lectures/stat SOURCE ; aucune autre texture/particule lue. Provider/transition/rendu ouverts ; font miroir inchangé, témoin Ahri réutilisé.

Ressource courante Mana : source_sha256 identifie le StatsJSON communautaire 3929 octets/SHA `2bebd77931372a7667ff23612ed38bc32f4a12d8df625ea4bd5a19a5b1b14648`, distinct de l’INIBIN 1018 octets/SHA `3af17060c8a13cc989cabdbe19c4e33c6b7f31750eee0532305f60ebb8c31fef` (`resource_provenance.json`). PARType absent n’est pas une déclaration native Mana.

## 3. Consommateurs actuels

34 ancres, 16 entrées communes et 29 fichiers code/configuration vérifiés. Aucun producteur nommé Sona/PowerChord/Staccato/Diminuendo ni occurrence Tempo dans les Rust sélectionnés : recherche bornée. Routes physiques à distance, statistiques/AP et objets génériques conservées ; apprentissage/casts refusés dans les cas observés.

Slows.rs:74/78 expose application/expiration génériques ; aucun Tempo exercé. Summoner_exhaust.rs:38 réduit les dégâts lorsque exhaust_until est actif ; ce consommateur reste Exhaust, pas Diminuendo. HUD sélectionné : santé/Mana, rangs/délais ; aucun binding du compteur, dernier chant ou attaque chargée établi. Absence visuelle globale non déduite.

## 4. Attendu et observé

Attendu : trois casts admissibles, compteur/prêt, dernier chant, consommation et HUD cohérents. V632 conservé : profils base/Tome1052+20AP, 12 projectiles/impacts ordinaires, 362 ticks d’attente, 54 refus, quatre trajets sans reprise. Cinq relevés boutique et trois transactions achat/vente/rachat.

AP0/20, AD50.0400009 et armure20.5440006. Dégâts41.9728088–41.9728394 ordinaires recalculés, tolérance0.002 ; six projectiles uniques/cas. L’AP est enregistré dans le résultat final, pas dans chaque relevé boutique ; inventaire et AD/armure sont contrôlés aux étapes. Aucun scaling de Power Chord déduit.

Aucun sort Sona accepté ni charge native appliquée : compteur, attaque chargée et trois variantes non exercés. Attente181ticks sans producteur ne valide ni durée Diminuendo/Tempo ni réinitialisation. Mana au plafond, restitution non qualifiée. Aucun slow, réduction Diminuendo ou aura injectés dans le diagnostic.

Refus par flags de snapshot inchangé ; paires PVcible adjacentes sortantes absentes, soin non qualifié, aucune garde NPC universelle. Historique15 fichiers/10776266 octets, 13 empreintes anciennes concordantes/deux identités nouvelles ; JSON brut RUN égal au relevé. Binaire 6073856 octets/SHA `52226d50c084ae42c184995e8873ab9a972938f073a90d43aab9829e6b41dac2` inerte, BUILD/RUN0.

Contrôles61/61, cohérence66/66 séparée du même agent ; productions journalisées sorties0. Aucun nouveau build/jeu/VM/REA/rendu/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Producteur compteur/dernier chant non établi dans les consommateurs inspectés. f1/f2/AP/progression, initialisation, ordonnancement, consommation, cibles, variantes, durée/composition des débuffs, lifecycle, providers, transport et pixels ouverts. E communautaire reste une recherche bornée. V564/Nami et autres clauses conservés.

## 6. Corrections et reprise

Réutiliser SOURCE/SIMULATION/NETWORK/HUD. `COR-SONA-POWER-CHORD-POLICY-01` : qualifier compteur, dégâts, AP/progression, dernier chant, ordre et lifecycle. Fin : contrat historique sourcé, avec exclusion de l’ultime selon le texte précis, sans importer valeurs communautaires ou niveaux8/15 comme formule.

`COR-SONA-POWER-CHORD-COUNTER-PROC-01` : produire compteur/prêt et consommation avec variantes. Fin : états, casts admissibles/refusés, attaque chargée, bonus Q, réduction W, slow E, valeurs/arrondis, cibles, interruptions et lifecycle vérifiés selon politique qualifiée. Prérequis : sorts d’application acceptés dans leurs tâches existantes ; conserver Tome/attaques ordinaires comme contrôles.

`COR-SONA-POWER-CHORD-HUD-BINDINGS-01` : relier compteur, icônes base/chargée, texte et dernier chant à l’état autoritaire. Fin : transitions, variantes, transport et pixels observés. Reprendre sur artefact serveur/mapping/callsite nouveau, dérive ou autorisation fonctionnelle ; aucun correctif produit ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_sona_passive_hud_20261104` : evidence_review/coherence_review, DDS/histoire, resource_provenance.json, phase_package_prerequisites.json et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement, sauvegardes exactes/sept protégés contrôlés. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
