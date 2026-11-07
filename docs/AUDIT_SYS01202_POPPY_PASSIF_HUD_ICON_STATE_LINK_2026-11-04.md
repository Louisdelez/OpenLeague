# SYS-01.2-02 — Poppy : Valiant Fighter et HUD, V1259

4 novembre 2026. Unité `AUD-SYS-01.2-02-POPPY-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre ; implémentation, vérification du gameplay et acceptation humaine distinctes.

## 1. Exigence et périmètre

`CH-Poppy-PASSIF-PRESENTATION-HUD`, `OLF-1c8b783e-9eb6-5a64-beb4-3b24d7e51bd1` : relier icône, texte, rang applicable et réduction des dégâts aux consommateurs. Contrat a_faire,implémentation/acceptation false,dépendance NETWORK ; inconnue `OLU-e285d7c5-3a23-597c-8af5-dc1304980e83` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE conservés. Phase D06/lot D06-CH-Poppy/prérequis consultés,sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/poppy-passive-valiant-fighter-links-v615.json`,2297425octets,SHA `c6e844b55e2501a483853517247d8d82cc53ccfb061c4c93dca9aa3e95eee3a8`,UTC documentaire 2026-10-26T13:12:13.878593+00:00,sans attribution à une heure d’exécution.

HUD :deux sources/un catalogue. SOURCE :52relations/46identités,six sites/trois fichiers. V615 :46sources/138associations,24sites/48liens/13fichiers. Union :15fichiers/30ancres. Aucun ID SOURCE supplémentaire. Métadonnées réutilisées sans réouverture D :12INIBIN,19Lua,14preloads,font.

Définition et buff :PoppyValiantFighter/Poppy_ValiantFighter.dds. Font4255 et buff2471 décrivent dégâts physiques/magiques dépassant10% des PV courants réduits de50%,hors structures. Cela ne résout pas partie excédentaire/coup entier ni ordre seuil/résistances/boucliers/régénération. PersistsThroughDeath/NonDispellable ne prouvent pas les callbacks ou le cycle mort/respawn.

Passive1=9,texte Jax,mana40/60/80% et niveaux3/7/11/15 conservés sans adoption. 19Lua :15littéraux/quatre limites NEWTABLE ;14preloads,huit BuffData exactement résolus,dont VayneCondemn. ETarget référence RumbleDangerZone ; XenZhaoSweep apparaît dans les constantes. Ces métadonnées croisées ne deviennent pas des mécaniques qualifiées. CharScript natif vide56octets,communautaire vide. Cinq candidats absents,sans manque global d’assets ni corruption déduits. DDF non sélectionné.

17références communautaires non adoptées :Q au pourcentage décroissant sans AD/plafond/attaque renforcée qualifiés,E stun sans déplacement/collision murale,W/R délèguent des buffs. Texte WIP sans exception des structures non retenu. Ni serveur original ni gameplay Rust prouvé par ces scripts.

Deux DDS nécessaires,8448octets/un contenu,4224octets chacun,64×64DXT5,mip1 :Characters/Poppy/HUD/Icons2D,membre0.0.0.235 ; Spells/Icons2D,membre0.0.0.25. SHA commun `f28c16773e27597d0d9c9597268ed1dd098680fdd8cc0283d3b1a6c811bab27e`,MD5c5a12471ad73b025565883ce220e227c. Taille/MD5 concordent au manifeste lol_game_client0.0.1.7,inventaire E avant deux lectures SOURCE. Chemin retenu/lookup/pixels ouverts.

Font miroir inchangé,témoin Ahri réutilisé. Mana courant,PARType natif absent ; source_sha256 correspond au JSON communautaire5077octets/SHAb520131f8d0aaf7c1f64cd51e3bb8987f072d3e077bcd6ba054bb2435111606e,distinct de l’INIBIN natif1816octets/SHA730a4c4df699888df4a24875282da1698825307dac4872b6c8c9850ab99085ec (`resource_provenance.json`).

## 3. Consommateurs actuels

