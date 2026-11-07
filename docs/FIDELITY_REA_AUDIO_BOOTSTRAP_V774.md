# SYS-01.2-02 — Mémoire, flux et démarrage audio natif, V774

Projet : F:/OpenLeague. Référence : LoL PUBLIC4.20.0.315 EUW/en_GB. Fiches SYS-01.2-02 et SYS-02.2-07 ; leurs objectifs complets restent ouverts.

## Résultat attendu et observé

Le banc précédent fournissait la mémoire prête, le gestionnaire de flux et les identifiants des pools. Les instructions ADA380/ADA540 publient maintenant la mémoire, puis B37F90/B376D0 produisent les paramètres et le gestionnaire de flux. AEA3B0/B0FAB0 produisent les paramètres moteur/plateforme ; AEA510 exécute son parent complet, construit dix composants, termine avec1 et publie le drapeau initialisé. Une relance retourne2 sans nouvelles allocations ou appels physiques.

L’ordre est recoupé avec l’appelant704E60 analysé par REA : configuration706A20, mémoire, flux, wrapper IO, paramètres, pool, moteur, puis plugins7062A0. Le banc exécute les étapes mémoire/flux/paramètres/moteur/plugins, mais pas cet appelant entier ni le wrapper IO. Les paramètres de configuration effectifs restent à composer.

| Vérification | Attendu et observé |
| --- | --- |
| Démarrages complets AEA510 | 2 retours1, puis2 à la relance |
| État publié | mémoire prête, stream non nul,10 composants, initialisé=1 |
| Pools demandés | 64KiB/blocs32,64MiB/blocs4096,16MiB/blocs64,16MiB/blocs64 avec dernier argument16 |
| Mode0 | deux activations COM refusées explicitement avec E_NOINTERFACE, puis repli natif3 |
| Mode3 | repli choisi explicitement, sans ces deux demandes COM |
| Mémoire résiduelle | 41 allocations dans chacun des deux contextes de démarrage ; pas de fermeture globale |
| Relance | retour2, aucun événement physique nouveau |
| Limites | 23 profils :6 mémoire,7 flux,10 pool inférieur |
| Validation adversariale | 12 falsifications refusées |
| REA | 14 fonctions,717 instructions,20 références ; session exportée et fermée sans erreur |

Les pools portent les identifiants fournis23/19/17/21. Leurs demandes et publications sont natives ; leurs allocateurs restent des adaptateurs. Les fragments s’exécutent en mémoire x86 isolée, avec sections exécutables protégées contre l’écriture. Les octets de1450 observations de blocs sont comparés au PE ; ce nombre additionne les profils et ne représente pas1450 blocs uniques.

## Refus et états conservés

ADA380 retourne2 pour paramètres nuls, mémoire déjà prête ou allocation refusée. Les profils1 et20 initialisent les enregistrements de72octets et leurs sections critiques fournies. Les quatre octets de padding28..31 restent inchangés. Pour compte0, le retour2 est observé avec un allocateur explicitement configuré pour rendre nul ; ce comportement n’est pas généralisé à tous les allocateurs.

B376D0 vérifie la mémoire prête avant de retourner un gestionnaire existant. La création normale publie la vtable FF3268. Un pool refusé donne0. Après refus de l’allocation de l’objet, le pool est détruit par le service fourni mais son identifiant23 reste dans121031C : le document ne le présente pas comme un gestionnaire prêt.

B0C830 emploie16MiB lorsque la taille demandée est inférieure ou égale à64 ;65 est conservé. Son dernier argument vaut16, contrairement au pool principal. Refus de création :52, global principal UINT_MAX et ancien alias conservé. Des pools existants0 et21 sont admis. B0C880 détruit le pool et réinitialise le global principal ; l’alias1210240 reste inchangé.

## Limites des profils complets

