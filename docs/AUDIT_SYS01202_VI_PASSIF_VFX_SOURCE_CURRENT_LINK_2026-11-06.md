# SYS-01.2-02 — Vi : Blast Shield et consommateurs VFX, V1420

6 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-VI-PASSIF-VFX-SOURCE-CURRENT-LINK-01`. Audit documentaire de liaison terminé ; fonctionnalité et acceptation ouvertes.

## 1. Exigence et périmètre

`CH-Vi-PASSIF-PRESENTATION-VFX`, `OLF-c95250a2-e44d-5f4e-8596-10a4bec4e9da` : relier Marker/Ready/Buff, porteur de bouclier et dépendances aux consommateurs actuels. Contrat VFX, prérequis de phase/lot, consommateurs et inconnues conservés dans initial_scope.json. SOURCE V649 et HUD V1293 réutilisés ; QWER complet, état/absorption, réseau et présentation complète restent distincts.

## 2. Sources et provenance

PUBLIC 4.20.0.315, EUW/en_GB ; build littéral 2014-11-17 17:46:45, fuseau/déploiement inconnus. Catalogue 4.20.1 distinct. Source `reference_requirement_trace_sources/vi-passive-blast-shield-links-v649.json`,3655258 octets,SHA `5daa0250e871d5618149a3c8fe40fdd306da6c34cf910def971f794da33ceb0d`. UTC documentaire 2026-10-27T00:59:18.541332+00:00. Métadonnées et captures E réutilisées ;aucun accès D/F/OpenLeague-work renouvelé.

Seize ressources primaires :cinq INIBIN,cinq Lua,quatre preloads,DDF,font ;98 voisins non promus. Cinq chunks directs parmi55 vues Lua sans prototype enfant :46 initialisations littérales,neuf limites NEWTABLE,86 globals. CharScript56 vide. Aucun AutoBuff reconnu dans ces vues ;aucune absence globale de VFX déduite.

Définition982 :ViPassiveMarker/ViPassive.dds,nom4479 ;Passive1/Desc,six niveaux et PassLev1Desc1 non résolus. Traduction4303 existante,sans liaison de champ inventée. Passive180 déclare Rev Up/Caitlyn_Headshot2 ;Marker191 MonkeyKingStoneSkin ;Buff145/Ready180 ViPassive. Ces noms ne constituent pas des mécaniques Caitlyn/Wukong. Persistance littérale nonlifecycle exécuté.

Marker2891 :touche de compétence activée →bouclier10 %PVmax pendant trois secondes. f2/force affichée et f3/recharge restent inconnus. Buff2889/Ready2892 contiennent SourceName. Cooldown2890 existe,sans fichier de stem ViPassiveCooldown parmi114 candidats hérités ni dans le manifeste70286 membres déjà examiné. Absence bornée,non universelle ;aucun nouveau recensement. DDF16 lignes/quatre coefficients Q/E/W ;ViE;f1=14/12.5/11/9.5/8 non recharge passive prouvée. W DentingBlows communautaire distinct. Miroir font vérifié par identité,sans reparcours sémantique.

Quatre identités preload,1774 octets :Char1060,Passive91,Buff448/SHA `1f96597673a065d615aa276d2d77ba3ed7031bc475cb08c0a26b87f977cfd118`,Ready175/SHA `78cc015c5847af8fa101827af349889d9646fdfa189d70370807c2ca5a3ed9f2`. Rôles bouclier/root et ready/backpack conservés ;texte brut et références typées non présents dans les copies sélectionnées,donc inconnus. Préchargement root nonimmobilisation,création/owner/attache ou rendu qualifiés.

Trois DDS relus dans E,64×64 DXT1 :ViPassive2872/sept mips/SHA `145daa644bf0f016624c260825873e7ffa237e41468d44757e221a723758eaee` ;Caitlyn partagé2872/sept mips/SHA `03dbccc572064f3080bffc75fb7ad8a1c0ed2eb78fc3f394d1a79fe541a6ddef` ;MonkeyKing partagé2176/mip brut1/SHA `19cb76dfc570b45dcea242861c9ffaebea7a07d60df3f7d3fdfaebb1af1740e8`. Membership139/25/40 du projet0.0.1.7 hérité ;provider/skin,pixels et particules non qualifiés. StatsJSON communautaire distinct de l’INIBIN.

## 3. Consommateurs réels

Quatorze fichiers actuels,douze Rust et deux lecteurs Python ;31 ancres concordantes. Treize sources/frontières,35 contextes,14 entrées VFX communes,deux liens d’animation ordinaire et font inchangés.

shields.rs fournit grant_shield/absorb_shields/advance_shields ;lifesteal→apply_damage Physical et absorption générique existent. Ils ne produisent pas Blast Shield. Aucun producteur nommé dans douze préfixes Rust inspectés ;ancienne recherche client réutilisée après garde,conclusion bornée.

Deux points HUD supplémentaires réutilisés après garde des fichiers :main.rs1675 somme les réserves actives et porte un texte générique ;native_hud_bars.rs32 garde les barres de bouclier pending. Acquis textuel conservé,sans exécution UI ni barre native qualifiée. Owner/projection/chargement et widget Ezreal nonpassif Vi.

## 4. Attendu, observé et contrôles

Attendu :distinguer déclencheur natif,porteur générique et présentation requise ;établir producteur ou manque borné. Observé :déclarations et primitives reliées,activation/rendu spécifiques non établis.

34/34 contrôles documentaires,55/55 de cohérence séparée du même agent. HUD143/143 et120/120 hérités ;complément statique4/4 réutilisé. Ancien3/4 conservé :seul prédicat .sum()→.sum::<f32>() qualifié,trois autres et deux fenêtres inchangés. Ancien échec LF/CRLF conservé,sans changer les gardes d’identité d’octets.

L1/L18 :deux impacts de mêlée non critiques et dix relevés de bouclier vide aux0/89/90/91/95 relus.41 calculs PV/régénération hérités,sans recalcul. Absence après attaque ordinaire compatible avec le natif :aucune touche de compétence activée,pas de génération ou expiration Vi démontrée. Aucun sort Vi fonctionnel exécuté.

Barrière publique distincte :115/455 de réserve,expiration60 ticks,recharge6300 enregistrée,retour à6300 non attendu.24 échantillons API Annie→Vi relus,trois types aux0/59/60/61 :12 absorbés sans perte PV,12 après expiration retirent les PV. Paires PV/réserves présentes,calculs antérieurs réutilisés,sans recalcul float32 ni simulation. Ces appels ne sont ni sorts Vi ni attaques entrantes ordinaires.

60 refus publics et14 refus grant_shield avec flags,toutes les paires individuelles non archivées.4121 ticks,deux apports XP diagnostiques100000 ;pas de progression naturelle complète,mort ou fin de partie. BUILD/RUN hérités0,ancien RUN218541 et1158 dépendances non relus. Binaire6098432/SHA `3a1ce44cdb8604a9c0b2481374763f8531402e8a84233e1634f7f870579b5ef3`,identité inerte.

Six productions actuelles réussies,sans échec propre. Ancienne commande PowerShell mal formée conservée comme contexte. Aucun nouveau build,jeu,décodage natif,REA,GPU,réseau/audio/rendu.

## 5. Écarts et inconnues

f2/f3,recharge,lecturePVmax,touches/cibles/refresh/overlap,types/priorités,lifecycle,audiences,provider/skin et pixels restent ouverts. **Le rendu des états de Blast Shield reste non qualifié.** Barrière,texte générique,icônes et rôle root ne remplacent pas le passif. Aucune revue indépendante/humaine ni inventaire secondaire complet qualifié.

## 6. Corrections et reprise

corrections_and_restart.json conserve quatre clauses :POLICY-01 qualifie règles et états visuels ;ABILITY-TRIGGER-01 relie une touche activée ;NETWORK qualifie prêt/actif/recharge et audiences ;VFX relie présentations et rendu. STATE-ABSORPTION-01 et HUD-BINDINGS-01 existants restent des dépendances séparées. Une compétence minimale admise suffit au premier cas,sans attendre tout QWER. Préconditions,fins et reprises précises.

Reprendre sur source/capture/callsite ou règle de provider nouvelle,ou dérive ;implémentation sous autorisation distincte. next_lot.json vise Viktor :chercher ses audits avant acquisition.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_vi_passive_vfx_20261106` :projections,fenêtres,reçus de bouclier,HUD qualifié,identités,corrections et journaux. Publication limitée au rapport et aux ajouts CURRENT/HANDOFF,sauvegardes exactes et sept registres protégés.

Une unité de liaison close ;zéro tâche VFX,fonctionnalité,inconnue,acceptation ou goal clos. Goal/Plan/UI/bases/registres/produit inchangés. SYS-01.2-02 reste actif.
