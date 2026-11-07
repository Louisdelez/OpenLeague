# SYS-01.2-02 — Renekton : Reign of Anger et HUD, V1262

4 novembre 2026. Unité `AUD-SYS-01.2-02-RENEKTON-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre. Implémentation, vérification du gameplay et acceptation humaine restent distinctes.

## 1. Exigence et périmètre

`CH-Renekton-PASSIF-PRESENTATION-HUD`, `OLF-270d9a75-8eac-5111-b9b8-cd0fff168d19` : relier icône, texte, rang applicable, Furie et état renforcé aux consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-0ffb43d6-de96-5ee4-bc86-282169f283c5` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE conservés. Phase D06, lot D06-CH-Renekton et prérequis consultés, sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts ;112priorités Renekton antérieures conservées.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/renekton-passive-reign-of-anger-links-v618.json`,2482618octets,SHA `8aafd895c1a6c93607108455d2babc4d2f00c1ace4b6cc75f0ee8fe7ca42f56f`, UTC documentaire 2026-10-26T14:11:09.129047+00:00, sans attribution à une heure d’exécution.

HUD : deux sources/un catalogue. SOURCE :65relations/59identités,six sites/trois fichiers. V618 :59sources/177associations,24sites/48liens/12fichiers. Union :14fichiers/30ancres. Aucun ID SOURCE supplémentaire. Métadonnées réutilisées sans réouverture D :18INIBIN,25Lua,14preloads,DDF et font.

Définition/buff :RenektonPredator et Renekton_Predator.dds. PARType=Rage,BaseMP est la chaîne100.0,BaseStaticMPRegen=0 ; PARStart/PARMax absents. Cela ne fixe pas la valeur initiale native. Buff2531 décrit gain5 par attaque,seuil50 et dépense50,perte5 toutes les2s hors combat,gains+50% sous50%PV. Description4265 confirme gains/renforcement/faible vie. Ancien texte bonus dégâts contre unités sous50% et mana40/60/80% non adoptés ; Passive1/six niveaux absents.

RenektonInCombat déclare BuffName RenekthonPredator et Corki_RapidReload.dds. RageReady déclare RenekthonCleaveReady et SpellToggleSlot1.0. Graphies Renekthon,emplacements,priorité/provider et drapeaux de persistance restent non qualifiés. Ces métadonnées ne sont pas des callbacks ni une corruption démontrée.

25Lua :17littéraux/huit limites NEWTABLE ;six BuffData exactement résolus,CharScript natif vide56octets et communautaire vide. DDF12lignes,dont six liaisons AD QWE,ne fournit pas le moteur de Furie. Cinq candidats absents ne prouvent aucune absence globale. 23références communautaires comparatives :Q ADtotal/soins fixes,W frappe immédiate,E cône sans dash,R commentaire/code divergents ; aucune gestion de Furie dans les quatre fichiers lus.

Deux DDS nécessaires,7096octets/deux contenus,64×64 :

- Characters/Renekton/HUD/Icons2D/Renekton_Predator.dds,2872octets,DXT1/mip7,membre0.0.0.248,SHA bc13de0b576f1240fb14a7a461861f97a2b3f97441264234aae8eb4e1a232e50.
- Spells/Icons2D/Corki_RapidReload.dds,4224octets,DXT5/mip1,membre0.0.0.25,SHA9858f3f2ad8518e0c21d0ff4e7fec9799deb3e313910aec10278713c2e108ba1.

Taille/MD5 concordent au manifeste lol_game_client0.0.1.7 ; sélection E avant deux lectures SOURCE. Le chemin partagé Corki est justifié par InCombat ; aucun chemin Characters/Corki lu. Lookup/pixels/variante ouverts. Font miroir inchangé,témoin Ahri réutilisé.

Rage courant concorde au PARType natif,mais son source_sha256 correspond au JSON communautaire7819octets/SHA2869359f1023d4c1eba36ed5a9deaf6b7d0b9e11e4c2d9dda16f5574b027f0eb, distinct de l’INIBIN natif2562octets/SHA5bf20052b327cd11bc1999bea965631f1c4fe2b13cff3e114b9d67faa705e31d (`resource_provenance.json`).

## 3. Consommateurs actuels

30ancres exactes,16entrées communes et28fichiers code/configuration vérifiés. Une occurrence Renekton dans regeneration.rs:93 appartient au test générique Rage ; aucun producteur du passif identifié dans les routes inspectées,sans absence globale revendiquée.

Lib.rs:563 initialise mana depuis def.mana. Lifecycle ne restaure régulièrement que Mana/Energy et remet Rage à0 au respawn ; progression exclut le mana d’objet pour Rage. Acquis génériques conservés. Basic_attack_hit applique dégâts/soin génériques,sans mutation de ressource. Le HUD bars.rs:11 renvoie resource=None hors Mana ; widgets.rs:91 n’insère MPStat que pour Mana. La jauge Rage et son texte ne sont donc pas produits par ces routes.

## 4. Attendu et observé

Attendu :génération/décroissance/renforcement natifs et HUD attribuable. V618 :deux cas base/Saphir1027+200mana,AD58,328,max100. Dix-huit mêlées dont12 depuis0 et six sous50%PV ;50physiques entrants,deux morts/deux respawns,1204ticks d’attente,54refus,six trajets aboutis sans reprise.

Dix-huit paires brutes de ressource source :six attaques au plafond100→100,puis12attaques0→0,dont six avecPV≈40,8–41,7%. Le plafond ne permet pas de mesurer un gain ; depuis0,aucun gain observé. Deux fenêtres301ticks depuis100 restent100 ; deux depuis0 restent0. Absence de décroissance observée depuis100,mais grâce hors combat non qualifiée ; attente au plancher ne teste pas une perte effective.

Deux réapparitions après480ticks chacune rendent0 ; état initial100 observé,sans qualification native de cette différence. Saphir réellement équipé,maximum100 conservé :classification Rage/non-restauration/reset acquis,passif non terminé. Aucun sort Renekton accepté ; seuils/consommation/bonus renforcés non exercés.

50paires brutes PV avant/après recalculées avec régénération actuelle et mitigation/clamp létal ;concordance aux dérivés enregistrés,tolérance0,002. Dégâts sortants ordinaires ;PV cible sortants sans paires adjacentes. Refus :flags sans snapshots bruts. Aucune garde NPC universelle ni qualification complète du soin ;niveau1,deux profils.

Historique15fichiers/14323947octets,13ancienshashes concordants/deux identités de reçus nouvelles. Binaire6095872octets/SHA19b9b86aa8e3dfb8b95c4938510e0f07e4f40a5aa0f4f8a3344a09a9c58d716a,inerte,BUILD/RUN bruts0. Ancienne préparation d’inspecteur arrêtée avant exécution signalée dans V618 ;version qualifiée conservée,aucun rejeu ici. Contrôles54/54,cohérence séparée51/51,même agent. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Événement de gain,cibles/caps/arrondis,combat/grâce,passage sous50%PV,seuil50/dépense,ordre des sorts renforcés,R,initialisation et politique native mort/respawn ouverts. Provider Renekthon/Corki,toggle,affichage Rage/état prêt,provenance sourcehash et transport non qualifiés. QWER/112priorités antérieures distinctes ;V564 et deux échecs Nami conservés.

## 6. Corrections et reprise

Réutiliser `CH-Renekton-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-RENEKTON-FURY-POLICY-01` :qualifier initialisation,événements,cibles,caps/arrondis,grâce et lifecycle. Fin :contrat4.20 sourcé,seuils et horloge explicités,sans mana initial100 imposé comme règle native.

`COR-RENEKTON-FURY-STATE-EMPOWER-01` :implémenter gain5/+50% faible vie,décroissance5/2s,seuil/dépense50. Fin :0/plafond,avant/à/après50,combat/interruptions,sources/cibles,sorts acceptés,mort/respawn vérifiés,en préservant les acquis Rage.

`COR-RENEKTON-FURY-HUD-01` :produire jauge/chiffres,seuil/état prêt,texte/icônes et transport. Fin :0/49/50/100 et transitions attribuables,provider/renforcement refusé/accepté vérifiés. Reprendre sur nouvelle preuve,mapping/callsite,dérive ou autorisation d’implémenter ;aucun correctif fonctionnel ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_renekton_passive_hud_20261104` ;evidence_review/coherence_review,DDS/histoire,resource_provenance.json,phase_package_prerequisites.json et journaux. Captures avant assertions,hook7/7 réutilisé ;limites Python/contexte/inventaire final/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement ;sauvegardes et sept protégés vérifiés avant/après publication. Une unité d’audit bornée close ;zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif ;goal/Plan/UI/bases/registres/produit inchangés.
