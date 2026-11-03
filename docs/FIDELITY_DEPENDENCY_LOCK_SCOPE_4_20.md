# Correction de portée — Cargo metadata sans résolution

Cette preuve complète et corrige la formulation initiale V66 « lockfiles consommés avec succès ». Les deux lockfiles réels existent et leurs octets sont inchangés. Le succès de metadata --locked --offline --no-deps recense les manifestes ; il ne démontre pas la consommation,la validité ou la cohérence du lockfile dans une résolution réelle.

Deux nouveaux petits projets locaux sans dépendances sont observés avec le même Cargo1.96.1. Le premier n’a aucun Cargo.lock avant/après ; le second conserve un Cargo.lock mal formé. Les deux commandes retournent0 et resolve=null,sans compilation. Ces contre-exemples suffisent à refuser l’inférence « succès metadata donc lockfile validé ». Ils ne prétendent pas décrire tous les modes de Cargo ou toutes les conditions d’un projet complexe.

Les sept contrôles de cette correction passent,dont six refus de données ou modes altérés. Les deux commandes du projet OpenLeague et les deux nouveaux profils ne sont pas rejoués pour reformater la preuve. Le script de qualification relit leurs sources et journaux.

Le contexte courant et les trois scopes de configuration de SYS-03.1-07 sont corrigés ; leurs formulations précédentes restent en historique. Les documents et reçus initiaux restent conservés comme preuves antérieures à cette correction. La tâche reste ouverte ; une vraie résolution verrouillée et une construction propre complète ne sont pas qualifiées. Aucun code,lockfile,asset ou état utilisateur OpenLeague modifié.

Reçu courant : docs/reference_dependency_sources/no-deps-lock-scope.json. Observations et relecture : E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision66/no-deps-lock-boundary-observation.json et qualify_no_deps_lock_scope.py.
