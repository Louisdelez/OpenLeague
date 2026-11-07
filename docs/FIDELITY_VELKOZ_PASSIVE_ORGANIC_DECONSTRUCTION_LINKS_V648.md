# SYS-01.2-02 — Vel’Koz / Organic Deconstruction, V648

Date UTC 2026-10-27T00:48:28.785961+00:00. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ;fuseau/déploiement non établis. Catalogue4.20.1 distinct.

V648 Velkoz / Organic Deconstruction : 19 sources natives, 57 associations, 23 points actuels et 46 liens de frontière. Le texte natif décrit trois marques de sorts, des dégâts vrais f1 non résolus et sept secondes sans touche ; les attaques ordinaires rafraîchissent seulement. Six attaques publiques aux niveaux 1/18 restent physiques, sans bonus ; elles ne testent pas l’activation par sorts, qui sont refusés. Témoin Embrasement distinct : cinq applications de 14 dégâts vrais, disparition au tick relatif150. 58 refus sans mutation, 6532 ticks et deux apports XP serveur explicites. BUILD/RUN 0, 1158 entrées conservées. Aucun code de jeu modifié, aucune case ou question fermée.

## Résultat intégré et prérequis

CH-Velkoz-PASSIF-SOURCE, CH-Velkoz-PASSIF-SIMULATION-CONTRAT et CH-Velkoz-PASSIF-SIMULATION reçoivent sources,preuves et instructions copiables. SYS-01.2-02 reçoit la synthèse. Dix-neuf sources natives donnent57associations ;23points actuels donnent46liens sur les deux fiches de simulation. Ce sont des frontières de commandes/attaques/dégâts ou un témoin distinct,pas un producteur de marques Velkoz.

Les prérequis des phases,lots et tâches sont conservés dans le reçu. Trois questions propres et quatre dépendances restent inchangées ;aucune n’est déclarée achevée. Les statuts,critères et acceptations antérieurs sont conservés. Les registres d’inconnues,d’identifiants et de hiérarchie restent identiques octet par octet.

## Sources natives et références communautaires

La découverte vérifie82ressources natives :19INIBIN,36Lua,25preloads,unDDF et le fontconfig. Six candidats hors périmètre sont exclus. Les19références communautaires JSON sont identifiées séparément. Toutes ces sources sont comparées au registre par taille/SHA ;l’appartenance native au manifeste RADS sélectionné est vérifiée.

| Ressource reliée | Octets | SHA-256 |
|---|---:|---|
| Velkoz.inibin | 1188 | 2ab18c8d2237c5ade5700d526ecac10eb1380ec7f4267f5e9b4eac0fa9fa779e |
| Velkoz.ddf | 1620 | 0ec4f7534b47bbdb645cb4c4c14c2ea50bab839a927d6bf4ee8b1ba82080515a |
| CharScriptVelkoz.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| CharScriptVelkoz.preload | 585 | 8a5434c63d1006c4141ac52eb775fd8f618bae8b234ef406ee9d4f46935c0147 |
| VelkozPassive.inibin | 45 | 57cf740f848ab4568c038ec0324aa6b7a4633d399f8bff4d5f11d209e671aad5 |
| VelkozPassive.luaobj | 171 | 16ab20c58e5701ad9755c3f742068e07a8c2a0af93312e2223e6cba3354acc31 |
| VelkozResearchApply.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| VelkozResearchApply.preload | 96 | 52df483a0f78578aba16b52350fdc2e01ebad194b450fa46b51107874d6ceddb |
| VelkozResearchStack.inibin | 51 | a6636a2cf807fc85df7e9d6882c3f41b32ec96b943b78820012bea70668657bb |
| VelkozResearchStack.luaobj | 156 | e715c0d49e727b400a17ae45a23088114f4ff7ffb79c6362f2a34fc96b91331f |
| VelkozResearchStack.preload | 98 | c878da5331214f47a74696d353aadc1e1eeead726c557ed246dfe5ba271736a2 |
| VelkozResearchProc.inibin | 128 | 8a1539b53c6c6a689da43a75cfb78b2bd4b68cc591874883a57ff1eedc7ba4bf |
| VelkozResearchProc.luaobj | 154 | 57debfd7b7842be38eaf970787583d21866b766121329a79a30e7d2ed717f72f |
| VelkozResearchProc.preload | 196 | a59639cd3ac5039b89ee411c6e69d66615eccffeb70f3796423bdc832f1b5125 |
| VelkozResearchTracker.luaobj | 90 | 0b936e4b235f178501c4b0a41735e6e80944f715b24b4a523e28570f8020d45a |
| VelkozRResearchBuildup.luaobj | 56 | 7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0 |
| VelkozRResearchBuildup.preload | 96 | e62263825c7a559e8e3db5a7f73068c762fe7ce4c914c233eb55a1cf1d21b4d3 |
| VelkozBasicAttack.inibin | 972 | 42ae491385c322ab23a742d96a960b2a9a05f85e3fcd1b0fe12f1e0cba0d6139 |
| fontconfig_en_GB.txt | 2220957 | 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3 |

