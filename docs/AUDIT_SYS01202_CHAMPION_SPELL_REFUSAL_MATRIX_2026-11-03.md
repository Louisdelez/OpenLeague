# Audit groupé — refus de progression et de sorts pour les champions du catalogue local (2026-11-03)

## Périmètre et décision

Unité AUD-SYS-01.2-02-CHAMPION-SPELL-REFUSAL-MATRIX-01. Question : les refus génériques déjà liés aux tâches de simulation sont-ils réellement atteignables pour chacun des champions et chacun des quatre slots concernés ? Périmètre : API du cœur courant et catalogue local de 122 IDs, pas les règles Riot ni le jeu complet. L'audit de cette matrice locale est clos pour les conditions décrites. Il ne clôt ni les 472 audits de source individuelle, ni les fonctionnalités des champions.

## Référence et liens

Le catalogue compilé openleague_core::champion_catalog charge data/4.20/champions.json; SHA-256 de ce JSON 7cc80048c9460419041134232345d9b4da6d8f4e6795f7236720bef39e99de88. Le nombre de 122 correspond au catalogue local, pas à une nouvelle vérification de la liste historique Riot. Les branches courantes sont crates/core/src/progression.rs:150–164 pour l'apprentissage, spells.rs:101–125 pour Action::Cast et annie_w.rs:29–50 pour Action::CastAt, dispatchés par lib.rs:598–623. Garen, Annie, Trundle et Ezreal ont des branches spécifiques dans ces chemins; être une exception ne démontre pas qu'un champion ou un sort soit complet.

Le script task_links.py a rapproché le catalogue, completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json et fidelity_sources_4_20.json : pour les 118 autres IDs, chacune des 472 tâches CH-<champion>-<Q/W/E/R>-SIMULATION existe, est a_implementer_ou_integrer et référence déjà OLC-f4df34db-711f-52bc-8bb6-979c3621a25b (explicit_refusal, spells.rs:120). Le mapping par ID, noms exacts et requirement_id est conservé dans task_links.json; la comparaison est insensible à la casse pour les IDs de tâche. Les 472 traces portent associated_sources_and_current_entrypoints et une liste unknown_ids vide; cela ne démontre pas l'existence d'une mécanique implémentée ni la résolution de toutes les inconnues historiques.

## Vérification exécutée

Programme Rust externe E:/mapslol3v3/champion_spell_refusal_audit, compilation et exécution `cargo run --offline --manifest-path E:/mapslol3v3/champion_spell_refusal_audit/Cargo.toml --quiet`, code 0, puis binaire conservé relancé, code 0. openleague-core courant, grille synthétique plate 80×80, session 420, une simulation isolée par champion. Pour chaque champion, quatre tentatives Learn depuis niveau 1/rangs 0; pour chaque slot ensuite rang 1 injecté directement, niveau 1 pour Q/W/E et niveau 6 pour R, et commandes Cast sans cible puis CastAt avec point fini. Ces rangs ne sont pas obtenus par une progression jouée. Avant/après chaque refus, égalité de l'instantané sérialisé; pas d'affirmation sur tous les champs privés.

Attendu et observé pour chacun des 118 IDs et chacun des quatre slots :
- Learn refuse `champion skill progression not implemented` : 472 refus.
- Cast refuse `champion spell not implemented` : 472 refus.
- CastAt refuse `champion ground spell not implemented` : 472 refus.

Total : 1 416 refus et 1 416 comparaisons d'instantané réussis dans la fixture. Quatre témoins distincts montrent que Garen, Annie, Trundle et Ezreal apprennent chacun Q à niveau 1; aucun lancement ni autre slot de ces quatre témoins n'est validé ici. Le script crosscheck.py, code 0, confirme que les 118 IDs testés sont exactement ceux des 472 tâches liées, avec un Q/W/E/R par ID. Aucun client, serveur réseau, partie ordinaire, source historique native ou comportement Riot n'a été exécuté. Les résultats individuels sont dans resultats.json.

Compilation : cargo/rustc 1.96.1; les avertissements du cœur sont consignés dans compilation-warnings.txt. Le lockfile de cette fixture est isolé et ne garantit pas l'identité d'un build officiel du dépôt. Le code serveur 4.20 ou une capture mesurée demeure nécessaire pour qualifier les mécaniques et paramètres; une liste locale d'inconnues vide ne remplace pas ces entrées.

## Preuves et fichiers

E:/mapslol3v3/champion_spell_refusal_audit : source src/main.rs SHA-256 17942933fac919f2c98f3fdd3f8aa81a4c38e01e26a5b43e4222fce5bc7d6e85; Cargo.lock 06948ded7b90a5718b31c09f1f45b90a7396922629772f854aa8324cf1e773cd; binaire openleague-champion-spell-refusal-audit.exe, 28 747 264 octets, eb4565070c05541771749dcc1a2730260a2b9de4247b1b48391b33b9bd1c9f66; resultats.json b62062a87666acc0c494a73229d6d2c34b45a81cfeb5909fdd320df02e493edb. task_links.py c85b702ebab931480f40c5e1cb2a2d7d7fd5880236c5ba9ce8d09c7fed3b319e; task_links.json c59129268bf06c3057a7a0c7a5d15b425aedf511301687944174bfffeac8ca53; crosscheck.py 2c70d02cbb7c20971e00bda2430a3b243c4f870e4e0004a5280eccec86e5582e; crosscheck.txt 952157de44e2d1e27126caab1e650f05bf31dbe0a4563f99f2333d9731e42c26.

Empreintes des entrées de registre : completion_tasks_2026-10-20.json 5c30d6f9543cc7f39e7801ab721242204f5745b60e118f793fe618b13baef8da; fidelity_requirement_trace_4_20.json 05e82921fde916bc1b576db7f9801b87e8223b866ad1bf1205a8d3e670e60a05; fidelity_sources_4_20.json d8283f8872339087d5e2134f9342b06bc3e67d21514ce4149a1bf42b388fcc38. Ancres partielles du cœur : lib.rs cb2af93a240737ed3f1d3ee31cf4ff916e730f402e7d0b128e7f29e5a3ed004d; spells.rs 26fc5175f41325935b7e7ad91d6aba72cf4560b1be97f69f69d70e0dfe0680a5; annie_w.rs b15cfe63f6bd51560917af5e6270ebc4b2b7d73fd63fd5fc5061145de9f74553; progression.rs eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766. Non hermétique : autres dépendances non toutes hachées.

## Écarts et reprise

La preuve montre un manque de support sur ces entrées, pas qu'aucune autre représentation ou ressource n'existe. Réutiliser, pour chaque champion et capacité, les tâches SOURCE, SIMULATION-CONTRAT, SIMULATION, NETWORK, PRESENTATION et ACCEPTANCE existantes. Qualifier d'abord les sources et règles distinctes, puis implémenter dans un travail séparé l'apprentissage, le type de ciblage, les effets et refus, avec contrôle des cinq rangs ou du schéma propre, interactions, réseau et présentation. Rejouer cette matrice après changement des dispatchs et remplacer les attentes de refus par des tests fonctionnels propres aux sorts alors implémentés. Ne pas traiter 1 416 refus attendus comme 1 416 fonctions achevées.

Audit de matrice local terminé; implémentation absente sur les chemins contrôlés, vérification partielle et acceptation humaine non demandée. Aucun statut, registre, goal, application de suivi, base ou code produit modifié.
