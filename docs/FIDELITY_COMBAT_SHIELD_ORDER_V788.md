# SYS-01.2-02 — Sources des boucliers et ordre des dégâts, V788

Projet : F:/OpenLeague. SYS-04.3-14 et SYS-04.3-15 restent partielles. Ce lot précise les associations entre sources et consommateurs ; il ne corrige pas les règles de production.

## Sources natives

Huit fichiers 4.20 sont conformes aux manifestes RADS sélectionnés : BlackShield.inibin, NullLance.inibin, objets3155/3156, BlackShield.luaobj, NullLance.luaobj, fontconfig_en_GB.txt et League of Legends.exe. Les tailles, empreintes et entrées sont conservées. Deux refus sont vérifiés : SHA attendu incorrect et chemin logique traversant.

Les quatre INIBIN lient leurs descriptions aux clés du fichier de langue. Neuf textes sont conservés avec clé et ligne. BlackShield (ligne9312), NullLance (9669), Hexdrinker3155 (6794) et Maw3156 (6795) décrivent une protection contre les dégâts magiques. Cela établit cette restriction descriptive, pas toute la formule serveur, les priorités de cumul ou les interactions.

Les deux Lua client sont parsés :21instructions pour BlackShield et13pour NullLance, aucun prototype enfant ni CALL/TAILCALL. Le lecteur borné de constantes refuse NEWTABLE au pc8 de BlackShield : limite du lecteur, pas fichier corrompu. Ces métadonnées ne fournissent pas le callback serveur d’absorption.

## REA sur le binaire original

REA6.4.0, Ghidra12.1.4 et Java21.0.10 analysent une copie isolée exacte du PE x86, sans exécuter le jeu ni modifier sa source.15973880octets, SHA256402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Session fermée proprement, empreintes avant/après identiques, aucune erreur d’outil.

Trois recherches trouvent PhysicalShieldColor@0x10bb214, AllShieldColor@0x10bb23c et MagicShieldColor@0x10bb24c. Leurs cinq références appartiennent à0x7c5d80 et0x7c6200. REA fournit743entrées d’assemblage. Une lecture indépendante des sections PE recoupe les34arguments chaînes et36appels directs entrants/sortants avec leurs octets PUSH/CALL. Ce n’est pas un second désassemblage intégral.

Les fonctions combinent offsets de barres de vie, couleurs et accès à0x8b11e0. Leur rôle de configuration d’affichage est une interprétation fondée sur ces arguments et écritures ; elles ne prouvent pas les règles d’absorption serveur. PhysShieldColor dans la seconde fonction reste distinct de PhysicalShieldColor. Le getter0x8b11e0 n’est ni décompilé ni exécuté dans ce lot.

## Vraie simulation Rust

Ajout de crates/core/tests/combat_contract_observation.rs, utilisant Simulation d’openleague-core, la navigation Map10 et Garen dans des états de test contrôlés. Code de production inchangé.

Commande depuis F:/OpenLeague : cargo test --locked --offline -p openleague-core --test combat_contract_observation -- --nocapture.

Code0,3tests réussis,0échec,6observations. Les24avertissements Rust existants sont conservés dans stderr. Le reçu identifie le compilateur, le binaire de test de5170688octets et les sources vérifiées avant/après.

| Cas | Attendu d’après le code actuel et observé |
| --- | --- |
| Bouclier500, dégâts bruts100 physiques |78,409233 absorbés après mitigation ; aucun dégât de vie. |
| Même bouclier, dégâts magiques |75,700226 absorbés ; aucun dégât de vie. |
| Même bouclier, dégâts vrais |100absorbés ; aucun dégât de vie. |
| Bouclier50, appels75puis80 au tick0 | Premier événement absorbe50et retire25PV ; second retire80PV. |
| Bouclier50, appels80puis75 au tick0 | Premier événement absorbe50et retire30PV ; second retire75PV. Même total105PV. |
| NaN,+infini,-1 puis expiration | Trois refus invalid damage conservent l’état ; au tick60 affecté par le test, le bouclier expiré n’absorbe plus les20dégâts vrais. |

Shield ne contient aucun type de dégâts ; apply_damage transmet le montant à absorb_shields sans DamageKind. Les trois nouvelles ancres grant_shield/absorb_shields/apply_damage restent des frontières génériques, pas des consommateurs de boucliers typés. L’évaluation feature_consumer_identified=false est conservée.

L’ordre de deux appels directs au même tick est observé. La séquence Simulation::advance et la boucle UDP socket.recv_from sont inspectées statiquement. Aucun serveur réseau exécuté, aucun ordre total inter-clients ou inter-systèmes qualifié. SYS-04.3-15 reçoit un contrat local partiel explicite, sans prétendre remplacer la politique Riot.

## Intégration et limites

Huit sources natives reliées à SYS-04.3-14 ; quatre ancres ajoutées et dix ancres vérifiées. Anciens liens conservés. Deux questions précisées avec historique, sans clôture ni promotion.

Les quatre registres completion_tasks, fidelity_requirement_trace, fidelity_sources et fidelity_unknowns sont mis à jour par deltas réversibles. Trois fiches, parent compris, sont synchronisées dans les bases du projet et de l’application. Cases, notes, historiques, prérequis et autres lignes conservés. Les documents coverage, completion_plan, resume_checkpoint, CURRENT, HANDOFF, DECISIONS et REA_WORKFLOW reçoivent les preuves.

Sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20 :

- revision788_current_combat/RECEIPT.json : commande et logs du test Rust.
- revision788_native_combat_sources/OBSERVATIONS.json : manifestes, INIBIN, Lua, textes et identités du binaire/compilateur.
- revision788_rea_shield_colors/observations/4c05e5db-ee1c-4a94-931c-9e80134f6749/receipt.json : requêtes/réponses REA et bundle.
- revision788_rea_review.json : recoupement des chaînes et appels du PE.
- revision788_associations/OBSERVATIONS.json : associations et questions.
- revision788_delivery/ : publication, deltas et relecture indépendante.

Livrable lié au registre : docs/fidelity_combat_shield_order_v788.json. Binaires originaux, assets et code de production inchangés. Aucune exécution du client historique, validation visuelle, preuve réseau ou acceptation du jeu complet.

## Suite

Continuer SYS-01.2-02 sur F avec REA. V788 relie les sources des boucliers typés et explicite le contrat local partiel d’ordre des événements ; le filtre par catégorie et l’ordre total d’origine restent non qualifiés. Les5exigences sans native_inputs ni base locale explicite concernent Battle Training : vérifier les contrats et consommateurs réels avant toute conclusion. Ce sous-ensemble ne représente pas tout le travail restant : poursuivre les associations partielles du recensement V784, les limites audio V783 et distribution V786. Préserver les sources, preuves, cases, notes, historiques et inconnues.