Velkoz.inibin lie Passive1LuaName=VelkozPassive, l’icône Velkoz_Passive.dds et PassLev1Desc1=game_character_passiveDescription_Velkoz. Passive1Desc,Passive1 et Passive1Level1..6 sont absents,pas zéro. La description précise que les sorts construisent les marques et que la troisième touche de sort les consomme pour infliger des dégâts vrais.

VelkozPassive.inibin lie exactement game_buff_tooltip_VelkozPassive,ligne2868 :dégâts vrais @f1@,disparition après7secondes sans touche,attaques de base qui rafraîchissent sans ajouter de marques. Le tooltip de cible ResearchStack,ligne2871,emploie plus vaguement attacks. Ce mot seul n’est pas promu comme déclenchement sur trois attaques ordinaires. **f1 et sa variation avec le niveau restent inconnus** ;les36entrées DDF n’ont ni lien ni coefficient.

Les chunks CharScriptVelkoz, ResearchApply et RResearchBuildup sont vides. Passive déclare BuffName=VelkozPassive, texture2.dds et PersistsThroughDeath=true. Stack déclare VelkozResearchStack/Velkoz_Passive.dds ;Proc déclare VelkozResearchProc/VelkozPassive.dds ;Tracker déclare PersistsThroughDeath=true. Ce sont des littéraux client,pas un état serveur ou une qualification du cycle de vie. ResearchProc.inibin n’a pas de tooltip récupéré ni de champs nommés de sort renseignés dans la sélection inspectée.

Les preloads relient Apply→Stack→Tracker et RResearchBuildup→Apply ;ils ne donnent ni fréquence de R ni règles de collision/cumul. Proc référence les particules researchloop et researchproc_tar. Le CharScript référence aussi le faisceau d’attaque. Aucun rendu n’est validé. Les36chunks n’ont pas de fonctions enfants ;12limites NEWTABLE du lecteur restent documentées. Aucun serveur historique n’est exécuté.

Les répertoires communautaires LeagueSandbox-Scripts/Characters/Velkoz et Buffs/Velkoz sont absents. Les19JSON retrouvés ne constituent pas des callbacks serveur. Les recherches bornées dans le Rust et les scripts C# existants ne trouvent pas de producteur Velkoz/Research dans leur périmètre ;elles ne prouvent pas une absence universelle dans toutes les archives.

## Consommateurs actuels

