# Singed — correctif du fichier natif avec espace, V628

Date UTC : 2026-10-26T17:28:08.137787+00:00. SYS-01.2-02, F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB ; catalogue4.20.1 distinct. Build littéral2014-11-17 17:46:45, fuseau et déploiement non établis.

## Correction livrée

V627 avait omis `DATA/Spells/Empowered Bulwark.inibin` : son filtre sélectionnait EmpoweredBulwark sans espace. Le fichier avec espace est présent, fait49octets et correspond au manifeste RADS sélectionné. Cette omission de sélection est corrigée ici ; les sources, rapports, erreurs et résultats V627 sont conservés.

Il ne s’agit pas de sa première découverte dans le projet : les deux fiches de simulation possédaient déjà une référence V543 à ce fichier. Ces anciens liens sont conservés. Le correctif enrichit le rôle détaillé et corrige le périmètre de la sélection V627, sans présenter le fichier comme auparavant absent de tout le registre. SHA256 du fichier : `eb11bb5565c765bfc640a20a7c01748247d05ddc034604fb6b31f2a584b33809`.

Une association native est ajoutée à chacune des trois fiches Singed (SOURCE, SIMULATION-CONTRAT, SIMULATION), soit3associations. Un nouveau point de code, `Simulation::stats`, est relié aux deux fiches de simulation :2liens. Il représente le consommateur actuel du maximum de PV, sans être qualifié comme implémentation du passif. Les32sources et26points V627 restent intacts.

Le nouveau fichier a un seul champ décodé : BuffData.DynamicTooltip, hash2287725201, valeur `game_buff_tooltip_Empowered_Bulwark`. Le texte en_GB résolu décrit **f2PV pourf3mana**, et **f1** pour afficher les PVbonus. La description du personnage25PV/100mana reste une source complémentaire. Les producteurs f1/f2/f3, l’assiette exacte et les arrondis ne sont pas inventés.

Le nom de fichier avec espace, Passive1LuaName et BuffName sont reliés explicitement ; le preload sans espace et le Lua sans espace gardent leurs identités propres. Cette association n’exécute pas le loader historique ni ses règles de normalisation. Le candidat EmpoweredBulwark.inibin sans espace reste absent et distinct du fichier présent.

## Vérification des sources

La sélection élargie contient33fichiers natifs :10INIBIN,14Lua,8preloads et le font en_GB. Ils sont revérifiés par identité, SHA et appartenance RADS ;2liaisons BuffData sont désormais résolues, celle du passif et celle de MegaAdhesiveSnare. Les3limites NEWTABLE et les scripts vides de V627 restent documentés.

15 références communautaires sont recensées, dont `Empowered Bulwark.json`. Seule cette nouvelle référence est ajoutée : les14 précédentes et les7 ressources locales ne sont pas dupliquées dans la traçabilité. Le JSON communautaire ne devient pas une autorité serveur native. Les divergences QWER et le texte secondaire de réduction magique10% restent ouverts.

| Source ajoutée | Identité du registre |
|---|---|
| Empowered Bulwark.inibin | OLS-3fb3ed7a-abfc-5330-bb2e-5e54f6dd709a |

| Point courant ajouté | Rôle |
|---|---|
| crates/core/src/progression.rs:68 | exact spaced passive text compared with current max-health producer;prior26boundaries retained |

## Résultats hérités et revalidés

**Aucun nouveau build ni lancement de jeu en V628.** Le diagnostic public V627 est relu ;1158 entrées du cœur et de ses ressources, le binaire, Cargo.lock, les journaux et les preuves précédentes sont contrôlés. BUILD/RUN0 désignent l’exécution V627, pas une exécution supplémentaire. Le collecteur initial1 et la relecture0 de cette même exécution restent conservés.

Binaire hérité `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-singed-passive-empowered_bulwark-probe.exe`, 6093824 octets, SHA256 `3df7aa3c4b60261180b36d1f8331e2be7f37dbec7f78b22635c12a0cad572438`.

| Profil V627 | PVmax | Mana / plafond à la fin | Dégâts d’attaque | Refus |
|---|---:|---:|---:|---:|
| base | 542.76001 | 290.60001/290.60001 | 52.27310 | 27 |
| Ruby150HP | 692.76001 | 290.60001/290.60001 | 52.27310 | 27 |
| Sapphire200Mana | 542.76001 | 490.60001/490.60001 | 52.27310 | 27 |

