# SYS-01.2-02 — Rengar : Unseen Predator et HUD, V1263

4 novembre 2026. Unité `AUD-SYS-01.2-02-RENGAR-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre. Implémentation, vérification du gameplay et acceptation humaine restent distinctes.

## 1. Exigence et périmètre

`CH-Rengar-PASSIF-PRESENTATION-HUD`, `OLF-b541b80f-cb5e-5c17-a397-9c177c3ef991` : relier icône, texte, rang applicable, saut et Férocité aux consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-f248e513-0411-5205-9537-97270a87e4ed` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE conservés. Phase D06, lot D06-CH-Rengar et prérequis consultés, sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315, EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/rengar-passive-unseen-predator-links-v619.json`,3809762octets,SHA `e13845fbd27790c4868045258740fbd9b6d1eb038ded11048aebbfb5ef8be369`,UTC documentaire 2026-10-26T14:29:52.209558+00:00,sans attribution à une heure d’exécution.

HUD :deux sources/un catalogue. SOURCE :150relations/145identités,six sites/trois fichiers. V619 :145sources/435associations,28sites/56liens/14fichiers. Union :16fichiers/34ancres. Aucun ID SOURCE supplémentaire. Métadonnées réutilisées sans réouverture D :37INIBIN,66Lua,40preloads,DDF et font.

La définition lie RengarPassive/Rengar_Passive.dds ; le buff examiné est RengarNewPassive, sans BuffTextureName déclaré. Leur priorité effective reste inconnue. Description4266 :saut sur attaque depuis buisson/furtivité,un point de Férocité par capacité sur ennemi,seuil5. Buff2538 précise disponibilité immédiate du renforcement,remise0 après utilisation et portée f1. f1,événements/cibles/ordre restent ouverts. PARType=Ferocity,BaseMP chaîne5.0,PARStart/PARMax absents :valeur initiale native non établie.

Ancien texte Warwick/soins et Passive1=1/niveaux1/6/11/16 non adoptés. CharScript114octets déclare seulement Wolfman_InnerHunger.dds,sans callback ; Managers vides. Ce n’est pas une mécanique Warwick.66Lua :57littéraux/neuf limites NEWTABLE.25références BuffData :18résolutions/17clés distinctes,sept absences exactes. Deux références Hatred renvoient à VolibearHatredZilean,résolution sans acceptation sémantique. DDF16lignes :Q/f1 @dynamic.attackdamage×1,R/f1 @text5,aucune portée passive déduite.

Cinq candidats absents et Lua RengarPassive absent au chemin recensé ne prouvent pas un manque global. NewPassive,Passive,trophées/Bonetooth et Dominion restent séparés.42références communautaires comparatives :Q frappe immédiate,W soin fixe10%PVmax sans défenses qualifiées,E root inconditionnel,R délégation ;aucune branche de Férocité dans les quatre fichiers lus. Aucun serveur original prouvé.

Trois DDS nécessaires,11360octets/deux contenus,64×64/mip7 :

- Rengar_Passive.dds :Characters/Rengar/HUD/Icons2D membre0.0.0.163 et Spells/Icons2D membre0.0.0.116 ;2872octets/DXT1,SHAff040fafd72fdcf6f9c9ffcc40304683e467bba068d69acabf69ec69577041e8.
- RengarPassive.dds sans soulignement :Spells/Icons2D membre0.0.0.116 ;5616octets/DXT5,SHA3fa9eaa4a052ba18ec10991c7a9cfd1e2b0059282fbf20960a792da394fa026e.

Déclarations BuffVisible/Ferocity justifient ces variantes ;priorité/lookup/pixels non qualifiés. Taille/MD5 concordent au manifeste lol_game_client0.0.1.7,sélection E avant trois lectures SOURCE. Aucun DDS Wolfman/Warwick lu. Font miroir inchangé,témoin Ahri réutilisé.

Ferocity courant concorde au PARType natif ;son source_sha256 est celui du JSON communautaire4831octets/SHAae02e8e84538b8dfc716f64d08b5230e4ef0653343723745929276584daab4f3,distinct de l’INIBIN natif1748octets/SHA6bb46f0dada3c0bded8657d30f938f99d66ebdc704a5dfe694a7c46ce03844ed (`resource_provenance.json`).

## 3. Consommateurs actuels

34ancres exactes,16entrées communes et29fichiers code/configuration vérifiés. Aucun producteur Rengar identifié dans ces Rust,sans absence globale revendiquée. Attacks.rs:154–155 utilise portée de définition+rayon cible ;movement.rs:53 calcule vitesse générique+objets ;vision.rs:45/48/79 fournit drapeaux/LOS/visibilité. Aucune branche de saut du champion identifiée dans ces routes.

Acquis génériques Ferocity,vision,mouvement et attaques conservés. HUD bars.rs:11 renvoie resource=None hors Mana ;widgets.rs:91 omet MPStat pour Ferocity. Icône cible/saut,compteur/état renforcé et texte spécifique non qualifiés.

## 4. Attendu et observé

Attendu :saut quand les conditions natives sont réunies,Férocité produite/consommée et HUD attribuable. V619 :quatre cas buisson/ouvert×sans/avec Bottes1001. Cible visible à400 ;drapeau initial buisson1 ou terrain0. Douze mêlées,108refus,244ticks d’attente,huit trajets aboutis sans reprise.

464paires brutes de positions avant/après recalculées. Chaque pas reste≤vitesse/30+0,003 :345sans bottes,370avec. Avant premier impact :20pas pleins/230unités sans bottes ;18pas/environ221,99414avec. Somme76pas pleins sur les quatre cas ;maxpas11,5/12,33301. Marche ordinaire observée depuis buisson et terrain ouvert,aucun saut dans ces cas. Comme f1 est inconnu,l’éligibilité historique à400 n’est pas prouvée ;aucune portée inventée ni déficit de saut chiffré.

Les12impacts correspondent à l’AD ordinaire après mitigation actuelle,tolérance0,002. Jauge actuelle5/max5 et attentes61ticks/cas inchangées. Aucun sort Rengar accepté ;génération sur capacité ennemie et dépense renforcée non exercées,ni furtivité. Les attaques ordinaires et une jauge pleine ne testent pas ces déclencheurs.

Positions/visibilité sont des témoins de simulation actuelle,pas des règles serveur historiques. PV cible adjacents non sauvegardés,dégâts dérivés hérités ;refus :flags sans snapshots bruts. Aucune garde NPC universelle. Niveau1,une cible,quatre profils ;rendu/hauteur/collision native non qualifiés.

Historique15fichiers/12056522octets,13ancienshashes concordants/deux identités de reçus nouvelles. Binaire6057472octets/SHAcb828f2396f4682b30f83b233835dc6a0ce6539a5ffbdff19812bf9682849aac,inerte ;BUILD/RUN bruts0,inspection numérique héritée. Contrôles74/74,cohérence séparée63/63,même agent. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

Portée f1,priorité Passive/NewPassive,durée après sortie du buisson,furtivité/cibles/obstacles/interruptions et leap lifecycle ouverts. Génération/caps/renforcement/réinitialisation/initial5,Ferocity HUD et sept bindings manquants non qualifiés. Trophées/Bonetooth/Dominion et QWER distincts ;V564 et deux échecs Nami conservés.

## 6. Corrections et reprise

Réutiliser `CH-Rengar-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-RENGAR-PASSIVE-POLICY-01` :résoudre f1,provider,conditions/événements,initialisation et lifecycle. Fin :contrat4.20 sourcé,sans portée400 présumée native.

`COR-RENGAR-BRUSH-STEALTH-LEAP-01` :intégrer saut au mouvement/attaque. Fin :avant/à/après portée,entrée/sortie buisson,furtivité,cible visible/refusée,obstacles/hauteur/annulation et impact vérifiés.

`COR-RENGAR-FEROCITY-EMPOWER-01` :capacités sur ennemi,gain1,seuil5,disponibilité immédiate/reset0. Fin :vrais sorts acceptés/refusés,0–5,multicibles/échecs/interruptions/mort vérifiés,en conservant les acquis génériques.

`COR-RENGAR-PASSIVE-HUD-BINDINGS-01` :résoudre sept références,priorité d’icônes,jauge/texte/état prêt et transport. Fin :liaisons sourcées,transitions0/4/5 et saut attribuables,sans alias implicite. Reprendre sur preuve nouvelle,mapping/callsite,dérive ou autorisation d’implémenter ;aucun correctif fonctionnel ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_rengar_passive_hud_20261104` ;evidence_review/coherence_review,DDS/histoire,resource_provenance.json,phase_package_prerequisites.json et journaux. Captures avant assertions,hook7/7 réutilisé ;limites Python/contexte/inventaire final/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement ;sauvegardes et sept protégés vérifiés avant/après publication. Une unité d’audit bornée close ;zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif ;goal/Plan/UI/bases/registres/produit inchangés.
