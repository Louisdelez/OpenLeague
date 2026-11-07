# SYS-01.2-02 — Leblanc : liaison de Mirror Image au HUD, V1236

4 novembre 2026. Unité `AUD-SYS-01.2-02-LEBLANC-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné, soumis à revue indépendante et publication racine. Implémentation et acceptation distinctes.

## 1. Exigence et périmètre

`CH-Leblanc-PASSIF-PRESENTATION-HUD`, `OLF-df7de27f-5ccf-548d-b26c-85b47a1946c7` : icônes normale/recharge,texte,rang applicable et état autoritaire du passif/clone. Contrat requis,a_faire,implémentation/acceptation false,dépendance NETWORK. `OLU-25c008a9-b5ec-5ff8-bec0-3130228b31c6` reste ouverte. Six contrats HUD,NETWORK,SIMULATION,SIMULATION-CONTRAT,SOURCE et ACCEPTANCE avec leurs six inconnues propres conservés ; PRESENTATION parent distinct.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/leblanc-passive-mirror_image-links-v591.json`,1499582octets,SHAca4875eb0394e50c57e748e1667697d22b96cabc3a87b886243e6c30d851bdef. UTC2026-10-26T05:51:44.295201+00:00 ; MD05:59:37.274447. Dates documentaires,pas de date d’exécution déduite.

V591 :14identités natives,42associations,trois tâches,24sites/48liens. SOURCE actuel20relations/14identités ; HUD deux liens natifs :définition INIBIN et CharScript client,métadonnée sans corps serveur. Copies historiques exactes sur E,origines F-work/D inertes. Métadonnées/font/INIBIN/Lua/preloads inchangés non relus sur D. Les33OBS hors Leblanc copiées par le premier filtre SOURCE(51241266octets) restent archivées,inertes et exclues des preuves sémantiques ; leur copie n’est pas un audit de ces champions.

Passive1LuaName=LeblancPassive,icône LeblancMirrorImage.dds,six champs de niveau absents,sans défaut inventé. Description4218 et buff2198 :sous40%santé,invisible1seconde,clone sans dégâts jusqu’à8secondes,recharge60secondes,Alt+clic droit. Disponibilité initiale,égalité au seuil et politique serveur ne sont pas établies par le texte seul.

Cooldown2199 s’intitule Schism,ressource LeblancPassiveCooldown,icône LeblancMirrorImage_Charging.dds. BuffName=LeblancNoxianCruelty conservé ; passive Nondispellable et cooldown NonDispellable ont une casse différente,non normalisée,effet historique inconnu. Texte NightmareBot du même font non adopté comme passif ordinaire.

Six Lua entièrement parsés,aucun enfant,six initialisations littérales ; CharScript,MIFull,MIStealth vides,MIApplicator déclare persistance. Persistance après mort et non-dissipation restent des métadonnées,sans callbacks serveur de clone/furtivité/contrôle qualifiés. Quatre preloads :Passive→Applicator/cooldown,Applicator→teinte/MIStealth/MIFull/cooldown,MIFull→effets image/mort/root ; pas exécution démontrée. Deux buffs liés,huit références communautaires secondaires,CharScript communautaire vide. Six candidats absents bornés :DDF,CharScript sous Scripts,Passive global,trois INIBIN MI ; Lua/preloads présents reconnus.

Inventaire exact avant payload :trois chemins/9968octets. Deux lectures nécessaires,7096octets :

| Chemin lu | Octets | En-tête observé | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/Leblanc/HUD/Icons2D/LeblancMirrorImage.dds | 2872 | 64×64, DXT1, mip brut 7 | 0.0.0.153 |
| DATA/Spells/Icons2D/LeblancMirrorImage_Charging.dds | 4224 | 64×64, DXT5, mip brut 1 | 0.0.0.107 |

Deux contenus distincts,tailles/MD5/membership vérifiés. Normale globale2872octets non lue,MD5 de manifeste identique à la normale personnage ; pas comparaison SHA/pixels de cette candidate. Aucun alias,lookup,priorité,rang/état ou rendu qualifié. Localisation reliée au témoin natif/mirror Ahri,sans font D relu ; locale runtime ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new. SOURCE6sites/3fichiers,catalogue et lecteurs INIBIN/Lua. V59124sites/12fichiers,plus2lecteurs,union14fichiers. Dégâts/santé,seuils,régénération,vision/projections,boutique,mouvement et refus sont inspectés. QWER Leblanc non admis dans les corps sélectionnés ; aucun producteur spécifique établi,sans absence globale déduite.

Création/lookup par propriétaire,ordres et durée de Tibbers sont des consommateurs existants examinés comme contexte statique ; aucun appel du clone Mirror Image exercé ou implémentation transférée. Chemin Alt+clic droit et payload autoritaire restent distincts de la mention native. Provider/StartupHud,barres,QWER-D/F,EzrealBuff0/BuffStack0 et F3/Annie restent des acquis ; 4enregistrements QWER,0non résolus,ne constituent pas ce passif. Aucune liaison Leblanc icônes/texte/rang/disponibilité/clone/recharge spécifique établie. Lifecycle/départ/fin/cleanup restent statiques.

## 4. Attendu, observé et contrôles

