# SYS-01.2-02 — Recherche préparatoire des sources des passifs, V533

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB ; catalogue officiel 4.20.1 en_US distinct de la langue native en_GB. Build littéral 2014-11-17 à 17:46:45, fuseau/déploiement non établis.

## État réel

Les 122 tâches PASSIF-SOURCE sont inspectées en lecture seule : 118 a_qualifier, quatre partiel_a_terminer. Leurs 122 questions propres restent ouvertes. **Aucun lien de passif, nouveau CID, changement de statut ou acceptation n'est publié par cette recherche.** Les propositions décrites ici doivent encore passer préparation, contrôles, publication puis audit des vrais consommateurs du plan.

Le lot V532 précédent est publié et audité : 122 parents MODELE, 854 dépendances conservées, 145 questions enfants conservées et 122 questions propres sur import/rendu non qualifiés. Le présent travail le prolonge sans le republier.

## Lectures et résultats

| Contrôle exécuté | Observé | Portée |
| --- | --- | --- |
| Définitions natives des champions | 122 INIBIN lus avec le lecteur actuel | Data.Passive1..5 LuaName/Name/Desc/Icon et clés brutes, sans valeur inventée |
| Première appartenance manifeste | 297 occurrences conformes | Définitions, chunks déjà recensés et candidats exacts ; pas une sélection du moteur |
| Noms de fichiers déclarés | 112 fichiers candidats exacts ; 61 déclarations sans nom exact dans leur répertoire | Un nom déclaré peut désigner un buff, pas un fichier homonyme |
| BuffName dans les répertoires des champions concernés | 151 chunks lus, deux candidats nommés exactement | Caitlyn/Headshot Marker et Pantheon/Pantheon Aegis ; aucune priorité runtime déduite |
| BuffName dans DATA/Spells, DATA/Shared et DATA/Scripts | 2 446 chunks lus sans erreur ; 47 déclarations / 63 fichiers candidats | Métadonnées littérales uniquement, tous les candidats conservés |
| Déclarations encore non résolues dans ces recherches | 12 déclarations ; Talon a en plus un LuaName vide | Cela ne prouve pas 13 assets manquants |
| INIBIN candidats | 60 fichiers décodés en clés brutes | Pas d'interprétation automatique de tous les rangs, coûts, délais ou exceptions |
| Refus des lecteurs réels | Huit cas refusés | INIBIN vide/version/flags/table, Lua vide/en-tête/troncature/octets en trop |

Les fichiers candidats sont contrôlés sur les manifestes natifs sélectionnés, avec chemins, tailles et empreintes. Les scripts Python lisent les conteneurs et leurs littéraux ; ils n'exécutent ni Lua, ni le client, ni un serveur d'origine.

## Liaisons encore ouvertes

La recherche de nom exact et de littéraux n'établit pas la résolution ou priorité de chargement du moteur. Les douze déclarations ci-dessous restent sans correspondance dans le périmètre inspecté ; elles peuvent aussi être des noms anciens, des références internes, des libellés non autoritaires ou relever d'autres règles. Elles ne deviennent pas des manques d'assets constatés.

| Tâche | Déclaration brute |
| --- | --- |
| CH-Ezreal-PASSIF-SOURCE | EzrealRisingSpellForceBuff |
| CH-Irelia-PASSIF-SOURCE | Voracity |
| CH-Jayce-PASSIF-SOURCE | GarenRecouperate |
| CH-Katarina-PASSIF-SOURCE | Voracity |
| CH-Kennen-PASSIF-SOURCE | KennenMarkOfStorm.lua |
| CH-LeeSin-PASSIF-SOURCE | Shen Passive Marker |
| CH-MissFortune-PASSIF-SOURCE | Draw a Bead |
| CH-Nocturne-PASSIF-SOURCE | NocturneUmbraBladesTooltip |
| CH-Varus-PASSIF-SOURCE | VarusPassiveBuff |
| CH-Vayne-PASSIF-SOURCE | Focus |
| CH-Viktor-PASSIF-SOURCE | ViktorBlah |
| CH-Ziggs-PASSIF-SOURCE | ZiggsPassiveBuff |

**Talon** possède un Passive1LuaName vide et une description qui parle des soins de Warwick. La description native **Ezreal** est également divergente du passif nommé au catalogue. Les deux valeurs brutes et leurs empreintes sont conservées. Ni une description auxiliaire native, ni la comparaison Data Dragon ne sont transformées en récupération des callbacks serveur.

