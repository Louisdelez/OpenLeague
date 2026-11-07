# SYS-01.2-02 — Katarina : liaison de Voracity au HUD, V1231

4 novembre 2026. Unité `AUD-SYS-01.2-02-KATARINA-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture puis publication racine. Mécanique, HUD complet et acceptation restent ouverts.

## 1. Exigence et périmètre

`CH-Katarina-PASSIF-PRESENTATION-HUD`, `OLF-0b549c14-6615-582e-abc2-fca0a5ec9a56`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. `OLU-ab44f977-e92d-584e-afea-73c56a83cd2f` reste ouverte. Six contrats HUD, NETWORK, SIMULATION, CONTRAT, SOURCE, ACCEPTANCE et leurs six inconnues propres sont conservés ; PRESENTATION parent distinct.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Primaire V586 UTC 2026-10-26T04:32:33.330516+00:00 ; MD UTC 04:39:42.719947. Dates documentaires, sans date d’exécution déduite.

V586 :12 identités natives/36 associations sur trois tâches. SOURCE actuel :14 relations/12 identités ; HUD :une relation définition. Captures historiques conservées exactement sur E avec provenance/empreintes ; chemins F-work inertes. Métadonnées/font/INIBIN/Lua/DDF/preloads ne sont pas relus sur D.

Passive1LuaName=Voracity, icône Katarina_Voracity ; description liée4213 :15secondes de réduction après élimination/assistance. BuffData lie game_buff_tooltip_Voracity2922 :10secondes sur Death Lotus et rafraîchissement des sorts de base. Les deux liaisons sont réelles ; leur priorité demeure indéterminée. Aucune variante n’est choisie automatiquement.

Voracity, fichier global KatarinaPassive, dépendance katarinapassive et BuffName=KatarinaPassive restent distincts. Trois chemins non retrouvés dans V586 :Voracity.inibin/.luaobj globaux et KatarinaPassive.inibin personnage ; pas d’absence universelle déduite. Deux clés MaliceAndSpite de SpellData.DynamicTooltip/Description manquent au font sélectionné ; elles ne remplacent pas BuffData Voracity.

Deux Lua entièrement parsés, deux initialisations littérales, aucun prototype enfant. Globals CharScript natif et classe communautaire CS vides ; buff persistant/non dissipable et flags restent déclaratifs, sans callback/lifecycle effectif qualifiés. Deux preloads référencent katarinapassive,apbonusdamagetotowers et katarina_spell_refresh_indicator.troy, sans politique de remboursement ni rendu acceptés. DDF28 n’a pas de formule passive :DeathLotus;f1 bonusAD×5 et KatarinaR;f1×3 sont des contextes distincts de sorts. Sept références communautaires restent secondaires.

Délais normaux déclarés :Q10/9,5/9/8,5/8 ; W4 ; E12/10,5/9/7,5/6 ; R90/60/45. Champs supplémentaires de rang6 et zéros R hors rang normal conservés sans adoption. Rangs passifs et coûts inspectés absents, sans valeur par défaut inventée.

Inventaire exact avant lecture :trois candidats/7920octets. Payloads nécessaires :

| Chemin lu | Octets | Format | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/Katarina/Info/Katarina_Voracity.dds | 2872 | 64×64, DXT1, mip brut 7 | 0.0.0.116 |
| DATA/Spells/Icons2D/Katarina_Voracity.dds | 2872 | 64×64, DXT1, mip brut 7 | 0.0.0.116 |

Deux lectures/payloads5744octets,un contenu SHA`29a518d7813fe25a91e23bfbd0cde730512d7adf75cd6ce6790a67a313726672` ; tailles/MD5/membership vérifiés. Homonyme Orianna/Info2176octets/member40,MD5 différent de manifeste,non lu. Identité de contenu des deux captures ne qualifie ni priorité,lookup,alias,rang,pixels ni rendu. Localisation en_GB et témoin Ahri identifiés sur miroir F ; aucune relecture font D, locale effective ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new ; SOURCE :quatre sites/deux fichiers, catalogue et trois fonctions INIBIN. V586 :22sites/13fichiers, plus un lecteur INIBIN. Aucun lecteur Lua ajouté à cette liaison SOURCE. Contribution/crédit de mort,or d’assistance,or ambiant,dégâts létaux,attaques mêlée/régénération,CDR et refus d’apprentissage/cast sont inspectés. La branche profile.melee utilise basic_attack_hit et Windup.release.

La fenêtre générique d’assistance est450ticks ; son équivalent15s ne constitue pas un montant de remboursement. CDR/Codex et création/décompte des délais sont distincts de Voracity. Aucun producteur spécifique identifié dans les corps inspectés, sans absence globale déduite. Katarina est refusée avant rang/délai ; un zéro n’établit ni remboursement ni refresh. Lifecycle/départ sont ici statiques. Mécanismes spécifiques d’autres champions conservés sans transfert.

Provider/StartupHud,barres,QWER,Buff0 Ezreal,F3/Annie et snapshot/session/horloges existent sans liaison Katarina icône/texte/rang/état autoritaire établie. QWER :cinq icônes,quatre primaires/une variante E,zéro unresolved ; cela ne constitue pas le passif intégré.

## 4. Attendu, observé et contrôles

Attendu :contrat natif résolu et délai réel réduit,ressources reliées aux widgets/audiences applicables. Observé :sources contradictoires,crédits ordinaires et refus actuels,liaison spécifique non établie. Sources 69/69,relecture E 86/86 ; consommateurs 67/67 et leur relecture10/10 hérités ; projection documentaire E 17/17. Seize entrées/29 fenêtres communes,22ancres V586,quatre SOURCE et 10pins/20fenêtres directes vérifiés. Capture DDS unique, deux lectures5744octets. Producteurs source trois sorties[1,1,0] :KeyError de sélecteur suffixé .inibin, puis attendu SOURCE6/3 hérité ; attendus corrigés au schéma et périmètre réels4/2, sans réécrire les métadonnées. Scripts/logs binaires/commandes/contrôles refusés archivés. Collecteurs deux sorties[1,0] :premier65/66 refusé sur ce périmètre, puis67/67. Préparations/encodage corrigés avant collecte conservés. Aucun diagnostic historique rejoué. Relecture finale :le MD C conservait deux passages6/3/2/15 et28ancres malgré JSON4/2/1/14 et26. Projection E-only corrigée,originaux archivés. JSON,67contrôles,118entrées et collecteur exécuté inchangés ; 17nouveaux contrôles documentaires,ancienne relecture10 héritée. Générateur corrigé préparé séparément,non exécuté. Ancien paquet racine non publié archivé avant reconstruction.

V586 hérité :quatre parties Map10,45 impacts mêlée non critiques :38 Katarina(11+11+8+8),7 Garen(0+0+3+4). Chaque baisse de santé a un windup source/cible,release au tick exact ; autres ticks corrigés de régénération. Aucun projectile ni impact non attribué substitué à ces témoins. Quatre morts ordinaires :deux kills Katarina,une assistance récente et une contribution expirée.

Deux kills donnent chacun400or dans leur partie indépendante ; assistance113ticks après contribution,86,875or de crédit ; contribution expirée612ticks,aucun crédit Katarina,après451ticks d’attente supplémentaire. Or ambiant séparé.112 refus sans mutation,720ticks de suivi plus451ticks d’attente. Codex3108 donne10%CDR/30AP dans un cas kill,mais aucun délai n’est activé :rangs/délais[0,0,0,0],sorts refusés. Aucun montant10/15s ou refresh n’est mesuré. Les crédits et exclusions sont des témoins locaux, sans qualification de la fenêtre native d’assistance.

Premier BUILD historique101 :diagnostic utilisait Windup.releases,champ réel release. Source/script/journal/reçu conservés ; variante qualifiée corrige ce seul champ,BUILD/RUN0,aucun moteur modifié. Binaire qualifié6284800octets,SHA`60bc0f173d205ffe555dc7f21a19beb3a63f21ac591cea92249da055b164658f`. Aucun nouveau build,jeu,VM,REA,réseau,GPU,audio/rendu ; KassadinCHECKinitial/stockage/Jax/V564 conservés,sans recovery/nettoyage/copie de bases.

## 5. Écarts et inconnues

Priorité15s versus10sR+refreshbase,mapping effectif Voracity/KatarinaPassive/MaliceAndSpite,admission QWER/délais activés,plancher/ordre CDR/rangs,crédits simultanés/en chaîne/dernier tick,capacités engagées/canalisation,contributions indirectes/pets/exclusions,lifecycle/session/reconnexion/fin,rangs/lookup/états/audiences et rendu restent ouverts. Aucun modèle/texture manquant déduit de callbacks absents.

## 6. Correction et reprise

Réutiliser `CH-Katarina-PASSIF-PRESENTATION-HUD`,NETWORK et SOURCE/SIMULATION. Résoudre sur preuve la priorité des textes et les mappings sans choisir le cas le plus facile ; qualifier paramètres/rangs/coûts et lancer des sorts pour armer de vrais délais. Relier crédits natifs qualifiés à la réduction/refresh autoritaire,puis HUD/audiences avec refus/retrait des données absentes,invalides,périmées ou non autorisées. Vérifier10/15s selon contrat établi,planchers/CDR/rangs,assistance récente/expirée,chaînes/simultanéité/expiration,canalisation/invocations,lifecycle/reconnexion et rendu identifié. Garder témoins de crédit/or génériques et acceptation humaine distincts. Reprise sur primaire,mapping,producteur/consommateur ou dérive précise,sans replay inchangé.

## 7. Livraison et décision

Preuves :`E:/mapslol3v3/audit_sys01202_katarina_passive_hud_20261104`,sources/consommateurs/scripts/journaux/archives/result/finalpeer. Préparateur f9/vérificateur V1226 réutilisés,toutes entrées/archives incluses. Publication :rapport+ajouts CURRENT/HANDOFF,sauvegardes exactes,sept protégés avant/après/readback.

Une clôture bornée après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK,inconnue,fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
