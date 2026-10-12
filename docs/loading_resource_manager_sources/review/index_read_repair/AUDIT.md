# Réparation isolée de l'ordre de lecture de l'index

Le candidat corrige les deux écarts INDEX-READ-01/02 du rapport intégré, sans toucher le manager, son inventaire ou le curseur de retrait. `insert_hint` lit count avant head et ne charge la clé qu'au point source de sa branche. `insert_at` relit head après les publications de liens et avant la couleur de root ; la branche de recoloration relit parent/grandparent dans l'ordre5DA5E0. Les deux relectures omises de `rotate` (child après publication, parent sur la branche hors root) sont également rétablies d'après5C64E0/5C6540 et leur version inline.

Les quatre clés statiques réelles déclenchent les branches vide, minimum, maximum, puis prédécesseur/recoloration. Elles ne déclenchent aucune rotation. Les corrections des deux relectures de rotation reposent donc sur les opcodes extraits ; aucune couverture dynamique de rotation, fallback ou callback mutateur n'est revendiquée par cet oracle.

## Oracle natif exécuté

`probe_index_read.py` copie le mécanisme du probe manager gelé et lit le même PE épinglé402bf2b9…. Les octets de chaque instruction exécutée sont comparés à ce PE. Les seules primitives adaptées restent allocation/free/copieur mémoire. Aucun fournisseur ni résultat de lookup n'est injecté.

Chaque scope démarre au premier opcode5BD9B0, avec ECX/tree, ESP, retour original et key_ref capturés. Il se termine au hook CODE du retour original avec ESP=entry_sp+8 (ret4), avant les écritures du caller. La capture retient uniquement les adresses de la banque canonique33000000..33400000, les quatre octets du key_ref original, et les globals de routage de free14BEF40/44. Les arguments ABI, les spills stack, cookies et FS/SEH sont exclus. Chaque lecture conserve largeur et EIP dans `read_sites`. Les écritures sont normalisées par octet ; les lectures gardent leurs largeurs natives.

Résultat natif : **deux constructions et huit insertions réelles, 232 lectures**. Le probe vérifie encore les snapshots du manager et l'ordre des frees du lot gelé. `source_index_read_regions.json` conserve les octets/hashes de huit fonctions, avec zéro edge hors fenêtre.

## Deux tests Rust ajoutés

- `audio_loading_resource_index_matches8_native_insertions_including_exact_read_order` : part de chaque snapshot natif avant appel, reconstitue uniquement l'inventaire des allocations déjà existantes, appelle le vrai index privé, compare la séquence complète read/write/allocate, le slot, les octets et allocations finales ; huit appels,232 lectures.
- `audio_loading_resource_index_each_native_read_failure_preserves_partial_constructor_ownership` : échoue successivement chacune des232 lectures, compare le préfixe observable jusqu'à l'erreur, vérifie que l'inventaire conserve chaque allocation, puis échoue un free atomique et reprend le retrait sans double free. L'erreur primaire de lecture demeure distincte du nettoyage.

Ces tests n'ont **pas été compilés ou exécutés par cet agent**. Root doit les qualifier avec le lot assemblé. Aucun test existant n'est supprimé ni renommé. Le nouveau module de tests est déclaré uniquement sous cfg(test), depuis l'index.

## Installation prévue et limites

Trois deltas seulement : remplacer `crates/core/src/audio_loading_resource_manager_index.rs`, ajouter `crates/core/src/audio_loading_resource_manager_index_read_tests.rs` et ajouter `data/4.20/loading_resource_index_read_contract.json`. Les contenus avant/après, manifestes assemblé/installé et preuves sont épinglés dans `repair_manifest.json`. Le patch textuel est fourni pour revue ; aucun delta n'a été appliqué en production par cet agent.

La compilation précédente a été interrompue par root après identification de l'écart ; son log reste distinct. L'exécution native réussie ne constitue pas un résultat de test Rust. Aucune fabrique de fournisseur, cache peuplé complet, interface de chargement non vide ou startup intégral n'est qualifié ici.
