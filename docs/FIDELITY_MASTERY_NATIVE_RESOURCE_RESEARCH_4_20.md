# Maîtrises4312/4313 : recherche native du champ et index de ressources — V64

Les deux divergences restent ouvertes : SpellData.Ranks=4 dans les fichiers natifs, trois rangs dans Data Dragon4.20.1, valeur effective du Talent.maxRank historique inconnue. Aucune valeur de plafond n'est adoptée par ce lot.

La recherche exacte du hash SpellData*Ranks et du littéral Ranks ne fournit aucune occurrence dans ce PE précis. Six champs connus ont aussi zéro occurrence de leur hash brut : ce contrôle invalide toute conclusion d'absence de lecteur à partir de ce seul procédé. Des champs peuvent être calculés, indirects ou décrits hors de cette représentation.

Une recherche ASCII/UTF16LE trouve Data/Talents et des diagnostics TalentHashMap. Des fenêtres statiques exactes contiennent90B97FpushData/Talents,90B9F1call905620et90BA93call905090. Le candidat607640référence.luaobjet.lua et des collisions de hash. Ces fenêtres ne prouvent ni fonction complète, activation, lecture de Ranks ni plafond de service. Les anciens contrats de ressources identifient905090comme insertion/alias de noms et enregistrent DATA/Talents dans la population globale. Leurs programmes natifs ne sont pas rejoués et leurs limites d'adaptateurs/ordre de fichiers restent attachées.

Le fournisseur Rust courant est exercé dans un programme isolé avec son préfixe exact, avant les tests.13nouveaux cas vérifient les noms/alias4312/4313, une variante de casse, les clés absentes et le refus nonASCII. Quatre noms de fichiers réels sont fournis comme chaînes ; aucun fichier de maîtrise n'est ouvert par ce programme. Résoudre4312.iniou4312.lua n'est ni parser leur contenu, ni déterminer maxRank. Le code généré, le compilateur, le binaire et ses résultats sont identifiés.

25contrôles de source et17contrôles de contrat dont16refus qualifient cette distinction.42sources sont relues ; le lecteur installé tools/project-plan/audit_mastery_native_research.py reproduit le contrôle. La preuve AIR39 de19contrôles reste héritée : elle établit l'autorité du DTO et ses consommateurs, pas la valeur historique du champ. Aucun ancien export, ancien cas natif ou programme terminé n'est relancé.

Le registre conserve les deux questions, leurs textes/recherches/conditions antérieurs et les deux lignes Data Dragon inchangées. Il reçoit les nouvelles recherches et les conditions précises : identifier le véritable lecteur natif du champ et son rôle, ou récupérer le payload EUW4.20 Talent.maxRank/une preuve primaire équivalente, puis qualifier le consommateur courant. L'index de ressources, le nom de hash, les descriptions et les recherches négatives ne remplacent pas cette entrée.

Aucun client historique, serveur, jeu graphique, Blender ou instruction originale exécuté dans V64. Aucun code Rust de production, asset, case, note ou historique utilisateur modifié. Le nouveau Python est un lecteur de preuves, pas une implémentation du plafond des maîtrises. Les six objectifs du Goal restent actifs.

Sources :docs/reference_mastery_native_resources/native-resource-research.json. Livraison :docs/fidelity_registry_mastery_native_research_revision_4_20.json. Recherches, cas et binaire isolé :E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision64.

## 2026-11-02 — consommateur de maîtrise absent du runtime actuel

### Résultat source → consommateur

Le reçu `reference_mastery_native_resources/native-resource-research.json` conserve les candidats natifs `Data/Talents/4312.*` et `Data/Talents/4313.*`, les traces `TalentHashMap` et les limites de l’analyse du PE. Il rapporte `SpellData.Ranks=4` dans les fichiers natifs examinés, contre trois rangs dans Data Dragon 4.20.1, mais aucun lecteur natif de `Ranks` ni plafond historique effectif (`Talent.maxRank`) qualifié.

Une inspection actuelle ciblée de tout `F:\OpenLeague\crates` confirme qu’aucun module Rust `mastery`/`talent`, `TalentHashMap` ou `maxRank` n’existe ; la seule mention est un commentaire dans `passive_gold.rs` indiquant que les modificateurs de revenu de maîtrises ne sont pas pris en charge. `main.rs` n’initialise ni ne planifie un consommateur de maîtrise. Le catalogue de cinq ZIP monté au démarrage couvre les paquets Menu/HUD et Spells observés ; aucun appel de lecture d’un fichier `Data/Talents/4312` ou `4313` n’est présent. Les treize contrôles précédents du fournisseur isolé vérifient des noms/alias de chemins en chaînes et des refus, mais n’ouvrent pas les fichiers natifs. Ils ne constituent pas un consommateur de jeu.

**Audit du consommateur courant : terminé dans le périmètre Rust du client inspecté — aucun consommateur de maîtrise n’est intégré ou appelé.** Le plafond et l’implémentation de maîtrise restent incomplets ; aucune valeur 3 ou 4 n’est adoptée par ce constat. Résultat attendu : un callsite de jeu qui lit la valeur native et transmet le rang effectif. Résultat observé : aucun callsite, et l’analyse native conserve explicitement `native_Ranks_consumer_qualified=false` et `effective_mastery_cap_qualified=false`. Aucun test, build, serveur ou client n’a été exécuté dans ce lot.

Condition de reprise : obtenir une preuve primaire du lecteur natif de `SpellData.Ranks`/`Talent.maxRank` et relier ce lecteur à un consommateur Rust de jeu, puis comparer le comportement 4312/4313. Les recherches négatives actuelles ou la seule existence des noms `4312.ini`/`4312.lua` ne doivent pas être répétées comme preuve de valeur.