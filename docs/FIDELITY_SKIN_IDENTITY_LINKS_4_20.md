# Identités de skins — liens V108

Recherche puis intégration contrôlée ;les mentions non intégré ci-dessous décrivent les étapes antérieures.

# V108 — identités de skins, recherche

Relecture actuelle des668 identités du catalogue officiel4.20.1 :656 liaisons explicites uniques,5 liaisons équivalentes,7 ambiguïtés conservées. Les456 fichiers natifs candidats ont été revérifiés en taille et SHA-256. Neuf tests du résolveur existant passent :identités héritées/dédiées, mauvais identifiant refusé, absence sans repli base, ambiguïté Renekton, séparation runtime, entrées invalides, équivalence de champs.

Le code du résolveur et du parser est chargé depuis F. Le helper historique conserve un chemin E dans sa recherche de modules ;le parser F est chargé explicitement avant lui. Les tests historiques lisent leur référence E en lecture seule. Aucun fichier E ou natif modifié. Le catalogue officiel référencé garde sa provenance originale.

Le premier contrôle strict des dictionnaires de pins a échoué sur la casse Skin01/skin01 du chemin Lissandra. Taille221 et SHA10198534f71a9639cc5ca4d1cb12dbc1c01070f073c817f8efc9815b7344ad4a identiques. Le script initial est conservé. Correction :équivalence de chemin Windows et comparaison stricte taille/SHA, sans réécrire les sources historiques.

Le catalogue de rendu contient265 clés et couvre les122 noms canoniques. Ses clés supplémentaires incluent noms d’affichage, cheminsGLB, formes, invocations, monstres et décors. Ce relevé ne prouve ni la propriété de chaque forme par un skin ni une liste de champions supplémentaires. Examiner ensuite le générateur du catalogue et animation::Catalog/request pour établir les alias effectivement consommés et les exceptions justifiées.

La date embarquée du client reste2014-11-17 17:46:45, fuseau/déploiement inconnus. Le catalogue4.20.1 est distinct ;aucune date de sortie d’apparence n’en est déduite. Les sept ambiguïtés natives, la sélection des skins en partie et l’acceptation visuelle restent ouvertes.

Preuves :skin-identity-research.json,skin-tests.log,identity-research.log. V107 reste dernière intégration au registre. Cette recherche V108 n’a changé aucune case,aucun gameplay ni aucune source native. Suite :alias/formes/exclusions,associations précises et intégration du lot SYS-14.1.


# V108 — catalogue réellement consommé, alias et exclusions

Lecture statique de Catalog::default et animation::request :122 entrées du manifeste champion fusionnées avec42 entrées du manifeste monde,soit164 entrées effectives. Les122 noms canoniques sont présents. Ezreal reçoit le chemin local champions/ezreal_joint_identity_local.glb. Le chargement des champions demande p.champion ;aucun choix de skin/forme n’est démontré par cet appel.

Correction de portée du premier inventaire :les265 clés de model_catalog.json sont un catalogue documentaire/outil ;ce fichier n’est pas l’entrée du Catalog de ce parcours. Ses alias ne peuvent pas être qualifiés comme dispatch runtime sur cette seule présence.

Deux groupes du catalogue effectif partagent un chemin de modèle :les deux nexus détruits et les huit tourelles détruites. Aucun de ces deux groupes ne démontre un alias de champion. Un chemin partagé ne prouve ni identité native ni propriétaire d’une forme alternative. Les alias de noms et formes présents dans le catalogue documentaire nécessitent leur propre source native et leur consommateur.

Le plan comporte10688 tâches SKIN.10020 portent required=false mais deux conditions explicites imposent la qualification historique avant exclusion :8016 tâches avec condition d’implémentation et2004 avec disponibilité à prouver. Ce sont des obligations conditionnelles, pas10020 exclusions acquises. Le consommateur instructions.py affiche ces conditions. Aucune tâche n’a été exclue ou cochée ici.

