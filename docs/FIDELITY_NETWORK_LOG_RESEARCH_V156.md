# SYS-01.2-02 — Recherche des journaux réseau natifs (V156)

## Résultat vérifié

La table virtuelle primaire 0x10AFE8C, installée par le constructeur 0x72A3B0, donne la méthode 0x72A780 au déplacement +0xC. Le chemin netlog préparé par le caller 0x591484 traverse 0x7297E0, 0x8F68D0 et 0x8FB650 jusqu’à 0x8F8F10.

Le dernier composant transmet le chemin et les chaînes natives `wc` puis `ac` au wrapper 0xC9951E (qui appelle 0xC9945A avec le paramètre 0x40). Le second appel dépend du résultat non nul du premier. Le drapeau d’initialisation ne devient vrai que si le second résultat est non nul. En amont, 0x8FB650 vérifie une option, un résultat de service et un chemin non nul.

## Vérifications réellement exécutées

Analyse PE et désassemblage statique uniquement. SHA-256 du binaire comparé à la preuve antérieure ; dix régions relues contre ses octets ; onze ancres vérifiées. Un cas nominal et trois refus de cible/modes altérés réussis. Le script et les empreintes sont dans NETWORK_LOG_CHAIN_CHECKPOINT.json, dossier revision156 du travail F:.

## Limites et suite

Aucun code original ni client graphique exécuté. Les modes sont des octets observés ; tous les comportements CRT et appels auxiliaires ne sont pas nouvellement qualifiés. Cette chaîne ne prouve ni la cause historique des 34 journaux vides, ni l’équivalence d’un producteur Rust actuel. Ne pas reconstruire des données fictives pour remplir ces journaux. Relier ensuite les tâches exactes à leur consommateur actuel et traiter les neuf autres fichiers vides séparément. Aucune tâche clôturée et aucun état manuel du plan changé. V155 reste la dernière intégration au registre.

L’observation Git de cette reprise a renvoyé « must be run in a work tree » depuis F:, malgré safe.directory ; aucune opération Git de mutation effectuée. Ce problème d’observation ne remet pas en cause les vérifications directes des fichiers ci-dessus.

## Consommateurs actuels du plan — contrôle supplémentaire

86 tâches CLASSIFY/RESOLVE portant sur 43 fichiers ont été exercées via les fonctions réelles `instructions.references` et `fidelity_ids.for_task`. Chaque référence pointe vers le fichier natif existant ; chaque identité correspond au registre et reste stable après changement du numéro de scan. Les six entrées invalides (hors racine, vide ou absente) sont refusées. Les prérequis de chaque lot sont conservés dans le reçu.

La recherche littérale insensible à la casse de `netlog|Network Logs|Localization_Errors|EventLookupTable|Light\.dat` dans 1192 fichiers Rust ne produit aucun résultat. Cela ne prouve pas l’absence de consommateurs sous d’autres noms. Le module `native_game_cfg_text` sait traiter des entrées vides, mais aucune liaison de ce module à `RADS/system/user.cfg` n’est établie : ne pas lui attribuer cette ressource par ressemblance.

Les noms de certains netlogs portent une date de 2016. Leur présence dans la copie du client ne prouve pas leur appartenance à la livraison de novembre 2014 ni leur provenance d’exécution. Les neuf autres fichiers restent à qualifier séparément : first_time, trois S_OK, config.prop, Localization_Errors.txt, CSV Skin02 de Chogath, map11/Light.dat et user.cfg.

Reçu : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision156/EMPTY_CURRENT_CONSUMERS_CHECKPOINT.json. Aucun consommateur de jeu ni statut de tâche ajouté au registre sur la seule base de ces contrôles du plan.

## Lecteurs des autres fichiers — recherche native

Light.dat est associé au mode rt et au format `%d %d %d %d %d %d %d`. Les branches d’ouverture nulle, de fin de lecture et d’instanciation par ligne sont distinctes. Deux régions et neuf ancres sont vérifiées. Le sélecteur SoundBanks/EventLookupTable est identifié ; son association effective au CSV Chogath Skin02 reste ouverte.

Cinq binaires RADS/patcher ont été recherchés et empreintés. Le candidat first_time du patcher appelle GetFileAttributesA et examine l’échec ainsi que le bit répertoire ; le callee suivant et la provenance du fichier restent à suivre. Les premières extractions RADS comportaient des départs au milieu d’instructions : elles sont conservées comme candidates non fiables ; utiliser les régions réalignées et leurs limites explicites.

