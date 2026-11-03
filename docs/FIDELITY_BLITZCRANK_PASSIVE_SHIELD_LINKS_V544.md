# SYS-01.2-02 — Blitzcrank : sources du Bouclier de mana, V544

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 à17:46:45 ; fuseau et date de déploiement inconnus. Catalogue4.20.1 distinct. **Traçabilité partielle ; aucun passif ou jeu accepté.**

## Intégration et prérequis

Les trois fiches CH-Blitzcrank-PASSIF-SOURCE, CH-Blitzcrank-PASSIF-SIMULATION-CONTRAT et CH-Blitzcrank-PASSIF-SIMULATION reçoivent36 arêtes vers12 sources natives. Les deux fiches de simulation reçoivent20 liens vers dix points de code, tous `entry_boundary_only` et `provides_feature_consumer=false`. Les lecteurs SOURCE et le chargeur partagé sont conservés sans promotion en déclencheur du passif. SYS-01.2-02 référence ce lot.

Phases D01/D06, lots et prérequis effectifs sont consignés dans le reçu sans déclarer leurs sorties achevées. Trois questions propres, quatre dépendances et références aux questions de leurs propriétaires restent exactes. Aucun inconnu ajouté ou fermé ; statuts, critères, cases, notes et historiques conservés.

## Sources natives

| Fichier | Identifiant |
|---|---|
| Blitzcrank.inibin | OLS-71d6b4e7-a4d7-5cca-8789-871a26034eea |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| BlitzcrankManaBarrierCD.inibin | OLS-d169b1b7-2dad-5a25-b2de-8875ec2c7840 |
| ManaBarrier.inibin | OLS-4d46a81a-6bf7-511c-a29f-70db5cb39f56 |
| ManaBarrier.luaobj | OLS-d2342baf-9886-5a7c-83b7-68815dc7d3d8 |
| ManaBarrier.preload | OLS-8db59512-c5e7-5767-af46-faf87a51ee43 |
| ManaBarrierCooldown.luaobj | OLS-14c6ac22-1902-5e5d-adca-2a6b4a6cfc9c |
| ManaBarrierIcon.inibin | OLS-7492b8f9-4479-5d09-8509-af0135fbb180 |
| ManaBarrierIcon.luaobj | OLS-189f00b3-e24c-5ec9-958d-3177c5f397ac |
| ManaBarrierIcon.preload | OLS-3232541e-833e-53b8-a8e5-805504595083 |
| CharScriptBlitzcrank.luaobj | OLS-67735fe6-81a9-577f-9383-108fcbe17bfc |
| CharScriptBlitzcrank.preload | OLS-9e1c1df6-966a-5cd2-9be0-8cb51226b044 |

Les12 fichiers correspondent en taille/SHA au registre et en taille/MD5 aux projets sélectionnés du manifeste RADS. La recherche porte sur les noms ManaBarrier et BlitzcrankManaBarrier dans DATA/Spells, la définition et les CharScript du champion. Quatre fichiers NightmareBotBlitzcrankManaBarrier sont identifiés et conservés à titre d’exclusions ; ils ne sont pas promus en règles du champion normal. Ce périmètre ne démontre pas une absence mondiale de sources serveur.

La définition déclare Passive1LuaName=ManaBarrierIcon. Les trois INIBIN lient exactement les infobulles ManaBarrierIcon, ManaBarrier et BlitzcrankManaBarrierCD. L’infobulle Icon, ligne2263 du font anglais, décrit un passage **sous20% de vie**, un bouclier de **50% du mana courant**, une durée maximale de **10secondes** et une recharge de **90secondes**. Les textes actif et recharge figurent aux lignes2262 et1731 ; la description du champion à4161 est conservée séparément.

