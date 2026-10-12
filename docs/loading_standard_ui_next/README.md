# Prochaine tranche standard : choix du nom et du skin, avant90AD00

**Inventaire statique et oracle natif borné, sans port Rust, compilation ni
changement production dans ce lot.** La production contient maintenant le nom
standard vide et conserve l'erreur explicite à57D6FE pour un nom non vide. Les
preuves de qualification de la compilation en cours restent à la charge du lot
racine ; cet inventaire ne les présume pas réussies. Les21 régions extraites
restent une analyse statique ; seule la tranche mesurée par l'oracle décrit
ci-dessous a été exécutée.

La prochaine tranche proposée est **[57D6FE,57D775)** :119 octets du caller,
RVA17D6FE, arrêt juste avant l'instruction `call90AD00` à57D775. Elle sélectionne
le nom/skin réellement demandés. Le raccordement ultérieur de cette tranche ne
doit pas transformer le paquet non vide en succès : tant que90AD00 reste absent,
l'erreur doit être déplacée vers cette frontière, puis le caller doit détruire
la String24 conformément au nettoyage déjà porté.

La source est le PE4.20 SHA256
`402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
`source_regions.json` donne pour21 régions les VA, RVA, tailles, octets et SHA256
complets, revérifiés contre ce PE. Il contient3 172 octets de preuve sélectionnée,
dont le préfixe119, le diagnostic991E60 statique286, les getters existants et la
frontière package. La fenêtre99A310 de64 octets est explicitement une entrée
partielle, pas une taille de fonction complète.

## Ordre exact à conserver

1. À57D702, lire la longueur de String24(recipient+1A8), champ+1B8. Si non nulle,
   comparer l'adresse de la String24 temporaire avec recipient+1A8. Si elles
   diffèrent, appeler564AF0(temp, override, offset0, countFFFFFFFF). La chaîne
   temporaire contient déjà un nom non vide issu du vrai72AD90 ; ce n'est pas
   une destination fraîche. Son allocation/capacité existante doit survivre ou
   être remplacée selon le contrat natif.
2. À57D722, relire la clé depuis le payload. Utiliser le service conservé depuis
   le premier lookup, lire sa vtable, puis virtual+4C à57D72D. Le vrai slot
   10AFED8 contient72AE40, lequel est déjà porté et appelle728500 sur la metadata
   retenue du parent. Ne pas convertir la clé en nom, ni le retour en index de
   texture ; le caller traite d'abord ses32 bits comme un entier signé.
3. Si le retour est signé négatif,991E60 est appelé à57D74C avec les cinq
   arguments visibles `skinID >= 0`, chaîne vide,0, chaîne vide, format vide.
   **Cela précède l'override skin.** Même un override valide ne dispense pas de
   cette branche.991E60 n'est pas un simple bool/assertion hôte : l'analyse
   montre formatage CRT C9B551, chemin d'échec C9B780, construction991CB0,
   consommateur5B4560 et destruction. Aucun port complet de ces consommateurs
   n'a été trouvé dans la recherche bornée `crates/**/*.rs`.
4. À57D759, lire le global package manager2D78F1C **avant** le champ override
   recipient+1A0 lu à57D75F. Si ce dernier ne vaut pasFFFFFFFF, remplacer le skin.
   Ne pas réordonner la lecture du global après la sélection pour simplifier.
5. À57D76F..57D775, le caller passe nomString24*, skin effectif et un troisième
   mot résiduel empilé avant le chargement d'ECX=manager.90AD00 fait `ret0C` mais
   ne lit que les deux premiers paramètres dans le corps inspecté. Conserver
   ce résidu comme opaque si le harnais expose l'ABI ; aucune sémantique de flag
   ne doit lui être attribuée. Le slot local précédemment associé au payload
   devient le skin ; la future suite ne doit pas continuer à le nommer payload.

## Réutilisation exacte, sans changer les contrats

| Code existant | Réutilisation admissible |
|---|---|
| `audio_loading_metadata::service_extra(b,key,scratch8)` (72AE40) | Appel direct existant, retouru32 natif, scratch8 exclusif/disjoint. L'acquisition parent/metadata, les références et la destruction de paire sont déjà dans ce corps. |
| `audio_loading_metadata::extra` (728500) | Callee déjà utilisé par service_extra ; ne pas le contourner dans le caller. La résolution729EC0/index et le verrou restent dans la chaîne actuelle. |
| `Backend::event_temporary(8,...)` | Encadre exactement le scratch requis par service_extra sous le verrou launch déjà acquis. Pas d'acquisition récursive de launch. |
| `audio_loading_screen_packet::receive` et son `drop_string` privé | Garder la propriété du nom et son nettoyage57DCAE, y compris lorsque le futur préfixe ou90AD00 retourne une erreur. Aucun reset des champs du temporaire standard. |
| `Storage`, `metadata::Error`, boundaries existantes du resolver | Aucun changement de contrat nécessaire pour les lectures/écritures/erreurs et le vrai lookup metadata. |

Le pont de dispatch du service+4C dans `loading::Boundary` n'existe pas encore.
Il devra valider la cible72AE40 et déléguer au `service_extra` existant comme le
pont+48 actuel. Le service doit être celui retenu au premier appel, sans seconde
lecture inventée de son global au milieu du préfixe.

La signature actuelle `initialize_standard_record(recipient,record,payload,
scratch)` ne transmet pas ce service conservé. Le futur préfixe devra rester
dans `receive`, où cette valeur existe déjà, ou recevoir un argument service
explicite. Relire le global pour pallier cette absence modifierait le contrat.

**À ne pas réutiliser aveuglément :**

- Le `assign` privé d'`audio_loading_metadata.rs` couvre l'affectation entière
  non alias du caller728410 avec capacité conservée. C'est un candidat à partager
  après nouvelle parité564AF0 dans le préfixe, pas une API publique générale déjà
  qualifiée. Vérifier l'ordre des accès, les cas allocation/reprise et la branche
  d'égalité d'adresses du caller avant de l'exposer.
- `audio_replay_engine_thread::copy_fresh_name`, le constructeur de nom de
  `audio_replay_loading_owner` et les copies fresh de metadata_text exigent une
  destination fraîche. Ils ne remplacent pas le nom temporaire déjà possédé.
- `engine_thread::destroy_name`/564900 remettent les champs à zéro. Ils ne
  remplacent pas le drop standard57DCAE.
- `Backend::failure` peut rendre une dépendance non raccordée explicite ; il
  n'exécute pas991E60/991CB0/5B4560. Ne pas compter une erreur hôte ou un log de
  remplacement comme qualification du diagnostic source négatif.

## Frontière90AD00 précise

90AD00 (RVA50AD00,220 octets) conserve le pointeur manager reçu, construit une
copie de String24 par99A310, ajoute le skin à la clé, appelle lower_bound90D220
sur manager+0C puis901F00 pour confirmer l'égalité. Hit : retourne le pointeur
node+2C sans incrément de référence visible. Miss :90B520 construit/publie un
provider et ses relations, avant retour. La copie de clé est détruite par564900.

Le manager et son cache ne sont ni construits ni publiés par la tranche119
octets. Le global2D78F1C est zéro dans le PE et **absent** des61 régions de l'image
runtime actuelle. Copier ce zéro dans l'image ne crée pas un manager utilisable.
La vtable finale du provider10D64A8 est également absente ; son slot+1C pointe
903EE0, une résolution de chemin emprunté que les callers suivants utilisent.

Les corps90AD00/90D220/901F00/90B520/9034D0 ne disposent pas de ports natifs
identifiés dans la production inspectée. Les primitives de clé comprennent la
String24, la comparaison byte5FA6B0 et le skin unsigned, sans comparaison de
pointeurs. Le vrai constructeur/destructeur du manager package et les owners
des providers doivent précéder une publication normale.

**Correction de l'ancienne proposition de test : un hit peut allouer.**
99A310 initialise capacité15/longueur0 puis appelle564AF0 dès99A337. Un nom long
peut donc allouer pour la clé temporaire, même sans nouveau node/provider. Le
critère est la parité des allocations/libérations de cette copie et l'absence
de création de provider sur hit, pas « zéro allocation sur hit ».

La tranche119 octets ne lit pas encore les12 lignes14C7630, les INI/DDS,
catégories `flash`, textures, renderer ou localisateur. Ces dépendances restent
dans la suite après90AD00, déjà détaillée dans l'audit antérieur ; aucun fichier
d'image local ou provider fictif ne permet de sauter cette frontière.

## Données et vérification à préparer après la qualification actuelle

Le global service2D787B8 et le slot72AE40 sont déjà mappés. Le constructeur
canonique publie seulement `Shared.service` : la publication normale du global
n'est pas encore portée. Les tests de premier nom utilisent une liaison
diagnostique explicite du vrai service, restaurée avant destruction. Les deux
littéraux du diagnostic et le global manager ne
sont pas mappés dans l'image courante ; leurs adresses/tailles/état sont dans
`runtime_data_coverage.json`. La tranche ne demande aucun asset bitmap nouveau.

Le premier oracle doit entrer dans le vrai57D650 avec le provider72AD90/72AE40
et la metadata/index réels, puis **s'arrêter avant l'appel90AD00**, en conservant
registres, pile, String24, événements et allocations. Cet arrêt est une frontière
de mesure ; il n'est pas une réussite d'écran. Le nom possédé doit ensuite être
retiré par une étape de cleanup explicitement mesurée, sans faux retour de
provider pour poursuivre le caller.

Matrice recommandée : override vide/court/15/16/long ; destination SSO et heap
de capacité suffisante/insuffisante ; égalité des adresses si autorisée par le
harnais ; identifiants existants et absents via vrais producteurs ; skin0/positif/
7FFFFFFF et overridesFFFFFFFF/0/positif/80000000. Les retours natifs négatifs
doivent former un lot explicitement bloqué sur les vrais consommateurs du
diagnostic tant qu'ils ne sont pas qualifiés, même si un override positif existe.
Conserver poison00/A5, traces exactes et références metadata/index1→1.

Une fois cet oracle puis le port testés : raccorder uniquement le préfixe et
le pont+4C, garder l'erreur de ressource à90AD00 et qualifier son cleanup Windows.
Le lot suivant pourra traiter les hits du cache package, avec allocations
String24 et propriétaires réels ; le miss90B520 demeure une étape distincte.

## Oracle borné exécuté

`probe_prefix.py` a exécuté128 vies natives avec poison00/A5 :64 arrêts avant
l'appel90AD00 à57D775 et64 avant l'appel991E60 à57D74C. Résultat :128/128,
10 144 événements, toutes allocations possédées libérées après teardown.
Les données sont dans `prefix_native_probe.json`, le résumé dans
`prefix_native_result.json`, les empreintes dans `preparation_manifest.json`.

Le caller57D650 utilise les vrais72AD90/728410 et72AE40/728500, le vrai
resolver729EC0/729730/738AC0 et l'index8F8CF0. Les noms/skins ne proviennent
d'aucun résultat de provider simulé. Les identifiants absents utilisent le vrai
lookup0 avec une vraie ligne metadata de clé0. Les branches d'override utilisent
564AF0/564F30 et les strings préparées par564C20.

La matrice contient des noms initiaux SSO/heap ; override absent, court,
15/16 octets, réutilisation de capacité et croissance à120 octets ; skins0,
17,7FFFFFFF,80000000,FFFFFFFF ; overridesFFFFFFFF,0,17,80000000. Les flags du
payload varient0/1/128/255. Les120 octets des records sont comparés et le reset
du mot+10 pour bit0 est préservé. Les références index et metadata restent1.

Pour les64 skins natifs négatifs, l'arrêt précède le diagnostic et toute lecture
du global package ou de l'override skin, même quand l'override vaut0. Pour les
64 skins non négatifs, le global package est lu avant l'override, la String24
finale et les arguments du futur90AD00 sont capturés. Le troisième argument
reste opaque. Aucun appel90AD00 ni991E60 n'a été exécuté ou remplacé.

Après chaque arrêt, le harnais abandonne explicitement cette continuation,
restaure l'ESP avant les arguments non consommés puis rejoint57DCAE. Cette
mesure distincte vérifie la libération du temporaire sans reset de ses champs ;
elle ne démontre ni retour normal de90AD00/991E60 ni exception unwinding.
Le record, l'override, le parent et ses index/metadata sont ensuite détruits
avec leurs routines natives ; aucune allocation possédée ne subsiste.

Limites : recipient/service partiellement préparés en mémoire diagnostique,
pas de factory UI complète ni producteur normal deSERVICE_GLOBAL ; primitives
allocateur/mémoire/verrous mono-thread fournies ; pas d'UI, de renderer, de
chargement package, d'horloge ni de réseau. L'égalité d'adresses des strings,
l'alias partiel, l'OOM et les exceptions restent à qualifier. Aucun de ces
résultats n'est une qualification du raccordement applicatif de la tranche.
