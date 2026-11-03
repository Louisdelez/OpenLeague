# SYS-01.2-02 — affectation du fournisseur natif

Recherche qualifiée : trois régions alignées (deux préfixes et une fonction complète), onze ancres et quatre cas de branchement originaux exécutés en mémoire isolée. Binaire League of Legends.exe SHA256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862.

568E20 stocke le numéro de skin reçu dans +1C et le résultat de 90AD00 dans +20. 90AD00 renvoie le fournisseur mis en cache ou appelle 90B520 en cas d’absence. Les gardes rejettent un fournisseur nul ou un retour faux du slot virtuel +30. Les quatre cas atteignent les destinations attendues ; aucun appel ni accès fichier n’a été exécuté dans ces fragments.

569210 transmet +20 à 566B90 puis le même objet à 6F67E0. La création 90B520 et l’identité effective du fournisseur, les arguments de l’instance historique, le chargement CSV et le consommateur Rust restent ouverts.

Preuve détaillée : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision167/CHARACTER_PROVIDER_BINDING.json. Script : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/qualify_character_provider_v167.py.

Cette recherche n’est pas encore intégrée aux fiches du registre ni aux bases du plan. Prochaine action : qualifier 90B520 et sa relation avec le fournisseur V166, puis intégrer les liens précis. Aucune tâche clôturée. Les fenêtres de reconnaissance non alignées ne servent pas de preuve ; seules les régions alignées du reçu sont qualifiées.

## 2026-11-02 — SYS-01.2-02, appel de production du PackageProvider

### Lot clos : présence d’un consommateur courant

Critère de fin de ce lot : distinguer les déclarations, l’implémentation, les tests et un appel de production à `PackageProvider` / `Catalog::source_from_package`. Résultat observé : aucun appel de production dans `crates/client/src`; les seules constructions et invocations sont dans `relic_package_provider_tests.rs`.

Preuve de recherche ciblée : `rg -n "PackageProvider::prepared|source_from_package|PackageProvider" F:\OpenLeague\crates\client\src`. Le résultat contient les déclarations et l’implémentation (`relic_package_provider.rs:6,42-89`; `relic_recovered_catalog.rs:68-75`) et les appels de test (`relic_package_provider_tests.rs:16-19,66,76-78`), sans autre appelant.

Les modules sont déclarés dans `main.rs:41-46` avec l’intégration acteur ordinaire explicitement en attente. Le plugin Ring est enregistré à `main.rs:697`; le chemin actif `tt_well_ring_live.rs:12-13,216-224` fournit deux textures par `include_bytes!` puis `Source::request` / `Bindings::acquire`, sans appeler le PackageProvider.

Les tests présents couvrent un chemin nominal (`relic_package_provider_tests.rs:22-48`, puis le chargement du sous-ensemble à `51-75`) et trois refus de `source_from_package` à `76-78`. Ils n’ont pas été exécutés dans ce lot. Aucun build, lancement, rendu ou accès aux ressources originales n’a été effectué.

Preuves antérieures réutilisées : `docs/FIDELITY_CHOGATH_PROVIDER_GRAPH_V166.md`, `docs/FIDELITY_PROVIDER_FACTORY_GRAPH_V168.md` et les conclusions provider déjà conservées dans `docs/resume_checkpoint.json`. Les fixtures et tests ne prouvent pas une route de jeu montée.

### Portée et reprise

Audit statique du critère « existe-t-il un appelant de production courant ? » : clos, réponse négative. Fonctionnalité PackageProvider intégrée à un acteur : non terminée. `SYS-01.2-02` et le goal restent ouverts; aucun statut de registre n’est changé.

Restent inconnus : la source native exacte de montage, l’ordre de providers réellement construit, le choix d’un acteur ordinaire, le chargement via les INI fusionnés et le rendu effectif. Reprendre ce sous-sujet uniquement sur une nouvelle preuve de montage/appel de production ou une trace native acteur → provider → ressource. Sans cette piste, sélectionner une autre relation exigence-source-consommateur requise et non encore auditée; ne pas répéter ce recensement.