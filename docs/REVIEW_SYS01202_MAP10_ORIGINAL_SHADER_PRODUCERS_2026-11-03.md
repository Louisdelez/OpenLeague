# V1158 — Revue indépendante finale des producteurs shaders

## Verdict

**PASS borné — 387/387 contrôles, zéro échec.**

La revue a relu et rehaché le manifeste, les sept artefacts figés, les deux reçus finaux et le PE original. Elle a aussi rejoué uniquement le validateur non mutant : résultat identique au reçu stocké, **191/191**, sans exécuter un troisième run producteur. Le dossier audité était identique avant et après la revue.

## Résultat vérifié

- ordre original composé : pixel `0x98C070`, puis vertex `0x98D960` ;
- spans tracés : pixel 518 instructions, vertex 522, avec entrées, stores `record+4`, closes et `ret 8` critiques présents ;
- profils exacts `ps_2_0` / `vs_2_0` et `EDX=0` aux deux frontières factory ;
- include vtable `0x10DBAEC`, répertoire brut `Environment/` ;
- stream `+0x10` : plain return, zéro argument dépilé, `char*` NUL emprunté, source morte après close original ;
- handles pool non nuls et distincts, wrapper/CTAB/shader non nuls, refcount 1 et bit feuille actif avant cleanup ;
- cleanup original en ordre inverse : vertex `0x9AED50`, puis pixel `0x9AEDC0` ;
- après cleanup : records et bitmaps à zéro, wrappers libérés, quatre releases host à zéro, aucun proxy D3DX ni shader host vivant ;
- préflight de slot libre exécuté avant chaque entrée, remis à zéro, sans factory ni wrapper durant le probe ;
- refus négatifs uniquement avant entrée ; aucune saturation provoquée dans une factory ;
- arrêt strict avant `0x9AEE30`, `0x9C22E0`, `0x9BEF40`, setters, draw, Present et readback ;
- projection déterministe commune : `7d44993531535ac1be39fe636b8ac877fdcfd11de9f84aef5f7ab4cf5e630055`.

## Contrôles indépendants supplémentaires

Le validateur de revue analyse le PE32 sans bibliothèque tierce et confirme les octets critiques du calcul du flag 3.0, du slot `+0x10`, des appels factory, des stores, des closes et des `ret 8`. Il rehache aussi directement les spans PE :

- pixel : `5340e9893340a103cd3fa47a780b8b796366f0dd7251a35c0283f014f985add3` ;
- vertex : `ee5a87ff392a97a19b705b8bf2a3923de12bb52b42954110b5cc9db38191082a`.

Identités de la revue :

- validateur indépendant : `5eb58d36f1aff2046966bcd493dce583a8c751ddf32da645b1ea1a204e71a0f5` ;
- reçu indépendant : `f7a933025d8b547ff9e82b93659c7c6078abda2b336def5a5a69643a415e292e` ;
- manifeste V1158 audité : `a15ea9231a0bf6725128bba5af6505f510d10665724456ef185835e6e112aa41`.

## Qualification et limites

Le résultat qualifie les deux **spans producteurs originaux** uniquement dans la composition bornée V1158. Les corps factory originaux ne sont pas exécutés ; VFS, stream, initialisation include, factories et managers restent des adapters ou fixtures exact-layout. D3DX/D3D9 sont current-host, pas Riot 2014.

La revue ne qualifie aucun pair, bind, setter, draw, Present, readback, frame rendue, fidélité visuelle, Map10 complète ou jeu complet. Les traces complètes sont conservées dans les reçus sous forme de compteur, hash, premières/dernières adresses et membres critiques, pas comme liste exhaustive d’adresses.

Le contrôle d’écriture confirme que cette intervention n’a modifié aucun fichier du dossier audité et n’a lancé aucun producteur. Les sources figées confinent leurs sorties au dossier de preuve E: et désactivent le bytecode ; les reçus déclarent zéro écriture F:/produit/Goal/Plan/UI/base/registre. Une surveillance historique de toutes les écritures système antérieures reste hors périmètre.
