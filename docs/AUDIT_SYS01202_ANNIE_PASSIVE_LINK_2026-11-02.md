# Audit borne — Annie / Pyromania : source et consommateur actuels

Date : 2026-11-02  
Goal parent : SYS-01.2-02, toujours actif  
Exigence parent : OLF-3a11ace9-485c-55ae-8dff-2533902a5839  
Unite : AUD-SYS-01.2-02-ANNIE-PASSIVE-LINK-01  
Taches existantes concernees : CH-Annie-PASSIF-SOURCE, CH-Annie-PASSIF-SIMULATION, CH-Annie-PASSIF-NETWORK, CH-Annie-PASSIF-ACCEPTANCE. Aucun identifiant ni statut de ces taches n’a ete modifie.

## Perimetre et decision

Ce lot relie les ressources client Pyromania disponibles au consommateur Annie actuel dans crates/core. Il ne valide ni le passif complet, ni ses effets visuels/audio, ni le comportement Riot historique. Le lot est clos comme audit de liaison statique et d’identite des sources. La mecanique, la duree numerique native et les nouveaux callsites restent non valides; SYS-01.2-02 et les taches fonctionnelles demeurent ouverts.

## Sources et provenances

| Source | Identite observee | Ce qu’elle etablit | Limite |
|---|---|---|---|
| D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Characters/Annie/Spells/Pyromania.inibin | 48 octets; SHA-256 437764669622e7711b34f8c87a889b9cb9cd3042aaead5d3b671848220e88905; MD5 7ec4ca1dd8f10768d54539dad826cd2a. Rehachage de ce tour. Source OLS-8c2d0207-6ce1-546c-8b2c-f993b36b57bf. | Le reçu de membership existant associe le chemin logique au projet lol_game_client 0.0.1.7, release membre 0.0.1.2, statut matches_selected_project_manifest. | Les champs numeriques suivis dans annie_native_sources.json sont nuls pour cet INIBIN; il ne fournit pas la duree de l’etourdissement ni le corps serveur. La preuve de membership est reprise du recu existant; son empreinte (8cfb03b7e8c928135dc485b5fc02a5761568818a100f793d85492808059ce6e2) avait ete verifiee dans le lot precedent, pas rehachee ici. |
| Pyromania.luaobj | 146 octets; SHA-256 cdd6e5a46f85bbabf9f14cfb4caf4750e400e46af4bc3727b1c3584e0fead154. Rehachage de ce tour. | Le recu annie_passive_sources.json rapporte BuffTextureName=Annie_Passive2.dds et BuffName=Pyromania. | Ce sont des metadonnees du client compile, sans logique de passif. Le recu de membership selectionne consulte ne donne pas d’entree pour ce LuaObj; ne pas lui attribuer le membership de l’INIBIN. |
| Pyromania_marker.luaobj | 214 octets; SHA-256 76c18bfae89af8e422636393580c41e59ec595f43633ad275fd69d512ee7e7c3. Rehachage de ce tour. | Le recu rapporte le nom Pyromania Marker, PersistsThroughDeath=true et NonDispellable=true. | Ces proprietes portent sur ce marqueur; elles ne prouvent pas la persistance des charges ou de l’etat pret. Aucun corps serveur n’est present. Membership RADS non etabli dans le recu consulte. |
| Pyromania_particle.luaobj | 201 octets; SHA-256 5486fbc76effccbe5f0248896740c67d5a580608cb055f448fcaa2be4ba431bd. Rehachage de ce tour. | Le recu rapporte BuffName=Energized et AutoBuffActivateEffect=StunReady.troy. | Identifie un effet visuel nomme, pas sa selection, son execution, son audience ou le comportement serveur. Membership RADS non etabli dans le recu consulte. |
| docs/annie_q_refund_native_contract.json | Recu conserve, source de textes fontconfig_en_US et fontconfig_fr_FR et cache Data Dragon officiel 4.20.1. | Les textes client indiquent quatre sorts charges et un prochain sort offensif qui etourdit; le texte du marqueur laisse la duree comme @f1@. | Ces textes en_US/fr_FR ne qualifient pas la locale cible en_GB ni la valeur de @f1@. Le catalogue 4.20.1 reste distinct du client PUBLIC 4.20.0.315. |

La recherche bornee du recu native-release-membership.json trouve l’entree exacte Pyromania.inibin et l’entree Pyromania Marker.inibin; elle ne relie pas les trois LuaObj ci-dessus. Les anciens recus restent conserves. Les sources communautaires LeagueSandbox mentionnees dans annie_passive_sources.json n’ont pas de script P Annie dans l’arbre inspecte et ne sont pas une autorite Riot.

