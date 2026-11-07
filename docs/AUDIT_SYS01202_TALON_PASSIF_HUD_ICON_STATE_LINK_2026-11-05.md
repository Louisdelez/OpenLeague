# SYS-01.2-02 — Talon : Mercy et HUD, V1279

5 novembre 2026, Europe/Zurich ; lot engagé le4novembre, dossier de preuves conserve cette date initiale. Unité `AUD-SYS-01.2-02-TALON-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Talon-PASSIF-PRESENTATION-HUD`, `OLF-6cf5e0b1-2678-5479-b43b-87bc4ae6210f` : relier condition de contrôle, dégâts, icône et texte aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-71046c9f-03d4-5e44-9f57-538da314ef50` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/D06-CH-Talon consultés, sans satisfaction revendiquée. Parent PRESENTATION, QWER et goal restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/talon-passive-mercy-links-v636.json`, 2565517octets, SHA `6c2188b39df436ba036d6a092398623df0951815cfd304147726a02361f8ac2f`, UTC documentaire 2026-10-26T20:02:30.663783+00:00, sans attribution à l’heure d’exécution.

HUD enregistré : une définition/un catalogue. SOURCE :65relations/63identités/quatre sites/deux fichiers. V636 :63membres/189associations,27sites/15fichiers ; union16fichiers/31ancres. Aucun ID SOURCE supplémentaire ; registres gelés conservés. Métadonnées réutilisées sans relecture native :21INIBIN,25Lua,15preloads,DDF/font.

Font4286 : attaques de base +10% contre cible ralentie, étourdie, immobilisée ou sous suppression ; nom Mercy4462. Producteur serveur, définition exhaustive des contrôles, ordre et arrondis restent non qualifiés. Quatre BuffData exactement traduits : DamageAmp/Surprise, Disappear, Slow, NoxianDiplomacyBuff ; aucune équivalence automatique avec Mercy.

Définition : Passive1LuaName vide, icône TalonMercy.dds, ancienne description de soin Warwick, textes mana40/60/80%, marqueurs1/6/11/16 distincts. PARType absent, BaseMP numérique327.2000122/croissance chaîne40. **CharScript/Scripts fait114octets** et déclare Wolfman_InnerHunger.dds ; TalonMercy.luaobj déclare BladeRogue_CheatDeath/22.dds. Ces héritages ne remplacent pas le binding Mercy ni ne prouvent la priorité effective des providers. Trois candidats alternatifs absents sans absence globale déduite.

25Lua sans fonctions enfants, trois limites NEWTABLE ; persistance/preloads non preuves de lifecycle/rendu. DDF12lignes : Q bonusAD0.3/1.2, W0.6, R0.9, aucune formule Mercy. E DamageAmp, BrewPoison et icônes Jax/Zilean restent distincts. 26références communautaires partielles : Q immédiat/totalAD, W simple impact, E silence, Rcoefficient0.75 non promus en règles natives. Producteurs TalonAmp/TalonStealth non retrouvés dans le sous-arbre choisi, pas d’absence globale déduite. Ancien hit « talon » dans MetadataLonger est une sous-chaîne de donnée de test.

Un DDS nécessaire `DATA/Spells/Icons2D/TalonMercy.dds` :5616octets,64×64 DXT5/septmips, SHA `8c54436b7a0fcb7c7188a3d842bd8f6d348dc9c2d831be0c58e3f31250776527`. Projet RADS0.0.1.7/membre0.0.0.43, taille/MD5 concordants ; sélection E avant unique stat/lecture SOURCE. Aucun DDS Warwick/22/étranger/particule lu. Provider/pixels ouverts ; miroir font et témoin Ahri réutilisés.

Mana courant : source_sha256 identifie StatsJSON communautaire 6727octets/SHA `396275b0ebcb66a4185d9ce16282ed4e2e5286f9d83c4dfe879cb4c445f239ad`, distinct de l’INIBIN natif 2433octets/SHA `a597f428de59af0461a31395e884b97e51e7a4d3c3ee9c3dc88b4f869f541b40` ; resource_provenance.json.

## 3. Consommateurs actuels

31ancres exactes,34fichiers code/configuration vérifiés et16entrées communes inchangées. Aucun producteur nommé Talon/Mercy/BladeRogue dans ce périmètre Rust ; recherche bornée par mots, sans faux positif MetadataLonger.

