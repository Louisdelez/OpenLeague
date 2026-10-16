# Snapshot de développement — 14 octobre 2026

Cette publication conserve une copie du chantier local dans une branche dédiée, basée sur le main GitHub 5e8f07eca8454527e4361b1757bd92aa8e039ef7. Elle ne clôture aucune fonctionnalité, champion, carte ou livraison du jeu. Le chantier local actif est préservé.

## Contenu

- Effets de reliques : fournisseurs de ressources, simulation des particules, rendu du ramassage Capture et anneau permanent Well.
- Fin de partie : retrait et opacité des sbires, effets de Nexus et observations de l'interface.
- Brume des bases : géométrie, matériau, simulation et observations.
- Boutique historique Foundry, règles d'admission Map10 et données d'icônes.
- Évolutions du traitement audio RTPC, des valeurs globales et du retrait des propriétaires.
- Sources Rust, shaders, tests et données associées ; mise à jour du plan HTML.

L'inventaire détaillé et les empreintes de cette copie sont dans development_snapshot_2026-10-14.json. Ce snapshot fixe un instant du développement ; les modifications ultérieures du chantier actif ne sont pas automatiquement publiées.

## Vérifications de publication

- Métadonnées Cargo du workspace vérifiées hors réseau avec les lockfiles.
- cargo check --offline --locked -p openleague-core réussi avec les ressources locales copiées, dans un répertoire de compilation isolé ; 18 avertissements conservés.
- Contrôleur d'hygiène du dépôt et ses dix tests exécutés ; vérification du contenu indexé.
- Recherche ciblée de formats de clés privées et tokens courants dans les textes sélectionnés : aucune correspondance. Ce contrôle n'est pas une garantie d'absence de tous les secrets.

Aucun test de partie, GPU, audio audible ni test complet des champions n'a été rejoué pour qualifier cette copie. Les preuves précédentes restent rattachées à leurs exécutables et à leur portée d'origine.

## Ressources et limites

Le manifeste et les packs assets-2026-10-12 existants sont conservés. Le contrôle des include_str!/include_bytes! littéraux a identifié treize entrées locales requises qui ne sont pas présentes dans ces packs : onze textures/images et deux contrats audio de test de plus de 5 MiB. Elles sont listées avec leurs empreintes dans le JSON du snapshot ; elles restent à distribuer dans un pack supplémentaire.

Les autres ressources embarquées utilisées pour cargo check ont été copiées localement depuis la source du projet. Le check réussi ne prouve donc pas qu'un clone seul, ou un clone restauré avec les seuls packs actuels, compile tous les tests ou le client. Les ressources chargées dynamiquement pendant une partie n'ont pas été intégralement auditées dans cette publication.

Les corpus RADS reconstruits, caches, sessions, logs privés et gros historiques de qualification restent hors du commit. La branche/PR conserve le travail, mais nécessite une qualification supplémentaire avant intégration et livraison autonome. Aucun pack existant n'est remplacé et aucune release du jeu n'est créée.
