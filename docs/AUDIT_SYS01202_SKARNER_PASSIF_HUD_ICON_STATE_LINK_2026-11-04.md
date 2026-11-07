# SYS-01.2-02 — Skarner : Crystallizing Sting et HUD, V1274

4 novembre 2026. Unité `AUD-SYS-01.2-02-SKARNER-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Skarner-PASSIF-PRESENTATION-HUD`, `OLF-f96a5a29-8b74-5e1f-b50a-12e2507d19a9` : relier icônes, textes et états des charges aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false ; dépendance NETWORK et inconnue `OLU-d26407ad-eb65-58d9-b0ab-65cd8c18e5f3` ouvertes. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/D06-CH-Skarner consultés, sans satisfaction revendiquée. Parent PRESENTATION, QWER et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/skarner-passive-crystallizing_sting-links-v631.json`, 2850374 octets, SHA `87d8663b848ee1915fc3dc674f2c9645a308141aac2bcf2b21d2d356d96930ce`, UTC documentaire 2026-10-26T18:18:33.165673+00:00, sans attribution à l’heure d’exécution.

HUD enregistré : définition/CharScript et un catalogue. SOURCE : 74 relations, 68 identités, six sites/trois fichiers. V631 : 68 membres/204 associations, 26 sites/13 fichiers ; union 15 fichiers/32 ancres. Aucun ID SOURCE supplémentaire ; registres gelés conservés. Métadonnées réutilisées : 21 INIBIN, 28 Lua, 17 preloads, DDF et font, sans nouvelle lecture native.

Définition : Passive1LuaName=SkarnerPassive, icône Skarner_Passive.dds, PV601.2800293, mana272.2000122, AD61.1559982. PARType, Passive1Desc, Passive1 et six niveaux absents. CharScript/DDF à la racine ; quatre candidats alternatifs absents sans manque global déduit.

Font2663/4280 : sorts infligeant des dégâts appliquent Crystal Venom pendant cinq secondes, maximum trois charges ; attaque suivante à trois charges inflige f1 dégâts magiques et étourdit pendant f2 secondes. Application ensuite interdite sur cette cible pendant six secondes après l’étourdissement. Montants f1/f2, progression, éligibilité, ordre et producteurs inconnus. Les cinq secondes concernent les charges, pas la durée du stun.

Textes distincts : PassiveBuff2664, Cooldown2665, Stun2666. Treize liens BuffData, douze résolutions et une clé étrangère non résolue game_buff_tooltip_SionWPassive, sans alias. ImpaleVO déclare VarusQ ; aucune règle de Sion/Varus adoptée.

Passive déclare persistance après mort ; Cooldown/Stun utilisent la même icône. Preloads référencent les particules stack1/2/3 et de stun, sans démontrer leur production ou rendu. 28 Lua sans callback exécuté, 14 limites NEWTABLE ; CharScript/BrushCheck/ImpaleFlashLock/Resurrection vides ne prouvent ni résurrection spéciale ni Flash.

PassiveAttack SpellData.Cooldown10 n’est pas le verrou par cible6s. Q réduit son propre délai de0.5s par attaque, doublé contre champion ; R consomme des charges : règles séparées du proc d’attaque. Fracture conserve un ancien texte « prochain coup/marque », distinct du tooltip projectile/slow. DDF quatre lignes, seul lien Q bonusAD×0.8, aucune formule passive f1/f2.

26 références communautaires : Q0.5bonusAD contre DDF0.8 et dégâts mixtes non démontrés, W bouclier/vitesse délégués, E slow, R deux impacts sans drag/consommation prouvés. Aucun moteur C# exécuté ; noms de buffs non promus en comportement historique.

Deux chemins DDS nécessaires :

- `DATA/Characters/Skarner/HUD/Icons2D/Skarner_Passive.dds` : 2176 octets, membre0.0.0.249.
- `DATA/Spells/Icons2D/Skarner_Passive.dds` : 2176 octets, membre0.0.0.237.

4352 octets lus, un contenu commun, 64×64 DXT1/mip brut0, SHA `32919eee9a0ab3bf537daaf8776a34c521f6a3462211e092232de41f936f3a0c`. Manifeste0.0.1.7, tailles/MD5 concordants ; sélection E avant deux lectures/stat SOURCE. Aucun DDS Varus/particule lu. Identité des pixels ne prouve pas l’alias au chargement. Lookup/provider/rendu ouverts ; font miroir inchangé, témoin Ahri réutilisé.

Ressource courante Mana : source_sha256 identifie le StatsJSON communautaire 4418 octets/SHA `1fa0999fa45d2a3cf986ad23a1b4c599eabb7ba7d3bdf1a5b9011f6d63b1c5c7`, distinct de l’INIBIN 1636 octets/SHA `4d1b37e39d95d6ca5992af211aab7b60a8b8b4971ef6019f8a64c84b690404a9` (`resource_provenance.json`). PARType absent n’est pas une déclaration native Mana.

## 3. Consommateurs actuels

32 ancres, 16 entrées communes et 28 fichiers code/configuration vérifiés. Aucun producteur nommé Skarner/Crystallizing/CrystalVenom dans les Rust sélectionnés : recherche bornée. Routes d’attaque physique, statistiques et objets génériques conservées. Sorts refusés dans les cas observés ; aucune application native des charges amorcée.

Stuns.rs:15 expose grant_stun autoritaire, avec durée/contrôle/interruption ; ligne37 expire les états génériques. Ces routes ne deviennent pas un consommateur de Crystal Venom. HUD sélectionné : pools santé/Mana, rangs/délais et états de sorts ; aucun binding du passif établi. Absence visuelle globale non déduite d’une recherche statique.

## 4. Attendu et observé

Attendu : états0/1/2/3, consommation, stun/verrou et HUD correspondants. V631 conservé : profils base/Tome1052+20AP, 12 mêlées ordinaires, 362 ticks d’attente, 54 refus, quatre trajets sans reprise. Cinq relevés boutique et trois transactions achat/vente/rachat.

AP0/20, AD61.1559982 et armure29.3840008 ; dégâts51.2967529 physiques ordinaires recalculés, tolérance0.002. L’AP est enregistré dans le résultat final de chaque cas, pas dans chaque relevé boutique. Inventaire et AD/armure sont vérifiés aux étapes achat/vente/rachat. Aucun scaling du passif déduit de ces attaques non amorcées.

Aucun sort Skarner accepté ni charge native appliquée ; proc à trois charges, stun et verrou non exercés. L’attente181ticks/cas dépasse six secondes sans avoir lancé ce verrou : elle ne valide pas son expiration, ni celle des charges. Mana déjà au plafond, restitution non qualifiée.

Refus par flags de snapshot inchangé ; paires PVcible adjacentes sortantes absentes, soin non qualifié, aucune garde NPC universelle. Historique15 fichiers/10542240 octets, 13 empreintes anciennes concordantes/deux identités nouvelles ; JSON brut RUN égal au relevé. Binaire 6077952 octets/SHA `4c220f87ad520d59136dab5509707565cf1f7e69ea2194440ce8a7afd88c42ee` inerte, BUILD/RUN0.

Contrôles55/55, cohérence61/61 séparée du même agent. Formulation ambiguë du relevé corrigée : cinq secondes=charges, stun=f2 inconnu ; original conservé, seuls mots de conclusion modifiés, 61 contrôles identiques (`stun_wording_correction.json`). Productions journalisées sorties0. Aucun nouveau build/jeu/VM/REA/rendu/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Producteur de charges non établi dans les consommateurs courants inspectés. f1/f2/progression, cibles, ordre, rafraîchissement, expiration, propriétaires multiples, consommation R/attaque, tenacité, lifecycle, providers, traduction étrangère, transport et pixels ouverts. V564/Nami et autres clauses conservés.

## 6. Corrections et reprise

Réutiliser SOURCE/SIMULATION/NETWORK/HUD. `COR-SKARNER-STING-POLICY-01` : qualifier f1/f2, progression, éligibilité, ordre et règles par propriétaire/cible. Fin : contrat historique sourcé, sans fusionner Cooldown10, verrou6s, Q et R.

`COR-SKARNER-STING-CHARGES-PROC-01` : produire les charges par sorts admissibles, puis consommation d’attaque. Fin : états0/1/2/3, renouvellement/expiration5s, dégâts magiques, stunf2, verrou6s, refus, simultanéité, multi-propriétaire, tenacité et lifecycle vérifiés. Prérequis : sorts d’application acceptés, conservés dans leurs tâches existantes.

`COR-SKARNER-STING-HUD-BINDINGS-01` : relier icône/textes, nombre de charges, stun et verrou aux états autoritaires. Fin : transitions, propriétaire/cible, transport et pixels observés. Reprendre sur artefact serveur/mapping/callsite nouveau, dérive ou autorisation fonctionnelle ; aucun correctif produit ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_skarner_passive_hud_20261104` : evidence_review/coherence_review, DDS/histoire, resource_provenance.json, phase_package_prerequisites.json, correction de formulation et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement, sauvegardes exactes/sept protégés contrôlés. Une unité documentaire close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
