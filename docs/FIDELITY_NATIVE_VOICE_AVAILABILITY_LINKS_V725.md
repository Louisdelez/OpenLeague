# SYS-01.2-02 — Disponibilité native des événements de voix, V725

Projet : F:/OpenLeague. Référence : PUBLIC 4.20.0.315, EUW/en_GB. Catalogue 4.20.1 distinct.

## Résultat

Le backend original de disponibilité est exécuté sur les 244 banques de voix de base, chacune dans un registre isolé. Les payloads de 2 109 événements sont chargés par le code natif ;leurs 2 195 actions passent les constructeurs et inscriptions originaux.

Les 2 196 recherches par nom produisent 718 correspondances dans les banques, couvrant 713 noms distincts de V723. Les cinq doublons restent séparés. Aucun ordre de chargement historique n'est déduit.

La disponibilité vaut vrai quand l'événement enregistré est trouvé, même si ses cibles sonores ne sont pas chargées. Tous les contrôles nominaux utilisent explicitement des tables de cibles vides : le code de requête retourne 3 avec zéro cible. Ce résultat ne prouve pas qu'un son peut être joué.

## Chaîne originale

- Les actions passent `B21D40` et leurs constructeurs, puis la registration native. Les champs cible/catégorie restent des entrées source déclarées ;le lecteur complet de propriétés n'est pas exécuté.
- `B1A7B0`, `B1A960`, `B1A760` construisent, chargent les payloads et inscrivent les événements, en conservant l'ordre des actions.
- `6F8210` appelle le slot `34` de la vtable `10AF384`, soit `705750` ;`AEA430` calcule le hash du nom.
- `AEBDA0` et `AF9530` cherchent l'événement, puis `B1A800` examine ses actions. `B1A8E0` équilibre la référence acquise.
- Les cibles des actions Play sont recherchées par `B21EE0/AF6480` dans les tables déclarées vides. Aucun callback de disponibilité fabriquant un booléen n'est utilisé.

## Contrôles et conservation

253 sources et 9 ancres actuelles vérifiées ;602 adresses exécutées comparées au PE ;12 contrôles diagnostiques,4 gardes du banc et4 falsifications de preuve.

Les 611 fiches et leurs instructions copiables sont intégrées dans les deux bases, avec vérification des autres tâches, cases, notes, historiques et inconnues. Aucun nouveau build Rust, code du jeu, asset ou son modifié.

Le premier essai a échoué à cause d'un adaptateur du banc qui écrasait EAX. Il est conservé. La correction préserve EAX ;la nouvelle exécution complète constitue la preuve publiée.

Exécutable original : `League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Python, bibliothèques, scripts et sources sont identifiés dans le reçu.

## Limites

- Original6F8210/705750/AEA430/AEBDA0/AF9530/B1A800 and nonterminal event releaseB1A8E0 execute. Backend enable=1 and disabled legacy provider are declared. No synthetic boolean availability callback is used.
- Each bank is loaded separately into a declared empty manager. Original subtype factories/registration prepare actions; their target/alternate fields are supplied from serialized headers rather than the full action-property reader. Full bank loading,overlays and historical joint bank registry remain open.
- Actual event payloads pass B1A960 and B1A760 original loading/registration; allocation and single-thread critical sections are bounded adapters. No partial loader rollback/destruction qualification is inferred.
- Target tables are explicitly empty. OriginalB21EE0/AF6480 target searches run but find no targets. Status3 and available=true can therefore coexist with output count0. This proves event availability semantics under declared state,not media readiness or playback.
- Requests reuse source-pinned V723 base voice names,now queried per bank. No new ordinal/hero context or skin bank selection is claimed. Duplicate event identities in different banks remain separate; no precedence inferred.
- No game source,bank or asset modified; no Rust build,full historical client,current game or audible output run. Existing current audio consumers need explicit skin/champion wiring and media qualification.
- Les244banques sont gardees separees ;les cinq doublons Lissandra restent distincts. V723 conserve sa disponibilite adaptee et son contexte de noms fourni ;V725 ne transforme pas retroactivement cette preuve en execution de tout le client.
- Les2195types/id/actions passent leurs constructeurs et inscriptions originaux. TargetID et un bit de categorie sont des entrees fournies aux champs consommateurs ;les2195octets sources du drapeau observes valent tous0. Le lecteur complet des proprietes d action reste ouvert.
- Les12controles incluent backend desactive/nonzero,evenement vide,collisions,action Play avec cible absente,action nonPlay,boucle de comptage sans buffer,capacite avec buffer,action absente et actionID0 refusees par le loader. Quatre gardes du banc et quatre falsifications sont distinguees des codes natifs.
- Le premier essai de banc ecrasait EAX au retour du controle de cookie ;la source et l echec sont conserves dans revision725_voice_availability_probe. Le transport corrige preserve ce registre ;son execution complete est la seule integree.
- Les610fiches de voix et SYS sont enrichies. Les fiches AIR-SELECT et les668fiches audio de skins deV724 restent inchangees. Le nouveau point d entree est le dispatcher actuel de contrats audio,avec sa portee ambiante inspectee ;aucun fournisseur de voix de champion n est promu.

## Livraison

Le [reçu détaillé](fidelity_native_voice_availability_links_v725.json) contient les banques, payloads, recherches, résultats et limites. Les registres de tâches, traces et sources, les documents de couverture/reprise et les deux bases du plan sont enrichis.

Reçus `VERIFIED.json` et `INDEPENDENT_READBACK.json` : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision725_delivery/`. Deltas ciblés sans copies intégrales de bases. Le goal reste ouvert.
