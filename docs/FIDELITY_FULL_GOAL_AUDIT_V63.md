# Audit des six objectifs du Goal — V63

V63 relie les quinze exigences communes de combat SYS-04.3-01 à15 à dix-neuf sites actuels précis. Le Goal conserve les six objectifs SYS-01.2-01 à06. Aucun algorithme original complet, question sémantique, fonctionnalité complète ou acceptation n'est fermé par ce lot.

| Objectif original | Résultat vérifié | Travail encore ouvert |
|---|---|---|
| 01 — Identifiants stables | 42757 identités et liens conservés | Acceptation humaine non déduite |
| 02 — Source et consommateur de chaque exigence | 92257 sources, 292 ancres ; quinze associations communes de combat précisées | 897 liens génériques, 1 470 frontières sans fonctionnalité ; six périmètres Map10 et quinze périmètres de combat partiels |
| 03 — Origine, version et SHA | Métadonnées complètes ; 71 fichiers d'entrée/delta relus ; 92 224 anciens enregistrements et 273 anciennes ancres intacts | Qualification V62 héritée ; pas de nouveau scan global ni d'authentification globale des origines |
| 04 — Divergences natif/Data Dragon | Décisions et comparaisons antérieures conservées | 4312/4313 : rôle de Ranks4 et plafond effectif de service face au maxRank3 du catalogue |
| 05 — Contradictions communautaires | Inventaire 797 scripts et évaluations nommées conservés | Selon les cas : dispatch, arguments, retours et rôles ; l'inventaire n'est pas une évaluation sémantique complète |
| 06 — Inconnues | 30 835 questions structurées ; quinze recherches/conditions affinées | 25 321 ouvertes, 5 514 résolues ; aucune clôture nouvelle |

Les entrées natives sont des champs de personnage, sorts, objets et textes en_GB. Leur appartenance aux manifestes sélectionnés est vérifiée. Les valeurs de défense de Garen et les valeurs de Trundle R/W sont liées aux tables courantes. Un exemple natif et une description ne sont pas le corps d'algorithme serveur Riot manquant. Les règles non établies gardent cette limite, y compris les règles de distribution Map10 traitées en V62.

Trois fonctions courantes sont compilées et exécutées dans un programme isolé : resistance_multiplier, mitigate et effective. Les corps sont copiés exactement ; contexte de crate et derives de sérialisation omis.35cas comparent les bits f32 pour physiques/magiques/bruts, résistances positives/négatives, réductions, pénétration, zéro, NaN, infinis et overflow. Le compilateur, le code généré, le binaire et les résultats sont identifiés. Ce n'est ni une exécution complète de Simulation ni une comparaison avec le serveur historique. Les cas terminés ne sont pas rejoués après correction du collecteur.

Les sites actuels distinguent l'événement de dégâts, les défenses, la pénétration, les réductions, les boucliers, la vie, les soins et le calendrier. Le bouclier commun reçoit un montant sans DamageKind ; ses champs sont tag/remaining/expires_at. Le consommateur d'une fonctionnalité de bouclier typé reste donc non identifié dans ce chemin. SYS-04.3-14 conserve une frontière d'entrée explicite et une question ouverte, sans promotion en fonctionnalité. Les priorités de boucliers, règles complètes de pile, ticks et ordre de tous les événements restent à qualifier.

18contrôles de source, 16contrôles de contrat dont15refus, et26contrôles de livraison passent. Les42 214consignes et24couples HTTP fiche/copie concordent ; dix-huit seules métadonnées/consignes changent : trois du registre des sources et quinze du combat commun. Les42 606états manuels et l'historique restent identiques. Aucun Rust/C de production, asset ou binaire du jeu modifié ; aucun jeu, serveur, Blender ou programme historique exécuté. Tauri est relié à la même base ; sa fenêtre native n'est pas observée.

Le premier collecteur cherchait les sorts Trundle dans le répertoire global ; la table native_resource et les fichiers réels donnent DATA/Characters/Trundle/Spells. Source et échec initiaux conservés. Le générateur a aussi eu une règle de remplacement redondante et deux erreurs de finalisation de métadonnées de dérivation ; les brouillons et détails sont conservés. Seules les étapes échouées ont été corrigées ; aucune préparation, sonde numérique ou qualification réussie rejouée pour reformater une preuve.

Les liens génériques passent de912à897 ; une nouvelle frontière sans fonctionnalité est explicitée, portant ces frontières à1470. Le compte combiné passe de2381à2367. Cette baisse correspond à des sites identifiés, pas à quatorze fonctionnalités terminées. Les quinze périmètres de combat et les six de Map10 restent ouverts. Les six objectifs initiaux gardent leurs états :01/03/06àvalider,02/04/05partiels. Goal actif.

Livraison : docs/fidelity_registry_combat_consumer_links_revision_4_20.json. Sources et limites : docs/FIDELITY_COMMON_COMBAT_LINKS_4_20.md. Audit JSON : docs/fidelity_goal_completion_audit_20261022_V63.json. V62, SYS-01.1-02, les recherches des42autres fichiers vides, les12décisions d'adoption, les caps4312/4313 et les cas communautaires sont conservés.
