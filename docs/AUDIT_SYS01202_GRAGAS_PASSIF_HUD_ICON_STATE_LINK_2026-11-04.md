# SYS-01.2-02 — Gragas : liaison de Happy Hour au HUD, V1218

4 novembre 2026. Unité `AUD-SYS-01.2-02-GRAGAS-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine. Déclencheur, HUD complet, fidélité native et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Gragas-PASSIF-PRESENTATION-HUD`, `OLF-c9166d81-3908-5313-91bf-7e1d1de0b7da`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. L’inconnue `OLU-b5731afc-5408-5994-a7e8-a7a1a93bb3f9` reste ouverte.

Ce lot relie ressources, lancement/recast, soin et délai aux consommateurs inspectés. Il distingue Happy Hour, soins génériques, Soin d’invocateur et régénération. Un cast refusé ne teste pas le soin après cast réussi.

## 2. Sources, identité et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Reçu primaire V573 UTC2026-10-26T00:48:28.235431+00:00 ; MD00:55:57.781970, date documentaire distincte sans date d’exécution déduite.

Seize identités datées parmi vingt candidats réutilisées sans relire métadonnées/font/Lua D. Les48 associations historiques concernent trois tâches ; HUD possède deux relations natives : définition `OLS-93336735-982e-529d-9dfb-648617d6ec32` et CharScript `OLS-b0ddfbb3-c281-54ea-9db7-d4cc2fd9ed32`, métadonnée sans corps serveur original.

Passive1LuaName=GragasPassive ; Passive1Icon et BuffTextureName=GragasPassiveHeal.dds. PassLev1Desc1 lie la description Gragas. Tooltip1960 et description4196 indiquent4%HPmax lors d’un lancement, au plus toutes les8secondes ; f1 montant reste sans producteur/format qualifié. PersistsThroughDeath déclaré ne décide pas du délai à la mort.

Sept Lua intégralement parsés sans prototype enfant, six initialisations littérales reconnues ; GragasW NEWTABLEpc16 dépasse le lecteur, sans corruption déduite. Q DoesntTriggerSpellCasts=false et QToggle=true ne suffisent pas à qualifier les événements éligibles. Alias Flash Frost/Cryophoenix, Passive1Desc parlant d’Alistar, descriptions400/600PV et niveaux littéraux10 restent non adoptés.

Quatre clés de tooltip : Passive et Q résolues, W/E sans texte dans le font sélectionné. Ce ne sont pas deux sorts absents. Q1961/SourceName reste un état Barrel Roll distinct ; nom4372=Happy Hour. WAttackBuff/WSelf exclus de l’autorité du passif. Preload avec trois références et quatorze références communautaires conservés séparément ; CharScript communautaire vide, présence QWER non promue en serveur original.

Discovery et inspection historiques capturées exactement E, origines F-work inertes. Quatre chaînes en_GB et leur markup conservés, provenance V573/Ahri et miroir F vérifiés sans relire font D ; locale effective ouverte.

Inventaire exact avant les deux lectures DDS :

| Chemin | Octets / format / mip brut | Membre sous core0.0.1.7 |
|---|---|---|
| DATA/Characters/Gragas/HUD/GragasPassiveHeal.dds | 4224 / 64×64 DXT5 / 1 | 0.0.0.207 |
| DATA/Characters/Gragas/HUD/Icons2D/GragasPassiveHeal.dds | 4224 / 64×64 DXT5 / 1 | 0.0.0.207 |

Un contenu SHA256 `f480ab650d49185c0d3df873b4910390cbc8d2baccdbfa0070d96379cebf03c9`. Captures E exactes, tailles/MD5 conformes au manifeste ; aucun OLS créé. Priorité, alias, pixels et rendu non qualifiés.

## 3. Consommateurs courants

