# SYS-01.2-02 — Malphite : liaison de Granite Shield au HUD, V1243

4 novembre 2026. Unité `AUD-SYS-01.2-02-MALPHITE-PASSIF-HUD-ICON-STATE-LINK-01`. Audit de liaison statique ; fonctionnement du passif et acceptation distincts.

## 1. Exigence et périmètre

`CH-Malphite-PASSIF-PRESENTATION-HUD`, `OLF-ce458987-c2ec-537e-88dd-5fb31b1296c7` : icône normale/grise, texte, rang applicable, bouclier et recharge. Contrat requis, a_faire, implémentation/acceptation false, dépendance NETWORK. Inconnue `OLU-35b21292-ee82-5ddb-bece-330365490ea2` ouverte. Les six contrats HUD, NETWORK, SIMULATION, SIMULATION-CONTRAT, SOURCE et ACCEPTANCE conservent leurs inconnues ; parent PRESENTATION distinct.

## 2. Sources et provenance

PUBLIC4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/malphite-passive-granite-shield-links-v598.json`, 1285759 octets, SHA `f74841ed9134cce9e0bcd2f707e6f6a36eb04c244d883a7bf4eef2ce228be4c4`. UTC documentaire2026-10-26T07:53:37.763822+00:00 ; MD08:00:55.143013+00:00. Ces dates ne prouvent pas l’exécution.

V598 :39 identités natives,117 associations,trois tâches,27 sites/54 liens. SOURCE :56 relations/39 identités ; HUD :une définition. Métadonnées, INIBIN, Lua, DDF, preloads et font D réutilisés sans relecture ; historique Malphite ciblé copié sur E.

MalphiteShield et Malphite_GraniteShield.dds : personnage4228 décrit 10% des PV maximum et dix secondes sans être touché. Buff2256 emploie « ne pas subir de dégâts », `@f1@`/`@f2@`. Producteurs, moment du calcul et distinction coup/dégât restent ouverts. Recharge2251, effet2255 et SeismicShard2599 sont distincts ; quatre bindings BuffData résolus. Passive1=9, description Jax, textes mana40/60/80% et niveaux3/7/11/15/absent/absent restent hérités, sans adoption.

Treize Lua sans enfant :quatre initialisations littérales(CharScript vide,Shield,BeenHit,Removal), neuf limites NEWTABLE ; aucune corruption ni callback serveur déduits. BeenHit déclare l’icône grise et la recharge ; persistance/non-dissipation ne prouvent pas le lifecycle. Douze preloads décrivent le cycle Effect/Removal/BeenHit et des particules Leona héritées, sans gameplay/rendu qualifié. Quatre lignes DDF Landslide(armure×0,3/AP×0,2 et deux champs vides) concernent le E. Dix-sept références communautaires, seul CharScript établi vide ; six chemins candidats absents bornés, sans manque global d’assets déduit.

Inventaire avant payload ; 2 chemins/6400 octets/2 contenus :

| Chemin lu | Octets | En-tête observé | Membre core0.0.1.7 |
|---|---:|---|---|
| DATA/Spells/Icons2D/Malphite_GraniteShield.dds | 4224 | 64×64, DXT5, mip brut 1 | 0.0.0.25 |
| DATA/Spells/Icons2D/Malphite_GraniteShield_Grey.dds | 2176 | 64×64, DXT1, mip brut 1 | 0.0.0.79 |

Deux icônes distinctes : normale DXT5 et grise DXT1,64×64,mip brut1 ; membres0.0.0.25/0.0.0.79. Priorité runtime ouverte ; QWER/particules/modèles non relus. Membership/MD5/SHA identifiés, sans lookup, pixels ou GPU qualifiés. Texte relié au témoin/mirror Ahri ; font D non relu, locale effective ouverte.

## 3. Consommateurs actuels

Catalogue appelé par Simulation::new ; SOURCE :6 sites/3 fichiers, plus contexte des lecteurs INIBIN/Lua. V598 :27 sites/14 fichiers et deux lecteurs ; union16 fichiers/33 ancres. Initialisation, Action/Step/Snapshot, statistiques, attaques entrantes, Q d’Annie, mitigation, régénération et Ruby examinés.

apply_damage traverse absorb_shields avec listes vides ; advance_shields entretient les boucliers génériques. grant_shield existe en contexte statique, sans injection dans les scénarios ni producteur Malphite établi. Ces API ne constituent pas Granite Shield. HUD/provider/barres/QWER et données génériques restent partiels :4 enregistrements QWER/0 non résolus ne prouvent pas icône normale/grise, réserve absorbante ou compte à rebours autoritaires.

## 4. Attendu, observé et contrôles

Attendu :production d’un bouclier puis recharge depuis un événement réel, avec montant et état HUD cohérents. Observé hérité :deux parties Map10, Malphite reçoit Annie, base puis Ruby1028(+150PV maximum). Six impacts physiques non critiques et deux Q d’Annie acceptés(raw80/coût60), dégâts après mitigation/régénération avec résidu inférieur à0,002. Les dégâts entrants exercent réellement le prérequis ; les refus de sorts Malphite ne l’annulent pas.

PV maximum574,200012/724,200012 ; 10% théoriques57,42/72,42, jamais présentés comme boucliers observés. Listes vides aux offsets299/300/301 après le dernier impact Q ;102 refus Malphite,602 ticks d’attente, mana plafonné282,200012. Les602 lignes d’attente contiennent des listes de boucliers brutes vides ; HP absents, régénération attestée par flags/assertions. Refus :snapshot_unchanged sans paires brutes. Gardes combat/attente :deux joueurs vivants,niveau1,sans stun/slow ; trajets :voyageur/winner seulement. NPC présents, sans garde universelle. Le champ C target_champion contient Annie adverse ; rôles réels :Malphite21 receveur,Annie22 attaquante. BUILD/RUN bruts0 ; inspection OBS passée, code numérique inconnu.

Sources127/127, relecture E171/171 ; consommateurs43/43, relecture E20/20. C127 courants/20 génération/union127 ; 101 fenêtres/33 ancres/21 configurations/61 chemins matériels. SOURCE :deux échecs documentaires archivés(binaire ambigu, attendu7configs corrigé8), production[1,0], sans rejeu D. C :préflight[1,0], ancienne vitesse d’attaque Lux corrigée en Annie1200 avant collecte ; collecte/relecture uniques code0. 18 captures :13 anciens pins et5 origines supplémentaires. Resource SHA5c5ab39d… désigne le JSON communautaire9353 octets, distinct du natifb9a9e43d…/3213 octets. Génération C :20 déjà courants,0 supplémentaires, sans double comptage.

Binaire historique6056960 octets, SHA `30c15bba6e5e23530c89688d5e21e1e0476e0f4137a95b47436fae94c2e6e236`, inert ; ancien nom de répertoire revision536_yasuo conservé. Aucun nouveau build, jeu, VM, REA, réseau, rendu, audio ou GPU.

## 5. Écarts et inconnues

Production/état initial/respawn, `@f1@`/`@f2@`, calcul selon PV maximum et changements de statistiques restent ouverts. Reset sur coups/dégâts nuls/absorbés/DoT/immunités, échéance/événements simultanés non qualifiés. Absorption, rupture/débordement, types de dégâts, priorités/empilement, W/armure, attribution/récapitulatif et lifecycle restent distincts. Icône normale/grise, montant/durée/audience, animation, particules, son et réseau non acceptés. Une liste vide ne démontre pas le fonctionnement d’un bouclier actif.

## 6. Correction et reprise

Réutiliser `CH-Malphite-PASSIF-PRESENTATION-HUD` et dépendances SOURCE/NETWORK/SIMULATION. Identifier le producteur, son admission et l’état autoritaire ; résoudre montant/horloge/reset sans adopter les anciennes données ni le DDF du E. Vérifier génération, dommages entrants et recharge depuis un vrai impact, avant/à/après échéance, interruptions et simultanéité. Couvrir absorption/rupture, évolution des PV, cumul et lifecycle ; relier état fiable au HUD, invalider données périmées/non autorisées. Qualifier séparément réseau/rendu/audio et acceptation humaine. Reprendre uniquement sur nouvelle preuve, mapping, producteur ou dérive précise ; aucun replay inchangé.

## 7. Livraison et décision

Preuves : `E:/mapslol3v3/audit_sys01202_malphite_passive_hud_20261104`, sourceproof/current_consumer_review, manifestes, scripts, commandes, journaux, archives, result/finalpeer. Préparateur57f8545c/gate19cac4e4 byte-exacts V1242 ; inputs courants/génération/archives vérifiés. Publication après revue :rapport et ajouts CURRENT/HANDOFF, deux sauvegardes exactes, sept protégés avant/après/readback.

Une clôture d’audit borné ; zéro tâche complète, inconnue, fonctionnalité ou acceptation close. Fidélité humaine À VALIDER. SYS-01.2-02 actif/partiel ; goal/Plan/UI/bases/registres/code/assets inchangés.
