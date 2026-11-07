# SYS-01.2-02 — Soraka : Salvation et HUD, V1276

4 novembre 2026. Unité `AUD-SYS-01.2-02-SORAKA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Soraka-PASSIF-PRESENTATION-HUD`, `OLF-36617279-2da9-5d74-88b9-b0cb7e49b010` : relier bonus conditionnel, direction, icônes et textes aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false ; dépendance NETWORK et inconnue `OLU-4708397c-41bc-5962-bf2c-dcd103191562` ouvertes. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/D06-CH-Soraka consultés, sans satisfaction revendiquée. Parent PRESENTATION, QWER et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/soraka-passive-salvation-links-v633.json`, 2668660 octets, SHA `fe82f93e26d1d9ba5c0f13b6f3248e10a0d9fd1f3bea9b9e0188f21f19be4491`, UTC documentaire 2026-10-26T18:59:29.252876+00:00, sans attribution à l’heure d’exécution.

HUD enregistré : définition/CharScript et un catalogue. SOURCE : 79 relations, 74 identités, six sites/trois fichiers. V633 : 74 membres/222 associations, 29 sites/14 fichiers ; union 16 fichiers/35 ancres. Aucun ID SOURCE supplémentaire ; registres gelés conservés. Métadonnées réutilisées : 18 INIBIN, 29 Lua, 25 preloads, DDF et font, sans nouvelle lecture native.

Définition : Passive1LuaName="Consecration Self", icône Soraka_Passive.dds, vitesse325. Ancienne description Starcall/Infuse/Astral Blessing et niveaux8/15 non adoptés comme politique actuelle. PARType absent. CharScript/DDF à la racine ; quatre candidats alternatifs absents sans manque global déduit.

`Consecration Self.inibin` avec espace est déjà recensé ; identité conservée. Font1792, game_buff_tooltip_Consecration_Self : Salvation donne 70% de vitesse bonus en allant vers un champion allié sous40% de vie, dans2500 unités. Texte SorakaPassive2684 et description4282 moins précis, sans seuils inventés. Cinq liens BuffData exactement résolus, sans alias automatique.

Aura déclare Soraka_Consecration.dds, persistance/non-dispellable ; Marker/Orient n’indiquent qu’une attache root, pas un consommateur d’orientation. Falloff vide ne fournit pas l’expiration. 29 Lua sans callback exécuté, 15 limites NEWTABLE. Recall/Syndra/Draven et StarBuff/Jayce restent étrangers. DDF16 lignes : seul lien InfuseWrapper mana×0.05, distinct de Salvation.

22 références communautaires : QHaste sans producteur retrouvé dans les scripts sélectionnés ; Qcentre/soin W non démontrés ; garde de paiement W distincte du refus natif sous5% ; E ciblé/silence/mana allié divergent d’Equinox ; R sans purge ni bonus sous40% démontrés. Aucun moteur C# exécuté, aucune absence globale déduite.

DDS actuel : `DATA/Characters/Soraka/HUD/Icons2D/Soraka_Passive.dds`, 2176 octets, 64×64 DXT1/mip brut0, SHA `718bc762c40bcc03096eef65de57c2e6ee863a444fff8a836f88a45ffbcdee99`, manifeste0.0.1.7/membre0.0.0.251, taille/MD5 concordants. Sélection E avant une lecture/stat SOURCE ; font miroir inchangé, témoin Ahri réutilisé.

Ancienne icône Soraka_Consecration : quatre occurrences du manifeste sous OdinMinionGraveyardPortal, OdinMinionSpawnPortal, OdinQuestIndicator et OriannaBall/info. Aucun candidat dans Soraka/HUD/Icons2D ou les Icons2D partagés. Ces occurrences étrangères ne sont pas lues ; provider/alias ouvert, sans conclure à une corruption ou absence mondiale. Icône actuelle et ancien nom ne sont pas fusionnés.

Ressource courante Mana : source_sha256 identifie le StatsJSON communautaire 5396 octets/SHA `50c3a8e5387497fbb35afbfda1f8efb602c673df0085bd4d9e7c425d1fda6136`, distinct de l’INIBIN 1899 octets/SHA `c6d7f0e3f550c0faa4d3616206bfc0d9f39cd6fdfd0ed580d7971ca011571635` (`resource_provenance.json`). PARType absent n’est pas une déclaration native Mana.

## 3. Consommateurs actuels

35 ancres, 16 entrées communes et 29 fichiers code/configuration vérifiés. Aucun producteur nommé Soraka/Salvation/Consecration dans les Rust sélectionnés : recherche bornée. Movement.rs compose base+objet et effets existants, sans branche Salvation identifiée ; progression exporte cette vitesse. Garen possède une régénération existante ; les ratios de vie réellement enregistrés sont contrôlés.

Snapshots exposent positions, équipes et pools ; HUD sélectionné affiche santé/Mana et délais génériques. Ces routes ne prouvent pas marker, orientation, icône ou activation de Salvation. Absence visuelle globale non déduite.

## 4. Attendu et observé

Attendu : bonus conditionnel sourcé, déplacement et HUD cohérents. V633 conservé : quatre profils base/Bottes×allié sain/blessé, 26 projectiles Annie sur Garen, 112 refus, douze arrivées, huit marches et240ticks, deux achats Bottes ; aucune vente/rachat ni injection d’état.

Distances sur30ticks, vers/à l’opposé :324.990234375 sans objet,349.9951171875 avec Bottes ; coordonnées/sommes recalculées. Vitesse effective/statistique325/350, identique sain/blessé et vers/opposé. Les 240 trames revalident pas, continuité, cosinus, distance et ratios ; 60 trames vers l’allié blessé ont cosinus>0.99, vie≈21.92–22.42%, distance<801, donc conditions textuelles nominales exercées sans bonus observé. L’angle natif exact n’est pas assimilé au seuil de ce contrôle géométrique.

Les 26 impacts conservent PV avant/après, ratio et projectile réel ; dommage physique attendu/observé cohérent avec l’armure. Chaque contribution de régénération n’est pas recalculée indépendamment. Refus par flags de snapshot inchangé, aucune garde NPC universelle. Sorts Soraka refusés, mais leur acceptation n’est pas un prérequis de ce déclencheur de mouvement. Limites40%,2500, angles/visibilité/choix d’allié et ordre des softcaps non qualifiés ; aucune vitesse historique finale inventée.

Historique22 fichiers/11492186 octets, 20 empreintes anciennes concordantes/deux identités nouvelles. Premier BUILD privé101/E0382 conservé : snapshot emprunté après déplacement de s, aucun RUN initial. Projet owned corrige l’ordre de capture ; BUILD/RUN0, JSON brut égal au relevé. Binaire 6095872 octets/SHA `62390fa18045f8ec1caacc151ac04ae02d754c334accf40f5cd0168c1c470919` inerte.

Contrôles96/96, cohérence89/89 séparée du même agent. Préparation actuelle : inventory01 sortie1 sur déclaration sans candidat admis ; inventory02 sortie1 dans le résumé après écriture des artefacts. Originaux/journaux conservés, inventory03 vérifie les sorties complètes sans reparsing du manifeste ni nouvelle lecture native. Autres productions sorties0. Aucun nouveau build/jeu/VM/REA/rendu/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Bonus conditionnel non observé sur le cas nominal. Provider, alias ancien/current, direction/angle, seuil/range exacts, sélection/visibilité, activation/retrait, softcaps, interactions, lifecycle, HUD et transport restent ouverts. V564/Nami et autres clauses conservés.

## 6. Corrections et reprise

Réutiliser SOURCE/SIMULATION/NETWORK/HUD. `COR-SORAKA-SALVATION-POLICY-01` : qualifier direction, sélection, seuils, ordre des modificateurs et lifecycle. Fin : contrat historique sourcé, sans inventer une vitesse finale après plafonnement.

`COR-SORAKA-SALVATION-MOVEMENT-01` : produire activation/retrait conditionnels. Fin : témoins sains/blessés, vers/opposé,39.99/40/40.01%, autour2500, virages, multi-alliés, objets/slows, mort/reconnexion et frontières vérifiés selon politique qualifiée ; conserver les quatre contrôles publics.

`COR-SORAKA-SALVATION-HUD-PROVIDER-01` : qualifier provider de l’ancien nom ou ressource exacte, puis relier marker/icône/texte à l’état autoritaire. Fin : preuve d’alias/sélection sans emprunt par basename, transitions, transport et pixels observés. Reprendre sur nouveau mapping/callsite/artefact exact, dérive ou autorisation fonctionnelle ; aucun correctif produit ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_soraka_passive_hud_20261104` : evidence_review/coherence_review, DDS/histoire, resource_provenance.json, phase_package_prerequisites.json, qualifications d’inventaire et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement, sauvegardes exactes/sept protégés contrôlés. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
