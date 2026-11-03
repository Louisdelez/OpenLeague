# SYS-01.2-02 — Volibear : sources du seuil et de la régénération, V541

25 octobre 2026 — F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral du 2014-11-17 à 17:46:45. Fuseau et déploiement inconnus ; catalogue 4.20.1 distinct. **Livraison de traçabilité partielle ; aucun passif ou jeu complet accepté.**

## Intégration et prérequis

Les fiches CH-Volibear-PASSIF-SOURCE, CH-Volibear-PASSIF-SIMULATION-CONTRAT et CH-Volibear-PASSIF-SIMULATION reçoivent 39 arêtes vers 13 sources natives. Les deux fiches de simulation reçoivent 20 liens vers dix frontières de code qualifiées `provides_feature_consumer=false`. Les lecteurs d’audit SOURCE sont conservés, sans promotion en mécanique de jeu. SYS-01.2-02 référence ce résultat.

Les phases D01/D06, lots et dépendances réels sont identifiés dans le reçu ; leurs sorties complètes ne sont pas déclarées atteintes. Trois questions propres ouvertes, références des questions de dépendances et quatre dépendances restent exactes. Aucune question ajoutée ou fermée ; statuts, critères, acceptations, cases, notes et historique conservés.

## Sources et portée

| Fichier | Source enregistrée |
|---|---|
| Volibear.inibin | OLS-6cc99ef3-758d-5380-991a-f4346763a390 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| VolibearPassiveBuff.inibin | OLS-2f7c0efd-eb33-5de4-8890-4139da069c76 |
| VolibearPassiveBuff.luaobj | OLS-7df1d1f8-620d-52d1-8cb0-a5e707bbccfa |
| VolibearPassiveCD.inibin | OLS-edb4a7bd-c955-5675-b314-efa44743e46a |
| VolibearPassiveCD.luaobj | OLS-82914ccb-ca5d-5fbb-9074-dec3b305ce3a |
| VolibearPassiveCD.preload | OLS-a9a4d78f-3260-5d33-a9d3-a9fc9d45d061 |
| VolibearPassiveHeal.inibin | OLS-e44073da-8d0f-5162-8969-2bb9445115a9 |
| VolibearPassiveHeal.luaobj | OLS-2620ad9b-c017-5480-aba1-ace20e06eadc |
| VolibearPassiveHealCheck.luaobj | OLS-4548d2d7-ce0a-5221-9469-1acb31c14fa1 |
| VolibearPassiveHealCheck.preload | OLS-0424042d-bc5e-58b9-b6df-f458b74f2301 |
| CharScriptVolibear.luaobj | OLS-475277e0-e332-5b94-be61-a530573bce14 |
| CharScriptVolibear.preload | OLS-56d4b904-c769-5b71-8bd9-bab5fd4364f9 |

Les 13 payloads correspondent en taille/SHA au registre et en taille/MD5 au manifeste RADS sélectionné : définition, font anglais, trois INIBIN de buffs, cinq Lua et trois preloads. Cette appartenance ne prouve pas une priorité d’alias ou une règle du serveur original. La recherche couvre les candidats nommés dans DATA/Spells et Characters/Volibear/Scripts ; aucune absence globale n’est déduite.

Volibear.inibin déclare Passive1LuaName=VolibearPassiveBuff. Les trois INIBIN lient directement les clés anglaises VolibearPassiveBuff/CD/Heal, lignes 2914 à 2916. L’infobulle principale décrit **un passage sous 30 % de vie, un soin de @f1@ % de la vie maximale sur six secondes et une recharge de deux minutes**. La conversion de deux minutes en 120 secondes est arithmétique ; le mécanisme de recharge n’est pas reconstitué par le texte.

Les cinq Lua sont parsés intégralement et n’ont pas de prototype de callback enfant. VolibearPassiveBuff conserve littéralement un espace final dans `VolibearPassive.dds `. VolibearPassiveHealCheck contient OnPreDamagePriority=8 et une référence d’icône Blitzcrank_ManaBarrier.dds. Son preload mentionne notamment manabarrier et steamgolemshield_hit.troy. VolibearPassiveHeal déclare l’effet volibear_passive_heal.troy. Ces données restent des déclarations : aucune normalisation silencieuse du nom, aucun bouclier de Volibear ou callback de pré-dégât n’en est déduit. Les politiques de chargement, mort et dissipation restent à qualifier.

