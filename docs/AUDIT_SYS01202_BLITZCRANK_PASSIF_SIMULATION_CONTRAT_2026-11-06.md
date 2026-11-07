# Blitzcrank — contrat connu de Mana Barrier et écarts actuels

6 novembre 2026 · V1456 · AUD-SYS-01.2-02-BLITZCRANK-PASSIF-SIMULATION-CONTRAT-01

## 1. Exigence et frontière

CH-Blitzcrank-PASSIF-SIMULATION-CONTRAT, OLF-eb36aaac-2f76-5fea-a180-e19b6b7cc9a2, parent SYS-01.2-02. Décrire les branches connues de Mana Barrier face aux consommateurs de dégâts, mana et boucliers. **Audit borné terminé ; tâche complète et fonctionnalité ouvertes.** Aucun audit SOURCE, HUD ou VFX clôturé à nouveau. Prérequis SOURCE, phase et lot conservés sans satisfaction implicite.

## 2. Sources et provenance

Référence PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct.

Le reçu docs/reference_requirement_trace_sources/blitzcrank-passive-shield-links-v544.json associait déjà ce contrat : 441186 octets, SHA 184e94afc243a8b725ce7b67a4cfa1a97cc37f48e8ac59bb4c6aa0f6a27468cf. Rapport V544 et SOURCE V1186 réutilisés, avec publication et sous-reçus épinglés. Résultat SOURCE : 30411 octets, SHA a6fa476081e16a6e33e8d1f7bdf019a0cf795878ef84f3516b8cd3dff8b23327 ; ses 15 contrôles restent antérieurs.

Douze identités natives sélectionnées ; trois preloads, cinq références communautaires et quatre fichiers NightmareBot exclus gardent leurs rôles. La déclaration ManaBarrierIcon et neuf littéraux Icon/Cooldown sont conservés. OnPreDamagePriority=8 ne prouve ni callback ni ordre serveur.

V544 affirme quatre Lua parsés sans prototypes enfants ; le détail embarqué ici ne couvre que ManaBarrier, 365 octets, limité par NEWTABLE pc8 pour les littéraux. Sa projection reste inconnue, globals=null et raw globals={} conservés. AutoCooldownByLevel et DoOnPreDamageInExpirationOrder ne reçoivent aucune règle inventée. Limite de lecture, pas corruption.

Cinq chaînes en_GB relues : trois bindings directs 1731/2262/2263, description et nom du champion. Miroir 2220957 octets, SHA 1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3. Lookup lexical, binding effectif et locale runtime distincts ; identité commune du fichier seulement, aucun transfert du gameplay Azir.

## 3. Branches et consommateurs

Quatorze branches décrites dans contract_review.json : identité/disponibilité ; état initial ; seuil ; ordre des dégâts/létalité ; montant/mana ; création/stacking/refus ; absorption/catégories ; durée ; recharge ; lifecycle ; régénération/capacité ; présentation ; lecteur/variantes ; vérification historique.

Le texte Icon indique : passage sous 20 %PV, bouclier de 50 % du mana courant, jusqu’à dix secondes, activation une fois toutes les 90 secondes. Disponibilité initiale, niveaux, égalité exacte, capture/coût du mana et ordre natif restent inconnus. Ancien texte Alistar, +400/+600PV et niveaux 6/12/18 ne sont pas adoptés.

Onze ancres sont retrouvées : catalogue et dix frontières génériques, aucune promue en producteur ManaBarrier. Dix-sept entrées sélectionnées concordent avec V544 et SOURCE : neuf Rust, six JSON, deux lecteurs Python. Les 21 fenêtres SOURCE sont réutilisées après identité et comparaison exacte des lignes.

Le trajet actuel est attaque→hit physique→mitigation→absorption des boucliers existants→PV/mort. grant_shield est un événement serveur recevant tag, montant et durée explicites, avec validation et remplacement du même tag. Il ne calcule pas 50 %mana, ne vérifie pas 20 %PV et ne gère pas la recharge ManaBarrier dans ce corps. Aucune commande client grant_shield.

Boucliers expirés retirés avant les phases ultérieures ; régénération avant attaques ordinaires. Mana courant, capacité calculée et capacité exposée au snapshot sont distincts. Mort générique efface effets/boucliers ; retour ordinaire restaure les ressources. Ces voies ne qualifient pas déclenchement, persistance ou recharge du passif.

