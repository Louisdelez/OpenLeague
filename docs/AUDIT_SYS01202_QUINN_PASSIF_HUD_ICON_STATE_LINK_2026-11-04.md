# SYS-01.2-02 — Quinn : Harrier et HUD, V1260

4 novembre 2026. Unité `AUD-SYS-01.2-02-QUINN-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur ce périmètre. Implémentation, vérification du gameplay et acceptation humaine restent distinctes.

## 1. Exigence et périmètre

`CH-Quinn-PASSIF-PRESENTATION-HUD`, `OLF-11e13164-fe68-51dd-83b1-dcd26f1ea099` : relier icône, texte, rang applicable, marquage et bonus physique aux consommateurs actuels. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-1d687aa0-f8f7-5f8a-871a-826906430491` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE conservés. Phase D06, lot D06-CH-Quinn et prérequis consultés, sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Primaire `reference_requirement_trace_sources/quinn-passive-harrier-links-v616.json`, 3022937 octets, SHA `ae8f61a03ad5e26718c2bda74af3ff25ab53205a05ffb2979dcdd2155e8183be`, UTC documentaire 2026-10-26T13:33:58.645847+00:00, sans attribution à une heure d’exécution.

HUD : deux sources/un catalogue. SOURCE : 107 relations/101 identités, six sites/trois fichiers. V616 : 101 sources/303 associations, 24 sites/48 liens/13 fichiers. Union : 15 fichiers/30 ancres. Aucun ID SOURCE supplémentaire. Métadonnées réutilisées sans réouverture D : 32 INIBIN, 44 Lua, 22 preloads, deux DDF et font.

QuinnPassive et Quinn_Passive.dds sont liés par définition/buff. Font 4257 décrit le marquage périodique par Valor, puis le bonus physique de la première attaque sur une cible Vulnerable. Buff 2493 conserve f2+f1 et la durée f3. Ces valeurs, période, sélection, propriétaire et consommation restent inconnus. Cooldown1=28, Effect2=35, Effect3=4 et coefficient0 ne sont pas des mappings démontrés. Ancien Passive1Desc « Attack Speed », Passive1 et six niveaux absents : aucune progression inventée.

QuinnPassiveAmmo lie Quinn_W.dds et Heightened Senses ; priorité OnPreDamage=3/ordre d’expiration sont des métadonnées, pas des callbacks. 44 Lua : 30 littéraux/14 limites NEWTABLE ; 11 références BuffData, huit résolutions/sept clés distinctes, trois références manquantes : QuinnR deux fois, QuinnWPassive. Aucune réécriture d’alias. QuinnValorQ renvoie à VolibearE, sans adoption de sa mécanique. CharScript natif vide56octets et communautaire vide.

DDF principal : 60 lignes dont 40 Khazix ; en_us : 28 lignes. Leur membership core vient de V616, sans rejeu. Seul lien non vide : KhazixW/f1 bonusattackdamage×0,6, sans formule Harrier. Priorité de locale inconnue. Quatre candidats absents, QuinnValor.inibin présent ; aucune absence globale/corruption déduite. Valor reprend le passif mais définit mêlée125 contre distance525, sans transformation qualifiée.

37 références communautaires restent comparatives : Q ADtotal contre texte bonusAD, E sans bond/retour/marquage qualifiés, W/R délèguent des buffs. Ni serveur original ni gameplay actuel prouvés par ces scripts.

Deux DDS nécessaires dans Characters/Quinn/HUD/Icons2D, membre0.0.0.150, 2872octets chacun, 64×64 DXT1/mip7 :

- Quinn_Passive.dds : SHA630de486ff74d8987a0b61a603204efecc4c1189df87d355f4d27d6bf17fdf31.
- Quinn_W.dds : SHAcdfdcb4c5a69db694e4ef18450ea94558b6c6c8eef02b2627c86965dac2f5783.

Taille/MD5 concordent au manifeste lol_game_client0.0.1.7 ; sélection E avant deux lectures SOURCE, 5744octets/deux contenus. Aucun chemin partagé trouvé par cette recherche. Lookup/pixels/variante ouverts. Font miroir inchangé, témoin Ahri réutilisé. Mana courant/PARType natif absent ; source_sha256 communautaire 3974octets/SHA2a6743219a5ec2222a3dfa0298b64943f81d031fffa4dd0e5d039b490ea3bdb0, distinct de l’INIBIN natif1086octets/SHAe016c55ba35221ac9991f18dee5b0a813bb7ec543ea792f0ae540d634176ba05 (`resource_provenance.json`).