Trois miroirs JSON communautaires et CharScriptVolibear.cs sont relus avec leur identité et provenance enregistrées. La classe C# est vide dans cette copie. Cela ne prouve ni la fidélité au serveur natif ni l’absence mondiale d’une autre implémentation. Les ressources référencées par preload/VFX ne sont pas qualifiées visuellement dans ce lot.

## Diagnostic exécuté dans le core courant

Deux simulations Map10 utilisent le vrai core non-test et la navigation réelle. Volibear et Garen adversaires rejoignent des cellules praticables par commandes publiques. Garen blesse Volibear par attaques ordinaires ; Volibear ne reçoit aucun dégât ou soin injecté et aucun champ n’est modifié directement.

Garen est arrêté une première fois quand Volibear est sous 40 % mais au-dessus de 30 %. Une fenêtre de 180 ticks vérifie la régénération de base. Les attaques reprennent ensuite jusqu’au passage sous 30 %, puis Garen est arrêté de nouveau. Une seconde fenêtre de 180 ticks observe la vie. Dans la partie témoin seulement, une potion2003 achetée avant le déplacement est utilisée publiquement après ce passage.

Le passage est obtenu au tick 1364 après 10 frappes ordinaires au total, de 34.77638125 % à 26.94986070 %. Garen n’a plus de cible ni windup pendant les fenêtres. Volibear reste vivant, niveau1 et sous sa vie maximale. Dans le cas ordinaire, il reste sous 30 % pendant toute la seconde fenêtre.

| Mesure sur les 180 ticks après passage sous30% | Sans potion | Avec potion témoin |
|---|---:|---:|
| Vie au début | 157.51654052734375 | 157.51654052734375 |
| Vie finale | 167.2257080078125 | 227.22479248046875 |
| Régénération de base, PV/s | 1.618399977684021 | 1.618399977684021 |
| Soin ajouté au-delà de la régénération | 0.0 | 59.99908447265625 |

Le diagnostic calcule à chaque tick l’attente f32 après la seule régénération et la soustrait à la vie observée. Les 180 résidus sont nuls dans le cas ordinaire. Avec potion, chacun vaut 0.3333282470703125 PV. Les fenêtres au-dessus du seuil ont également des résidus nuls, y compris lorsque la potion est portée mais pas encore consommée.

Le code courant mène de l’ordre Attack à la libération mêlée, basic_attack_hit, apply_damage et la perte de vie. Le tick appelle la régénération ; celle-ci comprend la base et le chemin spécifique Garen déjà existant. La potion suit UseItem puis advance_consumables. Ces chemins génériques et la potion ne constituent pas un producteur accepté du passif Volibear.

**Aucune régénération spéciale n’est observée pendant les six secondes suivant le passage sous30 % dans ce scénario.** Le montant f1 et la disponibilité initiale du passif restent inconnus ; l’essai ne prouve pas la condition exacte d’égalité à30 %, le comportement de la recharge120 s, un second déclenchement ou la fidélité historique complète. Aucun correctif gameplay n’est livré par cette tâche de traçabilité.

Refus exécutés : dans chaque cas, joueur inconnu → unknown player, cible inconnue → unknown target, propre champion → invalid enemy target. Avant blessure, UseItem est refusé par empty inventory slot sans potion, puis health already full avec potion. Aucun refus n’a consommé la potion du cas témoin.

## Identité et validations

Build/run : codes0, dépendances et checksums identiques au Cargo.lock racine ; core en cache, src_path F:/OpenLeague/crates/core/src/lib.rs et profil non-test. Les 1 158 entrées source/ressource et anciens binaires/manifests/locks restent exacts. Aucun diagnostic Nasus/Warwick relancé.

