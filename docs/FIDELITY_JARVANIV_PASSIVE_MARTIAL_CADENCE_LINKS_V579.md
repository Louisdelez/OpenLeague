# SYS-01.2-02 — Jarvan IV : Cadence martiale, V579

Date UTC : 2026-10-26T02:35:14.472171+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral du 2014-11-17 à 17:46:45 ; fuseau et déploiement non établis. Catalogue officiel 4.20.1 distinct.

## Résultat intégré

CH-JarvanIV-PASSIF-SOURCE, CH-JarvanIV-PASSIF-SIMULATION-CONTRAT et CH-JarvanIV-PASSIF-SIMULATION reçoivent 39 associations vers 13 ressources natives et 44 liens vers 22 points précis du code actuel. SYS-01.2-02 référence le lot. Trois inconnues propres, quatre dépendances, critères et statuts conservés ; prérequis des phases et lots consultés.

**Les 16 impacts observés suivent uniquement les dégâts ordinaires. Aucun bonus de Cadence martiale n’est appliqué dans les parcours inspectés.** Les consommateurs restent `entry_boundary_only`, `provides_feature_consumer=false`. Il s’agit de traçabilité source/consommateur et de qualification de l’écart, sans modification du gameplay ou des assets.

## Sources disponibles et limites

| Ressource | Identifiant |
|---|---|
| JarvanIV.inibin | OLS-27b089a1-a481-595c-a79c-1ca40e6a7d70 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptJarvanIV.luaobj | OLS-5f054f01-4c4e-5c36-a8ca-e3b996ec3847 |
| CharScriptJarvanIV.preload | OLS-ce219be3-e518-55f5-9c82-5998ef23c9e2 |
| JarvanIVMartialCadence.inibin | OLS-b1b2cbf9-b1a4-5bf7-a0d6-7496445c0a82 |
| JarvanIVMartialCadence.luaobj | OLS-aca8bc4b-d31c-5e4b-98a3-735cdf28cd72 |
| JarvanIVMartialCadenceAttack.fx | OLS-fb21b081-b0b4-51d0-a065-85c5986905e4 |
| JarvanIVMartialCadenceAttack.inibin | OLS-1c07f3a3-cf89-5a4e-8bd0-191d67528d3e |
| JarvanIVMartialCadenceAttack.luaobj | OLS-0afc7b53-7226-5e18-8372-5404f4050a77 |
| JarvanIVMartialCadenceAttack.preload | OLS-dd0a0743-ea84-54e7-b60c-78668eebd9df |
| JarvanIVMartialCadenceCheck.inibin | OLS-171d9055-8857-596e-a674-85f0c3345c90 |
| JarvanIVMartialCadenceCheck.luaobj | OLS-45687769-4a5d-52a4-8185-45e6d166c799 |
| JarvanIV.ddf | OLS-238ec7ec-fec7-5988-b46a-eea321047796 |

Les 13 ressources sont vérifiées par taille/SHA256 contre le registre et taille/MD5 contre les manifestes RADS sélectionnés. Leur appartenance ne démontre pas l’ordre de montage historique.

Le personnage désigne JarvanIVMartialCadence, son icône JarvanIV_MartialCadence.dds et ExtraSpell1=JarvanIVMartialCadenceAttack. Les deux buffs utilisent cette même icône. Le texte en_GB ligne 2091 annonce un bonus physique de 10 % des PV actuels au premier coup, maximum 400, avec délai par cible **@f1@ non résolu**. Le buff cible ligne 2092 mentionne un délai court sans valeur. La description personnage ligne 4204 confirme première attaque et restriction par cible, sans fournir les détails du calcul serveur.

Quatre chunks Lua sont entièrement lus, sans prototype enfant ; trois initialisations littérales sont reconnues. CharScriptJarvanIV n’a pas de globals. Le buff source déclare PersistsThroughDeath=true ; le champ est absent du buff cible, ce qui ne signifie pas false. Le lecteur littéral s’arrête sur NEWTABLE pc0 pour l’attaque : limite du lecteur, pas corruption démontrée. Aucun callback ni serveur historique exécuté.