Preuves : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision156\OTHER_EMPTY_RESEARCH_PROGRESS.json. Aucun de ces constats ne clôture la classification intentionnelle ou une réparation. Prochaine étape : suivre le callee 5CA3D0 du patcher et les consommateurs S_OK/user.cfg, puis qualifier les liens précis sans substituer une recherche de nom à un consommateur prouvé.

## first_time — création conditionnelle précisée

Le caller natif teste les attributs du chemin (GetFileAttributesA), puis construit un flux lorsque la cible est absente ou est un répertoire. Le constructeur transmet le mode2 ; la table du patcher sélectionne l’index1 et la chaîne large `w` à 0x798998. Le caller détruit immédiatement le flux, sans écriture de contenu entre construction et destruction. Sept régions relues contre le SHA-256 du patcher.

Ce comportement permet une création sans contenu si l’ouverture réussit. Il ne prouve pas l’origine du fichier RADS/first_time archivé, la résolution complète de son chemin ni l’exécution effective sur une installation historique. En cas d’échec, le constructeur marque le flux en erreur ; le retour du caller ne doit pas être assimilé à une création réussie. Aucun processus natif exécuté, aucun fichier d’origine modifié.

Reçu : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision156\FIRST_TIME_CREATION_CHECKPOINT.json. Suite : suivre le chemin complet et relier ce rôle aux tâches EMPTY-032, puis examiner les consommateurs S_OK et user.cfg. Le registre et les cases restent inchangés tant que ces liens ne sont pas qualifiés.

## S_OK — filtre de noms du noyau RADS

S_OK est comparé comme nom connu par le noyau RADS via _stricmp, aux côtés de releasemanifest. La branche journalise Validated known file puis distingue S_OK. Trois instructions exactes, empreintes de régions/binaire et import CRT vérifiés. Ce filtre ne valide pas le contenu ni l’intégrité de la release ; cycle de création/suppression et consommateur Rust restent ouverts. Aucun code natif exécuté.

Preuve : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision156\S_OK_NAME_FILTER_CHECKPOINT.json.

## config.prop — fichier facultatif et branche vide

data/config.prop est explicitement facultatif dans le lecteur natif ParseConfigFile. Une taille nulle provoque une sortie avant lecture et parsing ; mode rb. Quatre régions, sept ancres et cinq cas (quatre refus) vérifiés. Les occurrences user.cfg actuelles sont des tests/adaptateurs ; elles ne prouvent pas un consommateur RADS. Aucun processus natif exécuté ni statut de tâche changé.

Preuve : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision156\CONFIG_PROP_OPTIONAL_CHECKPOINT.json.

## user.cfg — lecteur RADS distinct

Le lecteur natif RADS SettingsFile::Load construit rads/system/user.cfg et possède un repli /system/ depuis son entrée de constructeur. Il traite les lignes et le séparateur égal, avec sorties sur états du flux et lignes invalides. Trois régions et neuf ancres vérifiées. Ce lecteur est distinct du parseur Game.cfg actuel ; EOF exact, racine de repli et intégration Rust ordinaire restent ouverts. Aucun code natif exécuté.

Preuve : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision156\USER_CFG_READER_CHECKPOINT.json.

## user.cfg — fragment EOF exécuté

Cinq cas du fragment natif 47D450..47D4FB ont été exécutés en mémoire isolée : EOF avant extraction donne3, après extraction1, états préexistants conservés7/5 ; une valeur non EOF continue avec0. Entrées de registres explicites, sans appel externe ni accès aux fichiers. Le setter de flux, le backend de lecture, le caller complet et le consommateur Rust restent non exécutés. Cette preuve ne valide pas le patcher complet.

Preuve : F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision156\USER_CFG_EOF_FRAGMENT_EXECUTION.json.

## Intégration aux tâches et au texte copiable

86 tâches EMPTY et SYS-01.2-02 enrichies avec les preuves natives exactes et leurs limites. Les deux bases locales ont été relues via Store.task et Store.copy_text :87 fiches/copies par base conformes ;42606 états manuels et historique conservés, intégrité SQLite ok. Reçu docs/fidelity_empty_research_task_links_v156.json. Cette intégration documente les recherches ; elle ne remplace pas les liens sémantiques du graphe, ne clôture pas les tâches et ne démontre pas les consommateurs Rust ordinaires. Suite : qualifier et enregistrer les rôles précis restants, puis poursuivre LOCALE/REF et le candidat archive non identifié.