Binaire : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-volibear-passive-healing-probe.exe` — 5943808 octets — SHA256 `f080fab31c970b35875a1f371631b06ecb1a2d8476677fcd0a90631ae697f7a7`. Commandes, journaux, outils, manifeste privé, lock et code du driver sont identifiés dans revision541_Volibear_passive_probe/OBSERVATIONS.json. Aucun client original, serveur original, moteur Lua, GPU ou réseau exécuté.

Inspection/prepare/check/publish/audit : réussis. Soixante associations invalides sont refusées : potion prise pour passif, faux f1, faux callback de priorité, bouclier déduit des références Blitzcrank, disponibilité initiale inventée, égalité/recharge faussement testées, faux correctif/acceptation, identité ou résultat modifié, question étrangère et dépendance retirée. Quatre refus du lecteur public couvrent source/consommateur absents, fausse acceptation et question appartenant à une autre fiche.

Les deux bases réelles sont vérifiées par Store.task/copy_text/summary, dépendances, résolution des questions, integrity_check et sync_catalog idempotent. Par base : quatre destinataires actualisés, 42 603 autres lignes de catalogue exactes, 42 607 états manuels et 23 événements historiques exacts. Trois fragments de consignes changent ; 42 212 restent exacts. Les 42 211 autres objets tâche/trace et tous anciens descripteurs sont conservés. Identifiants, hiérarchie et inconnus restent identiques en octets.

Précision sur le nom hérité du vérificateur : `copy_has_regeneration_lifesteal_and_f1_limits` désigne ici le contrôle réel des chaînes f1, régénération, potion, résultat59.99908447265625 et disponibilité initiale dans la copie. Le prédicat a été relu ; le mot lifesteal dans cet ancien nom ne constitue pas un test du vol de vie de Volibear.

Réexamen : 42 215 exigences, 98 839 sources, 2 815 consommateurs, 26 189 questions ouvertes et 5 517 résolues. Les 2 815 ancres et identités de 527 fichiers correspondent, zéro divergence ; 17 auxiliaires conservés. Ce contrôle n’est pas un nouveau census physique des98k sources. Les8 356 fiches CH au seul chargeur partagé restent une file de recherche, pas une preuve d’absence ou un pourcentage de complétion.

## Livrables et limites restantes

Registres modifiés : completion_tasks_2026-10-20.json, fidelity_requirement_trace_4_20.json, fidelity_sources_4_20.json. Inconnus inchangés. Reçu : docs/reference_requirement_trace_sources/volibear-passive-healing-links-v541.json ; preuve : docs/fidelity_volibear_passive_healing_links_v541.json. Quatre lignes de données/consignes changées par base. Couverture, plan documentaire, reprise, CURRENT et HANDOFF actualisés avec sauvegardes et conservation des anciens champs.

Les nouveaux scripts sont exécutés depuis F:/OpenLeague-work après préparation ; copies exactes archivées avec la livraison. Les preuves conservent leurs chemins réels locaux, sans revendication de portabilité. Aucun code produit ou asset changé ; aucun stage/reset/commit.

Restent ouverts : fournisseur de f1, disponibilité initiale et producteur autoritaire du soin, égalité précise au seuil, recharge/réactivation, mort, cibles/types de dégâts, réduction et amplification des soins, et présentation visuelle. Les111 autres contrats/parents restent à examiner.

Continuer SYS-01.2-02 depuis revision542_trace_review/REVIEW.json. V541 Volibear est publié/audité : trois fiches,13 sources natives,39 arêtes et20 liens vers10 frontières. Attaque ordinaire au tick1364 :34.78% vers26.95% de vie ;180ticks suivants sans régénération supplémentaire, potion témoin +59.99908447265625 PV. Trois infobulles lient seuil30%, durée6s et recharge2min ; f1, disponibilité initiale, égalité exacte au seuil et comportement de recharge restent ouverts. Métadonnées priorité8, Blitzcrank et espace final du nom de texture conservés sans règle inventée. Inconnus/statuts/cases inchangés ; aucun passif accepté ou corrigé. Ne pas republier ni relancer les diagnostics sans cause nouvelle. Examiner ensuite DrMundo : source du soin proportionnel à la vie maximale, formule et producteur de régénération courants, distincts de la régénération de base et des objets. Préserver les sources partielles, phases/lots et inconnues.111 autres contrats/parents restent à examiner ;8356CH au seul chargeur partagé sont une file de recherche, pas une preuve d’absence ou de complétion. Goal actif.
