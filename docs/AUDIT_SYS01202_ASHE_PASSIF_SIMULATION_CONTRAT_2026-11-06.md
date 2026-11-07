# Ashe — contrat connu de Focus et écarts de simulation

6 novembre 2026 · V1454 · AUD-SYS-01.2-02-ASHE-PASSIF-SIMULATION-CONTRAT-01

## 1. Exigence et frontière

CH-Ashe-PASSIF-SIMULATION-CONTRAT, OLF-c34d31b6-7d27-5abe-bb41-49c0d98edec2, parent SYS-01.2-02. Décrire les branches connues et les consommateurs actuels, sans inventer les politiques historiques. **Audit borné terminé ; tâche complète et fonctionnalité ouvertes.** Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Les prérequis de phase/lot et SOURCE restent conservés, sans déclaration de satisfaction.

## 2. Sources et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau et déploiement inconnus ; catalogue 4.20.1 distinct.

Le reçu docs/reference_requirement_trace_sources/ashe-tryndamere-passive-boundary-links-v537.json associait déjà ce contrat : 370589 octets, SHA 134107704ce06d179a91ace60f29ad192ee2bf3479e1fe9a2a3ca45285004432. Seule l’association Ashe SIMULATION-CONTRAT est qualifiée ici. Les champs et observations Tryndamere présents dans le reçu restent étrangers à cette décision.

SOURCE V1184 est réutilisé avec son rapport publié, son résultat SHA e47f79956da0b70460aa843a06526ed96d1459e4a258fa57538d45a8db9f1047, sa publication et ses sous-reçus épinglés. Ses 14 contrôles et les 72 contrôles HUD antérieurs ne sont pas rejoués.

Deux chunks client Focus/CharScript entièrement lus par V537 fournissent quatre globals littéraux, sans prototype enfant ; CharScript possède une vue vide qualifiée dans ce chunk seulement. Les rôles HUD CritChance/Ready restent des contrôles de littéraux distincts, pas des callbacks serveur. Focus déclare persistance/non-dispellabilité ; Ready nomme Ashe_Base_P_buf_geo.troy, sans preuve d’exécution.

Cinq chaînes exactes sont relues dans le miroir en_GB : 1692/1693/1917/4159/4335 ; 2220957 octets, SHA 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3. L’identité partagée du fichier ne transfère aucun gameplay Annie. Lookup lexical, binding effectif et locale runtime restent distincts.

## 3. Branches et consommateurs réels

Douze branches sont décrites dans contract_review.json : identité/formulations ; charges initiales ; délai sans attaque ; accumulation ; prochaine attaque garantie ; cache/annulation ; libération/impact/reset ; cibles/modificateurs ; changements de critique ; lifecycle ; présentation ; vérification historique.

Le tooltip Focus indique : après trois secondes sans attaque, gain de @f1@ charges chaque seconde ; à 100, prochaine attaque critique ; charges initiales égales à la chance critique. Le fournisseur f1 et l’unité initiale restent inconnus. « Hors combat » dans la description/catalogue et l’ancien Passive1Desc « chance augmentée toutes les trois secondes » restent des formulations distinctes, sans normalisation arbitraire.

Neuf ancres du contrat sont retrouvées : catalogue et huit frontières génériques. Quatorze entrées sélectionnées concordent avec V537 et SOURCE : huit Rust, quatre JSON et deux lecteurs Python. Dix-huit fenêtres sont reliées : treize SOURCE et deux communes réutilisées, trois compléments sur annulation, interruption et commandes.

Le chemin actuel calcule base+croissance+objets, borné 0..1 ; le sampler reconstruit renvoie faux pour probabilité invalide/non positive, vrai à partir de 1, sinon SplitMix64. Ni probabilité 1 ni profil critique ne signifient 100 charges Focus.

La décision est stockée dans attack_roll/Windup. Move/Stop appellent cancel_windup : retrait du windup annulable et remise de cadence, sans effacer attack_roll. L’invalidation de cible conserve aussi ce cache ; la mort l’efface. resets_cached_completion concerne l’occupation alliée, pas le critique. À la libération, attack_roll est effacé, AD/multiplicateur sont lus et le projectile est créé ; son arrivée sur cible vivante appelle le hit physique. Ces mécanismes ne qualifient pas le gain, la garantie ou le reset Focus.

