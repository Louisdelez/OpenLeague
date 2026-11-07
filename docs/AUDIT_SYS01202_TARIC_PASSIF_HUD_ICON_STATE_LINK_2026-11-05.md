# SYS-01.2-02 — Taric : Gemcraft et HUD, V1280

5 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-TARIC-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Taric-PASSIF-PRESENTATION-HUD`, `OLF-93178803-f490-585c-804a-2ca2bcd5f855` : relier attaque après sort, dégâts, délais, icône et texte aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-df7127a1-1c5b-586d-b340-321cdd983f00` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/D06-CH-Taric consultés, sans satisfaction revendiquée. Parent PRESENTATION, QWER et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/taric-passive-gemcraft-links-v637.json`, 3880179 octets, SHA `9667a4d8f2f524c62e927f00662f0dae8a76442195ffc24e3ceb40043c5e5113`, UTC documentaire 2026-10-26T20:18:35.205253+00:00, sans attribution à l’heure d’exécution.

HUD enregistré : une définition/un catalogue. SOURCE :45relations/42identités/six sites/trois fichiers. V637 :42membres/126associations,26sites/13fichiers ; union15fichiers/32ancres. Aucun ID SOURCE supplémentaire ; registres gelés conservés. Réutilisation sans relecture native :16INIBIN,14Lua,10preloads,DDF/font.

Passive1LuaName=Gemcraft, icône GemKnight_Gemcraft.dds ; ancienne description Singed/PV selon mana non adoptée. PARType, Passive1 et six niveaux absents, aucune conversion en zéro. BaseMP numérique349.0799866, croissance56. CharScript/Scripts vide56octets ; trois candidats alternatifs absents sans absence globale déduite.

BuffData Gemcraft1943 : après un sort, prochaine attaque avec dégâts magiques f1, f2% d’armure et réduction des délais de **2 secondes**. Description personnage4287 et Gemcraft.Description9443 lient armure/après-sort/délais. **Gemcraft.DynamicTooltip11543 parle de mana maximal** : contradiction native conservée, aucune priorité de dispatch déduite du nombre de textes concordants. TaricGemcraftBuff.DynamicTooltip11935 renvoie à Radiance/R, distinct de son BuffData2753. f1/f2, progression, sélection et consommation restent non qualifiés.

Neuf BuffData, huit résolutions exactes dont ShatterAura répété ; game_buff_tooltip_TaricHammerSmash non résolu, sans alias automatique. Champs Tantrum/Amumu, ZyraQ et Judicator, anciennes clés Radiance absentes et OpalHarmony restent distincts. DDF12lignes : Shatter armure×0.12/0.2/0.05, Imbue bonusPV×0.07 ; aucune formule Gemcraft. 14Lua sans fonctions enfants, cinq limites NEWTABLE ; persistance/non-dissipation/preloads ne prouvent pas le lifecycle ou le rendu.

24références communautaires comparatives : Gemcraft/CharScriptTaric non retrouvés dans l’arbre sélectionné ; aucune absence mondiale déduite. E lancement de projectile commenté, W aura non démontrée, R/buffs non exécutés : aucune règle native ou fonctionnalité Rust acquise par ces références.

Un DDS nécessaire `DATA/Spells/Icons2D/GemKnight_Gemcraft.dds` :4224octets,64×64 DXT5/unmip, SHA `8c099eaec42b5d15ed55736ce6cd2ef4902c31aac7e8f335c008c3375a66da2a`. Projet RADS0.0.1.7/membre0.0.0.25, taille/MD5 concordants ; sélection E avant unique stat/lecture SOURCE. Aucun DDS étranger/particule lu. Provider/pixels ouverts ; font miroir et témoin Ahri réutilisés.

Mana courant : source_sha256 identifie StatsJSON communautaire 5705octets/SHA `3a683fc6a8966cb0381b8f46a1904f37223812faafc6e392a48edd620c9adfe8`, distinct de l’INIBIN natif 1663octets/SHA `4af9c86670d82fe298d1587ca5f8b55b70f08f105275d029324cd8f1f41cd011` ; resource_provenance.json.

## 3. Consommateurs actuels

32ancres exactes,30fichiers code/configuration vérifiés ;16entrées communes inchangées. Aucun producteur nommé Taric/Gemcraft dans le périmètre Rust sélectionné ; recherche bornée.

attacks.rs/lifesteal.rs appliquent attaque physique générique, progression.rs calcule statistiques et armure d’objet ; shop.rs:233 ajoute l’armure. Les chemins learn/cast/cast_at refusent Taric. cooldown.rs:10/11 convertit une réduction **en pourcentage** en durée, sans producteur Gemcraft identifié : ce mécanisme ne prouve pas une soustraction déclenchée de2s. native_hud_bars.rs:11 et native_hud_spells.rs:21 utilisent Mana/rangs/cooldowns génériques ; présentation Gemcraft non qualifiée.

## 4. Attendu, observé et contrôles

Deux profils publics base/Tissu1029 : armure25.8759995→40.8759995, AD57.8800011 inchangé, AP0. Achat/vente/rachat et inventaires vérifiés dans cinq relevés boutique ; trois transactions. L’armure revient à la base à la vente. AP seulement au relevé final, sans mesure dédiée à chaque étape boutique.

Douze attaques de mêlée non amorcées : dégâts physiques attendus/observés≈48.54889 contre Annie dans les deux profils, cadence48ticks, témoins windup/impact et rangs/délais zéro vérifiés. Le contrôle +15armure ne mesure pas un scaling de proc inexistant dans ce diagnostic.

362trames au repos, Mana au plafond ;360paires PV adjacentes d’Annie recalculées pour cette attente. Paires PV cible adjacentes à l’impact non enregistrées : dégâts d’impact dérivés/résidus vérifiés, sans reconstruction de chaque terme PV. Soin non qualifié. Quatre trajets publics sans réordre,54refus par flags ; aucune garde NPC universelle.

**Aucun sort Taric accepté, aucun déclencheur Gemcraft appliqué.** Attaque magique renforcée, consommation et réduction de2s non exercées. Délais constamment zéro dans les états enregistrés, non discriminants pour une réduction. Attente181ticks sans état produit ne valide pas une expiration ; Mana plafonné ne qualifie pas une restitution.

Historique15fichiers/10606812octets,13empreintes anciennes concordantes/deux identités nouvelles. RUN brut identique au relevé ; binaire 6077952octets/SHA `7d1d70fbacf797b28454e4df977190d3199fc27fc225ade51146d1b97a1df2f7` conservé inerte, BUILD/RUN0 hérités. Contrôles69/69, cohérence72/72 séparée du même agent ; productions actuelles journalisées sorties0. Aucun nouveau jeu/build/VM/REA/rendu/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Dispatch armure/mana non établi ; f1/f2/progression et producteur d’activation/consommation absents du périmètre inspecté. Soustraction de2s, sorts admissibles, cibles, ordre/arrondis, cumul, lifecycle, provider et présentation restent ouverts. Sources contradictoires et recherches communautaires bornées conservées. QWER, V564/Nami et autres clauses ouvertes.

## 6. Corrections et reprise

Réutiliser SOURCE/SIMULATION-CONTRAT/SIMULATION/NETWORK/HUD. `COR-TARIC-GEMCRAFT-POLICY-01` : qualifier dispatch, assiette armure/mana, f1/f2, sorts admissibles, consommation et lifecycle. Fin : contrat historique sourcé résolvant ou explicitant chaque contradiction, sans choix par majorité.

`COR-TARIC-GEMCRAFT-ARM-PROC-01` : produire état prêt et attaque magique autoritaire. Fin : sort accepté selon tâches QWER existantes, prochain impact/consommation, contrôles base/armure/mana, cibles/refus et arrondis vérifiés selon politique ; conserver les attaques ordinaires comme témoins.

`COR-TARIC-GEMCRAFT-COOLDOWN-01` : appliquer la réduction déclenchée. Fin : délais positifs avant impact, réduction conforme2s, plancher, horloge/ordre, interaction avec CDR, sorts/cas exclus vérifiés. Zéro initial seul ne suffit pas.

`COR-TARIC-GEMCRAFT-HUD-BINDINGS-01` : relier bon provider/texte/icône et état prêt/consommé. Fin : transitions, variantes, transport et pixels observés. Reprendre sur preuve serveur/callsite nouveau, dérive ou autorisation fonctionnelle ; aucune réparation produit ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_taric_passive_hud_20261105` : evidence_review/coherence_review, DDS/histoire, resource_provenance.json, phase_package_prerequisites.json et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes/sept protégés vérifiés à la publication. Une unité documentaire close, zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