30ancres exactes,16entrées communes et29fichiers code/configuration vérifiés. Recherche Poppy/ValiantFighter sans occurrence dans ces Rust,sans absence globale revendiquée. Catalogue,stats/objets,attaques/dégâts,commandes et snapshots inspectés.

damage.rs:80–104 :Courage0,7 ou1,pénétration/mitigation,puis absorb_shields,puis PV. Aucun seuil Poppy identifié dans cette route. Bouclier à montant et Courage ne sont pas Valiant Fighter. HUD Mana/MPStat/PV et module Ezreal ne qualifient pas son icône,texte ou indicateur de réduction.

## 4. Attendu et observé

Attendu :réduction physique/magique fidèle,seuil PV courants,exception des structures et HUD attribuable. Hérité V615 :trois cas base/Rubis1028+150PV/Cape1033+25RM,AD61,97,armure28,72 ; PVmax559,08/709,08/559,08 et RM30/30/55. Neuf mêlées sortantes,18physiques entrants,six QAnnie,81refus,360ticks d’attente,six trajets aboutis sans reprise.

24événements entrants recalculés :10au-dessus/14dessous du seuil illustratif après mitigation (5/3,1/7,4/4). Tous restent conformes aux dégâts ordinaires,tolérance0,002 :physiques≈39,16252,Q≈61,53846 ou51,61290. Aucune réduction observée. Ces classifications ne fixent pas la formule native. Rubis déplace le seuil et Cape réduit les dégâts magiques ; effets d’objets distincts du passif.

Six Q :PV bruts adjacents avant/après et régénération recalculés,sans bouclier ;18physiques :PV avant présents,PV après bruts non sauvegardés,observé dérivé hérité. Refus :flags sans snapshots bruts ; attentes :PV/attendu,pas âge de buff ; aucune garde NPC universelle. Aucun sort Poppy accepté,mais dégâts entrants exerçant le candidat. Égalité exacte,structures,bouclier positif,dégâts purs,multisource/mort/respawn non testés.

Historique15fichiers/11046282octets,13ancienshashes concordants/deux identités nouvelles. Binaire6135296octets/SHA32b4ea468478ac52b01b82aaf7982f90a6ddc603dd0a550022a4c2d07585420c,inerte ; BUILD/RUN bruts0. Contrôles55/55,cohérence séparée49/49,même agent. Préparation :mauvais nom MD corrigé ; première relecture coupait avant apply_damage au premier cfg(test),corrigée vers impl Simulation. Scripts/entrées/erreurs conservés,échecs de méthode distincts du jeu. Aucun nouveau build/jeu/VM/REA/rendu/GPU/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Formule excédent/coup entier,ordre des résistances/régénération/boucliers,égalité stricte,structures,types/sources admissibles et HUD non établis. QWER/callbacks,cycle mort/respawn,lookup/provenance Mana et transport ouverts. Un niveau,trois profils ; limites V564 et deux échecs Nami conservés.

## 6. Corrections et reprise

Réutiliser `CH-Poppy-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-POPPY-VALIANT-FIGHTER-POLICY-01` :qualifier formule,ordre,structures et sources admissibles. Fin :contrat4.20 sourcé,cas avant/égalité/après seuil,physique/magique/pur,boucliers et changement de PVmax,sans hypothèse transformée en règle.

`COR-POPPY-VALIANT-FIGHTER-DAMAGE-HUD-01` :appliquer le contrat au vrai pipeline,exposer texte/icône/état et transport. Fin :événements attribuables,structures/multisource,boucliers/résistances/objets/mort/respawn vérifiés. Reprendre sur preuve serveur/mapping/callsite nouveau,dérive ou autorisation d’implémenter ; aucun correctif fonctionnel ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_poppy_passive_hud_20261104` ; evidence_review/coherence_review,DDS/histoire,resource_provenance.json,phase_package_prerequisites.json,journaux et corrections de méthode. Hook7/7 réutilisé ; captures avant assertions,limites Python/contexte/inventaire final/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement,deux sauvegardes,sept protégés vérifiés avant/après publication. Une unité d’audit bornée close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif ; goal/Plan/UI/bases/registres/produit inchangés.
