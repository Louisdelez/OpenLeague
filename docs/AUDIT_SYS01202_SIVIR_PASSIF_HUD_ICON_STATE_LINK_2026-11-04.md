# SYS-01.2-02 — Sivir : Fleet of Foot et HUD, V1273

4 novembre 2026. Unité `AUD-SYS-01.2-02-SIVIR-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Sivir-PASSIF-PRESENTATION-HUD`, `OLF-2f439c1b-6c73-582b-a866-eaa997902017` : relier icône, texte et bonus de vitesse aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false ; dépendance NETWORK et inconnue `OLU-540f73da-0ffe-5053-8e42-340df2d1a029` ouvertes. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/D06-CH-Sivir consultés, sans satisfaction revendiquée. Parent PRESENTATION, QWER, passif de R et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/sivir-passive-fleet_of_foot-links-v630.json`, 2624478 octets, SHA `8476b556195741c2f7dd87e559224fafa4e62b7d735b1753b3f5b468126906ef`, UTC documentaire 2026-10-26T18:03:13.636724+00:00, sans attribution à l’heure d’exécution.

HUD enregistré : définition/CharScript et un catalogue. SOURCE : 58 relations, 52 identités, six sites/trois fichiers. V630 : 52 membres/156 associations, 28 sites/13 fichiers ; union 15 fichiers/34 ancres. Aucun ID SOURCE supplémentaire ; registres gelés conservés. Métadonnées réutilisées : 20 INIBIN, 19 Lua, 11 preloads, DDF et font, sans nouvelle lecture native.

Définition : Passive1LuaName=SivirPassive, icône Sivir_Passive.dds, vitesse335, AD52.0400009, PV515.7600098, mana284. PARType absent. Ancienne esquive en mouvement, valeurs15/20/25% et niveaux1/6/11/16 conservés, sans adoption comme progression de Fleet of Foot.

Font2654 : toucher un champion ennemi par attaque de base ou capacité donne f1 vitesse pendant deux secondes. Font2655 décrit l’état accéléré ; description4279 moins précise. Montant f1, progression, éligibilité, ordre et rafraîchissement inconnus ; aucun déficit numérique historique précis déduit. Sept liens BuffData : six résolutions et une clé exacte non résolue, game_buff_tooltip_SivirRPassiveBuff, sans alias automatique.

SivirPassive et PassiveSpeed déclarent la même icône. Passive persistant/non-dispellable ; Speed référence Sivir_Base_passivehaste.troy attaché à spine. Ces métadonnées ne prouvent pas callback, lifecycle ou rendu. RPassive déclare également BuffName=SivirPassive avec icône Sprint ; RPassiveBuff/Marker utilisent Deadeye. Homonymie non fusionnée avec Fleet of Foot.

CharScript et DDF à la racine, quatre candidats alternatifs absents sans manque global déduit. CharScript vide, aucun callback exécuté. Trois limites NEWTABLE : R/WAttack/WAttackBounce ; constantes non promues en globals. DDF28 lignes : SpiralBlade bonusAD×1, SivirQ AD×Effect4, SivirW AD×Effect6/7 ; aucune formule du f1 passif. On The Hunt et Spell Shield avec espaces, alias historiques et noms sélectionnés restent distincts.

26 références communautaires : Q par cônes/deux passes, W chaîne partielle/reset et TODO cooldown, E/R ajout de buffs sans qualification complète. Ces règles ne prouvent ni projectile natif, ni blocage/remboursement, ni déclenchement du passif ; aucun moteur C# exécuté.

Un DDS nécessaire : `DATA/Characters/Sivir/HUD/Icons2D/Sivir_Passive.dds`, 2176 octets, 64×64 DXT1/mip brut0, SHA `6ca51591da1a726b47c9fd6508f2a6395cb6a03f47299eb904ccbd892a52a1a6`. Manifeste0.0.1.7/membre0.0.0.183, taille/MD5 concordants. Sélection E avant une lecture/stat SOURCE ; aucun DDS Sprint/Deadeye/particule lu. Lookup/provider/pixels ouverts ; font miroir inchangé, témoin Ahri réutilisé.

Ressource courante Mana : source_sha256 identifie le StatsJSON communautaire 6347 octets/SHA `9201a48fa8705d6b13c51adbba19764ba75bd59e01c227bf85cb04e33e684a91`, distinct de l’INIBIN 2441 octets/SHA `9ede15c3fe734de6edbe94c2e7fc01b8e88429a192e2af662c6b114d321b8512` (`resource_provenance.json`). PARType absent n’est pas une déclaration native Mana.

## 3. Consommateurs actuels

34 ancres, 16 entrées communes et 28 fichiers code/configuration vérifiés. Aucun producteur nommé Sivir/Fleet of Foot dans les Rust sélectionnés : recherche bornée. Movement.rs compose base+objet, effets existants, slows et softcaps reconstruits ; progression exporte cette vitesse. Attacks.rs dispatch les projectiles ordinaires ; aucune branche du passif trouvée sur ces routes.

HUD natif sélectionné : santé/Mana, rangs et délais génériques. Ces chemins n’établissent pas icône/texte/f1, indicateur du bonus ni présentation de la vitesse spécifique au passif. Absence visuelle globale non déduite d’une recherche statique.

## 4. Attendu et observé

Attendu : bonus sourcé après impact admissible, vitesse effective et présentation cohérentes. V630 conservé : profils base/Bottes1001+25 vitesse, 12 projectiles/impacts sur Annie, 54 refus, six trajets sans reprise et deux ordres de marche mesurée. Un achat Bottes, aucune vente/rachat.

Vitesse effective/statistique335 ou360 inchangée sur 416 observations pendant les attaques et 244 après impact. Ce sont des observations de vitesse de déplacement, pas de vitesse d’attaque. Dégâts43.6503906 ordinaires recalculés, tolérance0.002. Aucun bonus supplémentaire observé ; valeur native exacte inconnue.

Deux marches de30 pas : coordonnées avant/après et sommes recalculées, 334.9951171875 et360 unités ; écart flottant conservé, tolérance0.01 sur une seconde. Arrêt après30ticks et attente stationnaire vérifiés. Les fenêtres61ticks couvrent plus de deux secondes, mais aucun bonus produit : expiration/rafraîchissement non qualifiés. Aucun sort Sivir accepté ; branche capacité non exercée.

Refus par flags de snapshot inchangé ; paires PVcible adjacentes sortantes absentes, soin non qualifié, aucune garde NPC universelle. Historique15 fichiers/10692558 octets, 13 empreintes anciennes concordantes/deux identités nouvelles, JSON brut RUN égal au relevé. Binaire 6118400 octets/SHA `e09998b4275bdaa0fa4ea0c2b818062c68b7576cc38a397429a0b77816b8dcd3` inerte, BUILD/RUN0.

Ancien échec de découverte « progressivir.rs » conservé dans les preuves antérieures : substitution trop large corrigée, sans modification produit ni nouveau diagnostic ici. Contrôles59/59, cohérence57/57 séparée du même agent ; productions journalisées actuelles sorties0. Aucun nouveau build/jeu/VM/REA/rendu/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Bonus non observé après attaques admissibles dans ces cas. f1/progression, catégories de cibles, dégâts nuls/boucliers, projectiles/rebonds/retourQ, ordre/softcaps, renouvellement/cumul/expiration, lifecycle, providers, traductions, transport et pixels restent ouverts. V564/Nami et autres clauses conservés.

## 6. Corrections et reprise

Réutiliser SOURCE/SIMULATION/NETWORK/HUD. `COR-SIVIR-FLEET-POLICY-01` : qualifier f1, progression, éligibilité, composition, rafraîchissement et lifecycle. Fin : contrat historique sourcé, sans importer esquive ou passif de R.

`COR-SIVIR-FLEET-ONHIT-MOVEMENT-01` : produire le bonus après impact admissible. Fin : attaques/capacités, cibles autorisées/refusées, objets, frontières temporelles, renouvellement, mouvement effectif, mort/réapparition et absence de double application vérifiés selon politique qualifiée ; conserver le contrôle Bottes.

`COR-SIVIR-FLEET-HUD-BINDINGS-01` : relier icône/texte/f1 et état de vitesse autoritaire. Fin : transitions, séparation RPassive, transport et pixels observés. Reprendre sur artefact serveur/mapping/callsite nouveau, dérive ou autorisation fonctionnelle ; aucun correctif produit ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_sivir_passive_hud_20261104` : evidence_review/coherence_review, DDS/histoire, resource_provenance.json, phase_package_prerequisites.json et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement, sauvegardes exactes/sept protégés contrôlés. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