Cinq noms ont plusieurs candidats exacts dans les ressources partagées : **HecarimPassive (3)**, **NautilusPassive (7)**, **LuluPassive (5)**, **Second Sight (2)** et **SyndraPassive (4)**. Certains noms apparaissent aussi dans des métadonnées d'animation ou de test. Tous sont conservés ; le premier chemin n'est pas choisi comme implémentation canonique. Une correspondance BuffName n'accepte pas à elle seule le propriétaire, l'activation ou le comportement.

## Consommateurs actuels inspectés

Les vrais lecteurs reference_inibin.read/decode/hashkey et lua51_reference.inspect/literal_globals ont été exécutés pour cette recherche. Leur portée proposée est l'audit de données brutes et de métadonnées client. Ils ne constituent pas une fiche sémantique complète du passif ni une récupération des règles serveur.

Quatre politiques actuelles partielles existent :

- **Annie** : compteur Pyromania et producteur de stun ; l'ordre historique des événements, immunités et exceptions restent séparés.
- **Ezreal** : contacts Q/W/E/R acceptés, cinq charges, rafraîchissement local de six secondes et bonus additif ; commentaire et code distinguent cette reconstruction des callbacks d'origine.
- **Garen** : table de paliers, soin et interruption ; la filiation de la copie des notes 4.17/tooltip dynamique est héritée, tandis que les sources environnementales, boucliers et ticks natifs restent non qualifiés. Le descripteur de l'include reste une frontière fausse pour l'acceptation complète.
- **Trundle** : table communautaire explicite et récepteur local de morts par dégâts ; formule native f2, variante communautaire contradictoire, expirations naturelles, illusions, ordre et présentation ne sont pas résolus par ce code.

Neuf nouveaux descripteurs **sont proposés seulement**, avec identité de fichier, ligne, extrait et portée partielle. La proposition contient 362 arêtes natives, 600 liens partiels et un contexte Garen. Toutes les identités physiques existent déjà au registre ; aucun enregistrement physique neuf n'est nécessaire à ce stade. Les descripteurs réutilisés restent identiques. Les 122 questions propriétaires, statuts et critères restent conservés.

## Preuves et intégrité

- revision533_passive_source_discovery/DISCOVERY.json : contrats réels, métadonnées, catalogue, sources et questions.
- revision533_passive_alias_inspection/OBSERVATIONS.json : inspection des 61 répertoires et deux correspondances de littéraux.
- revision533_passive_contract_inspection/OBSERVATIONS.json : candidats partagés, propositions de composants, 60 décodages, écarts de description et huit refus.
- Commandes ALIAS_INSPECTION et CONTRACT_INSPECTION, journaux et SHA conservés ; les trois commandes de recherche retournent 0.
- Les entrées de registre avant/après et tous les fichiers inspectés sont recontrôlés. Aucun registre de tâche/trace/source/inconnue, aucune base du plan, aucun code ou asset du jeu modifié par la recherche.

La couverture, le plan documentaire et la reprise sont enrichis avec sauvegardes et champs antérieurs conservés. Aucun build Rust, Blender, GPU, VM ou réseau lancé. Aucune acceptation de champion ou de jeu.

## Suite

Poursuivre SYS-01.2-02 par le lot122CH-*-PASSIF-SOURCE depuis revision533_passive_contract_inspection/OBSERVATIONS.json. Inspection0 :122définitions INIBIN,60candidats INIBIN décodés,2446chunks partagés lus sans erreur,8refus. Proposition non publiée :362arêtes natives,600liens de composants partiels,1contexte Garen,9nouveauxCID,0nouvelle source physique ;122questions propriétaires conservées,aucune source-sheet complète. Vérifier les conditions d’usage/propriété et les sources des quatre politiques actuelles avant préparation/check/publication/audit ;préserver tous les anciens champs/cases/notes/historiques. Réutiliser les lecteurs réels dans leur portée d’audit, jamais comme preuve de règles serveur complètes. Aliases :2cas Caitlyn/Pantheon,47déclarations partagées/63fichiers,5groupes multivalués ;12déclarations non résolues et LuaName vide de Talon ne prouvent pas13assets absents. Descriptions natives Ezreal/Talon non autorité mécanique. Garder chaque candidat,ne pas choisir par premier chemin. V532publié/audité,ne pas republier :122parents/854dépendances/145questions enfants+122questions parent import/rendu ouverts. Modèles/rig/mips/matériaux et rendu non acceptés ;V531copies1347déjà exactes,ne pas refaire. Goal actif.
