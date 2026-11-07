# SYS-01.2-02 — V1301 Yasuo : Way of the Wanderer, Wind et HUD

## 1. Périmètre et prérequis

2026-11-05, F:/OpenLeague. Unité `AUD-SYS-01.2-02-YASUO-PASSIF-HUD-ICON-STATE-LINK-01`, tâche `CH-Yasuo-PASSIF-PRESENTATION-HUD`, exigence `OLF-0654c585-7394-5d75-b7cb-1814861926ab`, inconnue `OLU-4667bd96-297e-550c-b210-bdee5a80f99f`. Audit documentaire borné du lien HUD terminé ; six contrats/questions conservés, HUD a_faire, implémentation/acceptation false, NETWORK ouvert. D06/D06-CH-Yasuo et prérequis dans phase_package_prerequisites.json, sans acceptation présumée. SYS-01.2-02 actif.

[V808](AUDIT_SYS01202_YASUO_PASSIVE_CURRENT_CONSUMER_2026-11-02.md) clôt déjà la frontière statique core : ses huit identités courantes concordent. Cet ajout couvre ressource, textes, icône et HUD ; aucune seconde clôture du même audit core. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct.

## 2. Sources et provenance native

[V536](reference_requirement_trace_sources/yasuo-critical-gap-boundary-links-v536.json),302868octets/SHA `52c5f07f067c39be34c945e0dcdf73e6b70da77b686d56db52654adff24f3452`, UTC hérité `2026-10-25T15:15:54.919988+00:00`. SOURCE4relations/3IDs. JSON primaire sans native_metadata/phases : seuls les enregistrements Yasuo de V533 et découverte V536 qualifiée sont extraits ; aucune collecte globale rejouée.

Yasuo.inibin1266octets/SHA `797977795e29e35e2a3140a90ff6fca9132d0fcf94af27b0bcd26d7ea786e579` ; YasuoPassive.inibin1560/SHA `00c99df33e71f82f168c3a09bbea576d877214d03de038c4e02b5159d3cce4c8` ; Lua182/SHA `590931f87f55aa1fceb44f85f205a4c4de0ba56f557ff0c309590116bb4daa54`. Identités/memberships conservés concordants. Alias YasuoPassive,icône Yasuo_Passive.dds,Passive1Desc null. Lua sans fonction enfant : BuffName YasuoPassive,BuffTextureName BlindMonkWOne.dds,PersistsThroughDeath ; aucune formule/callback/lifecycle déduite.

Font miroir SHA1dd19dfe… vérifié : clés natives4490/10678/2957/12040/11346/9948. Buff2957 décrit Flow gagné en mouvement, davantage avec vitesse, bouclier au maximum après dégâts champion/monstre,@f1@ selon niveau ; critique doublé mais dégâts critiques réduits de10%,bonus courant@f2@. SpellDescription9948 concorde au catalogue. **SpellTooltip12040 décrit pourtant une réduction de dégâts après capacité, pendant deux secondes,20%+1% par4AD.** Textes distincts conservés ; sélection runtime non établie, aucune fusion de règles.

resource_provenance : DDS propre HUD2176octets,64×64 DXT1/mip0,membre0.0.0.191,SHA `d28ee7a95df3fafc99f697678b22768a64736c5c91f6c71cf3f0da7c96ad84cc`,taille/MD5/en-tête concordants au manifeste0.0.1.7. Sélection E avant lecture SOURCE. BlindMonkWOne a un candidat LeeSin/HUD2872octets,membre0.0.0.188,manifeste seulement ; pas d’équivalent exact dans les chemins propres/partagés sélectionnés. Ni absence globale,ni priorité de montage,pixels/GPU qualifiés. Métadonnées natives non relues.

## 3. Consommateurs actuels

12ancres héritées sur6fichiers,5relevés HUD supplémentaires ;31fichiers code/configuration,16communs et16identités V536 inchangés. Huit comparaisons V808 exactes : formule générique critique,stockage/absorption des boucliers et Barrière restent présents. Pas de nouvelle recherche globale des callsites inchangés.

champion_resources.json déclare Yasuo en Wind ; source_sha256 distinct du natif sélectionné, sans corruption déduite. native_hud_bars::values n’émet resource que pour Mana, puis update écarte les éléments MP si None. native_hud_widgets n’insère MPStat que pour Mana. Ces gardes statiques excluent le Flow de ces éléments ; HP reste pris en charge. health.rs consomme positions/PV, sans état Yasuo dans ce périmètre. Aucune exécution Bevy revendiquée.