## 4. Attendu, observé et contrôles

Attendu : chaque branche relie déclaration, consommateur courant, inconnue et correction précise. Observé : douze branches, dix-huit fenêtres, neuf ancres et dix-huit identités courantes ; **37/37 contrôles documentaires et 36/36 cohérences du même agent**. Quatre producteurs journalisés réussissent : bootstrap01, contract01, coherence01 et documentation01.

Le contrôle SOURCE des huit fichiers nommés reste hérité : zéro nom Focus trouvé, code rg1 attendu. Ses fichiers sont inchangés ; recherche non rejouée, aucune absence globale déduite. La conclusion repose sur les corps et l’ordre des appels conservés.

V537 Ashe : ticks 0/90/900/5400, chance critique de base 0. Ces attentes ne prouvent ni absence du passif, ni atteinte de 100, ni attaque garantie/reset. Aucune observation Fury/Tryndamere n’est adoptée. Ancien probe Ashe identifié comme donnée inerte : 5973504 octets, SHA 4670977346ebb26c7d662c6456a91e2e507d0f0019195e4b35b66cc9ddf2c31c.

Aucun nouveau build, test Rust, runtime, ancien probe, VM Lua, accès D/F-work/EXE, REA, réseau, GPU ou capture. Ni les 1158 entrées historiques ni un corpus Rust complet ne sont recensés ; concordance sélectionnée et provenance complète de compilation restent différentes.

## 5. Écarts et inconnues

Non qualifiés : fournisseur/taux f1, niveaux, unités et arrondis initiaux ; événements interrompant le délai, premier incrément, cadence/cap ; priorité du critique forcé face au cache, cibles/structures, consommation/refund à l’ordre, libération, impact ou annulation ; dégâts bloqués, cible ou lanceur morts ; changements d’objets, décès/respawn/reconnexion ; bindings et état visible.

Aucun producteur Focus n’est qualifié dans les chemins inspectés ; cette conclusion bornée ne déclare pas tout code/asset inexistant. Les flags du buff ne définissent pas la persistance du compteur.

La provenance b3f467… du profil de ressource est déjà résolue : JSON Stats décodé, distinct de l’INIBIN natif de1706…. Aucun nouveau manque ni corruption déduit. Inconnue propre OLU-d9566c6e-c0bd-522f-94f7-42aee992653e et inconnue SOURCE OLU-b31a9a69-0c7d-527e-9685-415f3d9cfc46 conservées.

## 6. Corrections et reprise

corrections_and_restart.json conserve les trois tâches de correction SOURCE antérieures et détaille cinq propositions documentaires COR-SYS-01.2-02-ASHE-FOCUS : SEMANTICS-01, ACCUMULATION-01, CRITICAL-01, LIFECYCLE-01 et VERIFICATION-01. Objectifs, tâches existantes liées, entrées, travail, fin et conditions de reprise sont explicités ; aucun registre changé.

Reprendre sur fournisseur, source serveur, trace, callsite, dérive ou observation précise. Toute correction du produit exige politique sourcée et autorisation adaptée. Vérifier ensuite accumulation → 100 → attaque garantie → reset, frontières trois secondes, cache/annulation/refus et lifecycle, avec provenance de build. Prochaine paire réelle : Azir SIMULATION-CONTRAT, preuves existantes d’abord.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_ashe_passive_simulation_contract_20261106 : contrat, douze branches, ancres, identités, cohérence, journaux et corrections. Projection existante des 122 paires réutilisée ; aucun grand registre chargé ni gain temporel chiffré.

Publication limitée au rapport et aux ajouts CURRENT/HANDOFF sauvegardés exactement. Sept registres, goal, Plan/UI, bases, code et assets inchangés. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2440 entrées groupées conservées. Revue du même agent, sans acceptation indépendante/humaine. Une unité bornée close ; aucune tâche complète, inconnue ou fonctionnalité fermée.