Les deux preloads déclarent le passif, jarvincritattack_tar.troy et le buff de contrôle par cible. Le DDF contient 20 entrées dont quatre pour MartialCadenceAttack avec link/coeff vides : aucune durée @f1@ n’en est déduite. Le sort supplémentaire déclare l’animation Passive et des champs Cooldown à zéro ; ces zéros ne constituent pas le délai de réactivation du passif par cible. Les autres paramètres et références d’effets restent conservés dans `native_metadata.related_metadata.attack_named_fields`. Le FX binaire est identifié sans décodage ni rendu.

Les anciennes chaînes relatives à Master Yi et à la régénération de mana sont conservées, sans adoption comme comportement de Jarvan. Les six champs Passive1Level sont absents, sans valeur inventée. Neuf références communautaires sont séparées des sources natives ; CharScriptJarvanIV.cs est vide. Une ressource communautaire et une chaîne de preload ne prouvent pas le fonctionnement historique.

## Vérifications réellement exécutées

Deux simulations publiques Map10, sans injection de position, PV, niveau, rang, XP ou effet. Jarvan rejoint le centre par Move/Stop ; deux Annie ennemies arrivent successivement de part et d’autre, avec Ahri alliée servant à attribuer les équipes. Aucun PNJ supprimé. Le cas équipé achète l’Épée longue 1036 au départ.

Chaque cas réalise huit attaques sur deux cibles dans l’ordre **A A B B A B A B**, arrêt après chaque impact, puis 90 ticks de suivi. Les ennemis survivent et les acteurs restent niveau 1. Les variations de santé des deux cibles sont vérifiées à chaque tick ; la cible non frappée ne reçoit que sa régénération. Le hit doit coïncider avec la cible et le tick de libération du windup, sans critique. La régénération est prise en compte pour isoler les dégâts.

| Cas | AD brut | Impacts | Refus | Résidu maximal des dégâts ordinaires |
|---|---:|---:|---:|---:|
| base | 55.712002 | 8 | 16 | 0.00000763 |
| long_sword | 65.712006 | 8 | 16 | 0.00001144 |

Les 16 impacts correspondent à AD × 100 / (100 + armure), résidu inférieur à 0,002. Au premier impact la cible possède 511,679993 PV ; 10 % représentent environ 51,168 dégâts bruts supplémentaires **selon le texte**, qui ne sont pas présents dans le résultat courant. Ce calcul indicatif ne qualifie pas l’ordre exact de lecture des PV ou de mitigation du serveur original. L’Épée longue ajoute 10 AD ; elle ne constitue pas le passif.

Au total, 32 refus atomiques : joueur inconnu, attaque de soi, attaque alliée, slot invalide, puis Learn/Cast/CastAt des quatre capacités pour chacun des deux cas. Les snapshots restent inchangés. Après Stop, les 180 ticks cumulés ne montrent que la régénération attendue.

Le changement de cible vérifie le parcours courant, mais **ne démontre aucun délai natif par cible**. Le plafond 400 n’est pas atteint. Pas de test sur sbires, monstres, structures, seuil minimum, niveaux supérieurs, boucliers, critique, mort/réapparition ou déconnexion. Pas de transport réseau, GPU, audio ou affichage HUD qualifié.

## Consommateurs précis

Les liens couvrent initialisation, commandes, statistiques, progression, refus de capacités, ordre des ticks, validité de cible, windup, libération des attaques, basic_attack_hit, apply_damage, mitigation, régénération, achat/bonus d’objets et snapshots. Respawn et remove_player sont seulement inspectés statiquement pour le futur cycle de vie du passif.

La libération d’une attaque ordinaire de Jarvan utilise l’AD ; basic_attack_hit transmet les dégâts physiques au moteur partagé. Les fonctions inspectées n’ajoutent ni pourcentage des PV actuels ni verrou Cadence martiale par cible. Ces observations n’acceptent pas les détails historiques des autres modificateurs.