## 3. Consommateurs actuels

30 ancres exactes, 16 entrées communes et 29 fichiers code/configuration vérifiés. Aucun hit Quinn/Harrier dans ces Rust, sans absence globale revendiquée. Attacks transmet m.raw à basic_attack_hit ; lifesteal applique les dégâts physiques génériques, puis le soin d’objet éventuel. Aucun producteur de marque/bonus Harrier identifié dans cette route. HUD Mana/MPStat/PV et module Ezreal ne prouvent pas icône, cible marquée, consommation ou état Harrier.

## 4. Attendu et observé

Attendu : marquage périodique attribué, bonus physique de première attaque et HUD cohérents. Hérité V616 : deux cas base/Épée1036+10AD, AD51,04/61,04, AP0 ; 12 projectiles non critiques, 54 refus, quatre trajets aboutis sans reprise, 3604ticks d’attente. Six identifiants de projectile distincts par partie.

Chaque cas : trois attaques, attente901ticks, trois attaques ; attente initiale901 également. Ticks2839/2884/2929 puis3843/3888/3933. Sur armure Annie19,22 du catalogue courant, raw×100/(100+armure) concorde aux attendus/observés, tolérance0,002 : environ42,81161/51,19946. Le +10AD explique l’écart ; aucun bonus supplémentaire observé. Déclencheur périodique non qualifié, aucun sort Quinn accepté, Valor non exercé. 901ticks dépassent le candidat28s sans fixer période ni expiration d’une marque absente.

PV cible adjacents avant/après non sauvegardés ; dégâts dérivés hérités. PV source plafonnés/healing_checked false ne qualifient pas régénération ou soin. Refus : flags sans snapshots bruts ; attentes : PV/attendus, sans âge de marque. Aucune garde NPC universelle. Niveau1, une cible, deux profils.

Historique : 28fichiers/21350280octets ; 23 pins primaires, identité du binaire final issue des observations, quatre reçus BUILD/RUN supplémentaires. Essais301ticks et découverte avant ajout de Valor conservés. Deux binaires6061568octets : initial SHA8306adb2dacff4bc03026ec9f08385550d31954de87ed1efc1452605592c6cc7 ; final SHA323c52ecb31c1db3aa96b769e2c80c48ce7817591f717fcb953c7f9e5c787698. Filtre initial complété pour ce second nom, sans rejeu. BUILD/RUN courts et longs bruts0 ; inspection numérique héritée. Contrôles actuels56/56, cohérence séparée48/48, même agent. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni revue indépendante/humaine.

## 5. Écarts et inconnues

f1/f2/f3, période/sélection/propriété/consommation, marquage Q/E, bénéfice W, formes/Valor, locale, lookup, provenance Mana et transport ouverts. Plusieurs propriétaires/cibles, immunités/boucliers, mort/respawn, interruptions et affichage non qualifiés. Limites V564 et deux échecs Nami conservés.

## 6. Corrections et reprise

Réutiliser `CH-Quinn-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-QUINN-HARRIER-POLICY-01` : résoudre valeurs, période, sélection, propriété, consommation et éligibilité des formes. Fin : contrat4.20 sourcé, sans Cooldown28/35/4 arbitrairement affectés.

`COR-QUINN-HARRIER-BINDINGS-01` : résoudre trois références/deux clés et priorité de locale, sans alias implicite. Fin : liaisons identifiées avec provenance.

`COR-QUINN-HARRIER-ONHIT-HUD-01` : produire/consommer marque et bonus au vrai impact, afficher états/cible/texte et transmettre. Fin : première/seconde attaque, propriétaires/cibles, W/Q/E/Valor, échéances, critiques/boucliers/immunités, mort/respawn/interruptions vérifiés. Reprendre sur nouveau mapping/callsite/artefact serveur, dérive ou autorisation d’implémenter ; aucun correctif fonctionnel ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_quinn_passive_hud_20261104` ; evidence_review/coherence_review, DDS/histoire, resource_provenance.json, phase_package_prerequisites.json et journaux. Captures avant assertions, hook7/7 réutilisé ; limites Python/contexte/inventaire final/TOCTOU déclarées.

Rapport et ajouts CURRENT/HANDOFF uniquement ; sauvegardes et sept protégés vérifiés avant/après publication. Une unité d’audit bornée close ; zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif ; goal/Plan/UI/bases/registres/produit inchangés.
