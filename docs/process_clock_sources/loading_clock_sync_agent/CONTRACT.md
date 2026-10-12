# Horloge partagée : synchronisation du once

Lot scratch uniquement. Le port n'introduit aucune origine QPC, fréquence privée,
horloge `Instant`, ni singleton hôte. Les appels chargement et effets doivent
atteindre le même producteur et les mêmes banques canoniques.

## Preuve et qualification

L'exécutable source est vérifié par SHA256
`402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
`clock_sync_probe.json` contient 26 régions avec octets/hash, revérifiées depuis
le PE dans `qualify.py`. Le désassemblage est conservé dans
`clock_sync_disassembly.txt`.

- 64 durées de vie natives : CE298A complet, trois appels successifs, deux
  identités de thread, 4 valeurs du flag, callbacks imbriqués sur un autre flag,
  remplissage mémoire 00/A5, choix API CS legacy/Ex, retour atexit 0/FFFFFFFF.
  Le chemin ConCRT non contendu exécute réellement CBE789, CBEB45 et CBED6D,
  puis CBEEED. L'acquisition du contexte ConCRT est une frontière explicite.
- 64 autres durées de vie isolent CBEE12/CBEEED en frontières qui préservent
  les octets. Les tests Rust du niveau extérieur/type1 comparent cette série :
  tous les octets des banques, tous les appels et leur état à l'entrée, toutes
  les écritures ordonnées. Cela ne certifie aucun mutex hôte.
- 34 cas du once extérieur : états initiaux 0/1/2/3, bytes 0/1/128/255,
  attente Sleep(1) et course de publication avant XCHG (ancienne valeur2).
  Ce sont des ordonnancements déterministes d'émulateur, pas des threads OS.
- 8 cas d'allocation/destruction : type1/101, calloc nul/non nul, deux fills.
- 5 tests Rust passent, dont injections d'erreurs d'adoption calloc, acquisition,
  propriétaire/profondeur, récursion et nettoyage à double erreur.

## Contrat source du mutex type1

CE290B appelle CE2702 avec timeout nul. Le test `(type & !0x100) == 1`
sélectionne la branche portée. Aucun timer ni try-lock ne sont atteints ici :
CBE789 reçoit -1. Les autres types restent explicitement refusés par le port.

Le stockage possède 44 octets. À la construction, CE28CF efface d'abord le
pointeur destination, puis appelle le CRT calloc(1,44). CBE86C écrit dans
`inner = object+4` les offsets 18,1C,00,04,0C à0 ; 08 à2 ; 10,14 à0.
Ensuite `object+24=FFFFFFFF`, `object+00=type`, puis publication du pointeur.
Ces offsets sont hexadécimaux. La profondeur est `object+28` et reste zéro
grâce à calloc. Les champs publics propriétaire/profondeur ne sont pas opaques.

Acquisition : GetCurrentThreadId ; si `object+24` est déjà ce thread, incrément
de profondeur sans acquisition intérieure. Sinon CBEE12(inner), nouveau
GetCurrentThreadId, relecture du pointeur destination, publication du
propriétaire, relecture du pointeur et incrément de profondeur. Libération :
décrément profondeur ; si zéro, relecture du pointeur, propriétaire=FFFFFFFF,
relecture du pointeur, puis CBEEED(inner).

CBEE12 est non récursif. Il crée un nœud de24 octets sur la pile, obtient le
contexte ConCRT (CBE75B : TLS ou CC50EB), puis enfile par XCHG du tail+1C.
CBEB45 refuse la réentrée d'un même contexte. Le premier nœud acquiert sans
attente. CBED6D transfère ensuite le nœud temporaire dans le stockage permanent.
CBEEED efface l'identité intérieure, retire le premier successeur et tente son
réveil ; les nœuds expirés sont sautés. La voie sans timeout de type1 n'en crée
pas. Le réveil utilise des méthodes virtuelles du contexte (notamment +0C).
Le chemin de contention dépend du scheduler ConCRT et n'est pas qualifié ici.

Une adaptation Windows peut conserver l'exclusion, la propriété, le transfert
FIFO et le réveil d'un seul participant avec une file et des événements privés.
Elle doit être annoncée comme adaptation des threads OS : elle ne reproduit
ni fibres/contexte C++/scheduler ni octets de file ConCRT. Un simple verrou
CS/SRW ne donne pas la même garantie FIFO. Les objets d'attente doivent rester
vivants jusqu'à consommation du signal et sortie du dernier utilisateur.

## API et intégration

`prepare_and_enter_clock_mutex` porte CE5247→CE2961→CE290B.
Le producteur générique conserve le test/publication de son flag CE298A et son
callback entre cette entrée et `leave_clock_mutex` (CE2934).
`dispatch_cleanup` accepte CE2955 et CE52C1, exclusivement.

| Adresse | Taille | Rôle / banque canonique |
| --- | ---: | --- |
| 14AF61C | 1 | byte once mutex ; CRT |
| 14AF620 | 4 | pointeur allocation44 ; CRT |
| 14B1840 | 4 | état atomique extérieur0/1/2 ; CRT |
| 14B1844 | 24 | identité logique CS PE32 ; stockage opaque Windows privé |
| 1222ED0 | 4 | cookie CRT existant, à réutiliser |
| 2DA5310 | 4 | dispatch encodé existant, à réutiliser |
| 2D75530 | 4 | flag producteur horloge, banque partagée du producteur |

Le décodage API est `word(2DA5310) XOR word(1222ED0)` : zéro choisit
InitializeCriticalSectionAndSpinCount, nonzero choisit InitializeCriticalSectionEx.
Le port fournit spin4000 et flags None/Some(0). Les pointeurs hôte64 ne sont
jamais tronqués dans une adresse logique32.

Si l'adaptation crée sa file hôte paresseusement au premier inner_lock,
retire_inner doit également gérer le cas construit mais jamais verrouillé.
Si elle la crée lors du calloc, free doit retirer la file en cas d'échec
d'adoption. Une seule allocation44 est possédée par la banque CRT ; aucune
copie miroir ne doit être créée dans la banque transport.

Le callback CE52C1 est enregistré après l'initialisation extérieure. CE2955
est enregistré après construction et publication du mutex. Le teardown LIFO
appelle donc CE2955 avant CE52C1. Source5642D0 est exactement RET : cette
destruction native ne vérifie pas l'absence de concurrents. Le port appelle
retire_inner pour permettre le contrôle du vrai stockage hôte, puis relit le
pointeur et free CRT. Comme le natif, il ne remet pas le pointeur à zéro.
Il faut fermer les nouvelles acquisitions et attendre tous les utilisateurs
avant ces callbacks, puis empêcher toute réutilisation du cycle fermé.

## Frontières et erreurs

Les méthodes de banque doivent rejeter une écriture invalide avant toute
mutation. Aucun verrou de map non récursif ne peut rester tenu pendant
EnterCriticalSection, l'attente FIFO ou un callback qui reprend cette banque.
Les RMW et la publication state2 doivent avoir l'ordre atomique approprié.

Les erreurs Rust constituent une extension explicite, pas une preuve du SEH
natif. Une erreur avant adoption calloc libère l'allocation. Une erreur après
acquisition intérieure et avant depth++ restaure le propriétaire observé après
acquisition puis libère le verrou acquis par cette invocation. Une erreur
réentrante ne libère pas le verrou du parent. Les erreurs de nettoyage sont
conservées avec l'erreur initiale ; une erreur du free signifie que le stockage
est encore à traiter, pas qu'il a disparu. Le callback du once extérieur est
suivi de leave même en cas d'erreur.

Les échecs d'initialisation de la CS/atexit avant publication state2 ne sont pas
une nouvelle tentative automatiquement sûre : l'état1 natif pourrait persister.
Une adaptation ne doit pas masquer l'indisponibilité par un succès fictif ;
elle doit fermer/traiter ce cycle avant une nouvelle acquisition. Les retours
entiers natifs d'atexit/InitializeCriticalSection sont ignorés dans le flux
original, mais les erreurs de disponibilité hôte doivent rester explicites.

QPC/QPF, l'arithmétique x87, l'adaptateur FIFO Windows et le raccordement réel
chargement/effets sont qualifiés séparément. Ce lot ne revendique ni horloge
opérationnelle intégrée, ni écran de chargement complet.
