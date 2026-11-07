# SYS-01.2-02 — Nunu : Visionary et HUD, V1255

4 novembre 2026. Unité `AUD-SYS-01.2-02-NUNU-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre ; aucune implémentation du passif ou acceptation humaine déduite.

## 1. Exigence et périmètre

`CH-Nunu-PASSIF-PRESENTATION-HUD`, `OLF-77e43b6c-1b16-51fe-8399-0e9c48c51def` : relier icône, texte, rang, charges/prêt et coût gratuit aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-08c05937-d790-5414-872a-624020075450` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et leurs inconnues conservés. Phase D06/lot D06-CH-Nunu/prérequis consultés, sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/nunu-passive-visionary-links-v611.json`,2373268 octets,SHA `bf98ae28656a56f02b337d4322a854d9e7752070e9ec9a35d05130a4efb6dcc7`,UTC documentaire 2026-10-26T12:06:02.347759+00:00, sans attribution à une heure d’exécution.

HUD :une définition/un catalogue. SOURCE :50 relations/36 identités,six sites/trois fichiers. V611 :36 sources/108 associations,26 sites/52 liens/13 fichiers. Union :15 fichiers/32 ancres. Aucun ID SOURCE supplémentaire. Métadonnées natives réutilisées sans réouverture D. V553 reste un contexte hérité distinct :témoin payant AnnieW ≠ Visionary ; comptes non fusionnés.

Nunu.inibin lie Visionary/Yeti_FrostNova.dds. Textes2898–2900/4242 :après cinq attaques de base, prochain sort sans mana ; compteur en charge et Visions prêt. Événement de comptage,cibles,sorts admissibles,reset/plafond/consommation non résolus. Passive1 absent ; niveaux1/6/11/16 non assimilés à une progression du compteur. Textes aléatoires/non-ultime/Yuralia10% conservés sans adoption.

`Visionary Counter.inibin` existe avec espace ; `Visionary_Counter.luaobj` déclare ce BuffName. Correspondance enregistrée, priorité runtime inconnue. Visionary.luaobj rencontre NEWTABLE ; constantes Visions/NunuBot/particule ≠ affectations exécutées, callbacks ou exclusion du passif normal. Le marqueur expose icône/nom/PersistsThroughDeath/NonDispellable, sans qualification mort/respawn.

13 Lua :dix littéraux/trois limites ; neuf BuffData exactement résolus,cinq preloads,deux CharScripts natif/communautaire vides. Six candidats absents,dont Nunu.ddf, sans manque global ni corruption déduits. Coûts natifs :Q60/W50 aux cinq rangs,E75/85/95/105/115,R100 aux trois rangs ; champs absents des buffs ≠ coût nul effectif.

22 références communautaires non adoptées :Q soin75 sans AP contre70+0,75AP natif et exclusion des champions non démontrée ; W application à la cible seule ; E dégâts/buff sans projectile qualifié ; R pulses temporisés sans canalisation originale démontrée. Ni serveur original ni consommateurs Rust.

Trois DDS nécessaires,12672 octets/deux contenus, chacun4224 octets/64×64 DXT5 :

| Icône et chemins | Identité |
|---|---|
| Yeti_FrostNova.dds :Characters/Nunu/Info et Spells/Icons2D | mip brut0,membres0.0.0.40 et0.0.0.25 ; SHAc3f713bc73ea74b0c2744c514fe7eef6c76095a321a8b785dd6bd6ff9bb5134f |
| Yeti_FrostNova_Charging.dds :Spells/Icons2D | mip1,membre0.0.0.107 ; SHA300a047d4da079b6bad6467ccdddfb13fbae2cec9047991ddfbcd96b03b8a8e0 |

Taille/MD5 concordent au manifeste lol_game_client0.0.1.7 ; inventaire E avant trois lectures SOURCE. Lookup/variante/pixels ouverts,mip0 non déclaré corrompu. Font miroir identique au témoin Ahri. Mana courant,PARType natif absent ; source_sha256 correspond au JSON communautaire8762 octets,distinct de l’INIBIN natif3378 octets/SHAd052022fcea8943299f9fd1c48f9d743b3ac183927497a27d37dc749c0e4d6a6 (`resource_provenance.json`).

## 3. Consommateurs actuels

32 ancres exactes,16 entrées communes et28 fichiers code/configuration vérifiés. Recherche Nunu/Visionary sans hit dans ces Rust, sans absence globale revendiquée. `progression.rs:150–165` refuse l’apprentissage ; `spells.rs:101–124` et `annie_w.rs:29–61` refusent ses casts avant traitement d’un coût Nunu. Aucun compteur Visionary identifié dans Effects/routes inspectées.

Attaques/dégâts génériques fonctionnent. `lifecycle.rs:16/24` classe la ressource ; `regeneration.rs:10/32` et `shop.rs:314–322` expliquent le mana. Le plafond augmente sans remplissage instantané ; cette politique courante reconstruite n’est pas une qualification native. HUD Mana/MPStat/PV et module Ezreal ne démontrent pas charges/prêt/exemption du coût Visionary.

## 4. Attendu et observé

Attendu :attaques admissibles chargeant Visionary,puis vrai sort accepté sans mana et consommation unique du prêt,avec HUD attribuable. Hérité V611 :deux cas base/Cristal1027,AD56,856,mana maximal283,56/483,56. Douze mêlées ordinaires et102 refus aux comptes observés0/4/5/6 ; quatre trajets aboutis,sans reprise.

Huit étapes conservent des snapshots bruts avant/après exactement égaux ; comptes recalculés depuis les ticks d’impact,trois familles de refus explicites. Douze paires de mana concordent aux prédictions et restent bornées. Elles sont plafonnées :ni gratuité ni taux en déficit qualifiés. Achat Cristal :capacité+200,réserve initiale conservée ; mana final plein ne prouve aucune gratuité. Aucun sort Nunu accepté,donc consommation gratuite non exercée ; six coups ≠ compteur natif démontré.

Premier essai historique BUILD0/RUN101 :hypothèse mana=maximum après achat,283,6096 contre483,56. Source/binaire/logs conservés. Diagnostic corrigé :bornes et régénération ; moteur non modifié. Binaire final6093312 octets,SHA `b0dd7cf7943d3b38f3c2738afe2b85e598c42367c7928fd9cfc59e15c2385800`,inerte ; BUILD/RUN corrigés0/0.

Collecte actuelle :FileExistsError sur deux reçus déjà sélectionnés ; script/journal/échec conservés. Récupération :20 captures vérifiées réutilisées,deux reçus corrigés manquants lus,aucune relance du jeu. Ensemble final22 fichiers/16584616 octets,20 anciens hashes concordants/deux identités nouvelles (`history_recovery.json`).

Contrôles actuels60/60,cohérence séparée50/50 par le même agent. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni revue indépendante/humaine. Dommages cible sans paire pré-impact adjacente ; autres refus avec flags seuls ; aucune garde universelle NPC qualifiée.

## 5. Écarts et inconnues

Compteur/prêt,admission des sorts,exemption/consommation et HUD non établis. Initiation/libération/impact,cibles/ratés/blocages,ultime/items/summoners/recasts,annulations,plafond/reset,mort/respawn,attribution et réseau ouverts. Provenance Mana et lookup des icônes à qualifier. Limites V564 et deux échecs Nami conservés.

## 6. Corrections et reprise

Réutiliser `CH-Nunu-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-NUNU-VISIONARY-POLICY-01` :sourcer événements/cibles/sorts/reset/consommation. Fin :contrats4.20 démontrés sans héritage aléatoire ni alias supposé.

`COR-NUNU-VISIONARY-CAST-HUD-01` :intégrer compteur/prêt au vrai lancement des capacités nécessaires et au HUD. Fin :seuils4/5/6,mana nul/insuffisant/plein,sort gratuit accepté,consommation unique,plusieurs cycles,refus/interruptions/mort/respawn et transport vérifiés. Reprendre sur nouvelle preuve,dérive ou autorisation d’implémenter ; aucun correctif fonctionnel réalisé ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_nunu_passive_hud_20261104` ; evidence_review/coherence_review,DDS/histoire,`resource_provenance.json`,`phase_package_prerequisites.json`,reprise/journaux. Identités conservées avant assertions ; hook7/7 réutilisé. Captures explicites F/OpenLeague-work ; limites Python/bootstrap/contexte/inventaire final/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement,deux sauvegardes,sept protégés contrôlés avant/après. Une unité d’audit bornée close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif ; goal/Plan/UI/bases/registres/produit inchangés.
