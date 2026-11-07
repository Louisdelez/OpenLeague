# SYS-01.2-02 — Shen : Ki Strike et HUD, V1269

4 novembre 2026. Unité `AUD-SYS-01.2-02-SHEN-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; implémentation, vérification du jeu et acceptation humaine restent distinctes.

## 1. Exigence et périmètre

`CH-Shen-PASSIF-PRESENTATION-HUD`, `OLF-b11e279e-33de-5d04-a1fc-5398127137c0` : relier icônes/texte, disponibilité, bonus magique et énergie aux consommateurs et au HUD. Contrat a_faire, implémentation/acceptation false, dépendance NETWORK ; inconnue `OLU-433079a1-5aa8-5b0e-bf45-21af1d4acdda` ouverte. Six contrats HUD/NETWORK/SIMULATION/SIMULATION-CONTRAT/SOURCE/ACCEPTANCE et prérequis D06/lot D06-CH-Shen consultés, sans satisfaction revendiquée. Parent PRESENTATION et goal ouverts ; QWER distincts. Acquis V549 conservés, sans fusion de leurs anciens essais avec V625.

## 2. Sources et provenance

PUBLIC4.20.0.315,EUW/en_GB ; build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus. Catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/shen-passive-ki-strike-links-v625.json`,2818218octets,SHA `6171366a907ad4947badbdba945438949038af8241fab4b8bc5fd780da8661dc`,UTC documentaire 2026-10-26T16:24:40.047291+00:00,sans attribution à une heure d’exécution.

HUD enregistré :une définition/un catalogue, sans liaison Lua enregistrée. SOURCE :78relations/57identités,six sites/trois fichiers. V625 :57sources/171associations,26sites/52liens/13fichiers. Union15fichiers/32ancres. Aucun ID SOURCE supplémentaire ;liaisons complémentaires documentées ici,registre gelé conservé. Réutilisation sans lecture D :22INIBIN,20Lua,13preloads,DDF et font.

Les sorts sont dans DATA/Spells,CharScript dans Characters/Shen/Scripts. Ancien inventaire sur Characters/Shen/Spells arrêté,ressources retrouvées :aucune absence d’assets déduite. PARType=Energy,BaseMP chaîne200.0,BaseStaticMPRegen chaîne10.0,croissances0 ;PARStart/PARMax absents. Passive1LuaName=ShenWayOfTheNinjaMarker,icône Shen_KiStrike.dds,ExtraSpell1=ShenKiAttack. Passive1 numérique9 n’est pas automatiquement une durée. Héritage Jax/+40/+60/+80%mana/niveaux3/7/11/15 non adopté.

Description Shen_WIP4273 :8s ;texte général Shen également8s. Buff2622 :9s,prochaine attaque restituant f2 énergie et ajoutant f1+f3[10%PVbonus] en magie ;chaque attaque sur sbire/champion retire1s au délai. Les deux bindings Marker résolvent ce texte sans prouver une priorité de provider. Ancien texte KiAttack/PVmax reste distinct. Producteurs f1/f2/f3,progression,sélection8s/9s,état initial et consommation ouverts. Feint/Effect5 décrit une réduction additionnelle pendant le bouclier,non exercée.

Douze BuffData résolus/onze clés distinctes. 20Lua :15littéraux/cinq limites NEWTABLE,aucun callback serveur qualifié ;CharScript56octets vide. Aura/Marker/HardCooldown/Cooldown et drapeaux ne définissent ni état prêt,ni durée,ni mort/respawn. Preloads/TPAShen ne prouvent pas activation/rendu/skin. DDF8lignes,trois liaisons Q :texte6/10/14/18/22,health×0.015/0.005 ;ces soins ne fournissent pas les valeurs passives. Quatre candidats absents ne prouvent aucune absence globale. 27références communautaires comparatives ;divergences Q/W/E/R conservées.

Deux DDS nécessaires,7792octets/deux contenus :

- `DATA/Spells/Icons2D/Shen_KiStrike.dds` :5616octets,64×64 DXT3/mip7,membre0.0.0.25,SHA `eb6ba2feee42637ec70855a55765c4b61f6bd6d9c522cec1d2d7093e1eaeea37`.
- `DATA/Spells/Icons2D/Shen_KiStrike_Grey.dds` :2176octets,64×64 DXT1/mip1,membre0.0.0.77,SHA `96e32790fc571bc3f66488bb2f9502a05c829c758b9ad2a8e3f526377b8bec70`.

Manifeste lol_game_client0.0.1.7,tailles/MD5 concordants ;sélection E avant deux lectures SOURCE,chemins partagés Icons2D uniquement. Aucun alias étranger/particule lu. Lookup/provider/pixels ouverts. Font miroir inchangé,témoin Ahri réutilisé.

Energy courant concorde au PARType,mais source_sha256 correspond au StatsJSON communautaire 7980octets/SHA `36b32344f30b4e53393032bda7928ed047c3c017bd3b011361fba4792cfd667a`,distinct de l’INIBIN natif 2559octets/SHA `df5b5610bca7867c982e1bd89bee7066f9c88727f330fd12d21e20c2597067b6` (`resource_provenance.json`).