attacks.rs:157 et lifesteal.rs:4 appliquent attaque physique générique, damage.rs mitigation, progression.rs statistiques. slows.rs/stuns.rs et summoner_exhaust.rs produisent les contrôles ; Exhaust retire10armure, séparément de Mercy. Annie/Pyromania fournit l’étourdissement public. lib.rs exécute Annie avant régénération, puis attaques ordinaires. native_hud_bars.rs:11 et native_hud_spells.rs:21 consomment Mana/rangs/cooldowns génériques, sans présentation Mercy qualifiée.

## 4. Attendu, observé et contrôles

Trois cas publics niveau1 : ralentissement, étourdissement, cumul. Neuf attaques Talon avant/pendant/après, dix impacts Q Annie, deux Exhaust, deux apprentissages Q Annie, neuf arrivées sans réordre,84refus. Aucun état de contrôle injecté ; sorts Talon refusés, sans être prérequis du passif d’attaque.

AD55.2080002 ; armure Garen27.5359993, puis17.5359993 sous Exhaust. Attaque ordinaire attendue43.2881699 ou46.9711418. Pendant étourdissement seul : observé43.2881775, comparaison nominale avec Mercy47.6169891. Sous ralentissement/cumul : observé≈46.97113–46.97115, comparaison51.6682587. Les trois écarts discriminants dépassent4.32 ; aucun bonus Mercy observé après prise en compte d’Exhaust.

Neuf paires PV brutes recalculées avec régénération f32, plafond et Perseverance, puis dégâts. Dix Q Annie : dégâts magiques/missile/source/résidu et séquence Pyromania1/2/3/4/0 vérifiés ; leurs paires PV adjacentes à l’impact ne sont pas enregistrées, tous les termes de PV ne sont donc pas recalculés indépendamment. Contrôles expirés dans les snapshots ; cela ne teste pas l’expiration d’un buff Mercy produit. Refus par flags, aucune garde NPC universelle. Immobilisation/suppression/critiques/on-hit/frontières non exercés.

Historique25fichiers/18900084octets :23identités attendues/deux nouvelles. Premier BUILD0/RUN101 conservé, assertion du collecteur sur l’ordre impact Annie/régénération. Version corrigée distincte BUILD/RUN0, RUN brut identique au relevé ; binaire 6063616octets/SHA `c012eaf9d01a6161a3ff72a1a879b4eb16a11ecbeec84cfd5cef92357ff80b9e` conservé inerte. Ancien binaire également conservé.

Contrôles107/107 après correction ciblée, cohérence108/108 séparée du même agent. evidence01=1/106sur107 : hypothèse CharScript vide56octets réfutée par114octets/Wolfman. Seul ce contrôle est remplacé ; original/script/logs et charscript_qualification.json conservés, autres106inchangés, qualification01=0. Aucun nouveau jeu/build/VM/REA/rendu/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Bonus conditionnel non observé dans trois cas nominaux. Producteur/politique historique, immobilisation/suppression, critiques/on-hit, ordre/arrondis, cibles, lifecycle, provider et présentation restent ouverts. Legacy Warwick/BladeRogue, E amplification et communautaire non substitués. V564/Nami et autres clauses conservés.

## 6. Corrections et reprise

Réutiliser SOURCE/SIMULATION-CONTRAT/SIMULATION/NETWORK/HUD. `COR-TALON-MERCY-POLICY-01` : qualifier classification des contrôles, base du10%, types d’attaque/cible, critiques/on-hit, ordre/arrondis et lifecycle. Fin : contrat historique sourcé, héritages exclus explicitement.

`COR-TALON-MERCY-ONHIT-01` : appliquer le bonus autoritaire au bon impact. Fin : ralentissement/étourdissement/immobilisation/suppression, cumul sans double bonus, contrôles expirés, refus/frontières, valeurs et interactions vérifiés selon contrat. Conserver Exhaust et régénération comme contrôles séparés ; sorts Talon non prérequis de ce déclencheur.

`COR-TALON-MERCY-HUD-BINDINGS-01` : qualifier provider Mercy et relier texte/icône à l’état pertinent, sans adopter Wolfman/22 par homonymie. Fin : lookup, transitions, transport et pixels observés. Reprendre sur artefact serveur/callsite nouveau, dérive ou autorisation fonctionnelle ; aucune réparation produit ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_talon_passive_hud_20261104` : evidence_review_corrected.json, coherence_review.json, qualification, DDS/histoire combinée, resource_provenance.json, phase_package_prerequisites.json et journaux. Hook7/7 réutilisé ; limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes exactes/sept protégés vérifiés à la publication. Une unité documentaire close, zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ; SYS-01.2-02 actif.
