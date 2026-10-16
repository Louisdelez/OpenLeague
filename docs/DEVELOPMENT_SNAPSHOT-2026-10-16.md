# Snapshot de développement du 16 octobre 2026

Ce commit complète le snapshot e970eed et la PR #2. Il sauvegarde les sources capturées dans le chantier actif, avec des contrôles de publication effectués dans une copie isolée. Le jeu reste en développement ; ce document n'annonce aucune livraison complète.

## Contenu

- Routes et présentation partielles de Trundle Q/W/E/R, passif, ralentissements des unités et corrections de poursuite de Tibbers et d'interaction avec Garen.
- Primitive de trajectoire/collision linéaire et correctif empêchant un dégât refusé de polluer l'attribution ultérieure d'une élimination ou assistance. La préparation du Q d'Ezreal ne devient pas un sort implémenté dans ce snapshot.
- Connexions locales IPv6, caméra, HUD, brume, textures natives de sbires et captures graphiques. Le fork local Bevy Render et ses licences sont inclus pour conserver les sources du mécanisme de capture.
- Catalogue de 122 champions : dix associations d'animation de sorts et 34 rôles critiques restent manquants. Les associations présentes ne qualifient pas les kits ni leur lecture réelle en jeu.
- Rulesync, skills de reprise/passation, configurations Codex/Claude Code/Copilot/Gemini CLI/OpenCode/Kimi, mémoire locale MCP et outils continues/Repomix. Les dépendances sont fixées ; caches, venv, node_modules et historiques privés ne sont pas publiés.
- Contrôle de dépôt adapté au mode de packs explicitement locaux déjà implémenté par le téléchargeur. Une URL distante absente sans local_only booléen et provenance reste refusée ; les états IA privés sont interdits dans les ajouts.

## Vérifications de cette copie

- cargo metadata --offline --locked --no-deps : réussi.
- cargo check --offline --locked -p openleague-core, avec cible de compilation isolée : réussi, 22 avertissements. Les 103 entrées littérales absentes de la copie Git ont été copiées depuis les vraies ressources locales uniquement pour ce contrôle ; elles ne sont pas des fixtures et ne sont pas ajoutées au commit par cette copie.
- 15 tests du contrôle de dépôt : réussis.
- Cinq tests de continuité IA : réussis, dont conservation de l'index et refus des chemins/jonctions sortant du projet.
- Vérification Rulesync des fichiers générés : réussie.
- Recherche ciblée de motifs de secrets dans les 230 fichiers capturés : aucun résultat. Ce contrôle n'est pas une garantie exhaustive.

Les contrôles du diff indexé et les résultats GitHub sont consignés dans la PR après leur exécution. Les suites complètes du moteur, serveur, client, launcher et GPU ne sont pas relancées ni revendiquées par cette publication. Les tests du chantier actif et les observations ordinaires restent attachés à leurs propres sources et exécutables.

## Distribution et limites

Le manifeste contient deux packs local_only avec URL nulle : openleague-assets-02-gnar-local-20261015.zip et openleague-assets-11-native-minion-mips-local-20261016.zip. Ils doivent être fournis avec leurs empreintes exactes dans le cache indiqué par le manifeste. Aucun remplacement des anciennes releases ni publication de ces ZIP n'est effectué ici.

L'examen des includes Rust repère aussi treize entrées supplémentaires non distribuées par le manifeste : onze textures/images et deux grands contrats audio. Les trois DDS natifs de sbires relèvent du pack local ci-dessus. Leur inventaire et les empreintes sont dans development_snapshot_2026-10-16.json. Les chargements dynamiques ne sont pas audités exhaustivement, et les packs distants ne sont pas retéléchargés pour cette publication.

Les corpus RADS reconstruits, archives, exécutables, ressources destinées aux packs et états privés restent hors de ce nouveau commit. Certains rapports détaillés de suivi restent locaux ou issus de graines historiques ; les notes courtes de reprise donnent le contexte sans prétendre publier toutes les preuves de travail.

Une installation depuis un clone neuf, une partie à six clients jusqu'aux résultats, la fidélité native, l'audio et les performances ne sont pas qualifiés ici. La PR reste en brouillon. Le checkout actif est préservé et ses changements ultérieurs à cette capture ne sont pas synchronisés automatiquement.
