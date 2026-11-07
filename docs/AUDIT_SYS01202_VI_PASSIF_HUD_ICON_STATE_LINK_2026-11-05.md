# SYS-01.2-02 — Vi : Blast Shield et HUD, V1293

5 novembre 2026, Europe/Zurich. Unité `AUD-SYS-01.2-02-VI-PASSIF-HUD-ICON-STATE-LINK-01`. Audit documentaire terminé pour ce périmètre ; fonctionnalité et acceptation humaine ouvertes.

## 1. Exigence et périmètre

`CH-Vi-PASSIF-PRESENTATION-HUD`, `OLF-39e27263-7620-5b36-82a6-8df1425b5ca3` : relier déclencheur,réserve/absorption,icônes/textes et HUD aux consommateurs actuels. Contrat a_faire,implémentation/acceptation false ; dépendance NETWORK et inconnue `OLU-ddc3c3d2-479f-567b-954b-1ee73a22cfd2` ouverte. Six contrats et prérequis D06/D06-CH-Vi consultés sans satisfaction revendiquée. SOURCE/SIMULATION,QWER et parent PRESENTATION restent distincts.

## 2. Sources et provenance

PUBLIC4.20.0.315 EUW/en_GB,build littéral2014-11-17 17:46:45,fuseau/déploiement inconnus ; catalogue4.20.1 distinct. Primaire `reference_requirement_trace_sources/vi-passive-blast-shield-links-v649.json`,3655258 octets/SHA `5daa0250e871d5618149a3c8fe40fdd306da6c34cf910def971f794da33ceb0d`,UTC documentaire 2026-10-27T00:59:18.541332+00:00.

HUD enregistré : définition/CharScript et catalogue. SOURCE22 relations/16 identités/six sites ; V64925 frontières,union31 ancres/13 fichiers. Seize directs : cinq INIBIN,cinq Lua,quatre preloads,DDF,font ;98 voisins non promus.55 Lua sans prototype enfant,neuf limites littérales. Aucune relecture native des métadonnées.

Définition982 octets : ViPassiveMarker/ViPassive.dds,nom4479. Passive1/Desc,six niveaux et **PassLev1Desc1 absents**. Traduction de personnage4303 existante,mais liaison de champ non inventée. Marker2891 établit10%PVmax pendant3secondes après touche de compétence activée ; producteurs f2/force affichée et f3/recharge inconnus. Buff2889/Ready2892 contiennent SourceName. Cooldown2890 existe ; aucun fichier de stem ViPassiveCooldown parmi114 candidats hérités,ni70286 membres du manifeste sélectionné. Absence bornée,pas universelle.

CharScript56 vide. Passive déclare Rev Up/Caitlyn_Headshot2 ; Marker MonkeyKingStoneSkin ; Buff/Ready ViPassive. Noms étrangers non assimilés à des mécaniques Caitlyn/Wukong. Persistance et preload root ne qualifient ni lifecycle ni immobilisation. DDF16 lignes,quatre coefficients Q/E/W ; ViE;f1=14/12.5/11/9.5/8 n’est pas une recharge passive prouvée. W communautaire DentingBlows n’est pas Blast Shield.

Trois DDS64×64 DXT1,7920 octets lus SOURCE après sélection E : ViPassive2872/sept mips/membre139/SHA `145daa644bf0f016624c260825873e7ffa237e41468d44757e221a723758eaee` ; Caitlyn partagé2872/sept mips/membre25/SHA `03dbccc572064f3080bffc75fb7ad8a1c0ed2eb78fc3f394d1a79fe541a6ddef` ; MonkeyKing partagé2176/mip brut1/membre40/SHA `19cb76dfc570b45dcea242861c9ffaebea7a07d60df3f7d3fdfaebb1af1740e8`. Tailles/MD5 concordants au projet RADS0.0.1.7. Dossiers d’autres champions/particules non lus ; provider/variantes/pixels ouverts.

Quatre archives2248713 octets sélectionnées avant lecture F/OpenLeague-work. Aucun binaire ou1158 dépendances copié/rejoué. resource_provenance.json distingue StatsJSON communautaire et INIBIN natif.

## 3. Consommateurs actuels

31 ancres héritées,35 fichiers code/configuration,16 entrées communes et23 identités V649 comparables inchangées. Deux points HUD supplémentaires : main.rs1675 somme les réserves encore actives et produit un texte générique de bouclier ; native_hud_bars.rs32 déclare les barres de bouclier encore pending. Source statique,aucun rendu observé. Cet acquis textuel reste conservé.

grant_shield/absorb_shields/advance_shields/apply_damage fournissent un porteur générique. Vi est de mêlée ; ses sorts restent refusés. Maxima ne la prend pas en charge ; recherche Vi/ViPassive/Blast Shield vide dans le Rust sélectionné. Absence bornée,sans conclusion mondiale ni assimilation du porteur à un producteur passif.

