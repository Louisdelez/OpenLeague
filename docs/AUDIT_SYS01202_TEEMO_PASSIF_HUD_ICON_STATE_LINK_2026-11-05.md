# SYS-01.2-02 — Teemo : Camouflage et HUD, V1281

5 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-TEEMO-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Teemo-PASSIF-PRESENTATION-HUD`, `OLF-b1c285bf-f66d-508d-a901-823f814102b1` : relier attente sans action, furtivité, bonus de sortie, icône et texte aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-40756d61-3949-59a6-9197-6e4a4d693c27` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/D06-CH-Teemo consultés, sans satisfaction revendiquée. Parent PRESENTATION, QWER et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/teemo-passive-camouflage-links-v638.json`, 3987120octets, SHA `b3d4894357ad67190caf104ffcfffdf6b91cc302ba74a0253859428cea1e4745`, UTC documentaire 2026-10-26T20:35:58.361614+00:00, sans attribution à l’heure d’exécution.

HUD enregistré : une définition/un catalogue. SOURCE :49relations/46identités/six sites/trois fichiers. V638 :46membres/138associations,30sites/12fichiers ; union14fichiers/36ancres. Aucun ID SOURCE supplémentaire ; registres gelés conservés. Réutilisation sans relecture native :13INIBIN,22Lua,9preloads,DDF/font.

Définition Camouflage/Teemo_Camouflage.dds ; ancienne description de portée de vision non adoptée. PARType, Passive1 et six niveaux absents. BaseMP numérique267.2000122/croissance chaîne40. CharScript/Scripts109octets initialise Teemo_EagleEye.dds, distinct de l’icône Camouflage. Trois candidats alternatifs absents sans absence globale déduite.

Buff1768 : immobile2s puis furtivité ; sortie avec +40% vitesse d’attaque pendant3s. Description4288 précise absence d’action et furtivité indéfinie ; CamouflageStealth1769 décrit l’état furtif. Trois BuffData exactement résolus, dont TrapLimiter distinct. Texte Kha’Zix hors contrat, aucun alias automatique.

CamouflageCheck a une initialisation vide. CamouflageBuff et TeemoCamouflageStealthTT portent littéralement **CamoflagueBuff**, icône BlindMonk_BlindingStrike.dds ; conserver la faute et la provenance sans importer Lee Sin. La variante TT ne prouve pas son dispatch historique Map10.

Preloads non vides vérifiés dans les reçus conservés : CharScript cite Camouflage/Check/TrapLimiter ; Camouflage cite Check/Stealth ; Stealth cite Buff/globalstealthscreentint/Check/varianteTT. Ce sont des dépendances déclarées, pas une exécution ni un provider de teinte écran qualifié. L’ancienne assertion de preloads vides est réfutée et conservée, sans réanalyse native.

22Lua sans fonctions enfants, huit limites NEWTABLE ; persistance/non-dissipation non preuves de lifecycle. DDF8lignes, deux liens BantamTrap @cooldownchampion avec coefficients textuels35/31/27 et31/27 ; aucune formule Camouflage. 18références communautaires : CharScript vide, producteurs Camouflage/Camoflague non retrouvés dans l’arbre sélectionné, Q projectile commenté, W/E appels sans producteur établi ; recherche bornée, aucune absence globale déduite.

Un DDS nécessaire `DATA/Spells/Icons2D/Teemo_Camouflage.dds` :4224octets,64×64 DXT5, compteur de mips brut0, SHA `387270dfab8ca34562dbd282d674181668b866d0c765ae5cc94974660908875f`. Projet RADS0.0.1.7/membre0.0.0.25, taille/MD5 concordants ; sélection E avant unique stat/lecture SOURCE. Aucun DDS EagleEye/BlindMonk/étranger/particule lu. Provider/pixels ouverts ; miroir font et témoin Ahri réutilisés.

Mana courant : source_sha256 identifie StatsJSON communautaire 7301octets/SHA `fba16034c5c30cac883e7f0f3bfc7a3216e3af16a5c306f332371a1926078f47`, distinct de l’INIBIN natif 2430octets/SHA `1d24a1b7e39b32384ebe3af7a99cd04ecf86553e5dc9d7834366eab7ffeb619c` ; resource_provenance.json.

## 3. Consommateurs actuels

36ancres exactes,27fichiers code/configuration vérifiés ;16entrées communes inchangées. Aucun producteur nommé Teemo/Camouflage/CamoflagueBuff dans le périmètre Rust sélectionné ; recherche bornée.

vision.rs:79 délègue visible_to à la visibilité du point, sans état Camouflage consulté dans ce chemin. snapshot_for:137 filtre les joueurs par visible_to ; snapshot_for_atomic:208 reprend cette projection sur la même simulation immuable. Ligne de vue, rayon, brouillard, buissons et révélation Ignite existants sont distincts du producteur Camouflage.

attacks.rs:159 et lifesteal.rs fournissent projectiles/dégâts physiques génériques ; progression.rs fournit cadence. native_hud_bars.rs:11 et native_hud_spells.rs:21 utilisent Mana/rangs/cooldowns génériques ; présentation Camouflage non qualifiée.

## 4. Attendu, observé et contrôles

Deux diagnostics hérités niveau1 : immobile puis attaque, ou immobile puis déplacement80unités et attaque. Chacun attend181ticks, soit182échantillons avec état initial. Positions fixes, terrain échantillonnéflags0, acteur Teemo identique dans les snapshots bruts de début/fin. Le collecteur vérifie chaque tick position, absence de destination/cible/windup et santé stable, sans commande pendant l’attente.

Attendu textuel : entrée après2s sans action. Observé :364indicateurs de visibilité positifs, y compris offsets59/60/61/181 et plus largement après le seuil local60ticks. Teemo reste présent dans les projections ennemies standard/atomique selon les assertions exécutées. **Les projections ennemies complètes ne sont pas conservées à chaque trame** : présence/LOS sont des indicateurs enregistrés après assertions, pas une relecture indépendante de payloads complets. Aucun replay LOS/navigation ni transport/rendu effectué ici. Équipe invalide/joueur inconnu refusés selon les assertions du collecteur, pas une validation réseau.

Six projectiles ordinaires, dégâts≈39.8758545, intervalles de lancement/cadence43ticks ; cinq arrivées sans réordre,54refus par flags. Sorts Teemo refusés, sans être prérequis du déclencheur immobile. Aucune entrée en furtivité observée : bonus de sortie40%/3s et son expiration **non exercés**. Cadence ordinaire43 ne prouve pas une absence de bonus après sortie réelle.

Dégâts dérivés/résidus et témoins de projectiles vérifiés, paires PV cible adjacentes à l’impact non enregistrées ; soin non qualifié. Mana plafonné, restitution non qualifiée ; aucune garde NPC universelle.

Historique16fichiers/10722865octets,14empreintes anciennes/deux identités nouvelles. RUN brut identique au relevé ; binaire 6256640octets/SHA `1b9c9031d30b1a5fcbbc3b71ece64c8ecea93f9a59fef1ca45263b6f12ed87df` conservé inerte, BUILD/RUN0 hérités. Reçu historique : première inspection1, assertion erronée de preloads vides, script conservé ; inspection_preload corrigée passée. Cet échec d’inspection n’est pas un échec du moteur.

Contrôles73/73, cohérence69/69 séparée du même agent ; productions actuelles journalisées sorties0. Aucun nouveau jeu/build/VM/REA/rendu/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Entrée furtive non observée dans les deux cas nominaux. Conditions historiques complètes, temps/interruptions/révélation/buissons, provider/varianteTT, teinte écran, lifecycle, bonus de sortie, transport et pixels ouverts. Traces par indicateurs qualifiées avec leur limite de conservation. QWER, V564/Nami et autres clauses ouvertes.

## 6. Corrections et reprise

Réutiliser SOURCE/SIMULATION-CONTRAT/SIMULATION/NETWORK/HUD. `COR-TEEMO-CAMOUFLAGE-POLICY-01` : qualifier délai, actions/interruptions, révélation, variantes et lifecycle. Fin : contrat historique sourcé, sans alias de faute ou sélection Map10 déduite du nom TT.

`COR-TEEMO-CAMOUFLAGE-STEALTH-STATE-01` : produire état furtif autoritaire et filtrage ennemi. Fin : entrée nominale, frontières, interruptions/refus, vues propre/alliée/ennemie et lifecycle vérifiés ; conserver projections complètes datées, pas seulement indicateurs.

`COR-TEEMO-CAMOUFLAGE-EXIT-AS-01` : appliquer bonus après sortie réelle. Fin : activation40%, durée3s, calcul de cadence/arrondis, composition, réinitialisation et expiration observés selon contrat ; prérequis entrée furtive effective.

`COR-TEEMO-CAMOUFLAGE-HUD-BINDINGS-01` : relier provider, icône/texte/teinte et état. Fin : transitions, audiences, transport et pixels observés. Reprendre sur preuve serveur/callsite nouveau, dérive ou autorisation fonctionnelle ; aucune réparation produit ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_teemo_passive_hud_20261105` : evidence_review/coherence_review, DDS/histoire, resource_provenance.json, phase_package_prerequisites.json et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes/sept protégés vérifiés à la publication. Une unité documentaire close, zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
