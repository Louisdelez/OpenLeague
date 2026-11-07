# D01-SYS-01-2 — champs System des templates natifs — V35

Relevé du 22 octobre 2026 (Europe/Zurich). Référence inchangée : PUBLIC
4.20.0.315, Releases/4.20, EUW/en_GB. Le catalogue4.20.1 reste distinct.

## Résultat et provenance

Les689 payloads candidats exacts conservés par V33 sont relus. Il s'agit du
profil explicite de ressources locales/globales de cette recherche ; la priorité
historique de découverte des skins, packages et namespaces n'est pas établie.
La source, la taille, le SHA et l'appartenance manifeste sont conservés.

Sur chaque ressource,16 requêtes exécutent les wrappers8B0630/8B1F50/8B1A80,
le cache et le parseur compilé originaux : **11024 requêtes**, **34038325
instructions observées**,6903PC,aucun accès invalide. Le processus d'expérience
termine normalement avec le code0. Le pilote16 requêtes reste séparé.

La feuille d'ouverture en lecture seule ajoute aux INIBIN le seul corpus
`.troybin` sélectionné et vérifie son identité. Les lectures et fermetures
virtuelles consomment exactement tous les octets. Aucun décodeur Python ne
remplit les tableaux de clés/valeurs invités. Chaque payload utilise un nouveau
contexte isolé de sections PE/cache ; le teardown historique du cache n'est pas
exercé. Les adaptations héritées d'allocation, chaînes/copie, thread/locale,
OS et journalisation restent déclarées dans les observations.

| Champ(s) | Attendu et observé |
|---|---|
| System/group-vis |16 valeurs stockées comme chaînes converties par le getter natif ;673 absences donnent le défaut natif250 |
| System/group-scale-cap |3 valeurs entières-1 converties en float ;686 absences. Le défaut2.0 des sondes est **fourni explicitement**, et ne qualifie pas le callback réel du gestionnaire |
| SoundOnCreate / SoundPersistent |71 /269 champs présents ;chaîne vide pour les absences |
| VoiceOverOnCreate / VoiceOverPersistent |21 /42 champs présents ;chaîne vide pour les absences |
| AudioFlexValueParameterName / AudioParameterFlexID |Absents des689 candidats ;défauts natifs chaîne vide / entier-1 |
| GroupPart1..8 |675,221,147,116,79,65,43,34 champs présents respectivement ;défaut-NONE- pour les absences |

Ces huit champs numérotés ne constituent pas une borne supérieure du nombre de
groupes. La suite de la boucle et la construction des groupes restent séparées.
L'absence de GroupPart1 dans14 définitions ne prouve aucune absence d'effet.

## Contrat de la sentinelle

La routineC98C70 appelée à918F5B renvoie le pointeur de la première sous-chaîne
correspondante ou0, sur les sept cas ASCII fournis. Les394 instructions
originales/62PC s'exécutent sans faute, allocation restante ou adaptation du
résultat de recherche. Le contexte initial de dispatch CRT est relevé.

`prefix-NONE-suffix` renvoie le pointeur à l'offset6 ;-none- ne correspond pas à
-NONE-. Un retour nul entre dans918FF9/918D50 ;un retour non nul saute ce groupe.
Il faut donc préserver cette sémantique de sous-chaîne et la distinguer d'un
comparateur d'égalité. Aucun comportement de locale ultérieure n'est extrapolé.

## Consommateurs actuels et vérifications

`tools/project-plan/audit_native_template_system_fields.py` est le consommateur
de référence en lecture seule. Il recoupe les octets, champs indépendamment
décodés, wrappers/callsites, résultats natifs, canaris du producteur, séquences de
lecture complètes et reçus d'exécution.46 contrôles passent :cas nominal,44
refus de preuves altérées et conservation des observations originales.

Deux consommateurs Rust existants sont inspectés sans mutation :

- `crates/core/src/native_troy_position_bounds.rs::Config::from_decoded_system`
  consomme un System déjà décodé et numérique, défaut250. Il ne convertit pas à
  lui seul les chaînes brutes de ces16 ressources.
- `crates/client/src/native_ambient_parent.rs::AmbientParent::new` consomme
  group-vis,SoundOnCreate etSoundPersistent pour une topologie ambiante Simple
  et l'enregistrement audio logique. Cette ancre ne qualifie ni les effets des
  champions, ni les voix, ni la lecture physique.

Aucun nouveau test Rust, build du jeu, processus Windows historique, rendu ou
écoute humaine n'est revendiqué. Les adaptations de ces expériences restent
distinctes des preuves CPU/rendu antérieures.

## Intégration et inconnues

Seules les traces et métadonnées SYS-01.2-02/03/06 sont enrichies. Une inconnue
composée existante garde son état ouvert et son historique. Les identifiants,
sources/versions et preuves antérieurs, la dernière tâche SYS-01.1-02, les cases,
notes, révisions et historique du plan restent conservés. Le reçu d'intégration
documente les contrôles réellement exécutés ;aucune acceptation n'est inventée.

Restent :le chemin complet918B30/918E90 et le gestionnaire réel, le montage et la
priorité des packages, les callbacks non nuls, le parsing/chargement et la durée
de vie des groupes non vides, le raccordement général aux producteurs Rust,
événements, rendu et audio. Les autres inconnues des six tâches, dont les deux
caps AIR4312/4313 et les divergences des scripts communautaires, restent ouvertes.

Preuve :`docs/fidelity_registry_native_template_system_revision_4_20.json`.
Observations et producteurs :`E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision35`.
