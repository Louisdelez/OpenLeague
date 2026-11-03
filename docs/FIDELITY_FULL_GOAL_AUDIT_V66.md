# Audit des six objectifs du Goal — V66

Les six objectifs SYS-01.2-01 à06 restent intacts. V66 précise sept contrats locaux de construction et transport avec23sites actuels. Deux exigences n’ont que des frontières de configuration ;aucun des sept périmètres n’est terminé ou accepté. Un contre-exemple supplémentaire corrige la portée de Cargo metadata avant la livraison.

| Objectif original | Évidence actuelle | Travail ouvert |
|---|---|---|
| 01 — Identifiants stables | 42757 identités et liens structurels vérifiés | Acceptation humaine non déduite |
| 02 — Sources et consommateurs | 92508 sources,318 ancres ;sept liens locaux précisés | 890liens génériques,1472frontières seules ;sept périmètres locaux,six Map10 et quinze de combat partiels |
| 03 — Origine,version,SHA | Métadonnées présentes ;176entrées/delta relues et318ancres contrôlées ;92345anciens enregistrements/294ancres conservés | V65héritée ;aucun scan global ni authentification indépendante du publieur des archives locales |
| 04 — Divergences natif/Data Dragon | Comparaisons et recherches précédentes préservées | Deux caps4312/4313 :rôle de Ranks4 et autorité effective historique face au ranks3 du catalogue |
| 05 — Scripts communautaires | Études et17profils Garen Q conservés avec leurs rôles | Dispatch original,effets réels et autres évaluations nominatives |
| 06 — Inconnues | 30835questions structurées ;sept recherches affinées | 25321ouvertes,5514résolues ;aucune clôture nouvelle |

Les sources Rust/build sont des contrats locaux explicites. Elles ne sont pas présentées comme une spécification native Riot4.20 et aucun lien natif n’est inventé pour ces sept exigences. Les deux frontières sans fonctionnalité sont le verrouillage de Rust/cibles Windows et le remplacement de bibliothèque conditionné à un cas mesuré. Elles restent comptées dans les lacunes.

Le workspace déclare1.90 ;les six packages retournent rust_version=null dans les métadonnées. Rust/Cargo1.96.1 et les trois cibles installées ont été observés ;aucune cible n’est qualifiée par une nouvelle construction. Les locks sélectionnent Bevy0.19.0,wgpu29.0.4et Tauri2.11.5. Le wrapper webview2-com0.38.2ne donne ni version installée ni verrouillage du runtime WebView2. Le frontend local et le transport UDP/JSON ont des sites précis ;leurs limites réseau et leur rendu ne sont pas mesurés ici.

Les deux archives locales de crates sont comparées aux arbres vendor sans extraction. L’animation modifie lib.rs et transition.rs pour partager AnimationDelta. Le rendu modifie screenshot.rs et ajoute screenshot_copy_witness.rs. Le lock propre à l’archive animation manque dans son arbre vendor ;les locks du workspace et du launcher sont présents et inchangés. Le premier comparateur attendait un .cargo-checksum.json absent :échec conservé,portée corrigée sur les vrais fichiers disponibles. Aucun checksum officiel indépendant n’est inventé. Les différences brutes restent conservées ;la vue normalisée LF sert seulement à lire le contenu.

Deux commandes metadata --locked --offline --no-deps ont réussi sur les manifestes du projet. Une vérification ultérieure apporte deux nouveaux petits projets sans dépendances :le premier sans lockfile,le second avec un lockfile mal formé. Les deux réussissent aussi,resolve=null,et leurs locks restent respectivement absent ou inchangé. Le succès metadata ne prouve donc pas la consommation/validation des locks,leur cohérence dans une résolution réelle ou une construction reproductible. La formulation initiale V66est explicitement corrigée ;l’ancien reçu et les trois anciens scopes restent en historique. Voir docs/FIDELITY_DEPENDENCY_LOCK_SCOPE_4_20.md et docs/reference_dependency_sources/no-deps-lock-scope.json. La portée ne prétend pas décrire tous les modes de Cargo.

12contrôles de source,28contrôles de lecteur/27refus et7contrôles de correction/6refus passent. Le lecteur installé vérifie147identités et23sites ;les deux commandes du projet et les deux nouveaux profils ne sont pas rejoués pour reformater la preuve. La livraison passe31contrôles. Les42214consignes actives et14couples HTTP lecture/copie concordent après correction ;dix seules métadonnées/consignes changent :trois du référentiel et sept des contrats locaux.

Les42606états manuels,notes,révisions et22entrées d’historique restent identiques. Les anciens enregistrements et consommateurs sont conservés ;seuls trois scopes nouvellement créés dans V66sont rétrécis avec historique par la correction. Tauri pointe sur la même base ;sa fenêtre native n’est pas observée. Aucun Rust/C de production,asset,lockfile ou binaire du jeu modifié. Un lecteur Python de preuves est ajouté ;aucune compilation,exécution du jeu/serveur/Blender ou qualification GPU nouvelle.

Les liens génériques passent de897à890 ;deux frontières seules sont ajoutées. Le compte combiné des liens génériques/frontières passe de2367à2362. Les sept périmètres locaux restent ouverts,ainsi que Map10,combat,Garen Q,les deux caps,les autres scripts communautaires,42autres fichiers vides,12décisions d’adoption et la chaîne parent du marqueur.

Les six objectifs gardent leurs états :01/03/06àvalider,02/04/05partiels. Le Goal demeure actif. Livraison :docs/fidelity_registry_dependency_links_revision_4_20.json. Étude initiale :docs/FIDELITY_DEPENDENCY_SOURCE_LINKS_4_20.md,à lire avec la correction de portée citée ci-dessus. Audit JSON :docs/fidelity_goal_completion_audit_20261022_V66.json. V65,SYS-01.1-02 et toutes les preuves antérieures sont conservés.
