# SYS-01.2-02 — Inscription native des textures et portée du cache actuel, V713

Date : 28 octobre 2026. Projet : F:/OpenLeague. Référence : LoL PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct.

V713 : inscription native978820 exécutée sous sélecteur PE2 inchangé, avec constructeur réel, noms diagnostiques et allocations adaptées. Neuf contrôles vérifient insertion, refus des noms actifs, références1/2/1, maintien à zéro et réutilisation du même objet. Le cache Rust actuel a un contrat distinct (acquisition répétée autorisée, destruction à zéro). Aucune texture GPU ni continuation Standard complète qualifiée.

## Source et contrat

League of Legends.exe est identifié par SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`. Le banc exécute le constructeur9783D0 et sa publication réelle dans2D79030 avant978820. Aucun manager n'est fabriqué par l'hôte. Les allocations CRT et la vérification du cookie restent des adaptations déclarées. Les1398 adresses d'instructions exécutées correspondent aux octets du PE.

978820 reçoit ECX=manager, puis quatre emplacements de pile : sortie, nom C, wrapper et quatrième emplacement dont le sens reste inconnu. Les deux sorties natives utilisent ret0x10 et EAX renvoie l'adresse de sortie. Le chemin du caller98964D, puis969680/6B5860, est désassemblé à partir d'instructions alignées ; seuls les appels de référence sont exécutés isolément ici.

Le sélecteur natif1225B04 reste à sa valeur embarquée2. L'objet de40octets porte le descripteurFFFFFFFF et des dimensions nulles. **Un objet inscrit ne prouve pas une texture utilisable ou un renderer initialisé.** Aucun appel9B16B0/9BF1B0, COM, API graphique ou GPU n'est exécuté.

## Attendu et observé

| Contrôle | Attendu d'après le code original | Observé |
|---|---|---|
| Nouveau nom A | Objet, référence1, table et liste cohérentes | Conforme |
| Même texte dans un autre tampon | Refus, sortie nulle, aucune allocation/entrée ajoutée | Conforme |
| Nouveau nom B | Autre objet | Conforme |
| Nom A en minuscules | Identité distincte | Conforme |
| Copie puis libération temporaire | Compteurs1→2→1 | Conforme |
| Réinscription pendant détention | Refus, état inchangé | Conforme |
| Dernière libération, drapeau+15 nul | Compteur0, objet encore inscrit | Conforme |
| Réinscription après compteur0 | Retrait, destructeur sans free, même objet réutilisé, compteur1 | Conforme |
| Doublon après réutilisation | Refus, état inchangé | Conforme |

Ces contrôles utilisent des noms diagnostiques, pas des chemins de portraits validés. Le banc conserve21 blocs alloués et ne prétend pas qualifier la fermeture complète du manager. Les pointeurs et tailles sont dans le reçu.

## Consommateurs actuels

La sonde Rust compile directement le fichier actuel `crates/client/src/relic_texture_reference_cache.rs`, sans copie du module. Compilation et exécution : code0. Même clé : ID101 renvoyé deux fois et compteur2 ; dernière libération : entrée détruite ; inscription résidente répétée : pas de référence supplémentaire ; cleanup : ID103 libéré. Le fichier source reste identique.

Ce cache gère des clésu32 et n'implémente pas le contrat de noms internés de978820. Le commentaire980AC0 de `register_resident` renvoie à une autre opération native. Aucun changement de gameplay ou remplacement de ce cache n'est effectué à partir de cette comparaison.

`relic_image_reference_store::acquire_dds/release` restent des consommateurs CPU candidats. `audio_replay_windows_loading_packets::initialize_standard_record_owned` conserve ses erreurs explicites : manager absent, continuation après provider emprunté, fabrique90B520 indisponible. La preuve nativeV685 du provider est distincte de son intégration actuelle.

## Limites et vérifications de livraison

- PE backend2 is unchanged and yields descriptor FFFFFFFF and zero dimensions. A returned registry object is not a valid GPU texture.
- No original configured backend0/1, wrapper creation, device, full caller or portrait rendering executed.
- Synthetic names, not native VFS portrait naming. Fourth stack argument is not semantically qualified beyond these paths.
- Original reference-copy/release and zero-ref reuse run; full manager shutdown and physical resource lifetime remain unqualified. All tracked live blocks are disclosed.
- Native 978820 registration differs from current cache hit acquisition and from the independently modeled 980AC0 renderer resident list. No equivalence inferred.
- Le banc initial a échoué au parsing Python (mot réservé return), code1 ; aucun code natif exécuté. Source initiale et correction séparée conservées.
- La sonde Rust compile le module de cache réel isolément, pas le client ou son écran de chargement. Le caller Standard et Store sont inspectés, pas exécutés dans V713.
- Les sept entrées du lot préalable D01-SYS-01-1 ont une implémentation enregistrée mais restent a_valider ; aucune acceptation ajoutée.
- Les preuves V685 de création du provider90AD00/90B520 ne sont pas annulées par les refus actuels. Provider2D78F1C et registre2D79030 restent distincts.
- Bootstrap natif configuré0/1, wrapper réel, nom portrait/VFS, transport, GPU, écran champion/skin/équipe et fermeture complète restent à qualifier. Kalista288octets et12noms restent ouverts.

Quatre mutations de preuve sont refusées : prétendre un GPU exécuté, un backend1 configuré, un client actuel exécuté par la sonde, ou la tâche complète. Les sources, binaires et journaux de cette vérification sont pinés dans [le reçu](fidelity_native_texture_registration_v713.json).

Ajout ciblé aux fiches SYS-01.2-02 et SYS-17.3-01 ; les consommateurs globaux et les inconnues restent conservés. Les cases, notes et historiques des deux bases du plan sont contrôlés pendant la publication. Delta réversible de fragments et lignes, sans copie intégrale des bases. Preuve de publication : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision713_delivery/VERIFIED.json`.

Suite : qualifier l'inscription avec backend natif0/1 configuré et wrapper réel, puis les producteurs du nom et le chemin Standard complet. Ne pas déduire la fidélité de l'écran de la réussite du registre sous backend2.
