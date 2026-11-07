# SYS-01.2-02 — Miss Fortune : liaison de Strut au HUD, V1247

4 novembre 2026. Unité `AUD-SYS-01.2-02-MISSFORTUNE-PASSIF-HUD-ICON-STATE-LINK-01`. Audit statique de liaison ; implémentation, runtime et acceptation restent distincts.

## 1. Exigence et périmètre

`CH-MissFortune-PASSIF-PRESENTATION-HUD`, `OLF-e9abfae2-847b-5b28-a0ac-1b415d8f8bee` : icône normale/grisée, texte, rang applicable, délai/charges et état de déplacement. Fiche requise a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-f6545778-3e65-52f4-b667-58f6663b13c4` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et leurs inconnues préservés ; parent PRESENTATION distinct.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB ; build littéral2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/missfortune-passive-strut-links-v602.json`,1405571 octets, SHA `5b2dd4979d4a5411cf20b0651fc715c4ce691abb71046f8cefe5e047d6c6d4cb`, UTC documentaire2026-10-26T09:04:00.731668+00:00 ; MD09:11:41.548164+00:00. Aucun horaire d’exécution déduit.

V602 :62 identités natives,186 associations/trois fiches,25 sites/50 liens. SOURCE :66 relations/62 IDs ; HUD :définition+CharScript client, non corps serveur. Métadonnées/font/INIBIN/Lua/preloads/DDF D réutilisés sans relecture.

Texte :5 secondes sans être attaquée, puis+25 vitesse,+8/seconde jusqu’à70. Buff « impact en combat » et cooldown « dégâts » ne déterminent pas tous les événements d’interruption. Passive1LuaName Draw a Bead reste un alias, sans politique Tristana. Descriptions/niveaux absents ne définissent pas une politique de rang. Strut et StrutStacks partagent l’icône normale ; StrutDebuff utilise la grise et le nom espacé. Persistance/non-dissipation ne prouvent pas le comportement mort/respawn.

MissFortunePassive/Stack désignent Impure Shots(W), distinct de Strut :coût50/délai16/rayon210/portée600/coefficient~0,05 non transférés. Neuf lignes BuffData/huit clés uniques, sept chaînes sélectionnées ; Strut/Stacks restent deux identités.27Lua(18 littéraux/9NEWTABLE,0enfant),13preloads,12lignes DDF QWER et25références communautaires ne prouvent pas les callbacks ; CharScript communautaire vide,six chemins candidats absents bornés.

Inventaire E avant lecture native :3 chemins/6528 octets/2 contenus ; SOURCE seule a lu ces DDS.

| Chemin | Octets | En-tête | Membre(lol_game_client0.0.1.7) |
|---|---:|---|---|
| DATA/Characters/MissFortune/HUD/Icons2D/MissFortune_Strut.dds | 2176 | 64×64 DXT1, mip brut1 | 0.0.0.239 |
| DATA/Spells/Icons2D/MissFortune_Strut.dds | 2176 | 64×64 DXT1, mip brut1 | 0.0.0.25 |
| DATA/Spells/Icons2D/MissFortune_Strut_Grey.dds | 2176 | 64×64 DXT1, mip brut1 | 0.0.0.79 |

L’égalité du contenu normal entre deux chemins n’établit pas la priorité de chargement. Membership/taille/MD5/SHA qualifiés, pas lookup runtime/variante/pixels/GPU. Localisation liée au témoin/mirror Ahri, locale effective ouverte. Historique ciblé :18fichiers/11591930octets,13anciennes empreintes concordantes et5identités actuelles sans hash historique. Les données catalogue/statistiques communautaires ne remplacent pas la définition native.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new ; SOURCE6 sites/3 fichiers, deux lecteurs inclus. V60225 sites/12 fichiers ; union14 fichiers/31 ancres. Initialisation/Action/Step/Snapshot, mouvement/collision/vitesse, dégâts/buffs/objets et frontières HUD examinés. Aucun producteur complet de délai/bonus/charges/reset Strut établi dans ces chemins. Les4 icônes QWER/0 non résolues ne constituent pas un état de passif autoritaire.

## 4. Attendu, observé et contrôles

Attendu :délai/bonus progressif et interruption conformes à une politique sourcée, puis présentation de l’état réel. Observé hérité :deux parties Map10 sans objet/avec bottes+25,1324 ticks d’attente,8 trajets mesurés,216 pas dont208 à pleine vitesse,2 AnnieQ reçus et54 refus atomiques. Vitesse325/350 constante ; aucun bonus Strut observé. Déplacement et dégât réel exercent le scénario malgré les sorts propres refusés ; sans bonus initial, le reset demeure non qualifié.