## 3. Consommateurs actuels

32ancres exactes,16entrées communes et28fichiers code/configuration vérifiés. Aucun producteur nommé Shen/KiStrike dans les fichiers Rust sélectionnés ;recherche bornée. Basic_attack_hit applique dommage physique/soin génériques,sans restitution d’énergie ni cycle Ki identifié.

Classification Energy,max200,exclusion du mana d’objet et chemin générique de régénération conservés. Taux de base courant10/s vérifié statiquement ;cap plein ne valide pas sa mesure ni f2. Native_hud_bars.rs:11 ne produit resource que pour Mana ;widgets.rs:91 ne produit MPStat que pour Mana :jauge/chiffres Energy omis par ces routes. Santé et autres chemins génériques ne complètent pas Ki Strike.

## 4. Attendu et observé

Attendu :disponibilité qualifiée,attaque magique supplémentaire,restitution d’énergie et délai réduit,HUD attribuable. V625 :trois profils base/Rubis1028+150PV/Saphir1027+200mana,18mêlées,813ticks d’attente,81refus,six trajets sans reprise,neuf relevés boutique/six transactions buy/sell/rebuy.

AD60.169998 inchangé,PVmax570.799988/720.799988/570.799988. Dégâts50.469711–50.469727 physiques ordinaires identiques ;Rubis n’ajoute aucun dégât observé. Recalcul avec armure Annie,tolérance0.002. Chaque cas attend271ticks après la troisième attaque ;premier impact suivant280ticks après le précédent. Ces intervalles dépassent8s/9s à30ticks/s actuels,mais ne prouvent pas l’expiration d’un buff Ki jamais produit ni la période historique exacte.

Dix-huit paires brutes d’énergie200→200,maximum200 malgré Saphir équipé. Aucun sort Shen accepté pour dépenser la ressource :restitution au plafond non qualifiée. Feint non accepté,shields absents des témoins d’impacts ;réduction additionnelle non exercée. Rang/délais propres génériques ne sont pas un timer Ki.

Dégâts dérivés sans paires PVcible adjacentes brutes ;healing_checked=false,refus flags seulement,pas de garde NPC universelle. Historique15fichiers/11320109octets,13ancienshashes concordants/deux identités nouvelles. Binaire 6078976octets/SHA `c6d30a0ba5cf44ef793371c2135b53437c1eaa64c94a44e4d298a716c40d74c9` inerte,BUILD/RUN bruts0. Contrôles66/66,cohérence séparée57/57,même agent ;aucune opération matérielle actuelle échouée. Aucun nouveau build/jeu/VM/REA/rendu/audio/GPU/réseau ni validation humaine.

## 5. Écarts et inconnues

8s/9s,provider/initialisation,f1/f2/f3 et progression,consommation/événements/cibles,ordre de réduction1s/Feint,caps,énergie sous plafond,lifecycle,icônes prêtes/grises,HUD Energy et transport ouverts. QWER,V549 et V564/Nami restent distincts.

## 6. Corrections et reprise

Réutiliser `CH-Shen-PASSIF-PRESENTATION-HUD` et SOURCE/NETWORK/SIMULATION. `COR-SHEN-KI-POLICY-01` :qualifier provider8s/9s,valeurs/événements,horloge,initialisation et Feint/lifecycle. Fin :contrat4.20 sourcé,sans convertir Passive1=9 en preuve ni substituer les soins Q.

`COR-SHEN-KI-ONHIT-RESOURCE-01` :produire bonus magique/restitution/consommation et réduction1s sur événements admissibles. Fin :cas prêt/recharge,Rubis,énergie diminuée/plafond,cibles/refus,Feint actif/absorbé/expiré,mort/respawn vérifiés selon politique qualifiée ;préserver max200 et exclusion du mana d’objet.

`COR-SHEN-KI-HUD-BINDINGS-01` :relier Marker/Aura/Cooldown,icônes prête/grise et énergie au bon état. Fin :liaisons distinctes,f1/f2/état prêt/délai,réplication et pixels observés,affichage Energy partagé réutilisé lorsque disponible. Reprendre sur nouveau mapping/artefact serveur/callsite,dérive ou autorisation d’implémenter ;aucun correctif fonctionnel ici.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_shen_passive_hud_20261104` :evidence_review/coherence_review,DDS/histoire,resource_provenance.json,phase_package_prerequisites.json et journaux. Hook7/7 réutilisé ;limites Python/contexte/inventaire final/TOCTOU déclarées. Rapport et ajouts CURRENT/HANDOFF uniquement,sauvegardes exactes et sept protégés contrôlés avant/après publication. Une unité documentaire close ;zéro tâche/fonctionnalité/inconnue/acceptation close. Fidélité humaine À VALIDER ;SYS-01.2-02 actif,goal/Plan/UI/bases/registres/produit inchangés.