Le mode0 refuse deux activations COM dans l’adaptateur. Les services de notification COM, allocation, verrous, événements et création de threads sont fournis explicitement. Les deux entrées de workers AF8C80/B20D10 sont demandées mais leurs corps ne sont pas exécutés dans ces nouveaux profils de démarrage. Aucun thread Windows, périphérique ou son réel n’est qualifié ici. Le singleton CPU, le TLS et les services CRT conservent les entrées fournies du banc.

Les six banques,31préfixes,784sorties et713buffers de V773 restent des preuves antérieures. Ils ne sont pas réexécutés sous les nouveaux paramètres : cette composition est le prochain contrôle. Les41allocations de démarrage ne remplacent pas le constat historique de1657allocations après médias ; ce sont deux points de mesure différents.

## Consommateurs actuels

Les quatre ancres existantes de audio_bank_command_worker.rs et audio_bank_command_queue.rs sont relues et conservées. Elles portent le worker/la file en aval ; aucune nouvelle ancre de démarrage Wwise n’est inventée.

La recherche bornée dans crates/core/src et crates/client/src et la lecture de fichiers voisins distinguent : audio_backend_references::Registry::new (compteur6CDC80), audio_replay_windows_game_manager::initialize_game_manager (72A800), audio_crt_windows_root_startup (CA92CB) et le contrat du compteur backend. Ces fonctions ne prouvent pas la correspondance avec704E60. Aucune absence globale n’est déduite de cette recherche. Aucun test Rust ni client ordinaire n’est fraîchement exécuté dans V774 ; aucun code produit ou asset modifié.

## Essais antérieurs et corrections du banc

Les essais explore et extended sont conservés : ils refusaient respectivement le quatrième pool, puis l’activation COM du mode0 et l’allocation alignée du pool21. Le profil contrôlé passe après correction de ces frontières, sans patch du PE. Le premier assemblage du vérificateur utilisait un nom d’encodage erroné. Son premier contrôle bornait ensuite la publication du flux à B376xx ; l’adresse native exacte est B3772D. Le vérificateur initial et sa correction restent distincts.

## Intégrité et preuves

Binaire original : D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe.
SHA256 : 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.
REA6.4.0, SDK2.3.1, Ghidra12.1.4 et Java21 ; même copie vérifiée avant/après.

Preuves dans F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :

- revision774_rea_audio_bootstrap/observations/41d584da-2f96-48ae-a131-45b9f35a0e21/receipt.json.
- revision774_bootstrap_verified/mode0_OBSERVATIONS.json et mode3_OBSERVATIONS.json.
- revision774_bootstrap_boundaries/OBSERVATIONS.json.
- revision774_bootstrap_associations/OBSERVATIONS.json : intégrité, comparaison native,12falsifications, liens sources/consommateurs et limites.
- revision774_delivery/VERIFIED.json, INDEPENDENT_READBACK.json et FINAL_VERIFIED.json : intégration et relecture.

Les registres sources/exigences/tâches et les deux bases du plan sont enrichis sur deux fiches. Les inconnues, prérequis, cases, notes, historique et autres tâches restent conservés. Les modifications documentaires de couverture/reprise sont réversibles par deltas ciblés, sans nouvelle copie complète des bases.

## Suite

Continuer SYS-01.2-02 sur F avec REA. V774 qualifie ADA380/ADA540, B376D0 et AEA510 avec allocateurs, CPU/TLS et services Windows explicitement fournis. Recomposer les six banques et31préfixes avec ces nouveaux paramètres : les sorties V773 sont héritées, pas rerun. Puis qualifier704E60 complet, config706A20, IOwrapper704700, plugins après initialisation et destruction globale. Ne pas assimiler les fonctions Rust CRT/replay/counter voisines au démarrage Wwise. Retrouver ou relier son consommateur ordinaire, maintenir ouvert le transport physique, les workers/TLS distincts, les autres médias, le streaming/seek/boucles et les commandes1..11. Préserver les preuves, cases, notes et historiques ; utiliser des deltas ciblés sur F.
