# SYS-01.2-02 — Rumble : Junkyard Titan et HUD, V1265

4 novembre 2026. Unité `AUD-SYS-01.2-02-RUMBLE-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé sur le périmètre ci-dessous ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Rumble-PASSIF-PRESENTATION-HUD`, `OLF-c42fa670-48fc-57fb-9741-ced6f5eb2e25` : relier icônes, texte, chaleur et états au HUD courant. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-e8e78b73-96a1-5467-a0d7-1b39f88e59a1` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE consultés. Phase D06,lot D06-CH-Rumble et prérequis identifiés,sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315,EUW/en_GB ;build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus,catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/rumble-passive-junkyard-titan-links-v621.json`,3347139octets,SHA `11b9488304e04f91df4e6854c978174d5948b343eb54fd6486d0f50cbccb53c6`,UTC documentaire 2026-10-26T15:09:23.572111+00:00,sans attribution à une heure d’exécution.

HUD :deux sources/un catalogue. SOURCE :109relations/103identités,six sites/trois fichiers. V621 :103sources/309associations,26sites/52liens/12fichiers. Union14fichiers/32ancres. Aucun ID SOURCE supplémentaire. Réutilisation sans réouverture D :29INIBIN,51Lua,22preloads,font.

PARType=Heat,BaseMP chaîne100.0,BaseStaticMPRegen=0,PARStart/PARMax absents. Passive1LuaName et BuffName=RumbleHeatSystem ;icône exacte `Rumble_Junkyard Titan1.dds`,espace conservé. PersistsThroughDeath ne définit pas seul un lifecycle serveur. Passive1 absent ;Alistar/tourelles,+400/+600PV et niveaux6/12/18 hérités ne sont pas adoptés.

Buff2571 :Danger Zone50,Overheat100,bonus magique f1(+f2) sur attaques,sorts bloqués6s. Description4268 générale « chaque sort » distincte des textes Q/W/E20chaleur,second E gratuit3s et R No Cost. Champs QEffect2,W/EEffect3=20 aux cinq rangs ;ManaCost0 n’est pas une politique de chaleur. Producteurs f1/f2,refroidissement,initialisation et exceptions ouverts. Rcoefficients0.5/0.30000000000000004 et Ecooldown0.5 ne résolvent pas ces questions.

51Lua :28littéraux/23limites NEWTABLE,aucun callback serveur qualifié. CharScript natif56octets et communautaire vides. Seize BuffData :15résolutions,clé RumbleDangerZone absente et RumbleDangerZoneBuff distincte ;six OlafRagnarok non adoptés. HeatPunchTT ne prouve pas une règle Map10. Overheat/Silence/VFX/preloads ne prouvent aucun état exécuté. DDF non retrouvé selon filtre local et cinq candidats absents :aucune absence globale ni corruption conclue. 34références communautaires comparatives,avec divergences Q/W/E/R conservées.

Quatre DDS nécessaires,10792octets/trois contenus,64×64 :

- `DATA/Characters/Rumble/HUD/Icons2D/Rumble_Junkyard Titan1.dds` :2872octets,DXT1/mip7,membre0.0.0.200,SHA `7aa0c72352c40f4575b2d1e1be025eacf9732aa63fa0f21f01eabe3ea9858de4`.
- `DATA/Spells/Icons2D/034_Steel_Shield.DDS` :2176octets,DXT1/mip0,membre0.0.0.188,SHA `62d43722f4b01bde58d806ebe4a15850a28e91f07cce9ad144999f1540bb01e5`.
- `DATA/Spells/Icons2D/Rumble_Junkyard Titan1.dds` :2872octets,DXT1/mip7,membre0.0.0.28,SHA `7aa0c72352c40f4575b2d1e1be025eacf9732aa63fa0f21f01eabe3ea9858de4`.
- `DATA/Spells/Icons2D/Rumble_Junkyard Titan2.dds` :2872octets,DXT1/mip7,membre0.0.0.28,SHA `0e00ad9d4d05c74c86c9e3f635a127e3849f5af76333a901201e9edf36da3ed4`.

Manifeste lol_game_client0.0.1.7,tailles/MD5 concordants ;sélection E avant quatre lectures SOURCE,aucun chemin de champion étranger lu. Variantes,lookup et pixels ouverts. Font miroir inchangé,témoin Ahri réutilisé. Heat courant concorde au PARType,mais source_sha256 correspond au StatsJSON communautaire6549octets/SHA5c70dca475b679d84d758c4d22be5d471ad3bb98283b65b9770e9376b3457648,distinct de l’INIBIN natif2695octets/SHA78ee7f1fe9a5d5dd02f3b8843d15df1b42e73ea686e9f77eb09f3c7029d137a8 (`resource_provenance.json`).

