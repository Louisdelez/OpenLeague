# SYS-01.2-02 — Morgana : Soul Siphon et HUD, V1249

4 novembre 2026. Unité `AUD-SYS-01.2-02-MORGANA-PASSIF-HUD-ICON-STATE-LINK-01` ; audit statique de liaison,aucune implémentation implicite.

## 1. Exigence et périmètre

`CH-Morgana-PASSIF-PRESENTATION-HUD`,`OLF-605c5b36-0a26-5522-9df6-f77aeca75a1b` :icône,texte,rang applicable et état Spell Vamp. Fiche requise a_faire,implémentation/acceptation false,dépendance NETWORK ;inconnue `OLU-67f4a80e-8777-5d3a-8e02-39daa85cda9d` ouverte. Six contrats/inconnues HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE conservés ;phaseD06/lotD06-CH-Morgana/prérequis consultés sans satisfaction revendiquée. Parent PRESENTATION distinct ;goal ouvert.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ;catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/morgana-passive-soul-siphon-links-v605.json`,2049558octets,SHA `dc1b5e98d64e7247652fc72af97985754ee1ff747fc9b4a42b220d812a3f42b6`,UTC documentaire2026-10-26T10:11:36.033738+00:00,pas un horaire d’exécution.

HUD :une relation native(définition),un catalogue,un consommateur. SOURCE38relations/28IDs/6sites/3fichiers ;V60528sources/84associations,28sites/56liens/15fichiers ;union17fichiers/34ancres. Métadonnées/INIBIN/Lua/font D réutilisés sans relecture.

Empathize/FallenAngel_Empathize.dds ;Soul Siphon ligne4412,description4236,tooltip1866 `@f1@% bonus Spell Vamp`. f1,paliers et modificateurs de cibles non résolus. Niveaux et SpellData absents ne valent pas zéro. Ancien texte de régénération des alliés et textes mana40/60/80% conservés sans adoption. Le nom EmpathizeAura ne prouve pas une aura alliée.

CharScript natif non vide :PersistsThroughDeath et NonDispellable,sans callback retrouvé ;CharScript communautaire vide. Aura contient aussi nom/icône/ces indicateurs,qui ne qualifient pas le respawn. Dix Lua :trois littéraux/sept limites NEWTABLE,sans corruption déduite ;sept preloads ne qualifient pas le rendu. Aucun DDF sélectionné,huit chemins candidats absents bornés,18NightmareBot exclus. Quinze références communautaires dont QWER codés,non exécutés ni adoptés comme serveur original. W16timers0,3125s malgré commentaire « single pulse »,rayon275/native280 ;R600/native625. QWER/coefficient AP ne fournissent pas f1.

Inventaire préalable par basename :trois chemins/12672octets/un contenu,DDS lus une fois chacun par SOURCE.

| Chemin | Octets | En-tête | Membre lol_game_client0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/EliseSpiderling/Info/FallenAngel_Empathize.dds | 4224 | DXT5 64×64, mip brut0 | 0.0.0.130 |
| DATA/Characters/Morgana/Info/FallenAngel_Empathize.dds | 4224 | DXT5 64×64, mip brut0 | 0.0.0.40 |
| DATA/Spells/Icons2D/FallenAngel_Empathize.dds | 4224 | DXT5 64×64, mip brut0 | 0.0.0.25 |

Le chemin EliseSpiderling est un alias supplémentaire inspecté,pas un consommateur Morgana ou une règle Elise. SHA commun `a4ba96acc8a9d64e9073b7a253be9a2b7eaeb249e571405c9c301437b7c49586`. Membership/MD5/SHA qualifiés,lookup/variante/pixels ouverts ;mip brut0 n’est pas une corruption démontrée. Font miroir inchangé,témoin Ahri réutilisé.

Registre courant :type Mana,mais PARType natif absent ;ne pas confondre classification actuelle et champ retrouvé. source_sha256 correspond au JSON communautaire8395octets,distinct de l’INIBIN natif2955octets/SHAc99edcae3d71… (`resource_provenance.json`). Historique :17fichiers/15837786octets,15hashes anciens concordants/2identités nouvelles. Quatre artefacts V555 sont conservés sans fusionner ses cas/chiffres avec V605.

## 3. Consommateurs actuels

34ancres actuelles et16entrées communes inchangées vérifiées. Catalogue/initialisation,progression,learn/cast/cast_at,dégâts,attaques,vol de vie et heal audités. Recherche lexicale limitée aux sources épinglées :aucun branchement nommé Morgana/Empathize/SoulSiphon/SpellVamp,ce qui ne prouve pas une absence globale.

`native_hud_bars.rs:9–11` et `native_hud_widgets.rs:91` traitent Mana/MPStat ;Morgana est classée Mana dans le registre courant. Ces chemins et les PV génériques ne fournissent ni f1 ni attribution du soin au passif. Le module de passif Ezreal n’est pas un consommateur Morgana. Aucun HUD Soul Siphon complet établi dans les chemins inspectés ;constat statique,sans capture GPU.

## 4. Attendu et observé

Attendu :dégâts de sorts admissibles produisant un soin conforme à la politique sourcée,puis état/paramètre affiché. Hérité V605 :trois cas base/Tome20AP/Sceptre10AD8% ;neuf attaques sortantes,neuf physiques entrantes,trois AnnieQ,540ticks d’attente,81refus,six trajets. Aucun sort Morgana accepté :déclencheur non exercé ;ni absence ni réussite du Spell Vamp quantifiable.

Les neuf impacts sortants conservent les PV propres immédiatement avant/après. Après soustraction du gain de régénération médian observé dans les attentes(0,03805542PV/tick),soin recalculé0/base et Tome,4,39254761/Sceptre,attendu4,39255142,écart<0,002. Hypothèse bornée :régénération constante,niveau/objets inchangés et PV non plafonnés ;ce n’est pas f1. Les540trames conservent PV/attendu ;les dégâts cible/Q n’ont pas de paire pré-impact adjacente,les refus ont flags/erreurs sans paires brutes. Gardes joueurs/statuts/winner ne prouvent pas l’exclusion universelle des NPC.

Contrôles actuels46/46,relecture séparée44/44,même agent sans revue humaine/agent indépendante revendiquée. Binaire V6056094848octets,SHA `203e6f9527c900647a58ad17edc97e23013e8f420aa4e12eaf1ce3f243e3e32e`,inert ;BUILD/RUN bruts0,inspection numérique non établie. Aucun nouveau build/jeu/VM/REA/réseau/rendu/audio/GPU.

## 5. Écarts et inconnues

f1,paliers,catégories de cibles,zone/périodique,mitigation/absorption/surdégâts,anti-soin/amplification,arrondis/ordre,lifecycle et cumul d’objets ouverts. Contrat communautaire divergent,pas de sorts déclencheurs ni de producteur de soin établi ;icône/texte/paramètre réseau/HUD à qualifier. L’observation de vol de vie ordinaire ne résout aucune de ces inconnues.

## 6. Corrections et reprise

Réutiliser `CH-Morgana-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION :résoudre f1/paliers,qualifier Q/W/R puis conversion dégâts-soin et cibles/interactions/anti-soin/mort/respawn. Publier paramètre/attribution autoritaires et relier icône/texte/HUD ;réseau/rendu/audio/acceptation séparés. Reprendre sur nouvel artefact serveur/mapping/callsite ou dérive,sans valeur moderne inventée.

