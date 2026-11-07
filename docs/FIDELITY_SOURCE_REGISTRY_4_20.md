# Révision courante — configurations legacy et ambiguïtés de skins

24206sources/34ancres revérifiées,83tests réussis ;25310questions ouvertes et5508résolues avec historique. La recherche dédiée+legacy corrige5344absences mal qualifiées et relie10688tâches à668identités officielles. Les7configurationsRenekton ambiguës gardent112questions de priorité. Les autres5344questions de rôle/consommateur restent ouvertes avec le libellé d’absence corrigé ; sources et comportement ne sont pas confondus. Le sélecteur natif est copié dans le plan. Voir `FIDELITY_SKIN_CONFIGURATION_BINDINGS_4_20.md` et `docs/fidelity_registry_skin_revision_4_20.json`.

---

# Révision courante — conversion numérique et recherches de caps

24200sources avec origine/version/taille/SHA et33ancres actuelles sont revérifiées ;73tests ciblés passent. 164questions sont résolues avec historique et30542restent ouvertes. Deux questionsKarma sont résolues sous locale initiale avec les instructions originales ; une nouvelle question sur la locale effective conserve la limite. Les285snapshots de journaux utilisés ont leur identité de contenu ; leur appartenance au même build n’est pas présumée. Les recherchesAIR et les consommateurs de maxRank sont conservés, sans payload natif inventé. Les tâches02/04/05 restent partielles ; aucune fidélité du jeu ni acceptation humaine n’est déduite. Preuve : `docs/fidelity_registry_numeric_revision_4_20.json`.

---

# Révision courante — sources communautaires nommées

23943sources avec origine/version/taille/SHA et31ancres actuelles revérifiées ;42214exigences conservées.30543questions ouvertes,162résolues avec historique. Les797questions de script ont une recherche nominative supplémentaire ;680candidats Lua décodés,116absences et33ambiguïtés de nom sont conservées. Une nouvelle question explicite porte sur les templatesGarenQ/GarenQBuff divergents. Aucune qualification globale de script n’est déduite. 65tests installés passent, la politique de147résolutions originales se reproduit et quatre comparaisons numériques restent ouvertes. Preuve : `docs/fidelity_registry_semantic_revision_4_20.json`. Couverture/reprise et consignes du plan sont actualisées ; suivi manuel et preuves antérieures préservés.

---

# Révision courante du registre — 20 octobre 2026

23311fichiers avec provenance/version/taille/SHA et26points d’entrée sont fraîchement revérifiés ;42214exigences actives conservées. 30542questions ouvertes et162résolues avec historique. Les compteurs de statut sont recalculés à partir des lignes :22643associations,4contrats locaux,19567liens partiels. Le validateur refuse maintenant les compteurs périmés. Les147nouvelles résolutions reposent sur les fragments originaux exécutés en mémoire isolée et sur des liens de métadonnées nommés ; elles ne qualifient aucun gameplay. 49tests ciblés passent. Une dérive du rapportSYS02 issu de la tâche précédente a été détectée puis réconciliée avec l’ancienne copie et le reçu propre àSYS02 ; aucun fichier natif n’a changé. Sources et preuves historiques conservées. La CLI native_constructor_reference rejoue les décisions persistées. Preuve : docs/fidelity_registry_constructor_revision_4_20.json.

---

# Registre de sources, consommateurs et inconnues — LoL4.20

Référence : PUBLIC4.20.0.315, EUW/en_GB, build2014-11-17 à17:46:45 sans fuseau ni déploiement établi. DataDragon4.20.1 en_US reste un catalogue distinct.

Le registre `fidelity_requirement_trace_4_20.json` indexe les42 214exigences actives,151parents historiques et392tâches archivées. Les identités OLF sont celles de SYS-01.2-01. `fidelity_sources_4_20.json` contient23 303fichiers avec origine, version ou identité de snapshot explicite, taille et SHA256. Toutes ces tailles/empreintes ont été relues avec succès. Les186originaux AIR et9139exports de revue sont distingués et liés aux bibliothèques et manifestes de leur contrat ; un export décompilé n’est pas le SWF original. Les snapshots de code actuels incluent les modifications non commitées.

Chaque exigence a des liens typés vers ses entrées, références, consommateurs et questions.22points d’entrée actuels sont ancrés par fichier/ligne/texte/hash. Les sources liées et les modules apparentés ne prouvent pas toute la sémantique. Le lecteur native_spells est filtré sur Garen ; AatroxQ atteint actuellement un refus explicite. Un élément absent de shop_foundation atteint un refus, pas un objet générique. Le chargeur de modèle de base ne prouve pas une sélection de skin. Les types de lien `current_catalog_lookup_absent` signalent une recherche sans entrée, sans inventer une fiche présente.

SYS-01.2-02 reste partielle : il reste des consommateurs et contrats précis à résoudre, particulièrement présentation, skins, passifs, modes et services. Les lacunes ne sont ni supprimées ni transformées en réussite. Le registre des inconnues conserve30 704questions observées, dont30 689ouvertes et15résolues avec preuve/historique. Une question résolue sur une expression de tooltip n’accepte pas le gameplay correspondant. Chaque question garde exigence, recherche réellement effectuée et condition de résolution ; les recherches par métadonnées sont explicitement distinguées d’une analyse sémantique exhaustive.

SYS-01.2-03 est réalisée pour les références utilisées par ce registre : origine/version/SHA sont enregistrés et vérifiés. Une version de snapshot est une identité locale précise, pas une révision amont inventée. Le dépôt communautaire et son sous-module sont modifiés ;549scripts non suivis ne sont pas attribués au HEAD. Les détails Git et SHA de chaque fichier restent distincts. Un ancien journal de tests est une production locale versionnée par son contenu, sans version amont applicable ; ses résultats restent hérités.

SYS-01.2-06 fournit le registre exploitable des inconnues et leurs recherches/clôtures. Sa réalisation n’exige pas de déclarer les inconnues résolues. Les15résolutions gardent les anciennes questions et leurs preuves.

Le plan existant copie maintenant la trace propre à la tâche, les sources et SHA, les points d’entrée ou refus, les limites et identifiants d’inconnues. Fiche complète : `python -B tools/project-plan/requirement_trace.py --root E:/OpenLeague --task CH-Aatrox-Q-SOURCE`. Validation complète : même commande sans --task, avec --verify-files. Les données restent dans les fichiers de référence et la base SQLite partagée ; cases, notes et révisions ne sont pas acceptées par cette intégration.

39nouveaux tests installés réussissent :18trace/provenance,11lecteur,10comparaisons. Le lecteur INIBIN corrigé est recoupé avec le corps original d’un lecteur indépendant sur1267fichiers et41109valeurs numériques/vecteurs/bits ; les91458chaînes ne sont pas qualifiées sémantiquement par ce test. Le lecteur local antérieur oubliait le facteur0.1 des vecteurs compressés ; il est conservé comme preuve, pas promu comme décodeur correct.

Commandes, versions, logs, cas attendus/observés, fichiers et intégration sont dans `fidelity_registry_verification_4_20.json`. Aucun programme historique, build ou test du jeu exécuté. Aucune acceptation humaine ni complétude du jeu déduite.