Le CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` est le catalogue appelé par Simulation::new. SOURCE possède six sites sur trois fichiers, dont cinq sites dans deux lecteurs supplémentaires ; qualifications conservées sans promotion en HUD.

Apprentissage/next_rank, cast et cast_at refusent Gragas dans les corps lus. Simulation::heal existe : santé reçue modifiée par Ignite/TrundleW et bornée au maximum. Régénération base/objets réelle ; le producteur spécifique Garen ne s’applique pas à Gragas. Soin générique et changement de santé ne constituent pas un événement Happy Hour.

Provider/StartupHud et plugins ordinaires existent. HPBar/HPStat, QWER/InventoryIcon, variantes, Buff0 Ezreal et F3/Annie restent distincts du passif. Aucun binding Happy Hour icône/texte/rang/f1/délai/état identifié dans les sélecteurs inspectés. Snapshot/projection/session/horloges génériques ne qualifient pas un état Happy Hour transmis. Recherche bornée, sans absence globale déduite.

## 4. Attendu, observé et contrôles

Attendu : événement éligible réussi, soin/délai autoritaires et ressources reliés aux widgets/audiences qualifiés. Observé : déclarations et soins génériques réels ; déclencheur Gragas et liaison dédiée non établis. Sources59/59, consommateurs51/51 contrôles documentaires ; aucun nouveau scénario produit/HUD exécuté.

Seize fichiers/29 extraits communs ;13 fichiers/20ancres V573 et sixSOURCE ;16pins/13fenêtres directes. Entrées/fenêtres/configs couvertes avant livraison. Deux pins manquants interceptés avant première sortie, puis gardes/timing précisés après archives exactes. Attendu de compteur de relecture source corrigé avant exécution, cinq fichiers préparatoires archivés ; producteur régénéré pour le hash du vérifieur, aucune ressource native recapturée.

V573 hérité : deux parties publiques niveau1, PVmax583.520020/733.520020 après1028(+150),10impacts reçus,40refus atomiques,600ticks de suivi. Régénération prise en compte, dégâts physiques ordinaires résidu<0.002. Aucun cast Gragas réussi : ni déclenchement, ni expiration du passif testés.

Positif distinct : Action::Summoner/Soin restaure90PV dans les deux cas, cooldown7200ticks/240s du contrat local, conflit natif300s conservé. Il ne qualifie pas4%/8s. Suivi sans autre soin discret : régénération ordinaire, pas délai Happy Hour exercé. V564 et diagnostics de voie antérieurs restent ouverts/conservés.

Binaire hérité6018048octets, SHA256 `d12672adae3aa86b35a7ea5a0929453219a6300262e4ce6564605802f25565d5`, build/run0 historiques. Ancien générateur de livraison refusé avant publication pour remplacement trop large, corrigé et conservé ; pas un échec moteur. Aucun nouveau build, runtime, VM, REA, GPU, réseau, audio ou rendu ici.

## 5. Écarts et inconnues

Éligibilité QWER/recasts, annulation/refus, ordre, f1/arrondis, instant de mesure HPmax, plafond/modificateurs, début/fin du délai, santé pleine/blessée, mort/réapparition, lookup/rang/états, audiences/reconnexion et rendu restent ouverts. Métadonnées et casts refusés ne prouvent pas une guérison après lancement. Aucun besoin de reconstruction graphique établi.

## 6. Correction et reprise

Réutiliser `CH-Gragas-PASSIF-PRESENTATION-HUD`, NETWORK et SOURCE/SIMULATION ; aucune tâche créée. Critères : qualifier ressources/textes/lookup/rangs et f1 ; définir puis produire l’événement de lancement/recast éligible,4%HPmax et délai8s avec ordre/arrondis ; qualifier identité/session/fraîcheur/audiences/transitions ; relier le HUD avec refus/retrait des données absentes/invalides/périmées/non autorisées ; vérifier casts réussis avant/à/après échéance, absence de double proc, HPmax/soins reçus/mort/reconnexion et rendu identifié ; conserver témoins génériques et acceptation humaine distincts. Reprise sur primaire, mapping, producteur/consommateur ou dérive précise, sans replay inchangé.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_gragas_passive_hud_20261104` : sources/captures/manifestes, consommateurs, scripts/journaux/archives, result/finalpeer. Publication racine : rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes, sept protégés avant/après/readback.

Une clôture d’audit borné après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification statique et preuves partielles datées ; fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code du jeu/assets inchangés ; SYS-01.2-02 actif/partiel.
