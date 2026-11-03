# Runes et maîtrises : limites d’entrée actuelles — V57

Les 1 469 tâches futures des 296 runes et 57 maîtrises sont reliées à leurs définitions natives et aux frontières d’entrée actuelles. **Aucun consommateur de leur fonctionnalité n’est déclaré réalisé.** L’audit distingue ces 1 469 limites des associations encore génériques ; il les conserve toutes comme lacunes fonctionnelles.

Une nouvelle sonde compile cinq extraits inchangés des types Rust, avec les versions serde 1.0.229 et serde_json 1.0.151 du verrou courant. Elle teste les 353 sujets : le Join local legacy accepte puis supprime les champs runes/masteries ajoutés ; JoinResumable les refuse à la désérialisation et le type legacy refuse aussi cette forme. Cinq témoins couvrent les types ordinaires et deux noms de variante synthétiques non pris en charge. Les noms synthétiques ne sont pas des commandes historiques revendiquées.

Cette sonde ne lance ni serveur ni client de jeu, n’envoie aucun paquet, n’exerce aucune admission/authentification et n’applique aucun effet. Elle ne qualifie ni icône, ni placement/rang, ni stockage ou relance. Le Snapshot factice satisfait uniquement un import inutilisé du préfixe de types, sans comportement de Snapshot exécuté.

Les sources courantes sont inspectées dans 659 fichiers Rust core/serveur/Tauri et les fichiers du launcher. Sept sites précis sont liés : enums legacy/action, JoinRequest, deux appels réels de désérialisation serveur et surface de commandes/payload du launcher. L’absence de résultat dans cette recherche bornée n’est pas une preuve d’absence dans toute archive. Les 359 champs natifs des fiches V50 restent des sources, sans adoption mécanique, disponibilité historique ni cap de service déduits.

Le validateur maintenu refuse de présenter une frontière d’entrée comme un consommateur de fonctionnalité, exige une inconnue ouverte et une preuve de portée, et ajoute une limite explicite aux consignes copiées. Ses 14 contrôles ciblés, dont 10 refus, passent. Sa version précédente et ses octets sont archivés avec la chaîne de version ; les lignes des fonctions existantes restent stables. Les 25 contrôles d’association, dont 23 refus, passent sans rejouer la sonde Rust ni les anciennes fiches.

Les 1 469 états et questions restent ouverts : 410 tâches à qualifier et 1 059 à faire. Les cas 4312/4313 gardent leur divergence Ranks natif 4 / catalogue 3 et leur autorité de service inconnue. Le compte des consommateurs de fonctionnalités manquants ne baisse pas à cause de ces nouveaux liens.

Reçu : docs/reference_rune_mastery_boundary_sources/rune-mastery-boundary-links.json. Livraison : docs/fidelity_registry_rune_mastery_boundary_revision_4_20.json. Les six objectifs initiaux, les cases manuelles et les preuves précédentes sont conservés.
