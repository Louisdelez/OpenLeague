# Ashe — sources et consommateurs des VFX du passif

2026-11-05 · V1329 · AUD-SYS-01.2-02-ASHE-PASSIF-VFX-LEGACY-SOURCE-CURRENT-LINK-01

## 1. Exigence, frontières et fin

SYS-01.2-02 ; CH-Ashe-PASSIF-PRESENTATION-VFX, OLF-ff63c9cd-9388-594d-b7cc-65e59e110aed. Qualifier la branche Ashe du reçu partagé V537 et les consommateurs pertinents. Son contrat demande les effets de lancement, trajet et impact applicables ; dépendance CH-Ashe-PASSIF-NETWORK conservée. Phase D06 et lot hérités, aucun prérequis accepté implicitement.

Fin du présent audit : provenance et portée des vues disponibles, code réel ou manque borné, contrôles et corrections précis. Audit documentaire terminé après publication vérifiée ; implémentation spécifique non établie dans les corps sélectionnés, mécanique générique conservée ; vérification statique seulement, acceptation humaine non donnée. Inventaire VFX complet et rendu exclus. Les deux associations Tryndamere restent intactes, sans audit ni clôture.

## 2. Sources et identités

Référence PUBLIC4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue officiel4.20.1 distinct. Copie V1322 de ashe-tryndamere-passive-boundary-links-v537.json :370589octets, SHA134107704ce06d179a91ace60f29ad192ee2bf3479e1fe9a2a3ca45285004432, identité vérifiée avant usage. V537 vise SIMULATION-CONTRAT/SIMULATION, pas un inventaire VFX ; ses observations ne sont pas réexécutées.

V1184 conserve Focus.luaobj :202octets, SHAbc782c78f7914d988ab2501fc92333ed692aa571d18d414a5d90ea75330d14e5, neuf instructions, zéro enfant, lecture complète. Quatre littéraux qualifiés aux PC1/3/5/7 : BuffTextureName=Ashe_Passive.dds, BuffName=Focus, PersistsThroughDeath=true, NonDispellable=true. Symboles moteur non résolus ; pas de corps serveur retrouvé. CharScriptAshe :56octets, SHA7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0, une instruction, zéro enfant, globals vides. Aucun AutoBuff dans ces vues, sans absence native déduite.

V1174 avait vérifié neuf identités natives et72contrôles. AsheCritChance nomme le DDS gris ; AsheCritChanceReady contient le DDS normal et Ashe_Base_P_buf_geo.troy. Son validateur teste la présence de chaînes dans les octets : cela ne qualifie pas le champ d’affectation, la recette complète, l’ouverture ou le rendu. Ces deux ressources ne deviennent pas deux lectures Lua structurées nouvelles. Les DDS sont distincts ; leurs identités et le manifeste restent hérités, non redécodés.

Le tooltip en_GB ligne1917 conserve @f1@, trois secondes et100charges ; ancien Passive1Desc « every3seconds » distinct. Aucun taux numérique inventé. Les quatre observations V537 aux ticks0/90/900/5400 restent historiques : 0de critique de base ne prouve pas absence de Focus ni activation à100.

## 3. Consommateurs et réemploi

Cinq fichiers relus : crates/core/src/attacks.rs, progression.rs, critical.rs, spells.rs et crates/client/src/projected_live.rs ; huit ancres exactes. SOURCE14entrées et HUD6entrées comparées par empreinte aux reçus précédents, toutes concordantes. Ce sont des entrées de code/données/outils, pas14nouveaux consommateurs. Quatorze identités communes V1315 inchangées permettent le réemploi des frontières VFX.

stats additionne critique de profil, croissance et objets ; roll_critical refuse les valeurs non finies/non positives, garantit chance>=1 puis utilise SplitMix64 reconstruit. L’attaque conserve les règles Garen/Trundle, le tirage mémorisé et le projectile générique. Aucun de ces chemins n’est un producteur Focus qualifié.

La recherche nommée dans les cinq préfixes de production trouve seulement attacks.rs:271, commentaire sur Annie/Ashe et le hit au lancement. Il ne crée ni charge ni effet Focus. La conclusion de corps SOURCE antérieure est réutilisée sous empreintes, sans nouveau census Rust. projected_live sélectionne Annie Q ; le HUD Ezreal et les panneaux QWER déjà audités ne deviennent pas un HUD ou un VFX Ashe. Aucune absence globale affirmée.

## 4. Attendu, observé et contrôles

Attendu nominal statique : conserver les rôles source, reconnaître le type de preuve Ready et établir les frontières courantes. Observé :47/47contrôles qualifiés,36/36cohérences séparées du même agent, huit ancres, gardes SOURCE14/HUD6/communes14 concordantes.

Le collecteur initial46/47 attendait zéro occurrence nommée ; le commentaire réel a provoqué code1. Résultat et journaux conservés. Un seul prédicat qualifié sur le texte exact : commentaire de projectile, pas producteur ; les46autres et toutes observations inchangés. Une requête d’affichage seule a aussi échoué sur le nom schema au lieu de root_schema ; aucun contrôle source modifié.

Refus/limites lus : valeurs critiques invalides et branche spécialisée Annie, sans exécution. Anciennes validations HUD/SOURCE et simulations non rejouées. Aucun test Rust, build, jeu, réseau, GPU, REA, lecteur natif, accès/stat/résolution D ou comparaison de pixels nouveau.

## 5. Écarts et inconnues

Lecture structurée Ready, inventaire secondaire complet, applicabilité des phases, recette, producteur f1/100charges, sélection réseau, owner/skin, audiences, attache, cadence, montage et rendu restent ouverts. Un nom Troy ne prouve ni son absence ni son fonctionnement. Les IDs d’inconnues VFX/SOURCE et consommateurs inscrits sont conservés exactement.

V1322 demeure immuable. Zéro tâche SOURCE/SIMULATION/NETWORK/VFX complète, feature, inconnue, acceptation ou goal clos. Identités vérifiées aux lectures, sans garantie globale TOCTOU. Aucun pourcentage de jeu déduit.

## 6. Corrections et reprise

Réutiliser CH-Ashe-PASSIF-PRESENTATION-VFX, clauses ready-source-visual-contract, focus-state-owner-world-link et resource-lifecycle-render-acceptance. Chaque clause possède objectif, prérequis, fin et reprise dans corrections_and_restart.json. SOURCE et NETWORK conservent leurs propres critères.

Reprendre uniquement avec source/copie attribuable, lecteur, appel, capture ou dérive pertinente. Ne pas générer une texture pour remplacer une recette inconnue. Prochain lot : CH-Tryndamere-PASSIF-PRESENTATION-VFX, examiner sa branche V537 et ses propres ressources/consommateurs, sans recomptage Ashe.

## 7. Livraison et conservation

Preuves E:/mapslol3v3/audit_sys01202_ashe_passive_vfx_20261105 : copies retenues, initial_scope, inspection, current_inspection, evidence_review original/qualified, coherence_review et journaux. Sept rubriques vérifiées ; relecture du même agent, non revue indépendante ni acceptation humaine.

Publication limitée à ce rapport et ajouts CURRENT/HANDOFF après sauvegardes exactes, sept registres protégés inchangés. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2316 entrées sales groupées conservées. Goal/Plan/UI/bases/registres/produit/assets inchangés ; aucune installation, migration, suppression, relance ou mutation Git.