Les18attaques,81refus atomiques,543ticks de repos et6trajets V627 montrent toujours : Saphir+200mana sans augmentation des PV ; Rubis+150PV. Les réserves courantes ne sont pas remplies par l’achat. Le mana est plein avant l’attente, donc cette attente ne prouve pas la régénération sous plafond. Aucun sort Singed n’est accepté, aucun passif complet ou serveur historique n’a été exécuté. La nouvelle source apporte une liaison de tooltip précise ; elle ne change pas ces résultats et ne suffit pas à résoudre les variables dynamiques.

## Publication et conservation

Découverte élargie, revalidation et inspection :0. PREPARE/CHECK_PREVIEW_EXACT/PUBLISH/AUDIT :0. Le CHECK initial échoue avec code1 car il attendait trois aperçus modifiés ; CHECK_PREVIEW échoue avec code1 car il en attendait zéro. Les deux échecs sont conservés. Le diff montre exactement deux changements : les fiches SIMULATION-CONTRAT et SIMULATION contenaient déjà la source via V543 parmi leurs trois premiers groupes, dont les sélecteurs sont réunis par instruction_lines. La fiche SOURCE garde son aperçu limité inchangé. Le contrôle final vérifie ces positions et ces deux changements, les trois fiches complètes et les quatre textes copiables, où le nom exact et f1/f2/f3 sont présents. Il ne transforme pas un aperçu inchangé en preuve d’absence de l’ajout. Les72associations invalides et4graphes invalides sont refusés ; fausse absence du fichier avec espace, source manquante, preuve de binaire modifiée et fausse acceptation ne passent pas la validation.

Graphe99189sources/4729consommateurs ;4729ancres exactes vérifiées sans divergence. Le contrôle global est structurel ; les vérifications de SHA portent séparément sur les entrées sélectionnées.

Deux bases :4destinataires actualisés,42603autres lignes,42607états manuels et23historiques conservés ; synchronisation Store idempotente. Trois fiches de traçabilité sont enrichies ; deux aperçus changent et42213restent identiques. Trois questions propres et quatre dépendances sont préservées ; identités, hiérarchie et inconnues restent identiques octet pour octet.

Fichiers : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json, reference_requirement_trace_sources/singed-passive-empowered_bulwark-links-v628.json, fidelity_singed_passive_empowered_bulwark_links_v628.json et ce rapport. Couverture, plan, reprise, CURRENT et HANDOFF mis à jour avec sauvegardes. Les pièces privées sont conservées sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision628_Singed et fichiers revision628_singed associés. V627 reste consultable, y compris son inventaire initial incomplet et le signalement de l’omission.

## Limites et suite

L’omission du fichier est corrigée. Restent à qualifier : producteurs f1/f2/f3, assiette mana actuel/maximal/bonus, croissance, arrondis, ordre de recalcul et lifecycle. Il faut ensuite implémenter et tester le bonus avec achats/ventes, mana incomplet/plein, PV pleins/blessés, buffs, niveaux, mort/réapparition et reconnexion. HUD, effets, sons, animations et réseau demandent leurs propres preuves. Aucun statut ou case de complétion n’est accordé au passif, au champion ou au jeu.

Suite : Continuer SYS-01.2-02 depuis revision629_trace_review/REVIEW.json. V628 correctif Singed / Empowered Bulwark :le fichier natif Empowered Bulwark.inibin AVEC ESPACE,49octets,omis du filtre V627,est présent et vérifié RADS. Il résout game_buff_tooltip_Empowered_Bulwark :f2PV pourf3mana,affichage du bonusf1. Les producteurs numériques,assiette,arrondis et lifecycle restent non qualifiés ;le texte personnage25PV/100mana est conservé. Trois associations natives ajoutées,un point stats actuel et deux liens ;les32sources et26points V627 sont conservés,33fichiers natifs revérifiés. Quinze références communautaires recensées,dont le JSON avec espace ;une seule nouvelle référence communautaire ajoutée. Diagnostic V627 réutilisé avec identités source/binaire contrôlées,aucun nouveau build/lancement :18attaques,81 refus,543ticks,six trajets. Saphir+200mana sans PVbonus,Rubis+150PV ;collecteur initial1 puis relecture0 conservés,attente au plafond non test de régénération sous plafond. L’omission de source est corrigée,le gameplay reste incomplet ;statuts,cases,inconnues et preuves antérieures conservés. PREPARE/CHECK_PREVIEW_EXACT/PUBLISH/AUDIT :0 ;CHECK et CHECK_PREVIEW initiaux1 conservés ;deux aperçus enrichis depuis liensV543 déjà présents,aperçuSOURCE inchangé,trois fiches complètes et quatre copies vérifiées ;72+4 refus. Omission du filtre V627 corrigée,variables dynamiques et gameplay ouverts. Prochain passif à inspecter réellement :Sion. Goal actif.
