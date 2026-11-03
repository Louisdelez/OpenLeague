# Audit ciblé — Ahri Q : source, saisie et refus du moteur (2026-11-03)

## Périmètre et décision

Unité AUD-SYS-01.2-02-AHRI-Q-SOURCE-DISPATCH-01, rattachée à CH-Ahri-Q-SOURCE (OLF-48c350ed-7a20-53bc-8b45-c8c3bec69663) et CH-Ahri-Q-SIMULATION-CONTRAT (OLF-fb9e92cb-40fe-5e01-b67a-f74e6c1dfa81). Question : quelle ressource native correspond au Q, quels champs numériques ciblés existent dans l'export, et les points d'entrée courants permettent-ils de l'apprendre ou de le lancer ? Audit borné terminé pour ces liaisons et refus observés. Cela ne clôt pas les exigences parentes, le contrat complet du sort ou l'implémentation.

## Source, interprétation et consommateur

La ressource client DATA/Characters/Ahri/Spells/AhriOrbofDeception.inibin, OLS-d7489bc3-06e0-5aa2-abdf-1b9c3f4f318e, a été relue dans la copie 4.20.0.315 de référence : 1 461 octets, SHA-256 2071a9595653d4a391c806a5dd167a5ae926f9c49f3cf3b96f9baa7f58d7a152, conformes au registre. La liaison Data/Spell1 dans Ahri.inibin et le rattachement de cette ressource au manifeste sont des preuves antérieures; elles ne prouvent pas le code serveur historique. Le SHA c1d95904... de la ligne native_spells_420.json désigne son export JSON cité, pas ce fichier INIBIN.

Le lecteur existant tools/project-plan/reference_inibin.py (SHA-256 8649d9775feaa9a8a549e07e8a8b6f57a4d4bf91e68841094fa5ccec383a5da5) a décodé le fichier original en lecture seule. Pour 19 clés SpellData ciblées, comparaison numérique native/export local à 10⁻⁶ réussie : ManaCost1..5 = 55/60/65/70/75; Cooldown1..5 = 7; Effect1Level1Amount..5 = 40/65/90/115/140; Coefficient et Coefficient2 valent chacun approximativement 0,35; CastRange = 10000 et CastRangeDisplayOverride = 880. Les coefficients natifs float valent 0,3499999940395355 : comparaison approchée, pas égalité bit à bit au JSON 0,35. Ces champs ne démontrent ni quel effet serveur emploie chacun ni que la portée d'affichage est la portée de simulation.

Le HUD courant crates/client/src/native_hud_spells.rs:21–31 lit la ligne native_spells_420.json selon champion et slot pour déterminer le coût en mana si un rang est renseigné et les autres gardes satisfaites. Le plugin est enregistré dans crates/client/src/main.rs. C'est un consommateur générique de données, pas une preuve de rendu exécuté ou du comportement Q. L'apprentissage ordinaire d'Ahri est actuellement refusé; le cas d'un rang existant dans le HUD n'est donc pas démontré par une progression normale.

La saisie courante crates/client/src/spell_input.rs:1 ne classe pas Ahri Q comme visée au sol. Sous les gardes de connexion/snapshot et de raccourci pertinentes, crates/client/src/main.rs:1388–1392 et 1440–1455 prédit pour Q Action::Cast { slot: 0, target: None }; cette route client n'a pas été exécutée ici. Le cœur dispatch ces actions depuis crates/core/src/lib.rs:598–623 vers progression.rs, spells.rs et annie_w.rs. Une recherche littérale ciblée AhriOrbofDeception / ahri_orb / orb.of.deception dans crates/core/src, crates/client/src et crates/server/src n'a trouvé aucune occurrence; cette recherche ne prouve pas à elle seule l'absence de tout comportement indirect. Les refus effectifs ci-dessous établissent les cas d'API testés.

## Vérification réellement exécutée

Fixture Rust externe E:/mapslol3v3/ahri_q_audit_probe, compilation/exécution `cargo run --offline --manifest-path E:/mapslol3v3/ahri_q_audit_probe/Cargo.toml`, code 0, puis exécutable copié relancé, code 0. Simulation réelle openleague-core, grille synthétique plate 80×80, session 420, champion Ahri niveau 1. Aucune installation, connexion réseau, interface graphique ou partie historique. La compilation a émis 24 avertissements préexistants du cœur. Cargo/rustc 1.96.1; lock isolé avec serde_json 1.0.151 mais d'autres versions peuvent différer du lock projet : ce n'est pas un build officiel hermétique.

