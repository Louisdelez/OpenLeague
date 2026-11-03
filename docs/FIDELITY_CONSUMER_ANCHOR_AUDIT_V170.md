# SYS-01.2-02 — audit actuel des consommateurs V170

Les 1778 ancres enregistrées sont présentes aux lignes annoncées dans427 fichiers. Chaque fichier lu possède une empreinte dans le reçu ; aucun déplacement ou texte absent n’a été constaté. Les chemins relatifs sont résolus sous F:/OpenLeague et les chemins externes absolus sont conservés. Cette vérification couvre la présence du texte, pas la validité sémantique, l’exécution ni la fidélité de chaque fonctionnalité.

88 tâches ne référencent que des rôles plan/local-contract :86 tâches EMPTY de classification/résolution, SYS-01.2-01 et SYS-03.4-07. SYS-01.2-01 possède un consommateur local explicite dans fidelity_ids.py:63 ; l’absence d’équivalent natif est attendue pour ce contrat d’identifiants et ne signifie pas une implémentation manquante. Les86 tâches EMPTY et le candidat d’archives nécessitent une qualification adaptée à leur portée.1891 tâches déclarent explicitement une frontière d’entrée sans consommateur fonctionnel identifié.

La première commande d’exploration a supposé à tort que current_consumers contenait des objets ; elle a échoué sans mutation. Le schéma réel contient des identifiants, ensuite résolus contre le registre des consommateurs. L’audit complet a été exécuté avec ce schéma correct.

Preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision170/CURRENT_CONSUMER_ANCHOR_AUDIT.json et CONSUMER_SCOPE_TRIAGE.json. Script : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/audit_consumer_anchors_v170.py.

Aucune fiche, base du plan ou état manuel modifié par cet audit. Aucune exigence clôturée. Suite : confronter les86 tâches EMPTY aux outils actuels de classification/réparation, puis examiner les1891 frontières selon leurs critères propres. Conserver les inconnues de provenance et de comportement historique.
