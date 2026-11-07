# SYS-01.2-02 — Nami : Surging Tides et HUD, V1250

4 novembre 2026. Unité `AUD-SYS-01.2-02-NAMI-PASSIF-HUD-ICON-STATE-LINK-01` ;audit de liaison statique,fonctionnement et acceptation distincts.

## 1. Exigence et périmètre

`CH-Nami-PASSIF-PRESENTATION-HUD`,`OLF-68804d78-37d5-50e8-a4e3-ed903a6299ea` :icônes,texte,rang applicable,état de vitesse du destinataire et durée. Fiche requise a_faire,implémentation/acceptation false,dépendance NETWORK ;inconnue `OLU-01377d9b-1955-5421-a6ed-f5581a4b9bae` ouverte. Six contrats/inconnues HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE conservés ;phaseD06/lotD06-CH-Nami/prérequis consultés,sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ;catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/nami-passive-surging-tides-links-v606.json`,2736464octets,SHA `db571e21224ee2e4622b8df70b44d9de061af2db9d70577405b1c1b30ea37bf4`,UTC documentaire2026-10-26T10:33:27.286456+00:00,pas un horaire d’exécution.

HUD :définition+CharScript client(non corps serveur),un catalogue,un consommateur. SOURCE69relations/63IDs/6sites/3fichiers ;V60663sources/189associations,21sites/42liens/9fichiers ;union11fichiers/27ancres. Métadonnées/INIBIN/Lua/font D réutilisés sans relecture.

NamiPassive/NamiPassive.dds ;Surging Tides4413,description4237,tooltips2326/2327 :contact d’une compétence avec un champion allié,40+f1 de vitesse pendant1,5s,texte destinataire bref. f1/statistiques/capture-recalcul ouverts. Passive1Desc présent vide ;niveaux1..4 chaînes«0»,5..6absents,sans progression numérique déduite. SpellData sélectionnés absents≠zéro ;24DDF vides(dont quatre passif),QWER/SowTheWind ne fournissent pas f1.

NamiPassive.luaobj :Janna_Tailwind.dds,NamiPassive,DoesntTriggerSpellCasts/PersistsThroughDeath/NonDispellable. NamiPassiveDebuff :NamiPassive.dds,NamiPassivett,Nami_Base_P_buf.troy ;«Debuff» ne prouve pas un effet négatif. NamiRunSpeed n’a qu’un indicateur de persistance. Aliases Janna/Minotaur et clé Zyra conservés sans mécanique étrangère. CharScript natif/communautaire vides ;sept BuffData résolus,26Lua(12littéraux/14NEWTABLE),12preloads,sept absences bornées ;aucune corruption/absence globale déduite. Aucun NightmareBotNami sélectionné.

Vingt-huit références communautaires :QWER codés,sans liaison directe au passif ;W une cible malgré commentaire de rebond,E NamiTidecaller,Q délai1,5s avant contrôle ennemi,R filtrage angulaire instantané. Aucun serveur original ou consommateur Rust déduit.

Inventaire E avant payload :champion+partagé nécessaires seulement,deux chemins/7096octets/deux contenus ;alias Janna/HUD gardé au manifeste sans lecture native.

| Chemin | Octets | En-tête | Membre lol_game_client0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/Nami/HUD/Icons2D/NamiPassive.dds | 2872 | DXT1 64×64, mip brut7 | 0.0.0.137 |
| DATA/Spells/Icons2D/Janna_Tailwind.dds | 4224 | DXT5 64×64, mip brut1 | 0.0.0.25 |

Membership/taille/MD5/SHA identifiés,lookup/variante/pixels ouverts ;Janna n’impose pas sa politique. Méthode COR-SYS01202-AUDIT-DDS-CHAMPION-PATH-SCOPE-01 appliquée à ce lot. Font miroir inchangé,témoin Ahri réutilisé. Type courant Mana,PARType natif absent. source_sha256 correspond au JSON communautaire4995octets,distinct de l’INIBIN natif1337octets/SHA2a961442f0ed… (`resource_provenance.json`). Historique ciblé46fichiers/12620339octets,44hashes anciens concordants/2identités nouvelles.

## 3. Consommateurs actuels

27ancres exactes et16entrées communes inchangées vérifiées. Catalogue,initialisation,learn/cast/cast_at,stats/objets,movement_speed/effective_speed_with_slow/soft_cap et advance_allied_motion/fit_step/note_ally_move inspectés. Aucun producteur Surging Tides établi. Recherche nommée bornée évitant «dynamic»,sans absence globale déduite.

`native_hud_bars.rs:9–11` et `native_hud_widgets.rs:91` traitent Mana/MPStat ;ces chemins et les PV/cooldowns génériques ne donnent ni état NamiPassivett,ni bonus/cap,destinataire ou expiration autoritaires. Le module passif Ezreal n’est pas un consommateur Nami. Aucun rendu HUD Nami qualifié par ce constat statique.

## 4. Attendu et observé

Attendu :contact allié admissible,bonus40+f1,persistance1,5s selon politique sourcée puis état fiable affiché. Hérité :deux cas à trois joueurs,base/Bottes25+Tome20AP ;Nami335/360,Ahri330. Aucun sort Nami accepté,donc contact allié non exercé.184trames d’attente,12snapshots aux offsets44/45/46,102refus. Ces offsets ne sont pas l’âge d’un buff actif.

Huit trajets,512paires de positions,198pas à pleine vitesse,recalculés avec tolérance0,003 ;seuils inchangés :arrivée<1 et au moins10pas pleins. Six critères réussissent,deux échouent. Ahri23 s’arrête à(8398,981445 ;6934,240234) pour but(8434,981445 ;6934,240234) :36unités restantes,destination déjà nulle AVANT Stop explicite,24pas pleins puis156nuls/180 dans chacun des deux cas. Le retour aboutit. Aucun ordre de reprise ajouté pendant les trajets mesurés ;cause non attribuée automatiquement à V564.

Installation simultanée1037ticks/cas,trois participants arrivés,aucune reprise ;trois essais historiques antérieurs BUILD0/RUN101 conservés avec sources/logs/reçus et identités binaires. La collecte finale BUILD/RUN0 garde nominal_walk_checks_all_passed=false et movement_fidelity_accepted=false. Binaire final6086144octets,SHA `2c869cb5bbf12223895cb7a11c7f5adfb9f9346383604ed4daf0ccf153cef9e4`,inert ;inspection numérique non établie.

Attentes sans PV/position par tick,positions des trajets avec avant/après,budgets/vitesse ;refus :flags/erreurs sans paires brutes. Gardes joueurs/statuts/winner ne prouvent pas une exclusion universelle des NPC. Contrôles documentaires55/55,relecture séparée39/39,ne requalifient pas les deux échecs de mouvement. Même agent,pas de revue humaine/agent indépendante. Aucun nouveau build/jeu/VM/REA/réseau/rendu/audio/GPU.

## 5. Écarts et inconnues

f1,contacts soi/alliés,Q/W/E/R,recalcul/cumul/rafraîchissement,ralentissements/caps/lifecycle,dissipation,mort/respawn,réseau/HUD/pixels ouverts. Deux arrivées échouées et cause de navigation restent ouvertes ;V564 conservé sans cause commune démontrée. Les refus ne prouvent pas un échec d’un bonus effectivement appliqué.

## 6. Corrections et reprise

Réutiliser `CH-Nami-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION :résoudre f1,puis sorts/contacts admissibles,application et conversion du bonus vers mouvement,réplication/HUD. Qualifier cibles/rafraîchissement/cumul/expiration d’un buff actif,interactions/objets/caps/lifecycle. Reprendre sur nouvel artefact serveur/mapping/callsite ou dérive,sans politique Janna inventée.

`COR-NAMI-SURGING-TIDES-WALK-ARRIVAL-01` :diagnostiquer la perte de destination d’Ahri dans ally_occupancy/mouvement à partir des preuves enregistrées. Fin :les huit critères originaux passent,sans abaisser<1/10pas ni injecter de reprise ;conserver les anciens échecs,comparer explicitement V564 avant attribution. Correction fonctionnelle à exécuter séparément.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_nami_passive_hud_20261104` :evidence_review/coherence_review,resource_provenance,phase_package_prerequisites,DDS/histoire/journaux. Identités avant assertions(témoin hook7/7 réutilisé),captures explicites F/OpenLeague-work ;exclusions Python/contexte/bootstrap/inventaire final et limites TOCTOU déclarées. Ancien sessionhandle historique de copie surveillé jusqu’à sortie0,sans reprise du producteur.

Publication documentaire :rapport et ajouts CURRENT/HANDOFF,deux sauvegardes,sept protégés avant/après/readback. Une unité d’audit borné close,zéro tâche/feature/inconnue/acceptation close. Fidélité humaine À VALIDER ;SYS-01.2-02 actif/partiel,goal/Plan/UI/bases/registres/produit inchangés.