Les1324 trames d’attente ne donnent ni PV ni position ;84 snapshots propriétaire aux bornes des fenêtres sont conservés. Les216 pas ont chacun deux positions/distance/budget,208 complets+8partiels. Q :PV au début du cast puis après impact,différence61,4971923828125 ; pas de PV immédiatement pré-impact. Le montant reconstruit dépend des assertions de PV plafonnés et d’absence de dommage intermédiaire. Refus :flags/erreurs,sans paires brutes.34 snapshots complets(17/cas,10ticks distincts/cas) montrent18..42unités NPC et aucun ciblage participant à ces instants seulement. Garde de trajet limitée au voyageur vivant/winner ; autres gardes ne prouvent pas une exclusion universelle des NPC.

Sources42/42, relecture sémantique E37/37 ; consommateurs16/16, relecture E7/7. Relectures avant agrégation finale des pins ; identités finales contrôlées séparément. C105 courants/163 génération/union163 ;99 fenêtres/31 ancres/19 configurations/60 chemins matériels. Source :neuf jobs,huit codes0/un échec de sélection de schéma conservé ; producteur unique. C :collecte/relecture uniques réussies. Flux brut du bootstrap initial C indisponible(Tronqué),JSON logique et journal présents ; recherche exploratoire sur fichier absent exclue des conclusions. Classification Windows des enfants faible dans le sealer C ; contrôle exact indépendant argv/commande/reçu terminal dans root_material_inventory.

Binaire historique6057472octets,SHA `262a20e7cb4e690fa49c48767b82643cc83f83e52ab4e96efc3a9721774c197b`,copie E identifiée/inert ; répertoire revision536_yasuo_crit_probe_aligned simple localisation. BUILD/RUN bruts0 ; inspection numérique inconnue. Aucun nouveau build/jeu/VM/REA/réseau/rendu/audio/GPU.

## 5. Écarts et inconnues

Délai/augmentation/cap, événements d’interruption, charges/affichage, lookup/variante/native-vs-catalogue, rang, QWER/objets/lifecycle/réseau et acceptation restent ouverts. Le scénario sans bonus ne prouve aucun reset. Les limites de lecteurs ne prouvent ni corruption ni absence globale d’assets. Les montants de dégâts ne sont pas indépendamment recalculables comme une paire adjacente ; assertions héritées et observations sauvegardées restent distinctes.

## 6. Correction et reprise

Réutiliser `CH-MissFortune-PASSIF-PRESENTATION-HUD` et ses dépendances SOURCE/NETWORK/SIMULATION. Établir une politique historique d’interruption/timer/cap ; vérifier montée sans dégât, dégâts admissibles/non admissibles, objets/interactions/mort/respawn ; publier l’état autoritaire, puis relier icône/texte/charges au HUD. Réseau/rendu/audio/acceptation distincts. Reprise sur nouvel artefact serveur/mapping/callsite ou dérive identifiée.

`COR-SYS01202-AUDIT-INPUT-PREFLIGHT-PINS-01` :identité/copie matérielle avant assertion, test7/7 et relecture indépendante ; inventaire agrégé des journaux vérifié séparément. Périmètre Python après installation du hook, exclusions explicites ; aucune garantie OS universelle/TOCTOU. Témoins E externes supposés immuables et recontrôlés. Aucun hash historique V1246 reconstruit. Premier essai Windows échoué(O_ACCMODE et deux contrôles vacues),scripts/logs préservés avant correction. Deux introspections Root échouées sur formes de schéma conservées avec transcriptions d’outil,non journaux bruts ; aucune preuve d’entrée perdue après installation du hook. Préparateur de base57f8545c échoué tardivement sur champ absent du contrat gelé ; dérivé V1247 change uniquement la lecture de classification vers root_preflight.previous_turn_classification, sans modifier contrat ni composants. Partiels et transcription(nonbrute) préservés.

## 7. Livraison et décision

Preuves :`E:/mapslol3v3/audit_sys01202_missfortune_passive_hud_20261104`, composants gelés, scripts/journaux/archives,root_material_inventory/result/finalpeer. Base57f8545c et gate19cac4e4 inchangés ; préparateur V1247 dérivé qualifié sur un seul sélecteur de métadonnée. Publication après revue :rapport et ajouts CURRENT/HANDOFF, deux sauvegardes, sept protégés avant/après/readback.

Une unité d’audit borné close ; zéro tâche complète/inconnue/fonctionnalité/acceptation close. Fidélité humaine À VALIDER ; SYS-01.2-02 actif/partiel. Goal/Plan/UI/bases/registres/produit inchangés.