- Attendu et observé : apprendre Q par Action::Learn est refusé avec `champion skill progression not implemented`.
- Le rang 1 est ensuite injecté directement comme condition de test, puisque l'apprentissage est refusé. Action::Cast Q est refusé avec `champion spell not implemented`; Action::CastAt vers un point fini est refusé avec `champion ground spell not implemented`.
- Un point NaN est refusé avec `invalid spell point`. Dans chaque refus, l'instantané sérialisé avant et après est égal; cette comparaison ne démontre pas l'absence de mutation de tout état privé hors instantané.
- Témoin : dans une simulation distincte, Garen apprend puis lance Q et son cooldown vaut 240 ticks. Ce contrôle distingue les refus ciblés d'un dysfonctionnement général de la fixture, sans valider Ahri.

Contrôle natif distinct : `F:/OpenLeague/.ai-tools/.venv/Scripts/python.exe -B E:/mapslol3v3/ahri_q_audit_probe/native_check.py`, code 0, 19/19 champs numériques ciblés concordants avec la tolérance décrite. Aucun test client/HUD, projectile, effets, réseau ni serveur Riot exécuté.

## Preuves et limites

Fixture Rust : source SHA-256 8ffc46f2f47dd4413016aac577460204cb697c5b37474f2c61ad593c866096c7; Cargo.lock 281ca5277ef97913622bcf03f325bb4213ab670f65091595f967776097cd7b72; exécutable de 28 665 856 octets SHA-256 87a838996a5380abc0e1c05226ee067f7450906c6c179330f258969415c4003d; resultats.txt 0a2101c9507bbb2b4e34f09ba97feabd873f77c59cd256952d47793601bcc79e. Contrôle natif : native_check.py f0485c6d65764072ecd255b94f4c8c8cd59d5f634e5284bf597171d2ff0a4ad3; native_resultats.txt 2d317e9d73385965307fdfaa2e505520e652d5b17c7193974d945a55f391b668. Export local native_spells_420.json 0cae6f5c167aa852e8f86e7f3298d7c797727d5cc92616dcb856ac15c8af5d14. Ancres partielles : spells.rs 26fc5175f41325935b7e7ad91d6aba72cf4560b1be97f69f69d70e0dfe0680a5; annie_w.rs b15cfe63f6bd51560917af5e6270ebc4b2b7d73fd63fd5fc5061145de9f74553; progression.rs eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766; native_hud_spells.rs c9af91d89a4c014ee3a844378e61579f3b01efbe682c89d8fbf83b40050ede4d; spell_input.rs 2f99cb617bfd218da8d8125fcf65fbfea34eb602391899547cf065c758eadccf. Les sources projet peuvent évoluer; ces hashes ne recensent pas toutes les dépendances.

## Corrections et conditions de reprise

Réutiliser les tâches existantes sans changer leur état : CH-Ahri-Q-SOURCE (a_qualifier), CH-Ahri-Q-SIMULATION-CONTRAT (a_faire), CH-Ahri-Q-SIMULATION (a_implementer_ou_integrer), CH-Ahri-Q-PRESENTATION-HUD (a_faire), puis NETWORK, PRESENTATION et ACCEPTANCE selon leurs périmètres. L'absence d'unknown_ids pour certaines traces ne prouve pas que la sémantique est connue.

1. Qualifier les règles historiques par source serveur attribuable ou capture 4.20 mesurée, notamment ciblage, trajet aller/retour, effets et valeurs réellement consommées; distinguer portée d'affichage et portée effective.
2. Prévoir séparément la progression Q d'Ahri, la saisie au bon type de cible et la simulation avec refus explicites; les vérifier aux cinq rangs, aux frontières et sur une partie ordinaire.
3. Relier l'état et les événements aux clients, puis vérifier indépendamment HUD, animations, VFX, audio et réseau; comparer à la référence avant acceptation.

Ne pas rejouer les mêmes hashes ni le même probe sans modification ou nouvelle question. Le contrôle de liaison ciblé est clos; implémentation absente sur les chemins exercés, vérification partielle, acceptation humaine non demandée. Aucune modification de code produit, registre, goal, application de suivi ou base.