## Consommateur courant

- crates/core/src/annie_passive.rs contient pyromania_spell et pyromania_hit. Le code fixe quatre charges, distingue les activations offensives/non offensives, choisit une duree par seuil de niveau et demande l’application d’un etourdissement.
- crates/core/src/annie.rs appelle le compteur lors de l’acceptation de E et a l’impact de Q.
- crates/core/src/annie_w.rs appelle le compteur a la liberation de W et passe le stun aux cibles endommagees.
- crates/core/src/annie_r.rs fait de meme a la liberation de R et aux cibles endommagees par l’invocation.
- Une recherche dans crates/ ne trouve aucune lecture directe de Pyromania.inibin ou des trois LuaObj. Le code Rust courant est une implementation reconstruite et codee en dur; le lien aux ressources est une concordance semantique, pas un flux de donnees natif importe.

Attendu pour le sous-perimetre : retrouver une source client identifiee, un consommateur courant et les limites du lien. Observe : l’identite/membership de l’INIBIN et les callsites Rust sont localises; les metadonnees LuaObj sont identifiees; aucune source disponible n’explique le corps serveur complet ni la duree numerique. La relation est donc etablie comme rapprochement documente, pas comme equivalence de mecanique.

## Verification nominale, refus et preuve reutilisee

Le recu annie_passive_progress.json date du 2026-10-04 et annie_passive_network.json rapportent six nouveaux controles core et neuf controles UDP ordinaires passes. Le cas nominal UDP observe quatre charges, puis une cinquieme competence offensive qui consomme l’etat pret et applique un stun de 38 ticks au niveau 1. Les controles core couvrent notamment le plafond de quatre charges, un cast invalide, un Q invalide, une cible morte, les cibles multiples de W, la cible alliee et les seuils de niveaux. Ce resultat est celui du moteur local, pas une execution du client Riot.

Relecture d’applicabilite des preuves : les empreintes actuelles de annie_passive.rs et annie_passive_tests.rs correspondent exactement au recu du 2026-10-04. Les empreintes de crates/core/src/annie.rs, annie_w.rs, annie_r.rs, spells.rs, lib.rs et crates/client/src/main.rs different de ce recu. Les anciens tests/network runs ne sont donc pas promus en preuve des callsites actuels. Ils sont reutilises comme evidence historique bornee, sans reexecution. Aucun test, build ou lancement n’a ete execute ce tour.

## Ecarts, correction reutilisee et reprise

Corrections non executees dans ce goal : reutiliser CH-Annie-PASSIF-SIMULATION-CONTRAT pour la semantique de l’evenement/duree, CH-Annie-PASSIF-NETWORK pour les effets en session, et CH-Annie-PASSIF-ACCEPTANCE pour l’acceptation. Ne pas creer de tache de groupe ou modifier les statuts pendant cette restriction.

Restent ouverts :
- retrouver une preuve primaire 4.20 qui donne la duree numerique, l’evenement de charge/consommation et leur ordre;
- retrouver le comportement du marqueur et des charges a la mort, pendant un projectile en vol, contre immunites/boucliers et sur chaque cible;
- etablir l’identite/membership des LuaObj si une exigence l’exige, ainsi que la source en_GB effective;
- rerun les controles nominaux/refus sur la revision courante seulement quand un run cible est requis et que ses artefacts peuvent etre ecrits sans toucher au Plan ou a la base;
- verifier visuellement StunReady.troy et l’affichage du compteur separement.

Condition de reprise : source primaire Riot serveur ou trace executable native qui tranche les champs ci-dessus; archive/manifeste en_GB exact; ou nouvelle qualification des callsites Rust modifies accompagnee d’un controle courant. Ne pas repeter les decodages et hashes inchanges.

## Dimensions distinctes

| Dimension | Etat dans cette unite |
|---|---|
| Audit | Termine pour l’identite des sources disponibles et le mapping statique Pyromania -> consommateur Rust; semantique native detaillee ouverte. |
| Implementation | Partielle/reconstruite; valeurs et ordre ne sont pas tous adosses a une source primaire. |
| Verification | Preuves historiques core/reseau reutilisees; applicability des callsites actuels partielle; aucune verification reexecutee ce tour. |
| Acceptation humaine | Non fournie. |

Ce lot ne declare pas le passif Annie termine et ne contribue pas a un pourcentage global du jeu. Aucun code, asset, registre, coverage, plan d’implementation, goal, application de suivi, base, installation ou migration n’a ete modifie.