## 4. Attendu, observé et contrôles

Archives L1/L18 : deux impacts de mêlée non critiques,windup vérifié,41 paires PV recalculées float32/régénération. Pertes physiques concordantes avec armure courante à0.002PV près. Quatre trajets publics arrivés sans réordre.

Après chaque attaque : cinq relevés de bouclier vide aux temps0/89/90/91/95 ; surveillance95ticks par assertions du pilote. **Attaque ordinaire ≠ touche de compétence activée** : cette absence est compatible avec le natif,ne valide ni génération ni expiration3secondes. Aucun sort Vi fonctionnel exécuté.

Barrière publique distincte :115/455 de réserve,expiration60ticks.24 appels API apply_damage Annie→Vi,trois types aux0/59/60/61 ;paires PV et réserves avant/après recalculées. Aux0/59,12 appels absorbés sans perte PV ;aux60/61,12 appels sans bouclier retirent les PV après mitigation. Ce ne sont pas des sorts Vi ou attaques entrantes ordinaires. Recharge6300 enregistrée et refus immédiat ;retour à6300 non attendu/testé.

60 refus publics et14 refus API grant_shield (NaN,infini,zéro,négatif,tag vide,durée nulle,cible inconnue) conservent des flags ;toutes les paires de snapshots complètes non archivées.4121ticks,deux apports diagnostiques100000XP,pas progression naturelle,aucune mort/fin de partie.

BUILD/RUN hérités0,RUN égal OBS. Binaire inerte6098432 octets/SHA `3a1ce44cdb8604a9c0b2481374763f8531402e8a84233e1634f7f870579b5ef3`,identité non fraîchement rehashée.143/143 contrôles,120/120 cohérence séparée du même agent ;complément HUD4/4 après qualification. Aucun nouveau jeu/build/VM/REA/GPU/réseau ni acceptation indépendante/humaine.

Contrôle HUD initial3/4 conservé : motif.sum() trop strict pour.sum::<f32>(). Première qualification échouée sur comparaison LF/CRLF ;seconde vérifie syntaxe,octets identiques et fenêtres normalisées,avec trois autres contrôles inchangés. Commande exploratoire PowerShell mal formée échouée avant accès projet,requête corrigée. Aucun produit modifié par ces corrections de lecture.

## 5. Écarts et inconnues

f2/f3,recharge effective,instant de lecture PVmax,cibles,touches multiples,refresh/overlap,types de dégâts/priorités et lifecycle ouverts. Barrière ne détermine pas les politiques Vi. Binding exact prêt/actif/recharge,provider,compteur,transport,HUD natif,tooltip,pixels,animation/audio non qualifiés.

## 6. Corrections et reprise

`COR-VI-BLAST-SHIELD-POLICY-01` : qualifier f2/f3,recharge,PVmax,ordre/types et lifecycle. Fin : contrat historique sourcé ou reconstruction explicitement séparée ; aucun emprunt à Barrière ou ViE.

`COR-VI-BLAST-SHIELD-ABILITY-TRIGGER-01` : relier une touche de compétence activée au passif prêt. Fin : au moins une compétence admise,touche/rate/refus/cibles vérifiés ;attaque ordinaire et W passif non substitués. Ne pas attendre tout QWER pour le premier cas.

`COR-VI-BLAST-SHIELD-STATE-ABSORPTION-01` : produire état/réserve10%/durée3s et recharge qualifiée avec les primitives existantes. Fin : nominal,absorption,expiration,rafraîchissement,invalides/mort/reconnexion selon contrat ;Barrière préservée.

`COR-VI-BLAST-SHIELD-HUD-BINDINGS-01` : relier variantes/icônes/nom/textes,f2/f3 et audiences à l’état autoritaire. Fin : conserver le texte générique,qualifier barre native,transport,transitions,tooltip et pixels,sans inventer PassLev1Desc1. Reprendre sur source/callsite nouveau,dérive ou autorisation fonctionnelle.

## 7. Livraison et décision

Preuves `E:/mapslol3v3/audit_sys01202_vi_passive_hud_20261105` : evidence_review,coherence_review,generic_shield_HUD_review_corrected/qualification,cooldown_manifest_context,archives,DDS,resource_provenance.json,prérequis et journaux. Hook7/7 réutilisé ;limites Python/contexte/TOCTOU conservées.

Rapport et ajouts CURRENT/HANDOFF uniquement ;sauvegardes exactes et sept protégés contrôlés à publication. Une unité documentaire close ;zéro tâche/fonctionnalité/inconnue/acceptation close. Goal/Plan/UI/bases/registres/produit inchangés ;SYS-01.2-02 actif.
