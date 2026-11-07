# SYS-01.2-02 — Hecarim : liaison de Warpath au HUD, V1220

4 novembre 2026. Unité `AUD-SYS-01.2-02-HECARIM-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture et publication racine. Mécanique, HUD complet, fidélité native et acceptation restent ouverts.

## 1. Exigence et frontière

`CH-Hecarim-PASSIF-PRESENTATION-HUD`, `OLF-4098dea3-19bd-54cc-917d-eca134bc6185`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. L’inconnue `OLU-4b01f9ab-9275-58d4-9343-c55ab7795289` reste ouverte.

Ce lot distingue conversion de vitesse bonus en AD, passage entre unités, vitesse affichée, plafonds locaux, AD des objets et E/Ramp. Les calculs génériques ne sont pas une qualification de Warpath.

## 2. Sources, identité et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Reçu V575 UTC2026-10-26T01:16:47.291875+00:00 ; MD01:28:11.938449, date documentaire distincte sans date d’exécution déduite.

Onze identités datées réutilisées sans relire métadonnées, font, Lua ou DDF D. Les33 associations historiques concernent trois tâches. HUD possède une relation native, définition `OLS-052bbb16-2c48-5c43-8ad5-f4ffb9ac6c14`.

Passive1LuaName=HecarimPassive ; définition Hecarim_Passive.dds distincte du BuffTextureName Hecarim_Warpath.dds. PassLev1Desc1 lie la description. Niveaux recherchés non retrouvés : aucun zéro/rang déduit. Anciennes descriptions de critique d’alliés et vitesse d’attaque restent non adoptées.

Tooltip1984 : passage entre unités et AD égal à f2% de vitesse bonus ; f1 affiche le bonus AD courant. Description4199 et nom conservés. Les producteurs/formats et paliers restent inconnus ; total, bonus, valeurs avant/après plafonds ne sont pas interchangeables. Ramp1985/SourceName décrit Devastating Charge, capacité active distincte.

Quatre Lua entièrement parsés sans prototype enfant, trois initialisations littérales ; Ramp NEWTABLEpc10 dépasse le lecteur, sans corruption déduite. PersistsThroughDeath déclaré ne qualifie pas le recalcul à la mort. Deux preloads conservés ; références animations/particules E ne prouvent pas leur exécution.

DDF16 entrées RapidSlash/Ramp/W/Ult sans entrée passive dans ce fichier ; coefficients0.6/0.5/1.0 actifs ne fournissent pas f2. Aucune absence globale de formule déduite. Huit références communautaires et CharScript vide restent secondaires. Observations historiques capturées exactement E, origines F-work inertes. Chaînes en_GB brutes et témoin Ahri réel vérifiés sur miroir F, sans relire font D ; locale effective ouverte.

Inventaire exact avant les lectures DDS :

| Chemin | Octets / format | Membre sous core0.0.1.7 |
|---|---|---|
| DATA/Characters/Hecarim/Info/Hecarim_Passive.dds | 5616 / 64×64 DXT5, mip brut=7 | 0.0.0.87 |
| DATA/Spells/Icons2D/Hecarim_Warpath.dds | 5616 / 64×64 DXT5, mip brut=7 | 0.0.0.87 |

2 chemins, 1 contenu(s) SHA256 : `eed7a9156b981165861843d284814da44fa26bcac92b8ae3d86b417fb22b488b`. Captures E exactes, tailles/MD5 conformes au manifeste ; aucun OLS créé. Noms de ressource distincts conservés malgré une éventuelle identité des octets. Priorité, alias, pixels, choix effectif et rendu non qualifiés.

## 3. Consommateurs courants

CID HUD `OLC-93924678-ea15-5516-8f55-08616c5450cc` : catalogue appelé par Simulation::new. SOURCE : six sites sur trois fichiers, catalogue et cinq helpers dans deux lecteurs. Qualifications préservées sans promotion en HUD.

AD de base/croissance/objets/autels/ajustements et vitesse/modificateurs/plafonds sont réels. Aucune conversion Hecarim identifiée dans les corps inspectés. L’occupation utilise les alliés vivants et les rayons de navigation, sans exemption Hecarim identifiée. body_radius reste distinct ; les commandes et déplacements génériques ne qualifient pas le passage natif.

Provider/StartupHud et plugins ordinaires existent. Sélecteurs, barres, QWER, Buff0 Ezreal, F3/Annie et payloads inspectés n’établissent pas de liaison Warpath icône/texte/rang/f1/f2/état. Snapshot/projection/session/horloges génériques ne fournissent pas cette qualification. Aucun transfert du producteur Garen ni absence globale déduite.

## 4. Attendu, observé et contrôles

Attendu : bonus de vitesse qualifié, conversion/états autoritaires et ressources reliés aux widgets/audiences applicables. Observé : déclarations et voies génériques réelles, liaison spécifique non établie. Sources60/60, consommateurs55/55 contrôles documentaires ; aucun nouveau scénario produit/HUD exécuté.

Seize fichiers/29 extraits communs ;15 fichiers/29ancres V575 et sixSOURCE ;8 pins/19 fenêtres directes. Entrées, fenêtres et configurations sont vérifiées. Les deux composants ont réussi sans correction ni relance ; aucun diagnostic historique n’est rejoué.

V575 hérité : cinq cas publics,30impacts de mêlée,77refus,450ticks de suivi. Vitesses345,370 avec1001(+25),441.799988/467.799988 avec Soin ; AD61.375999 inchangé. Objet1036 donne séparément+10AD. Au moins un impact pendant chaque bonus Soin, résidu physique après régénération<0.002, sans critique.

Soin30%/30ticks et plafonds proviennent de contrats locaux, non d’un runtime natif qualifié ; conflit cooldown240/300s conservé. Expiration vitesse au tick30 et retour345/370 ne qualifient ni f2 ni la base native avant/après plafonds/ralentissements. Les capacités Hecarim restent refusées.

Quatre collisions publiques : allié Hecarim arrêté80=50+30 de navigation, Garen65=35+30 ; le80 ne prouve pas l’usage du rayon gameplay80. Tous deux traversent l’ennemi, minimum3.004350 et destination250.000061 atteinte : comportement partagé, pas preuve du passif. Sbires/monstres/obstacles et V564 restent ouverts.

Binaire hérité6084096octets, SHA256 `9c0bf4fbb737d84019e0b0306ab6d9bd5ac8b06890182ea497d0ef394de0889f`, build/run0 historiques, chaîne antérieure conservée. Aucun nouveau build, runtime, VM, REA, GPU, réseau, audio ou rendu ici.

## 5. Écarts et inconnues

f1/f2, niveaux, base de vitesse bonus, ordre des plafonds/modificateurs/ralentissements, arrondis, recalcul, catégories/équipes de passage, mort/réapparition, lookup/rang/états, audiences/reconnexion et rendu restent ouverts. Référence d’icône ou vitesse affichée ne remplit pas ces contrats. Aucun besoin de reconstruction graphique établi.

## 6. Correction et reprise

Réutiliser `CH-Hecarim-PASSIF-PRESENTATION-HUD`, NETWORK et SOURCE/SIMULATION ; aucune tâche créée. Critères : qualifier ressources/lookup/rangs et f1/f2 ; définir puis produire conversion de vitesse bonus et passage par catégories/équipes sans terrain interdit ; qualifier identité/session/fraîcheur/audiences/transitions ; relier le HUD avec refus/retrait des données absentes/invalides/périmées/non autorisées ; vérifier achats/ventes, effets temporaires/plafonds/ralentissements/niveaux, dégâts réels, collision, mort/reconnexion et rendu identifié ; préserver témoins génériques et acceptation humaine distincts. Reprise sur primaire, mapping, producteur/consommateur ou dérive précise, sans replay inchangé.

## 7. Livraison et décision

Preuves sous `E:/mapslol3v3/audit_sys01202_hecarim_passive_hud_20261104` : sources/captures/manifestes, consommateurs, scripts/journaux/archives, result/finalpeer. Publication racine : rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes, sept protégés avant/après/readback.

Une clôture d’audit borné après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Vérification statique et preuves datées ; fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code du jeu/assets inchangés ; SYS-01.2-02 actif/partiel.
