# SYS-01.2-02 — Jinx : liaison de Get Excited au HUD, V1227

4 novembre 2026. Unité `AUD-SYS-01.2-02-JINX-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique borné soumis à relecture puis publication racine. La mécanique, le HUD complet et l’acceptation restent ouverts.

## 1. Exigence et périmètre

`CH-Jinx-PASSIF-PRESENTATION-HUD`, `OLF-4d982620-2ee1-5d45-930f-9a9f766aeb4b`, exige icône, texte, rang et états. Contrat requis, `a_faire`, implémentation/acceptation `false`, dépendance NETWORK. `OLU-a1c2389b-175d-5a39-9ac1-5a55dbc90fe4` reste ouverte. Six contrats HUD, NETWORK, SIMULATION, CONTRAT, SOURCE, ACCEPTANCE et leurs six inconnues propres sont conservés ; PRESENTATION parent reste distinct.

## 2. Sources et provenance

PUBLIC 4.20.0.315 EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue 4.20.1 distinct. Primaire V582 UTC 2026-10-26T03:26:47.634463+00:00 ; MD UTC 03:34:36.134607. Dates documentaires sans date d’exécution déduite.

V582 possède 15 identités natives et 45 associations sur trois tâches ; SOURCE actuel : 21 relations/15 identités. HUD possède deux relations, définition et CharScript. Les captures historiques sont conservées sur E avec provenance/empreintes ; les anciens chemins F-work sont des identités documentaires. Aucune relecture native font/INIBIN/Lua/DDF/preload n’est nécessaire.

Passive1LuaName=JinxPassiveMarker, icône personnage Jinx_Passive. PassLev1Desc1 et les six champs de niveaux sont absents, sans valeur substituée. La description4207 est recherchée par clé explicite, sans liaison inventée depuis le champ absent. Les buffs Kill2114 et Marker2115 sont liés exactement. Le texte Marker décrit champion/tour/inhibiteur endommagé dans les trois secondes puis éliminé/détruit, avec 175% de vitesse décroissant sur quatre secondes. Cela ne fournit pas la courbe ni le callback serveur.

Six Lua entièrement parsés, six initialisations littérales et aucun prototype enfant ; CharScript vide. Marker déclare Bowmaster_Bullseye, Kill Jinx_Passive et Jinx_Passive_Buff.troy ; le moniteur déclare JinxCatchMe/Jinx_Hidden. Quatre preloads relient marker/run-cycle/kill/monitor. Leur `root` ne prouve pas une immobilisation. DDF72, dont16 lignes Vi et aucune JinxPassive, ne fournit aucune formule native de vitesse ; Q/minigun/totalattackdamage et références sociales Caitlyn/Vi restent distincts. Huit références communautaires/une classe vide restent secondaires.

Inventaire exact avant lectures : cinq candidats/17024octets ; deux homonymes ZyraPassive/member183 et ZyraThornPlant/member111 restent non lus. Payloads ciblés :

| Chemin lu | Octets | Format | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Characters/Jinx/HUD/Icons2D/Jinx_Hidden.dds | 2176 | 64×64, DXT1, mip brut 0 | 0.0.0.181 |
| DATA/Characters/Jinx/HUD/Icons2D/Jinx_Passive.dds | 2176 | 64×64, DXT1, mip brut 0 | 0.0.0.181 |
| DATA/Spells/Icons2D/Bowmaster_BullsEye.dds | 4224 | 64×64, DXT5, mip brut 0 | 0.0.0.25 |

Trois fichiers/8576octets ; Jinx_Hidden.dds : `1c5bcc4cf8c5d35ce6455b21b5f6c63f8cce75ac6fa2a6a230c0d9a7f4d464d8` ; Jinx_Passive.dds : `afdcaff341e95dde675be4636a004a0e71db8fe64b932b469cddd0e3e9c072f7` ; Bowmaster_BullsEye.dds : `d9a843e53ce1ad00fd295ab8554afd53e87feec91919b0d25185ae5b8f06c9eb`. Tailles/MD5/membership vérifiés. La casse déclarée Bowmaster_Bullseye diffère du fichier Bowmaster_BullsEye : identité candidate conservée sans lookup/alias automatique. Personnage/Kill, Marker et moniteur gardent leurs rôles, sans remplacement ni qualification pixels/rendu. Localisation en_GB et témoin Ahri vérifiés sur miroir F ; aucune relecture font D, locale effective ouverte.

## 3. Consommateurs actuels

Le catalogue est appelé par Simulation::new. SOURCE couvre six sites/trois fichiers ; V582 couvre 24 sites/13 fichiers, plus deux lecteurs. Attaques/projectiles, dégâts/mort, récompenses/contributions, croissance ordinaire, or ambiant, structures, mouvement et réapparition sont des chemins réels inspectés.

La fenêtre générique d’assistance de15s n’est pas la condition Jinx de3s. speed_until reste gardé pour GarenQ ; Soin/relique/Trundle/ralentissements/plafonds sont distincts. Aucun producteur Get Excited n’est établi dans les corps inspectés, sans absence globale déduite. Les refus de sorts/rangs sont conservés. Provider/StartupHud, barres, QWER, Buff0 Ezreal, F3/Annie et snapshot/session/horloges existent sans payload Jinx autoritaire ni liaison spécifique icône/texte/rang/état établie. QWER possède cinq icônes, quatre primaires/une variante Q, zéro unresolved ; elles ne constituent pas le passif intégré.

## 4. Attendu, observé et contrôles

Attendu : déclenchement et état qualifiés, ressources reliées aux widgets/audiences applicables. Observé : déclarations et voies ordinaires réelles, liaison spécifique non établie. Sources 65/65, relecture E 61/61 ; consommateurs 62/62, relecture 11/11. Seize entrées/29 fenêtres communes,24 ancres V582,six SOURCE et 17 pins/24 fenêtres directes sont vérifiés. Un producteur source et une relecture E, sans échec. Avant collecte, un remplacement config trop large a été refusé sans créer préfixe/collecteur, puis limité au tuple ; une branche morte non exécutée a été retirée. Deux originaux archivés exactement. Un seul collecteur et une relecture, sans retry ; aucun diagnostic hérité rejoué.

V582 hérité : deux cas publics Jinx/Annie, base et bottes1001.48 baisses de vie avec projectiles source/cible témoins, quatre kills,34 refus sans mutation,720 ticks après kills et20 pas. Vitesses325/350 inchangées, récompenses400/300 par cas, or ambiant séparé. Aucun assistant. Les gains ordinaires d’XP/niveau ne deviennent pas un niveau constant supposé. Annie réapparaît naturellement avant la seconde élimination ; cela ne qualifie pas la vie du buff de Jinx.

Chaque fenêtre post-kill contient180ticks/six secondes : cinq pas puis175ticks après Stop, résidu<0,005. L’absence d’accélération est bornée à ces cas ; sans état créé, les fenêtres ne qualifient pas la courbe/expiration4s. Assistance/tours/inhibiteurs non exercés, structures statiques seulement. Refus publics QWER/cible morte/autres invalides séparés des contrôles de graphes.

Binaire historique6056960octets, SHA`73641609917d7aab84f0acc1650d89a0a7d4e54e30c8dbc933c70f3f1e1b1ea1`, BUILD/RUN0 hérités. Aucun nouveau build, jeu, VM, REA, réseau, GPU, audio ou rendu. Ancien PREPARE échoué sur stockage, trois essais de récupération interrompus, relocalisations et reçus conservés sans rejouer nettoyage/compression ni recopier des bases. V564/chaînes antérieures restent ouverts.

## 5. Écarts et inconnues

Déclenchement/contribution3s, attribution/invocations/assistance, destructions, courbe175%/4s, ordre de calcul/plafonds/arrondis, répétition/refresh, cibles/exclusions, niveaux, mort/respawn/déconnexion de Jinx, lookup/rang/casse, états/audiences/reconnexion et rendu restent ouverts. Aucun asset3D manquant n’est déduit de callbacks absents.

## 6. Correction et reprise

Réutiliser `CH-Jinx-PASSIF-PRESENTATION-HUD`, NETWORK et SOURCE/SIMULATION. Qualifier déclenchement3s et courbe4s/175%, catégories, attribution, durées/arrondis et lookup sans valeur/alias arbitraire ; produire l’état autoritaire via dégâts/mort/destruction ; intégrer vitesse et HUD avec refus/retrait des données absentes, invalides, périmées ou non autorisées. Vérifier frontières temporelles, assistance récente/expirée, structures, invocations, simultanéité, refresh, objets/ralentissements, mort/reconnexion et rendu sur binaires/ressources identifiés. Préserver témoins génériques/récompenses ; acceptation humaine distincte. Reprise sur primaire, mapping, producteur/consommateur ou dérive précise, sans replay inchangé.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_jinx_passive_hud_20261104`, sources/consommateurs/scripts/journaux/archives/result/finalpeer. Préparateur f9 et vérificateur racine V1226 réutilisés ; toutes entrées et archives incluses. Publication : rapport et ajouts CURRENT/HANDOFF, sauvegardes exactes, sept protégés avant/après/readback.

Une clôture bornée après contrôles ; zéro tâche complète HUD/SOURCE/NETWORK, inconnue, fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. Goal/Plan/UI/bases/registres/code/assets inchangés ; SYS-01.2-02 actif/partiel.