Méthode `COR-SYS01202-AUDIT-DDS-CHAMPION-PATH-SCOPE-01` :aux prochaines collectes,limiter les payloads au champion et aux chemins partagés nécessaires ;garder les autres aliases au seul manifeste sauf question précise. Fin :sélection persistée avant stat/read,aucune lecture étrangère sans justification ;les trois lectures présentes restent conservées.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_morgana_passive_hud_20261104` :evidence_review/coherence_review,resource_provenance,phase_package_prerequisites,histoire,DDS,journaux. Hook avant assertion(témoin7/7 réutilisé),capture explicite avant contrôle de F/OpenLeague-work hors hook ;limites Python/exclusions/TOCTOU déclarées. Deux erreurs de noms de fichiers de canevas conservées avec commandes/flux bruts,puis corrigées ;aucune source absente inventée. Un critère f1/f2 hérité de Mordekaiser a été corrigé vers f1 seulement,conformément au primaire ;tentative de préparation1 conservée avant résultat/publication.

Publication documentaire :rapport et ajouts CURRENT/HANDOFF,deux sauvegardes,sept protégés avant/après/readback. Une unité bornée close,zéro tâche/feature/inconnue/acceptation close. Fidélité humaine À VALIDER ;SYS-01.2-02 actif/partiel,goal/Plan/UI/bases/registres/produit inchangés.
