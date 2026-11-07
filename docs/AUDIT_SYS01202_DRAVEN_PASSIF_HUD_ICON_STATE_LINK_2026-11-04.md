# SYS-01.2-02 — Draven : liaison d’Adoration au HUD, V1209

4 novembre 2026. Unité `AUD-SYS-01.2-02-DRAVEN-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine ; mécanique, HUD complet, rendu et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Draven-PASSIF-PRESENTATION-HUD`, `OLF-584a071c-8fb6-51c3-8586-a245aacdd119`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance `CH-Draven-PASSIF-NETWORK`. L’inconnue `OLU-2be81c51-cf04-5516-ae53-0f4e9c673fde` reste ouverte.

Ce lot relie déclarations passif/charges/or et consommateurs HUD courants. Passive, PassiveStacks et Spinning/Q gardent leurs rôles distincts ; Q ne reçoit aucune clôture. Mouvement V564/V563, autres compteurs et voies génériques restent des périmètres séparés.

## 2. Sources, identité et provenance

Référence PUBLIC4.20.0.315 EUW/en_GB, build littéral2014-11-17 17:46:45 ; fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Treize identités V565 datées réutilisées sans rehash des métadonnées natives. SOURCE19relations/13identités, HUD deux relations vers la définition `OLS-de854af7-8098-58e8-9090-8d859ab32b6b` et CharScript `OLS-2258e080-5901-564d-897c-fa413c7f4a71`. Les39associations historiques couvrent trois tâches, pas39ressources.

`Passive1LuaName=DravenPassive`, `Passive1Icon=Draven_passive.dds`, BuffName/texture concordants. Passive1/Passive1Desc et six niveaux absents, sans valeur de repli. Cinq Lua hérités entièrement parsés, sans prototype enfant : quatre initialisations littérales ; Spinning refusé par le lecteur à NEWTABLEpc10, sans diagnostic de corruption. CharScript natif vide. Flags PersistsThroughDeath/NonDispellable ne démontrent ni compteur ni perte de moitié. CharScript communautaire vide et Q.cs simplifié ajoutant buff/particule restent sept références séparées, sans rattrapage natif prouvé.

Inventaire exact avant les deux lectures DDS,9840octets :

| Chemin | Octets / format | Membre core0.0.1.7 |
|---|---|---|
| DATA/Characters/Draven/HUD/Icons2D/Draven_passive.dds | 4224 / 64×64 DXT5, 1mips | 0.0.0.235 |
| DATA/Spells/Icons2D/Draven_passive.dds | 5616 / 64×64 DXT5, 7mips | 0.0.0.169 |

- `DATA/Characters/Draven/HUD/Icons2D/Draven_passive.dds` : `8b76dfdd72ae0ff38590d8f120401c1158ac7a7c3a09e3306b883c9a51ee7888`.
- `DATA/Spells/Icons2D/Draven_passive.dds` : `00134909f6d0d7a894b1d41f0528b81702960df01a7c41a3f333c34caa69bafd`.

Deux contenus distincts sous le même basename : tailles/MD5 conformes au manifeste sélectionné, sans priorité de lookup ou corruption inférée. Captures E exactes issues des lectures D de ce lot ; aucun OLS créé, pixels/rendu non qualifiés.

Découverte V565 déjà épinglée capturée byte-identique E,303109octets/SHA `dc42a110f766b8eeaa5cec7ba7225d0014d9978d76f11908cc0c8c346b4655ff`, pour préserver les références des deux preloads,3et8déclarations. Original horsracines non rouvert au gate, gardes inchangées ; preloads sans allocator ou animation qualifiés.

Cinq clés en_GB uniques : passive1848, Stacks1849, Q1850, description4180, nom4356. Le passif déclare une charge au rattrapage ou à l’élimination sbire/monstre/tour ; un kill champion consomme les charges et paie f4+f1parcharge ; la mort en retire la moitié. f2/f3 décrivent total gagné/meilleure récompense ; SourceName appartient aux tooltips Stacks et Q. Fournisseurs, valeurs et arrondi restent inconnus. Provenance font V565/reçu Ahri exact/empreinte du miroir F comparée ; Font D non relu, locale effective ouverte.

## 3. Consommateurs courants

Le CID HUD enregistré `OLC-93924678-ea15-5516-8f55-08616c5450cc` est le catalogue appelé par `Simulation::new`. Catalogue et cinq sites lecteurs SOURCE restent des frontières de données.