Quatre Lua sont parsés jusqu’à leur fin et ne contiennent aucun prototype de callback enfant. ManaBarrierIcon fournit littéralement OnPreDamagePriority=8 : ce nombre ne prouve pas un callback ni l’ordre de création/absorption du bouclier. ManaBarrierCooldown déclare BuffName=BlitzcrankManaBarrierCD, correspondant au nom de l’INIBIN ; aucune politique d’alias exécutée n’en est déduite. Le chunk ManaBarrier est entièrement parsé, mais le lecteur d’initialisation littérale s’arrête sur NEWTABLE au pc8. Ses constantes incluent AutoCooldownByLevel et DoOnPreDamageInExpirationOrder ; leur présence ne suffit pas à attribuer des valeurs ou un comportement. **Cette limite du lecteur ne signifie pas que le fichier est corrompu.** Les preloads de steamgolemshield/steamgolemshield_hit ne constituent pas une validation visuelle.

La définition conserve un ancien texte concernant Alistar et les tourelles, des chaînes +400/+600PV et des niveaux6/12/18. Ils restent des littéraux non adoptés comme règles actives. Le champ Passive1 absent reste absent. La disponibilité initiale et la politique de niveau ne sont pas inventées à partir de ces valeurs. Quatre miroirs JSON communautaires et le C# CharScriptBlitzcrank vide de cette copie sont relus avec provenance ; ils ne deviennent pas le serveur original.

## Consommateur et diagnostic courant

Le chemin observé passe par l’ordre Attack, la libération mêlée, basic_attack_hit, apply_damage, absorb_shields et la perte de vie. Le tick avance les boucliers et la régénération. grant_shield crée un bouclier générique via une API d’événement serveur ; il ne constitue pas, à lui seul, le déclencheur de Mana Barrier. Le moteur absorbe les dégâts avec les boucliers déjà présents avant de réduire la vie.

Deux parties Map10 utilisent le vrai core non-test et la navigation réelle. Blitzcrank et Garen se déplacent par commandes publiques ; Garen porte des attaques ordinaires jusqu’au passage sous20%, puis est arrêté. Aucun dégât, vie ou mana n’est injecté directement. Aucun événement de bouclier n’est fourni avant le passage dans les deux parties.

Après la11e frappe au tick1321, la vie passe de144.427978515625 à97.94989776611328 sur582.5999755859375PV, soit24.79024795% vers16.81254752%. Le mana courant est267.20001220703125 ; sa moitié textuelle vaut133.60000610351562PV. Aucun bouclier n’est observé aux frappes initiales ni au passage.

Le second scénario fournit ensuite, explicitement, l’événement diagnostique `grant_shield(id,"diagnostic-control",100,300)`. Il s’agit d’un état témoin artificiellement créé par l’API serveur, **pas d’une activation du passif ni d’une commande client**. Les attaques, déplacements et dégâts demeurent ordinaires. Garen porte une frappe supplémentaire au tick1369 dans les deux cas, puis est arrêté de nouveau.

| Mesure à la frappe suivante | Sans événement témoin | Bouclier témoin100PV |
|---|---:|---:|
| Bouclier consommé | 0.0 | 46.534812927246094 |
| Vie perdue au-delà de la régénération | 46.534812927246094 | 0.0 |
| Vie finale au tick1621 | 68.43473815917969 | 114.96955108642578 |

Le bouclier témoin restant est présent juste avant son expiration et disparaît au tick1621,300ticks après l’événement. Cette vérification concerne l’expiration générique choisie pour le témoin ; elle ne valide pas la durée native de Mana Barrier. Les observations après la frappe sont conservées jusqu’à cette échéance ; sans témoin, aucun bouclier n’y apparaît. Les champions restent vivants, niveau1, sans fin de partie.

**Aucun déclenchement du bouclier passif n’est observé dans ce scénario.** La disponibilité initiale, la règle de niveau, l’égalité exacte à20%, l’ordre natif avant/après dégâts, la recharge90s et un second déclenchement restent non qualifiés. Ce diagnostic ne permet donc pas de déclarer la fidélité complète ou l’absence globale du passif. Aucun correctif gameplay n’est livré par cette tâche de liens source/consommateur.

## Refus, exécution et conservation

Six refus Attack sont vérifiés : joueur inconnu, cible inconnue et propre champion dans chaque cas. Dans le contrôle serveur, cinq refus grant_shield couvrent montant0, NaN, durée0, tag vide et cible inconnue. Les snapshots complets restent identiques après les refus. Les erreurs sont exactes dans les observations.