Le manifeste d’icônes contient six entrées Yasuo, slots0/1/2/2/3/3,InventoryIcon/variantes QWER ; elles ne lient pas YasuoPassive. Aucun hook Yasuo/Flow/BlindMonk dans les seuls fichiers Rust examinés ; pas d’absence universelle.

## 4. Attendu, observé et vérifications

80/80 contrôles après qualification,77/77 cohérence séparée du même agent. Neuf archives9497538octets ; deux RUN bruts intégralement identiques aux observations. Deux témoins historiques : six statistiques immédiates, puis six avec ticks30/30/60/60/90/120. Achat public1051 et vente publique ; chances/empreintes f32 recalculées. Garen témoin0→8% ; Yasuo0→8→16→8%, face au comparateur16→32→16% du catalogue. Multiplicateur de dégâts2,0 distinct du doublement de chance. Aucun impact,tirage critique,mouvement ou bouclier exercé.

Un refus « unknown player » par témoin, sans paires de snapshots d’invariance. Les120ticks maximum concernent Yasuo ; pas toutes les frames, ni total additionné des simulations Garen/Yasuo. Inventaires/soldes bruts non archivés. Ancien premier essai avec quatre dépendances différentes conservé ; alignement au sous-ensemble du verrou racine ensuite vérifié, sans répétition actuelle.

Binaires alignés hérités :5410304octets/SHA bb0795ac31d89620ff71508dc49f3155b7b1de3e29ddf2899d4d0b0586f0fe21 ;5967360/SHA eead663ce771e3040473237389c457b9c46ff648fe58c1e1ef589251f17887f4. Non relus/rejoués ;1158entrées non requalifiées. Aucun nouveau build,jeu,REA,VM native,réseau/GPU.

## 5. Écarts et échecs conservés

Deux contrôles interrompus par une hypothèse erronée sur les conteneurs de membership : correction du lecteur vers trace conservée ou candidat V533,avec chemin/taille/SHA exacts. Troisième contrôle79/80 : motif MPStat présent ligne91 en production et156 sous module de tests130. Attendu corrigé1→2,les79autres contrôles et tous autres champs identiques ; occurrences conservées,sans replay. Trois codes1/journaux originaux conservés dans evidence_qualification.json.

Flow,seuil/reset,quantité/durée du bouclier,producteurs f1/f2,ordre critique/réduction et choix des textes/icônes restent ouverts. La fixture Yasuo W séparée n’accepte aucun comportement du passif.

## 6. Corrections et conditions de reprise

- `COR-YASUO-NATIVE-POLICY-01` : qualifier sélection des textes,f1/f2 et règles effectives sur source versionnée ; conserver chaque contradiction jusqu’à preuve.
- `COR-YASUO-CRITICAL-CHANCE-01` : relier chance doublée et modificateur critique qualifié ; vérifier achat/vente et dégâts séparément.
- `COR-YASUO-FLOW-STATE-01` : produire charge par déplacement,vitesse,seuil/reset et réplication ; vérifier limites et interruptions selon contrat.
- `COR-YASUO-SHIELD-TRIGGER-01` : relier dégâts admissibles au bouclier qualifié ; vérifier déclenchement,durée/lifecycle en conservant Barrière.
- `COR-YASUO-ICON-PROVIDER-PATH-01` : résoudre Yasuo/BlindMonk et montage effectif sur preuve ; aucune substitution arbitraire.
- `COR-YASUO-HUD-BINDINGS-01` : relier Flow,bouclier,icône et texte à l’état autoritaire ; vérifier transitions/rendu en conservant HP/Mana.

Reprendre sur nouvelle source,consommateur modifié ou test nécessaire autorisé. Prochain candidat : Yorick.

## 7. Livraison et garde-fous

Rapport et appendices CURRENT/HANDOFF seuls publiables ; octets antérieurs archivés,sept documents protégés comparés avant/après. Preuves E:/mapslol3v3/audit_sys01202_yasuo_passive_hud_20261105 :evidence_review original/corrigé,qualification,cohérence,captures,journaux,result/publication/postpublication. Journal Python instrumenté seulement,contexte/dispatch/empaquetage exclus,sans garantie OS/TOCTOU. Main `8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca`,2288entrées sales groupées conservées. Aucune tâche complète,feature,inconnue,acceptation ou goal clos ; même agent,sans acceptation indépendante/humaine.