## 4. Attendu, observé et contrôles

Attendu : source, chemin courant, inconnue et correction par branche. Observé : 14 branches, 21 fenêtres, onze ancres et 21 identités courantes ; **39/39 contrôles documentaires et 40/40 cohérences du même agent**. Quatre producteurs journalisés réussis : bootstrap01, contract01, coherence01, documentation01.

V544 hérité : deux cas, onze attaques avant le passage 24,79→16,81 %PV au tick1321, aucun bouclier au passage. Mana267,2000122, moitié textuelle133,6000061PV. Le mana était plein : ce diagnostic ne distingue pas courant et maximum.

Le second cas ajoute ensuite le témoin serveur grant_shield100PV/300ticks. Il absorbe46,5348129PV à la frappe1369 puis expire1621. **100PV n’est pas133,6000061PV ; 300ticks choisis ne prouvent pas dix secondes natives.** Ce témoin n’est pas le passif. Six refus Attack et cinq grant_shield restent historiques ; égalité20 %, réarmement90s et ordre natif non testés.

Ancien binaire inerte :6041088octets, SHA ad9fad9534b1a2d38c58e30d99d564d4d3e04cf8760e99188f73044127d6a862. Aucun accès au payload, nouveau build/test Rust/runtime/probe/VM Lua/D/F-work/EXE/REA/réseau/GUI/GPU/capture. Recherche SOURCE neuf Rust et 1158 entrées historiques non rejouées ; identité sélectionnée distincte de provenance complète de compilation.

## 5. Écarts et limites

Restent ouverts : admission/initialisation/niveaux ; seuil exact et basePV ; mitigation/absorption/létalité/concurrence ; capture/coût/arrondi du mana réellement entamé ; tag/stacking/catégories/refus ; début/fin des dix secondes ; départ des 90 secondes et second déclenchement ; mort/reconnexion/état visible.

Aucun producteur ManaBarrier qualifié dans les corps inspectés ; aucune absence globale de code/assets déduite. Priorité8, flags de persistance et préchargements ne sont pas des politiques exécutées.

Inconnue propre OLU-3b33cefd-4d8d-5ad3-a734-41eb0fa2a173 et inconnue SOURCE OLU-9d0518cb-b11f-5c9d-913f-309518d1521f conservées. Provenance JSON typé distincte du natif, sans nouveau défaut de hash inventé.

La limite de préservation du candidat préparatoire SOURCE ancien reste consignée, sans prétendre récupérer sa sauvegarde. Le résumé root a rencontré KeyError from_line ; le schéma réel start_line/end_line/numbered_lines a été repris sans changer le reçu, puis vérifié ligne par ligne. Ce n’est pas un défaut produit.

## 6. Corrections et reprise

corrections_and_restart.json conserve les trois rôles SOURCE existants et propose sept sous-objectifs COR-SYS-01.2-02-BLITZCRANK-MB : SEMANTICS, TRIGGER, SHIELD, DURATION, COOLDOWN, LIFECYCLE, VERIFICATION, suffixés -01. Objectif unique, tâche liée, entrées, travail, fin et reprise sont explicites ; aucun registre modifié.

Reprendre sur source serveur, fournisseur, trace, callsite, dérive ou observation précise. Corrections produit sous autorisation adaptée. Vérifier ensuite PV au-dessus/égaux/sous20 %, mana réellement entamé distinct de capacité, boucliers existants/létalité, expiration/recharge/réactivation et refus sans mutation, avec provenance de build. Prochaine paire réelle : Brand SIMULATION-CONTRAT, preuves existantes d’abord.

## 7. Livraison et décision

Preuves E:/mapslol3v3/audit_sys01202_blitzcrank_passive_simulation_contract_20261106 : contrat, branches, ancres, identités, cohérence, journaux et corrections. Projection existante de 122 paires réutilisée ; aucun grand registre chargé ni gain temporel chiffré.

Publication limitée au rapport et aux ajouts CURRENT/HANDOFF sauvegardés exactement. Sept registres, goal, Plan/UI, bases, code et assets inchangés. Main 8c19026eb8fdc2d9e47960b0110c5f9175f4d1ca, 2442 entrées groupées conservées. Même agent, sans acceptation indépendante/humaine. Une unité bornée close ; aucune tâche complète, inconnue ou fonctionnalité fermée.
