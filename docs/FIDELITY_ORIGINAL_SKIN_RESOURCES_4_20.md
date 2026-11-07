# Ressources de skins — chaîne originale et précision numérique

Référence : PUBLIC 4.20.0.315, EUW/en_GB, catalogue officiel 4.20.1. Les 668 identités sont composées par les instructions originales : enregistrement des alias, constructeurs/nœuds/insertion/équilibrage des arbres, Contains/GetResolvedPath, sélection de fichier/section, ajout de bin au nom.ini, lecture complète de 456 INIBIN, hash section/champ et getters typés. Les 5 344 champs sont comparés : 668 identités et 3 340 chaînes identiques, 1 258 valeurs numériques au même float32 et 78 différences de conversion float32 des valeurs normalisées en double. Les tableaux natifs ne sont pas remplis par le décodeur Python.

Les fichiers/dossiers retenus constituent un sous-ensemble explicite de la référence ; le bootstrap des providers/découverte des packages et le gestionnaire complet du cache/defaults/overrides restent non qualifiés. Les 112 questions Renekton gardent donc leur statut ouvert et leur ancien texte. La lecture compilée et les recherches dans les tables ne sont plus des frontières simulées ; allocation/free/copie, helpers de chaînes, thread/log et flux d’octets restent des adaptateurs détaillés dans le reçu. Aucun processus historique, fichier écrit par le client original ou build/test du jeu n’est lancé.

Douze échelles de base ont une différence d’un ULP entre le calcul numérique natif et la projection du cast du manifeste courant : Akali, Corki, Fizz, Kassadin, Orianna, Quinn, Sivir, Skarner, Sona, Veigar, Warwick, Zyra. Douze questions précises sont liées aux tâches ASSET-MESH, au fichier natif et à animation.rs::request. Le consommateur ordinaire Rust/jeu n’a pas été exécuté ici ; aucune fidélité visuelle ou correction du jeu n’est déduite. Les données du manifeste et toutes les métadonnées/casesSKIN restent inchangées.

Les hypothèses initiales sur le type desIDs et le retourAL du getter ont été corrigées avant publication : certainsIDs sont entiers ; le check de cookie valide doit conserverEAX. Les essais échoués restent dans le dossier revision7 et les régressions sont maintenues. Reproduction : `python -B tools/project-plan/exercise_original_skin_resources.py --root E:/OpenLeague --output CHEMIN_NEUF.json`. La preuve ne peut pas être écrasée. Reçu : [docs/reference_native_skin_loader_sources/original-skin-resources-execution.json](reference_native_skin_loader_sources/original-skin-resources-execution.json). Vérifications et conservation : [fidelity_registry_skin_resources_revision_4_20.json](fidelity_registry_skin_resources_revision_4_20.json).


## Portée du contrôle flottant

Les calculs natifs utilisent le contexte SIMD/x87 isolé enregistré dans le reçu. Le mode d’arrondi MXCSR et le contrôle x87 du processus historique restent à établir. Les 12 questions de précision le demandent explicitement. Le cast du manifeste est une projection du code courant ; le consommateur Rust ordinaire et le jeu ne sont pas exécutés ici.


## Comparaison matérielle et copie des sources distinctes

Les quatre instructions du calcul scalaire sont comparées sur le CPU Windows x64 de ce PC et dans Unicorn : 256 entrées octet, quatre modes d’arrondi, soit 1 024 résultats identiques. Le déplacement du littéral est relocalisé pour l’adressage RIP x64 ; ABI, capture et sauvegarde/restauration MXCSR/RBP sont des instructions de sonde explicites. Le MXCSR du thread est vérifié identique après chaque appel matériel. Le processus historique et son mode flottant effectif restent non qualifiés. Reçu : [original-scalar-hardware-crosscheck.json](reference_native_skin_loader_sources/original-scalar-hardware-crosscheck.json).

La consigne copiée groupe désormais les relations/sélecteurs par fichier natif, afin que les expériences répétées sur le même binaire ne masquent pas les deux configurations Renekton contradictoires. La régression vérifie leurs deux chemins et le maintien de la question ouverte.

## 2026-11-02 — sélecteur de skin du chemin champion actuel

### Source et appel consommateur

Le reçu natif `reference_native_skin_loader_sources/original-skin-resources-execution.json` identifie 668 skins officiels et 456 configurations INIBIN analysées. Il relie les identités et les champs natifs sous ses contextes déclarés, sans qualifier le montage historique complet. Le chemin Rust de création du modèle de base a été vérifié séparément : le catalogue `animation::Catalog` embarque `data/4.20/animation_manifest.json`; l’entrée `renekton` contient `scale`, `clips` et `roles`, sans champ `asset` ni identifiant de skin. `animation::request` reçoit `(id, name, catalog, assets)`, demande l’asset déclaré ou retombe sur `champions/{name}.glb`, puis retourne la scale. Dans `main.rs`, l’appel passe `p.champion`, sans `skin_id`, et applique cette scale au `Transform`.

Recherche bornée des sélecteurs `skin_id`, `skinid`, `selected_skin` et `skin_number` dans `main.rs`, `animation.rs` et `fow_champion_sources.rs` : aucun résultat. Aucun fichier nommé comme un module de skin n’apparaît sous `crates/client/src`. Cela qualifie seulement le chemin de modèle de champion inspecté, pas tous les systèmes de skin éventuels hors de ce chemin.

### Décision de clôture

**Audit du consommateur de modèle de base : terminé pour ce chemin — il sélectionne par nom de champion et ne reçoit pas d’identité de skin.** Les 668 identités natives ne sont donc pas toutes des skins consommés par cet appel. **Sélection et rendu des skins : non intégrés par ce chemin.** Les 112 questions de priorité Renekton restent ouvertes : elles concernent la sélection historique/base/overlays et ne sont pas résolues par l’absence d’un `skin_id` dans le callsite Rust. Aucun client, test, rendu ou GPU n’a été lancé pour ce lot.

Reprise fonctionnelle quand une identité de skin est ajoutée au contrat de création et reliée à un consommateur de modèle. Reprise de la priorité historique Renekton seulement avec qualification du bootstrap, des providers/cache et de l’ordre effectif ; ne pas substituer le modèle de base ni une entrée de catalogue à une décision historique sur les skins.