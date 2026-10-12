# Préparation non compilée : préfixe standard57D6FE..57D775

Ce dossier est un candidat Rust en scratch. Aucun compilateur, test Rust,
installation production, texture, UI ou factory normale n'a été exécuté ou
déclaré terminé dans ce lot. Les128 vies natives sont la preuve gelée du lot
précédent ; leur reprise comme fixture ne crée pas de nouvelle qualification.

**Non prêt pour intégration.** La réutilisation de l'affectation String24 doit
d'abord disposer d'une stratégie d'appartenance sûre après publication
partielle et erreur d'écriture hôte. La parité des128 chemins natifs normaux
ne qualifie pas ce rollback. Le helper global n'a pas été corrigé dans ce lot.

## API et contrat

`audio_loading_standard_prefix::prepare(b, recipient, retained_service, payload,
name24, scratch8) -> Result<Stop, metadata::Error>` traite l'override de nom,
l'appel au vrai72AE40, puis la sélection de skin jusqu'à la frontière suivante.
`Stop` décrit soit l'appel991E60 encore non exécuté, soit la requête90AD00 encore
non exécutée. Ce résultat n'est pas un succès de chargement.

Le nom est déjà possédé par le caller. Le préfixe ne le détruit pas ;
`loading::receive` conserve son cleanup standard, y compris sur une erreur.
Le service passé est celui conservé avant l'appel du provider de nom. La
signature de `initialize_standard_record` reçoit maintenant cet argument.
Le préfixe ne relit jamais `SERVICE_GLOBAL`.

L'ordre natif est conservé : longueur override, assign si adresse différente,
clé payload, table du service conservé, slot+4C, vrai72AE40, test signé du skin,
puis seulement si non négatif global package2D78F1C et override recipient+1A0.
Le diagnostic négatif précède tout override skin. Le troisième mot de pile
devant90AD00 est du résidu de registre opaque, non lu par son corps ; il reste
dans l'oracle ABI, sans sémantique inventée dans la requête portable.

## Réutilisation des fonctions existantes

La fonction privée `audio_loading_metadata::assign` est renommée
`pub(crate) assign_owned_non_alias`. Son algorithme reste inchangé : affectation
entière, offset0/countMAX, capacité de destination conservée ou agrandie,
copie de l'ancien contenu avant libération lors de croissance, publication de
la nouvelle longueur. Le caller évite la même adresse ; les buffers partagés
et alias partiels restent hors contrat. Ce changement ne publie pas un clone
de String24 fraîche à la place d'une affectation.

Le vrai `service_extra` est appelé après validation du slot72AE40. Il conserve
l'acquisition/libération de la paire metadata et le vrai resolver/index. La
valeur ECX du service est inutilisée par72AE40, mais le caller lit sa table
par le pointeur conservé et ne remplace pas cette lecture.

Revue indépendante reçue de `replay_path_registry` : PE et régions564AF0/564F30
revérifiés, corps du helper strictement inchangé, aucun blocage identifié pour
les chemins succès valides/exclusifs. Deux limites du helper existant demeurent :
à564BCB, le natif lit la capacité avant d'écrire la longueur, alors que le helper
écrit la longueur puis relit la capacité ; les états sont équivalents pour le
stockage exclusif stable de ce contrat, pas pour des hooks arbitraires qui
muteraient ces champs entre les accès. Une erreur injectée d'écriture après
la libération de l'ancien buffer, avant `adopted=true`, peut laisser un pointeur
ancien ou nouveau déjà libéré et conduire à une seconde libération pendant le
cleanup appelant. Aucun rollback de ce type n'est qualifié par les128 vies.
Le lot ne modifie pas ce mécanisme général et ne le présente pas comme résolu.
Il doit être traité dans la qualification d'erreurs avant d'élargir le contrat
au-delà d'une destination valide, exclusive et stable.
Avant toute intégration, définir la transition de propriété exacte de l'ancien
et du nouveau buffer et qualifier l'adaptation d'erreur hôte séparément de la
parité native succès, sans double libération ni fuite silencieuse.

## Fichiers proposés

- Nouveaux `audio_loading_standard_prefix.rs` et `_tests.rs`.
- `audio_loading_metadata.rs` : visibilité/nom de l'assign seulement.
- `audio_loading_screen_packet.rs` et `_tests.rs` : argument service conservé.
- `audio_replay_windows_loading_packets.rs` : scratch8 exclusif puis erreur
  explicite selon la frontière ; aucune ressource ou UI fabriquée.
- `audio_replay_windows_loading_packets_tests.rs` : le test standard prépare
  ses vrais inputs diagnostiques et attend désormais la frontière90AD00.
- `loading_standard_prefix_probe.json` :128 cas natifs inchangés avec trois
  tables PE ajoutées pour initialiser le host de test, sans nouveau run natif.
- `base_manifest.json`, fichiers `base_*.txt` et `changes.patch` : bases et diff.

Ajouter au `lib.rs` : `pub mod audio_loading_standard_prefix;`. Installer la
fixture sous `data/4.20/loading_standard_prefix_probe.json` seulement dans le
lot d'intégration qui qualifiera ce code.

## Prérequis image Windows

`runtime_image_requirements.json` décrit les quatre octets PE exacts manquants
à2D78F1C, groupe1. Extracteur, table Rust, binaire et manifeste doivent être
modifiés ensemble puis revérifiés contre le PE avant le test Windows. Copier
la valeur initiale0 ne construit pas le gestionnaire package. Le préfixe
s'arrête explicitement avant de l'utiliser. Sans cette région, une erreur de
lecture précèderait la frontière90AD00 attendue ; ce cas n'est pas présenté
comme une intégration prête à compiler telle quelle.

## Tests préparés, non exécutés

Le premier test compare128 invocations complètes de `loading::receive` aux
blocs vivants, allocations/libérations, données String24, records et frontières
de l'oracle. Les providers de nom/skin, le resolver et l'index sont les corps
Rust existants. Aucun retour de nom/skin/index n'est substitué par la fixture.
Les octets préparés natifs initialisent la mémoire ; seules les primitives
d'allocation/verrous sont fournies par le host, comme dans l'oracle natif.

Le second couvre six invocations où le premier provider modifie le global
service après sa lecture : l'ancien service conservé reste utilisé, sans
seconde lecture du global. Ce cas teste une propriété du port et n'est pas
présenté comme une mutation exécutée par l'oracle natif.

Le cleanup natif du lot source a été mesuré séparément : le harnais abandonnait
les frontières et rejoignait57DCAE après avoir retiré leurs arguments de pile.
Le test Rust compare son cleanup d'erreur à cet état, sans prétendre qualifier
un retour réel de991E60/90AD00 ou un déroulement d'exception natif.

Les parents et leurs ressources restent possédés par la fixture de chaque
appel ; la destruction native totale existe dans le lot source. Ces nouveaux
tests ne démontrent pas une factory, un rendu, un gameplay ou un réseau.
