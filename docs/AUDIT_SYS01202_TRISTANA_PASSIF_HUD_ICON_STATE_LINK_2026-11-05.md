# SYS-01.2-02 — Tristana : Draw a Bead et HUD, V1283

5 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-TRISTANA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Tristana-PASSIF-PRESENTATION-HUD`, `OLF-53dec9bf-e613-5d98-8f8e-a62172e2f3bc` : relier progression de portée, attaques/E/R, icône et texte aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-be85d33f-3a98-5663-8dd2-ae32cbc04594` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/D06-CH-Tristana consultés, sans satisfaction revendiquée. Parent PRESENTATION, QWER et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/tristana-passive-draw-a-bead-links-v640.json`, 3547996octets, SHA `e18481aefa95a517a449fb0268f2d6c014630d9f96a56f6dc2916f5e04409698`, UTC documentaire 2026-10-26T21:16:08.474428+00:00, sans attribution à l’heure d’exécution.

HUD enregistré : définition/CharScript et un catalogue. SOURCE :35relations/30identités/six sites/trois fichiers. V640 :30membres/90associations,18sites/huit fichiers ; union10fichiers/24ancres, plus deux consommateurs HUD complémentaires. Aucun ID SOURCE supplémentaire ; registres gelés conservés. Réutilisation sans relecture native :14INIBIN,11Lua,4preloads,font.

Définition : Passive1LuaName littéral **Draw a Bead**, icône Tristana_DrawABead.dds, AttackRange chaîne550. PARType/Passive1/Passive1Desc/six niveaux absents, aucune conversion en zéro. CharScript vide56octets à la racine du personnage. La recherche conservée dans le deploy fourni par motif *Tristana*.ddf n’a aucun résultat ; trois candidats DDF absents et CharScript présent. Cela ne prouve pas une absence mondiale ou l’absence d’un autre mapping de formule.

Font1851 : portée d’attaque et portées de lancement d’Explosive Shot/Buster Shot augmentées de f1. Description4290 : portée d’attaque croissante avec les niveaux. **Valeurs de progression et producteurs f1/Effect1 non résolus** ; aucune règle9parniveau supposée. Définition E=DetonatingShot, R=BusterShot, CastRange550.0000 dans les champs sélectionnés, sans application du bonus démontrée.

Six BuffData exactement résolus. Noms avec espaces conservés séparément des noms de sorts sans espaces ; aucun alias automatique. 11Lua sans fonctions enfants, sept limites NEWTABLE ; persistance/non-dissipation/preloads ne prouvent pas un lifecycle ou un callback serveur. 19références communautaires : CharScript vide, Q producteur non retrouvé dans le sous-arbre, W sans saut démontré, E à charges divergent du DoT/réduction des soins natifs, R sans recul démontré. Aucune règle communautaire promue en autorité native.

Un DDS nécessaire `DATA/Characters/Tristana/HUD/Icons2D/Tristana_DrawABead.dds` :4224octets,64×64 DXT5, compteur de mips brut0, SHA `3aadf2f5989d4e0d91ab84194ea08b763d35a53c75e1b7eebbc9de0878997d0d`. Projet RADS0.0.1.7/membre0.0.0.248, taille/MD5 concordants ; sélection E avant unique stat/lecture SOURCE. Aucun DDS étranger/particule lu. Provider/pixels ouverts ; font miroir et témoin Ahri réutilisés.

Mana courant : source_sha256 identifie StatsJSON communautaire 4543octets/SHA `1fe1af5260792a65c4a023a50238175e17f4ca1913673dd935fbcebfcbc94219`, distinct de l’INIBIN natif 1614octets/SHA `93e718ddcca0312b2c79b1c521228dc03598cba96531bce24c9d1d4133d05952` ; resource_provenance.json.

## 3. Consommateurs actuels

24ancres exactes,29fichiers code/configuration vérifiés et16entrées communes inchangées. Aucun producteur nommé Tristana/DrawABead dans le périmètre Rust sélectionné ; recherche bornée.

combat.rs:25/36 lit directement définition.attack_range + rayon cible pour poursuite ; attacks.rs:155 reprend cette valeur pour validation. world.rs:226 construit le rayon cible depuis collision::body_radius ; collision.rs:29 applique un **repli local65** si gameplay_radius absent,40 si valeur non positive. Le profil Garen conserve gameplay_radius=null ; sélection75 et pathfinding35 ne sont pas ce rayon. Aucune fidélité historique du repli65 accordée.

Learn et casts Tristana refusés. HUD maxima/apprentissage exclut Tristana ; les consommateurs génériques Mana/rangs ne qualifient pas f1 ou une portée effective affichée. Un simple catalogue de base550 n’est pas un producteur de portée dépendant du niveau.

## 4. Attendu, observé et contrôles

Diagnostic de niveaux hérité : Tristana garde définition550 aux18niveaux ; Annie625 sert de témoin. 144prédictions : Tristana72Learn et144Cast/CastAt refusés,0/0/0/0 ; Annie18Learn acceptés/54refusés,5/5/5/3. Total278refus de commandes et10XP. Succès Learn sans valeur distingué du rang prédit ; snapshots bruts Tristana inchangés par niveau, autres refus par flags, aucune garde NPC universelle.

Phase niveaux :36attributions XP par API serveur, zéro tick simulé, pas de progression naturelle ou réseau. Phase portée :quatre scènes publiques niveaux1/18, chacune à550ou650, huit trajets sans réordre,7640ticks archivés, deux attributions XP supplémentaires19245 pour niveau18. Au total,38attributions diagnostiques ; aucune progression naturelle n’est qualifiée.

Coordonnées recalculées : à550, aucun déplacement avant windup ; à650, déplacement43.33203125, windup à606.66796875, identique aux niveaux1/18. Seuil **calculé local615=550+65**, non frontière empirique exacte615, non mesure du rayon natif. Premier tick :poursuite à650, windup immédiat à550. Quatre témoins de lancement/projectiles source/cible/release vérifiés ; ce sont des lancements, pas des impacts ou dégâts mesurés.

Attendu natif qualitatif : croissance avec niveau. Aucun accroissement observé dans les chemins vérifiés. Sans valeurs historiques qualifiées, ne pas conclure qu’une attaque aurait dû partir à650 au niveau18. Géométrie des niveaux2–17, frontières exactes et cibles mobiles non testées. Aucun E/R accepté, portées effectives de sorts non exercées.

Historique27fichiers/21018042octets,25empreintes anciennes/deux nouvelles. RUN corrigé brut identique au relevé ; binaire 6087680octets/SHA `2630b5ac6b1f37a26c371dc66c177c267f1f6b32a90ddc4075019c2f26224048` inerte, BUILD/RUN corrigés0. Ancien BUILD0/RUN101 sur unwrap du rayon absent conservé avec binaire/logs/source ; correction du diagnostic, pas du moteur. Première découverte1/FileNotFoundError DDF, garde de génération faussement sensible à threshold et copie non générée conservées par les preuves antérieures ; aucune compilation déduite de cette tentative.

Contrôles238/238, cohérence116/116 séparée du même agent ; productions actuelles journalisées sorties0. Aucun nouveau jeu/build/VM/REA/rendu/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Progression numérique, f1/Effect1, actualisation de niveau, collision historique, portée effective partagée et E/R non qualifiés. Interactions/ordre/arrondis, audiences, provider et affichage ouverts. QWER, V564/V606/Nami et autres clauses conservés.

## 6. Corrections et reprise

Réutiliser SOURCE/SIMULATION-CONTRAT/SIMULATION/NETWORK/HUD. `COR-TRISTANA-DRAW-A-BEAD-POLICY-01` : qualifier valeurs par niveau, f1/Effect1, temps d’application et géométrie. Fin : contrat historique sourcé, rayon absent/repli local explicités sans formule inventée.

`COR-TRISTANA-DRAW-A-BEAD-ATTACK-RANGE-01` : fournir portée autoritaire effective commune à poursuite/validation/windup. Fin : chaque niveau, frontières, cibles mobiles et changement de niveau pendant action vérifiés ; ne pas modifier globalement le catalogue partagé pour une seule instance.

`COR-TRISTANA-DRAW-A-BEAD-CAST-RANGE-01` : appliquer la politique à E/R via leurs tâches existantes. Fin : casts acceptés/refusés aux bonnes distances, temps d’évaluation et cibles vérifiés ; pas de blocage du parcours attaque de base sur tout QWER.

`COR-TRISTANA-DRAW-A-BEAD-HUD-BINDINGS-01` : relier valeur effective, f1, icône/texte et portées affichées. Fin : progression, transitions, transport et pixels observés. Reprendre sur source/callsite nouveau, dérive ou autorisation fonctionnelle ; aucune réparation produit ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_tristana_passive_hud_20261105` : evidence_review/coherence_review, DDS/histoire, resource_provenance.json, phase_package_prerequisites.json et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes/sept protégés vérifiés à la publication. Une unité documentaire close, zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