## Identités, erreurs conservées et publication

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-jarvan-passive-martial-cadence-probe.exe`. Taille : 6028288 octets. SHA256 : `18374d860f2adc88a15c6aa1af67432ad07bb06c3bf165817c06043d00e2af64`.

BUILD et RUN : code 0. Core courant non-test, verrou privé aligné sur les identités/checksums du verrou racine ; 1 158 entrées core/ressources et chaîne de preuves antérieure inchangées. Le probe n’a pas été modifié ni relancé après son succès.

L’inspection initiale a échoué : le script convertissait les clés de hash textuelles en entiers avant de les consulter avec le hash textuel du lecteur. Le contenu natif était présent. Le script original `revision579_jarvan_inspection.py` est conservé et identifié ; `revision579_jarvan_inspection_qualified.py` corrige cette conversion et réussit. Un défaut de syntaxe du générateur et une première commande PowerShell de lecture ont également été corrigés avant la publication ; ils n’ont modifié ni source ni registre. Ces erreurs ne démontrent aucune corruption des assets.

Discovery, inspection corrigée, prepare, check, publish, audit et revue globale : succès. Les contrôles refusent 72 associations invalides et quatre graphes invalides. Trois fragments de trace enrichis, 42 212 autres inchangés. Les lecteurs réels Store.task/copy_text/summary, dépendances et résolution de trace sont vérifiés.

Dans chacune des deux bases SQLite : quatre destinataires enrichis, 42 603 autres lignes, 42 607 états manuels et 23 historiques conservés ; intégrité et synchronisation normale idempotente vérifiées. Identifiants, hiérarchie et registre des inconnues identiques en octets. Aucun statut ou case accepté automatiquement.

Revue globale : 42 215 exigences, 98 993 sources, 3 524 consommateurs ; 3 524 ancres exactes, aucune divergence courante. 26 189 inconnues ouvertes et 5 517 résolues conservées. La revue structurelle ne re-hashe pas tout le corpus et n’est pas un pourcentage de jeu terminé.

## Travail restant

- Résoudre la durée @f1@ par cible et sa variation éventuelle avec le niveau.
- Qualifier cibles admissibles, maximum 400, éventuel minimum et règles spécifiques champions/sbires/monstres/structures.
- Fixer le moment de lecture des PV, l’ordre avec l’attaque ordinaire, armure, pénétration, réduction, boucliers, critique, vol de vie et effets au contact.
- Implémenter le bonus et l’état par source/cible ; tester premières attaques, répétitions, expiration, changement et retour sur cible.
- Vérifier attaques annulées, disparition/mort des acteurs, respawn, déconnexion et fin de partie.
- Intégrer et qualifier séparément animation Passive, icône, VFX, audio, HUD et réseau ; les références présentes ne démontrent pas leur rendu.
- Conserver les autres écarts du projet, notamment le défaut de déplacement V564.

## Fichiers et reprise

Registres modifiés : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`. Reçu : `docs/reference_requirement_trace_sources/jarvaniv-passive-martial_cadence-links-v579.json`. Preuve : `docs/fidelity_jarvaniv_passive_martial_cadence_links_v579.json`. Couverture, plan, checkpoint, CURRENT, HANDOFF et deux bases actualisés avec sauvegardes. Scripts et journaux sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20, préfixe revision579.

Continuer SYS-01.2-02 depuis revision580_trace_review/REVIEW.json. JarvanIV V579 publié/audité :3fiches,13natives,39associations,22points/44liens limités. Deux cas publics base/Épée longue,16impacts totaux sur deux cibles par cas AABBABAB,32refus,180ticks de suivi;dégâts ordinaires seuls AD55.712/65.712. Texte10%PV actuels physique max400,délai @f1@ non résolu;cap,type de cibles,ordre et lifecycle ouverts. DDF4coefficients passifs vides,NEWTABLEpc0limitelecteur,FXsans rendu,anciennes chaînes Yi/mana non adoptées. Inspection initiale échouée par conversion erronée des clés hashstring en int,script conservé;inspection qualified réussie après correction sans rerun du probe. Préserver chaîneV578 et preuve initiale V579. Aucun statut/case/inconnu fermé. Poursuivre autre passif après inspection réelle,par exemple Jax. Défaut déplacementV564 ouvert;goal actif.
