# PhysicalDamage_Enabled — checkbox Damage et textes flottants

## R1 — Portée et décision

Date 2026-10-31T16:47:51.705694+00:00. AUD-17.5-01-OPTIONS-FLOATING-PHYSICAL-DAMAGE-01, SYS-17.5-01, goal SYS-01.2-02. Un checkbox142 et son groupe/type/admission natifs, distincts du calcul de dégâts, flashécran, particules et autresFloatingText. Producteur non clôturant ; relecture séparée attendue. Fonctionnalité, parent, goal et acceptation ouverts.

## R2 — Sources et réutilisation

PE4.20 SHA `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, XML/index/factory/export et19checkboxfragments/3constantes/defaultregular épinglés. LabelenGB772 : Damage. DefaultsPhysicalDamage_Enabled1ligne185, user/deployabsents/Fexactabsent ; provider effectif inconnu. Pas strategy/updateonclick physiques, regular conditionnel à definition, pas savecfg/live du voisin. Nativepertypefallback1, model/GFXfallback0 et selectedfile distincts.

Ancien auditDAMAGE-FLASH/readback et14vraisfragmentsproducers/consumers repris avec identités inchangées. Calcul/outcome/recap/HP et Qworldflash ne sont pas un nombreflottant. Deux lecturescourantes complètent DamageKind/DamageOutcome et AttackPresentationCritical/hit_succeeded sansamount ; pas de nouveaux tests/l’ancienrendu ou nativecases promus en preuve de cette option.

## R3 — Résultat natif et actuel

Registration7BBFD0 : clé [FloatingText]PhysicalDamage_Enabled, capturemanager/callback7BE400 viaadapter65C4C0 partagé. Enregistrementinline au premierconteneur2D78568/entry28 ; aucun appel82D410mode2 dans le préfixe retenu, sans conclure absenceglobale de live/subscribers. Sourcecache/enregistrement pas acquittement UI/Save ou lifetime.

Callbackcomplet7BE400 écrit sharedbool sixfois :40/41/42 et36/37/38. Table29noms10B8198..10B820C et cache30+type donnent16PhysicalDamage,17MagicalDamage,18TrueDamage,6PhysicalDamageCritical,7MagicalDamageCritical,8TrueDamageCritical. Le labelDamage correspond à ce groupe ; ne pas réduire au typephysique16. Enemy19..24 sont distincts, aucune relation viewer/team depuis leur nom seul.

Init : boucleindex0/names+4 jusqu’àend29, format%s_Enabled puis cfgboolFloatingText fallback1/selector0 versmanager30+index. Aliasframe : indexbase24/managerbase2C, stack40/48 après28octetspush. Callbackgroupé et clésinitialespar-type restent deux mécanismes : ordre/priming/réconciliation/provider effectifs non qualifiés, pas de startupbug ou réécriture de clés cachées imaginés.

Admission7BB760préfixe : managerECX, subjectarg8, typeargC. SubjectNULL/virtual98/argumentoptionnel, puis enable[30+type]zero→cleanup7BBC37 ; ensuite Debug28 et autres gardes mode/identity/predicates/profileAC peuvent refuser. Truecache autorise la suite, pas un rendu. Indexation précède comparaisonDebug ; légitimité/bornes des callers non prouvées, aucun indiceinvalide exécuté. Montant/type/amountformat/position/audience/nativefont/profile/clock/merge/pool/draw ne se déduisent pas de ce gate.

Actuel : DamageKind3 et DamageOutcome(raw/postmitigation/shield/health/lethal), serverdamage/recap privé et publication mort/session, Snapshot réels etreceivecommit, HPnumeric, Qacceptedfacts/QUADworldeffets présents. AttackPresentation transporte Critical et Resolvedhit_succeeded, pas amount ; un hit réussi ne prouve pas dégâtspositifs. Aucun namedfloatingtext route dans recherchebornée1168sources, corroborée par ces producteurs/consumers ; pas de négation de tous dégâts/critique/événements/réseau/ressources. Ne pas créer un nombre depuis deltaHP ou particule.

Deux cheminslooseGamePermanent.cfg exacts absents ; archives/provider/montageeffectif et font/profil restent non évalués ici. Ce n’est ni preuve de ressourcepackagée absente ni besoin de reconstruire texture/glyphes.

## R4 — Attendu et observé

Sept cas dans preuve : déclaration/init, groupe6, admission, acquisactuels, limitesressource, rendu/Save ouverts et réutilisation. 8fenêtresalignées/43attentes, table29/sixaffectés et helpers vérifiés. Les explorations horsfrontière ou au-delà de la table n’établissent aucune preuve ; seules bornes formelles vérifiées retenues. Recherches nomsrenderer/types et un sousensembletitresplan initiales ne sont pas preuvesuniverselles d’absence ; chemins réels inspectés et sourceexacte apportés.

Python/PE/hashreadonly, pas exécution ou émulation x86/AS/Rust/jeu/GUI/input/réseau/loader ni install/migration/restart/ancienlecteur/test/export. Choix0/1/normalcrit/sixcas/shield/zero/lethal/privacy/merge/expiry/viewport/session/Save/cancel/default/reload non exécutés. Cinq registres/25protégés/corpus/Git inchangés.

## R5 — Manques et reprise

- PHYSICAL-GROUP-EVENT-ADMISSION : un caller7BB760/amountproducer/category/subject/audience/typevalide requis ; garder raw/postmitigation/shield/HP et Critical distincts. Un producteur précis, pas nouvelinventaireglobaldamage.
- PHYSICAL-INIT-PROVIDER : pertypeEnabled/groupcallback/priming/conflicts/provider et profil/font/montageeffectif inconnus ; un ordre/provider ou resourceconsumer nommé, pas reconstruction depuis absenceloose.
- PHYSICAL-CURRENT-VIEW : pas de consumer/préférence/vuefloating identifié malgré données/HP/effetsacquis. Reprise autorisée avec une entrée admise et contratamount/type/style/temps, réutilisant DamageOutcome/acceptedfacts suffisants sans imposer un nouveaustream générique.
- PHYSICAL-RENDER-LIFECYCLE : format/anchor/clock/merge/pool/expiry/hidden/owner/viewport et cyclecfg non vérifiés ; build/assets/scénarioidentifiés, sixaffectés/autresnonaffectés/refus et Save séparés.

Impacts et conditions de reprise détaillés dans preuve. Ce lot n’est pas une implémentation.

## R6 — Corrections et suite

HUD-OPTIONS-ENTRY-01 et HUD-LOCAL-RENDER-01 conservés, HUD-DAMAGE-FLASH-SETTING-01 aussi ; objectifs diffèrent. Une seule proposition HUD-FLOATING-PHYSICAL-DAMAGE-SETTING-01, pour ce checkbox/groupe6 : première entréePhysical16 utile puis cinqautres toujours suivies jusqu’à qualification/suppression explicite, pas raccourci physical-only ni allcombat/VFX reconstruits. Source/Gamecfg/menu et mécanismes de dégâts/transport/privacy réutilisés, zéro application/registre changé.

SuiteHeal_Enabled143 : table/gate/AS/registrationpartagée et vrais producteurs d’abord, propre callback/typegroup seulement ; pas nouveau reverse intégral.

## R7 — Livraison et relecture

Preuve `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-PHYSICAL-DAMAGE-01\floating-physical-damage-proof.json` SHA `a0105a7b5a9cd5d87d0d7ec739ee0439a4ca46a1f963f77fd8e49aade626dcea`, producteur `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-PHYSICAL-DAMAGE-01\verify_floating_physical_damage.py`, fiche `F:\OpenLeague-work\audit-units\AUD-17.5-01-OPTIONS-FLOATING-PHYSICAL-DAMAGE-01\audit-unit.json`. delivery-readback.json/INDEPENDENT-REVIEW attendus ; seul périmètredocumentaire peut être clos. Goal/critères, code/assets, Plan/UI/bases, registres et anciensdocuments/preuves conservés ; nouveauxfichiersisolés seulement.