| Point courant | Ancre vérifiée |
|---|---|
| crates/core/src/lib.rs:533 | pub fn join( |
| crates/core/src/summoners.rs:32 | pub fn join_with_summoners( |
| crates/core/src/lib.rs:598 | pub fn command( |
| crates/core/src/lib.rs:685 | pub fn advance( |
| crates/core/src/lib.rs:744 | pub fn snapshot( |
| crates/core/src/progression.rs:68 | pub fn stats( |
| crates/core/src/progression.rs:150 | pub fn learn( |
| crates/core/src/progression.rs:159 | pub fn next_rank( |
| crates/core/src/progression.rs:131 | pub fn award_experience( |
| crates/core/src/spells.rs:101 | pub fn cast( |
| crates/core/src/annie_w.rs:29 | pub fn cast_at( |
| crates/core/src/attacks.rs:141 | fn attack_target_valid( |
| crates/core/src/attacks.rs:157 | pub(crate) fn advance_attacks( |
| crates/core/src/attacks.rs:26 | pub fn windup_ticks( |
| crates/core/src/lifesteal.rs:4 | pub(crate) fn basic_attack_hit( |
| crates/core/src/damage.rs:53 | pub fn apply_damage( |
| crates/core/src/damage.rs:38 | pub fn mitigate( |
| crates/core/src/summoner_ignite.rs:14 | pub(crate) fn cast_ignite( |
| crates/core/src/summoner_ignite.rs:25 | fn apply_ignite_tick( |
| crates/core/src/summoner_ignite.rs:34 | pub(crate) fn advance_ignite( |
| crates/core/src/regeneration.rs:10 | pub fn regeneration_rates( |
| crates/core/src/regeneration.rs:32 | pub(crate) fn advance_regeneration( |
| crates/core/src/vision.rs:79 | pub fn visible_to( |

next_rank autorise actuellement Garen,Annie,Trundle et Ezreal ;Velkoz reçoit champion skill progression not implemented. Les lancements restent refusés. advance_attacks, basic_attack_hit et apply_damage fournissent les attaques ordinaires physiques. Le profil courant Velkoz utilise MissileSpeed8000,dérivé du BasicAttack.inibin dont l’empreinte est vérifiée. Cela ne qualifie pas un faisceau visuel historique. Le chemin DamageKind::True existe dans mitigate/apply_damage et est exercé séparément par Embrasement.

La première inspection a échoué sur une hypothèse d’enregistrement du fichier native_summoners_420.json. Aucun résultat n’a été publié. Ce catalogue intervient dans les tests du module Ignite ;le moteur non-test charge ignite_rules.json. La version corrigée relie les huit ressources runtime réellement sélectionnées et conserve le catalogue test comme contexte épinglé,ainsi que le script initial et son erreur. Une recherche exploratoire PowerShell avec le glob combat*.rs passé comme chemin a aussi été rejetée ;la recherche suivante utilise le dossier et le filtre -g '*.rs'. Aucun code de jeu n’a été modifié pour ces corrections. Le commentaire d’en-tête du pilote Python exécuté conserve par erreur la mention direction/movement-speed du lot précédent. Le corps Rust,les commandes,le schéma et les observations épinglés sont bien ceux des attaques ordinaires Velkoz et du témoin Embrasement ;aucun résultat de direction ou vitesse n’est revendiqué. Le pilote exécuté est conservé sans réécriture.

## Diagnostic exécuté et portée des résultats

Deux simulations niveaux1/18 utilisent la navigation Map10 réelle et des déplacements publics pour approcher une Annie initialement non marquée. Deux appels serveur explicites award_experience(100000) préparent les deux joueurs du cas niveau18 ;ce n’est pas une progression naturelle. Aucune injection directe de position,PV,rang,marque ou horloge. Les quatre trajets de préparation de ces cas n’exigent aucune réémission.

| Cas | Attendu du diagnostic | Observé |
|---|---|---|
| Trois attaques ordinaires par niveau | dégâts physiques sans ajout artificiel de passif | six impacts physiques avec projectile témoin,aucun bonus |
| Mesure des impacts | armure courante et régénération comptabilisées | écart inférieur à0,002 entre attendu et observé |
| Après dernier impact,cible non marquée | surveiller les pertes inexpliquées | aucune pendant211ticks dans chaque cas |
| Learn/Cast/CastAt,quatre slots,avant/après | refus sans mutation | tous refusés aux niveaux1/18 |
| Embrasement distinct | vrai chemin de dégâts vrais périodiques | cinq applications de14 aux ticks0/30/60/90/120 |
| Fin du témoin | disparition du statut | absent à partir du tick150 |

**Les attaques ordinaires ne constituent pas un test positif de génération des marques.** Leur absence de dégâts supplémentaires est compatible avec le texte natif. Le diagnostic ne crée aucune marque et ne qualifie donc ni leur rafraîchissement,ni l’expiration historique à7secondes,ni le troisième sort. Les211ticks ne deviennent pas une preuve de durée d’un statut absent.

Les58refus conservent les snapshots :54commandes des deux cas Velkoz(inconnus/cibles/slots/apprentissages/lancements) et4commandes du témoin Embrasement(cibles invalides/délai). Les attaques sont arrêtées publiquement après trois impacts. Embrasement est un contrôle distinct :ses cinq applications,la régénération réduite et sa disparition sont mesurées ;cela ne qualifie pas f1 ni les marques Velkoz. La cadence du serveur historique reste distincte de ce témoin reconstruit.

Total6532ticks :2230 et2210pour les cas Velkoz,2092pour le témoin. Deux apports XP explicites,six impacts physiques,aucune mort ou victoire provoquée. Le témoin effectue également ses déplacements publics ;aucune position n’est forcée.

Binaire :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-velkoz-organic-deconstruction-probe.exe ;6077952octets ;SHA-256 77a57a995bc4dd9ff8772f95d6e02366eb5e72f1864465ebc4241b91597bff50. Le compilateur identifie F:/OpenLeague/crates/core/src/lib.rs avec profile.test=false. Dépendances/checksums alignés sur le Cargo.lock racine ;1158 entrées moteur/ressources conservées avant/après. Aucun code de jeu ni asset modifié.

## Vérifications de livraison

| Étape | Code | SHA-256 du journal |
|---|---:|---|
| BUILD | 0 | 76a5854f8c85c21ae95b9e892d5745a74ff518814ae5141005d7b7667a81c2b2 |
| RUN | 0 | 99c00082c8934c98ae0883429b9c707cd181783ced5b9bd5e565712ee88c28d8 |
| prepare | 0 | 770ec746fbb3471c7805d9a4fd9ef08098341236530194240b81870a76810e62 |
| check | 0 | 1441372c05cc6569e53ec220d1c8e342e373183952d2b8a16965d5eb2f754043 |
| publish | 0 | 3557ba738f94136e92668329db0e7b4359a1316b388547ab31f4347583b3f00b |
| audit | 0 | 2fa6d7b824ac4afab57bf7677633d162c2f307c7ca4913c7b75806b2083b934a |

Reprise,découverte,BUILD/RUN et inspection corrigée :code0. L’inspection initiale s’est terminée en erreur sur le catalogue test ;elle est conservée. Les60associations falsifiées et quatre graphes invalides sont refusés. Le contrôle réel Store.task/copy_text relit les instructions complètes des quatre destinataires et résout leurs sources,questions et dépendances. Trois fragments courts changent,42212restent identiques.

Les deux bases conservent42603autres lignes de catalogue,42607états manuels et23historiques ;quatre destinataires sont actualisés. Intégrité et synchronisation Store idempotente vérifiées. Revue indépendante :5150ancres/empreintes de consommateurs exactes,99267sources enregistrées. Ce contrôle ne rehache pas toutes les sources historiques et ne mesure pas l’achèvement du jeu.

## Fichiers et preuves

Registres modifiés :docs/completion_tasks_2026-10-20.json, docs/fidelity_requirement_trace_4_20.json, docs/fidelity_sources_4_20.json. Reçu :docs/reference_requirement_trace_sources/velkoz-passive-organic-deconstruction-links-v648.json. Vérification :docs/fidelity_velkoz_passive_organic_deconstruction_links_v648.json. Bases :runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3. Couverture/reprise :docs/coverage.json, docs/completion_plan.json, docs/resume_checkpoint.json, docs/ai/CURRENT.md et docs/ai/HANDOFF.md.

Découverte :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision648_Velkoz_discovery\OBSERVATIONS.json. Diagnostic :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision648_Velkoz_passive_probe\OBSERVATIONS.json. Inspection :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20/revision648_Velkoz_inspection_runtime_inputs/OBSERVATIONS.json. Audit :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision648_Velkoz/DELIVERY_AUDIT.json. Revue :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision649_trace_review\REVIEW.json. Scripts et journaux conservés sousF:\OpenLeague-work\Requirements_registry_4_20_2026-10-20,y compris les échecs et brouillons antérieurs.

Neuf copies privées de validation archivées en gzip après audit et comparaison SHA décompressée ;gain logique2443115787octets. Reçu :F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision648_Velkoz/snapshot-archives/VERIFIED.json. Sources enregistrées,preuves,binaires et bases actives restent intacts. Restauration explicite par revision648_restore_validation_snapshots.py,non exécutée après archivage.

## Manques et prochaine action

Restent ouverts :f1 et variation par niveau,producteur de marques,règles par sort/cible,touches multiples et R,consommation au troisième impact,rafraîchissement par attaque,durée7secondes et frontières,marques par lanceur,cumuls,boucliers/invulnérabilité,mort/retour/déconnexion,réplication,HUD,icônes,particules,animation et audio. Aucune case ni question n’est fermée automatiquement ;ni Velkoz ni le jeu ne sont déclarés terminés.

Continuer SYS-01.2-02 depuis revision649_trace_review/REVIEW.json. V648 Velkoz publié et audité :19sources natives,57associations,23points actuels/46liens. Six attaques ordinaires physiques niveaux1/18 sur cible non marquée ;sorts Learn/Cast/CastAt refusés,58refus,6532ticks,deux apports XP explicites. Embrasement distinct5x14dégâts vrais aux ticks0/30/60/90/120,disparition150. f1 et producteur de marques inconnus ;rafraîchissement et expiration7s non qualifiés. Ne pas confondre absence de bonus sur attaques ordinaires avec preuve d’absence du passif. Première inspection sur catalogue test non enregistré conservée ;consommateur runtime corrigé vers ignite_rules.json. V649 Vi PASSIF Blast Shield :découverte terminée,114sources natives vérifiées,35références communautaires,quatre exclusions. Texte du marqueur :10%PVmax pendant3secondes après touche de compétence ;f2/f3 et cooldown restent à qualifier. Alias personnage ViPassiveMarker,PassLev1Desc1 absent ;ViPassive décrit Rev Up avec icône Caitlyn et Marker emploie MonkeyKingStoneSkin. CharScripts natif et C# vides. Contrat encore au chargeur partagé :qualifier sources et consommateurs du bouclier puis exécuter le diagnostic,sans promouvoir des dégâts génériques comme touche de sort. Découverte conservée dans revision649_Vi_discovery/OBSERVATIONS.json ;aucun test moteur V649 exécuté. Snapshots V648 archivés/restaurables explicitement par revision648_restore_validation_snapshots.py. Goal actif.
