# SYS-01.2-02 — V1309 Fiora : Duelist, régénération et HUD

## 1. Périmètre et prérequis

2026-11-05, F:/OpenLeague. Unité `AUD-SYS-01.2-02-FIORA-PASSIF-HUD-ICON-STATE-LINK-01`, tâche `CH-Fiora-PASSIF-PRESENTATION-HUD`, exigence `OLF-9404e32a-81c4-5148-9c8f-ff469ee9e933`, inconnue `OLU-1d9ce12d-4858-5faa-8bee-083e43d16246`. Audit documentaire borné du lien HUD terminé. Six contrats/questions conservés ; HUD a_faire, implémentation/acceptation false, NETWORK ouvert. D06/D06-CH-Fiora et dépendances dans phase_package_prerequisites.json, sans acceptation présumée. SYS-01.2-02 reste actif.

Référence PUBLIC4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. La consolidation V1308 identifiait ce lien restant ; elle reste conservée sans réécriture.

## 2. Sources et provenance

[V662](reference_requirement_trace_sources/fiora-passive-duelist-links-v662.json), 2846777octets/SHA `072515317cf632a1b1da6b27d9c19c336222edaeebe9a9ee80d56d2e6097b6e9`, UTC hérité `2026-10-27T05:32:57.490099+00:00`. SOURCE24relations/21IDs :6INIBIN,9Lua,4preload,DDF,font ; memberships conservés concordants. Fiora.inibin2592octets/SHA `a762b0b53b83bcecef9612f80164d5738d1a240c1832912bd21553cc5fe58ac9` déclare FioraDuelist et Fiora_Duelist.dds. Passive1/Desc/Level1..6 sont null, pas zéro.

Font miroir exact :4362/4186/1899/1900. Le personnage dit « dégâts » ; le buff précise dégâts physiques, récupération @f1@ sur6secondes, quatre cumuls contre champions. Cette différence reste ouverte. Le montant f1, la périodicité et le renouvellement ne sont pas qualifiés ; aucun passif moderne de points vitaux substitué.

28Lua consommés entièrement, sans fonctions enfants ; six limites NEWTABLE conservées. CharScript56vide ; Duelist210 déclare texture/nom/persistance/non-dissipation. Hot/HotParticle/HotParticle2,489octets chacun et même SHA, déclarent FioraDuelistHot avec effets d’activation vides. Run90 ne fournit que persistance. Ces métadonnées ne prouvent ni callback de soin ni maintien des cumuls après mort. DDF8lignes :Q×0,6 et Dance×1,2 bonusAD, sans formule de soin.

resource_provenance :deux Fiora_Duelist.dds, propre Info et partagé Spells/Icons2D,5616octets chacun,64×64 DXT5/mip7,membre0.0.0.79,même SHA `f519d5977c3b0dce8bc7b1378a0536e14737e73d7c55cd9300fe8da5479320f9`. Sélection E avant lectures SOURCE ; taille/MD5/en-têtes concordent au manifeste0.0.1.7. Métadonnées natives non relues. Montage, priorité, pixels et GPU restent ouverts.

## 3. Consommateurs actuels

27ancres sur12fichiers hérités ;30fichiers code/configuration,16communs et18identités V662 inchangés. Attaques, dégâts, mitigation, régénération et heal génériques existent. Aucun hook Fiora/Duelist dans les seuls fichiers Rust examinés ; aucune absence universelle affirmée.

Le catalogue QWER Fiora contient six entrées :quatre InventoryIcon et deux InventoryIcon1, pour Q/R. Aucune ne référence Fiora_Duelist. native_hud_spells consomme ces entrées QWER ; le Buff0 de native_ezreal_passive_hud est spécifique à Ezreal. HP/Mana HUD consomment les valeurs réelles, ressource Mana conservée, sans binding qualifié du soin Duelist, des cumuls, de la durée ou du tooltip f1. Le « rang » du critère reste à qualifier, sans rang inventé.

## 4. Attendu, observé et contrôles

55/55contrôles documentaires corrigés,56/56cohérence séparée du même agent. Nominal :déclarations, textes, DDS, catalogue et routes HUD sont reliés. Limite :pas de chemin Duelist identifié dans les consommateurs inspectés. Deux archives1348669octets :inspection V662 qualifiée et source du diagnostic. Le RUN et les9444523octets d’observations brutes ne sont pas relus/recalculés ici.