Attendu :déclenchement admissible sous40%,furtivité/clone puis états HUD qualifiés. Observé :aucune invisibilité ni clone dans les représentations exposées,original visible/projeté,recharge non armée. Sources95/95,relecture E195/195 ; consommateurs56/56,relecture E27/27. 127entrées,106fenêtres,30ancres,23configurations/63chemins matériels contrôlés ; prose dérivée des données. SOURCE :producteurs[1,0],premier arrêt de sérialisation bytes DDS après95contrôles ;script,journal,commande et brouillon partiel archivés avant correction,aucune relecture D. C :collecteurs[1,0],nom MD ICATHIAN hérité corrigé en MIRROR_IMAGE avant résultats,originaux conservés ;premier draft à quote invalide détecté avant exécution conservé séparément. Gel C après fin réelle du driver,puis sealer séparé,tous59pins rehashés. Deux labels ManaBarrier hérités de fenêtres Snapshot/Effects demeurent du contexte générique,pas des états Mirror Image ;lignes et conclusions Leblanc exactes. Logs binaires enveloppés et transcriptions exploratoires distingués.

V591 qualifié :deux parties Map10 publiques,base516HP/Ruby1028+150HP=666.24projectiles Annie→Leblanc(11+13),quatre franchissements avant≥40%/après<40%. Égalité exacte non exercée. Attentes1810+241ticks par cas,total4102frames contiguës :original visible/enemyprojected,noLeblancUnit/noOwnedPet,aucun NPC ciblant les participants,deux joueurs vivants,pas mort/fin. Niveau1 Leblanc contrôlé par state ; Annie niveau1 observée dans52snapshots complets,XP finale0 des deux,pas assertion de son niveau à chaque state.

Repères29/30/31,239/240/241,1799/1800/1801/1810 encadrent1/8/60secondes à30ticks/s locaux,sans qualifier l’horloge historique. Aucun déclenchement/CD armé :la minute d’attente ne qualifie pas une recharge ni la durée/contrôle/dégâts du clone.54refus avec flags snapshot_unchanged ; paires before/after absentes,égalité non recalculable indépendamment. Recherche d’entités limitée aux unités de définition Leblanc et familiers possédés exposés,pas toutes représentations historiques possibles.

Deux RUN historiques101,BUILD0,avaient invalidé l’hypothèse régénération seule en voie basse,base/phase0/offset1778,tick3774→3775. Trois Red_Minion_Wizard38/42/46 visaient21,émetteur de l’impact exact inconnu. Binaires/journaux conservés,inertes. Reprise qualifiée :mêmes durées/quatre franchissements,zone centrale,z7000 demandé mais6934,240234375/6934,07861328125 atteints,guardNPC. Binaire qualifié6124544octets,SHA`560aa21ef402b3388f3b6f015e94b0f23099402b0be9556cf15c958cd271a401`,BUILD/RUN0 hérités,sans équivalence courante.

Parenthèse du générateur d’inspection corrigée avant création :récit MD49 seulement,ancien script/exception non pinnés ; inspection finale0 identifiée. Aucun nouveau jeu/build/VM/REA/transport réseau/GPU/audio/rendu ; anciennes preuves conservées,sans recovery/nettoyage/copie de bases.

## 5. Écarts et inconnues

Seuil exact,létal,ordre mitigation/boucliers,changementsHPmax,disponibilité initiale,simultanéité,proc unique et réarmement restent ouverts. Furtivité/interruption/révélation/audiences,identité/position/santé/statistiques/apparence/collision/vision du clone,Alt+ordres/IA/attaques sans dégâts,expiration/mort/récompenses/lifecycle et cleanup non qualifiés. Métadonnées anciennes/casse,rendu/skins/audio/réseau et acceptation humaine restent distincts. Aucun modèle manquant déduit du défaut de gameplay.

## 6. Correction et reprise

Réutiliser `CH-Leblanc-PASSIF-PRESENTATION-HUD` et ses dépendances SOURCE/NETWORK/SIMULATION. Qualifier seuil/initialisation/cooldown/ordre,sans fabriquer callbacks à partir des littéraux. Établir furtivité1s,clone contrôlable sans dégâts8s maximum,ownership/lifetime/cleanup,règles d’ordres et recharge réellement armée60s,distincts de Tibbers. Relier icônes normale/recharge,texte,rang/état/audience et retrait des données absentes,invalides,périmées ou non autorisées au HUD. Vérifier niveaux,causes de dégâts,frontières temps/seuil,létal,révélateurs,autres clones,lifecycle et absence d’entités résiduelles. Reprise sur primaire,mapping,producteur,consommateur ou dérive précise ; aucun replay inchangé.

## 7. Livraison et décision

Preuves :`E:/mapslol3v3/audit_sys01202_leblanc_passive_hud_20261104`,sourceproof/current_consumer_review,manifestes/scripts/commandes/journaux/archives,result/finalpeer. f9 et804f69 hérités byte-exacts de V1235,tous inputs/archives inclus. Publication :rapport,ajouts CURRENT/HANDOFF,deux sauvegardes exactes,sept protégés avant/après/readback.

Une clôture d’audit borné seulement,zéro tâche complète,inconnue,fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ; goal/Plan/UI/bases/registres/code/assets inchangés.