Build/run codes0 ; core non-test en cache, src_path F:/OpenLeague/crates/core/src/lib.rs. Dépendances et checksums alignés sur le Cargo.lock racine. Les1158 entrées source/ressource et anciens artefacts sont exacts ; aucun ancien diagnostic relancé. Aucun code produit ou asset modifié. Aucun client/serveur original, VM Lua, GPU ou réseau exécuté.

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-blitzcrank-passive-shield-probe.exe` ; 6041088octets ; SHA256 `ad9fad9534b1a2d38c58e30d99d564d4d3e04cf8760e99188f73044127d6a862`. Commandes, journaux, outils, manifeste privé, lock et code du driver sont dans revision544_Blitzcrank_passive_probe/OBSERVATIONS.json. Le contrôle serveur artificiel est distingué du scénario sans injection de bouclier dans chaque résultat.

Inspection/prepare/check/publish/audit réussis.66 associations invalides et quatre graphes invalides sont refusés : témoin présenté comme passif, priorité prise pour callback, NEWTABLE pris pour corruption, anciens textes ou bots adoptés, disponibilité/niveau/recharge/ordre faussement prouvés, faux bouclier, question étrangère, identité ou dépendance modifiée.

Par base réelle : quatre destinataires actualisés,42603 autres lignes de catalogue,42607 états manuels et23 événements historiques exacts. Store.task/copy_text/summary, questions/dépendances, integrity_check et sync_catalog idempotent vérifiés. Trois fragments changent,42212 restent exacts ;42211 autres objets tâche/trace et anciens descripteurs conservés. IDs, hiérarchie et registre des inconnus restent identiques en octets.

Réexamen :42215 exigences,98851 sources,2845 consommateurs ;26189 inconnues ouvertes et5517 résolues. Les2845 ancres et les octets de527 fichiers correspondent, zéro divergence ;17 auxiliaires conservés. Ce n’est pas un nouveau contrôle physique de toutes les98k sources. Les8350 fiches CH au seul chargeur partagé restent une file de recherche, pas un taux de complétion.

## Livrables et suite

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json et fidelity_sources_4_20.json. Reçu docs/reference_requirement_trace_sources/blitzcrank-passive-shield-links-v544.json ; preuve docs/fidelity_blitzcrank_passive_shield_links_v544.json. Quatre lignes données/consignes changées par base. Couverture, plan documentaire, reprise, CURRENT et HANDOFF actualisés avec sauvegardes et anciens champs conservés. Scripts exécutés sur F et archivés. Aucun stage/reset/commit.

Restent ouverts le corps serveur original, le déclencheur autoritaire, disponibilité/niveau, ordre, recharge/réactivation, mort, types de dégâts, interactions et présentation visuelle. Aucun passif, champion ou jeu déclaré complet.

Continuer SYS-01.2-02 depuis revision545_trace_review/REVIEW.json. V544 Blitzcrank est publié et audité : trois fiches,12 sources natives,36 arêtes et20 liens vers10 frontières. Passage24.79% vers16.81%vie au tick1321 après11frappes, aucun bouclier observé. Le témoin distinct grant_shield100PV/300ticks absorbe46.534812927246094 à la frappe1369 puis expire1621 ; ce n’est pas le passif. Texte20%/50%mana courant/10s/90s qualifié ; disponibilité initiale,règle de niveau,égalité,recharge et ordre natifs ouverts. Priorité8 littérale, NEWTABLEpc8 non qualifié, vieux textes Alistar/HP/niveaux et quatre variantes NightmareBot conservés sans promotion. Aucun code gameplay changé ni passif accepté ; inconnus/statuts/cases inchangés. Ne pas republier V544 ni relancer ses diagnostics sans cause nouvelle. Examiner ensuite Vladimir : Crimson Pact/VladimirBloodGorged, conversion40PV bonus→1AP et1AP→1.4PV sans cumul récursif, achats/ventes et vrais producteurs actuels de stats. Le lookahead anglais n’est pas encore qualifié avec les sources natives.108 autres contrats/parents restent à examiner ;8350CH au seul chargeur partagé restent une file de recherche, pas un taux de complétion. Goal actif.
