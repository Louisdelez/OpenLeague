## Application Windows OpenLeague Plan — 20 octobre 2026

Demande active terminée : porter le plan HTML et sa base dans une application Rust/Tauri et créer son icône avec ImageGen. Application 1.0.0 installée dans C:\Users\loicd\AppData\Local\Programs\OpenLeague Plan\OpenLeague Plan.exe, raccourci C:\Users\loicd\Desktop\OpenLeague Plan.lnk. Fenêtre native ouverte et observée. Sources : tools/project-plan-desktop/ ; workspace Cargo indépendant du moteur et du launcher.

Backend Rust/rusqlite et UI embarqués, sans serveur Python pour l’application. La configuration %LOCALAPPDATA%/OpenLeague Plan/connection.json lie volontairement la base originale runtime/project-plan/plan.sqlite3 pour partager exactement les coches, notes et historique avec le site. Une graine SQLite compressée cohérente est embarquée pour une première installation sans base configurée ; le lancement sur un profil vierge n’a pas été exécuté. Une base explicitement liée mais absente n’est jamais remplacée par cette graine.

Vérifications nouvelles : 10 tests Rust fonctionnels réussis ; build Windows release final réussi ; contrôle par Rust des 42 214 tâches uniques et 2 770 fiches sur toutes les pages ; 42 606 états conservés avec done/notes identiques. La seule révision modifiée par la recette UI est SYS-01.1-01 (+2, coche puis décoche). Persistance observée après fermeture/réouverture ; copie native signalée réussie et contenu de consigne observé, sans relecture indépendante du presse-papiers. Export réellement enregistré via dialogue Windows : 42 214 tâches actives et 392 archives. Dossier Documents vérifié dans le dialogue final, puis annulation. Les notes sont testées par Rust sur une base temporaire, sans édition des notes utilisateur dans la recette native.

Icône intégrée : PNG/ICO dérivés par conversion de format de l’image ImageGen originale conservée. Consigne exacte : tools/project-plan-desktop/ICON.md. SHA-256 de l’exécutable final : E2289B1E68A0335988275E9752A5590351E07B6F3A49D7A3A6DBD1A132E5290B ; 31738880 octets.

Historique des essais : premier résolveur Cargo incompatible entre familles Tauri, corrigé par versions explicites et verrouillées ; première fixture refusée car usize n’implémente pas ToSql, corrigée en i64. Les journaux restent conservés. L’export ouvrait initialement le dossier du processus appelant ; la version finale utilise le dossier Documents Windows.

Preuves : E:/mapslol3v3/Plan_Tauri_2026-10-20/FINAL_VERIFICATION.json, tests-final.log, release-final.log, installed.json, catalog-verification.json, native-export.json et application.png. Sauvegarde cohérente avant travail : database-before.sqlite3. Git : main, HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, modifications du jeu préexistantes conservées ; aucun staging, commit ou changement du moteur. Aucun test du jeu réexécuté et aucun statut du Goal changé.

Prochaine action : suivre la demande utilisateur actuelle. Le plan fonctionne par le raccourci du Bureau ; ses coches restent un suivi manuel distinct des preuves d’achèvement du jeu.

## Plan détaillé et audit — 20 octobre 2026

Demande active : redécouper l’intégralité du plan en tâches précises, une fiche par champion et contenu, puis auditer et corriger le plan et ses consignes. Le résultat est installé dans le plan local http://127.0.0.1:10427/ et dans les fichiers du Bureau.

Catalogue v2 : 24 parties, 2 770 fiches, 42 214 sous-tâches. La partie 06 contient exactement les 122 champions, avec les passifs, 499 entrées de capacités, rangs et 4 267 références de clips. Fiches individuelles pour 668 apparences, 280 objets du catalogue, 296 runes, 57 maîtrises, 13 sorts invocateur ; les entrées natives supplémentaires sont classifiées séparément. Les configurations natives de cartes, unités, 115 matériaux Map10 et 19 locales candidates sont recensés sans présumer leur disponibilité historique.

Validation actuelle : 33 contrôles du catalogue entier et 14 tests de l’application passent. 9 461 états préexistants, notes et révisions conservés exactement ; 392 anciennes cases globales archivées, sans propagation de coche. UI réelle vérifiée, copie de consigne, coche persistante puis retirée, aucun débordement horizontal ou erreur console observé. Les groupes internes restent ouverts après une coche. Les anciens journaux d’essais sont conservés ; le journal final est TESTS_FINAL.log.

Références actives : docs/completion_tasks_2026-10-20.json, docs/execution_plan_A_Z.json, docs/OpenLeague_PLAN_DE_TRAVAIL_A_Z.md et docs/OpenLeague_PLAN_COMPLET_DETAILLE_A_Z.md. Audit : docs/PLAN_AUDIT_2026-10-20.md. Preuves et sauvegarde : E:/mapslol3v3/Plan_granulaire_2026-10-20/FINAL_VERIFICATION.json et preinstall/plan.sqlite3.

Git : branche main, HEAD 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca ; checkout déjà modifié, aucun commit, staging ou changement de code du jeu effectué par cette demande. Le serveur du plan reste local, sans service externe ni démarrage Windows automatique. Le Goal n’a pas été remplacé ou clôturé par cette modification.

Limites : les règles historiques encore inconnues, les branches découvertes, l’acceptation humaine et la recette du jeu restent des tâches ouvertes. Les coches manuelles sont distinctes des preuves. Les résultats de tests du jeu du 18 octobre et leurs relectures du 20 octobre restent des preuves héritées, pas de nouveaux tests exécutés ici.

Prochaine action : suivre la demande utilisateur courante ; pour la construction, choisir une sous-tâche prête de la fiche visée, respecter ses sources et prérequis, intégrer puis qualifier le résultat. L’audit source antérieur reste disponible dans docs/OpenLeague_Audit_Complet_et_Plan_A_Z_2026-10-20.md. Une nouvelle découverte doit devenir une tâche nommée avant la clôture du contenu concerné.

Pour reprendre : lire AGENTS.md et exécuter `node .ai-tools/project.mjs resume`, puis vérifier les fichiers et la demande humaine actuelle.