Preuve :runtime-alias-research.json avec ancrages,sources SHA,inventaires et conditions exactes. Aucun test Rust,chargement Bevy ou GPU exécuté dans cette lecture statique. Les neuf tests précédents concernent le résolveur natif seulement. Prochaine étape :retrouver le producteur des alias documentaires et les références natives des formes,puis lier les quatre exigences SYS-14.1 en distinguant résultats partiels et frontières. V107 reste dernière livraison intégrée ;Goal actif.


# V108 — provenance des alias et préchargements natifs

Le producteur historique E:/mapslol3v3/tools/prepare_rust_integration.py ajoute les noms d’affichage uniquement pour les entrées kind=champion,avec mise en minuscules. Douze alias officiels distincts du nom canonique sont présents dans model_catalog.json et leurs entrées sont entièrement égales. bootstrap_openleague.py importe ce catalogue depuis MinecraftMOBA comme model_metadata. Les producteurs ont été lus,pas exécutés.

import_all_champions.py regroupe aussi des répertoires par préchargement et par préfixe de nom. Ses75 entrées related_form_or_summon sont une classification d’exporteur ;elles ne prouvent pas75 transformations ni une propriété de skin. Leur association actuelle est conservée sans la promouvoir en fait natif.

Les456 fichiers candidats du registre des668 skins ont été décodés avec le parser F en lecture seule.71 liaisons de champs ExtraCharacterPreloads ont été relevées avec champion,skin,section,statut de liaison,fichier et SHA. Cette dépendance native est précise mais ne distingue pas invocation/transformation et ne prouve pas la sélection runtime. Les candidats ambigus restent signalés. Aucun fallback ou propriétaire inventé.

Preuve :alias-preload-research.json. Ce contrôle complète les recherches précédentes et permet de préparer les quatre associations SYS-14.1 :réconciliation partielle,alias documentaires démontrés,préchargements partiels et frontière de justification des exclusions. La propriété complète de chaque forme/skin et la politique historique de disponibilité restent ouvertes. Aucun runtime,asset ou état manuel modifié ;V107 reste dernière intégration. Suite :lecteur de preuves et intégration contrôlée V108.


## Qualification et livraison

484 fichiers,1048 contrôles source,25 cas lecteur dont24 refus. Le registre observé est conservé dans task-registry-observed.json pour éviter une preuve dépendant de sa propre mutation. Les sources natives sont des candidats identifiés ou des dépendances de préchargement,avec ambiguïtés conservées. Aucun choix complet de skin/forme ni disponibilité historique qualifié. Résultat de livraison dans docs/fidelity_registry_skin_identity_links_revision_4_20.json.

| Tâche | Source et consommateur | Travail restant |
|---|---|---|
| SYS-14.1-01 | 668 catalogue identities reproduce their native configuration bindings:656 unique,5 equivalent,7 ambiguous;date/build and catalogue remain distinct. | Historical availability per appearance and runtime skin selection remain unqualified. |
| SYS-14.1-02 | Twelve display aliases equal canonical entries in the documentary catalogue and the historical producer explicitly creates them. Current Catalog reads two other manifests;no extra champions inferred. | Qualify each native alias and runtime name translation;documentary aliases alone are not active dispatch. |
| SYS-14.1-03 | Seventy-one ExtraCharacterPreloads bindings read from456 native files;exporter labels75 related resources. These identify dependencies,not complete form ownership. | Map every form to owner champion and skin with original selectors;distinguish summons and transforms,retain ambiguities. |
| SYS-14.1-04 | Instructions render conditional skin obligations and demand sourced historical justification;ambiguous or absent bindings never imply exclusion. | No complete appearance exclusion ledger or historical availability classification is qualified. |

Reçu : docs/reference_skin_identity_sources/skin_identity-links.json. Livraison : docs/fidelity_registry_skin_identity_links_revision_4_20.json. Les quatre tâches et le Goal restent ouverts.
