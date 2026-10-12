# Ordre natif du gestionnaire replay

Lecture directe du PE 4.20 SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` et sonde native complète. Aucun changement de production, aucun build.

## Entrée et arguments

`0x7297E0` est une méthode `thiscall`, ECX = gestionnaire de 68 octets, `ret 0x30` = 12 arguments de pile. Les noms ci-dessous décrivent le raccordement observé, sans attribuer de sémantique supplémentaire aux valeurs opaques.

| Index | Emplacement | Usage observé |
|---|---|---|
| 0 | EBP+08 | premier argument opaque d'ouverture |
| 1 | EBP+0C | second argument opaque d'ouverture |
| 2 | EBP+10 | pointeur vers les 16 octets de clé |
| 3 | EBP+14 | pointeur chaîne hôte |
| 4 | EBP+18 | premier argument de démarrage |
| 5 | EBP+1C | second argument de démarrage |
| 6 | EBP+20 | troisième argument de démarrage |
| 7 | EBP+24 | mode d'implémentation (octet bas utilisé par ouverture) |
| 8 | EBP+28 | flag d'ouverture |
| 9 | EBP+2C | argument supplémentaire d'ouverture |
| 10 | EBP+30 | chemin diagnostic/enregistrement |
| 11 | EBP+34 | flag d'enregistrement |

La callback est obtenue séparément : cloner gestionnaire+40 si non nul; sinon factory `7337C0`, soit 12 octets `[108606C, gestionnaire, 729370]`. Une nouvelle copie est passée par valeur à l'ouverture et consommée par celle-ci. Les temporaires sont ensuite détruits.

Appel à `72988D` : `8F68D0(gestionnaire+30, callback, a0, a1, a2, a3, 0, a7, a8, a9, a10, a11)`. **Le port est littéralement 0 dans cette entrée parent.**

Contrôle `7298CC..7298D1` : si le résultat d'ouverture est non nul, il est renvoyé sans démarrer. Sinon `7298D3..7298E2` appelle `8F6AF0(stream, a4, a5, a6, residue0, residue1, residue2)`. Les 12 derniers octets sont réservés par `sub esp,0xC` sans initialisation; la fonction actuelle de démarrage ne les utilise pas. Ne pas fabriquer une signification pour ces trois valeurs.

Le service natif `72A780` appelle d'abord sa vtable+1C = `72A800` (initialisation gestionnaire/callbacks), puis le parent `7297E0`. Il calcule a7 comme `(service+122 != 0 && service+12F == 0)`, prend a9 depuis le global `2D62A48`, et transmet les autres arguments. Son `ret 0x28` consomme dix arguments. La réinitialisation/réutilisation du gestionnaire n'est pas qualifiée.

## Destruction et durée de vie du journal

`728EE0` détruit d'abord gestionnaire+28 (bundle de callbacks20), puis gestionnaire+30 via vtable+8 = `8F67C0`. Celui-ci appelle `8F6800`, qui appelle `8F6BC0` avant de libérer manager/implémentation/base.

En état4, `8F6BC0` arrête et joint le worker, puis appelle implémentation vtable+1C. Pour le dérivé, `901C44` ajuste ECX de -E0 et saute vers `8F6FA0`, qui libère le transport global via `8FC500`. La ressource LogOut_File est encore vivante à cet instant. `8FB490` ferme ensuite le fichier via `8F8F90`, libère metadata+38, ressource+30, mutex+10 et thread+8. Enfin le parent détruit callback+40, metadata+34/+38, callbacks+2C/+24/+20 et string+08.

Le démarrage parent réussi passe donc automatiquement de3 à4. Même l'échec de création d'hôte testé retourne6 **après** transition à4 et le destructeur arrête correctement ce flux. Une erreur d'ouverture2 ne démarre pas, reste en état1 et n'a aucune référence globale à libérer dans les profils qualifiés.

Le callback du logger retient un pointeur brut sur la ressource. La destruction de celle-ci ne le désinscrit pas. La sonde retire explicitement le logger immédiatement après la destruction parent et ne lit aucune ressource retraitée. Cela ne prouve pas la sûreté de logs ultérieurs ou d'une nouvelle session qui réutiliserait cette chaîne.

Singleton parent natif : initialisation `5CF1E0`, stockage `2D78240` (68), pointeur `2D78520`, shutdown enregistré `5D81B0`. Shutdown logger `901C00` détruit la chaîne, supprime sa section critique, remet `2D78EC4` à0 et `2D78EC1` à1. L'ordre global effectif des callbacks atexit du jeu complet n'a pas été qualifié.

## Prochain raccordement concret

Porter le parent dans la banque canonique Windows, avec son bundle20, ses callbacks et sa metadata **512 octets** (base727DE0, vtable dérivée10B00C4, string+1E8), puis invoquer cette entrée open+start depuis le service. Ne pas transférer les pointeurs0x34000000 du service actuel vers Runtime0x39000000.

Factories supplémentaires nécessaires : `7337C0` (réception→729370), `733840` (bundle+4→71EC30) en plus des cinq déjà listées. Les échanges de callbacks passent par `728B60` (bundle+4), `728CC0` (bundle+C), `728D70` (bundle+10), et leurs wrappers parent729A50/729AE0. Dispatchers/clone : vtables108606C `[578010,5CCE40,5CCEB0]`,1086078 `[578010,5CCDC0,5CCE30]`,10AFD14 `[578010,734010,734080]`,10AFD20 `[578010,733F80,733FF0]`,10AFD34 `[578010,733F00,733F70]`.

Activer ensuite les callbacks de service `72A800` (738A3A/72B950) et le dispatch729370, sans assimiler les pointeurs de méthodes non implémentées à du succès. Hôte8FD6A0, démarrage réussi8F7060/8F75D0, poll8F7920 et livraison des trames restent à implémenter/qualifier. Aucun nouvel import OS n'a été nécessaire pour la sonde parent, qui réutilise les frontières primitives déjà fournies; cela ne qualifie pas les imports du réseau actif.

## Preuve exécutable

`probe_parent_order.py` et `replay_parent_open_lifetime_probe.json` : 16 vies complètes, fills0/A5 × modes0/1 × recording0/1 × hôte numérique/null. Les vraies fonctions parent, metadata et callback s'exécutent; tous les blocs reviennent au niveau initial, aucune lecture après libération de LogOut_File. Hôte dérivé fourni comme échec0; worker PE exécuté au join après drapeau d'arrêt. Aucun trafic réseau, fichier réel ni polling actif n'est revendiqué. Le nom du tableau de trace est `parent_trace` pour éviter une collision avec le buffer de diagnostic hérité du harness.