Provider/StartupHud et plugins ordinaires sont montés. Les18textes/11barres/14widgets QWER-D/F et payloads inspectés n’identifient aucun binding Adoration icône/texte/rang/charges/consommation/statistiques d’or. Buff0/BuffIcon0/BuffStack0 restent dédiés à Ezreal ; F3/Annie4, HP/Mana et états QWER distincts. Configurations QWER et coûts ne prouvent pas des capacités implémentées. Recherche .rs corroborative après les corps, sans absence globale de code, alias ou assets.

GoldStat valide la finitude/plage unsigned32 puis affiche floor(player.gold), portefeuille courant, pas total gagné/meilleure récompense ou compteur. reward_champion_death attribue les récompenses ordinaires et score/événement ; world attribue l’or des unités, passive_gold les paiements ambiants. Mort/réapparition et effets génériques existent sans chemin de consommation/perte de moitié Adoration identifié dans les corps inspectés. Leur existence ne prouve ni rattrapage de hache, ni produit réseau ou HUD du passif.

## 4. Attendu, observé et contrôles

Attendu : charges/consommation/or propres au passif et audiences autoritaires reliées aux widgets qualifiés. Observé : sources identifiées, voies ordinaires réelles, aucune liaison Adoration spécifique établie dans le trajet inspecté. Sources59/59, consommateurs43/43 contrôles documentaires ; aucun nouveau nominal/refus HUD exécuté.

Seize pins/29fenêtres communs, treize fichiers/24sites V565 et deux lecteurs/six sites SOURCE concordent. Auxiliaires sélectionnés comparés et 2pins/8fenêtres directes ; inventaires et analyses historiques réutilisés sans census.

V565 : Draven frais, Caitlyn témoin et Draven après trois sbires crédités ; six kills donnent400/300or nets ordinaires, après retrait par tick des paiements ambiants8 aux frontières locales75s puis5s. Aucun supplément observé ; trois sbires crédités ne sont pas trois charges internes observées. Les123baisses de santé ne sont pas123impacts attribués :71avec projectile au snapshot précédent,52sans. Attribution des récompenses appuyée sur événements de mort et or, pas cette étiquette d’impact corrigée. Quarante-cinq refus atomiques historiques ; victimes réapparues naturellement, pas preuve de la mort de Draven ou de sa perte de charges. Mouvement V564 et chaîne V563 conservés, non résolus par ces parcours. Aucun replay, build, test produit, VM, REA, runtime, GPU, audio, réseau ou rendu exécuté ici.

## 5. Écarts et inconnues

f1/f2/f3/f4/SourceName, compteur/rang, rattrapage, monstres/tours/attribution, durée/persistance, consommation/perte de moitié/arrondi, simultanéité, statistiques d’or, lookup/états, audiences/confidentialité, mort/reconnexion et rendu restent ouverts. Or disponible, récompenses ordinaires et preloads ne remplacent pas Adoration. Aucun besoin de reconstruction graphique démontré.

## 6. Correction et reprise

Réutiliser `CH-Draven-PASSIF-PRESENTATION-HUD`, NETWORK et dépendances SOURCE/SIMULATION ; aucune tâche créée. Six critères : qualifier ressources/textes/rangs/lookup4.20 et substitutions ; qualifier état autoritaire charges/catch/consommation/perte/or et audiences ; intégrer widgets/refus sans faux zéro/activation ; vérifier incréments effectifs, kill/cashout, absence de double paiement, propre mort/arrondi, reconnexion/confidentialité et rendu identifié ; séparer portefeuille/revenus ordinaires/Q et autres compteurs du passif ; obtenir l’acceptation humaine applicable séparément. Reprise sur primaire, mapping, producteur/consommateur ou contrat pertinent, ou dérive précise, sans rejeu inchangé. Mouvement reste dans ses tâches existantes.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_draven_passive_hud_20261104` : source_worker/sourceproof.json, captures/manifestes, reçu consommateur, scripts/journaux/archives, result.json et finalpeer_review.json. Publication racine : rapport et ajouts CURRENT/HANDOFF seulement, sauvegardes exactes et sept protégés contrôlés avant/après puis relus.

Une clôture d’audit borné après ces contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification fonctionnelle non exécutée, fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
