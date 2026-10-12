# Proposition : wrapper replay12 octets5CCEB0

Proposition scratch uniquement. Aucune source de production modifiée ; aucune compilation rustc/cargo lancée pendant les builds root.

API ajoutée à la copie de `audio_replay_callbacks.rs` :

```rust
pub fn invoke12(
    b: &mut impl audio_replay_events::Boundary,
    p: u32,
    args: [u32; 5],
) -> Result<u32, Error>;
```

Le caller choisit explicitement ce wrapper pour la famille `108606C+8=5CCEB0`. Il lit `*args[0]`, `callback+4` (owner), puis `callback+8` (membre), dans cet ordre. Les quatre arguments suivants traversent la frontière comme valeurs, sans lecture indirecte. Aucune lecture `callback+12`, aucun ajustement du propriétaire. Le résultat conserve tous les32 bits. `Boundary::member_call` est celui du port existant `audio_replay_events`, et une erreur de consommateur non raccordé reste une erreur. Le `invoke` historique sans arguments garde son refus explicite ; aucune famille n'est activée implicitement.

`callback12.patch` contient seulement cette fonction et l'ajustement du commentaire de module. `audio_replay_events.rs` est une copie inchangée pour le harness, pas un fichier à réintégrer. Les copies `body_*.rs` retirent seulement les modules de tests indépendants pour permettre la future compilation isolée.

## Preuve native exécutée

`probe_callback12.py` charge le PE4.20 réel et vérifie SHA256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Les instructions de `5CCEB0` s'exécutent sous Unicorn. L'objet est exactement12 octets en fin de page ; la page suivante est interdite en lecture.

`callback12_native_probe.json` : **96 cas passés**, couvrant propriétaires0/normal/FFFFFFFF, deux adresses de membres réels729370/72C780, quatre retours de frontière (0,1,ABCDEF00,F1234501), référence arg0 indépendante ou alias du vtable/owner/member. Comparaisons : ordre des trois lectures, this et cinq arguments remis au terminal, retour32 bits, absence de mutation de l'objet, restauration EBP et pile équilibrée (+24).

Contrôle négatif exécuté : appliquer le wrapper16 octets734130 au même objet produit `UC_ERR_READ_PROT` exactement à callback+12, sans appel terminal. Cela démontre que la protection de queue détecte la lecture indue qu'il faut éviter.

Les membres729370/72C780 sont interceptés **avant leur corps**, uniquement pour tracer leurs paramètres et fournir un résultat de frontière explicitement déclaré. Aucun consommateur terminal, metadata, réseau, frame ou gameplay n'est exécuté ni prétendu reconstruit par cet oracle. Les adresses et la valeur du retour sont des entrées contrôlées de la qualification du wrapper.

## Tests Rust préparés, non exécutés

`callback12_tests.rs` contient trois tests : comparaison aux96 traces natives ; différenciation12/16 octets et refus de la queue ; propagation de l'erreur terminale et des références absentes avant invocation. La mémoire de test réserve seulement12 octets au callback.

`prepare_harness.py` prépare `callback12_harness.rs` et les sources isolées, sans lancer de compilateur. Après les builds root, il faudra compiler ce harness avec `--test --edition=2021` et la dépendance serde_json du workspace, puis exécuter le binaire. À cette livraison, seuls les résultats natifs sont observés ; les tests Rust restent à valider.
