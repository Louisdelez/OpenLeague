# SYS-01.2-02 — dépendances Cargo observées (V193)

Deux artefacts Cargo réels sont lus : liste de liaison du client et dépendances directes du binaire de tests. Leurs portées restent distinctes. Les ressources assets/data sont normalisées, dédupliquées, relues et comparées au manifeste de distribution courant.

- client_link_dependency_list : {'resources': 189, 'declared': 131, 'undeclared': 58, 'missing': 0, 'modified_after_dep_info': 0}
- client_test_direct_dependencies : {'resources': 463, 'declared': 212, 'undeclared': 251, 'missing': 0, 'modified_after_dep_info': 0}

Trois refus du lecteur passent : séparateur absent, liste vide, échappement de nom non pris en charge. Les empreintes des artefacts et fingerprints Cargo sont conservées. Aucune compilation ni exécution du client effectuée. Les dates postérieures à dep-info signalent une limite, pas une preuve suffisante de corruption.

Cette preuve affine le précédent recensement lexical de1428includes ; elle ne le remplace pas et ne constitue pas une fermeture transitive complète des ressources chargées dynamiquement. Les ressources non déclarées doivent être qualifiées individuellement avant modification des packs.

Preuve : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision193/CARGO_RESOURCE_DEPENDENCIES.json. Script : revision193_cargo_resources.py dans le répertoire parent. Suite : examiner les ressources non déclarées propres à la liste de liaison, relier le lecteur et ses limites à SYS02.5-04. Aucun statut ou contenu de pack modifié.
