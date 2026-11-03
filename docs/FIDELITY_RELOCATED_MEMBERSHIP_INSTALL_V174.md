# SYS-01.2-02 — lecteur RADS déplacé installé

Installé : tools/project-plan/rads_reference_membership_relocated.py. C’est un successeur explicitement nommé ; le module historique rads_reference_membership.py, les catalogues et leurs chemins E restent inchangés. Les consommateurs existants qui importent l’ancien module ne sont pas déclarés migrés. Les liens historiques ne sont pas réaffectés silencieusement.

Le successeur vérifie les deux copies, les racines déclarées et le chemin relatif avant d’accepter une référence historique déplacée. Le même contrôle est appliqué aux manifestes et aux alternatives récupérées. Son défaut --root dérive du répertoire d’installation. La version initiale et son empreinte sont conservées dans revision174/INSTALLATION.json et installed_before_alternative_fix.py ; les reçus finaux identifient le code après ajustement des alternatives.

Huit contrôles passent sur le module installé, ainsi que la lecture des43 fichiers vides (2 membres exacts,4 non listés,37 hors périmètre des deux projets du jeu) et des2 alternatives récupérées exactes. Le mode CLI parcourant tout le catalogue n’a pas été exécuté. Aucune précédence runtime ni intentionnalité du vide n’est déduite.

Preuves : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision174/RELOCATED_MEMBERSHIP_QUALIFICATION.json et RECOVERED_ALTERNATIVES_VERIFIED.json. Scripts de qualification et installation dans le même répertoire.

Suite : enregistrer ce nouveau consommateur et les associations exactes aux tâches de fichiers vides relevant des manifestes du jeu ; vérifier les fiches/copies du plan. Auditer séparément les importateurs historiques et les37 fichiers hors périmètre. Graphe et bases du plan non modifiés par cette installation. Objectif complet toujours ouvert.