## 3. Consommateurs actuels

32ancres exactes,16entrées communes et28fichiers code/configuration vérifiés. Aucune occurrence nommée Rumble/JunkyardTitan dans les fichiers Rust sélectionnés ;recherche bornée,aucune absence globale revendiquée.

Lib.rs:563 initialise mana depuis def.mana. Lifecycle réserve la restauration à Mana/Energy et remet Heat à0 au respawn ;progression exclut le mana d’objet. Basic_attack_hit applique dommage physique/soin génériques sans chaleur. Acquis conservés. Native_hud_bars.rs:11 renvoie resource=None hors Mana ;widgets.rs:91 ajoute MPStat seulement pour Mana :jauge Heat absente sur ces routes,états/seuils non produits.

## 4. Attendu et observé

Attendu :politique historique et rendu attribuable. V621 :trois cas base/Tome1052+20AP/Saphir1027+200mana,AD61,036,max100. Dix-huit mêlées,dont neuf depuis0 ;48physiques entrants,trois morts/réapparitions480ticks chacune,1806ticks d’attente,81refus,neuf trajets sans reprise.

Dix-huit paires brutes de ressource :neuf100→100/neuf0→0. Chaque cas attend301ticks depuis100,puis301depuis0,sans variation. Ces attentes ne qualifient ni grâce ni décroissance d’un état natif actif. Aucun sort Rumble accepté :génération/transitions/silence/surchauffe non exercés. Silence_until reste0 ;valeur100 ne démontre pas une entrée en surchauffe. Dégâts51,196106 physiques ordinaires,inchangés avec20AP,sans bonus observé ;aucune formule native déduite. Saphir équipé,max100 ;spawn100/respawn0 observés,initialisation native inconnue.

48paires PV adjacentes entrantes recalculées avec régénération actuelle,mitigation et clamp létal,tolérance0,002. Sortants sans paires PVcible brutes ;healing_checked false,refus flags seulement,pas de garde NPC universelle. Historique15fichiers/16234141octets,13ancienshashes concordants/deux identités nouvelles ;binaire6112256octets/SHA24fd16ef49603853a6f8500b00b8c75dff0e303f055ed8f2bef4968f55332b60 inerte,BUILD/RUN bruts0.

Contrôles71/71,cohérence séparée61/61,même agent. Inspecteur initial arrêté sur local_resources:list traité comme dict ;script/logs conservés,affichage corrigé par enumerate avant contrôles,aucune donnée produit modifiée. Préparation du rapport arrêtée sur quoting Python avant exécution ;source originale et transcription outil conservées,puis quoting corrigé. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni validation humaine.

## 5. Écarts et inconnues

Initialisation,production/cooling/délai/caps/arrondis,franchissements50/100,bonus f1/f2,ordre et exceptions E/R,silence6s,mort/respawn,providers et priorité des icônes,clé manquante,HeatPunchTT,rendu/transport ouverts. QWER distincts ;V564/Nami conservés.

## 6. Corrections et reprise

Réutiliser `CH-Rumble-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-RUMBLE-HEAT-POLICY-01` :qualifier événements,f1/f2,initial/cooling/horloge,exceptions et lifecycle. Fin :contrat4.20 sourcé,incertitudes explicites,sans imposer spawn100 comme règle native.

`COR-RUMBLE-HEAT-STATE-ONHIT-01` :produire chaleur,seuils50/100,Danger Zone,silence6s et bonus magique. Fin :capacités acceptées,0/49/50/99/100,cooling,recastE/R,mort/respawn,cibles et contrôle20AP vérifiés,en conservant les acquis génériques.

`COR-RUMBLE-HEAT-HUD-BINDINGS-01` :jauge Heat,états,icônes/textes/transport. Fin :transitions et réplication attribuables,bindings distincts,refus sans alias inventé,pixels vérifiés. Reprendre sur nouveau mapping,source/callsite,dérive ou autorisation d’implémenter ;aucun correctif fonctionnel ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_rumble_passive_hud_20261104` :evidence_review/coherence_review,DDS/histoire,resource_provenance.json,phase_package_prerequisites.json,journaux et qualification d’inspection. Hook7/7 réutilisé,limites Python/contexte/inventaire final/TOCTOU explicites. Rapport et ajouts CURRENT/HANDOFF uniquement,sauvegardes exactes et sept protégés contrôlés avant/après publication. Une unité documentaire close ;zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER ;SYS-01.2-02 actif,goal/Plan/UI/bases/registres/produit inchangés.