**Les observations suivantes sont héritées de V662**, dont l’inspection/les identités actuelles concordent :Fiora/Annie1/18,24attaques,24fenêtres181ticks sans supplément de soin, déficit PV conservé ;12contrôles API de dégâts physiques/magiques/vrais ;quatre heal25 distincts de f1 ;20préparations heal+blessure40%PVmax, huit trajets, six XP diagnostiques.60refus publics/40API,12768ticks. La cinquième attaque sans activation ne valide pas le plafond4. Ces résultats ne sont pas présentés comme de nouveaux tests.

V662 annonçait BUILD/RUN0. Binaire6116352octets/SHA `267c7eecac4910c920a86c86a002c66ef0af46578a87ef330530505dbc78d16c` hérité, non relu/rejoué ;1158entrées non requalifiées. Aucun nouveau build, jeu, REA, VM native, réseau/GPU.

Le premier contrôle attendait quatre entrées QWER :54/55, code1 conservé. Qualification sur le catalogue E déjà capturé :six entrées avec variantes Q/R, sans Duelist. Un seul prédicat est corrigé ;54autres contrôles et tous les autres champs du résultat sont identiques. Aucun nouveau F/Dread pour cette qualification, aucun changement produit.

## 5. Écarts et limites

Restent producteur f1, progression, cadence et arrondis du soin ; déclencheurs/crédit/cibles, gain/renouvellement/cap des cumuls, durée commune ou individuelle, mort/dissipation/reconnexion et interactions QWER. Le soin générique ne devient pas Duelist ; les descriptions et constantes client ne deviennent pas du code serveur. Présence de texture et variations QWER ne prouvent pas affichage du passif. Réseau, rendu, particules, animations/audio restent séparés.

## 6. Corrections et reprise

Réutiliser les six tâches SOURCE/SIMULATION-CONTRAT/SIMULATION/NETWORK/PRESENTATION-HUD/ACCEPTANCE existantes. Sous-objectifs proposés, sans ajout au registre :

- `COR-FIORA-NATIVE-DUELIST-POLICY-01` :qualifier f1, dégâts admissibles, cibles, cadence, ordre et exceptions sur source4.20 ; conserver chaque inconnue.
- `COR-FIORA-DUELIST-STACK-STATE-01` :produire gain/renouvellement/cap4 selon politique qualifiée ; vérifier activation puis cumuls1–4/cinquième événement et expiration.
- `COR-FIORA-DUELIST-HEAL-01` :relier l’état au soin qualifié sur6s ; vérifier PV/arrondis, témoins sans bonus, modificateurs et plafond, sans adopter heal25 comme f1.
- `COR-FIORA-DUELIST-LIFECYCLE-01` :qualifier mort/respawn/dissipation/reconnexion ; vérifier transitions sans déduire la règle de PersistsThroughDeath.
- `COR-FIORA-ICON-PROVIDER-PATH-01` :établir sélection/montage Info/partagé et rôle des variantes ; vérifier chemin réel sans substitution QWER.
- `COR-FIORA-HUD-BINDINGS-01` :lier icône/tooltip f1, cumuls et durée à l’état autoritaire ; vérifier transitions en préservant HP/Mana et préciser le rang applicable.

Reprendre sur nouvelle source, consommateur modifié ou contrôle nécessaire autorisé. Prochain lot :Gnar V571/V572, sources et consommateurs réels à inspecter avant toute reprise.

## 7. Livraison et garde-fous

Rapport et seuls appendices CURRENT/HANDOFF ; notes antérieures sauvegardées, sept documents protégés comparés avant/après. Preuves E:/mapslol3v3/audit_sys01202_fiora_passive_hud_20261105 :evidence_review original/corrected,evidence_qualification,coherence_review,captures,journaux,result/publication/postpublication.

Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2296entrées sales groupées conservées. Journal Python instrumenté seulement ; contexte/dispatch/empaquetage exclus,sans garantie OS/TOCTOU. Goal/Plan/UI/bases/registres/produit inchangés. Aucune tâche complète, fonctionnalité, inconnue ou acceptation close ; même agent, sans acceptation indépendante/humaine.
