# SYS-01.2-02 — Mordekaiser : Iron Man, ressources et HUD, V1248

4 novembre 2026. Unité `AUD-SYS-01.2-02-MORDEKAISER-PASSIF-HUD-ICON-STATE-LINK-01` ; audit de liaison statique, aucune implémentation implicite.

## 1. Exigence et périmètre

`CH-Mordekaiser-PASSIF-PRESENTATION-HUD`, `OLF-f34936b0-8d81-579b-9d63-214608e8de0e` : icône, texte, rang applicable et état de bouclier. Fiche requise a_faire, implémentation/acceptation false ; dépendance NETWORK, inconnue `OLU-6fd34cc7-6c6f-53cb-9564-c30fd821f092` ouverte. Six contrats/inconnues HUD,NETWORK,SIMULATION,SIMULATION-CONTRAT,SOURCE,ACCEPTANCE conservés ; phase/lot/prérequis consultés dans les caches existants, sans déclaration de satisfaction. Le parent PRESENTATION et le goal restent ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/mordekaiser-passive-iron-man-links-v604.json`,1415184octets,SHA `d3ca325409ff2003c210c8bccb95b4fd277321306138d52daabf965691eeae7c`. UTC documentaire2026-10-26T09:55:37.923853+00:00 ; pas un horaire d’exécution.

HUD :une seule relation native(définition),un catalogue,un consommateur ; ne pas importer uniformément deux sources des autres champions. SOURCE60relations/57IDs/6sites/3fichiers ; V60457sources/171associations,32sites/64liens/16fichiers ; union18fichiers/38ancres. Métadonnées/INIBIN/Lua/font D réutilisés sans relecture.

PARType Shield/BaseMP chaîne120.0 ne prouvent ni plafond ni charge initiale. Niveaux/PARMax/Start/RegenRate/Enabled absents restent inconnus. Texte4235 :conversion de dégâts de compétence ; tooltip2311 :@f2@%,plafond@f1@PV,décroissance3%/seconde,conversion moitié contre sbires. f1/f2,base/cadence/délai/plancher/ordre et autres cibles ouverts. La formule de Q(DDF f1/f2) et les valeurs/priorités R ne résolvent pas le passif.

Passive1Desc référence Jester absent,PassLev1Desc1 donne Mordekaiser ; anciens textes mana40/60/80% sans progression de bouclier déduite. Six BuffData résolus,24Lua littéraux sans enfant/NEWTABLE,13preloads,4DDF Q,23références communautaires ; CharScript vides,six absences de chemins bornées. PersistsThroughDeath ne qualifie pas le respawn ; NonDispellable absent ne vaut pas false. Aliases d’autres champions conservés sans adopter leur politique.

Inventaire E préalable :deux chemins/4352octets/un contenu ; SOURCE seule les a lus une fois chacun.

| Chemin | Octets | En-tête | Membre lol_game_client0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/Mordekaiser/Info/Mordekaiser_IronMan.dds | 2176 | DXT1 64×64, mip brut0 | 0.0.0.25 |
| DATA/Spells/Icons2D/Mordekaiser_IronMan.dds | 2176 | DXT1 64×64, mip brut0 | 0.0.0.25 |

SHA commun `8e969e50de2fd999f79758dc0442fd7036616f2f2e0b1796b6602b84393c7691`. Mip brut0 n’est pas une corruption démontrée. Membership/MD5/SHA identifiés,lookup/variante/pixels non qualifiés. Font miroir identique au témoin Ahri,aucune relecture D.

Le source_sha256 du registre de ressource correspond au JSON communautaire7849octets,distinct de l’INIBIN natif3253octets/SHA69844e007b71… ; aucun renommage de provenance. Historique ciblé :13fichiers/9522174octets,11anciens hashes concordants,2identités nouvelles sans hash historique.

## 3. Consommateurs actuels

38ancres exactes actuelles et16entrées communes inchangées vérifiées. Catalogue/initialisation,progression,actions,attaques,dégâts,resource carrier,grant_shield/advance_shields/absorb_shields et lifecycle sont des contextes ; aucun producteur Iron Man établi dans les chemins inspectés.

`native_hud_bars.rs:9–11` fournit une fraction uniquement pour Mana ; ligne25 masque MP sans fraction. `native_hud_widgets.rs:91` n’ajoute MPStat que pour Mana. Mordekaiser étant Shield,ces branches ne fournissent pas sa jauge. `main.rs:1675–1685` somme les boucliers génériques non expirés pour un texte de diagnostic ; ce n’est pas la jauge120 ni un HUD Iron Man. Le module de passif Ezreal n’est pas un consommateur Mordekaiser. Conclusions statiques,aucun rendu observé.

## 4. Attendu et observé

Attendu :dégâts de compétence admissibles produisant une charge plafonnée/décroissante selon politique sourcée,puis état fiable affiché. Hérité :deux cas base/Ruby+150PV/Sapphire+200mana ; PVmax555,4/705,4,ressource120 constante,aucun bouclier. Six attaques sortantes,six physiques entrantes,deux AnnieQ,244ticks d’attente,54refus. Aucun sort Mordekaiser accepté :déclencheur non exercé,attaques ordinaires insuffisantes pour qualifier conversion/décroissance.

244trames resource/shields sans PV/position,24propriétaires aux bornes. Impacts et Q conservent résultats/résidus/propriétaire après,mais pas les PV immédiatement pré-impact ; refus :flags/erreurs sans paires brutes. Gardes des joueurs/niveau/ressource/statuts,winner/kill-events ne prouvent pas l’exclusion de tous les NPC.

Contrôle séparé par API générique :50absorbés sur un troisième Q ;80restants jusqu’au29e tick,expiration au30e sur31trames propriétaires,sept événements invalides refusés. Ce n’est ni un producteur Iron Man ni sa décroissance3%. Binaire historique6107648octets,SHA `f270d2f8073b114a3ca0455a5ed7d1dbf746784a34bab6048b1ca2f25f264b19`,inert ; BUILD/RUN bruts0,inspection numérique non établie.

Contrôles actuels31/31,relecture séparée42/42 ; identité des deux DDS E recalculée par une autre lecture d’en-tête. Un seul agent,pas de revue humaine/agent indépendante revendiquée. Aucun nouveau build/jeu/VM/REA/réseau/rendu/audio/GPU.

## 5. Écarts et inconnues

Conversion/plafond/décroissance/cibles/multi-boucliers/priorités/coûtsPV/protections,lifecycle/réseau et affichage natif restent ouverts. Jester absent,provenance du registre de ressource,lookup de texture et politique de rang à résoudre. Les refus de sorts n’établissent pas un échec de conversion observé ; le cas admissible reste manquant.

## 6. Corrections et reprise

Réutiliser `CH-Mordekaiser-PASSIF-PRESENTATION-HUD` et dépendances SOURCE/NETWORK/SIMULATION. Résoudre f1/f2 et décroissance depuis un artefact identifié ; qualifier les sorts déclencheurs,puis génération/absorption/cap/minions/monstres/objets/mort/respawn. Publier charge/cap autoritaires et relier barre,icône/texte à cet état ; réseau/rendu/audio/acceptation séparés. Clarifier provenance et tooltip sans remplacement silencieux. Reprendre sur nouvel artefact serveur/mapping/callsite ou dérive,constater les manques sinon.

## 7. Livraison et décision

Preuves :`E:/mapslol3v3/audit_sys01202_mordekaiser_passive_hud_20261104` :evidence_review/coherence_review,resource_provenance,histoire,DDS,journaux,reçus. Méthode de journalisation avant assertion réutilisée(témoin7/7) ; capture explicite avant contrôle pour F/OpenLeague-work hors hook. Une première observation Git nulle corrigée par reprise en lecture seule élevée ; tentative/script/transcription conservés. Limites Python/exclusions/TOCTOU explicites.

Publication documentaire seulement :rapport et ajouts CURRENT/HANDOFF,deux sauvegardes,sept protégés avant/après/readback. Une unité d’audit close,zéro tâche/feature/inconnue/acceptation close. Fidélité humaine À VALIDER ; SYS-01.2-02 actif/partiel,goal/Plan/UI/bases/registres/produit inchangés.
