# SYS-01.2-02 — Rumble : sources et consommateurs VFX du passif, V1393

6 novembre 2026 UTC. Unité `AUD-SYS-01.2-02-RUMBLE-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé sur ce périmètre ; fonctionnalité, gameplay et acceptation humaine ouverts.

## 1. Exigence et frontières

`CH-Rumble-PASSIF-PRESENTATION-VFX`, `OLF-49ccf8b7-f8b5-53dc-9c80-c6d4f654477d` : relier les effets applicables à leurs sources et consommateurs. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; six consommateurs enregistrés conservés. Inconnues VFX `OLU-21ed6492-2fb1-502b-a15c-f91472aea0e0` et SOURCE `OLU-324082c6-08e3-58e5-854c-ba4f50a71565` ouvertes. Phase D06,lot et prérequis consultés sans satisfaction revendiquée. Parent et SYS-01.2-02 ouverts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45 ;fuseau/déploiement inconnus,catalogue4.20.1 distinct. Source `reference_requirement_trace_sources/rumble-passive-junkyard-titan-links-v621.json`,3347139octets,SHA `11b9488304e04f91df4e6854c978174d5948b343eb54fd6486d0f50cbccb53c6`. UTC documentaire2026-10-26T15:09:23.572111+00:00,sans heure d’exécution déduite.

103identités natives :29INIBIN,51Lua,22preloads,font. V621 conserve309associations/26sites. Les51chunks sont consommés selon les reçus,sans prototype enfant :28initialisations littérales,78globals,23limites NEWTABLE. Globals conservés par chemin complet. CharScript56 vide ;HeatSystem195 lie BuffName,PersistsThroughDeath et `Rumble_Junkyard Titan1.dds`,espace conservé,sans lifecycle serveur déduit.

PARType=Heat,BaseMP chaîne100.0,PARStart/PARMax absents. Ces champs ne qualifient pas l’initialisation native. Buff2571 :Danger Zone50,surchauffe100,bonus magique f1(+f2),sorts bloqués6s. Description4268 « chaque sort » distincte des textes/champs Q/W/E20chaleur,second E gratuit3s et R No Cost ;exceptions et producteurs restent ouverts. Anciens textes Alistar/HP/niveaux6/12/18 non adoptés.

Quatre chunks comportent12champs AutoBuff reconnus. CarpetBombSlow/GrenadeSlow déclarent Global_Slow.troy ;ShieldBuff associe ses effets W à Robot_Root/BUFFBONE_CSTM_BOOSTER. DangerZone porte six champs vides. Ces contextes ne qualifient pas la recette passive. Seize BuffData :15résolutions,dont six OlafRagnarok contextuels ;clé RumbleDangerZone absente,tandis que RumbleDangerZoneBuff est distincte. Aucun alias inventé.

**Overheat650 est non qualifié à NEWTABLE pc16.** Ses constantes conservent LOC_Silence.troy,C_BUFFBONE_GLB_HEAD_LOC,rumble_overheat.troy,spine,rumble_overheat_lite.troy,rumble_overheat_lite_02.troy,RumbleSkin03 et des noms de champs de sélection FX/VO. Candidats identifiés,sans mapping effet→os,choix de skin,déclenchement ou arrêt prouvés. OverheatAttack116/OverheatSound158 sont également non qualifiés à NEWTABLE pc0. L’icône3 mentionnée dans les constantes n’a pas été sélectionnée ni lue ;aucune absence globale conclue.

22preloads7923octets/101références typées :40particules/59sorts/deuxpersonnages testcube. Discovery1214173octets/SHAa7de4fe1… conserve les textes ;reconstruction CRLF exacte des22identités. CharScript→HeatSystem/HeatPunchTT/globalruncyclemanager. HeatSystem158→Overheat/DangerZoneBuff ;Overheat220→sound/heatdelay/heatingup ;HeatDelay155→heatingup/heatingup2. Dépendances QWER/skin03 distinctes,HeatPunchTT ne prouve pas une sélection Map10 ;préchargement ne vaut pas création d’effet.

Quatre DDS E relus,10792octets/troiscontenus,64×64DXT1 :icône1 Characters/Spells2872octets,mip7,mêmeSHA7aa0c723… ;034_Steel_Shield.DDS2176octets,mip0,SHA62d43722… ;icône2 Spells2872octets,mip7,SHA0e00ad9d…. Membres200/188/28/28 hérités. Identité/en-tête ne prouve pas lookup/variante/pixels. Source_sha256 Heat=5c70dca4… correspond au JSON communautaire6549octets ;INIBIN natif2695octets/78ee7f1f… distinct. DDF non retrouvé par le filtre hérité et cinq candidats absents ne prouvent aucune absence globale/corruption.

## 3. Consommateurs actuels

15fichiers relus,dont13Rust/deuxlecteurs Python ;32ancres exactes. Quatorze fichiers SOURCE/frontières antérieurs et28contextes concordants. Recherche Rumble/JunkyardTitan sans occurrence dans ces13Rust,sans absence globale revendiquée.

`lib.rs:563` initialise mana depuis def.mana. `lifecycle.rs:24` restaure Mana/Energy ;la route respawn48–77 remplit Mana/Energy/Wind et remet les autres types à0. `progression.rs:110` ajoute le mana d’objet seulement avec uses_mana. `lifesteal.rs:4` applique le dommage physique ordinaire ;sa riposte magique Annie en sens inverse reste distincte d’un bonus Overheat. Aucun producteur Rumble identifié ici.

Quatorze mécanismes communs et deux fichiers d’animation ordinaire réutilisés après garde d’identité ;aucune preuve de recette passive,owner/attache/pose,clip,registration ou pixels. Les limites HUD Heat du V1265 demeurent héritées,sans nouvelle qualification de rendu.

## 4. Attendu et observé

Attendu :états thermiques et présentation attribuable. Hérité V621/HUDV1265 :trois profils niveau1,base/Tome1052+20AP/Saphir1027+200mana ;AD61,036,max100. Dix-huit attaques sortantes,dont neuf depuis0 ;48physiques entrants,trois morts/respawns480ticks chacun,1806ticks d’attente,81refus,neuftrajets sans reprise.

Dix-huit paires brutes de chaleur relues :neuf100→100/neuf0→0,silence_until0. Six fenêtres de301frames restent fixes à100 ou0. Aucun sort Rumble accepté :production,franchissements,silence et surchauffe non exercés. Valeur100 ne prouve pas une entrée en surchauffe ;absence de décroissance ne qualifie pas le refroidissement natif. Spawn100/respawn0 est une observation courante,pas une politique historique acceptée.

Dix-huit paires attendu/observé sauvegardées concordent à0,002PV,dégâts≈51,196106,inchangés avec20AP. Sortants sans PVcible adjacents bruts. Quarante-huit paires PVentrants adjacentes relues avec arrondi f32,régénération héritée,clamp PVmax et contrôle des valeurs attendues sauvegardées ;trois cas létaux. Ce calcul ne qualifie aucune politique native. Healing_checked false,refus flags seulement et garde NPC universelle absente restent des limites.

Actuel :44/44documentaires,73/73cohérence séparée par le même agent ;sixopérations journalisées exit0. Anciens71/71 et61/61 réutilisés. Ancien inspecteur local_resources list/dict et quoting du générateur conservés comme corrections de méthode,sans fix produit. Incident actuel de lecture full_idle[:1] sur dict transcrit sans faux journal brut ;frames réellement relues après inspection du schéma.

Trois JSON et deux reçus anciens BUILD/RUN0 relus ;binaire6112256octets/SHA24fd16ef… inerte,jamais ouvert. Aucun nouveau build/jeu/natif/REA/GPU/réseau.

## 5. Écarts et limites

Initialisation,génération/cooling/délai,caps/arrondis,seuils50/100,f1/f2,exceptions E/R,silence6s,lifecycle et HeatPunchTT ouverts. Recette/choix skin03,icône3,priorités des bindings,création/owner/attache/horloge/arrêt,lookup/pixels et transport non qualifiés. Trois profils niveau1 ne couvrent pas tous les événements/variantes. Acquis QWER et limites V564/Nami conservés ;aucune acceptation supplémentaire.

## 6. Corrections et reprise

`corrections_and_restart.json` porte quatre clauses sur IDs existants :politique native/recette ;état thermique et on-hit réel ;attribution réseau ;consommateur VFX/ressources. Chacune définit objectif,prérequis,critères de fin et entrée de reprise. Conserver les contrôles AD/AP/Saphir. Reprendre sur nouvelle preuve native,mapping/callsite,capture précise,dérive ou autorisation distincte d’implémenter. Aucun correctif fonctionnel exécuté ici.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_rumble_passive_vfx_20261106`,evidence_review/coherence_review,gardes,journaux et qualifications héritées. `next_lot.json` cible Ryze,ligne de couverture vérifiée ;chercher d’abord un audit équivalent. Sept rubriques relues ;une unité de liaison bornée close,zéro tâche complète/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER.

Publication limitée à ce rapport et aux ajouts CURRENT/HANDOFF après sauvegardes exactes ;sept documents protégés contrôlés avant/après. Goal/Plan/UI/bases/registres/produit conservés. Relecture du même agent,sans revue indépendante.
